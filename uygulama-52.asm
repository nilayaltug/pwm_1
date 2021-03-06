	LIST P=16F877A
	#INCLUDE <P16F877A.INC>
	__CONFIG H'3F31'
	PWM_DEGER EQU 0X18
	DEGER EQU 0X19
	SAYICI1 EQU 0X20
	SAYICI2 EQU 0X21
	ORG 0X000
	GOTO BASLA

BASLA
	BANKSEL ADCON1
	MOVLW 0X06
	MOVWF ADCON1
	BANKSEL PORTA
	CLRF PORTA
	BANKSEL TRISC
	BCF TRISC,2
	BANKSEL TRISA
	MOVLW H'FF'
	MOVWF TRISA
	BANKSEL CCP1CON
	MOVLW B'00001100'
	MOVWF CCP1CON
	BANKSEL CCPR1L
	CLRF CCPR1L
	BANKSEL PR2
	MOVLW D'65'
	MOVWF PR2
	BANKSEL PWM_DEGER
	MOVLW D'0'
	MOVWF PWM_DEGER
	BANKSEL T2CON
	MOVLW B'00000110'
	MOVWF T2CON
	CALL PWM_ISLEM

KONTROL
	BANKSEL PORTA
	BTFSC PORTA,4
	CALL PARLAKLIK_ARTIR
	BTFSC PORTA,5
	CALL PARLAKLIK_AZALT
	GOTO KONTROL

PARLAKLIK_ARTIR
	BANKSEL PWM_DEGER
	MOVLW H'FF'
	SUBWF PWM_DEGER,W
	BTFSS STATUS,C
	CALL PWM_ISLEM
	INCF PWM_DEGER,F
	CALL GECIKME
	RETURN

PARLAKLIK_AZALT
	BANKSEL PWM_DEGER
	MOVF PWM_DEGER,W
	SUBLW D'0'
	BTFSS STATUS,C
	CALL PWM_ISLEM
	DECF PWM_DEGER,F
	CALL GECIKME
	RETURN

GECIKME
	MOVLW 0XFF
	MOVWF SAYICI1

TEKRAR1
	MOVLW 0XFF
	MOVWF SAYICI2

TEKRAR2
	DECFSZ SAYICI2,F
	GOTO TEKRAR2
	DECFSZ SAYICI1,F
	GOTO TEKRAR1
	RETURN

PWM_ISLEM	
	BANKSEL PWM_DEGER
	MOVF PWM_DEGER,W
	BANKSEL DEGER
	ANDLW B'00000011'
	MOVWF DEGER
	SWAPF DEGER,W
	ANDLW B'11110000'
	IORLW B'00001100'
	BANKSEL CCP1CON
	MOVF PWM_DEGER,W
	MOVWF DEGER
	RRF DEGER,F
	RRF DEGER,W
	ANDLW B'00111111'
	MOVWF CCPR1L
	RETURN

END
