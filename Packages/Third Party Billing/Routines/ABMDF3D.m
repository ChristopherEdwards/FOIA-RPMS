ABMDF3D ; IHS/ASDST/DMJ - Set HCFA1500 Print Array - Part 4 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ; IHS/SD/LSL - 11/18/02 - V2.5 Patch 2 - NOIS CGA-1102-110054
 ;      Resolve <UNDEF>54+2^ABMDBLK
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;    Added code for modifier changes if ambulance and QL
 ; IHS/SD/SDR - v2.5 p10 - block 29
 ;    Added code to check new flag for printing block 29
 ; IHS/SD/SDR - v2.5 p12 - IM24880
 ;   Made change for number of line items printing per page
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 ; ********************************************************************
 ; 
DX ; Diagnosis Info
 K ABMP("DX")
 S ABM="" F ABM("I")=31:1:34 S ABM=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM)) Q:'ABM  D
 .S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",ABM,""))
 .S ABM(9)=$P(^AUTNPOV($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABM("X"),0),U,3),0),U)
 .S ABM(9)=$S(ABM(9)["*ICD*":$P(ABM(9),"  "),1:ABM(9))
 .S ABM("ID")=$S(ABM("I")=32:33,ABM("I")=34:33,1:31)
 .S ABM("TB")=$S(ABM("I")<33:1,1:2)
 .S ABM(9)=""
 .S ABM("DIAG")=$P($$DX^ABMCVAPI(ABM("X"),ABMP("VDT")),U,2)  ;CSV-c
 .S $P(ABMF(ABM("ID")),U,ABM("TB"))=ABM("DIAG")_" "_ABM(9)
 .S ABMP("DX",ABM("DIAG"))=ABM("I")-30
 ;
ST S ABMP("GL")="^ABMDBILL(DUZ(2),"_ABMP("BDFN")_","
 S ABMPRINT=1 D ^ABMDESM1
 I $P($G(^DIC(40.7,$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,10),0)),U,2)="A3" D
 .S ABMI=0
 .F  S ABMI=$O(ABMS(ABMI)) Q:'ABMI  D
 ..I $P($P(ABMS(ABMI),U,4),"-",2)="QL" S ABMQLFLG=1
 ..S ABMODMOD=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,14)_$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),12)),U,16)
 .S ABMI=0
 .F  S ABMI=$O(ABMS(ABMI)) Q:'ABMI  D
 ..I $G(ABMQLFLG)=1,($P($P(ABMS(ABMI),U,4),"-",2)'="QL") S $P(ABMS(ABMI),U,4)=$P($P(ABMS(ABMI),U,4),"-")
 ..I $G(ABMQLFLG)'=1 S $P(ABMS(ABMI),U,4)=$P($P(ABMS(ABMI),U,4),"-")_$P($P(ABMS(ABMI),U,4),"-",2)_"-"_ABMODMOD
 K ABMQLFLG
HCFA ;
 I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U)=0 S ABMS("TOT")=0
 D EMG^ABMDF3E
 S ABMS=0
 F  S ABMS=$O(ABMS(ABMS)) Q:+ABMS=0  D
 .S ABMLN=2
 .D PROC^ABMDF14E
 .S ABMLN=ABMLN+1
 S ABMLN=0,ABMPRT=0
 F ABMS("I")=37:1:47 D  Q:$G(ABM("QUIT"))
 .S ABMLN=$O(ABMR(ABMLN))
 .I 'ABMLN S ABM("QUIT")=1 Q
 .S ABMPRT=0
 .I (($O(ABMR(ABMLN,9),-1))+(ABMS("I")))>49 Q
 .F  S ABMPRT=$O(ABMR(ABMLN,ABMPRT)) Q:+ABMPRT=0  D
 ..I +$O(ABMR(ABMLN,ABMPRT))'=0,($G(ABMF(ABMS("I")-1))=""),(ABMS("I")#2=1),ABMS("I")=37 S ABMS("I")=ABMS("I")-1
 ..M ABMF(ABMS("I"))=ABMR(ABMLN,ABMPRT)
 ..S ABMS("I")=ABMS("I")+1
 ..K ABMR(ABMLN,ABMPRT)
 ;
 D PREV^ABMDFUTL
 S ABM("RATIO")=+^ABMDBILL(DUZ(2),ABMP("BDFN"),2)/$S($P(^(2),U,3):$P(^(2),U,3),1:1)
 S:ABM("RATIO")>1 ABM("RATIO")=1
 S ABM("W")=+$FN(ABMP("WO")*ABM("RATIO"),"",2)
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,17)="DO" D
 .S $P(ABMF(49),U,8)=+$FN(ABMP("PD")*ABM("RATIO"),"",2)+ABM("W")
 S ABM("OB")=ABMS("TOT")-$P(ABMF(49),U,8)
 S:ABM("OB")<0 ABM("OB")=0
 S ABM("YTOT")=ABM("OB")
 D YTOT^ABMDFUTL
 S $P(ABMF(49),U,7)=ABMS("TOT")                        ; Total Charges
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,17)="DO" D
 .S $P(ABMF(49),U,8)=+$FN(ABMP("PD"),"",2)
 ; Amount Due
 I $D(ABMP("BILL")) S $P(ABMF(49),U,9)=+$FN(ABMP("BILL"),"",2)
 E  S $P(ABMF(49),U,9)=+$FN(ABMS("TOT")-ABMP("PD"),"",2)-$G(ABMP("PENS"))-$G(ABMP("NONC"))
 K ABMS
 I $D(ABMR) D
 .S ABMR("TOT")=$P(ABMF(49),U,7,9)
 .S $P(ABMF(49),U,7)="",$P(ABMF(49),U,8)="",$P(ABMF(49),U,9)=""
 ;
PRV ; Provider Info
 I $P($G(^ABMDPARM(DUZ(2),1,0)),"^",17)=3 D  G PDT
 .S ABM("SIGN")=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",7)
 .I ABM("SIGN")="" D
 ..S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0)) D
 ...Q:'ABM("X")
 ...D SELBILL^ABMDE4X
 ...S ABM("SIGN")=$P(ABM("A"),U,2)
 .E  D
 ..S ABM("A")=$P($G(^VA(200,+ABM("SIGN"),20)),"^",2)_"^"_+ABM("SIGN")
 .S $P(ABMF(53),U)=$P($G(^VA(200,+ABM("SIGN"),20)),"^",2)
 I $P($G(^ABMDPARM(DUZ(2),1,0)),U,17)=2 D  G PDT
 .S $P(ABMF(53),U)=$P($G(^VA(200,$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,4),20)),"^",2)
 S ABM("X")=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0)) D
 .Q:'ABM("X")
 .D SELBILL^ABMDE4X
 .S $P(ABMF(52),U)=$P($G(^VA(200,+$P(ABM("A"),"^",2),20)),"^",2)
 .S:$P(ABMF(52),U)="" $P(ABMF(52),U)=$P(ABM("A"),U)
 .S $P(ABMF(53),U)=ABM("PNUM")
PDT ;
 S $P(ABMF(54),U)=$$SDTO^ABMDUTL(DT)
 S ABMFLAG=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,20)
 I ABMFLAG["PRO",$D(ABM("A")) D
 .S ABM("PRO")=$P(ABM("A"),U,2)
 .S $P(ABMF(54),U,3)=$P($G(^VA(200,ABM("PRO"),9999999.18,ABMP("INS"),0)),U,2)
 .S $P(ABMF(54),U,4)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 I ABMFLAG["LOC" D
 .; provider number from insurer file
 .S $P(ABMF(54),U,3)=$P($G(^AUTNINS(ABMP("INS"),15,ABMP("LDFN"),0)),U,2)
 .; insurer assigned number form 3p insurer file
 .S $P(ABMF(54),U,4)=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 ; default to this if the block 33 was left blank
 I $G(ABMFLAG)="" D 54^ABMDBLK
 ;
XIT K ABM,ABMV,ABMX,ABMPRINT
 Q
