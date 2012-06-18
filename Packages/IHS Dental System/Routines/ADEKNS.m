ADEKNS ; IHS/HQT/MJL -REPORTS INSTALL ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
 ;
 ;This routine runs at post-init
 ;initiates the compilation of dental data.
 ;The routine follows these steps:
 ;1) Checks the quarter prior to the current qtr
 ;   for existence of dental data.
 ;2) If data exists, queues itself to compile data for
 ;   that prior quarter
 ;3) Compiles data for the current quarter.
 ;This queueing loop continues until there's no dental data
 ;left to compile.
 ;
 ;Enter at top for interactive session
 I '$D(^ADEKOB(1,0)) D  G END
 . W !!,"The DENTAL PROGRAM OBJECTIVES File and its "
 . W !,"data global (^ADEKOB) must be installed before running this routine."
 Q:'$$CONFIRM()
EN ;EP -Enter here to bypass interactive prompts
 ;called here by post-init
 I '$D(^ADEKOB(1,0)) G END
 N ADEYQ,ADESELOB,ZTDTH
 S ADEYQ=$$QTR^ADEKNT5(DT)
 S ADESELOB="ALL"
 S ZTDTH=$H
 K ^ADEUTL("ADEKNT_TIME")
 D QUEUE(ZTDTH,$P(ADEYQ,U),ADESELOB)
END Q
 ;
 ;
QUEUE(ZTDTH,ADEYQ,ADESELOB) ;EP
 ;- Call to reque ADEKNS to run at time ZTDTH ($H-format)
 ;  to compile data for YR.Q ADEYQ for objectives ADESELOB
 N ZTRTN,ZTDESC,ZTIO,ZTSAVE
 S ZTRTN="START^ADEKNS",ZTDESC="DENTAL STATS "_ADEYQ,ZTIO="",ZTSAVE("ADEYQ")="",ZTSAVE("ADESELOB")="" D ^%ZTLOAD
 ;
 Q
 ;
START ;EP
 ;TASKMAN ENTERS HERE
 ;
 ;If the quarter previous to ADEYQ has dental data,
 ; then this routine requeues itself to compile that quarter.
 ;Called with ADEYQ and ADESELOB defined
 N ADEPRE
 S ADEPRE=$$BACK^ADEKRP(ADEYQ)
 ;Y2K - FHL 09/03/98
 ;I $$HASDATA(ADEPRE) D
 ;Y2K - FHL 09/03/98
 I ADEPRE,$$HASDATA(ADEPRE) D
 . S ZTDTH=$$ADDMIN^ADEKNT3($H,(15*60)) ;Default requeue is 10 hours
 . I $D(^ADEUTL("ADEKNT_TIME")) S ZTDTH=$$ADDMIN^ADEKNT3($H,^("ADEKNT_TIME"))
 . D QUEUE(ZTDTH,ADEPRE,ADESELOB)
 ;
 ;Do current quarter
 D KNS^ADEKNT(ADEYQ,ADESELOB)
 ;
 K ADEYQ,ADESELOB
 Q
 ;
HASDATA(ADEYQ)     ;EP
 ;RETURNS TRUE IF THE PERIOD ADEYQ CONTAINS DENTAL DATA
 ;OTW FALSE
 S ADEYQ=$$PERIOD^ADEKNT5($P(ADEYQ,"."),+$P(ADEYQ,".",2))
 ;Y2K - FHL 09/03/98
 Q:'ADEYQ 0
 I '$D(^ADEPCD("AC")) Q 0
 I ($O(^ADEPCD("AC",$P(ADEYQ,U,2)),-1))'<($P(ADEYQ,U,5)) Q 1
 Q 0
 ;
CONFIRM() ;Return 1 if ok to go, otw 0
 N DIR
 S DIR(0)="YA",DIR("B")="YES"
 W !!,"This routine (^ADEKNS) will compile dental program statistics"
 W !,"using the data in the Dental program files."
 ;W !!,"You should complete installation of the DENTAL ENHANCED REPORTS"
 ;W !,"Package BEFORE running this routine, including the assignment of"
 ;W !,"mail groups to the new Bulletin."
 W !!,"This routine need only be run one time at initial installation."
 W !,"No harm will be done, however, if the routine runs more than once.",!
 S DIR("A")="Continue? "
 D ^DIR
 I $$HAT^ADEPQA Q 0
 Q Y
