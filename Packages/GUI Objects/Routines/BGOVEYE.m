BGOVEYE ; IHS/MSC/MGH - V EyeGlass Management ;10-Jul-2014 12:07;MGH
 ;;1.1;BGO COMPONENTS;**11,14**;Mar 20, 2007;Build 2
 ;----------------------------------------------------------------
 ; Return last eyeglass record for a patient
 ;  DFN = Patient IEN
 ; .RET = Returned as a list of records:
 ;  RET(1)=IEN [1] ^ Visit Date [2] ^Facility Name [3] ^Provider IEN [4] ^ Location Name [5] ^ Entered Date [6] ^ Visit IEN [7] ^ Visit Category [8] ^ Visit Locked [9]
 ;  RET(2)=Left sphere [1] ^ left cyl [2] ^ left axis [3] ^ L prism H [4] ^ L Prism HD [5] ^ L Prism V [6] ^ L Prism VD [7] ^ L reading [8]
 ;  RET(3)=Right sphere [1] ^ Right cyl [2] ^ Right axis [3] ^ R prism H [4] ^ R Prism HD [5] ^ R Prism V [6] ^ R Prism VD [7] ^ R reading [8]
 ;  RET(4)=Reading [1] ^ PD Near [2] ^ PD Far [3] ^ LPD [4] ^ RPD [5]
 ;  RET(5)=Comment
GET(RET,DFN,VIEN) ;EP
 N X,CNT,REC,VCAT,EYE,VDT,IND,LOC,FAC,FACNAM,EXNAME,PRVIEN,PRVNAME,EDATA,READ
 N FNUM,VDATE,EDATE,COMMENT,EYE,LSPHERE,RSPHERE,LAXIS,RAXIS,LCYL,RCYL,LPD,RPD,LREAD,RREAD
 N LPRISMH,PDNEAR,PDFAR,LRPISMH,LPRISMHN,LPRISMHV,LPRISMV,LPRISMVN,LPRISMVV,RPRISMH,RPRISMHN,RPRISMV,RPRISMHV,RPRISMVN,RPRISMVV
 S RET=$$TMPGBL^BGOUTL
 S CNT=0
 I $G(VIEN)'="" D
 .;Get eyeglass prescription for the visit
 .S EYE=$C(0)
 .S EYE=$O(^AUPNVEYE("AD",VIEN,EYE),-1) Q:'EYE  D
 ..S REC=$G(^AUPNVEYE(EYE,0))
 ..Q:REC=""
 ..D DATA
 E  D
 .;Get last eyeglass prescription
 .S VDT=0
 .S VDT=$O(^AUPNVEYE("AA",DFN,VDT)) Q:'VDT  D
 ..S EYE=$C(0)
 ..F  S EYE=$O(^AUPNVEYE("AA",DFN,VDT,EYE),-1) Q:'EYE  D
 ...S REC=$G(^AUPNVEYE(EYE,0))
 ...Q:REC=""
 ...D DATA
 Q
DATA S FNUM=$$FNUM
 ;Get visit data
 S PRVIEN=$P($G(^AUPNVEYE(EYE,12)),U,4)
 S PRVNAME=$S('PRVIEN:"",1:$P($G(^VA(200,+PRVIEN,0)),U))
 S VIEN=$P(REC,U,3)
 Q:'VIEN
 S LOC=$P($G(^AUPNVSIT(VIEN,0)),U,6)
 S FAC=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U,10),1:"")
 S FACNAM=$S(LOC:$P($G(^AUTTLOC(LOC,0)),U),1:"")
 S:FACNAM FACNAM=$P($G(^DIC(4,FACNAM,0)),U)
 S:$P($G(^AUPNVSIT(VIEN,21)),U)'="" FACNAM=$P(^(21),U)
 S VCAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 I '$D(VDT) D
 .S VDATE=$P($P($G(^AUPNVSIT(VIEN,0)),U,1),".",1)
 .S VDT=9999999-VDATE
 E  S VDATE=9999999-VDT
 S EDATE=$P($G(^AUPNVEYE(EYE,12)),U,1)
 I EDATE="" S EDATE=VDATE
 ;Get right eye data
 S EDATA=$G(^AUPNVEYE(EYE,19))
 S RSPHERE=$$EXTERNAL^DILFD(FNUM,1902,,$P(EDATA,U,2))
 S RCYL=$$EXTERNAL^DILFD(FNUM,1903,,$P(EDATA,U,3))
 S RAXIS=$$EXTERNAL^DILFD(FNUM,1904,,$P(EDATA,U,4))
 S RREAD=$$EXTERNAL^DILFD(FNUM,1908,,$P(EDATA,U,8))
 S RPRISMH=$$EXTERNAL^DILFD(FNUM,1915,,$P(EDATA,U,15))
 S RPRISMHN=+$G(RPRISMH)
 I RPRISMHN=0 S RPRISMHN=""
 S RPRISMHV=$S(RPRISMH["BI":"BI",RPRISMH["BO":"BO",RPRISMH["BU":"BU",RPRISMH["BD":"BD",1:"")
 S RPRISMV=$$EXTERNAL^DILFD(FNUM,1917,,$P(EDATA,U,17))
 S RPRISMVN=+$G(RPRISMV)
 I RPRISMVN=0 S RPRISMVN=""
 S RPRISMVV=$S(RPRISMV["BI":"BI",RPRISMV["BO":"BO",RPRISMV["BU":"BU",RPRISMV["BD":"BD",1:"")
 S RPD=$$EXTERNAL^DILFD(FNUM,1920,,$P(EDATA,U,20))
 ;Get left eye data
 S LSPHERE=$$EXTERNAL^DILFD(FNUM,1902,,$P(EDATA,U,5))
 S LCYL=$$EXTERNAL^DILFD(FNUM,1903,,$P(EDATA,U,6))
 S LAXIS=$$EXTERNAL^DILFD(FNUM,1904,,$P(EDATA,U,7))
 S LREAD=$$EXTERNAL^DILFD(FNUM,1909,,$P(EDATA,U,9))
 S LPRISMH=$$EXTERNAL^DILFD(FNUM,1916,,$P(EDATA,U,16))
 S LPRISMHN=+$G(LPRISMH)
 I LPRISMHN=0 S LPRISMHN=""
 S LPRISMHV=$S(LPRISMH["BI":"BI",LPRISMH["BO":"BO",LPRISMH["BU":"BU",LPRISMH["BD":"BD",1:"")
 S LPRISMV=$$EXTERNAL^DILFD(FNUM,1917,,$P(EDATA,U,18))
 S LPRISMVN=+$G(LPRISMV)
 I LPRISMVN=0 S LPRISMVN=""
 S LPRISMVV=$S(LPRISMV["BI":"BI",LPRISMV["BO":"BO",LPRISMV["BU":"BU",LPRISMV["BD":"BD",1:"")
 S LPD=$$EXTERNAL^DILFD(FNUM,1919,,$P(EDATA,U,19))
 ;Pupil distance
 S PDNEAR=$$EXTERNAL^DILFD(FNUM,1913,,$P(EDATA,U,13))
 S PDFAR=$$EXTERNAL^DILFD(FNUM,1914,,$P(EDATA,U,14))
 S READ=$$EXTERNAL^DILFD(FNUM,1901,,$P(EDATA,U,1))
 S COMMENT=$G(^AUPNVEYE(EYE,11))
 S CNT=CNT+1
 S @RET@(CNT)=EYE_U_VDATE_U_FACNAM_U_PRVIEN_U_LOC_U_EDATE_U_VIEN_U_VCAT_U_$$ISLOCKED^BEHOENCX(VIEN)
 S CNT=CNT+1
 S @RET@(CNT)=LSPHERE_U_LCYL_U_LAXIS_U_LPRISMHN_U_LPRISMHV_U_LPRISMVN_U_LPRISMVV_U_LREAD
 S CNT=CNT+1
 S @RET@(CNT)=RSPHERE_U_RCYL_U_RAXIS_U_RPRISMHN_U_RPRISMHV_U_RPRISMVN_U_RPRISMVV_U_RREAD
 S CNT=CNT+1
 S @RET@(CNT)=READ_U_PDNEAR_U_PDFAR_U_LPD_U_RPD
 S CNT=CNT+1
 S @RET@(CNT)=COMMENT
 Q
 ; Delete a V EYE GLASS
 ;  INP = IEN
DEL(RET,INP) ;EP
 N IEN,REFUSAL
 S IEN=+INP
 I 'IEN S RET=$$ERR^BGOUTL(1008)
 E  D VFDEL^BGOUTL2(.RET,$$FNUM,IEN)
 Q
 ; Set eyeglass prescription record
 ; DATA is an array
 ; DATA(0)=V File IEN (if edit) [1] ^ Patient ien [2] ^ visit ien [3] ^ provider [4] ^Event Date [5] ^ Location IEN [6] ^ Other Location [7] ^ Historical Flag [8]
 ; DATA(1)=Left sphere [1] ^ left cyl [2] ^ left axis [3] ^ L prism H [4] ^ L Prism HD [5] ^ L Prism V [6] ^ L Prism VD [7] ^ L reading [8]
 ; DATA(2)=Right sphere [1] ^ Right cyl [2] ^ Right axis [3] ^ R prism H [4] ^ R Prism HD [5] ^ R Prism V [6] ^ R Prism VD [7] ^ R reading [8]
 ; DATA(3)=Reading [1] ^ PD Near [2] ^ PD Far [3] ^ LPD [4] ^ RPD [5]
 ; DATA(4)=Comment
 ; .RET = Returned as -1^error text if error
SET(RET,DATA) ;EP
 N VFIEN,VCAT,TYPE,VIEN,DFN,PROV,RESULT,COMMENT,EVNTDT,LOCIEN,OUTLOC,HIST,FDA,FNUM,VFNEW
 N LEYE,REYE,PUPIL
 S RET="",FNUM=$$FNUM
 S INP=$G(DATA(0))
 S VFIEN=$P(INP,U,1)
 S VFNEW='VFIEN
 S LEYE=DATA(1)
 S REYE=DATA(2)
 S PUPIL=DATA(3)
 S TYPE=1
 S VIEN=+$P(INP,U,3)
 I 'VIEN S RET=$$ERR^BGOUTL(1077) Q
 S HIST=$P(INP,U,13)
 S DFN=$P(INP,U,2)
 I 'VIEN,'HIST S RET=$$ERR^BGOUTL(1002) Q
 S VCAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 S:VCAT="E" HIST=1
 S PROV=$P(INP,U,4)
 I 'PROV,VFIEN S RET=$$ERR^BGOUTL(1027) Q
 S EVNTDT=$P(INP,U,5)
 S LOCIEN=$P(INP,U,6)
 S OUTLOC=$P(INP,U,7)
 I HIST D  Q:RET
 .S RET=$$MAKEHIST^BGOUTL(DFN,EVNTDT,$S($L(OUTLOC):OUTLOC,1:LOCIEN),VIEN)
 .S:RET>0 VIEN=RET,RET="",VCAT="E"
 S RET=$$CHKVISIT^BGOUTL(VIEN,DFN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,TYPE,VIEN)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.01)=TYPE
 S @FDA@(1101)=$G(DATA(4))
 I $P(PUPIL,U,1)="" S $P(PUPIL,U,1)="@"
 S @FDA@(1901)=$P(PUPIL,U,1)
 I $P(REYE,U,1)="" S $P(REYE,U,1)="@"
 S @FDA@(1902)=$P(REYE,U,1)
 I $P(REYE,U,2)="" S $P(REYE,U,2)="@"
 S @FDA@(1903)=$P(REYE,U,2)
 I $P(REYE,U,3)="" S $P(REYE,U,3)="@"
 S @FDA@(1904)=$P(REYE,U,3)
 I $P(LEYE,U,1)="" S $P(LEYE,U,1)="@"
 S @FDA@(1905)=$P(LEYE,U,1)
 I $P(LEYE,U,2)="" S $P(LEYE,U,2)="@"
 S @FDA@(1906)=$P(LEYE,U,2)
 I $P(LEYE,U,3)="" S $P(LEYE,U,3)="@"
 S @FDA@(1907)=$P(LEYE,U,3)
 I $P(REYE,U,8)="" S $P(REYE,U,8)="@"
 S @FDA@(1908)=$P(REYE,U,8)
 I $P(LEYE,U,8)="" S $P(LEYE,U,8)="@"
 S @FDA@(1909)=$P(LEYE,U,8)
 I $P(PUPIL,U,2)="" S $P(PUPIL,U,2)="@"
 S @FDA@(1913)=$P(PUPIL,U,2)
 I $P(PUPIL,U,3)="" S $P(PUPIL,U,3)="@"
 S @FDA@(1914)=$P(PUPIL,U,3)
 I $P(REYE,U,4)="" S $P(REYE,U,4)="@"
 I $P(REYE,U,5)="" S $P(REYE,U,5)=""
 I $P(REYE,U,6)="" S $P(REYE,U,6)="@"
 I $P(REYE,U,7)="" S $P(REYE,U,7)=""
 I $P(LEYE,U,4)="" S $P(LEYE,U,4)="@"
 I $P(LEYE,U,5)="" S $P(LEYE,U,5)=""
 I $P(LEYE,U,6)="" S $P(LEYE,U,6)="@"
 I $P(LEYE,U,7)="" S $P(LEYE,U,7)=""
 S @FDA@(1915)=$P(REYE,U,4)_$P(REYE,U,5)
 S @FDA@(1916)=$P(LEYE,U,4)_$P(LEYE,U,5)
 S @FDA@(1917)=$P(REYE,U,6)_$P(REYE,U,7)
 S @FDA@(1918)=$P(LEYE,U,6)_$P(LEYE,U,7)
 I $P(PUPIL,U,4)="" S $P(PUPIL,U,4)="@"
 S @FDA@(1919)=$P(PUPIL,U,4)
 I $P(PUPIL,U,5)="" S $P(PUPIL,U,5)="@"
 S @FDA@(1920)=$P(PUPIL,U,5)
 I PROV=""!(PROV=0) S PROV=DUZ
 S:PROV @FDA@(1204)="`"_PROV
 I EVNTDT="" S EVNTDT="N"
 S @FDA@(1201)="N"
 I VFNEW D
 .S @FDA@(1216)="N"
 .S @FDA@(1217)="`"_DUZ
 S @FDA@(1218)="N"
 S @FDA@(1219)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
GETFLD(ARRAY) ;Get fields and values
 S ARRAY(1)="L SPHERE^Type a number between -28.00 and +16.00 (include the + or -) OR PLANO"
 S ARRAY(2)="R SPHERE^Type a number between -28.00 and +16.00 (include the + or -) OR PLANO"
 S ARRAY(3)="L CYL^Type a number between -9.50 AND +9.50 (include the  + or -)"
 S ARRAY(4)="R CYL^Type a number between -9.50 AND +9.50 (include the  + or -)"
 S ARRAY(5)="L AXIS^Type a whole number between 0 and 180"
 S ARRAY(6)="R AXIS^Type a whole number between 0 and 180"
 S ARRAY(7)="L PRISM H^Enter a number between .25 and 50"
 S ARRAY(8)="L BASE H^Base Up=BU, Base Down=BD, BI or BO"
 S ARRAY(9)="L PRISM V^Enter a number between .25 and 50"
 S ARRAY(10)="L BASE V^Base Up=BU, Base Down=BD, BI or BO"
 S ARRAY(11)="R PRISM H^Enter a number between .25 and 50"
 S ARRAY(12)="R BASE H^Base Up=BU, Base Down=BD, BI or BO"
 S ARRAY(13)="R PRISM V^Enter a number between .25 and 50"
 S ARRAY(14)="R BASE V^Base Up=BU, Base Down=BD, BI or BO"
 S ARRAY(15)="PD NEAR^Type a whole number between 40 and 80"
 S ARRAY(16)="PD FAR^Type a whole number between 40 and 80"
 S ARRAY(17)="LEFT PD^Type a whole number between 25 and 40"
 S ARRAY(18)="RIGHT PD^Type a whole number between 25 and 40"
 ; Return V File #
FNUM() Q 9000010.04
