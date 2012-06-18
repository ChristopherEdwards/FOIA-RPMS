ABMDESM1 ; IHS/ASDST/DMJ - Display Summarized Claim Info ; 
 ;;2.6;IHS Third Party Billing;**1,6,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers and units
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Added code for misc services if dental visit type
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    Prompt/display provider
 ; IHS/SD/SDR - v2.5 p8 - task 6
 ;   Modified to check for ambulance services
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p9 - IM19707
 ;    Make sure ABMP("CLN") is defined before using
 ; IHS/SD/SDR - v2.5 p10 - IM19843
 ;    Added SERVICE TO DATE/TIME
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p12 - IM25331
 ;   Made change to print Taxonomy if NPI ONLY
 ; IHS/SD/SDR,AML - v2.5 p13 - IM25899
 ;   Alignment changes
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7884 - display if visit type 731
 ; IHS/SD/SDR - abm*2.6*6 - HEAT28973 - if 55 modifier present use '1' for units when calculating charges
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - Swing bed changes
 ;
 K ABMS
 ;
 ; ABMS(revn)=Totl Charge^units^Unit Charge^CPT Code^Non-Cvd Amount
 ;
 S ABMS("TOT")=0,ABMS("I")=1
 G ITEM:'$D(ABMP("FLAT"))
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB",$P(ABMP("FLAT"),U,8) Q
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" D  G XIT
 .;S ABMX=$P($G(@(ABMP("GL")_"6)")),U,6)+$P($G(^(7)),U,3) S:$E(ABMP("BTYP"),2)'<3 ABMX=1  ;abm*2.6*1 HEAT7884
 .S ABMX=$P($G(@(ABMP("GL")_"6)")),U,6)  ;abm*2.6*1 HEAT7884
 .S ABMX=ABMX+$S((ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID")):$P($G(@(ABMP("GL")_"5)")),U,7),1:$P($G(@(ABMP("GL")_"7)")),U,3))  ;abm*2.6*1 HEAT7884
 .;S:($E(ABMP("BTYP"),2)'<3&'(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID"))) ABMX=1  ;abm*2.6*1 HEAT7884  ;abm*2.6*6 Swing bed
 .S:($E(ABMP("BTYP"),2)'<3&'(ABMP("VTYP")=999&(ABMP("BTYP")=731)&($P($G(^AUTNINS(ABMP("INS"),0)),U)["MONTANA MEDICAID"))&(ABMP("BTYP")'=181)) ABMX=1  ;abm*2.6*1 HEAT7884  ;abm*2.6*6 Swing bed
 .S:ABMX=0 ABMX=1 S ABMS($P(ABMP("FLAT"),U,2))=$P(ABMP("FLAT"),U)*ABMX_U_ABMX_U_$P(ABMP("FLAT"),U)_U_U_($P($G(@(ABMP("GL")_"6)")),U,6)*$P(ABMP("FLAT"),U))
 .S ABMS("TOT")=+ABMS($P(ABMP("FLAT"),U,2)) G ^ABMDESMC:(ABMP("BTYP")=831)
 .I $D(ABMP("FLAT",170)) S ABMX=ABMP("FLAT",170),ABMS(170)=$P(ABMP("FLAT"),U)*ABMX_U_ABMX_U_$P(ABMP("FLAT"),U)_U_U_($P($G(@(ABMP("GL")_"6)")),U,6)*$P(ABMP("FLAT"),U)),ABMS("TOT")=ABMS("TOT")+ABMS(170)
 ; I flat rate HCFA ...
 I ($P(^ABMDEXP(ABMP("EXP"),0),U)["HCFA")!($P(^ABMDEXP(ABMP("EXP"),0),U)["CMS") D  G XIT
 .S (ABMS("TOT"),ABMS(1))=$P(ABMP("FLAT"),U)*$P(ABMP("FLAT"),U,3)
 .S ABMS(1)=ABMS(1)_U_$$HDT^ABMDUTL($P(@(ABMP("GL")_"7)"),U))_U_$$HDT^ABMDUTL($P(@(ABMP("GL")_"7)"),U,2))_U
 .S ABMS(1)=ABMS(1)_$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),"^",16)
 .S ABMS(1)=ABMS(1)_U_U_$P(ABMP("FLAT"),U,3)_U_U_$P(ABMP("FLAT"),U,6)
 .I $$K24^ABMDFUTL D
 ..Q:'$G(ABMP("BDFN"))
 ..S ABMAPRV=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"C","A",0))
 ..S ABMAPRV=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,ABMAPRV,0),U)
 ..S $P(ABMS(1),U,9)=$$K24N^ABMDFUTL(ABMAPRV)
 ..S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMAPRV),U)
 ..;Below line for South Dakota Urban (SD Urban)
 ..S ABMTLOC=$$GET1^DIQ(9999999.06,ABMP("LDFN"),.05,"E")  ;abm*2.6*8 NOHEAT
 ..I ((ABMTLOC["PIERRE URBAN")!(ABMTLOC["SOUTH DAKOTA URBAN"))&($P($G(^AUTNINS(ABMP("INS"),0)),U)="SOUTH DAKOTA MEDICAID") S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Organization_ID",ABMP("LDFN")),U)  ;abm*2.6*8 NOHEAT
 ..I $G(ABMP("NPIS"))="N" S $P(ABMS(1),U,9)=$$PTAX^ABMEEPRV(ABMAPRV)
 I ABMP("PAGE")'[8 G XIT
ITEM ;itemized
 I ABMP("VTYP")=998 D ^ABMDESMD,^ABMDESMU,^ABMDESMX,^ABMDESML,^ABMDESMR,ER G XIT
 I ABMP("VTYP")=997 D ^ABMDESMR G XIT
 I ABMP("VTYP")=996 D ^ABMDESML G XIT
 I ABMP("VTYP")=995 D ^ABMDESMX G XIT
 I $G(ABMP("CLN"))'="",($P($G(^DIC(40.7,ABMP("CLN"),0)),U,2)="A3") D MISC^ABMDESMU,AMB^ABMDESMB G XIT
 D MS,^ABMDESMM,^ABMDESMX,^ABMDESML,^ABMDESMA,^ABMDESMD,^ABMDESMR,ER,ROO^ABMDESMU,MISC^ABMDESMU,REVN^ABMDESMU,SUP^ABMDESMU
 G XIT
 ;
MS ;
 S ABMCAT=21 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX="""""" F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"21,""C"","_ABMX_")")) Q:'ABMX  S ABMX("X")=$O(^(ABMX,"")) D MS1
 Q
 ;
MS1 S ABMX(0)=@(ABMP("GL")_"21,"_ABMX("X")_",0)"),ABMX(1)=$G(^(1))
 S ABMX("SUB")=$P(ABMX(0),"^",7)*$P(ABMX(0),"^",13)
 S:'+ABMX("SUB") ABMX("SUB")=$P(ABMX(0),U,7)
 I ($P(ABMX(0),U,9)=55!($P(ABMX(0),U,11)=55)!($P(ABMX(0),U,12)=55)) S ABMX("SUB")=$P(ABMX(0),U,7)  ;IHS/SD/SDR 2/15/11 HEAT28973
 S ABMX("R")=$P(ABMX(0),U,3)
 I +$P(ABMX(0),U,7)=0!(ABMX("R")=""&($P(^ABMDEXP(ABMP("EXP"),0),U)["UB")) S ABMS("I")=ABMS("I")-1 Q
MS2 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G MSH
 I ABMX("R")="" S ABMS("I")=ABMS("I")-1 Q
MSU S ABMS(ABMX("R"))=+$G(ABMS(ABMX("R")))+ABMX("SUB")
 S:$P(ABMS(ABMX("R")),U,4)="" $P(ABMS(ABMX("R")),U,4)=$P(ABMX(0),U)
 Q
 ;
MSH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMS(ABMS("I"))=ABMS(ABMS("I"))_U_$$HDT^ABMDUTL($P(ABMX(0),U,5))
 S $P(ABMS(ABMS("I")),U,3)=$S($P(ABMX(0),U,19)'="":$$HDT^ABMDUTL($P(ABMX(0),U,19)),1:$P(ABMS(ABMS("I")),U,2))
 S ABMX("C")=$P(ABMX(0),U)
 D CPT
 S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,9)]"":"-"_$P(ABMX(0),U,9),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,11)]"":"-"_$P(ABMX(0),U,11),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,12)]"":"-"_$P(ABMX(0),U,12),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U)]"":"-"_$P(ABMX(1),U),1:"")
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U,2)]"":"-"_$P(ABMX(1),U,2),1:"")
 I ABMP("EXP")=27 D
 .S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,9)]"":"   "_$P(ABMX(0),U,9),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,11)]"":" "_$P(ABMX(0),U,11),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(0),U,12)]"":" "_$P(ABMX(0),U,12),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U)]"":" "_$P(ABMX(1),U),1:"")
 .S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P(ABMX(1),U,2)]"":" "_$P(ABMX(1),U,2),1:"")
 S $P(ABMS(ABMS("I")),U,5)=$P(ABMX(0),U,4)
 S $P(ABMS(ABMS("I")),U,6)=$P(ABMX(0),U,13)
 I $P(ABMX(0),U,16) D
 .S $P(ABMS(ABMS("I")),U,7)=$P($G(^ABMDCODE($P(ABMX(0),U,16),0)),U)
 E  S $P(ABMS(ABMS("I")),U,7)=$S($P(^DIC(81.1,$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,4),0),U,3)=2:2,1:1)  ;CSV-c
 S $P(ABMS(ABMS("I")),U,10)=$P($G(ABMX(0)),U,15)  ;POS
 S $P(ABMS(ABMS("I")),U,8)=$P(^AUTNPOV($P(ABMX(0),U,6),0),U)
 S ABMX(0)=@(ABMP("GL")_"21,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"21,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"21,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 Q
 ;
ER ;
 S ABMX("ER")=+$P($G(@(ABMP("GL")_"8)")),U,10) I 'ABMX("ER") Q
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" S $P(ABMS(450),U)=$S($D(ABMS(450)):$P(ABMS(450),U)+ABMX("ER"),1:ABMX("ER")) G HER
 S ABMS(ABMS("I"))=ABMX("ER")
 S X=$S($P($G(@(ABMP("GL")_"6)")),U)]"":$P(@(ABMP("GL")_"6)"),U),1:$P($G(@(ABMP("GL")_"7)")),U))
 S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL(X)
 S $P(ABMS(ABMS("I")),U,3)=$P(ABMS(ABMS("I")),U,2)
 S $P(ABMS(ABMS("I")),U,8)="EMERGENCY ROOM CHARGE"
 S ABMS("I")=ABMS("I")+1
HER S ABMS("TOT")=ABMS("TOT")+ABMX("ER")
 Q
 ;
CPT S:ABMX("C") ABMX("C")=$P($$CPT^ABMCVAPI(ABMX("C"),ABMP("VDT")),U,2) Q  ;CSV-c
 ;
XIT K ABMX
 Q
 ;
HDT ;EP for date format
 S ABMDTF=$P($G(@(ABMP("GL")_"7)")),U)
 S ABMDTT=$P($G(@(ABMP("GL")_"7)")),U,2)
 I '$G(ABMCAT) D  Q
 .S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL(ABMDTF)
 .S $P(ABMS(ABMS("I")),U,3)=$$HDT^ABMDUTL(ABMDTT)
 I ABMCAT=21 D
 .Q:$P(ABMX(0),U,5)=""
 .S ABMDTF=$P(ABMX(0),U,5)
 .S ABMDTT=$S($P(ABMX(0),U,19)'="":$P(ABMX(0),U,19),1:$P(ABMX(0),U,5))
 I ABMCAT=23 D
 .Q:$P(ABMX(0),U,14)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,14)
 I ABMCAT=25 D
 .Q:$P(ABMX(0),U,4)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,4)
 I ABMCAT=27 D
 .Q:$P(ABMX(0),U,7)=""
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,7))
 I ABMCAT=33 D
 .Q:$P(ABMX(0),U,7)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,7)
 I ABMCAT=35 D
 .Q:$P(ABMX(0),U,9)=""
 .S ABMDTF=$P(ABMX(0),U,9)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,9))
 I ABMCAT=37 D
 .Q:$P(ABMX(0),U,5)=""
 .S ABMDTF=$P(ABMX(0),U,5)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,5))
 I ABMCAT=39 D
 .Q:'$P(ABMX(0),U,8)
 .S ABMDTT=$P(ABMX(0),U,8)
 .S ABMDTT=$P(ABMDTT,".",1)
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTF=$P(ABMDTF,".")
 I ABMCAT=43 D
 .Q:$P(ABMX(0),U,7)=""
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,7))
 I ABMCAT=45 D
 .Q:$P(ABMX(0),U,2)=""
 .S (ABMDTF,ABMDTT)=$P(ABMX(0),U,2)
 I ABMCAT=47 D
 .Q:$P(ABMX(0),U,7)=""
 .S ABMDTF=$P(ABMX(0),U,7)
 .S ABMDTT=$S($P(ABMX(0),U,12)'="":$P(ABMX(0),U,12),1:$P(ABMX(0),U,7))
 S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL(ABMDTF)
 S $P(ABMS(ABMS("I")),U,3)=$$HDT^ABMDUTL(ABMDTT)
 K ABMDTF,ABMDTT,ABMPC,ABMCAT
 Q
PCK ;EP - PAGE CHECK
 K ABMQUIT
 Q:ABMP("GL")'["ABMDCLM"
 S ABMPC=$F("27^21^25^23^37^35^39^43^33^45^47",ABMCAT)/3
 S ABMEXM=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),70)),"^",ABMPC)
 S:ABMEXM="" ABMEXM=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,14)
 Q:ABMEXM=""
 S:ABMEXM'=ABMP("EXP") ABMQUIT=1
 K ABMEXM,ABMPC
 Q
