BGOPFUTL ; MSC/IND/DKM - Preference Management ;20-Jul-2007 09:59;DKM
 ;;1.1;BGO COMPONENTS;**3**;Mar 20, 2007
 ; Add or remove a manager from a category
 ;  INP = Category IEN [1] ^ Manager IEN [2] ^ Add [3]
 ;  SFN = Item subfile #
SETMGR(RET,INP,SFN) ;EP
 N CAT,MGR,ADD,FDA,GBL
 I $G(INP)="" S RET=$$ERR^BGOUTL(1008) Q
 S CAT=+INP
 I 'CAT S RET=$$ERR^BGOUTL(1018) Q
 S MGR=$P(INP,U,2)
 I 'MGR S RET=$$ERR^BGOUTL(1031) Q
 S ADD=$P(INP,U,3)
 I ADD="" S RET=$$ERR^BGOUTL(1032) Q
 S RET=$$ITEMROOT(SFN,CAT,.GBL)
 Q:RET
 I '$D(@GBL@(MGR,0))'='ADD D
 .S FDA(SFN,$S(ADD:"+1",1:MGR)_","_CAT_",",.01)=$S(ADD:"`"_MGR,1:"@")
 .S RET=$$UPDATE^BGOUTL(.FDA,"E")
 Q
 ; Set display name for a preference
 ;  INP = Category IEN [1] ^ Item IEN [2] ^ Display Name [3]
 ;  SFN = Item subfile #
SETNAME(RET,INP,SFN) ;EP
 N ITM,CAT,NAME,FDA
 S CAT=+INP
 I 'CAT S RET=$$ERR^BGOUTL(1018) Q
 S ITM=$P(INP,U,2)
 I 'ITM S RET=$$ERR^BGOUTL(1033) Q
 S NAME=$P(INP,U,3)
 I NAME="" S RET=$$ERR^BGOUTL(1034) Q
 S FDA(SFN,ITM_","_CAT_",",.02)=NAME
 S RET=$$UPDATE^BGOUTL(.FDA)
 Q
 ; Set frequency for a CPT code
 ;  INP = Category IEN [1] ^ Item Value (defaults to all) [2] ^ Increment [3] ^ Frequency [4]
 ;  SFN = Item subfile #
SETFREQ(RET,INP,SFN) ;EP
 N CAT,CNT,ITM,VAL,INC,DA,FDA,GBL
 S RET=""
 S CAT=+INP
 I 'CAT S RET=$$ERR^BGOUTL(1018) Q
 S ITM=$P(INP,U,2)
 S INC=+$P(INP,U,3)
 S VAL=$P(INP,U,4)
 S RET=$$ITEMROOT(SFN,CAT,.GBL)
 Q:RET
 I ITM="" D
 .F  S ITM=$O(@GBL@("B",ITM)) Q:'$L(ITM)  D SF1 Q:RET
 E  D SF1
 S:'RET RET=$$UPDATE^BGOUTL(.FDA)
 Q
SF1 S DA=$O(@GBL@("B",ITM,0))
 I 'DA S RET=$$ERR^BGOUTL(1035) Q
 I $L(VAL) S CNT=+VAL
 E  S CNT=$P(@GBL@(DA,0),U,3)+INC
 S FDA(SFN,DA_","_CAT_",",.03)=$S(CNT>0:CNT,1:0)
 Q
 ; Return global root and item subfile # for a file
 ;  FNUM = Preference file #
 ; .GBL  = Returned global root
 ; .SFN  = Returned item subfile #
 ;  Return value is null if success, or -1^error text
GBLROOT(FNUM,GBL,SFN) ;
 S GBL=$$ROOT^DILFD(FNUM,,1)
 Q:GBL="" $$ERR^BGOUTL(1036)
 D FIELD^DID(FNUM,1,,"SPECIFIER","SFN")
 S SFN=+$G(SFN("SPECIFIER"))
 K SFN("SPECIFIER")
 Q:'SFN $$ERR^BGOUTL(1037)
 Q ""
 ; Return global root for item subfile
 ;  SFN = Item subfile #
 ;  CAT = Category IEN
 ; .GBL = Returned global root
 ;  OPN = Return open root (default=closed)
 ;  Return value is null if success, or -1^error text
ITEMROOT(SFN,CAT,GBL,OPN) ;
 S GBL=$$ROOT^DILFD(SFN,","_CAT_",",'$G(OPN))
 Q:GBL="" $$ERR^BGOUTL(1036)
 Q ""
 ; Clone a category
 ;  INP = Source Category IEN ^ Target Category IEN
 ;  FNUM = Preference file #
CLONE(RET,INP,FNUM) ;EP
 N FROM,TO,ITM,SFN,GBL
 K RET
 S RET=$$GBLROOT(FNUM,.GBL,.SFN)
 Q:RET
 I $G(INP)="" S RET=$$ERR^BGOUTL(1008) Q
 S FROM=+INP
 I 'FROM S RET=$$ERR^BGOUTL(1038) Q
 I '$D(@GBL@(FROM,0)) S RET=$$ERR^BGOUTL(1039) Q
 S TO=$P(INP,U,2)
 I 'TO S RET=$$ERR^BGOUTL(1040) Q
 I '$D(@GBL@(TO,0)) S RET=$$ERR^BGOUTL(1041) Q
 S ITM=0
 F  S ITM=$O(@GBL@(FROM,1,ITM)) Q:'ITM  D  Q:RET
 .N FDA,X
 .Q:$O(@GBL@(TO,1,"B",ITM,0))
 .S X=@GBL@(FROM,1,ITM,0)
 .S FDA=$NA(FDA(SFN,"+1,"_TO_","))
 .S @FDA@(.01)=+X
 .S @FDA@(.03)=$P(X,U,3)
 .S RET=$$UPDATE^BGOUTL(.FDA,"@")
 Q
 ; Check a visit for a specific provider or provider class
 ;  VIEN = Visit IEN
 ;  PRV  = Provider IEN (optional)
 ;  CLS  = Provider Class IEN (optional)
 ;  Returns true if visit contains a matching provider or provider class
VISPRCL(VIEN,PRV,CLS) ;EP
 N X,RET
 S (X,RET)=0
 F  S X=$O(^AUPNVPRV("AD",VIEN,X)) Q:'X  D  Q:RET
 .S PRV2=$P($G(^AUPNVPRV(X,0)),U)
 .Q:'PRV2
 .I PRV,PRV'=PRV2 Q
 .I CLS,$P($G(^VA(200,PRV2,"PS")),U,5)'=CLS Q
 .S RET=1
 Q RET
 ; Update a category's item entry
 ;  FNUM = Preference file #
 ;  CAT  = Category IEN
 ;  PTR  = Item pointer
 ;  CNT  = Item count (or "+n" to increment existing count) (optional)
 ;  TXT  = Item display text (optional)
 ;  NEW  = If true, force creation of new entry (optional, default=false)
 ; .ITM  = Returned value of item IEN
 ;  Return value is 0 if success, or -1^error text
UPDITEM(FNUM,CAT,PTR,CNT,TXT,NEW,ITM) ;EP
 N FDA,IEN,GBL,SFN,RET
 S RET=$$GBLROOT(FNUM,.GBL,.SFN)
 Q:RET RET
 S ITM=$S($G(NEW):0,1:$O(@GBL@(CAT,1,"B",PTR,0)))
 S:$E($G(CNT))="+" CNT=$S(ITM:$P(@GBL@(CAT,1,ITM,0),U,3),1:0)+CNT
 S FDA=$NA(FDA(SFN,$S(ITM:ITM,1:"+1")_","_CAT_","))
 S @FDA@(.01)=PTR
 S:$D(CNT) @FDA@(.03)=CNT
 S:$D(TXT) @FDA@(.02)=$TR(TXT,";",",")
 S RET=$$UPDATE^BGOUTL(.FDA,"@",.IEN)
 I 'RET,'ITM S ITM=IEN(1)
 Q RET
 ; Return categories matching specified criteria
 ;  INP = Category IEN [1] ^ Hospital Location IEN [2] ^ Provider IEN [3] ^ Manager IEN [4] ^ Show All [5] ^
 ;        Historical Flag (CPT pref only) [6]
 ;  FNUM = Preference file #
 ;  Returns a list of records in the format:
 ;   Category Name [1] ^ Category IEN [2] ^ Hosp Loc Name [3] ^ Hosp Loc IEN [4] ^
 ;   Clinic Stop Name [5] ^ Clinic Stop IEN [6] ^ Provider Name [7] ^ Provider IEN [8] ^
 ;   Owner Name [9] ^ Owner IEN [10] ^ Provider Class Name [11] ^ Provider Class IEN [12]
GETCATS(RET,INP,FNUM) ;EP
 N CATIEN,CATNAME,PRVIEN,MGRIEN,SHOWALL,CAT,DISCIEN
 N CLNIEN,HLIEN,PRVIEN,HIST,PRI,CNT,GBL,X0,X
 S RET=$$TMPGBL^BGOUTL
 S X=$$GBLROOT(FNUM,.GBL)
 I X S @RET@(1)=X Q
 S CATIEN=$P(INP,U)
 S HLIEN=$P(INP,U,2)
 S PRVIEN=$P(INP,U,3)
 S MGRIEN=$P(INP,U,4)
 S SHOWALL=$P(INP,U,5)
 S HIST=$S(FNUM=90362.31:+$P(INP,U,6),1:2)
 S:SHOWALL!(HIST=1) (CATIEN,HLIEN,PRVIEN,MGRIEN)=0
 S (PRI,CNT)=0
 I CATIEN D  Q
 .D GC1
 S CLNIEN=$S(HLIEN:$P($G(^SC(HLIEN,0)),U,7),1:"")
 S DISCIEN=$S(PRVIEN:$P($G(^VA(200,PRVIEN,"PS")),U,5),1:"")
 S CATNAME=""
 F  S CATNAME=$O(@GBL@("B",CATNAME)) Q:CATNAME=""  D
 .S CATIEN=$O(@GBL@("B",CATNAME,0))
 .Q:'CATIEN
 .S X0=$G(@GBL@(CATIEN,0))
 .I HIST=1,'$P(X0,U,7) Q
 .I 'HIST,$P(X0,U,7) Q
 .S PRI=3
 .I HLIEN,$P(X0,U,2) D  Q:PRI=-1
 ..I $P(X0,U,2)'=HLIEN S PRI=-1
 ..E  S PRI=1
 .I CLNIEN,$P(X0,U,3) D  Q:PRI=-1
 ..I $P(X0,U,3)'=CLNIEN S PRI=-1
 ..E  S PRI=2
 .I PRVIEN,$P(X0,U,4) D  Q:PRI=-1
 ..I $P(X0,U,4)'=PRVIEN S PRI=-1
 ..E  S PRI=0
 .I DISCIEN,$P(X0,U,6) D  Q:PRI=-1
 ..I $P(X0,U,6)'=DISCIEN S PRI=-1
 ..E  S PRI=4
 .I MGRIEN,'$D(@GBL@(CATIEN,2,MGRIEN)),$P(X0,U,5)'=MGRIEN Q
 .D GC1
 Q
GC1 N X0,CAT,HL,CL,PRV,OWN,DISC
 S X0=$G(@GBL@(CATIEN,0))
 Q:'$L(X0)
 S CAT=$P(X0,U)_U_CATIEN
 S HL=$P(X0,U,2)
 S HL=$P($G(^SC(+HL,0)),U)_U_HL
 S CL=$P(X0,U,3)
 S CL=$P($G(^DIC(40.7,+CL,0)),U)_U_CL
 S PRV=$P(X0,U,4)
 S PRV=$P($G(^VA(200,+PRV,0)),U)_U_PRV
 S OWN=$P(X0,U,5)
 S OWN=$P($G(^VA(200,+OWN,0)),U)_U_OWN
 S DISC=$P(X0,U,6)
 S DISC=$P($G(^DIC(7,+DISC,0)),U)_U_DISC
 S CNT=CNT+1
 S @RET@(PRI*1000000+CNT)=CAT_U_HL_U_CL_U_PRV_U_OWN_U_DISC
 Q
 ; Return list of managers associated with a specified category
 ;  CAT  = Category IEN
 ;  FNUM = Preference file IEN
 ;  Returns a list of records in the format:
 ;    Provider Name ^ Provider IEN
GETMGRS(RET,CAT,FNUM) ;EP
 N PRV,CNT,GBL,X
 K RET
 S X=$$GBLROOT(FNUM,.GBL)
 I X S RET(1)=X Q
 I 'CAT S RET(1)=$$ERR^BGOUTL(1018) Q
 I '$D(@GBL@(CAT,0)) S RET(1)=$$ERR^BGOUTL(1019) Q
 S (CNT,PRV)=0
 F  S PRV=$O(@GBL@(CAT,2,PRV)) Q:'PRV  D
 .Q:'$D(@GBL@(CAT,2,PRV,0))
 .Q:'$D(^VA(200,PRV,0))
 .S CNT=CNT+1,RET(CNT)=$P(^VA(200,PRV,0),U)_U_PRV
 Q
 ; Set category fields
 ;  INP  = Name [1] ^ Hosp Loc [2] ^ Clinic [3] ^ Provider [4] ^ User [5] ^ Category IEN [6] ^ Delete [7] ^ Discipline [8]
 ;  FNUM = Preference file IEN
SETCAT(RET,INP,FNUM) ;EP
 N NAME,HLOC,CLN,PRV,USR,IEN,DEL,DDG,DIC,DA,DIE,DR,Y,X,DISC,GBL
 K RET
 S RET=$$GBLROOT(FNUM,.GBL)
 Q:RET
 S NAME=$P(INP,U)
 S HLOC=$P(INP,U,2)
 S CLN=$P(INP,U,3)
 S PRV=$P(INP,U,4)
 S USR=$P(INP,U,5)
 S IEN=$P(INP,U,6)
 S DEL=$P(INP,U,7)
 S DISC=$P(INP,U,8)
 I DEL D  Q
 .S RET=$$DELETE^BGOUTL(FNUM,IEN)
 I NAME="" S RET=$$ERR^BGOUTL(1007) Q
 I IEN,USR'=DUZ S RET=$$ERR^BGOUTL(1042) Q
 I 'IEN D  Q:RET
 .S IEN=$O(@GBL@("B",NAME,0))
 .I IEN,USR'=DUZ S RET=$$ERR^BGOUTL(1043)
 S FDA=$NA(FDA(FNUM,$S(IEN:IEN_",",1:"+1,")))
 S @FDA@(.01)=NAME
 S @FDA@(.02)=HLOC
 S @FDA@(.03)=CLN
 S @FDA@(.04)=PRV
 S @FDA@(.05)=USR
 S @FDA@(.06)=DISC
 S RET=$$UPDATE^BGOUTL(.FDA,"@",.X)
 I 'RET,'IEN S IEN=X(1)
 S:'RET RET=IEN
 Q
 ; Set field values for an item entry
 ;  INP =  Category IEN [1] ^ Item Pointer [2] ^ Display Text [3] ^ Delete [4] ^ Item Code [5] ^ Frequency [6] ^
 ;         Allow Dups [7] ^ Item IEN [8]
 ;  FNUM = Preference file #
SETITEM(RET,INP,FNUM) ;EP
 N CAT,PTR,TXT,DEL,IEN,CODE,FREQ,DUP,ITEM,FDA,GBL
 S CAT=+INP
 I 'CAT S RET=$$ERR^BGOUTL(1018) Q
 S PTR=$P(INP,U,2)
 S TXT=$P(INP,U,3)
 S DEL=$P(INP,U,4)
 S CODE=$P(INP,U,5)
 S FREQ=+$P(INP,U,6)
 S DUP=+$P(INP,U,7)
 S ITEM=$P(INP,U,8)
 I DEL D
 .N DA,SFN
 .S RET=$$GBLROOT(FNUM,,.SFN)
 .S:'RET RET=$$ITEMROOT(SFN,CAT,.GBL,1)
 .Q:RET
 .S DA(1)=CAT,DA=ITEM
 .S RET=$$DELETE^BGOUTL(GBL,.DA)
 E  D
 .S RET=$$GBLROOT(FNUM,.GBL)
 .D:RET'<0 @("VALIDATE"_GBL_"(.RET,.PTR,CODE)")
 .S:RET'<0 RET=$$UPDITEM(FNUM,CAT,PTR,FREQ,TXT,DUP,.IEN)
 .S:RET'<0 RET=IEN
 Q
 ; Initialize a query
QRYINIT(FNUM,CAT) ;EP
 L +^XTMP("BGO QUERY",FNUM,CAT):0
 Q:'$T $$ERR^BGOUTL(1044)
 K ^XTMP("BGO QUERY",FNUM,CAT) S ^(CAT)=0
 Q ""
 ; Add output to a query
QRYADD(FNUM,CAT,VAL,TXT) ;EP
 S:VAL ^(CAT)=$G(^XTMP("BGO QUERY",FNUM,CAT))+1,^(VAL)=$G(^(CAT,VAL))+1,^(VAL,0)=$G(TXT)
 Q
 ; Finish a query
QRYDONE(FNUM,CAT) ;EP
 N VAL,CNT,TXT,RET
 S VAL=0,RET=""
 F  S VAL=$O(^XTMP("BGO QUERY",FNUM,CAT,VAL)) Q:'VAL  S CNT=^(VAL),TXT=$G(^(VAL,0)) D  Q:RET
 .K:'$L(TXT) TXT
 .S RET=$$UPDITEM^BGOPFUTL(FNUM,CAT,VAL,"+"_CNT,.TXT)
 S CNT=^XTMP("BGO QUERY",FNUM,CAT) K ^(CAT)
 L -^XTMP("BGO QUERY",FNUM,CAT)
 Q CNT
