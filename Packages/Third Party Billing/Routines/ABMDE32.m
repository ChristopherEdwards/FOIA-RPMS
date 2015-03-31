ABMDE32 ;IHS/SD/SDR - Third Party Liability/Worker's Comp - PAGE 3B ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**6,13**;NOV 12, 2009;Build 213
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - New routine for page 3B
 ;IHS/SD/SDR - 2.6*13 - added property/casualty date of 1st contact here and removed from page 3
 ;
OPT ;EP
 G XIT:$D(ABMP("WORKSHEET"))
 K ABM,ABME,ABMZ,DUOUT,ABMP("QU")
 S ABMP("OPT")="ENVJBQ"
 D DISP
 G XIT:$D(DTOUT)!$D(DIROUT)
 D ^ABMDE32X
 I +$O(ABME(0)) D
 . S ABME("CONT")=""
 . D ^ABMDERR
 . K ABME("CONT")
 G XIT:$D(DTOUT)!$D(DIROUT)
 W !
 D SEL^ABMDEOPT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!("EV"'[$E(Y))
 S ABM("DO")=$S($E(Y)="E":"E1",1:"V1")
 W !
 D @ABM("DO")
 G XIT:$D(DTOUT)!$D(DIROUT)
 G OPT
V1 ;View data
 S ABMZ("TITL")="THIRD PARTY LIABILITY/WORKER'S COMP QUESTIONS - VIEW OPTION"
 D SUM^ABMDE1
 D ^ABMDERR
 Q
E1 ;Edit data
 ;S ABMP("FLDS")=3  ;abm*2.6*13 exp mode 35
 S ABMP("FLDS")=4  ;abm*2.6*13 exp mode 35
 D FLDS^ABMDEOPT
 W !
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S DR=""
 Q:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)
 S DA=ABMP("CDFN")
 S DIE="^ABMDCLM(DUZ(2),"
 ;S DR=$S(X=1:".713//;.725//;.726//",X=2:".717",X=3:".718",1:"")  ;abm*2.6*13 exp mode 35
 S DR=$S(X=1:".713//;.725//;.726//",X=2:".717",X=3:".718",X=4:".722//",1:"")  ;abm*2.6*13 exp mode 35
 D ^DIE
 K DRR
 Q
DISP ;
 S ABMZ("TITL")="THIRD PARTY LIABILITY/WORKER'S COMP QUESTIONS"
 S ABMZ("PG")="3B"
 I $D(ABMP("DDL")),$Y>(IOSL-6) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 E  D SUM^ABMDE1
 ;
 W !
 W "[1] Property and Casualty Claim Number: ",$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,13)
 W !,?8,"Patient Identifier/Number: "_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,25)_"/"_$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,26)
 W !,"[2] Date Last Worked: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,17))
 W !,"[3] Date Authorized to Return to Work: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,18))
 W !,"[4] Property/Casualty Date of 1st Contact: ",$$SDT^ABMDUTL($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),7)),U,22))  ;abm*2.6*13 exp mode 35
 Q
XIT ;
 S ABMP("C0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 K ABM,ABMV,ABME
 Q
