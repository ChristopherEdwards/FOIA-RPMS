PXRM ; SLC/PKR - Clinical Reminders entry points. ; 02/01/2001
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;=======================================================================
MAIN(DFN,PXRMITEM,PXRHM,NODISC) ;Main driver for clinical reminders.
 ;INPUT  DFN - Pointer to Patient File (#2)
 ;       PXRMITEM - The reminder to evaluate. This is the internal
 ;       entry number in file #811.9.
 ;       PXRHM - Flag to indicate level of information requested.
 ;         0 - Reminders DUE NOW only (CLINICAL REMINDERS DUE
 ;             HS component)
 ;         1 - All Reminders with Next and Last Information
 ;             (CLINICAL REMINDERS SUMMARY HS component)
 ;         5 - Health Maintenance (CLINICAL REMINDERS MAINTENANCE
 ;              HS component)
 ;        NODISC - (optional) if this is true then the disclaimer
 ;                 will not be loaded.
 ;
 ;OUTPUT  ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)=STATUS_U_DUE DATE_U_LAST DONE
 ;        where PXRMRNAM is the PRINT NAME or if it is undefined then
 ;        it is the NAME.
 ;        For the Clinical Maintenance component, PXRHM=5, there is 
 ;        subsequent output of the form
 ;        ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM,"TXT",N)=TEXT
 ;        where N is a number and TEXT is a text string.
 ;
 ;        If NODISC is false or not present then the disclaimer will
 ;        be loaded into ^TMP("PXRM",$J,"DISC",N).
 ;
 ;        The calling application can display the contents of these
 ;        two ^TMP arrays as it chooses. The caller should also make
 ;        sure the ^TMP globals are killed before it exits.
 ;
 ;These are the reminder evaluation "global" variables.
 N PXRMAGE,PXRMDOB,PXRMDFN,PXRMDOD,PXRMPID,PXRMRNAM,PXRMRACE,PXRMSEX
 N PXRMSSN,PXRMXTLK,PXRMTXEV
 S PXRMPID="PXRM"_PXRMITEM_$$NOW^XLFDT
 ;
 ;Set the error handler to the PXRMERRH routine. Use the new style of
 ;error trapping.
 N $ES,$ET
 S $ET="D ERRHDLR^PXRMERRH"
 ;
 ;Initialize the working array.
 K ^TMP(PXRMPID,$J)
 ;
 ;Establish the main findings evaluation variables.
 N DUE,DUEDATE,FIEVAL,FREQ,PCLOGIC,RESDATE,RESLOGIC
 S (DUE,DUEDATE,FREQ,RESDATE)=0
 S (PCLOGIC,RESLOGIC)=""
 ;
 ;Make sure the reminder exists.
 I '$D(^PXD(811.9,PXRMITEM)) D  G EXIT
 . S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","NO REMINDER")="ITEM "_$G(PXRMITEM)_" IS NOT A VALID REMINDER ITEM"
 ;
 N D00
 S D00=^PXD(811.9,PXRMITEM,0)
 S PXRMRNAM=$P(D00,U,3)
 ;If the print name is null use the .01.
 I PXRMRNAM="" S PXRMRNAM=$P(D00,U,1)
 ;
 ;Make sure the reminder is active.
 I $P(D00,U,6) D  G OUTPUT
 . S ^TMP(PXRMPID,$J,PXRMITEM,"N/A","INACTIVE")="The reminder "_PXRMRNAM_" was inactivated "_$$FMTE^XLFDT($P(D00,U,7),"5Z")
 I $L(PXRMRNAM)=0 S PXRMRNAM=$P($G(^PXD(811.9,PXRMITEM,0)),U,1)
 ;
 ;Establish the patient demographic information. This call defines
 ;PXRMDFN and locks the patient cache.
 N TEMP
 S TEMP=$$DEM^PXRMPINF(DFN)
 I TEMP="NO PATIENT" D  G EXIT
 . S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","PATIENT","NO PAT")="DFN "_DFN_" IS NOT A VALID PATIENT"
 . S PCLOGIC=0
 I TEMP="NO LOCK" D  G OUTPUT
 . S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","PATIENT","NO LOCK")="NO LOCK"
 . S PCLOGIC=0
 ;
 ;Check for a date of death.
 I $L(PXRMDOD)>0 D
 . S ^TMP(PXRMPID,$J,PXRMITEM,"N/A","DEAD")=""
 . S ^TMP(PXRMPID,$J,PXRMITEM,"DEAD")="Patient is deceased."
 ;
 ;If the component is CR and the patient is deceased we are done.
 I PXRHM=0,$L(PXRMDOD)>0 G OUTPUT
 ;
 ;Check for a sex specific reminder.
 N SEXOK
 S SEXOK=$$SEX^PXRMLOG
 ;If the patient is the wrong sex then don't do anything else.
 I 'SEXOK D  G OUTPUT
 . S PCLOGIC=0
 . S ^TMP(PXRMPID,$J,PXRMITEM,"N/A","SEX")=""
 . S ^TMP(PXRMPID,$J,PXRMITEM,"INFO","SEX")="Patient is the wrong sex!"
 ;
 ;Evaluate the findings.
 S PXRMXTLK=""
 D EVAL^PXRMEVFI(DFN,.FIEVAL)
 I +PXRMXTLK>0 D  G OUTPUT
 . S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","EXPANDED TAXONOMY","NO LOCK")="NO LOCK for ien "_+PXRMXTLK
 . S PCLOGIC=0
 ;
 ;Evaluate the Patient Cohort Logic.
 D EVALPCL^PXRMLOG(.FREQ,.PCLOGIC,.FIEVAL)
 ;
 ;Evaluate the resolution logic and get the last resolution date.
 D EVALRESL^PXRMLOG(.RESDATE,.RESLOGIC,.FIEVAL)
 ;
 ;If the reminder is applicable calculate the due date.
 I PCLOGIC D DUE^PXRMDATE(RESDATE,FREQ,.DUE,.DUEDATE)
 ;
OUTPUT ;Prepare the final output.
 D FINAL^PXRMFOUT(PCLOGIC,RESLOGIC,DUE,DUEDATE,RESDATE,FREQ,.FIEVAL)
 ;
 ;Unlock the patient cache
EXIT I $D(PXRMDFN) D UNLOCKPC^PXRMPINF(PXRMDFN)
 ;
 ;Kill the working arrays unless this was a development run.
 I $D(PXRMDEV) D
 . S PXRMID=PXRMPID
 . S FIEVAL("PATIENT AGE")=$G(PXRMAGE)
 . M FIEV=FIEVAL
 . S FIEV("DFN")=DFN
 . S ^TMP(PXRMPID,$J,PXRMITEM,"REMINDER NAME")=$G(PXRMRNAM)
 E  K ^TMP(PXRMPID,$J)
 ;
 ;If this was called from the FIDATA entry point then load FIEVAL
 ;into the FINDINGS array.
 I $G(PXRMFDAT) D
 . M FINDINGS=FIEVAL
 ;
 ;I NODISC is true then don't load the disclaimer.
 I $G(NODISC) Q
 ;If there is any data in ^TMP("PXRHM",$J) then set up the disclaimer.
 I $D(^TMP("PXRHM",$J)) D LOAD^PXRMDISC
 ;
 Q
 ;
 ;=======================================================================
DATE(DFN,PXRMITEM,PXRHM,NODISC,FUTDATE) ;Evaluate reminder PXRMITEM on a date
 ;in the future.
 N PXRMDATE
 S PXRMDATE=FUTDATE
 D MAIN(DFN,PXRMITEM,PXRHM,NODISC)
 Q
 ;
 ;=======================================================================
FIDATA(DFN,PXRMITEM,FINDINGS) ;Return the finding evaluation array to the
 ;caller in the array FINDINGS. The caller should use the form
 ;D FIDATA^PXRM(DFN,PXRMITEM,.FINDINGS)
 ;The elements of the FINDINGS array will correspond to the
 ;findings in the reminder definition. For finding N FINDINGS(N)
 ;will be 0 if the finding is false and 1 if it is true. For
 ;true findings there will be additional elements. The exact set
 ;of additional elements will depend of the type of finding.
 ;Some typical examples are:
 ;FINDINGS(N)=1
 ;FINDINGS(N,"DATE")=FileMan date
 ;FINDINGS(N,"FINDING")=variable pointer to the finding
 ;FINDINGS(N,"SOURCE")=variable pointer to the data source
 ;FINDINGS(N,"VALUE")=value of the finding, for example the
 ;                    value of a lab test
 ;
 N PXRMFDAT
 S PXRMFDAT=1
 D MAIN(DFN,PXRMITEM,0,1)
 K ^TMP("PXRM",$J),^TMP("PXRHM",$J)
 Q
 ;
 ;=======================================================================
INACTIVE(PXRMITEM) ;Return the INACTIVE FLAG, which has a value of 1
 ;if the reminder is inactive.
 I '$D(^PXD(811.9,PXRMITEM)) Q 1
 Q $P(^PXD(811.9,PXRMITEM,0),U,6)
 ;
