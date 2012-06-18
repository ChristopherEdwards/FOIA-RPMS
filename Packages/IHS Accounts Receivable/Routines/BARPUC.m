BARPUC ; IHS/SD/LSL - UN-ALLOCATED CASH JAN 16,1997 ; 01/26/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,6,7,9,10,17,21**;OCT 26, 2005
 ;
 ; ********************************************
 ;
EN ;EP - Unallocated Posting
 S BARESIG=""
 D SIG^XUSESIG
 Q:X1=""  ;elec signature test
 S BARESIG=1
 D RAYGO^BARPST  ;ROLLOVER QUESTION-
 ;
ENTRY ;
 S REIMBURS=0  ;BAR*1.8*4 SCR? 2 REIMBURSEMENT MODE
 S TRANSFER=0  ;BAR*1.8*4 UFMS SCR? TRANSFER MODE
 D ^BARVKL0       ;KILL OFF BAR* VARIABLES
 K ^TMP($J,"BARVL")
 I '$D(BARUSR) D INIT^BARUTL  ;INITIALIZE VARIABLES  
 W !!
 ;
GETTX ;
 ;** list open u/c transactions and get selection from user
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 K BARVL
 K BARTX
 S (BARCNT,BARTX)=0
 S BARTT=$O(^BARTBL("B","UN-ALLOCATED",""))
 F  S BARTX=$O(^BARTR(DUZ(2),"AGL","O",BARTX)) Q:'BARTX  D
 . Q:$$GET1^DIQ(90050.03,BARTX,101,"I")'=BARTT
 . Q:'$$CKDATE^BARPST($P(^BARTR(DUZ(2),BARTX,0),U,14),0,"COLLECTION")  ;IGNORE OLD BATCHES;MRS;BAR*1.8*6 DD 4.2.4
 . S ^TMP($J,"BARVL",BARTX)=""
 I '$D(^TMP($J,"BARVL")) D  G EXIT
 . W *7,"No open UNALLOCATED CASH transactions on file!"
 . D EOP^BARUTL(0)
 ;;; routine ^BARPTR finds g/l transactions and returns selected trx.
 S BARTR=$$EN^BARPTR()
 I +BARTR=0 G EXIT
 ;
LOADTX ;
 ; ** get u/c transaction detail
 K BARTX
 S DR="2;6;14;15;105"
 S DA=+BARTR
 S DIC="^BARTR(DUZ(2),"
 S DIQ(0)="0I"
 S DIQ="BARTX("
 D ENP^XBDIQ1(DIC,DA,DR,DIQ,DIQ(0))
 S BARCLV(17)=$$GET1^DIQ(90051.01,BARTX(14,"I"),17)  ;A/R COLLECTION BATCH, BATCH POSTING BALANCE
 S BARITV(19)=$$GET1^DIQ(90051.01,BARTX(15,"I")_","_BARTX(14,"I")_",",19)  ;A/R COLLECTION BATCH,POSTABLE TOTAL 
 ;
CHOOSE ;
 D TOP^BARPTR
 W ?3,$J(BARTX(2,"I"),8,2)
 W ?15,$E(BARTX(6),1,30)
 W ?47,BARTX(14),!
 S BARPRTQ=0 ; PRINT COMMENTS ON LETTER VARIABLE PKD BAR 1.8.17
 K DIR
 ;S DIR(0)="SAO^1:Post to A/R Bill;2:Refund;3:Exit"
 ;S DIR("A")="Action (1=Post to an A/R Bill, 2=Refund, 3=Exit): "
 ; Remove old Action list and insert new ; PKD:BAR*1.8*17 IHS/SD/PKD 2/12/2010 Add Msg to Item per Adrian
 ;S DIR(0)="SAO^1:Post to A/R Bill;2:Refund;3:Unbilled Reimb;4:Transfers;6:Exit"
 ;S DIR("A")="Action (1=Post to an A/R Bill, 2=Refund, 3=Unbilled Reimbursement, 4=Transfer to another facility, 6=Exit): "  ;BAR*1.8*P4 SCR56
 S DIR(0)="SAO^1:Post to A/R Bill;2:Refund;3:Unbilled Reimb;4:Transfers;5:Add Item Message;6:Exit"
 S DIR("A")="Action (1=Post to an A/R Bill, 2=Refund, 3=Unbilled Reimbursement, 4=Transfer to another facility, 5=Add Item Message, 6=Exit): "  ;BAR*1.8*P17 
 ; Remove old Action list and insert new ; PKD:BAR*1.8*17 IHS/SD/PKD 2/12/2010 Add Msg to Item per Adrian
 ;I $$IHS^BARUFUT(DUZ(2)) D               ;MRS:BAR*1.8*7 TO131 REQ_11
 ;.S DIR(0)="SAO^1:Post to A/R Bill;2:Refund;3:Transfers;4:Exit"
 ;.S DIR("A")="Action (1=Post to an A/R Bill, 2=Refund, 3=Transfer to another facility, 4=Exit): "  ;BAR*1.8*P4 SCR56
 I $$IHS^BARUFUT(DUZ(2)) D               ;MRS:BAR*1.8*7 TO131 REQ_11
 .S DIR(0)="SAO^1:Post to A/R Bill;2:Refund;3:Transfers;4:Add Item Message;5:Exit"
 .S DIR("A")="Action (1=Post to an A/R Bill, 2=Refund, 3=Transfer to another facility, 4=Add Item Message, 5=Exit): "  ;BAR*1.8*P17
 ;take out reprint from this action menu
 ;per Adrian testing of 12/1/2007
 ;S DIR(0)="SAO^1:Post to A/R Bill;2:Refund;3:Unbilled Reimb;4:Transfers;5:Reprint Letter;6:Exit"
 ;S DIR("A")="Action (1=Post to an A/R Bill, 2=Refund, 3=Unbilled Reimbursement, 4=Transfer to another facility, 5=Reprint Letter, 6=Exit): "  ;BAR*1.8*P4
 D ^DIR
 ;Begin old code ;MRS:BAR*1.8*9 IM30896
 ;K DIR
 ;I $D(DIRUT) G ENTRY
 ;I Y=3 G EXIT
 ;I Y=5 G EXIT  ;BAR*1.8*4 ITEM 4 SCR
 ;I Y=6 G EXIT  ;BAR*1.8*4
 ;I Y=5 D REPRINT^BARUFLTR G ENTRY  ;BAR*1.8*4
 ;I Y=3 D REIMBURS S REIMBURS=1 G ENTRY
 ;I Y=4 D TRANSFER G ENTRY
 ;END BAR*1.8*4 SCR56
 ;I Y=2 D REFUND G ENTRY
 ;I Y=6 G EXIT  ;BAR*1.8*4
 ;I Y=5 D REPRINT^BARUFLTR G ENTRY  ;BAR*1.8*4
 ;I Y=5 G EXIT  ;BAR*1.8*4 ITEM 4 SCR
 ;END BAR*1.8*4 SCR56
 ;Begin new code ;MRS:BAR*1.8*9 IM30896
 N STR
 S STR=$P($E($P(DIR("A"),Y,2),2,99),",")  ; Get the Action Choice
 I $D(DIRUT) G ENTRY
 I Y=1 G GETBILL
 I Y=2 D REFUND G ENTRY
 ; Remove old code to simplify selection BAR*1.8*17 PKD
 ;I Y=3,STR["3=Unbilled Reimb" D REIMBURS S REIMBURS=1 G ENTRY
 ;I Y=3,STR["3=Transfer" D TRANSFER G ENTRY
 ;I Y=4,STR["4=Transfer" D TRANSFER G ENTRY  ;MRS:BAR*1.8*10 H1333
 ; Begin new code, simplify selection ; PKD:BAR*1.8.17 2/12/10
 I STR["Unbilled Reimb" D REIMBURS S REIMBURS=1 G ENTRY
 I STR["Transfer" D TRANSFER G ENTRY
 I STR["Item Message" D ITMSG^BARPUC2 G ENTRY  ; Adding Item Msg per Adrian
 G EXIT
 ;End new code ;MRS:BAR*1.8*9 IM30896
 ;--------------------------------
 ;
GETBILL ;
 S BARPASS=$$EN^BARPST1()
 I +BARPASS=0 G EXIT
 S BARCNT=$$EN^BARPUC2(BARPASS)
 I +BARCNT=0 W *7,!!,"No bills in this date range!",!! G EN
 D EN^BARPUC3
 G ENTRY
 ;
EXIT ;
 K ^TMP($J,"BARVL")
 D ^BARVKL0
 Q
 ;
REFUND ;
 N BARAMT,BARAC,BARTT
 ;
AMT ;
 S BARDEF=BARTX(2)
 W !!!,"Refund Amount: "
 W $J(BARDEF,0,2)_"// "
 R X:DTIME
 I X="" S X=+BARDEF
 S X=$$AMT^BARPUCU(X,0,BARDEF)
 I X="^" Q
 I X="?" W *7,"  Must be a valid number!" G AMT
 S BARAMT=X
 ;
REFTO ;
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("B")=BARTX(6)
 S DIC("A")="A/R Account: "
 S DIC("S")="I $P(^(0),U)'[(""AUTTLOC"")"  ;BAR*1.8*3 UFMS
 K DD,DO
 D ^DIC
 K DIC
 I +Y<0 G AMT
 S BARAC=+Y
 ;
REFPST ;** post refund
 N DIC,DR,DA
 S BARTT=39
 ; correct posting of refunds
 S BARCAT=19
 S (BARATYP,BARX,BARJ)=0
 F  S BARX=$O(^BARTBL("D",BARCAT,BARX)) Q:'BARX  D  Q:BARJ>1
 .S BARJ=BARJ+1
 .Q:BARJ>1
 .S BARATYP=BARX
 S DIC=90052.02
 S DIC(0)="AEMNQZ"
 S DIC("A")="Adjustment Type: "
 ;S DIC("S")="I $P(^(0),U,2)=BARCAT"
 S DIC("S")="I $P(^(0),U,2)=BARCAT,(Y<1000)"  ;BAR*1.8*4 LATE REQUEST PER SANDRA 11/27/2007
 K DD,DO
 D ^DIC
 K DIC
 I +Y<0 D  G AMT
 . K BARAMT
 . W *7,!!
 S BARATYP=+Y
 S NEWEXTYP=$P(Y,U,2)
 S NEWTYP=$P(Y,U)
 ;
 ;BEGIN NEW CODE BAR*1.8*4 ADD REFUND LETTER CAPABILITY
ASKREF ;EP - VERIFY ENTRY
 N ASKREF
 K DIR
 ;S DIR("A",1)="You have entered "_BARAMT_" as an Refund to "_BARAC_"."
 S DIR("A",1)="You have entered "_BARAMT_" as a Refund to "_$$GET1^DIQ(90050.02,BARAC_",",.01,"E")_"."  ;IHS/SD/TPF; BAR*1.8*6 IM30170
 S DIR("A")="Would you like to Post this or Print the Finance Letter"
 S DIR("B")="L"
 S DIR(0)="SO^P:POST IT;L:PRINT FINANCE LETTER"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) G REFUND
 S ASKREF=Y
 ;S BARAMT=NEWVALUE
 ;S BARSIB(101,"I")=NEWTYP
 ;S BARAC=BARTX(6,"I")
 S BARCHK=$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",11,"E")
 S BARSCHED=$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")
 I ASKREF="L" D  Q  ; If comments exist, give option to print BAR1.8*17 PKD 2/24/2010 
 . D PRTQ^BARPUC2  ; Question
 . D LETTER^BARUFLTR(BARAMT,BARTX(14),BARCHK,BARSCHED,BARTX(6),"REFUND LETTER",NEWTYP_" "_NEWEXTYP) Q
 W !!
 K DIR
 S DIR(0)="Y"
 S DIR("B")="N"
 S DIR("A")="ARE YOU SURE YOU WISH TO POST THIS NOW?"
 D ^DIR
 G:'Y!$D(DTOUT)!$D(DUOUT) ASKREF
 K ASKREF
 ;CONTINMUE ON TO POST THE REFUND
 ;
REIMCONT ;EP - REIMBURSEMENT CONTINUED
TRANCONT ;EP - TRANSFER CONTINUED
 S DR="3////^S X=BARAMT"
 S DR=DR_";6////^S X=BARAC"
 S DR=DR_";12////^S X=DT"
 S DR=DR_";13////^S X=DUZ"
 S DR=DR_";101////^S X=BARTT"
 ;S DR=DR_";102///^S X=+BARCAT"
 ;S DR=DR_";103///^S X=+BARATYP"
 S:'REIMBURS&'(TRANSFER) DR=DR_";102///^S X=+BARCAT"  ;BAR*1.8*4 UFMS SCR56
 S:'REIMBURS&'(TRANSFER) DR=DR_";103///^S X=+BARATYP"
 S DR=DR_";201////^S X=+BARTX(""ID"")"
 S DR=DR_";14////^S X=BARTX(14,""I"")"
 S DR=DR_";15////^S X=BARTX(15,""I"")"
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 ;
PX ; 
 S X=$$NEW^BARTR
 ;I X<1 D  G REFUND
 ;. W !!,"The system couldn't create a REFUND transaction.  Please try again.",!
 ;IHS/SD/TPF BAR*1.8*4 UFMS SCR56
 I X<1 D  G:'REIMBURS&'(TRANSFER) REFUND Q
 . W !!,"The system couldn't create a "_$S($G(REIMBURS):"REIMBURSEMENT",$G(TRANSFER):"TRANSFER",1:"REFUND")_" transaction.  Please try again.",!
 ;END
 S DA=X
 S DIE=90050.03
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ;
 ;** Update account
 N BARUNAC
 S BARUNAC=$$GET1^DIQ(90050.03,+BARTX("ID"),6,"I")
 S BARTX(304)=$$GET1^DIQ(90050.02,BARUNAC,304,"I")
 S DIE="^BARAC(DUZ(2),"
 S DA=BARUNAC
 S DR="304////^S X=BARTX(304)-BARAMT"             ;UNALLOCATED
 S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"  ;A/R SERVICE
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ; 
 ; UPDATE TRANSFER TO ACCOUNT
 I $G(TRANSFER) D
 .S TBARACAM=$$GET1^DIQ(90050.02,TBARAC_",",301,"I")  ;A/R CURRENT BALANCE FOR TRANSFER TO ACCT
 .S DIE="^BARAC(DUZ(2),"
 .S DA=TBARAC
 .S DR="301////^S X=TBARACAM+BARAMT"               ;ADD THE TRANSFERRED AMOUNT
 .S DR=DR_";10////^S X=$$VALI^XBDIQ1(200,DUZ,29)"
 .S DIDEL=90050
 .D ^DIE
 .K DIDEL
 ;
 G:REIMBURS!(TRANSFER) FINISH  ;IHS/SD/TPF BAR*1.8*3 UFMS SCR2
 ;
 ;** update collection batch 
 ; Next 9 lines of code to post refund amount to a batch,
 ; if the transaction record has a batch/item number defined
 I BARTX(14,"I")'>0 G FINISH
 S DA=BARTX(15,"I")     ;A/R COLLECTION ITEM
 S DA(1)=BARTX(14,"I")  ;A/R COLLECTION BATCH
 S BARITRF=$$GET1^DIQ(90051.1101,.DA,106,"I")
 S BARITRF=BARITRF+BARAMT
 K DA,DIE,DIC,DR
 S DIE=$$DIC^XBDIQ1(90051.1101)
 S DA=BARTX(15,"I")
 S DA(1)=BARTX(14,"I")
 ;THIS IS A COMPUTED FIELD OFF OF $$ITT^BARCBC I DON'T THINK THIS DOES
 ;ANYTHING
 S DR="106////^S X=BARITRF"  ;ITEM REFUNDED UNDER ITEM SUBFILE
 S DIDEL=90050
 D ^DIE
 K DIDEL
 ;
FINISH ;
 K DR,DIC
 I (+BARTX(2,"I"))-(+BARAMT)'=0 D  G CLOSE
 . D ENP^XBDIQ1("^BARTR(DUZ(2),",+BARTX("ID"),"6;8;10;11;14;15;101;104;105","BARSIB(","0I")
 . S BARREM=(+BARTX(2,"I"))-(+BARAMT)
 . S DIC="^BARTR(DUZ(2),"
 . S DIC(0)="L"
 . S DLAYGO=90050
 . L +^BARTR(DUZ(2)):2
 . F  D NOW^%DTC S X=% I '$D(^BARTR(DUZ(2),"B",X)) L -^BARTR(DUZ(2)) D ^DIC K DLAYGO Q
 . S BARSIB=+Y
 . I BARSIB<1 D  G FINISH
 . . W !,"Couldn't create a new UN-ALLOCATED transaction.  The system is trying again.",!
 . S DA=BARSIB
 . S DIE="^BARTR(DUZ(2),"
 . S DR="2////^S X=BARREM"
 . S DR=DR_";12////^S X=DT"
 . S DR=DR_";13////^S X=DUZ"
 . S DR=DR_";201////^S X=+BARTX(""ID"")"
 . S DR=DR_";6////^S X=BARSIB(6,""I"")"
 . S DR=DR_";8////^S X=BARSIB(8,""I"")"
 . S DR=DR_";10////^S X=BARSIB(10,""I"")"
 . S DR=DR_";11////^S X=BARSIB(11,""I"")"
 . S DR=DR_";14////^S X=BARSIB(14,""I"")"
 . S DR=DR_";15////^S X=BARSIB(15,""I"")"
 . S DR=DR_";101////^S X=BARSIB(101,""I"")"
 . S DR=DR_";104////^S X=BARSIB(104,""I"")"
 . S DR=DR_";105////^S X=BARSIB(105,""I"")"
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 . S DIE="^BARTR(DUZ(2),"
 . S DR="2////^S X=BARAMT"
 . S DR=DR_";105////^S X=""R"""
 . S DR=DR_";202////^S X=+BARSIB"
 . S DA=+BARTX("ID")
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 . Q
 I (+BARTX(2,"I"))-(+BARAMT)=0 D
 . S DIE="^BARTR(DUZ(2),"
 . S DR="105////^S X=""R"""
 . S DA=+BARTX("ID")
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 ;
CLOSE ;
 K ^BARTMP($J)
 K BARTX,BARREM,BARSIB,BARTR,BARPMT,BARADJ,BARCAT,BARATYP,BARBTOT,BARBLV
 Q
REIMBURS ;EP - PROCESS REIMBURSEMENTS
 S REIMBURS=1  ;REIMBURSEMENT MODE
 K DIR
 S DIR(0)="NO^.01:"_$G(BARTX(2))_":2"
 S DIR("A")="Unbilled Reimbursement Amount: "
 S DIR("B")=$G(BARTX(2))
 D ^DIR
 Q:$D(DIRUT)!$D(DUOUT)!$D(DTOUT)
 I Y>BARTX(2) W !,"YOU CANNOT ENTER AN AMOUNT EXCEEDING THE UNALLOCATED AMOUNT!!" K DIR S DIR(0)="E" D ^DIR G REIMBURS
 S NEWVALUE=Y
 ;
ASKTYP ;EP - ASK TYPE
 K DIR,DIE,DIC,DR,DA,X
 S DIC="^BARTBL("
 S DIC(0)="AEQZ"
 S DIC("A")="Unbilled Reimbursement Type: "
 S DIC("S")="I $P(^(0),U,2)=23"
 D ^DIC
 G:Y<0 REIMBURS
 S BARTT=+Y
 S BARATYP=""
 S BARCAT=""
 S NEWTYP=+Y
 S EXNEWTYP=$P(Y,U,2)
ASKVER ;EP - VERIFY ENTRY
 N ASKVER
 K DIR
 S DIR("A",1)="You have entered "_NEWVALUE_" as an Unbilled Reimbursement to "_EXNEWTYP_"."
 S DIR("A")="Would you like to Post this or Print the Finance Letter"
 S DIR("B")="L"
 S DIR(0)="SO^P:POST IT;L:PRINT FINANCE LETTER"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) K NEWTYP,EXNEWTYP,NEWVALUE G REIMBURS
 S ASKVER=Y
 S BARAMT=NEWVALUE
 S BARSIB(101,"I")=NEWTYP
 S BARAC=BARTX(6,"I")
 S BARCHK=$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",11,"E")
 S BARSCHED=$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")
 ;I ASKVER="L" D LETTER^BARUFLTR(BARAMT,BARTX(14),BARCHK,BARSCHED,BARTX(6),"UNBILLED REIMBURSEMENT LETTER") Q  ;PRINT REIMBURSMENT LETTER
 I ASKVER="L" D  Q
 . D PRTQ^BARPUC2  ; Question to print comments
 . D LETTER^BARUFLTR(BARAMT,BARTX(14),BARCHK,BARSCHED,BARTX(6),"UNBILLED REIMBURSEMENT LETTER",NEWTYP_" "_EXNEWTYP) Q  ;PRINT REIMBURSMENT LETTER ;BAR*1.8*4
 W !!
 K DIR
 S DIR(0)="Y"
 S DIR("B")="N"
 S DIR("A")="ARE YOU SURE YOU WISH TO POST THIS NOW?"
 D ^DIR
 G:'Y!$D(DTOUT)!$D(DUOUT) ASKVER
 D REIMCONT
 K ASKVER
 Q
 ;
TRANSFER ;EP - PROCESS TRANSFERS
 S BARTT=560
 S BARATYP=""
 S BARCAT=""
 S TRANSFER=1  ;TRANSFER MODE
 K DIR
 S DIR(0)="NO^.01:"_$G(BARTX(2))_":2"
 S DIR("A")="Transfer Amount: "
 S DIR("B")=$G(BARTX(2))
 W !!
 D ^DIR
 Q:$D(DIRUT)!$D(DUOUT)!$D(DTOUT)
 I Y>BARTX(2) W !,"YOU CANNOT ENTER AN AMOUNT EXCEEDING THE UNALLOCATED AMOUNT!!" K DIR S DIR(0)="E" D ^DIR G TRANSFER
 S NEWVALUE=Y
 ;
ASKACCT ;EP - TRANSFER TO WHAT A/R ACCOUNT
 K DIR,DIC,DIE,DA,X
 S DIC="^BARAC(DUZ(2),"
 S DIC(0)="AMEZQ"
 S DIC("S")="I $P(^(0),U)[(""AUTTLOC"")"
 W !
 D ^DIC
 G:Y<0 TRANSFER
 S TBARAC=$P($P(Y,U,2),";")  ;TRANSFER TO ACCOUNT
 S TEXBARAC=$$GET1^DIQ(9999999.06,TBARAC_",",.01,"E")
 ;
ASKVERT ;EP - VERIFY ENTRY
 K DIR
 N ASKVERT
 S DIR("A",1)="You are transferring "_NEWVALUE_" to "_TEXBARAC_"."
 S DIR("A")="Would you like to Post this or Print Finance Letter"
 S DIR("B")="L"
 S DIR(0)="SO^P:POST IT;L:PRINT FINANCE LETTER"
 W !
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) K NEWVALUE,EXBARAC G TRANSFER
 S ASKVERT=Y
 S BARAMT=NEWVALUE
 S BARSIB(101,"I")=560
 S BARAC=BARTX(6,"I")
 S BARCHK=$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",11,"E")
 S BARSCHED=$$GET1^DIQ(90051.1101,BARTX(15,"I")_","_BARTX(14,"I")_",",20,"E")
 I ASKVERT="L" D  Q
 . D PRTQ^BARPUC2  ; Question to print comments
 . D LETTER^BARUFLTR(BARAMT,BARTX(14),BARCHK,BARSCHED,TEXBARAC,"TRANSFER LETTER") Q  ;PRINT TRANSFER LETTER
 W !!
 K DIR
 S DIR(0)="Y"
 S DIR("B")="N"
 S DIR("A")="ARE YOU SURE YOU WISH TO POST THIS NOW?"
 D ^DIR
 G:'Y!$D(DTOUT)!$D(DUOUT) ASKVERT
 D REIMCONT
 Q
R ;;MEDICARE
MD ;;MEDICARE
MH ;;MEDICARE
D ;;MEDICAID
K ;;MEDICAID
F ;;PRIVATE INS
P ;;PRIVATE INS
H ;;PRIVATE INS
M ;;PRIVATE INS
T ;;PRIVATE INS
N ;;OTHER
I ;;OTHER
W ;;OTHER
C ;;OTHER
G ;;OTHER
