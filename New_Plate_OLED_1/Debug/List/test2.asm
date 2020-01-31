
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8
;Program type           : Application
;Clock frequency        : 2,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _LCD_X=R5
	.DEF _LCD_Y=R4
	.DEF _U_Bat_ADC=R6
	.DEF _U_Bat_ADC_msb=R7
	.DEF _T_ADC=R8
	.DEF _T_ADC_msb=R9
	.DEF _U1_ADC=R10
	.DEF _U1_ADC_msb=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_LCD_Buffer:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x36,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x22
	.DB  0x1C,0x7F,0x49,0x49,0x49,0x41,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x7A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x0,0x41,0x7F
	.DB  0x41,0x0,0x20,0x40,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x19,0x29,0x46,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0x1F,0x20
	.DB  0x40,0x20,0x1F,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x7,0x8,0x70
	.DB  0x8,0x7,0x61,0x51,0x49,0x45,0x43,0x0
	.DB  0x7F,0x41,0x41,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x41,0x41,0x7F,0x0,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x7C,0x4,0x18,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x18,0x7C,0x7C,0x8,0x4,0x4,0x8,0x8
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x10,0x8
	.DB  0x8,0x10,0x8,0x78,0x46,0x41,0x46,0x78
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x8,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x0,0x6,0x9,0x9,0x6,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x1,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x36,0x36,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49,0x49
	.DB  0x49,0x31,0x7F,0x49,0x49,0x49,0x36,0x7F
	.DB  0x1,0x1,0x1,0x3,0x60,0x3E,0x21,0x21
	.DB  0x7F,0x7F,0x49,0x49,0x49,0x41,0x77,0x8
	.DB  0x7F,0x8,0x77,0x22,0x41,0x49,0x49,0x36
	.DB  0x7F,0x10,0x8,0x4,0x7F,0x7F,0x10,0x9
	.DB  0x4,0x7F,0x7F,0x8,0x14,0x22,0x41,0x40
	.DB  0x3E,0x1,0x1,0x7F,0x7F,0x2,0xC,0x2
	.DB  0x7F,0x7F,0x8,0x8,0x8,0x7F,0x3E,0x41
	.DB  0x41,0x41,0x3E,0x7F,0x1,0x1,0x1,0x7F
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x41
	.DB  0x41,0x22,0x1,0x1,0x7F,0x1,0x1,0x27
	.DB  0x48,0x48,0x48,0x3F,0x1E,0x21,0x7F,0x21
	.DB  0x1E,0x63,0x14,0x8,0x14,0x63,0x3F,0x20
	.DB  0x20,0x3F,0x60,0x7,0x8,0x8,0x8,0x7F
	.DB  0x7F,0x40,0x7F,0x40,0x7F,0x3F,0x20,0x3F
	.DB  0x20,0x7F,0x1,0x7F,0x48,0x48,0x30,0x7F
	.DB  0x48,0x30,0x0,0x7F,0x0,0x7F,0x48,0x48
	.DB  0x30,0x22,0x41,0x49,0x49,0x3E,0x7F,0x8
	.DB  0x3E,0x41,0x3E,0x46,0x29,0x19,0x9,0x7F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x25:
	.DB  0x1
_0x26:
	.DB  0x3C
_0x0:
	.DB  0x20,0xD2,0x2E,0xCA,0xCB,0xC0,0xCF,0x25
	.DB  0x32,0x2E,0x75,0x63,0x0,0x20,0x55,0x69
	.DB  0x6E,0x20,0x3D,0x25,0x34,0x2E,0x75,0x42
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x55,0x62,0x20,0x3D,0x20,0x25,0x32
	.DB  0x2E,0x75,0x2E,0x25,0x31,0x2E,0x75,0x42
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x21,0x21,0x21,0x20,0xCE,0xC1,0xD1,0xCB
	.DB  0xD3,0xC6,0xC8,0xC2,0xC0,0xCD,0xC8,0xC5
	.DB  0x20,0x21,0x21,0x21,0x20,0x0,0x20,0x20
	.DB  0x54,0x20,0x3D,0x2D,0x25,0x33,0x2E,0x69
	.DB  0x2A,0x43,0x20,0x4E,0x3A,0x25,0x35,0x2E
	.DB  0x75,0x68,0x20,0x0,0x20,0x20,0x54,0x20
	.DB  0x3D,0x20,0x25,0x33,0x2E,0x69,0x2A,0x43
	.DB  0x20,0x4E,0x3A,0x25,0x35,0x2E,0x75,0x68
	.DB  0x20,0x0,0x20,0x20,0x54,0x20,0x3D,0x20
	.DB  0x6E,0x2F,0x63,0x20,0x20,0x20,0x4E,0x3A
	.DB  0x25,0x35,0x2E,0x75,0x68,0x20,0x0,0x20
	.DB  0x4D,0x69,0x63,0x72,0x6F,0x43,0x72,0x61
	.DB  0x66,0x74,0x20,0x0,0x28,0x54,0x4D,0x29
	.DB  0x0,0x20,0x50,0x47,0x53,0x49,0x49,0x20
	.DB  0x20,0x76,0x2E,0x32,0x20,0x0,0x20,0x31
	.DB  0x3A,0x20,0xC0,0xC2,0xD2,0xCE,0x20,0x20
	.DB  0x20,0x20,0x0,0x24,0x0,0x20,0x20,0x48
	.DB  0x45,0x54,0x20,0x43,0x45,0x54,0xC8,0x21
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x25,0x33
	.DB  0x2E,0x75,0x63,0x20,0x20,0x20,0x0,0x20
	.DB  0x32,0x3A,0x20,0xD0,0xD3,0xD7,0xCD,0xCE
	.DB  0xC9,0x20,0x0,0x20,0x33,0x3A,0x20,0xD1
	.DB  0xD2,0xCE,0xCF,0x20,0x20,0x20,0x0,0x20
	.DB  0xCD,0xC0,0xD1,0xD2,0xD0,0xCE,0xC9,0xCA
	.DB  0xC8,0x20,0x0,0x20,0x74,0x34,0x20,0x20
	.DB  0x3D,0x25,0x34,0x2E,0x75,0x63,0x20,0x0
	.DB  0x20,0x20,0x20,0xC2,0xD0,0xC5,0xCC,0xDF
	.DB  0x20,0xCE,0xC1,0xCE,0xC3,0xC0,0xD9,0xC5
	.DB  0xCD,0xC8,0xDF,0x20,0x20,0x20,0x0,0x20
	.DB  0x74,0x35,0x20,0x20,0x3D,0x25,0x34,0x2E
	.DB  0x75,0x63,0x20,0x0,0x20,0xCF,0xD0,0xCE
	.DB  0xC3,0xD0,0xC5,0xC2,0x20,0xC1,0xC5,0xC7
	.DB  0x20,0xCD,0xC0,0xC3,0xD0,0xD3,0xC7,0xCA
	.DB  0xC8,0x20,0x0,0x20,0x54,0x7A,0x20,0x20
	.DB  0x3D,0x25,0x33,0x2E,0x75,0x2A,0x43,0x20
	.DB  0x0,0x20,0xCC,0xC8,0xCD,0x2E,0xD2,0xC5
	.DB  0xCC,0xCF,0x2E,0xCE,0xC1,0xCE,0xC3,0xC0
	.DB  0xD9,0xC5,0xCD,0xC8,0xDF,0x20,0x20,0x0
	.DB  0x20,0x4B,0x7A,0x20,0x20,0x3D,0x25,0x34
	.DB  0x2E,0x75,0x20,0x0,0x20,0xCA,0xCE,0xCB
	.DB  0xC8,0xD7,0xC5,0xD1,0xD2,0xC2,0xCE,0x20
	.DB  0xC7,0xC0,0xCF,0xD3,0xD1,0xCA,0xCE,0xC2
	.DB  0x20,0x20,0x0,0x20,0x3C,0xC7,0xC0,0xD1
	.DB  0xCB,0xCE,0xCD,0xCA,0xC0,0x3E,0x20,0x0
	.DB  0x20,0x3C,0x20,0xCA,0xCB,0xC0,0xCF,0xC0
	.DB  0xCD,0x20,0x3E,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0xD2,0xC8,0xCF,0x20,0xCF,0xD0
	.DB  0xC8,0xC2,0xCE,0xC4,0xC0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0xD0,0xCE,0xD2
	.DB  0xCE,0xD0,0x28,0x6F,0x66,0x66,0x29,0x0
	.DB  0x20,0xD0,0xCE,0xD2,0xCE,0xD0,0x28,0x6F
	.DB  0x6E,0x29,0x20,0x0,0x20,0x20,0x20,0xD1
	.DB  0xC8,0xC3,0xCD,0xC0,0xCB,0x20,0x3A,0x20
	.DB  0x27,0xD0,0xCE,0xD2,0xCE,0xD0,0x27,0x20
	.DB  0x20,0x20,0x0,0x20,0x2D,0x20,0xC2,0xDB
	.DB  0xD5,0xCE,0xC4,0x20,0x2D,0x20,0x0,0x20
	.DB  0x20,0xC4,0xCB,0xDF,0x20,0xC2,0xDB,0xD5
	.DB  0xCE,0xC4,0xC0,0x20,0x3E,0x27,0xC2,0xC2
	.DB  0xCE,0xC4,0x27,0x20,0x20,0x0,0x20,0x20
	.DB  0xC7,0xC0,0xCF,0xD3,0xD1,0xCA,0x20,0x25
	.DB  0x31,0x2E,0x75,0x20,0x0,0x20,0xC7,0xC0
	.DB  0xC6,0xC8,0xC3,0xC0,0xCD,0xC8,0xC5,0x20
	.DB  0x20,0x0,0x20,0xC7,0xC0,0xD1,0xCB,0xCE
	.DB  0xCD,0xCA,0xC0,0x2D,0x3E,0x20,0x0,0x20
	.DB  0xCA,0xCB,0xC0,0xCF,0xC0,0xCD,0x20,0x2D
	.DB  0x3E,0x20,0x20,0x0,0x20,0xD1,0xD2,0xC0
	.DB  0xD0,0xD2,0xC5,0xD0,0x3A,0x25,0x31,0x2E
	.DB  0x75,0x63,0x20,0x0,0xCF,0xD0,0xCE,0xC3
	.DB  0xD0,0xC5,0xC2,0x3A,0x25,0x32,0x2E,0x75
	.DB  0x63,0x20,0x0,0x20,0xC7,0xC0,0xD1,0xCB
	.DB  0xCE,0xCD,0xCA,0xC0,0x20,0x3C,0x20,0x0
	.DB  0x20,0xCA,0xCB,0xC0,0xCF,0xC0,0xCD,0x20
	.DB  0x3C,0x2D,0x20,0x20,0x0,0x20,0xD0,0xC0
	.DB  0xC7,0xC3,0xCE,0xCD,0x3A,0x25,0x32,0x2E
	.DB  0x75,0x63,0x20,0x0,0x20,0xCF,0xCE,0xC2
	.DB  0xD2,0xCE,0xD0,0xCD,0xDB,0xC9,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0xC7,0xC0,0xCF,0xD3
	.DB  0xD1,0xCA,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0xD0,0xC0,0xC1,0xCE,0xD2,0xC0,0x20,0x20
	.DB  0x20,0x0,0x20,0xD1,0xC5,0xD2,0xDC,0x20
	.DB  0xCD,0xCE,0xD0,0xCC,0xC0,0x20,0x0,0x20
	.DB  0x20,0xCE,0xD1,0xD2,0xC0,0xCD,0xCE,0xC2
	.DB  0x20,0x20,0x0,0x20,0xCE,0xD5,0xCB,0xC0
	.DB  0xC6,0xC4,0xC5,0xCD,0xC8,0xC5,0x20,0x0
	.DB  0x28,0x21,0x29,0x20,0xCE,0xD8,0xC8,0xC1
	.DB  0xCA,0xC0,0x20,0x0,0x20,0xCD,0xC5,0x20
	.DB  0xC7,0xC0,0xCF,0xD3,0xD1,0xCA,0x20,0x0
	.DB  0x20,0x20,0xC4,0xCB,0xDF,0x20,0xD1,0xC1
	.DB  0xD0,0xCE,0xD1,0xC0,0x20,0x3E,0x27,0xC2
	.DB  0xC2,0xCE,0xC4,0x27,0x20,0x20,0x0,0x20
	.DB  0xCD,0xC5,0xD2,0x20,0xD2,0xCE,0xCA,0xC0
	.DB  0x20,0x20,0x0,0x28,0x21,0x29,0x20,0xC7
	.DB  0xC0,0xD9,0xC8,0xD2,0xC0,0x20,0x0,0x20
	.DB  0x55,0x69,0x6E,0x20,0x3D,0x25,0x34,0x2E
	.DB  0x75,0x42,0x0,0x21,0x55,0x69,0x6E,0x20
	.DB  0x3E,0x20,0x32,0x36,0x30,0xC2,0x21,0x0
	.DB  0x20,0x20,0xC2,0xDB,0xD1,0xCE,0xCA,0xCE
	.DB  0xC5,0x20,0xCD,0xC0,0xCF,0xD0,0xDF,0xC6
	.DB  0xC5,0xCD,0xC8,0xC5,0x20,0x21,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _PositionPointer_G000
	.DW  _0x25*2

	.DW  0x01
	.DW  _podsvet_G000
	.DW  _0x26*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : test2
;Version : 1
;Date    : 17.02.2019
;Author  : Kostya
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 1,000000 MHz (8 MHz)
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;static char buff[30];
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <i2c.h>
;#include <stdio.h>
;#include "ssd1306.c"
;/*
;Библиотека для светодиодного
;OLED LCD SSD1306 дисплея.
;Библиотека сделана под CVAVR.
;22.12.2015 Виниченко А.В.
;*/
;
;#include <delay.h>
;
;void LCD_init(void);  //начальная инициализация дисплея
;void LCD_Commmand(unsigned char ControByte, unsigned char DataByte); //команды дисплею или данные
;void LCD_Goto(unsigned char x, unsigned char y);    //установить координаты
;void LCD_Clear(void);  //очистка всего дисплея
;//void LCD_Contrast(char set_contrast); //настройка контраста от 0 до 255
;void LCD_Blinc(unsigned int t,unsigned char x);  //t секунд ,  x раз
;void LCD_CharVeryBig(unsigned int c,unsigned char h); //
;void LCD_Printf(unsigned char* buf, unsigned char size); //печатает строку с размерами - 0 самый мелкий 2 - увеличиный - ...
;void LCD_Mode(char set_mode); //1 - inverted / 0 - normal
;void LCD_Sleep(char set);   //1 - on sleep / 0 - off sleep
;void ShowLine(unsigned char line);
;void ShowBigLine(unsigned char line);
;
;
;unsigned char LCD_X,LCD_Y;
;
;#define SSD1306_I2C_ADDRESS					 0x78
;// size
;#define SSD1306_LCDWIDTH                      125
;#define SSD1306_LCDHEIGHT                     64
;#define SSD1306_DEFAULT_SPACE                 5
;// Commands
;#define SSD1306_SETCONTRAST                  0x81
;#define SSD1306_DISPLAYALLON_RESUME          0xA4
;#define SSD1306_DISPLAYALLON                 0xA5
;#define SSD1306_NORMALDISPLAY                0xA6
;#define SSD1306_INVERTDISPLAY                0xA7
;#define SSD1306_DISPLAYOFF                   0xAE
;#define SSD1306_DISPLAYON                    0xAF
;#define SSD1306_SETDISPLAYOFFSET             0xD3
;#define SSD1306_SETCOMPINS                   0xDA
;#define SSD1306_SETVCOMDETECT                0xDB
;#define SSD1306_SETDISPLAYCLOCKDIV           0xD5
;#define SSD1306_SETPRECHARGE                 0xD9
;#define SSD1306_SETMULTIPLEX                 0xA8
;#define SSD1306_SETLOWCOLUMN                 0x00
;#define SSD1306_SETHIGHCOLUMN                0x10
;#define SSD1306_SETSTARTLINE                 0x40
;#define SSD1306_MEMORYMODE                   0x20
;#define SSD1306_COLUMNADDR                   0x21
;#define SSD1306_PAGEADDR                     0x22
;#define SSD1306_COMSCANINC                   0xC0
;#define SSD1306_COMSCANDEC                   0xC8
;#define SSD1306_SEGREMAP                     0xA0
;#define SSD1306_CHARGEPUMP                   0x8D
;#define SSD1306_EXTERNALVCC                   0x1
;#define SSD1306_SWITCHCAPVCC                  0x2
;// Scrolling #defines
;#define SSD1306_ACTIVATE_SCROLL               0x2F
;#define SSD1306_DEACTIVATE_SCROLL             0x2E
;#define SSD1306_SET_VERTICAL_SCROLL_AREA      0xA3
;#define SSD1306_RIGHT_HORIZONTAL_SCROLL       0x26
;#define SSD1306_LEFT_HORIZONTAL_SCROLL        0x27
;#define SSD1306_VERT_AND_RIGHT_HORIZ_SCROLL   0x29
;#define SSD1306_VERT_AND_LEFT_HORIZ_SCROLL    0x2A
;
;#define COMAND		                          0x00
;#define DATA		                          0x40
;
;flash unsigned char LCD_Buffer[0x0460] =      //0x0500
;{
;0x00, 0x00, 0x00, 0x00, 0x00,// 00 space
;0x00, 0x00, 0x5F, 0x00, 0x00,// 01 !
;0x00, 0x07, 0x00, 0x07, 0x00,// 02 "
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 03
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 04
;0x23, 0x13, 0x08, 0x64, 0x62,// 05
;0x36, 0x49, 0x55, 0x22, 0x50,// 06
;0x00, 0x05, 0x03, 0x00, 0x00,// 07
;0x00, 0x1C, 0x22, 0x41, 0x00,// 08
;0x00, 0x41, 0x22, 0x1C, 0x00,// 09
;0x14, 0x08, 0x3E, 0x08, 0x14,// 0A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 0B
;0x00, 0x50, 0x30, 0x00, 0x00,// 0C
;0x08, 0x08, 0x08, 0x08, 0x08,// 0D
;0x00, 0x60, 0x60, 0x00, 0x00,// 0E
;0x20, 0x10, 0x08, 0x04, 0x02,// 0F
;0x00, 0x00, 0x00, 0x00, 0x00,// 10
;0x00, 0x00, 0x5F, 0x00, 0x00,// 11
;0x00, 0x07, 0x00, 0x07, 0x00,// 12
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 13
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 14
;0x23, 0x13, 0x08, 0x64, 0x62,// 15
;0x36, 0x49, 0x55, 0x22, 0x50,// 16
;0x00, 0x05, 0x03, 0x00, 0x00,// 17
;0x00, 0x1C, 0x22, 0x41, 0x00,// 18
;0x00, 0x41, 0x22, 0x1C, 0x00,// 19
;0x14, 0x08, 0x3E, 0x08, 0x14,// 1A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 1B
;0x00, 0x50, 0x30, 0x00, 0x00,// 1C
;0x08, 0x08, 0x08, 0x08, 0x08,// 1D
;0x00, 0x60, 0x60, 0x00, 0x00,// 1E
;0x20, 0x10, 0x08, 0x04, 0x02,// 1F
;0x00, 0x00, 0x00, 0x00, 0x00,// 20 space
;0x00, 0x00, 0x5F, 0x00, 0x00,// 21 !
;0x00, 0x07, 0x00, 0x07, 0x00,// 22 "
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 23 #
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 24 $
;0x23, 0x13, 0x08, 0x64, 0x62,// 25 %
;0x36, 0x49, 0x55, 0x22, 0x50,// 26 &
;0x00, 0x05, 0x03, 0x00, 0x00,// 27 '
;0x00, 0x1C, 0x22, 0x41, 0x00,// 28 (
;0x00, 0x41, 0x22, 0x1C, 0x00,// 29 )
;0x14, 0x08, 0x3E, 0x08, 0x14,// 2a *
;0x08, 0x08, 0x3E, 0x08, 0x08,// 2b +
;0x00, 0x50, 0x30, 0x00, 0x00,// 2c ,
;0x08, 0x08, 0x08, 0x08, 0x08,// 2d -
;0x00, 0x60, 0x60, 0x00, 0x00,// 2e .
;0x20, 0x10, 0x08, 0x04, 0x02,// 2f /
;0x3E, 0x51, 0x49, 0x45, 0x3E,// 30 0
;0x00, 0x42, 0x7F, 0x40, 0x00,// 31 1
;0x42, 0x61, 0x51, 0x49, 0x46,// 32 2
;0x21, 0x41, 0x45, 0x4B, 0x31,// 33 3
;0x18, 0x14, 0x12, 0x7F, 0x10,// 34 4
;0x27, 0x45, 0x45, 0x45, 0x39,// 35 5
;0x3C, 0x4A, 0x49, 0x49, 0x30,// 36 6
;0x01, 0x71, 0x09, 0x05, 0x03,// 37 7
;0x36, 0x49, 0x49, 0x49, 0x36,// 38 8
;0x06, 0x49, 0x49, 0x29, 0x1E,// 39 9
;0x00, 0x36, 0x36, 0x00, 0x00,// 3a :
;0x00, 0x56, 0x36, 0x00, 0x00,// 3b ;
;0x08, 0x14, 0x22, 0x41, 0x00,// 3c <
;0x14, 0x14, 0x14, 0x14, 0x14,// 3d =
;0x00, 0x41, 0x22, 0x14, 0x08,// 3e >
;0x02, 0x01, 0x51, 0x09, 0x06,// 3f ?
;0x32, 0x49, 0x79, 0x41, 0x3E,// 40 @
;0x7E, 0x11, 0x11, 0x11, 0x7E,// 41 A
;0x7F, 0x49, 0x49, 0x49, 0x36,// 42 B
;0x3E, 0x41, 0x41, 0x41, 0x22,// 43 C
;0x7F, 0x41, 0x41, 0x22, 0x1C,// 44 D
;0x7F, 0x49, 0x49, 0x49, 0x41,// 45 E
;0x7F, 0x09, 0x09, 0x09, 0x01,// 46 F
;0x3E, 0x41, 0x49, 0x49, 0x7A,// 47 G
;0x7F, 0x08, 0x08, 0x08, 0x7F,// 48 H
;0x00, 0x41, 0x7F, 0x41, 0x00,// 49 I
;0x20, 0x40, 0x41, 0x3F, 0x01,// 4a J
;0x7F, 0x08, 0x14, 0x22, 0x41,// 4b K
;0x7F, 0x40, 0x40, 0x40, 0x40,// 4c L
;0x7F, 0x02, 0x0C, 0x02, 0x7F,// 4d M
;0x7F, 0x04, 0x08, 0x10, 0x7F,// 4e N
;0x3E, 0x41, 0x41, 0x41, 0x3E,// 4f O
;0x7F, 0x09, 0x09, 0x09, 0x06,// 50 P
;0x3E, 0x41, 0x51, 0x21, 0x5E,// 51 Q
;0x7F, 0x09, 0x19, 0x29, 0x46,// 52 R
;0x46, 0x49, 0x49, 0x49, 0x31,// 53 S
;0x01, 0x01, 0x7F, 0x01, 0x01,// 54 T
;0x3F, 0x40, 0x40, 0x40, 0x3F,// 55 U
;0x1F, 0x20, 0x40, 0x20, 0x1F,// 56 V
;0x3F, 0x40, 0x38, 0x40, 0x3F,// 57 W
;0x63, 0x14, 0x08, 0x14, 0x63,// 58 X
;0x07, 0x08, 0x70, 0x08, 0x07,// 59 Y
;0x61, 0x51, 0x49, 0x45, 0x43,// 5a Z
;0x00, 0x7F, 0x41, 0x41, 0x00,// 5b [
;0x02, 0x04, 0x08, 0x10, 0x20,// 5c Yen Currency Sign
;0x00, 0x41, 0x41, 0x7F, 0x00,// 5d ]
;0x04, 0x02, 0x01, 0x02, 0x04,// 5e ^
;0x40, 0x40, 0x40, 0x40, 0x40,// 5f _
;0x00, 0x01, 0x02, 0x04, 0x00,// 60 `
;0x20, 0x54, 0x54, 0x54, 0x78,// 61 a
;0x7F, 0x48, 0x44, 0x44, 0x38,// 62 b
;0x38, 0x44, 0x44, 0x44, 0x20,// 63 c
;0x38, 0x44, 0x44, 0x48, 0x7F,// 64 d
;0x38, 0x54, 0x54, 0x54, 0x18,// 65 e
;0x08, 0x7E, 0x09, 0x01, 0x02,// 66 f
;0x0C, 0x52, 0x52, 0x52, 0x3E,// 67 g
;0x7F, 0x08, 0x04, 0x04, 0x78,// 68 h
;0x00, 0x44, 0x7D, 0x40, 0x00,// 69 i
;0x20, 0x40, 0x44, 0x3D, 0x00,// 6a j
;0x7F, 0x10, 0x28, 0x44, 0x00,// 6b k
;0x00, 0x41, 0x7F, 0x40, 0x00,// 6c l
;0x7C, 0x04, 0x18, 0x04, 0x78,// 6d m
;0x7C, 0x08, 0x04, 0x04, 0x78,// 6e n
;0x38, 0x44, 0x44, 0x44, 0x38,// 6f o
;0x7C, 0x14, 0x14, 0x14, 0x08,// 70 p
;0x08, 0x14, 0x14, 0x18, 0x7C,// 71 q
;0x7C, 0x08, 0x04, 0x04, 0x08,// 72 r
;0x08, 0x54, 0x54, 0x54, 0x20,// 73 s
;0x04, 0x3F, 0x44, 0x40, 0x20,// 74 t
;0x3C, 0x40, 0x40, 0x20, 0x7C,// 75 u
;0x1C, 0x20, 0x40, 0x20, 0x1C,// 76 v
;0x3C, 0x40, 0x30, 0x40, 0x3C,// 77 w
;0x44, 0x28, 0x10, 0x28, 0x44,// 78 x
;0x0C, 0x50, 0x50, 0x50, 0x3C,// 79 y
;0x44, 0x64, 0x54, 0x4C, 0x44,// 7a z
;0x00, 0x08, 0x36, 0x41, 0x00,// 7b <
;0x00, 0x00, 0x7F, 0x00, 0x00,// 7c |
;0x00, 0x41, 0x36, 0x08, 0x00,// 7d >
;0x10, 0x08, 0x08, 0x10, 0x08,// 7e Right Arrow ->
;0x78, 0x46, 0x41, 0x46, 0x78,// 7f Left Arrow <-
;0x00, 0x00, 0x00, 0x00, 0x00,// 80
;0x00, 0x00, 0x5F, 0x00, 0x00,// 81
;0x00, 0x07, 0x00, 0x07, 0x00,// 82
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 83
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 84
;0x23, 0x13, 0x08, 0x64, 0x62,// 85
;0x36, 0x49, 0x55, 0x22, 0x50,// 86
;0x00, 0x05, 0x03, 0x00, 0x00,// 87
;0x00, 0x1C, 0x22, 0x41, 0x00,// 88
;0x00, 0x41, 0x22, 0x1C, 0x00,// 89
;0x14, 0x08, 0x3E, 0x08, 0x14,// 8A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 8B
;0x00, 0x50, 0x30, 0x00, 0x00,// 8C
;0x08, 0x08, 0x08, 0x08, 0x08,// 8D
;0x00, 0x60, 0x60, 0x00, 0x00,// 8E
;0x20, 0x10, 0x08, 0x04, 0x02,// 8F
;0x00, 0x00, 0x00, 0x00, 0x00,// 90
;0x00, 0x00, 0x5F, 0x00, 0x00,// 91
;0x00, 0x07, 0x00, 0x07, 0x00,// 92
;0x14, 0x7F, 0x14, 0x7F, 0x14,// 93
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// 94
;0x23, 0x13, 0x08, 0x64, 0x62,// 95
;0x36, 0x49, 0x55, 0x22, 0x50,// 96
;0x00, 0x05, 0x03, 0x00, 0x00,// 97
;0x00, 0x1C, 0x22, 0x41, 0x00,// 98
;0x00, 0x41, 0x22, 0x1C, 0x00,// 99
;0x14, 0x08, 0x3E, 0x08, 0x14,// 9A
;0x08, 0x08, 0x3E, 0x08, 0x08,// 9B
;0x00, 0x50, 0x30, 0x00, 0x00,// 9C
;0x08, 0x08, 0x08, 0x08, 0x08,// 9D
;0x00, 0x60, 0x60, 0x00, 0x00,// 9E
;0x20, 0x10, 0x08, 0x04, 0x02,// 9F
;0x00, 0x00, 0x00, 0x00, 0x00,// A0
;0x00, 0x00, 0x5F, 0x00, 0x00,// A1
;0x00, 0x07, 0x00, 0x07, 0x00,// A2
;0x14, 0x7F, 0x14, 0x7F, 0x14,// A3
;0x24, 0x2A, 0x7F, 0x2A, 0x12,// A4
;0x23, 0x13, 0x08, 0x64, 0x62,// A5
;0x36, 0x49, 0x55, 0x22, 0x50,// A6
;0x00, 0x05, 0x03, 0x00, 0x00,// A7
;0x00, 0x1C, 0x22, 0x41, 0x00,// A8
;0x00, 0x41, 0x22, 0x1C, 0x00,// A9
;0x14, 0x08, 0x3E, 0x08, 0x14,// AA
;0x08, 0x08, 0x3E, 0x08, 0x08,// AB
;0x00, 0x50, 0x30, 0x00, 0x00,// AC
;0x08, 0x08, 0x08, 0x08, 0x08,// AD
;0x00, 0x60, 0x60, 0x00, 0x00,// AE
;0x20, 0x10, 0x08, 0x04, 0x02,// AF
;//0x3E, 0x51, 0x49, 0x45, 0x3E,// B0
;0x00, 0x06, 0x09, 0x09, 0x06,
;0x00, 0x42, 0x7F, 0x40, 0x00,// B1
;0x42, 0x61, 0x51, 0x49, 0x46,// B2
;0x21, 0x41, 0x45, 0x4B, 0x31,// B3
;0x18, 0x14, 0x12, 0x7F, 0x10,// B4
;0x27, 0x45, 0x45, 0x45, 0x39,// B5
;0x3C, 0x4A, 0x49, 0x49, 0x30,// B6
;0x01, 0x71, 0x09, 0x05, 0x03,// B7
;0x36, 0x49, 0x49, 0x49, 0x36,// B8
;0x06, 0x49, 0x49, 0x29, 0x1E,// B9
;0x00, 0x36, 0x36, 0x00, 0x00,// BA
;0x00, 0x56, 0x36, 0x00, 0x00,// BB
;0x08, 0x14, 0x22, 0x41, 0x00,// BC
;0x14, 0x14, 0x14, 0x14, 0x14,// BD
;0x00, 0x41, 0x22, 0x14, 0x08,// BE
;0x02, 0x01, 0x51, 0x09, 0x06,// BF
;0x7E, 0x11, 0x11, 0x11, 0x7E,// C0 А
;0x7F, 0x49, 0x49, 0x49, 0x31,// C1 Б
;0x7F, 0x49, 0x49, 0x49, 0x36,// C2 В
;0x7F, 0x01, 0x01, 0x01, 0x03,// C3 Г
;0x60, 0x3E, 0x21, 0x21, 0x7F,// C4 Д
;0x7F, 0x49, 0x49, 0x49, 0x41,// C5 Е
;0x77, 0x08, 0x7F, 0x08, 0x77,// C6 Ж
;0x22, 0x41, 0x49, 0x49, 0x36,// C7 З
;0x7F, 0x10, 0x08, 0x04, 0x7F,// C8 И
;0x7F, 0x10, 0x09, 0x04, 0x7F,// C9 И
;0x7F, 0x08, 0x14, 0x22, 0x41,// CA К
;0x40, 0x3E, 0x01, 0x01, 0x7F,// CB Л
;0x7F, 0x02, 0x0C, 0x02, 0x7F,// CC М
;0x7F, 0x08, 0x08, 0x08, 0x7F,// CD Н
;0x3E, 0x41, 0x41, 0x41, 0x3E,// CE О
;0x7F, 0x01, 0x01, 0x01, 0x7F,// CF П
;0x7F, 0x09, 0x09, 0x09, 0x06,// D0 Р
;0x3E, 0x41, 0x41, 0x41, 0x22,// D1 С
;0x01, 0x01, 0x7F, 0x01, 0x01,// D2 Т
;0x27, 0x48, 0x48, 0x48, 0x3F,// D3 У
;0x1E, 0x21, 0x7F, 0x21, 0x1E,// D4 Ф
;0x63, 0x14, 0x08, 0x14, 0x63,// D5 Х
;0x3F, 0x20, 0x20, 0x3F, 0x60,// D6 Ц
;0x07, 0x08, 0x08, 0x08, 0x7F,// D7 Ч
;0x7F, 0x40, 0x7F, 0x40, 0x7F,// D8 Ш
;0x3F, 0x20, 0x3F, 0x20, 0x7F,// D9 Щ
;0x01, 0x7F, 0x48, 0x48, 0x30,// DA Ъ
;0x7F, 0x48, 0x30, 0x00, 0x7F,// DB Ы
;0x00, 0x7F, 0x48, 0x48, 0x30,// DC Ь
;0x22, 0x41, 0x49, 0x49, 0x3E,// DD Э
;0x7F, 0x08, 0x3E, 0x41, 0x3E,// DE Ю
;0x46, 0x29, 0x19, 0x09, 0x7F // DF Я
;};
;/*
;0x20, 0x54, 0x54, 0x54, 0x78,// E0 а
;0x3C, 0x4A, 0x4A, 0x4A, 0x30,// E1 б
;0x7C, 0x54, 0x54, 0x28, 0x00,// E2 в
;0x7C, 0x04, 0x04, 0x04, 0x04,// E3 г
;0x60, 0x38, 0x24, 0x24, 0x7C,// E4 д
;0x38, 0x54, 0x54, 0x54, 0x18,// E5 е
;0x6C, 0x10, 0x7C, 0x10, 0x6C,// E6 ж
;0x00, 0x44, 0x54, 0x54, 0x28,// E7 з
;0x7C, 0x20, 0x10, 0x08, 0x7C,// E8 и
;0x7C, 0x21, 0x12, 0x09, 0x7C,// E9 й
;0x7C, 0x10, 0x28, 0x44, 0x00,// EA к
;0x40, 0x38, 0x04, 0x04, 0x7C,// EB л
;0x7C, 0x08, 0x10, 0x08, 0x7C,// EC м
;0x7C, 0x10, 0x10, 0x10, 0x7C,// ED н
;0x38, 0x44, 0x44, 0x44, 0x38,// EE о
;0x7C, 0x04, 0x04, 0x04, 0x7C,// EF п
;0x7C, 0x14, 0x14, 0x14, 0x08,// F0 р
;0x38, 0x44, 0x44, 0x44, 0x00,// F1 с
;0x04, 0x04, 0x7C, 0x04, 0x04,// F2 т
;0x0C, 0x50, 0x50, 0x50, 0x3C,// F3 у
;0x08, 0x14, 0x7C, 0x14, 0x08,// F4 ф
;0x44, 0x28, 0x10, 0x28, 0x44,// F5 х
;0x3C, 0x20, 0x20, 0x3C, 0x60,// F6 ц
;0x0C, 0x10, 0x10, 0x10, 0x7C,// F7 ч
;0x7C, 0x40, 0x7C, 0x40, 0x7C,// F8 ш
;0x3C, 0x20, 0x3C, 0x20, 0x7C,// F9 щ
;0x04, 0x7C, 0x50, 0x50, 0x20,// FA ъ
;0x7C, 0x50, 0x20, 0x00, 0x7C,// FB ы
;0x00, 0x7C, 0x50, 0x50, 0x20,// FC ь
;0x28, 0x44, 0x54, 0x54, 0x38,// FD э
;0x7C, 0x10, 0x38, 0x44, 0x38,// FE ю
;0x48, 0x54, 0x34, 0x14, 0x7C // FF я
;}; */
;
;void LCD_init(void)
; 0000 001C {

	.CSEG
_LCD_init:
; .FSTART _LCD_init
;  #asm("cli")
	cli
;  LCD_Sleep(0);
	LDI  R26,LOW(0)
	RCALL _LCD_Sleep
;  delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
;  LCD_Commmand(COMAND, SSD1306_SETDISPLAYCLOCKDIV);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(213)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x80);
	LDI  R26,LOW(128)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SETMULTIPLEX);
	LDI  R26,LOW(168)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x3F);
	LDI  R26,LOW(63)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SETDISPLAYOFFSET);
	LDI  R26,LOW(211)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x00);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SETSTARTLINE | 0x00);
	LDI  R26,LOW(64)
	RCALL SUBOPT_0x1
;    // We use internal charge pump
;  LCD_Commmand(COMAND, SSD1306_CHARGEPUMP);
	LDI  R26,LOW(141)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x14);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x1
;    // Horizontal memory mode
;  LCD_Commmand(COMAND, SSD1306_MEMORYMODE);
	LDI  R26,LOW(32)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x00);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SEGREMAP | 0x1);
	LDI  R26,LOW(161)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_COMSCANDEC);
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SETCOMPINS);
	LDI  R26,LOW(218)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x12);
	LDI  R26,LOW(18)
	RCALL SUBOPT_0x1
;    // Max contrast
;  LCD_Commmand(COMAND, SSD1306_SETCONTRAST);
	LDI  R26,LOW(129)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0xCF);
	LDI  R26,LOW(207)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SETPRECHARGE);
	LDI  R26,LOW(217)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0xF1);
	LDI  R26,LOW(241)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_SETVCOMDETECT);
	LDI  R26,LOW(219)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, 0x40);
	LDI  R26,LOW(64)
	RCALL SUBOPT_0x1
;  LCD_Commmand(COMAND, SSD1306_DISPLAYALLON_RESUME);
	LDI  R26,LOW(164)
	RCALL _LCD_Commmand
;    // Non-inverted display
;  LCD_Mode(0);
	LDI  R26,LOW(0)
	RCALL _LCD_Mode
;    // Turn display back on
;  LCD_Sleep(1);
	LDI  R26,LOW(1)
	RCALL _LCD_Sleep
;
;  LCD_Clear();
	RCALL _LCD_Clear
;  LCD_Goto(0,0);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	RCALL _LCD_Goto
;  #asm("sei")
	sei
;}
	RET
; .FEND
;
;/*
;void LCD_Contrast(char set_contrast)
;{
;  LCD_Commmand(COMAND, SSD1306_DISPLAYOFF);
;  delay_ms(10);
;  LCD_Commmand(COMAND, SSD1306_SETCONTRAST);
;  LCD_Commmand(COMAND, set_contrast);
;  LCD_Commmand(COMAND, SSD1306_DISPLAYON);
;}
;*/
;void LCD_Mode(char set_mode)
;{
_LCD_Mode:
; .FSTART _LCD_Mode
; if(set_mode==0){ LCD_Commmand(COMAND, SSD1306_NORMALDISPLAY); }
	ST   -Y,R26
;	set_mode -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	RCALL SUBOPT_0x0
	LDI  R26,LOW(166)
	RCALL _LCD_Commmand
; if(set_mode==1){ LCD_Commmand(COMAND, SSD1306_INVERTDISPLAY); }
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x4
	RCALL SUBOPT_0x0
	LDI  R26,LOW(167)
	RCALL _LCD_Commmand
;}
_0x4:
	RJMP _0x2060002
; .FEND
;
;void LCD_Sleep(char set)
;{
_LCD_Sleep:
; .FSTART _LCD_Sleep
;  if(set==0){LCD_Commmand(COMAND,SSD1306_DISPLAYOFF);}
	ST   -Y,R26
;	set -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x5
	RCALL SUBOPT_0x0
	LDI  R26,LOW(174)
	RCALL _LCD_Commmand
;  if(set==1){LCD_Commmand(COMAND,SSD1306_DISPLAYON);}
_0x5:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x6
	RCALL SUBOPT_0x0
	LDI  R26,LOW(175)
	RCALL _LCD_Commmand
;}
_0x6:
	RJMP _0x2060002
; .FEND
;
;void LCD_Commmand(unsigned char ControByte, unsigned char DataByte)
;{
_LCD_Commmand:
; .FSTART _LCD_Commmand
;  #asm("cli")
	ST   -Y,R26
;	ControByte -> Y+1
;	DataByte -> Y+0
	cli
;  i2c_start();
	RCALL _i2c_start
;  i2c_write(SSD1306_I2C_ADDRESS);
	LDI  R26,LOW(120)
	RCALL _i2c_write
;  i2c_write(ControByte);
	LDD  R26,Y+1
	RCALL _i2c_write
;  i2c_write(DataByte);
	LD   R26,Y
	RCALL _i2c_write
;  i2c_stop();
	RCALL _i2c_stop
;  #asm("sei")
	sei
	RJMP _0x2060003
;}
; .FEND
;
;void LCD_Goto(unsigned char x, unsigned char y)
;{
_LCD_Goto:
; .FSTART _LCD_Goto
;  #asm("cli")
	ST   -Y,R26
;	x -> Y+1
;	y -> Y+0
	cli
;	LCD_X = x;
	LDD  R5,Y+1
;	LCD_Y = y;
	LDD  R4,Y+0
;
;	// установка  и настройка
;	LCD_Commmand(COMAND, 0xB0 + y);//установить адрес начала координат
	RCALL SUBOPT_0x0
	LDD  R26,Y+1
	SUBI R26,-LOW(176)
	RCALL SUBOPT_0x1
;	LCD_Commmand(COMAND, x & 0xf);//установить нижний адрес столбца
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	RCALL SUBOPT_0x1
;	LCD_Commmand(COMAND,0x10 | (x >> 4));//установить верхний адрес столбца
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF
	ORI  R30,0x10
	MOV  R26,R30
	RCALL _LCD_Commmand
;  #asm("sei")
	sei
_0x2060003:
;}
	ADIW R28,2
	RET
; .FEND
;
;void LCD_Clear(void)
;{
_LCD_Clear:
; .FSTART _LCD_Clear
;	unsigned short i;
;	unsigned short x=0;
;	unsigned short y=0;
;    #asm("cli")
	RCALL __SAVELOCR6
;	i -> R16,R17
;	x -> R18,R19
;	y -> R20,R21
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	cli
;	LCD_Goto(0,0);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	RCALL _LCD_Goto
;
;	for (i=0; i<(SSD1306_LCDWIDTH*SSD1306_LCDHEIGHT/8); i++) //(SSD1306_LCDWIDTH*SSD1306_LCDHEIGHT/8)
	__GETWRN 16,17,0
_0x8:
	__CPWRN 16,17,1000
	BRSH _0x9
;	{
;		LCD_CharVeryBig(' ',0);
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(0)
	RCALL _LCD_CharVeryBig
;		x ++;
	__ADDWRN 18,19,1
;		if(x>SSD1306_LCDWIDTH)
	__CPWRN 18,19,126
	BRLO _0xA
;		{
;			x =0;
	__GETWRN 18,19,0
;			y++;
	__ADDWRN 20,21,1
;			LCD_Goto(0,y);
	RCALL SUBOPT_0x0
	MOV  R26,R20
	RCALL _LCD_Goto
;		}
;	}
_0xA:
	__ADDWRN 16,17,1
	RJMP _0x8
_0x9:
;	LCD_X =SSD1306_DEFAULT_SPACE;
	LDI  R30,LOW(5)
	MOV  R5,R30
;	LCD_Y =0;
	CLR  R4
;    #asm("sei");
	sei
;}
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;void LCD_Blinc(unsigned int t,unsigned char x )
;{
_LCD_Blinc:
; .FSTART _LCD_Blinc
;  unsigned char xx = 0;
;   for (xx=0; xx<x; xx++)
	ST   -Y,R26
	ST   -Y,R17
;	t -> Y+2
;	x -> Y+1
;	xx -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0xC:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0xD
;	{
;       LCD_Mode(1);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x3
;       delay_ms(t);
;       LCD_Mode(0);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x3
;       delay_ms(t);
;    }
	SUBI R17,-1
	RJMP _0xC
_0xD:
;}
	LDD  R17,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void LCD_CharVeryBig(unsigned int c,unsigned char h)
;{
_LCD_CharVeryBig:
; .FSTART _LCD_CharVeryBig
;  unsigned char x  = 0;
;  unsigned int  m  = 0;
;  unsigned char cl = 0;
;  #asm("cli")
	ST   -Y,R26
	RCALL __SAVELOCR4
;	c -> Y+5
;	h -> Y+4
;	x -> R17
;	m -> R18,R19
;	cl -> R16
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R16,0
	cli
;  i2c_start();
	RCALL _i2c_start
;  i2c_write(SSD1306_I2C_ADDRESS);
	LDI  R26,LOW(120)
	RCALL _i2c_write
;  i2c_write(DATA);//data mode
	LDI  R26,LOW(64)
	RCALL _i2c_write
;  for (x=0; x<5; x++)
	LDI  R17,LOW(0)
_0xF:
	CPI  R17,5
	BRLO PC+2
	RJMP _0x10
;	{
;    //0x27, 0x48, 0x48, 0x48, 0x3F,// D3 У
;
;         m = LCD_Buffer[c*5+x];
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	LDI  R30,LOW(5)
	RCALL __MULB1W2U
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_LCD_Buffer*2)
	SBCI R31,HIGH(-_LCD_Buffer*2)
	LPM  R18,Z
	CLR  R19
;         cl=m;
	MOV  R16,R18
;         if(h==1)
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BREQ _0x110
;         {
;         i2c_write(cl);
;         }
;         else
;         if(h==2)
	CPI  R26,LOW(0x2)
	BRNE _0x13
;         {
;             cl = 0;
	LDI  R16,LOW(0)
;             if (0b00000001 == (m & 0b00000001)) { cl =cl+0b00000011;};
	MOVW R30,R18
	ANDI R30,LOW(0x1)
	CPI  R30,LOW(0x1)
	BRNE _0x14
	SUBI R16,-LOW(3)
_0x14:
;             if (0b00000010 == (m & 0b00000010)) { cl =cl+0b00001100;};
	MOVW R30,R18
	ANDI R30,LOW(0x2)
	CPI  R30,LOW(0x2)
	BRNE _0x15
	SUBI R16,-LOW(12)
_0x15:
;             if (0b00000100 == (m & 0b00000100)) { cl =cl+0b00110000;};
	MOVW R30,R18
	ANDI R30,LOW(0x4)
	CPI  R30,LOW(0x4)
	BRNE _0x16
	SUBI R16,-LOW(48)
_0x16:
;             if (0b00001000 == (m & 0b00001000)) { cl =cl+0b11000000;};
	MOVW R30,R18
	ANDI R30,LOW(0x8)
	CPI  R30,LOW(0x8)
	BRNE _0x17
	SUBI R16,-LOW(192)
_0x17:
;         i2c_write(cl);
	RJMP _0x110
;         }
;         else if(h==3)
_0x13:
	LDD  R26,Y+4
	CPI  R26,LOW(0x3)
	BRNE _0x19
;         {
;             cl = 0;
	LDI  R16,LOW(0)
;             if (0b00010000 == (m & 0b00010000)) { cl =cl+0b00000011;};
	MOVW R30,R18
	ANDI R30,LOW(0x10)
	CPI  R30,LOW(0x10)
	BRNE _0x1A
	SUBI R16,-LOW(3)
_0x1A:
;             if (0b00100000 == (m & 0b00100000)) { cl =cl+0b00001100;};
	MOVW R30,R18
	ANDI R30,LOW(0x20)
	CPI  R30,LOW(0x20)
	BRNE _0x1B
	SUBI R16,-LOW(12)
_0x1B:
;             if (0b01000000 == (m & 0b01000000)) { cl =cl+0b00110000;};
	MOVW R30,R18
	ANDI R30,LOW(0x40)
	CPI  R30,LOW(0x40)
	BRNE _0x1C
	SUBI R16,-LOW(48)
_0x1C:
;             if (0b10000000 == (m & 0b10000000)) { cl =cl+0b11000000;};
	MOVW R30,R18
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x1D
	SUBI R16,-LOW(192)
_0x1D:
;         i2c_write(cl);
_0x110:
	MOV  R26,R16
	RCALL _i2c_write
;         }
;         i2c_write(cl);
_0x19:
	MOV  R26,R16
	RCALL _i2c_write
;    }
	SUBI R17,-1
	RJMP _0xF
_0x10:
;
;    i2c_write(0x00);  //пробеол в 1 точку между символами
	LDI  R26,LOW(0)
	RCALL _i2c_write
;//    i2c_write(0x00);  //пробеол в 1 точку между символами
;    i2c_stop();    // stop transmitting
	RCALL _i2c_stop
;	if(h==0){
	LDD  R30,Y+4
	CPI  R30,0
	BRNE _0x1E
;        LCD_X += 6;
	LDI  R30,LOW(6)
	RJMP _0x111
;    }
; 	else{
_0x1E:
;        LCD_X += 12;
	LDI  R30,LOW(12)
_0x111:
	ADD  R5,R30
;    }
;  #asm("sei")
	sei
;}
	RCALL __LOADLOCR4
	ADIW R28,7
	RET
; .FEND
;
;void LCD_Printf(unsigned char* buf, unsigned char size) //выводим строку из буфера
;{
_LCD_Printf:
; .FSTART _LCD_Printf
;
;        while ((*buf!=0)&&(LCD_X<SSD1306_LCDWIDTH))
	ST   -Y,R26
;	*buf -> Y+1
;	size -> Y+0
_0x20:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R26,X
	CPI  R26,LOW(0x0)
	BREQ _0x23
	LDI  R30,LOW(125)
	CP   R5,R30
	BRLO _0x24
_0x23:
	RJMP _0x22
_0x24:
;        {
;           // if((LCD_X>SSD1306_LCDWIDTH)||(LCD_X<5)){LCD_X=SSD1306_DEFAULT_SPACE;}
;            LCD_CharVeryBig(*buf++,size);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	LDI  R31,0
	RCALL SUBOPT_0x2
	LDD  R26,Y+2
	RCALL _LCD_CharVeryBig
;        }
	RJMP _0x20
_0x22:
;
;}
	ADIW R28,3
	RET
; .FEND
;
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void ShowLine(unsigned char line)
;{
_ShowLine:
; .FSTART _ShowLine
;    LCD_Goto(0,line);
	ST   -Y,R26
;	line -> Y+0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
;    LCD_Printf(buff,0);  //  вывод на дисплей
	LDI  R26,LOW(0)
	RCALL _LCD_Printf
;}
	RJMP _0x2060002
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void ShowBigLine(unsigned char line)
;{
_ShowBigLine:
; .FSTART _ShowBigLine
;    LCD_Goto(0,line);
	ST   -Y,R26
;	line -> Y+0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x4
;    LCD_Printf(buff,2);  //  вывод на дисплей
	LDI  R26,LOW(2)
	RCALL _LCD_Printf
;    LCD_Goto(0,line+1);
	RCALL SUBOPT_0x0
	LDD  R26,Y+1
	SUBI R26,-LOW(1)
	RCALL SUBOPT_0x5
;    LCD_Printf(buff,3);  //  вывод на дисплей
	LDI  R26,LOW(3)
	RCALL _LCD_Printf
;}
	RJMP _0x2060002
; .FEND
;
;
;
;
;
;
;
;
;// Voltage Reference: Int., cap. on AREF
;#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;//#define PWR_LCD             PORTD.4
;#define STARTER_REL         PORTB.0
;
;#define GEN_REL             PORTD.2
;#define LINE_REL            PORTD.3
;#define ON_REL              PORTD.4
;#define OFF_REL             PORTD.5
;#define VALVE_U_REL         PORTD.6
;#define VALVE_D_REL         PORTD.7
;
;#define ROTOR_PIN           PINC.4
;#define GEN_OUT_PIN         PIND.0
;
;
;#define KEY_E               PINB.4
;#define KEY_U               PINB.3
;#define KEY_D               PINB.2
;#define KEY_SIG_NUM         10
;#define GO_TO_OPTIONS       20
;#define INFOLINE1           6
;#define INFOLINE2           7
;#define LAST_MODE_MENU      3
;#define FIRST_OPTION_MENU   10      //
;#define LAST_OPTION_MENU    16      //
;
;#define U1_MIN              140      //
;#define U1_MAX              265      //
;
;#define ONE_SECOND          4000    //
;#define HALF_SECOND         2000    //
;#define QUARTER_SECOND      1000    //
;#define NEXT_ZAPUSK_SECOND  20000   // 5c
;
;#define RAZGON              5       // 5c
;#define PODSVETKA           60
;
;// Global variables
;eeprom unsigned char Termo[256]=            // +50C
;{175,170,155,145,135,130,125,120,117,115,
; 112,110,107,105,104,102,100, 99, 98, 96,
;  95, 94, 93, 91, 90, 89, 88, 87, 86, 85,
;  84, 84, 83, 82, 82, 81, 80, 80, 79, 78,
;  78, 77, 77, 76, 76, 75, 75, 74, 74, 73,
;  72, 72, 71, 71, 70, 70, 69, 69, 68, 68,
;  68, 67, 67, 67, 66, 66, 65, 65, 65, 64,
;  64, 64, 63, 63, 63, 62, 62, 62, 61, 61,
;  61, 60, 60, 60, 60, 59, 59, 59, 58, 58,
;  58, 58, 57, 57, 57, 56, 56, 56, 55, 55,
;  55, 55, 55, 54, 54, 54, 54, 53, 53, 53,
;  53, 53, 52, 52, 52, 52, 51, 51, 51, 51,
;  50, 50, 50, 50, 49, 49, 49, 49, 49, 49,
;  48, 48, 48, 48, 48, 47, 47, 47, 47, 47,
;  47, 46, 46, 46, 46, 46, 45, 45, 45, 45,
;  45, 44, 44, 44, 44, 44, 44, 43, 43, 43,
;  43, 43, 43, 43, 42, 42, 42, 42, 42, 41,
;  41, 41, 41, 41, 41, 40, 40, 40, 40 ,40,
;  40, 39, 39, 39, 39, 39, 39, 39, 38, 38,
;  38, 38, 38, 38, 38, 37, 37, 37, 37, 37,
;  37, 37, 36, 36, 36, 36, 36, 35, 35, 35,
;  35, 35, 35, 35, 34, 34, 34, 34, 34, 34,
;  34, 33, 33, 33, 33, 33, 33, 33, 33, 32,
;  32, 32, 32, 32, 32, 32, 31, 31, 31, 31,
;  31, 31, 31, 30, 30, 30, 30, 30, 30, 30,
;  30, 29, 29, 29, 20, 20};
;//                                                                                                  В МЕНЮ!
;eeprom unsigned char typeEEP = 0;           // тип електростанціі                                       -
;eeprom unsigned char t1EEP   =10;           // час переходу на генератор                                -
;eeprom unsigned char t2EEP   =10;           // час переходу на мережу                                   -
;eeprom unsigned char t3EEP   = 6;           // час роботи стартера                                      -
;eeprom unsigned char t4EEP   = 8;           // час роботи із заслонкою                                  V
;eeprom unsigned char t5EEP   = 5;           // час без нагрузки  (прогрев в нормальном режиме)          V
;                                            // Охлаждение - в 2 раза больше чем прогрев бед нагрузки
;//eeprom unsigned char t6EEP =10;           // час охолодження
;
;eeprom unsigned char TminZEEP=20;           // Мінімальна температура прогріву генератора с заслонкой
;eeprom unsigned char TminNEEP=50;           // Мінімальна температура прогріву генератора               -
;eeprom unsigned char Z_EEP   = 0;           // zaslonka/klapan                                          V
;eeprom unsigned char R_EEP   = 0;           // Проверка сигнала "Вращение ротора"                       V
;eeprom unsigned char KilkistZapuskiv_EEP=3; // Количество попыток запуска                               V
;
;eeprom unsigned int  NarabotkaEEP=0;
;eeprom unsigned char TO_EEP=1;           //TO заноситься 1 якщо пора робити ТО, можно скинути із меню
;
;
;static unsigned char type,t1,t2,t3,t4,t5,TminZ,TminN,KilkistZapuskiv;//,Narabotka,;
;static unsigned char AvtRu=0;               //0-Auto; 1-Ru4noy
;static bit z=0;
;static bit r=0;
;//static bit rbit=0;
;static bit TO_output=0;
;
;static unsigned char up,down,enter;
;static unsigned char PositionPointer = 1;

	.DSEG
;static bit podmenu=0;
;
;static unsigned char podsvet=60; //sec
;static unsigned int  U_Bat=0;
;static unsigned int U1;
;static int T;
;
;static unsigned char rotor= 0;
;//static unsigned char average_ADC_counter=0;
;static unsigned int interrapt_counter=0;
;static unsigned char second_counter=0;
;static unsigned int  minut_counter=0;
;
;unsigned int  U_Bat_ADC=0;
;unsigned int  T_ADC=0;
;unsigned int  U1_ADC=0;
;
;static unsigned int temp;
;
;
;//char buff[30];  //буфер дисплея
;
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0097 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0098 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 0099 // Delay needed for the stabilization of the ADC input voltage
; 0000 009A delay_us(10);
	__DELAY_USB 7
; 0000 009B // Start the AD conversion
; 0000 009C ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 009D // Wait for the AD conversion to complete
; 0000 009E while ((ADCSRA & (1<<ADIF))==0);
_0x27:
	SBIS 0x6,4
	RJMP _0x27
; 0000 009F ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 00A0 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x2060002:
	ADIW R28,1
	RET
; 0000 00A1 }
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void UpDownEnterKey()       //перенести в прерівание!!!
; 0000 00A6 {
_UpDownEnterKey:
; .FSTART _UpDownEnterKey
; 0000 00A7  //Main menu
; 0000 00A8  if((PositionPointer>=1)&(PositionPointer<=LAST_MODE_MENU))
	RCALL SUBOPT_0x6
	LDI  R30,LOW(1)
	RCALL __GEB12U
	MOV  R0,R30
	RCALL SUBOPT_0x6
	LDI  R30,LOW(3)
	RCALL __LEB12U
	AND  R30,R0
	BREQ _0x2A
; 0000 00A9  {
; 0000 00AA     if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;};
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	BREQ _0x2B
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
_0x2B:
; 0000 00AB     if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;};
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xD
	BREQ _0x2C
	RCALL SUBOPT_0xE
_0x2C:
; 0000 00AC 
; 0000 00AD     if(PositionPointer>LAST_MODE_MENU){PositionPointer=LAST_MODE_MENU;} //limits of Main menu
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x4)
	BRLO _0x2D
	RCALL SUBOPT_0xF
; 0000 00AE     if(PositionPointer<1){PositionPointer=1;}
_0x2D:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x1)
	BRSH _0x2E
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x10
; 0000 00AF     // Go to Options menu
; 0000 00B0     if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_MODE_MENU)){PositionPointer=FIRST_OPTION_MENU;enter=2;LCD_Clear();Ki ...
_0x2E:
	RCALL SUBOPT_0x11
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x12
	BREQ _0x2F
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x13
	RCALL _LCD_Clear
	RCALL SUBOPT_0x14
_0x2F:
; 0000 00B1     if((enter>GO_TO_OPTIONS)&(PositionPointer==2)){PositionPointer=30;enter=2;KilkistZapuskiv=KilkistZapuskiv_EEP;}; //н ...
	RCALL SUBOPT_0x11
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x12
	BREQ _0x30
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
_0x30:
; 0000 00B2 
; 0000 00B3   }
; 0000 00B4   if((PositionPointer>=FIRST_OPTION_MENU)&(PositionPointer<=LAST_OPTION_MENU))
_0x2A:
	RCALL SUBOPT_0x6
	LDI  R30,LOW(10)
	RCALL __GEB12U
	MOV  R0,R30
	RCALL SUBOPT_0x6
	LDI  R30,LOW(16)
	RCALL __LEB12U
	AND  R30,R0
	BRNE PC+2
	RJMP _0x31
; 0000 00B5   {
; 0000 00B6         if(podmenu == 0)
	SBRC R2,3
	RJMP _0x32
; 0000 00B7         {
; 0000 00B8             if((up==1)|(up>KEY_SIG_NUM)){PositionPointer++;up=2;};
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x9
	BREQ _0x33
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
_0x33:
; 0000 00B9             if((down==1)|(down>KEY_SIG_NUM)){PositionPointer--;down=2;};
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0xD
	BREQ _0x34
	RCALL SUBOPT_0xE
_0x34:
; 0000 00BA         }
; 0000 00BB 
; 0000 00BC         if((enter==1)&(PositionPointer!=LAST_OPTION_MENU))
_0x32:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x6
	LDI  R30,LOW(16)
	RCALL __NEB12
	AND  R30,R0
	BREQ _0x35
; 0000 00BD             {
; 0000 00BE 
; 0000 00BF                 podmenu=!podmenu;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x18
; 0000 00C0                 enter=2;
	RCALL SUBOPT_0x19
; 0000 00C1                 if(podmenu==0){
	SBRC R2,3
	RJMP _0x36
; 0000 00C2                     #asm("cli")
	cli
; 0000 00C3                     typeEEP=type;
	LDS  R30,_type_G000
	LDI  R26,LOW(_typeEEP)
	LDI  R27,HIGH(_typeEEP)
	RCALL __EEPROMWRB
; 0000 00C4                     t1EEP=t1;
	LDS  R30,_t1_G000
	LDI  R26,LOW(_t1EEP)
	LDI  R27,HIGH(_t1EEP)
	RCALL __EEPROMWRB
; 0000 00C5                     t2EEP=t2;
	LDS  R30,_t2_G000
	LDI  R26,LOW(_t2EEP)
	LDI  R27,HIGH(_t2EEP)
	RCALL __EEPROMWRB
; 0000 00C6                     t3EEP=t3;
	LDS  R30,_t3_G000
	LDI  R26,LOW(_t3EEP)
	LDI  R27,HIGH(_t3EEP)
	RCALL __EEPROMWRB
; 0000 00C7                     t4EEP=t4;
	RCALL SUBOPT_0x1A
	LDI  R26,LOW(_t4EEP)
	LDI  R27,HIGH(_t4EEP)
	RCALL __EEPROMWRB
; 0000 00C8                     t5EEP=t5;
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(_t5EEP)
	LDI  R27,HIGH(_t5EEP)
	RCALL __EEPROMWRB
; 0000 00C9                     TminZEEP=TminZ;
	RCALL SUBOPT_0x1C
	LDI  R26,LOW(_TminZEEP)
	LDI  R27,HIGH(_TminZEEP)
	RCALL __EEPROMWRB
; 0000 00CA                     TminNEEP=TminN;
	LDS  R30,_TminN_G000
	LDI  R26,LOW(_TminNEEP)
	LDI  R27,HIGH(_TminNEEP)
	RCALL __EEPROMWRB
; 0000 00CB                     KilkistZapuskiv_EEP=KilkistZapuskiv;
	RCALL SUBOPT_0x1D
	LDI  R26,LOW(_KilkistZapuskiv_EEP)
	LDI  R27,HIGH(_KilkistZapuskiv_EEP)
	RCALL __EEPROMWRB
; 0000 00CC                     Z_EEP=z;
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	LDI  R26,LOW(_Z_EEP)
	LDI  R27,HIGH(_Z_EEP)
	RCALL __EEPROMWRB
; 0000 00CD                     R_EEP=r;
	LDI  R30,0
	SBRC R2,1
	LDI  R30,1
	LDI  R26,LOW(_R_EEP)
	LDI  R27,HIGH(_R_EEP)
	RCALL __EEPROMWRB
; 0000 00CE                     #asm("sei");
	sei
; 0000 00CF                 }
; 0000 00D0             }
_0x36:
; 0000 00D1         if(PositionPointer>LAST_OPTION_MENU){PositionPointer=FIRST_OPTION_MENU;}  //limits of Options menu
_0x35:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x11)
	BRLO _0x37
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x10
; 0000 00D2         if(PositionPointer<FIRST_OPTION_MENU){PositionPointer=LAST_OPTION_MENU;}
_0x37:
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0xA)
	BRSH _0x38
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x10
; 0000 00D3 
; 0000 00D4         if((enter>GO_TO_OPTIONS)&(PositionPointer==LAST_OPTION_MENU)){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear() ...
_0x38:
	RCALL SUBOPT_0x11
	LDI  R30,LOW(16)
	RCALL SUBOPT_0x12
	BREQ _0x39
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x1E
; 0000 00D5   }
_0x39:
; 0000 00D6 }
_0x31:
	RET
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00DA {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00DB #asm("cli")
	cli
; 0000 00DC 
; 0000 00DD     if(rotor>8){STARTER_REL=0;}//ротор працює- стартер не потрібен відключаємо стартер v1.4)
	RCALL SUBOPT_0x1F
	CPI  R26,LOW(0x9)
	BRLO _0x3A
	CBI  0x18,0
; 0000 00DE     if(ROTOR_PIN==0){rotor=rotor+1;}else{rotor=rotor-1;};
_0x3A:
	SBIC 0x13,4
	RJMP _0x3D
	LDS  R30,_rotor_G000
	SUBI R30,-LOW(1)
	RJMP _0x112
_0x3D:
	LDS  R30,_rotor_G000
	SUBI R30,LOW(1)
_0x112:
	STS  _rotor_G000,R30
; 0000 00DF     if(rotor<1) rotor=1;
	RCALL SUBOPT_0x1F
	CPI  R26,LOW(0x1)
	BRSH _0x3F
	LDI  R30,LOW(1)
	STS  _rotor_G000,R30
; 0000 00E0     if(rotor>10) rotor=10;
_0x3F:
	RCALL SUBOPT_0x1F
	CPI  R26,LOW(0xB)
	BRLO _0x40
	LDI  R30,LOW(10)
	STS  _rotor_G000,R30
; 0000 00E1 
; 0000 00E2     if(KEY_U==0){up=up+1;podsvet=PODSVETKA;}      else  {up=0;};
_0x40:
	SBIC 0x16,3
	RJMP _0x41
	LDS  R30,_up_G000
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x21
	RJMP _0x42
_0x41:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x20
_0x42:
; 0000 00E3     if(KEY_D==0){down=down+1;podsvet=PODSVETKA;}  else  {down=0;};
	SBIC 0x16,2
	RJMP _0x43
	LDS  R30,_down_G000
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x21
	RJMP _0x44
_0x43:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x22
_0x44:
; 0000 00E4     if(KEY_E==0){enter=enter+1;podsvet=PODSVETKA;}else  {enter=0;};   //beep begin -DDRD.2=1;
	SBIC 0x16,4
	RJMP _0x45
	LDS  R30,_enter_G000
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x21
	RJMP _0x46
_0x45:
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x19
_0x46:
; 0000 00E5 
; 0000 00E6     if(up>99) up=99;
	RCALL SUBOPT_0x7
	CPI  R26,LOW(0x64)
	BRLO _0x47
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x20
; 0000 00E7     if(down>99) down=99;
_0x47:
	RCALL SUBOPT_0xC
	CPI  R26,LOW(0x64)
	BRLO _0x48
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x22
; 0000 00E8     if(enter>99) enter=99;
_0x48:
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0x64)
	BRLO _0x49
	LDI  R30,LOW(99)
	RCALL SUBOPT_0x19
; 0000 00E9     UpDownEnterKey();
_0x49:
	RCALL _UpDownEnterKey
; 0000 00EA /*
; 0000 00EB     U_Bat_ADC=read_adc(0);
; 0000 00EC     U1_ADC=read_adc(2);
; 0000 00ED     T_ADC=read_adc(1);
; 0000 00EE 
; 0000 00EF     T_ADC=T_ADC/4;
; 0000 00F0     T=Termo[T_ADC];
; 0000 00F1     T=T-50;
; 0000 00F2     U_Bat=(U_Bat_ADC*20)/102; //останній розряд- десяті !!!!при виводі ділити на 10
; 0000 00F3     U1=(U1_ADC*11)/41;//ціле без десятих
; 0000 00F4 */
; 0000 00F5     U_Bat_ADC=U_Bat_ADC+read_adc(1);
	LDI  R26,LOW(1)
	RCALL _read_adc
	__ADDWRR 6,7,30,31
; 0000 00F6     U_Bat_ADC=U_Bat_ADC>>1;
	LSR  R7
	ROR  R6
; 0000 00F7     U1_ADC=U1_ADC+read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	__ADDWRR 10,11,30,31
; 0000 00F8     U1_ADC=U1_ADC>>1;
	LSR  R11
	ROR  R10
; 0000 00F9 
; 0000 00FA     T_ADC=T_ADC+read_adc(5);
	LDI  R26,LOW(5)
	RCALL _read_adc
	__ADDWRR 8,9,30,31
; 0000 00FB     T_ADC=T_ADC>>1;
	LSR  R9
	ROR  R8
; 0000 00FC 
; 0000 00FD 
; 0000 00FE     if(interrapt_counter>=31) //61~2sec -   8 mHz
	LDS  R26,_interrapt_counter_G000
	LDS  R27,_interrapt_counter_G000+1
	SBIW R26,31
	BRSH PC+2
	RJMP _0x4A
; 0000 00FF     {
; 0000 0100         U_Bat=U_Bat_ADC/5; //останній розряд- десяті !!!!при виводі ділити на 10
	MOVW R26,R6
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL __DIVW21U
	STS  _U_Bat_G000,R30
	STS  _U_Bat_G000+1,R31
; 0000 0101         U1=(U1_ADC*11)/41;//ціле без десятих
	MOVW R30,R10
	LDI  R26,LOW(11)
	LDI  R27,HIGH(11)
	RCALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	RCALL __DIVW21U
	RCALL SUBOPT_0x23
; 0000 0102         T=Termo[T_ADC>>2]; // divide 4
	MOVW R30,R8
	RCALL __LSRW2
	SUBI R30,LOW(-_Termo)
	SBCI R31,HIGH(-_Termo)
	MOVW R26,R30
	RCALL __EEPROMRDB
	LDI  R31,0
	RCALL SUBOPT_0x24
; 0000 0103         T=T-50;
	RCALL SUBOPT_0x25
	SBIW R30,50
	RCALL SUBOPT_0x24
; 0000 0104 
; 0000 0105         interrapt_counter=0;
	LDI  R30,LOW(0)
	STS  _interrapt_counter_G000,R30
	STS  _interrapt_counter_G000+1,R30
; 0000 0106         second_counter++;
	LDS  R30,_second_counter_G000
	SUBI R30,-LOW(1)
	STS  _second_counter_G000,R30
; 0000 0107         if(podsvet>0)podsvet--;
	LDS  R26,_podsvet_G000
	CPI  R26,LOW(0x1)
	BRLO _0x4B
	LDS  R30,_podsvet_G000
	SUBI R30,LOW(1)
	STS  _podsvet_G000,R30
; 0000 0108 
; 0000 0109         ////////////////TO
; 0000 010A         if(TO_EEP!=0)
_0x4B:
	RCALL SUBOPT_0x26
	BREQ _0x4C
; 0000 010B         {
; 0000 010C             if (second_counter%2!=0){TO_output=1; }
	LDS  R26,_second_counter_G000
	CLR  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	SBIW R30,0
	BREQ _0x4D
	SET
	RJMP _0x113
; 0000 010D             else{TO_output=0;};//БЛИМАННЯ  ТО
_0x4D:
	CLT
_0x113:
	BLD  R2,2
; 0000 010E         }
; 0000 010F         ////////////////TO
; 0000 0110           if(second_counter>=59)
_0x4C:
	LDS  R26,_second_counter_G000
	CPI  R26,LOW(0x3B)
	BRLO _0x4F
; 0000 0111         {
; 0000 0112             second_counter=0;
	LDI  R30,LOW(0)
	STS  _second_counter_G000,R30
; 0000 0113             podsvet=10;
	LDI  R30,LOW(10)
	STS  _podsvet_G000,R30
; 0000 0114             if(PositionPointer==32){minut_counter++;};
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x20)
	BRNE _0x50
	LDI  R26,LOW(_minut_counter_G000)
	LDI  R27,HIGH(_minut_counter_G000)
	RCALL SUBOPT_0x27
_0x50:
; 0000 0115         }
; 0000 0116     }
_0x4F:
; 0000 0117     interrapt_counter++;
_0x4A:
	LDI  R26,LOW(_interrapt_counter_G000)
	LDI  R27,HIGH(_interrapt_counter_G000)
	RCALL SUBOPT_0x27
; 0000 0118 
; 0000 0119 // временная информация
; 0000 011A 
; 0000 011B 
; 0000 011C #asm("sei")
	sei
; 0000 011D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void PerehodNaGenerator()
; 0000 0120 {
_PerehodNaGenerator:
; .FSTART _PerehodNaGenerator
; 0000 0121         LINE_REL=1; // відключаємо МЕРЕЖУ
	SBI  0x12,3
; 0000 0122         delay_ms(HALF_SECOND);
	RCALL SUBOPT_0x28
; 0000 0123         GEN_REL=1; // Підключаємо генератор
	SBI  0x12,2
; 0000 0124 }
	RET
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void PerehodNaMereju()
; 0000 0127 {
_PerehodNaMereju:
; .FSTART _PerehodNaMereju
; 0000 0128         GEN_REL=0; // відключаємо ГЕНЕРАТОР
	CBI  0x12,2
; 0000 0129         delay_ms(HALF_SECOND);
	RCALL SUBOPT_0x28
; 0000 012A         LINE_REL=0; // Підключаємо МЕРЕЖУ
	CBI  0x12,3
; 0000 012B }
	RET
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void Klapan_off()
; 0000 012E {
_Klapan_off:
; .FSTART _Klapan_off
; 0000 012F #asm("cli")
	cli
; 0000 0130 LCD_Clear();
	RCALL _LCD_Clear
; 0000 0131             temp=15;  // загружаємо час перекриття паливного клапану (при зупинці)
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RCALL SUBOPT_0x29
; 0000 0132             OFF_REL=1; // перекриваэмо паливний клапан
	SBI  0x12,5
; 0000 0133             while (temp!=0){
_0x5B:
	RCALL SUBOPT_0x2A
	SBIW R30,0
	BREQ _0x5D
; 0000 0134 //                 sprintf(buff," ТОПЛИВНЫЙ  "); ShowBigLine(3);
; 0000 0135                     sprintf(buff," Т.КЛАП%2.uc",temp);ShowBigLine(5);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x2C
; 0000 0136                     delay_ms(ONE_SECOND);
; 0000 0137                    // PORTD.6=0;//вимикаємо запалення после первой секунды роботы клапана
; 0000 0138                     temp--;
	RCALL SUBOPT_0x2D
; 0000 0139                  };
	RJMP _0x5B
_0x5D:
; 0000 013A             OFF_REL=0; // відкриваэмо паливний клапан
	CBI  0x12,5
; 0000 013B             ON_REL=0;//вимикаємо запалення
	CBI  0x12,4
; 0000 013C LCD_Clear();
	RCALL _LCD_Clear
; 0000 013D #asm("sei")
	sei
; 0000 013E }
	RET
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;
;
;
;void MainInfo()
; 0000 0144 {
_MainInfo:
; .FSTART _MainInfo
; 0000 0145     sprintf(buff," Uin =%4.uB ",U1);ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,13
	RCALL SUBOPT_0x2E
; 0000 0146     sprintf(buff,"       Ub = %2.u.%1.uB       ",U_Bat/10,U_Bat%10);ShowLine(5);
	__POINTW1FN _0x0,26
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL SUBOPT_0x2F
	RCALL __MODW21U
	RCALL SUBOPT_0x31
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
	LDI  R26,LOW(5)
	RCALL _ShowLine
; 0000 0147 //    sprintf(buff,"  Ub =%2.u.%1.uB N:%5.uh ",U_Bat/10,U_Bat%10,NarabotkaEEP/6);ShowLine(5);
; 0000 0148 //    LCD_Goto(0,5);
; 0000 0149 //    LCD_Printf(buff,1);  //  вывод на дисплей
; 0000 014A //            sprintf(buff,"      N:%6.uh       ",NarabotkaEEP/6);
; 0000 014B //            sprintf(buff,"СИГНАЛ:'TO'  N:%5.uh ",NarabotkaEEP/6); ShowLine(INFOLINE1);
; 0000 014C //sprintf(buff,"  ЗАПУСКА ЭЛ.СТАНЦИИ  "); ShowLine(INFOLINE2);
; 0000 014D //sprintf(buff," Uin =%4.uB Ubat=%2.u.%1.uB ",U1,U_Bat/10,U_Bat%10);ShowLine(2);
; 0000 014E     if(TO_EEP)
	RCALL SUBOPT_0x26
	BREQ _0x62
; 0000 014F     {
; 0000 0150         if(TO_output)
	SBRS R2,2
	RJMP _0x63
; 0000 0151         {
; 0000 0152             sprintf(buff,"                      ");
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,56
	RJMP _0x114
; 0000 0153         }
; 0000 0154         else
_0x63:
; 0000 0155         {
; 0000 0156             sprintf(buff," !!! ОБСЛУЖИВАНИЕ !!! ");
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,79
_0x114:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x32
; 0000 0157 
; 0000 0158         }
; 0000 0159         ShowLine(INFOLINE2);
	LDI  R26,LOW(7)
	RCALL _ShowLine
; 0000 015A     }
; 0000 015B 
; 0000 015C             if (T<0){  sprintf(buff,"  T =-%3.i*C N:%5.uh ",-T,NarabotkaEEP/6);}
_0x62:
	LDS  R26,_T_G000+1
	TST  R26
	BRPL _0x65
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,102
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x25
	RCALL __ANEGW1
	RJMP _0x115
; 0000 015D                 else{  sprintf(buff,"  T = %3.i*C N:%5.uh ",T,NarabotkaEEP/6);};
_0x65:
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,124
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x25
_0x115:
	RCALL __CWD1
	RCALL __PUTPARD1
	RCALL SUBOPT_0x33
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 015E             if (T<-25){sprintf(buff,"  T = n/c   N:%5.uh ",NarabotkaEEP/6);};  ShowLine(6);
	RCALL SUBOPT_0x34
	CPI  R26,LOW(0xFFE7)
	LDI  R30,HIGH(0xFFE7)
	CPC  R27,R30
	BRGE _0x67
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,146
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x35
_0x67:
	RCALL SUBOPT_0x36
; 0000 015F }
	RET
; .FEND
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;//--------------------------------    MAIN     ----------------------------------------------------------
;//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;void main(void)
; 0000 0164 {
_main:
; .FSTART _main
; 0000 0165 // Declare your local variables here
; 0000 0166 
; 0000 0167 // Input/Output Ports initialization
; 0000 0168 
; 0000 0169 PORTB=0b00000000; DDRB =0b00100011;         // 0-START ; 1,5 - OLED; 2,3,4 -keys;  6,7 - zaslonka
	LDI  R30,LOW(0)
	OUT  0x18,R30
	LDI  R30,LOW(35)
	OUT  0x17,R30
; 0000 016A PORTC=0b00000000; DDRC =0b00000000;         //
	LDI  R30,LOW(0)
	OUT  0x15,R30
	OUT  0x14,R30
; 0000 016B PORTD=0b00000000; DDRD =0b11111100;
	OUT  0x12,R30
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 016C 
; 0000 016D // Timer/Counter 0 initialization
; 0000 016E // Clock source: System Clock; Clock value: 0,977 kHz ???
; 0000 016F TCCR0=(1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0170 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0171 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0172 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0173 // External Interrupt(s) initialization  INT0: Off; INT1: Off
; 0000 0174 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0175 // USART initialization USART disabled
; 0000 0176 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0177 // Analog Comparator: Off
; 0000 0178 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0179 // ADC Clock frequency: 1000.000 kHz, AREF pin
; 0000 017A ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 017B ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 017C SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 017D 
; 0000 017E // Bit-Banged I2C Bus initialization
; 0000 017F // Project|Configure|C Compiler|Libraries|I2C menu.
; 0000 0180 ///////////////////////////////////////////////////////////////////////////////
; 0000 0181 // Init Variables and sequenses
; 0000 0182 
; 0000 0183 PositionPointer=1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x10
; 0000 0184 //Narabotka=0;
; 0000 0185 // загружаємо із EEPROM
; 0000 0186 type=typeEEP;
	LDI  R26,LOW(_typeEEP)
	LDI  R27,HIGH(_typeEEP)
	RCALL __EEPROMRDB
	STS  _type_G000,R30
; 0000 0187 t1=t1EEP;
	LDI  R26,LOW(_t1EEP)
	LDI  R27,HIGH(_t1EEP)
	RCALL __EEPROMRDB
	STS  _t1_G000,R30
; 0000 0188 t2=t2EEP;
	LDI  R26,LOW(_t2EEP)
	LDI  R27,HIGH(_t2EEP)
	RCALL __EEPROMRDB
	STS  _t2_G000,R30
; 0000 0189 t3=t3EEP;
	LDI  R26,LOW(_t3EEP)
	LDI  R27,HIGH(_t3EEP)
	RCALL __EEPROMRDB
	STS  _t3_G000,R30
; 0000 018A t4=t4EEP;
	LDI  R26,LOW(_t4EEP)
	LDI  R27,HIGH(_t4EEP)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x37
; 0000 018B t5=t5EEP;
	LDI  R26,LOW(_t5EEP)
	LDI  R27,HIGH(_t5EEP)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x38
; 0000 018C //t6=t6EEP;
; 0000 018D TminZ=TminZEEP;
	LDI  R26,LOW(_TminZEEP)
	LDI  R27,HIGH(_TminZEEP)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x39
; 0000 018E TminN=TminNEEP;
	LDI  R26,LOW(_TminNEEP)
	LDI  R27,HIGH(_TminNEEP)
	RCALL __EEPROMRDB
	STS  _TminN_G000,R30
; 0000 018F z=Z_EEP;
	LDI  R26,LOW(_Z_EEP)
	LDI  R27,HIGH(_Z_EEP)
	RCALL __EEPROMRDB
	RCALL __BSTB1
	BLD  R2,0
; 0000 0190 r=R_EEP;
	LDI  R26,LOW(_R_EEP)
	LDI  R27,HIGH(_R_EEP)
	RCALL __EEPROMRDB
	RCALL __BSTB1
	BLD  R2,1
; 0000 0191 KilkistZapuskiv=KilkistZapuskiv_EEP;
	RCALL SUBOPT_0x14
; 0000 0192 //EEPROM
; 0000 0193 
; 0000 0194 U1=220;
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	RCALL SUBOPT_0x23
; 0000 0195 i2c_init();
	RCALL _i2c_init
; 0000 0196 #asm("sei")    // Global enable interrupts
	sei
; 0000 0197 //   PWR_LCD=1;
; 0000 0198 ///////////////////////////////////////////////////////////////////////////////
; 0000 0199 
; 0000 019A     LCD_init();
	RCALL _LCD_init
; 0000 019B     sprintf(buff," MicroCraft "); ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,167
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 019C     LCD_Goto(45,3);
	LDI  R30,LOW(45)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x5
; 0000 019D 
; 0000 019E     sprintf(buff,"(TM)");
	__POINTW1FN _0x0,180
	RCALL SUBOPT_0x3A
; 0000 019F     LCD_Printf(buff,1);  //  вывод на дисплей
	RCALL SUBOPT_0x2B
	LDI  R26,LOW(1)
	RCALL _LCD_Printf
; 0000 01A0     LCD_Goto(0,6);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x5
; 0000 01A1     sprintf(buff," PGSII  v.2 ");
	__POINTW1FN _0x0,185
	RCALL SUBOPT_0x3A
; 0000 01A2     LCD_Printf(buff,1);  //  вывод на дисплей
	RCALL SUBOPT_0x2B
	LDI  R26,LOW(1)
	RCALL _LCD_Printf
; 0000 01A3 
; 0000 01A4     LCD_Blinc(QUARTER_SECOND,3);
	RCALL SUBOPT_0x3C
; 0000 01A5 /*
; 0000 01A6 //    delay_ms(5000);
; 0000 01A7 
; 0000 01A8     //     LCD_DrawImage(0);
; 0000 01A9     //     delay_ms(5000);
; 0000 01AA //LCD_Clear();
; 0000 01AB     //       LCD_Contrast(1);
; 0000 01AC     */
; 0000 01AD ///////////////////////////////////////////////////////////////////////////////
; 0000 01AE while (1)
_0x68:
; 0000 01AF     {
; 0000 01B0       #asm("cli")
	cli
; 0000 01B1       if(podmenu == 0){LCD_Mode(0);}
	SBRC R2,3
	RJMP _0x6B
	LDI  R26,LOW(0)
	RJMP _0x116
; 0000 01B2       else{LCD_Mode(1);}
_0x6B:
	LDI  R26,LOW(1)
_0x116:
	RCALL _LCD_Mode
; 0000 01B3       #asm("sei")
	sei
; 0000 01B4 ///////////////////////////////////////////////////////////////////////////////
; 0000 01B5 //    sprintf(buff,"  R:%2.u S%3.u e:%2.u p:%2.u",rotor,second_counter,enter,PositionPointer);
; 0000 01B6 //    sprintf(buff,"%3.u %3.u N:%4.uч p%2.u",second_counter,minut_counter,NarabotkaEEP,PositionPointer);
; 0000 01B7 //    ShowLine(7);
; 0000 01B8 
; 0000 01B9 //    sprintf(buff,"      N:%6.uч     ",NarabotkaEEP/6);
; 0000 01BA //    ShowLine(7);
; 0000 01BB 
; 0000 01BC //                        sprintf(buf2,"N=%4.uА ",NarabotkaMinEEP/10);
; 0000 01BD ///////////////////////////////////////////////////////////////////////////////
; 0000 01BE if (minut_counter>=10)
	LDS  R26,_minut_counter_G000
	LDS  R27,_minut_counter_G000+1
	SBIW R26,10
	BRLO _0x6D
; 0000 01BF {
; 0000 01C0     #asm("cli")
	cli
; 0000 01C1     NarabotkaEEP++;
	RCALL SUBOPT_0x3D
	ADIW R30,1
	RCALL __EEPROMWRW
; 0000 01C2     minut_counter=0;
	LDI  R30,LOW(0)
	STS  _minut_counter_G000,R30
	STS  _minut_counter_G000+1,R30
; 0000 01C3     if ((NarabotkaEEP==120)|(NarabotkaEEP==600)|(NarabotkaEEP==1200)|(NarabotkaEEP==1800)|(NarabotkaEEP==2400)){Narabotk ...
	RCALL SUBOPT_0x3D
	MOVW R22,R30
	LDI  R26,LOW(120)
	LDI  R27,HIGH(120)
	RCALL __EQW12
	MOV  R0,R30
	MOVW R30,R22
	LDI  R26,LOW(600)
	LDI  R27,HIGH(600)
	RCALL SUBOPT_0x3E
	LDI  R26,LOW(1200)
	LDI  R27,HIGH(1200)
	RCALL SUBOPT_0x3E
	LDI  R26,LOW(1800)
	LDI  R27,HIGH(1800)
	RCALL SUBOPT_0x3E
	LDI  R26,LOW(2400)
	LDI  R27,HIGH(2400)
	RCALL __EQW12
	OR   R30,R0
	BREQ _0x6E
	RCALL SUBOPT_0x3D
	ADIW R30,1
	RCALL __EEPROMWRW
	LDI  R26,LOW(_TO_EEP)
	LDI  R27,HIGH(_TO_EEP)
	LDI  R30,LOW(1)
	RCALL __EEPROMWRB
_0x6E:
; 0000 01C4     #asm("sei")
	sei
; 0000 01C5 };            //   для підрахунку 10хв
_0x6D:
; 0000 01C6 ///////////////////////////////////////////////////////////////////////////////
; 0000 01C7     switch (PositionPointer){
	RCALL SUBOPT_0xA
	LDI  R31,0
; 0000 01C8     ///////////////////////////////////////////////////////////////////////////////
; 0000 01C9         case 1: // автоматичний запуск
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x72
; 0000 01CA             //if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){#asm("cli") TO_EEP=0; #asm("sei") up=2;}
; 0000 01CB             if(enter>=98){enter=2;LCD_Clear();#asm("cli") TO_EEP=0; #asm("sei") up=2; }
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0x62)
	BRLO _0x73
	RCALL SUBOPT_0x1E
	cli
	LDI  R26,LOW(_TO_EEP)
	LDI  R27,HIGH(_TO_EEP)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	sei
	RCALL SUBOPT_0x3F
; 0000 01CC 
; 0000 01CD             AvtRu=0; // встановлюємо флаг, який буде показувати який був останній режим - Автомат чи Ручний
_0x73:
	LDI  R30,LOW(0)
	STS  _AvtRu_G000,R30
; 0000 01CE             if(podsvet>=1){
	LDS  R26,_podsvet_G000
	CPI  R26,LOW(0x1)
	BRLO _0x74
; 0000 01CF                 sprintf(buff," 1: АВТО    ");
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,198
	RCALL SUBOPT_0x3A
; 0000 01D0                 ShowBigLine(0);
	RCALL SUBOPT_0x3B
; 0000 01D1                 MainInfo();
	RCALL _MainInfo
; 0000 01D2 //            if(podsvet==1){LCD_Clear();podsvet=0;}
; 0000 01D3             }
; 0000 01D4             else
	RJMP _0x75
_0x74:
; 0000 01D5             {
; 0000 01D6                 LCD_Clear();
	RCALL _LCD_Clear
; 0000 01D7                 sprintf(buff,"$");
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,211
	RCALL SUBOPT_0x3A
; 0000 01D8                 ShowBigLine(0);
	RCALL SUBOPT_0x3B
; 0000 01D9                 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 01DA                 LCD_init();
	RCALL _LCD_init
; 0000 01DB             }
_0x75:
; 0000 01DC 
; 0000 01DD             if ((U1<U1_MIN)||(U1>U1_MAX)){  //напруга в мережі низька 175В-80% або висока 265
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x8C)
	LDI  R30,HIGH(0x8C)
	CPC  R27,R30
	BRLO _0x77
	RCALL SUBOPT_0x41
	BRLO _0x76
_0x77:
; 0000 01DE //добавлена быстрая защита нагрузки!!!
; 0000 01DF                 if(U1>U1_MAX){LINE_REL=1;}   // відключаємо МЕРЕЖУ    для защиты !!!
	RCALL SUBOPT_0x41
	BRLO _0x79
	SBI  0x12,3
; 0000 01E0                 temp=t1;  // загружаємо затримку переходу на генератор
_0x79:
	LDS  R30,_t1_G000
	RCALL SUBOPT_0x42
; 0000 01E1                 while (temp!=0)
_0x7C:
	RCALL SUBOPT_0x43
	BREQ _0x7E
; 0000 01E2                 {
; 0000 01E3                     sprintf(buff,"  HET CETИ! "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,213
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 01E4                     sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
	RCALL SUBOPT_0x45
; 0000 01E5                     delay_ms(ONE_SECOND);
; 0000 01E6                     if(PositionPointer!=1){goto begin;}
	RCALL SUBOPT_0x6
	CPI  R26,LOW(0x1)
	BREQ _0x7F
	RJMP _0x80
; 0000 01E7                     temp--;
_0x7F:
	RCALL SUBOPT_0x2D
; 0000 01E8                 }
	RJMP _0x7C
_0x7E:
; 0000 01E9                 if ((U1<U1_MIN-5)||(U1>U1_MAX+5)){PositionPointer=30; KilkistZapuskiv=KilkistZapuskiv_EEP;};
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x87)
	LDI  R30,HIGH(0x87)
	CPC  R27,R30
	BRLO _0x82
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x10F)
	LDI  R30,HIGH(0x10F)
	CPC  R27,R30
	BRLO _0x81
_0x82:
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x14
_0x81:
; 0000 01EA                 //напруга все ще за допустимими межами ?,тоді перехід.
; 0000 01EB                 // добавлен гистерезис
; 0000 01EC             }
; 0000 01ED         break;
_0x76:
	RJMP _0x71
; 0000 01EE     ///////////////////////////////////////////////////////////////////////////////
; 0000 01EF         case 2: //
_0x72:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x84
; 0000 01F0             AvtRu=1; // встановлюємо флаг, який буде показувати який був останній режим - Автомат чи Ручний
	LDI  R30,LOW(1)
	STS  _AvtRu_G000,R30
; 0000 01F1             sprintf(buff," 2: РУЧНОЙ ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,239
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 01F2             MainInfo();
	RCALL _MainInfo
; 0000 01F3             if (U1>U1_MAX)
	RCALL SUBOPT_0x41
	BRLO _0x85
; 0000 01F4             {
; 0000 01F5                 PositionPointer=42;// перехід на аварію
	RCALL SUBOPT_0x46
; 0000 01F6                 Klapan_off();
; 0000 01F7                 LINE_REL=1; // відключаємо МЕРЕЖУ     !!!
; 0000 01F8                 LCD_Clear();
; 0000 01F9             }
; 0000 01FA         break;
_0x85:
	RJMP _0x71
; 0000 01FB     ///////////////////////////////////////////////////////////////////////////////
; 0000 01FC         case 3: //
_0x84:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x88
; 0000 01FD             sprintf(buff," 3: СТОП   ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,251
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 01FE             MainInfo();
	RCALL _MainInfo
; 0000 01FF 
; 0000 0200 /*
; 0000 0201 //            sprintf(buff," t4  =%4.uc",t4); ShowBigLine(3);
; 0000 0202             sprintf(buff,"%4.uB %2.u.%1.uB",U1,U_Bat/10,U_Bat%10);ShowBigLine(3);
; 0000 0203             if (T<0){  sprintf(buff,"  T =-%3.i*C ",-T);}
; 0000 0204                 else{  sprintf(buff,"  T = %3.i*C ",T);};
; 0000 0205             if (T<-25){sprintf(buff,"  T = n/c   ");};  ShowBigLine(5);
; 0000 0206 */
; 0000 0207 
; 0000 0208             if (U1>U1_MAX)
	RCALL SUBOPT_0x41
	BRLO _0x89
; 0000 0209             {
; 0000 020A                 PositionPointer=42;// перехід на аварію
	RCALL SUBOPT_0x46
; 0000 020B                 Klapan_off();
; 0000 020C                 LINE_REL=1; // відключаємо МЕРЕЖУ     !!!
; 0000 020D                 LCD_Clear();
; 0000 020E             }
; 0000 020F         break;
_0x89:
	RJMP _0x71
; 0000 0210   ///////////////////////////////////////////////////////////////////////////////
; 0000 0211         case 10: // час роботи із заслонкою
_0x88:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x8C
; 0000 0212             sprintf(buff," НАСТРОЙКИ ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,263
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 0213             sprintf(buff,"                      "); ShowLine(5);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,56
	RCALL SUBOPT_0x3A
	LDI  R26,LOW(5)
	RCALL _ShowLine
; 0000 0214             sprintf(buff," t4  =%4.uc ",t4); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,275
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x44
; 0000 0215             sprintf(buff,"   ВРЕМЯ ОБОГАЩЕНИЯ   "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,288
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 0216 //            sprintf(buff,"         СМЕСИ        "); ShowLine(INFOLINE2);
; 0000 0217             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t4++;up=2;}
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	BREQ _0x8D
	RCALL SUBOPT_0x1A
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x3F
; 0000 0218             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t4--;down=2;}
_0x8D:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x49
	BREQ _0x8E
	RCALL SUBOPT_0x1A
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x4A
; 0000 0219             if(t4>60){t4=60;}
_0x8E:
	LDS  R26,_t4_G000
	CPI  R26,LOW(0x3D)
	BRLO _0x8F
	LDI  R30,LOW(60)
	RCALL SUBOPT_0x37
; 0000 021A             if(t4<1){t4=1;}
_0x8F:
	LDS  R26,_t4_G000
	CPI  R26,LOW(0x1)
	BRSH _0x90
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x37
; 0000 021B           break;
_0x90:
	RJMP _0x71
; 0000 021C     ///////////////////////////////////////////////////////////////////////////////
; 0000 021D         case 11: //   t5=t6
_0x8C:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x91
; 0000 021E             sprintf(buff," t5  =%4.uc ",t5);         ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,311
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x44
; 0000 021F //            sprintf(buff,"    ВРЕМЯ ПРОГРЕВА    "); ShowLine(INFOLINE1);
; 0000 0220             sprintf(buff," ПРОГРЕВ БЕЗ НАГРУЗКИ "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,324
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 0221             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){t5=t5+5;up=2;}
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	BREQ _0x92
	RCALL SUBOPT_0x1B
	SUBI R30,-LOW(5)
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x3F
; 0000 0222             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){t5=t5-5;down=2;}
_0x92:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x49
	BREQ _0x93
	RCALL SUBOPT_0x1B
	SUBI R30,LOW(5)
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x4A
; 0000 0223             if(t5>60){t5=60;}
_0x93:
	LDS  R26,_t5_G000
	CPI  R26,LOW(0x3D)
	BRLO _0x94
	LDI  R30,LOW(60)
	RCALL SUBOPT_0x38
; 0000 0224             if(t5<5){t5=5;}
_0x94:
	LDS  R26,_t5_G000
	CPI  R26,LOW(0x5)
	BRSH _0x95
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x38
; 0000 0225         break;
_0x95:
	RJMP _0x71
; 0000 0226     ///////////////////////////////////////////////////////////////////////////////
; 0000 0227         case 12: // Мінімальна температура прогріву генератора с заслонкой(накал свечей для дизеля)
_0x91:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x96
; 0000 0228             sprintf(buff," Tz  =%3.u*C ",TminZ);      ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,347
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x44
; 0000 0229 //            sprintf(buff,"   Мaх. ТЕМПЕРАТУРА   "); ShowLine(INFOLINE1);
; 0000 022A //            sprintf(buff,"   ОБОГАЩЕНИЯ СМЕСИ   "); ShowLine(INFOLINE2);
; 0000 022B             sprintf(buff," МИН.ТЕМП.ОБОГАЩЕНИЯ  "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,361
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 022C             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){TminZ=TminZ+5;up=2;}
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	BREQ _0x97
	RCALL SUBOPT_0x1C
	SUBI R30,-LOW(5)
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x3F
; 0000 022D             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){TminZ=TminZ-5;down=2;}
_0x97:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x49
	BREQ _0x98
	RCALL SUBOPT_0x1C
	SUBI R30,LOW(5)
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x4A
; 0000 022E             if(TminZ>90){TminZ=90;}
_0x98:
	LDS  R26,_TminZ_G000
	CPI  R26,LOW(0x5B)
	BRLO _0x99
	LDI  R30,LOW(90)
	RCALL SUBOPT_0x39
; 0000 022F             if(TminZ<5){TminZ=5;}
_0x99:
	LDS  R26,_TminZ_G000
	CPI  R26,LOW(0x5)
	BRSH _0x9A
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x39
; 0000 0230         break;
_0x9A:
	RJMP _0x71
; 0000 0231     ///////////////////////////////////////////////////////////////////////////////
; 0000 0232         case 13: //
_0x96:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x9B
; 0000 0233             sprintf(buff," Kz  =%4.u ",KilkistZapuskiv); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,384
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x44
; 0000 0234 //            sprintf(buff,"  КОЛИЧЕСТВО ПОПЫТОК  "); ShowLine(INFOLINE1);
; 0000 0235 //          sprintf(buff,"  ЗАПУСКА ЭЛ.СТАНЦИИ  "); ShowLine(INFOLINE2);
; 0000 0236             sprintf(buff," КОЛИЧЕСТВО ЗАПУСКОВ  "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,396
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 0237             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv++;up=2;}
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	BREQ _0x9C
	RCALL SUBOPT_0x1D
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x3F
; 0000 0238             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){KilkistZapuskiv--;down=2;}
_0x9C:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x49
	BREQ _0x9D
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4A
; 0000 0239             if(KilkistZapuskiv>6){KilkistZapuskiv=6;}
_0x9D:
	RCALL SUBOPT_0x4C
	CPI  R26,LOW(0x7)
	BRLO _0x9E
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x4B
; 0000 023A             if(KilkistZapuskiv<1){KilkistZapuskiv=1;}
_0x9E:
	RCALL SUBOPT_0x4D
	BRSH _0x9F
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x4B
; 0000 023B         break;
_0x9F:
	RJMP _0x71
; 0000 023C     ///////////////////////////////////////////////////////////////////////////////
; 0000 023D         case 14: //
_0x9B:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0xA0
; 0000 023E             if(z==0){sprintf(buff," <ЗАСЛОНКА> ");}
	SBRC R2,0
	RJMP _0xA1
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,419
	RJMP _0x117
; 0000 023F             else{sprintf(buff," < КЛАПАН > ");}
_0xA1:
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,432
_0x117:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x32
; 0000 0240             ShowBigLine(3);
	RCALL SUBOPT_0x44
; 0000 0241             sprintf(buff,"     ТИП ПРИВОДА      "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,445
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 0242 //            sprintf(buff,"      И ИМПУЛЬСА      "); ShowLine(INFOLINE2);
; 0000 0243             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){z=!z;up=2;}
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	BREQ _0xA3
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x20
; 0000 0244             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){z=!z;down=2;}
_0xA3:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x49
	BREQ _0xA4
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x22
; 0000 0245         break;
_0xA4:
	RJMP _0x71
; 0000 0246     ///////////////////////////////////////////////////////////////////////////////
; 0000 0247         case 15: //
_0xA0:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0xA5
; 0000 0248             if(r==0){sprintf(buff," РОТОР(off)");}
	SBRC R2,1
	RJMP _0xA6
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,468
	RJMP _0x118
; 0000 0249             else{sprintf(buff," РОТОР(on) ");}
_0xA6:
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,480
_0x118:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x32
; 0000 024A             ShowBigLine(3);
	RCALL SUBOPT_0x44
; 0000 024B //            sprintf(buff,"       КОНТРОЛЬ       "); ShowLine(INFOLINE1);
; 0000 024C             sprintf(buff,"   СИГНАЛ : 'РОТОР'   "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,492
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 024D             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){r=!r;up=2;}
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	BREQ _0xA8
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x20
; 0000 024E             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){r=!r;down=2;}
_0xA8:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x49
	BREQ _0xA9
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x22
; 0000 024F         break;
_0xA9:
	RJMP _0x71
; 0000 0250 
; 0000 0251     ///////////////////////////////////////////////////////////////////////////////
; 0000 0252 /*        case 16: //
; 0000 0253             if(TO_EEP==0){sprintf(buff,"  TO  ( 0 )");}
; 0000 0254             else{         sprintf(buff,"  TO  ( 1 )");}
; 0000 0255             ShowBigLine(3);
; 0000 0256 
; 0000 0257 //            sprintf(buff,"       КОНТРОЛЬ       "); ShowLine(INFOLINE1);
; 0000 0258 //            sprintf(buff,"      N:%6.uh       ",NarabotkaEEP/6);
; 0000 0259             sprintf(buff,"СИГНАЛ:'TO'  N:%5.uh ",NarabotkaEEP/6); ShowLine(INFOLINE1);
; 0000 025A //            sprintf(buff,"   СИГНАЛ : ' TO  '   "); ShowLine(INFOLINE1);
; 0000 025B             if(((up==1)|(up>KEY_SIG_NUM))&(podmenu==1)){#asm("cli") TO_EEP=0; #asm("sei") up=2;}
; 0000 025C             if(((down==1)|(down>KEY_SIG_NUM))&(podmenu==1)){#asm("cli") TO_EEP=0; #asm("sei")down=2;}
; 0000 025D         break;
; 0000 025E */
; 0000 025F     ///////////////////////////////////////////////////////////////////////////////
; 0000 0260         case 16: //
_0xA5:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0xAA
; 0000 0261             sprintf(buff," - ВЫХОД - ");            ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,515
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 0262 //            sprintf(buff,"      ДЛЯ ВЫХОДА      "); ShowLine(INFOLINE1);
; 0000 0263 //            sprintf(buff,"   УДЕРЖИВАЙ  'ВВОД'  "); ShowLine(INFOLINE2);
; 0000 0264             sprintf(buff,"  ДЛЯ ВЫХОДА >'ВВОД'  "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,527
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 0265 
; 0000 0266 //            sprintf(buff,"%2.u",enter);
; 0000 0267 //            ShowLine(4);
; 0000 0268 
; 0000 0269         break;
	RJMP _0x71
; 0000 026A     ///////////////////////////////////////////////////////////////////////////////
; 0000 026B         case 30: //
_0xAA:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xAB
; 0000 026C             LCD_Clear();
	RCALL _LCD_Clear
; 0000 026D             sprintf(buff,"  ЗАПУСК %1.u ",KilkistZapuskiv);           ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,550
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x47
	RCALL SUBOPT_0x3B
; 0000 026E             delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 026F             sprintf(buff," ЗАЖИГАНИЕ  ");           ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,565
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x4F
; 0000 0270             ON_REL=1;      //вмикаємо запалення OUT7
	SBI  0x12,4
; 0000 0271             if(T<TminZ){
	RCALL SUBOPT_0x50
	BRGE _0xAE
; 0000 0272                 VALVE_U_REL=1;
	SBI  0x12,6
; 0000 0273                 delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 0274                 if(z==0)
	SBRC R2,0
	RJMP _0xB1
; 0000 0275                 {
; 0000 0276                     sprintf(buff," ЗАСЛОНКА-> "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,578
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x4F
; 0000 0277                     VALVE_U_REL=0;//відключаємо імпульс закритої заслонки
	CBI  0x12,6
; 0000 0278                 }
; 0000 0279                 else
	RJMP _0xB4
_0xB1:
; 0000 027A                 {
; 0000 027B                     sprintf(buff," КЛАПАН ->  "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,591
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x4F
; 0000 027C                 }
_0xB4:
; 0000 027D                 delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 027E             };
_0xAE:
; 0000 027F             ///////////////////////////////////
; 0000 0280 ////////
; 0000 0281             // !!!!добавить проверку выходного напряжения
; 0000 0282             if(rotor<3){STARTER_REL=1;};// запускаємо стартер ,якщо ротор не  працює v1.4)
	RCALL SUBOPT_0x1F
	CPI  R26,LOW(0x3)
	BRSH _0xB5
	SBI  0x18,0
_0xB5:
; 0000 0283             // !!!!добавить проверку выходного напряжения
; 0000 0284             temp=t3;
	LDS  R30,_t3_G000
	RCALL SUBOPT_0x42
; 0000 0285             while (temp!=0)
_0xB8:
	RCALL SUBOPT_0x43
	BREQ _0xBA
; 0000 0286             {
; 0000 0287                 sprintf(buff," СТАРТЕР:%1.uc ",temp); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,604
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x4F
; 0000 0288                 delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 0289                 temp--;
	RCALL SUBOPT_0x2D
; 0000 028A                 if(rotor>7){temp=0;};// еесли двигатель запустился- переходим к засллонке
	RCALL SUBOPT_0x1F
	CPI  R26,LOW(0x8)
	BRLO _0xBB
	LDI  R30,LOW(0)
	STS  _temp_G000,R30
	STS  _temp_G000+1,R30
_0xBB:
; 0000 028B             };
	RJMP _0xB8
_0xBA:
; 0000 028C             STARTER_REL=0;                           //відключаємо стартер OUT6 на (1-6c)
	CBI  0x18,0
; 0000 028D             ///////////////////////////////////
; 0000 028E             temp=t4;                             // прогріваємо генератор із заслонкою (5-30с)
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x42
; 0000 028F             if(T<TminZ){
	RCALL SUBOPT_0x50
	BRGE _0xBE
; 0000 0290                 while (temp!=0)
_0xBF:
	RCALL SUBOPT_0x43
	BREQ _0xC1
; 0000 0291                 {
; 0000 0292                     sprintf(buff,"ПРОГРЕВ:%2.uc ",temp); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,620
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x4F
; 0000 0293                     delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 0294                     temp--;
	RCALL SUBOPT_0x2D
; 0000 0295     //                if(T>TminZ){temp=0;}     //якщо температура высока - зупиняемо прогрів
; 0000 0296                 };
	RJMP _0xBF
_0xC1:
; 0000 0297                 ///////////////////////////////////
; 0000 0298                 VALVE_U_REL=0; //відключаємо імпульс закритої заслонки АБО КЛАПАНА
	CBI  0x12,6
; 0000 0299                 if(z==0)
	SBRC R2,0
	RJMP _0xC4
; 0000 029A                 {
; 0000 029B                     sprintf(buff," ЗАСЛОНКА < "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,635
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x4F
; 0000 029C                     delay_ms(HALF_SECOND);                           //пауза чтоб не подать встречное напряжение
	RCALL SUBOPT_0x28
; 0000 029D                     VALVE_D_REL=1; //відкріваємо заслонку OUT4  Реверсивный импульс!!!
	SBI  0x12,7
; 0000 029E                 }
; 0000 029F                 else
	RJMP _0xC7
_0xC4:
; 0000 02A0                 {
; 0000 02A1                     sprintf(buff," КЛАПАН <-  "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,648
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x4F
; 0000 02A2                     delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 02A3                 }
_0xC7:
; 0000 02A4                 delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 02A5             }
; 0000 02A6             VALVE_D_REL=0; //відключаємо  реверсивний імпульс для заслонки и КЛАПАНА (на всякий случай)
_0xBE:
	CBI  0x12,7
; 0000 02A7             ///////////////////////////////////
; 0000 02A8 
; 0000 02A9 //!!! /// добавить проверку (может уже завелся?)
; 0000 02AA             temp=RAZGON;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x29
; 0000 02AB             while (temp!=0){
_0xCA:
	RCALL SUBOPT_0x43
	BREQ _0xCC
; 0000 02AC                    sprintf(buff," РАЗГОН:%2.uc ",temp); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,661
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x4F
; 0000 02AD                    delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 02AE                    temp--;
	RCALL SUBOPT_0x2D
; 0000 02AF                  };
	RJMP _0xCA
_0xCC:
; 0000 02B0             ///////////////////////////////////
; 0000 02B1             if(KilkistZapuskiv>0){KilkistZapuskiv--;};
	RCALL SUBOPT_0x4D
	BRLO _0xCD
	RCALL SUBOPT_0x1D
	SUBI R30,LOW(1)
	RCALL SUBOPT_0x4B
_0xCD:
; 0000 02B2             PositionPointer=31; // Переход на проверку и прогрев
	LDI  R30,LOW(31)
	RCALL SUBOPT_0x10
; 0000 02B3        break;
	RJMP _0x71
; 0000 02B4     ///////////////////////////////////////////////////////////////////////////////
; 0000 02B5        case 31: // ПЕРЕВІРКА РОБОТИ ГЕНЕРАТОРА ,ПРОГРІВ
_0xAB:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0xCE
; 0000 02B6             LCD_Clear();
	RCALL _LCD_Clear
; 0000 02B7             if(rotor<3){//ротор зупинився (генератор заглох)
	RCALL SUBOPT_0x1F
	CPI  R26,LOW(0x3)
	BRSH _0xCF
; 0000 02B8                 ON_REL=0;              //вимикаємо запалення
	CBI  0x12,4
; 0000 02B9                 if(KilkistZapuskiv>0){
	RCALL SUBOPT_0x4D
	BRLO _0xD2
; 0000 02BA                     sprintf(buff," ПОВТОРНЫЙ  "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,676
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 02BB                     sprintf(buff,"   ЗАПУСК   "); ShowBigLine(5);
	__POINTW1FN _0x0,689
	RCALL SUBOPT_0x3A
	LDI  R26,LOW(5)
	RCALL _ShowBigLine
; 0000 02BC                     delay_ms(NEXT_ZAPUSK_SECOND);
	LDI  R26,LOW(20000)
	LDI  R27,HIGH(20000)
	RCALL _delay_ms
; 0000 02BD                       if(KilkistZapuskiv==1){delay_ms(NEXT_ZAPUSK_SECOND);};//якщо остання попитка - то акумулятор відпо ...
	RCALL SUBOPT_0x4D
	BRNE _0xD3
	LDI  R26,LOW(20000)
	LDI  R27,HIGH(20000)
	RCALL _delay_ms
_0xD3:
; 0000 02BE                       PositionPointer=30;
	LDI  R30,LOW(30)
	RCALL SUBOPT_0x10
; 0000 02BF                 }
; 0000 02C0                 else  //кількість запусків вичерпана
	RJMP _0xD4
_0xD2:
; 0000 02C1                 {
; 0000 02C2                     PositionPointer=40;     //переходимо на аварію "генератор не запустився"
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x10
; 0000 02C3                     Klapan_off();
	RCALL _Klapan_off
; 0000 02C4                     goto begin;
	RJMP _0x80
; 0000 02C5                 };
_0xD4:
; 0000 02C6             }
; 0000 02C7             else //Генератор запустився, чекаємо підключення нагрузки
	RJMP _0xD5
_0xCF:
; 0000 02C8             {
; 0000 02C9                 if(T<TminN){
	LDS  R30,_TminN_G000
	RCALL SUBOPT_0x34
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0xD6
; 0000 02CA                         temp=t5;     // Мінімальний час до підключення нагрузки
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x42
; 0000 02CB                         while (temp!=0)
_0xD7:
	RCALL SUBOPT_0x43
	BREQ _0xD9
; 0000 02CC                         { //якщо генератор запустився , то чекаємо (Мінімальний час до підключення нагрузки)
; 0000 02CD                             sprintf(buff,"ПРОГРЕВ:%2.uc ",temp); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,620
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x4F
; 0000 02CE                             delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 02CF                             temp--;
	RCALL SUBOPT_0x2D
; 0000 02D0                         };
	RJMP _0xD7
_0xD9:
; 0000 02D1                  };
_0xD6:
; 0000 02D2                  //ТУТ!!! Можна підключити генератор  (температура нормальна, або час витримано)
; 0000 02D3                  //але лише якщо вхідний автомат влючений, та генератор видае напругу
; 0000 02D4                 ///////////////////////////////////
; 0000 02D5                  if(GEN_OUT_PIN==1){ //на виході генератора немає напруги?  (лінія інверсна: 0 - напруга Є)
	SBIS 0x10,0
	RJMP _0xDA
; 0000 02D6                         ON_REL=0;              //вимикаємо запалення
	RCALL SUBOPT_0x52
; 0000 02D7                         PositionPointer=41;     //переходимо на аварію "генератор не видае напруги"
; 0000 02D8                         Klapan_off();
; 0000 02D9                         enter=2;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x19
; 0000 02DA                         goto begin;
	RJMP _0x80
; 0000 02DB                  };
_0xDA:
; 0000 02DC                  PerehodNaGenerator();  //підключення нагрузки на генератор
	RCALL _PerehodNaGenerator
; 0000 02DD                  PositionPointer=32; // Робочий режим
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x10
; 0000 02DE //                 TimeSec=podsvet; PORTD.7=1; //вмикаємо підсвічування ЖКІ та переходимо до РОБОТИ
; 0000 02DF             };
_0xD5:
; 0000 02E0        break;
	RJMP _0x71
; 0000 02E1     ///////////////////////////////////////////////////////////////////////////////
; 0000 02E2         case 32:  // РОБОТА (РУЧНА або АВТОМАТИЧНА)
_0xCE:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0xDD
; 0000 02E3             sprintf(buff,"  РАБОТА   ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,702
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 02E4             MainInfo();
	RCALL _MainInfo
; 0000 02E5 
; 0000 02E6             if(AvtRu==0)//якщо робота АВТОМАТИЧНА то потрібен контроль появи струму!!
	RCALL SUBOPT_0x53
	BRNE _0xDE
; 0000 02E7             {
; 0000 02E8 //!!!ПОМЕНЯТЬ
; 0000 02E9                 if((U1>150)&&(U1<250))
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x97)
	LDI  R30,HIGH(0x97)
	CPC  R27,R30
	BRLO _0xE0
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0xFA)
	LDI  R30,HIGH(0xFA)
	CPC  R27,R30
	BRLO _0xE1
_0xE0:
	RJMP _0xDF
_0xE1:
; 0000 02EA                 {   //напруга в мережі з'явилась?
; 0000 02EB                     ///////////////////////////////////
; 0000 02EC                     temp=t2;        // загружаємо затримку переходу на основну мережу
	LDS  R30,_t2_G000
	RCALL SUBOPT_0x42
; 0000 02ED                     while (temp!=0) // ждем, вдруг сеть пропадет снова?
_0xE2:
	RCALL SUBOPT_0x43
	BREQ _0xE4
; 0000 02EE                     {
; 0000 02EF                         sprintf(buff," СЕТЬ НОРМА "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,714
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 02F0                         sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
	RCALL SUBOPT_0x45
; 0000 02F1                         delay_ms(ONE_SECOND);
; 0000 02F2                         temp--;
	RCALL SUBOPT_0x2D
; 0000 02F3                     }
	RJMP _0xE2
_0xE4:
; 0000 02F4 //!!!ПОМЕНЯТЬ
; 0000 02F5 /*2.2*/             if ((U1>140)&&(U1<255)){PositionPointer=33;enter=2;goto begin;}  //напруга все ще є?,тоді перехід.
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x8D)
	LDI  R30,HIGH(0x8D)
	CPC  R27,R30
	BRLO _0xE6
	RCALL SUBOPT_0x54
	BRLO _0xE7
_0xE6:
	RJMP _0xE5
_0xE7:
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x13
	RJMP _0x80
; 0000 02F6                 }
_0xE5:
; 0000 02F7             }
_0xDF:
; 0000 02F8             else // ручная работа- тогда останов кнопкой!
	RJMP _0xE8
_0xDE:
; 0000 02F9             {
; 0000 02FA                 if(enter>GO_TO_OPTIONS){PositionPointer=33;enter=2;};
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0x15)
	BRLO _0xE9
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x13
_0xE9:
; 0000 02FB             }
_0xE8:
; 0000 02FC 
; 0000 02FD             if(GEN_OUT_PIN==1){ //на виході генератора зникла напруга?  (лінія інверсна: 0 - напруга Є)
	SBIS 0x10,0
	RJMP _0xEA
; 0000 02FE                     PerehodNaMereju();
	RCALL _PerehodNaMereju
; 0000 02FF                     ON_REL=0;              //вимикаємо запалення
	RCALL SUBOPT_0x52
; 0000 0300                     PositionPointer=41;     //переходимо на аварію "генератор не видае напруги"
; 0000 0301                     Klapan_off();
; 0000 0302                     enter=2;
	RCALL SUBOPT_0x1E
; 0000 0303                     LCD_Clear();
; 0000 0304             };
_0xEA:
; 0000 0305         break;
	RJMP _0x71
; 0000 0306     ///////////////////////////////////////////////////////////////////////////////
; 0000 0307         case 33:  // ОСТАНОВ С ОХЛАЖДЕНИЕМ
_0xDD:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0xED
; 0000 0308             sprintf(buff,"  ОСТАНОВ  ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,727
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 0309             PerehodNaMereju();
	RCALL _PerehodNaMereju
; 0000 030A             delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 030B             ///////////////////////////////////
; 0000 030C             temp=t5;    //загружаємо час охолодження
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x42
; 0000 030D             while (temp!=0) // ждем, вдруг сеть пропадет снова?
_0xEE:
	RCALL SUBOPT_0x43
	BREQ _0xF0
; 0000 030E             {
; 0000 030F                 sprintf(buff," ОХЛАЖДЕНИЕ "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,739
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 0310                 sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
	RCALL SUBOPT_0x45
; 0000 0311                 delay_ms(ONE_SECOND);
; 0000 0312                 temp--;
	RCALL SUBOPT_0x2D
; 0000 0313                 if(AvtRu==0)
	RCALL SUBOPT_0x53
	BRNE _0xF1
; 0000 0314                 { //якщо робота АВТОМАТИЧНА то потрібен контроль ЗНИКНЕННЯ струму!!
; 0000 0315                     if ((U1<140)||(U1>265))
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x8C)
	LDI  R30,HIGH(0x8C)
	CPC  R27,R30
	BRLO _0xF3
	RCALL SUBOPT_0x41
	BRLO _0xF2
_0xF3:
; 0000 0316                     {  //напруга в мережі знову зникла
; 0000 0317                         sprintf(buff,"  HET CETИ! "); ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,213
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 0318                         sprintf(buff,"    %3.uc   ",temp);ShowBigLine(5);
	RCALL SUBOPT_0x45
; 0000 0319                         delay_ms(ONE_SECOND);
; 0000 031A                         PerehodNaGenerator();  //підключення нагрузки на генератор
	RCALL _PerehodNaGenerator
; 0000 031B                         PositionPointer=32; // перехід у "Робочий режим"
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x13
; 0000 031C                         enter=2; goto begin;
	RJMP _0x80
; 0000 031D                     }
; 0000 031E                 }
_0xF2:
; 0000 031F             }
_0xF1:
	RJMP _0xEE
_0xF0:
; 0000 0320            //////////////////////////////////
; 0000 0321             Klapan_off();
	RCALL _Klapan_off
; 0000 0322             //////////////////////////////////
; 0000 0323             if(AvtRu==0) //для автоматичного режиму - повернення у режим АВТОМАТ  иначе в ИНФО
	RCALL SUBOPT_0x53
	BRNE _0xF5
; 0000 0324             {
; 0000 0325                 PositionPointer=1;
	LDI  R30,LOW(1)
	RJMP _0x119
; 0000 0326             }
; 0000 0327             else
_0xF5:
; 0000 0328             {
; 0000 0329                 PositionPointer=3;
	LDI  R30,LOW(3)
_0x119:
	STS  _PositionPointer_G000,R30
; 0000 032A             }
; 0000 032B             ON_REL=0;//вимикаємо запалення
	CBI  0x12,4
; 0000 032C             goto begin;
	RJMP _0x80
; 0000 032D         break;
; 0000 032E     ///////////////////////////////////////////////////////////////////////////////
; 0000 032F 
; 0000 0330         case 40: // АВАРИЯ ГЕНЕРАТОР НЕ ЗАПУСТИЛСЯ
_0xED:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0xF9
; 0000 0331             sprintf(buff,"(!) ОШИБКА ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,752
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 0332             sprintf(buff," НЕ ЗАПУСК ");            ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,764
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 0333 //            sprintf(buff,"      ДЛЯ СБРОСА      "); ShowLine(INFOLINE1);
; 0000 0334 //            sprintf(buff,"   УДЕРЖИВАЙ  'ВВОД'  "); ShowLine(INFOLINE2);
; 0000 0335             sprintf(buff,"  ДЛЯ СБРОСА >'ВВОД'  "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,776
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 0336             delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 0337             LCD_Blinc(QUARTER_SECOND,3);
	RCALL SUBOPT_0x3C
; 0000 0338             if(enter>GO_TO_OPTIONS){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear();}
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0x15)
	BRLO _0xFA
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x1E
; 0000 0339         break;
_0xFA:
	RJMP _0x71
; 0000 033A     ///////////////////////////////////////////////////////////////////////////////
; 0000 033B         case 41: // АВАРИЯ НЕТ ТОКА ОТ ГЕНЕРАТОРА
_0xF9:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0xFB
; 0000 033C             sprintf(buff,"(!) ОШИБКА ");            ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,752
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 033D             sprintf(buff," НЕТ ТОКА  ");            ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,799
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 033E             sprintf(buff,"  ДЛЯ СБРОСА >'ВВОД'  "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,776
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x36
; 0000 033F             delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 0340             LCD_Blinc(QUARTER_SECOND,3);
	RCALL SUBOPT_0x3C
; 0000 0341             if(enter>GO_TO_OPTIONS){PositionPointer=LAST_MODE_MENU;enter=2;LCD_Clear();}
	RCALL SUBOPT_0x17
	CPI  R26,LOW(0x15)
	BRLO _0xFC
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x1E
; 0000 0342         break;
_0xFC:
	RJMP _0x71
; 0000 0343     ///////////////////////////////////////////////////////////////////////////////
; 0000 0344         case 42: // АВАРИЯ НЕТ ТОКА ОТ ГЕНЕРАТОРА
_0xFB:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x71
; 0000 0345             LINE_REL=1;  // відключаємо МЕРЕЖУ     !!!
	SBI  0x12,3
; 0000 0346             GEN_REL=0;  // відключаємо ГЕНЕРАТОР
	CBI  0x12,2
; 0000 0347             ON_REL =0;  //вимикаємо: запалення OUT7
	CBI  0x12,4
; 0000 0348             VALVE_U_REL=0;  //заслонку OUT5 (Port4)
	CBI  0x12,6
; 0000 0349             VALVE_D_REL=0;
	CBI  0x12,7
; 0000 034A             STARTER_REL=0;  //вимикаємо стартер OUT6
	CBI  0x18,0
; 0000 034B 
; 0000 034C 
; 0000 034D 
; 0000 034E             sprintf(buff,"(!) ЗАЩИТА ");        ShowBigLine(0);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,811
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x3B
; 0000 034F             if(U1<255){
	RCALL SUBOPT_0x54
	BRSH _0x10A
; 0000 0350             sprintf(buff," Uin =%4.uB",U1);     ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,823
	RCALL SUBOPT_0x2E
; 0000 0351             sprintf(buff,"  ДЛЯ СБРОСА >'ВВОД'  "); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,776
	RJMP _0x11A
; 0000 0352             }
; 0000 0353             else
_0x10A:
; 0000 0354             {
; 0000 0355             sprintf(buff,"!Uin > 260В!");       ShowBigLine(3);
	RCALL SUBOPT_0x2B
	__POINTW1FN _0x0,835
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x44
; 0000 0356             sprintf(buff,"  ВЫСОКОЕ НАПРЯЖЕНИЕ !"); ShowLine(INFOLINE1);
	__POINTW1FN _0x0,848
_0x11A:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
; 0000 0357 //            sprintf(buff,"       СЕТИ !         "); ShowLine(INFOLINE2);
; 0000 0358             }
; 0000 0359             delay_ms(ONE_SECOND);
	RCALL SUBOPT_0x4E
; 0000 035A             LCD_Blinc(QUARTER_SECOND,3);
	RCALL SUBOPT_0x3C
; 0000 035B             if((U1<255)&(enter>GO_TO_OPTIONS)){PositionPointer=LAST_MODE_MENU;PORTD.0=0;enter=2;LCD_Clear();} // PORTD.0 ...
	RCALL SUBOPT_0x40
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RCALL __LTW12U
	MOV  R0,R30
	RCALL SUBOPT_0x17
	LDI  R30,LOW(20)
	RCALL __GTB12U
	AND  R30,R0
	BREQ _0x10C
	RCALL SUBOPT_0xF
	CBI  0x12,0
	RCALL SUBOPT_0x1E
; 0000 035C         break;
_0x10C:
; 0000 035D     ///////////////////////////////////////////////////////////////////////////////
; 0000 035E     };// switch (PositionPointer)
_0x71:
; 0000 035F     begin:
_0x80:
; 0000 0360     } //while
	RJMP _0x68
; 0000 0361 
; 0000 0362 } //main
_0x10F:
	RJMP _0x10F
; .FEND
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL SUBOPT_0x55
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x56
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x57
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x56
	ADIW R26,2
	RCALL SUBOPT_0x27
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	RCALL SUBOPT_0x56
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x27
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x56
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x55
	SBIW R28,12
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ADIW R30,1
	STD  Y+24,R30
	STD  Y+24+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x58
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x58
	RJMP _0x20000E7
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BRNE _0x2000028
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200002C
	LDI  R17,LOW(4)
	RJMP _0x200001B
_0x200002C:
	RJMP _0x200002D
_0x2000028:
	CPI  R30,LOW(0x4)
	BRNE _0x200002F
	CPI  R18,48
	BRLO _0x2000031
	CPI  R18,58
	BRLO _0x2000032
_0x2000031:
	RJMP _0x2000030
_0x2000032:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200001B
_0x2000030:
_0x200002D:
	CPI  R18,108
	BRNE _0x2000033
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001B
_0x2000033:
	RJMP _0x2000034
_0x200002F:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200001B
_0x2000034:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000039
	RCALL SUBOPT_0x59
	RCALL SUBOPT_0x5A
	RCALL SUBOPT_0x59
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x5B
	RJMP _0x200003A
_0x2000039:
	CPI  R30,LOW(0x73)
	BRNE _0x200003C
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x70)
	BRNE _0x200003F
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x5E
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200003D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000041
	CP   R20,R17
	BRLO _0x2000042
_0x2000041:
	RJMP _0x2000040
_0x2000042:
	MOV  R17,R20
_0x2000040:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000043
_0x200003F:
	CPI  R30,LOW(0x64)
	BREQ _0x2000046
	CPI  R30,LOW(0x69)
	BRNE _0x2000047
_0x2000046:
	ORI  R16,LOW(4)
	RJMP _0x2000048
_0x2000047:
	CPI  R30,LOW(0x75)
	BRNE _0x2000049
_0x2000048:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x200004A
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x5F
	LDI  R17,LOW(10)
	RJMP _0x200004B
_0x200004A:
	__GETD1N 0x2710
	RCALL SUBOPT_0x5F
	LDI  R17,LOW(5)
	RJMP _0x200004B
_0x2000049:
	CPI  R30,LOW(0x58)
	BRNE _0x200004D
	ORI  R16,LOW(8)
	RJMP _0x200004E
_0x200004D:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x200008C
_0x200004E:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000050
	__GETD1N 0x10000000
	RCALL SUBOPT_0x5F
	LDI  R17,LOW(8)
	RJMP _0x200004B
_0x2000050:
	__GETD1N 0x1000
	RCALL SUBOPT_0x5F
	LDI  R17,LOW(4)
_0x200004B:
	CPI  R20,0
	BREQ _0x2000051
	ANDI R16,LOW(127)
	RJMP _0x2000052
_0x2000051:
	LDI  R20,LOW(1)
_0x2000052:
	SBRS R16,1
	RJMP _0x2000053
	RCALL SUBOPT_0x5C
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x20000E8
_0x2000053:
	SBRS R16,2
	RJMP _0x2000055
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5D
	RCALL __CWD1
	RJMP _0x20000E8
_0x2000055:
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5D
	CLR  R22
	CLR  R23
_0x20000E8:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x2000057
	LDD  R26,Y+15
	TST  R26
	BRPL _0x2000058
	__GETD1S 12
	RCALL __ANEGD1
	RCALL SUBOPT_0x60
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x2000058:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x2000059
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200005A
_0x2000059:
	ANDI R16,LOW(251)
_0x200005A:
_0x2000057:
	MOV  R19,R20
_0x2000043:
	SBRC R16,0
	RJMP _0x200005B
_0x200005C:
	CP   R17,R21
	BRSH _0x200005F
	CP   R19,R21
	BRLO _0x2000060
_0x200005F:
	RJMP _0x200005E
_0x2000060:
	SBRS R16,7
	RJMP _0x2000061
	SBRS R16,2
	RJMP _0x2000062
	ANDI R16,LOW(251)
	LDD  R18,Y+17
	SUBI R17,LOW(1)
	RJMP _0x2000063
_0x2000062:
	LDI  R18,LOW(48)
_0x2000063:
	RJMP _0x2000064
_0x2000061:
	LDI  R18,LOW(32)
_0x2000064:
	RCALL SUBOPT_0x58
	SUBI R21,LOW(1)
	RJMP _0x200005C
_0x200005E:
_0x200005B:
_0x2000065:
	CP   R17,R20
	BRSH _0x2000067
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000068
	RCALL SUBOPT_0x61
	CPI  R21,0
	BREQ _0x2000069
	SUBI R21,LOW(1)
_0x2000069:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000068:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL SUBOPT_0x5B
	CPI  R21,0
	BREQ _0x200006A
	SUBI R21,LOW(1)
_0x200006A:
	SUBI R20,LOW(1)
	RJMP _0x2000065
_0x2000067:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x200006B
_0x200006C:
	CPI  R19,0
	BREQ _0x200006E
	SBRS R16,3
	RJMP _0x200006F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000070
_0x200006F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000070:
	RCALL SUBOPT_0x58
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
	SUBI R19,LOW(1)
	RJMP _0x200006C
_0x200006E:
	RJMP _0x2000072
_0x200006B:
_0x2000074:
	RCALL SUBOPT_0x62
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000076
	SBRS R16,3
	RJMP _0x2000077
	SUBI R18,-LOW(55)
	RJMP _0x2000078
_0x2000077:
	SUBI R18,-LOW(87)
_0x2000078:
	RJMP _0x2000079
_0x2000076:
	SUBI R18,-LOW(48)
_0x2000079:
	SBRC R16,4
	RJMP _0x200007B
	CPI  R18,49
	BRSH _0x200007D
	RCALL SUBOPT_0x63
	__CPD2N 0x1
	BRNE _0x200007C
_0x200007D:
	RJMP _0x200007F
_0x200007C:
	CP   R20,R19
	BRSH _0x20000E9
	CP   R21,R19
	BRLO _0x2000082
	SBRS R16,0
	RJMP _0x2000083
_0x2000082:
	RJMP _0x2000081
_0x2000083:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000084
_0x20000E9:
	LDI  R18,LOW(48)
_0x200007F:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000085
	RCALL SUBOPT_0x61
	CPI  R21,0
	BREQ _0x2000086
	SUBI R21,LOW(1)
_0x2000086:
_0x2000085:
_0x2000084:
_0x200007B:
	RCALL SUBOPT_0x58
	CPI  R21,0
	BREQ _0x2000087
	SUBI R21,LOW(1)
_0x2000087:
_0x2000081:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x62
	RCALL __MODD21U
	RCALL SUBOPT_0x60
	LDD  R30,Y+16
	RCALL SUBOPT_0x63
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x5F
	__GETD1S 8
	RCALL __CPD10
	BREQ _0x2000075
	RJMP _0x2000074
_0x2000075:
_0x2000072:
	SBRS R16,0
	RJMP _0x2000088
_0x2000089:
	CPI  R21,0
	BREQ _0x200008B
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x5B
	RJMP _0x2000089
_0x200008B:
_0x2000088:
_0x200008C:
_0x200003A:
_0x20000E7:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,26
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x64
	SBIW R30,0
	BRNE _0x200008D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x200008D:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x64
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x2
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x55
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x55
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_buff_G000:
	.BYTE 0x1E

	.ESEG
_Termo:
	.DB  0xAF,0xAA,0x9B,0x91
	.DB  0x87,0x82,0x7D,0x78
	.DB  0x75,0x73,0x70,0x6E
	.DB  0x6B,0x69,0x68,0x66
	.DB  0x64,0x63,0x62,0x60
	.DB  0x5F,0x5E,0x5D,0x5B
	.DB  0x5A,0x59,0x58,0x57
	.DB  0x56,0x55,0x54,0x54
	.DB  0x53,0x52,0x52,0x51
	.DB  0x50,0x50,0x4F,0x4E
	.DB  0x4E,0x4D,0x4D,0x4C
	.DB  0x4C,0x4B,0x4B,0x4A
	.DB  0x4A,0x49,0x48,0x48
	.DB  0x47,0x47,0x46,0x46
	.DB  0x45,0x45,0x44,0x44
	.DB  0x44,0x43,0x43,0x43
	.DB  0x42,0x42,0x41,0x41
	.DB  0x41,0x40,0x40,0x40
	.DB  0x3F,0x3F,0x3F,0x3E
	.DB  0x3E,0x3E,0x3D,0x3D
	.DB  0x3D,0x3C,0x3C,0x3C
	.DB  0x3C,0x3B,0x3B,0x3B
	.DB  0x3A,0x3A,0x3A,0x3A
	.DB  0x39,0x39,0x39,0x38
	.DB  0x38,0x38,0x37,0x37
	.DB  0x37,0x37,0x37,0x36
	.DB  0x36,0x36,0x36,0x35
	.DB  0x35,0x35,0x35,0x35
	.DB  0x34,0x34,0x34,0x34
	.DB  0x33,0x33,0x33,0x33
	.DB  0x32,0x32,0x32,0x32
	.DB  0x31,0x31,0x31,0x31
	.DB  0x31,0x31,0x30,0x30
	.DB  0x30,0x30,0x30,0x2F
	.DB  0x2F,0x2F,0x2F,0x2F
	.DB  0x2F,0x2E,0x2E,0x2E
	.DB  0x2E,0x2E,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2C
	.DB  0x2C,0x2C,0x2C,0x2C
	.DB  0x2C,0x2B,0x2B,0x2B
	.DB  0x2B,0x2B,0x2B,0x2B
	.DB  0x2A,0x2A,0x2A,0x2A
	.DB  0x2A,0x29,0x29,0x29
	.DB  0x29,0x29,0x29,0x28
	.DB  0x28,0x28,0x28,0x28
	.DB  0x28,0x27,0x27,0x27
	.DB  0x27,0x27,0x27,0x27
	.DB  0x26,0x26,0x26,0x26
	.DB  0x26,0x26,0x26,0x25
	.DB  0x25,0x25,0x25,0x25
	.DB  0x25,0x25,0x24,0x24
	.DB  0x24,0x24,0x24,0x23
	.DB  0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x22,0x22
	.DB  0x22,0x22,0x22,0x22
	.DB  0x22,0x21,0x21,0x21
	.DB  0x21,0x21,0x21,0x21
	.DB  0x21,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20
	.DB  0x1F,0x1F,0x1F,0x1F
	.DB  0x1F,0x1F,0x1F,0x1E
	.DB  0x1E,0x1E,0x1E,0x1E
	.DB  0x1E,0x1E,0x1E,0x1D
	.DB  0x1D,0x1D,0x14,0x14
_typeEEP:
	.DB  0x0
_t1EEP:
	.DB  0xA
_t2EEP:
	.DB  0xA
_t3EEP:
	.DB  0x6
_t4EEP:
	.DB  0x8
_t5EEP:
	.DB  0x5
_TminZEEP:
	.DB  0x14
_TminNEEP:
	.DB  0x32
_Z_EEP:
	.DB  0x0
_R_EEP:
	.DB  0x0
_KilkistZapuskiv_EEP:
	.DB  0x3
_NarabotkaEEP:
	.DB  0x0,0x0
_TO_EEP:
	.DB  0x1

	.DSEG
_type_G000:
	.BYTE 0x1
_t1_G000:
	.BYTE 0x1
_t2_G000:
	.BYTE 0x1
_t3_G000:
	.BYTE 0x1
_t4_G000:
	.BYTE 0x1
_t5_G000:
	.BYTE 0x1
_TminZ_G000:
	.BYTE 0x1
_TminN_G000:
	.BYTE 0x1
_KilkistZapuskiv_G000:
	.BYTE 0x1
_AvtRu_G000:
	.BYTE 0x1
_up_G000:
	.BYTE 0x1
_down_G000:
	.BYTE 0x1
_enter_G000:
	.BYTE 0x1
_PositionPointer_G000:
	.BYTE 0x1
_podsvet_G000:
	.BYTE 0x1
_U_Bat_G000:
	.BYTE 0x2
_U1_G000:
	.BYTE 0x2
_T_G000:
	.BYTE 0x2
_rotor_G000:
	.BYTE 0x1
_interrapt_counter_G000:
	.BYTE 0x2
_second_counter_G000:
	.BYTE 0x1
_minut_counter_G000:
	.BYTE 0x2
_temp_G000:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x1:
	RCALL _LCD_Commmand
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 137 TIMES, CODE SIZE REDUCTION:134 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL _LCD_Mode
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDD  R26,Y+1
	RCALL _LCD_Goto
	LDI  R30,LOW(_buff_G000)
	LDI  R31,HIGH(_buff_G000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	RCALL _LCD_Goto
	LDI  R30,LOW(_buff_G000)
	LDI  R31,HIGH(_buff_G000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	LDS  R26,_PositionPointer_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x7:
	LDS  R26,_up_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(1)
	RCALL __EQB12
	MOV  R0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x7
	LDI  R30,LOW(10)
	RCALL __GTB12U
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDS  R30,_PositionPointer_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	SUBI R30,-LOW(1)
	STS  _PositionPointer_G000,R30
	LDI  R30,LOW(2)
	STS  _up_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xC:
	LDS  R26,_down_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0xC
	LDI  R30,LOW(10)
	RCALL __GTB12U
	OR   R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xA
	SUBI R30,LOW(1)
	STS  _PositionPointer_G000,R30
	LDI  R30,LOW(2)
	STS  _down_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(3)
	STS  _PositionPointer_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	STS  _PositionPointer_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x11:
	LDS  R26,_enter_G000
	LDI  R30,LOW(20)
	RCALL __GTB12U
	MOV  R0,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x12:
	RCALL __EQB12
	AND  R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x10
	LDI  R30,LOW(2)
	STS  _enter_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_KilkistZapuskiv_EEP)
	LDI  R27,HIGH(_KilkistZapuskiv_EEP)
	RCALL __EEPROMRDB
	STS  _KilkistZapuskiv_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x7
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0xC
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDS  R26,_enter_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	EOR  R2,R30
	LDI  R30,LOW(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x19:
	STS  _enter_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDS  R30,_t4_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDS  R30,_t5_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDS  R30,_TminZ_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDS  R30,_KilkistZapuskiv_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x19
	RJMP _LCD_Clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDS  R26,_rotor_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	STS  _up_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(60)
	STS  _podsvet_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	STS  _down_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	STS  _U1_G000,R30
	STS  _U1_G000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	STS  _T_G000,R30
	STS  _T_G000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
	LDS  R30,_T_G000
	LDS  R31,_T_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_TO_EEP)
	LDI  R27,HIGH(_TO_EEP)
	RCALL __EEPROMRDB
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x27:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x29:
	STS  _temp_G000,R30
	STS  _temp_G000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x2A:
	LDS  R30,_temp_G000
	LDS  R31,_temp_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 66 TIMES, CODE SIZE REDUCTION:128 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(_buff_G000)
	LDI  R31,HIGH(_buff_G000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2A
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(5)
	RCALL _ShowBigLine
	LDI  R26,LOW(4000)
	LDI  R27,HIGH(4000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_temp_G000)
	LDI  R27,HIGH(_temp_G000)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2E:
	RCALL SUBOPT_0x2
	LDS  R30,_U1_G000
	LDS  R31,_U1_G000+1
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(3)
	RCALL _ShowBigLine
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2F:
	LDS  R26,_U_Bat_G000
	LDS  R27,_U_Bat_G000+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	RCALL __DIVW21U
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x31:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:80 WORDS
SUBOPT_0x32:
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(_NarabotkaEEP)
	LDI  R27,HIGH(_NarabotkaEEP)
	RCALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	LDS  R26,_T_G000
	LDS  R27,_T_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x35:
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(6)
	RJMP _ShowLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	STS  _t4_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	STS  _t5_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	STS  _TminZ_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0x2
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(0)
	RJMP _ShowBigLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(3)
	RJMP _LCD_Blinc

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(_NarabotkaEEP)
	LDI  R27,HIGH(_NarabotkaEEP)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	RCALL __EQW12
	OR   R0,R30
	MOVW R30,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3F:
	LDI  R30,LOW(2)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x40:
	LDS  R26,_U1_G000
	LDS  R27,_U1_G000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0x10A)
	LDI  R30,HIGH(0x10A)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	LDI  R31,0
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x2A
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(3)
	RCALL _ShowBigLine
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x45:
	__POINTW1FN _0x0,226
	RJMP SUBOPT_0x2C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x46:
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x10
	RCALL _Klapan_off
	SBI  0x12,3
	RJMP _LCD_Clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x47:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x48:
	RCALL SUBOPT_0x7
	LDI  R30,LOW(10)
	RCALL __GTB12U
	OR   R0,R30
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x49:
	RCALL SUBOPT_0xC
	LDI  R30,LOW(10)
	RCALL __GTB12U
	OR   R0,R30
	LDI  R26,0
	SBRC R2,3
	LDI  R26,1
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	LDI  R30,LOW(2)
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	STS  _KilkistZapuskiv_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4C:
	LDS  R26,_KilkistZapuskiv_G000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x4C
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(4000)
	LDI  R27,HIGH(4000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(3)
	RJMP _ShowBigLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x50:
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x34
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x51:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2A
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	CBI  0x12,4
	LDI  R30,LOW(41)
	RCALL SUBOPT_0x10
	RJMP _Klapan_off

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	LDS  R30,_AvtRu_G000
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x40
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x57:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x58:
	ST   -Y,R18
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x59:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5A:
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5B:
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5C:
	RCALL SUBOPT_0x59
	RJMP SUBOPT_0x5A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5D:
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	RJMP SUBOPT_0x57

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5F:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x62:
	__GETD1S 8
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=5
	.equ __i2c_port=0x18 ;PORTB
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,3
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,7
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F4
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__LEB12U:
	CP   R30,R26
	LDI  R30,1
	BRSH __LEB12U1
	CLR  R30
__LEB12U1:
	RET

__GEB12U:
	CP   R26,R30
	LDI  R30,1
	BRSH __GEB12U1
	CLR  R30
__GEB12U1:
	RET

__GTB12U:
	CP   R30,R26
	LDI  R30,1
	BRLO __GTB12U1
	CLR  R30
__GTB12U1:
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__LTW12U:
	CP   R26,R30
	CPC  R27,R31
	LDI  R30,1
	BRLO __LTW12UT
	CLR  R30
__LTW12UT:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
