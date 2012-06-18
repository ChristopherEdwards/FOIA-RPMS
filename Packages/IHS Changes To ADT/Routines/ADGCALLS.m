ADGCALLS ; IHS/ADC/PDW/ENM - PCC LINK ; [ 06/05/2002  1:14 PM ]
 ;;5.3;ADMISSION/DISCHARGE/TRANSFER;**1010,1011**;MAR 25, 1999
 ;
 ;cmi/anch/maw 10/20/2008 PATCH 1010 added set of APCDALV("APCDOPT") to BDG VISIT CREATOR
 ;cmi/anch/maw 05/05/2009 PATCH 1010 add check at visit delete to see if BDG VISIT CREATOR is in visit before deletion
 ;
APCDEIN ;EP; -- initialize PCC variables
 D ^APCDEIN Q
 ;
DSCV ;EP; -- day surgery create visit
 N BDGOPT
 S BDGOPT="BDG VISIT CREATOR"
 S APCDALVR("APCDOPT")=$O(^DIC(19,"B",BDGOPT,0))  ;cmi/maw 10/20/2008 PATCH 1011 added set of option used to create visit
 D ^APCDALV I $D(APCDALVR("APCDAFLG")) D ERR,APCDEKL Q
 D APCDEKL Q
 ;
APCDALV ;EP; -- create visit
 ;cmi/maw 9/2/2009 PATCH 1010
 N BDGOPT
 S BDGOPT="BDG VISIT CREATOR"
 S APCDALVR("APCDOPT")=$O(^DIC(19,"B",BDGOPT,0))  ;cmi/maw 10/20/2008 PATCH 1010 added set of option used to create visit
 S APCDALVR("APCDADD")=1,APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDLOC")=DUZ(2),APCDALVR("APCDCAT")="H"
 S APCDALVR("APCDTYPE")=$P(^DG(43,1,9999999),U)
 S APCDALVR("APCDDATE")=+DGPMA
 D ^APCDALV I $D(APCDALVR("APCDAFLG")) D ERR,APCDEKL Q
 W !!,"Visit created for date of admission" S DIE="^DGPM("
 L +^DGPM(DGPMCA):3 I '$T D  Q
 . W !,*7,"CANNOT UPDATE VISIT LINK; ENTRY LOCKED"
 . D APCDEKL
 S DA=DGPMCA,DR="9999999.1////"_APCDALVR("APCDVSIT")
 D ^DIE L -^DGPM(DGPMCA)
 D APCDEKL Q
 ;
APCDCVDT ;EP; -- edit visit date
 I '+$$VIP D APCDALV Q
 S APCDCVDT("VISIT DFN")=$$VIP,APCDCVDT("VISIT DATE/TIME")=+DGPMA
 D ^APCDCVDT I $D(APCDCVDT("ERROR FLAG")) D ERR
 D APCDEKL Q
 ;
APCDVDLT ;EP; -- delete visit
 ;cmi/maw 5/5/2009 PATCH 1010 check here to see if BDG VISIT CREATOR and delete only if
 D APCDEIN S APCDVDLT=$$VIP D ^APCDVDLT,APCDEKL Q
 ;
APCDALVR ;EP; -- v hospitalization
 D APCDEIN
 ; -- check/create visit
 I '+$$VIC N DGPMA,DGPMDA,DGPMP S DGPMA=^DGPM(DGPMCA,0),DGPMDA=DGPMCA D APCDALV
 I '+$$VIC D ERR,APCDEKL Q
 S APCDALVR("APCDVSIT")=+$$VIC
 ; -- create v hosp
 I '$O(^AUPNVINP("AD",+$$VIC,0)) D CVH Q
 ;I $P(DGPMA,U,2)=3&(DGPMP="") D CVH Q
 ; -- modify v hosp
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.02 (MOD)]"
 S APCDALVR("APCDLOOK")=$O(^AUPNVINP("AD",+$$VIC,0))
 S APCDALVR("APCDDSCH")=+^DGPM(+$P(^DGPM(DGPMCA,0),U,17),0)
 D ^APCDALVR I $D(APCDALVR("APCDAFLG")) D ERR
 D APCDEKL Q
 ;
CVH ; -- create v hosp
 S APCDALVR("APCDPAT")=DFN,APCDALVR("APCDTDT")="`"_$P(DGPMA,U,4)
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.02 (ADD)]"
 S:$P(DGPMA,U,18)=10 APCDALVR("APCDTTT")=$$TFAC
 S APCDALVR("APCDLOOK")=$E(+DGPMA,1,12),APCDALVR("APCDTDCS")="`"_$$DSRV
 S APCDALVR("APCDTADS")="`"_$P(^DGPM($O(^DGPM("APHY",DGPMCA,0)),0),U,9)
 S APCDALVR("APCDTAT")="`"_$P(^DGPM(DGPMCA,0),U,4)
 D ^APCDALVR I $D(APCDALVR("APCDAFLG")) D ERR
 D APCDEKL Q
 ;
APCDEA3 ;EP;***> call to PCC Data Entry rtns
 D ^APCDEA3 Q
 ;
APCDCHK ;EP;***> call to PCC visit check rtn
 D ^APCDVCHK Q
 ;
APCLYV3 ;EP;***> call to pcc reports rtns
 D ^APCLYV31,^APCLYV32 Q   ;clinic visits with icd codes
 ;
APCDEKL ;EP; -- cleanup variables
 D EN1^APCDEKL K DIE,DA,DR,APCDALVR,APCDCVDT,APCDVDLT  Q
 ;
ERR ; -- error processor
 Q
 ;
TFAC() ;EP; -- transfer facility
 N X S X=$P(DGPMA,U,5) Q $S(X["DIC(4":"VA/IHS.`",1:"VENDOR.`")_+X
 ;
DSRV() ;EP; -- discharge service
 N X,Y S Y=9999999.9999999-$G(^DGPM(+$P(^DGPM(DGPMCA,0),U,17),0)) Q:'Y 0
 S X=$O(^DGPM("ATID6",+DFN,+$O(^DGPM("ATID6",+DFN,Y)),0))
 Q $P($G(^DGPM(+X,0)),U,9)
 ;
VIP() ; -- visit ien (dgpmp)
 Q +$O(^AUPNVSIT("AA",+DFN,+$$IDP,0))
 ;
IDP() ; -- inverse date (dgpmp)
 Q (9999999-$P(+DGPMP,"."))_"."_$P(+DGPMP,".",2)
 ;
VIC() ; -- visit ien (dgpmca)
 N X,Y S (X,Y)=0
 F  S X=$O(^AUPNVSIT("AA",+DFN,+$$IDC,X)) Q:'X  Q:Y  D
 . I $P($G(^AUPNVSIT(X,0)),U,7)="H" S Y=X
 Q Y
 ;
 ;Q +$O(^AUPNVSIT("AA",+DFN,+$$IDC,0))
 ;
IDC() ; -- inverse date (dgpmca)
 Q (9999999-$P(+^DGPM(+DGPMCA,0),"."))_"."_$P(+^DGPM(+DGPMCA,0),".",2)
