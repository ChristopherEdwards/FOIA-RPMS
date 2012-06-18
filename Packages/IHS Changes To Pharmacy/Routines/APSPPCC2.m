APSPPCC2 ;IHS/CIA/PLS - PCC Hook for Pharmacy Package - Continued ;12-Feb-2008 16:01;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1006**;Sep 23, 2004
 ; Outside Medication VMED support
EN(IEN,MSG) ;EP
 ; Mapping Table
 ; NVA                       VMED
 ; Dispense Drug             Drug (.01)
 ; File 55 .01               .02
 ; Medication Route          SIG
 ; Documented Date           Visit Date
 ; Clinic                    Visit Clinic
 ; Disclaimer                Comment
 ; Discontinued Date         Date Discontinued
 ; IEN                       EHR Outside Med
 ;
 N DEFOLOC,IN,OUT,DFN,SEG,LP,DL1,DL2,ERR,PCC,SIG,ORDNUM
 N VSTR,NVA0,COM,STATUS,VMED,VSIT,VM0,DAT,DRG,CAN,COM1
 S LP=0
 S SEG=$$SEG^APSPPCC("MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 S SEG=$$SEG^APSPPCC("PID",.LP)
 S DFN=$P(SEG,DL1,4)
 Q:'DFN
 S DEFOLOC=$$GET^XPAR("ALL","BEHOENCX OTHER LOCATION")
 S:'DEFOLOC DEFOLOC=DUZ(2)
 ;D LOG
 ;
 S NVA0=$G(^PS(55,DFN,"NVA",+IEN,0))
 S DRG=$P(NVA0,U,2)
 S CAN=$P(NVA0,U,7)
 S ORDNUM=$P(NVA0,U,8)
 S SIG=$$SIG(ORDNUM)
 S VMED=$G(^PS(55,DFN,"NVA",+IEN,999999911))
 S VM0=$S(VMED:$G(^AUPNVMED(VMED,0)),1:"")
 S DAT=+$S($P(NVA0,U,9):$P(NVA0,U,9),1:$P(NVA0,U,10))
 S VSIT=$P(VM0,U,3)
 S VSTR="0;"_DAT_";E;"_$S('VSIT:";"_-DEFOLOC,1:VSIT)
 S STATUS=$P(NVA0,U,6)
 S ACT=$S(STATUS:"",VMED:"",1:"+")
 S COM=$O(^PS(55,DFN,"NVA",1,"DSC",0))
 S:COM COM1=$O(^PS(55,DFN,"NVA",1,"DSC",COM))
 S:COM COM=$G(^PS(55,DFN,"NVA",1,"DSC",COM,0))
 D ADD("HDR^^^"_VSTR)
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_DAT)
 ;I VM0,DRG'=+VM0 D ADD("RX-^"_+VM0_U_VMED_U_IEN) S ACT="+"
 D ADD("RXV"_ACT_U_DRG_U_VMED_U_IEN_U_DFN_U_U_U_U_CAN_U)
 D:$L(COM) ADD("COM^1^"_$S($L(COM)<71:COM,1:$E(COM,1,69)_"~"))
 D ADD("SIG^1^"_$S($L(SIG)<146:SIG,1:$E(SIG,1,144)_"~"))
 D SAVE^APSPPCCV(.ERR,.PCC)
 Q
ADD(X) S PCC=$G(PCC)+1,PCC(PCC)=X
 Q
 ; Return SIG from Order
SIG(ORIFN) ;EP
 N ID,LP,SIG
 Q:'$G(ORIFN) ""
 S ID=$$PTR(ORIFN,"SIG")
 Q:'ID ""
 S SIG=""
 S LP=0 F  S LP=$O(^OR(100,ORIFN,4.5,ID,2,LP)) Q:'LP  D
 .S SIG=SIG_$S($L(SIG):" ",1:"")_^OR(100,ORIFN,4.5,ID,2,LP,0)
 Q SIG
PTR(ORIFN,ID) S ID=$O(^OR(100,ORIFN,4.5,"ID",ID,0))
 Q ID
