ABMDESMR ; IHS/ASDST/DMJ - Summarized Claim RX charges ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DSD/LSL - 09/02/98 - Patch 2 - NOIS NDA-0898-180038
 ;             0.00 charges on HCFA because version 2.0 does not assume
 ;             1 for units.  Modify code to set units to 1 if not
 ;             already defined.
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    Prompt/display provider
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 57
 ;    Added code for days supply
 ;
 ; IHS/SD/SDR- v2.5 p9 - task 1
 ;   Use new service line provider multiple
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20645
 ;    NDC not printing all the time
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM25331
 ;    Add provider taxonomy to CMS-1500 block 24K
 ;
MED ;EP for Medication Charges
 Q:$P($G(^AUTNINS(ABMP("INS"),2)),U,3)="U"
 Q:$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,997,0)),U,7)="N"
 I $G(ABMP("VTYP",997)),'$G(ABMPRINT) Q:ABMP("VTYP",997)'=ABMP("EXP")
 S ABMCAT=23 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"23,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D MED1
 Q
 ;
MED1 S ABMX(0)=@(ABMP("GL")_"23,"_ABMX("X")_",0)")
 S ABMZ("UNIT")=$P(ABMX(0),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMX("SUB")=+$FN(ABMZ("UNIT")*$P(ABMX(0),U,4),"T",2)+$P(ABMX(0),U,5)
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G MEDH
 ; ABMS(revn)=Totl Charge^units^Unit Charge^CPT Code^Drug^Rx #
MEDU S ABMX("R")=$P(ABMX(0),U,2) Q:ABMX("R")=""
 I $D(ABMS(ABMX("R"))) S $P(ABMS(ABMX("R")),U)=$P(ABMS(ABMX("R")),U)+ABMX("SUB")
 E  S ABMS(ABMX("R"))=ABMX("SUB")
 Q
 ;
 ; ABMS(#)=Charge^date from^date to^CPT Code^Corr. ICD^units^typ serv^Description^RX #^Provider^Days Supply
MEDH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=23 D HDT^ABMDESM1
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMX(0),U,29)  ;cpt
 S $P(ABMS(ABMS("I")),"^",5)=$P(ABMX(0),"^",13)
 S $P(ABMS(ABMS("I")),U,6)=ABMZ("UNIT")
 S $P(ABMS(ABMS("I")),U,7)=9
 S ABMX("D")=$P(ABMX(0),U) D DRUG
 S ABMX("C")=$S($P(ABMX(0),U,24)'="":$P(ABMX(0),U,24),1:$P($G(^PSDRUG(+ABMX(0),2)),U,4))
 S $P(ABMS(ABMS("I")),U,8)=$S(ABMX("C")]"":ABMX("C")_" ",1:"")
 S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_$S('$P(ABMX(0),U,7)&'$P(ABMX(0),U,8):ABMX("D"),$P(ABMX(0),U,7):$P(^PS(52.6,$P(ABMX(0),U,7),0),U),1:$P(^PS(52.7,$P(ABMX(0),U,8),0),U))
 I ABMP("EXP")=27 S $P(ABMS(ABMS("I")),U,8)="N4"_$P(ABMS(ABMS("I")),U,8)
 I $P(ABMX(0),U,9)]"" S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_" "_$P(ABMX(0),U,9)
 I ABMP("EXP")'=27 S $P(ABMS(ABMS("I")),U,9)="RX#-"_$S($P(ABMX(0),U,22)'="":$P(^PSRX($P(ABMX(0),U,22),0),U),1:$P(ABMX(0),"^",6))
 S ABMX(0)=@(ABMP("GL")_"23,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"23,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"23,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .I ABMP("EXP")'=27 S $P(ABMS(ABMS("I")),U,9)=$P($G(ABMS(ABMS("I"))),U,9)_";;"_$$K24N^ABMDFUTL(ABMDPRV)
 .E  S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 Q
 ;
DRUG I ABMX("D")]"" S ABMX("D")=$P($G(^PSDRUG(ABMX("D"),0)),U)
 Q
RX I ABMX("C")]"" S ABMX("C")=$P($G(^PSRX(ABMX("C"),0)),U)
 Q
