BDMUTL ; IHS/CMI/LAB - Area Database Utility Routine ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**5**;JUN 14, 2007
 ;
GETIMMS(P,EDATE,C,BDMX) ;EP
 K BDMX
 NEW X,Y,I,Z,V
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVIMM(X,0))  ;happens
 .S Y=$P(^AUPNVIMM(X,0),U)
 .Q:'Y  ;happens too
 .S I=$P($G(^AUTTIMM(Y,0)),U,3)  ;get HL7/CVX code
 .F Z=1:1:$L(C,U) I I=$P(C,U,Z) S V=$P(^AUPNVIMM(X,0),U,3) I V S D=$P($P($G(^AUPNVSIT(V,0)),U),".") I D]"",D'>EDATE S BDMX(D)=Y
 .Q
 Q
IMMREF(P,IMM,BD,ED) ;EP
 NEW X,Y,G,D,R
 I 'IMM Q ""
 S (X,G)=0,Y=$O(^AUTTIMM("C",IMM,0))
 I 'Y Q ""
 F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .S G=G+1
 Q G
ANCONT(P,C,ED) ;EP - ANALPHYLAXIS CONTRAINDICATION
 NEW X
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G="2  No - Contraindication Anaphylaxis"
 Q G
DEMO(P,T) ;EP - called to exclude demo patients
 I $G(P)="" Q 0
 I $G(T)="" S T="I"
 I T="I" Q 0
 NEW R
 S R=""
 I T="E" D  Q R
 .I $P($G(^DPT(P,0)),U)["DEMO,PATIENT" S R=1 Q
 .NEW %
 .S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 .I '% S R=0 Q
 .I $D(^DIBT(%,1,P)) S R=1 Q
 I T="O" D  Q R
 .I $P($G(^DPT(P,0)),U)["DEMO,PATIENT" S R=0 Q
 .NEW %
 .S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 .I '% S R=1 Q
 .I $D(^DIBT(%,1,P)) S R=0 Q
 .S R=1 Q
 Q 0
 ;
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
 ;
DEMOCHK(R) ;EP - check demo pat
 NEW DIR,DA
 S R=-1
 S DIR(0)="S^I:Include ALL Patients;E:Exclude DEMO Patients;O:Include ONLY DEMO Patients",DIR("A")="Demo Patient Inclusion/Exclusion",DIR("B")="E"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S R=-1 Q
 S R=Y
 Q
