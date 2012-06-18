BCHUTIL ; IHS/TUCSON/LAB - UTILITIES ;  [ 01/27/03  9:58 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**7,14,16**;OCT 28, 1996
 ;
 ;IHS/CMI/LAB - for xtmp 0 node set
XTMP(N,T) ;EP
 I $G(N)="" Q
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_U_DT_U_T
 Q
PPINI(REC) ;EP Retrieve CHR Primary Provider Initials
 NEW X,Y,BCHX,BCHY,DIQ,DR,DA,BCHG,BCHINI
 S BCHY=$P(^BCHR(REC,0),U,3)
 I 'BCHY S BCHINI="???" Q BCHINI
 S DA=BCHY,DIC=200,DR=1,DIQ="BCHINI",DIQ(0)="I"
 D EN^DIQ1
 S BCHINI=$G(BCHINI(200,BCHY,1,"I"))
 S:BCHINI="" BCHINI="???"
 Q BCHINI
PPNAME(REC) ;EP
 NEW X,Y,BCHX,BCHY,DIQ,DR,DA,BCHG,BCHNAME
 S BCHY=$P(^BCHR(REC,0),U,3)
 I '$D(BCHY) S BCHNAME="???" Q BCHNAME
 S BCHNAME=$P(^VA(200,BCHY,0),U)
 S:BCHNAME="" BCHNAME="???"
 Q BCHNAME
PPINT(REC) ;primary provider internal # from 200 (duz)
 NEW X,Y,BCHX,DIQ,DR,DA,BCHG,BCHY
 S BCHY=$P(^BCHR(REC,0),U,3)
 I '$D(BCHY) S BCHY="???" Q BCHY
 Q BCHY
PPAFFL(REC,FORM) ;EP - get pp affiliation internal or external
 NEW X,Y,BCHX,BCHY,DIQ,DR,DA,BCHG,BCHAFFL
 S BCHY=$P(^BCHR(REC,0),U,3)
 I 'BCHY S BCHAFFL="?" Q BCHAFFL
 I '$D(^VA(200,BCHY)) S BCHAFFL="?" Q BCHAFFL
 S DA=BCHY,DIC=200,DR=9999999.01,DIQ="BCHAFFL" S:$G(FORM)="I" DIQ(0)="I"
 D EN^DIQ1
 S BCHAFFL=$S($G(FORM)="I":BCHAFFL(200,BCHY,9999999.01,"I"),1:BCHAFFL(200,BCHY,"9999999.01"))
 S:BCHAFFL="" BCHAFFL="?"
 Q BCHAFFL
PPCLS(REC,FORM) ;EP GET primary provider discipline (internal or text)
 NEW X,Y,BCHX,BCHY,DIQ,DR,DA,BCHG,BCHCLS
 S BCHY=$P(^BCHR(REC,0),U,3)
 I 'BCHY S BCHCLS="???" Q BCHCLS
 S DA=BCHY,DIC=200,DR=53.5,DIQ="BCHCLS" S:$G(FORM)="I" DIQ(0)="I"
 D EN^DIQ1
 S BCHCLS=$S($G(FORM)="I":$G(BCHCLS(200,BCHY,53.5,"I")),1:$G(BCHCLS(200,BCHY,"53.5")))
 S:BCHCLS="" BCHCLS="???"
 Q BCHCLS
PPCLSC(REC) ;EP GET PRIMARY PROVIDER CLASS CODE
 NEW X,Y,CODE,DIC,DR,DA,DIQ,CLS
 S CLS=$$PPCLS^BCHUTIL(REC,"I")
 I CLS="???" S CODE="???" Q CODE
 S DIC=7,DR="9999999.01",DA=CLS,DIQ="CODE"
 D EN^DIQ1
 S CODE=CODE(7,CLS,"9999999.01")
 S:CODE="" CODE="???"
 Q CODE
CALLDIE ;EP
 Q:'$D(DA)
 Q:'$D(DIE)
 Q:'$D(DR)
 D ^DIE
 K DIE,DIC,DR,DA,D0,D,D1,DO,%X,%Y,X,A,Z,DIU,DIV,DIY,DIW,DIADD,DLAYGO,%,%E,%D,%W,DI,DIFLD,DIG,DIH,DK,DL,DISYS
 Q
PROVCLC(PROV) ;get provider class code, not using fileman DIQ1
 NEW CODE,A
 S CODE=""
 I 'PROV Q CODE
 S A=$P($G(^VA(200,PROV,"PS")),U,5)
 I A="" Q CODE
 S CODE=$P($G(^DIC(7,A,9999999)),U)
 Q CODE
CANNEDN() ;EP - return canned narrative
 NEW BCHX
 ;*****CALLED FROM SCREENMAN
 S BCHX=$$GET^DDSVAL(90002.01,.DA,.04,"","I") I BCHX,$P($G(^BCHTSERV(BCHX,0)),U,4) D HLP^DDSUTL("You must type in a narrative for those services that pass to PCC") Q ""
 I $$GET^DDSVAL(90002.01,.DA,.01,"","I")="" Q "<???>"
 I $$GET^DDSVAL(90002.01,.DA,.04,"","I")="" Q $P(^BCHTPROB($$GET^DDSVAL(90002.01,.DA,.01,"","I"),0),U)
 Q $E($P(^BCHTPROB($$GET^DDSVAL(90002.01,.DA,.01,"","I"),0),U)_":"_$P(^BCHTSERV($$GET^DDSVAL(90002.01,.DA,.04,"","I"),0),U),1,80)
UPDPCC ;EP - called when pcc adds a visit
 ;if it is initiated by chr (i.e. BCHEV exists) chr will store
 ;ien's of visit and v file entries
 Q:'$D(BCHEV)  ;quit if not initiated by chr
 Q:'$G(BCHEV("CHR IEN"))  ;quit if don't know chr record ien
 Q:'$D(BCHV)  ;quit if no pcc data passed back
 S DIE="^BCHR(",DA=BCHEV("CHR IEN"),DR=".15////"_BCHV("VISIT","9000010") D CALLDIE
 K Y,DA,DR,DIE
 S BCHX=0 F  S BCHX=$O(BCHV("VFILES",BCHX)) Q:BCHX'=+BCHX  D
 .S BCHY=0 F  S BCHY=$O(BCHV("VFILES",BCHX,BCHY)) Q:BCHY'=+BCHY  D
 ..S DA=BCHEV("CHR IEN"),DR="3101///""`"_BCHX_"""",DIE="^BCHR("
 ..S DR(2,90002.03101)=".02////"_BCHY
 ..D CALLDIE
 ..K DIE,DA,DR,Y,X
 ..Q
 .Q
 K BCHX,BCHY
 Q
SETDEFNX(R) ;EP - called from screenman screen
 I '$G(R) Q ""
 NEW X,Y,G,Z
 S G=1
 S X=0 F  S X=$O(^BCHRPROB("AD",R,X)) Q:X'=+X  D
 .S Y=$P(^BCHRPROB(X,0),U,1)
 .I Y S Y=$P(^BCHTPROB(Y,0),U,2)
 .I Y="AM" S G=0 Q
 .I Y="LT" S G=0 Q
 .I Y["-" S G=0 Q
 .S Z=$$GET^DDSVAL(90002.01,X,.04,,"I")
 .I Z S Y=$P(^BCHTSERV(Z,0),U,3)
 .I Y="LT" S G=0 Q
 .I Y="AM" S G=0 Q
 .I Y="NF" S G=0 Q
 .I Y="OT" S G=0 Q
 .Q
 Q G
SETDEFNS ;
 NEW %
 S %=$$GET^DDSVAL(DIE,DA,.12)
 I %]"" Q
 NEW G S G=$$SETDEFNX(DA)
 D PUT^DDSVAL(DIE,DA,.12,G)
 Q
