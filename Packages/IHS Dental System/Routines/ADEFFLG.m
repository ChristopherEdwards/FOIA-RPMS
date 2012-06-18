ADEFFLG ; IHS/HQT/MJL  - RESET F- EXTRACT FLAG ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 W !!,"This routine (ADEFFLG) should not be entered at the top.",!! Q
RESETA ; THIS ENTRY POINT WILL CLEAR XTRACT FLAG IN ALL FLUORIDE SURVEILLANCE
 ; RECORDS
 D ^XBKVAR
 W !!,"This will clear ALL date stamps from ALL records in the FLUORIDE",!,"SURVEILLANCE file from which data has been extracted.",!,"Stop now if you're not sure what you're doing.",!
ASK ;
 R "Ok to continue? N// ",X:DTIME S:'$T X="^" S X=$E(X_"N")
 I X["?" W !,"Records from which data has been extracted are marked with the date the",!,"extraction was performed so that they will not be processed again for",!,"transmission to Area/DPSB. You will lose that indicator if you proceed.",! G ASK
 I "Yy"'[X W " -- reset canceled",! Q
 W !,"Beginning reset.",!
 F %=0:0 S ADEFDV=$O(^ADEFLU("AC",0)) Q:ADEFDV=""  W ADEFDV," " D RESET2
 W "Done!",!
 Q
 ;
RESET1 ; THIS ENTRY POINT WILL ASK FOR A DATE FOR WHICH THE
 ; XTRACT FLAG IS TO BE RESET
 ; Entry point not called from within dental package.  For programmer
 ; diagnostic and troubleshooting use only.
 D ^XBKVAR
 S %DT="EX"
 R "Date for which DPSC flag is to be reset: ",X:DTIME
 Q:'$T
 Q:X=""!(X["^")
 I X["?" W !,"Dates of prior extractions:",! X "S ADED=0 F  S ADED=$O(^ADEFLU(""AC"",ADED)) Q:'+ADED  W ?3,$E(ADED,4,5),""-"",$E(ADED,6,7),""-"",$E(ADED,2,3),!" G RESET1
 D ^%DT W !
 Q:Y<0
 S ADEFDV=Y
 D RESET2
 Q
 ;
RESET2 ;EP
 ; THIS ENTRY EXPECTS ADEFDV AND RESETS THE CORRESPONDING
 ; FLAGS
 Q:'$D(ADEFDV)
 F ADEA=0:0 S ADEA=$O(^ADEFLU(ADEA)) Q:'+ADEA  F ADEB=0:0 S ADEB=$O(^ADEFLU(ADEA,1,ADEB)) Q:'+ADEB  I $D(^ADEFLU(ADEA,1,ADEB,0)) S ADED=$P(^(0),U,5) I ADED=ADEFDV S $P(^(0),U,5)="" K ^ADEFLU("AC",ADED,ADEA,ADEB)
 W ADEFDV," Reset.",!
 K ADEA,ADEB,ADED,ADEFDV
 Q
