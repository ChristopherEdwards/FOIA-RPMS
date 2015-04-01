BDMUTL ; IHS/CMI/LAB - Area Database Utility Routine ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**5,8**;JUN 14, 2007;Build 53
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
 ;
ICD(VAL,TAXNM,TYP) ;EP -- check to see if value is in taxonomy in ^TMP("BDMTMP",$J,Taxonomy Name
 ;add 3rd param with pass type
 I $G(BDMJOB)=""!($G(BDMBTH)="") Q $$ICD^ATXCHK(VAL,$O(^ATXAX("B",TAXNM,0)),TYP)
 I '$D(^XTMP("BDMTAX",BDMJOB,BDMBTH,TAXNM)) Q $$ICD^ATXCHK(VAL,$O(^ATXAX("B",TAXNM,0)),TYP)
 I $D(^XTMP("BDMTAX",BDMJOB,BDMBTH,TAXNM,VAL)) Q 1
 Q 0
 ;
UNFOLDTX(YEAR) ;EP -- unfold all taxes for dm audit into ^TMP("BDMTMP",$J,Taxonomy Name
 ;lets go through all the taxonomies needed here and put them in above location
 ;need to check DMS Taxonomies Used option to determine
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 I '$D(^ICDS(0)) Q  ;only in icd10 environment
 N BDMYR,BDMDA,BDMTAX,BDMFL,BDMTAXI,BDMVAL,BDMTYP,BDMTGT
 S BDMYR=$O(^BDMTAXS("B",YEAR,0))
 Q:'BDMYR
 S BDMDA=0 F  S BDMDA=$O(^BDMTAXS(BDMYR,11,BDMDA)) Q:'BDMDA  D
 . S BDMTAX=$P($G(^BDMTAXS(BDMYR,11,BDMDA,0)),U)
 . S BDMFL=$P($G(^BDMTAXS(BDMYR,11,BDMDA,0)),U,2)
 . S BDMTYP=$S(BDMFL=60:"L",1:"")
 . S BDMTAXI=$O(^ATXAX("B",BDMTAX,0))
 . I BDMTYP="L" D
 .. S BDMTAXI=$O(^ATXLAB("B",BDMTAX,0))
 . S BDMTGT="^XTMP("_"""BDMTAX"""_","_BDMJOB_","_""""_BDMBTH_""""_","_""""_BDMTAX_""""_")"
 . ;D BLDTAX^ATXAPI(BDMTAX,BDMTGT,BDMTAXI,BDMTYP)
 . D BLDTAX^BDMTAPI(BDMTAX,BDMTGT,BDMTAXI,BDMTYP)
 Q
 ;
 ;
ICDDX(C,D,S,I) ;PEP - CHECK FOR ICD10
 I $T(ICDDX^ICDEX)]"" Q $$ICDDX^ICDEX(C,$G(D),,$G(I))
 Q $$ICDDX^ICDCODE(C,$G(D),$G(I))
 ;
ICDOP(C,D,S,I) ;PEP - CHECK FOR ICD10
 I $T(ICDOP^ICDEX)]"" Q $$ICDOP^ICDEX(C,$G(D),,$G(I))
 Q $$ICDOP^ICDCODE(C,$G(D),$G(I))
 ;
VSTD(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTD^ICDEX)]"" Q $$VSTD^ICDEX(C,$G(D))
 Q $$VSTD^ICDCODE(C,$G(D))
 ;
VSTP(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTP^ICDEX)]"" Q $$VSTP^ICDEX(C,$G(D))
 Q $$VSTP^ICDCODE(C,$G(D))
 ;
ICDD(C,A,D) ;EP - CHECK FOR ICD10
 I $T(ICDD^ICDEX)]"" Q $$ICDD^ICDEX(C,A,$G(D))
 Q $$ICDD^ICDCODE(C,A,$G(D))
CODEN(C,F) ;EP CHECK/GET CODE
 I $T(CODEN^ICDEX)]"" Q $$CODEN^ICDEX(C,F)
 Q $$CODEN^ICDCODE(C,F)
