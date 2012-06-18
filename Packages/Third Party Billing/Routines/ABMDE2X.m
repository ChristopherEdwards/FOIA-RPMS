ABMDE2X ; IHS/ASDST/DMJ - PAGE 2 - INSURER data chk ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**3,6,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P3 - 1/24/03 - NOIS NEA-0301-180044
 ;     Modified routine to display patient info when workers comp
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM15307/IM14092 - Modified to check for new MSP errors 194-197
 ; IHS/SD/SDR - v2.5 p8 - IM15111 - Check format of Medicare name
 ; IHS/SD/SDR - v2.5 p10 - IM20000 - Added code to use CARD NAME for Policy Holder
 ; IHS/SD/SDR - v2.5 p10 - IM20593 - Added new warning for NO MSP FOR MEDICARE PATIENT
 ; IHS/SD/SDR - v2.5 p10 - IM20311 - Added new error for missing DOB when Medicare active (219)
 ; IHS/SD/SDR - v2.5 p12 - UFMS - Added new warning/errors 225 and 226 for pseudo/missing TIN
 ; IHS/SD/SDR - v2.5 p13 - NO IM
 ; IHS/SD/SDR - abm*2.6*3 - HEAT7574 - added tribal self-insured warning
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - added error 236
 ;
 ; *********************************************************************
ERR ;
 I '$D(ABMC("QUE")),'$G(ABMQUIET) D
 .S ABME("TITL")="PAGE 2 - INSURER INFORMATION"
 .W !?26,ABME("TITL"),!
 S ABM=""""""
 F ABM("I")=1:1 S ABM=$O(@(ABMP("GL")_"13,""C"","_ABM_")")) Q:'ABM
 I ABM("I")=1 S ABME(110)=""
 ;
PRIM ;
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 D ^ABMDE2X1
 I ABMP("INS")]"" D
 .S Y=ABMP("INS")
 .S ABM("XIEN")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"B",ABMP("INS"),0))
 .Q:'ABM("XIEN")
 .D COV^ABMDE2X5
 .D SEL
 K ABM,ABMV
 G XIT
 ;
 ; *********************************************************************
QUE ;
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 D ^ABMDE2X1
 S ABM=0
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM!($G(ABMC("CTR"))>0)  D
 .S ABM("XIEN")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,0))
 .S Y=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0),U)
 .D SEL
 .Q:'+$O(ABME(0))
 .S ABME("CHK")=""
 .D QUE^ABMDERR
 K ABM,ABMV
 G XIT
 ;
 ; *********************************************************************
 ; X1=IDFN;INSURER^PHONE^CONTACT^POLICY #^NAME^DOB^PROV #^COVERAGE(S)
 ;
SEL ;EP - Entry Point for Checking Select Insurer for Errors
 K ABMV,ABME
 D MERGE
 I $D(ABMP("ERR",Y)) S ABMX="" F  S ABMX=$O(ABMP("ERR",Y,ABMX)) Q:'ABMX  S ABME(ABMX)=""
 I $D(@(ABMP("GL")_"13,"_+ABM("XIEN")_",0)")) S ABMX("I0")=^(0)
 E  S ABMP("QUIT")="" G XIT
 S ABMX("INS")=$P(ABMX("I0"),U)
 ;
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,14)=1 D  ;export
 .S ABMTIN=$P($G(^AUTNINS(ABMX("INS"),0)),U,11)
 .;if no TIN and anything except Ben Patient
 .I ABMTIN="",($P($G(^AUTNINS(ABMX("INS"),2)),U)'="I") S ABME(225)=$S('$D(ABME(225)):$P(ABMX("I0"),U,2),1:ABME(225)_","_$P(ABMX("I0"),U,2))
 .I $A($E(ABMTIN,9))>64,$A($E(ABMTIN,9))<91 S ABME(226)=$S('$D(ABME(226)):$P(ABMX("I0"),U,2),1:ABME(226)_","_$P(ABMX("I0"),U,2))
 .K ABMTIN
 ;
 S ABMV("X1")=+Y_";"_$P(^AUTNINS(+Y,0),U)_U_$P(^(0),U,6)_U_$P(^(0),U,9)
 S (ABMV("X2"),ABMV("X3"))=""
 K DR
 I $L(ABMX("I0"),U)=3,$P(ABMX("I0"),U,3)'="U",$P(^AUTNINS(+Y,0),U)'="RAILROAD RETIREMENT" D
 .S ABMVDFN=$G(ABMP("VDFN"))
 .S DFN=ABMP("PDFN")
 .S ABMVDT=ABMP("VDT")
 .D ELG^ABMDLCK(ABMVDFN,.ABML,DFN,ABMVDT)
 .S ABM("PRI")=""
 .F  S ABM("PRI")=$O(ABML(ABM("PRI"))) Q:'ABM("PRI")  I $D(ABML(ABM("PRI"),ABMX("INS"))) D  Q
 ..Q:"PMRDAW"'[$P(ABML(ABM("PRI"),ABMX("INS")),U,3)
 ..Q:$P(ABML(ABM("PRI"),ABMX("INS")),U,3)=""
 ..I $P(ABML(ABM("PRI"),ABMX("INS")),U,3)?1(1"P",1"A",1"W") S DR=".08////"_$P(ABML(ABM("PRI"),ABMX("INS")),U,2)
 ..I $P(ABML(ABM("PRI"),ABMX("INS")),U,3)="M" S DR=".04////"_$P(ABML(ABM("PRI"),ABMX("INS")),U,2)
 ..I $P(ABML(ABM("PRI"),ABMX("INS")),U,3)="R" S DR=".05////"_$P(ABML(ABM("PRI"),ABMX("INS")),U,2)
 ..I $P(ABML(ABM("PRI"),ABMX("INS")),U,3)="D" S DR=".06////"_$P(ABML(ABM("PRI"),ABMX("INS")),U,1)_";.07////"_$P(ABML(ABM("PRI"),ABMX("INS")),U,2)
 ..S DA(1)=$S(ABMP("GL")["CLM":ABMP("CDFN"),1:ABMP("BDFN"))
 ..I $D(DR) D
 ...S DIE=ABMP("GL")_"13,"
 ...S DA=ABM("XIEN")
 ...D ^DIE
 ..S ABMX("I0")=@(ABMP("GL")_"13,"_ABM("XIEN")_",0)")
 ..K ABML
 I "INW"[$P($G(^AUTNINS(ABMX("INS"),2)),U),$P(^(2),U)]"" D ^ABMDE2X3 G XIT
 ;I $P($G(^AUTNINS(ABMX("INS"),2)),U)="P",('$D(^AUPNPRVT(ABMP("PDFN"),11,"B",ABMX("INS")))) D ^ABMDE2X3 G XIT  ;abm*2.6*6 HEAT30524
 I $P($G(^AUTNINS(ABMX("INS"),2)),U)="P",('$D(^AUPNPRVT(ABMP("PDFN"),11,"B",ABMX("INS")))) D ^ABMDE2X3  ;abm*2.6*6 HEAT30524
 S ABMX("DIC")=$S($P(ABMX("I0"),U,6)]"":"^AUPNMCD(",$P(ABMX("I0"),U,8)]"":"^AUPNPRVT(",$P(ABMX("I0"),U,4)]"":"^AUPNMCR(",1:"^AUPNRRE("),ABMX("SUB")=$S($P(ABMX("I0"),U,7)]"":$P(ABMX("I0"),U,7),1:"")
 S ABMX(2)=$S(ABMX("DIC")="^AUPNMCD(":$P(ABMX("I0"),U,6),1:ABMP("PDFN"))
 I ABMX("DIC")="^AUPNPRVT(" S ABMX(1)=$P(ABMX("I0"),"^",8) G XIT:'ABMX(1)
 I ABMX("DIC")="^AUPNMCD(" S ABMX(1)=$P(ABMX("I0"),U,7)
 S ABMX("REC")=ABMX("DIC")_ABMX(2)_",0)"
 Q:'$D(@ABMX("REC"))
 S ABMX("REC")=@ABMX("REC")
 S ABMX("LBL")=$E($P(ABMX("DIC"),"("),6,10)
 D @(ABMX("LBL")_"^ABMDE2XA")
 D COV^ABMDE2XA
 I +ABMV("X2"),$D(^AUPN3PPH(+ABMV("X2"),0)) D
 .S $P(ABMV("X2"),U)=$P(ABMV("X2"),U)_";"_$S($P($G(^AUPN3PPH($P(ABMV("X2"),U),1)),U)'="":$P($G(^AUPN3PPH($P(ABMV("X2"),U),1)),U),1:$P($G(^AUPN3PPH($P(ABMV("X2"),U),0)),U))
 .S:$P(ABMV("X2"),U,2)]"" $P(ABMV("X2"),U,2)=$S($D(^AUTTRLSH($P(ABMV("X2"),U,2),0)):$P(ABMV("X2"),U,2)_";"_$P(^(0),U),1:"")
 S:$P(ABMV("X1"),U,4)="" ABME(68)=""
 I $P(ABMP("C0"),U,8)="" S ABME(111)=""  ;abm*2.6*8 HEAT37612
 I $P($G(^AUTNINS(ABMX("INS"),2)),U)="R" D
 .S $P(ABMV("X1"),U,7)=$P(^AUTTLOC(ABMP("LDFN"),0),U,19)
 .S:$P($G(^AUTTLOC(ABMP("LDFN"),0)),U,19)="" ABME(173)=""
 .; no MSP and inpatient
 .I $G(ABMMSPRS)="",ABMP("BTYP")=111 S ABMG(194)=""
 .;
 .I ABMP("BTYP")'=111,($G(ABMMSP)="") S ABMG(218)=""
 .;
 .;not inpatient and >90 days since form signed
 .I ABMP("BTYP")'=111,($G(ABMMSP)'="") D
 ..S X=ABMMSP
 ..K %DT
 ..D ^%DT
 ..S X1=ABMP("VDT"),X2=Y
 ..D ^%DTC
 ..I X>90 S ABME(195)=""
 .;
 .;no MSP and Medicare is secondary
 .I $G(ABMMSPRS)="",$D(ABMZ(2)),($P($G(^AUTNINS($P($G(ABMZ(2)),U,2),2)),U))="R" S ABMG(196)=""
 .;
 .; MSP but Medicare not secondary
 .I $G(ABMMSPRS)'="",$D(ABMZ(2)),($P($G(^AUTNINS($P($G(ABMZ(2)),U,2),2)),U)'="R"),($G(ABMMSP)'="") D
 ..I ABMP("BTYP")'=111 S ABMG(197)=""
 ..S X=ABMMSP
 ..D ^%DT
 ..S X1=ABMP("VDT"),X2=Y
 ..D ^%DTC
 ..I X>90 S ABMG(197)=""
 E  I ABMP("LDFN")]"",$D(^AUTNINS(ABMX("INS"),15,ABMP("LDFN"),0)),$P(^(0),U,2)]"" S $P(ABMV("X1"),U,7)=$P(^(0),U,2)
 E  I $P(ABMV("X1"),U,7)="" S ABME(5)=""
 I ABMV("X2")]"" D ^ABMDE2X2
 D ^ABMDE2X3
 S:$G(ABMP("INS"))="" ABMP("INS")=$P($G(ABMV("X1")),";")
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="R"!($P($G(^AUTNINS(ABMP("INS"),2)),U)="D") D
 .S ABMCK=$P(ABMV("X1"),U,5)
 .D NAME
 .I $G(ABMCK)="" S ABME(203)=""
 I $P($G(^AUTNINS(ABMP("INS"),2)),U)="R",($P($G(ABMV("X1")),U,6)="") S ABME(219)=""
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),0)),U,11)="Y" S ABME(234)=""  ;abm*2.6*3 HEAT7574
 I $P(ABMV("X1"),U,4)="" S ABME(236)=""  ;abm*2.6*6 5010
 ;
XIT ;
 K ABMX,ABMP("ERR")
 Q
 ;
 ; *********************************************************************
MERGE ;CHECK IF INSURER HAS BEEN MERGED
 S ABMX("MRGDT")=$P($G(^AUTNINS(+Y,2)),U,7)
 Q:'ABMX("MRGDT")
 Q:ABMX("MRGDT")=+Y
 S ABMX("MRGDF")=+Y
 I $P(@(ABMP("GL")_"0)"),U,8)=ABMX("MRGDF") D
 .S DIE=$P(ABMP("GL"),",",1)_","
 .S DA=$P(ABMP("GL"),",",2)
 .S DR=".08///`"_ABMX("MRGDT")
 .D ^DIE
 S %X=ABMP("GL")_"13,"_ABMX("MRGDF")_","
 S %Y=ABMP("GL")_"13,"_ABMX("MRGDT")_","
 D %XY^%RCR
 S $P(@(ABMP("GL")_"13,"_ABMX("MRGDT")_",0)"),U)=ABMX("MRGDT")
 S $P(@(ABMP("GL")_"13,0)"),U,3)=ABMX("MRGDT"),$P(^(0),U,4)=$P(^(0),U,4)+1 I ABMP("GL")["ABMDBILL",$P(^(0),U,2)="9002274.3013P" S $P(^(0),U,2)="9002274.4013P"
 S DIK=ABMP("GL")_"13,"
 S DA(1)=$P(ABMP("GL"),",",2)
 S DA=ABMX("MRGDF")
 D ^DIK
 S DA=ABMX("MRGDT")
 D IX1^DIK
 S Y=ABMX("MRGDT")
 I $D(ABM("X")),ABM("X")=ABMX("MRGDF") S ABM("X")=ABMX("MRGDT")
 Q
NAME ; entry point for name
 I ABMCK[""""!(ABMCK'?1U.AP)!(ABMCK'[",")!(ABMCK?.E1","." ")!(ABMCK?.E1","." "1",".E)!($L(ABMCK,",")>3)!($L(ABMCK,".")>3)!($L(ABMCK,"-")>6)!($L(ABMCK,"(")>2)!($L(ABMCK,")")>2)!($L(ABMCK)>30)!($L(ABMCK)<3)!(ABMCK?.E1", ".E) K ABMCK Q
 F L=1:0 S L=$F(ABMCK," ",L) Q:L=0  S:$E(ABMCK,L-2)?1P!($E(ABMCK,L)?1P)!(L>$L(ABMCK)) ABMCK=$E(ABMCK,1,L-2)_$E(ABMCK,L,99),L=L-1
 S ABMNAMX=ABMCK
 F ABMII=$L(ABMNAMX):-1:1 S:"/:;'*()_+=&%$#@![]{}|\?<>~"""[$E(ABMNAMX,ABMII) ABMNAMX=$E(ABMNAMX,1,ABMII-1)_$E(ABMNAMX,ABMII+1,245)
 I ABMNAMX'=ABMCK K ABMCK
 I $D(ABMCK) S ABMCK=$$UP^XLFSTR(ABMCK)
 K ABMNAMX,ABMII
 Q
