ABMDESMA ; IHS/ASDST/DMJ - Summarized Claim ANESTHESIA charges ;
 ;;2.6;IHS Third Party Billing;**1,3**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P8 - IM10618/IM11164
 ;   Prompt/display provider
 ; IHS/SD/SDR - v2.5 p9 - IM17729
 ;    Added code to calculate anesthesia minutes
 ; IHS/SD/SDR - v2.5 p9 - task 1
 ;    Use new service line provider multiple
 ; IHS/SD/SDR - v2.5 p10 - IM21539
 ;    Fixed summary screen to display correct anes amt
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ; IHS/SD/SDR - 2.5 p12 - IM25331
 ;   Add provider taxonomy to CMS-1500 block 24K
 ; IHS/SD/SDR - v2.5 p12 - IM24277
 ;   Added code for 2nd and 3rd modifiers
 ; IHS/SD/SDR,AML - v2.5 p13 - IM25899
 ;   Alignment changes
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT6566 - Populate anes based on MCR vs non-MCR
 ; IHS/SD/SDR - abm*2.6*3 - HEAT12742 - Corrections to MCR/non-MCR; removed all HEAT6566 changes
 ;
ANS ;EP for Anesthesia Charges
 I $G(ABMP("VTYP",992)),'$G(ABMPRINT) Q:ABMP("VTYP",992)'=ABMP("EXP")
 S ABMCAT=39 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"39,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D ANS1
 Q
ANS1 ;
 S ABMX(0)=@(ABMP("GL")_"39,"_ABMX("X")_",0)")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" S ABMX("R")=$P(ABMX(0),U,2)
 S (ABMX("C"),ABMX("SUB"))=$P(ABMX(0),U,4)  ;abm*2.6*1 HEAT6566
 ;I ($G(ABMP("ITYP"))="R")!($G(ABMP("ITYPE"))="R") S (ABMX("C"),ABMX("SUB"))=$P(ABMX(0),U,4)  ;abm*2.6*1 HEAT6566
 ;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S ABMX("C")=$P(ABMX(0),U,3),ABMX("SUB")=ABMX("C")+$P(ABMX(0),U,4)  ;abm*2.6*1 HEAT6566  ;IHS/SD/SDR 4/27/10 HEAT12742
 ;I ($G(ABMP("ITYP"))'="R")!($G(ABMP("ITYPE"))'="R") S (ABMX("C"),ABMX("SUB"))=+$P(ABMX(0),U,4)  ;abm*2.6*1 HEAT6566  ;IHS/SD/SDR 4/27/10 HEAT12742
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G ANSH
ANSU Q:ABMX("R")=""  D REVN
 Q
 ;
ANSH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=39 D HDT^ABMDESM1
 S ABMX("C")=$P(ABMX(0),U) D CPT S $P(ABMS(ABMS("I")),U,4)=ABMX("C")
 S:$P(ABMX(0),"^",6)'="" $P(ABMS(ABMS("I")),"^",4)=$P(ABMS(ABMS("I")),"^",4)_"-"_$P(ABMX(0),"^",6)
 S:$P(ABMX(0),"^",14)'="" $P(ABMS(ABMS("I")),"^",4)=$P(ABMS(ABMS("I")),"^",4)_"-"_$P(ABMX(0),"^",14)
 S:$P(ABMX(0),"^",19)'="" $P(ABMS(ABMS("I")),"^",4)=$P(ABMS(ABMS("I")),"^",4)_"-"_$P(ABMX(0),"^",19)
 I ABMP("EXP")=27 S ABMX("C")=$P(ABMX(0),U) D CPT S $P(ABMS(ABMS("I")),U,4)=ABMX("C") D
 .S:$P(ABMX(0),U,6)'="" $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_"   "_$P(ABMX(0),U,6)
 .S:$P(ABMX(0),U,14)'="" $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_" "_$P(ABMX(0),U,14)
 .S:$P(ABMX(0),U,19)'="" $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_" "_$P(ABMX(0),U,19)
 S $P(ABMS(ABMS("I")),"^",5)=$P(ABMX(0),"^",10)
 S $P(ABMS(ABMS("I")),U,10)=$P(ABMX(0),U,15)
 S ABMMTS=$$FMDIFF^XLFDT($P(ABMX(0),U,8),$P(ABMX(0),U,7),2)
 S ABMMTS=ABMMTS\60
 S $P(ABMS(ABMS("I")),U,6)=ABMMTS
 S:$P(ABMS(ABMS("I")),"^",6)="" $P(ABMS(ABMS("I")),"^",6)=1
 S $P(ABMS(ABMS("I")),U,7)=7
 S $P(ABMS(ABMS("I")),U,8)="ANESTHESIA IN ASSOC W/ CPT:"_$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,2)  ;CSV-c
 S ABMX(0)=@(ABMP("GL")_"39,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"39,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"39,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 S:$P(ABMX(0),"^",6)'="" $P(ABMS(ABMS("I")),"^",8)=$P(ABMS(ABMS("I")),"^",8)_"-"_$P(ABMX(0),"^",6)
 I ABMP("EXP")=27 D
 .S $P(ABMS(ABMS("I")),U,2)=$P(ABMS(ABMS("I")),U,2)_"@"_$P($$MDT^ABMDUTL($P(ABMX(0),U,7))," ",2)
 .S $P(ABMS(ABMS("I")),U,3)=$P(ABMS(ABMS("I")),U,3)_"@"_$P($$MDT^ABMDUTL($P(ABMX(0),U,8))," ",2)
 Q
 ;
CPT I ABMX("C")]"" S ABMX("C")=$P($$CPT^ABMCVAPI(ABMX("C"),ABMP("VDT")),U,2)  ;CSV-c
 Q
ICD I ABMX("D")]"" S ABMX("D")=$P($$DX^ABMCVAPI(ABMX("D"),ABMP("VDT")),U,2)  ;CSV-c
 Q
 ;
REVN I $D(ABMS(ABMX("R"))) S $P(ABMS(ABMX("R")),U)=$P(ABMS(ABMX("R")),U)+ABMX("SUB")
 E  S ABMS(ABMX("R"))=ABMX("SUB")
 Q
