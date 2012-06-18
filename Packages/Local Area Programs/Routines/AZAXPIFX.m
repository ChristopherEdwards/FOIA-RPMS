AZAXPIFX;IHS/PHXAO/AEF - FIX BAD NODES IN ^AUPNPRVT GLOBAL
 ;;1.0;ANNE'S SPECIAL ROUTINES;;MAY 21, 2004     
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine can be used to SCAN and DELETE bad entries in the Private
 ;;Insurance Eligible file.  You should first run the routine in SCAN mode
 ;;to determine which entries have bad data.  It is HIGHLY RECOMMENDED that
 ;;you make a backup copy of your ^AUPNPRVT global before you delete the
 ;;bad entries.
 ;;
 ;;$$END
 ;
EN ;EP --- MAIN ENTRY POINT
 ;
 N DEL,OUT
 ;
 D TXT
 ;
 S (DEL,OUT)=0
 ;
 D ASK(.DEL,.OUT)
 Q:OUT
 ;
 I DEL D BKU(.OUT)
 Q:OUT
 ;
 D LOOP(DEL)
 ;
 Q
LOOP(DEL) ;
 ;----- LOOP THROUGH PRIVATE INSURANCE ELIGIBLE ^AUPNPRVT GLOBAL
 ;
 N CNT,D0,D1
 ;
 W !!,"Checking Private Insurance Eligible File... PLEASE WAIT",!!
 ;
 S CNT=0
 ;
 S D0=0
 F  S D0=$O(^AUPNPRVT(D0)) Q:'D0  D
 . S D1=0
 . F  S D1=$O(^AUPNPRVT(D0,11,D1)) Q:'D1  D
 . . D ONE(D0,D1,DEL,.CNT)
 ;
 I CNT W !!,CNT," ENTRIES ",$S(DEL:"FIXED",1:"FOUND")
 I 'CNT W !!,"NO BAD ENTRIES FOUND"
 W !!,"DONE!",!!
 Q
ONE(D0,D1,DEL,CNT) ;
 ;----- PROCESS ONE ENTRY
 ;
 Q:+$G(^AUPNPRVT(D0,11,D1,0))
 ;
 S CNT=$G(CNT)+1
 ;
 W !," bad entry at ien: ",D0,"  ^AUPNPRVT(",D0,",11,",D1,",0)=",^AUPNPRVT(D0,11,D1,0)
 ;
 Q:'DEL
 K ^AUPNPRVT(D0,11,D1,0)
 ; 
 W !,"fixed"
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
TXT ;----- PRINT OPTION TEXT
 ;
 N I,X
 F I=1:1 S X=$P($T(DESC+I),";",3) Q:X["$$END"  W !,X
 Q
