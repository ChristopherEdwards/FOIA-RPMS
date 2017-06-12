APCDALVR ; IHS/CMI/LAB - V FILE CREATION ;
 ;;2.0;IHS PCC SUITE;**8,10**;MAY 14, 2009;Build 88
 ; Add entries to VISIT related files.
 ;
 ;  Upon exit if APCDAFLG exists it means:
 ;    Value=1    Invalid TEMPLATE specification
 ;    Value=2    VISIT DFN incorrect or ^DIE rejected data
 ;
EN ;PEP - called to create PCC V File entries
 K APCDALVR("APCDAFLG"),APCDDUZO
 NEW (U,DT,IO,DTIME,DUZ,APCDALVR,ZTQUEUED,BLRLINK,ADGPMADT,XQORS)  ;5/12/05 IHS/CMI/LAB added XQORS per Christy Smith, Daou
 ;Exception granted by SACC for unargumented NEW command
 I DUZ(0)'["M"&(DUZ(0)'="@") S APCDDUZO=DUZ(0),DUZ(0)=DUZ(0)_"M"
 S APCDX="" F APCDL=0:0 S APCDX=$O(APCDALVR(APCDX)) Q:APCDX=""  S @APCDX=APCDALVR(APCDX)
 K APCDAFLG
 S APCDADFN="",APCDAVF=""
 S:'$D(APCDAFLE) APCDAFLE=9000010
 I '$D(APCDVSIT) S APCDAFLG=2 G XIT
 I APCDVSIT'?1N.N S APCDAFLG=2 G XIT
 I '$D(^AUPNVSIT(APCDVSIT,0)) S APCDAFLG=2 G XIT
 ;I $P(^AUPNVSIT(APCDVSIT,0),U,11) S APCDAFLG=2 G XIT  ;deleted visit is invalid
 I $P(^AUPNVSIT(APCDVSIT,0),U,11) S $P(^AUPNVSIT(APCDVSIT,0),U,11)="",DA=APCDVSIT,DIK="^AUPNVSIT(" D IX1^DIK K DA,D0,DO,DIK,DIC,DICR,DIU,DIV,DG  ;reindex if visit is deleted, shouldn't happen, but does
 I $E(APCDATMP)'="["!($E(APCDATMP,$L(APCDATMP))'="]") S APCDAFLG=1 G XIT
 I '$D(^DIE("B",$P($E(APCDATMP,2,99),"]"))) S APCDAFLG=1 G XIT
 S:'$D(APCDPAT) APCDPAT=$P(^AUPNVSIT(APCDVSIT,0),U,5)
 S:$E(APCDPAT)="`" APCDPAT=$E(APCDPAT,2,99)
 S Y=APCDPAT D ^AUPNPAT
 S DIE=^DIC(APCDAFLE,0,"GL"),(DA,D0)=APCDVSIT,DR=APCDATMP
 S APCDOVRR=1 D ^DIE
 S:$D(Y)!((APCDADFN="")&(APCDATMP["(ADD)")) APCDAFLG=2
 I $D(APCDAFLG),APCDADFN,APCDAVF,APCDATMP["(ADD)" S DIK=^DIC(APCDAVF,0,"GL"),(DA,D0)=APCDADFN,APCDADFN="" D ^DIK K DIK,DR
XIT ; KILL VARIABLES AND QUIT
 ;I $D(APCDAFLG) S %AIHSERR="APCDALVR",$ZE="" D ^%ET
 I $D(APCDVFE) D VL
 I $D(APCDDUZO) S DUZ(0)=APCDDUZO K APCDDUZO
 ;I '$D(APCDAFLG) S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT ;IHS/CMI/LAB - see below **5**
 I '$D(APCDAFLG) S AUPNVSIT=APCDVSIT D MOD^AUPNVSIT,MODVF,SNOMED,LOINC D
 .Q:APCDATMP'[9000010.09
 .Q:$T(EN^BLSLX)=""
 .I APCDATMP["ADD",$G(APCDADFN) D EN^BLSLX(APCDADFN)
 .I APCDATMP["MOD",$G(APCDLOOK) D EN^BLSLX(APCDLOOK)
 .Q
 K Y
 S APCDALVR("APCDADFN")=APCDADFN,APCDALVR("APCDAVF")=APCDAVF S:$D(APCDAFLG) APCDALVR("APCDAFLG")=APCDAFLG
 K APCDAFLE,APCDATMP,APCDAVF,APCDDUZO
 Q
SNOMED ;
 S APCDVF=$P(APCDATMP,"APCDALVR ",2),APCDVF=$P(APCDVF," ",1)
 I APCDVF<9000010.01 Q
 I APCDVF>9000010.99 Q
 S APCDG=$G(^DIC(APCDVF,0,"GL"))
 I $G(APCDTSND)]"" D
 .;delete out these snomeds from 2601 field
 .F APCDP=1:1 S APCDV=$P(APCDTSND,U,APCDP) Q:APCDV=""  D
 ..S APCDVIGR=APCDG_APCDADFN_",26,"_"""B"",APCDV,0)"
 ..S DA=$O(@APCDVIGR)
 ..Q:'DA  ;didn't find it
 ..S DA(1)=APCDADFN
 ..S DIK=APCDG_APCDADFN_",26,"
 ..D ^DIK K DA,DIK
 I $G(APCDTSNO)]"" D
 .F APCDP=1:1 S APCDV=$P(APCDTSNO,U,APCDP) Q:APCDV=""  D
 ..S DA(1)=APCDADFN
 ..S X=APCDV
 ..S DIC=APCDG_DA(1)_",26," ;the root of the subfile for that entry
 ..S DIC(0)="L" ;LAYGO to the subfile is allowed
 ..S DIC("P")=$P(^DD(APCDVF,2601,0),"^",2) ;returns the subfile# and specifiers
 ..D ^DIC K DA,DIC
 Q
 ;
LOINC ;
 S APCDVF=$P(APCDATMP,"APCDALVR ",2),APCDVF=$P(APCDVF," ",1)
 I APCDVF<9000010.01 Q
 I APCDVF>9000010.99 Q
 S APCDG=$G(^DIC(APCDVF,0,"GL"))
 I $G(APCDTLDE)]"" D
 .;delete out these snomeds from 2601 field
 .F APCDP=1:1 S APCDV=$P(APCDTLDE,U,APCDP) Q:APCDV=""  D
 ..S APCDVIGR=APCDG_APCDADFN_",27,"_"""B"",APCDV,0)"
 ..S DA=$O(@APCDVIGR)
 ..Q:'DA  ;didn't find it
 ..S DA(1)=APCDADFN
 ..S DIK=APCDG_APCDADFN_",27,"
 ..D ^DIK K DA,DIK
 I $G(APCDTLOI)]"" D
 .F APCDP=1:1 S APCDV=$P(APCDTLOI,U,APCDP) Q:APCDV=""  D
 ..S DA(1)=APCDADFN
 ..S X=APCDV
 ..S DIC=APCDG_DA(1)_",27," ;the root of the subfile for that entry
 ..S DIC(0)="L" ;LAYGO to the subfile is allowed
 ..S DIC("P")=$P(^DD(APCDVF,2701,0),"^",2) ;returns the subfile# and specifiers
 ..D ^DIC K DA,DIC
 Q
MODVF ;
 NEW APCDVF,DIE,DR,DA
 S APCDVF=$P(APCDATMP,"APCDALVR ",2),APCDVF=$P(APCDVF," ",1)
 I APCDVF<9000010.01 Q
 I APCDVF>9000010.99 Q
 Q:'APCDADFN
 I APCDATMP["ADD" S DIE=APCDVF,DR="1216////"_$$NOW^XLFDT,DA=APCDADFN D ^DIE
 I APCDATMP["MOD" S DIE=APCDVF,DR="1218////"_$$NOW^XLFDT,DA=APCDADFN D ^DIE
 Q
VL ;EP - create v line item entries if appropriate
 ;not yet ready
 Q
 S APCDFILE=$P($P(APCDALVR("APCDATMP")," ",2)," ")
 S APCDMODE=$E($P(APCDALVR("APCDATMP")," ",3))
 D @$P(APCDFILE,".",2)
 Q
 ;
DEL(DIK,DA) ;PEP - DELETE ONE V FILE ENTRY
 ;
 ; Meaning of returned values are:
 ;    0 = v file entry deleted
 ;    1 = data global invalid
 ;    2 = no 0th node for data global
 ;    3 = specified file is not a v file
 ;    4 = specified entry is not in specified v file
 ;
 NEW (DA,DIK,DT,DTIME,DUZ,U)
 ;Exception granted by SACC for exclusive NEW command
 ;
 S:DIK DIK=$G(^DIC(DIK,0,"GL")) ;    get data gbl if file #
 I DIK'?1"^".E1"(".E Q 1  ;          data gbl invalid
 S X=$E(DIK,$L(DIK)) ;               get last chr of gbl
 I X'="(",X'="," Q 1  ;              data gbl invalid
 I '$D(@(DIK_"0)")) Q 2  ;           no 0th node for data gbl
 S X=+$P(@(DIK_"0)"),U,2) ;          get file #
 I $P(X,".")'=9000010 Q 3  ;         not a v file
 I X=9000010 Q 3  ;                  not a v file
 I '$D(@(DIK_DA_",0)")) Q 4  ;       entry not in v file
 D ^DIK ;                            delete v file entry
 Q 0
 ;
LABC(LVIEN,LCOM)   ;-- stuff v lab comments
 I '$D(^AUPNVLAB(LVIEN,0)) S APCDALVR("APCDAFLG")="1^No V Lab Entry"
 I '$O(LCOM("")) S APCDALVR("APCDAFLG")="1^No Comments Passed In"
 S APCDCDA=0 F  S APCDCDA=$O(LCOM(APCDCDA)) Q:'APCDCDA  D
 . S APCDLCOM=$G(LCOM(APCDCDA))
 . K DD,DO
 . S DIC="^AUPNVLAB("_LVIEN_",21,",DIC(0)="L",DA(1)=LVIEN
 . S DIC("P")=$P(^DD(9000010.09,2100,0),U,2),X=APCDLCOM
 . D FILE^DICN
 . I +Y<0 S APCDALVR("APCDAFLG")="1^Error Adding Entry to V Lab"
 I $G(APCDALVR("APCDAFLG")) Q APCDALVR("APCDAFLG")
 Q ""
 ;
