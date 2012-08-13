CIAVIHVT ;CIA/DKM - Vitals support for RPMS ;07-Sep-2004 19:29;DKM
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;;Copyright 2000-2003, Clinical Informatics Associates, Inc.
 ;=================================================================
 ; Converts vitals to proper formatting for PCC
VIT2PCC(VIT) ;
 N PCC,X,VAL,TYP,VST,OBS,DFN,VSTR,UNT,DAT,ERR
 S PCC="",X=0,VSTR="",ERR=""
 F  S X=$O(VIT(X)) Q:'X  D  Q:$L(ERR)
 .S VAL=VIT(X),OBS=$P(VAL,U,2),TYP=$TR($P(VAL,U),"+")
 .I TYP="VST" S VAL=$P(VAL,U,3)
 .E  S UNT=$P(VAL,U,7),DAT=$P(VAL,U,8),VAL=$P(VAL,U,5)
 .D:$L(VAL) VALIDATE(TYP,.OBS,.VAL,.UNT,.ERR)
 .I $L(ERR) S ERR="-1^"_ERR Q
 .I $L(VAL),TYP="VIT" S PCC=PCC_$S($L(PCC):"|",1:"")_OBS_";"_VAL
 I '$L(ERR) D
 .S VST=$$VSTR2VIS^CIAVCXEN(DFN,VSTR,1)
 .I VST>0 S VST=+VST
 .E  S ERR=VST
 Q $S($L(ERR):ERR,1:VST_"|"_DUZ_"|"_PCC)
 ; Validate VAL
VALIDATE(TYP,OBS,VAL,UNT,ERR) ;
 N EP
 S EP=TYP_OBS,ERR="",UNT=$G(UNT)
 I $T(@EP)="" S ERR="Unknown measurement type."
 E  D @EP
 Q
 ; Validates units
CHKUNT(UNIT) ;
 S:'$L(UNT) UNT=UNIT
 S:UNT'=UNIT ERR="Improper units: "_UNT
 Q:$Q $L(ERR)
 Q
 ; Validate numeric range
CHKRNG(VAL,LOW,HI,FR) ;
 I '$G(FR),VAL["." S ERR="Fractional portion not allowed"
 E  I "."'[$TR(VAL,"0123456789") S ERR="Invalid numeric format"
 E  S VAL=+VAL S:(VAL<LOW)!(VAL>HI) ERR="Entry outside acceptable range"
 Q:$Q $L(ERR)
 Q
VSTDT S $P(VSTR,";",2)=+VAL
 Q
VSTPT S DFN=+VAL
 Q
VSTHL S $P(VSTR,";")=+VAL
 Q
VITPN S OBS="PA"
VITPA D CHKRNG(.VAL,0,10)
 Q
VITBP I VAL'?2.3N1"/"2.3N S ERR="Invalid data format" Q
 N SBP,DBP
 S SBP=$P(VAL,"/"),DBP=$P(VAL,"/",2)
 Q:$$CHKRNG(.SBP,0,300)
 Q:$$CHKRNG(.DBP,0,200)
 S VAL=SBP_"/"_DBP
 Q
VITTMP S:UNT="C" VAL=VAL*9/5+32,UNT="F"
 Q:$$CHKUNT("F")
 Q:$$CHKRNG(.VAL,80,110,1)
 Q
VITPU D CHKRNG(.VAL,0,300)
 Q
VITRS Q
VITHT S:UNT="CM" VAL=VAL/2.54,UNT="IN"
 Q:$$CHKUNT("IN")
 Q
VITWT S:UNT="KG" VAL=VAL/2.2,UNT="LB"
 Q:$$CHKUNT("LB")
 Q
 ; Store vitals data in V MEASUREMENT
VALSTORE(DATA,VIT) ;
 S VIT=$$VIT2PCC(.VIT)
 I VIT'>0 S DATA(1)=VIT
 E  D MEA^BTRSETME(.DATA,VIT)
 I $G(DATA(1))<0 S DATA(0)=-1,DATA(1)=$P(DATA(1),U,2)
 E  S DATA(0)=1
 Q
 ; RPC for validate
RATECHK(DATA,OBS,VAL,UNT) ;
 N ERR
 D VALIDATE("VIT",OBS,.VAL,.UNT,.ERR)
 S DATA=$S($L(ERR):"0^"_ERR,1:"1^"_VAL_U_UNT)
 Q
 ; Return most recent vital of specified type
 ; Return value is IEN^VALUE^D/T
VITAL(DFN,TYP) ;
 N IDT,IEN,DAT,VIS
 S:TYP'=+TYP TYP=$O(^AUTTMSR("B",TYP,0))
 Q:'TYP ""
 S IDT=$O(^AUPNVMSR("AA",DFN,TYP,0)) Q:'IDT "" S IEN=$O(^(IDT,0))
 Q:'IEN ""
 S X=$G(^AUPNVMSR(IEN,0)),DAT=+$G(^(12))
 S:'DAT DAT=+$G(^AUPNVSIT(+$P(X,U,3),0))
 Q IEN_U_$P(X,U,4)_U_DAT
 ; Return data for vital entry template
 ; Format is:
 ; DATA(n)=Type IEN^Type Abbr^Type Desc^Last Value^Last Date^Units
TEMPLATE(DATA,DFN,LOC) ;
 N ENT,TMP,ERR,TYP,X
 S ENT=$S($G(LOC):"ALL^LOC.`"_LOC,1:"ALL"),DATA=$$TMPGBL^CIAVMRPC
 D GETLST^XPAR(.TMP,ENT,"CIAOCVVM TEMPLATE","I",.ERR)
 F TMP=0:0 S TMP=$O(TMP(TMP)) Q:'TMP  D
 .S TYP=+TMP(TMP),X=$$VITAL(DFN,TYP),@DATA@(TMP)=TYP_U_$P($G(^AUTTMSR(TYP,0)),U,1,2)_U_$P(X,U,2,3)
 Q
 ; Postinit for installation
POSTINIT D SETLIST^CIAOCVVM("CIAOCVVM TEMPLATE")
 Q
