APSEWMSG ;IHS/DSD/LWJ - Patient Drug Education Database expiration message [ 11/13/2003  11:04 AM ]
 ;;6.1;IHS/PHARMACY MODIFICATIONS;**1,4**;04/17/01
 ;
 ; This program will be responsible for determining if a warning message
 ; needs to be issued to inform the pharmacist that the First 
 ; DataBank database has either, or is about to, expire.  This program
 ; can be called at the TEST subroutine to test the message, or at the
 ; main subroutine to process with the current date.
 ;
 Q
TEST ; this routine is used to test the messages
 N I
 N TEST
 S TEST=1
 F I=78:7:93 S COUNT=I D EP
 ;
 Q
 ;
EP ;EP -this subroutine will decipher if a warning message needs to be 
 ; sent and if one does need to be sent, which message should display.
 ;
 ;
 N APSEEDT,APSEWST,APSEWREC     ;expiration date, warning last sent
 N APSECDT,APSEWEX              ;current date (VA format), exit value
 N APSEDT15,APSEDT7,APSETDY     ;15 days back, 7 days back, today
 N X,APSEMTP                    ;date variable, message type indicator
 ;
 S APSEWEX=""
 S APSEWREC=$G(^APSAPPI("EXPWARN"))
 Q:APSEWREC=""                  ;quit if blank - package not installed
 S APSEEDT=$P(APSEWREC,"^")     ;expiration date of current data
 S APSEWST=$P(APSEWREC,"^",2)   ;warning message was last sent on
 ;
 D NOW^%DTC S APSETDY=X                       ;today's date in VA form
 ;
 I $G(TEST) S APSETDY=$$CONVDAT(APSETDY,COUNT) ;only if testing
 ;
 S APSEDT15=$$CONVDAT(APSEEDT,-15)          ;15 days from expiration
 S APSEDT7=$$CONVDAT(APSEEDT,-7)            ;7 days from expiration
 ;
 Q:APSETDY<APSEDT15            ;quit if we are more than 2 wks from exp
 ;
 I ((APSETDY>APSEDT15)&(APSETDY<APSEDT7)) D
 . I APSEWST="" S APSEMTP=2 D WARNMSG     ;two week expiration message
 ;
 I ((APSETDY'<APSEDT7)&(APSETDY<APSEEDT)) D
 . I APSEWST<APSEDT7 S APSEMTP=1 D WARNMSG ;one week expiration message
 ;
 ;IHS/DSD/lwj nxt line changed to chk APSEWST as well
 I (APSEEDT'>APSETDY)&(APSETDY'=APSEWST) S APSEMTP="D" D WARNMSG  ;daily  /IHS/DSD/lwj 5/11/01
 ;
 Q
 ;
WARNMSG ; This subroutine will generate the message that is sent 
 ; one and two weeks prior to the First DataBank Patient Education  
 ; Database expiring, and daily once the database has expired.
 ; APSEMTP will indicate which message type should be sent (two
 ; weeks prior, one week prior, or daily message).
 ;
 D MSGHED
 I APSEMTP=2 D MSGMID2          ;2 weeks prior to expire
 I APSEMTP=1 D MSGMID1          ;1 week prior to expire
 I APSEMTP="D" D MSGMIDD        ;expired - daily msg
 S APSEWEX=$$MSGEND(20,APSETDY)
 ;
 Q
 ;
MSGHED ; this is the header portion of all messages
 ;
 W !!
 W "*******************************************************************************",!
 W "*    WARNING   WARNING   ********  WARNING ********   WARNING   WARNING       *",!
 W "*                                                                             *",!
 ;
 Q
 ;
MSGMIDD ; this is the middle portion of the daily message
 ;
 W "* The First DataBank data used to print the Drug Medication Sheets has        *",!
 W "* expired.  This information is used in the following options found on the    *",!
 W "* main RX menu:                                                               *",!
 Q
 ;
MSGMID2 ; this is the middle portion of the message displayed 2 weeks out
 ;
 W "* The First DataBank data used to print the Drug Medication Sheets will       *",!
 W "* expire in two weeks.  This information is used in the following options     *",!
 W "* found on the main RX menu:                                                  *",!
 ;
 Q
 ;
MSGMID1 ; this is the middle portion of the message displayed 1 week out
 ;
 W "* The First DataBank data used to print the Drug Medication Sheets will       *",!
 W "* expire in one week.  This information is used in the following options     *",!
 W "* found on the main RX menu:                                                 *",!
 ;
 Q
 ;
MSGEND(APSETIM,APSEDATE) ; this is the final portion of the messages
 N DIR,DUOUT,APSEREC
 S DUOUT=0
 ;
 ;
 ;W "*                                                                             *",!
 W "*       DPMI   PRINT DRUG MEDICATION SHEETS                                   *",!
 W "*       PMI    PRINT PATIENT MEDICATION SHEETS                                *",!
 W "*       NERX   New Prescription Entry                                         *",!
 W "*               (Printing of the Med Sheet)                                   *",!
 W "*                                                                             *",!
 W "* Records indicate that your site is using this information to provide        *",!
 W "* patients with drug monographs.  It is extremely important that your system  *",!
 W "* be updated with the most current version of the First DataBank Patient Drug *",!
 W "* Education Database (PDED) as soon as possible.  Failure to update your      *",!
 W "* system could result in incorrect or out dated informaton being distributed. *",!
 W "* New versions of the First DataBank PDED are obtainable monthly and should   *",!
 W "* be loaded on your system as they are available.  Please contact your site   *",!
 W "* manager to schedule an update of the First DataBank PDED as soon as         *",!
 W "* possible.   (**** This message will display at frequent intervals until     *",!
 W "* a system update has been performed. ****)                                   *",!
 W "*******************************************************************************",!
 S DIR("T")=APSETIM,DIR(0)="E"           ;hold message for 20 seconds
 D ^DIR
 I '$D(DUOUT) S DUOUT=0
 ;
 ;
 S APSEREC=$G(^APSAPPI("EXPWARN"))
 S $P(APSEREC,"^",2)=APSEDATE          ;set the last sent date to today
 S ^APSAPPI("EXPWARN")=APSEREC
 ;
 Q DUOUT
 ;
CONVDAT(VADATE,NUMDAYS)      ;converts the expiration date to previous days
 ;  This is done to calculate the week range for the 2 week and 1 week
 ;  warning messages.
 ;
 N X,X1,X2
 S X1=VADATE,X2=NUMDAYS
 D C^%DTC
 ;
 Q X
