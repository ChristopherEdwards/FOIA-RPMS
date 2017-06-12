BGOSNOPR ; IHS/BAO/TMD - SNOMED PREFERENCES MANAGER ;19-Apr-2016 11:50;du
 ;;1.1;BGO COMPONENTS;**13,14,19,20**;Mar 20, 2007;Build 1
 ; Return categories matching specified criteria
 ;  INP = Category IEN [1] ^ Hospital Location IEN [2] ^ Provider IEN [3] ^ Manager IEN [4] ^ Show All [5]
GETCATS(RET,INP) ;EP
 N ARRAY,X,I,DEFAULT
 S RET=$$TMPGBL
 D GETCATS^BGOPFUTL(.ARRAY,INP,90362.34)
 ;Get the default
 S DEFAULT=$$GET^XPAR("ALL","BGO DEFAULT PICKLIST")
 S I=1
 S X=0 F  S X=$O(@ARRAY@(X)) Q:X=""  D
 .I $P($G(@ARRAY@(X)),U,2)=DEFAULT S @RET@(1)=$G(@ARRAY@(X))_U_1 Q
 .E  S I=I+1
 .S @RET@(I)=$G(@ARRAY@(X))
 K ARRAY
 Q
 ; Returns list of SNOMEDS for specified category
 ;  INP = Category IEN [1] ^ Descriptor [2] ^ Display Freq Order [3]
 ;  Returns list of records in the format
 ;  IEN[1] ^ Narrative [2] ^ DESCT CT [3] ^ CONCEPT CT [4] ^ Status [5] ^ Freq [6]
 ;  ^ Rank [7] ^ Pref IEN [8] ^ Qualifier string [9] ^ group [10] ^ Laterality flag [11]
GETITEMS(RET,INP) ;EP
 N PX,I,J,FREQ,VIEN,GRP,CAT,LONG,VPX,FREQ,CNT,RANK,IEN
 S RET=$$TMPGBL^BGOUTL
 S CAT=+INP
 I 'CAT S @RET@(1)=$$ERR^BGOUTL(1018) Q
 I '$D(^BGOSNOPR(CAT,0)) S @RET@(1)=$$ERR^BGOUTL(1019) Q
 S GRP=$P(INP,U,2)
 S FREQ=$P(INP,U,3)
 S:$P(^BGOSNOPR(CAT,0),U,6) GRP=""
 S (CNT,RANK)=0
 I FREQ D
 .S J=""
 .F  S J=$O(^BGOSNOPR(CAT,1,"AC",J),-1) Q:J=""  D
 ..S IEN=0
 ..F  S IEN=$O(^BGOSNOPR(CAT,1,"AC",J,IEN)) Q:'IEN  D GD1
 E  D
 .S IEN=0
 .F  S IEN=$O(^BGOSNOPR(CAT,1,IEN)) Q:'IEN  D GD1
 Q
GD1 ;Get fields
 N N0,SNOCT,DESCT,NARR,TXT,DX,FREQVAL,CODE,OPEN,QUAL,QUALCT,QUALT,QSTR
 N STATUS,GROUP,PREF,PREFNAR,ICD,LAT,IN,ICDFLD,I1,CODE,Z1,X
 S QSTR=""
 S N0=$G(^BGOSNOPR(CAT,1,IEN,0))
 S SNOCT=+N0
 Q:'SNOCT
 ;IHS/MSC/MGH Changed to use new API
 ;Patch 20
 K VAR
 ;Patch 20 changes to only do 1 lookup
 S DESCT=$P(N0,U,2)
 S X=$$DSCLKP^BSTSAPI("VAR",DESCT_"^^1")
 S NARR=$G(VAR(1,"PRB","TRM"))
 S PREFNAR=$G(VAR(1,"PRE","TRM"))
 S ICD="",I1=0
 F  S I1=$O(VAR(1,"ICD",I1)) Q:'+I1  D
 .S ICD=ICD_$S(ICD]"":"|",1:"")_$G(VAR(1,"ICD",I1,"COD"))
 S STATUS=$P(N0,U,6)
 S TXT=$P($G(^BGOSNOPR(CAT,1,IEN,1)),U,1)
 S FREQVAL=$P(N0,U,3)
 S GROUP=$P($G(^BGOSNOPR(CAT,1,IEN,1)),U,2)
 ;IHS/MSC/MGH add laterality flag to list
 S IN=DESCT_U_"EHR IPL PROMPT FOR LATERALITY"_U_U_1
 ;S LAT=$$VSBTRMF^BSTSAPI(IN)
 S LAT=$G(VAR(1,"LAT"))
 I FREQ D
 .S RANK=RANK+1
 .S RANK=$S(RANK<10:"00",RANK<100:"0",1:"")_RANK
 S QUAL=0 F  S QUAL=$O(^BGOSNOPR(CAT,1,IEN,2,QUAL)) Q:QUAL=""  D
 .S QUALCT=$P($G(^BGOSNOPR(CAT,1,IEN,2,QUAL,0)),U,1),QUALT=$P($G(^BGOSNOPR(CAT,1,IEN,2,QUAL,0)),U,2)
 .S QSTR=$S(QSTR="":QUALCT_"|"_QUALT,1:QSTR_"~"_QUALCT_"|"_QUALT)
 S CNT=CNT+1
 S @RET@(CNT)=IEN_U_NARR_U_DESCT_U_SNOCT_U_STATUS_U_FREQVAL_U_TXT_U_RANK_U_QSTR_U_GROUP_U_PREFNAR_U_ICD_U_LAT
 Q
 ; Return list of managers associated with a specified category
GETMGRS(RET,CAT) ;EP
 D GETMGRS^BGOPFUTL(.RET,CAT,90362.34)
 Q
 ; Set category fields
 ;  INP = Name [1] ^ Hosp Loc [2] ^ Clinic [3] ^ Provider [4] ^ User [5] ^ Category IEN [6] ^ Delete [7] ^ Discipline [8]
SETCAT(RET,INP) ;EP
 D SETCAT^BGOPFUTL(.RET,INP,90362.34)
 Q
 ; Add or remove a manager from a category
 ;  INP = Category IEN [1] ^ Manager IEN [2] ^ Add [3]
SETMGR(RET,INP) ;EP
 D SETMGR^BGOPFUTL(.RET,INP,90362.343)
 Q
 ; Set Provider Text for a preference
 ;  INP = Category IEN [1] ^ Item IEN [2] ^ Display Name [3]
 ;  SFN = Item subfile #
SETNAME(RET,INP,FIELD) ;EP
 N ITM,CAT,NAME,FDA
 S SFN=90362.342
 S CAT=+INP
 I 'CAT S RET=$$ERR^BGOUTL(1018) Q
 S ITM=$P(INP,U,2)
 I 'ITM S RET=$$ERR^BGOUTL(1033) Q
 S NAME=$P(INP,U,3)
 I NAME="" S RET=$$ERR^BGOUTL(1034) Q
 S FDA(SFN,ITM_","_CAT_",",FIELD)=NAME
 S RET=$$UPDATE^BGOUTL(.FDA)
 Q
 ; Set frequency for an item
 ;  INP = Category IEN [1] ^ SNOMED CT [2] ^ Increment [3] ^ Frequency [4]
SETFREQ(RET,INP) ;EP
 D SETFREQ^BGOPFUTL(.RET,INP,90362.342) ;EP
 Q
 ; Set field values for a SNOMED preference entry
 ;  INP = Category IEN [1] ^ SNOMED CT [2] ^ DESC CT [3] ^ Status [4] ^ Frequency [5] ^
 ;        Group [6] ^ Item IEN [7] ^ Delete [8]
SETITEM(RET,INP) ;EP
 N CAT,SNO,DESCT,DEL,NEW,IEN,FREQ,DUP,ITEM,FDA,GBL,FNUM,X,Y,GRP,PREF
 S RET=""
 S CAT=+INP
 S FNUM=90362.34
 S NEW=""
 I 'CAT S RET=$$ERR^BGOUTL(1018) Q
 S SNO=$P(INP,U,2)
 I SNO="" S RET="-1^No Concept CT sent in call"
 ;IHS/MSC/MGH changed to use new API
 ;S X=$$CONC^BSTSAPI(SNO_"^^^1")
 S X=$$CONC^AUPNSICD(SNO_"^^^1")
 S PREF=$P(X,U,3)
 S DESCT=$P(INP,U,3)
 I DESCT="" S DESCT=PREF
 S Y=$$DESC^BSTSAPI(DESCT_"^^1")
 S TXT=$P(Y,U,2)
 I DESCT="" S RET="-1^Snomed not valid"
 I TXT="" S RET="-1^Snomed not valid"
 Q:RET=-1
 S STAT=$P(INP,U,4)
 ;MSC/MGH Patch 20
 I STAT="" S STAT=$P(X,U,9)
 S STAT=$S(STAT="Chronic":"A",STAT="Inactive":"I",STAT="Sub-acute":"S",STAT="Episodic":"E",STAT="Social/Environmental":"O",STAT="Routine/Admin":"R",STAT="Admin":"R",STAT="Personal History":"P",1:STAT)
 S FREQ=+$P(INP,U,5)
 S GRP=$P(INP,U,6)
 S ITEM=$P(INP,U,7)
 I '+ITEM S NEW=1           ;P19
 S DEL=$P(INP,U,8)
 I DEL D
 .N DA,SFN
 .S RET=$$GBLROOT^BGOPFUTL(FNUM,,.SFN)
 .S:'RET RET=$$ITEMROOT^BGOPFUTL(SFN,CAT,.GBL,1)
 .Q:RET
 .S DA(1)=CAT,DA=ITEM
 .S RET=$$DELETE^BGOUTL(GBL,.DA)
 E  D
 .S RET=$$GBLROOT^BGOPFUTL(FNUM,.GBL)
 .;D:RET'<0 @("VALIDATE"_GBL_"(.RET,.PTR,CODE)")
 .S:RET'<0 RET=$$UPDITEM(FNUM,CAT,SNO,DESCT,STAT,FREQ,TXT,NEW,GRP,.IEN,ITEM,PREF)
 .S:RET'<0 RET=IEN
 Q
 ; Update a category's item entry
 ;  FNUM = Preference file #
 ;  CAT  = Category IEN
 ;  SNO  = Snomed CT
 ;  DESCT= Desc CT
 ;  STAT = Status
 ;  CNT  = Item count (or "+n" to increment existing count) (optional)
 ;  TXT  = Text of DESC CT (optional)
 ;  NEW  = If true, force creation of new entry (optional, default=false)
 ;  GRP  = Group for this item
 ; .ITM  = Returned value of item IEN
 ;  Return value is 0 if success, or -1^error text
UPDITEM(FNUM,CAT,SNO,DESCT,STAT,CNT,TXT,NEW,GRP,ITM,ITEM,PREF) ;EP
 N FDA,IEN,GBL,SFN,RET
 S RET=$$GBLROOT^BGOPFUTL(FNUM,.GBL,.SFN)
 Q:RET RET
 ;S ITM=$S($G(NEW):0,1:$O(@GBL@(CAT,1,"B",SNO,0)))
 S ITM=$S($G(NEW):0,$G(ITEM):ITEM,1:$O(@GBL@(CAT,1,"B",SNO,0)))
 S:$E($G(CNT))="+" CNT=$S(ITM:$P(@GBL@(CAT,1,ITM,0),U,3),1:0)+CNT
 S FDA=$NA(FDA(SFN,$S(ITM:ITM,1:"+1")_","_CAT_","))
 S @FDA@(.01)=SNO
 S @FDA@(.02)=DESCT
 S:$D(CNT) @FDA@(.03)=CNT
 S @FDA@(.06)=STAT
 S @FDA@(.04)=$$NOW^XLFDT
 S @FDA@(.07)=PREF
 S:$D(TXT) @FDA@(6)=$TR(TXT,";",",")
 S:$D(GRP) @FDA@(7)=GRP
 S RET=$$UPDATE^BGOUTL(.FDA,"@",.IEN)
 I 'RET,'ITM S ITM=IEN(1)
 Q RET
TMPGBL(X) ;EP
 K ^TMP("BGOPICK",$J) Q $NA(^($J))
