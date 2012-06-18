ABMDESMX ; IHS/ASDST/DMJ - Summarized Claim RADIOLOGY charges ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/DSD/LSL - 09/02/98 - Patch 2 - NOIS NDA-0898-180038
 ;             0.00 charges on HCFA because version 2.0 does not assume
 ;             1 for units.  Modify code to set units to 1 if not
 ;             already defined.
 ;
 ; IHS/SD/SDR - v2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
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
RAD ;EP for adding Radiology
 I $G(ABMP("VTYP",995)),'$G(ABMPRINT) Q:ABMP("VTYP",995)'=ABMP("EXP")
 S ABMCAT=35 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"35,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D RAD1
 Q
 ;
RAD1 S ABMX(0)=@(ABMP("GL")_"35,"_ABMX("X")_",0)")
 S ABMZ("UNIT")=$P(ABMX(0),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMX("SUB")=(ABMZ("UNIT")*$P(ABMX(0),U,4))
 I ABMX("SUB")=0 S ABMS("I")=ABMS("I")-1 Q
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G RADH
RADU S ABMX("R")=$P(ABMX(0),U,2) Q:ABMX("R")=""
 I $D(ABMS(ABMX("R"))) S $P(ABMS(ABMX("R")),U)=$P(ABMS(ABMX("R")),U)+ABMX("SUB")
 E  S ABMS(ABMX("R"))=ABMX("SUB")
 Q
 ;
RADH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=35 D HDT^ABMDESM1
 S $P(ABMS(ABMS("I")),U,4)=$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,2)_$S($P(ABMX(0),U,5)]"":"-"_$P(ABMX(0),U,5),1:"")_$S($P(ABMX(0),U,6)]"":"-"_$P(ABMX(0),U,6),1:"")_$S($P(ABMX(0),U,7)]"":"-"_$P(ABMX(0),U,7),1:"")  ;CSV-c
 I ABMP("EXP")=27 S $P(ABMS(ABMS("I")),U,4)=$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,2)_$S($P(ABMX(0),U,5)]"":" "_$P(ABMX(0),U,5),1:"")_$S($P(ABMX(0),U,6)]"":" "_$P(ABMX(0),U,6),1:"")_$S($P(ABMX(0),U,7)]"":" "_$P(ABMX(0),U,7),1:"")  ;CSV-c
 S $P(ABMS(ABMS("I")),"^",5)=$P(ABMX(0),"^",8)
 S $P(ABMS(ABMS("I")),U,6)=ABMZ("UNIT")
 I $P(ABMX(0),"^",16) D
 . S $P(ABMS(ABMS("I")),U,7)=$P($G(^ABMDCODE($P(ABMX(0),"^",16),0)),"^")
 E  S $P(ABMS(ABMS("I")),U,7)=4
 S $P(ABMS(ABMS("I")),U,10)=$P($G(ABMX(0)),"^",15)  ;POS
 S $P(ABMS(ABMS("I")),U,8)=$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,3)  ;CSV-c
 S ABMX(0)=@(ABMP("GL")_"35,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"35,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"35,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 Q
