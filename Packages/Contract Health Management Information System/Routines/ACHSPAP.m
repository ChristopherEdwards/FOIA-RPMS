ACHSPAP ; IHS/ITSC/PMF - LINK TO PATIENT CARE COMPONENT (1/2) ; JUL 10, 2008
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,14**;JUN 11,2001
 ;ACHS*3.1*3  set a var needed by the PCC interface
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;
 ;  This routine is not called unless the LINK is established to PCC.
 ;
 ; Required variables, that are unaltered:
 ;      ACHSDOCR - Document record.
 ;      ACHSDIEN - Document Internal Entry Number.
 ;
 S ACHS=$G(APCDALVR("APCDTYPE"))
 ;
 N ACHSDUZ0,ACHSLBL,ACHSTRAN,ACHSWOK,APCDALVR,AUPNTALK,APCDANE,APCDAUTO
 ;
 I $L(ACHS) S APCDALVR("APCDTYPE")=ACHS
 S ACHSWOK=(($G(ACHSISAO)'=0)&('$D(ZTQUEUED))) ; OK to write.
 ;
 I $P(ACHSDOCR,U,12)'=3 W:ACHSWOK !,"NOT A PAID DOCUMENT." Q
 I $P(ACHSDOCR,U,3) W:ACHSWOK !,"DOCUMENT NOT PATIENT SPECFIC (BLANKET OR SPECIAL LOCAL TRANS)." Q
 ;
 I ACHSWOK W !,"Transferring Medical data to PATIENT CARE COMPONENT!",! D WAIT^DICD
 ;
 ;IF THERE IS A VISIT DELETE IT?????
 I $$DOC^ACHS(2,5) D  I '$$DIE^ACHS("60///@;61///@") W:ACHSWOK !,"DELETE VISIT from DOCUMENT record failed." Q
 . I $$TOK W !,"DELETING EXISTING VISIT INFO."
 . N APCDVDLT
 . S APCDVDLT=$$DOC^ACHS(2,5)
 . D ^APCDVDLT                 ;
 .Q
 ;
 F %=1:1 I $P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",%,0)),U,2)="P" S ACHSTRAN=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",%,0)) Q
 S AUPNTALK=1,APCDANE=1,APCDAUTO=1,Y=$P(ACHSDOCR,U,22)
 D ^AUPNPAT
 ;
 S ACHSDUZ0=DUZ(0)
 S:'(DUZ(0)["M") DUZ(0)=DUZ(0)_"M" ; Requires SAC exception.
 ;
 F ACHSLBL="VISIT","VPOV","VPRV","PX","CHS","VDEN","VCPT" D @ACHSLBL Q:$D(APCDALVR("APCDAFLG"))  S %=APCDALVR("APCDVSIT") K APCDALVR S APCDALVR("APCDVSIT")=%
 ;
 I $D(APCDALVR("APCDAFLG")) D
 . I $G(ACHSISAO)=0 S ACHSERRE=24,ACHSEDAT=$$FLG(APCDALVR("APCDAFLG")) D ^ACHSEOBG
 . N APCDVDLT
 . S APCDVDLT=$S($$DOC^ACHS(2,5):$$DOC^ACHS(2,5),1:$G(APCDALVR("APCDVSIT")))
 . D:APCDVDLT ^APCDVDLT
 . I $$DOC^ACHS(2,5),$$DIE^ACHS("60///@;61///@")
 . Q:'ACHSWOK
 . W *7,!,"MEDICAL DATA FAILED TRANSFER TO PATIENT CARE COMPONENT.",!,$$FLG(APCDALVR("APCDAFLG"))
 . I $L($P($G(APCDALVR("APCDAFLG")),U,2)) W !,"VALUE = '",$P(APCDALVR("APCDAFLG"),U,2),"'"
 .Q
 ;
 S:1 DUZ(0)=ACHSDUZ0
 Q
 ;
 ; ---------------------------------------------------------------
 ;
VISIT ; Check/create VISIT entry in Patient Care Component.
 I $$TOK W !,"PCC VISIT..."
 ;
 S APCDALVR("APCDPAT")=$P(ACHSDOCR,U,22)
 S APCDALVR("APCDDATE")=$P(ACHSTRAN,U,10)
 S APCDALVR("APCDLOC")="`"_$$LOC($P(ACHSDOCR,U,4))
 S:'$D(APCDALVR("APCDTYPE")) APCDALVR("APCDTYPE")="CONTRACT"
 S APCDALVR("APCDCAT")=$S($P(ACHSTRAN,U,16)="Y":"I",$P(ACHSDOCR,U,4)=1:"H",1:"A")
 ; S APCDALVR("APCDCLN")= ptr to CLINIC STOP file
 ; S APCDALVR("APCDACS")="" unknown
 ;
 S APCDALVR("APCDADD")=""
 D EN^APCDALV
 ;
 I $D(APCDALVR("APCDAFLG")) S APCDALVR("APCDAFLG")=APCDALVR("APCDAFLG")_U_"ADD to VISIT failed." Q
 ;
 I '$$DIE^ACHS("60////"_APCDALVR("APCDVSIT")),ACHSWOK W !,"Edit VISIT field of DOCUMENT failed."
 Q
 ;
 ;
VPRV ; Create entry in "V PROVIDER" file.  ^AUPNVPRV  9000010.06
 I $$TOK W !,"PCC PROVIDER..."
 ;
 ;GET THE GENERIC USER??
 S X=$O(^VA(200,"GIHS",215999,0))   ;IHS ADC INDEX
 I 'X S APCDALVR("APCDAFLG")=21 Q
 ;
 ;IF THE PCC FILE CONVERSION HAS NOT BEEN DONE LOOK AT PERSON FILE PTR
 ;IN USER FILE
 I '$P($G(^AUTTSITE(1,0)),U,22) S X=$P(^DIC(3,X,0),U,16) I 'X K X S APCDALVR("APCDAFLG")=22 Q
 ;
 ;IF PCC CONVERSION HAS BEEN DONE USE NEW PERSON FILE ELSE USE PERSON
 ;LINE BELOW WAS MISSING A COMMA AFTER ^VA(200   
 S (DIE,DIC)=$S($P($G(^AUTTSITE(1,0)),U,22):"^VA(200,",1:"^DIC(16,")
 S DIC(0)=""
 S X="`"_X   ;SET X WITH ACCENT- INTERNAL NUMBER
 X $P(^DD(9000010.06,.01,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=41 Q  ;PROV FAILED EDIT IN "V PROVIDER" FILE
 S APCDALVR("APCDTPRO")="`"_X
 ;
 S (X,APCDALVR("APCDPAT"))=$P(ACHSDOCR,U,22)
 X $P(^DD(9000010.06,.02,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=42 Q   ;PATIENT FAILED EDIT 
 ;
 S (X,APCDALVR("APCDTPS"))="P"
 X $P(^DD(9000010.06,.04,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=44 Q   ;PRIMARY/SEC FAILED EDIT
 ;
 S (X,APCDALVR("APCDTOA"))=""
 X $P(^DD(9000010.06,.05,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=45 Q   ;OPER/ATTENDING FAILED EDIT
 ;
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 ;
 D EN^APCDALVR
 ;
 I $D(APCDALVR("APCDAFLG")) S APCDALVR("APCDAFLG")=APCDALVR("APCDAFLG")_U_"ADD to V PROVIDER failed." Q
 ;
 Q
 ;
 ;
VPOV ; Create entry in "V POV" file.
 I $$TOK W !,"PCC PURPOSE OF VISIT..."
 ;
 S APCDALVR("APCDTPS")="P"
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 3 LINES AND SPLIT F LOOP
 ;F ACHS=0:0 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,9,ACHS)) Q:'ACHS!$D(APCDALVR("APCDAFLG"))  S ACHS("DX")=+^(ACHS,0) I ACHS("DX")>1,$D(^ICD9(ACHS("DX"),0)),$E($G(^ICD9(ACHS("DX"),0)))'="E" D VPOV1
 F ACHS=0:0 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,9,ACHS)) Q:'ACHS!$D(APCDALVR("APCDAFLG"))  S ACHS("DX")=+^(ACHS,0) I ACHS("DX")>1,$D(^ICD9(ACHS("DX"),0)),$E($P($$ICDDX^ICDCODE(ACHS("DX")),U,2))'="E" D VPOV1
 K ACHS("DX")
 Q
 ;
VPOV1 ;
 ; Pointer to ^ICD9( is in ACHS("DX").
 ;
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.07 (ADD)]"
 ;
 ;pmf - 10/18/00  add the next line, Lori Butcher says it allows
 ;^APCDALVR to work, and it does.
 S APCDALVR("APCDOVRR")=""
 ;
 ; .01 - POV - APCDTPOV
 S (DIE,DIC)="^ICD9(",DIC(0)=""
 S (X,APCDALVR("APCDTPOV"))="`"_ACHS("DX")
 X $P(^DD(9000010.07,.01,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=24_U_APCDALVR("APCDTPOV") Q
 ;
 ; .02 - Patient Name
 S APCDALVR("APCDPAT")=$P(ACHSDOCR,U,22)
 ;
 ; .04 - Provider Narrative - APCDTNQ
 S (DIE,DIC)="^AUTNPOV(",DIC(0)=""
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 2 LINES
 ;S (X,APCDALVR("APCDTNQ"))=$P(^ICD9(ACHS("DX"),0),U,3)
 S (X,APCDALVR("APCDTNQ"))=$P($$ICDDX^ICDCODE(ACHS("DX")),U,4)
 ;
 ;2/12/02  pmf  We need even more to make PCC work
 S APCDOVRR=1  ; ACHS*3.1*3
 ;
 X $P(^DD(9000010.07,.04,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=14_U_APCDALVR("APCDTNQ") Q
 ;
 ; .05 - Stage - APCDTSTG
 ; .06 - Modifier - APCDTMOD
 ; .07 - Cause of DX - APCDTCD
 ; .08 - First/Revisit - APCDTFR
 ;
 ; .09 - Cause of Injury - APCDTCI
 S X=$$DOC^ACHS(3,7)
 I X S APCDALVR("APCDTCI")=X,(DIE,DIC)="^ICD9(",DIC(0)="" X $P(^DD(9000010.07,.09,0),U,5,99) I '$D(X) S APCDALVR("APCDAFLG")=15_U_APCDALVR("APCDTCI") Q
 ; .11 - Place of Accident - APCDTPA
 ; .12 - Primary/Secondary - APCDTPS
 ; .13 - Date of Injury
 ; .14 - Override/Accept - APCDTACC
 ; .15 - Clinical Term
 ; .16 - Problem List Entry
 ;
 S APCDALVR("ACHSDIEN")="" ; Needed to get by X-NEW in APCDALVR, as a
 ;     flag to "V POV" file to accept inactive ICD9 codes.
 ;
 D EN^APCDALVR
 ;
 I $D(APCDALVR("APCDAFLG")) S APCDALVR("APCDAFLG")=APCDALVR("APCDAFLG")_U_"ADD to V POV failed."
 ;
 K APCDALVR("APCDTPS")
 Q
 ;
 ;
PX ; Create/update "V PROCEDURE" data.
 I $$TOK W !,"PCC PROCEDURE..."
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 2 LINES
 ;F ACHS=0:0 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,10,ACHS)) Q:'ACHS!$D(APCDALVR("APCDAFLG"))  S ACHS("PTR")=+^(ACHS,0),ACHS("PXDT")=$P(^(0),U,2),ACHS("PX")=$P(^ICD0(+^(0),0),U) D PX1
 F ACHS=0:0 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,10,ACHS)) Q:'ACHS!$D(APCDALVR("APCDAFLG"))  S ACHS("PTR")=+^(ACHS,0),ACHS("PXDT")=$P(^(0),U,2),ACHS("PX")=$P($$ICDOP^ICDCODE(+^(0)),U,2) D PX1
 K ACHS("PTR"),ACHS("PXDT"),ACHS("PX")
 Q
 ;
PX1 ;
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.08 (ADD)]"
 S DIC(0)="M",X=$G(^DD(80.1,0,"DIC"))
 I X]"" X ^%ZOSF("TEST") E  S DIC(0)="IM"
 I DFN S Y=DFN D ^AUPNPAT
 ;
 ; .01 - Procedure - APCDTPRC
 S (DIE,DIC)="^ICD0("
 S (X,APCDALVR("APCDTPRC"))=ACHS("PX")
 X $P(^DD(9000010.08,.01,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=25_U_APCDALVR("APCDTPRC") Q
 ;
 ; .04 - Provider Narrative - APCDTNQ
 S (DIE,DIC)="^AUTNPOV("
 S (X,APCDALVR("APCDTNQ"))=$E($P($G(^ICD0(ACHS("PTR"),1)),U),1,80)
 ;THESE TWO LINES MOVED DOWN 4
 I $L(APCDALVR("APCDTNQ"))>74 S APCDALVR("APCDTNQ")=$E(APCDALVR("APCDTNQ"),1,74)_"~*CHS*"
 E  S APCDALVR("APCDTNQ")=APCDALVR("APCDTNQ")_"*CHS*"
 ;THIS IS GEORGES 5-23 CHANGE TO NARATIVE FAILURE
 S X=APCDALVR("APCDTNQ")
 X $P(^DD(9000010.08,.04,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=35_U_APCDALVR("APCDTNQ") Q
 ;
 ; .06 - Procedure Date - APCDTPD
 S (X,APCDALVR("APCDTPD"))=ACHS("PXDT")
 X $P(^DD(9000010.08,.06,0),U,5,99)
 I '$D(X) S APCDALVR("APCDAFLG")=23_U_APCDALVR("APCDTPD") Q
 ;
 D EN^APCDALVR
 ;
 I $D(APCDALVR("APCDAFLG")) S APCDALVR("APCDAFLG")=APCDALVR("APCDAFLG")_U_"ADD to V PROCEDURE failed." Q
 ;
 Q
 ;
VDEN ; Create entries in "V DENTAL"
 I $$TOK W !,"PCC V DENTAL..."
 D VDEN^ACHSPAP1
 Q
 ;
VCPT ; Create entries in "V CPT"
 I $$TOK W !,"PCC V CPT..."
 D VCPT^ACHSPAP1
 Q
 ;
CHS ; Create an entry in V CHS
 I $$TOK W !,"PCC V CHS..."
 D CHS^ACHSPAP1
 Q
 ;
TOK() ;EP - Change argument to 1 interactive testing.
 Q 0
 ;
LOC(T) ;
 ; Given the Type of service return the LOCATION IEN:
 ; TOS                       LOCATION Name
 ; ------------------------  -------------------------
 ; 1 = Inpatient             CHS HOSPITAL
 ; 2 = Dental                CHS OTHER
 ; 3 = Outpatient            CHS PHYSICIAN OFFICE
 ; If the above cannot be ascertained based on the ASUFAC of the
 ; facility, return DUZ(2).
 N A,Y
 S A=$P($G(^AUTTLOC(DUZ(2),0)),U,10)
 I 'A Q DUZ(2)
 S A=$E(A,1,4)_$S(T=1:"82",T=2:"97",1:"88")
 S Y=$O(^AUTTLOC("C",A,0))
 I Y Q Y
 I T=2 S A=$E(A,1,4)_"86" S Y=$O(^AUTTLOC("C",A,0)) I Y Q Y
 Q DUZ(2)
 ;
FLG(N) ;
 I '$G(N) Q "<UNKNOWN>"
 I '$L($T(ERRS+N)) Q "<UNKNOWN>"
 Q $P($T(ERRS+N),";",4)
ERRS ;
 ;;1;Bad Input Template
 ;;2;DIE Interface Failed
 ;;3
 ;;4
 ;;5
 ;;6
 ;;7
 ;;8
 ;;9
 ;;10
 ;;11
 ;;12
 ;;13
 ;;14;Provider Narrative failed edit in V POV
 ;;15;Cause Of Injury failed edit in V POV
 ;;16
 ;;17
 ;;18
 ;;19
 ;;20
 ;;21;Cannot find generic contract provider for V PROVIDER
 ;;22;PROVIDER cannot be found in File 6 for V PROVIDER
 ;;23;PROCEDURE DATE failed edit in V PROCEDURE
 ;;24;ICD Diagnosis code failed edit in V POV
 ;;25;ICD Procedure code failed edit in V PROCEDURE
 ;;26;AUTHORIZATION NUMBER failed edit in V CHS
 ;;27;PAY STATUS failed edit in V CHS
 ;;28;TOTAL CHARGES failed edit in V CHS
 ;;29;DATE OF DISCHARGE failed edit in V CHS
 ;;30;NO OF VISITS failed edit in V CHS
 ;;31;ADA code failed edit in V DENTAL
 ;;32;CPT code failed edit in V CPT
 ;;33;Number Of Unites failed edit in V DENTAL
 ;;34;Tooth Surface failed edit in V DENTAL
 ;;35;PROVIDER NARRATIVE failed edit in V PROCEDURE
 ;;36
 ;;37
 ;;38
 ;;39
 ;;40
 ;;41;Provider (.01) failed edit in V PROVIDER
 ;;42;Patient (.02) failed edit in V PROVIDER
 ;;43
 ;;44;Primary/Secondary (.04) failed edit in V PROVIDER
 ;;45;Operator/Attending (.05) failed edit in V PROVIDER
 ;;46
