BDMP819 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2008 Pre-Diabetes Audit. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BDMP819",XBNS="",XBRX="XIT^BDMP819"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 W:$D(IOF) @IOF
 K BDMQUIT
 W !,"Checking for Taxonomies to support the 2008 Pre-Diabetes Audit...",!
 NEW A,BDMX,I,Y,Z,J,BDMY,B,C
 K A,B
 S C=0
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BDMX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BDMX=""  D
 .I '$D(^ATXAX("B",BDMX)) S A(BDMX)=Y_"^is Missing" Q
 .S I=$O(^ATXAX("B",BDMX,0))
 .I '$D(^ATXAX(I,21,"B")) S A(BDMX)=Y_"^has no entries "
 S T="LAB" F J=1:1 S Z=$T(@T+J),BDMX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BDMX=""  D
 .I '$D(^ATXLAB("B",BDMX)) S A(BDMX)=Y_"^is Missing " Q
 .S I=$O(^ATXLAB("B",BDMX,0))
 .I '$D(^ATXLAB(I,21,"B")) S A(BDMX)=Y_"^has no entries " Q
 .I '$P(^ATXLAB(I,0),U,11) D
 ..;check for panels and warn
 ..S BDMY=0 F  S BDMY=$O(^ATXLAB(I,21,"B",BDMY)) Q:BDMY'=+BDMY  D
 ...I $O(^LAB(60,BDMY,2,0)) S C=C+1,B(BDMX,C)=Y_"^contains a panel test: "_$P(^LAB(60,BDMY,0),U)_" and should not."
 I $Y>(IOSL-2) D PAGE
 I '$D(A),'$D(B) W !,"All taxonomies are present.",! K A,BDMX,Y,I,Z Q
 W !!,"In order for the 2008 Diabetes Audit to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing, have",!,"no entries or contain a panel test and should not:",!
 S BDMX="" F  S BDMX=$O(A(BDMX)) Q:BDMX=""!($D(BDMQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BDMQUIT)
 .W !,$P(A(BDMX),U)," [",BDMX,"] ",$P(A(BDMX),U,2)
 .Q
 G:$D(BDMQUIT) DONE
 S BDMX="" F  S BDMX=$O(B(BDMX)) Q:BDMX=""!($D(BDMQUIT))  D
 .S BDMY=0 F  S BDMY=$O(B(BDMX,BDMY)) Q:BDMY'=+BDMY!($D(BDMQUIT))  D
 ..W !,$P(B(BDMX,BDMY),U)," [",BDMX,"] ",$P(B(BDMX,BDMY),U,2)
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
XIT ;EP
 K BDM,BDMX,BDMQUIT,BDMLINE,BDMJ,BDMX,BDMTEXT,BDM
 K X,Y,J
 Q
LASTHF(P,C,BDATE,EDATE,F) ;EP - get last factor in category C for patient P
 I '$G(P) Q ""
 I $G(C)="" Q ""
 I $G(F)="" S F=""
 S C=$O(^AUTTHF("B",C,0)) ;ien of category passed
 I '$G(C) Q ""
 NEW H,D,O S H=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNVHF("AA",P,H))
 .  S D="" F  S D=$O(^AUPNVHF("AA",P,H,D)) Q:D'=+D  D
 .. Q:(9999999-D)>EDATE  ;after time frame
 .. Q:(9999999-D)<BDATE  ;before time frame
 .. S O(D)=$O(^AUPNVHF("AA",P,H,D,""))
 .  Q
 S D=$O(O(0))
 I D="" Q D
 I F="F" Q $P(^AUTTHF($P(^AUPNVHF(O(D),0),U),0),U)
 ;
 Q 1
 ;;
BANNER ;EP - banner for 2003 audit menu
 S BDMTEXT="TEXTD",BDM("VERSION")="3.0"
 F BDMJ=1:1 S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) Q:BDMX="QUIT"!(BDMX="")  S BDMLINE=BDMJ
PRINT D ^XBCLS W:$D(IOF) @IOF
 F BDMJ=1:1:BDMLINE S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) W !?80-$L(BDMX)\2,BDMX K BDMX
 W !?80-(8+$L(BDM("VERSION")))/2,"Version ",BDM("VERSION")
  G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BDM("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BDM("SITE"))\2,BDM("SITE")
 D XIT
 Q
TEXTD ;EP
 ;;****************************************
 ;;**      Diabetes Management System    **
 ;;**   2008 Diabetes Audit Report Menu  **
 ;;****************************************
 ;;QUIT
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT="" Q
 Q
BMIEPI(H,W) ;EP ;
 NEW %
 I H="" Q ""
 I W="" Q ""
 S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 Q %
TAXS ;
 ;;SURVEILLANCE DIABETES;;Diabetes Diagnoses Codes
 ;;SURVEILLANCE HYPERTENSION;;Hypertension Diagnoses Codes
 ;;DM AUDIT DIET EDUC TOPICS;;Diabetes Diet Education Topics
 ;;DM AUDIT EXERCISE EDUC TOPICS;;Diabetes Excercise Education Topics
 ;;DM AUDIT SMOKING CESS EDUC;;Smoking Cess Education Topics
 ;;DM AUDIT TOBACCO HLTH FACTORS;;Tobacco Health Factors
 ;;DM AUDIT PROBLEM SMOKING DXS;;Smoking related diagnoses for Problem List
 ;;DM AUDIT PROBLEM HTN DIAGNOSES;;Hypertension Diagnoses
 ;;DM AUDIT PROBLEM DIABETES DX;;Diabetes Diagnoses
 ;;DM AUDIT SMOKING RELATED DXS;;Smoking related diagnoses for POVs
 ;;DM AUDIT CESSATION HLTH FACTOR;;Smoking Cessation Health Factors
 ;;DM AUDIT SULFONYLUREA DRUGS;;Sulfonylurea Drug Taxonomy
 ;;DM AUDIT METFORMIN DRUGS;;Metformin Drug Taxonomy
 ;;DM AUDIT ACARBOSE DRUGS;;Acarbose Drug Taxonomy
 ;;DM AUDIT LIPID LOWERING DRUGS;;Lipid Lowering Drug Taxonomy
 ;;DM AUDIT STATIN DRUGS;;Statin Drug Taxonomy
 ;;DM AUDIT GLITAZONE DRUGS;;Glitzaone Drug Taxonomy
 ;;DM AUDIT ACE INHIBITORS;;ACE Inhibitor Drug Taxonomy
 ;;DM AUDIT ASPIRIN DRUGS;;Aspirin Drug Taxonomy
 ;;DM AUDIT ANTI-PLATELET DRUGS;;Anti-Platelet Drug Taxonomy
 ;;
LAB ;
 ;;DM AUDIT FASTING GLUCOSE TESTS;;Fasting Glucose Tests Taxonomy
 ;;DM AUDIT CHOLESTEROL TAX;;Cholesterol Lab Taxonomy
 ;;DM AUDIT LDL CHOLESTEROL TAX;;LDL Cholesterol Lab Taxonomy
 ;;DM AUDIT HDL TAX;;HDL Lab Taxonomy
 ;;DM AUDIT TRIGLYCERIDE TAX;;Triglyceride Lab Taxonomy
 ;;DM AUDIT 75GM 2HR GLUCOSE;;75 gm 2hr glucose test taxonomy
 ;;
