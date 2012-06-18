BWRPPCD ;IHS/ANMC/MWR - REPORT: PROCEDURES STATISTICS;15-Feb-2003 22:09;PLS
 ;;2.0;WOMEN'S HEALTH;**6,8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "BW PRINT PROCEDURE STATS".
 ;
 D SETVARS^BWUTL5 S BWPOP=0 K BWRES
 D TITLE^BWUTL5("PROCEDURE STATISTICS REPORT")
 D DATES                  G:BWPOP EXIT
 D SELECT                 G:BWPOP EXIT
 D CURCOM                 G:BWPOP EXIT ;IHS/CMI/LAB - added current community screen
 D BYAGE(.BWAGRG,.BWPOP)  G:BWPOP EXIT
 D DEVICE                 G:BWPOP EXIT
 D ^BWRPPCD2
 D COPYGBL
 D ^BWRPPCD1
 ;
EXIT ;EP
 D KILLALL^BWUTL8
 Q
 ;
 ;
DATES ;EP
 ;---> ASK DATE RANGE.  RETURN DATES IN BWBEGDT AND BWENDDT.
 D ASKDATES^BWUTL3(.BWBEGDT,.BWENDDT,.BWPOP,"T-365","T")
 Q
 ;
SELECT ;EP
 D SELECT^BWSELECT("Procedure Type",9002086.2,"BWARR","","",.BWPOP)
 Q
 ;
CURCOM ;
 ;IHS/CMI/LAB - added this subroutine to screen on current comm
 ;---> SELECT CASES FOR ONE OR MORE CURRENT COMMUNITY (OR ALL).
 ;---> DO NOT PROMPT FOR CURRENT COMMUNITY IF THIS IS A VA SITE.
 I $$AGENCY^BWUTL5(DUZ(2))'="i" D  Q  ;IHS/ANMC/MWR 11/20/96
 .S BWCC("ALL")=""                    ;IHS/ANMC/MWR 11/20/96
 ;---> SELECT CURRENT COMMUNITY(S).
 D TEXT2^BWRPSCR K BWTAB,BWLINL
 ;D SELECT^BWSELECT("Current Community",9999999.05,"BWCC","","",.BWPOP)
 K BWCC
 S DIR(0)="S^O:One particular Community;A:All Communities;S:Selected Set of Communities (Taxonomy)",DIR("A")="List children who live in",DIR("B")="O" K DA D ^DIR K DIR
 I $D(DIRUT) S BWPOP=1 Q
 I Y="A" W !!,"All communities will be included in the report.",! S BWCC("ALL")="" Q
 I Y="O" D  Q:$D(BWCC)  I 1
 .S DIC="^AUTTCOM(",DIC(0)="AEMQ",DIC("A")="Which COMMUNITY: " D ^DIC K DIC
 .Q:Y=-1
 .S BWCC($P(^AUTTCOM(+Y,0),U))=""
 S X="COMMUNITY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G CURCOM
 D ^AMQQGTX0(+Y,"BWCC(")
 I '$D(BWCC) G CURCOM
 I $D(BWCC("*")) S BWCC("ALL")=""
 Q
 ;
BYAGE(BWAGRG,BWPOP) ;EP
 ;---> RETURN AGE RANGE IN BWAGRG.
 N DIR,DIRUT,Y S BWPOP=0
 W !!?3,"Do you wish to display statistics by age group?"
 S DIR(0)="Y",DIR("B")="YES" D HELP1
 S DIR("A")="   Enter Yes or No"
 D ^DIR K DIR W !
 S:$D(DIRUT) BWPOP=1
 ;---> IF NOT DISPLAYING BY AGE GROUP, SET BWAGRG (AGE RANGE)=1, QUIT.
 I 'Y S BWAGRG=1 Q
BYAGE1 ;
 W !?5,"Enter the age ranges you wish to select for in the form of:"
 W !?5,"  15-29,30-39,40-105"
 W !?5,"Use a dash ""-"" to separate the limits of a range,"
 W !?5,"use a comma to separate the different ranges."
 W !!?5,"NOTE: Patient ages will reflect the age they were on the"
 W !?5,"      dates of their procedures.  Patient ages will NOT"
 W !?5,"      necessarily be their ages today.",!
 K DIR D HELP2
 S DIR(0)="FOA",DIR("A")="     Enter age ranges: "
 S:$D(^BWAGDF(DUZ,0)) DIR("B")=$P(^(0),U,2)
 D ^DIR K DIR
 I $D(DIRUT) S BWPOP=1 Q
 D CHECK(.Y)
 I Y="" D  G BYAGE1
 .W !!?5,"* INVALID AGE RANGE.  Please begin again. (Enter ? for help.)"
 ;---> BWAGRG=SELECTED AGE RANGE(S).
 S BWAGRG=Y
 D DIC^BWFMAN(9002086.72,"L",.Y,"","","","`"_DUZ)
 Q:Y<0
 D DIE^BWFMAN(9002086.72,".02////"_BWAGRG,+Y,.BWPOP,1)
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="DEQUEUE^BWRPPCD"
 F BWSV="AGRG","BEGDT","ENDDT" D
 .I $D(@("BW"_BWSV)) S ZTSAVE("BW"_BWSV)=""
 ;---> SAVE PROCEDURES ARRAY.
 I $D(BWARR) N N S N=0 F  S N=$O(BWARR(N)) Q:N=""  D
 .S ZTSAVE("BWARR("""_N_""")")=""
 D ZIS^BWUTL2(.BWPOP,1)
 Q
 ;
COPYGBL ;EP
 ;---> COPY BWRES("R") TO BWAR( TO MAKE IT FLAT.
 N I,M,N K BWAR
 S N=0,I=0
 F  S N=$O(BWRES("R",N)) Q:N=""  D
 .S M=0
 .F  S M=$O(BWRES("R",N,M)) Q:M=""  D
 ..S I=I+1,BWAR(I)=BWRES("R",N,M)
 Q
 ;
 ;
DEQUEUE ;EP
 ;---> TASKMAN QUEUE OF PRINTOUT.
 D SETVARS^BWUTL5,^BWRPPCD2,COPYGBL,^BWRPPCD1,EXIT
 Q
 ;
HELP1 ;EP
 ;;Answer "YES" to display statistics by age group.  If you choose
 ;;to display by age group, you will be given the opportunity to
 ;;select the age ranges.  For example, you might choose to display
 ;;from ages 15-40,41-65,65-99.
 ;;Answer "NO" to display statistics without grouping by age.
 S BWTAB=5,BWLINL="HELP1" D HELPTX
 Q
 ;
HELP2 ;EP
 ;;Enter each age range you which to report on by entering the
 ;;earlier age-dash-older age.  For example, 20-29 would report
 ;;on all patients between the ages of 20 and 29 inclusive.
 ;;You may select as many age ranges as you wish.  Age ranges must
 ;;be separated by commas.  For example: 15-19,20-29,30-39
 ;;To select only one age, simply enter that age, with no dashes,
 ;;for example, 30 would report only on women who were 30 years
 ;;of age.
 S BWTAB=5,BWLINL="HELP2" D HELPTX
 Q
 ;
HELPTX ;EP
 ;---> CREATES DIR ARRAY FOR DIR.  REQUIRED VARIABLES: BWTAB,BWLINL.
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  S DIR("?",I)=T_$P(X,";;",2)
 S DIR("?")=DIR("?",I-1) K DIR("?",I-1)
 Q
 ;
CHECK(X) ;EP
 ;---> CHECK SYNTAX OF AGE RANGE STRING.
 ;---> IF X=ONE AGE ONLY, SET IT IN THE FORM X-X AND QUIT.
 I X?1N.N S X=X_"-"_X Q
 ;
 N BW1,FAIL,I,Y,Y1,Y2
 S FAIL=0
 ;---> CHECK EACH RANGE.
 F I=1:1:$L(X,",") S Y=$P(X,",",I) D  Q:FAIL
 .S Y1=$P(Y,"-"),Y2=$P(Y,"-",2)
 .;---> EACH END OF EACH RANGE SHOULD BE A NUMBER.
 .I (Y1'?1N.N)!(Y2'?1N.N) S FAIL=1 Q
 .;---> THE LOWER NUMBER SHOULD BE FIRST.
 .I Y2<Y1 S FAIL=1
 I FAIL S X="" Q
 ;
 ;---> MAKE SURE ORDER IS FROM LOWEST (YOUNGEST) TO HIGHEST (OLDEST).
 F I=1:1:$L(X,",") S Y=$P(X,",",I),Y1=$P(Y,"-"),BW1(Y1)=Y
 S N=0,X=""
 F  S N=$O(BW1(N)) Q:'N  S X=X_BW1(N)_","
 S:$E(X,$L(X))="," X=$E(X,1,($L(X)-1))
 Q
