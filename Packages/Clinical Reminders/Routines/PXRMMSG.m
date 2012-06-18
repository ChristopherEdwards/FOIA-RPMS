PXRMMSG ; SLC/PKR - Routine for sending MailMan messages. ;08/03/2001
 ;;1.5;CLINICAL REMINDERS;**2,7**;Jun 19, 2000
 ;
 ;======================================================================
SEND(XMSUB) ;Send a MailMan message to the mail group defined
 ;by the site and to the user. The text of the message is in
 ;^TMP("PXRMXMZ",$J,N,0), where the are N lines of text. The subject
 ;is the string XMSUB.
 N MGIEN,MGROUP,NL,REF,REMINDER,XMDUZ,XMY,XMZ
 ;
 ;If this is a test run write out the message.
 I $D(PXRMDEV) D
 . S REF="^TMP(""PXRMXMZ"",$J)"
 . D AWRITE^PXRMUTIL(REF)
 ;
 ;Make sure the subject does not exceed 64 characters.
 S XMUSB=$E(XMSUB,1,64)
 ;
 ;Make the sender the Postmaster.
 S XMDUZ=0.5
 ;
RETRY ;Get the message number.
 D XMZ^XMA2
 I XMZ<1 G RETRY
 ;
 ;Load the message
 M ^XMB(3.9,XMZ,2)=^TMP("PXRMXMZ",$J)
 K ^TMP("PXRMXMZ",$J)
 S NL=$O(^XMB(3.9,XMZ,2,""),-1)
 S ^XMB(3.9,XMZ,2,0)="^3.92^"_+NL_U_+NL_U_DT
 ;
 ;Send the message to the site defined mailgroup or the user if
 ;there is no mailgroup.
 S MGIEN=$G(^PXRM(800,1,"MGFE"))
 I MGIEN'="" D
 . S MGROUP="G."_$$GET1^DIQ(3.8,MGIEN,.01)
 . S XMY(MGROUP)=""
 E  S XMY(DUZ)=""
 D ENT1^XMD
 ;
 Q
 ;
