ABMDVST7 ; IHS/ASDST/DMJ - PCC VISIT STUFF MEDICAL-SKIN TEST ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;Original;TMD;03/26/96 12:00 PM
 ; modifed to use the new extrinsic function
 ; skip this rtn
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 Q
 ; Delete this following code after alpha tesing
 K ABMR
SKIN S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",37,",DIC(0)="LE"
 S ABM="^AUPNVSK(""AD"","_ABMVDFN_")"
 F  S ABM=$Q(@ABM) Q:$P($P(ABM,"AD",2),",",2)'=ABMVDFN  K DIC("DR"),DD,DO S X=+$P($P(ABM,"AD",2),",",3) D SKCHK
 G EXAM
 ;
SKCHK Q:'$D(^AUPNVSK(X,0))  S ABMR("X")=$P($G(^AUTTSK(+^(0),0)),U,2) Q:'ABMR("X")
 S ABM("CPT")=$P($T(@ABMR("X")),";;",2) Q:'ABM("CPT")
 ;Q:$P($G(^ABMDFEE(ABMP("FEE"),17,ABM("CPT"),0)),U,2)<1  S ABMR("FEE")=$P(^(0),U,2)
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),17,ABM("CPT"),0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),17,ABM("CPT"),ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;S ABMR("FEE")=$P($G(^ABMDFEE(ABMP("FEE"),17,ABM("CPT"),0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMR("FEE")=$P($$ONE^ABMFEAPI(ABMP("FEE"),17,ABM("CPT"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S X=ABM("CPT")
 I $D(ABMR(X)) S ABMR(X)=ABMR(X)+1
 E  S ABMR(X)=1
 S DIC("P")=$P(^DD(9002274.3,37,0),U,2)
 S DIC("DR")=".02////"_$S($P($$IHSCPT^ABMCVAPI(X,ABMP("VDT")),U,3):$P($$IHSCPT^ABMCVAPI(X,ABMP("VDT")),U,3),1:302)_";.03////"_ABMR(X)_";.04////"_ABMR("FEE")  ;CSV-c
 K DD,DO D FILE^DICN
 Q
 ;
EXAM K ABMR
 S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 S ABM="^AUPNVXAM(""AD"","_ABMVDFN_")"
 F  S ABM=$Q(@ABM) Q:$P($P(ABM,"AD",2),",",2)'=ABMVDFN  K DIC("DR"),DD,DO S X=+$P($P(ABM,"AD",2),",",3) D EXCHK
 Q
 ;
EXCHK Q:'$D(^AUPNVXAM(X,0))  S ABMR("X")=$P($G(^AUTTEXAM(+^(0),0)),U,2) Q:'ABMR("X")
 S ABMR("X")="E"_ABMR("X"),ABM("CPT")=$P($T(@ABMR("X")),";;",2) Q:'ABM("CPT")
 ;Q:$P($G(^ABMDFEE(ABMP("FEE"),19,ABM("CPT"),0)),U,2)<1  S ABMR("FEE")=$P(^(0),U,2)
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),19,ABM("CPT"),0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),19,ABM("CPT"),ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;S ABMR("FEE")=$P($G(^ABMDFEE(ABMP("FEE"),19,ABM("CPT"),0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMR("FEE")=$P($$ONE^ABMFEAPI(ABMP("FEE"),19,ABM("CPT"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S X=ABM("CPT")
 I $D(ABMR(X)) S ABMR(X)=ABMR(X)+1
 E  S ABMR(X)=1
 S DIC("P")=$P(^DD(9002274.3,27,0),U,2)
 S DIC("DR")=".02////"_$S($P($G(^ICPT(X,9999999)),U,2):$P(^(9999999),U,2),1:960)_";.03////"_ABMR(X)_";.04////"_ABMR("FEE")
 K DD,DO D FILE^DICN
 Q
 ;
20 ;;86585
21 ;;86580
22 ;;86580
23 ;;86490
24 ;;86580
E23 ;;92551
E24 ;;92552
E25 ;;92567
E26 ;;92100
