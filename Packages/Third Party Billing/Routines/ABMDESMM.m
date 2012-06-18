ABMDESMM ; IHS/ASDST/DMJ - Summarized Claim Medical Charges ;
 ;;2.6;IHS Third Party Billing System;**3**;NOV 12, 2009
 ;
 ;IHS/DSD/LSL -03/26/98  - Semicolon out the line in
 ;subrtn PRO that  quits if Optometry visit.
 ;Optometry 994 total was 0's 
 ; IHS/DSD/LSL - 09/02/98 - Patch 2 - NOIS NDA-0898-180038
 ;             0.00 charges on HCFA because version 2.0 does not assume
 ;             1 for units.  Modify code to set units to 1 if not
 ;             already defined.
 ;
 ; IHS/SD/SDR - v2.5 - p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;    Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;   Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - v2.5 p12 - IM25331
 ;   Add provider taxonomy to CMS-1500 block 24K
 ; IHS/SD/SDR - v2.5 p13 - IM25574
 ;   Correction for CPT modifier in Medical multiple
 ; IHS/SD/SDR - v2.5 p13 - IM25899
 ;   Alignment changes
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
PRO ;EP for Medical Charges
 ;
 S ABMCAT=27 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"27,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D PRO1
 Q
 ;
PRO1 ;PRO1
 S ABMX(0)=@(ABMP("GL")_"27,"_ABMX("X")_",0)")
 S ABMZ("UNIT")=$P(ABMX(0),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 I $G(ABMP("VTYP",999)),'$G(ABMPRINT),ABMP("VTYP",999)'=ABMP("EXP"),$P(ABMX(0),"^",2)>959 Q
 S ABMX("SUB")=(ABMZ("UNIT")*$P(ABMX(0),U,4))
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G PROH
PROU S ABMX("R")=$P(ABMX(0),U,2) Q:ABMX("R")=""  D REVN
 Q
 ;
PROH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=27 D HDT^ABMDESM1
 S ABMX("C")=$P(ABMX(0),U) D CPT
 ;S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,5)]"":"-"_$P($$MOD^ABMCVAPI($P(ABMX(0),U,5),"",ABMP("VDT")),U,2),1:"")_$S($P(ABMX(0),U,8)]"":"-"_$P(ABMX(0),U,8),1:"")_$S($P(ABMX(0),U,9)]"":"-"_$P(ABMX(0),U,9),1:"")  ;CSV-c  ;IHS/SD/SDR 3/1/2010 HEAT11136
 S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,5)]"":"-"_$P(ABMX(0),U,5),1:"")_$S($P(ABMX(0),U,8)]"":"-"_$P(ABMX(0),U,8),1:"")_$S($P(ABMX(0),U,9)]"":"-"_$P(ABMX(0),U,9),1:"")  ;CSV-c  ;IHS/SD/SDR 3/1/2010 HEAT11136
 I ABMP("EXP")=27  S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,5)]"":"   "_$P(ABMX(0),U,5),1:"")_$S($P(ABMX(0),U,8)]"":" "_$P(ABMX(0),U,8),1:"")_$S($P(ABMX(0),U,9)]"":" "_$P(ABMX(0),U,9),1:"")
 S $P(ABMS(ABMS("I")),U,5)=$P(ABMX(0),U,6)
 S $P(ABMS(ABMS("I")),U,6)=ABMZ("UNIT")
 I $P(ABMX(0),"^",16) D
 .S $P(ABMS(ABMS("I")),U,7)=$P($G(^ABMDCODE($P(ABMX(0),"^",16),0)),"^")
 E  S $P(ABMS(ABMS("I")),U,7)=1
 S $P(ABMS(ABMS("I")),U,10)=$P($G(ABMX(0)),"^",15)  ;POS
 S $P(ABMS(ABMS("I")),U,8)=$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,3)  ;CSV-c
 S ABMX(0)=@(ABMP("GL")_"27,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"27,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"27,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I +$G(ABMDPRV)=0 S ABMDPRV=$$GETPRV^ABMDFUTL
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
REVN S $P(ABMS(ABMX("R")),U)=+$P($G(ABMS(ABMX("R"))),U)+ABMX("SUB")
 S $P(ABMS(ABMX("R")),"^",2)=$P(ABMS(ABMX("R")),"^",2)+ABMZ("UNIT")
 Q
