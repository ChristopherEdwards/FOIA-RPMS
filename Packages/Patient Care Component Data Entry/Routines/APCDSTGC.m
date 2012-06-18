APCDSTGC ; IHS/CMI/LAB - LIST MANAGER API'S FOR FAMILY HISTORY AND API FOR REP FACTORS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;BJPC v1 patch 1
INPUT ;EP - called from input transform on Stage field
 NEW A,T,C,H,L
 S C=$P($G(^AUPNVPOV(DA,0)),U)
 S A=0 F  S A=$O(^APCDSTGC(A)) Q:A'=+A!('$D(X))  D
 .S T=$P(^APCDSTGC(A,0),U,2)
 .Q:T=""
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S L=$P(^APCDSTGC(A,0),U,3)
 .S H=$P(^APCDSTGC(A,0),U,4)
 .I X<L!(X>H) K X
 .Q
 Q
 ;
HELP ;EP - Executable help from stage field of V POV
 NEW A,T,C,H,L,G
 S G=0
 S C=$P($G(^AUPNVPOV(DA,0)),U)
 S A=0 F  S A=$O(^APCDSTGC(A)) Q:A'=+A!(G)  D
 .S T=$P(^APCDSTGC(A,0),U,2)
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S G=1
 .S H=0 F  S H=$O(^APCDSTGC(A,12,H)) Q:H'=+H  D
 ..D EN^DDIOL($G(^APCDSTGC(A,12,H,0)))
 .Q
 Q
 ;
EP(APCDDFN,APCDV,APCDI,APCDX) ;EP - called from xref on stage field of V POV
 ;APCDDFN=PATIENT DFN
 ;APCDV=VISIT IEN
 ;APCDX=VALUE
 ;APCDI=IEN OF V POV
 NEW APCDA,APCDC,APCDT,C
 S C=$P($G(^AUPNVPOV(APCDI,0)),U)
 Q:C=""
 S APCDA=0 F  S APCDA=$O(^APCDSTGC(APCDA)) Q:APCDA'=+APCDA  D
 .S APCDT=$P(^APCDSTGC(APCDA,0),U,2)
 .Q:'$D(^ATXAX(APCDT))
 .Q:'$$ICD^ATXCHK(C,APCDT,9)
 .I $G(^APCDSTGC(APCDA,13))]"" X ^APCDSTGC(APCDA,13)
 .Q
 Q
 ;
ASTH ;EP
 D EN^XBNEW("ASTH1^APCDSTGC","APCDDFN;APCDV;APCDX;APCDI")
 Q
 ;
ASTH1 ;EP - called from xbnew
 ;Add V Asthma Severity for this stage
 ;if V Asthma entry already exists on this day, overlay it
 ;if deleted, delete v astHma entry that matches
 ;
 ;first check to see if stage is blank, if it is find the V ASTHMA created by
 ;this pov and delete out the severity value, if there is no V ASTHMA then quit
 ;as there is nothing to delete
 I $P($G(^AUPNVPOV(APCDI,0)),U,5)="" D  Q
 .S APCDB=0 F  S APCDB=$O(^AUPNVAST("AD",APCDV,APCDB)) Q:APCDB'=+APCDB  D
 ..Q:'$D(^AUPNVAST(APCDB,0))  ;bad xref
 ..Q:$P(^AUPNVAST(APCDB,0),U,13)'=APCDI  ;not created by this pov so leave it alone
 ..S DA=APCDB,DIE="^AUPNVAST(",DR=".04///@" D ^DIE K DA,DR,DIE,DIU,DIV
 ..Q
 .Q
 ;
 ;now find V ASTHMA created by this V POV and edit it, if none exists, add it
 S APCDB=0,G=0 F  S APCDB=$O(^AUPNVAST("AD",APCDV,APCDB)) Q:APCDB'=+APCDB!(G)  D
 .Q:'$D(^AUPNVAST(APCDB,0))  ;bad xref
 .Q:$P(^AUPNVAST(APCDB,0),U,13)'=APCDI  ;not this vpov
 .S DA=APCDB,DIE="^AUPNVAST(",DR=".04///"_APCDX D ^DIE K DA,DIE,DIU,DIV
 .S G=1
 I G Q  ;found one, editted it, quit
 ;add v asthma entry
 ;
ADDVAST ;
 K APCDALVR
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.41 (ADD)]"
 S APCDALVR("APCDPAT")=APCDDFN
 S APCDALVR("APCDVSIT")=APCDV
 S APCDALVR("APCDTSEV")=APCDX
 S APCDALVR("APCDTPOV")="`"_APCDI
 D ^APCDALVR
 K APCDALVR
 ;if it fails, not much I can do but it shouldn't fail
 Q
 ;
ASKSTG(C) ;EP - called from data entry input templates to determine whether stage should be prompted for this icd diagnosis
 ;C is ien of the icd9 entry
 I $G(C)="" Q 0
 NEW A,T,H
 S A=0,H=0 F  S A=$O(^APCDSTGC(A)) Q:A'=+A!(H)  D
 .S T=$P(^APCDSTGC(A,0),U,2)
 .Q:T=""
 .Q:'$D(^ATXAX(T))
 .Q:'$$ICD^ATXCHK(C,T,9)  ;not in this taxonomy
 .S H=1
 .Q
 Q H
