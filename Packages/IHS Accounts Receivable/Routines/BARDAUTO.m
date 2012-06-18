BARDAUTO ; IHS/SD/LSL - A/R Debt Collection Process ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/08/2004 - V1.8
 ;      Routine created.  Moved (modified) from BBMDC1
 ;      Called by taskable menu option BAR DEBT COLLECTION AUTO
 ;
 ; ********************************************************************
 ;
 Q
 ;
EP ; EP
 ; Loop parent facilities and see if they are set up.
 S BARHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BAR(90052.06,DUZ(2))) Q:'+DUZ(2)  D PARENT
 S DUZ(2)=BARHOLD
 Q
 ; ********************************************************************
 ;
PARENT ;
 Q:'$D(^BAR(90052.06,DUZ(2),DUZ(2),0))
 Q:'+$P($G(^BAR(90052.06,DUZ(2),DUZ(2),11)),U,7)    ; not set up auto
 D VARS^BARDMAN                   ; Get site parameter values
 S BARQUIT=$$CHECK()              ; Check parameters
 I +BARQUIT D CLEAN Q
 K BARQUIT
 D DATE                           ; Determine start and end dates
 I '+BARSTART D CLEAN Q           ; Date range not entered
 S BARAMT=BARMAMT                 ; Minimum bill amount
 D PROCESS                        ; Find bills and build temp global
 I $D(BARQUIT) D CLEAN Q
 D SEND^BARDMAN2                  ; create and Send file to ITSC Server
 Q
 ; ********************************************************************
 ;
CHECK(BARQUIT) ;
 I ((BARINUM="")&(BARSNUM="")) Q 1
 I BARPATH="" Q 1
 I +BARIMAX=0 Q 1
 I +$L(BARSNUM),'+BARSMAX Q 1
 I BARINUM]"",BARICUR'<BARIMAX Q 1
 I BARSNUM]"",+BARSMAX,BARSCUR'<BARSMAX Q 1
 Q 0
 ; ********************************************************************
 ;
DATE ;
 S BARSTART=BARASDT               ; Start date for auto(def'd in param)
 I '+BARSTART S BARSTART=BARSRCHD    ; default earliest date to search
 Q:'+BARSTART                     ; quit if neither parameter set
 S X1=DT                          ; today
 S X2=-BARMAGE                    ; Minimum bill age (90 days if undef)
 D C^%DTC
 S BAREND=X                       ; End date
 Q
 ; ********************************************************************
 ;
PROCESS ;
 ; Find bills to send.
 S BARQUIET=1
 D FINDSTOP^BARDMAN2
 I BARICUR>BARIMAX,(+BARSMAX&(BARSCUR>BARSMAX)) Q
 I BARICUR>BARIMAX,'+BARSMAX Q
 D FINDSTRT^BARDMAN2
 Q
 ; ********************************************************************
 ;
CLEAN ;
 D ^BARVKL0
 Q
