ABMDE8B1 ; IHS/ASDST/DMJ - Edit Page 8 - SURG PROC ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**6**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P2 - 5/9/02 - NOIS HQW-0302-100190
 ;     Modified to display 2nd and 3rd modifiers and units
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - v2.6 p6 - HEAT28973 - if 55 modifier present use '1' for units when calculating charges
 ;
 D MODE^ABMDE8X
 I ^ABMDEXP(ABMMODE(2),0)["UB" S ABMZ("DR")=";W !;.03//960"_ABMZ("DR")
 D HD G LOOP
HD W !,"BIL",?4,"SERV"
 W ?11,$S($P(^ABMDEXP(ABMP("EXP"),0),"^",1)["UB":"REVN",1:"CORR"),?17," CPT",?29,"CPT",?52,"PROVIDER'S"
 W !,"SEQ",?4,"DATE"
 W ?11,$S($P(^ABMDEXP(ABMP("EXP"),0),"^",1)["UB":"CODE",1:"DIAG")
 W ?17," CODE    DESCRIPTION",?52,"NARRATIVE",?72,"CHARGE"
 W !,"===",?4,"=====",?10,"======",?17,"==========================="
 W ?46,"=======================",?71,"========"
 Q
LOOP S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABM)=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,"C",ABM)) Q:'ABM  S ABM("X")=$O(^(ABM,"")),ABMZ("NUM")=ABM("I") D MS1
 S ABM("L")=ABMZ("LNUM")+1,ABMZ("DR2")=";.02////"_ABM("L")
 S ABMZ("MOD")=.09_U_3_U_.11_U_.12
TOTL I ABM("TOTL")>0 W !?70,"=========",!?68,$J(("$"_$FN(ABM("TOTL"),",",2)),11)
 G XIT
 ;
MS1 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM("X"),0)) K ^ABMDCLM(DUZ(2),ABMP("CDFN"),21,"C",ABM,ABM("X")) Q
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),21,ABM("X"),0),ABM("X1")=$G(^(1))
 S:ABMZ("LNUM")<$P(ABM("X0"),U,2) ABMZ("LNUM")=$P(ABM("X0"),U,2)
ICD K ABM("ICD0") S ABM("ICD")=0 F  S ABM("ICD")=$O(^ICPT(+ABM("X0"),"ICD",ABM("ICD"))) Q:'ABM("ICD")  D  Q:ABM("ICD")="HIT"
 .I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,ABM("ICD"),0)) S ABM("ICD")="HIT"
 .I '$D(ABM("ICD0")) S ABM("ICD0")=ABM("ICD")
 I $D(ABM("ICD0")),ABM("ICD")'="HIT" S DA(1)=ABMP("CDFN"),DIC="^ABMDCLM(DUZ(2),"_DA(1)_",19,",(DINUM,X)=ABM("ICD0"),DIC("DR")=";.03///"_$P(ABM("X0"),U,5)_";.04////"_$P(ABM("X0"),U,6)
 I  S ABM("ICD0")=0,ABM("ICD")="" F  S ABM("ICD")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),19,"C",ABM("ICD"))) Q:'ABM("ICD")  S ABM("ICD0")=ABM("ICD")
 I  K DD,DO S DIC(0)="LE",DIC("DR")=".02////"_(ABM("ICD0")+1)_DIC("DR") S DIC("P")=$P(^DD(9002274.3,19,0),U,2) D FILE^DICN
 S ABMZ("MOD")=""
 F ABM("M")=9,1,2 S:$P($S(ABM("M")=9:ABM("X0"),1:ABM("X1")),U,ABM("M"))]"" ABMZ("MOD")=ABMZ("MOD")_"-"_$P($S(ABM("M")=9:ABM("X0"),1:ABM("X1")),U,ABM("M"))
 S ABMZ(ABM("I"))=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,2)_U_ABM("X")_U_$P(ABM("X0"),U)_U_$P(ABM("X0"),U,3,12)  ;CSV-c
EOP I $Y>(IOSL-5) D PAUSE^ABMDE1,HD
 S ABM("LITMTOTAL")=$P(ABM("X0"),"^",7)*$P(ABM("X0"),"^",13)
 I ABMZ("MOD")="-55" S ABM("LITMTOTAL")=$P(ABM("X0"),"^",7)*(1)  ;IHS/SD/AML 2/10/2011 - HEAT28973
 K ABMU S ABMU(1)="?70"_U_$J($FN(ABM("LITMTOTAL"),",",2),9)
 S ABM("TOTL")=ABM("TOTL")+ABM("LITMTOTAL")
 W !,$J(ABM("I"),2)
 W ?4,$E($P(ABM("X0"),U,5),4,5),"/",$E($P(ABM("X0"),U,5),6,7)
 I $P(^ABMDEXP(ABMP("EXP"),0),U)["UB" W ?11,$S($P(ABM("X0"),U,3)="":"***",$D(^AUTTREVN($P(ABM("X0"),U,3),0)):$P(^(0),U),1:"***")
 E  W ?10,$P(ABM("X0"),U,4)
 W ?17,$P(ABMZ(ABM("I")),U) I ABMZ("MOD")]"" W ABMZ("MOD")
 I $P(^ABMDPARM(DUZ(2),1,0),U,14)'="Y" S ABMU("TXT")=$P($$CPT^ABMCVAPI($P(ABM("X0"),U),ABMP("VDT")),U,3)  ;CSV-c
 ;start CSV-c
 E  D
 .S ABMU("TXT")=""
 .D IHSCPTD^ABMCVAPI($P(ABM("X0"),U),ABMZCPTD,"",ABMP("VDT"))
 .S ABM("CP")=0
 .F  S ABM("CP")=$O(ABMZCPTD(ABM("CP"))) Q:'$D(ABMZCPTD(ABM("CP")))  D
 ..S ABMU("TXT")=ABMU("TXT")_ABMZCPTD(ABM("CP"))_" "
 ;end CSV-c
 S ABMU("RM")=44,ABMU("LM")=24+$L(ABMZ("MOD")),ABMU("TAB")=6+$L(ABMZ("MOD"))
 S ABMU("2TXT")=$S($P(ABM("X0"),U,6)]"":$P($G(^AUTNPOV($P(ABM("X0"),U,6),0)),U),1:""),ABMU("2LM")=46,ABMU("2RM")=70,ABMU("2TAB")=-2
 D ^ABMDWRAP
 Q
 ;
XIT I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 K ABM,ABMMODE
 Q
