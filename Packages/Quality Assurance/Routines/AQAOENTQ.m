AQAOENTQ ; IHS/ORDC/LJF - DISPLAY OCCURRENCES ENTERED ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn is called by ^AQAOENTR to display all occurrences already
 ;entered for the combination of patient, occ date & indicator.  If
 ;any are found, user can select one or choose to add a new occurrence.
 ;
FIND ; >> find occurrences in file for patient, date & indicator
 S (AQAOX,AQAONUM)=0 K AQAO
 F  S AQAOX=$O(^AQAOC("AA",AQAOIND,AQAODATE,AQAOPAT,AQAOX)) Q:AQAOX=""  D
 .S AQAOST=$P($G(^AQAOC(AQAOX,1)),U) ;status codes
 .Q:AQAOST="2"  ;bypass deletd occ
 .S AQAOST=$S(AQAOST=0:"OPEN",AQAOST=1:"CLOSED",1:"") ;set status
 .S AQAOID=$P($G(^AQAOC(AQAOX,0)),U) ;case identifier
 .S AQAONUM=AQAONUM+1,X="     " ;set array
 .S AQAO(AQAONUM)=AQAOX_U_AQAOID_X_AQAOST_X_$P(^AQAO(2,+AQAOIND,0),U,2)
 .Q
 G EXIT:'$D(AQAO) ;no occ found
 ;
DISPLAY ; >> display occurrences found
 W !!?5,"*** OCCURRENCES FOUND FOR "
 W $P(^DPT(AQAOPAT,0),U)," FOR DATE SELECTED ***",!
 W !?3,"Case #      Status    Indicator"
 K DIR S DIR(0)="N^1:"_(AQAONUM+1),DIR("A")="Choose ONE from list"
 S DIR("A",(AQAONUM+1))=(AQAONUM+1)_". ADD NEW ENTRY"
 S AQAON=0 F  S AQAON=$O(AQAO(AQAON)) Q:AQAON=""  D
 .S DIR("A",AQAON)=AQAON_". "_$P(AQAO(AQAON),U,2)
 D ^DIR G EXIT:$D(DIRUT)
 I Y=(AQAONUM+1) K AQAO G EXIT ;user chose to add new entry
 I $P($P(AQAO(+Y),U,2),"     ",2)'="OPEN" D  G DISPLAY
 .W !!,"CASE NOT OPEN!  MUST BE REOPENED TO EDIT IT!"
 S AQAOIFN=$P(AQAO(+Y),U) ;user chose to edit an entry
 S AQAOCID=$P(AQAO(+Y),U,2)
 ;
EXIT ; >> return to calling routine
 Q
