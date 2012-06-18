BGOVIMM2 ;IHS/BAO/TMD  BGO - IMMUNIZATION mgt;17-Sep-2009 11:59;MGH
 ;;1.1;BGO COMPONENTS;**1,3,4,6**;Mar 20, 2007
 ;---------------------------------------------
 ; Get case data
GETCASE(RET,DFN) ;EP
 K RET
 I '$D(^BIP(DFN,0)) S RET(0)=$$ERR^BGOUTL(1083)
 E  D GETS^DIQ(9002084,DFN,".1;.09;.13;.08;.16;.12;.15;.11","IE","RET")
 Q
 ; Add/edit patient immunization registry entry
 ;  INP = Patient IEN [1] ^ Case Manager IEN [2] ^ Parent [3] ^ Other Info [4] ^ Activate Flag [5] ^
 ;        Inactive Date [6] ^ Inactive Reason [7] ^ Tx Location [8] ^ Forecast Inf/Pneu [9] ^
 ;        Mother HBSAg Status [10]
SETREG(RET,INP) ;EP
 N DFNX,CM,PARENT,OTH,ACTIVATE,INACT,REAS,MOV,FLU,HBSAG,FDA
 S RET=""
 S DFNX=+$G(INP)
 I '$D(^DPT(DFNX,0)) S RET=$$ERR^BGOUTL(1001) Q
 S CM=$P(INP,U,2)
 S PARENT=$P(INP,U,3)
 S OTH=$P(INP,U,4)
 S ACTIVATE=$P(INP,U,5)
 S INACT=$P(INP,U,6)
 S REAS=$P(INP,U,7)
 S MOV=$P(INP,U,8)
 S FLU=$P(INP,U,9)
 S HBSAG=$P(INP,U,10)
 D:'$D(^BIP(DFNX)) ADDPAT^BIPATE(DFNX,DUZ(2),.RET)
 S RET=$$IMMERR^BGOVIMM(.RET)
 Q:RET
 S FDA=$NA(FDA(9002084,DFNX_","))
 I $L(ACTIVATE),$P(^BIP(DFNX,0),U,8) S (INACT,REAS,MOV)="@"
 S:CM @FDA@(.1)="`"_CM
 S @FDA@(.09)=PARENT
 S @FDA@(.13)=OTH
 S @FDA@(.08)=INACT
 S @FDA@(.16)=REAS
 S @FDA@(.12)=MOV
 S @FDA@(.15)=FLU
 S @FDA@(.11)=HBSAG
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 Q
 ; Get Primary Provider for VIMM IEN
PRIPRV(RET,VIMMIEN) ;EP
 S RET=$$PRIPRV^BGOUTL($P($G(^AUPNVIMM(+VIMMIEN,0)),U,3))
 Q
 ; Retrieve lot #'s associated with a vaccine
 ; IMM = Immunization type IEN
 ; Returned as a list of records in the format:
 ;  Lot IEN ^ Name ^ Manufacturer ^ Exp Date
LOT(RET,IMM) ;EP
 N CNT,FLG,LOT
 S RET=$$TMPGBL^BGOUTL
 S CNT=0,IMM=+$G(IMM),FLG=IMM
 F  D:IMM  Q:FLG  S IMM=$O(^AUTTIML("C",IMM)) Q:'IMM
 .S LOT=0
 .F  S LOT=$O(^AUTTIML("C",IMM,LOT)) Q:'LOT  D
 ..N X,NAME,MANUFAC,EXPDT
 ..S X=$G(^AUTTIML(LOT,0))
 ..Q:'$L(X)
 ..Q:$P(X,U,3)=1
 ..S NAME=$P(X,U)
 ..S MANUFAC=$P(X,U,2)
 ..S:MANUFAC MANUFAC=$P($G(^AUTTIMAN(MANUFAC,0)),U)
 ..S EXPDT=$$FMTDATE^BGOUTL($P(X,U,9))
 ..S CNT=CNT+1,@RET@(CNT)=LOT_U_NAME_U_MANUFAC_U_EXPDT
 Q
 ; Add a contraindication
 ;   INP = Patient IEN [1] ^ Vaccine IEN [2] ^ Reason IEN [3] ^ Visit Date [4]
SETCONT(RET,INP) ;EP
 N DATE,DFN,VACP,RSN,FDA,NEW,IEN,IENX,X
 S DFN=+INP
 I '$D(^DPT(DFN,0)) S RET=$$ERR^BGOUTL(1001) Q
 S VACP=+$P(INP,U,2)
 I '$D(^AUTTIMM(VACP,0)) S RET=$$ERR^BGOUTL(1084) Q
 S RSN=+$P(INP,U,3)
 S DATE=$P(INP,U,4)
 S IEN=0
 F  S IEN=$O(^BIPC("B",DFN,IEN)) Q:'IEN  D  Q:$D(X)
 .S X=$G(^BIPC(IEN,0))
 .I +X=DFN,$P(X,U,2)=VACP,$P(X,U,3)=RSN Q
 .K X
 S NEW='IEN
 S FDA=$NA(FDA(9002084.11,$S(NEW:"+1,",1:IEN_",")))
 S @FDA@(.01)="`"_DFN
 S @FDA@(.02)="`"_VACP
 S @FDA@(.03)="`"_RSN
 S @FDA@(.04)=$S(DATE:DATE,1:DT)
 S RET=$$UPDATE^BGOUTL(.FDA,"E",.IENX)
 Q:RET
 S:NEW IEN=$G(IENX(1))
 S:$$UP^XLFSTR($P($G(^BICONT(RSN,0)),U))["REFUSAL" RET=$$REFSET2^BGOUTL2(DFN,DATE,VACP,"IMMUNIZATION","R")
 S:'RET RET=IEN
 D:RET>0 BRDCAST^CIANBEVT("CONTRAINDICATION."_DFN_".IMMUNIZATION",IEN_U_$G(CIA("UID"))_U_'NEW)
 Q
 ; Delete a contraindication
DELCONT(RET,IEN) ;EP
 N DFN
 S DFN=+$G(^BIPC(IEN,0))
 Q:'DFN
 S RET=$$DELETE^BGOUTL("^BIPC(",IEN)
 D:'RET BRDCAST^CIANBEVT("CONTRAINDICATION."_DFN_".IMMUNIZATION",IEN_U_$G(CIA("UID"))_U_2)
 Q
 ; Get contraindication reasons
 ; Returns a list of records in the format:
 ;  IEN ^ Name
GETCONT(RET,DUMMY) ;EP
 N CNT,X,Y
 S RET=$$TMPGBL^BGOUTL
 S (X,CNT)=0
 F  S X=$O(^BICONT(X)) Q:'X  D
 .S Y=$P($G(^BICONT(X,0)),U)
 .S:$L(Y) CNT=CNT+1,@RET@(CNT)=X_U_Y
 Q
 ; Return immunization profile
PROFILE(RET,DFN) ;EP
 D IMMPROF^BIRPC(.RET,+DFN,"","")
 S:$A($G(@RET@(1)))=31 @RET@(1)=$$IMMERR^BGOVIMM(@RET@(1))
 Q
 ; Return fully resolved immunization letter
 ;  INP = Patient IEN [1] ^ Letter IEN [2] ^ Text of Date/Location Line [3] ^ Forecast Date [4]
PRINT(RET,INP) ;EP
 N BIDFN,BIDLOC,BIFDT,BIPCS,BILET,S,N
 S RET=$NA(^UTILITY($J,"W"))
 K @RET
 S BIDFN=+INP
 S BILET=$P(INP,U,2)
 S BIDLOC=$P(INP,U,3)
 S BIFDT=$P(INP,U,4)
 S S=$S($D(^BISITE(DUZ(2),0)):DUZ(2),1:+^AUTTSITE(1,0))
 S BILET=$S(BILET=1:$P($G(^BISITE(S,0)),U,4),1:$P($G(^BISITE(S,0)),U,13))
 I 'BILET S @RET@(1,0)="ERROR: Missing letter template" Q
 D BUILD^BILETPR1(BIDFN,BILET,BIDLOC,BIFDT)
 I '$D(^TMP("BILET",$J)) S @RET@(1,0)="ERROR: Blank letter template" Q
 ; Resolve embedded functions
 S N=0
 F  S N=$O(^TMP("BILET",$J,N)) Q:'N  D
 .N X,DIWL,DIWR,DIWF
 .S X=^TMP("BILET",$J,N,0),DIWL=1,DIWR=80,DIWF="N"
 .D ^DIWP
 K ^TMP("BILET",$J)
 S ^UTILITY($J,"W",1)=""
 Q
 ;Determine patient's age, if the site is an IHS site,and the default value for the VFC
 ;INP=DFN of patient
 ;RET= [1] IHS (Y/N)^ [2] Age ^ [3] Default
GETVFC(RET,INP) ;EP call to get the VFC default for a patient
 N IHS,AGE,DEFAULT,DFN
 K RET
 S IHS="N",AGE="",DEFAULT=""
 S DFN=$P(INP,U,1)
 I DUZ("AG")="I" D
 .S IHS="Y"
 .S AGE=$$PTAGE^BGOUTL(DFN)
 .I AGE<19 D
 ..S DEFAULT=$$BENTYP^BIUTL11(DFN)
 ..I DEFAULT=1 S DEFAULT="Am Indian/AK Native"
 S RET=IHS_U_AGE_U_DEFAULT
 Q
