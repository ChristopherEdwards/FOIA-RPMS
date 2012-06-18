ABMDESMH ; IHS/DSD/DMJ - Profession Services for Seperate Bill ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 p5 - 5/18/04 - Modified to put POS and TOS by line item
 ; IHS/SD/SDR - v2.5 p13 - IM25574
 ;   Correction to CPT Modifier in Medical multiple
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 K ABMS I $D(ABMP("FLAT")),$P(ABMP("FLAT"),U,3)]"" G FLAT
 ;
 S ABMS("TOT")=0
MS S:'$D(ABMS("I")) ABMS("I")=1 S ABMX="""""",ABMX("ER")=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"21,""C"","_ABMX_")")) Q:'ABMX  S ABMX("X")=$O(^(ABMX,"")) D MS1
 G PRO
 ;
MS1 S ABMX(0)=@(ABMP("GL")_"21,"_ABMX("X")_",0)"),ABMX(1)=$G(^(1))
 S ABMX("R")=$P(ABMX(0),U,3)
 I +$P(ABMX(0),U,7)=0!(ABMX("R")=""&($P(^ABMDEXP(ABMP("EXP"),0),U)["UB")) S ABMS("I")=ABMS("I")-1 Q
 I (ABMX("R")<960!(ABMX("R")>963))&(ABMX("R")'=969) S ABMS("I")=ABMS("I")-1 Q
 S ABMS("TOT")=ABMS("TOT")+$P(ABMX(0),U,7)
 ; ABMS(#)=Charge^date from^date to^CPT Code^Corr. ICD^units^typ serv^Description
MSH S ABMS(ABMS("I"))=$P(ABMX(0),U,7)
 S $P(ABMS(ABMS("I")),U,2)=$$HDT^ABMDUTL($P(ABMX(0),U,5)),$P(ABMS(ABMS("I")),U,3)=$$HDT^ABMDUTL($P(ABMX(0),U,5))
 S ABMX("C")=$P(ABMX(0),U) D CPT S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,9)]"":"-"_$P(ABMX(0),U,9),1:"")_$S($P(ABMX(1),U)]"":"-"_$P(ABMX(1),U),1:"")_$S($P(ABMX(1),U,2)]"":"-"_$P(ABMX(1),U,2),1:"")
 S ABMX("D")=$P(ABMX(0),U,4) D ICD S $P(ABMS(ABMS("I")),U,5)=ABMX("D")
 S $P(ABMS(ABMS("I")),U,6)=1
 I $P(ABMX(0),"^",16) D
 . S $P(ABMS(ABMS("I")),U,7)=$P($G(^ABMDCODE($P(ABMX(0),"^",16),0)),"^")
 E  S $P(ABMS(ABMS("I")),U,7)=$S($P(^DIC(81.1,$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,4),0),U,3)=2:2,1:1)  ;CSV-c
 S $P(ABMS(ABMS("I")),U,10)=$P($G(ABMX(0)),"^",15)  ;POS
 S $P(ABMS(ABMS("I")),U,8)=$P(^AUTNPOV($P(ABMX(0),U,6),0),U)
 Q
 ;
PRO S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"27,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D PRO1
 G ANS
 ;
PRO1 S ABMX(0)=@(ABMP("GL")_"27,"_ABMX("X")_",0)")
 S ABMX("SUB")=($P(ABMX(0),U,3)*$P(ABMX(0),U,4))
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 ;
PROH S ABMS(ABMS("I"))=ABMX("SUB")
 D HDT^ABMDESM1
 ;
 S ABMX("C")=$P(ABMX(0),U) D CPT
 S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_$S($P(ABMX(0),U,5)]"":"-"_$P($$MOD^ABMCVAPI($P(ABMX(0),U,5),"",ABMP("VDT")),U,2),1:"")_$S($P(ABMX(0),U,8)]"":"-"_$P(ABMX(0),U,8),1:"")_$S($P(ABMX(0),U,9)]"":"-"_$P(ABMX(0),U,9),1:"")  ;CSV-c
 ;
 S ABMX("D")=$P(ABMX(0),U,6) D ICD S $P(ABMS(ABMS("I")),U,5)=ABMX("D")
 S $P(ABMS(ABMS("I")),U,6)=$P(ABMX(0),U,3)
 S $P(ABMS(ABMS("I")),U,7)=1
 S $P(ABMS(ABMS("I")),U,8)=$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,3)  ;CSV-c
 Q
 ;
ANS S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"39,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D ANS1
 G XIT
 ;
ANS1 S ABMX(0)=@(ABMP("GL")_"39,"_ABMX("X")_",0)")
 S ABMX("R")=$P(ABMX(0),U,2) I ABMX("R")'=963 S ABMS("I")=ABMS("I")-1 Q
 S ABMX("C")=$P(ABMX(0),U,3)   ; D ANESTH^ABMDESMA
 S ABMX("SUB")=ABMX("C")+$P(ABMX(0),U,4)
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
ANSH S ABMS(ABMS("I"))=ABMX("SUB") D HDT^ABMDESM1
 S ABMX("C")=$P(ABMX(0),U) D CPT S $P(ABMS(ABMS("I")),U,4)=ABMX("C")_"-47"
 S $P(ABMS(ABMS("I")),U,6)=1,$P(ABMS(ABMS("I")),U,7)=7
 S $P(ABMS(ABMS("I")),U,8)="ANESTHESIA IN ASSOC W/ CPT:"_$P($$CPT^ABMCVAPI(+ABMX(0),ABMP("VDT")),U,2)  ;CSV-c
 Q
 ;
CPT ;
 S:ABMX("C")]"" ABMX("C")=$P($$CPT^ABMCVAPI(ABMX("C"),ABMP("VDT")),U,2)  ;CSV-c
 Q
ICD ;
 S:ABMX("D")]"" ABMX("D")=$P($$DX^ABMCVAPI(ABMX("D"),ABMP("VDT")),U,2)  ;CSV-c
 Q
 ;
XIT S ABMP("EXP",ABMP("VTYP",999))=ABMS("TOT")
 K ABMX
 Q
 ;
FLAT S $P(ABMS(1),U,2)=$$HDT^ABMDUTL($P($G(@(ABMP("GL")_"7)")),U))
 S $P(ABMS(1),U,3)=$$HDT^ABMDUTL($P($G(@(ABMP("GL")_"7)")),U,2))
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="R" S $P(ABMS(1),U,4)=90250
 S ABMX("FDAYS")=$S($P(ABMS(1),U,2)=$P(ABMS(1),U,3):1,1:$P(ABMP("FLAT"),U,8))
 S ABMX("NARR")=$S(ABMX("FDAYS")>0:ABMX("FDAYS"),1:1)
 S ABMX("NARR2")=" "_$S(ABMX("NARR")>1:"DAYS",1:"DAY")_" @ $"_$J($P(ABMP("FLAT"),U,4),4,2)
 S $P(ABMS(1),U,8)=ABMX("NARR")_ABMX("NARR2")
 S ABMS("TOT")=$P(ABMP("FLAT"),U,4)*$S(ABMX("FDAYS")>0:ABMX("FDAYS"),1:1)
 S $P(ABMS(1),U,1)=ABMS("TOT")
 S $P(ABMS(1),U,6)=$S(ABMX("FDAYS")>0:ABMX("FDAYS"),1:1)
 S $P(ABMS(1),U,7)=1
 G XIT
