BLR6249P ; IHS/OIT/MKK - CHANGE LA7 MESSAGE QUEUE ERROR MESSAGES TO PURGEABLE MESSAGES ; [ 03/24/2006 08:00 AM ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;; Routine to change the status of entries in the LA7 MESSAGE QUEUE
 ;; file (62.49) from "ERROR" to "PURGEABLE".  This will prevent the
 ;; queue from growing forever.  This will only be done on errors
 ;; that are greater than 30 days old.
 ;;
EP ; 
 W $C(7),$C(7),$C(7),!
 W !,"Run at Label",!
 Q
 ;
PEP ; EP
 NEW CNT,CURDATE,MSG,MSGDATE,FDA,STATUS,ERRS
 NEW DTBEG,DTEND,HEADER
 ;
 D ^XBCLS
 S HEADER(1)="LA7 MESSAGE QUEUE (#62.49)"
 S HEADER(2)="MODIFY ERROR MESSAGES 30 Days or Older to PURGEABLE MESSAGE"
 D BLRGSHSH^BLRGMENU
 ;
 S (CNT,MSG)=0
 W !,?5,"Making LA7 MESSAGE QUEUE ERROR MESSAGES Purgeable",!
 F  S MSG=$O(^LAHM(62.49,MSG))  Q:MSG=""!(MSG'?.N)  D
 . D ^XBFMK                   ; Clear FileMan variables
 . K ERRS,FDA
 . S STATUS=$$GET1^DIQ(62.49,MSG_",","STATUS","I",,"ERRS")
 . ;
 . ; If FileMan ERROR, output error message and get next message
 . I $D(ERRS("DIERR"))>0 D ERRORMSG("GET1^DIQ")  Q
 . ;
 . I STATUS'["E" Q            ; If Status not Error, skip
 . ;
 . ; Get the message date
 . K ERRS,FDA
 . S MSGDATE=$$GET1^DIQ(62.49,MSG_",","DATE/TIME ENTERED","I",,"ERRS")
 . I $D(ERRS("DIERR"))>0 D ERRORMSG("GET1^DIQ")  Q
 . ;
 . S MSGDATE=+$P(MSGDATE,".",1)
 . S CURDATE=$P($$HTFM^XLFDT($H),".",1)
 . ;
 . ; Only change those Messages that are older than 30 days.
 . I +$$FMDIFF^XLFDT(CURDATE,MSGDATE,"1")<30 Q
 . ;
 . D ^XBFMK
 . K ERRS,FDA
 . ; NOTE: Even though STATUS is piece 3, the field number is 2
 . S FDA(62.49,MSG_",",2)="X"
 . ;
 . D FILE^DIE("K","FDA","ERRS")
 . I $D(ERRS("DIERR"))>0 D ERRORMSG("FILE^DIE")  Q
 . ;
 . S CNT=CNT+1
 . I CNT=1 W ?7,""
 . W "."
 . I $X>69 W !,?7,""
 . ;
 ;
 I CNT>0 W !,!,?10,"Number of ""Errors"" in 62.49 Changed to Purgeable:",CNT,!,!
 I CNT<1 W !,!,?10,"No ""Errors"" found in 62.49",!,!
 ;
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Enter RETURN to Continue"
 D ^DIR
 ; It's irrelevant what the answer is
 Q
 ;
 ; Display Error Message -- it's known to be a FileMan error
ERRORMSG(WOT) ;
 W !!,$TR($RE($J($RE("FILEMAN_ERROR_"),IOM))," _","* "),!   ; Trick
 W ?10,"ERROR Occurred during ",$G(WOT),!
 I $D(FDA)>0 D ARRYDUMP("FDA")
 I $D(ERRS)>0 D ARRYDUMP("ERRS")
 W $TR($J("_FILEMAN_ERROR",IOM)," _","* "),!!
 Q
 ;
 ; Because the use of Z functions are not allowed, 
 ; I've written my own version of ZW.
ARRYDUMP(ARRY) ;
 NEW STR1
 ;
 S STR1=$Q(@ARRY@(""))
 W !,?5,ARRY,!
 W ?10,STR1,"=",@STR1,!
 F  S STR1=$Q(@STR1)  Q:STR1=""  D
 . W ?10,STR1,"=",@STR1,!
 Q
 ;
 ; Temp code to reset STATUS back to ERROR -- this is supposed to be
 ; removed BEFORE the national release of IHS LAB PATCH 1022.
MAKERRS ; EP
 NEW HEADER
 S HEADER(1)="LA7 MESSAGE QUEUE (#62.49)"
 S HEADER(2)="MODIFY PURGEABLE MESSAGE to ERROR MESSAGE"
 D BLRGSHSH^BLRGMENU
 ;
 S (CNT,MSG)=0
 W !,?5,"Making LA7 MESSAGE QUEUE PURGEABLE MESSAGES into ERROR MESSAGES again",!
 F  S MSG=$O(^LAHM(62.49,MSG))  Q:MSG=""!(MSG'?.N)  D
 . D ^XBFMK                   ; Clear FileMan variables
 . K ERRS,FDA
 . S STATUS=$$GET1^DIQ(62.49,MSG_",","STATUS","I",,"ERRS")
 . ;
 . ; If FileMan ERROR, output error message and continue
 . I $D(ERRS("DIERR"))>0 D ERRORMSG("GET1^DIQ")  Q
 . ;
 . I STATUS'["X" Q            ; If not purgeable, skip
 . ;
 . D ^XBFMK
 . K ERRS,FDA
 . ; NOTE: Even though STATUS is piece 3, the field number is 2
 . S FDA(62.49,MSG_",",2)="E"
 . ;
 . D FILE^DIE("K","FDA","ERRS")
 . I $D(ERRS("DIERR"))>0 D ERRORMSG("FILE^DIE")  Q
 . I $D(ERRS("DIERR"))<1 D  Q
 .. S CNT=CNT+1
 .. I CNT=1 W ?7,""
 .. W "."
 .. I $X>69 W !,?7,""
 . ;
 ;
 I CNT>0 W !,!,?10,"Number of ""Purgeable"" Messages in 62.49 Changed to ""Errors"":",CNT,!,!
 I CNT<1 W !,!,?10,"No ""Purgeable"" Messages found in 62.49",!,!
 ;
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Enter RETURN to Continue"
 D ^DIR
 ; Don't care what the answer is
 Q
