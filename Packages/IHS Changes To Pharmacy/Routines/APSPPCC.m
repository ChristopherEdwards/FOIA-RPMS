APSPPCC ;IHS/CIA/DKM/PLS - PCC Hook for Pharmacy Package ;21-Apr-2011 10:37;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1003,1004,1006,1007,1008,1009,1010**;Sep 23, 2004
 ; EP - Called by event protocol.
 ;   DATA  = Event message.  May either be a global reference or
 ;           a local array passed by reference.
 ;  REPROC = If this is a reprocessed message, this should contain
 ;           the index of the message in the XTMP global.
 ; Modified - IHS/MSC/PLS - 02/04/08 - Line POV - changed v68.1 to primary
 ;                          02/05/08 - API PRVNARR  modified
 ;                          01/27/09 - LOCADJ+4
 ;                          01/28/09 - Checks for SUSPENSE status
 ;                          08/25/10 - DOIT+40
 ;                          02/10/11 - Added support of POV for Suspense
EN(DATA,REPROC) ;EP
 N MSG
 I $D(DATA)=1 M MSG=@DATA
 E  M MSG=DATA
 S MSG=$S($G(REPROC):REPROC,1:-1)
 ;I $$QUEUE^CIAUTSK("TASK^APSPPCC","PCC VMED FILER",,"MSG^MSG(")
 D TASK
 Q
 ; Taskman entry point
TASK ;EP
 N SEG,LP,DL1,DL2,IEN
 S ZTREQ="@"
 S LP=0
 S SEG=$$SEG("MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 Q:$P(SEG,DL1,3)'="PHARMACY"
 S SEG=$$SEG("PID",.LP)
 Q:'LP
 Q:'$P(SEG,DL1,4)
 S SEG=$$SEG("ORC",.LP)
 Q:'LP
 S IEN=$P($P(SEG,DL1,4),U)
 I IEN?1.N1"N" D EN^APSPPCC2(IEN,.MSG)  ;IHS/MSC/PLS 10/29/07 - Outside Meds
 Q:IEN'=+IEN
 D LOG("MSG",.MSG)
 K:$$PROCESS(IEN,,MSG,1)<0 ZTREQ
 Q
 ; EP - Process a script
 ;   IEN = IEN of prescription
 ;   REF = Refill # (0=original fill,>0=refill,missing=last)
 ;   MSG = Message log IEN
 ;   BUL = If nonzero, a bulletin is fired on error
PROCESS(IEN,REF,MSG,BUL) ;EP
 N PRV,SIG,RX0,RX2,RX3,PCC,LOC,DAT,DIV,INS,RTS,PHM,QTY,DAY,CAN,DFN,OPV
 N VMED,VM0,VSTR,VSIT,ERR,ACT,COM,RXID,PLOC,PRI,POV,DRG,STA,RF0,LFN,X
 N DEFOLOC,VSVCCAT
 S ERR="",MSG=$G(MSG),BUL=$G(BUL)
 L +^APSPPCC(IEN):5
 I  D
 .D DOIT
 .L -^APSPPCC(IEN)
 E  S ERR="-1^Timeout while trying to lock record."
 D:ERR LOG("ERR",.MSG)
 D:ERR<0 BUL(IEN,.DFN,.MSG,ERR):BUL
 ;IHS exemption approved on 3/29/2007
 Q:$Q ERR
 Q
DOIT ;EP
 D LOG($NA(^PSRX(IEN)),.MSG)
 S RX0=$G(^PSRX(IEN,0)),RX2=$G(^(2)),RX3=$G(^(3)),STA=+$G(^("STA")),LFN=+$O(^(1,$C(1)),-1)
 S RXID=$P(RX0,U)
 S DFN=$P(RX0,U,2)
 ;IHS/CIA/PLS - 05/23/06 - Commented out next line and added the line after.
 ;K:STA'<10 ^PS(55,DFN,"P","CP",IEN)
 ; Chronic Med flag is cleared if status is: DISCONTINUED, DELETED, DISCONTINUED BY PROVIDER or
 ;     DISCONTINUED (EDIT)
 D:STA>11&(STA<16) KILLOCM^PSORN52(IEN)
 I STA=13,LFN S ERR="1^Prescription logically deleted." Q  ;Ignore if deleted with refills remaining
 S CAN=$P(RX3,U,5)
 I STA=14,'CAN S CAN=$P($G(^OR(100,+$P($G(^PSRX(IEN,"OR1")),U,2),6)),U,3)
 S DRG=$P(RX0,U,6)   ;Drug
 S SIG=$P(RX0,U,10)  ;SIG
 S LOC=$P(RX0,U,5)   ;Clinic (File 44 IEN)
 S:'$L(SIG) SIG=$P($G(^PSRX(IEN,"SIG")),U)
 I '$L(SIG) D
 .F X=0:0 S X=$O(^PSRX(IEN,"SIG1",X)) Q:'X  S SIG=SIG_$S($L(SIG):" ",1:"")_^(X,0) Q:$L(SIG)>144
 S:'$D(REF) REF=LFN
 S RF0=$S(REF:$G(^PSRX(IEN,1,REF,0)),1:RX0)
 S VMED=+$S(REF:$G(^PSRX(IEN,1,REF,999999911)),1:$G(^PSRX(IEN,999999911)))
 S DAT=+$S(REF:$P(RF0,U),1:$P(RX2,U,2))
 ;I STA=3,'DAT S DAT=DT  ; Substitute Today's Date if Fill Date null.
 ;IHS/MSC/PLS - 01/28/09 - Added check for suspense status
 I (STA=3!(STA=5)),'DAT S DAT=DT  ; Substitute Today's Date if Fill Date null.
 I 'DAT S ERR="1^Not released." Q
 I DAT>DT,'VMED S ERR="1^Future Fill Date - Suspense" Q
 I REF D  ; Use Refill Date for refills
 .I DAT>DT S DAT=+$P(RF0,U,19) ; Use Dispense date if Refill Date>Today
 I 'DAT S ERR="1^No date associated with fill."
 S:DAT#1=0 DAT=DAT+.12
 S DIV=+$P($S(REF:RF0,1:RX2),U,9),INS=$$INS(DIV)
 I 'INS S ERR="1^Hook disabled for division." Q
 S DEFOLOC=$P($G(^APSPCTRL(DIV,1)),U,2)
 S:'DEFOLOC DEFOLOC=INS
 S RTS=$S(REF:$P(RF0,U,16),1:$P(RX2,U,15))\1
 S COM=$S(RTS:"RETURNED TO STOCK",1:"@")
 S VMED=+$S(REF:$G(^PSRX(IEN,1,REF,999999911)),1:$G(^PSRX(IEN,999999911)))
 ;S ACT=$S(STA=13:"-",STA=16:"-",STA=3:"-",VMED:"",1:"+")
 ;IHS/MSC/PLS - 01/28/09 - Added check for suspense status
 S ACT=$S(STA=13:"-",STA=16:"-",STA=3:"-",STA=5:"-",VMED:"",1:"+")
 I 'VMED,ACT="-" Q
 ;IHS/MSC/PLS - 02/10/2011 - removed restriction for refill on POV process
 ; Process Paperless Refills
 ;I +$$GET1^DIQ(9009033,+$G(DIV),315,"I") D
 ;.;IHS/MSC/PLS - 08/25/10 - Logic changed to obtain cached POV from Parameter
 ;.;Q:'$L($G(^XTMP("APSPPCC.VPOV",+IEN,+REF)))
 ;.Q:'$D(^PSRX(IEN,1,REF))  ; Refill check
 ;.;S POV=$G(^XTMP("APSPPCC.VPOV",IEN,REF))
 ;.S POV=$TR($$GET^XPAR("SYS","APSP POV CACHE",+IEN_","_+REF),"~",U)
 ;.Q:'$L(POV)
 ;.S DAT=$P(DAT,".")_".13"
 ;.;K ^XTMP("APSPPCC.VPOV",IEN,REF)
 ; Check for cached POV
 S POV=$TR($$GET^XPAR("SYS","APSP POV CACHE",+IEN_","_+REF),"~",U)
 ; Refills or suspended prescriptions will be set to 1300 unless the
 ; suspended prescription is an original dispensed on the day of release.
 I $L(POV),$P(RX0,U,13)'=$P(DAT,".") D  ; if issue date<>fill date
 .S DAT=$P(DAT,".")_".13"
 E  D
 .D:$L(POV)&(ACT'="-") DEL^XPAR("SYS","APSP POV CACHE",+IEN_","_+REF)
 .K POV
 ; Provider is set to Clerk if Paperless Refill otherwise to Ordering Provider
 ;S (OPV,PRV)=$S($D(POV):$$NPF($P(RF0,U,7)),1:$$NPF(+$P(RX0,U,4)))
 ;IHS/CIA/PLS - 10/07/05 - Changed following line to look at clerk if paperless refill, refill provider if regular refill or prescription provider
 ;S PRV=$S($D(POV):$$NPF($P(RF0,U,7)),1:$$NPF(+$P(RX0,U,4)))
 ;IHS/MSC/PLS - 10/23/07 - Changed following line to add support for requesting refill provider
 ;S PRV=$S($D(POV):$$NPF($P(RF0,U,7)),REF:$$NPF($P(RF0,U,17)),1:$$NPF(+$P(RX0,U,4)))
 S PRV=$S($D(POV):$S(REF:$$NPF($P(RF0,U,7)),1:$$NPF(+$P($G(^PSRX(IEN,"OR1")),U,5))),REF:$$REFPRV(IEN,REF),1:$$NPF(+$P(RX0,U,4)))
 S OPV=$S(REF:$$NPF($P(RF0,U,17)),1:$$NPF(+$P(RX0,U,4)))  ;Provider
 S PHM=$$NPF(+$P(RX2,U,3))                       ;Pharmacist
 S:REF PHM=$$NPF($P(RF0,U,7))                    ;Clerk Code
 S:'PHM PHM=$$NPF(+$P($G(^PSRX(IEN,"OR1")),U,5)) ;Finishing Person
 S:'PHM PHM=$$NPF(+$P(RX0,U,16))                 ;Entered By
 S QTY=$P(RF0,U,$S(REF:4,1:7))
 S DAY=$P(RF0,U,$S(REF:10,1:8))
 ;S VMED=+$S(REF:$G(^PSRX(IEN,1,REF,999999911)),1:$G(^PSRX(IEN,999999911)))
 ;;S ACT=$S(STA=13:"-",STA=16:"-",STA=3:"-",VMED:"",1:"+")
 ;;IHS/MSC/PLS - 01/28/09 - Added check for suspense status
 ;S ACT=$S(STA=13:"-",STA=16:"-",STA=3:"-",STA=5:"-",VMED:"",1:"+")
 ;I 'VMED,ACT="-" Q
 S VM0=$S(VMED:$G(^AUPNVMED(VMED,0)),1:"")
 S VSIT=$P(VM0,U,3)
 S VSVCCAT="A"
 ;IHS/CIA/PLS - 10/07/05 - Changed to pass clinic (if defined) or zero for ancillary
 ;S LOC=$S($D(POV):$O(^DIC(40.7,"C",39,0)),1:0)  ; Set location to pharmacy stop code if Paperless refill
 ;Old format = VSTR format = zero or Clinic Stop Code; Date/Time of Visit;Visit Category
 S LOC=$$LOCADJ(LOC,IEN,RXID)  ; IHS/CIA/PLS - 12/30/05 - Call to adjust the hospital location for REFILL and RENEWED orders
 S:$D(POV) LOC=0
 ; New VSTR format = Hospital Location IEN; Date/Time of Visit;Visit Category
 I $P($G(^PSRX(IEN,999999921)),U,4) D  ; Electronic Pharmacy
 .N EPHARM
 .S EPHARM=$$GET1^DIQ(9009033.9,$$GET1^DIQ(52,IEN,9999999.24,"I"),.01)
 .S VSIT=$S('VSIT:";"_DEFOLOC_";"_EPHARM,1:VSIT)
 .S VSVCCAT="E"
 S VSTR=LOC_";"_DAT_";"_VSVCCAT_";"_VSIT  ; Location is either a pointer to clinic stop code or a zero
 ;S (PRV,PHM,PRI)=0
 I $D(POV) D
 .S PRI=1,PHM=0
 .S X=$$VSTR2VIS^APSPPCCV(DFN,.VSTR,1,PRV,DIV,1)   ;Find or create a visit using clerk code
 E  D
 .S X=$$VSTR2VIS^APSPPCCV(DFN,.VSTR,1,PRV,DIV,0)   ;Find or create a visit using ordering provider
 .;I X'>0!(+VSTR=PLOC) S LOC=PLOC,$P(VSTR,";")=PLOC,PRV=0,PHM=0,PRI=1
 .I X'>0 S PRV=0,PHM=0,PRI=1
 .E  S (PRV,PHM,PRI)=0
 D ADD("HDR^^^"_VSTR)
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_DAT)
 D:$D(POV)&PRV ADD("PRV^"_PRV_"^^^^"_PRI)
 D:PHM ADD("PRV^"_PHM_"^^^^0")
POV I $D(POV) D
 .;D:POV'="" ADD("POV^"_$P(POV,U)_"^^"_$P(POV,U,2)_"^0^2")  ;IHS/MSC/PLS - 02/04/2008 - Changed to secondary
 .D:POV'="" ADD("POV^"_$P(POV,U)_"^^"_$P(POV,U,2)_U_$S(REF:0,1:1)_U_$S(REF:2,1:1))  ;IHS/MSC/PLS - 04/21/2011
 .D:REF ADD("POV^"_"V68.1"_"^^"_$$PRVNARR("MEDICATION REFILL")_"^1^2")  ;IHS/MSC/PLS - 02/04/2008 - Changed to primary
 .;IHS/MSC/PLS - 08/25/2010 - remove the cached data
 .Q:ACT="-"  ;Leave in cache
 .D DEL^XPAR("SYS","APSP POV CACHE",+IEN_","_+REF)
 I VM0,DRG'=+VM0 D ADD("RX-^"_+VM0_U_VMED_U_IEN_U_REF) S ACT="+"
 D ADD("RX"_ACT_U_DRG_U_VMED_U_IEN_U_REF_U_$S(OPV:OPV,1:"")_U_QTY_U_DAY_U_$S(RTS:RTS,1:CAN)_U_RXID)
 D:$L(COM) ADD("COM^1^"_COM)
 D ADD("SIG^1^"_$S($L(SIG)<146:SIG,1:$E(SIG,1,144)_"~"))
 D LOG("PCC",.MSG)
 D SAVE^APSPPCCV(.ERR,.PCC)
 Q
 ; Add to PCC array
ADD(X) S PCC=$G(PCC)+1,PCC(PCC)=X
 Q
 ; Adjust file 200 pointer if file 16 conversion not done
NPF(IEN) Q +$S('$D(^VA(200,+IEN,0)):0,$P($G(^AUTTSITE(1,0)),U,22):IEN,1:$P(^VA(200,+IEN,0),U,16))
 ; Return institution if PCC capture enabled for division
INS(DIV) Q $S($P($G(^APSPCTRL(+DIV,0)),U,15)="Y":+$G(^PS(59,+DIV,"INI")),1:0)
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(MSG(LP)) Q:'LP  Q:$E(MSG(LP),1,$L(TYP))=TYP
 Q $S(LP:MSG(LP),1:"")
 ; Send a bulletin on error
BUL(IEN,DFN,MSG,ERR) ;
 N XMB,XMTEXT,XMY,XMDUZ,XMDT,XMYBLOB,XMZ
 S XMB="APSP LINK FAIL VMED"
 S XMB(1)=$G(IEN,"UNKNOWN")
 S XMB(2)=$P($G(^DPT(DFN,0)),U)
 S XMB(3)=$G(MSG,"UNKNOWN")
 S XMB(4)=$$FMTE^XLFDT(DT)
 S XMB(5)=$P(ERR,U,2)
 S XMDUZ=.5
 D ^XMB
 Q
 ; Log data
LOG(ARY,CNT) ;
 Q:'$G(CNT)
 Q:'$$GET^XPAR("ALL","APSPPCC LOG MESSAGES")
 N SUB,NMSP
 S SUB="APSPPCC",NMSP=$TR($P(ARY,"("),U)
 L +^XTMP(SUB):2
 S ^XTMP(SUB,0)=$$FMADD^XLFDT(DT,7)_U_$$DT^XLFDT
 S:CNT<0 CNT=1+$O(^XTMP(SUB,""),-1)
 K ^XTMP(SUB,CNT,NMSP)
 M ^XTMP(SUB,CNT,NMSP)=@ARY
 L -^XTMP(SUB)
 Q
 ; Return Provider Narrative IEN
PRVNARR(TXT) ; EP
 N IEN,FDA,IENS,ERR
 Q:'$L(TXT) ""
 S IEN=$O(^AUTNPOV("B",$E(TXT,1,30),0))  ; IHS/MSC/PLS - 02/05/08 - Changed lookup to 30 characters
 I 'IEN D
 .S FDA(9999999.27,"+1,",.01)=$E(TXT,1,80)  ; IHS/MSC/PLS - 02/05/08 - Changed set to 80 characters
 .D UPDATE^DIE("","FDA","IENS","ERR")
 .I $G(ERR) S IEN=""
 .E  S IEN=$G(IENS(1))
 Q IEN
 ; Return Inpatient Location IEN or Zero
 ; VAINDT contains inpatient admission date or defaults to today
INPAT(DFN,VAINDT) ;
 N RET,VAIN
 D INP^VADPT
 S RET=+$G(VAIN(4))
 Q RET
 ; Return adjusted Hospital Location IEN
 ; The visit location will be returned as zero using the following rules:
 ;   1) Refill orders - Orders processed using options other than PSO LMOE FINISH
 ;   2) Renew orders - Orders processed using options other than PSO LMOE FINISH
 ;
LOCADJ(LOC,RXIEN,RXN) ;EP
 I $G(PSOFROM)="REFILL",$G(XQY0)'["PSO LMOE FINISH" S LOC=0
 I $G(PSOFROM)="NEW",RXN?.N1.U,$G(XQY0)'["PSO LMOE FINISH" S LOC=0
 ; IHS/MSC/PLS - 01/27/2009 - If new prescription and Fill Date <> Issue Date
 I $G(PSOFROM)="NEW",($P($G(^PSRX(RXIEN,2)),U,2)'=$P($G(^PSRX(RXIEN,0)),U,13)) S LOC=0
 Q LOC
 ; IHS/MSC/PLS - 10/24/07
REFPRV(RX,REF) ;EP
 N RES,PRV,RPRV
 S PRV=$P(^PSRX(RX,1,REF,0),U,17)
 S RPRV=$P(^PSRX(RX,1,REF,9999999),U)
 S RES=$S(RPRV:RPRV,1:PRV)
 Q RES
