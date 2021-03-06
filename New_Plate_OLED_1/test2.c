/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
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
static char buff[30];
#include <mega8.h>
#include <delay.h>
#include <i2c.h>
#include <stdio.h>
#include "ssd1306.c"

// Voltage Reference: Int., cap. on AREF
#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))

//#define PWR_LCD             PORTD.4
#define STARTER_REL         PORTB.0

#define GEN_REL             PORTD.2
#define LINE_REL            PORTD.3
#define ON_REL              PORTD.4
#define OFF_REL             PORTD.5
#define VALVE_U_REL         PORTD.6
#define VALVE_D_REL         PORTD.7

#define ROTOR_PIN           PINC.4
#define GEN_OUT_PIN         PIND.0

                            
#define KEY_E               PINB.4
#define KEY_U               PINB.3
#define KEY_D               PINB.2
#define KEY_SIG_NUM         10 
#define GO_TO_OPTIONS       20  
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
#define PODSVETKA           60

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
//                                                                                                  � ����!
eeprom unsigned char typeEEP = 0;           // ��� ��������������                                       -
eeprom unsigned char t1EEP   =10;           // ��� �������� �� ���������                                -
eeprom unsigned char t2EEP   =10;           // ��� �������� �� ������                                   -
eeprom unsigned char t3EEP   = 6;           // ��� ������ ��������                                      -
eeprom unsigned char t4EEP   = 8;           // ��� ������ �� ���������                                  V
eeprom unsigned char t5EEP   = 5;           // ��� ��� ��������  (������� � ���������� ������)          V
                                            // ���������� - � 2 ���� ������ ��� ������� ��� ��������
//eeprom unsigned char t6EEP =10;           // ��� ����������� 

eeprom unsigned char TminZEEP=20;           // ̳�������� ����������� ������� ���������� � ���������
eeprom unsigned char TminNEEP=50;           // ̳�������� ����������� ������� ����������               -
eeprom unsigned char Z_EEP   = 0;           // zaslonka/klapan                                          V
eeprom unsigned char R_EEP   = 0;           // �������� ������� "�������� ������"                       V
eeprom unsigned char KilkistZapuskiv_EEP=3; // ���������� ������� �������                               V

eeprom unsigned int  NarabotkaEEP=0;
eeprom unsigned char TO_EEP=1;           //TO ���������� 1 ���� ���� ������ ��, ����� ������� �� ����


static unsigned char type,t1,t2,t3,t4,t5,TminZ,TminN,KilkistZapuskiv;//,Narabotka,;
static unsigned char AvtRu=0;               //0-Auto; 1-Ru4noy                           
static bit z=0;
static bit r=0;
//static bit rbit=0;
static bit TO_output=0;

static unsigned char up,down,enter;
static unsigned char PositionPointer = 1;
static bit podmenu=0;

static unsigned char podsvet=60; //sec    
static unsigned int  U_Bat=0;
static unsigned int U1;
static int T;
  
static unsigned char rotor= 0;
//static unsigned char average_ADC_counter=0;
static unsigned int interrapt_counter=0;
static unsigned char second_counter=0;
static unsigned int  minut_counter=0;

unsigned int  U_Bat_ADC=0;
unsigned int  T_ADC=0;       
unsigned int  U1_ADC=0;

static unsigned int temp;


//char buff[30];  //����� �������

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

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void UpDownEnterKey()       //��������� � ���������!!!
{
 //Main menu
 if((PositionPointer>=1)&(PositionPointer<=LAST_MODE_MENU))    
 {  
    if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;};
    if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;};

    if(PositionPointer>LAST_MODE_MENU){PositionPointer=LAST_MODE_MENU;} //limits of Main menu
    if(PositionPointer<1){PositionPointer=1;}
    // Go to Options menu
    if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_MODE_MENU)){PositionPointer=FIRST_OPTION_MENU;enter=2;LCD_Clear();KilkistZapuskiv=KilkistZapuskiv_EEP;}; //� ���� kilkistzap obnovlyaem !
    if((enter>GO_TO_OPTIONS)&(PositionPointer==2)){PositionPointer=30;enter=2;KilkistZapuskiv=KilkistZapuskiv_EEP;}; //�� ������

  }
  if((PositionPointer>=FIRST_OPTION_MENU)&(PositionPointer<=LAST_OPTION_MENU))  
  {
        if(podmenu == 0)
        {
            if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;};
            if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;}; 
        }
        
        if((enter==1)&(PositionPointer!=LAST_OPTION_MENU))
            {   

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

        if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_OPTION_MENU)){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear(); }
  }
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
#asm("cli") 

    if(rotor>8){STARTER_REL=0;}//����� ������- ������� �� ������� ��������� ������� v1.4)
    if(ROTOR_PIN==0){rotor=rotor+1;}else{rotor=rotor-1;};
    if(rotor<1) rotor=1;
    if(rotor>10) rotor=10;

    if(KEY_U==0){up=up+1;podsvet=PODSVETKA;}      else  {up=0;};
    if(KEY_D==0){down=down+1;podsvet=PODSVETKA;}  else  {down=0;};
    if(KEY_E==0){enter=enter+1;podsvet=PODSVETKA;}else  {enter=0;};   //beep begin -DDRD.2=1;

    if(up>99) up=99;
    if(down>99) down=99;
    if(enter>99) enter=99;
    UpDownEnterKey(); 
/*
    U_Bat_ADC=read_adc(0); 
    U1_ADC=read_adc(2);
    T_ADC=read_adc(1);

    T_ADC=T_ADC/4;
    T=Termo[T_ADC];
    T=T-50;
    U_Bat=(U_Bat_ADC*20)/102; //�������� ������- ����� !!!!��� ����� ����� �� 10
    U1=(U1_ADC*11)/41;//���� ��� �������
*/
    U_Bat_ADC=U_Bat_ADC+read_adc(1);
    U_Bat_ADC=U_Bat_ADC>>1;
    U1_ADC=U1_ADC+read_adc(0);
    U1_ADC=U1_ADC>>1;

    T_ADC=T_ADC+read_adc(5); 
    T_ADC=T_ADC>>1;

    
    if(interrapt_counter>=31) //61~2sec -   8 mHz
    {
        U_Bat=U_Bat_ADC/5; //�������� ������- ����� !!!!��� ����� ����� �� 10
        U1=(U1_ADC*11)/41;//���� ��� �������
        T=Termo[T_ADC>>2]; // divide 4
        T=T-50;

        interrapt_counter=0;
        second_counter++;
        if(podsvet>0)podsvet--;
                      
        ////////////////TO
        if(TO_EEP!=0)
        {
            if (second_counter%2!=0){TO_output=1; }
            else{TO_output=0;};//��������  ��
        }
        ////////////////TO
          if(second_counter>=59) 
        {
            second_counter=0;
            podsvet=10;
            if(PositionPointer==32){minut_counter++;};            
        }
    }
    interrapt_counter++;

// ��������� ����������


#asm("sei")         
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void PerehodNaGenerator()
{
        LINE_REL=1; // ��������� ������
        delay_ms(HALF_SECOND);
        GEN_REL=1; // ϳ�������� ���������
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void PerehodNaMereju()
{
        GEN_REL=0; // ��������� ���������
        delay_ms(HALF_SECOND); 
        LINE_REL=0; // ϳ�������� ������
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void Klapan_off()
{
#asm("cli") 
LCD_Clear();
            temp=15;  // ��������� ��� ���������� ��������� ������� (��� �������)
            OFF_REL=1; // ������������ �������� ������
            while (temp!=0){
//                 sprintf(buff," ���������  "); ShowBigLine(3); 
                    sprintf(buff," �.����%2.uc",temp);ShowBigLine(5);
                    delay_ms(ONE_SECOND);
                   // PORTD.6=0;//�������� ��������� ����� ������ ������� ������ �������
                    temp--;                            
                 };
            OFF_REL=0; // ���������� �������� ������   
            ON_REL=0;//�������� ���������   
LCD_Clear();
#asm("sei")            
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



void MainInfo()
{
    sprintf(buff," Uin =%4.uB ",U1);ShowBigLine(3); 
    sprintf(buff,"       Ub = %2.u.%1.uB       ",U_Bat/10,U_Bat%10);ShowLine(5);
//    sprintf(buff,"  Ub =%2.u.%1.uB N:%5.uh ",U_Bat/10,U_Bat%10,NarabotkaEEP/6);ShowLine(5);
//    LCD_Goto(0,5);
//    LCD_Printf(buff,1);  //  ����� �� �������
//            sprintf(buff,"      N:%6.uh       ",NarabotkaEEP/6);
//            sprintf(buff,"������:'TO'  N:%5.uh ",NarabotkaEEP/6); ShowLine(INFOLINE1); 
//sprintf(buff,"  ������� ��.�������  "); ShowLine(INFOLINE2);
//sprintf(buff," Uin =%4.uB Ubat=%2.u.%1.uB ",U1,U_Bat/10,U_Bat%10);ShowLine(2);
    if(TO_EEP)
    {
        if(TO_output)
        {
            sprintf(buff,"                      ");
        }
        else
        {
            sprintf(buff," !!! ������������ !!! ");
         
        }
        ShowLine(INFOLINE2);
    }

            if (T<0){  sprintf(buff,"  T =-%3.i*C N:%5.uh ",-T,NarabotkaEEP/6);}
                else{  sprintf(buff,"  T = %3.i*C N:%5.uh ",T,NarabotkaEEP/6);};
            if (T<-25){sprintf(buff,"  T = n/c   N:%5.uh ",NarabotkaEEP/6);};  ShowLine(6);
}
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//--------------------------------    MAIN     ----------------------------------------------------------
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void main(void)
{
// Declare your local variables here
   
// Input/Output Ports initialization

PORTB=0b00000000; DDRB =0b00100011;         // 0-START ; 1,5 - OLED; 2,3,4 -keys;  6,7 - zaslonka
PORTC=0b00000000; DDRC =0b00000000;         // 
PORTD=0b00000000; DDRD =0b11111100;

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
// ��������� �� EEPROM
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
    sprintf(buff," MicroCraft "); ShowBigLine(0); 
    LCD_Goto(45,3);

    sprintf(buff,"(TM)");
    LCD_Printf(buff,1);  //  ����� �� �������       
    LCD_Goto(0,6);
    sprintf(buff," PGSII  v.2 ");
    LCD_Printf(buff,1);  //  ����� �� �������  

    LCD_Blinc(QUARTER_SECOND,3);
/*
//    delay_ms(5000); 

    //     LCD_DrawImage(0);
    //     delay_ms(5000);
//LCD_Clear();
    //       LCD_Contrast(1);  
    */
///////////////////////////////////////////////////////////////////////////////
while (1)
    {
      #asm("cli") 
      if(podmenu == 0){LCD_Mode(0);}
      else{LCD_Mode(1);}
      #asm("sei")
///////////////////////////////////////////////////////////////////////////////
//    sprintf(buff,"  R:%2.u S%3.u e:%2.u p:%2.u",rotor,second_counter,enter,PositionPointer);
//    sprintf(buff,"%3.u %3.u N:%4.u� p%2.u",second_counter,minut_counter,NarabotkaEEP,PositionPointer);    
//    ShowLine(7);

//    sprintf(buff,"      N:%6.u�     ",NarabotkaEEP/6);    
//    ShowLine(7);

//                        sprintf(buf2,"N=%4.u� ",NarabotkaMinEEP/10);                                                  
///////////////////////////////////////////////////////////////////////////////
if (minut_counter>=10)
{ 
    #asm("cli") 
    NarabotkaEEP++; 
    minut_counter=0;  
    if ((NarabotkaEEP==120)|(NarabotkaEEP==600)|(NarabotkaEEP==1200)|(NarabotkaEEP==1800)|(NarabotkaEEP==2400)){NarabotkaEEP++;TO_EEP=1;};
    #asm("sei")
};            //   ��� ��������� 10��     
///////////////////////////////////////////////////////////////////////////////
    switch (PositionPointer){
    ///////////////////////////////////////////////////////////////////////////////
        case 1: // ������������ ������
            //if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){#asm("cli") TO_EEP=0; #asm("sei") up=2;}
            if(enter>=98){enter=2;LCD_Clear();#asm("cli") TO_EEP=0; #asm("sei") up=2; }

            AvtRu=0; // ������������ ����, ���� ���� ���������� ���� ��� �������� ����� - ������� �� ������    
            if(podsvet>=1){
                sprintf(buff," 1: ����    "); 
                ShowBigLine(0);     
                MainInfo();
//            if(podsvet==1){LCD_Clear();podsvet=0;} 
            }
            else 
            {
                LCD_Clear();
                sprintf(buff,"$"); 
                ShowBigLine(0);
                delay_ms(100); 
                LCD_init(); 
            }   

            if ((U1<U1_MIN)||(U1>U1_MAX)){  //������� � ����� ������ 175�-80% ��� ������ 265
//��������� ������� ������ ��������!!!
                if(U1>U1_MAX){LINE_REL=1;}   // ��������� ������    ��� ������ !!! 
                temp=t1;  // ��������� �������� �������� �� ���������
                while (temp!=0)
                {
                    sprintf(buff,"  HET CET�! "); ShowBigLine(3); 
                    sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                    delay_ms(ONE_SECOND);
                    if(PositionPointer!=1){goto begin;}
                    temp--;                            
                }
                if ((U1<U1_MIN-5)||(U1>U1_MAX+5)){PositionPointer=30; KilkistZapuskiv=KilkistZapuskiv_EEP;};  
                //������� ��� �� �� ����������� ������ ?,��� �������.
                // �������� ����������
            }
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 2: //
            AvtRu=1; // ������������ ����, ���� ���� ���������� ���� ��� �������� ����� - ������� �� ������
            sprintf(buff," 2: ������ ");            ShowBigLine(0);      
            MainInfo();  
            if (U1>U1_MAX)
            { 
                PositionPointer=42;// ������� �� ����� 
                Klapan_off();
                LINE_REL=1; // ��������� ������     !!!
                LCD_Clear();                                             
            }            
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 3: //
            sprintf(buff," 3: ����   ");            ShowBigLine(0);
            MainInfo();   

/*
//            sprintf(buff," t4  =%4.uc",t4); ShowBigLine(3);
            sprintf(buff,"%4.uB %2.u.%1.uB",U1,U_Bat/10,U_Bat%10);ShowBigLine(3); 
            if (T<0){  sprintf(buff,"  T =-%3.i*C ",-T);}
                else{  sprintf(buff,"  T = %3.i*C ",T);};
            if (T<-25){sprintf(buff,"  T = n/c   ");};  ShowBigLine(5);
*/            

            if (U1>U1_MAX)
            { 
                PositionPointer=42;// ������� �� ����� 
                Klapan_off();
                LINE_REL=1; // ��������� ������     !!!                                             
                LCD_Clear();                                             
            }    
        break;  
  ///////////////////////////////////////////////////////////////////////////////
        case 10: // ��� ������ �� ���������
            sprintf(buff," ��������� ");            ShowBigLine(0); 
            sprintf(buff,"                      "); ShowLine(5);
            sprintf(buff," t4  =%4.uc ",t4); ShowBigLine(3);
            sprintf(buff,"   ����� ����������   "); ShowLine(INFOLINE1);
//            sprintf(buff,"         �����        "); ShowLine(INFOLINE2); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t4++;up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t4--;down=2;}
            if(t4>60){t4=60;}
            if(t4<1){t4=1;} 
          break;
    ///////////////////////////////////////////////////////////////////////////////
        case 11: //   t5=t6
            sprintf(buff," t5  =%4.uc ",t5);         ShowBigLine(3);              
//            sprintf(buff,"    ����� ��������    "); ShowLine(INFOLINE1);
            sprintf(buff," ������� ��� �������� "); ShowLine(INFOLINE1); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t5=t5+5;up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t5=t5-5;down=2;}
            if(t5>60){t5=60;}
            if(t5<5){t5=5;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 12: // ̳�������� ����������� ������� ���������� � ���������(����� ������ ��� ������)
            sprintf(buff," Tz  =%3.u*C ",TminZ);      ShowBigLine(3);
//            sprintf(buff,"   �a�. �����������   "); ShowLine(INFOLINE1);
//            sprintf(buff,"   ���������� �����   "); ShowLine(INFOLINE2);
            sprintf(buff," ���.����.����������  "); ShowLine(INFOLINE1);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){TminZ=TminZ+5;up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){TminZ=TminZ-5;down=2;}
            if(TminZ>90){TminZ=90;}
            if(TminZ<5){TminZ=5;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 13: //
            sprintf(buff," Kz  =%4.u ",KilkistZapuskiv); ShowBigLine(3);
//            sprintf(buff,"  ���������� �������  "); ShowLine(INFOLINE1);
//          sprintf(buff,"  ������� ��.�������  "); ShowLine(INFOLINE2); 
            sprintf(buff," ���������� ��������  "); ShowLine(INFOLINE1);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv++;up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv--;down=2;}
            if(KilkistZapuskiv>6){KilkistZapuskiv=6;}
            if(KilkistZapuskiv<1){KilkistZapuskiv=1;}             
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 14: //
            if(z==0){sprintf(buff," <��������> ");}
            else{sprintf(buff," < ������ > ");}
            ShowBigLine(3);
            sprintf(buff,"     ��� �������      "); ShowLine(INFOLINE1);
//            sprintf(buff,"      � ��������      "); ShowLine(INFOLINE2);
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){z=!z;up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){z=!z;down=2;}
        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 15: //
            if(r==0){sprintf(buff," �����(off)");}
            else{sprintf(buff," �����(on) ");}
            ShowBigLine(3);
//            sprintf(buff,"       ��������       "); ShowLine(INFOLINE1);
            sprintf(buff,"   ������ : '�����'   "); ShowLine(INFOLINE1); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){r=!r;up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){r=!r;down=2;}
        break;

    ///////////////////////////////////////////////////////////////////////////////
/*        case 16: //
            if(TO_EEP==0){sprintf(buff,"  TO  ( 0 )");}
            else{         sprintf(buff,"  TO  ( 1 )");}
            ShowBigLine(3);

//            sprintf(buff,"       ��������       "); ShowLine(INFOLINE1);
//            sprintf(buff,"      N:%6.uh       ",NarabotkaEEP/6);
            sprintf(buff,"������:'TO'  N:%5.uh ",NarabotkaEEP/6); ShowLine(INFOLINE1); 
//            sprintf(buff,"   ������ : ' TO  '   "); ShowLine(INFOLINE1); 
            if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){#asm("cli") TO_EEP=0; #asm("sei") up=2;}
            if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){#asm("cli") TO_EEP=0; #asm("sei")down=2;}
        break;
*/
    ///////////////////////////////////////////////////////////////////////////////
        case 16: //
            sprintf(buff," - ����� - ");            ShowBigLine(3); 
//            sprintf(buff,"      ��� ������      "); ShowLine(INFOLINE1);
//            sprintf(buff,"   ���������  '����'  "); ShowLine(INFOLINE2); 
            sprintf(buff,"  ��� ������ >'����'  "); ShowLine(INFOLINE1);
           
//            sprintf(buff,"%2.u",enter);
//            ShowLine(4); 

        break;
    ///////////////////////////////////////////////////////////////////////////////
        case 30: //
            LCD_Clear();
            sprintf(buff,"  ������ %1.u ",KilkistZapuskiv);           ShowBigLine(0);
            delay_ms(ONE_SECOND); 
            sprintf(buff," ���������  ");           ShowBigLine(3); 
            ON_REL=1;      //������� ��������� OUT7
            if(T<TminZ){
                VALVE_U_REL=1;                          
                delay_ms(ONE_SECOND); 
                if(z==0)
                {
                    sprintf(buff," ��������-> "); ShowBigLine(3);
                    VALVE_U_REL=0;//��������� ������� ������� ��������
                }
                else
                {
                    sprintf(buff," ������ ->  "); ShowBigLine(3);
                }
                delay_ms(ONE_SECOND);
            };
            ///////////////////////////////////
////////
            // !!!!�������� �������� ��������� ����������
            if(rotor<3){STARTER_REL=1;};// ��������� ������� ,���� ����� ��  ������ v1.4)
            // !!!!�������� �������� ��������� ����������
            temp=t3; 
            while (temp!=0)
            {
                sprintf(buff," �������:%1.uc ",temp); ShowBigLine(3); 
                delay_ms(ONE_SECOND);
                temp--;                            
                if(rotor>7){temp=0;};// ����� ��������� ����������- ��������� � ���������                 
            };
            STARTER_REL=0;                           //��������� ������� OUT6 �� (1-6c) 
            ///////////////////////////////////
            temp=t4;                             // ��������� ��������� �� ��������� (5-30�)
            if(T<TminZ){
                while (temp!=0)
                {
                    sprintf(buff,"�������:%2.uc ",temp); ShowBigLine(3); 
                    delay_ms(ONE_SECOND);
                    temp--;                            
    //                if(T>TminZ){temp=0;}     //���� ����������� ������ - ��������� ������
                };
                ///////////////////////////////////
                VALVE_U_REL=0; //��������� ������� ������� �������� ��� �������  
                if(z==0)
                {
                    sprintf(buff," �������� < "); ShowBigLine(3);
                    delay_ms(HALF_SECOND);                           //����� ���� �� ������ ��������� ����������
                    VALVE_D_REL=1; //�������� �������� OUT4  ����������� �������!!!
                }
                else
                {
                    sprintf(buff," ������ <-  "); ShowBigLine(3);
                    delay_ms(ONE_SECOND);
                }                                   
                delay_ms(ONE_SECOND);
            }
            VALVE_D_REL=0; //���������  ����������� ������� ��� �������� � ������� (�� ������ ������)
            ///////////////////////////////////

//!!! /// �������� �������� (����� ��� �������?)
            temp=RAZGON;   
            while (temp!=0){
                   sprintf(buff," ������:%2.uc ",temp); ShowBigLine(3); 
                   delay_ms(ONE_SECOND);
                   temp--;                            
                 };
            ///////////////////////////////////
            if(KilkistZapuskiv>0){KilkistZapuskiv--;};
            PositionPointer=31; // ������� �� �������� � �������
       break;
    ///////////////////////////////////////////////////////////////////////////////  
       case 31: // ����²��� ������ ���������� ,����в� 
            LCD_Clear();
            if(rotor<3){//����� ��������� (��������� ������)
                ON_REL=0;              //�������� ���������
                if(KilkistZapuskiv>0){
                    sprintf(buff," ���������  "); ShowBigLine(3); 
                    sprintf(buff,"   ������   "); ShowBigLine(5);           
                    delay_ms(NEXT_ZAPUSK_SECOND);
                      if(KilkistZapuskiv==1){delay_ms(NEXT_ZAPUSK_SECOND);};//���� ������� ������� - �� ���������� �������� � ���� ����� (10�)
                      PositionPointer=30;  
                }
                else  //������� ������� ���������
                { 
                    PositionPointer=40;     //���������� �� ����� "��������� �� ����������"
                    Klapan_off();
                    goto begin;
                };
            }
            else //��������� ����������, ������ ���������� ��������
            {
                if(T<TminN){
                        temp=t5;     // ̳��������� ��� �� ���������� ��������                        
                        while (temp!=0)
                        { //���� ��������� ���������� , �� ������ (̳��������� ��� �� ���������� ��������) 
                            sprintf(buff,"�������:%2.uc ",temp); ShowBigLine(3); 
                            delay_ms(ONE_SECOND);
                            temp--;                            
                        };
                 };
                 //���!!! ����� ��������� ���������  (����������� ���������, ��� ��� ���������)
                 //��� ���� ���� ������� ������� ��������, �� ��������� ����� �������    
                ///////////////////////////////////
                 if(GEN_OUT_PIN==1){ //�� ����� ���������� ���� �������?  (���� ��������: 0 - ������� �)
                        ON_REL=0;              //�������� ���������
                        PositionPointer=41;     //���������� �� ����� "��������� �� ����� �������"
                        Klapan_off();
                        enter=2;
                        goto begin;
                 };
                 PerehodNaGenerator();  //���������� �������� �� ���������
                 PositionPointer=32; // ������� �����
//                 TimeSec=podsvet; PORTD.7=1; //������� ����������� �ʲ �� ���������� �� ������
            };
       break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 32:  // ������ (����� ��� �����������)
            sprintf(buff,"  ������   ");            ShowBigLine(0); 
            MainInfo();

            if(AvtRu==0)//���� ������ ����������� �� ������� �������� ����� ������!!
            { 
//!!!��������
                if((U1>150)&&(U1<250))
                {   //������� � ����� �'�������?         
                    ///////////////////////////////////
                    temp=t2;        // ��������� �������� �������� �� ������� ������
                    while (temp!=0) // ����, ����� ���� �������� �����?
                    {
                        sprintf(buff," ���� ����� "); ShowBigLine(3); 
                        sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                        delay_ms(ONE_SECOND);
                        temp--;                            
                    }
//!!!��������
/*2.2*/             if ((U1>140)&&(U1<255)){PositionPointer=33;enter=2;goto begin;}  //������� ��� �� �?,��� �������.
                }
            }
            else // ������ ������- ����� ������� �������!
            {
                if(enter>GO_TO_OPTIONS){PositionPointer=33;enter=2;};         
            }

            if(GEN_OUT_PIN==1){ //�� ����� ���������� ������ �������?  (���� ��������: 0 - ������� �)
                    PerehodNaMereju();
                    ON_REL=0;              //�������� ���������
                    PositionPointer=41;     //���������� �� ����� "��������� �� ����� �������"
                    Klapan_off();
                    enter=2;
                    LCD_Clear();
            };
        break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 33:  // ������� � �����������
            sprintf(buff,"  �������  ");            ShowBigLine(0);  
            PerehodNaMereju();
            delay_ms(ONE_SECOND);
            ///////////////////////////////////
            temp=t5;    //��������� ��� �����������            
            while (temp!=0) // ����, ����� ���� �������� �����?
            {
                sprintf(buff," ���������� "); ShowBigLine(3); 
                sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                delay_ms(ONE_SECOND);
                temp--;                            
                if(AvtRu==0)
                { //���� ������ ����������� �� ������� �������� ��������� ������!!
                    if ((U1<140)||(U1>265))
                    {  //������� � ����� ����� ������
                        sprintf(buff,"  HET CET�! "); ShowBigLine(3); 
                        sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
                        delay_ms(ONE_SECOND);
                        PerehodNaGenerator();  //���������� �������� �� ���������
                        PositionPointer=32; // ������� � "������� �����"
                        enter=2; goto begin;
                    }
                }
            }
           //////////////////////////////////
            Klapan_off();
            //////////////////////////////////
            if(AvtRu==0) //��� ������������� ������ - ���������� � ����� �������  ����� � ����
            {
                PositionPointer=1;
            }
            else
            {
                PositionPointer=3;
            }
            ON_REL=0;//�������� ���������
            goto begin;
        break;
    ///////////////////////////////////////////////////////////////////////////////  

        case 40: // ������ ��������� �� ����������
            sprintf(buff,"(!) ������ ");            ShowBigLine(0); 
            sprintf(buff," �� ������ ");            ShowBigLine(3); 
//            sprintf(buff,"      ��� ������      "); ShowLine(INFOLINE1);
//            sprintf(buff,"   ���������  '����'  "); ShowLine(INFOLINE2);
            sprintf(buff,"  ��� ������ >'����'  "); ShowLine(INFOLINE1);
            delay_ms(ONE_SECOND);
            LCD_Blinc(QUARTER_SECOND,3);
            if(enter>GO_TO_OPTIONS){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear();}
        break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 41: // ������ ��� ���� �� ����������
            sprintf(buff,"(!) ������ ");            ShowBigLine(0); 
            sprintf(buff," ��� ����  ");            ShowBigLine(3); 
            sprintf(buff,"  ��� ������ >'����'  "); ShowLine(INFOLINE1);
            delay_ms(ONE_SECOND);
            LCD_Blinc(QUARTER_SECOND,3);
            if(enter>GO_TO_OPTIONS){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear();}
        break;
    ///////////////////////////////////////////////////////////////////////////////  
        case 42: // ������ ��� ���� �� ����������
            LINE_REL=1;  // ��������� ������     !!!
            GEN_REL=0;  // ��������� ���������
            ON_REL =0;  //��������: ��������� OUT7
            VALVE_U_REL=0;  //�������� OUT5 (Port4)
            VALVE_D_REL=0;           
            STARTER_REL=0;  //�������� ������� OUT6         
            


            sprintf(buff,"(!) ������ ");        ShowBigLine(0); 
            if(U1<255){
            sprintf(buff," Uin =%4.uB",U1);     ShowBigLine(3);
            sprintf(buff,"  ��� ������ >'����'  "); ShowLine(INFOLINE1);
            }
            else
            {
            sprintf(buff,"!Uin > 260�!");       ShowBigLine(3);
            sprintf(buff,"  ������� ���������� !"); ShowLine(INFOLINE1);
//            sprintf(buff,"       ���� !         "); ShowLine(INFOLINE2);
            }
            delay_ms(ONE_SECOND);
            LCD_Blinc(QUARTER_SECOND,3);
            if((U1<255)&(enter>GO_TO_OPTIONS)){PositionPointer=LAST_MODE_MENU;PORTD.0=0;enter=2;LCD_Clear();} // PORTD.0=0 - ��������� ������
        break;
    ///////////////////////////////////////////////////////////////////////////////  
    };// switch (PositionPointer)
    begin:
    } //while

} //main


