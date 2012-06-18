ACDVSRV0 ;IHS/ADC/EDE/KML - UPLOAD EXTRACTION GLOBAL TO MAIL MESSAGE VIA ^XMD; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;***********************************************************
 ;This routine will move the CDMIS extraction global into
 ;a mail message. The mail message will be sent to a server
 ;at the area or headquarters.
 ;***********************************************************
EN ;EP ENTRY
 ;//^ACDVSAVE
 W !!,"Creating mail message now. Mail server."
 ;
 ;Ck for new data found...or not
 I '$D(^ACDVTMP) W !!,"No new data found." Q
 ;
 ;Set message count.
 ;Set global to $Q on.
 S ACDCNT=1,ACDGLO="^ACDVTMP"
 ;
 ;Set header record.
 ;Set encryption key
 S ^ACDVMESS(ACDCNT,0)=ACDFR_U_ACDTO_U_$P(^AUTTLOC($P(^AUTTSITE(1,0),U),0),U,2)_U_$P(^(0),U,10)_U_"$P($G(ACDZIP),U)"
 ;
 ;Load ^ACDVMESS in form: data node data node data node
 ;%RCR will move ^ACDVMESS into ^XMB (obsolete in K7)
 F  S ACDGLO=$Q(@ACDGLO) Q:ACDGLO=""  D
 .S ACDCNT=ACDCNT+1 S ^ACDVMESS(ACDCNT,0)=ACDGLO
 .S ACDCNT=ACDCNT+1 S ^ACDVMESS(ACDCNT,0)=@ACDGLO
 ;
SEND ;
 ;Send the new mail message just created to the remote server(s)
 ;Variable ACDOMAIN is a site parameter pre-set
 S XMTEXT="^ACDVMESS("
 S XMDUZ=.5
 S XMSUB="EXTRACTION GLOBAL"
 D ^XMD
K ;
 K ACDCNT,ACDGLO,XMTEXT,XMSUB,XMY
 K ^ACDVMESS ;       kill of scratch global  SAC EXEMPTION (2.3.2.3  killing of unsubscripted globals is prohibited)
 ;
 ;Future enhancement listed below:
 ;K7 will allow the developer to create a new message directly
 ;into ^XMB so cpu time of %RCR is avoided.
 ;
 ;D XMZ^XMA2        ;Get new message number in variable XMZ
 ;=>                ;S ^XMB(3.9,XMZ,2,0)="^3.92A^"_ACDCNT_"^"_ACDCNT
 ;D ENT1^XMD        ;Call here after loading ^XMB directly
 ;See page 54 of the 1992 Paragon Training Manual 'INSIDE KERNAL 7'
