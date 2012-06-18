BWRPSCR ;IHS/ANMC/MWR - WOMEN'S HEALTH PCC LINK [ 09/07/99  7:19 AM ];15-Feb-2003 22:10;PLS
 ;;2.0;WOMEN'S HEALTH;**1,6,8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  THIS REPORT WILL DISPLAY SCREENING RATES FOR PAPS & MAMS.
 ;;  PATCHED AT LINELABEL CURCOM.  IHS/ANMC/MWR 11/20/96
 ;
PRINT ;EP
 ;---> DISPLAY PROCEDURE PCC .01 POINTERS.
 D SETUP
 D TITLE^BWUTL5("SCREENING RATES FOR PAPS AND MAMS")
 D TEXT1,DIRZ^BWUTL3 G:BWPOP EXIT
 D DATES   G:BWPOP EXIT
 D AGERNG  G:BWPOP EXIT
 D CURCOM  G:BWPOP EXIT
 D DEVICE  G:BWPOP EXIT
 D DATA^BWRPSCR1
 D DISPLAY
 ;
EXIT ;EP
 K AMQQTAX
 D KILLALL^BWUTL8
 Q
 ;
SETUP ;EP
 D SETVARS^BWUTL5
 Q
 ;
DATES ;EP
 ;---> ASK DATE RANGE.  RETURN DATES IN BWBEGDT AND BWENDDT.
 D ASKDATES^BWUTL3(.BWBEGDT,.BWENDDT,.BWPOP)
 Q
 ;
AGERNG ;EP
 ;---> ASK AGE RANGE.
 ;---> RETURN AGE RANGE IN BWAGRG.
 D AGERNG^BWRPSCR1(.BWAGRG,.BWPOP)
 Q
 ;
CURCOM ;EP
 ;---> SELECT CASES FOR ONE OR MORE CURRENT COMMUNITY (OR ALL).
 ;---> DO NOT PROMPT FOR CURRENT COMMUNITY IF THIS IS A VA SITE.
 ;I $$AGENCY^BWUTL5(DUZ(2))='"i" S BWCC("ALL")="" Q   ;VAMOD
 I $$AGENCY^BWUTL5(DUZ(2))'="i" D  Q  ;IHS/ANMC/MWR 11/20/96
 .S BWCC("ALL")=""                    ;IHS/ANMC/MWR 11/20/96
 ;---> SELECT CURRENT COMMUNITY(S).
 D TEXT2
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
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="DEQUEUE^BWRPSCR"
 F BWSV="AGRG","BEGDT","ENDDT" D
 .I $D(@("BW"_BWSV)) S ZTSAVE("BW"_BWSV)=""
 ;---> SAVE ATTRIBUTES ARRAY. NOTE: SUBSTITUTE LOCAL ARRAY FOR BWATT.
 I $D(BWCC) N N S N=0 F  S N=$O(BWCC(N)) Q:N=""  D
 .S ZTSAVE("BWCC("""_N_""")")=""
 D ZIS^BWUTL2(.BWPOP,1,"HOME")
 Q
 ;
 ;
DISPLAY ;EP
 U IO
 S BWTITLE="*  WOMEN'S HEALTH: SCREENING RATES FOR PAPS AND MAMS  *"
 D CENTERT^BWUTL5(.BWTITLE)
 D TOPHEAD^BWUTL7
 S BWPAGE=1,BWPOP=0
 S BWSUB="W !?3,""For Age Range: "",$S(BWAGRG=1:""ALL"",1:BWAGRG)"
 ;
 S (BWPOP,N,Z)=0
 W:BWCRT @IOF D HEADER8^BWUTL7
 F  S N=$O(^TMP("BW",$J,N)) Q:'N!(BWPOP)  D
 .I $Y+3>IOSL D:BWCRT DIRZ^BWUTL3 Q:BWPOP  D HEADER8^BWUTL7
 .W !,^TMP("BW",$J,N,0)
 W:'BWCRT !
 D ENDREP^BWUTL7(BWCRT)
 Q
 ;
DEQUEUE ;EP
 ;---> CALLED BY TASKMAN
 D SETUP,DATA^BWRPSCR1,DISPLAY,EXIT
 Q
 ;
TEXT1 ;
 ;;This report is designed to serve as an indicator of screening
 ;;rates for PAPs and MAMs.  The report will display the percentages
 ;;of women who received PAPs and MAMs for screening purposes only,
 ;;within the selected date range.
 ;;
 ;;Only patients who have had normal results for procedures in the
 ;;specified date range are counted; the intent is to exclude
 ;;any procedures that would involve abnormal results, diagnostic
 ;;and follow-up procedures, etc.  Due to the complexities
 ;;involved in the treatment of individual cases that involve
 ;;abnormal results, those patients will not be included, even
 ;;though some of them may have received screening PAPs or MAMs.
 ;;
 ;;This report, therefore, serves ONLY AS AN INDICATOR (NOT as an exact
 ;;count of screening rates) for gauging the success rates of annual
 ;;screening programs.  It can be run for several different time frames
 ;;in order to examine trends.  Assuming a screening cycle of one year,
 ;;a minimum date range spanning 15 months is recommended.
 S BWTAB=5,BWLINL="TEXT1" D PRINTX
 Q
 ;
TEXT2 ;EP
 ;;
 ;;You may limit this report to one or more specific communities,
 ;;or you may select all communities.  "Community" in this context
 ;;refers to the patient's "Current Community" as displayed and
 ;;edited in the IHS Registration software.
 S BWTAB=3,BWLINL="TEXT2" D PRINTX
 Q
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
