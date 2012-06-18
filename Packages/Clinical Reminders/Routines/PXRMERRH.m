PXRMERRH ; SLC/PKR - Error handling routines. ;06/07/2001
 ;;1.5;CLINICAL REMINDERS;**2,5**;Jun 19, 2000
 ;
 ;======================================================================
ERRHDLR ;PXRM error handler. Send a MailMan message to the mail group defined
 ;by the site and put the error in the error trap.
 N ERROR,MGIEN,MGROUP,NL,REMINDER,XMDUZ,XMSUB,XMY,XMZ
 ;
 ;Save the error then put it in the error trap, this saves the correct
 ;last global reference.
 S ERROR=$$EC^%ZOSV
 D ^%ZTER
 ;
 ;If this is a test run write out the error.
 I $D(PXRMDEV) W !,ERROR
 ;
 ;Make the sender the Postmaster.
 S XMDUZ=0.5
 S XMSUB="ERROR EVALUATING CLINICAL REMINDER"
 ;
RETRY ;Get the message number.
 D XMZ^XMA2
 I XMZ<1 G RETRY
 ;
 ;Load the message
 S ^XMB(3.9,XMZ,2,1,0)="The following error occurred:"
 S ^XMB(3.9,XMZ,2,2,0)=ERROR
 I +$G(PXRMITEM)>0 S REMINDER=$P(^PXD(811.9,PXRMITEM,0),U,1)
 E  D
 . S PXRMITEM=999999
 . S REMINDER="?"
 S ^XMB(3.9,XMZ,2,3,0)="While evaluating reminder "_REMINDER
 S ^XMB(3.9,XMZ,2,4,0)="For patient DFN="_DFN
 S ^XMB(3.9,XMZ,2,5,0)="The time of the error was "_$$FMTE^XLFDT($$NOW^XLFDT,"5Z")
 S ^XMB(3.9,XMZ,2,6,0)="See the error trap for complete details."
 S NL=6
 ;Look for specific error text to append to the message.
 I $D(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","ERROR TRAP")) D
 . N ESOURCE,IND
 . S ESOURCE=""
 . F  S ESOURCE=$O(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","ERROR TRAP",ESOURCE)) Q:ESOURCE=""  D
 .. S IND=0
 .. F  S IND=$O(^TMP(PXRMPID,$J,PXRMITEM,"FERROR","ERROR TRAP",ESOURCE,IND)) Q:IND=""  D
 ... S NL=NL+1
 ... S ^XMB(3.9,XMZ,2,NL,0)=^TMP(PXRMPID,$J,PXRMITEM,"FERROR","ERROR TRAP",ESOURCE,IND)
 ;
 ;Send the message to the site defined mailgroup.
 S MGIEN=$G(^PXRM(800,1,"MGFE"))
 ;If the mailgroup has not been defined send the message to the user.
 I MGIEN="" D
 . S MGROUP=DUZ
 . S NL=NL+1,^XMB(3.9,XMZ,2,NL,0)=" "
 . S NL=NL+1,^XMB(3.9,XMZ,2,NL,0)="You received this message because your IRM has not set up a mailgroup"
 . S NL=NL+1,^XMB(3.9,XMZ,2,NL,0)="to receive Clinical Reminder errors; please notify them."
 . S ^XMB(3.9,XMZ,2,0)="^3.92^"_+NL_U_+NL_U_DT
 E  S MGROUP="G."_$$GET1^DIQ(3.8,MGIEN,.01)
 ;
 S XMY(MGROUP)=""
 D ENT1^XMD
 ;
 ;Mark that an error occured.
 I PXRMITEM=999999 Q
 S ^TMP(PXRMPID,$J,PXRMITEM,"FERROR","ERROR TRAP")=""
 N PCLOGIC,DUE,DUEDATE,RESDATE,FREQ,FIEVAL
 S (PCLOGIC,DUE,DUEDATE,RESDATE,FREQ)=""
 D FINAL^PXRMFOUT(PCLOGIC,DUE,DUEDATE,RESDATE,FREQ,.FIEVAL)
 ;
 ;Set the first line of ^TMP("PXRHM") to ERROR.
 S ^TMP("PXRHM",$J,PXRMITEM,PXRMRNAM)="ERROR"
 ;
 ;Make sure patient cache is unlocked.
 D UNLOCKPC^PXRMPINF(PXRMDFN)
 ;
 ;Clean up globals.
 K ^TMP("PXRM",$J)
 K ^TMP("PXRHM",$J)
 K ^TMP(PXRMPID,$J)
 ;
 ;Unwind the stack.
 D UNWIND^%ZTER
 Q
 ;
