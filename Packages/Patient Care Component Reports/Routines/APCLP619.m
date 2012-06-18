APCLP619 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2006 Pre-Diabetes Audit. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^APCLP619",XBNS="",XBRX="XIT^APCLP619"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP
 W:$D(IOF) @IOF
 K APCLQUIT
 W !,"Checking for Taxonomies to support the 2006 Pre-Diabetes Audit...",!
 NEW A,APCLX,I,Y,Z,J
 K A
 S T="TAXS" F J=1:1 S Z=$T(@T+J),APCLX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:APCLX=""  D
 .I '$D(^ATXAX("B",APCLX)) S A(APCLX)=Y_"^is Missing" Q
 .S I=$O(^ATXAX("B",APCLX,0))
 .I '$D(^ATXAX(I,21,"B")) S A(APCLX)=Y_"^has no entries "
 S T="LAB" F J=1:1 S Z=$T(@T+J),APCLX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:APCLX=""  D
 .I '$D(^ATXLAB("B",APCLX)) S A(APCLX)=Y_"^is Missing " Q
 .S I=$O(^ATXLAB("B",APCLX,0))
 .I '$D(^ATXLAB(I,21,"B")) S A(APCLX)=Y_"^has no entries "
 I $Y>(IOSL-2) D PAGE
 I '$D(A) W !,"All taxonomies are present.",! K A,APCLX,Y,I,Z Q
 W !!,"In order for the 2006 Pre-Diabetes Audit to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S APCLX="" F  S APCLX=$O(A(APCLX)) Q:APCLX=""!($D(APCLQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(APCLQUIT)
 .W !,$P(A(APCLX),U)," [",APCLX,"] ",$P(A(APCLX),U,2)
 .Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
XIT ;EP
 K APCL,APCLX,APCLQUIT,APCLLINE,APCLJ,APCLX,APCLTEXT,APCL
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
 S APCLTEXT="TEXTD",APCL("VERSION")="3.0"
 F APCLJ=1:1 S APCLX=$T(@APCLTEXT+APCLJ),APCLX=$P(APCLX,";;",2) Q:APCLX="QUIT"!(APCLX="")  S APCLLINE=APCLJ
PRINT D ^XBCLS W:$D(IOF) @IOF
 F APCLJ=1:1:APCLLINE S APCLX=$T(@APCLTEXT+APCLJ),APCLX=$P(APCLX,";;",2) W !?80-$L(APCLX)\2,APCLX K APCLX
 W !?80-(8+$L(APCL("VERSION")))/2,"Version ",APCL("VERSION")
  G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S APCL("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(APCL("SITE"))\2,APCL("SITE")
 D XIT
 Q
TEXTD ;EP
 ;;****************************************
 ;;**       PCC Management Reports       **
 ;;**   2006 Diabetes Audit Report Menu  **
 ;;****************************************
 ;;QUIT
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
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
