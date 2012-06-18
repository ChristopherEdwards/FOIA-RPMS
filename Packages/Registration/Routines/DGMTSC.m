DGMTSC ;ALB/RMO,CAW,RTK,PDJ - Means Test Screen Driver ; 7/30/03 2:51pm
 ;;5.3;Registration;**182,327,372,433,463,540**;Aug 13, 1993
 ;
 ;A series of screens used to collect the means test data
 ; Input  -- DFN      Patient IEN
 ;           DGMTACT  Means Test Action  (ie, ADD to Add a Means Test)
 ;           DGMTDT   Date of Test
 ;           DGMTI    Annual Means Test IEN
 ;           DTMTYPT  Type of Test 1=MT 2=COPAY
 ;           DGMTROU  Option Routine Return
 ; Output -- None
 ;
 ;DG*5.3*540 - set 408.21 (Idiv. Ann. Income) ien to 0 to prevent from
 ;             linking to old test incomes for IVM converted cases.
 ;
EN ;Entry point for means test screen driver
 D PRIOR^DGMTEVT:DGMTACT'="VEW",HOME^%ZIS,SETUP^DGMTSCU I DGERR D MG G Q1
EN1 ;Entry point to edit means test if incomplete
 S DGMTSCI=+$O(DGMTSC(0))
 I DGMTI,$$GET1^DIQ(408.31,DGMTI,.23)["IVM" S DGVINI=0     ;DG*5.3*540
 G @($$ROU^DGMTSCU(DGMTSCI))
 ;
Q I DGMTACT'="VEW" D EN^DGMTSCC I DGERR G EN1:$$EDT
 ; Added for LTC Co-pay Phase II - DG*5.3*433
 I DGMTACT'="VEW",DGMTYPT=4 D  G K
 .Q:$P($G(^DGMT(408.31,DGMTI,0)),U,3)=""  ; LTC 4 test is incomplete
 .D AFTER^DGMTEVT S DGMTINF=0
 .D EN^DGMTAUD,EN^IVMPMTE
 .D DATETIME^DGMTU4(DGMTI)
 .; If LTC copay exemption test is edited, update LTC copay test
 .I DGMTACT="EDT" D UPLTC3^EASECMT(DGMTI)
Q1 I DGMTACT'="VEW" D AFTER^DGMTEVT S DGMTINF=0 D EN^DGMTEVT
 ;
 ;If the veteran has agreed to pay copay after previously refusing,
 ;automatically update their Primary Eligibility (327-Ineligible Project)
 I $D(DGMTP),$D(DGMTA) D
 .I $D(^DPT(DFN,.3)),$P(DGMTP,U,11)=0,$P(DGMTA,U,11)=1 D
 ..N DATA
 ..I $P(^DPT(DFN,.3),U)="Y" S DATA(.361)=$O(^DIC(8,"B","SC LESS THAN 50%",""))
 ..E  S DATA(.361)=$O(^DIC(8,"B","NSC",""))
 ..I $$UPD^DGENDBS(2,DFN,.DATA)
 .;If the veteran has refused to pay copay, update ENROLLMENT
 .;PRIORITY to null.
 .I $P(DGMTA,U,11)=0 D
 ..S CUR=$$FINDCUR^DGENA(DFN)
 ..N DATA S DATA(.07)="@" I $$UPD^DGENDBS(27.11,CUR,.DATA)
 ;
 ; Added for LTC Copay Phase II (DG*5.2*433)
 ; If means test or copay test is edited and has a LTC copay exemption
 ; test associated with it, update the LTC copay exemption test.
 I DGMTACT="EDT",$O(^DGMT(408.31,"AT",DGMTI,0)) D LTC4^EASECMT(DGMTI)
 ;
K K %,DGBL,DGDC,DGDEP,DGDR,DGFCOL,DGFL,DGMT0,DGMTA,DGMTINF,DGMTOUT,DGMTP,DGMTPAR,DGMTSC,DGMTSCI,DGREL,DGRNG,DGRPPR,DGSCOL,DGSEL,DGSELTY,DGVI,DGVINI,DGVIRI,DGVO,DGVPRI,DGX,DGY,DTOUT,DUOUT,Y,Z
 ;
 ; Validate record with consistency checks, when adding, editing, or
 ; completing either a means or copay test.
 K IVMERR,IVMAR,IVMAR2
 I DGMTACT'="VEW" D INCON^DGMTUTL1(DFN,DGMTDT,DGMTI,DGMTYPT,.IVMERR),PROB^IVMCMFB(DGMTDT,.IVMERR,1)
 ;
 ;Update the TEST-DETERMINED STATUS field (#2.03) in the ANNUAL MEANS
 ;TEST file (408.31) when adding a means or copay test, completing a 
 ;means test, or editing a means or copay test.
 I "ADDCOMEDT"[DGMTACT D SAVESTAT^DGMTU4(DGMTI,DGERR)
 K DGERR,IVMERR,ARRAY,ZIC,ZIR,ZMT,ZDP,IVMAR,IVMAR2
 ;
 G @(DGMTROU)
 ;
MG ;Print set-up error messages
 I $D(DGVPRI),DGVPRI'>0 W !!?3,"Patient Relation cannot be setup for patient."
 I $D(DGVINI),DGVINI'>0 W !!?3,"Individual Annual Income cannot be setup for patient."
 I $D(DGMTPAR),DGMTPAR']"",DGMTYPT=1 W !!?3,"Means Test Thresholds are not defined."
 W !?3,*7,"Please contact your site manager."
 Q
 ;
EDT() ;Edit means/copay test if incomplete
 N DIR,Y
 S DIR("A")="Do you wish to edit the "_$S(DGMTYPT=1:"means",1:"copay exemption")_" test"
 S DIR("B")="YES",DIR(0)="Y" D ^DIR
 Q +$G(Y)
