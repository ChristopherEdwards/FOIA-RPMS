BYIMSEGS ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**3**;JAN 15, 2013;Build 79
 ;
 ;this routine will contain code to supplement fields in the
 ;HL7 segments
 ;
PV1 ;EP;FOR PV1 SEGMENT CONTENT
 D PV120
 Q
 ;-----
PV120 ;PV1-20 VFC
 S INA("PV120",1)=$$VFC^BYIMIMM3(INDA)
PV1END Q
 ;-----
 ;-----
PD1 ;EP;
 D PD13
 D PD111
 D PD112
 D PD113
 D PD116
 D PD117
 D PD118
 Q
 ;-----
PD13 ;setup for PD13 variable - location
 S INA("PD13",1)=""
 S INA("PD13",1)=$G(BYIM("PD13.1"))_CS_$G(BYIM("PD13.2"))
 Q:$L(INA("PD13",1))>1
 S INA("PD13",1)=$P($G(^AUTTLOC(+$G(DUZ(2)),0)),U,10)_CS_$P($G(^DIC(4,+$G(DUZ(2)),0)),U)
 Q
 ;-----
PD111 ;PD1-11 PUBLICITY
 S INA("PD111",1)=$$PUB^BYIMIMM3(INDA)
 Q
 ;-----
PD112 ;PD1-12
 S INA("PD112",1)=$$PROT^BYIMIMM3(INDA)
 Q
 ;-----
PD113 ;PD1-13
 S INA("PD113",1)=$$PROTDT^BYIMIMM3(INDA)
 S:INA("PD113",1)="" INA("PD113",1)=DT+17000000
 Q
 ;-----
PD116 ;PD1-16
 S X=$P($G(^BIP(INDA,0)),U,8)
 S INA("PD116",1)=$S('X:"A",1:"I")
 Q
 ;-----
PD117 ;PD1-17
 S INA("PD117",1)=$$ACTDT^BYIMIMM3(INDA)
 S:INA("PD117",1)="" INA("PD113",1)=DT+17000000
 Q
 ;-----
PD118 ;PD1-18
 I INA("PD111",1)="" S INA("PD118",1)="" Q
 S INA("PD118",1)=$$PUBDT^BYIMIMM3(INDA)
 S:INA("PD118",1)="" INA("PD113",1)=DT+17000000
 Q
 ;-----
PD1END Q
 ;-----
 ;-----
ORC ;EP; - for ORC components
 D VSET(INDA)
 D ORC1
 D ORC2
 D ORC3
 D ORC5
 D ORC10
 D ORC12
 D ORC17
 Q
 ;-----
ORC1 ;
 S INA("ORC1",INDA)="RE"
 Q
 ;-----
ORC2 ;
 S INA("ORC2",INDA)=INDA_"-"_$P($G(^AUTTLOC(+$G(DUZ(2)),0)),U,10)_CS_"IHS"
 Q
 ;-----
ORC3 ;
 N X
 S X=$P($G(^AUPNVSIT(+$P($G(^AUPNVIMM(+INDA,0)),U,3),0)),".")
 S INA("ORC3",INDA)=$E($$TIMEIO^INHUT10(X),1,8)_"-"_INDA_"-"_$P($$HRN^BYIMIMM3($P($G(^AUPNVIMM(+INDA,0)),U,2)),U)_CS_$P($$HRN^BYIMIMM3($P($G(^AUPNVIMM(+INDA,0)),U,2)),U,4)
 Q
 ;-----
ORC5 ;
 S INA("ORC5",INDA)="IP"
 Q
 ;-----
ORC10 ;entered by
 S BYIMPRV=$P($G(^AUPNVIMM(+INDA,12)),U,14)
 D:'BYIMPRV
 .S BYIMVST=$P($G(^AUPNVIMM(+INDA,0)),U,3)
 .S BYIMPRV=$P($G(^AUPNVIMM(+INDA,12)),U,2)
 .S:'BYIMPRV BYIMPRV=$P($G(^AUPNVIMM(+INDA,12)),U,4)
 .I 'BYIMPRV D
 ..S BYIMPRV=$O(^AUPNVPRV("AD",+BYIMVST,0))
 ..S BYIMPRV=+$G(^AUPNVPRV(+BYIMPRV,0))
 Q:'BYIMPRV
 S NPI=$$NPI(BYIMPRV)
 S INA("ORC10",INDA)=NPI_CS_$$PN^INHUT($$VAL^XBDIQ1(200,BYIMPRV,.01))
 S:$P(INA("ORC10",INDA),CS)]"" INA("ORC10",INDA)=INA("ORC10",INDA)_CS_CS_"IHS"
 Q
 ;-----
ORC12 ;ordering provider
 S BYIMVST=$P($G(^AUPNVIMM(+INDA,0)),U,3)
 S BYIMPRV=$P($G(^AUPNVIMM(+INDA,12)),U,2)
 S:'BYIMPRV BYIMPRV=$P($G(^AUPNVIMM(+INDA,12)),U,4)
 I 'BYIMPRV D
 .S BYIMPRV=$O(^AUPNVPRV("AD",+BYIMVST,0))
 .S BYIMPRV=+$G(^AUPNVPRV(+BYIMPRV,0))
 Q:'BYIMPRV
 S NPI=$$NPI(BYIMPRV)
 S INA("ORC12",INDA)=NPI_CS_$$PN^INHUT($$VAL^XBDIQ1(200,BYIMPRV,.01))
 S:$P(INA("ORC12",INDA),CS)]"" INA("ORC12",INDA)=INA("ORC12",INDA)_CS_CS_"IHS"
 Q
 ;-----
ORC17 ;setup for ORC17 variable - location
 S INA("ORC17",INDA)=CS_CS_CS_$P($G(^DIC(4,+$G(DUZ(2)),0)),U)
ORCEND Q
 ;-----
 ;-----
RXA ;EP;
 Q:'$D(^AUPNVIMM(INDA,0))
 D VSET(INDA)
 D RXA2
 D RXA3
 D RXA4
 D RXA5
 D RXA6
 D RXA7
 D RXA9
 D RXA10
 D RXA11
 D RXA15
 D RXA16
 D RXA17
 D RXA20
 D RXA21
 D RXA22
 Q
 ;-----
RXA2 ;admin subid
 S INA("RXA2",INDA)=1
 Q
 ;-----
RXA3 ;admin date/time
 S INA("RXA3",INDA)=$P($$TIMEIO^INHUT10($P(V0,U)),"-")
 Q
 ;-----
RXA4 ;date/time entered
 S INA("RXA4",INDA)=$P($$TIMEIO^INHUT10($P(V0,U)),"-")
 Q
 ;-----
RXA5 ;admin code
 N X
 S X=$P(Z,U,3)
 S:$L(X)=1 X="0"_X
 S INA("RXA5",INDA)=X_CS_$P(Z,U)_CS_"CVX"
 Q
 ;-----
RXA6 ;dose
 N X
 S X=+$P(X0,U,11)
 S INA("RXA6",INDA)=X
 S:'X INA("RXA6",INDA)="999"
 Q
 ;-----
RXA7 ;quantity definition
 S INA("RXA7",INDA)=""
 S:INA("RXA6",INDA) INA("RXA7",INDA)="mL^milliters^UCUM"
 Q
 ;-----
RXA9 ;admin history
 S INA("RXA9",INDA)=$$HX1^BYIMIMM3(INDA)_CS_$$HX2^BYIMIMM3(INDA)_CS_"NIP001"
 Q
 ;-----
RXA10 ;ordering provider
 S INA("RXA10",INDA)=""
 Q:'$P(X12,U,4)
 N N,P
 S P=$P(X12,U,4)
 Q:'$D(^VA(200,P,0))
 S N=$$NPI(P)
 S P=$P(^VA(200,P,0),U)
 S INA("RXA10",INDA)=N_CS_$P(P,",")_CS_$P($P(P,",",2)," ")
 S:$P(INA("RXA10",INDA),CS)]"" INA("RXA10",INDA)=INA("RXA10",INDA)_CS_CS_CS_CS_CS_CS_"IHS"
 Q
 ;-----
RXA11 ;location of encounter
 S INA("RXA11",INDA)=""
 N X,Y,Z
 S Z=+$P(V0,U,6)
 I $D(^BYIMPARA(DUZ(2),5,Z,0)) S X=$P(^(0),U,2)
 I '$D(^BYIMPARA(DUZ(2),5,Z,0)) S X=$P($G(^DIC(4,Z,0)),U)
 I $E(X,1,5)="OTHER"!(X=""),$P(V21,U)]"" S X=$P(V21,U)
 S INA("RXA11",INDA)=CS_CS_CS_X
 Q
 ;-----
RXA15 ;immunization lot number
 S INA("RXA15",INDA)=""
 N X,Y,Z
 S X=$P(X0,U,5)
 Q:'X
 S INA("RXA15",INDA)=$P($G(^AUTTIML(X,0)),U,16)
 S:INA("RXA15",INDA)="" INA("RXA15",INDA)=$P($G(^AUTTIML(X,0)),U)
 Q
 ;-----
RXA16 ;immunization lot number
 S INA("RXA16",INDA)=""
 N X,Y,Z
 S X=+$P(X0,U,5)
 Q:'$P($G(^AUTTIML(X,0)),U,9)
 S INA("RXA16",INDA)=$P($G(^AUTTIML(X,0)),U,9)+17000000
 Q
 ;-----
RXA17 ;immunization manufacturer
 S INA("RXA17",INDA)=""
 N X,Y,Z
 S X=$P(X0,U,5)
 Q:'X
 S X=$P($G(^AUTTIML(X,0)),U,2)
 Q:'X
 S X=$G(^AUTTIMAN(X,0))
 S INA("RXA17",INDA)=$P(X,U,2)_CS_$P(X,U)_CS_"MVX"
 Q
 ;-----
RXA20 ;action code
 S INA("RXA20",INDA)="CP"
 Q
 ;-----
RXA21 ;action code
 S INA("RXA21",INDA)="A"
 Q
 ;-----
RXA22 ;action code
 S X=$P(X12,U)
 S:'X X=$P(V0,U)
 S INA("RXA22",INDA)=$P($$TIMEIO^INHUT10(X),"-")
RXAEND Q
 ;-----
 ;-----
QRD ;EP; setup the variables for the QRD segment
 N BYIMDA,BYIMNM,BYIMRN,BYIMASU
 S BYIMDA=$O(INA("QNM",0))
 Q:'BYIMDA
 D QRD1
 D QRD2
 D QRD3
 D QRD4
 D QRD7
 D QRD8
 D QRD9
 D QRD10
 D QRD12
 Q
 ;-----
QRD1 ;
 D NOW^%DTC
 S INA("QRD1")=$P($$TIMEIO^INHUT10(%),"-")
 Q
 ;-----
QRD2 ;
 S INA("QRD2")="R"
 Q
 ;-----
QRD3 ;
 S INA("QRD3")="I"
 Q
 ;-----
QRD4 ;
 S INA("QRD4")=INA("QRD1")_"-"_$P($$HRN^BYIMIMM3(BYIMDA),U)
 Q
 ;-----
QRD7 ;
 S INA("QRD7")="25^RD"
 Q
 ;-----
QRD8 ;get the necessary information to build a who string (QRD-8)
 ;support for multiples built in
 N X,Y,Z
 S X=$P($G(^DPT(BYIMDA,0)),U)
 S X=$$PN^INHUT(X)
 S Y=$$HRN^BYIMIMM3(BYIMDA)
 S INA("QRD8")=$P(Y,U)_CS_X
 Q
 ;-----
QRD9 ;
 S INA("QRD9")="VXI"_CS_"VACCINE INFORMATION"_CS_"HL70048"
 Q
 ;-----
QRD10 ;
 S INA("QRD10")=CS_"IIS"
 Q
 ;-----
QRD12 ;
 S INA("QRD12")="T"
QRDEND Q
 ;-----
 ;-----
QRF ;EP; this is the main routine driver
 S INA("INQWHICH")="ANY"
 D QRF1
 D QRF2
 D QRF3
 D QRF5
 Q
 ;-----
QRF1 ;
 S INA("QRF1")=$P($G(^DIC(4,+$G(DUZ(2)),0)),U)
 Q
QRF2 ;
 S INA("QRF2")=""
 Q
 ;-----
QRF3 ;
 ;S INA("INQEDTM")=$G(INA("QEDT"))
 S INA("QRF3")=""
 Q
 ;-----
QRF5 ;build the other query subject filter
 N BYIMDA,BYIMSSN,BYIMDOB,BYIMBST,BYIMBCN,BYIMMCN,BYIMMNM,BYIMMMN,BYIMMSSN,BYIMFNM
 S BYIMDA=$O(INA("QNM",0))
 Q:'BYIMDA
 N X,Y,Z,X0,X24
 S X0=$G(^DPT(BYIMDA,0))
 Q:X0=""
 S BYIMSSN=$TR($P(X0,U,9),"-")
 S BYIMDOB=$P(X0,U,3)+17000000
 S BYIMBST=$P($G(^DIC(5,+$P(X0,U,12),0)),U,2)
 S BYIMBCN=$P($G(^AUPNPAT(BYIMDA,11)),U,5)
 S BYIMMCN=""
 S BYIMMNM=""
 S BYIMMMN=""
 S BYIMMSSN=""
 S BYIMFNM=""
 S X24=$G(^DPT(BYIMDA,.24))
 S X=$P(X24,U,2)
 S:X]"" BYIMMNM=$$QRFNAME(X)
 S X=$P(X24,U,3)
 S:X]"" BYIMMMN=$$QRFNAME(X)
 S X=$P(X24,U)
 S:X]"" BYIMFNM=$$QRFNAME(X)
 S BYIMFSSN=""
 S INA("QRF5")=BYIMSSN_RS_BYIMDOB_RS_BYIMBST_RS_BYIMBCN_RS_BYIMMCN_RS_BYIMMNM_RS_BYIMMMN_RS_BYIMMSSN_RS_BYIMFNM_RS_BYIMFSSN
 Q
 ;-----
QRFNAME(NAME) ;FORMAT NAME
 Q:NAME="" ""
 S X=$P(NAME,",")_U_$P($P(NAME,",",2)," ")
 S:NAME[" " X=X_U_$P(NAME," ",2)
 Q X
QRFEND Q
 ;-----
 ;-----
FHS ;EP;
 D FHS3
 D MSH
 Q
 ;-----
FHS3 ;
 N X
 S X=$P($G(^BYIMPARA(+$G(DUZ(2)),0)),U,7)
 S:X="" X=$P($G(^DIC(4,+$G(DUZ(2)),0)),U)
 S INA("FSH3")=X
FHSEND Q
 ;-----
 ;-----
MSH ;EP;entry point
 D PATH^BYIMIMM
 D NOW^%DTC
 S INA("EVDT")=%
 S INA("ENC")=$$COMP^INHUT()_$$REP^INHUT()_$$SUBCOMP^INHUT()_$$ESC^INHUT()
 S INA("MT")=$P($G(^INTHL7M(BHLMIEN,0)),U,6)
 S INA("ET")=$P($G(^INTHL7M(BHLMIEN,0)),U,2)
 S INA("ACA")=$P($G(^INTHL7M(BHLMIEN,0)),U,10)
 S INA("APA")=$P($G(^INTHL7M(BHLMIEN,0)),U,11)
 S INA("VER")=BYIMVER
 S INA("PRID")=$P($G(^INTHL7M(BHLMIEN,0)),U,3)
 S INA("SAP")=$P($G(^INTHL7M(BHLMIEN,7)),U)
 S INA("SF")=$P($G(^INTHL7M(BHLMIEN,7)),U,2)
 S INA("RAP")=$P($G(^INTHL7M(BHLMIEN,7)),U,3)
 S INA("RF")=$P($G(^INTHL7M(BHLMIEN,7)),U,4)
 D MSH3
 D MSH4
 D MSH5
 D MSH6
 D MSH7
 D MSH8
 D MSH9
 D MSH10
 D MSH11
 D MSH12
 Q
 ;-----
MSH3 ;
 S X=BYIM("MSH31")
 S:X="" X="RPMS"
 S INA("MSH3")=X ;_CS_BYIM("MSH32")_CS_"ISO"
 Q
 ;-----
MSH4 ;
 N X
 S X=BYIM("MSH41")
 S:X="" X=$P($G(^DIC(4,+$G(DUZ(2)),0)),U)
 I BYIM("MSH41")="",BYIM("MSH42")="" S INA("MSH4")=X Q
 I BYIM("MSH41")]"" S INA("MSH4")=X Q
 I BYIM("MSH41")="",BYIM("MSH42")]"" S INA("MSH4")=CS_BYIM("MSH42")_CS_BYIM("MSH43") Q
 S INA("MSH4")=X
 Q
 ;-----
MSH5 ;
 S INA("MSH5")=""
 Q
 ;-----
MSH6 ;
 S INA("MSH6")=BYIM("MSH6")
 Q
 ;-----
MSH7 ;
 D NOW^%DTC
 S INA("MSH7")=$P($$TIMEIO^INHUT10(%),"-")
 Q
 ;-----
MSH8 ;
 S INA("MSH8")=BYIMMSH8
 Q
 ;-----
MSH9 ;
 S INA("MSH9")=INA("MT")_CS_INA("ET")_CS_INA("MT")_"_"_INA("ET")
 Q
 ;-----
MSH10 ;
 S INA("MSH10")=$P($G(^INTHU(+$G(UIF),0)),U,5)
 S:INA("MSH10")="" INA("MSH10")=$$MESSID^INHD()
 Q
 ;-----
MSH11 ;
 S INA("MSH11")="P"
 Q
 ;-----
MSH12 ;
 S INA("MSH12")=BYIMVER
 Q
 ;-----
MSHEND Q
 ;-----
 ;-----
NK1 ;-- this will generate the IHS NK1 segment
 D NK11
 D NK12
 D NK13
 D NK14
 D NK15
 Q
 ;-----
NK11 ;subid
 S INA("NK11",1)="1"
 S INA("NK11")="1"
 Q
 ;-----
NK12 N X,FN,LN,MN
 S X=$P($G(^DPT(INDA,.21)),U)
 S LN=$P(X,",")
 S FN=$P($P(X,",",2)," ")
 S MN=$P(X," ",2)
 S INA("NK12",1)=LN_CS_FN_CS_MN_CS_CS_CS_CS_"L"
 S INA("NK12")=LN_CS_FN_CS_MN_CS_CS_CS_CS_"L"
 Q
 ;-----
NK13 N X
 S X=$P($G(^DPT(INDA,.21)),U,2)
 S Y=$S(X="":"",X="MOTHER":"MTH",X="FATHER":"FTH",1:"GRD")
 S INA("NK13",1)=Y_CS_X_CS_"HL70063"
 S INA("NK13")=Y_CS_X_CS_"HL70063"
 Q
 ;-----
NK14 ;NOK ADDRESS
 S X=$P($G(^DPT(+INDA,.21)),U,3,8)
 S INA("NK14",1)=$P(X,U)_CS_CS_$P(X,U,4)_CS_$P($G(^DIC(5,+$P(X,U,5),0)),U,2)_CS_$P(X,U,6)_CS_"USA"_CS_"P"
 S INA("NK14")=$P(X,U)_CS_CS_$P(X,U,4)_CS_$P($G(^DIC(5,+$P(X,U,5),0)),U,2)_CS_$P(X,U,6)_CS_"USA"_CS_"P"
 Q
 ;-----
NK15 ;PHONE NUMBER
 S INA("NK15",1)=""
 S X=$P($G(^DPT(INDA,.21)),U,9)
 S X=$TR(X,"()\/- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 S:$E(X)=1 X=$E(X,2,99)
 I X'?10N S INA("NK15",1)="" Q
 D:BYIMVER["2.5"
 .S INA("NK15",1)=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 .S INA("NK15")=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 D:BYIMVER'["2.5"
 .S INA("NK15",1)="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
 .S INA("NK15")="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
NK1END Q
 ;-----
 ;-----
PID ;EP;
 D PID3
 D PID7
 D PID10
 D PID11
 D PID13
 D PID14
 D PID22
 D PID24
 Q
 ;-----
PID3 ;-- this will generate the IHS PID-3 field
 N X,Y,Z
 S X=$$HRN^BYIMIMM3(INDA)
 S Y=$TR($P($G(^DPT(INDA,0)),U,9),"-")
 S:Y]"" X=X_"~"_Y_CS_CS_CS_"SSA"_CS_"SS"
 S Y=""
 S Z=$O(^AUPNMCD("B",INDA,9999999999),-1)
 S:Z Y=$P($G(^AUPNMCD(Z,0)),U,3)
 S:Y]"" X=X_"~"_Y_CS_CS_CS_"MCD"_CS_"MA"
 S INA("PID3",1)=X
 S INA("PID3")=X
 Q
 ;-----
PID7 ;PID-7 DOB
 S INA("PID7",1)=17000000+$P($G(^DPT(INDA,0)),U,3)
 S INA("PID7")=INA("PID7",1)
 Q
 ;-----
PID10 ;PID-10 RACE
 S INA("PID10",1)=$$RACE^BYIMIMM3(INDA)
 S INA("PID10")=INA("PID10",1)
 Q
 ;-----
PID11 ;PID-11 ADDRESS
 S X=$G(^DPT(+INDA,.11))
 S INA("PID11",1)=$P(X,U)_CS_CS_$P(X,U,4)_CS_$P($G(^DIC(5,+$P(X,U,5),0)),U,2)_CS_$P(X,U,6)_CS_"USA"_CS_"P"
 S INA("PID11")=$P(X,U)_CS_CS_$P(X,U,4)_CS_$P($G(^DIC(5,+$P(X,U,5),0)),U,2)_CS_$P(X,U,6)_CS_"USA"_CS_"P"
 Q
 ;-----
PID13 ;PID-13 PHONE HOME
 S INA("PID13",1)=""
 S X=$P($G(^DPT(INDA,.13)),U)
 S X=$TR(X,"()\/- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 S:$E(X)=1 X=$E(X,2,99)
 I X'?10N S INA("PID13",1)="" Q
 D:BYIMVER["2.5"
 .S INA("PID13",1)=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 .S INA("PID13")=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 D:BYIMVER'["2.5"
 .S INA("PID13",1)="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
 .S INA("PID13")="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
 Q
 ;-----
PID14 ;PID-14 PHONE BUSINESS
 S INA("PID14",1)=""
 S X=$P($G(^DPT(INDA,.13)),U,2)
 S X=$TR(X,"()\/- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 S:$E(X)=1 X=$E(X,2,99)
 I X'?10N S INA("PID14",1)="" Q
 D:BYIMVER["2.5"
 .S INA("PID14",1)=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 .S INA("PID14")=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 D:BYIMVER'["2.5"
 .S INA("PID14",1)="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
 .S INA("PID14")="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
 Q
 ;-----
PID22 ;PID-22 ETHNICITY
 S INA("PID22",1)=$$ETH^BYIMIMM3(INDA)
 S INA("PID22")=INA("PID22",1)
 Q
 ;-----
PID24 ;PID-24 BIRTH ORDER
 S INA("PID24",1)="N"
 S INA("PID24")="N"
PIDEND Q
 ;-----
 ;-----
RCP ;-- setup the variables for the RCP segment
RCPEND Q
 ;-----
 ;-----
QPD ;-- setup the variables for the QPD segment
QPDEND Q
 ;-----
 ;-----
RXR ;EP;
 D RXR1
 D RXR2
 Q
 ;-----
RXR1 ;
 S INA("RXR1",INDA)=""
 N X,R
 D VSET(INDA)
 S X=$P(X0,U,9)
 Q:X=""
 S R=$E(X,$L(X))
 Q:"IDNOS"'[R
 S:R="I" INA("RXR1",INDA)="IM"_CS_"INTRAMUSCULAR"_CS_"HL70162"
 S:R="D" INA("RXR1",INDA)="IM"_CS_"INTRADERMAL"_CS_"HL70162"
 S:R="N" INA("RXR1",INDA)="NS"_CS_"NASAL"_CS_"HL70162"
 S:R="O" INA("RXR1",INDA)="PO"_CS_"ORAL"_CS_"HL70162"
 S:R="S" INA("RXR1",INDA)="SC"_CS_"SUBCUTANEOUS"_CS_"HL70162"
 Q
 ;-----
RXR2 ;
 S INA("RXR2",INDA)=""
 N X,R
 D VSET(INDA)
 S X=$P(X0,U,9)
 Q:X=""
 S R=$E(X,1,2)
 S:R="LT" INA("RXR2",INDA)=R_CS_"Left Thigh"_CS_"HL70163"
 S:R="LA" INA("RXR2",INDA)=R_CS_"Left Arm"_CS_"HL70163"
 S:R="LD" INA("RXR2",INDA)=R_CS_"Left Deltoid"_CS_"HL70163"
 S:R="LG" INA("RXR2",INDA)=R_CS_"Left Gluteus Medius"_CS_"HL70163"
 S:R="LL" INA("RXR2",INDA)=R_CS_"Left Vastus Lateralis"_CS_"HL70163"
 S:R="LI" INA("RXR2",INDA)=R_CS_"Left Lower Forearm"_CS_"HL70163"
 S:R="RA" INA("RXR2",INDA)=R_CS_"Right Arm"_CS_"HL70163"
 S:R="RT" INA("RXR2",INDA)=R_CS_"Right Thigh"_CS_"HL70163"
 S:R="RVL" INA("RXR2",INDA)=R_CS_"Right Vastus Lateralis"_CS_"HL70163"
 S:R="RG" INA("RXR2",INDA)=R_CS_"Right Gluteous Medius"_CS_"HL70163"
 S:R="RD" INA("RXR2",INDA)=R_CS_"Right Deltoid"_CS_"HL70163"
 S:R="RI" INA("RXR2",INDA)="RLFA"_CS_"Right Lower Forearm"_CS_"HL70163"
 Q
 ;-----
 ;-----
VSET(INDA) ;SET VISIT VARIABLES
 S X0=^AUPNVIMM(INDA,0)
 S X12=$G(^AUPNVIMM(INDA,12))
 S Z=$G(^AUTTIMM(+X0,0))
 S V0=$G(^AUPNVSIT(+$P(X0,U,3),0))
 S V21=$G(^AUPNVSIT(+$P(X0,U,3),21))
 S T=$P(V0,U,7)
 Q
 ;-----
 ;-----
NPI(PRV) ;
 S NPI=$P($G(^VA(200,PRV,"NPI")),U)
 Q NPI
 ;-----
 ;-----
