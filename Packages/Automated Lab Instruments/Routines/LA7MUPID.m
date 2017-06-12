LA7MUPID ;ihs/cmi/maw - MU2 PID Segment ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;BLR IHS REFERENCE LAB;**1033**;NOV 01, 1997
 ;
PID3(CS,RS,SC,DFN,SSN)  ;identifiers
 N PID3
 S PID3=$$HRN^AUPNPAT(DFN,DUZ(2))_CS_CS_CS_"RPMS MPI"_SC_"2.16.840.1.113883.3.72.5.31.2"_SC_"ISO"_CS_"MR"_CS_FAC_SC_"2.16.840.1.113883.5.0"_SC_"ISO"
 S PID3=PID3_RS_$G(SSN)_CS_CS_CS_"SSN"_SC_"2.16.840.1.113883.3.4.1"_SC_"ISO"_CS_"SS"_CS_"SSA"_SC_"2.16.840.1.113883.3.184"_SC_"ISO"
 Q PID3
 ;
PID5(CS,RS,AL)  ;patients name
 N PID5
 ;S PID5=$P(VADM(1),",")_CS_$P($P(VADM(1),",",2)," ")_CS_$P($P(VADM(1),",",2)," ",2)_CS_$P($P(VADM(1),",",2)," ",3)_CS_$P($P(VADM(1),",",2)," ",4)_CS_CS_"L"_CS_$P($P(VADM(1),",",2)," ",5)  ;_CS_$P($P($P(VADM(1),",",2)," ",2)," ",5)_"L"
 S $P(PID5,CS)=$P(VADM(1),",")
 S $P(PID5,CS,2)=$P($P(VADM(1),",",2)," ")
 S $P(PID5,CS,3)=$P($P(VADM(1),",",2)," ",2)
 S $P(PID5,CS,4)=$P($P(VADM(1),",",2)," ",3)
 S $P(PID5,CS,5)=$P($P(VADM(1),",",2)," ",4)
 S $P(PID5,CS,7)="L"
 S $P(PID5,CS,14)=$P($P(VADM(1),",",2)," ",5)
 S PID5=PID5_RS_$P(AL,",")_CS_$P($P(AL,",",2)," ")_CS_$P($P(AL,",",2)," ",2)_CS_$P($P(AL,",",2)," ",3)_CS_$P($P(AL,",",2)," ",4)_CS_CS_"A"  ;$P($P($P(AL,",",2)," ",2)," ",5)_CS_"B"
 Q PID5
 ;
PID6(CS,DF)  ;-mothers maiden name
 N PID6,MMN,MLNM,M2,MFNM,MMI,MSFX,MPRX,MPSFX
 S MMN=$$GET1^DIQ(2,DF,.2403)
 S MLNM=$P(MMN,",")
 S M2=$P(MMN,",",2)
 S MFNM=$P(M2," ")
 S MMI=$P($P(M2," ",2)," ")
 S MSFX=$P($P(M2," ",3)," ")
 S MPRX=$P($P(M2," ",4)," ")
 S MPSFX=$P(M2," ",5)
 S PID6=""
 i $G(MMN)]"" S PID6=MLNM_CS_MFNM_CS_MMI_CS_MSFX_CS_MPRX_CS_CS_"M"_CS_CS_CS_CS_CS_CS_CS_MPSFX  ;mothers maiden name
 Q PID6
 ;
PID7()  ;-- dob
 N PID7
 S PID7=$$FMTHL7^XLFDT($P(VADM(3),U))
 Q PID7
 ;
PID8()  ;-- sex
 N PID8
 S PID8=$P(VADM(5),U)
 Q PID8
 ;
PID10(CS)  ;--race
 N PID10
 S PID10=$P($G(^DIC(10,$P(VADM(8),U),0)),U,3)_CS_$P(VADM(8),U,2)_CS_"CDCREC"_CS_$P($G(^DIC(10,$P(VADM(8),U),0)),U,3)_CS_$P(VADM(8),U,2)_CS_"L"_CS_"1.1"_CS_"2.0"
 Q PID10
 ;
PID11(CS,DF)  ;-- address
 N PID11,ADD1,ADD2
 S ADD1=$G(^DPT(DF,.11))
 S ADD2=$G(^DPT(DF,.121))
 S PID11=$P(ADD1,U)_CS_$P(ADD1,U,2)_CS_$P(ADD1,U,4)_CS_$$GET1^DIQ(5,$P(ADD1,U,5),1)_CS_$P(ADD1,U,6)_CS_"USA"_CS_"H"_CS_CS_$$LZERO($$GET1^DIQ(5,$P(ADD1,U,5),2)_$P(ADD1,U,7),5)
 I $P(ADD2,U)]"" S PID11=PID11_RS_$P(ADD2,U)_CS_$P(ADD2,U,2)_CS_$P(ADD2,U,4)_CS_$$GET1^DIQ(5,$P(ADD2,U,5),1)_CS_$P(ADD2,U,6)_CS_"USA"_CS_"C"_CS_CS_$$LZERO($$GET1^DIQ(5,$P(ADD1,U,5),2)_$P(ADD2,U,11),5)
 Q PID11
 ;
PID13(CS,DF)  ;-- home communications
 N PID13,PH1
 S PH1=$G(^DPT(DF,.13))
 I PH1="" Q ""
 I $P(PH1,U,1)]"" S PID13=CS_"PRN"_CS_"PH"_CS_CS_$E(PH1,1)_CS_$E(PH1,2,4)_CS_$E(PH1,5,11)_CS_$R(1000)_CS_$$GET1^DIQ(2,DF,.091)
 I $P(PH1,U,1)="",$P(PH1,U,4)]"" S PID13=CS_"PRN"_CS_"CP"_CS_CS_$E($P(PH1,U,4),1)_CS_$E($P(PH1,U,4),2,4)_CS_$E($P(PH1,U,4),5,11)_CS_CS
 I $P(PH1,U,3)]"" S PID13=PID13_RS_CS_"NET"_CS_"Internet"_CS_$P(PH1,U,3)_CS_CS_CS_CS_CS_"home"
 I $$GET1^DIQ(9000001,DF,1801)]"" D
 . S PID13=PID13_RS_CS_"ORN"_CS_"CP"_CS_CS_$E($$GET1^DIQ(9000001,DF,1801))_CS_$E($$GET1^DIQ(9000001,DF,1801),2,4)_CS_$E($$GET1^DIQ(9000001,DF,1801),5,11)_CS_CS_"other phone"
 I $P(PH1,U,2)]"",PID13'[RS S PID13=PID13_RS_CS_"WPN"_CS_"PH"_CS_CS_$E($P(PH1,U,2),1)_CS_$E($P(PH1,U,2),2,4)_CS_$E($P(PH1,U,2),5,11)_CS_$R(1000)_CS_$$GET1^DIQ(2,DF,.091)
 Q PID13
PID14(CS,DF)  ;-- work communications
 N PID14,PH1
 S PH1=$G(^DPT(DF,.13))
 S PID14=""
 I $P(PH1,U,2)]"" S PID14=CS_"WPN"_CS_"PH"_CS_CS_$E($P(PH1,U,2),1)_CS_$E($P(PH1,U,2),2,4)_CS_$E($P(PH1,U,2),5,11)_CS_$R(1000)_CS_$$GET1^DIQ(2,DF,.091)
 Q PID14
 ;
PID22(CS,DF,ETH,SITE)  ;-- ethnic group
 N PID22
 S PID22=$P($G(^DIC(10.2,ETH,0)),U,2)_CS_$P($G(^DIC(10.2,ETH,0)),U)_CS_"HL70189"_CS_$P($G(^DIC(10.2,ETH,0)),U,3)_CS_$P($G(^DIC(10.2,ETH,0)),U)_CS_"CDCREC"_CS_$P($G(^BLRRLMU(SITE,0)),U,2)_CS_$P($G(^BLRRLMU(SITE,0)),U,2)
 Q PID22
 ;
PID29(DF)  ;-- patient death date/time
 N PID29
 S PID29=$$FMTHL7^XLFDT($P($G(^DPT(DF,.35)),U))
 Q PID29
 ;
PID30(DF)  ;-- patient death indicator
 N PID30
 S PID30=$S($P($G(^DPT(DF,.35)),U)]"":"Y",1:"N")
 Q PID30
 ;
PID33(DF)  ;-- last update
 N PID33
 S PID33=$$FMTHL7^XLFDT($P($G(^AUPNPAT(DF,0)),U,3))_"0000"
 Q PID33
 ;
PID34(CS,FAC)  ;update facility
 N PID34
 S PID34=$G(FAC)_CS_"2.16.840.1.113883.5.0"_CS_"ISO"
 Q PID34
 ;
PID35(CS,SITE)  ;species  MU2 hardcoded
 N PID35
 S PID35=337915000_CS_"Homo sapiens"_CS_"SCT"_CS_"HUMAN"_CS_"HUMAN"_CS_"L"_CS_$P($G(^BLRRLMU(SITE,0)),U,2)_CS_"2.0"
 Q PID35
 ;
LZERO(VAL,NM) ;-- leading zero utility
 N RET
 I $L(VAL)=1 Q "0000"_VAL
 I $L(VAL)=2 Q "000"_VAL
 I $L(VAL)=3 Q "00"_VAL
 I $L(VAL)=4 Q "0"_VAL
 Q VAL
 ;
