ADEPQA1B ; IHS/HQT/MJL - OUTPUT TYPE ;09:31 AM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 ;
OUTPUT ;EP
 ;Sets up variables for DIP call.  Options are Visit count, Code count
 ;Patient Count, Patient listing.  Variables returned are BY, FLDS
 ;The first comma element of BY is a sort template which contains the
 ;hits from the search.  Subsequent elements set up subtotal fields
 ;First, have to get the template name & DFN
 ;The template name may be user-specified. If user doesn't want
 ;to save results, program generates its own template.
 W !!,?5,"***STEP TWO:  Specify OUTPUT FORMAT***"
 S ADEROPT=$$ROPT^ADEPQA2() Q:$$HAT^ADEPQA()  ;Get report options
 S ADETFIL=9002007
 I $P(ADEROPT,U,2)="PATIENT" S ADETFIL=9000001
 S ADETNAM=$$USRTMP^ADEPQA1A(ADETFIL) G:$$HAT^ADEPQA() OUTPUT ; Create template on file ADETFILE
 S ADETDFN=$P(ADETNAM,U,2)
 S ADETNAM=$P(ADETNAM,U)
 D BY^ADEPQA2
 Q
 ;
ASKDEV ;EP
 K IOP
 S %ZIS="NQ" D ^%ZIS Q:POP
 S IOP=ION
 S %ZIS("IOPAR")=IOPAR
 ;FHL 9/9/98 I $D(IO("Q")) D QUE I '$D(ZTSK) K IOP G ASKDEV
 I $D(IO("Q")) D QUE I '$D(ZTQUEUED) K IOP G ASKDEV
 I $D(IO("Q")) D HOME^%ZIS
 Q
 ;
QUE ;
 N ADEJ
 S ZTRTN="ZTM^ADEPQA",ZTDESC="DENTAL QA REPORT"
 F ADEJ="ADESTP","ADEDATE","ADEAGE","ADEPROV","ADEHYG","ADELOC","ADEROPT","ADETFIL","ADETNAM","ADETDFN","ADEADA(","BY","FR","TO","FLDS","DIC","DHD","DIOBEG" S ZTSAVE(ADEJ)=""
 S ZTSAVE("IOP")=""
 D ^%ZTLOAD
 Q
