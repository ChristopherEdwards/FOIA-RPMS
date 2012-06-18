BARCLU01 ; IHS/SD/LSL - Split out of BARCLU0 ;; 07/09/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,19**;OCT 26, 2005
 ;;
 ; IHS/SD/TMM 06/18/2010 1.8*Patch 19 (M819), Add Prepayment functionality.
 ;      See work order 3PMS10001
 ;      ------------------------
 ;      819_1. Display prepayments not assigned to a batch (^BARCLU)
 ;      819_2. Remove prompt: AUTO PRINT RECEIPT (^BARCLU01)
 ;      819_3. Prepayment entry ^BARPPY01 (new routine),^BARCLU1,^BARPUTL
 ;      819_4. Display prepayments matching payment type selected (^BARCLU)
 ;      819_5. Allow user to assign prepayment to batch (^BARCLU,^BARCLU01,^BARPUTL,^BARPST1,^BARBLLK)
 ;      819_6. Print Prepayment Receipt (^BARPPY02) (new routine)
 ; ********************************************************************* ;
 ;
S ;
CACC ; EP
 ; CHeck or Cash entry
 ;S DR=DR_"101;" ;amt  ;IHS/SD/SDR bar*1.8*4 SCR88
 ;---BEGIN ADD(1)--- ;M819*ADD*TMM*20100710 (M819_5)
 ; 29 = Batch Amount (^BARCOL(DUZ(2),BARCLDA,0))
 ; 22 = ASK TREASURY DEPOSIT NUMBER  (BARCLID(22,"I"))
 ;S DR=DR_"101"_$S((+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)=0&+BARCLID(22,"I")):"////0;",1:";")   ;101=credit  ;IHS/SD/SDR bar*1.8*4 SCR88 ;M819*DEL*TMM*20100710 (819_5)
 ;
 ;User should not be prompted for CREDIT when Prepayment item selected. 
 ;Prepayment amt defaults to CREDIT.
 I '$G(BARPPSEL) S DR=DR_"101"_$S((+$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,29)=0&+BARCLID(22,"I")):"////0;",1:";")   ;101=credit  ;IHS/SD/SDR bar*1.8*4 SCR88  ;M819*ADD*TMM*20100710 (819_5)
 I $G(BARPPSEL) D
 . S BARPPCR=$G(BARPPAY(.07))
 . S DR=DR_"101////^S X=$G(BARPPAY(.07));"
 . W !,"CREDIT:  ",$G(BARPPAY(.07))
 ;-------------------------------------------------------------------
 ;look up A/R BILL-PATIENT-DOS
 ;I BARX=52 S:+BARCLID(15,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CA  ;M819*DEL*TMM*20100711
 ;I BARX=53 S:+BARCLID(14,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CC  ;M819*DEL*TMM*20100711
 ;I BARX=81 S:+BARCLID(16,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CK  ;M819*DEL*TMM*20100711
 I '$G(BARPPSEL) D
 . I BARX=52 S:+BARCLID(15,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CA
 . I BARX=53 S:+BARCLID(14,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CC
 . I BARX=81 S:+BARCLID(16,"I") DR=DR_"6///^S X="""" D ^BARBLLK S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CK
 ;
 I $G(BARPPSEL) D
 . ; Prepayment patient
 . S BARPPNM=BARPPAY(.08)                         ; A/R Bill Patient name from Prepayment file
 . ; Prepayment A/R BILL NUMBER
 . ;M819*DEL*TMM*20100727  S BARPPBL=BARPPAY(.09)                         ; A/R BILL IEN from Prepayment file
 . S BARPPBL=BARPPAY(.09,"I")                         ; A/R BILL IEN from Prepayment file ;M819*ADD*TMM*20100727
 . ; Prepayment A/R BILL DOS
 . S BARPPBDS=BARPPAY(.12)
 . ; Prepayment DOS
 . S BARPPSDT=BARPPAY(.13)
 . ;
 . ;M819*DEL*TMM*20100726  S DICB=BARPPNM          ;default lookup - Patient Name
 . S DICB=$$GET1^DIQ(90050.01,BARPPBL_",",101,"I")          ;default lookup - Patient Name
 . S DICB2=BARPPBL        ;default lookup for A/R Bill
 . S DICB3=BARPPBDS         ;default lookup for A/R BILL DOS  ;M819*ADD*TMM*20100715
 . I BARX=52 S:+BARCLID(15,"I") DR=DR_"6///^S X="""" D EN1^BARBLLK(DICB,DICB2,DICB3) S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CA
 . I BARX=53 S:+BARCLID(14,"I") DR=DR_"6///^S X="""" D EN1^BARBLLK(DICB,DICB2,DICB3) S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CC
 . I BARX=81 S:+BARCLID(16,"I") DR=DR_"6///^S X="""" D EN1^BARBLLK(DICB,DICB2,DICB3) S:$D(BARBL)>1 X=BARBL(.01);Q;" ;bill CK
 W !!
 ;-----END ADD(1)--- ;M819*ADD*TMM*20100710 (M819_5)
 K BARBL
 S DIDEL=90050
 D ^DIE
 W !!!!
 S DR=""
 I '$D(BARBL) D
 .I BARX=52 S:+BARCLID(18,"I") DR=DR_"5;" ;pat CA       ;5=Patient
 .I BARX=53 S:+BARCLID(17,"I") DR=DR_"5;" ;pat CC
 .I BARX=81 S:+BARCLID(19,"I") DR=DR_"5;" ;pat CK
 .S DR=DR_"7//^S X=$G(BARITAC);" ;account
 .I BARSPAR(2,"I") S DR=DR_"8//^S X=$G(BARITLC);"       ;8=Visit Location (A/R Satelite)
 .E  S DR=DR_"8///^S X=BARSPAR(.01);" ;location
 I BARCLIT(201)]"" S DR=DR_"201///^S X=BARCLIT(201);Q;" ;201=payor
 S DR=DR_"201;" ;payor
 S:+BARCLID(13,"I") DR=DR_"10;" ;i/o pat
 ;S DR=DR_"16//^S X=BARCLID(3);301;" ;receipt,comment    ;16=AUTO PRINT RECEIPT ;M819*DEL*TMM*20100710 (M819_2)
 ;IHS/SD/TPF BAR*1.8*3 UFMS
 I +BARCLID(22,"I") D
 .Q:BARX'=81&(BARX'=53)&(BARX'=52)&(BARX'=99)
 .;S DR=DR_"20R;"  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 .S DR=DR_"20////"_$P($G(^BARCOL(DUZ(2),BARCLDA,0)),U,28)_";"  ;20=TDN/IPAC  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1
 ;END BAR*1.8*3 UFMS
 S DIDEL=90050
 D ^DIE
 W !!!!
 K DIDEL
 K DICB,DICB2,DICB3,DIC("B")             ;M819*ADD*TMM*20100713
 ;insert sub node
 D INSSUB^BARCLU0 ;insert sub node
CACCE ;
 Q
