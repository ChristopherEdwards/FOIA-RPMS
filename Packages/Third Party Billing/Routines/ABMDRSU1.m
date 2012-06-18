ABMDRSU1 ; IHS/ASDST/DMJ - Summarized Claim Display ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
VAR S U="^" K ABM
START ;
 S ABM("80E")="==============================================================================="
 S ABM("80D")="-------------------------------------------------------------------------------"
 K ABMP("QUIT")
 D DFN
 Q
DFN ;
 S ABM("ERR")=0
 Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),0))
 S ABM("PDFN")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,1),ABM("LOC")=$P(^(0),U,3),ABM("VD")=$P(^(0),U,2),ABM("CLN")=$P(^(0),U,6)
 S:ABM("LOC")="" ABM("LOC")=DUZ(2)
 I ABM("CLN")]"",$D(^DIC(40.7,ABM("CLN"),0)) S ABM("CLN")=$P(^(0),U,1)
 S ABM("PN")=$P(^DPT(ABM("PDFN"),0),U)
 S ABM("VD")=$$SDT^ABMDUTL(ABM("VD"))
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),$P(^(6),U,3)]"" S Y=$P(^(6),U,3),ABM("DD")=$$SDT^ABMDUTL(Y)
 E  S ABM("DD")=""
 I 'ABMP("PG") D HEAD1
 I $Y>(IOSL-10) D HEAD Q:$D(ABMP("QUIT"))
 D HD
 ;
VST S ABM("VTYPE")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,7)
 S ABM("VTYPE")=$S(ABM("VTYPE")="H":"HOME HLTH",ABM("VTYPE")="I":"INPATIENT",ABM("VTYPE")="D":"DENTAL",ABM("VTYPE")="S":"O/P SURGERY",1:"OUTPATIENT")
 W !!?5,"Visit",?14,"Discharge" ;,?32,"Visit",?72,"Visit"
 W !?6,"Date",?16,"Date",?26,"Location",?48,"Clinic",?68,"Type"
 W !?4 F I=1:1:75 W "-"
 W !?3,ABM("VD"),?14,ABM("DD"),?26,$P(^AUTTLOC(ABM("LOC"),0),U,2),?48,$E(ABM("CLN"),1,14),?68,$E(ABM("VTYPE"),1,10)
 ;
 D ^ABMDRSU2
 Q
 ;
HD ;EP to print mid header
 S ABM("HRN")="no HRN here",ABM("SSN")="    none"
 S (ABM("DOB"),Y)=$P(^DPT(ABM("PDFN"),0),U,3) I ABM("DOB")]"" X ^DD("DD") S ABM("DOB")=Y
 I $D(^AUPNPAT(ABM("PDFN"),41,ABM("LOC"),0)) S ABM("HRN")=$P(^AUPNPAT(ABM("PDFN"),41,ABM("LOC"),0),U,2)
 S ABM("SSN")=$P(^DPT(ABM("PDFN"),0),U,9) I ABM("SSN")]"" S ABM("SSN")=$E(ABM("SSN"),1,3)_"-"_$E(ABM("SSN"),4,5)_"-"_$E(ABM("SSN"),6,9)
 W !,ABM("PN")
 I '$D(ABM("CONT")) W "  (",ABM("HRN"),")",?38,ABMP("CDFN"),?50,ABM("DOB"),?66,ABM("SSN")
 E  W "   (continued from previous page)"
 K ABM("CONT")
 Q
HEAD ;EP to print header
 I 'ABMP("PG") G HEAD1
 I $E(IOST)="C",'$D(IO("S")) W ! K DIR,%P S DIR(0)="EO" D ^DIR K DIR I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)) S ABMP("QUIT")="" Q
HEAD1 ;
 W $$EN^ABMVDF("IOF") S ABMP("PG")=ABMP("PG")+1
 I $E(IOST)="P" W !
 W ?6,"  ",$$SDT^ABMDUTL(DT)
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),?(64-$L(ABMP("PG"))),"Page: ",ABMP("PG"),"  "
 I $D(ABMP("HEAD2")) S ABM("LENG")=$L(ABMP("HEAD2")) W !?6,?((80-ABM("LENG"))/2),ABMP("HEAD2"),?70,"  "
 I $D(ABMP("HEAD3")) S ABM("LENG")=$L(ABMP("HEAD3")) W !?6,?((80-ABM("LENG"))/2),ABMP("HEAD3"),?70,"  ",!
 W !,"Patient Name  (HRN)",?37,"CLM #",?48,"Date of Birth",?70,"SSN"
 W !,ABM("80E")
 Q
