ABMDF27A ; IHS/ASDST/DMJ - Set HCFA-1500 (08/05) Print Array ;    
 ;;2.6;IHS Third Party Billing;**1,4**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25331
 ;   Put taxonomy code if NPI ONLY
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4158 - mammography cert#
 ; IHS/SD/SDR - abm*2.6*4 - HEAT12115 - Moved box 22 right by 2 for "extra" DX codes
 ;
ENT ;
 K ABMF,ABM,ABMU,ABMR,ABMS
 S ABMP("B0")=^ABMDBILL(DUZ(2),ABMP("BDFN"),0)       ;0 node bill file
 S ABMP("INS")=$P(ABMP("B0"),U,8)                    ;Active insurer IEN
 Q:'ABMP("INS")                                      ;q:no active ins
 S ABMP("PDFN")=$P(ABMP("B0"),U,5)                   ;Patient IEN
 S ABMP("LDFN")=$P(ABMP("B0"),U,3)                   ;Visit Location IEN
 Q:'ABMP("PDFN")!('+ABMP("LDFN"))                    ;q:no pat or loc
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)  ;Srv date from
 S ABMP("BTYP")=$P(ABMP("B0"),"^",2)                 ;Bill type
 S ABMP("VTYP")=$P(ABMP("B0"),"^",7)                 ;Visit Type IEN
 S (ABMP("CLN"),ABMP("CLIN"))=$P(ABMP("B0"),"^",10)                ;clinic
 S ABMP("ITYPE")=$P($G(^AUTNINS(ABMP("INS"),2)),U)  ; Type of ins.
 S ABMP("NPIS")=$$NPIUSAGE^ABMUTLF(ABMP("LDFN"),ABMP("INS"))
 S (ABMV("X1"),ABMV("X2"),ABMV("X3"))=""
 D PAT^ABMDE1X                        ; returns ABMV("X2") array
 D REMPL^ABMDE1X1                     ; returns ABMV("X3") array
 D LOC^ABMDE1X1                       ; returns ABMV("X1") array
 K ABME
 ;
BLOC ;
 S ABMF(50)=$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,11)  ; Facility phone
 ; Billing Name
 S $P(ABMF(51),"^",2)=$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),"^",6)
 I $P(ABMF(51),"^",2)="" D
 .S $P(ABMF(51),U,2)=$S($P($G(^ABMDPARM(DUZ(2),1,2)),U,6)]"":$P(^(2),U,6),$P($P(ABMV("X1"),U,2),"C/O ",2)]"":$P($P(ABMV("X1"),U,2),"C/O ",2),1:$P($P(ABMV("X1"),U),";",2))
 S $P(ABMF(52),U,3)=$P(ABMV("X1"),U,3)   ; Billing Address
 S $P(ABMF(53),U,2)=$TR($P(ABMV("X1"),U,4),",")   ; Billing City,State Zip
 S ABMLNPI=$S($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,8)'="":$P(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1),U,8),$P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,12)'="":$P(^ABMDPARM(ABMP("LDFN"),1,2),U,12),1:ABMP("LDFN"))
 S $P(ABMF(54),U,2)=$P($$NPI^XUSNPI("Organization_ID",ABMLNPI),U)
 I ($P($G(^DIC(40.7,ABMP("CLIN"),0)),U,2)=72)&($P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)'="") S $P(ABMF(54),U,2)=$P($G(^ABMDPARM(ABMP("LDFN"),1,5)),U,4)  ;abm*2.6*1 HEAT4158
 I ABMP("ITYPE")="R"&(ABMP("NPIS")'="")&(ABMP("NPIS")'="N") S $P(ABMF(54),U,3)=$S($$MCR^ABMUTLF(ABMP("LDFN"))'="":"1C"_$$MCR^ABMUTLF(ABMP("LDFN")),1:"")
 I (ABMP("ITYPE")="D"!(ABMP("ITYPE")="K"))&(ABMP("NPIS")'="")&(ABMP("NPIS")'="N") S $P(ABMF(54),U,3)=$S($$MCD^ABMUTLF(ABMP("LDFN"))'="":"1D"_$$MCD^ABMUTLF(ABMP("LDFN")),1:"")
 I (ABMP("ITYPE")'="R"&(ABMP("ITYPE")'="D")&(ABMP("ITYPE")'="K"))&(ABMP("NPIS")'="N") D
 .S ABMIDCD=""
 .D PIREFID^ABME8L2
 .S $P(ABMF(54),U,3)=$S($$PI^ABMUTLF(ABMP("LDFN"))'="":ABMIDCD_$$PI^ABMUTLF(ABMP("LDFN")),1:"")
 I $G(ABMP("NPIS"))="N"&(($P($G(^AUTNINS(ABMP("INS"),0)),U)="NEW MEXICO MEDICAID")!($P($G(^AUTNINS(ABMP("INS"),0)),U)="MEDICAID EXEMPT")) D
 .S $P(ABMF(54),U,3)=""
 E  I (ABMP("NPIS")'="")&(ABMP("NPIS")'="N") S $P(ABMF(54),U,3)="ZZ"_$$PTAX^ABMUTLF(ABMP("LDFN"))
 ;
VLOC ;
 S $P(ABMF(51),U)=$P(^DIC(4,ABMP("LDFN"),0),U)
 I $G(ABMP("CLIN"))'="",($P($G(^DIC(40.7,ABMP("CLIN"),0)),U)["AMBULANCE") S $P(ABMF(51),U)="ORIGIN: "_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,2)
 I $D(^DIC(4,ABMP("LDFN"),1)) D
 .S ABMVLOC=^DIC(4,ABMP("LDFN"),1)
 .S $P(ABMF(52),"^",2)=$P(ABMVLOC,U)
 .S $P(ABMF(53),U)=$TR($$CSZ^ABMDUTL($P(ABMVLOC,"^",3)_"^"_$P(^DIC(4,ABMP("LDFN"),0),"^",2)_"^"_$P(ABMVLOC,"^",4)),",")
 .K ABMVLOC
 I '$D(^DIC(4,ABMP("LDFN"),1)) D
 .S $P(ABMF(52),U,2)=$P(^AUTTLOC(ABMP("LDFN"),0),U,12)
 .S $P(ABMF(53),U)=$TR($$CSZ^ABMDUTL($P(^AUTTLOC(ABMP("LDFN"),0),U,13,15)),",")
 I $P($G(^DIC(40.7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10),0)),U)["AMBULANCE" D
 .S ABMDREC=$$GETDEST^ABMDE31($P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,7))
 .S $P(ABMF(52),U,2)="DESTINATION: "_$P(ABMDREC,U)
 ;
BNUM ;
 S $P(ABMF(49),U,4)=$P(ABMP("B0"),U)_$S($P($G(^ABMDPARM(ABMP("LDFN"),1,2)),U,4)]"":"-"_$P(^ABMDPARM(ABMP("LDFN"),1,2),U,4),1:"")
 I $P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,3),($P($G(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0)),U,2)) S $P(ABMF(49),U,4)=$P(ABMF(49),U,4)_"-"_$P(^AUPNPAT(ABMP("PDFN"),41,ABMP("LDFN"),0),U,2)
 ;
INSNUM ;
 ;GET PROVIDER NUMBER
 S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),0)),"^",8)
 I ABM("INUM")="" D
 .S ABM("I")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$P(ABMP("B0"),U,7),0)),U,6)
 .S ABM("INUM")=$P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,$S(ABM("I")="Y":999,1:$P(ABMP("B0"),U,7)),0)),U,8)
 S:ABM("INUM")="" ABM("INUM")=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 S:(ABMP("NPIS")'="N") $P(ABMF(54),U,5)=ABM("INUM")
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="R"&(ABMP("NPIS")'="N") S $P(ABMF(54),U,5)=$P(^AUTTLOC(ABMP("LDFN"),0),U,19)
 S ABM("ITYP")=$P($G(^AUTNINS(ABMP("INS"),2)),U)
 S ABM("ITYP")=$S(ABM("ITYP")="R":1,ABM("ITYP")="D":2,ABM("ITYP")="C":3,1:7)
 S $P(ABMF(1),U,ABM("ITYP"))="X"
 ;
TAX ;
 S $P(ABMF(49),U,1)=$P(ABMV("X1"),U,6)
 S:$P(ABMV("X1"),U,6)]"" $P(ABMF(49),U,3)="X"
 S $P(ABMF(49),U,5)="X"
 ;
PNODES ;
 ;PATIENT INFO
 D ISET^ABMERUTL             ; Needed to get medicaid name from ABMER20A
 D PNM^ABMER20A
 S ABM("P0")=ABME("PNM")
 S $P(ABM("P0"),"^",3)=ABME("DOB")
 ;
NAME ;
 S ABMF(3)=$P(ABM("P0"),U)
 ;
ADDRESS ;
 S $P(ABMF(5),U)=$P(ABMV("X2"),U,3)
 S $P(ABMF(7),U)=$P($P(ABMV("X2"),U,4),", ")
 S $P(ABMF(7),U,2)=$P($P($P(ABMV("X2"),U,4),", ",2),"  ")
 S $P(ABMF(9),U)=$P($P($P(ABMV("X2"),U,4),", ",2),"  ",2)
 S $P(ABMF(9),U,2)=$S($E($P(ABMV("X2"),U,5))="(":"",1:" ")_$P(ABMV("X2"),U,5)
 ;
DOB ;
 S $P(ABMF(3),U,2)=$P(ABM("P0"),U,3)
 ;
SEX ;
 I $P(ABMV("X2"),U,2)="M" S $P(ABMF(3),U,3)="X"
 E  S $P(ABMF(3),U,4)="X"
 K ABM("P0")
 I $P(^AUPNPAT(ABMP("PDFN"),0),U,21),"1246"[$P(^(0),U,21) S $P(ABMF(9),U,3)="X"
 ;I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)'="" S $P(ABMF(31),U,3)=$P(^(4),U,9)  ;abm*2.6*4 HEAT12115
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),4)),U,9)'="" S $P(ABMF(31),U,5)=$P(^(4),U,9)  ;abm*2.6*4 HEAT12115
 ;
XIT ;
 K ABM,ABMX,ABMV
 Q
