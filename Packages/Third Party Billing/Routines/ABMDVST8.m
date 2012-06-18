ABMDVST8 ; IHS/ASDST/DMJ - PCC VISIT STUFF - IMMUNIZ ; 
 ;;2.6;IHS Third Party Billing System;**2**;NOV 12, 2009
 ;Original;TMD;03/26/96 11:59 AM
 ; this rtn is replaced by the new call to $$CPT etc
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*2 - 3PMS10003A - modified to call ABMFEAPI
 ;
 Q
 ; Leave this code until live alpha testing proves it is not needed
 K ABMR
CPT S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",27,",DIC(0)="LE"
 S ABM="^AUPNVIMM(""AD"","_ABMVDFN_")"
 F  S ABM=$Q(@ABM) Q:$P($P(ABM,"AD",2),",",2)'=ABMVDFN  K DIC("DR"),DD,DO S X=+$P($P(ABM,"AD",2),",",3) D CPTCHK
 Q
 ;
CPTCHK Q:'$D(^AUPNVIMM(X,0))  S ABMR("X")=+$P($G(^AUTTIMM(+^(0),0)),U,3)
 Q:'ABMR("X")  S ABM("CPT")=$P($T(@ABMR("X")),";;",2) Q:'ABM("CPT")
 ;Q:$P($G(^ABMDFEE(ABMP("FEE"),19,ABM("CPT"),0)),U,2)<1  S ABMR("FEE")=$P(^(0),U,2)
 ;Q:($P($G(^ABMDFEE(ABMP("FEE"),19,ABM("CPT"),0)),U,2)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 Q:($P($$ONE^ABMFEAPI(ABMP("FEE"),19,ABM("CPT"),ABMP("VDT")),U)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,14)'="Y"))  ;abm*2.6*2 3PMS10003A
 ;S ABMR("FEE")=$P($G(^ABMDFEE(ABMP("FEE"),19,ABM("CPT"),0)),U,2)  ;abm*2.6*2 3PMS10003A
 S ABMR("FEE")=$P($$ONE^ABMFEAPI(ABMP("FEE"),19,ABM("CPT"),ABMP("VDT")),U)  ;abm*2.6*2 3PMS10003A
 S X=ABM("CPT")
 I $D(ABMR(X)) S ABMR(X)=ABMR(X)+1
 E  S ABMR(X)=1
 S DIC("P")=$P(^DD(9002274.3,27,0),U,2)
 S DIC("DR")=".02////"_$S($P($$IHSCPT^ABMCVAPI(X,ABMP("VDT")),U,3):$P($$IHSCPT^ABMCVAPI(X,ABMP("VDT")),U,3),1:960)_";.03////"_ABMR(X)_";.04////"_ABMR("FEE")  ;CSV-c
 K DD,DO
 K DD,DO D FILE^DICN
 Q
 ;
1 ;;90749
2 ;;90718
3 ;;90701
4 ;;90703
5 ;;90714
6 ;;90712
7 ;;90713
8 ;;90749
9 ;;90749
10 ;;90731;  This code has been replaced by 90744-90747
11 ;;90705
12 ;;90724
13 ;;90725
14 ;;90706
15 ;;90704
16 ;;90728
17 ;;90707
18 ;;90708
19 ;;90732
31 ;;90717
32 ;;90749
33 ;;90726
34 ;;90702
35 ;;90737
36 ;;90737
37 ;;90737
38 ;;90737
39 ;;90737
