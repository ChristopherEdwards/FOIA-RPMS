BUDCRP71 ; IHS/CMI/LAB - UDS REPORT DRIVER TABLE ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
PRINT ;EP
 S BUDPG=0
 ;S BUDPREN=1,BUDSITE=2582,BUDBD=3030101,BUDED=3031231
 S BUDQUIT=0
 I BUDROT="D" D  G PL
 .D ^%ZISC ;close printer device
 .K ^TMP($J)
 .S ^TMP($J,"BUDDEL",0)=0
 .S BUDDECNT=0
 S BUDTELB="Hispanic/Latino",BUDTELN=1
 D P71
 Q:BUDQUIT
 S BUDTELB="Non-Hispanic/Latino",BUDTELN=2
 D P71
 Q:BUDQUIT
 ;D R
 W "Unreported/Refused to Report Ethnicity",!
 W $$REPEAT^XLFSTR("_",80),!
 W "h",?5,"|Unreported/" D R1
 W ?5,"| Refused" D R1
 W ?5,"| to Report Race" D R1
 W ?5,"| and Ethnicity" D R1
 D R
 W "i",?5,"| Total" D R1
 D R ;W $$REPEAT^XLFSTR("_",80),!
 Q:BUDQUIT
B7 ;
 S BUDTELB="Hispanic/Latino",BUDTELL=1,BUDTELN=1
 D P7B
 Q:BUDQUIT
 S BUDTELB="Non-Hispanic/Latino",BUDTELL=2,BUDTELN=2
 D P7B
 Q:BUDQUIT
 W "Unreported/Refused to Report Ethnicity",!
 W $$REPEAT^XLFSTR("_",80),!
 W "h",?5,"|Unreported/" D R2B
 W ?5,"| Refused" D R2B
 W ?5,"| to Report Race" D R2B
 W ?5,"| and Ethnicity" S BUDTELL=3,X=1 D R1B
 D RB
 W "i",?5,"| Total" W ?23,"|",?28,$$C($P($G(BUDSECTB(4)),U,1),8),?42,"|",?47,$$C($P($G(BUDSECTB(4)),U,2),8),?61,"|",?66,$$C($P($G(BUDSECTB(4)),U,3),8),!
 D RB ;W $$REPEAT^XLFSTR("_",80),!
 Q:BUDQUIT
 ;section c
C7 ;
 S BUDTELB="Hispanic/Latino",BUDTELL=1,BUDTELN=1
 D P7C
 Q:BUDQUIT
 S BUDTELB="Non-Hispanic/Latino",BUDTELL=2,BUDTELN=2
 D P7C
 Q:BUDQUIT
 W "Unreported/Refused to Report Ethnicity",!
 W $$REPEAT^XLFSTR("_",80),!
 W "h",?5,"|Unreported/" D R2C
 W ?5,"| Refused" D R2C
 W ?5,"| to Report Race" D R2C
 W ?5,"| and Ethnicity" S BUDTELL=3,X=1 D R1C
 D RC
 W "i",?5,"| Total" D
 .W ?23,"|",?24,$$C($P($G(BUDSECTC(4)),U,1),7),?32,"|",?33,$$C($P($G(BUDSECTC(4)),U,2),7),?41,"|",?42,$$C($P($G(BUDSECTC(4)),U,4),7)
 .W ?50,"|",?51,$$C($P($G(BUDSECTC(4)),U,5),7),! ;,?59,"|",?60,$$C($P($G(BUDSECTC(4)),U,6),7),!
 D RC ;W $$REPEAT^XLFSTR("_",80),!
 Q:BUDQUIT
PL D LISTS
 D ^%ZISC
 I BUDROT="D" D SAVEDEL^BUDCRPTD
 K ^XTMP("BUDCRP7",BUDJ,BUDH)
 Q
P71 ;
 D HEADER^BUDCRPTP Q:BUDQUIT  D T7H
 W $$CTR("SECTION A: DELIVERIES AND BIRTH WEIGHT BY RACE AND HISPANIC/LATINO ETHNICITY",80),!
 W $$REPEAT^XLFSTR("_",80),!
 I BUDTELB'="Hispanic/Latino" G P71A
 W !,"0",?5,"HIV Positive Pregnant Women",$$REPEAT^XLFSTR("*",(67-$X)),?67,"|  ",$P($G(BUDSECTH(1)),U,18),!
 W $$REPEAT^XLFSTR("_",80),!
 W "2",?5,"Deliveries Performed by Health Center's Providers",$$REPEAT^XLFSTR("*",(67-$X)),?67,"|",!
 W $$REPEAT^XLFSTR("_",80),!
 ;D R
P71A ;W !!,$$REPEAT^XLFSTR("_",80),!
 W ?5,"|",?23,"|Prenatal Care",?37,"| Live Births:",?51,"| Live Births:",?65,"| Live Births:",!
 W ?5,"|",?23,"| Patients Who",?37,"| <1500 grams",?51,"| 1500-2499",?65,"| =>2500 grams",!
 W "Line",?5,"|  Race and ",?23,"|  Delivered",?37,"|",?51,"| grams",?65,"|",!
 W " #",?5,"|  Ethnicity",?23,"| During the",?37,"|",?51,"|",?65,"|",!
 W ?5,"|",?23,"|   Year",?37,"|",?51,"|",?65,"|",!
 W ?5,"|",?23,"|   (1a)",?37,"|   (1b)",?51,"|   (1c)",?65,"|   (1d)",!
 D R
 W BUDTELB,!
 W $$REPEAT^XLFSTR("_",80),!
 W BUDTELN_"a",?5,"| Asian" D R1
 D R
 W BUDTELN_"b1",?5,"| Native Hawaiian" D R1
 D R
 W BUDTELN_"b2",?5,"| Other Pacific" D R1
 W ?5,"| Islander" D R1
 D R
 W BUDTELN_"c",?5,"| Black/African" D R1
 W ?5,"| American" D R1
 D R
 W BUDTELN_"d",?5,"| American Indian/" D R1
 W ?5,"| Alaska Native" D R1
 D R
 W BUDTELN_"e",?5,"| White" D R1
 D R
 W BUDTELN_"f",?5,"| More than One" D R1
 W ?5,"| Race" D R1
 D R
 W BUDTELN_"g",?5,"| Unreported/" D R1
 W ?5,"| Refused" D R1
 W ?5,"| to Report Race" D R1
 D R
 W ?5,"| Subtotal"
 I BUDTELB["Non" W ?16,"Non-"
 D R1
 W ?5,"| ",$S(BUDTELB["-":$P(BUDTELB,"-",2),1:BUDTELB),?23,"|             |             |             |              ",! I 1
 D R
 Q
R ;EP
 ;W $$REPEAT^XLFSTR("_",80),!
 W "_____|_________________|_____________|_____________|_____________|______________",!
 Q
R1 ;EP
 W ?23,"|",?37,"|",?51,"|",?65,"|",!
 Q
P7B ;
 D HEADER^BUDCRPTP Q:BUDQUIT  D T7H
 W $$CTR("SECTION B:  HYPERTENSION BY RACE AND HISPANIC/LATINO ETHNICITY",80),!
 W $$REPEAT^XLFSTR("_",80),!
 W ?5,"|",?23,"|Total Hypertensive",?42,"| Charts Sampled or",?61,"| Patients with HTN",!
 W " #",?5,"|  Race and ",?23,"|  Patients",?42,"|  EHR Total",?61,"|   Controlled",!
 W ?5,"|  Ethnicity",?23,"|   (2a)",?42,"|   (2b)",?61,"|   (2c)",!
 D RB
 W BUDTELB,!
 W $$REPEAT^XLFSTR("_",80),!
 W BUDTELN_"a",?5,"| Asian" S X=1 D R1B
 D RB
 W BUDTELN_"b1",?5,"| Native Hawaiian" S X=2 D R1B
 D RB
 W BUDTELN_"b2",?5,"| Other Pacific" D R2B
 W ?5,"| American" S X=3 D R1B
 D RB
 W BUDTELN_"c",?5,"| Black/African" D R2B
 W ?5,"| American" S X=4 D R1B
 D RB
 W BUDTELN_"d",?5,"| American Indian/" D R2B
 W ?5,"| Alaska Native" S X=5 D R1B
 D RB
 W BUDTELN_"e",?5,"| White" S X=6 D R1B
 D RB
 W BUDTELN_"f",?5,"| More than One" D R2B
 W ?5,"| Race" S X=7 D R1B
 D RB
 W BUDTELN_"g",?5,"| Unreported/" D R2B
 W ?5,"| Refused" D R2B
 W ?5,"| to Report Race" S X=8 D R1B
 D RB
 W ?5,"| Subtotal"
 I BUDTELB["Non" W ?16,"Non-"
 D R2B
 W ?5,"| ",$S(BUDTELB["-":$P(BUDTELB,"-",2),1:BUDTELB) D
 .W ?23,"|",?28,$$C($P($G(BUDSECTB(BUDTELL)),U,1),8),?42,"|",?47,$$C($P($G(BUDSECTB(BUDTELL)),U,2),8),?61,"|",?66,$$C($P($G(BUDSECTB(BUDTELL)),U,3),8),!
 D RB
 Q
RB ;EP
 ;W $$REPEAT^XLFSTR("_",80),!
 W "_____|_________________|__________________|__________________|__________________",!
 Q
R1B ;EP
 W ?23,"|",?28,$$C($P($G(BUDSECTB(BUDTELL,X)),U,1),8),?42,"|",?47,$$C($P($G(BUDSECTB(BUDTELL,X)),U,2),8),?61,"|",?66,$$C($P($G(BUDSECTB(BUDTELL,X)),U,3),8),!
 Q
R2B ;EP
 W ?23,"|",?42,"|",?61,"|",!
 Q
P7C ;
 D HEADER^BUDCRPTP Q:BUDQUIT  D T7H
 W $$CTR("SECTION C:  DIABETES BY RACE AND HISPANIC/LATINO ETHNCITY",80),!
 W $$REPEAT^XLFSTR("_",72),!
 W ?5,"|",?23,"| Total",?32,"| Charts",?41,"|Patients",?50,"|Patients",!
 W " #",?5,"|  Race and ",?23,"|Patients",?32,"|Sampled",?41,"| with",?50,"| with",!
 W ?5,"|  Ethnicity",?23,"| with",?32,"| or EHR",?41,"| Hba1c",?50,"| Hba1c",!
 W ?5,"|",?23,"|Diabetes",?32,"| Total",?41,"| <8%",?50,"|>9% Or No",!
 W ?5,"|",?23,"|",?32,"|",?41,"|  ",?50,"| Test",!
 W ?5,"|",?23,"|",?32,"|",?41,"|",?50,"|During Year",!
 W ?5,"|",?23,"|  (3a)",?32,"|  (3b)",?41,"| (3d1)",?50,"|  (3f)",!
 D RC
 W BUDTELB,!
 W $$REPEAT^XLFSTR("_",72),!
 W BUDTELN_"a",?5,"| Asian" S X=1 D R1C
 D RC
 W BUDTELN_"b1",?5,"| Native Hawaiian" S X=2 D R1C
 D RC
 W BUDTELN_"b2",?5,"| Other Pacific" D R2C
 W ?5,"| Islander" S X=3 D R1C
 D RC
 W BUDTELN_"c",?5,"| Black/African" D R2C
 W ?5,"| American" S X=4 D R1C
 D RC
 W BUDTELN_"d",?5,"| American Indian/" D R2C
 W ?5,"| Alaska Native" S X=5 D R1C
 D RC
 W BUDTELN_"e",?5,"| White" S X=6 D R1C
 D RC
 W BUDTELN_"f",?5,"| More than One" D R2C
 W ?5,"| Race" S X=7 D R1C
 D RC
 W BUDTELN_"g",?5,"| Unreported/" D R2C
 W ?5,"| Refused" D R2C
 W ?5,"| to Report Race" S X=8 D R1C
 D RC
 W ?5,"| Subtotal"
 I BUDTELB["Non" W ?16,"Non-"
 D R2C
 W ?5,"| ",$S(BUDTELB["-":$P(BUDTELB,"-",2),1:BUDTELB) D
 .W ?23,"|",?24,$$C($P($G(BUDSECTC(BUDTELL)),U,1),7),?32,"|",?33,$$C($P($G(BUDSECTC(BUDTELL)),U,2),7),?41,"|",?42,$$C($P($G(BUDSECTC(BUDTELL)),U,4),7)
 .W ?50,"|",?51,$$C($P($G(BUDSECTC(BUDTELL)),U,5),7),!
 D RC
 Q
RC ;EP
 ;W $$REPEAT^XLFSTR("_",80),!
 W "_____|_________________|________|________|________|____________________",!
 Q
R1C ;EP
 W ?23,"|",?24,$$C($P($G(BUDSECTC(BUDTELL,X)),U,1),7),?32,"|",?33,$$C($P($G(BUDSECTC(BUDTELL,X)),U,2),7),?41,"|",?42,$$C($P($G(BUDSECTC(BUDTELL,X)),U,4),7)
 W ?50,"|",?51,$$C($P($G(BUDSECTC(BUDTELL,X)),U,5),7),!
 Q
R2C ;EP
 W ?23,"|",?32,"|",?41,"|",?50,"|",!
 Q
LISTS ;
 I $G(BUDPRGHL) S BUDGPG=0 D PRGHL^BUDCRP7I
 I $G(BUDPRGRL) S BUDGPG=0 D PRGRL^BUDCRP7I
 I $G(BUDHTRL) S BUDGPG=0 D HTRL^BUDCRP7J
 I $G(BUDHTCRL) S BUDGPG=0 D HTCRL^BUDCRP7J
 I $G(BUDHTURL) S BUDGPG=0 D HTURL^BUDCRP7U
 I $G(BUDDMRL) S BUDGPG=0 D DMRL^BUDCRP7L
 I $G(BUDDMR1L) S BUDGPG=0 D DMR1L^BUDCRP7L
 I $G(BUDDMR2L) S BUDGPG=0 D DMR2L^BUDCRP7T
 K ^XTMP("BUDCRP7",BUDJ,BUDH)
 Q
 ;
 ;
T7H ;EP
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES"),!  ;$$REPEAT^XLFSTR("_",80),!  ;,!?41,"HISPANIC/LATINO (1)",!
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
LINE1 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",9),?39,"|",$$REPEAT^XLFSTR("_",9),?49,"|",$$REPEAT^XLFSTR("_",9),?50,"|",$$REPEAT^XLFSTR("_",9),?59,"|",!  ;$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
T7H1 ;EP
 W !,$$CTR("TABLE 7 - HEALTH OUTCOMES AND DISPARITIES",60),!,$$REPEAT^XLFSTR("_",69),!  ;,!?41,"HISPANIC/LATINO",!
 Q
LINE4 ;EP
 W $$REPEAT^XLFSTR("_",69),?59,"|",!
 Q
LINE5 ;EP
 W $$REPEAT^XLFSTR("_",29),?29,"|",$$REPEAT^XLFSTR("_",9),?39,"|",$$REPEAT^XLFSTR("_",9),?49,"|",$$REPEAT^XLFSTR("_",9),?50,"|",$$REPEAT^XLFSTR("_",9),?59,"|",! ;,$$REPEAT^XLFSTR("_",9),?79,"|",!
 Q
LINE ;EP
 W $$REPEAT^XLFSTR("_",69),?59,"|",!
 Q
