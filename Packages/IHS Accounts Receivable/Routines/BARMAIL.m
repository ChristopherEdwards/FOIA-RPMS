BARMAIL ; IHS/SD/LSL - PATCH ANNOUNCEMENT UTILITY ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ;;This patch announcement utility generates a mail message to everyone
 ;;on the local machine that holds a security key in the namespace
 ;;of the calling package.  The text of the mail messages must be
 ;;provided by you, and passed to the utility as a line reference.  The
 ;;utility uses the first line after the line reference as the mail
 ;;message subject, and subsequent lines as the body of the message,
 ;;until a null string is encountered.  This places an implicit limit
 ;;on your mail messages to the maximum size of a routine.  Suggested
 ;;text would be to inform the users that the patch has been installed,
 ;;and describe any changes in displays or functionality, and provide
 ;;a contact number for questions, e.g:
 ;;------------------------------------------------------------------
 ;;Please direct your questions or comments about RPMS software to:
 ;;            OIRM / DSD (Division of Systems Development)
 ;;            5300 Homestead Road NE
 ;;            Albuquerque NM  87110
 ;;            505-837-4189
 ;;------------------------------------------------------------------
 ;;
 ;;A call example is:   D MAIL^BARMAIL("AG","LABEL^AGP5")
 ;;This would deliver a mail message containing the text beginning at
 ;;LABEL+2^AGP5, and continuing to the end of routine AGP5, to each
 ;;local user that holds a security key in the AG namespace.
 ;;The subject of the message is assumed to be the first line after
 ;;LABEL^AGP5:
 ;;              LABEL   ;EP - Mail msg text.
 ;;                      ;;PATIENT REG, PATCH 5 CHANGES.
 ;;
 ;;The utility will return Y=0 if successful, and Y=-1 if not
 ;;successful.  The message "Message delivered." will be displayed
 ;;if the routine is called interactively.
 ;;
 ;
 Q
 ;
MAIL(BARNS,BARREF) ;PEP - BARNS is namespace, BARREF is line reference.
 ;
 NEW BARLAB,BARRTN,XMSUB,XMDUZ,XMTEXT,XMY
 S BARLAB=$P(BARREF,U),BARRTN=$P(BARREF,U,2)
 I BARLAB=""!(BARRTN="") S Y=-1 Q  ; Invalid label reference.
 I '$L($T(@BARLAB+1^@BARRTN)) S Y=-1 Q  ; No text to send.
 S XMSUB=$P($T(@BARLAB+1^@BARRTN),";",3)
 K ^TMP($J,"BARMAIL")
 D WRITDESC,GETRECIP
 I '$D(XMY) S Y=-1 Q  ; No recipients.
 S XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP($J,""BARMAIL"","
 D ^XMD
 K ^TMP($J,"BARMAIL")
 I '$D(ZTQUEUED) W !!,"Message delivered.",!
 S Y=0
 Q
 ;
GETRECIP ;
 NEW X,Y
 S X=BARNS
 F  S X=$O(^XUSEC(X)) Q:'($E(X,1,$L(BARNS))=BARNS)  S Y=0 F  S Y=$O(^XUSEC(X,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
WRITDESC ;
 F %=2:1 S X=$P($T(@BARLAB+%^@BARRTN),";",3) Q:X=""  S ^TMP($J,"BARMAIL",%)=X
 Q
 ;
