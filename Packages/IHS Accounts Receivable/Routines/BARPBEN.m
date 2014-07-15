BARPBEN ; IHS/SD/LSL - AUTO POSTING OF BENEFICIARY ACCOUNTS ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**21,23**;OCT 26, 2005
 ;;
 ; IHS/SD/LSL - 04/29/03 - V1.8
 ;     Tweaked code for national release.  Original routine AZLKAP01.
 ;     Thanks to California area (7/10/2000)
 ;
 ;APR 2012 P.OTTIS TICKET # 66991 CODE FIX: <UNDEF> LOOP+21
 ;                        # 64722
 ;                        # 57240
 ; ********************************************************************
 Q
 ;
EN ; EP
 ; SELECT ACCOUNT
 Q:$G(XQUIT)=1  ;IHS/SD/TPF BAR*1.8*21 HEAT43451
 D:'$D(BARUSR) INIT^BARUTL                     ; Setup basic AR var
 S BAR("PRIVACY")=1                            ; Privacy Act applies
 S BAR("LOC")="BILLING"                        ;Always Billing location
 I $D(^XTMP("BAR-BEN")) D  Q
 . W !!!,"***AUTO POSTING JOB IN PROGRESS ***"
 . D EOP^BARUTL(0)
 D ASK                                         ; Ask user prompts
 Q:'+BARACDA!('$D(BARSBY))
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 S BARQ("RC")="LOOP^BARPBEN"
 S BARQ("RP")="PRINT^BARPBEN2"
 S BARQ("RX")="POUT^BARRUTL"
 S BARQ("NS")="BAR"
 D ^BARDBQUE
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
ASK ;
 ; Ask AR Account to Auto Post
 W !!
 S BARACDA=0
 K DIC,DA
 S DIC="^BARAC(DUZ(2),"
 S DIC("A")="Select Beneficiary Account to be Auto-Posted: "
 S DIC("S")="N ZZ S ZZ=$$GET1^DIQ(90050.02,+Y,.01) I ZZ[""BENEFIC"",ZZ[""PATIENT"",ZZ'[""NON"""
 S DIC(0)="AEQZ"
 D ^DIC
 Q:Y'>0
 S BARACDA=+Y
 S BARACNM=Y(0,0)
 ;
 ; Is this the Account they really want to Auto post
 W !!,"Account selected is ",BARACNM,!
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Is this the proper account"
 D ^DIR
 K DIR
 Q:Y'>0
 ;
 ; Are they sure they want to Auto Post said account
 W !!,"Proceeding with Auto-Posting of: ",BARACNM,!!
 K DIR
 S DIR(0)="SOB^P:Patient;B:Bill"
 S DIR("A")="Select Report Sorting By:(Patient/Bill)  "
 S DIR("B")="B"
 D ^DIR
 K DIR,DIC
 I "BP"'[Y Q
 S BARSBY=Y
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
LOOP ; EP
 ; Loop ABAL index
 S BARCNT=0,BARTOT=0
 D BASIC
 S BARDR=DR
 ;
 S ^XTMP("BAR-BEN",$J,0)=DT_U_DT_U_"AUTO POSTING OF BENEFICIARY BILLS LOG"
 S BARBLDA=0
 F  S BARBLDA=$O(^BARBL(DUZ(2),"ABAL",BARACDA,BARBLDA)) Q:'+BARBLDA  D
 . D GET
 . S HAVETRIEN=0 ;P.OTTIS TICKET # 66991
 . D POST
 . I HAVETRIEN=0 QUIT  ;P.OTTIS TICKET # 66991
 . Q:BARTRIEN<1
 . D LOG
 Q
 ; ********************************************************************
 ;
BASIC ;EP ASSEMBLE BASIC DATA FOR TRANSACTION   
 ;
 S DR="2////^ S X=BARBIL(15)"                  ; Credit
 S DR=DR_";4////^S X=BARBLDA"                  ; A/R Bill
 S DR=DR_";5////^S X=BARBIL(101,""I"")"        ; A/R Patient
 S DR=DR_";6////^S X=BARBIL(3,""I"")"          ; A/R Account
 S DR=DR_";8////^S X=DUZ(2)"                   ; Parent Location
 S DR=DR_";9////^S X=DUZ(2)"                   ; Parent ASUFAC
 S DR=DR_";10////^S X=BARBIL(10,""I"")"        ; A/R Section
 S DR=DR_";11////^S X=BARBIL(108,""I"")"       ; Visit Location
 S DR=DR_";12////^S X=DT"                      ; Date
 S DR=DR_";13////^S X=DUZ"                     ; Entry by
 S DR=DR_";101////^S X=43"                     ; Transaction Type
 S DR=DR_";102////3"                           ; Adjust Cat Write Off
 S DR=DR_";103////136"                         ; Adjust type Indian Ben
 Q
 ; ********************************************************************
 ;
GET ;EP pull data for posting
 K BARBL
 D ENP^XBDIQ1(90050.01,BARBLDA,".001;.01;3;10;13;15;18;101;102;108","BARBIL(","EI")
 I $E(IOST)="C" W "."
 Q
 ; ********************************************************************
 ;
POST ;EP
 ;IHS/SD/TPF BAR*1.8*21 8/3/2011 HEAT20490
 I $$NOTOPEN^BARUFUT(.DUZ,$G(UFMSESID)) Q  ;IS SESSION STILL OPEN
 ; SET TRANSACTION & POST FILES
 S BARTRIEN=$$NEW^BARTR               ; Create Transaction
 ; Populate Transaction file
 I BARTRIEN<1 D MSG^BARTR(BARBLDA) Q
 S HAVETRIEN=1                        ;P.OTTIS TICKET # 66991
 S DA=BARTRIEN                        ; IEN to A/R TRANSACTION
 S DIE=90050.03
 S DIDEL=90050
 S DR=BARDR
 D ^DIE
 K DIDEL,DIE,DA,DR
 ; Post from transaction file to related files
 D TR^BARTDO(BARTRIEN)
 Q
 ; ********************************************************************
 ;
LOG ;EP
 ; log entry into ^XTMP
 I BARSBY="P" S ^XTMP("BAR-BEN",$J,BARBIL(101),BARBIL(.01))=BARBIL(15)_U_BARBIL(102)
 I BARSBY="B" S ^XTMP("BAR-BEN",$J,BARBIL(.01))=BARBIL(15)_U_BARBIL(102)_U_BARBIL(101)
 S BARTOT=BARTOT+BARBIL(15)
 S BARCNT=BARCNT+1
 Q
