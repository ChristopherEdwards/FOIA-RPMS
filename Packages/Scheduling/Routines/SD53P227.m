SD53P227 ;ALB/RBS - Cleanup Encounter/Visit Date/Time 421 error ; 10/11/00 5:24pm
 ;;5.3;Scheduling;**227**;AUG 13, 1993
 ;
 ;DBIA Integration Reference # 3211.
 ;
 ;This routine will search for Encounters that have an invalid date
 ;and time setup causing a 421 error code to be setup.
 ;An attempt will be made to cleanup the date/time.
 ;Two options are provided for finding or fixing the 421 errors.
 ;The report will detail all 421 Encounters that can-not or can be
 ;fixed and flagged for retransmittion to the NCPD.
 ;An e-mail summary will be sent to the user running this utility.
 ;
 ;The ^XTMP global will be used as an audit file of all encounters
 ;that have been fixed and retransmitted to the NPCD.
 ;The purge date will be 30 days from last Cleanup option run.
 ; ^XTMP("SD53P227",0)=STRING of 10 fields
 ;  STRING = purge date^run date^start dt/time^stop dt/time...
 ;           ^option run^last cleanup d/t run^DUZ of user...
 ;           ^tot errors^tot fixed^tot searched
 ; ^XTMP("SD53P227",1)=error node of encounters that can't be fixed
 ; ^XTMP("SD53P227",2)=encounters that can be fixed and re-sent
 ; ^XTMP("SD53P227",3)=e-mail report sent to user
 ; ^XTMP("SD53P227,"SENT")=audit trial of all encounters fixed
 Q
 ;*;
START ;Check for Programmer DUZ(0)="@", then Prompt for Device.
 N EXIT,SDRTYP,TITLE,TXT,X,Y
 N ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTSK,ZTSAVE,ZTQUEUED,ZTREQ,%ZIS
 D TITLE
 I $G(DUZ)<1 W !!,$C(7),"DUZ must be defined to run this utility!" Q
 I DUZ(0)'="@" D  Q
 .W !!,$C(7),"     Sorry, you may not access this utility program!"
 .W !,"     To insure that data updates contained in this patch are"
 .W !,"     installed correctly, DUZ(0) must be equal the ""@"" symbol!",!! H 3
 ;
 L +^XTMP("SD53P227"):2
 I '$T D  Q
 .W !!,$C(7),"* This utility is already running.  Please try later. *",! H 3
 ;
 S EXIT=0
 I $D(^XTMP("SD53P227")) D
 .S X=$G(^XTMP("SD53P227",0))
 .Q:X=""
 .I $P(X,U,4)="" D  Q
 ..S EXIT=1
 ..W !!!,$C(7),"* This utility is currently running.  Start D/T:  ",$$FMTE^XLFDT($P(X,U,3)),! H 3
 .; if cleanup already run, ask user if they want to run again...
 .I $D(^XTMP("SD53P227","SENT")) D
 ..W !!,$C(7),"* WARNING * The 'C'  (Clean Up & Report) option has already been run"
 ..W !?12,"on:  ",$$FMTE^XLFDT($P(X,U,6)),!
 ..S EXIT=$$ASK()
 ..I EXIT'=1 S EXIT=1 Q    ;user didn't answer 'Y'es.
 ..S EXIT=0
 I EXIT D EXIT Q
 ;
 ; Prompt user for option to run...
 D TITLE,MSG
 I $$REPORT(.SDRTYP)'>-1 D EXIT Q
 ;
 W !!
 L -^XTMP("SD53P227")
 ;
 S %ZIS="Q" S:SDRTYP="C" %ZIS="Q0"        ;0=can't use own $IO
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D QUEUE Q
 D RUN,^%ZISC
 Q
 ;
QUEUE ; queue the report
 S ZTSAVE("SDRTYP")="",ZTSAVE("TITLE")=""
 S ZTRTN="RUN^SD53P227",ZTDESC="Cleanup Encounters w/421 error code"
 D ^%ZTLOAD
 I $D(ZTSK)[0 W !!?5,"Unable to schedule Task.",!
 E  W !!?5,"Scheduled as Task #: ",ZTSK
 D HOME^%ZIS
 Q
 ;
 ;
RUN ;Loop the 409.75 Transmitted Outpatient Encounter Error file
 L +^XTMP("SD53P227"):2
 I '$T D  Q
 .N SDMSG,XMSUB,XMDUZ,XMDUN,XMTEXT,XMY
 .S XMSUB=TITLE,(XMDUZ,XMDUN)="Patch SD*5.3*227",XMY(DUZ)=""
 .S SDMSG(1)="*WARNING*  Processing not started."
 .S SDMSG(2)="           Unable to LOCK error."
 .S SDMSG(3)="           Please check system."
 .S XMTEXT="SDMSG("
 .D ^XMD
 I '$D(ZTQUEUED),IOST?1"C-".E  D WAIT^DICD
 N CRT,EXIT,FIX,RUNDT,SDI,SDL,SDTEMP,TIMESTRT,X,Y
 S TIMESTRT=$$NOW^XLFDT()                            ;starting time
 S (CRT,EXIT,FIX,SDL)=0,(SDI,X)=""
 I '$D(ZTQUEUED),IOST?1"C-".E S CRT=1                ;print to screen
 S:SDRTYP="C" FIX=1                                  ;re-set date/time
 ;
 ; create ^XTMP() file to save fixed records
 I '$D(^XTMP("SD53P227","SENT")) K ^XTMP("SD53P227")
 ; If already run, don't kill node of encounters already fixed...
 I $D(^XTMP("SD53P227","SENT")) D
 .S X=^XTMP("SD53P227",0)
 .F SDI=1,2,3 K ^XTMP("SD53P227",SDI)
 ; setup 0 node info
 S $P(X,U)=$$HTFM^XLFDT(+$H+30),$P(X,U,2)=$$DT^XLFDT()
 S $P(X,U,3)=TIMESTRT,$P(X,U,4)="",$P(X,U,5)=SDRTYP,$P(X,U,7)=DUZ
 S:FIX $P(X,U,6)=TIMESTRT
 S ^XTMP("SD53P227",0)=X,SDTEMP="^XTMP(""SD53P227"")"
 ;
 D FIND^SD53227P                           ;search for encounters
 ;
 I EXIT D MAIL,EXIT Q                      ;early exit
 D PRINT^SD53227,MAIL,EXIT                 ;do printing & e-mail
 S ZTREQ="@"
 Q
 ;
 ;
MAIL ;Send mail message
 N XMSUB,XMDUZ,XMDUN,XMTEXT,XMY,XMZ
 S XMSUB="SD53P227 Encounter Report"_$S(SDRTYP="R":"",1:" & Cleanup")
 S (XMDUZ,XMDUN)="SD*5.3*227",XMY(DUZ)=""
 S XMTEXT="^XTMP(""SD53P227"",3,"
 D ^XMD
 Q
 ;
EXIT ;Clean up and quit
 ;check to see if process ran
 N X
 I $D(TIMESTRT) D
 .S X=@SDTEMP@(0),$P(X,U,4)=$$NOW^XLFDT(),@SDTEMP@(0)=X    ;stop d/t
 ;
 L -^XTMP("SD53P227")
 Q
 ;
REPORT(SDR) ;Select Utility action type
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="S^R:REPORT ONLY;C:CLEAN UP & REPORT",DIR("A")="Select utility format"
 S DIR("?",1)="          R - (REPORT ONLY) - will produce a mail message report of Encounter"
 S DIR("?",2)="              records (#409.75 file) with a 421 error code."
 S DIR("?",3)="          C - (CLEAN UP & REPORT) - will fix both the Encounter (409.68 file)"
 S DIR("?",4)="              and Visit (#9000010 file) records that are found and produce"
 S DIR("?")="              a mail message report of those records."
 W !!,$C(7) D ^DIR K DIR
 I $D(DIRUT)!$D(DTOUT)!$D(DUOUT) S Y=-1 Q Y
 S SDR=Y
 Q Y
 ;
ASK() ; Ask user to contuine or not
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 S DIR(0)="Y"
 S DIR("A")="Do you want to continue",DIR("B")="NO"
 D ^DIR K DIR
 I $D(DIRUT)!$D(DTOUT)!$D(DUOUT) Q 0
 Q Y
 ;
MSG ; List information message
 W !!,"This utility will Report on and Clean Up Encounter Date/Time"
 W !,"error code 421 entries in the #409.75 and #9000010 files."
 W !,"Both options will E-mail a summary report to the user."
 W !,"Updated entries will be flagged for Retransmission to the NPCD."
 W !!,"The REPORT ONLY option does NOT update any file information."
 W !,"You may run the REPORT ONLY option to your CRT or to a device."
 W !,"The CLEAN UP & REPORT option MUST be queued to a device."
 Q
 ;
TITLE ; Screen title
 W @IOF
 S TITLE="SD*5.3*227 Encounter 421 Error Report & Cleanup"
 W !!,?(80-$L(TITLE)\2),TITLE
 S X=$$HTE^XLFDT($H)
 W !,?(80-$L(X)\2),X
 Q
