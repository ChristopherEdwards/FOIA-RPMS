BGOREF ; IHS/BAO/TMD - Manage REFUSALS ;20-Oct-2008 11:02;MGH
 ;;1.1;BGO COMPONENTS;**1,3,5**;Mar 20, 2007
 ; Add/edit a refusal
 ;  INP = Refusal IEN [1] ^ Refusal Type [2] ^ Item IEN [3] ^ Patient IEN [4] ^
 ;        Refusal Date [5] ^ Comment [6] ^ Provider IEN [7] ^ Reason [8]
 ;Patch 5, changed mammogram code for bilateral mammogram
SET(RET,INP) ;EP
 N DFN,REFIEN,REFTYP,ITEMIEN,REFDATE,COMMENT,REASON,PRV
 S DFN=$P(INP,U,4)
 I 'DFN S RET=$$ERR^BGOUTL(1050) Q
 I '$D(^AUPNPAT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 S REFIEN=+INP
 S REFTYP=$P(INP,U,2)
 S ITEMIEN=$P(INP,U,3)
 S REFDATE=$P(INP,U,5)
 S COMMENT=$P(INP,U,6)
 S PRV=$P(INP,U,7)
 S REASON=$P(INP,U,8)
 S:REASON="" REASON="R"
 S RET=$$REFSET2^BGOUTL2(DFN,REFDATE,ITEMIEN,REFTYP,REASON,COMMENT,PRV,REFIEN)
 Q
 ; Get refusal data
 ;  INP = Patient IEN ^ Refusal IEN
 ;  List of records in the format:
 ;    R ^ Refusal IEN [2] ^ Type IEN [3] ^ Type Name [4] ^ Item IEN [5] ^ Item Name [6] ^ Provider IEN [7] ^
 ;    Provider Name [8] ^ Date [9] ^ Locked [10] ^ Reason [11] ^ Comment [12]
GET(RET,INP) ;EP
 N CNT,DFN,REFIEN
 S RET=$$TMPGBL^BGOUTL
 S DFN=+INP
 S REFIEN=$P(INP,U,2)
 I REFIEN S @RET@(1)=$$REFGET1^BGOUTL2(REFIEN)
 E  D
 .S REFIEN="",CNT=0
 .F  S REFIEN=$O(^AUPNPREF("AC",DFN,REFIEN),-1) Q:'REFIEN  D
 ..S CNT=CNT+1,@RET@(CNT)=$$REFGET1^BGOUTL2(REFIEN)
 Q
 ; Delete a refusal
DEL(RET,REFIEN) ;EP
 S RET=$$REFDEL^BGOUTL2(REFIEN)
 Q
 ; Return IEN for pap smear/mammogram/ekg
REFLIST(RET,INP) ;EP
 S INP=$$UP^XLFSTR(INP)
 I INP="PAP SMEAR" S RET=$O(^LAB(60,"B","PAP SMEAR",0))
 E  I INP="MAMMOGRAM" S RET=$O(^RAMIS(71,"D",76056,0))
 E  I INP="EKG" S RET=$O(^AUTTDXPR("B","ECG SUMMARY",0))
 E  S RET=$$ERR^BGOUTL(1051,INP)
 Q
