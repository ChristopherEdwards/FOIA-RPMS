XBHEDD3 ;402,DJB,10/23/91,EDD - Individual Field Summary
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus,ME
 N CNT,DATA,FILE,FNAM,FNUM,LEV,TEMP
 D INIT I FLAGP D HD
 F  D GETFLD Q:'LEV!FLAGE
 I FLAGP,$D(^UTILITY($J,"INDIV")) D PRINT
EX ;
 K DIC,^UTILITY($J,"INDIV") S FLAGQ=1 Q
GETFLD ;Field lookup. Var LEV increments and decrements with Multiple layers.
 S DIC="^DD("_FILE(LEV)_"," D ^DIC I Y<0 S LEV=LEV-1 Q
 S FNUM=+Y,FNAM=$P(Y,U,2),TEMP=+$P(^DD(FILE(LEV),FNUM,0),U,2)
 I TEMP S LEV=LEV+1,FILE(LEV)=TEMP Q
 I 'FLAGP D ^XBHEDD4 Q
 S ^UTILITY($J,"INDIV",CNT)=FILE(LEV)_"^"_FNUM_"^"_FNAM,CNT=CNT+1
 Q
PRINT ;
 W:IO'=IO(0) "  Printing.." U IO D TXT^XBHEDD7
 S CNT="" F  S CNT=$O(^UTILITY($J,"INDIV",CNT)) Q:CNT=""  S DATA=^UTILITY($J,"INDIV",CNT),FILE(LEV)=$P(DATA,U),FNUM=$P(DATA,U,2),FNAM=$P(DATA,U,3) D ^XBHEDD4 Q:FLAGQ  W !!,$E(ZLINE2,1,IOM),!!
 Q
HD ;
 W @IOF,!,$E(ZLINE1,1,80),!?5,"Enter one at a time, as many fields as you wish to print. Fields will",!?5,"print in the order entered.",!,$E(ZLINE1,1,80),!
 Q
INIT ;
 S (CNT,LEV)=1,FILE(LEV)=ZNUM K ^UTILITY($J,"INDIV")
 S DIC(0)="QEAM",DIC("W")="I $P(^DD(FILE(LEV),Y,0),U,2)>0 W ""    -->Mult Fld"""
 Q
