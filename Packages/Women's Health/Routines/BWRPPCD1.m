BWRPPCD1 ;IHS/ANMC/MWR - REPORT: PROCEDURE STATISTICS;15-Feb-2003 22:09;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  DISPLAY CODE FOR PROCEDURE STATISTICS REPORT.  CALLED BY BWRPPCD.
 ;
DISPLAY ;EP
 ;---> BWTITLE=TITLE AT TOP OF DISPLAY HEADER.
 ;---> BWSUBH=CODE TO EXECUTE FOR SUBHEADER (COLUMN TITLES).
 ;---> BWCRT=1 IF OUTPUT IS TO SCREEN (ALLOWS SELECTIONS TO EDIT).
 ;
 U IO
 S BWTITLE="* * *  WOMEN'S HEALTH: PROCEDURE STATISTICS REPORT  * * *"
 D CENTERT^BWUTL5(.BWTITLE)
 S BWSUBH="SUBHEAD^BWRPPCD1"
 D TOPHEAD^BWUTL7
 S (BWPOP,N)=0
 ;
DISPLAY1 ;EP
 D HEADER3^BWUTL7
 I '$D(BWAR) D  Q
 .W !!?5,"No records match the selected criteria.",!
 .D ENDREP^BWUTL7()
 F  S N=$O(BWAR(N)) Q:N=""!(BWPOP)  D
 .I $Y+10>IOSL D:BWCRT DIRZ^BWUTL3 Q:BWPOP  D
 ..S BWPAGE=BWPAGE+1
 ..D HEADER3^BWUTL7
 .S Y=BWAR(N)
 .S BWAGRP=$$BWAGRP($P(Y,U,16))
 .;---> QUIT IF DISPLAYING "ALL AGES" ONLY (NOT GROUPED BY AGE).
 .Q:BWAGRP=1
 .S BWPCD="< "_$P(Y,U)_": "_BWAGRP_" >",BWPCDL=$L(BWPCD)
 .S X=$E(BWLINE,1,31-(BWPCDL/2))
 .W !!?8,X,BWPCD,X
 .D VERTICAL
 D ENDREP^BWUTL7()
 Q
 ;
 ;
VERTICAL ;EP
 ;---> DISPLAY IN VERTICAL FORMAT.
 W !!?23,"NORMAL:",?35,$J($P(Y,U,4),5),?42,"(",$J($P(Y,U,5),3),"%)"
 W !?8,"PROCEDURES"
 W ?23,"ABNORMAL:",?35,$J($P(Y,U,8),5),?42,"(",$J($P(Y,U,9),3),"%)"
 W !?23,"NO RESULT:",?35,$J($P(Y,U,12),5),?42,"(",$J($P(Y,U,13),3),"%)"
 W !?23,"TOTAL:",?35,$J($P(Y,U,15),5)
 W !!?23,"NORMAL:",?35,$J($P(Y,U,2),5),?42,"(",$J($P(Y,U,3),3),"%)"
 W ?51,"Patients may be"
 W !?8,"PATIENTS"
 W ?23,"ABNORMAL:",?35,$J($P(Y,U,6),5),?42,"(",$J($P(Y,U,7),3),"%)"
 W ?51,"included in more"
 W !?23,"NO RESULT:",?35,$J($P(Y,U,10),5),?42,"(",$J($P(Y,U,11),3),"%)"
 W ?51,"than one category."
 W !?23,"TOTAL:",?35,$J($P(Y,U,14),5),!
 Q
 ;
HORIZ ;EP
 ;---> NOT USED CURRENTLY: DISPLAY IN HORIZONTAL FORMAT.
 W !!?2,"NORMAL",?15,"NORMAL",?28,"ABNORMAL",?41,"ABNORMAL"
 W ?54,"NO RESULT",?67,"NO RESULT"
 W !?2,"patients",?15,"procedures",?28,"patients",?41,"procedures"
 W ?54,"patients",?67,"procedures"
 S X=$E(BWLINE,1,11) W !,?2,X,?15,X,?28,X,?41,X,?54,X,?67,X
 W !?2,$J($P(Y,U,2),5),"(",$P(Y,U,3),"%)"
 W ?15,$J($P(Y,U,4),5),"(",$P(Y,U,5),"%)"
 W ?28,$J($P(Y,U,6),5),"(",$P(Y,U,7),"%)"
 W ?41,$J($P(Y,U,8),5),"(",$P(Y,U,9),"%)"
 W ?54,$J($P(Y,U,10),5),"(",$P(Y,U,11),"%)"
 W ?67,$J($P(Y,U,12),5),"(",$P(Y,U,13),"%)"
 W !!?10,"Total Patients Receiving ",$P(Y,U),": ",$P(Y,U,14)
 W !?13,"Total ",$P(Y,U)," Procedures Done: ",$P(Y,U,15),!!
 Q
 ;
 ;
BWAGRP(AGE) ;EP
 ;Q:AGE="ALL" "All ages"
 Q:AGE="ALL" $S(BWAGRP'=1:"Total for selected ages",1:"All ages")
 Q:AGE=1 1
 N I,X,Y,Z S X=BWAGRG
 F I=1:1:$L(X,",")  S Y=$P($P(X,",",I),"-",2)  Q:AGE'>Y
 S Z=$P($P(X,",",I),"-")
 Q:AGE<Z "Under "_Y_" yrs"
 Q:AGE>Y "Over "_Y_" yrs"
 Q $P(X,",",I)_" yrs"
 ;---> PUT A FINAL CHECK IN HERE??  *COMEBACK
 Q "Unknown age"
 ;
 ;
SUBHEAD ;EP
 ;---> SUB HEADER FOR PROCEDURE BROWSE OUTPUT.
 W !?5,"NOTE: Patient numbers are not intended to total.  "
 W "See documentation.",!
 F I=1:1:80 W "="
 Q
