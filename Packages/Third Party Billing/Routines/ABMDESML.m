ABMDESML ; IHS/ASDST/DMJ - Summarized Claim LAB Charges ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p12 - IM25331
 ;   Add provider taxonomy to CMS-1500 block 24K
 ; IHS/SD/SDR - v2.5 p13 - IM25899
 ;   Alignment changes
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
LAB ;EP for Lab Charges
 I $G(ABMP("VTYP",996)),'$G(ABMPRINT) Q:ABMP("VTYP",996)'=ABMP("EXP")
 S ABMCAT=37 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"37,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D LAB1
 Q
OUT ;OUTSIDE LAB
 Q:'$D(ABMP(638))
 Q:'$P($G(@(ABMP("GL")_"8)")),U)  S ABMX("SUB")=$P(^(8),U),ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" S ABMX("R")=300 D REVN Q
 S ABMS(ABMS("I"))=ABMX("SUB"),$P(ABMS(ABMS("I")),U,8)="OUTSIDE LAB TESTS"
 S ABMCAT=37 D HDT^ABMDESM1
 S ABMS("I")=ABMS("I")+1
 Q
 ;
LAB1 S ABMX(0)=@(ABMP("GL")_"37,"_ABMX("X")_",0)")
 S ABMZ("UNIT")=$P(ABMX(0),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMX("SUB")=(ABMZ("UNIT")*$P(ABMX(0),U,4))
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G LABH
 ; ABMS(revn)=Totl Charge^units^Unit Charge^CPT Code
LABU S ABMX("R")=$P(ABMX(0),U,2) Q:ABMX("R")=""  D REVN
 Q
 ;
 ; ABMS(#)=Charge^date from^date to^CPT Code^Corr. ICD^units^typ serv^Description
LABH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=37 D HDT^ABMDESM1
 S ABMX("C")=$P(ABMX(0),U) D CPT S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,6)]"":"-"_$P(ABMX(0),U,6),1:"")_$S($P(ABMX(0),U,7)]"":"-"_$P(ABMX(0),U,7),1:"")_$S($P(ABMX(0),U,8)]"":"-"_$P(ABMX(0),U,8),1:"")
 I ABMP("EXP")=27 D
 .S ABMX("C")=$P(ABMX(0),U) D CPT S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,6)]"":"   "_$P(ABMX(0),U,6),1:"")_$S($P(ABMX(0),U,7)]"":" "_$P(ABMX(0),U,7),1:"")_$S($P(ABMX(0),U,8)]"":" "_$P(ABMX(0),U,8),1:"")
 S $P(ABMS(ABMS("I")),"^",5)=$P(ABMX(0),"^",9)
 S $P(ABMS(ABMS("I")),U,6)=ABMZ("UNIT")
 S $P(ABMS(ABMS("I")),U,7)=5
 S $P(ABMS(ABMS("I")),U,8)=$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,3)  ;CSV-c
 S ABMX(0)=@(ABMP("GL")_"37,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"37,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"37,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 Q
 ;
CPT I ABMX("C")]"" S ABMX("C")=$P($$CPT^ABMCVAPI(ABMX("C"),ABMP("VDT")),U,2)  ;CSV-c
 Q
 ;
REVN I $D(ABMS(ABMX("R"))) S $P(ABMS(ABMX("R")),U)=$P(ABMS(ABMX("R")),U)+ABMX("SUB")
 E  S ABMS(ABMX("R"))=ABMX("SUB")
 Q
