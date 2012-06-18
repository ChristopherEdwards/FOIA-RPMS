AZAXFIX ;FIX ROUTINE [ 08/13/2003  12:27 PM ]
 ;;
 ;TO FIX BAD NODES IN ^AUPNPRVT GLOBAL
 ;THIS ROUTINE IS COPIED FROM AZHAFIX AND MODIFIED BY AEF
 ;;
START ;start
 ;
 N DEL,OUT
 ;
 D TEXT
 ;
 S (DEL,OUT)=0
 ;
 D ASK(.DEL,.OUT)
 Q:OUT
 ;
 I DEL D BKU(.OUT)
 Q:OUT
 ;
 W !!,"Checking Private Insurance Eligible File",!!
 S I=0
BY ;bypass with I set
 F  S I=$O(^AUPNPRVT(I)) Q:'I  D
 .I '(I#100) W "."
 .S J=0
 .F  S J=$O(^AUPNPRVT(I,11,J)) Q:'J  D
 ..D ONE
 W !!,"Done",!!
 Q
ONE ;one entry
 Q:+$G(^AUPNPRVT(I,11,J,0))
 W !," bad entry at ien: ",I,"  ^AUPNPRVT(",I,",11,",J,",0)=",^AUPNPRVT(I,11,J,0),!
 ;K ^AUPNPRVT(I,11,J,0) W "fixed"
 Q
ASK(DEL,OUT) ;
 ;----- ASK IF SCAN OR DELETE MODE
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S OUT=0
 S DIR(0)="S^0:SCAN;1:DELETE"
 S DIR("A")="Run in SCAN or DELETE mode?"
 S DIR("B")="SCAN"
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) S OUT=1
 S DEL=+Y
 Q
BKU(OUT) ;
 ;----- ASK IF BACKUP COPY OF ^AUPNPRVT GLOBAL HAS BEEN DONE
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="Y"
 S DIR("A")="Did you make a backup copy of the ^AUPNPRVT global?"
 S DIR("B")="NO"
 D ^DIR
 I $D(DTOUT)!($D(DUOUT))!($D(DIRUT)) S OUT=1
 I +Y'>0 S OUT=1
 Q
TEXT ;
 ;----- WHAT THIS ROUTINE DOES
 ;
 W !!,"This routine can be used to SCAN and DELETE bad entries in the Private"
 W !,"Insurance Eligible file.  You should first run the routine in SCAN mode"
 W !,"to determine which entries have bad data.  It is HIGHLY RECOMMENDED that"
 W !,"you make a backup copy of your ^AUPNPRVT global before you delete the"
 W !,"bad entries."
 W !!
 Q
