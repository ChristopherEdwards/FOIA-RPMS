PXRMV1IE ; SLC/PJH - Error handling routines. ;06/02/1999
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;======================================================================
ERR(ERROR) ;
 ;Send a MailMan message to the mail group defined by the site
 N IC,MGIEN,MGROUP,SUB,XMSUB,XMY,XMZ
 ;;
 S XMSUB="Error in Reminder Conversion"
 ;
 ;Get the message number
 F  D XMZ^XMA2 Q:XMZ>0
 ;
 ;Load the message
 S ^XMB(3.9,XMZ,2,1,0)="The time of the error was "_$$FMTE^XLFDT($$NOW^XLFDT,"5Y")
 ;
 S SUB=""
 F IC=3:1 S SUB=$O(ERROR(SUB)) Q:SUB=""  D
 .S ^XMB(3.9,XMZ,2,IC,0)=ERROR(SUB)
 ;
 S ^XMB(3.9,XMZ,2,0)="^3.92^"_+6_U_+6_U_DT
 ;
 ;Send the message to the site defined mailgroup.
 S MGIEN=$G(^PXRM(800,1,"MGFE"))
 ;If the mailgroup has not been defined send the message to the user.
 I MGIEN="" D
 . S MGROUP=DUZ
 . S ^XMB(3.9,XMZ,2,IC,0)=" "
 . S ^XMB(3.9,XMZ,2,IC+1,0)="You received this message because your IRM has not setup a mailgroup to receive"
 . S ^XMB(3.9,XMZ,2,IC+2,0)="Clinical Reminder errors, please notify them."
 E  S MGROUP="G."_$$GET1^DIQ(3.8,MGIEN,.01)
 ;
 S MGROUP=MGROUP_"@"_^XMB("NETNAME")
 S XMY(MGROUP)=""
 D ENT1^XMD
 Q
