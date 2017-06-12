APCHPWH3 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;  
 ;;2.0;IHS PCC SUITE;**2,5,7,11**;MAY 14, 2009;Build 58
 ;
 ;
MEDS ;EP - medications component
 ;get all meds in the past year +30 days
 NEW APCHMEDS,APCHMED,X,M,I,N,D,APCHKEEP,APCHGRP,APCHRXN,APCHRXO,APCHRX0,APCHSREF,APCHSTAT,C,APCHN,APCHI,APCHD,APCHC
 NEW X,M,D,N,C,Z,P,I
 ;
 S APCHMEDS=""
 D GETMEDS^APCHSMU1(APCHSDFN,$$FMADD^XLFDT(DT,-395),DT,,,,,.APCHMEDS)
 ;store each drug by inverse date
 K APCHMED
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X  D
 .S M=$P(APCHMEDS(X),U,4)
 .S D=$P(^AUPNVMED(M,0),U,1)
 .S N=$S($P(^AUPNVMED(M,0),U,4)]"":$P(^AUPNVMED(M,0),U,4),1:$P(^PSDRUG(D,0),U,1))
 .S APCHMED(N,D,(9999999-$P(APCHMEDS(X),U,1)))=APCHMEDS(X)
 ;now get rid of all except the latest one
 K APCHKEEP
 S N="" F  S N=$O(APCHMED(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHMED(N,D)) Q:D=""  D
 ..Q:$D(APCHKEEP(N,D))
 ..S X=$O(APCHMED(N,D,0))
 ..S APCHKEEP(N,D,X)=APCHMED(N,D,X)
 ;
 ;now put into groups
 K APCHGRP
 S N="" F  S N=$O(APCHKEEP(N)) Q:N=""  D
 .S D=0 F  S D=$O(APCHKEEP(N,D)) Q:D=""  D
 ..S X=0 F  S X=$O(APCHKEEP(N,D,X)) Q:X'=+X  D
 ...;get status, if expired or discontinued put in group 2, 3 all others go in group 1
 ...;skip 1,2,4,10,13,15
 ...S M=$P(APCHKEEP(N,D,X),U,4)
 ...S Z=""
 ...S APCHRXN=$O(^PSRX("APCC",M,0))
 ...I APCHRXN D  Q
 ....S APCHSTAT=$P($G(^PSRX(APCHRXN,"STA")),U,1)
 ....Q:APCHSTAT=""
 ....Q:APCHSTAT=1
 ....Q:APCHSTAT=2
 ....Q:APCHSTAT=4
 ....Q:APCHSTAT=10
 ....Q:APCHSTAT=13
 ....Q:APCHSTAT=15
 ....S C=$S(+APCHRXN:$D(^PS(55,APCHSDFN,"P","CP",APCHRXN)),1:0)
 ....S I=$S(C:120,1:14)
 ....I APCHSTAT=11 D  Q
 .....Q:$$FMDIFF^XLFDT(DT,$P($G(^PSRX(APCHRXN,2)),U,6))>I
 .....S APCHGRP(2,N,D,X)=APCHKEEP(N,D,X),$P(APCHGRP(2,N,D,X),U,10)=$P($G(^PSRX(APCHRXN,2)),U,6) S Z=2 D SET Q
 ....S C=$S(+APCHRXN:$D(^PS(55,APCHSDFN,"P","CP",APCHRXN)),1:0)
 ....S I=31
 ....I APCHSTAT=12!(APCHSTAT=14)&($$FMDIFF^XLFDT(DT,$P(^AUPNVMED(M,0),U,8))<I) S APCHGRP(3,N,D,X)=APCHKEEP(N,D,X),$P(APCHGRP(3,N,D,X),U,12)=$P(^AUPNVMED(M,0),U,8) S Z=3 D SET Q
 ....I APCHSTAT=12!(APCHSTAT=14) Q  ;only past 30/120 days
 ....S APCHGRP(1,N,D,X)=APCHKEEP(N,D,X) S Z=1 D SET
 ....I APCHSTAT=3 S $P(APCHGRP(1,N,D,X),U,11)=$P($G(^PSRX(APCHRXN,"H")),U,1)
 ...S APCHGRP(1,N,D,X)=APCHKEEP(N,D,X) S Z=1 D SET1
 ...Q
 ..Q
 .Q
 S D=DT
 F  S D=$O(^PS(55,APCHSDFN,"P","A",D)) Q:D'=+D  D
 .S N=0 F  S N=$O(^PS(55,APCHSDFN,"P","A",D,N)) Q:'N  D
 ..Q:'$$HOLD(N)
 ..S X=$$VAL^XBDIQ1(52,N,6)
 ..S APCHGRP(1,X,$P(^PSRX(N,0),U,6),D)=D_U_$$VAL^XBDIQ1(52,N,6)_U_$$VAL^XBDIQ1(52,N,6)
 ..S $P(APCHGRP(1,X,$P(^PSRX(N,0),U,6),D),U,11)=$$EXTSET^XBFUNC(52,99,$P($G(^PSRX(N,"H")),U,1))
 ..S $P(APCHGRP(1,X,$P(^PSRX(N,0),U,6),D),U,13)=N
 ;get pending order
 ;S P=APCHSDFN_";DPT("
 ;S D=0 F  S D=$O(^OR(100,"AC",P,D)) Q:D'=+D  D
 ;.S I=0 F  S I=$O(^OR(100,"AC",P,D,I)) Q:I'=+I  D
 ;..S G=$$VALI^XBDIQ1(100,I,12)
 ;..Q:'G
 ;..Q:$P($G(^DIC(9.4,G,0)),U,2)'="PSO"
 ;..Q:$$VAL^XBDIQ1(100,I,5)'="PENDING"
 ;..S X=0 F  S X=$O(^OR(100,I,.1,X)) Q:X'=+X  D
 ;...S N=$P(^OR(100,I,.1,X,0),U) I N]"" S N=$P($G(^OR(101.43,N,0)),U)
 ;...I N S APCHGRP(1.5,N,99,(9999999-$P(D,".")))=(9999999-$P(D,"."))_U_N
 ;display them now, this was a pain
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("MEDICATIONS - This is a list of medications and other items you are")
 D S^APCHPWH1("taking including non-prescription medications, herbal, dietary, and")
 D S^APCHPWH1("traditional supplements.  Please let us know if this list is not ")
 D S^APCHPWH1("complete.")
 I '$D(APCHGRP) D S^APCHPWH1("No medications are on file.  Please tell us if there are any that we missed.",1) Q
 S APCHC=0
 S APCHN=""
 F  S APCHN=$O(APCHGRP(1,APCHN)) Q:APCHN=""  D
 .S APCHI=0 F  S APCHI=$O(APCHGRP(1,APCHN,APCHI)) Q:APCHI'=+APCHI  D
 ..S APCHD=0 F  S APCHD=$O(APCHGRP(1,APCHN,APCHI,APCHD)) Q:APCHD'=+APCHD  D
 ...S Z=APCHGRP(1,APCHN,APCHI,APCHD)
 ...S APCHC=APCHC+1
 ...S X="",$E(X,1)=APCHC_".",$E(X,7)=APCHN,$E(X,47)=$S($P(Z,U,6)]"":"Rx#: "_$P(Z,U,6),1:""),$E(X,61)=$S($P(Z,U,7)]"":"Refills left: "_$P(Z,U,7),1:"") D S^APCHPWH1(X,1)
 ...;attempt to wrap directions 58 characters
 ...K ^UTILITY($J,"W") S X=$P(Z,U,8),DIWL=0,DIWR=58 D ^DIWP
 ...S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ...I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ...K ^UTILITY($J,"W")
 ...I $P(Z,U,11)]"" D S^APCHPWH1("      Ordered but not dispensed: "_$P(Z,U,11))
 I $D(APCHGRP(2)) D
 .D S^APCHPWH1("==========",1)
 .D S^APCHPWH1("Your prescription for these medications has expired.  You need to talk")
 .D S^APCHPWH1("with your prescriber to get a new prescription for these medications.")
 .D S^APCHPWH1(" ")
 .S APCHN="" F  S APCHN=$O(APCHGRP(2,APCHN)) Q:APCHN=""  D
 ..S APCHI=0 F  S APCHI=$O(APCHGRP(2,APCHN,APCHI)) Q:APCHI'=+APCHI  D
 ...S APCHD=0 F  S APCHD=$O(APCHGRP(2,APCHN,APCHI,APCHD)) Q:APCHD'=+APCHD  D
 ....S Z=APCHGRP(2,APCHN,APCHI,APCHD)
 ....S APCHC=APCHC+1
 ....S X="",$E(X,1)=APCHC_".",$E(X,7)=APCHN,$E(X,47)=$S($P(Z,U,6)]"":"Rx#: "_$P(Z,U,6),1:""),$E(X,61)=$S($P(Z,U,7)]"":"Refills left: "_$P(Z,U,7),1:"") D S^APCHPWH1(X,1)
 ....;S X="",$E(X,7)="Directions: "_$P(Z,U,8) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W") S X=$P(Z,U,8),DIWL=0,DIWR=58 D ^DIWP
 ....S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ....I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W")
 ....S X="",$E(X,7)="Last date filled: "_$$FMTE^XLFDT($P(Z,U))_"     Expired on: "_$$FMTE^XLFDT($P(Z,U,10)) D S^APCHPWH1(X)
 I $D(APCHGRP(3)) D
 .D S^APCHPWH1("==========",1)
 .D S^APCHPWH1("These medications have been stopped.  You should not take these")
 .D S^APCHPWH1("medications.  Talk to your pharmacist about ways to safely get rid")
 .D S^APCHPWH1("of these medications if you have them at home.")
 .D S^APCHPWH1(" ")
 .S APCHN="" F  S APCHN=$O(APCHGRP(3,APCHN)) Q:APCHN=""  D
 ..S APCHI=0 F  S APCHI=$O(APCHGRP(3,APCHN,APCHI)) Q:APCHI'=+APCHI  D
 ...S APCHD=0 F  S APCHD=$O(APCHGRP(3,APCHN,APCHI,APCHD)) Q:APCHD'=+APCHD  D
 ....S Z=APCHGRP(3,APCHN,APCHI,APCHD)
 ....S APCHC=APCHC+1
 ....S X="",$E(X,1)=APCHC_".",$E(X,7)=APCHN,$E(X,47)=$S($P(Z,U,6)]"":"Rx#: "_$P(Z,U,6),1:""),$E(X,61)=$S($P(Z,U,7)]"":"Refills left: "_$P(Z,U,7),1:"") D S^APCHPWH1(X,1)
 ....;S X="",$E(X,7)="Directions: "_$P(Z,U,8) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W") S X=$P(Z,U,8),DIWL=0,DIWR=58 D ^DIWP
 ....S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 ....I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ....K ^UTILITY($J,"W")
 ....S X="",$E(X,7)="Discontinued on: "_$$FMTE^XLFDT($P(Z,U,12)) D S^APCHPWH1(X)
 Q
 ;
SET1 ;
 S $P(APCHGRP(Z,N,D,X),U,6)=$P($G(^AUPNVMED(M,11)),U,2)
 S $P(APCHGRP(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 S $P(APCHGRP(Z,N,D,X),U,7)=$P($G(^AUPNVMED(M,11)),U,7)
 Q
SET ;
 S $P(APCHGRP(Z,N,D,X),U,6)=$P(^PSRX(APCHRXN,0),U)
 S $P(APCHGRP(Z,N,D,X),U,8)=$P(^AUPNVMED(M,0),U,5)
 S APCHSRX=APCHRXN,APCHSREF=0 D REF^APCHS7O S $P(APCHGRP(Z,N,D,X),U,7)=APCHSREF
 Q
HOLD(S) ;EP - is this prescription on hold?
 NEW X
 S X=$P($G(^PSRX(S,"STA")),U,1)
 I X=3 Q 1
 ;I X=5 Q 1
 ;I X=16 Q 1
 ;version 6
 S X=$P($G(^PSRX(S,0)),U,15)
 I X=3 Q 1
 ;I X=5 Q 1
 ;I X=16 Q 1
 Q 0
 ;
 ;
HIV ;EP - HIV component
 I $$AGE^AUPNPAT(APCHSDFN,DT)<13 Q
 I $$AGE^AUPNPAT(APCHSDFN,DT)>64 Q
 Q:$$HIVDX(DFN,DT)
 NEW APCHHIVT,APCH5Y,B
 S B=$$DOB^AUPNPAT(APCHSDFN)
 S APCH5Y=($E(DT,1,3)-5)_$E(DT,4,7)
 S APCHHIVT=$$HIVTEST(APCHSDFN,APCH5Y,DT)
 I APCHHIVT Q  ;had a test
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("SCREEN FOR HUMAN IMMUNODEFICIENCY VIRUS (HIV)")
 D S^APCHPWH1("HIV is a virus that causes a serious infection.  HIV infection")
 D S^APCHPWH1("can cause sickness and death.  A person can have HIV for many years")
 D S^APCHPWH1("and not know it.  Everyone should be tested for HIV when they are")
 D S^APCHPWH1("between 13 and 64 years old.  According to our records, you have not")
 D S^APCHPWH1("had an HIV test.  Talk to your provider about how you can get an")
 D S^APCHPWH1("HIV test.")
 Q
 ;
HIVDX(P,EDATE) ; any HIV dx ever or problem list HIV dx
 NEW APCHG
 S Y="APCHG("
 S BDATE=$$FMADD^XLFDT(EDATE,-365)
 S X=P_"^LAST DX [BGP HIV/AIDS DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(APCHG(1)) Q 1
 S T=$O(^ATXAX("B","BGP HIV/AIDS DXS",0))
 S X=0,G="" F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,8)>EDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXAPI(Y,T,9)
 .S G=1
 .Q
 I G Q G
 I $T(ATAG^BQITDUTL)]"" S X=$$ATAG^BQITDUTL(P,"HIV") I $P(X,U),($P(X,U,2)="P"!($P(X,U,2)="A")) Q 1
 Q ""
 ;
LAB(P,T,LT,LN) ;EP
 I '$G(LT) S LT=""
 S LN=$G(LN)
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G)  D
 ...I $D(^ATXLAB(T,21,"B",X)) S G=Y Q
 ...I LN]"",$$VAL^XBDIQ1(9000010.09,Y,.01)=LN S G=Y Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=Y
 ...Q
 ..Q
 .Q
 I 'G Q ""
 Q 1
 ;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
HIVTEST(P,BDATE,EDATE) ;
 NEW APCHC,APCHT,T,X,APCHLT,E,D,B,L,J,G,APCHT1,APCHA
 NEW BD,ED,Y,D,V
 K APCHA
 S APCHC=0
 S T=$O(^ATXAX("B","BGP CPT HIV TESTS",0))
 I T D
 .;go through visits in a date range for this patient, check cpts
 .S ED=(9999999-EDATE),BD=9999999-BDATE,G=0
 .F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 ..S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ...Q:'$D(^AUPNVSIT(V,0))
 ...Q:'$D(^AUPNVCPT("AD",V))
 ...S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ....I $$ICD^ATXAPI($P(^AUPNVCPT(X,0),U),T,1) S G=1
 ....Q
 ...Q
 ..Q
 I G Q G
 S T=$O(^ATXAX("B","BGP HIV TEST LOINC CODES",0))
 S APCHLT=$O(^ATXLAB("B","BGP HIV TEST TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE,G=0 S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(G)  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(G)  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...S V=$P(^AUPNVLAB(X,0),U,3)
 ...I APCHLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHLT,21,"B",$P(^AUPNVLAB(X,0),U))),'$D(APCHA((9999999-D))) S G=1 Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...I '$D(APCHA((9999999-D))) S G=1
 ...Q
 Q G
 ;
GOALS ;EP
 NEW APCHEDUC,X,N,APCHGOAL,APCHX,APCHY,APCHZ
 D EDUC(APCHSDFN,.APCHEDUC)
 D GOAL(APCHSDFN,.APCHGOAL)
 D SUBHEAD^APCHPWHU
 I '$D(APCHEDUC),'$D(APCHGOAL) D  Q
 .D S^APCHPWH1("My Healthcare Goals - No goals recorded")
 D S^APCHPWH1("My Healthcare Goals")
 S N="" F  S N=$O(APCHEDUC(N)) Q:N=""  D
 .S X=""
 .S Y="",Y=$P(N,"-") I Y]"" S Y=$O(^AUTTEDMT("B",Y,0)) I Y S Y=$P($G(^AUTTEDMT(Y,0)),U)
 .S T=$S(Y]"":Y_"-"_$P(N,"-",2),1:N),$E(X,2)=T D S^APCHPWH1(X)
 .S X="",$E(X,4)="Goal: "_$P(APCHEDUC(N),U,4) D S^APCHPWH1(X)
 I $D(APCHEDUC) D S^APCHPWH1(" ")
 Q:'$D(APCHGOAL)
 S APCHX=0 F  S APCHX=$O(APCHGOAL(APCHX)) Q:APCHX'=+APCHX  D
 .K ^UTILITY($J,"W") S X=$P($G(^AUPNGOAL(APCHX,11)),U,1),DIWL=0,DIWR=60 D ^DIWP
 .S X="",X="Goal Name: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"This goal has not been named.",1:" ") D S^APCHPWH1(X)
 .I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,12)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 .K ^UTILITY($J,"W")
 .S X="",$E(X,2)="Start: "_$$FMTE^XLFDT($P(^AUPNGOAL(APCHX,0),U,9))_"   Follow up: "_$$FMTE^XLFDT($P(^AUPNGOAL(APCHX,0),U,10)) D S^APCHPWH1(X)
 .S X="" S APCHY=0 F  S APCHY=$O(^AUPNGOAL(APCHX,10,APCHY)) Q:APCHY'=+APCHY  S:X]"" X=X_", " S X=X_$P(^APCDTPGT($P(^AUPNGOAL(APCHX,10,APCHY,0),U,1),0),U,1)
 .K ^UTILITY($J,"W") S DIWL=0,DIWR=65 D ^DIWP
 .S X="",X="  Type: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:" ",1:" ") D S^APCHPWH1(X)
 .I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,9)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 .K ^UTILITY($J,"W")
 .;
 .S APCHY=0 F  S APCHY=$O(^AUPNGOAL(APCHX,21,APCHY)) Q:APCHY'=+APCHY  D
 ..S APCHZ=0 F  S APCHZ=$O(^AUPNGOAL(APCHX,21,APCHY,11,APCHZ)) Q:APCHZ'=+APCHZ  D
 ...S X="",$E(X,2)="Step#"_$P(^AUPNGOAL(APCHX,21,APCHY,11,APCHZ,0),U,1)_":  "_$P($G(^AUPNGOAL(APCHX,21,APCHY,11,APCHZ,11)),U,1)
 ...K ^UTILITY($J,"W") S DIWL=0,DIWR=60 D ^DIWP
 ...S X="",X=$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"This STEP has not been defined.",1:" ") D S^APCHPWH1(X)
 ...I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,10)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ...K ^UTILITY($J,"W")
 ...S X="  Start: "_$$FMTE^XLFDT($P(^AUPNGOAL(APCHX,21,APCHY,11,APCHZ,0),U,5))_"   Follow up: "_$$FMTE^XLFDT($P(^AUPNGOAL(APCHX,21,APCHY,11,APCHZ,0),U,6)) D S^APCHPWH1(X)
 .Q
 Q
EDUC(P,DATA) ;EP pass back array of all educ topics
 ;any topic that begins with ASM or 493
 K DATA
 I '$G(P) Q
 NEW APCHE,X,E,%,G,A,N,D,I
 K ^TMP($J,"A")
 S A="^TMP($J,""A"","
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT($$FMADD^XLFDT(DT,-365))_"-"_$$FMTE^XLFDT(DT) S E=$$START1^APCLDF(X,A)
 I '$D(^TMP($J,"A",1)) Q
 S %=0 F  S %=$O(^TMP($J,"A",%)) Q:%'=+%  D
 .S D=$P(^TMP($J,"A",%),U,1)
 .S I=+$P(^TMP($J,"A",%),U,4)
 .S N=$P(^AUPNVPED(I,0),U)
 .Q:'N
 .I $P(^AUPNVPED(I,0),U,14)="" Q  ;only those with goal stuff
 .S APCHE($P(^TMP($J,"A",%),U,2),9999999-D)=$$VAL^XBDIQ1(9000010.16,+$P(^TMP($J,"A",%),U,4),.06)_U_$$VAL^XBDIQ1(9000010.16,+$P(^TMP($J,"A",%),U,4),.13)_U_$$VAL^XBDIQ1(9000010.16,+$P(^TMP($J,"A",%),U,4),.14)
 S N="" F  S N=$O(APCHE(N)) Q:N=""  S DATA(N)=(9999999-$O(APCHE(N,0)))_U_APCHE(N,$O(APCHE(N,0)))
 K APCHE,^TMP($J,"A")
 Q
 ;
GOAL(P,DATA) ;EP - pass back array in chronological order by start date and ien
 K DATA
 I '$G(P) Q
 NEW APCHE,X,E,%,G,A,N,D,I
 S X=0 F  S X=$O(^AUPNGOAL("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNGOAL(X,0))
 .Q:$P(^AUPNGOAL(X,0),U,1)="N"  ;not set excluded
 .Q:$P(^AUPNGOAL(X,0),U,11)="ME"  ;MET
 .Q:$P(^AUPNGOAL(X,0),U,11)="D"  ;deleted
 .Q:$P(^AUPNGOAL(X,0),U,11)="S"  ;changed
 .S DATA(X)=""
 Q
