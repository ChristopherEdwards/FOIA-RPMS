BAR3PINQ ; IHS/SD/LSL - Inquire into 3P Bill file from A/R Bill file DEC 4,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**16**;OCT 22,2008
 ;
 ; IHS/SD/LSL - 11/25/02 - V1.7 - NHA-0601-180049
 ;      Modified to search for bill in 3PB correctly (majority of the
 ;      routine has changed)
 ;
 ; M2 TMM 01/12/2010  HEAT 8727, Resolve error when 3P Claim does not exist.
 ;                    This scenario occurs when POS incorrectly creates claims 
 ;                    in ^ABMDBILL under individual site rather than the parent 
 ;                    facility and there are no corresponding claims in ^ABMDCLM.
 ;                         $ZE= <UNDEFINED>EN+7^DIC *DINDEX("#")
 ;                         . S:DINDEX("#")>1 DIC(0)=$TR(DIC(0),"M") Q
 ; ********************************************************************
 ;
 ;Computed field routine utilization
 ; $$VAL^BAR3PINQ(A/R IEN,"B"-bill "C"-claim,field number)
 ; $$VALI^BAR3PINQ(A/R IEN,"B"-bill "C"-claim,field number)
 Q
VAL(BARDA,BARFILE,BARFLD) ;EP - Return field from remote file
 N BARBL,BARDUZ2,BARX,Y,BAR3PBIL
 S BARX="",BARDUZ2=0
 D ENP^XBDIQ1(90050.01,BARDA,".01;17;108","BARBL(","I")
 S BAR3PBIL=$$FIND3PB^BARUTL(DUZ(2),BARDA)
 I BAR3PBIL="" G QUIT
 ;changes for supportability 
 I BARFILE'="B" G C
 ;
 ; -------------------------------
B ;EP - process "B"ill
 S BARDUZ2=DUZ(2)
 S DUZ(2)=$P(BAR3PBIL,",")
 S BARX=$$GET1^DIQ(9002274.4,$P(BAR3PBIL,",",2),BARFLD)
 S DUZ(2)=BARDUZ2
 G QUIT
 ; *********************************************************************
 ;
C ;EP - process "C"laim information
 N BARTMP1,BARTMP2                              ;M2*ADD*TMM
 S BARTMP1=$P(BAR3PBIL,",",1)       ;3PB DUZ2   ;M2*ADD*TMM
 S BARTMP2=$P(BAR3PBIL,",",2)       ;3PB IEN    ;M2*ADD*TMM
 I '$D(^ABMDCLM(BARTMP1,BARTMP2)) G QUIT        ;M2*ADD*TMM
 S BARDUZ2=DUZ(2)
 S DUZ(2)=$P(BAR3PBIL,",")
 S DIC=9002274.3
 S X=+BARBL(.01)
 S DIC(0)="X"
 D ^DIC
 S:Y>0 BARX=$$GET1^DIQ(9002274.3,+Y,BARFLD)
 S DUZ(2)=BARDUZ2
QUIT ;**
 K BAR3PDA
 Q BARX
