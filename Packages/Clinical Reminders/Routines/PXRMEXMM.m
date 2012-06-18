PXRMEXMM ; SLC/PKR - Routines to select and deal with MailMan messages. ;06/15/2001
 ;;1.5;CLINICAL REMINDERS;**5**;Jun 19, 2000
 ;======================================================================
CMM(SUCCESS,LIST) ;Create a MailMan message containing the repository
 ;entries in LIST.
 ;Get a new MailMan message number.
 N IC,IND,LC,LIEN,RIEN,TEMP,TLC,XMSUB
 S XMSUB="Clinical Reminder Exchange File Entries"
 S TEMP=$$GETSUB
 I TEMP["^" Q
 S XMSUB="CREX: "_TEMP
 S TEMP=$$SUBCHK^XMGAPI0(XMSUB,0)
 I $P(TEMP,U,1)'="" S XMSUB=$E(XMSUB,1,65)
RETRY ;
 D XMZ^XMA2
 I XMZ<1 G RETRY
 S SUCCESS("XMZ")=XMZ
 S SUCCESS("SUB")=XMSUB
 ;
 S (IC,TLC)=0
 S LIEN=""
 F  S LIEN=$O(LIST(LIEN)) Q:+LIEN=0  D
 . S RIEN=$$RIEN^PXRMEXU1(LIEN)
 . S LC=$O(^PXD(811.8,RIEN,100,""),-1)
 . S TLC=TLC+LC
 . F IND=1:1:LC D
 .. S IC=IC+1
 .. S ^XMB(3.9,XMZ,2,IC,0)=^PXD(811.8,RIEN,100,IND,0)
 S ^XMB(3.9,XMZ,2,0)="^3.92^"_TLC_"^"_TLC_"^"_DT
 ;
 ;Make the message information only.
 S $P(^XMB(3.9,XMZ,0),U,12)="Y"
 ;
 ;Get a list of who to send it to and send it.
 D ENT2^XMD
 Q
 ;
 ;======================================================================
FLUSH(XMZ) ;Read to the end of the message so the pointer is reset.
 N LINE
 F  S LINE=$$READ^XMGAPI1 Q:+$G(XMER)=-1
 Q
 ;
 ;======================================================================
GETMESSN() ;Get the message number.
 N DIC,TEMP,WBN,X,Y
 K DIRUT,DTOUT,DUOUT
 ;
 S DIC("A")="Select a MailMan message: "
 S DIC=3.9
 S DIC(0)="EQV"
 S X="CREX: "
 ;Look in every mailbox except WASTE.
 S WBN=$$BSKT^XMAD2("WASTE",DUZ)
 S DIC("S")="I $D(^XMB(3.7,""M"",+Y,DUZ))&'$D(^XMB(3.7,""M"",+Y,DUZ,WBN))"
 S DIC("W")="N SAVEY S SAVEY=+Y N Y S TEMP=$$NET^XMRENT(+SAVEY) W !,""         "",$P(TEMP,U,3),"" "",$P(TEMP,U,1),!"
 W !
 D ^DIC K DIC
 I X=(U_U) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q ""
 Q $P(Y,U,1)
 ;
 ;======================================================================
GETSUB() ;Prompt the user for a subject.
 N DIR,X,Y
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="FAU"_U_"1:59"
 S DIR("A")="Enter a subject: "
 D ^DIR K DIR
 Q Y
 ;
 ;======================================================================
LMM(SUCCESS,XMZ) ;Load repository entries from a MailMan message.
 N CSUM,DATE,FDA,FDAIEN,IND,LINE,MSG,NENTRY,NLINES,RETMP
 N RNAME,SOURCE,SSOURCE,TEMP,US,VRSN,XMVAR
 ;Get the message information
 S TEMP=$$HDR^XMGAPI2(XMZ,.XMVAR,0)
 I TEMP'=0 D  Q
 . W !,"This MailMan message has a corrupted header."
 . S SUCCESS=0
 . H 2
 .;Read all the way to the end of this entry to reset the line pointer.
 . D FLUSH(XMZ)
 ;Load the message
 W !,"Loading MailMan message number ",XMZ
 K ^TMP("PXRMEXLMM",$J)
 S RETMP="^TMP(""PXRMEXLMM"",$J)"
 S (NENTRY,NLINES,SSOURCE)=0
 F  S LINE=$$READ^XMGAPI1 Q:+$G(XMER)=-1  D
 . S NLINES=NLINES+1
 . S ^TMP("PXRMEXLMM",$J,NLINES,0)=LINE
 . I LINE["<PACKAGE_VERSION>" S VRSN=$$GETTAGV^PXRMEXU3(LINE,"<PACKAGE_VERSION>")
 . I LINE="<SOURCE>" S SSOURCE=1
 . I SSOURCE D
 .. I LINE["<NAME>" S RNAME=$$GETTAGV^PXRMEXU3(LINE,"<NAME>")
 .. I LINE["<USER>" S USER=$$GETTAGV^PXRMEXU3(LINE,"<USER>")
 .. I LINE["<SITE>" S SITE=$$GETTAGV^PXRMEXU3(LINE,"<SITE>")
 .. I LINE["<DATE_PACKED>" S DATEP=$$GETTAGV^PXRMEXU3(LINE,"<DATE_PACKED>")
 . I LINE="</SOURCE>" D
 .. S SSOURCE=0
 .. S SOURCE=USER_" at "_SITE
 .;See if the entry is loaded into the temporary storage.
 . I LINE="</REMINDER_EXCHANGE_FILE_ENTRY>" D
 .. S NLINES=0
 .. S NENTRY=NENTRY+1
 ..;Make sure it has the correct format.
 .. I (^TMP("PXRMEXLMM",$J,1,0)'["xml")!(^TMP("PXRMEXLMM",$J,2,0)'="<REMINDER_EXCHANGE_FILE_ENTRY>") D  Q
 ... W !,"There is a problem reading this MailMan message, try it again."
 ... W !,"If it fails twice it is not in the proper reminder exchange format."
 ... S SUCCESS=0
 ... H 2
 ...;Read all the way to the end of this entry to reset the line pointer.
 ... D FLUSH(XMZ)
 ... S XMER=-1
 ..;Make sure this entry does not already exist.
 .. I $$REXISTS^PXRMEXIU(RNAME,DATEP) D
 ... W !,RNAME," with a date packed of ",DATEP
 ... W !,"is already in the Exchange File."
 ... S SUCCESS(NENTRY)=0
 ... H 2
 .. E  D
 ... K FDA,IENROOT
 ... S FDA(811.8,"+1,",.01)=RNAME
 ... S FDA(811.8,"+1,",.02)=SOURCE
 ... S FDA(811.8,"+1,",.03)=DATEP
 ... D UPDATE^PXRMEXPU(.US,.FDA,.IENROOT)
 ... S SUCCESS(NENTRY)=US
 ...;Create the description and save the data.
 ... N DESCT,KEYWORDT
 ... D DESC^PXRMEXU3(RETMP,.DESCT)
 ... D KEYWORD^PXRMEXU3(RETMP,.KEYWORDT)
 ... D DESC^PXRMEXU1(IENROOT(1),RNAME,SOURCE,DATEP,"DESCT","KEYWORDT")
 ... M ^PXD(811.8,IENROOT(1),100)=^TMP("PXRMEXLMM",$J)
 .. K ^TMP("PXRMEXLMM",$J)
 ;Check the success of the entry installs.
 S SUCCESS=1
 S IND=""
 F  S IND=$O(SUCCESS(IND)) Q:+IND=0  D
 . I 'SUCCESS(IND) S SUCCESS=0 Q
 ;Read all the way to the end of the message.
 D FLUSH(XMZ)
 Q
 ;
