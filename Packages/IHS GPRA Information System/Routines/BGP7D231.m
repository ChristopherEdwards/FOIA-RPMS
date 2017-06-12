BGP7D231 ; IHS/CMI/LAB - measure I2 23 Jun 2010 10:08 AM ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
WC(P,BDATE,EDATE) ;EP
 I 'P Q ""
 KILL %,BGPARRY,H,E
 S %=P_"^LAST MEAS WC;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"BGPARRY(") S H=$P($G(BGPARRY(1)),U,2)
 I H="" Q H
 I H["?" Q ""
 I $P(^DPT(P,0),U,2)="M",H>40 Q "WC="_H
 I $P(^DPT(P,0),U,2)="F",H>35 Q "WC="_H
 Q ""
TRIG(P,BDATE,EDATE) ;EP
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP TRIGLYCERIDE LOINC CODES",0))
 S BGPLT=$O(^ATXLAB("B","DM AUDIT TRIGLYCERIDE TAX",0))
 S R=""
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(R]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(R]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(R]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BGPLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BGPLT,21,"B",$P(^AUPNVLAB(X,0),U))) D  Q:R]""
 ....S V=$P(^AUPNVLAB(X,0),U,4) Q:V=""  Q:'V  Q:+V<150  S R="TRIG="_V
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S V=$P(^AUPNVLAB(X,0),U,4)
 ...Q:V=""  Q:V'=+V
 ...Q:+V<150
 ...S R="TRIG="_V
 ...Q
 Q R
 ;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
