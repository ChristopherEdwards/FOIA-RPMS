ANSU ;IHS/OIRM/DSD/CSC - NURSE STAFFING UTILITY; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;UTILITY
EN S IOP="HOME"
 D ^%ZIS
 K IOP
 S X=$S($D(^%ZIS(2,IOST(0),5)):^(5),1:X),ANSRVON=$P(X,U,4),ANSRVOF=$P(X,U,5),ANSHOME=IOF,ANSLINE=$P(X,U,6),ANSPAGE=$P(X,U,7),ANSSPAC="*32",ANSPLUS="*43"
 S X=0
 X ^%ZOSF("RM")
 K ANSPAR
 I $D(^ANSD(51,1,0)) S ANSPAR=^(0),ANSSITE=$P(ANSPAR,U)
 I '$D(DT) S %DT="",X="T" D ^%DT S DT=Y
 I '$D(ANSPAR) D WARN
 Q
WARN ;EP;WARN USER IF SITE PARAMETERS NOT SET
 W @IOF
 W *7,!!!,"WARNING, The Nursing Site Parameters",!,?13,"Nursing Unit Data and",!,?13,"Non-Direct Care Types have not been set!!",!!,"They must be set before you proceed by......."
 W !!,?5,"1.  Selecting  Option 'SS', System Setup Utilities, from the",!,?30,"MAIN MENU"
 W !!,?5,"2.  Completing the following options in the order listed:"
 W !!?10,"a.  Option 'NU', Nursing Unit Data and",!,?10,"b.  Option 'SP', Nursing Site Parameters",!,?10,"c.  Option 'CT', Non-Direct Care Types"
 W !!,?5,"3.  Entering requested data"
 W !,?9,"(Consult your user's manual for further instructions.)"
 D PAUSE^ANSDIC
 Q
