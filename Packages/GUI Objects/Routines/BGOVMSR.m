BGOVMSR ; IHS/BAO/TMD - Manage V MEASUREMENTs ;30-Apr-2007 08:20;DKM
 ;;1.1;BGO COMPONENTS;**1,3**;Mar 20, 2007
 ; Return most recent vitals
 ;  INP = Patient IEN ^ Vital Types ^ Visit IEN
 ; .RET = List of records of format:
 ;        Type Name [1] ^ Value [2] ^ Date/Time [3] ^ V File IEN [4] ^ Visit IEN [5]
LAST(RET,INP) ;EP
 N DFN,TYPE,TYPESET,VIEN,CNT,TYPENM,IDT,IEN,X,DAT,FND,VSIT
 K RET
 S DFN=+INP
 I 'DFN S RET(1)=$$ERR^BGOUTL(1050) Q
 S TYPESET=$P(INP,U,2)
 S:'$L(TYPESET) TYPESET="HT;WT;TMP;BP;PU;RS;PA"
 S TYPESET=";"_TYPESET_";"
 S VIEN=$P(INP,U,3)
 S (TYPE,CNT)=0
 F  S TYPE=$O(^AUPNVMSR("AA",DFN,TYPE)) Q:'TYPE  D
 .S TYPENM=$P($G(^AUTTMSR(TYPE,0)),U)
 .Q:TYPENM=""
 .Q:TYPESET'[(";"_TYPENM_";")
 .S (FND,IDT)=0
 .F  S IDT=$O(^AUPNVMSR("AA",DFN,TYPE,IDT)) Q:'IDT  D  Q:FND
 ..S IEN=0
 ..F  S IEN=$O(^AUPNVMSR("AA",DFN,TYPE,IDT,IEN)) Q:'IEN  D  Q:FND
 ...S X=$G(^AUPNVMSR(IEN,0)),DAT=+$G(^(12))
 ...S VSIT=+$P(X,U,3)
 ...I VIEN,VSIT'=VIEN Q
 ...S:'DAT DAT=+$G(^AUPNVSIT(VSIT,0))
 ...S CNT=CNT+1,FND=1
 ...S RET(CNT)=TYPENM_U_$P(X,U,4)_U_$$CDT(DAT)_U_IEN_U_VSIT_U_$$ISLOCKED^BEHOENCX(VSIT)
 Q
 ; Returns vital measurements for current visit context in a single string
TIUSTR() ;EP
 N X,Y
 S X=$$GETVAR^CIANBUTL("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I X="" Q " "
 S X=$$VSTR2VIS^BEHOENCX(DFN,X)
 I X<1 Q " "
 D GET(.X,X_"^1")
 Q $G(X)
 ;
 ; Return vital measurements for a visit
 ;  INP = Visit IEN ^ Format (0=multiline, 1=single string)
 ;  Returned as:
 ;   Single line format: concatenated string of measurement results
 ;   Multiple line format:
 ;     Type Name [1] ^ Value [2] ^ Date [3] ^ VFile IEN [4] ^ Visit IEN [5] ^
 ;     Encounter Provider Name [6] ^ Visit Locked [7]
GET(RET,INP) ; EP
 N VIEN,VFIEN,CNT,FORMAT
 K RET
 S VIEN=+INP
 I 'VIEN S RET(1)=$$ERR^BGOUTL(1002) Q
 S FORMAT=$P(INP,U,2)
 S (VFIEN,CNT)=0
 F  S VFIEN=$O(^AUPNVMSR("AD",VIEN,VFIEN)) Q:'VFIEN  D
 .N X,USR,DAT,TYPE,TYPENM
 .S X=$G(^AUPNVMSR(VFIEN,0)),DAT=+$G(^(12)),USR=+$P($G(^(12)),U,4)
 .Q:X=""
 .S TYPE=+X
 .S TYPENM=$P($G(^AUTTMSR(TYPE,0)),U)
 .Q:TYPENM=""
 .S CNT=CNT+1
 .I FORMAT D
 ..N MSRSTR
 ..S MSRSTR=TYPENM_":"_$P(X,U,4)
 ..I TYPENM="WT" S MSRSTR=MSRSTR_" ("_($P(X,U,4)*.45359\1)_" kg)"
 ..I TYPENM="HT" S MSRSTR=MSRSTR_" ("_($P(X,U,4)*2.54\1)_" cm)"
 ..I TYPENM="TMP" S MSRSTR=MSRSTR_" ("_(((10*($P(X,U,4)-32/1.8))\1)/10)_" C)"
 ..S RET(1)=$S(CNT=1:"",1:RET(1)_", ")_MSRSTR
 .E  D
 ..N NAME
 ..S NAME=$P($G(^VA(200,USR,0)),U)
 ..S:'DAT DAT=+$G(^AUPNVSIT(VIEN,0))
 ..S RET(CNT)=TYPENM_U_$P(X,U,4)_U_$$CDT(DAT)_U_VFIEN_U_$P(X,U,3)_U_NAME_U_$$ISLOCKED^BEHOENCX(VIEN)
 Q
 ; Format date for display
CDT(X) N Y,TM
 Q:'X ""
 S Y=$$FMTDATE^BGOUTL(X)
 S TM=X#1*10000\1
 Q:'TM Y
 S TM=TM+10000
 Q Y_"@"_$E(TM,2,3)_":"_$E(TM,4,5)
 ; Return list of vital types
 ; Return format:
 ;  IEN [1] ^ Abbreviation [2] ^ Name [3] ^ Code [4]
GETTYPES(RET,DUMMY) ;EP
 N NAME,CODE,ABBR,REC,CNT,IEN
 K RET
 S (IEN,CNT)=0
 F  S IEN=$O(^AUTTMSR(IEN)) Q:'IEN  D
 .S REC=$G(^AUTTMSR(IEN,0))
 .Q:REC=""
 .Q:$P(REC,U,4)
 .S ABBR=$P(REC,U)
 .S NAME=$P(REC,U,2)
 .Q:NAME["INACTIVE"
 .S CODE=$P(REC,U,3)
 .S CNT=CNT+1
 .S RET(CNT)=IEN_U_ABBR_U_NAME_U_CODE
 Q
 ; Add/edit V Measurement entry
 ;  INP = Visit IEN [1] ^ V File IEN [2] ^ Type [3] ^ Value [4] ^ Date/Time [5]
SET(RET,INP) ;EP
 N VIEN,TYPE,VFIEN,VFNEW,VAL,DAT,FDA,FNUM
 S FNUM=$$FNUM
 S VIEN=+INP
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 S VFIEN=$P(INP,U,2)
 I VFIEN,$P($G(^AUPNVMSR(VFIEN,12)),U,4),$P(^(12),U,4)'=DUZ S RET=$$ERR^BGOUTL(1086,$P($G(^VA(200,$P(^(12),U,4),0)),U)) Q
 S VFNEW='VFIEN
 S TYPE=$P(INP,U,3)
 S:TYPE'=+TYPE TYPE=$O(^AUTTMSR("B",TYPE,0))
 I 'TYPE S RET=$$ERR^BGOUTL(1087) Q
 S VAL=$P(INP,U,4)
 S DAT=$$CVTDATE^BGOUTL($P(INP,U,5))
 I 'VFIEN D  Q:'VFIEN
 .N FLDS
 .S FLDS(.04)=VAL
 .D VFNEW^BGOUTL2(.RET,FNUM,TYPE,VIEN,,.FLDS)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.01)="`"_TYPE
 S @FDA@(.04)=VAL
 S @FDA@(1201)=$S(DAT:DAT,1:"N")
 S @FDA@(1204)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Delete a V Measurement entry
DEL(RET,VFIEN) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 Q
 ; Return V File #
FNUM() Q 9000010.01
