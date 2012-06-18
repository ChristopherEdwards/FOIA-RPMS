BDMD019 ; IHS/CMI/LAB - 2010 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3**;JUN 14, 2007
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2010 Audit. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BDMD019",XBNS="",XBRX="XIT^BDMD019"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP - called by gui
 ;D HOME^%ZIS
 K BDMQUIT
GUICHK ;EP
 NEW A,BDMX,I,Y,Z,J,BDMY,BDMT
 K A
 S BDMYR=$O(^BDMTAXS("B",2010,0))
 S BDMT=0 F  S BDMT=$O(^BDMTAXS(BDMYR,11,BDMT)) Q:BDMT'=+BDMT  D
 .S BDMY=$G(^BDMTAXS(BDMYR,11,BDMT,0))
 .S BDMTN=$P(BDMY,U,1)
 .S BDMFILE=$P(BDMY,U,2)
 .S BDMTYPE=$P(^DIC($P(BDMY,U,2),0),U)
 .S Y=BDMTYPE_" taxonomy "
 .I BDMFILE'=60 D
 ..I '$D(^ATXAX("B",BDMTN)) S A(BDMTN)=Y_"^is Missing" Q
 ..S I=$O(^ATXAX("B",BDMTN,0))
 ..I '$D(^ATXAX(I,21,"B")) S A(BDMTN)=Y_"^has no entries "
 .I BDMFILE=60 D
 ..I '$D(^ATXLAB("B",BDMTN)) S A(BDMTN)=Y_"^is Missing " Q
 ..S I=$O(^ATXLAB("B",BDMTN,0))
 ..I '$D(^ATXLAB(I,21,"B")) S A(BDMTN)=Y_"^has no entries "
 ..;check for panels and warn
 ..I '$P(^ATXLAB(I,0),U,11) D
 ...S BDMY=0 F  S BDMY=$O(^ATXLAB(I,21,"B",BDMY)) Q:BDMY'=+BDMY  D
 ....I $O(^LAB(60,BDMY,2,0)) S A(BDMTN)=Y_"^contains a panel test: "_$P(^LAB(60,BDMY,0),U)_" and should not."
 I '$D(A) W !,"All taxonomies are present.",! K A,BDMX,BDMT,BDMY,Y,I,Z D DONE Q
 W !!,"In order for the 2010 DM AUDIT Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BDMX="" F  S BDMX=$O(A(BDMX)) Q:BDMX=""!($D(BDMQUIT))  D
 .;I $Y>(IOSL-2) D PAGE Q:$D(BDMQUIT)
 .W !,$P(A(BDMX),U)," [",BDMX,"] ",$P(A(BDMX),U,2)
 .Q
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
BANNER ;EP - banner for 2010 audit menu
 S BDMTEXT="TEXTD",BDM("VERSION")="2.0"
 F BDMJ=1:1 S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) Q:BDMX="QUIT"!(BDMX="")  S BDMLINE=BDMJ
PRINT D ^XBCLS W:$D(IOF) @IOF
 F BDMJ=1:1:BDMLINE S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) W !?80-$L(BDMX)\2,BDMX K BDMX
 W !?80-(8+$L(BDM("VERSION")))/2,"Version ",BDM("VERSION")
  G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BDM("SITE")=$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),"^") W !!?80-$L(BDM("SITE"))\2,BDM("SITE")
 D XIT
 Q
TEXTD ;EP
 ;;****************************************
 ;;**     DIABETES MANAGEMENT SYSTEM     **
 ;;**   2010 Diabetes Audit Report Menu  **
 ;;****************************************
 ;;QUIT
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT="" Q
 Q
BMIEPI(H,W) ;EP ;
 NEW %
 I H="" Q ""
 I W="" Q ""
 I 'H Q ""
 S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 Q %
