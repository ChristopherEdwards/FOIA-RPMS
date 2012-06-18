BHLRLAB ;cmi/flag/maw - BHL Setup Ref Lab Segments 
 ;;3.01;BHL IHS Interfaces with GIS;**4**;OCT 15, 2002
 ;
 ;
 ;this routine will setup special formatting for data residing in the
 ;PV1, OBR, and OBX segments
 ;
ORM ;EP - this is the main routine driver
 D MORC,MOBR
 Q
 ;
ORU ;EP - this is the main routine driver
 D PV1,OBR,OBX
 Q
 ;
PV1 ;-- setup PV1 data
 S INA("PV13LAB",1)=$$PLOC(BHL("VIEN"))
 S INA("PV110LAB",1)=$$CLNC(BHL("VIEN"))
 Q
 ;
OBR ;-- setup OBR data
 S BHL("VLAB")=$G(INDA(9000010.09,1))
 S INA("OBR4LAB",1)=$$LOINC(BHL("VLAB"))
 S INA("OBR16LAB",1)=CS_$$GET1^DIQ(9000010.09,BHL("VLAB"),1202,"E")
 Q
 ;
OBX ;-- setup OBX data
 S INA("OBX7LAB",1)=$$REFLH(BHL("VLAB"))
 S INA("OBX8LAB",1)=$P($G(^AUPNVLAB(BHL("VLAB"),0)),U,5)
 Q
 ;
MORC ;-- setup ORM ORC segment
 S INA("ORC2LABO")=""
 S INA("ORC12LABO")=""
 Q
 ;
MOBR ;-- setup ORM ORC segment
 S INA("OBR4LABO")=""
 S INA("OBR7LABO")=""
 S INA("OBR22LABO")=""
 S INA("OBR27LABO")=""
 Q
 ;
PLOC(BHLZX)        ;-- get patient location
 S BHL("LOCI")=$P($G(^AUPNVSIT(BHLZX,0)),U,6)
 I BHL("LOCI")="" Q ""
 S BHL("ASUFAC")=$P($G(^AUTTLOC(BHL("LOCI"),0)),U,10)
 S BHL("LOCE")=$$VAL^XBDIQ1(9000010,BHLZX,.06)
 Q BHL("ASUFAC")_CS_BHL("LOCE")_CS_"99IHS"
 ;
CLNC(BHLZX)        ;-- get patient clinic code
 S BHL("CLNI")=$P($G(^AUPNVSIT(BHLZX,0)),U,8)
 I BHL("CLNI")="" Q ""
 S BHL("CLNC")=$P($G(^DIC(40.7,BHL("CLNI"),0)),U,2)
 Q BHL("CLNC")
 ;
LOINC(BHLZV)       ;-- get loinc setup
 S BHL("LABTI")=$P($G(^AUPNVLAB(BHLZV,0)),U)
 S BHL("LABTE")=$P($G(^LAB(60,BHL("LABTI"),0)),U)
 S BHL("LOINC")=$P($G(^AUPNVLAB(BHLZV,11)),U,13)
 I BHL("LOINC")="" Q ""
 S BHLCHK=$P($G(^LAB(95.3,BHL("LOINC"),9999999)),U,2)
 ;Q BHL("LOINC")_CS_BHL("LABTE")_CS_"L"
 Q BHLCHK_CS_BHL("LABTE")_CS_"LN"  ;maw chk digit
 ;
REFLH(BHLZV)       ;-- set up ref low/high
 S BHL("REFL")=$P($G(^AUPNVLAB(BHLZV,11)),U,4)
 S BHL("REFH")=$P($G(^AUPNVLAB(BHLZV,11)),U,5)
 Q BHL("REFL")_" - "_BHL("REFH")
 ;
