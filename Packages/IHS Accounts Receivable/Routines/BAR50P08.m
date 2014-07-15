BAR50P08 ; IHS/SD/LSL - POST HIPAA CLAIMS ; 12/01/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,4,5,6,10,19,20,21,23**;OCT 26,2005
 ;; NOHEAT 11/06/2013 REFINING ERROR MESSAGE >> -> >>>
  Q
POST(BARCKDA) ; EP  bar*1.8*20 REQ6 changed BARCKIEN to BARCKDA
 ;Post this ERA Check (called from POST^BAR50P00)
 N BPR02  ;TPF BAR*1.8*6 SCR119
 K BAROLD  ;MRS:BAR*1.8*6 DD 4.2.4
 S BARFND=0
 S BARSECT=BARUSR(29,"I")
 S BARCHECK=$P($G(^BARECHK(BARCKDA,0)),U)
 S BARBATCH=$P($G(^BARECHK(BARCKDA,0)),U,3)
 S BARPITEM=$P($G(^BARECHK(BARCKDA,0)),U,4)
 S BARICQ=$$GET1^DIQ(90056.22,BARCKDA_",",.08)  ;ID CODE QUALIFIER FROM A/R EDI IMPORT XX=NPI, FI = TAX ID
 S BARNPI=$$GET1^DIQ(90056.22,BARCKDA_",",.09)  ;ID CODE (NPI) FROM A/R EDI IMPORT
 S BARTIN=$$GET1^DIQ(90056.22,BARCKDA_",",.11)  ;TAX ID FROM A/R EDI IMPORT
 S BPR02=$$GETBPR02(BARCHECK)
 I BPR02?.A D  Q
 .;W !,"CANNOT FIND A BPR02 VALUE IN IMPORT FILE!" OLD CODE
 .W !,"CANNOT FIND A BPR02 VALUE IN IMPORT FILE! ("_BPR02_")" ;11/06/2013 MORE SPECIFIC MESSAGE
 .K DIR S DIR(0)="E"
 .D ^DIR
 K BARADD,BARERR
 D GETS^DIQ(90056.22,BARCKDA_",","2211*","E","BARADD","BARERR")  ;GET PAYEE ADD IDENTIFICATION  ;bar*1.8*20 REQ6
 I BARBATCH'="",'$$CKDATE^BARPST(BARBATCH,1,"POSTING TO A/R COLLECTION BATCH") D  Q  ;MRS:BAR*1.8*6 DD 4.2.4 USER ALLOWED TO POST TO NO BATCH SCR119
 .S (BARBATCH,BAROLD)=""
 .D NOBATCH
 I (BARBATCH=""!(BARPITEM="")),(BPR02>0) D NOBATCH  ;TPF BAR*1.8*6 SCR119
 Q:+BARFND
 I $D(BAROLD) K BAROLD Q  ;MRS:BAR*1.8*6 DD 4.2.4
 ;if there are claims w/BUILT status
 I $D(^BAREDI("I",DUZ(2),IMPDA,30,"AC","B")) D
 .S CLMDA=0
 .K BARSTOP
 .F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,"AC","B",CLMDA)) Q:'CLMDA  D
 ..I $P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U)=BARCHECK S BARSTOP=1
 .I $G(BARSTOP)=1 W !!,"EDI Claims are still in a BUILT status for this check!",!,"Run BLMT or REV auto-review for matching."
 Q:($G(BARSTOP)=1)
 D ASKPOST
 Q:'BARANS  ;MRS:BAR*1.8*10 H1228
 K DIR
 D EOP^BARUTL(1)
 D POSTEM
 I '+BARPSTED D  Q
 . W !!,"No matched bills to post",!!
 . I PSTQFLG=1 W !,$$EN^BARVDF("HIN"),"** BILLS HAVE BEEN MARKED AS 'ITEM BALANCE EXCEEDED'.  PLEASE REVIEW AND POST",!?4,"MANUALLY**",$$EN^BARVDF("HIF")  ;bar*1.8*20 REQ6
 . K DIR
 . D EOP^BARUTL(1)
 W !!,BARPSTED," Bills posted to AR.",!
 ;start new bar*1.8*20 REQ6
 I PSTQFLG=1 W !!,$$EN^BARVDF("HIN"),"** BILLS HAVE BEEN MARKED AS 'ITEM BALANCE EXCEEDED'.  PLEASE REVIEW AND POST",!?4,"MANUALLY**",$$EN^BARVDF("HIF")
 ;end new REQ6
 D ROLLBACK  ;Rollback now or later
 Q
 ;
GETBPR02(BARCHECK) ;EP -GET BPR02 MONETARY AMT FROM ERACHECK
 N IMPDA,CLMDA,BPR02
 S IMPDA="" S IMPDA=$O(^BAREDI("I",DUZ(2),"F",BARCHECK,IMPDA),-1)  ;ALL BPR02 WILL BE SAME FOR ALL CHK ENTRIES. GET LAST LOAD
 Q:IMPDA="" "NOIMPORT"
 S CLMDA="" S CLMDA=$O(^BAREDI("I",DUZ(2),"F",BARCHECK,IMPDA,CLMDA))
 Q:CLMDA="" "NOCLAIMFORIMPORT"
 S BPR02=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U,5)
 Q:BPR02="" "NOBPR02"
 Q BPR02
 ;
NOBATCH ;
 ;Chk for pymts on clms for this chk
 S (BARCLM,BARFND)=0  ;"F" IS CHECK/EFT TRACE X-REF
 F  S BARCLM=$O(^BAREDI("I",DUZ(2),"F",BARCHECK,IMPDA,BARCLM)) Q:'+BARCLM  D  Q:+BARFND
 . Q:'+$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCLM,0)),U,4)  ;E-PYMT
 . S BARFND=1
 I +BARFND D
 . W !!,$$CJ^XLFSTR("Check "_BARCHECK_" does not match an RPMS Collection Batch and Item.",IOM)
 . W !,$$CJ^XLFSTR("There is at least one bill for this check containing a payment amount.",IOM)
 . W !,$$CJ^XLFSTR("The system will not allow posting bills to this check at this time.",IOM)
 . W !,$$CJ^XLFSTR("Please go back and create an RPMS Collection Batch and Item",IOM),!
 . K DIR
 . D EOP^BARUTL(1)
 Q
 ; ********************
ASKPOST ;Ask user if really want to post clms
 W !
 S BARANS=0
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Do you want to post ERA Claims for Chk/EFT "_BARCHECK_" now"
 S DIR("B")="N"
 D ^DIR
 S:Y=1 BARANS=1
 Q
 ; ********************
POSTEM ; LOOP Claims with this chk
 ; Quit if status is not matched
 S (CLMDA,BARPSTED,BARDONE)=0
 ;start new bar*1.8*20 REQ6
 S CLMCNT=0,PSTQFLG=0
 K ^XTMP("BAR-MBAMT",$J,DUZ(2))
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),"F",BARCHECK,IMPDA,CLMDA)) Q:'+CLMDA  D  Q:+BARDONE
 .S ^XTMP("BAR-MBAMT",$J,DUZ(2),+$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),CLMDA)=""  ;E-payment
 S CLMAMT=""
 F  S CLMAMT=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),CLMAMT)) Q:($G(CLMAMT)="")  D
 .S CLMDA=0
 .F  S CLMDA=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),+CLMAMT,CLMDA)) Q:'+CLMDA  D  Q:+BARDONE
 ..;below lines added 1 dot to line up w/new code
 ..S BARCKIEN=$O(^BAREDI("I",DUZ(2),IMPDA,5,"B",BARCHECK,0))  ;bar*1.8*20 REQ6
 ..S BARBL=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U)  ;bar*1.8*20 REQ6
 ..D CLMFLG^BAR50P04(CLMDA,.ERRORS)  ;bar*1.8*20 REQ6
 ..I $$IHS^BARUFUT(DUZ(2)) S BARCHK=BARCHECK D NEGBAL^BAR50EB(IMPDA,"ERA")  ;bar*1.8*20
 ..;;;I $$IHSERA^BARUFUT(DUZ(2)) S BARCHK=BARCHECK D NEGBAL^BAR50EB(IMPDA,"ERA")  ;bar*1.8*20
 ..D:$$IHS^BARUFUT(DUZ(2)) NONPAYCH^BAR50EP1(IMPDA)  ;bar*1.8*20
 ..;;;D:$$IHSERA^BARUFUT(DUZ(2)) NONPAYCH^BAR50EP1(IMPDA)  ;bar*1.8*20
 ..Q:$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,2)'="M"
 ..Q:(($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,2)="M")&(+$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,0))'=0))  ;matched but reason not to post bar*1.8*20 REQ5
 ..S CLMCNT=+$G(CLMCNT)+1  ;bar*1.8*20 REQ6
 ..D BASIC
 .. S PSTQFLG=0 ;INIT VALUE
 ..;check if posting this payment will create a negative balance on batch/item
 ..;------------------------------------------------------------------------
 ..D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",".01;.05;1.01;.02;.04;.11;.12;301;501;601;602","CLM(")  ;BAR*1.8*5 INCLUDE 'POST THIS CLAIM AS TYPE' FIELD
 ..W !?7,"Billed: ",CLM(.05),?25,"Payment: ",CLM(.04)
 ..S IENS=BARITM_","_BARCOL_","
 ..S ITEMAMT=$$GET1^DIQ(90051.1101,IENS,19)  ;item posting balance
 ..S IENS=CLMDA_","_IMPDA_","
 ..S BARCR=$$GET1^DIQ(90056.0205,IENS,".04")
 ..;------------------------------------------------------------------------
 ..I (ITEMAMT-BARCR)<0 D
 ...W !!?7,$$EN^BARVDF("HIN"),"<<PYMT EXCEEDS COLLECTION ITEM BALANCE. MARKED AS 'ITEM BALANCE EXCEEDED'",$$EN^BARVDF("HIF")
 ...S PSTQFLG=1
 ..;------------------------------------------------------------------------
 ..I PSTQFLG=1 D UP^BAR50P0Z(IMPDA,CLMDA,"EBAL") Q  ;leave bill as matched but with NTP reason item balance exceeded
 ..D NEGBAL
 ..Q:'BARANS
 ..D ADJMULT
 ..D PAY
 ..D RMKCD  ;Post remark codes
 ..D NCPDP  ;Post NCPDP codes
 ..D MRKCLMP
 ..W !
 Q
 ; ********************
BASIC ;
 S BAREIENS=CLMDA_","_IMPDA_","
 S BARBLIEN=$$GET1^DIQ(90056.0205,BAREIENS,1.01,"I")  ;A/R BILL
 S BARBLPAT=$$GET1^DIQ(90050.01,BARBLIEN,101,"I")  ;A/R Patient IEN
 S BARBLAC=$$GET1^DIQ(90050.01,BARBLIEN,3,"I")  ;A/R Account
 S BARBAL=$$GET1^DIQ(90050.01,BARBLIEN,15)  ;A/R Bill Balance
 S BARCOL=BARBATCH
 ;S BARITM=BARITEM  ;bar*1.8*20
 S BARITM=BARPITEM  ;bar*1.8*20
 S BARVLOC=$$GET1^DIQ(90050.01,BARBLIEN,108,"I") ;A/R LOCATION
 Q
 ;---------------------------------------------------------
NEGBAL ;
 S BARANS=1
 S BARTOT=0
 S BARPAY=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4)
 S BARTOT=BARTOT+BARPAY
 S (BARADJ,ADJDA)=0
 F  S ADJDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA)) Q:'+ADJDA  D
 .S BARAMT=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,30,ADJDA,0)),U,2)
 .S BARADJ=BARADJ+BARAMT
 S BARTOT=BARTOT+BARADJ
 I (BARBAL-BARTOT)=0 Q
 I (BARBAL-BARTOT)>0 Q
 I BARBAL>0 W !!,"<<Posting this bill will result in a negative balance on the bill>>" ;11/22/2013
 I BARBAL=0 W !!,"<<<Posting this bill will result in a negative balance on the bill >>>" ;11/22/2013
 ;Mark bill not to post
 D UP^BAR50P0Z(IMPDA,CLMDA,"NEGR")
 S BARANS=0  ;bar*1.8*20
 Q
 ; ****************
PAY ;EP  ;PULL CLAIM INFO AND POST PYMT (IF ANY)
 D PAY^BAR50P8A  ;split due to rtn size
 Q
 ; ******************
ADJMULT ;EP  ;POST ADJUSTMENTS
 D ADJMULT^BAR50P8A  ;split due to rtn size
 Q
 ; *******************
RMKCD ;  POST REMARK CODES
 D RMKCD^BAR50P8A  ;split due to rtn size
 Q
 ; ***************
NCPDP ;  POST NCPDP CODES
 K BARTO,BARFROM  ;TPF BAR*1.8*6 SCR119
 K NCPDP,DR,BARDR
 D ENPM^XBDIQ1(90056.0212,"IMPDA,CLMDA,0",".03","NCPDP(","I")
 Q:'$D(NCPDP)
 S BARTRAN=506
 S DR=""
 D DR
 S DR=$E(DR,2,9999)  ;Strip leading ";"
 I +$G(BARCOL)>0 S DR=DR_";14////^S X=$G(BARCOL)"  ;Collct btch if know
 I +$G(BARITM)>0 S DR=DR_";15////^S X=$G(BARITM)"  ;Item if known
 S DR=DR_";108////^S X=BARNCPDP"  ;Remark Code pointer
 S BARDR=DR
 K DR
 S NCPDPDA=0
 F  S NCPDPDA=$O(NCPDP(NCPDPDA)) Q:'+NCPDPDA  D
 .S BARNCPDP=NCPDP(NCPDPDA,.03,"I")
 .Q:BARNCPDP=""
 .D POSTRAN
 .K NCPDPP
 .D ENP^XBDIQ1(90056.0212,"IMPDA,CLMDA,NCPDPDA",".02;.03","NCPDPP(")
 .W !?5,"NCPDP REJECT/PAYMENT CODE: ",NCPDPP(.03),?25,$E($P(NCPDPP(.02)," ",3,99),1,50)
 K NCPDP,NCPDPP
 Q
 ; ****************
DR ;  Gather data needed for transaction
 S DR=DR_";4////^S X=BARBLIEN"  ;A/R Bill
 S DR=DR_";5////^S X=BARBLPAT"  ;A/R Patient
 S DR=DR_";6////^S X=BARBLAC"  ;A/R Account
 S DR=DR_";8////^S X=DUZ(2)"  ;Parent Location
 S DR=DR_";9////^S X=DUZ(2)"  ;Parent ASUFAC
 S DR=DR_";10////^S X=BARSECT"  ;A/R Section
 S DR=DR_";11////^S X=BARVLOC"  ;Visit Location
 S DR=DR_";12////^S X=DT"  ;Date
 S DR=DR_";13////^S X=DUZ"  ;Entry by
 S DR=DR_";101////^S X=BARTRAN"  ;Transaction Type
 S DR=DR_";106////^S X=""e"""  ;Data Source = e
 S DR=DR_";401////^S X=BARICQ"  ;INDENTIFICATION CODE QUALIFIER XX=NPI, FI=TAX ID
 S DR=DR_";402////^S X=BARNPI"  ;IF BARICQ='XX' NPI
 S DR=DR_";403////^S X=BARTIN"  ;IF BARICQ='FI' TAX ID
 S DR=DR_";501////^S X=$G(BARTO)"  ;PYMT CREDIT APPLIED FROM BILL
 S DR=DR_";502////^S X=$G(BARFROM)"  ;PYMT CREDIT APPLIED TO BILL
 I BARTRAN=138 D
 .S BARTRAN=43  ;PYMT CREDIT POSTS AS ADJUSTMENT
 .S BARCAT=20
 .S BARREAS=138
 .S DR=DR_";102////^S X=BARCAT"  ;PYMT CREDIT
 .S DR=DR_";103////^S X=BARREAS"  ;CREDIT TO OTHER BILL
 I BARTRAN=139 D  ;IF THIS IS TRUE THEN WE NEED TO POST THIS AS AN ADJ
 .S BARTRAN=43
 .S BARCAT=20
 .S BARREAS=139
 .S DR=DR_";102////^S X=BARCAT"
 .S DR=DR_";103////^S X=BARREAS"  ;CREDIT FROM OTHER BILL
 Q
 ; *************
MRKCLMP ;EP ;  MARK CLAIM AS POSTED
 K DIC,DA,DR
 S DIE=$$DIC^XBDIQ1(90056.0205)
 S DA(1)=IMPDA
 S DA=CLMDA
 S DR=".02////P"
 D ^DIE
 K DIC,DA,DR
 S BARPSTED=BARPSTED+1
 Q
 ; ****************
POSTRAN ;EP  ; SET TRANSACTION & POST FILES
 S BARTRIEN=$$NEW^BARTR  ;Create Trans
 I BARTRIEN<1 D MSG^BARTR(BARBLIEN) Q
 S BARROLL(BARBLIEN)=""
 ;Populate Trans file
 S DR=BARDR
 S DA=BARTRIEN  ;IEN to A/R TRANSACTION
 S DIE=90050.03
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE,DA,DR
 ;BAR*1.8*1 SRS ADDENDUM FOR BAR*1.8*1
 S BARADD=0  ;USE RETURN ARRAY OF THE ADDITIONAL ID MULTIPLE FROM A/R EDI CHK
 ;FILE AND PLACE INTO TRANSACTION FILE
 N BARIQ,BARREF
 S DIC("P")=$P(^DD(90050.03,1101,0),U,2)
 F  S BARADD=$O(BARADD(90056.2211,BARADD)) Q:'BARADD  D
 .S BARIQ=BARADD(90056.2211,BARADD,.01,"E")
 .S BARREF=BARADD(90056.2211,BARADD,.02,"E")
 .S X=BARIQ
 .S DA(1)=BARTRIEN
 .S DIC="^BARTR("_DUZ(2)_","_DA(1)_",11,"
 .S DIC(0)="L"
 .D ^DIC
 .Q:Y<0
 .K DIE,DIC,DR,DA,DR,DIR
 .S DA(1)=BARTRIEN
 .S DA=+Y
 .S DIE="^BARTR("_DUZ(2)_","_DA(1)_",11,"
 .S DR=".02///^S X=BARREF"
 .D ^DIE
 ; Post from trans file to related files unless General/Pending
 I BARTRAN=43,(",21,22,"[(","_BARCAT_",")) Q
 D TR^BARTDO(BARTRIEN)
 Q
 ; ************
ROLLBACK ; Rollback bills that just posted if Roll as you go set to yes
 ; Otherwise just mark for rollback later
 S BARRAYGO=0  ;Default to not roll back
 S BARPARAM=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),U,13)
 I BARPARAM="A"!(BARPARAM="Y") D
 .K DIR
 .S DIR("A")="Do you want to rollback to 3P the bills that just posted"
 .S DIR("B")="N"
 .S DIR(0)="Y"
 .S DIR("?")="Enter 'YES' to roll these A/R bills back to 3P NOW"
 .D ^DIR
 .I Y=1 S BARRAYGO=1
 K DIR
 I BARRAYGO=1 D  Q  ;Ok...rolling bills.
 .W !!,"OK, now rolling back 3P the bills that just posted for chk/EFT ",BARCHECK
 .D EN^BARROLL
 .K BARROLL,DIR
 .D EOP^BARUTL(1)
 W !!,"OK, marking for rollback the bills that just posted for chk/EFT ",BARCHECK
 W !,"Please use the ROL option when you're ready to roll them back to 3P"
 D EN^BARROLL  ;since BARRAYGO = 0, it will only mark for rollback
 K DIR
 D EOP^BARUTL(1)
 Q
