ADEKNT5 ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
QTR(ADEDT) ;EP
 ;Return "YEAR.QUARTER^END DATE^3-YEAR BEGIN^1-YEAR BEGIN^QUARTER BEGIN"
 ;Where 3-YEAR BEGIN is beginning date of the 3-year period
 ;which ends at END DATE
 ;and immediately precedes ADEDT
 ;
 N ADEMON,ADEQTR,ADEYR,ADEQY,ADEDA,ADEEND,ADEQB,ADE1B,ADE3B
 ;Compute Year.Quarter ADEQY and End Date ADEEND
 ;
 S ADEMON=+$E(ADEDT,4,5)
 S ADEQTR=$S(ADEMON<4:4,ADEMON<7:1,ADEMON<10:2,1:3) ;Last Qtr
 ;beginning Y2K fix
 ;S ADEYR=$E(ADEDT,2,3)
 S ADEYR=$E(ADEDT,1,3)+1700  ;Y2000
 ;end Y2K fix block
 S:ADEQTR=4 ADEYR=ADEYR-1 ;Year of last qtr
 S ADEQY=ADEYR_"."_ADEQTR
 S ADEDA=$S(ADEQTR=1:31,ADEQTR=4:31,1:30) ;Day of last qtr
 S ADEMON=$S(ADEQTR=1:"03",ADEQTR=2:"06",ADEQTR=3:"09",1:12) ;Month 
 ;beginning Y2K fix
 ;S ADEEND=2_ADEYR_ADEMON_ADEDA
 S ADEEND=(ADEYR-1700)_ADEMON_ADEDA  ;Y2000
 ;end Y2K fix block
 ;
 ;Compute Quarter Begin Date ADEQB
 S ADEQB=$E(ADEEND,1,5)_"01"
 S ADEQB=ADEQB-200
 ;
 ;Compute 1-Year Begin Date ADE1B
 ;Add 1 to the end date ADEEND and subtract a year
 ;beginning Y2K fix
 ;S ADEYR=$E(ADEEND,2,3)
 S ADEYR=$E(ADEEND,1,3)  ;Y2000
 ;end Y2K fix block
 S ADEMON=+$E(ADEEND,4,5)
 S ADEMON=ADEMON+1
 S:ADEMON=13 ADEMON=1,ADEYR=ADEYR+1
 ;beginning Y2K fix
 ;S ADEMON="00"_ADEMON
 ;S ADEMON=$E(ADEMON,$L(ADEMON)-1,$L(ADEMON))
 ;S ADE1B=2_ADEYR_ADEMON_"01"
 S ADE1B=ADEYR_$S($L(ADEMON)=1:"0"_ADEMON,1:ADEMON)_"01"  ;Y2000
 ;end Y2K fix block
 S ADE1B=ADE1B-10000
 ;
 ;Compute 3-Year Begin Date ADE3B
 S ADE3B=ADE1B-20000
 ;
 Q ADEQY_U_ADEEND_U_ADE3B_U_ADE1B_U_ADEQB
 ;
PERIOD(ADEYR,ADEQTR)         ;EP
 ;Returns same string as QTR but input is YEAR and QUARTER
 ;i.e., finds the next day after the end of the input Q/Y
 ;and calls QTR to get the beginning and ending dates.
 ;Year is in form YYYY and quarter is 1-4
 N ADEMON,ADEDT
 ;
 ;beginning Y2K fix
 Q:$L(ADEYR)<4 0  ;Y2000
 S ADEMON=$S(ADEQTR=1:"04",ADEQTR=2:"07",ADEQTR=3:10,1:"01")
 S:ADEMON="01" ADEYR=ADEYR+1
 ;S ADEDT=2_ADEYR_ADEMON_"01"
 S ADEDT=(ADEYR-1700)_ADEMON_"01"  ;Y2000
 ;end Y2K fix block
 Q $$QTR(ADEDT)
