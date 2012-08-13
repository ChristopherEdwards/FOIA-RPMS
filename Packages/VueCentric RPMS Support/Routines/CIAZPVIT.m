CIAZPVIT ;CIA/DKM - PCC Data Capture Hook for Vitals Package;04-May-2004 16:20;DKM
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;;Copyright 2000-2004, Clinical Informatics Associates, Inc.
 ;=================================================================
 ; Store Vital Measurement entry into PCC
VIT2VMSR(IEN) ; EP
 N PCC,GMR0,VSTR,VT,QL,QX,DFN,VMSR,ACT,X
 S GMR0=$G(^GMR(120.5,+IEN,0)),VMSR=+$G(^(9999999))
 Q:'$L(GMR0)
 S VSTR=$P(GMR0,U,5)_";"_+GMR0,VT=$P(GMR0,U,3),DFN=$P(GMR0,U,2)
 S:VT VT=$$GET1^DIQ(120.51,VT,7),VT=$$FIND1^DIC(9999999.07,,,VT)
 Q:'VSTR!'VT
 S ACT=$S($G(^GMR(120.5,IEN,2)):"-",VMSR:"",1:"+")
 I 'VMSR,ACT="-" Q
 D INPLOC^CIAVCXPT(.X,DFN)
 S VSTR=VSTR_";"_$S(X:"H",1:"A")
 D ADD("HDR^^^"_VSTR)
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_+GMR0)
 D ADD("VIT"_ACT_U_VT_U_VMSR_U_IEN_U_$P(GMR0,U,8))
 S QL="",QX=0
 F  S QX=$O(^GMR(120.5,IEN,5,QX)) Q:'QX  S X=+$G(^(QX,0)) D:X
 .S QL=QL_$S($L(QL):", ",1:"Qualifiers: ")_$$GET1^DIQ(120.52,X,.01)
 D:$L(QL) ADD("COM^^"_QL)
 D SAVE^CIAVCXPC(,.PCC)
 Q
ADD(X) S PCC=$G(PCC)+1,PCC(PCC)=X
 Q
 ; EP - Initial population of V MEASUREMENT from GMRV
POPPCC N IEN
 F IEN=0:0 S IEN=$O(^GMR(120.5,IEN)) Q:'IEN  D VIT2VMSR(IEN)
 Q
