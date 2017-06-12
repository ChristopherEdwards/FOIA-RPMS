LA7MUNK1 ;ihs/cmi/maw - MU2 NK1 Segment ; 22-Oct-2013 09:22 ; MAW
 ;;5.2;BLR IHS REFERENCE LAB;**1033**;NOV 01, 1997
 ;
NK12(CS,DATA)  ;-- nok name
 N MMN,MLNM,M2,MFNM,MMI,MSFX,MPRX,MPSFX,NK12
 S NK12=""
 S MMN=$P(DATA,U)
 I $G(MMN)="" Q NK12
 S MLNM=$P(MMN,",")
 S M2=$P(MMN,",",2)
 S MFNM=$P(M2," ")
 S MMI=$P($P(M2," ",2)," ")
 S MSFX=$P($P(M2," ",3)," ")
 S MPRX=$P($P(M2," ",4)," ")
 S MPSFX=$P(M2," ",5)
 S NK12=MLNM_CS_MFNM_CS_MMI_CS_MSFX_CS_MPRX_CS_CS_"L"_CS_CS_CS_CS_CS_CS_CS_MPSFX
 Q NK12
 ;
 ;
NK13(CS,DF,DATA)  ;nok relationship
 N NK13,REL,RELI,RLHL
 S NK13=""
 S RELI=$$GET1^DIQ(9000001,DF,2802,"I")
 I '$G(RELI) Q NK13
 S REL=$$GET1^DIQ(9000001,DF,2802)
 S RLHL=$P($G(^AUTTRLSH(RELI,21)),U,4)
 S NK13=RLHL_CS_REL_CS_"HL70063"_CS_$E(REL,1,1)_CS_REL_CS_"L"_CS_LA7VER_CS_"1.0"
 Q NK13
 ;
NK14(CS,DF,DATA)  ;
 N NK14
 S NK14=""
 I $P(DATA,U,3)="" Q NK14
 S NK14=$P(DATA,U,3)_CS_$P(DATA,U,4)_CS_$P(DATA,U,6)_CS_$$GET1^DIQ(5,$P(DATA,U,7),1)_CS_$P(DATA,U,8)_CS_"USA"_CS_"H"_CS_CS_$$LZERO^LA7MUPID($P($G(^DPT(DF,.11)),U,7),5)
 Q NK14
 ;
NK15(CS,DF,DATA)  ;nok communications
 N NK15
 S $P(DATA,U,9)=$TR($P(DATA,U,9),"-","")
 S NK15=""
 I $P(DATA,U,9)]"" S NK15=CS_"PRN"_CS_"PH"_CS_CS_$E($P(DATA,U,9),1)_CS_$E($P(DATA,U,9),2,4)_CS_$E($P(DATA,U,9),5,11)_CS_$R(1000)_CS_$P($G(^DPT(DF,0)),U,10)
 I $P(DATA,U,11)]"" S NK15=NK15_RS_CS_"NET"_CS_"Internet"_CS_$P(DATA,U,11)_CS_CS_CS_CS_CS_"home"
 Q NK15
 ;
NK113(CS,DF,CSS) ;-- next of kin organization
 N NK113,DATA
 S DATA=$G(^DPT(DF,.291))
 S NK113=""
 I $G(DATA)]"" D
 . S $P(NK113,CS)=$P(DATA,U,3)
 . S $P(NK113,CS,2)="L"
 . S $P(NK113,CS,6)="RPMS_MPI"_CSS_"2.16.840.1.114222.4.10.3"_CSS_"ISO"
 . S $P(NK113,CS,7)="XX"
 . S $P(NK113,CS,10)=$P(DATA,U,5)  ;in ZIP+4 field
 Q NK113
 ;
NK130(CS,DF) ;-- next of kin contact person
 N NK130,DATA,CP,LNM,REST,GN,MI,SF,PR,PSF
 S DATA=$G(^DPT(DF,.291))
 S NK130=""
 I DATA]"" D
 .S CP=$P(DATA,U,4)
 .S LNM=$P(CP,",")
 .S REST=$P(CP,",",2)
 .S GN=$P(REST," ")
 .S MI=$P($P(REST," ",2)," ")
 .S SF=$P($P(REST," ",3)," ")
 .S PR=$P($P(REST," ",4)," ")
 .S PSF=$P(REST," ",5)
 .S $P(NK130,CS)=LNM
 .S $P(NK130,CS,2)=GN
 .S $P(NK130,CS,3)=MI
 .S $P(NK130,CS,4)=SF
 .S $P(NK130,CS,5)=PR
 .S $P(NK130,CS,7)="L"
 .S $P(NK130,CS,14)=PSF
 Q NK130
 ;
NK131(CS,DF) ;-- next of kin contact person telephone
 N NK131,DATA,PH
 S DATA=$G(^DPT(DF,.291))
 S PH=$P(DATA,U,11)
 S NK131=""
 I PH]"" D
 .S $P(NK131,CS,2)="WPN"
 .S $P(NK131,CS,3)="PH"
 .S $P(NK131,CS,5)=$E(PH,1)
 .S $P(NK131,CS,6)=$E(PH,2,4)
 .S $P(NK131,CS,7)=$E(PH,5,11)
 .S $P(NK131,CS,8)=$E(PH,12,15)
 .S $P(NK131,CS,9)=$P(DATA,U,5)
 Q NK131
 ;
NK132(CS,DF) ;-- next of kin contact person address
 N NK132,DATA
 S NK132=""
 S DATA=$G(^DPT(DF,.291))
 I DATA]"" D
 .S $P(NK132,CS)=$P(DATA,U,6)
 .S $P(NK132,CS,2)=$P(DATA,U,7)
 .S $P(NK132,CS,3)=$P(DATA,U,8)
 .S $P(NK132,CS,4)=$$GET1^DIQ(5,$P(DATA,U,9),1)
 .S $P(NK132,CS,5)=$P(DATA,U,10)
 .S $P(NK132,CS,6)="USA"
 .S $P(NK132,CS,7)="M"
 .S $P(NK132,CS,9)=$$GET1^DIQ(2,DF,.2928)
 Q NK132
 ;
