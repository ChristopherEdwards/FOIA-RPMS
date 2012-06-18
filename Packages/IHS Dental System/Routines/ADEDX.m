ADEDX ; IHS/HQT/MJL  - DENTAL PKG DIAGNOSTICS ;12:47 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;Enter at top to run entire diagnostic set
 ;Enter at specific labels to run a particular component
 S ZTRTN="ALL^ADEDX"
 D INIT
 I POP!($D(IO("Q"))) G END
ALL ;EP
 D HX G END:ADEQIT
 D BK G END:ADEQIT
 D EX
 G END
 ;
HISTORY ;EP Enter here to get installation history & status
 S ZTRTN="HX^ADEDX"
 D INIT
 I POP!($D(IO("Q"))) G END
 D HX
 G END
 ;
BKGRND ;EP Enter here for status of background processor
 S ZTRTN="BK^ADEDX"
 D INIT
 I POP!($D(IO("Q"))) G END
 D BK
 G END
 ;
EXTRACT ;EP Enter here to get extract log & count of unextracted records
 S ZTRTN="EX^ADEDX"
 D INIT
 I POP!($D(IO("Q"))) G END
 D HX
 G END
 ;
HX ;EP
 D EOP Q:ADEQIT
 W !!,"[INSTALLATION HISTORY AND CURRENT STATUS]",!
 D PKG Q:ADEQIT
 D ENTRIES Q:ADEQIT
 ;Get current DENTAL SITE PARAMETER settings
 D PARAM
 ;Check that bulletins are assigned to groups & get names in group
 Q
 ;
BK D DQRUN
 Q
 ;
EX ;Get extract log
 ;Count unextracted entries
 Q
END ;
 D ^%ZISC
 I $D(ZTQUEUED) S ZTREQ="@"
 K ADECNT,ADEJN,ADEQIT,ADEMSG,ADELF,ADELIN,ADENOD,ADEPAG,ADEPKG,ADESN,ADEVER,ADEJ
 Q
 ;
DQRUN D EOP Q:ADEQIT
 W !!,"[DENTAL BACKGROUND PROCESSOR]",!
 S (ADECNT,ADEJN)=0 I $D(^ADEUTL("ADELOCK")) F  S ADEJN=$O(^ADEUTL("ADELOCK",ADEJN)) Q:'+ADEJN  S ADECNT=ADECNT+1
 W !,$S(ADECNT=0:"No",1:ADECNT)," dental patient record(s) flagged as 'awaiting update'."
 S (ADECNT,ADEJN)=0 I $D(^ADEPOST(0)) F  S ADEJN=$O(^ADEPOST(ADEJN)) Q:'+ADEJN  S ADECNT=ADECNT+1
 D EOP Q:ADEQIT
 W !,$S(ADECNT=0:"No",1:ADECNT)," dental visit record(s) queued in the ADEPOST global."
 I ADECNT>0 W !,"^ADEPOST(0)=",^ADEPOST(0)
 S ADEMSG="0^No dental background job running according to KERNEL."
 S ADEJN=0 F  S ADEJN=$O(^XUTL("XQ",ADEJN)) Q:'+ADEJN  I $D(^XUTL("XQ",ADEJN,"ZTSK")),^XUTL("XQ",ADEJN,"ZTSK")="DENTAL DISC WRITES" D DQ1 Q
 D EOP Q:ADEQIT
 W !,$P(ADEMSG,U,2)
 I '+ADEMSG,$D(^ADEUTL("ADEDQUE")) D DQ2
 Q
DQ1 S ADEMSG="1^Dental background job running as Job# "_ADEJN
 I $D(^XUTL("XQ",ADEJN,0)) S Y=^XUTL("XQ",ADEJN,0) X ^DD("DD") S ADEMSG=ADEMSG_". Start time was "_Y
 Q
DQ2 W !!,"***It appears that the dental background routine is NOT running",!,"but that the dental package THINKS that it is.  To remedy, execute the",!,"EBAK option in the DEO submenu of the Dental Supervisor's menu.***"
 Q
PKG D EOP Q:ADEQIT
 ;W !,"RPMS SITE: ",$P(^DIC(4,$O(^AUTTSITE(0)),0),U)
 W !,"RPMS SITE: ",$P(^DIC(4,$P(^AUTTSITE($O(^AUTTSITE(0)),0),U),0),U)
 S ADEPKG=$O(^DIC(9.4,"B","IHS DENTAL",0))
 I '+ADEPKG W !,"No entry in PACKAGE file for IHS DENTAL" Q
 D EOP Q:ADEQIT
 W !,"CURRENT IHS DENTAL VERSION: ",$P(^DIC(9.4,ADEPKG,"VERSION"),U)
 I '$D(^DIC(9.4,ADEPKG,22)) W !,"No Installation history in PACKAGE file" Q
 D EOP Q:ADEQIT
 W !,"INSTALLATION HISTORY--",!?5,"VERSION",?20,"DATE INSTALLED"
 S ADEVER=0 F  S ADEVER=$O(^DIC(9.4,ADEPKG,22,ADEVER)) Q:'+ADEVER  D PKG1 D EOP Q:ADEQIT
 Q
PKG1 Q:'$D(^DIC(9.4,ADEPKG,22,ADEVER,0))
 S ADENOD=^DIC(9.4,ADEPKG,22,ADEVER,0)
 W !?5,$P(ADENOD,U)
 Q:'+$P(ADENOD,U,3)
 S Y=$P(ADENOD,U,3) X ^DD("DD") W ?20,Y
 Q
ENTRIES ;
 D EOP Q:ADEQIT
 W !!,"The DENTAL PROCEDURE File global (^ADEPCD) has ",$P(^ADEPCD(0),U,4)," entries."
 W !,"The first visit date in ADEPCD is "
 S Y=$O(^ADEPCD("AC",0))
 X ^DD("DD")
 W Y,"."
 Q
PARAM ;
 D EOP Q:ADEQIT
 W !!,"DENTAL SITE PARAMETER FILE"
 S ADESN=$O(^ADEPARAM(0))
 I '+ADESN W " HAS NOT BEEN SET UP!" Q
 S ADENOD=^ADEPARAM(ADESN,0)
PA W !?5,"DENTAL SITE NAME:   ",$P(^DIC(4,$P(ADENOD,U),0),U)
 W !?5,"LIMITED DATA ENTRY: ",$P(ADENOD,U,2) D EOP Q:ADEQIT
 W !?5,"BACKGROUND MODE:    ",$P(ADENOD,U,4) D EOP Q:ADEQIT
 W !?5,"PCC LINK ENABLED:   ",$P(ADENOD,U,5) D EOP Q:ADEQIT
 W !?5,"EXTRACT CONTRACT:   ",$P(ADENOD,U,6) D EOP Q:ADEQIT
 W !?5,"LOCAL FACILITIES:"
 S ADELF=0 F  S ADELF=$O(^ADEPARAM(ADESN,1,ADELF)) Q:'+ADELF  D PAR1,EOP Q:ADEQIT
 Q
PAR1 S ADENOD=^ADEPARAM(ADESN,1,ADELF,0)
 W !?10,$P(^DIC(4,$P(ADENOD,U),0),U)," (Universal Lookup ",$S($P(ADENOD,U,2)'=1:"not",1:"")," allowed.)"
 Q
INIT ;
 S U="^",ADEPAG=1,$P(ADELIN,"-",79)="",ADEQIT=0
 ;
ASKDEV S %ZIS="Q" D ^%ZIS Q:POP
 I $D(IO("Q")) D QUE W !,"REQUEST QUEUED." Q
 U IO
 Q
 ;
QUE S ZTDESC="DENTAL SOFTWARE DIAGNOSTICS"
 F ADEJ="ADEPAG","ADELIN","ADEQIT" S ZTSAVE(ADEJ)=""
 D ^%ZTLOAD
 K ADEJ
 Q
 ;
EOP I ADEPAG=1 D HEADER Q
 Q:$Y'>(IOSL-5)
EOP1 I $P(IOST,"-")["C" S DIR(0)="E" D ^DIR I 'Y!($D(DTOUT)) S ADEQIT=1 Q
 D HEADER
 Q
 ;
HEADER W:$D(IOF)&(ADEPAG'=1) @IOF
LINE W ?(IOM\2)-($L("DENTAL SOFTWARE DIAGNOSTICS -- Page "_ADEPAG)\2),"DENTAL SOFTWARE DIAGNOSTICS -- Page "_ADEPAG,!
 S ADEPAG=ADEPAG+1
 Q
