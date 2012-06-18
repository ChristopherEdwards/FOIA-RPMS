BARMEISS ; IHS/SD/LSL - Manually resend EISS files ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 05/03/04 - V1.8
 ;     Routine created to manually resend EISS files left in the
 ;     directory.
 ;
 Q
 ; ********************************************************************
EP ;EP
 D FINDFILE                       ; Find files in directory
 Q:'$D(BARFILES)                  ; No files in directory
 D DISPFILE                       ; Display files for choosing
 I BARANS<1 D  Q                  ; No file selected
 . D PAZ^BARRUTL
 D RUSURE                         ; Resend message.
 I BARANS<1 D  Q                  ; Don't resend
 . D PAZ^BARRUTL
 D RESEND                         ; Resend selected file
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
FINDFILE ;
 ; Find files in EISS directory.  List returned in BARFILES array
 ; BARFILES(#)=filename
 S BARDIR=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),2)),U,4)
 Q:BARDIR=""                      ; No EISS local directory.
 S BARLIST=$$LIST^%ZISH(BARDIR,"*",.BARFILES)
 I '$D(BARFILES) D  Q
 . W !!,"No files in ",BARDIR," directory"
 . D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
DISPFILE ;
 W !!
 S (BARA,BARCNT)=0
 F  S BARA=$O(BARFILES(BARA)) Q:'+BARA  D
 . S BARCNT=BARCNT+1
 . W !,$J(BARCNT,2),?5,BARFILES(BARA)
 . S BARTMP(BARCNT)=BARA
 S BARANS=0
 W !
 K DIR
 S DIR(0)="NAO^1:"_BARCNT
 S DIR("A")="Please enter the LINE # of the EISS file to be resent: "
 S DIR("?")="Enter a number between 1 and "_BARCNT
 D ^DIR
 S BARANS=Y
 Q:BARANS<1
 S BARFN=BARFILES(BARTMP(BARANS))
 Q
 ; ***********************************************************************
 ;
RUSURE ;
 W !
 S BARANS=0
 K DIR
 S DIR(0)="Y^A"
 S DIR("A")="Would you like to resend "_BARFN_" now"
 S DIR("B")="Y"
 D ^DIR
 S:Y BARANS=1
 K DIR
 Q
 ; ********************************************************************
 ;
RESEND ;
 ; Resend selected file
 S BAREISS=$G(^BAR(90052.06,DUZ(2),DUZ(2),2))
 S XBFN=BARFN
 S XBUF=BARDIR
 S BARUNAM=$P(BAREISS,U,2)      ; Username of system receiving file
 S BARUPASS=$P(BAREISS,U,3)     ; Password of system receiving file
 S XBQTO=$P(BAREISS,U)          ; System id to receive file
 ; Include username and password in system id
 ; Add i to XBQTO to send immediately rather than queue.  Needed so can
 ; delete sent files. (A/R 1.8)
 S XBQTO="-il """_BARUNAM_":"_BARUPASS_""" "_XBQTO
 I XBUF=""!(BARUNAM="")!(BARUPASS="")!(XBQTO="") Q
 I IO=IO(0) W !!
 I $$VERSION^%ZOSV(1)["Windows" D UUCPQ^ZIBGSVEP
 E  D UUCPQ^ZIBGSVEM
 D ^%ZISC,HOME^%ZIS
 S:'$D(XBFLG) XBFLG=0
 Q:+XBFLG                         ; Send not successful
 ; delete file from local, send successful
 S BARDEL=$$DEL^%ZISH(BARDIR,BARFN)
 Q
