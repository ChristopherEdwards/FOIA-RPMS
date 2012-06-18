ABMDF2B ; IHS/ASDST/DMJ - Set HCFA1500 Print Array PART 2 ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;IHS/DSD/DMJ - 5/14/1999 - NOIS HQW-0599-100027 Patch 2
 ;          Y2K IV&V issues, all $$HDT^ABMDUTL changed to $$HDTO^ABMDUTL
 ;                    in lines: EMPL+2,EMPL+3,EMPL+4,EMPL+5,EMPL+6,FSYM
 ;                              FCONS,SIML,LAB+3,ADMIT,DISCH
 ;
BNODES S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5)),ABM("B6")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),ABM("B7")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),ABM("B8")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8)),ABM("B9")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),9))
 I $P(ABM("B5"),U,8)]"" S $P(ABMF(34),U,2)=$P(ABM("B5"),U,8)
EMPL I $P(ABM("B9"),U,1)]"" S $P(ABMF(13),U,2)="X"
 E  S $P(ABMF(13),U,3)="X" G ACCD
 I $P(ABM("B9"),U,2)]"" S $P(ABMF(25),U,1)=$$HDTO^ABMDUTL($P(ABM("B9"),U,2))
 I $P(ABM("B9"),U,3)]"" S $P(ABMF(25),U,2)=$$HDTO^ABMDUTL($P(ABM("B9"),U,3))
 I $P(ABM("B9"),U,4)]"" S $P(ABMF(25),U,3)=$$HDTO^ABMDUTL($P(ABM("B9"),U,4))
 I $P(ABM("B9"),U,5)]"" S $P(ABMF(25),U,4)=$$HDTO^ABMDUTL($P(ABM("B9"),U,5))
 I $P(ABM("B9"),U,6)]"" S $P(ABMF(25),U,5)=$$HDTO^ABMDUTL($P(ABM("B9"),U,6))
 ;
ACCD I $P(ABM("B8"),U,3)]"" S:"12"[$P(ABM("B8"),U,3) $P(ABMF(16),U,2)="X" S:"12"'[$P(ABM("B8"),U,3) $P(ABMF(16),U,3)="X"
FSYM I $P(ABM("B8"),U,6)]"" S $P(ABMF(23),U,1)=$$HDTO^ABMDUTL($P(ABM("B8"),U,6))
FCONS I $P(ABM("B8"),U,7)]"" S $P(ABMF(23),U,2)=$$HDTO^ABMDUTL($P(ABM("B8"),U,7))
SIML I $P(ABM("B8"),U,9)]"" S $P(ABMF(23),U,3)=$$HDTO^ABMDUTL($P(ABM("B8"),U,9))
REFR I $P(ABM("B8"),U,8)]"" S $P(ABMF(27),U,1)=$P(ABM("B8"),U,8)
EMER I $P(ABM("B8"),U,5)]"" S $P(ABMF(23),U,4)="X"
LAB I $P(ABM("B8"),U,1)]"" S $P(ABMF(29),U,2)="X",$P(ABMF(29),U,4)=$P(ABM("B8"),U,1)
 E  S $P(ABMF(29),U,3)="X"
 I $P(ABM("B7"),U,5)="Y" S ABMF("19")="SIGNATURE ON FILE"
 I $P(ABM("B7"),U,4)="Y" S ABMF("20")="SIGNATURE ON FILE"_U_$$HDTO^ABMDUTL(DT)
 ;
 I $P(ABMP("B0"),U,7)'=111 G DAYS
 ;
 ; Hosp Info
ADMIT I $P(ABM("B6"),U,1)]"" S $P(ABMF(27),U,2)=$$HDTO^ABMDUTL($P(ABM("B6"),U,1))
DISCH I $P(ABM("B6"),U,3)]"" S $P(ABMF(27),U,3)=$$HDTO^ABMDUTL($P(ABM("B6"),U,3))
 ;
DAYS ; Service Periods
 S ABM=0 F ABM("I")=1:1 S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABM)) Q:'ABM  D
 .S ABM("X")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),59,ABM,0),U,1) Q:ABM("X")=""
 .I $P(^ABMDCODE(ABM("X"),0),U)["EPSDT" S $P(ABMF(31),U,2)="X"
 .I $P(^ABMDCODE(ABM("X"),0),U)["FAMILY " S $P(ABMF(32),U,2)="X"
 .Q
 I $P($G(ABMF(31)),U,2)="" S $P(ABMF(31),U,3)="X"
 I $P($G(ABMF(32)),U,2)="" S $P(ABMF(32),U,3)="X"
 ;
CONT K ABM,ABMV,ABMX
 G ^ABMDF2C
 ;
XIT Q
