ABMDESMD ; IHS/ASDST/DMJ - Summarized Claim Info - DENTAL ;    
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 09/21/00 - V2.4 Patch 3 - NOIS HQW-0900-100053
 ;     Some payers require a prefix of S, D, or 0 to ADA code
 ;
 ; IHS/SD/SDR - 10/03/02 - V2.5 P2 - NHA-0302-180192
 ;     Modified routine to get the units instead of hardset to 1 and
 ;     to calculate charges based on units
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;    Remove quit for ADA-90/ADA-94 formats
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ;   Change to print provider# on dental line items
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
DEN ;EP for setting DENTAL info in the ABMS array
 I $G(ABMP("VTYP",998)),'$G(ABMPRINT) Q:ABMP("VTYP",998)'=ABMP("EXP")
 S ABMCAT=33 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"33,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D DEN1
 Q
 ;
DEN1 S ABMX(0)=@(ABMP("GL")_"33,"_ABMX("X")_",0)")
 S ABMUNIT=$S($P(ABMX(0),U,9)'="":$P(ABMX(0),U,9),1:1)
 S ABMX("SUB")=$P(ABMX(0),U,8)*ABMUNIT
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G DENH
DENU S ABMX("R")=$P(ABMX(0),U,2) Q:ABMX("R")=""
 I $D(ABMS(ABMX("R"))) S $P(ABMS(ABMX("R")),U)=$P(ABMS(ABMX("R")),U)+ABMX("SUB")
 E  S ABMS(ABMX("R"))=ABMX("SUB")
 Q
 ;
 ; ABMS(#)=Charge^date from^date to^CPT Code^Corr. ICD^units^typ serv^Description^ADA Code^tooth^surface
DENH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=33 D HDT^ABMDESM1
 S $P(ABMS(ABMS("I")),U,6)=$S($P(ABMX(0),U,9)'="":$P(ABMX(0),U,9),1:1)
 S $P(ABMS(ABMS("I")),U,7)=9
 I $P(ABMX(0),U,3),ABMP("EXP")<4 S $P(ABMS(ABMS("I")),U,4)=$P($$CPT^ABMCVAPI($P(ABMX(0),U,3),ABMP("VDT")),U,2)  ;CSV-c
 E  D
 .S $P(ABMS(ABMS("I")),U,4)=$P($G(^AUTTADA(+ABMX(0),0)),U)
 .S ABMDENP=$P($G(^ABMDREC(ABMP("INS"),0)),U,2)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(ABMP("LDFN"),1,3)),U,11)
 .S:ABMDENP="" ABMDENP=$P($G(^ABMDPARM(DUZ(2),1,3)),U,11)
 .S:ABMDENP]"" $P(ABMS(ABMS("I")),U,4)=ABMDENP_$P(ABMS(ABMS("I")),U,4)
 S $P(ABMS(ABMS("I")),U,5)=$P(ABMX(0),"^",4)
 S $P(ABMS(ABMS("I")),U,8)=""
OPS I +$P(ABMX(0),U,5),$D(^ADEOPS($P(ABMX(0),U,5),88)) S $P(ABMS(ABMS("I")),U,8)="#"_$P(^(88),U) S:$P(ABMX(0),U,6)]"" $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_"-"_$P(ABMX(0),U,6) S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_" "
 S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_$P(^AUTTADA(+ABMX(0),0),U,2)
 S ABMX(0)=@(ABMP("GL")_"33,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"33,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"33,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 Q
