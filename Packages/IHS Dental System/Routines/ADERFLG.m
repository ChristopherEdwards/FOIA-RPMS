ADERFLG ; IHS/HQT/MJL  - RESET DENTAL EXTRACT FLAG ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;ORIG (ADEXFLGR) MLQ/DM-DPSB
 W !!,"This routine (ADERFLG) should not be entered at the top.",!!
 Q
RESETA ; THIS ENTRY POINT WILL CLEAR DPSC FLAG IN ALL RECORDS
 ; Entry point not called from within dental package.  For programmer
 ; diagnostic and troubleshooting use only.
 D ^XBKVAR
 W !!,"This will clear date stamps for ALL records from which data has been extracted.",!
ASK ;
 R "Ok to continue? N// ",X:DTIME S:'$T X="^" S X=$E(X_"N")
 I X["?" W !,"Records from which data has been extracted are marked with the date the",!,"extraction was performed so that they will not be processed again for",!,"transmission to Area/DPSB. You will lose that indicator if you proceed.",! G ASK
 I "Yy"'[X W " -- reset canceled",! Q
 W !,"Beginning reset.",!
 F %=0:0 S ADERDV=$O(^ADEPCD("AI",0)) Q:ADERDV=""  W ADERDV," " D RESET2
 W "Done!",!
 Q
 ;
RESET1 ; THIS ENTRY POINT WILL ASK FOR A DATE FOR WHICH THE
 ; DPSC FLAG IS TO BE RESET
 ; Entry point not called from within dental package.  For programmer
 ; diagnostic and troubleshooting use only.
 D ^XBKVAR
 S %DT="EX"
 R "Date for which DPSC flag is to be reset: ",X:DTIME
 Q:'$T
 Q:X=""!(X["^")
 I X["?" W !,"Dates of prior extractions:",! X "S ADED=0 F  S ADED=$O(^ADEPCD(""AI"",ADED)) Q:'+ADED  W ?3,$E(ADED,4,5),""-"",$E(ADED,6,7),""-"",$E(ADED,2,3),!" G RESET1
 D ^%DT W !
 Q:Y<0
 S ADERDV=Y
 D RESET2
 Q
 ;
RESET2 ;EP
 ; THIS ENTRY EXPECTS ADERDV AND REMOVES THE CORRESPONDING
 ; EXTRACT FLAGS - Called by "Re-extraction" process of ADEXSU
 N DA,DIE,DR
 Q:'$D(ADERDV)
 W !,"Please wait..."
 S DIE="^ADEPCD(",DA=0,DR="5///@"
 F  S DA=$O(^ADEPCD("AI",ADERDV,DA)) Q:'+DA  D
 . ;D ^DIE
 . S $P(^ADEPCD(DA,0),U,6)=""
 . K ^ADEPCD("AI",ADERDV,DA)
 ;
 W ADERDV," Reset.",!
 K ADERDV
 Q
