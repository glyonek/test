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

// Voltage Reference: Int., cap. on AREF
#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))

#define PWR_LCD             PORTD.4
#define KEY_E               PINB.4
#define KEY_U               PINB.3
#define KEY_D               PINB.2
#define KEY_SIG_NUM         10 
#define GO_TO_OPTIONS       30  
#define INFOLINE1           6
#define INFOLINE2           7
#define LAST_MODE_MENU      3
#define FIRST_OPTION_MENU   10      //
#define LAST_OPTION_MENU    16      //

#define U1_MIN              140      //
#define U1_MAX              265      //

#define ONE_SECOND          4000    //
#define HALF_SECOND         2000    //
#define QUARTER_SECOND      1000    //
#define NEXT_ZAPUSK_SECOND  20000   // 5c

#define RAZGON              5       // 5c

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
//                                                                                                  В МЕНЮ!
eeprom unsigned char typeEEP = 0;           // тип електростанціі                                       -
eeprom unsigned char t1EEP   =10;           // час переходу на генератор                                -
eeprom unsigned char t2EEP   =10;           // час переходу на мережу                                   -
eeprom unsigned char t3EEP   = 6;           // час роботи стартера                                      -
eeprom unsigned char t4EEP   = 8;           // час роботи із заслонкою                                  V
eeprom unsigned char t5EEP   = 5;           // час без нагрузки  (прогрев в нормальном режиме)          V
                                            // Охлаждение - в 2 раза больше чем прогрев бед нагрузки
//eeprom unsigned char t6EEP =10;           // час охолодження 

eeprom unsigned char TminZEEP=20;           // Мінімальна температура прогріву генератора с заслонкой
eeprom unsigned char TminNEEP=50;           // Мінімальна температура прогріву генератора               -
eeprom unsigned char Z_EEP   = 0;           // zaslonka/klapan                                          V
eeprom unsigned char R_EEP   = 0;           // Проверка сигнала "Вращение ротора"                       V
eeprom unsigned char KilkistZapuskiv_EEP=3; // Количество попыток запуска                               V

//eeprom unsigned int  NarabotkaMinEEP=0;
//eeprom unsigned char TEX_EEP=1;           //TO заноситься 1 якщо пора робити ТО, можно скинути із меню



static unsigned char type,t1,t2,t3,t4,t5,TminZ,TminN,KilkistZapuskiv;//,Narabotka,;
static unsigned char AvtRu=0;               //0-Auto; 1-Ru4noy                           
static bit z=0;
static bit r=0;
static bit rotor=0;

static unsigned char up,down,enter;
static unsigned char PositionPointer = 1;
static bit podmenu=0;
     
static unsigned int  U_Bat=0;
static int T;
static unsigned int U1;  
static unsigned int temp;        
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
 if((PositionPointer>=1)&(PositionPointer<=LAST_MODE_MENU))    
 {  
    if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;BEEP();};
    if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;BEEP();};

    if(PositionPointer>LAST_MODE_MENU){PositionPointer=LAST_MODE_MENU;} //limits of Main menu
    if(PositionPointer<1){PositionPointer=1;}
    // Go to Options menu
    if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_MODE_MENU)){PositionPointer=FIRST_OPTION_MENU;BEEP();enter=2;};
  }
  //Options menu
 if((PositionPointer>=FIRST_OPTION_MENU)&(PositionPointer<=LAST_OPTION_MENU))  
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
                    TminZEEP=TminZ; 
                    TminNEEP=TminN; 
                    KilkistZapuskiv_EEP=KilkistZapuskiv;
                    Z_EEP=z;
                    R_EEP=r;
                    #asm("sei");
                }
            }
        if(PositionPointer>LAST_OPTION_MENU){PositionPointer=FIRST_OPTION_MENU;}  //limits of Options menu
        if(PositionPointer<FIRST_OPTION_MENU){PositionPointer=LAST_OPTION_MENU;}        

        if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_OPTION_MENU)){PositionPointer=LAST_MODE_MENU;BEEP();enter=2;};
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

    if(rotor>8){PORTD.5=0;}//ротор працює- стартер не потрібен відключаємо стартер v1.4)
    if(PINB.6==0){rotor=rotor+1;}else{rotor=rotor-1;};
    if(rotor<1) rotor=1;
    if(rotor>10) rotor=10;

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

    U_Bat=(U_Bat_ADC*20)/102; //останній розряд- десяті !!!!при виводі ділити на 10
    U1=(U1_ADC*11)/41;//ціле без десятих
//#asm("sei")         
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void PerehodNaGenerator()
{
        PORTD.0=1; // відключаємо МЕРЕЖУ
        delay_ms(HALF_SECOND);
        PORTD.1=1; // Підключаємо генератор
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void PerehodNaMereju()
{
        PORTD.1=0; // відключаємо ГЕНЕРАТОР
        delay_ms(HALF_SECOND); 
        PORTD.0=0; // Підключаємо МЕРЕЖУ
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void MainInfo()
{
    sprintf(buff," Uвх =%4.uB",U1);ShowBigLine(3); 
    sprintf(buff," Uакб=%2.u.%1.uB",U_Bat/10,U_Bat%10);ShowBigLine(5);
//    sprintf(buff,"  u:%2.u d:%2.u e:%2.u p:%2.u",up,down,enter,PositionPointer);
//    ShowLine(7);
}
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
// Clock source: System Clock; Clock value: 0,977 kHz ??? 
TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
// External Interrupt(s) initialization  INT0: Off; INT1: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
// USART initialization USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
// Analog Comparator: Off
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
// ADC Clock frequency: 1000.000 kHz, AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
SFIOR=(0<<ACME);

// Bit-Banged I2C Bus initialization
// Project|Configure|C Compiler|Libraries|I2C menu.
///////////////////////////////////////////////////////////////////////////////
// Init Variables and sequenses

PositionPointer=1; 
//Narabotka=0;
// загружаємо із EEPROM
type=typeEEP;
t1=t1EEP;
t2=t2EEP;
t3=t3EEP;
t4=t4EEP;
t5=t5EEP;
//t6=t6EEP;
TminZ=TminZEEP;
TminN=TminNEEP;
z=Z_EEP;
r=R_EEP;
KilkistZapuskiv=KilkistZapuskiv_EEP;
//EEPROM

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
                
    LCD_Blinc(QUARTER_SECOND,3);
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
            AvtRu=0; // встановлюємо флаг, який буде показувати який був останній режим - Автомат чи Ручний
            sprintf(buff," 1: АВТО   "); 
            ShowHeadLine();     
            MainInfo();    
            if ((U1<U1_MIN)||(U1>U1_MAX)){  //напруга в мережі низька 175В-80% або висока 265
//добавлена быстрая защита нагрузки!!!
                if(U1>U1_MAX){PORTD.0=1;}   // відключаємо МЕРЕЖУ    для защиты !!! 
                temp=t1;  // загружаємо затримку переходу на генератор
                while (temp!=0)
                {
                    sprintf(buff,"  HET CETИ! "); ShowBigLine(3); 
                    sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                    delay_ms(ONE_SECOND);
                    if(PositionPointer!=1){goto begin;}
                    temp--;                            
                }
                if ((U1<U1_MIN-5)||(U1>U1_MAX+5)){PositionPointer=30; KilkistZapuskiv=KilkistZapuskiv_EEP;};  
                //напруга все ще за допустимими межами ?,тоді перехід.
                // добавлен гистерезис
            }
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 2: //
            AvtRu=1; // встановлюємо флаг, який буде показувати який був останній режим - Автомат чи Ручний
            sprintf(buff," 3: РУЧНОЙ ");            ShowHeadLine();      
            MainInfo();  
            if (U1>U1_MAX)
            { 
                PositionPointer=42;// перехід на аварію 
                PORTD.0=1; // відключаємо МЕРЕЖУ     !!!
                LCD_Clear();                                             
            }            
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 3: //
            sprintf(buff," 4: СТОП   ");            ShowHeadLine();
//            MainInfo();   
            sprintf(buff," t4  =%4.uc",t4); ShowBigLine(3);
//            sprintf(buff," t4  =%4.uc",t4); ShowBigLine(3);

            if (T<0){sprintf(buff,"T=-%3.i\xdfC",-T);}
            else{sprintf(buff,"T= %3.i\xdfC",T);};
            if (T<-25){sprintf(buff,"T=n/c   ");};ShowBigLine(5);
            

            if (U1>U1_MAX)
            { 
                PositionPointer=42;// перехід на аварію 
                PORTD.0=1; // відключаємо МЕРЕЖУ     !!!                                             
                LCD_Clear();                                             
            }    
        break;  
  ///////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////
        case 10: // час роботи із заслонкою
            sprintf(buff," НАСТРОЙКИ ");            ShowHeadLine(); 
            sprintf(buff,"                      "); ShowLine(5);
            sprintf(buff," t4  =%4.uc",t4); ShowBigLine(3);
            sprintf(buff,"   ВРЕМЯ ОБОГАЩЕНИЯ   "); ShowLine(INFOLINE1);
            sprintf(buff,"         СМЕСИ        "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t4++;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t4--;down=2;BEEP();}
            if(t4>60){t4=60;}
            if(t4<1){t4=1;} 
          break;
    ///////////////////////////////////////////////////////////////////////////////
        case 11: //   t5=t6
            sprintf(buff," t5  =%4.uc",t5);         ShowBigLine(3);              
            sprintf(buff,"    ВРЕМЯ ПРОГРЕВА    "); ShowLine(INFOLINE1);
            sprintf(buff,"     БЕЗ НАГРУЗКИ     "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t5=t5+5;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t5=t5-5;down=2;BEEP();}
            if(t5>60){t5=60;}
            if(t5<5){t5=5;}
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
        case 13: //
            sprintf(buff," Kz  =%4.u ",KilkistZapuskiv); ShowBigLine(3);
            sprintf(buff,"  КОЛИЧЕСТВО ПОПЫТОК  "); ShowLine(INFOLINE1);
            sprintf(buff,"  ЗАПУСКА ЭЛ.СТАНЦИИ  "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv++;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv--;down=2;BEEP();}
            if(KilkistZapuskiv>6){KilkistZapuskiv=6;}
            if(KilkistZapuskiv<1){KilkistZapuskiv=1;}             
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 14: //
            if(z==0){sprintf(buff," <ЗАСЛОНКА>");}
            else{sprintf(buff," < КЛАПАН >");}
            ShowBigLine(3);
            sprintf(buff,"     ТИП ПРИВОДА      "); ShowLine(INFOLINE1);
            sprintf(buff,"      И ИМПУЛЬСА      "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){z=!z;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){z=!z;down=2;BEEP();}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 15: //
            if(rotor==0){sprintf(buff," РОТОР<off>");}
            else{sprintf(buff," РОТОР<on> ");}
            ShowBigLine(3);
            sprintf(buff,"       КОНТРОЛЬ       "); ShowLine(INFOLINE1);
            sprintf(buff,"   СИГНАЛА: 'РОТОР'   "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){rotor=!rotor;up=2;BEEP();}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){rotor=!rotor;down=2;BEEP();}
        break;

    ///////////////////////////////////////////////////////////////////////////////
        case 16: //
            sprintf(buff," - ВЫХОД - ");            ShowBigLine(3); 
            sprintf(buff,"      ДЛЯ ВЫХОДА      "); ShowLine(INFOLINE1);
            sprintf(buff,"   УДЕРЖИВАЙ  'ВВОД'  "); ShowLine(INFOLINE2);
//            sprintf(buff,"%2.u",enter);
//            ShowLine(4); 

        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 30: //
            LCD_Clear();
            sprintf(buff,"  ЗАПУСК %1.u ",KilkistZapuskiv);           ShowHeadLine();
            delay_ms(ONE_SECOND); 
            sprintf(buff," ЗАЖИГАНИЕ  ");           ShowBigLine(3); 
            PORTD.6=1;                           //вмикаємо запалення OUT7
            delay_ms(ONE_SECOND); 
            ///////////////////////////////////
            PORTD.3=1; //Подаем сигнал на удержание заслонки и клапана
            if(z==0)
            {
                sprintf(buff," ЗАСЛОНКА-> "); ShowBigLine(3);
                PORTD.3=0;//відключаємо імпульс закритої заслонки
            }
            else
            {
                sprintf(buff," КЛАПАН ->  "); ShowBigLine(3);
            }
            delay_ms(ONE_SECOND);
            ///////////////////////////////////
            // !!!!добавить проверку выходного напряжения
            if(rotor<3){PORTD.5=1;};// запускаємо стартер ,якщо ротор не  працює v1.4)
            // !!!!добавить проверку выходного напряжения
            temp=t3; 
            while (temp!=0)
            {
                sprintf(buff," СТАРТЕР:%1.uc ",temp); ShowBigLine(3); 
                delay_ms(ONE_SECOND);
                temp--;                            
                if(rotor>7){temp=0;};// еесли двигатель запустился- переходим к засллонке                 
            };
            PORTD.5=0;                           //відключаємо стартер OUT6 на (1-6c) 
            ///////////////////////////////////
            temp=t4;                             // прогріваємо генератор із заслонкою (5-30с)
            while (temp!=0)
            {
                sprintf(buff,"ПРОГРЕВ:%2.uc ",temp); ShowBigLine(3); 
                delay_ms(ONE_SECOND);
                temp--;                            
//!!!                    if(T>TminZ){temp=0;};     //якщо температура высока - зупиняемо прогрів
            };
            ///////////////////////////////////
            PORTD.3=0; //відключаємо імпульс закритої заслонки АБО КЛАПАНА  
            if(z==0)
            {
                sprintf(buff," ЗАСЛОНКА < "); ShowBigLine(3);
                delay_ms(HALF_SECOND);                           //пауза чтоб не подать встречное напряжение
                PORTD.4=1; //відкріваємо заслонку OUT4  Реверсивный импульс!!!
            }
            else
            {
                sprintf(buff," КЛАПАН <-  "); ShowBigLine(3);
                delay_ms(ONE_SECOND);
            }                                   
            delay_ms(ONE_SECOND);
            PORTD.4=0; //відключаємо  реверсивний імпульс для заслонки и КЛАПАНА (на всякий случай)
            ///////////////////////////////////

//!!! /// добавить проверку (может уже завелся?)
            temp=RAZGON;   
            while (temp!=0){
                   sprintf(buff," РАЗГОН:%2.uc ",temp); ShowBigLine(3); 
                   delay_ms(ONE_SECOND);
                   temp--;                            
                 };
            ///////////////////////////////////
            if(KilkistZapuskiv>0){KilkistZapuskiv--;};
            PositionPointer=31; // Переход на проверку и прогрев
       break;
    ///////////////////////////////////////////////////////////////////////////////  
       case 31: // ПЕРЕВІРКА РОБОТИ ГЕНЕРАТОРА ,ПРОГРІВ 
            LCD_Clear();
            if(rotor<3){//ротор зупинився (генератор заглох)
                PORTD.6=0;              //вимикаємо запалення
                if(KilkistZapuskiv>0){
                    sprintf(buff," ПОВТОРНЫЙ  "); ShowBigLine(3); 
                    sprintf(buff,"   ЗАПУСК   "); ShowBigLine(5);           
                    delay_ms(NEXT_ZAPUSK_SECOND);
                      if(KilkistZapuskiv==1){delay_ms(NEXT_ZAPUSK_SECOND);};//якщо остання попитка - то акумулятор відпочиває у двічі довще (10с)
                      PositionPointer=30;  
                }
                else  //кількість запусків вичерпана
                { 
                    PositionPointer=40;     //переходимо на аварію "генератор не запустився"
                    goto begin;
                };
            }
            else //Генератор запустився, чекаємо підключення нагрузки
            {
                if(T<TminN){
                        temp=t5;     // Мінімальний час до підключення нагрузки                        
                        while (temp!=0)
                        { //якщо генератор запустився , то чекаємо (Мінімальний час до підключення нагрузки) 
                            sprintf(buff,"ПРОГРЕВ:%2.uc ",temp); ShowBigLine(3); 
                            delay_ms(ONE_SECOND);
                            temp--;                            
                        };
                 };
                 //ТУТ!!! Можна підключити генератор  (температура нормальна, або час витримано)
                 //але лише якщо вхідний автомат влючений, та генератор видае напругу    
                ///////////////////////////////////
                 if(PINC.4==1){ //на виході генератора немає напруги?  (лінія інверсна: 0 - напруга Є)
                        PORTD.6=0;              //вимикаємо запалення
                        PositionPointer=41;     //переходимо на аварію "генератор не видае напруги"
                        enter=2;
                        goto begin;
                 };
                 PerehodNaGenerator();  //підключення нагрузки на генератор
                 PositionPointer=32; // Робочий режим
//                 TimeSec=podsvet; PORTD.7=1; //вмикаємо підсвічування ЖКІ та переходимо до РОБОТИ
            };
       break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 32:  // РОБОТА (РУЧНА або АВТОМАТИЧНА)
            sprintf(buff,"  РАБОТА   ");            ShowHeadLine(); 
            MainInfo();

            if(AvtRu==0)//якщо робота АВТОМАТИЧНА то потрібен контроль появи струму!!
            { 
//!!!ПОМЕНЯТЬ
                if((U1>150)&&(U1<250))
                {   //напруга в мережі з'явилась?         
                    ///////////////////////////////////
                    temp=t2;        // загружаємо затримку переходу на основну мережу
                    while (temp!=0) // ждем, вдруг сеть пропадет снова?
                    {
                        sprintf(buff," СЕТЬ НОРМА "); ShowBigLine(3); 
                        sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                        delay_ms(ONE_SECOND);
                        temp--;                            
                    }
//!!!ПОМЕНЯТЬ
/*2.2*/             if ((U1>140)&&(U1<255)){PositionPointer=33;enter=2;goto begin;}  //напруга все ще є?,тоді перехід.
                }
            }
            else // ручная работа- тогда останов кнопкой!
            {
                if(enter>GO_TO_OPTIONS){PositionPointer=33;enter=2;};         
            }

            if(PINC.4==1){ //на виході генератора зникла напруга?  (лінія інверсна: 0 - напруга Є)
                    PerehodNaMereju();
                    PORTD.6=0;              //вимикаємо запалення
                    PositionPointer=41;     //переходимо на аварію "генератор не видае напруги"
                    enter=2;
            };
        break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 33:  // ОСТАНОВ С ОХЛАЖДЕНИЕМ
            sprintf(buff,"  ОСТАНОВ  ");            ShowHeadLine();  
            PerehodNaMereju();
            delay_ms(ONE_SECOND);
            ///////////////////////////////////
            temp=t5*2;    //загружаємо час охолодження            
            while (temp!=0) // ждем, вдруг сеть пропадет снова?
            {
                sprintf(buff," ОХЛАЖДЕНИЕ "); ShowBigLine(3); 
                sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                delay_ms(ONE_SECOND);
                temp--;                            
                if(AvtRu==0)
                { //якщо робота АВТОМАТИЧНА то потрібен контроль ЗНИКНЕННЯ струму!!
                    if ((U1<140)||(U1>265))
                    {  //напруга в мережі знову зникла
                        sprintf(buff,"  HET CETИ! "); ShowBigLine(3); 
                        sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                        delay_ms(ONE_SECOND);
                        PerehodNaGenerator();  //підключення нагрузки на генератор
                        PositionPointer=32; // перехід у "Робочий режим"
                        enter=2; goto begin;
                    }
                }
            }
           //////////////////////////////////
            temp=5;  // загружаємо час перекриття паливного клапану (при зупинці)
            PORTD.2=1; // перекриваэмо паливний клапан
            while (temp!=0){
                    sprintf(buff," ТОПЛИВНЫЙ  "); ShowBigLine(3); 
                    sprintf(buff," КЛАПАН%2.uc",temp);ShowBigLine(5);
                    delay_ms(ONE_SECOND);
                    PORTD.6=0;//вимикаємо запалення после первой секунды роботы клапана
                    temp--;                            
                 };
            PORTD.2=0; // відкриваэмо паливний клапан
            //////////////////////////////////
            if(AvtRu==0) //для автоматичного режиму - повернення у режим АВТОМАТ  иначе в ИНФО
            {
                PositionPointer=0;
            }
            else
            {
                PositionPointer=3;
            }
            PORTD.6=0;//вимикаємо запалення
            goto begin;
        break;
    ///////////////////////////////////////////////////////////////////////////////  

        case 40: // АВАРИЯ ГЕНЕРАТОР НЕ ЗАПУСТИЛСЯ
            sprintf(buff,"(!) ОШИБКА ");            ShowHeadLine(); 
            sprintf(buff," НЕ ЗАПУСК ");            ShowBigLine(3); 
            sprintf(buff,"      ДЛЯ СБРОСА      "); ShowLine(INFOLINE1);
            sprintf(buff,"   УДЕРЖИВАЙ  'ВВОД'  "); ShowLine(INFOLINE2);
            delay_ms(ONE_SECOND);
            LCD_Blinc(QUARTER_SECOND,3);
            if(enter>GO_TO_OPTIONS){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear();}
        break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 41: // АВАРИЯ НЕТ ТОКА ОТ ГЕНЕРАТОРА
            sprintf(buff,"(!) ОШИБКА ");            ShowHeadLine(); 
            sprintf(buff," НЕТ ТОКА  ");            ShowBigLine(3); 
            delay_ms(ONE_SECOND);
            LCD_Blinc(QUARTER_SECOND,3);
            if(enter>GO_TO_OPTIONS){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear();}
        break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 42: // АВАРИЯ НЕТ ТОКА ОТ ГЕНЕРАТОРА
            PORTD.0=1;  // відключаємо МЕРЕЖУ     !!!
            PORTD.1=0;  // відключаємо ГЕНЕРАТОР
            PORTD.6=0;  //вимикаємо: запалення OUT7
            PORTD.3=0;  //заслонку OUT5 (Port4)
            PORTD.4=0;           
            PORTD.5=0;  //вимикаємо стартер OUT6           

            sprintf(buff,"(!) ЗАЩИТА ");        ShowHeadLine(); 
            if(U1<255){
            sprintf(buff," Uвх =%4.uB",U1);     ShowBigLine(3);
            sprintf(buff,"      ДЛЯ СБРОСА      "); ShowLine(INFOLINE1);
            sprintf(buff,"   УДЕРЖИВАЙ  'ВВОД'  "); ShowLine(INFOLINE2);
            }
            else
            {
            sprintf(buff,"!Uвх > 260В!");       ShowBigLine(3);
            sprintf(buff,"  ВЫСОКОЕ НАПРЯЖЕНИЕ !"); ShowLine(INFOLINE1);
            sprintf(buff,"       СЕТИ !         "); ShowLine(INFOLINE2);
            }
            delay_ms(ONE_SECOND);
            LCD_Blinc(QUARTER_SECOND,3);
            if((U1<255)&(enter>GO_TO_OPTIONS)){PositionPointer=LAST_MODE_MENU;PORTD.0=0;enter=2;LCD_Clear();} // PORTD.0=0 - підключаємо МЕРЕЖУ
        break;
    ///////////////////////////////////////////////////////////////////////////////  

    };// switch (PositionPointer)
    begin:
    } //while

} //main


