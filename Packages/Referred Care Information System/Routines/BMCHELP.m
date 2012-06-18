BMCHELP ; IHS/PHXAO/TMJ - REFERRED CARE INFORMATION SYSTEM ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
EN1 ; EP - SHOW PAYOR ELIGIBILITY (SCREENMAN)
 Q:'$G(BMCDFN)
 Q:'$G(BMCRDATE)
 NEW BMCMSG,BMCI,BMCX
 S BMCI=1
 S BMCX=$$BEN^AUPNPAT(BMCDFN,"E")
 S:BMCX="" BMCX="UNKNOWN"
 S BMCMSG(BMCI)="CLASSIFICATION/BENEFICIARY IS: "_BMCX,BMCI=+BMCI+1
 S BMCX=$$ELIGSTAT^AUPNPAT(BMCDFN,"E")
 S:BMCX="" BMCX="UNKNOWN"
 S BMCMSG(BMCI)="ELIGIBILITY STATUS IS: "_BMCX,BMCI=+BMCI+1
 NEW BMCELG
 S BMCELG=BMCI
 I $$MCR^AUPNPAT(BMCDFN,BMCRDATE) S BMCMSG(BMCI)="PATIENT HAS MEDICARE",BMCI=BMCI+1
 I $$MCD^AUPNPAT(BMCDFN,BMCRDATE) S BMCMSG(BMCI)="PATIENT HAS MEDICAID",BMCI=BMCI+1
 I $$PI^AUPNPAT(BMCDFN,BMCRDATE) S BMCMSG(BMCI)="PATIENT HAS PRIVATE INSURANCE",BMCI=BMCI+1
 I BMCELG=BMCI S BMCMSG(BMCI)="NO THIRD PARTY COVERAGE RECORDED",BMC=BMCI+1
 NEW J,R S J=$O(^AUPNPAT(BMCDFN,13,0)) S R(1)=$S(J:^(J,0),1:"") S J=$O(^AUPNPAT(BMCDFN,13,J)) S R(2)=$S(J:^(J,0),1:"") S:$O(^AUPNPAT(BMCDFN,13,J)) R(2)=R(2)_" [more]"
 I R(1)]"" S BMCMSG(BMCI)=R(1),BMCI=BMCI+1
 I R(2)]"" S BMCMSG(BMCI)=R(2),BMCI=BMCI+1
 D HLP^DDSUTL(.BMCMSG)
 Q
 ;
EN2 ; EP - POSSIBLE 3RD PARTY LIABILITY MESSAGE (SCREENMAN)
 NEW BMCMSG
 S BMCMSG(1)="You are entering a diagnosis that indicates this claim may involve third party"
 S BMCMSG(2)="liability.  You may want to investigate this possibility in order to recover"
 S BMCMSG(3)="costs."
 D HLP^DDSUTL(.BMCMSG)
 D HLP^DDSUTL("$$EOP")
 Q
EN3 ; EP - chs warning if no chs eligibility
 NEW BMCMSG
 S BMCMSG(1)="WARNING:  Patient Registration indicates that this patient is NOT ELIGIBLE"
 S BMCMSG(2)="          for CHS care."
 D HLP^DDSUTL(.BMCMSG)
 D HLP^DDSUTL("$$EOP")
 Q
PRIORITY ;EP executable help from priority field in rcis referral
 NEW BMCMSG,J,K,T
 I '$O(^BMCPARM(DUZ(2),1,0)) D  I 1
 .S T="TEXTDEF"
 .F J=1:1 S K=$T(@T+J),K=$P(K,";;",2) Q:K="END"!(K="")  S BMCMSG(J)=K
 .Q
 E  D
 .S J=0 F  S J=$O(^BMCPARM(DUZ(2),1,J)) Q:J'=+J  S BMCMSG(J)=^BMCPARM(DUZ(2),1,J,0)
 .Q
 D EN^DDIOL(.BMCMSG)
 Q
SETDEF ;set default message into BMCMSG
SETMSG ;set site configured help prompt in BMCMSG
 Q
TEXTDEF ;default ihs standard help text for priority
 ;;1 - LEVEL I.  EMERGENT/ACUTELY URGENT CARE SERVICES
 ;; DEFINITION: Diagnostic/therapeutic services that are necessary to prevent the
 ;; immediate death/serious impairment of the health of the individual, and if
 ;; left untreated, would result in uncertain but potientially grave outcomes.
 ;;2 - LEVEL II. PREVENTIVE CARE SERVICES
 ;; DEFINITION: Primary health care that is aimed at the prevention of 
 ;; disease/disability such as, non-urgent preventive ambulatory care, screening
 ;; for known disease entities, and public health intervention, etc.
 ;;3 - LEVEL III. PRIMARY AND SECONDARY CARE SERVICES
 ;; DEFINITION: Inpatient and outpatient care services that involve the treatment
 ;; of prevalent illnesses/conditions that have a significant impact on mordidity
 ;; and mortality.
 ;;4 - LEVEL IV. CHRONIC TERTIARY AND EXTENDED CARE SERVICES
 ;; DEFINITION: Inpatient and outpatient care services that (1) are not 
 ;; essential for initial/emergent diagnosis/therapy, (2) have less impact on 
 ;; mortality that morbidity, or (3) are high cost, elective, and often require
 ;; tertiary care facilities.
 ;;5 - LEVEL V. EXCLUDED SERVICES
 ;; DEFINITION: Services and procedures that are considered purely cosmetic in 
 ;; nature, experimental or investigational, or have no proven medical benefit.
 ;;
 ;;END
