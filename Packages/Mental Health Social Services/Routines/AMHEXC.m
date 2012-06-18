AMHEXC ; IHS/CMI/LAB - MAIN DRIVER FOR PCC EXPORT RECORD CHECK ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;
START ;
 D INFORM
 S AMH("QFLG")=0
 D GETLOG^AMHEXDI2
 I AMH("QFLG") G EOJ
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S AMHBD=""
 I AMH("LAST LOG") S X1=$P(^AMHXLOG(AMH("LAST LOG"),0),U,2),X2=1 D C^%DTC S AMHBD=X,Y=X D DD^%DT
 I AMHBD="" D FIRSTRUN
 Q:AMH("QFLG")
 S Y=DT
 I Y<AMHBD W !!,"  Ending date cannot be before beginning date!",$C(7) S AMH("QFLG")=18 Q
 S AMHED=Y
 S Y=AMHBD X ^DD("DD") S AMH("X")=Y
 S Y=AMHED X ^DD("DD") S AMH("Y")=Y
 W !!,"This report will review records that were posted between ",AMH("X"),!," and ",AMH("Y"),", inclusive."
 K %,%H,%I,AMH("RDFN"),AMH("X"),AMH("Y"),AMH("LAST LOG"),AMH("LAST BEGIN"),AMH("Z"),AMH("DATE")
 ;
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) EOJ
 I 'Y W !!,"okay, bye." G EOJ
ZIS ;
 S XBRP="^AMHEXCP",XBRC="^AMHEXC1",XBRX="EOJ^AMHEXC",XBNS="AMH"
 D ^XBDBQUE
 D EOJ
 Q
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
FRLP ;
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Posting Date to review records" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMH("QFLG")=99 Q
 S AMHBD=Y
 S AMH("FIRST RUN")=1
 Q
 ;
EOJ ;
 K AMHR,AMH,AMHBD,AMHBDD,AMHED,AMHEDD,AMHPAT,AMHPROG,AMHCAT,AMHACT,AMHHRCN,AMHSD,DFN,AMH80D,AMH80E,AMHAFF,AMHBT,AMHBTH,AMHC,AMHCOM,AMHDATE,AMHDISC,AMHDUZ2,AMHE,AMHINI,AMHJOB,AMHLOC,AMHNAME,AMHO,AMHODAT,AMHPG,AMHQUIT,AMHRCNT
 K AMHREC,AMHTMP,AMHTX,AMHX,X,Y,AMHLENG,Z
 K DIR,DIC,DA,D0
 Q
INFORM ;
 W:$D(IOF) @(IOF)
 W !!,"This program will review all records that have been posted to the BH",!,"database since that last export was done.  It will review all records that",!,"were posted from the day after the last date of that run up until 2 days ago.",!!
 Q
