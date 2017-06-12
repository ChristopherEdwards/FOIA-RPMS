BGOVPRC ; IHS/BAO/TMD - Manage V PROCEDURE ;15-Jan-2015 08:13;du
 ;;1.1;BGO COMPONENTS;**1,3,11,12,14**;Mar 20, 2007;Build 5
 ; Add/edit V Procedure entry
 ; INP = V File IEN [1] ^ ICD0 IEN [2] ^ Visit IEN [3] ^ Patient IEN [4] ^ Event Date [5] ^ Diagnosis [6] ^
 ;       Principal [7] ^ Narrative [8] ^ Infection [9] ^ Operating Provider [10] ^ Anesthesiologist [11] ^
 ;       Anesthesia Time [12] ^ Location IEN [13] ^ Outside Location [14] ^ Historical [15] ^ Allow dups [16]
SET(RET,INP) ;EP
 N VIEN,VCAT,VFIEN,TYPE,DFN,EVNTDT,DX,PRIN,NARR,INFECT,OPRPRV,ANESTH,ANESTIME
 N LOCIEN,OUTLOC,HIST,APCDVSIT,APCDDATE,FNEW,FDA,VFNEW,DUPS,X,Y,FNUM,PROCDT,IMP
 S RET="",FNUM=$$FNUM
 S VFIEN=+INP
 S VFNEW='VFIEN
 S TYPE=+$P(INP,U,2)
 S (VIEN,APCDVSIT)=+$P(INP,U,3)
 I $$AICD^BGOUTL2 D
 .S (Y,APCDDATE)=+$G(^AUPNVSIT(VIEN,0))
 .S X=$$ICDOP^ICDEX(TYPE,Y,"","I")
 .I $P(X,U,1)=-1 S RET="-1^You may not use this ICD procedure for this visit date, please use visit services to assign this procedure" Q
 .I $P(X,U,10)'=1 S RET="-1^ICD procedure code is not active. Use visit service to enter an ICD procedure" Q
 .S IMP=$$IMP^ICDEX("10P",DT)    ;Get the implementaton date
 .I IMP>Y  D           ;This needs to be an ICD-9 code
 ..I $P(X,U,15)'=2  S RET="-1^You may not use this ICD procedure for this visit date, please use visit services to assign this procedure" Q
 .I IMP<Y D
 ..I $P(X,U,15)'=31 S RET="-1^You may not use this ICD procedure for this visit date, please use visit services to assign this procedure" Q
 E  D
 .S X=$G(^ICD0(TYPE,0))
 .I '$L(X) S RET=$$ERR^BGOUTL(1096) Q
 .I $P(X,U,9) S RET=$$ERR^BGOUTL(1097) Q
 .S X=$P(X,U,11)
 .S Y=+$G(^AUPNVSIT(VIEN,0))
 .I X,Y,$$FMDIFF^XLFDT(Y,X)>-1 S RET=$$ERR^BGOUTL(1097) Q
 Q:RET
 S DFN=+$P(INP,U,4)
 S EVNTDT=$$CVTDATE^BGOUTL($P(INP,U,5))
 I EVNTDT="" S EVNTDT=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 S PROCDT=$P(EVNTDT,".",1)
 S DX=$P(INP,U,6)
 S PRIN=$P(INP,U,7)
 S RET=$$FNDNARR^BGOUTL2($P(INP,U,8))
 Q:RET<0
 S NARR=$S(RET:"`"_RET,1:""),RET=""
 S INFECT=$P(INP,U,9)
 S OPRPRV=$P(INP,U,10)
 S ANESTH=$P(INP,U,11)
 S ANESTIME=$P(INP,U,12)
 S LOCIEN=$P(INP,U,13)
 S OUTLOC=$P(INP,U,14)
 S HIST=$P(INP,U,15)
 S DUPS=$P(INP,U,16)
 I 'VIEN,'HIST S RET=$$ERR^BGOUTL(1002) Q
 S VCAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 S:VCAT="E" HIST=1
 I HIST D  Q:RET<0
 .S RET=$$MAKEHIST^BGOUTL(DFN,EVNTDT,$S($L(OUTLOC):OUTLOC,1:LOCIEN),VIEN)
 .S:RET>0 VIEN=RET
 S RET=$$CHKVISIT^BGOUTL(VIEN,DFN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,TYPE,VIEN,$S('DUPS:"Procedure",1:""))
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.01)="`"_TYPE
 S @FDA@(.04)=NARR
 S @FDA@(.05)=$S(DX:"`"_DX,1:"")
 S @FDA@(.06)=PROCDT
 S @FDA@(.07)=PRIN
 S @FDA@(.08)=INFECT
 S @FDA@(.11)=$S(OPRPRV:"`"_OPRPRV,1:"")
 S @FDA@(.12)=$S(ANESTH:"`"_ANESTH,1:"")
 S @FDA@(.13)=ANESTIME
 S @FDA@(1201)=$S(EVNTDT:EVNTDT,1:"N")
 S @FDA@(1204)="`"_DUZ
 ;Patch 11 Set date entered
 I VFNEW D
 .S @FDA@(1216)="N"
 .S @FDA@(1217)="`"_DUZ
 ;Patch 11 Set last modified
 S @FDA@(1218)="N"
 S @FDA@(1219)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ;  INP = Lookup Value [1] ^ VIEN [2]
 ;  LKP = Text to lookup
 ;  VIEN = Visit IEN
LOOKUP(RET,INP) ;Lookup an ICD0 term with this call after AICD patch is installed
 N GBL,LKP,FROM,DIR,MAX,XREF,INP2,RET2,I,CNT,VIEN,VDT,ROOT,X,Y,VER,OUT,SYS
 N FLDS,IEN,IMP
 S GBL=80.1
 S RET=$$TMPGBL
 K ^TMP("ICD0",$J)
 S LKP=$P(INP,U,1)
 Q:LKP="" RET
 S VIEN=$P(INP,U,2)
 S VDT=""
 I +VIEN S VDT=$$GET1^DIQ(9000010,VIEN,.01,"I")
 I VDT="" S VDT=DT
 S FLDS=".01"
 S CNT=0
 S FROM=LKP
 S DIR=1
 S MAX=999,XREF="D"
 S INP2="80.1"_U_LKP_U_FROM_U_DIR_U_MAX_U_XREF_"^^^"_U_VDT
 D DICLKUP^BGOUTL(.RET2,INP2)
 M RET=RET2
 Q
 ; Return V File #
FNUM() Q 9000010.08
TMPGBL(X) ;EP
 K ^TMP("BGOPRC",$J) Q $NA(^($J))
