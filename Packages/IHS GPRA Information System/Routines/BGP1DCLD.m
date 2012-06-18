BGP1DCLD ; IHS/CMI/LAB - IHS gpra print ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
CPPL1 ;EP
 Q:$G(BGPAREAA)
 ;
 S BGPCNT=BGPCPLC,BGPPCNT=0
 I BGPCNT<11!(BGPLIST'="R") S BGPCNT=1 G GO
 I BGPCNT<100 S BGPCNT=BGPCNT\10 G GO
 S BGPCNT=10
GO ;
 S BGPQUIT="",BGPGPG=0,BGPH1P=1
 S X=" " D S(X,3,1)
 D HEADER
 S BGPY=$O(^BGPCTRL("B",2011,0))
 S BGPX=0 F  S BGPX=$O(^BGPCTRL(BGPY,28,BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 .S X=^BGPCTRL(BGPY,28,BGPX,0) D S(X,1,1)
 D H1
 S BGPH1P=0 S BGPCOM="",BGPCOUNT=0 F  S BGPCOM=$O(^XTMP("BGP18CPL",BGPJ,BGPH,"LIST",BGPCOM)) Q:BGPCOM=""  D CPL1
 S X="Total # of patients on list: "_$G(BGPPCNT) D S(X,1,1)
 Q
CPL1 ;EP
 S BGPSEX="" F  S BGPSEX=$O(^XTMP("BGP18CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX)) Q:BGPSEX=""  D CPL2
 Q
CPL2 ;
 S BGPAGE="" F  S BGPAGE=$O(^XTMP("BGP18CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE)) Q:BGPAGE=""  D
 .S DFN=0 F  S DFN=$O(^XTMP("BGP18CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE,DFN)) Q:DFN'=+DFN  S BGPCOUNT=BGPCOUNT+1 D PRINTL
 Q
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
PRINTL ;print one line
 Q:(BGPCOUNT#BGPCNT)
 S BGPPCNT=BGPPCNT+1
 S X=$E($P(^DPT(DFN,0),U),1,22) D S(X,1,1) S X=$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X,,2) S X=BGPCOM D S(X,,3) S X=BGPSEX D S(X,,4) S X=BGPAGE D S(X,,5)
 S W="",X=$P(^XTMP("BGP18CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE,DFN),"|||",1) F Y=1:1:12 I $P(X,"$$",Y)]"" S:W]"" W=W_"," S W=W_$P(X,"$$",Y)
 S Z="",X=$P(^XTMP("BGP18CPL",BGPJ,BGPH,"LIST",BGPCOM,BGPSEX,BGPAGE,DFN),"|||",2) F Y=1:1  Q:$P(X,"#",Y)=""  S:Z]"" Z=Z_", " S Z=Z_$P(X,"#",Y)
 D S(W,,6),S(Z,,7)
 S A=$$LAST^BGP1DCLP(DFN,BGPED) D S(A,,8)
 Q
 ;
HEADER ;EP
 S X="**** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****" D S(X,1,1)
 S X="***  IHS 2011 Comprehensive National GPRA Patient List ***" D S(X,1,1)
 S X="***  List of Patients Not Meeting a National GPRA measure ***" D S(X,1,1)
 S X=$$RPTVER^BGP1BAN D S(X,1,1)
 S X=$P(^DIC(4,DUZ(2),0),U) D S(X,1,1)
 S X="Report Period: "_$$FMTE^XLFDT(BGPBD)_" to "_$$FMTE^XLFDT(BGPED) D S(X,1,1)
 S X=$S(BGPLIST="A":"All Patients",BGPLIST="R":"Random Patient List",1:"Patient List by Provider: "_BGPLPROV) D S(X,1,1)
 S X=$TR($J("",80)," ","-") D S(X,1,1)
 Q
H1 ;
 S X=" " D S(X,1,1) S X="UP=User Pop; AC=Active Clinical; AD=Active Diabetic;" D S(X,1,1) S X="AAD=Active Adult Diabetic; PREG=Pregnant Female;" D S(X,1,1) S X="IMM=Active IMM Pkg Pt; IHD=Active Ischemic Heart Disease" D S(X,1,1)
 S X=" " D S(X,1,1)
 S X="PATIENT NAME" D S(X,1,1) S X="HRN" D S(X,,2) S X="COMMUNITY" D S(X,,3) S X="SEX" D S(X,,4) S X="AGE" D S(X,,5) S X="DENOMINATOR" D S(X,,6) S X="MEASURE NOT MET" D S(X,,7) S X="LST PRVDR" D S(X,,8)
 S X=$TR($J("",80)," ","-") D S(X,1,1)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
