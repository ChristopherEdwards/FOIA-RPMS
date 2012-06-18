AGELE2X2 ; IHS/ASDS/EFG - PAGE 2 - INSURER PART 2 ;   
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;X2=PHDFN;NAME^RDFN;RELATIONSHIP^ADDR1^ADDR2^PHONE^SEX^DOB
 ;X3=EMPLOYER^ADDR1^ADDR2^PHONE^STATUS;DESC^GROUP^GROUP #^EMPL #
 ;
 I +AGV("X2")="" G XIT
 I '$D(^AUPN3PPH(+AGV("X2"),0)) G XIT
 I $P(^AUPN3PPH(+AGV("X2"),0),U,2)]"" S AGX("HDFN")=$P(^(0),U,2)
 S $P(AGV("X3"),U,6)=$P(^AUPN3PPH(+AGV("X2"),0),U,6),$P(AGV("X3"),U,7)=$P(^(0),U,7)
 S $P(AGV("X2"),U,6)=$P(^AUPN3PPH(+AGV("X2"),0),U,8)
 S $P(AGV("X2"),U,7)=$P(^AUPN3PPH(+AGV("X2"),0),U,19)
REG I $P(^AUPN3PPH(+AGV("X2"),0),U,2)="" G PHINFO
 I $D(^DPT(AGX("HDFN"),.11)),$P(^(.11),U)]"",$P(^(.11),U,4)]"",$P(^(.11),U,5)]"",$P(^(.11),U,6)]"" D
 .S $P(AGV("X2"),U,3)=$P(^(.11),U)
 .S AG("PH9")=$P(^(.11),U)
 .S $P(AGV("X2"),U,4)=$P(^(.11),U,4)_", "
 .S AG("PH11")=$P(^(.11),U,4)
 E  G REMPL
 I $P(^DPT(AGX("HDFN"),.11),U,5)]"",$D(^DIC(5,$P(^(.11),U,5),0)) D
 .S $P(AGV("X2"),U,4)=$P(AGV("X2"),U,4)_$P(^(0),U,2)_"  "_$P(^DPT(AGX("HDFN"),.11),U,6)
 .S AG("PH12")=$P(^(.11),U,5)
 .S AG("PH13")=$P(^(.11),U,6)
 .S:$D(^(.13)) $P(AGV("X2"),U,5)=$P(^(.13),U)
 .S:$D(^(.13)) AG("PH14")=$P(^(.13),U)
REMPL I $P(^AUPNPAT(AGX("HDFN"),0),U,19)]"",$D(^AUTNEMPL($P(^(0),U,19),0)) D
 .S $P(AGV("X3"),U)=$P(^(0),U)
 .S AGX("E0")=^(0)
 E  G REMST
 S $P(AGV("X3"),U,2)=$P(AGX("E0"),U,2)
 S $P(AGV("X3"),U,3)=$P(AGX("E0"),U,3)_", "
 I $P(AGX("E0"),U,4)]"",$D(^DIC(5,$P(AGX("E0"),U,4),0)) D
 .S $P(AGV("X3"),U,3)=$P(AGV("X3"),U,3)_$P(^(0),U,2)_"  "_$P(AGX("E0"),U,5)
 S $P(AGV("X3"),U,4)=$P(AGX("E0"),U,6)
REMST S AGX("Y")=$P(^AUPNPAT(AGX("HDFN"),0),U,21)
 I AGX("Y")="" S AGX("Y")=9
 S AGX("Y0")=$P(^DD(9000001,.21,0),U,3)
 S AGX("Y0")=$P($P(AGX("Y0"),AGX("Y")_":",2),";",1)
 S $P(AGV("X3"),U,5)=AGX("Y")_";"_AGX("Y0")
 G XIT
PHINFO ;INSURER INFO FROM POLICY HOLDER FILE
 S AGX("Y")=$P(^AUPN3PPH(+AGV("X2"),0),U,15)
 I AGX("Y")="" G PHADD
 S AGX("Y0")=$P(^DD(9000003.1,.15,0),U,3)
 S AGX("Y0")=$P($P(AGX("Y0"),AGX("Y")_":",2),";",1)
 S $P(AGV("X3"),U,5)=AGX("Y")_";"_AGX("Y0")
PHADD I $P(^AUPN3PPH(+AGV("X2"),0),U,9)]"",$P(^(0),U,11)]"",$P(^(0),U,12)]"",$P(^(0),U,13)]"" D
 .S $P(AGV("X2"),U,3)=$P(^(0),U,9)
 .S $P(AGV("X2"),U,4)=$P(^(0),U,11)_", "
 E  G PEMPL
 I $D(^DIC(5,$P(^AUPN3PPH(+AGV("X2"),0),U,12),0)) D
 .S $P(AGV("X2"),U,4)=$P(AGV("X2"),U,4)_$P(^(0),U,2)_"  "_$P(^AUPN3PPH(+AGV("X2"),0),U,13)
 .S $P(AGV("X2"),U,5)=$P(^(0),U,14)
PEMPL I $P(^AUPN3PPH(+AGV("X2"),0),U,16)]"",$D(^AUTNEMPL($P(^(0),U,16),0)) D
 .S $P(AGV("X3"),U)=$P(^(0),U),AGX("E0")=^(0)
 E  G XIT
 I $P(AGX("E0"),U,2)]"",$P(AGX("E0"),U,3)]"",$P(AGX("E0"),U,4)]"",$P(AGX("E0"),U,5)]""
 E  G XIT
 S $P(AGV("X3"),U,2)=$P(AGX("E0"),U,2)
 S $P(AGV("X3"),U,3)=$P(AGX("E0"),U,3)_", "
 I $D(^DIC(5,$P(AGX("E0"),U,4),0)) D
 .S $P(AGV("X3"),U,3)=$P(AGV("X3"),U,3)_$P(^(0),U,2)_"  "_$P(AGX("E0"),U,5)
 S $P(AGV("X3"),U,4)=$P(AGX("E0"),U,6)
XIT K AGX Q
