BUDCRP6W ; IHS/CMI/LAB - UDS REPORT PROCESSOR 01 Dec 2015 4:03 PM ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
 ;
 ;
ROTACONT(P,C,ED) ;EP - ANALPHYLAXIS/IMMUNE DEF
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)["Immune" S G=D_U_$P(^BICONT(R,0),U,1)
 .I $P(^BICONT(R,0),U,1)="Neomycin Allergy" S G=D_U_"Neomycin Allergy"
 Q G
ROTA(P,BDATE,EDATE) ;EP
 ;check for a contraindication from DOB to 2nd birthday
 NEW X,G,N,BUDG,BUDX,BUDC,BUDOPV,BUDAPOV,C,BD,ED,V,Y,E
 ;now check for evidence of disease
 S X=$$LASTDXI^BUDCUTL1(P,"008.61",$$DOB^AUPNPAT(P),EDATE)
 I X]"" Q "1^ROTAVIRUS Evidence: "_$P(X,U,2)_" on "_$$DATE^BUDCUTL1($P(X,U,3))
 S X=$$LASTDX^BUDCUTL1(P,"BUD ROTA CONTRA DXS",$$DOB^AUPNPAT(P),EDATE)
 I X]"" Q "1^ROTAVIRUS Contraindication: "_$P(X,U,2)_" on "_$$DATE^BUDCUTL1($P(X,U,3))
 I $$PLCODE^BUDCDU(P,"008.61") Q "1^ROTAVIRUS Evidence: 008.61 on Problem List"
 S X=$$PLTAX^BUDCDU(P,"BUD ROTA CONTRA DXS") I X Q "1^ROTAVIRUS Contraindication: "_$P(X,U,2)_" on Problem List"
 F BUDZ=119,74,116,122 S X=$$ROTACONT(P,BUDZ,EDATE) Q:X]""
 I X]"" Q "1^ROTAVIRUS Contraindication IM package: "_$$DATE^BUDCUTL1($P(X,U))_" "_$P(X,U,2)
 S G=""
 S X=0 F  S X=$O(^GMR(120.8,"B",P,X)) Q:X'=+X!(G)  D
 .;Q:$P($P($G(^GMR(120.8,X,0)),U,4),".")>EDATE  ;entered after 2ND birthday
 .S N=$P($G(^GMR(120.8,X,0)),U,2),N=$$UP^XLFSTR(N)
 .Q:'$$ANAREACT^BUDCRP6C(X)  ;quit if anaphylactic is not a reaction/sign/symptom
 .I N["NEOMYCIN" S G="1^ROTAVIRUS Contraindiction: "_$$DATE^BUDCUTL1($P($P($G(^GMR(120.8,X,0)),U,4),"."))_"  Allergy Tracking: "_N
 I G]"" Q G
 ;now get imms and see if there are 3
 K BUDC,BUDG,BUDX
 K BUDOPV,BUDAPOV
 S BUDOPV2=0
ROTAIMM ;get all immunizations
 S C="119"
 K BUDX D GETIMMS^BUDCRP6C(P,BDATE,EDATE,C,.BUDX)
 ;now get cpt codes
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDOPV(X)=BUDX(X),BUDAPOV(X)=BUDX(X)
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90681 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,".")))
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90681 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,".")))
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S (X,Y)="",C=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDOPV(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BUDOPV=0,X=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S BUDOPV=BUDOPV+1
 I BUDOPV>1 S Y="1^ROTA 2: total #: "_BUDOPV,X="" F  S X=$O(BUDOPV(X)) Q:X'=+X  S Y=Y_"  "_BUDOPV(X)
 I BUDOPV>1 Q Y
 I BUDOPV=1 S BUDOPV2=2
 ;NOW TRY FOR 3 DOSE
 K BUDC,BUDG,BUDX
 K BUDOPV,BUDAPOV
ROT3IMM ;get all immunizations
 S C="74^116^122"
 K BUDX D GETIMMS^BUDCRP6C(P,BDATE,EDATE,C,.BUDX)
 ;now get cpt codes
 S X=0 F  S X=$O(BUDX(X)) Q:X'=+X  S BUDOPV(X)=BUDX(X),BUDAPOV(X)=BUDX(X)
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90680 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,".")))
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90680 D
 ....S BUDOPV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="CPT: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,".")))
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ...S Y=$$VAL^XBDIQ1(9000010.07,X,.01) I Y="008.61" D
 ....S BUDOPV(9999999-$P(ED,"."))="POV: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,"."))),BUDAPOV(9999999-$P(ED,"."))="POV: "_Y_" on "_$$DATE^BUDCUTL1((9999999-$P(ED,".")))
 S (X,Y)="",C=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BUDOPV(X) Q
 .S Y=X
 ;now count them and see if there are 3 of them
 S BUDOPV=0,X=0 F  S X=$O(BUDOPV(X)) Q:X'=+X  S BUDOPV=BUDOPV+1
 I BUDOPV>2 S Y="1^ROTA: total #: "_BUDOPV,X="" F  S X=$O(BUDOPV(X)) Q:X'=+X  S Y=Y_"  "_BUDOPV(X)
 I BUDOPV>2 Q Y
 S BUDOPV=BUDOPV+BUDOPV2
 I BUDOPV>2 S Y="1^ROTA: total #: "_BUDOPV,X="" F  S X=$O(BUDOPV(X)) Q:X'=+X  S Y=Y_"  "_BUDOPV(X)
 I BUDOPV>2 Q Y
 Q "0^"_(3-BUDOPV)_" ROTAVIRUS"
PRGA ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"Prenatal Patients by Age (Table 6B)",!
 D GENI^BUDCRP6I
 D PAUSE^BUDCRP6I
 W !!,"This report provides a list of patients by age that had pregnancy-related"
 W !,"visits during the past 20 months, with at least one pregnancy-related visit"
 W !,"during the report period."
 W !
 Q
PRGAL ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D PRGAH Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 S BUDAB="Less than 15 Years" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 15-19" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 20-24" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 25-44" D PRGAL1
 I BUDQUIT G PRGALX
 S BUDAB="Ages 45 and Over" D PRGAL1
 I BUDQUIT G PRGALX
 I BUDROT="P",$Y>(IOSL-3) D PRGAH G:BUDQUIT PRGALX
 I BUDROT="P" W !!,"TOTAL PREGNANT PATIENTS: ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PREGNANT PATIENTS: "_BUDTOT)
PRGALX ;
 Q
PRGAL1 ;
 I BUDROT="P" I $Y>(IOSL-7) D PRGAH Q:BUDQUIT
 I BUDROT="P" W !,BUDAB,!
 I BUDROT="D" D S(),S(BUDAB),S()
 S BUDSTOT=0
 S BUDA=0 F  S BUDA=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA)) Q:BUDA'=+BUDA!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P" I $Y>(IOSL-3) D PRGAH Q:BUDQUIT
 ....I BUDROT="P" W !?2,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$$AGE^AUPNPAT(DFN,BUDCAD),!
 ....S BUDSTOT=BUDSTOT+1,BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"PRGA",BUDAB,BUDA,BUDNAME,BUDCOM,DFN)
 ....F BUDX=1:1 S BUDV=$P(BUDALL,U,BUDX) Q:BUDV=""!(BUDQUIT)  D
 .....I BUDROT="P" I $Y>(IOSL-3) D PRGAH Q:BUDQUIT
 .....I $E(BUDV)="P",BUDROT="P" W ?5,BUDV,! Q
 .....I $E(BUDV)="P",BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$$AGE^AUPNPAT(DFN,BUDCAD)_U_BUDV D S(X) Q
 .....S V=$P(BUDV,"|"),C=$P(BUDV,"|",2)
 .....I BUDROT="P" W ?5,$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),".")),?20,C,?33,$P(^AUPNVSIT(V,0),U,7),?41,$E($$CLINIC^APCLV(V,"E"),1,15),?60,$E($$VAL^XBDIQ1(9000010,V,.06),1,19),!
 .....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 ......S X=X_U_$$FMTE^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))_U_C_U_$P(^AUPNVSIT(V,0),U,7)_U_$$CLINIC^APCLV(V,"E")_U_$$VAL^XBDIQ1(9000010,V,.06) D S(X)
 I BUDROT="P" W !,"Sub-Total ",BUDAB,":  ",BUDSTOT,!
 I BUDROT="D" D S("Sub-Total "_BUDAB_":  "_BUDSTOT),S()
 Q
PRGAHD ;delimited header
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Sections A & B, Pregnant Patients")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("List of all patients with pregnancy-related visits during the past 20")
 D S("months, with at least one pregnancy-related visit during the report")
 D S("period, with age and visit information.  Displays community, age, and")
 D S("visit data, and codes.")
 D S("Age is calculated as of June 30.")
 D S()
 D S("PATIENT NAME^HRN^COMMUNITY^AGE^VISIT DATE^DX OR SVC CD^SVC CAT^CLINIC^LOCATION")
 Q
PRGAH ;
 I BUDROT="D" D PRGAHD Q
 G:'BUDGPG PRGAH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
PRGAH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Sections A & B, Pregnant Patients",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !,"List of all patients with pregnancy-related visits during the past 20"
 .W !,"months, with at least one pregnancy-related visit during the report"
 .W !,"period, with age and visit information.  Displays community, age, and"
 .W !,"visit data, and codes."
 .W !,"Age is calculated as of June 30."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"AGE"
 W !?5,"VISIT DATE",?20,"DX OR SVC CD",?33,"SVC CAT",?41,"CLINIC",?60,"LOCATION"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
 ;
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
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
