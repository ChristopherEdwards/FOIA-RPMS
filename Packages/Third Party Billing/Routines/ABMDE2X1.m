ABMDE2X1 ; IHS/ASDST/DMJ - PAGE 2 - Primary Insurer Check ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 01/09/02 - V2.4 Patch 10 
 ;     Modified to allow pick option to function properly.  Thanks to
 ;     Jim Gray for the research.
 ;
 ; *********************************************************************
 ;
 S ABMP("C0")=@(ABMP("GL")_"0)")
 ;
PRIM ;
 S ABMP("INS")=""
 I $P(ABMP("C0"),U,8)="",'$G(ABMP("DERP OPT")) D
 .S ABMYES=0
 .S ABM("DR")=""
 .F  S ABM("DR")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM("DR"))) Q:'ABM("DR")  D  Q:'ABM("DR")
 ..S ABM("DA")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM("DR"),""))
 ..Q:ABM("DA")=""
 ..Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("DA"),0))
 ..K ABM("DRI")
 ..S ABM("I0")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("DA"),0))
 ..I "UCB"[$P(ABM("I0"),U,3) Q
 ..S ABM("INSCO")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("DA"),0),U)
 ..I +ABMYES,$P(ABM("I0"),U,3)="I" S ABM("DRI")=".03////P"
 ..I '+ABMYES D
 ...I $P(ABM("I0"),U,3)'="I" D
 ....S ABM("DRI")=".03////I"
 ...S ABMYES=1
 ...I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)'=ABM("INSCO") D
 ....S DIE="^ABMDCLM(DUZ(2),"
 ....S DA=ABMP("CDFN")
 ....S DR=".08////^S X=ABM(""INSCO"")"
 ....D ^DIE
 ....K DR
 ..I $D(ABM("DRI")) D
 ...S DA(1)=ABMP("CDFN")
 ...S DA=ABM("DA")
 ...S DR=ABM("DRI")
 ... S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ...D ^DIE
 ...K DR
 S ABMP("C0")=@(ABMP("GL")_"0)")
 I $P(ABMP("C0"),U,8)="" S ABME(111)="" G XIT
 S ABMP("INS")=$P(ABMP("C0"),U,8)
 K ABMP("FLAT"),ABMP("EXP"),ABMP("PX"),ABMP("FEE")
 D ^ABMDE2X4
 D FRATE
 D EXP^ABMDE2X5
 S:ABMP("BTYP")=121 ABMP("VTYP")=111
 G XIT
 ;
 ; X6=EXPORT MODE^PROCDURE CODING METHOD^BILL TYPE^REVN CD^FLAT RATE
 ;
FRATE ;EP - Entry Point for setting up Flat Rate array if applicable
 S ABMV("X6")=""
 I '$D(ABMP("GL")) S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,11),$P(^(0),U,11)=111!($P(^(0),U,11)=131) D
 .S DA(1)=ABMP("INS")
 .S DA=ABMP("VTYP")
 .S DIE="^ABMNINS("_DA(1)_",1,"
 .S DR=".11////"_$S($P(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0),U,11)=111:40,1:42)
 .D ^DIE
 D BTYP^ABMDEVAR
 S $P(ABMV("X6"),"^",3)=ABMP("BTYP")
 S:ABMP("BTYP")=121 ABMP("VTYP")=121
 S ABMX("VDT")=$P($G(@(ABMP("GL")_"7)")),U)
 I '$D(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0)) G RT
 S $P(ABMV("X6"),U,2)=$P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,2)
 S $P(ABMV("X6"),U,4)=$P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,3)
 I $P(ABMV("X6"),"^",4)="" D
 .I ABMP("VTYP")=111 S $P(ABMV("X6"),"^",4)=100 Q
 .I ABMP("VTYP")=121 S $P(ABMV("X6"),"^",4)=240 Q
 .S $P(ABMV("X6"),"^",4)=510
 I '$D(ABMP("EXP")) D EXP^ABMDEVAR
 I $D(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0)) D
 .I $P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,4) D
 ..S $P(ABMV("X6"),U)=$P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,4)
 .I $P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,5) D
 ..S ABMP("FEE")=$P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,5)
 I $D(ABMP("VTYP",999)),$P($G(^AUTNINS(ABMX("INS"),2)),U)="R" D
 .S ABMX=0 F  S ABMX=$O(@(ABMP("GL")_"13,"_ABMX("INS")_",11,"_ABMX_")")) Q:'ABMX  I $P($G(^AUTTPIC(ABMX,0)),U,3)="B" S ABMX="OK" Q
 .I ABMX'="OK" K ABMP("VTYP",999)
 S ABMX=0
 K ABMX("HIT")
 S $P(ABMV("X6"),"^",5)=$$FLAT^ABMDUTL(ABMX("INS"),ABMP("VTYP"),ABMX("VDT"))
 ;
RT ; ABMP("FLAT")=Flat Rate^Revn^Units^Pro Fee^Pro Coding Method^Revn Desc^Desc Code^Prof Comp Days
 I +$P(ABMV("X6"),U,5) D
 .S ABMP("FLAT")=$P(ABMV("X6"),U,5)_U_$P(ABMV("X6"),U,4)
 .S ABMP("FLAT")=ABMP("FLAT")_U_$S((ABMP("BTYP")=111!(ABMP("BTYP")=121))&($P($G(@(ABMP("GL")_"7)")),U,3)>0):$P($G(^(7)),U,3),ABMP("BTYP")=111:1,$P($G(^(6)),U,9)]"":$P(^(6),U,9),1:1)
 I  S $P(ABMP("FLAT"),U,6)=$P($P(^ABMNINS(DUZ(2),ABMX("INS"),1,ABMP("VTYP"),0),U,9),"|"),$P(ABMP("FLAT"),U,7)=$P($P(^(0),U,9),"|",2)
 Q:'$D(ABMP("FLAT"))
 I $P($G(@(ABMP("GL")_"5)")),U,10)>0 S ABMP("FLAT",170)=$P(^(5),U,10)
 I $D(ABMP("VTYP",999)) D
 .S $P(ABMP("FLAT"),U,8)=$P($G(@(ABMP("GL")_"5)")),U,7)
 .S:'$P(ABMP("FLAT"),U,8) $P(ABMP("FLAT"),U,8)=$P(ABMP("FLAT"),U,3)+3
 .S $P(ABMP("FLAT"),U,5)=$P($G(^ABMNINS(DUZ(2),ABMX("INS"),1,999,0)),U,2)
 .S $P(ABMP("FLAT"),U,4)=$$FLAT^ABMDUTL(ABMX("INS"),999,ABMX("VDT"))
 Q
 ;
 ; *********************************************************************
XIT ;
 K ABMX
 Q
