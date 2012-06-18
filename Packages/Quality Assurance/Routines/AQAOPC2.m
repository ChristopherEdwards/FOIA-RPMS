AQAOPC2 ; IHS/ORDC/LJF - OCC BY INDICATOR & ICD CODES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;this rtn contains the user interface for the trending report for
 ;occurrences by diagnosis and procedure codes.
 ;
 D ICD^AQAOHOP2 ;intro text
TYPE ; >>> ask user what type of report to print
 K DIR S DIR(0)="SO^L:LISTING PLUS STATISTICS;S:STATISTICS ONLY"
 S DIR("A")="Choose TYPE of report to print"
 S DIR("?",1)="Which report style do you want?"
 S DIR("?",2)="     Enter L to list occurrences PLUS subtotals"
 S DIR("?",3)="     Enter S to print the subtotals ONLY"
 S DIR("?")="For more information on these styles, see the User Manual."
 D ^DIR G END:$D(DIRUT) S AQAOTYPE=Y
 ;
IND ; >>> occurrences for which indicator?
 S AQAOIND=$$IND^AQAOLKP G END:AQAOIND=U,TYPE:AQAOIND=-1
 S AQAOIND=+AQAOIND
 ;
 ;
DATES ; >> ask user to choose date range
 S AQAOBD=$$BDATE^AQAOLKP G END:AQAOBD=U,IND:AQAOBD=""
 S AQAOED=$$EDATE^AQAOLKP G END:AQAOED=U,DATES:AQAOED=""
 ;
 ;
 W !!?5,"You can now LIMIT the report to occurrences with certain ICD"
 W !,"codes.  You will be asked to select one or more DIAGNOSIS code"
 W !,"ranges and one or more PROCEDURE code ranges.  To include all"
 W !,"diagnoses, enter ""ALL"" at the ENTER DIAGNOSES prompt.  To"
 W !,"include all procedures, enter ""ALL"" at the ENTER PROCEDURES"
 W !,"prompt."
CLDX ; >>> choose clinical dx codes for report
 W !! K AQAOTBL,AQAOARR
 S AQAOICD=9,AQAOTL="DIAGNOSES" D ^AQAOCOD ;get dx range
 S X=0 F  S X=$O(AQAOTBL(X)) Q:X=""  S AQAOARR(X)=AQAOTBL(X)
 G END:$D(DUOUT)
 I '$D(AQAOARR) W *7,"   ??" G CLDX
 ;
PROC ; >>> choose procedure codes for report    
 W !!?5,"Now you can choose select PROCEDURES:",!!
 K AQAOTBL,AQAOARR1 S AQAOICD=0,AQAOTL="PROCEDURES" D ^AQAOCOD
 S X=0 F  S X=$O(AQAOTBL(X)) Q:X=""  S AQAOARR1(X)=AQAOTBL(X)
 K AQAOTBL,AQAOICD,AQAOTL
 G END:$D(DUOUT)
 I '$D(AQAOARR1) W *7,"   ??" G PROC
 ;
DESCRIPT ; >>> ask user for report description
 W !! K DIR S DIR(0)="F0^0:60",DIR("A")="Enter REPORT DESCRIPTION"
 S DIR("?",1)="This REPORT DESCRIPTION will print on the Summary page"
 S DIR("?",2)="to help explain what you are looking for.  You can enter"
 S DIR("?",3)="up to 60 characters.  Some examples:"
 S DIR("?",4)=" ""WOUND INFECTIONS SEARCH"" or"
 S DIR("?",5)=" ""GYN PROCEDURES with COMPLICATIONS"" "
 S DIR("?")="The Report Description is optional."
 D ^DIR G END:X=U,END:$D(DTOUT) S AQAODESC=Y
 ;
DEV ; >>> get print device
 I $P(AQAOUA("USER"),U,7)=1 D EXPORT^AQAOUTIL G DESCRIPT:Y=U
 I AQAOTYPE="L" W !!,"REMINDER:  Use wide paper or condensed print!"
 W !! S %ZIS="QP" D ^%ZIS G END:POP
 I '$D(IO("Q")) U IO G ^AQAOPC21
 K IO("Q") S ZTRTN="^AQAOPC21",ZTDESC="OCC BY ICD CODES"
 F I="AQAOTYPE","AQAOIND","AQAOARR(","AQAOARR1(","AQAOBD","AQAOED","AQAODESC" S ZTSAVE(I)=""
 S:$D(AQAODLM) ZTSAVE("AQAODLM")=""
 S:$D(AQAOXSN) ZTSAVE("AQAOXSN")="",ZTSAVE("AQAOXSM")=""
 S:$D(AQAOXS) ZTSAVE("AQAOXS(")=""
 D ^%ZTLOAD K ZTSK D ^%ZISC
 ;
END ; >>> eoj
 D HOME^%ZIS D KILL^AQAOUTIL Q
