BCHEXC ; IHS/TUCSON/LAB - MAIN DRIVER FOR CHR EXPORT RECORD CHECK ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
 ;
 ;Main routine for the export record check option.
 ;
 ;
START ;
 D INFORM
 S BCH("QFLG")=0
 D GETLOG^BCHEXDI2
 I BCH("QFLG") G EOJ
CURRUN ;EP - COMPUTE DATES FOR CURRENT RUN
 S BCHBD=""
 I BCH("LAST LOG") S X1=$P(^BCHXLOG(BCH("LAST LOG"),0),U,2),X2=1 D C^%DTC S BCHBD=X,Y=X D DD^%DT
 I BCHBD="" D FIRSTRUN
 Q:BCH("QFLG")
 S Y=DT
 I Y<BCHBD W !!,"  Ending date cannot be before beginning date!",$C(7) S BCH("QFLG")=18 Q
 S BCHED=Y
 S Y=BCHBD X ^DD("DD") S BCH("X")=Y
 S Y=BCHED X ^DD("DD") S BCH("Y")=Y
 W !!,"This report will review records that were posted between ",BCH("X"),!," and ",BCH("Y"),", inclusive."
 K %,%H,%I,BCH("RDFN"),BCH("X"),BCH("Y"),BCH("LAST LOG"),BCH("LAST BEGIN"),BCH("Z"),BCH("DATE")
 ;
 W !! S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:$D(DIRUT) EOJ
 I 'Y W !!,"okay, bye." G EOJ
ZIS ;
 S XBRP="^BCHEXCP",XBRC="^BCHEXC1",XBRX="EOJ^BCHEXC",XBNS="BCH"
 D ^XBDBQUE
 D EOJ
 Q
FIRSTRUN ; FIRST RUN EVER (NO LOG ENTRY)
FRLP ;
 S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Posting Date to review records" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCH("QFLG")=99 Q
 S BCHBD=Y
 S BCH("FIRST RUN")=1
 Q
 ;
EOJ ;
 K BCHR,BCH,BCHBD,BCHBDD,BCHED,BCHEDD,BCHPAT,BCHPROG,BCHCAT,BCHACT,BCHHRCN,BCHSD,DFN,BCH80D,BCH80E,BCHAFF,BCHBT,BCHBTH,BCHC,BCHCOM,BCHDATE,BCHDISC,BCHDUZ2,BCHE,BCHINI,BCHJOB,BCHLOC,BCHNAME,BCHO,BCHODAT,BCHPG,BCHQUIT,BCHRCNT
 K BCHREC,BCHTMP,BCHTX,BCHX,X,Y,BCHLENG,Z,CLS,BCHCPOV,BCHAGE,BCHPOVD
 K DIR,DIC,DA,D0
 Q
INFORM ;
 W:$D(IOF) @(IOF)
 W !!,"This program will review all records that have been posted to the CHR",!,"database since that last export was done.  It will review all records that",!,"were posted from the day after the last date of that run up until 2 days ago.",!!
 Q
