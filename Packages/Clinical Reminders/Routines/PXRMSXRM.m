PXRMSXRM ; SLC/PKR - Main driver for building indexes. ;29-Oct-2012 10:39;DU
 ;;1.5;CLINICAL REMINDERS;**12,1009**;Jun 19, 2000;Build 24
 ;Patch 1009 added indices for V PRC and V MEASUREMENTS
 Q
 ;===============================================================
ADDERROR(GLOBAL,IDEN,NERROR) ;Add to the error list.
 S NERROR=NERROR+1
 S ^TMP("PXRMERROR",$J,NERROR,0)="GLOBAL: "_GLOBAL_" ENTRY: "_IDEN
 Q
 ;
 ;===============================================================
ASKTASK() ;See if this should be tasked.
 N DIR,X,Y
 S DIR(0)="YO"
 S DIR("A")="Do you want this to be tasked"
 S DIR("B")="Y"
 D ^DIR
 I $D(DUOUT)!$D(DTOUT) Q ""
 Q Y
 ;
 ;===============================================================
COMMSG(GLOBAL,START,END,NE,NERROR) ;Send a MailMan message providing
 ;notification that the indexing completed.
 N XMSUB
 K ^TMP("PXRMXMZ",$J)
 S XMSUB="Index for global "_GLOBAL_" sucessfully built"
 S ^TMP("PXRMXMZ",$J,1,0)="Build of Clinical Reminders index for global "_GLOBAL_" completed."
 S ^TMP("PXRMXMZ",$J,2,0)="Build finished at "_$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
 S ^TMP("PXRMXMZ",$J,3,0)=NE_" entries were created."
 S ^TMP("PXRMXMZ",$J,4,0)=$$ETIME(START,END)
 S ^TMP("PXRMXMZ",$J,5,0)=NERROR_" errors were encountered."
 I NERROR>0 S ^TMP("PXRMXMZ",$J,6,0)="Another MailMan message will contain the error information."
 D SEND^PXRMMSG(XMSUB)
 Q
 ;
 ;===============================================================
DETIME(START,END) ;Write out the elapsed time.
 N TEXT
 S TEXT=$$ETIME(START,END)
 D MES^XPDUTL(TEXT)
 Q
 ;
 ;===============================================================
ERRMSG(NERROR,GLOBAL) ;If there were errors send an error message.
 N END,IND,MAXERR,NE,XMSUB
 I NERROR=0 Q
 ;Return the last MAXERR errors
 S MAXERR=+$G(^PXRM(800,1,"MIERR"))
 I MAXERR=0 S MAXERR=200
 K ^TMP("PXRMXMZ",$J)
 S END=$S(NERROR'>MAXERR:NERROR,1:MAXERR)
 S NE=NERROR+1
 F IND=1:1:END S NE=NE-1,^TMP("PXRMXMZ",$J,IND,0)=^TMP("PXRMERROR",$J,NE,0)
 I END=MAXERR S ^TMP("PXRMXMZ",$J,MAXERR+1,0)="GLOBAL: "_GLOBAL_"- Maximum number of errors reached, will not report any more."
 K ^TMP("PXRMERROR",$J)
 S XMSUB="CLINICAL REMINDER INDEX BUILD ERROR(S) FOR GLOBAL "_GLOBAL
 D SEND^PXRMMSG(XMSUB)
 Q
 ;
 ;===============================================================
ETIME(START,END) ;Calculate and format the elapsed time.
 N ETIME,TEXT
 S ETIME=$$HDIFF^XLFDT(END,START,2)
 I ETIME>90 D
 . S ETIME=$$HDIFF^XLFDT(END,START,3)
 . S TEXT="Elapsed time: "_ETIME
 E  S TEXT="Elapsed time: "_ETIME_" secs"
 Q TEXT
 ;
 ;===============================================================
INDEX ;Driver for building the various indexes.
 N GBL,LIST,ROUTINE,TASKIT
 ;S ROUTINE(45)="INDEX^DGPTDDCR" ;DBIA 4521
 S ROUTINE(52)="PSRX^PSOPXRMI"  ;DBIA 4522
 S ROUTINE(55)="PSPA^PSSSXRD"   ;DBIA 4172
 S ROUTINE(63)="LAB^LRPXSXRL"   ;DBIA 4247
 S ROUTINE(70)="RAD^RAPXRM"     ;DBIA 3731
 S ROUTINE(100)="INDEX^ORPXRM"  ;DBIA 4498
 ;IHS/MSC/MGH 120.5 and mental health not used by IHS
 ;S ROUTINE(120.5)="VITALS^GMVPXRM"  ;DBIA 3647
 ;S ROUTINE(601.2)="INDEX^YTPXRM" ;DBIA 4523
 S ROUTINE(9000011)="INDEX^GMPLPXRM" ;DBIA 4516
 S ROUTINE(9000010.07)="VPOV^PXPXRMI2" ;DBIA 4520
 S ROUTINE(9000010.11)="VIMM^PXPXRMI1" ;DBIA 4519
 S ROUTINE(9000010.12)="VSK^PXPXRMI2"  ;DBIA 4520
 S ROUTINE(9000010.13)="VXAM^PXPXRMI2" ;DBIA 4520
 S ROUTINE(9000010.16)="VPED^PXPXRMI2" ;DBIA 4520
 S ROUTINE(9000010.18)="VCPT^PXPXRMI1" ;DBIA 4519
 S ROUTINE(9000010.23)="VHF^PXPXRMI1"  ;DBIA 4519
 ;Patch 10009 add routines to build indices for non-VA V files
 S ROUTINE(9000010.01)="VMEA^BPXRMDX1"
 S ROUTINE(9000010.08)="VPRC^BPXRMDX1"
 ;Get the list
 W !,"Which indexes do you want to (re)build?"
 D SEL(.LIST,.GBL)
 I LIST="" Q
 ;See if this should be tasked.
 S TASKIT=$$ASKTASK
 I TASKIT D
 . W !,"Queue the Clinical Reminders index job."
 . D TASKIT(LIST,.GBL,.ROUTINE)
 E  D RUNNOW(LIST,.GBL,.ROUTINE)
 Q
 ;
 ;===============================================================
RUNNOW(LIST,GBL,ROUTINE) ;Run the routines now.
 N IND,LI,NUM,RTN
 S NUM=$L(LIST,",")-1
 F IND=1:1:NUM D
 . S LI=$P(LIST,",",IND)
 . S RTN=ROUTINE(GBL(LI))
 . D @RTN
 Q
 ;
 ;===============================================================
SEL(LIST,GBL) ;Select global list
 ;Patch 1009 Added and removed selections for IHS
 N ALIST,DIR,DTOUT,DUOUT,X,Y
 S ALIST(1)="  1 - LABORATORY TEST (CH, Anatomic Path, Micro)",GBL(1)=63
 ;S ALIST(2)="  2 - MENTAL HEALTH",GBL(2)=601.2     ;1009
 S ALIST(2)="  2 - ORDER",GBL(2)=100
 ;S ALIST(3)="  3 - PTF",GBL(3)=45
 S ALIST(3)="  3 - PHARMACY PATIENT",GBL(3)=55
 S ALIST(4)="  4 - PRESCRIPTION",GBL(4)=52
 S ALIST(5)="  5 - PROBLEM LIST",GBL(5)=9000011
 S ALIST(6)="  6 - RADIOLOGY",GBL(6)=70
 S ALIST(7)="  7 - V CPT",GBL(7)=9000010.18
 S ALIST(8)="  8 - V EXAM",GBL(8)=9000010.13
 S ALIST(9)="  9 - V HEALTH FACTORS",GBL(9)=9000010.23
 S ALIST(10)="  10 - V IMMUNIZATION",GBL(10)=9000010.11
 S ALIST(11)="  11 - V PATIENT ED",GBL(11)=9000010.16
 S ALIST(12)="  12 - V POV",GBL(12)=9000010.07
 S ALIST(13)="  13 - V SKIN TEST",GBL(13)=9000010.12
 ;S ALIST(16)="  14 - VITAL MEASUREMENT",GBL(14)=120.5   ;1009
 S ALIST(14)="  14 - V MEASUREMENT",GBL(14)=9000010.01   ;1009
 S ALIST(15)="  15 - V PROCEDURE",GBL(15)=9000010.08     ;1009
 M DIR("A")=ALIST
 S DIR("A")="Enter your list"
 S DIR(0)="LO^1:15"
 D ^DIR
 I $D(DUOUT)!$D(DTOUT) S LIST="" Q
 S LIST=Y
 Q
 ;
 ;===============================================================
TASKIT(LIST,GBL,ROUTINE) ;Build the indexes as a tasked job.
 N DIR,DTOUT,DUOUT,MINDT,SDTIME,X,Y
 S MINDT=$$NOW^XLFDT
 ;W !,"Queue the Clinical Reminders index job."
 S DIR("A",1)="Enter the date and time you want the job to start."
 S DIR("A",2)="It must be after "_$$FMTE^XLFDT(MINDT,"5Z")
 S DIR("A")="Start the task at: "
 S DIR(0)="DAU"_U_MINDT_"::RSX"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 S SDTIME=Y
 K DIR
 ;Put the task into the queue.
 K ZTSAVE
 S ZTSAVE("LIST")=""
 S ZTSAVE("GBL(")=""
 S ZTSAVE("ROUTINE(")=""
 S ZTRTN="TASKJOB^PXRMSXRM"
 S ZTDESC="Clinical Reminders index build"
 S ZTDTH=SDTIME
 S ZTIO=""
 D ^%ZTLOAD
 W !,"Task number ",ZTSK," queued."
 Q
 ;
 ;===============================================================
TASKJOB ;Execute as tasked job. LIST, GBL, and ROUTINE come through
 ;ZTSAVE.
 N IND,LI,NUM,RTN
 S ZTREQ="@"
 S ZTSTOP=0
 S NUM=$L(LIST,",")-1
 F IND=1:1:NUM D
 .;Check to see if the task has had a stop request
 . I $$S^%ZTLOAD S ZTSTOP=1,IND=NUM Q
 . S LI=$P(LIST,",",IND)
 . S RTN=ROUTINE(GBL(LI))
 . D @RTN
 Q
 ;
