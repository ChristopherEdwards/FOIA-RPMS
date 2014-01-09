BUD8RP71 ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE 6B 03 Dec 2008 6:10 AM 30 Dec 2008 8:12 PM ;
 ;;7.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2013;Build 31
 ;
 ;
PRINT ;EP
 S BUDPG=0
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 S BUDQUIT=0
 D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?29,"|",?39,"|",?49,"|",?59,"|",?62,"Black/",?69,"|",?79,"|",!
 W ?29,"|",?39,"|",?41,"Native",?49,"|",?51,"Pacific",?59,"|",?61,"African",?69,"|",?79,"|",!
 W ?29,"|",?32,"Asian",?39,"|",?41,"Hawaiian",?49,"|",?51,"Islander",?59,"|",?61,"American",?69,"|",?79,"|",!
 W ?29,"|",?33,"(a)",?39,"|",?42,"(b1)",?49,"|",?52,"(b2)",?59,"|",?62,"(c)",?69,"|",?79,"|",!
 D LINE
 W "HIV Positive",?29,"|",?69,"|",?79,"|",!,"Pregnant Women",?29,"|***************************************",?69,"|",?79,"|",!
 D LINE2
 W "(NO PRENATAL CARE PROVIDED?  CHECK HERE:  "_$S(BUDPREN=0:"X",1:""),")",?79,"|",!
 D LINE
 W $$CTR("SECTION A:  DELIVERIES AND LOW BIRTH WEIGHT BY RACE"),?79,"|",!
 D LINE
 W $$CTR("Deliveries and Babies by birth weight"),?79,"|",!
 D LINE
 W ?2,"1",?5,"Prenatal care patients",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"who delivered during ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"the year",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"2",?5,"Deliveries performed",?29,"|",?69,"|",?79,"|",!
 W ?5,"by Grantee Provider",?29,"|***************************************",?69,"|",?79,"|",!
 D LINE2
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"3",?5,"Live Births <1500",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"grams",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"4",?5,"Live Births 1500-",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"2499 grams",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"5",?5,"Live Births >=2500",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 ;SECTION B
 I $Y>(IOSL-16) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?79,"|",!
 W $$CTR("SECTION B:  HYPERTENSION BY RACE"),?79,"|",!
 D LINE
 W $$CTR("Patients diagnosed with hypertension whose last blood pressure"),?79,"|",!
 W $$CTR("was less than 140/90"),?79,"|",!
 D LINE
 W ?2,"6",?5,"Total patients aged",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"18 + with hypertension",?29,"|",$$C($P($G(BUDSECTB(6)),U)),?39,"|",$$C($P($G(BUDSECTB(6)),U,2)),?49,"|",$$C($P($G(BUDSECTB(6)),U,3)),?59,"|",$$C($P($G(BUDSECTB(6)),U,4)),?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"7",?5,"Charts sampled or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTB(7)),U)),?39,"|",$$C($P($G(BUDSECTB(7)),U,2)),?49,"|",$$C($P($G(BUDSECTB(7)),U,3)),?59,"|",$$C($P($G(BUDSECTB(7)),U,4)),?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"8",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"controlled blood",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"pressure",?29,"|",$$C($P($G(BUDSECTB(8)),U)),?39,"|",$$C($P($G(BUDSECTB(8)),U,2)),?49,"|",$$C($P($G(BUDSECTB(8)),U,3)),?59,"|",$$C($P($G(BUDSECTB(8)),U,4)),?69,"|",?79,"|",!
 D LINE1
 D DMRACE1^BUD8RP7O
NEXT ;second page of sections a,b
 D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?29,"|",?31,"American",?39,"|",?49,"|",?52,"More",?59,"|",?60,"Unreport-",?69,"|",?79,"|",!
 W ?29,"|",?31,"Indian/",?39,"|",?42,"",?49,"|",?52,"than",?59,"|",?60,"ed/",?69,"|",?79,"|",!
 W ?29,"|",?31,"Alaska",?39,"|",?42,"",?49,"|",?52,"one",?59,"|",?60,"Refused",?69,"|",?79,"|",!
 W ?29,"|",?31,"Native",?39,"|",?42,"White",?49,"|",?52,"race",?59,"|",?60,"to Report",?69,"|",?72,"Total",?79,"|",!
 W ?29,"|",?33,"(d)",?39,"|",?42,"(e)",?49,"|",?52,"(f)",?59,"|",?62,"(g)",?69,"|",?72,"(h)",?79,"|",!
 D LINE
 W "HIV Positive",?29,"|",?69,"|",?79,"|",!,"Pregnant Women",?29,"|***************************************",?69,"|",?79,"|",!
 D LINE2
 W "(NO PRENATAL CARE PROVIDED?  CHECK HERE:  "_$S(BUDPREN=0:"X",1:""),")",?79,"|",!
 D LINE
 W $$CTR("SECTION A:  DELIVERIES AND LOW BIRTH WEIGHT BY RACE"),?79,"|",!
 D LINE
 W $$CTR("Deliveries and Babies by birth weight"),?79,"|",!
 D LINE
 W ?2,"1",?5,"Prenatal care patients",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"who delivered during ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"the year",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"2",?5,"Deliveries performed",?29,"|",?69,"|",?79,"|",!
 W ?5,"by Grantee Provider",?29,"|***************************************",?69,"|",?79,"|",!
 D LINE2 ;W $$REPEAT^XLFSTR("_",29),?29,"|_______________________________________",?69,"|",?79,"|",!
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"3",?5,"Live Births <1500",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"grams",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"4",?5,"Live Births 1500-",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"2499 grams",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"5",?5,"Live Births >=2500",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 D LINE1
 ;SECTION B
 I $Y>(IOSL-16) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?79,"|",!
 W $$CTR("SECTION B:  HYPERTENSION BY RACE"),?79,"|",!
 D LINE
 W $$CTR("Patients diagnosed with hypertension whose last blood pressure"),?79,"|",!
 W $$CTR("was less than 140/90"),?79,"|",!
 D LINE
 W ?2,"6",?5,"Total patients aged",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"18 + with hypertension",?29,"|",$$C($P($G(BUDSECTB(6)),U,5)),?39,"|",$$C($P($G(BUDSECTB(6)),U,6)),?49,"|",$$C($P($G(BUDSECTB(6)),U,7)),?59,"|",$$C($P($G(BUDSECTB(6)),U,8)),?69,"|",$$C($P($G(BUDSECTB(6)),U,9)),?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"7",?5,"Charts sampled or",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"EHR total",?29,"|",$$C($P($G(BUDSECTB(7)),U,5)),?39,"|",$$C($P($G(BUDSECTB(7)),U,6)),?49,"|",$$C($P($G(BUDSECTB(7)),U,7)),?59,"|",$$C($P($G(BUDSECTB(7)),U,8)),?69,"|",$$C($P($G(BUDSECTB(7)),U,9)),?79,"|",!
 D LINE1
 I $Y>(IOSL-3) D HEADER^BUD8RPTP Q:BUDQUIT  D T7H
 W ?2,"8",?5,"Patients with ",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"controlled blood",?29,"|",?39,"|",?49,"|",?59,"|",?69,"|",?79,"|",!
 W ?5,"pressure",?29,"|",$$C($P($G(BUDSECTB(8)),U,5)),?39,"|",$$C($P($G(BUDSECTB(8)),U,6)),?49,"|",$$C($P($G(BUDSECTB(8)),U,7)),?59,"|",$$C($P($G(BUDSECTB(8)),U,8)),?69,"|",$$C($P($G(BUDSECTB(8)),U,9)),?79,"|",!
 D LINE1
 D DMRACE2^BUD8RP7O
 ;write out ethnicity table
 D ETHN^BUD8RP7N
 I $G(BUDPRGHL) S BUDGPG=0 D PRGHL^BUD8RP7I
 I $G(BUDPRGRL) S BUDGPG=0 D PRGRL^BUD8RP7I
 I $G(BUDPRGEL) S BUDGPG=0 D PRGEL^BUD8RP7I
 I $G(BUDHTRL) S BUDGPG=0 D HTRL^BUD8RP7J
 I $G(BUDHTCRL) S BUDGPG=0 D HTCRL^BUD8RP7J
 I $G(BUDHTURL) S BUDGPG=0 D HTURL^BUD8RP7J
 I $G(BUDHTEL) S BUDGPG=0 D HTEL^BUD8RP7K
 I $G(BUDHTCEL) S BUDGPG=0 D HTCEL^BUD8RP7K
 I $G(BUDHTUEL) S BUDGPG=0 D HTUEL^BUD8RP7K
 I $G(BUDDMRL) S BUDGPG=0 D DMRL^BUD8RP7L
 I $G(BUDDMR1L) S BUDGPG=0 D DMR1L^BUD8RP7L
 I $G(BUDDMR2L) S BUDGPG=0 D DMR2L^BUD8RP7L
 I $G(BUDDMR3L) S BUDGPG=0 D DMR3L^BUD8RP7T
 I $G(BUDDMEL) S BUDGPG=0 D DMEL^BUD8RP7M
 I $G(BUDDME1L) S BUDGPG=0 D DME1L^BUD8RP7M
 I $G(BUDDME2L) S BUDGPG=0 D DME2L^BUD8RP7M
 I $G(BUDDME3L) S BUDGPG=0 D DME3L^BUD8RP7S
 K ^XTMP("BUD8RP7",BUDJ,BUDH)
 Q
 ;
 ;
T7H ;EP
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES"),!,$$REPEAT^XLFSTR("_",79),!
 Q
LINE ;EP
 W $$REPEAT^XLFSTR("_",79),?79,"|",!
 Q
LINE1 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",9),?39,"|",$$REPEAT^XLFSTR("_",9),?49,"|",$$REPEAT^XLFSTR("_",9),?59,"|",$$REPEAT^XLFSTR("_",9),?69,"|",$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
LINE2 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",39),?69,"|_________",?79,"|",!
 Q
 ;
LINE3 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",49),?79,"|",!
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
