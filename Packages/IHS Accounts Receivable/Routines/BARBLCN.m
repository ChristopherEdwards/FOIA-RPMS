BARBLCN ; IHS/SD/LSL - CANCEL BILL ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; ITSC/SD/LSL - 10/18/02 - V1.7 - NOIS QAA-1200-130051
 ;       Added quit logic if error getting new A/R Transaction although
 ;       I'm not sure this feature even works correctly.
 ;
 ; ********************************************************************
ENP ; EP
 ; EN point for cancelling a bill from 3P 
 I '$D(^BARBL(DUZ(2),"B",X)) D  Q
 . W $$EN^BARVDF("IOF"),X_"  Not in A/R System!"
 ;
 ; -------------------------------
SRCHTRNS ;
 ; Search the ^BARTR global for 49 type of transaction record for this A/R bill
 S (BARDTTM,BARBLDA)=0
 S BARUNDO=1
 K BARBIL
 S BARBLDA=$O(^BARBL(DUZ(2),"B",X,0))
 F  S BARDTTM=$O(^BARTR(DUZ(2),"AC",BARBLDA,BARDTTM)) Q:BARDTTM'>0  D
 . I '$D(^BARTR(DUZ(2),BARDTTM,0)) Q
 . I '$D(^BARTR(DUZ(2),BARDTTM,1)) Q
 . I $P(^BARTR(DUZ(2),BARDTTM,1),"^")=49 D  Q
 .. D REVERSE
 . Q
 I BARTRIEN<1 Q
 S BARBLST="143"
 S DA=BARBLDA
 S (DIC,DIE)=$$DIC^XBDIQ1(90050.01)
 S DR="16////^S X=BARBLST"
 S DIDEL=90050
 D ^DIE
 K DIDEL
 Q
 ; *********************************************************************
 ;
REVERSE ;
 ; Create transaction records to reverse out the transaction records when 3P cancels a bill
 N BARX,BARCR,BARDB,BARTT,BARCAT,BARATYP,BARBDFN,BARPT,BARAC,BARPAR
 N BARASFAC,BARSECT,BARSITE,BARTYPE
 S BARTRIEN=$$NEW^BARTR
 I BARTRIEN<1 D MSG^BARTR(BARBLDA) Q
 K DIE,DIC,DR,DA
 S (DA,BARTRDA)=X
 S DIE=90050.03
 S BARX=^BARTR(DUZ(2),BARDTTM,0)
 S (BARCR,BARDB)=0
 S:$P(BARX,"^",2)'=0 BARCR=$P(BARX,"^",2)
 S:$P(BARX,"^",3)'=0 BARDB=$P(BARX,"^",3)
 S BARTT=41
 S BARCAT=3
 S BARATYP=135
 S BARBDFN=$P(BARX,U,4)
 S BARPT=$P(BARX,U,5)
 S BARAC=$P(BARX,U,6)
 S BARPAR=$P(BARX,U,8)
 S BARASFAC=$P(BARX,U,9)
 S BARSECT=$P(BARX,U,10)
 S BARSITE=$P(BARX,U,11)
 S BARTYPE=$P(BARX,U,16)
 S DR=""
 F I=1:1 S J=$T(TXT+I) Q:J=""  D
 . S DR=DR_$P(J,"~",2)_";"
 . Q
 S DIDEL=90050
 D ^DIE
 K DIDEL
 D TR^BARTDO(BARTRDA,BARUNDO)
 ;
EXIT Q
TXT ;
 ;;~2////^S X=BARCR
 ;;~3////^S X=BARDB
 ;;~4////^S X=BARBDFN
 ;;~5////^S X=BARPT
 ;;~6////^S X=BARAC
 ;;~8////^S X=BARPAR
 ;;~9////^S X=BARASFAC
 ;;~10////^S X=BARSECT
 ;;~11////^S X=BARSITE
 ;;~12////^S X=DT
 ;;~13////^S X=DUZ
 ;;~16////^S X=BARTYPE
 ;;~101////^S X=BARTT
 ;;~102////^S X=BARCAT
 ;;~103////^S X=BARATYP
 Q
