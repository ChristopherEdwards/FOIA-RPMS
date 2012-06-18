PXRMXSE ; SLC/PJH - Build Patient lists for Reminder Due report;03-Nov-2005 13:32;MGH
 ;;1.5;CLINICAL REMINDERS;**6,1004**;Jun 19, 2000
 ;IHS/CIA/MGH Modified for reminder reports from IHS primary care providers
 ;
 ; Called/jobbed from PXRMXD
 ;
 ; Input - PXRMSEL,PXRMXTMP
 ;         PXRM*
 ; Output- ^XTMP(PXRMXTMP
 ;
 ;
START N ITEM,LIT,TOTAL,TODAY,ZTSTOP,BUSY
 S TOTAL=0,ZTSTOP="",TODAY=$$DT^XLFDT-.0001
 ;
 ; For the detail report there is only one reminder
 I PXRMREP="D" D
 .S ITEM=$P(REMINDER(1),U,1),LIT=$P(REMINDER(1),U,4)
 .I LIT="" S LIT=$P(REMINDER(1),U,2)
 ;
 K ^TMP($J),^TMP(PXRMRT,$J),^TMP("PXRMDUP",$J)
 K ^TMP("PXRMCMB",$J),^TMP("PXRMCMB1",$J),^TMP("PXRMCMB2",$J)
 ;
 I '(PXRMQUE!$D(IO("S"))) D INIT^PXRMXBSY(.BUSY)
 ;
 ;OE/RR team selected (PXRMOTM)
 I PXRMSEL="O" D OERR^PXRMXSEO
 ;
 ;PCMM team selected (PXRMPCM)
 I PXRMSEL="T" D PCMMT^PXRMXSEO
 ;
 ;Location selected (PXRMLCHL,PXRMCGRP)
 I PXRMSEL="L" D  G:ZTSTOP=1 EXIT
 .;Prior Visits - build patient list in ^TMP
 .I PXRMFD="P" D VISITS^PXRMXSEL
 .;Current Inpatients
 .I PXRMFD="C" D INP^PXRMXSEL
 .;Inpatient Admissions
 .I PXRMFD="A" D ADM^PXRMXSEL
 .;Future Appointments - build patient list in ^TMP
 .I PXRMFD="F" D APPTS^PXRMXSEL
 .;End task requested
 .Q:ZTSTOP=1
 .;Update ^XTMP from ^TMP
 .I '(PXRMQUE!$D(IO("S"))) D INIT^PXRMXBSY(.BUSY)
 .D XTMP^PXRMXSEO
 ;
 ;PCMM provider selected (PXRMPRV)
 I PXRMSEL="P" D PCMMP^PXRMXSEO
 ;
 ;IHS/CIA/MGH  designated provider selected
 I PXRMSEL="D" D IHS^BPXRMSEO
 ;
 ;Individual Patients selected (PXRMPAT)
 I PXRMSEL="I" D IND^PXRMXSEO
 ;
 K ^TMP($J),^TMP(PXRMRT,$J),^TMP("PXRMDUP",$J)
 K ^TMP("PXRMCMB",$J),^TMP("PXRMCMB1",$J),^TMP("PXRMCMB2",$J)
 ;
DONE ;
 ;Sorting is done.
 I '(PXRMQUE!$D(IO("S"))!(PXRMTABS="Y")) D DONE^PXRMXBSY("done")
 ;
 ;
 ;Print the report information.
 I PXRMQUE D  Q
 .;Start the printing that was queued but not scheduled.
 .N DESC,ROUTINE,TASK,ZTDTH
 .S ROUTINE="^PXRMXPR"
 .S DESC="Reminder Due Report - print"
 .S ZTDTH=$$NOW^XLFDT
 .S TASK=$G(^XTMP(PXRMXTMP,"PRZTSK"))
 .I TASK D REQUE^PXRMXQUE(DESC,ROUTINE,TASK)
 I 'PXRMQUE D ^PXRMXPR
 Q
 ;
 ;End Task requested
EXIT D EXIT^PXRMXGUT
 Q
