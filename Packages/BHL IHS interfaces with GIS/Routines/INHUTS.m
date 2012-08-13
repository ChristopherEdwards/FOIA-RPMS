INHUTS ;JMB; 18 Sep 96 09:35;Monitoring utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
QUIT() ;User presses any key
 ;OUTPUT
 ; function:   1 - time to exit
 ;             0 - continue
 Q:INTASKED 0
 N %,INEXIT S INEXIT=0
 R %#1:0 I $L(%)!$T S INEXIT=1
 Q INEXIT
 ;
FT0(DA) ;Returns formatted date-time
 ;INPUT:
 ; DA  - Date to be formatted in $H format
 ;OUTPUT:
 ; Function value - Time difference in format: 
 ;                  "HH:II:SS", "T-D@HH:MM", "T-DD@HH:MM", etc.
 ;                  (Max length of output string is 10)
 ;
 N H,DIF,INT
 Q:'$L($G(DA)) ""
 S H=$$DATEFMT^UTDT(DA,"@HH:II:SS")
 Q:+DA=+$H $P(H,"@",2)            ;       HH:II:SS
 ;Day difference
 I +$H>+DA S DIF=+$H-(+DA),INT="T-"
 I +$H'>+DA S DIF=(+DA)-(+$H),INT="T+"
 Q:$L(DIF)=1 $E(INT_DIF_H,1,9)   ;   T-D@HH:MM
 Q:$L(DIF)=2 $E(INT_DIF_H,1,10)  ;  T-DD@HH:MM
 Q $E(INT_DIF_H,1,10)            ; T-DDD@HH:M, ...
 ;
FT1(T,FMT) ;Returns formatted date-time
 ;INPUT:
 ;  T - number of seconds
 ;  FMT - format of output
 ;          1 - Exps:  a.- 23 (sec is the default unit);b.- 25m 50s
 ;                     c.- 22h 23m; d.- 98d 14h
 ;              Non-significant time is discarded.
 ;              Max output length is 7 characters.
 ;              Largest output: 99d 23h.
 ;          2 - Exps: a.- 3s; b.- 1.8m (i.e. 1m and 45s); c.- 2.5d
 ;              Returns up to 1 decimal.
 ;              Largest output: 99.9d
 ;OUTPUT:
 ;  Function value - formatted output
 ;
 ;Quit if no input value
 Q:'$L($G(T)) ""
 ;Quit if no valid format number
 Q:";1;2"'[FMT ""
 ;
 N D,H,M,S
 S D=T\86400,H=(T#86400)\3600,M=(T#3600)\60,S=T#60
 Q:FMT=1 $$FM1(D,H,M,S)
 Q:FMT=2 $$FM2(T,D,H,M,S)
 Q
 ;
FM1(D,H,M,S) ;Format type 1
 I 'M,'H,'D Q S            ;ex. 23 (sec is the default unit)
 I 'H,'D Q M_"m "_S_"s"    ;ex. 25m 50s
 I 'D Q H_"h "_M_"m"       ;ex. 22h 23m
 I D<100 Q D_"d "_H_"h"    ;ex. 98d 14h
 Q "xxx"                   ;Overflow
 ;
FM2(T,D,H,M,S) ;Format type 2
 ;
 ;Overflow
 I D>99 Q "xxx"
 ;Days, exp. 2.5d
 I D S D=T/86400 S:$P(D,".",2) D=$J(D,"",1) S D=D_"d" Q D
 ;Hours, ex. 3.1h
 I H S H=T/3600 S:$P(H,".",2) H=$J(H,"",1) S H=H_"h" Q H
 ;Minutes, ex. 1.8m
 I M S M=T/60 S:$P(M,".",2) M=$J(M,"",1) S M=M_"m" Q M
 ;Seconds, exp. 1, 0.6 
 S:$P(S,".",2) S=$J(S,"",1)
 Q S
 ;
TDIF(SAR,SOP,FMT) ;Return time differences (seconds) beween two dates
 ;INPUT:
 ;  SAR - starting date time (in any format)
 ;  SOP - stop date time (in any format) (def is NOW)
 ;  FMT - format of output
 ;          0 - number of seconds (def)
 ;          1 - formatted output (w/o seconds)
 ;          2 - formatted output (with seconds)
 ;OUTPUT:
 ;  function value - time difference 
 ;         number of seconds or formatted output
 ;
 N TOT
 N SESAR,SESOP,DTSAR,DTSOP,SEOV,SESOPTOT,SESARTOT ;JMB 6/5/95
 ;Quit if no start_date
 Q:'$L($G(SAR)) ""
 ;Set default stop_date to NOW
 S:'$L($G(SOP)) SOP=$H
 ;Convert dates to $H format
 S SAR=$$CONV(SAR),SOP=$$CONV(SOP) Q:'SAR!'SOP ""
 ;Get starting time and ending time
 S SESAR=+$P(SAR,",",2),SESOP=+$P(SOP,",",2)
 ;Get start_day and end_day
 S DTSAR=+SAR,DTSOP=+SOP
 ;Initialize overflow_days_seconds and total_stop_date_seconds
 S SEOV=0,SESOPTOT=0
 ;Set total_start_date_seconds
 S SESARTOT=SESOP-SESAR
 ;If days are not the same calculate seconds for each date
 I DTSAR'=DTSOP D
 .  ;Calculate total_start_date_seconds
 .  S SESARTOT=86400-SESAR
 .  ;Calcualte total_stop_date_seconds
 .  S SESOPTOT=SESOP
 ;Check if days are more than one day apart
 I (DTSOP-DTSAR-1)>0 D
 .  ;Set overlfow_seconds
 .  S SEOV=(DTSOP-DTSAR-1)*86400
 ;Calculate total_seconds
 S TOT=SESARTOT+SESOPTOT+SEOV
 ;Convert to text format
 I $G(FMT) S TOT=$$FORMAT(TOT,$G(FMT))
 Q TOT
 ;
CONV(DATE) ;Convert to $H format
 ;INPUT:
 ;  DATE - in any format
 ;OUTPUT:
 ;  function value - date in $H format or null
 ;
 ;Check for $H format
 Q:DATE?5N.1",".5N DATE
 ;Check for text format
 I DATE'?7N.1".".N S DATE=$$CDATA2F^UTDT(DATE,"TI")
 ;Check for Fileman internal format
 I DATE?7N.1".".N S DATE=$$CDATF2H^UTDT(DATE)
 I DATE<1 S DATE=""
 Q DATE
 ;
FORMAT(T,SEC) ;Convert number of seconds to formatted time
 ;INPUT:
 ;  T - number of seconds
 ;  SEC - display seconds ( 0 - no (def) ; 2 - yes )
 ;OUTPUT:
 ;  function - formatted time ( ex: 2 dy 1 hr 23 min 12 sec )
 ;
 Q:'$L($G(T)) ""
 Q:'T "0 sec"
 N D,H,M,S,TX
 S SEC=$S($G(SEC)>1:1,1:0),TX="",D=T\86400,H=(T#86400)\3600,M=(T#3600)\60,S=T#60
 S:SEC TX=S_" sec "
 S:M!'SEC TX=M_" min "_TX
 S:H!D TX=H_" hr "_TX
 S:D TX=D_" dy "_TX
 Q TX
