XBMAIL ; IHS/ADC/GTH - MAIL MESSAGE TO SECURITY KEY HOLDERS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; This utility generates a mail message to everyone on the
 ; local machine that holds a security key according to the
 ; namespace, range, or single key provided in the parameter.
 ; The text of the mail messages must be provided by you, and
 ; passed to the utility as a line reference.  The utility
 ; uses the first line after the line reference as the mail
 ; message subject, and subsequent lines as the body of the
 ; message, until a null string is encountered.  This places
 ; an implicit limit on your mail messages to the maximum
 ; size of a routine.  Suggested text would be to inform the
 ; users that a patch has been installed, and describe any
 ; changes in displays or functionality, or problems
 ; addressed, and provide a contact number for questions,
 ; e.g:
 ; ------------------------------------------------------------------
 ; Please direct your questions or comments about RPMS software to:
 ;             OIRM / DSD (Division of Systems Development)
 ;             5300 Homestead Road NE
 ;             Albuquerque NM  87110
 ;             505-837-4189
 ; ------------------------------------------------------------------
 ; 
 ; Call examples are:
 ; 
 ; D MAIL^XBMAIL("ACHS*","MSG^ACHSP56")
 ; D MAIL^XBMAIL("AG*,XUMGR-XUPROGMODE,APCDZMENU","LABEL^AGP5")
 ; 
 ; The second example would deliver a mail message containing
 ; the text beginning at LABEL+2^AGP5, and continuing to the
 ; end of routine AGP5, to each local user that holds a
 ; security key in the AG namespace, in the range from XUMGR
 ; to XUPROGMODE (inclusive), and to holders of the APCDZMENU
 ; security key.
 ;
 ; If you are indicating a namespace, your namespace must end
 ; with a star ("*") character.
 ;
 ; If you are indicating a range of security keys, the
 ; beginning and ending keys must be separated with a dash
 ; ("-").  If the utility encounters a dash in a comma-piece
 ; of the first parameter, it will consider it to be
 ; range-indicated, and not part of the name of the key.
 ; Use caution not to begin or end with a key that has a dash
 ; in it's name.
 ;
 ; If a comma-piece does not contain a star or dash, a single
 ; key is assumed.
 ;
 ; The subject of the message is assumed to be the first line
 ; after LABEL^AGP5:
 ;               LABEL   ;EP - Mail msg text.
 ;                       ;;PATIENT REG, PATCH 5 CHANGES.
 ; 
 ; The utility will return Y=0 if successful, and Y=-1 if not
 ; successful.  The message "Message delivered." will be
 ; displayed if the routine is called interactively.
 ; 
 ;
 Q
 ;
MAIL(XBNS,XBREF) ;PEP - XBNS is namespace, XBREF is line reference.
 ;
 NEW XBLAB,XBRTN,XMSUB,XMDUZ,XMTEXT,XMY
 S XBLAB=$P(XBREF,U),XBRTN=$P(XBREF,U,2)
 I XBLAB=""!(XBRTN="") S Y=-1 Q  ; Invalid label reference.
 I '$L($T(@XBLAB+1^@XBRTN)) S Y=-1 Q  ; No text to send.
 S XMSUB=$P($T(@XBLAB+1^@XBRTN),";",3)
 KILL ^TMP("XBMAIL",$J)
 D WRITDESC,GETRECIP
 I '$D(XMY) S Y=-1 Q  ; No recipients.
 S XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""XBMAIL"",$J,"
 D ^XMD
 KILL ^TMP("XBMAIL",$J)
 I '$D(ZTQUEUED) W !!,"Message delivered.",!
 S Y=0
 Q
 ;
GETRECIP ;
 NEW X,XBCTR,Y
 F XBCTR=1:1 S %=$P(XBNS,",",XBCTR) Q:%=""  D
 . I %["*" D NS(%) Q
 . I %["-" D RANGE(%) Q
 . D SINGLE(%)
 .Q
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
RANGE(R) ; Get holders of a range of keys.
 S X=$P(R,"-",1),R=$P(R,"-",2)
 D SINGLE(X)
 F  S X=$O(^XUSEC(X)) Q:X=R!(X="")  S Y=0 F  S Y=$O(^XUSEC(X,Y)) Q:'Y  S XMY(Y)=""
 D SINGLE(R)
 Q
 ;
NS(N) ; Get holders of keys in namespace N.   
 S (X,N)=$P(N,"*",1),Y=0
 D SINGLE(X)
 F  S X=$O(^XUSEC(X)) Q:'($E(X,1,$L(N))=N)  S Y=0 F  S Y=$O(^XUSEC(X,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
 ;
WRITDESC ;
 F %=2:1 S X=$P($T(@XBLAB+%^@XBRTN),";",3) Q:X=""  S ^TMP("XBMAIL",$J,%)=X
 Q
 ;  
