BUD9RP71 ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 03 Dec 2009 6:10 AM 30 Dec 2009 8:12 PM ;
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
 ;
 ;
PRINT ;EP
 S BUDPG=0
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 S BUDQUIT=0
 D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?29,"|",?41,"HISPANIC/LATINO",?69,"|",!
 W ?29,"|",?39,"|",?49,"|",?59,"|",?62,"Black/",?69,"|",!  ;,?79,"|",!
 W ?29,"|",?39,"|",?41,"Native",?49,"|",?51,"Pacific",?59,"|",?61,"African",?69,"|",!  ;,?79,"|",!
 W ?29,"|",?32,"Asian",?39,"|",?41,"Hawaiian",?49,"|",?51,"Islander",?59,"|",?61,"American",?69,"|",!  ;,?79,"|",!
 W ?29,"|",?33,"(a)",?39,"|",?42,"(b1)",?49,"|",?52,"(b2)",?59,"|",?62,"(c)",?69,"|",!  ;,?79,"|",!
 D LINE
 ;W "HIV Positive",?29,"|",?69,"|",!,"Pregnant Women",?29,"|***************************************",?69,"|",!  ;,?79,"|",!
 W "HIV Positive",?29,"|",?69,"|",!,"Pregnant Women",?29,"|",$$C($P($G(BUDSECTH(1)),U)),?39,"|",$$C($P($G(BUDSECTH(1)),U,2)),?49,"|",$$C($P($G(BUDSECTH(1)),U,3)),?59,"|",$$C($P($G(BUDSECTH(1)),U,4)),?69,"|",!
 D LINE2
 W "(NO PRENATAL CARE PROVIDED?  CHECK HERE:  "_$S(BUDPREN=0:"X",1:""),")",?69,"|",!
 S BUDXX=$S(BUDPREN:"",1:"N/A")
 D LINE
 W $$CTR("SECTION A: DELIVERIES AND LOW BIRTH WEIGHT BY RACE",80),?69,"|",!,$$CTR("AND HISPANIC/LATINO IDENTITY",80),?69,"|",!
 D LINE
 W $$CTR("Deliveries and Babies by birth weight"),?69,"|",!
 D LINE
 W ?2,"1",?5,"Prenatal care patients",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"who delivered during ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"the year",?29,"| ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|  ",BUDXX,?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"2",?5,"Deliveries performed",?29,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"by Grantee Provider",?29,"|***************************************",?69,"|",!  ;,?79,"|",!
 D LINE2
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"3",?5,"Live Births <1500",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"grams",?29,"| ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|  ",BUDXX,?69,"|",!  ;,?79,"|",! ?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"4",?5,"Live Births 1500-",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"2499 grams",?29,"| ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|  ",BUDXX,?69,"|",!  ;,?79,"|",!?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"5",?5,"Live Births >=2500",?29,"| ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|  ",BUDXX,?69,"|",!  ;?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 D LINE1
 ;SECTION B
 I $Y>(IOSL-16) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?69,"|",!
 W $$CTR("SECTION B: HYPERTENSION BY RACE AND HISPANIC/LATINO IDENTITY",70),?69,"|",!  ;,?79,"|",!
 D LINE
 W $$CTR("Patients 18 to 85 diagnosed with hypertension whose last ",70),?69,"|",!  ;,?79,"|",!
 W $$CTR("blood pressure was less than 140/90",70),?69,"|",!  ;,?79,"|",!
 D LINE
 W ?2,"6",?5,"Total hypertensive",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"patients",?29,"|",$$C($P($G(BUDSECTB(6)),U)),?39,"|",$$C($P($G(BUDSECTB(6)),U,2)),?49,"|",$$C($P($G(BUDSECTB(6)),U,3)),?59,"|",$$C($P($G(BUDSECTB(6)),U,4)),?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"7",?5,"Charts sampled or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTB(7)),U)),?39,"|",$$C($P($G(BUDSECTB(7)),U,2)),?49,"|",$$C($P($G(BUDSECTB(7)),U,3)),?59,"|",$$C($P($G(BUDSECTB(7)),U,4)),?69,"|",!  ;,?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H
 W ?2,"8",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",!  ;,?79,"|",!
 ;W ?5,"controlled blood",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"HTN controlled",?29,"|",$$C($P($G(BUDSECTB(8)),U)),?39,"|",$$C($P($G(BUDSECTB(8)),U,2)),?49,"|",$$C($P($G(BUDSECTB(8)),U,3)),?59,"|",$$C($P($G(BUDSECTB(8)),U,4)),?69,"|",!
 D LINE1
 D DMRACE1^BUD9RP7O  ;rest of page 1
NEXT ;second page of sections a,b
 D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?29,"|",?31,"HISPANIC/LATINO IDENTITY",?59,"|",!
 W ?29,"|",?31,"American",?39,"|",?49,"|",?52,"More",?59,"|",!  ;?60,"Unreport-",?69,"|",?79,"|",!
 W ?29,"|",?31,"Indian/",?39,"|",?42,"",?49,"|",?52,"than",?59,"|",!  ;,?60,"ed/",?69,"|",?79,"|",!
 W ?29,"|",?31,"Alaska",?39,"|",?42,"",?49,"|",?52,"one",?59,"|",!  ;?60,"Refused",?69,"|",?79,"|",!
 W ?29,"|",?31,"Native",?39,"|",?42,"White",?49,"|",?52,"race",?59,"|",! ;,?59,"|",?60,"to Report",?69,"|",?72,"Total",?79,"|",!
 W ?29,"|",?33,"(d)",?39,"|",?42,"(e)",?49,"|",?52,"(f)",?59,"|",! ;,?59,"|",?62,"(g)",?69,"|",?72,"(h)",?79,"|",!
 D LINE4
 W "HIV Positive",?29,"|",?59,"|",!  ;,?79,"|",
 W "Pregnant Women",?29,"|",$$C($P($G(BUDSECTH(1)),U,5)),?39,"|",$$C($P($G(BUDSECTH(1)),U,6)),?49,"|",$$C($P($G(BUDSECTH(1)),U,7)),?59,"|",!
 ;W "HIV Positive",?29,"|",?59,"|",!  ;,?79,"|",
 ;W "Pregnant Women",?29,"|*****************************",?59,"|",! ;,?79,"|",!
 D LINE6
 W "(NO PRENATAL CARE PROVIDED?  CHECK HERE:  "_$S(BUDPREN=0:"X",1:""),")",?59,"|",!
 D LINE4
 W $$CTR("SECTION A: DELIVERIES AND LOW BIRTH WEIGHT BY RACE AND ",60),?59,"|",!  ;,$$CTR("HISPANIC/LATINO IDENTITY",60),?59,"|",!
 D LINE4
 W $$CTR("Deliveries and Babies by birth weight",60),?59,"|",!
 D LINE4
 W ?2,"1",?5,"Prenatal care patients",?29,"|",?39,"|",?49,"|",?59,"|",!  ;69,"|",?79,"|",!
 W ?5,"who delivered during ",?29,"|",?39,"|",?49,"|",?59,"|",!  ;?69,"|",?79,"|",!
 W ?5,"the year",?29,"|  ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|",!  ;?69,"|",?79,"|",!
 D LINE5
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?2,"2",?5,"Deliveries performed",?29,"|",?59,"|",!  ;?79,"|",!
 W ?5,"by Grantee Provider",?29,"|*****************************",?59,"|",!
 D LINE6 ;W $$REPEAT^XLFSTR("_",29),?29,"|_______________________________________",?69,"|",?79,"|",!
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?2,"3",?5,"Live Births <1500",?29,"|",?39,"|",?49,"|",?59,"|",!  ;?69,"|",?79,"|",!
 W ?5,"grams",?29,"|  ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|",!  ;?69,"|",?79,"|",!?29,"|",?39,"|",?49,"|",?59,"|",!  ;?69,"|",?79,"|",!
 D LINE5
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?2,"4",?5,"Live Births 1500-",?29,"|",?39,"|",?49,"|",?59,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 W ?5,"2499 grams",?29,"|  ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|",!  ;?69,"|",?79,"|",!?29,"|",?39,"|",?49,"|",?59,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 D LINE5
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?2,"5",?5,"Live Births >=2500",?29,"|  ",BUDXX,?39,"|  ",BUDXX,?49,"|  ",BUDXX,?59,"|",!  ;?69,"|",?79,"|",!?29,"|",?39,"|",?49,"|",?59,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 D LINE5
 ;SECTION B
 I $Y>(IOSL-16) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?59,"|",!
 W $$CTR("SECTION B:  HYPERTENSION BY RACE AND ",60),?59,"|",!,$$CTR("HISPANIC/LATINO IDENTITY",60),?59,"|",!
 D LINE4
 W $$CTR("Patients diagnosed with hypertension whose last",60),?59,"|",!
 W $$CTR("blood pressure was less than 140/90",60),?59,"|",!
 D LINE4
 W ?2,"6",?5,"Total hypertensive",?29,"|",?39,"|",?49,"|",?59,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 W ?5,"patients",?29,"|",$$C($P($G(BUDSECTB(6)),U,5)),?39,"|",$$C($P($G(BUDSECTB(6)),U,6)),?49,"|",$$C($P($G(BUDSECTB(6)),U,7)),?59,"|",!  ;,?59,"|",$$C($P($G(BUDSECTB(6)),U,8)),?69,"|",$$C($P($G(BUDSECTB(6)),U,9)),?79,"|",!
 D LINE5
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?2,"7",?5,"Charts sampled or",?29,"|",?39,"|",?49,"|",?59,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTB(7)),U,5)),?39,"|",$$C($P($G(BUDSECTB(7)),U,6)),?49,"|",$$C($P($G(BUDSECTB(7)),U,7)),?59,"|",!  ;,?59,"|",$$C($P($G(BUDSECTB(7)),U,8)),?69,"|",$$C($P($G(BUDSECTB(7)),U,9)),?79,"|",!
 D LINE5
 I $Y>(IOSL-3) D HEADER^BUD9RPTP Q:BUDQUIT  D T7H1
 W ?2,"8",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 ;W ?5,"controlled blood",?29,"|",?39,"|",?49,"|",!  ;,?59,"|",?69,"|",?79,"|",!
 W ?5,"HTN controlled",?29,"|",$$C($P($G(BUDSECTB(8)),U,5)),?39,"|",$$C($P($G(BUDSECTB(8)),U,6)),?49,"|",$$C($P($G(BUDSECTB(8)),U,7)),?59,"|",!  ;,?59,"|",$$C($P($G(BUDSECTB(8)),U,8)),?69,"|",$$C($P($G(BUDSECTB(8)),U,9)),?79,"|",!
 D LINE5
 D DMRACE2^BUD9RP7O
 ;write out ethnicity table
 ;D ETHN^BUD9RP7N
 D ^BUD9RP7F  ;page 3 of table 7 with non-hispanic
 Q:BUDQUIT
 D ^BUD9RP7P  ;unreported/ total
 I $G(BUDPRGHL) S BUDGPG=0 D PRGHL^BUD9RP7I
 I $G(BUDPRGRL) S BUDGPG=0 D PRGRL^BUD9RP7I
 ;I $G(BUDPRGEL) S BUDGPG=0 D PRGEL^BUD9RP7I
 I $G(BUDHTRL) S BUDGPG=0 D HTRL^BUD9RP7J
 I $G(BUDHTCRL) S BUDGPG=0 D HTCRL^BUD9RP7J
 I $G(BUDHTURL) S BUDGPG=0 D HTURL^BUD9RP7J
 ;I $G(BUDHTEL) S BUDGPG=0 D HTEL^BUD9RP7K
 ;I $G(BUDHTCEL) S BUDGPG=0 D HTCEL^BUD9RP7K
 ;I $G(BUDHTUEL) S BUDGPG=0 D HTUEL^BUD9RP7K
 I $G(BUDDMRL) S BUDGPG=0 D DMRL^BUD9RP7L
 I $G(BUDDMR1L) S BUDGPG=0 D DMR1L^BUD9RP7L
 I $G(BUDDMR2L) S BUDGPG=0 D DMR2L^BUD9RP7L
 I $G(BUDDMR3L) S BUDGPG=0 D DMR3L^BUD9RP7T
 ;I $G(BUDDMEL) S BUDGPG=0 D DMEL^BUD9RP7M
 ;I $G(BUDDME1L) S BUDGPG=0 D DME1L^BUD9RP7M
 ;I $G(BUDDME2L) S BUDGPG=0 D DME2L^BUD9RP7M
 ;I $G(BUDDME3L) S BUDGPG=0 D DME3L^BUD9RP7S
 K ^XTMP("BUD9RP7",BUDJ,BUDH)
 Q
 ;
 ;
T7H ;EP
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES"),!,$$REPEAT^XLFSTR("_",69),!  ;,!?41,"HISPANIC/LATINO",!
 Q
LINE ;EP
 W $$REPEAT^XLFSTR("_",69),?69,"|",!
 Q
LINE1 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",9),?39,"|",$$REPEAT^XLFSTR("_",9),?49,"|",$$REPEAT^XLFSTR("_",9),?59,"|",$$REPEAT^XLFSTR("_",9),?69,"|",!  ;$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
LINE2 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",39),?69,"|",! ;_________",?79,"|",!
 Q
 ;
LINE3 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",49),?79,"|",!
 Q
T7H1 ;EP
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES",60),!,$$REPEAT^XLFSTR("_",59),!  ;,!?41,"HISPANIC/LATINO",!
 Q
LINE4 ;EP
 W $$REPEAT^XLFSTR("_",59),?59,"|",!
 Q
LINE5 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",9),?39,"|",$$REPEAT^XLFSTR("_",9),?49,"|",$$REPEAT^XLFSTR("_",9),?59,"|",!  ;$$REPEAT^XLFSTR("_",9),?69,"|",!  ;$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
LINE6 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",29),?59,"|",! ;_________",?79,"|",!
 Q
 ;
LINE7 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",29),?59,"|",!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
C(X,Y) ;
 I $G(Y)=1,+X=0 Q ""
 I $G(Y)=2 Q "********"
 S X2=0,X3=8
 D COMMA^%DTC
 Q X
