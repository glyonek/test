/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : test2
Version : 1
Date    : 17.02.2019
Author  : Kostya
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 1,000000 MHz (8 MHz)
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
//#include <mega8.h>
static char buff[30];

#include <delay.h>
#include <i2c.h>
#include <stdio.h>
#include "ssd1306.c"


#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))    // Voltage Reference: AVCC pin
#define PWR_LCD             PORTD.4
#define KEY_E               PINB.4
#define KEY_U               PINB.3
#define KEY_D               PINB.2
#define KEY_SIG_NUM         10 
#define GO_TO_OPTIONS       30  
#define INFOLINE1           6
#define INFOLINE2           7
#define LAST_OPTION_MENU    17      //

// Global variables 
eeprom unsigned char Termo[256]=            // +50C
{175,170,155,145,135,130,125,120,117,115,
 112,110,107,105,104,102,100, 99, 98, 96,
  95, 94, 93, 91, 90, 89, 88, 87, 86, 85,
  84, 84, 83, 82, 82, 81, 80, 80, 79, 78,
  78, 77, 77, 76, 76, 75, 75, 74, 74, 73,
  72, 72, 71, 71, 70, 70, 69, 69, 68, 68,
  68, 67, 67, 67, 66, 66, 65, 65, 65, 64,
  64, 64, 63, 63, 63, 62, 62, 62, 61, 61,
  61, 60, 60, 60, 60, 59, 59, 59, 58, 58,
  58, 58, 57, 57, 57, 56, 56, 56, 55, 55,
  55, 55, 55, 54, 54, 54, 54, 53, 53, 53,
  53, 53, 52, 52, 52, 52, 51, 51, 51, 51,
  50, 50, 50, 50, 49, 49, 49, 49, 49, 49,
  48, 48, 48, 48, 48, 47, 47, 47, 47, 47,
  47, 46, 46, 46, 46, 46, 45, 45, 45, 45,
  45, 44, 44, 44, 44, 44, 44, 43, 43, 43,
  43, 43, 43, 43, 42, 42, 42, 42, 42, 41,
  41, 41, 41, 41, 41, 40, 40, 40, 40 ,40,
  40, 39, 39, 39, 39, 39, 39, 39, 38, 38,
  38, 38, 38, 38, 38, 37, 37, 37, 37, 37,
  37, 37, 36, 36, 36, 36, 36, 35, 35, 35,
  35, 35, 35, 35, 34, 34, 34, 34, 34, 34,
  34, 33, 33, 33, 33, 33, 33, 33, 33, 32,
  32, 32, 32, 32, 32, 32, 31, 31, 31, 31,
  31, 31, 31, 30, 30, 30, 30, 30, 30, 30,
  30, 29, 29, 29, 20, 20};

eeprom unsigned char typeEEP=0;             // тип електростанціі
eeprom unsigned char t1EEP=10;              // час переходу на генератор
eeprom unsigned char t2EEP=5;               // час переходу на мережу
eeprom unsigned char t3EEP=5;               // час роботи стартера
eeprom unsigned char t4EEP=10;              // час роботи із заслонкою
eeprom unsigned char t5EEP=5;               // час без нагрузки
eeprom unsigned char t6EEP=10;              // час охолодження 

eeprom unsigned char TminZEEP=20;           // Мінімальна температура прогріву генератора с заслонкой
eeprom unsigned char TminNEEP=30;           // Мінімальна температура прогріву генератора
eeprom unsigned char KilkistZapuskiv_EEP=4; //
eeprom unsigned char Z_EEP=0;               // zaslonka/klapan
eeprom unsigned char rotor_EEP=0;
//eeprom unsigned int  NarabotkaMinEEP=0;
//eeprom unsigned char TEX_EEP=1;           //TO заноситься 1 якщо пора робити ТО, можно скинути із меню



static unsigned char type,t1,t2,t3,t4,t5,t6,TminZ,TminN,KilkistZapuskiv;//,Narabotka,;
static bit z=0;
static bit rotor=0;

static unsigned char up,down,enter;
static unsigned char PositionPointer = 1;
static bit podmenu=0;
     
static unsigned int  U_Bat=0;
static int T;
static unsigned char U1;       
//char buff[30];  //буфер дисплея

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
// Wait for the AD conversion to complete
while ((ADCSRA & (1<<ADIF))==0);
ADCSRA|=(1<<ADIF);
return ADCW;
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void BEEP()
{
        PORTD.2=1;
  //      delay_ms(50);
        PORTD.2=0;
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void UpDownEnterKey()       //перенести в прерівание!!!
{
 //Main menu
 if((PositionPointer>=1)&(PositionPointer<=4))    
 {  
    if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;BEEP();};
    if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;BEEP();};

    if(PositionPointer>4){PositionPointer=4;} //limits of Main menu
    if(PositionPointer<1){PositionPointer=1;}
    // Go to Options menu
    if((enter>GO_TO_OPTIONS)&(PositionPointer==4)){PositionPointer=5;BEEP();enter=2;};
  }
  //Options menu
 if((PositionPointer>=5)&(PositionPointer<=LAST_OPTION_MENU))  
  {
        if(podmenu == 0)
        {
            if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;BEEP();};
            if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;BEEP();}; 
        }
        
        if((enter==1)&(PositionPointer!=LAST_OPTION_MENU))
            {   
                BEEP();
                podmenu=!podmenu; 
                enter=2;
                    if(podmenu==0){ 
                            #asm("cli") 
                            typeEEP=type;
                            t1EEP=t1; 
                            t2EEP=t2; 
                            t3EEP=t3; 
                            t4EEP=t4; 
                            t5EEP=t5; 
                            t6EEP=t6; 
                            TminZEEP=TminZ; 
                            TminNEEP=TminN; 
                            KilkistZapuskiv_EEP=KilkistZapuskiv;
                            Z_EEP=z;
                            rotor_EEP=rotor;
                            #asm("sei");
                    };
            }
        if(PositionPointer>LAST_OPTION_MENU){PositionPointer=5;}  //limits of Options menu
        if(PositionPointer<5){PositionPointer=LAST_OPTION_MENU;}        

        if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_OPTION_MENU)){PositionPointer=4;BEEP();enter=2;};
  }
                        
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
unsigned int  U_Bat_ADC=0;
unsigned int  T_ADC=0;       
unsigned int  U1_ADC=0;

//#asm("cli") 

    if(KEY_U==0){up=up+1;}      else  {up=0;};
    if(KEY_D==0){down=down+1;}  else  {down=0;};
    if(KEY_E==0){enter=enter+1;}else  {enter=0;};   //beep begin -DDRD.2=1;

    if(up>99) up=99;
    if(down>99) down=99;
    if(enter>99) enter=99;
    UpDownEnterKey(); 


    U_Bat_ADC=read_adc(0);
    T_ADC=read_adc(1); 
    U1_ADC=read_adc(2);

    T=Termo[T_ADC];
    T=T-50;

    U_Bat=(U_Bat_ADC*20)/51; //останній розряд- десяті !!!!при виводі ділити на 10
    U1=(U1_ADC*11)/41;//ціле без десятих
//#asm("sei")         
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void MainInfo()
{
    sprintf(buff," Uвх =%4.uB",U1); 
    ShowBigLine(3); 
    sprintf(buff," Uакб=%2.u.%1.uB",U_Bat/10,U_Bat%10);
    ShowBigLine(5);

    sprintf(buff,"  u:%2.u d:%2.u e:%2.u p:%2.u",up,down,enter,PositionPointer);
    ShowLine(7);

}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------    MAIN     ----------------------------------------------------------
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void main(void)
{

// Declare your local variables here

// Input/Output Ports initialization

PORTB=0b00011100; DDRB =0b00000000;         // 0,1 - OLED; 2,3,4 -keys;  5,7- not used; 6 - generator OUT(detect)
PORTC=0b00000000; DDRC =0b01000000;         // 7 bit- TO
PORTD=0b00000000; DDRD =0b11111111;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0,977 kHz ??? 
TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 500,000 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// Bit-Banged I2C Bus initialization
// Project|Configure|C Compiler|Libraries|I2C menu.
///////////////////////////////////////////////////////////////////////////////
// Init Variables and sequenses

PositionPointer=1; 

 
//podmenu=0;
//TimeSec=podsvet;
//TempTime=1;
//Narabotka=0;
// загружаємо із EEPROM
type=typeEEP;
t1=t1EEP;
t2=t2EEP;
t3=t3EEP;
t4=t4EEP;
t5=t5EEP;
t6=t6EEP;
TminZ=TminZEEP;
TminN=TminNEEP;
KilkistZapuskiv=KilkistZapuskiv_EEP;
z=Z_EEP;
rotor=rotor_EEP;

U1=220;

i2c_init();
#asm("sei")    // Global enable interrupts
    //   PWR_LCD=1;
///////////////////////////////////////////////////////////////////////////////

    LCD_init();   
    sprintf(buff," MicroCraft "); ShowHeadLine();
    LCD_Goto(45,3);
    sprintf(buff,"(TM)");
    LCD_Printf(buff,1);  //  вывод на дисплей       
    
    LCD_Goto(0,6);
    sprintf(buff," PGS  v.5.0 ");
    LCD_Printf(buff,1);  //  вывод на дисплей  
                
    LCD_Blinc(500,3);
//    delay_ms(5000); 

    //     LCD_DrawImage(0);
    //     delay_ms(5000);
//LCD_Clear();
    //       LCD_Contrast(1);
///////////////////////////////////////////////////////////////////////////////

while (1)
    {
      if(podmenu == 0)
      {
        LCD_Mode(0);
      }
      else
      {
       LCD_Mode(1);
      }
///////////////////////////////////////////////////////////////////////////////
    switch (PositionPointer){
    ///////////////////////////////////////////////////////////////////////////////
        case 1: // автоматичний запуск
            sprintf(buff,"1:  АВТО   "); 
            ShowHeadLine();     
            MainInfo();
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 2: //
            sprintf(buff,"2:  АВТО(э)"); 
            ShowHeadLine();      
            MainInfo();
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 3: //
            sprintf(buff,"3:  РУЧНОЙ "); 
            ShowHeadLine();      
            MainInfo();
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 4: //
            sprintf(buff,"4:  СТОП   ");  
            ShowHeadLine();
            MainInfo();   
        break;  
    ///////////////////////////////////////////////////////////////////////////////
        case 5: //
            sprintf(buff," НАСТРОЙКИ ");            ShowHeadLine(); 
            sprintf(buff,"  <БЕНЗИН> ");            ShowBigLine(3);
            sprintf(buff,"                      "); ShowLine(5);
            sprintf(buff,"  ТИТ ЭЛЕКТРОСТАНЦИИ  "); ShowLine(INFOLINE1);
            sprintf(buff,"   БЕНЗИН / ДИЗЕЛЬ    "); ShowLine(INFOLINE2);
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 6: // на генератор  
            sprintf(buff," t1  =%4.uc",t1); ShowBigLine(3);
            sprintf(buff,"   ЗАДЕРЖКА ЗАПУСКА   "); ShowLine(INFOLINE1);
            sprintf(buff,"    ЭЛЕКТРОСТАНЦИИ    "); ShowLine(INFOLINE2);

            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t1=t1+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t1=t1-5;down=2;BEEP();}
            if(t1>60){t1=60;}
            if(t1<5){t1=5;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 7: // на мережу
            sprintf(buff," t2  =%4.uc",t2);         ShowBigLine(3);
            sprintf(buff,"   ЗАДЕРЖКА ГЛУШЕНИЯ  "); ShowLine(INFOLINE1);
            sprintf(buff,"    ЭЛЕКТРОСТАНЦИИ    "); ShowLine(INFOLINE2);

            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t2=t2+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t2=t2-5;down=2;BEEP();}
            if(t2>60){t2=60;}
            if(t2<5){t2=5;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 8: // час роботи стартера 
            sprintf(buff," t3  =%4.uc",t3);         ShowBigLine(3);
            sprintf(buff,"    ВРЕМЯ РАБОТЫ      "); ShowLine(INFOLINE1);
            sprintf(buff,"  СТАРТЕРА ( Max. )   "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t3++;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t3--;down=2;BEEP();}
            if(t3>6){t3=6;}
            if(t3<2){t3=2;}            
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 9: // час роботи із заслонкою
            sprintf(buff," t4  =%4.uc",t4); ShowBigLine(3);
            sprintf(buff,"   ВРЕМЯ ОБОГАЩЕНИЯ   "); ShowLine(INFOLINE1);
            sprintf(buff,"         СМЕСИ        "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t4++;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t4--;down=2;BEEP();}
            if(t4>60){t4=60;}
            if(t4<1){t4=1;} 
          break;
    ///////////////////////////////////////////////////////////////////////////////
        case 10: //
            sprintf(buff," t5  =%4.uc",t5);         ShowBigLine(3);
            sprintf(buff,"    ВРЕМЯ ПРОГРЕВА    "); ShowLine(INFOLINE1);
            sprintf(buff,"     БЕЗ НАГРУЗКИ     "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t5=t5+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t5=t5-5;down=2;BEEP();}
            if(t5>60){t5=60;}
            if(t5<5){t5=5;} 
        break;
      ///////////////////////////////////////////////////////////////////////////////
        case 11: //
            sprintf(buff," t6  =%4.uc",t6);         ShowBigLine(3);
            sprintf(buff,"   ВРЕМЯ ОХЛАЖДЕНИЯ   "); ShowLine(INFOLINE1);
            sprintf(buff,"     БЕЗ НАГРУЗКИ     "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t6=t6+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t6=t6-5;down=2;BEEP();}
            if(t6>180){t6=180;}
            if(t6<5){t6=5;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 12: // Мінімальна температура прогріву генератора с заслонкой(накал свечей для дизеля)
            sprintf(buff," Tz  =%3.u*C",TminZ);      ShowBigLine(3);
            sprintf(buff,"   Мaх. ТЕМПЕРАТУРА   "); ShowLine(INFOLINE1);
            sprintf(buff,"   ОБОГАЩЕНИЯ СМЕСИ   "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){TminZ=TminZ+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){TminZ=TminZ-5;down=2;BEEP();}
            if(TminZ>90){TminZ=90;}
            if(TminZ<5){TminZ=5;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 13: //Мінімальна температура прогріву генератора
            sprintf(buff," Tn  =%3.u*C",TminN);      ShowBigLine(3);
            sprintf(buff,"   Мin. ТЕМПЕРАТУРА   "); ShowLine(INFOLINE1);
            sprintf(buff," ПРОГРЕВА ЭЛ.СТАНЦИИ  "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){TminN=TminN+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){TminN=TminN-5;down=2;BEEP();}
            if(TminN>60){TminN=60;}
            if(TminN<10){TminN=10;}                                    
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 14: //
            sprintf(buff," Kz  =%4.u ",KilkistZapuskiv); ShowBigLine(3);
            sprintf(buff,"  КОЛИЧЕСТВО ПОПЫТОК  "); ShowLine(INFOLINE1);
            sprintf(buff,"  ЗАПУСКА ЭЛ.СТАНЦИИ  "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv++;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv--;down=2;BEEP();}
            if(KilkistZapuskiv>6){KilkistZapuskiv=6;}
            if(KilkistZapuskiv<1){KilkistZapuskiv=1;}             
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 15: //
            if(z==0){sprintf(buff," <ЗАСЛОНКА>");}
            else{sprintf(buff," < КЛАПАН >");}
            ShowBigLine(3);
            sprintf(buff,"     ТИП ПРИВОДА      "); ShowLine(INFOLINE1);
            sprintf(buff,"      И ИМПУЛЬСА      "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){z=0;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){z=1;down=2;BEEP();}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 16: //
            if(rotor==0){sprintf(buff," РОТОР<off>");}
            else{sprintf(buff," РОТОР<on >");}
            ShowBigLine(3);
            sprintf(buff,"       КОНТРОЛЬ       "); ShowLine(INFOLINE1);
            sprintf(buff,"   СИГНАЛА: 'РОТОР'   "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){rotor=0;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){rotor=1;down=2;BEEP();}
        break;

    ///////////////////////////////////////////////////////////////////////////////
        case 17: //
            sprintf(buff," - ВЫХОД - ");            ShowBigLine(3); 
            sprintf(buff,"      ДЛЯ ВЫХОДА      "); ShowLine(INFOLINE1);
            sprintf(buff,"   УДЕРЖИВАЙ  'ВВОД'  "); ShowLine(INFOLINE2);
//            sprintf(buff,"%2.u",enter);
//            ShowLine(4); 

       break;
    ///////////////////////////////////////////////////////////////////////////////


    };// switch (PositionPointer)

    } //while

} //main



/*
            sprintf(buff,"    РЕЖИМ ЭКОНОМИИ    "); ShowLine(INFOLINE1);
            sprintf(buff,"  РАБОТА / ОЖИДАНИЕ   "); ShowLine(INFOLINE2);
            sprintf(buff,"        СБРОС         "); ShowLine(INFOLINE1);
            sprintf(buff,"   СИГНАЛА:   'ТО'    "); ShowLine(INFOLINE2);