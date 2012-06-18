BARNCPDP ; IHS/SD/LSL - Post NCPDP Reject/Payment Codes ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1**;MAR 27,2007
 ;
 ; IHS/SD/LSL - 03/04/04 - V1.7 Patch 5
 ;     Routine created.  Post NCPDP Reject/Payment Codes.
 ;
 Q
 ; ********************************************************************
 ;
EN ; EP
 D ^BARVKL0                    ; kill namespace variables
 S BARESIG=""                  ; BAR electronic signature flag
 D SIG^XUSESIG Q:X1=""         ; elec sig test - Q if fail
 S BARESIG=1                   ; passed elec sig test
 S (BARDONE,BARCOL,BARITM)=0
 I '$D(BARUSR) D INIT^BARUTL   ; Initialize BAR environment
 D BATCHITM                    ; Ask Collection Batch/Item
 I '+BARCOL!'+BARITM D MSG   ; Double check no batch/item
 I +BARDONE D XIT Q
 I +BARCOL,+BARITM,+$P(^BAR(90052.06,DUZ(2),DUZ(2),0),U,2) D FAC
 S BARBDONE=0
 F  D BILLS Q:+BARBDONE        ; Ask bills and codes and post
 D XIT
 Q
 ;*********************************************************************
 ;
BATCHITM ;
 ; Ask Collection Batch and Item (not required)
 D BATCH^BARFPST               ; Ask Collection Batch
 I +BARCOL D ITEM^BARFPST    ; If batch, ask item
 Q
 ; ********************************************************************
 ;
MSG ;
 ; If no batch/item, give user chance to select.
 K DIR
 S DIR("A")="A valid collection batch and item was not entered.  Continue"
 S DIR("B")="N"
 S DIR(0)="Y"
 D ^DIR
 Q:+Y
 ;
 K DIR
 S DIR("A")="Do you want to enter a new collection batch and item"
 S DIR("B")="Y"
 S DIR(0)="Y"
 I '+Y S BARDONE=1 Q
 K BARCOL,BARITM
 D BATCHITM
 I '+BARCOL!'+BARITM S BARDONE=1
 Q
 ; ********************************************************************
 ;
FAC ;
 ; I multiple EOB site parameter, do...
 D FAC^BARFPST               ;eob
 I Y>0 D
 . S BAREOB=+Y
 . S BAREOB(0)=Y(0)
 . D EBAL^BARPST(BAREOB)
 Q
 ; ********************************************************************
 ;
BILLS ;
 ; Loop bills, select remark codes and post
 D SELBILL
 ;Q:'+BARBL
 Q:'+$G(BARBL)  ;IHS/SD/TPF 12/6/2005 IM15742 BAR*1.8*1
 Q:+BARBDONE
 S BARRDONE=0
 K BARMK
 F  D SELNCPDP Q:+BARRDONE
 Q:'$D(BARMK)                      ; No remark codes to post
 D REVIEW                          ; Review selection
 I '+BARANS D  Q
 . W !!,"NCPDP Reject/Payment Codes not posted!"
 . K DIR
 . D EOP^BARUTL(1)
 D POSTCD                          ; Post remark code
 K DIR
 D EOP^BARUTL(1)
 Q
 ; ********************************************************************
 ;
SELBILL ; EP
 ; Ask user for bill
 K BARFPASS,DIC,DD,D0,X,Y,BARZ
 W $$EN^BARVDF("IOF")
 W !
 S BARFPASS=$$GETBIL^BARFPST3      ; Get bills by bill, patient, or DOS
 I BARFPASS=0 S BARBDONE=1 Q       ; No bill selected; End loop
 S BARPASS=$P(BARFPASS,U,1,3)      ; Patient^DOS Start^DOS End
 ; If no A/R Bill IEN
 I '+$P(BARFPASS,U,4) D FINDBIL^BARFPST3
 I '+$P(BARFPASS,U,4) Q            ; bill not found - ask again
 S BARBL=$P(BARFPASS,U,4)
 Q
 ; ********************************************************************
 ;
SELNCPDP ;
 ; Select NCPDP Reject/Payment codes
 W !
 K DIC,DR,DA,Y,X
 S DIC="^ABSPF(9002313.93,"
 S DIC(0)="AEMQZ"
 S DIC("A")="Select NCPDP Reject Payment Code: "
 I $D(BARMK) S DIC("A")="Select Additional NCPDP Reject Payment Code: "
 S DIC("W")="W ?40,$P(^(0),U,2)"
 K DD,D0
 D ^DIC
 I +Y>0 S BARMK(+Y)=Y(0) Q
 S BARRDONE=1
 Q
 ; ********************************************************************
 ;
REVIEW ;
 ; Display stuff to post...
 S $P(BARSTAR,"*",81)=""
 D GETS^DIQ(90050.01,BARBL,".01;3;7.2;15;17.2;18;101:103;108","IE","BARDAT")
 M BARDATA=BARDAT(90050.01,BARBL_",")
 I '$D(BAREOB) S BAREOB=BARDATA(108,"I")
 W $$EN^BARVDF("IOF")
 W !?1,"BILL #: ",$E(BARDATA(.01,"E"),1,25)
 W ?36,"DATE BILLED:",?50,BARDATA(18,"E")
 W !,"PATIENT: ",$E(BARDATA(101,"E"),1,25)
 W ?36,"AGE OF BILL:",?50,$J(BARDATA(7.2,"E"),5),"  DAYS"
 W !?2,"CHART: ",$P($G(^AUPNPAT(BARDATA(101,"I"),41,BAREOB,0)),U,2)
 W ?36,"BILL STATUS:",?50,BARDATA(17.2,"E")
 W !!?4,"DOS: ",BARDATA(102,"E")
 W ?39,"A/R ACCT:",?50,$E(BARDATA(3,"E"),1,30)
 I BARDATA(102,"I")'=BARDATA(103,"I") W !?5,"TO: ",BARDATA(103,"E")
 W !,BARSTAR
 S I=0
 F  S I=$O(BARMK(I)) Q:'+I  D
 . W !,$P(BARMK(I),U)
 . W !,$P(BARMK(I),U,2),!
 W BARSTAR
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Post these NCPDP Reject/Payment codes to this bill"
 S DIR("B")="Y"
 D ^DIR
 S BARANS=+Y
 Q
 ; ********************************************************************
 ;
POSTCD ;
 K BARDR
 ; Post selected remark codes to selected bill.
 S BARDR="4////^S X=BARBL"                        ; A/R Bill
 S BARDR=BARDR_";5////^S X=BARDATA(101,""I"")"              ; A/R Patient
 S BARDR=BARDR_";6////^S X=BARDATA(3,""I"")"               ; A/R Account
 S BARDR=BARDR_";8////^S X=DUZ(2)"                ; Parent Location
 S BARDR=BARDR_";9////^S X=DUZ(2)"                ; Parent ASUFAC
 ; Force A/R section to Business Office
 S BARDR=BARDR_";10////8"                         ; A/R Section
 S BARDR=BARDR_";11////^S X=BAREOB"               ; Visit Location
 S BARDR=BARDR_";12////^S X=DT"                   ; Date
 S BARDR=BARDR_";13////^S X=DUZ"        ; Entry by
 S BARDR=BARDR_";101////506"             ; Tran Type = Remark Code
 S BARDR=BARDR_";108////^S X=BARMKCD"
 I +BARCOL,+BARITM D                        ; If collection batch/item
 . S BARDR=BARDR_";14////^S X=BARCOL"
 . S BARDR=BARDR_";15////^S X=BARITM"
 ;
 S DIE=90050.03
 S DIDEL=90050
 S BARMKCD=0
 W !
 F  S BARMKCD=$O(BARMK(BARMKCD)) Q:'+BARMKCD  D
 . K DR,DA
 . W !,"Posting NCPDP Reject/Payment Code ",$P(BARMK(BARMKCD),U)
 . S BARTRIEN=$$NEW^BARTR                     ; Create New Transaction
 . I +BARTRIEN<1 D MSG^BARTR(BARBL) Q
 . ; Populate Transaction file
 . S DA=BARTRIEN                              ; IEN to A/R TRANSACTION
 . S DR=BARDR
 . D ^DIE
 K DIDEL,DIE,DA,DR,DIR
 Q
 ; ********************************************************************
 ;
XIT ;
 W $$EN^BARVDF("IOF")
 D ^BARVKL0
 Q
