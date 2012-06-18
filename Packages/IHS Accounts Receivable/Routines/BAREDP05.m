BAREDP05 ; IHS/SD/LSL - REVIEW CLAIM STATUS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,4,5,6,20**;OCT 26,2005
 ;
 ; IHS/SD/LSL - V1.7 Patch 4 - HIPAA
 ;
 ; IHS/SD/LSL - 02/26/04 - V1.7 Patch 5
 ;      Changed check to chk/eft
 ;
 ;
 D CLEAR^VALM1
 ;
EN ; EP
 N ERRORS  ;BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008
 ; for the file type
 K ^TMP($J,"LVL1")
 D EN^VALM("BAR ERA Claim Review")
 Q
 ;
HDR ; EP
 ;  header code
 S FHDR="File name : "_$P($G(^BAREDI("I",DUZ(2),IMPDA,0)),"^")
 S THDR="Transport : "_$P($G(^BAREDI("1T",TRDA,0)),"^")
 S VALMHDR(1)=$$PAD(THDR,45)_FHDR
 I TRNAME["HIPAA" D
 .S THDR=TRNAME
 .S FHDR="File: "_$P($G(^BAREDI("I",DUZ(2),IMPDA,0)),U)
 .;start old bar*1.8*20 REQ5
 .;S CHDR="Chk/EFT #: "_$P($G(^BARECHK(BARCKIEN,0)),U)
 .;S VALMHDR(1)=$$PAD(THDR,20)_"  "_$$PAD(FHDR,24)_"  "_CHDR
 .;end old start new REQ5
 .S CHDR="Chk/EFT#: "_$S($G(BARCHK)'="":BARCHK,1:$P($G(^BARECHK(BARCKIEN,0)),U))
 .S VALMHDR(1)=$$PAD(THDR,18)_"  "_$$PAD(FHDR,28)_"  "_CHDR
 .;end new REQ5
 Q
 ;
INIT ; EP
 ; init variables and list array
 D GATHER(IMPDA)
 S VALMCNT=LN
 Q
 ;
HELP ; EP
 ; help code
 S X="?"
 D DISP^XQORM1
 D MSG^BARDUTL("",2,0,0)
 Q
 ;
EXIT ; EP
 ; exit code
 D CLEAR^VALM1
 K ^TMP($J,"LVL1")
 Q
 ;
EXPND ; EP
 ; expand code
 Q
 ;
RESET ; EP
 ; rebuilds array after action
 D TERM^VALM0
 S VALMBCK="R"
 D INIT,HDR
 Q
 ;
GATHER(IMPDA) ;
 ; SUBRTN to set data into array
 K ^TMP($J,"LVL1"),^TMP($J,"FD")
 K ^TMP($J,"E"),^TMP($J,"A")
 K ECLM
 S RECNM=0
 S (LN,LINE,COUNT)=1
 ;Get file details
 S ELIST=".01;.02;.06;.08"
 S ALIST="1.01;1.03;1.05;1.08"
 S WHOLELST=ELIST_";"_ALIST
 ; Build ^TMP($J,"E" and ^TMP($J,"A" globals for electronic and A/R 
 ; claim details.
 S CLMDA=0
 I TRNAME["HIPAA" F  S CLMDA=$O(^BAREDI("I",DUZ(2),"F",BARCHK,IMPDA,CLMDA)) Q:'+CLMDA  D CLAIM
 I TRNAME'["HIPAA" F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:CLMDA'>0  D CLAIM
 ; Build records for output via Listman.
 S RN=""
 F  S RN=$O(^TMP($J,"E",RN)) Q:RN=""  D
 .K EFLD
 .S (ERECORD,EFN)=""
 .F  S EFN=$O(^TMP($J,"E",RN,EFN)) Q:EFN=""  D
 ..S EFLD(EFN)=$G(^TMP($J,"E",RN,EFN))
 .S ERECORD=$$PAD(EFLD(.01),18)_$$PAD(EFLD(.08),13)_$$PAD(EFLD(.06),30)
 .S ERECORD=ERECORD_$$PAD(EFLD(.02),19)
 .K AFLD
 .S (ARECORD,AFN)=""
 .F  S AFN=$O(^TMP($J,"A",RN,AFN)) Q:AFN=""  D
 ..S AFLD(AFN)=$G(^TMP($J,"A",RN,AFN))
 .S ARECORD=$$PAD(AFLD(1.01),18)_$$PAD(AFLD(1.05),13)
 .S ARECORD=ARECORD_$$PAD(AFLD(1.03),18)_$$PAD(AFLD(1.08),15)
 .;Set up eclaim details
 .S ERECORD=$$PAD(COUNT,4)_ERECORD
 .D SET^VALM10(LN,ERECORD,COUNT)
 .S LN=LN+1
 .;BEGIN BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008
 .;SET UP REASON DETAILS
 .I $D(^TMP($J,"E",RN,401)) D
 ..S RHEADER=$$CJ^XLFSTR("**********REASONS NOT TO POST********",IOM)
 ..D SET^VALM10(LN,RHEADER,COUNT)
 ..S LN=LN+1
 ..S REASDA=""
 ..F  S REASDA=$O(^TMP($J,"E",RN,401,REASDA)) Q:'REASDA  D
 ...S RRECORD=$$CJ^XLFSTR($P(^TMP($J,"E",RN,401,REASDA),U,3),IOM)
 ...D SET^VALM10(LN,RRECORD,COUNT)
 ...S LN=LN+1
 .;END BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008
 .;Set up AR details
 .;start old code bar*1.8*20 REQ5
 .;S ARECORD=$$PAD("",4)_ARECORD
 .;D SET^VALM10(LN,ARECORD,COUNT)
 .;S LN=LN+1
 .;end old code start new code REQ5
 .I $TR(ARECORD," ")'="" D
 ..S ARECORD=$$PAD("",4)_ARECORD
 ..D SET^VALM10(LN,ARECORD,COUNT)
 ..S LN=LN+1
 .;end new code REQ5
 .;Line spacing
 .S BLANKLNE="    "
 .D SET^VALM10(LN,BLANKLNE,COUNT)
 .S LN=LN+1
 .S COUNT=COUNT+1
 .S LINE=LINE+1
 ;begin code change im15027
 I '$D(^TMP($J,"LVL1")) D
 .S VALMQUIT=1
 .W !!,"There are no Claims to Review."
 .D PAZ^BARRUTL
 ;end code change
 Q
 ;
CLAIM ;
 K RPT
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",ELIST,"^TMP($J,""E"",LINE,")
 S STATUS=$G(^TMP($J,"E",LINE,.02))
 I (STATUS="MATCHED")!(STATUS="NOT TO POST") S RPT=1
 S RPT=1  ;BAR*1.8*5 SRS-80 TESTING ONLY TPF
 I '$D(RPT) K ^TMP($J,"E",LINE) Q
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",ALIST,"^TMP($J,""A"",LINE,")
 S IENS=CLMDA_","_IMPDA_","  ;bar*1.8*20 REQ5
 S ^TMP($J,"E",LINE,"CLMDA")=CLMDA
 ;put a "*" in front of the claim number if there is a comment on the claim
 I $$GET1^DIQ(90056.0205,IENS,71)'="",($G(^TMP($J,"E",LINE,.01))'="") S ^TMP($J,"E",LINE,.01)=$S(^TMP($J,"E",LINE,.01)'["*":"*"_^TMP($J,"E",LINE,.01),1:^TMP($J,"E",LINE,.01))  ;bar*1.8*20 REQ5
 ;BEGIN BAR*1.8*5 SRS-80 IHS/SD/TPF 4/15/2008
 ;GET REASON NOT TO POST MULTIPLE AND PLACE IN ^TMP GLOBAL
 N REASDA,REASIENS,REASCODE
 S REASDA=0
 F  S REASDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,REASDA)) Q:'REASDA  D
 .S REASIENS=REASDA_","_CLMDA_","_IMPDA_","
 .S REASCODE=$$GET1^DIQ(90056.0205401,REASIENS,.01,"I")
 .S ^TMP($J,"E",LINE,401,REASDA)=REASCODE_U_$$GET1^DIQ(90056.0205401,REASIENS,.01,"E")_U_$$GET1^DIQ(90056.21,REASCODE,.02,"E")
 ;END BAR*1.8*5 SRS-80
 S LINE=LINE+1
 Q
 ;
PAD(D,L) ;
 ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
GETITEM ; -- select item from list
 S VALMLST=""
 S VALMLST=$O(^TMP($J,"LVL1","IDX",VALMLST),-1)
 D EN^VALM2(XQORNOD(0),"O")
 I '$D(VALMY) Q
 N XCLMDA
 S XCLMDA=0
 F  S XCLMDA=$O(VALMY(XCLMDA)) Q:XCLMDA=""  D
 .S XCLM=$G(^TMP($J,"E",XCLMDA,"CLMDA"))
 .D GETRECRD(XCLM)
 D GATHER(IMPDA)
 Q
 ;
BROWSE ; Called from Listman screen BAR ERA Claim Review
 K CLAIM
 D GETITEM
 Q
 ;
GETRECRD(XCLM) ;
 ;start new code bar*1.8*20 REQ5
 ;They want to be able to change the statuses; user can change
 ;  Matched -> Exception
 ;  Unmatched -> Exception
 ;  Exception -> Matched
 ;  Unmatched -> Matched
 ;The last two still have to go through the matching criteria and may have Not To Post reasons
 ;All status changes will now require a comment to be entered.
 D ENP^XBDIQ1(90056.0205,"IMPDA,XCLM",ELIST,"CLAIM($J,")
 I $G(CLAIM($J,.02))="POSTED" W !!,"Cannot change the status of a POSTED claim" H 2 Q
 I $G(CLAIM($J,.02))="BUILT" W !!,"Please run the BLMT option or Run Auto-Review first to do auto-matching" H 2 Q
 W !,"Do you wish to change the status of claim ",$G(CLAIM($J,.01))
 W " (# "_XCLMDA_" )"
 I "^MATCHED^EXCEPTION^"[("^"_$G(CLAIM($J,.02))_"^") D
 .I $G(CLAIM($J,.02))="MATCHED" S NEWSTAT="E"
 .I $G(CLAIM($J,.02))="EXCEPTION" S NEWSTAT="M"
 .W !,"from status '"_$G(CLAIM($J,.02))_"' to '"_$S(NEWSTAT="M":"MATCHED",NEWSTAT="E":"EXCEPTION",NEWSTAT="U":"CLAIM UNMATCHED",1:"EXCEPTION")_"' <N>? :"
 .K DIR
 .S DIR(0)="Y"
 .D ^DIR
 .K DIR
 I $G(CLAIM($J,.02))="CLAIM UNMATCHED" D
 .K DIR
 .S DIR(0)="SA^M:MATCHED;E:EXCEPTION"
 .S DIR("A")="from status '"_$G(CLAIM($J,.02))_"' to 'MATCHED' or 'EXCEPTION' <M/E>? "
 .D ^DIR
 .K DIR
 .Q:Y=""
 .Q:$D(DIROUT)!$D(DIRUT)!$D(DTOUT)!$D(DUOUT)
 .S NEWSTAT=Y
 .K DIR
 .S DIR(0)="Y"
 .S DIR("A")="Are you sure?"
 .S DIR("B")="N"
 .D ^DIR
 .K DIR
 Q:Y'>0
 S DIE=$$DIC^XBDIQ1(90056.0205)
 S DA(1)=IMPDA
 S DA=XCLM
 S DR=".02///^S X=NEWSTAT"
 D ^DIE
 I NEWSTAT="M" D
 .D ^BARBLLK
 .;start new bar*1.8*20
 .I BARBLDA=0 D  Q
 ..S NEWSTAT=$G(CLAIM($J,.02))
 ..S DIE=$$DIC^XBDIQ1(90056.0205)
 ..S DA(1)=IMPDA
 ..S DA=XCLM
 ..S DR=".02///^S X=NEWSTAT"
 ..D ^DIE
 ..;end new
 .S DIE=$$DIC^XBDIQ1(90056.0205)
 .S DA(1)=IMPDA
 .S DA=XCLM
 .S DR="1.01////^S X=BARBLDA"
 .D ^DIE
 .D REPROCES(IMPDA)  ;RE-PROCESS ERA FILE
 Q:(NEWSTAT=$G(CLAIM($J,.02)))  ;no match was entered/found  bar*1.8*20 
 S DIE=$$DIC^XBDIQ1(90056.0205)
 S DA(1)=IMPDA
 S DA=XCLM
 S DR="W !;71//"
 D ^DIE
 ;end new code bar*1.8*20 REQ5
 ;
 ;start old code bar*1.8*20 REQ5
 ;BEGIN NEW CODE BAR*1.8*6 SCR120 IHS/SD/TPF ALLOW EDIT OF MATCHED STATUS TO "NOT TO POST" ONLY
 ;"IMPDA,XCLM"
 ;N BARSTAT,REASON
 ;I $P($G(^BAREDI("I",DUZ(2),IMPDA,30,XCLM,0)),U,2)'="M" D  Q
 ;.W !,"CLAIM MUST HAVE A STATUS OF 'MATCHED'!!"
 ;.;W !,"BEFORE THE USER CAN SET IT TO 'NOT TO POST'!!"  ;bar*1.8*20 REQ5
 ;.W !,"BEFORE THE USER CAN SET IT TO 'EXCEPTION'!!"  ;bar*1.8*20 REQ5
 ;.K DIR
 ;.S DIR(0)="E"
 ;.D ^DIR
 ;K DIR
 ;S DIR(0)="YO"
 ;W !,"************************** WARNING *******************************"
 ;W !,"If you set this claim to 'NOT TO POST', you CAN NOT set it back!!!"
 ;S DIR("A")="Do You Really Want to change status of "_$P($G(^BAREDI("I",DUZ(2),IMPDA,30,XCLM,0)),U)_" to 'NOT TO POST'"
 ;D ^DIR
 ;I $D(DIROUT)!$D(DTOUT)!$D(DUOUT)!'Y D  Q
 ;.W !,"NO CHANGE IN STATUS MADE!!"
 ;.K DIR
 ;.S DIR(0)="E"
 ;.D ^DIR
 ;K DIR,DIE,DA,DIC,DR
 ;S BARSTAT="N"
 ;S DIE=$$DIC^XBDIQ1(90056.0205)
 ;S DA(1)=IMPDA
 ;S DA=XCLM
 ;S DR=".02///^S X=BARSTAT"
 ;D ^DIE
 ;K DIR,DIE,DA,DIC,DR
 ;S REASON="UOR"   ;SET SPECIAL ERROR MESSAGE
 ;S DIC("P")=$P(^DD(90056.0205,401,0),U,2)
 ;S DA(2)=IMPDA
 ;S DA(1)=XCLM
 ;S DIC(0)="L"
 ;S DIC="^BAREDI(""I"",DUZ(2),"_DA(2)_",30,"_DA(1)_",4,"
 ;S X=REASON
 ;D ^DIC
 ;END NEW CODE BAR*1.8*6 SCR120 IHS/SD/TPF ALLOW EDIT OF STATUS TO "NOT TO POST" ONLY
 ;end old code bar*1.8*20 REQ5
 ;
 ;BAR*1.8*5 SRS-80 IHS/SD/TPF 4/25/2008 LET'S CHECK FOR MATCHING AGAIN
 ;AND SEE IF THEY FIXED ANYTHING
 ;BAR*1.8*6 SCR120 MOVE THIS TO REPROCES AND ADD LIST MANAGER PROMPT FOR AUTO-REVIEW
 ;D REPROCES(IMPDA)  ;RE-PROCESS ERA FILE 
 ;I $O(^BAREDI("I",DUZ(2),IMPDA,30,XCLM,4,0)) D  Q
 ;.W !!,"There are still issues with this ERA claim!!"
 ;.W !,"Please resolve them before attempting to change the status to MATCHED."
 ;.W !!
 ;.K DIR
 ;.S DIR(0)="E"
 ;.D ^DIR
 ;E  Q
 ;END BAR*1.8*5 SRS-80 IHS/SD/TPF
 ;
 ; Get electronic claim details
 ;BEGIN COMMENT OUT BAR*1.8*6 SCR120 IHS/SD/TPF
 ;D ENP^XBDIQ1(90056.0205,"IMPDA,XCLM",ELIST,"CLAIM($J,")
 ;S ANS="N"
 ;W !,"Do you wish to change the status of claim ",$G(CLAIM($J,.01))
 ;W " (# "_XCLMDA_" )"
 ;BAR*1.8*4 SCR56,SCR58 PER CASUAL CONVERSTATION
 ;I $G(CLAIM($J,.02))="NOT TO POST" S NEWSTAT="M"
 ;E  S NEWSTAT=""  ;IHS/SD/SDR bar*1.8*4 5/1/08
 ;E  S NEWSTAT="NOT TO POST"  ;IHS/SD/SDR bar*1.8*4 5/1/08
 ;W !,"from status '"_$G(CLAIM($J,.02))_"' to 'NOT TO POST' <N>? :"
 ;W !,"from status '"_$G(CLAIM($J,.02))_"' to '"_$S(NEWSTAT="M":"MATCHED",1:"NOT TO POST")_"' <N>? :"
 ;END BAR*1.8*4
 ;K DIR
 ;S DIR(0)="Y"
 ;D ^DIR
 ;K DIR
 ;Q:Y'>0
 ;BAR*1.8*4
 ;S DIE=$$DIC^XBDIQ1(90056.0205)
 ;S DA(1)=IMPDA
 ;S DA=XCLM
 ;S DR=".02///^S X=NEWSTAT"
 ;D ^DIE
 ;END COMMENT OUT BAR*1.8*6 SCR120 IHS/SD/TPF
 ;BAR*1.8*4
 ;; Update status from original to 'NOT TO POST'
 ;S NEWSTAT="N"
 ;S DIE=$$DIC^XBDIQ1(90056.0205)
 ;S DA(1)=IMPDA
 ;S DA=XCLM
 ;S DR=".02///^S X=NEWSTAT"
 ;D ^DIE
 ;END BAR*1.8*4
 Q
 ;
REPROCES(IMPDA) ;EP - RE-PROCESS ERA FILE
AUTOREV ;EP - AUTO REVIEW ;BAR*1.8*6 SCR120 ADD LIST MANAGER PROMPT FOR AUTO-REVIEW
 N CLMDA
 D CLEAR^VALM1
 S CLMDA=0
 ;start old code bar*1.8*20 REQ6
 ;F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:'CLMDA  D
 ;.K ERRORS
 ;.D CLMFLG^BAREDP04(CLMDA,.ERRORS)
 ;D:$$IHS^BARUFUT(DUZ(2)) NEGBAL^BAREDEB(IMPDA,"ERA")  ;CHECK FOR NEGATIVE BALANCE IN RPMS BILLS
 ;end old code start new code REQ6
 K ^XTMP("BAR-LIST",$J,DUZ(2))
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:'CLMDA  S ^XTMP("BAR-LIST",$J,DUZ(2),$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U),CLMDA)=""
 S CLMCNT=0,BARBL=""
 F  S BARBL=$O(^XTMP("BAR-LIST",$J,DUZ(2),BARBL)) Q:BARBL=""  D
 .S CLMDA=0
 .F  S CLMDA=$O(^XTMP("BAR-LIST",$J,DUZ(2),BARBL,CLMDA)) Q:'CLMDA  K ERRS D CLMFLG^BAREDP04(CLMDA,.ERRORS)
 S BARFLG=$$EN^BAREDP0Z(IMPDA)  ;PLB/Pymt Rev/Neg pymt amt chks  ;bar*1.8*20 REQ4
 D:$$IHS^BARUFUT(DUZ(2)) NEGBAL^BAREDEB(IMPDA,"ERA")  ;CHECK FOR NEGATIVE BALANCE IN RPMS BILLS
 ;end new code REQ6 
 ;BAR*1.8*6 IHS/SD/TPF MOVE REVERSAL CHECK TO BAREDEP AS A FULL LOOP CHECK. REMOVE FROM CLMFLG^BAREDP04 PROCESSING
 ;D:$$IHS^BARUFUT(DUZ(2)) REVLOOP^BAREDEP(IMPDA)  ;CHECK FOR PAYMENTS NOT MATCHED TO A REVERSAL TO SEE IF THEY ARE BEING POSTED TO A 'NONPAYMENT' BATCH  ;bar*1.8*20 REQ4
 ;END REVERSAL MOD
 ;D:$$IHS^BARUFUT(DUZ(2)) NONPAYCH^BAREDEP(IMPDA)  ;CHECK FOR PAYMENTS NOT MATCHED TO A REVERSAL TO SEE IF THEY ARE BEING POSTED TO A 'NONPAYMENT' BATCH
 D:$$IHS^BARUFUT(DUZ(2)) NONPAYCH^BAREDEP1(IMPDA)  ;CHECK FOR PAYMENTS NOT MATCHED TO A REVERSAL TO SEE IF THEY ARE BEING POSTED TO A 'NONPAYMENT' BATCH ;BAR*1.8*6 SAC RTN TOO BIG
 D GATHER(IMPDA)
 Q
 ;start new code bar*1.8*20 REQ5
VIEW ;EP
 S VALMLST=""
 S VALMLST=$O(^TMP($J,"LVL1","IDX",VALMLST),-1)
 D EN^VALM2(XQORNOD(0),"O")
 I '$D(VALMY) Q
 D CLEAR^VALM1
 N XCLMDA
 S XCLMDA=0
 F  S XCLMDA=$O(VALMY(XCLMDA)) Q:XCLMDA=""  D
 .S XCLM=$G(^TMP($J,"E",XCLMDA,"CLMDA"))
 .S IENS=XCLM_","_IMPDA_","
 .W !,$$GET1^DIQ(90056.0205,IENS,71)
 .D PAZ^BARRUTL
 Q
 ;end new code REQ5
