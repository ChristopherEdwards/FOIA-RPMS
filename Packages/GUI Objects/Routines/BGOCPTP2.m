BGOCPTP2 ; IHS/BAO/TMD - CPT PREFERENCES MANAGER-2 ;06-Jan-2016 10:13;du
 ;;1.1;BGO COMPONENTS;**1,3,4,5,11,12,14,19**;Mar 20, 2007;Build 5
 ;
 ; Returns list of assocs for specified category and item
 ;  INP = Category IEN ^ Item IEN
 ;  Returned as a list of records in the format:
 ;   Item IEN [1] ^ Item Name [2] ^ Type [3] ^ Auto Add [4] ^ Auto Default [5] ^
 ;   No Dups [6] ^ Amount [7] ^ Association IEN [8] ^ Quantity [9] ^ Code [10] ^ ID [11]
GETASSOC(RET,INP) ;EP
 N ITEM,TYP,GBL,N0,ITEMIEN,CAT,CNT,IEN,AUTO,DFLT,NODUP,AMT,ITEMNAME,QTY,CODE,CPT,NAR,ID,P,X
 S RET=$$TMPGBL^BGOUTL
 S CAT=+INP
 S ITEM=+$P(INP,U,2)
 I 'CAT!'ITEM S @RET@(1)=$$ERR^BGOUTL(1008) Q
 S CNT=0
 I '$D(^BGOCPTPR(CAT,0)) S @RET@(1)=$$ERR^BGOUTL(1009) Q
 S N0=$G(^BGOCPTPR(CAT,1,ITEM,0)),CPT=$P(N0,U),NAR=$P(N0,U,2)
 I 'CPT S @RET@(1)=$$ERR^BGOUTL(1010) Q
 I '$O(^BGOCPTPR(CAT,1,ITEM,1,0)) D  Q:X<0
 .D SETASSOC(.X,CAT_U_ITEM_"^CPT^"_CPT_"^^1^^1")
 .S:X<0 @RET@(1)=X
 S IEN=0
 F  S IEN=$O(^BGOCPTPR(CAT,1,ITEM,1,IEN)) Q:'IEN  D
 .S N0=$G(^BGOCPTPR(CAT,1,ITEM,1,IEN,0))
 .S X=$P(N0,U)
 .S ITEMIEN=+X
 .Q:'ITEMIEN
 .S TYP=$P(X,";",2)
 .Q:TYP=""
 .I TYP="DIC(81.3" S TYP2="DIC(81.3"_","
 .E  S TYP2=TYP
 .S GBL=U_TYP2_ITEMIEN_",0)"
 .S X=$G(@GBL)
 .Q:'$L(X)
 .I ITEMIEN=CPT,TYP="ICPT(",$L(NAR) S $P(X,U,2)=NAR,CPT=0
 .S P=$$TYPECVT(TYP,1,3)
 .I TYP="DIC(81.3," S P=$$TYPECVT(TYP,1,3)
 .;Changes made for AICD version 4.0 and Patch 14
 .I TYP="ICD9(" D ICD(X,N0) Q
 .I TYP="ICD0(" D ICD0(X,N0) Q
 .E  S ITEMNAME=$P(X,U,P)
 .I TYP="AUTTEDT(" D
 ..I $P($G(^AUTTEDT(ITEMIEN,0)),U,12)'="" D
 ...N TXT,SNO,IN,X
 ...S TXT=""
 ...S SNO=$P($G(^AUTTEDT(ITEMIEN,0)),U,12)
 ...;IHS/MSC/MGH Changed to use new API p14
 ...S IN=SNO_"^^^1"
 ...;S X=$$CONC^BSTSAPI(IN)
 ...S X=$$CONC^AUPNSICD(IN)
 ...S TXT=$P(X,U,4)
 ...S ITEMNAME=TXT_"-"_$P($P($G(^AUTTEDT(ITEMIEN,0)),U,1),"-",2)
 .;End changes
 .S P=$$TYPECVT(TYP,1,4)
 .S CODE=$P(X,U,P)
 .S AUTO=$P(N0,U,2)
 .S DFLT=$P(N0,U,3)
 .S NODUP=$P(N0,U,4)
 .S AMT=$P(N0,U,5)
 .S QTY=$P(N0,U,7)
 .S ID=$$TYPECVT(TYP,1,5)
 .S TYP=$$TYPECVT(TYP,1,2)
 .S CNT=CNT+1
 .S @RET@(CNT)=ITEMIEN_U_ITEMNAME_U_TYP_U_AUTO_U_DFLT_U_NODUP_U_AMT_U_IEN_U_QTY_U_CODE_U_ID_U_""
 Q
ICD(X,N0) ;Lookup ICD diagnosis association
 N SNO,DESC,ERR,IMP,ICD,SYS,CODE,ITEMNAME,CT,ITEMIEN,STRING,SNOICD
 S SNO=$P(N0,U,8),DESC=$P(N0,U,9)
 S ICD=+$P(N0,U,1)      ;ICD code in the association
 S SNOICD=""
 S ERR=""
 I +SNO D
 .S CT=$$CONC^BSTSAPI(SNO_"^^^1")
 .S ITEMNAME=$P(CT,U,4)
 .S ITEMIEN=SNO
 .S SNOICD=$P($P(CT,U,5),";",1)    ;ICD code found from SNOMED lookup
 I 'SNO D
 .S CODE=$$ICDDX^ICDCODE(ICD)
 .S ITEMNAME=$P(CODE,U,4)
 .S ITEMIEN=$P(CODE,U,1)
 .S ERR="-1^DX has not been converted to SNOMED and cannot be stored."
 I $$AICD^BGOUTL2 D
 .S IMP=$$IMP^ICDEX("10D",DT)    ;Get the implementation date
 .S CODE=$$ICDDX^ICDEX(ICD,,,"I")
 .I IMP>$$NOW^XLFDT  D           ;This needs to be an ICD-9 code
 ..I $P(CODE,U,20)'=1  S ERR="-1^You may not use this diagnosis for this visit date, please assign POV from IPL"
 .I IMP<$$NOW^XLFDT D
 ..I $P(CODE,U,20)=1 S ICD=$$UPDATE(CAT,ITEM,SNOICD,IEN)    ;Change the code to an ICD-10 code
 .I SNOICD'="",ICD'=SNOICD S ICD=$$UPDATE(CAT,ITEM,SNOICD,IEN)  ;Change the code if it has changed
 E  D
 .S CODE=$$ICDDX^ICDCODE(ICD)
 .S ITEMNAME=$P(CODE,U,4)
 .S ITEMIEN=$P(CODE,U,1)
 S AUTO=$P(N0,U,2)
 S DFLT=$P(N0,U,3)
 S NODUP=$P(N0,U,4)
 S AMT=$P(N0,U,5)
 S QTY=$P(N0,U,7)
 S ID=$$TYPECVT(TYP,1,5)
 S CODE=$P(CODE,U,2)
 I +SNO S TYP=$$TYPECVT(TYP,1,2)
 E  S TYP="ICD Diagnosis"
 ;Patch 19 added DESC to output
 S STRING=ITEMIEN_U_ITEMNAME_U_TYP_U_AUTO_U_DFLT_U_NODUP_U_AMT_U_IEN_U_QTY_U_CODE_U_ID_U_DESC
 S CNT=CNT+1
 I ERR'="" S STRING=STRING_U_ERR
 S @RET@(CNT)=STRING
 Q
ICD0(X,N0) ;Lookup ICD procedure in association
 N ERR,IMP,ICD,SYS,CODE,ITEMNAME,CT,ITEMIEN,STRING,SNOICD
 S ICD=+$P(N0,U,1)      ;ICD code in the association
 S ERR=""
 I $$AICD^BGOUTL2 D
 .S IMP=$$IMP^ICDEX("10P",DT)    ;Get the implementation date
 .S CODE=$$ICDOP^ICDEX(ICD,"","","I")
 .S ITEMNAME=$P(CODE,U,5)
 .S ITEMIEN=$P(CODE,U,1)
 .I IMP>$$NOW^XLFDT  D           ;This needs to be an ICD-9 code
 ..I $P(CODE,U,15)'=2  S ERR="-1^You may not use this ICD Procedure Code for this visit date, please assign ICD procedure code from the Services component."
 .I IMP<$$NOW^XLFDT D
 ..I $P(CODE,U,15)=2 S ERR="-1^You may not use this ICD Procedure Code for this visit date, please assign ICD procedure code from the Services component."
 E  D
 .S CODE=$$ICDOP^ICDCODE(ICD)
 .S ITEMNAME=$P(CODE,U,5)
 .S ITEMIEN=$P(CODE,U,1)
 S AUTO=$P(N0,U,2)
 S DFLT=$P(N0,U,3)
 S NODUP=$P(N0,U,4)
 S AMT=$P(N0,U,5)
 S QTY=$P(N0,U,7)
 S ID=$$TYPECVT(TYP,1,5)
 S CODE=$P(CODE,U,2)
 S TYP="ICD Procedure"
 S STRING=ITEMIEN_U_ITEMNAME_U_TYP_U_AUTO_U_DFLT_U_NODUP_U_AMT_U_IEN_U_QTY_U_CODE_U_ID_U_""
 S CNT=CNT+1
 I ERR'="" S STRING=STRING_U_ERR
 S @RET@(CNT)=STRING
 Q
 ; Delete an association
 ;  INP = Category IEN ^ Item IEN ^ Element IEN
DELASSOC(RET,INP) ;EP
 N DA
 S DA(2)=+INP
 S DA(1)=+$P(INP,U,2)
 S DA=+$P(INP,U,3)
 S RET=$$DELETE^BGOUTL("^BGOCPTPR("_DA(2)_",1,"_DA(1)_",1,",.DA)
 Q
UPDATE(CAT,IEN,VAL,ASSOC) ;Change the code in the association
 N IENS,FDA,NEWCODE,RET2,ERR
 S ERR=""
 I $$AICD^BGOUTL2 S NEWCODE=$P($$ICDDX^ICDEX(VAL,"","","E"),U,1)
 E  S NEWCODE=$P($$ICDDX^ICDCODE(VAL),U,1)
 S IENS=ASSOC_","_IEN_","_CAT_","
 S FDA=$NA(FDA(90362.3121,IENS))
 S @FDA@(.01)=NEWCODE_";ICD9("
 S RET2=$$UPDATE^BGOUTL(.FDA,"@",.IEN)
 I 'RET2 S RET2=VAL
 Q RET2
 ; Set an association
 ;  INP = CPT Preference IEN [1] ^ CPT Subfile IEN [2] ^ Type [3] ^ Value [4] ^ Association [5] ^ Auto Add [6] ^
 ;        Default to Add [7] ^ No Dups [8] ^ Amount [9] ^ Quantity [10]
SETASSOC(RET,INP) ;EP
 N TYP,TYP2,VAL,ASSOC,AUTO,DFLT,NODUP,AMT,QTY,FDA,IENS,DA,IEN,Z,TYP2
 N SNO,ICD,X,IMP
 S RET=""
 S DA(2)=+INP
 S DA(1)=+$P(INP,U,2)
 S TYP=$P(INP,U,3)
 S VAL=$P(INP,U,4)
 S ASSOC=$P(INP,U,5)
 S AUTO=+$P(INP,U,6)
 S DFLT=+$P(INP,U,7)
 S NODUP=+$P(INP,U,8)
 S AMT=+$P(INP,U,9)
 S QTY=+$P(INP,U,10)
 I '$D(^BGOCPTPR(DA(2),1,DA(1),0)) S RET=$$ERR^BGOUTL(1011) Q
 I TYP=+TYP S TYP=$$TYPECVT(TYP,5,1)
 E  S TYP=$$TYPECVT(TYP,2,1)
 I TYP="" S RET=$$ERR^BGOUTL(1012) Q
 I VAL="" S RET=$$ERR^BGOUTL(1013) Q
 S IENS=$S(ASSOC:ASSOC,1:"+1")_","_DA(1)_","_DA(2)_","
 S FDA=$NA(FDA(90362.3121,IENS))
 ;Patch 14 changes
 I TYP="ICD9(" D
 .S X=$$CONC^BSTSAPI(VAL_"^^^1")
 .S ICD=$P($P(X,U,5),";",1)
 .;Store .9999 or ZZZ-999 depending on coding system
 .I ICD="" D
 ..I $$AICD^BGOUTL2 D
 ...S IMP=$$IMP^ICDEX("10D",DT)    ;Get the implementation date
 ...I IMP>$$NOW^XLFDT S ICD=".9999"
 ...I IMP<$$NOW^XLFDT S ICD="ZZZ-999"
 ..E  S ICD=".9999"
 .I $$AICD^BGOUTL2 S TYP2=$P($$ICDDX^ICDEX(ICD,$$NOW^XLFDT,"","E"),U,1)
 .E  S TYP2=$P($$ICDDX^ICDCODE(ICD,$$NOW^XLFDT,"","E"),U,2)
 .S @FDA@(1)=VAL
 .S @FDA@(1.1)=$P(X,U,3)
 .S @FDA@(.01)=TYP2_";"_TYP
 E  S @FDA@(.01)=VAL_";"_TYP
 S @FDA@(.02)=AUTO
 S @FDA@(.03)=DFLT
 S @FDA@(.04)=NODUP
 S @FDA@(.05)=AMT
 S @FDA@(.07)=QTY
 S RET=$$UPDATE^BGOUTL(.FDA,"@",.IEN)
 I 'RET,'ASSOC S ASSOC=IEN(1)
 S:'RET RET=ASSOC
 Q
 ; Return list of entries stored for a visit for a pick list
 ;  INP = Category IEN ^ Item IEN ^ Visit IEN
VSTASSOC(RET,INP) ;EP
 N LP,TMP,VFIEN,VIEN,GBL,IEN,TYP,CNT,TXT,ID,FNUM,X,Y
 S VIEN=$P(INP,U,3)
 Q:'VIEN
 D GETASSOC(.RET,$P(INP,U,1,2))
 S X=$G(@RET@(1))
 Q:X=""!(X<0)
 S TMP=RET,RET=$$TMPGBL^BGOUTL(1),(LP,CNT)=0
 F  S LP=$O(@TMP@(LP)) Q:'LP  D
 .S X=@TMP@(LP),IEN=+X,TYP=$P(X,U,3),TXT=$P(X,U,2),ID=+$P(X,U,11)
 .S FNUM=$$TYPECVT(ID,5,6)
 .Q:'FNUM
 .S GBL=$$ROOT^DILFD(FNUM,,1)
 .S VFIEN=0
 .F  S VFIEN=$O(@GBL@("AD",VIEN,VFIEN)) Q:'VFIEN  D
 ..S X=$G(@GBL@(VFIEN,0))
 ..S Y=$P(X,U,3)
 ..I GBL="^AUPNVPOV" S X=$G(@GBL@(VFIEN,11))
 ..Q:+X'=IEN!(Y'=VIEN)
 ..S CNT=CNT+1,@RET@(CNT)=ID_U_TYP_U_IEN_U_TXT_U_VFIEN_U_FNUM
 K @TMP
 Q
 ; Modify a field for an association
 ;  INP = CPT Preference IEN [1] ^ CPT Subfile IEN [2] ^ Associations Subfile IEN [3] ^ Column Index [4] ^ Value [5]
SETACHK(RET,INP) ;EP
 N DA,COL,VAL,FDA,IENS
 K RET
 S DA(2)=+INP
 S DA(1)=+$P(INP,U,2)
 S DA=+$P(INP,U,3)
 I '$D(^BGOCPTPR(+DA(2),1,+DA(1),1,+DA,0)) S RET=$$ERR^BGOUTL(1014) Q
 S COL=+$P(INP,U,4)
 I COL<1!(COL>5) S RET=$$ERR^BGOUTL(1015) Q
 S VAL=$P(INP,U,5)
 I VAL="" S RET=$$ERR^BGOUTL(1016) Q
 S IENS=DA_","_DA(1)_","_DA(2)_","
 S FDA=$NA(FDA(90362.3121,IENS))
 S @FDA@(COL+1/100)=VAL
 I VAL,COL<3 S @FDA@(4-COL/100)=0
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 Q
 ; Return list of CPT categories
OTHCATS(RET,DUMMY) ;EP
 N CNT,I,X
 K RET
 S CNT=0
 F I=1:1:2 D
 .S X=0
 .F  S X=$O(^DIC(81.1,"C",I,X)) Q:'X  D
 ..I X>22,X<30 Q
 ..Q:$P($G(^DIC(81.1,X,9999999)),U,3)>98999
 ..S CNT=CNT+1
 ..S RET(CNT)=$P($G(^DIC(81.1,X,0)),U)_U_X_U_$S(I=1:"Med",I=2:"Surg",I=3:"Anesth",I=4:"Rad",1:"Lab")
 S:CNT CNT=CNT+1,RET(CNT)="DENTAL^9999^Dent"
 Q
 ; Clone a CPT category into a preference category
 ;  INP = CPT Category IEN ^ Preference Category IEN
CLONEOTH(RET,INP) ;EP
 N CPTCAT,PRIEN
 K RET
 S RET=0
 S CPTCAT=+INP
 I 'CPTCAT S RET=$$ERR^BGOUTL(1017) Q
 S PRIEN=+$P(INP,U,2)
 I 'PRIEN S RET=$$ERR^BGOUTL(1018) Q
 I '$D(^BGOCPTPR(PRIEN,0)) S RET=$$ERR^BGOUTL(1019) Q
 I CPTCAT=9999 D
 .N ADA
 .S ADA="D0000"
 .F  S ADA=$O(^ICPT("B",ADA)) Q:$E(ADA)'="D"  D CC1("B",ADA) Q:RET
 E  D CC1("D",CPTCAT)
 S:'RET RET=1
 Q
CC1(SB,SBV) ;
 N CPT,X
 S CPT=0
 F  S CPT=$O(^ICPT(SB,SBV,CPT)) Q:'CPT  D  Q:RET
 .Q:$$CHKCPT^BGOVCPT(CPT)<0
 .Q:$O(^BGOCPTPR(PRIEN,1,"B",CPT,0))
 .S RET=$$UPDITEM^BGOPFUTL(90362.31,PRIEN,CPT,0)
 Q
 ; Clone a preference
 ;  INP = Pref IEN (from) ^ Pref IEN (to)
CLONE(RET,INP) ;EP
 D CLONE^BGOPFUTL(.RET,INP,90362.31)
 Q
 ; Execute query to update frequencies
 ;  INP = Category IEN [1] ^ Provider IEN [2] ^ Clinic IEN [3] ^ Provider Class [4] ^ Hospital Location [5] ^
 ;        Start Date [6] ^ End Date [7] ^ Max Hits [8]
 ;        Med [9] ^ Surg [10] ^ Anest [11] ^ Lab [9] ^ Rad [12] ^ Supply [13] ^ 3rd Party Billing [14] ^
 ;        V CPT [15] ^ CHS [16]
QUERY(RET,INP) ;EP
 N CAT,PRV,CLN,CLS,HL,MED,SURG,ANEST,LAB,RAD,SUPPLY,TPB,VCPT,CHS,BEGDT
 N ENDDT,VD,VIEN,PX,CLM,CPT,PIEN,PRV,VIS,GRP,CNT,MAX,ND,X
 I $G(INP)="" S RET=$$ERR^BGOUTL(1008) Q
 S RET=""
 S CAT=$P(INP,U)
 S PRV=$P(INP,U,2)
 S CLN=$P(INP,U,3)
 S CLS=$P(INP,U,4)
 S HL=$P(INP,U,5)
 S BEGDT=$P(INP,U,6)
 S ENDDT=$P(INP,U,7)
 S MAX=+$P(INP,U,8)
 S MED=$P(INP,U,9)
 S SURG=$P(INP,U,10)
 S ANEST=$P(INP,U,11)
 S LAB=$P(INP,U,12)
 S RAD=$P(INP,U,13)
 S SUPPLY=$P(INP,U,14)
 S TPB=$P(INP,U,15)
 S VCPT=$P(INP,U,16)
 S CHS=$P(INP,U,17)
 S CNT=0
 S VD=$S(BEGDT:BEGDT,1:DT-20000)
 S:'ENDDT ENDDT=DT
 S RET=$$QRYINIT^BGOPFUTL(90362.31,CAT)
 Q:RET
 F  S VD=$O(^AUPNVSIT("B",VD)) Q:'VD!RET!(VD>ENDDT)  D
 .S VIEN=0
 .F  S VIEN=$O(^AUPNVSIT("B",VD,VIEN)) Q:'VIEN!RET  D
 ..S VIS=$G(^AUPNVSIT(VIEN,0))
 ..Q:VIS=""
 ..I CLN,$P(VIS,U,8)'=CLN Q
 ..I HL,$P(VIS,U,22)'=HL Q
 ..I 'CHS,$P(VIS,U,3)="C" Q
 ..I CHS,'TPB,'VCPT,$P(VIS,U,3)'="C" Q
 ..I PRV!CLS,'$$VISPRCL^BGOPFUTL(VIEN,PRV,CLS) Q
 ..I TPB D  Q:RET                                                ; Query third-party billing
 ...S CLM=$O(^ABMDCLM(DUZ(2),"AV",VIEN,0))
 ...Q:'CLM
 ...F ND=21,27,43 D  Q:RET
 ....S PX=0
 ....F  S PX=$O(^ABMDCLM(DUZ(2),CLM,ND,PX)) Q:'PX!RET  D
 .....S CPT=+$G(^ABMDCLM(DUZ(2),CLM,ND,PX,0))
 .....D ADDPX
 ..I VCPT D                                                      ; Query VCPT
 ...S PX=0
 ...F  S PX=$O(^AUPNVCPT("AD",VIEN,PX)) Q:'PX!RET  D
 ....S CPT=+$G(^AUPNVCPT(PX,0))
 ....D ADDPX
 ..S PX=0                                                        ; Query V Procedure
 ..F  S PX=$O(^AUPNVPRC("AD",VIEN,PX)) Q:'PX!RET  D
 ...S CPT=+$P($G(^AUPNVCPT(PX,0)),U,16)
 ...D ADDPX
 S RET=$$QRYDONE^BGOPFUTL(90362.31,CAT)
 Q
ADDPX Q:'CPT
 S CNT=CNT+1
 S:CNT=MAX RET=CNT
 I CPT>98999,CPT<100000 Q
 I 'LAB,CPT>79999,CPT<90000 Q
 I 'RAD,CPT>69999,CPT<80000 Q
 I 'MED,CPT>89999,CPT<100000 Q
 I 'SURG,CPT>9999,CPT<70000 Q
 I 'ANEST,CPT>0,CPT<10000 Q
 I 'SUPPLY,$P($G(^ICPT(CPT,0)),U)?1A4N Q
 D QRYADD^BGOPFUTL(90362.31,CAT,CPT)
 Q
 ; Converts a variable pointer specifier to a related attribute
 ;  X = value to map
 ;  F = map from
 ;  T = map to
TYPECVT(X,F,T) ;
 N I,Y,R
 S X=$$UP^XLFSTR(X)
 I X="CPT MODIFIER" D
 .S Z=$$MODGBL^BGOVCPT
 .I Z="^DIC(81.3)" S X="CSV CPT MODIFIER"
 F I=0:1 S Y=$P($T(TYPES+I),";;",2) Q:'$L(Y)  D  Q:$D(R)
 .S:$$UP^XLFSTR($P(Y,";",F))=X R=$P(Y,";",T)
 Q $G(R)
 ; Information about association types
 ; Format is: Global Root;Item Name;Name Piece;Code Piece;ID;V File #
TYPES ;;ICD9(;SNOMED DX;3;1;0;9000010.07
 ;;ICD0(;ICD Procedure;4;1;1;9000010.08
 ;;ICPT(;CPT;2;1;2;9000010.18
 ;;AUTTSK(;Skin Test;1;2;3;9000010.12
 ;;AUTTEXAM(;Exam;1;2;4;9000010.13
 ;;AUTTCMOD(;CPT Modifier;2;1;5;
 ;;AUTTHF(;Health Factor;1;2;6;9000010.23
 ;;AUTTIMM(;Immunization;1;3;7;9000010.11
 ;;AUTTEDT(;Education Topic;1;1;8;9000010.16
 ;;BCMTCF(;Transaction;7;1;9;9000010.33
 ;;DIC(81.3;CSV CPT Modifier;2;2;5;
 ;;
