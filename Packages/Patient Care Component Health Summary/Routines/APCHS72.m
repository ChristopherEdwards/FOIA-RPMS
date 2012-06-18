APCHS72 ; IHS/CMI/LAB - PART 7 OF APCHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;2.0;IHS PCC SUITE;**2,5**;MAY 14, 2009
 ;
 ;
MEDS ;EP - called from component -  <SETUP>
 ;Q:'$D(^AUPNVMED("AC",APCHSPAT))
 X APCHSCKP Q:$D(APCHSQIT)  I 'APCHSNPG W ! X APCHSBRK
 ; <BUILD>
 S Z="",Y=$S(+$P(^APCHSCTL(APCHSTYP,1,APCHSEGT,0),U,4):$P(^APCHSCTL(APCHSTYP,1,APCHSEGT,0),U,4),1:"")
 I Y?1N.N!(Y?1N.N1"D") S Y=+Y
 I Y?1N.N1"M" S Y=+Y*30
 I Y?1N.N1"Y" S Y=Y*365
 D GETMEDS(APCHSPAT,Y,Z,$$VALI^XBDIQ1(9001015,APCHSTYP,3.5))
 D DISPLAY
 ;hold meds
 D HOLDDSP^APCHS7
 Q:$D(APCHSQIT)
 ;now display MED refusals
 S APCHST="MEDICATION",APCHSFN=50 D DISPREF^APCHS3C
 D MEDRU^APCHS7
 K APCHST,APCHSFN
MEDX ;
 K ^TMP($J,"APCHSAOM"),^TMP($J,"APCHSBCM"),^TMP("APCHSMEDS",$J)
 K APCHSX
 K X1,X2,X,Y
 Q
 ;
DISPLAY ;
 I $D(^TMP("APCHSMEDS",$J,"C")) W ?4,"LAST OF EACH CHRONIC MEDICATION (no limit on days)",?57,"Last fill date",!! D
 .S APCHSX=0 F  S APCHSX=$O(^TMP("APCHSMEDS",$J,"C",APCHSX)) Q:APCHSX'=+APCHSX!($D(APCHSQIT))  X APCHSCKP Q:$D(APCHSQIT)  W ^TMP("APCHSMEDS",$J,"C",APCHSX),!
 I $D(^TMP("APCHSMEDS",$J,"A")) W !?4,"LAST OF EACH OTHER MEDICATION "_APCHSEGL_"",?57,"Last fill date",!! D
 .S APCHSX=0 F  S APCHSX=$O(^TMP("APCHSMEDS",$J,"A",APCHSX)) Q:APCHSX'=+APCHSX!($D(APCHSQIT))  X APCHSCKP Q:$D(APCHSQIT)  W ^TMP("APCHSMEDS",$J,"A",APCHSX),!
 Q
GETMEDS(DFN,Y,Z,SIGT) ;PEP - return array of meds for patient P
 ;optionally Y is defined as the max # of days back the acute meds
 ;to be included
 ;optionally Z is the max # of days of chronic meds to be included
 ;the array will contain all chronic meds (listed first and ordered
 ;by NDC class
 ;and then all acute meds listed in NDC class order
 ;the array is ^TMP("APCHSMEDS",$J,"C" - chronic
 ;and ^TMP("APCHSMEDS",$J,"A" - other (non-chronic)
 NEW A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,%
 K ^TMP($J,"APCHSAOM"),^TMP($J,"APCHSBCM"),^TMP("APCHSMEDS",$J)
 I '$G(DFN) Q
 I '$D(^DPT(DFN)) Q  ;not a valid patient
 I '$G(Y) S Y=""
 I '$G(Z) S Z=""
 ;store dates
 I Y S Y="-"_Y S Y=9999999-$$FMADD^XLFDT(DT,Y)
 E  S Y=9999999
 I Z S Z="-"_Z S Z=9999999-$$FMADD^XLFDT(DT,Z)
 E  S Z=9999999
 ;gather up all chronic meds ever, store last of each 1
 NEW I
 S I=0 F  S I=$O(^AUPNVMED("AA",DFN,I)) Q:I=""!(I>Z)  D
 .NEW X S X=0 F  S X=$O(^AUPNVMED("AA",DFN,I,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVMED(X,0))
 ..I $D(^TMP($J,"APCHSBCM",$P(^AUPNVMED(X,0),U))) Q
 ..Q:'$$CHRONIC(X)  ;not marked as chronic in prescription file
 ..S ^TMP($J,"APCHSBCM",$P(^AUPNVMED(X,0),U))=X
 ..Q
 .Q
OTH ;gather up all others by date range in components, get last of each
 NEW I S I=0 F  S I=$O(^AUPNVMED("AA",DFN,I)) Q:I=""!(I>Y)  D
 .S X=0 F  S X=$O(^AUPNVMED("AA",DFN,I,X)) Q:X=""  D
 ..Q:'$D(^AUPNVMED(X,0))
 ..I $D(^TMP($J,"APCHSAOM",$P(^AUPNVMED(X,0),U))) Q
 ..Q:$$CHRONIC(X)
 ..S ^TMP($J,"APCHSAOM",$P(^AUPNVMED(X,0),U))=X
 ..Q
 .Q
 ;NOW MERGE IN NON VA MEDS FROM PS(55
NONVA ; S DFN=APCHSPAT,PSOACT=1 D ^PSOHCSUM
 ;quit if chronic
 S X=0 F  S X=$O(^PS(55,APCHSPAT,"NVA",X)) Q:X'=+X  D
 .I $P($G(^PS(55,APCHSPAT,"NVA",X,999999911)),U,1),$D(^AUPNVMED($P(^PS(55,APCHSPAT,"NVA",X,999999911),U,1),0)) Q
 .;S L=$P(^PS(55,APCHSPAT,"NVA",X,0),U,9)
 .;:'L
 .S L=$P($P($G(^PS(55,APCHSPAT,"NVA",X,0)),U,10),".")
 .S L=9999999-L
 .Q:L>APCHSDLM
 .S D=$P(^PS(55,APCHSPAT,"NVA",X,0),U,2)  ;DRUG
 .I D="" S D="NO DRUG IEN"
 .S N=$S(D:$P(^PSDRUG(D,0),U,1),1:$P(^PS(50.7,$P(^PS(55,APCHSPAT,"NVA",X,0),U,1),0),U,1))  ;NAME
 .S ^TMP($J,"APCHSAOM",$S(D:D,1:N))=U_$P(^PS(55,APCHSPAT,"NVA",X,0),U,6)_U_N_U_$P(^PS(55,APCHSPAT,"NVA",X,0),U,4)_" "_$P(^PS(55,APCHSPAT,"NVA",X,0),U,5)_U_$P(^PS(55,APCHSPAT,"NVA",X,0),U,7)_U_(9999999-L)_U_$S(D:$P(^PSDRUG(D,0),U,1),1:N)
REORDER ;
 ;reorder by NDC or by name
 NEW I,N,O,S,M S (C,I)=0 F  S I=$O(^TMP($J,"APCHSBCM",I)) Q:I'=+I  S C=C+1,N=$$VAL^XBDIQ1(50,I,25),O="ZZZ-"_$$VAL^XBDIQ1(50,I,.01) S S=$S(N]"":N,1:O),M(S,C)=^TMP($J,"APCHSBCM",I)
 NEW I,N,O,S,A S (C,I)=0 F  S I=$O(^TMP($J,"APCHSAOM",I)) Q:I=""  S C=C+1,N=$S(I:$$VAL^XBDIQ1(50,I,25),1:""),O="ZZZ-"_$S(I:$$VAL^XBDIQ1(50,I,.01),1:I) S S=$S(N]"":N,1:O),A(S,C)=^TMP($J,"APCHSAOM",I)
 NEW APCHSX,APCHSC,I,N S APCHSX=0,I="C" F  S APCHSX=$O(M(APCHSX)) Q:APCHSX=""  S APCHSC=0 F  S APCHSC=$O(M(APCHSX,APCHSC)) Q:APCHSC'=+APCHSC  S N=M(APCHSX,APCHSC) D SETARRAY
 NEW APCHSX,APCHSC,I,N S APCHSX=0,I="A" F  S APCHSX=$O(A(APCHSX)) Q:APCHSX=""  S APCHSC=0 F  S APCHSC=$O(A(APCHSX,APCHSC)) Q:APCHSC'=+APCHSC  S N=A(APCHSX,APCHSC) D SETARRAY
 K ^TMP("APCHSMEDS",$J,"C",0),^TMP("APCHSMEDS",$J,"A",0)
 K ^TMP($J,"APCHSBCM"),^TMP($J,"APCHSAOM")
 Q
CHRONIC(N) ;EP
 I '$G(N) Q ""
 I '$D(^AUPNVMED(N)) Q ""
 NEW X,Y,P
 S P=$P(^AUPNVMED(N,0),U,2)
 S X=$S($D(^PSRX("APCC",N)):$O(^(N,0)),1:0)
 S Y=$S(+X:$D(^PS(55,P,"P","CP",X)),1:0)
 I 'Y Q ""
 Q 1
SETARRAY ;DISPLAY MEDICATION
 I 'N D SETNVA Q
 S %=^AUPNVMED(N,0)
 ;d = external value of date, t=internal value of date
 S V=$P(%,U,3) I V S T=$P($P(^AUPNVSIT(V,0),U),"."),D=$$FMTE^XLFDT(T,"2D")
 I 'V S (D,T)="<???>"
 S E=$P(%,U,8),Q=$P(%,U,6),G=$P(%,U,5),T=$P(%,U,7)_" days"
 S K=$S($P(N,U,4)="":$P(^PSDRUG(+%,0),U,1),1:$P(N,U,4))
 S B="" I E S B="--  D/C "_$$FMTE^XLFDT(E,"2D")
 S APCHORTS=$P($G(^AUPNVMED(N,11)),U)
 I APCHORTS["RETURNED TO STOCK",E S B="--RTS "_$$FMTE^XLFDT(E,"2D")
 D SIG S G=$$LOW^XLFSTR(Z)
 D SITE ;I S]"" S G=G_"  ["_S_"]"
 S X="",$E(X,2)=K,X=X_" "_G_" "_" # "_$S(Q:Q,1:"?")_"  "_T_" "_D_" "_B D S(X)
 I S]"" S X="",$E(X,5)="Dispensed at: "_S D S(X)
 Q
SETNVA ;
 S D=$P(N,U,6)
 I 'D S D="<???>"
 I D S D=$$FMTE^XLFDT(D,"2D")
 S E=$P(N,U,5)
 S G=$P(N,U,4)
 S K=$P(N,U,7)
 S B="" I E S B="-- D/C"_$$FMTE^XLFDT(E,"2D")
 D SIG S G=$$LOW^XLFSTR(Z)
 S X="",$E(X,2)=K,X=X_" "_G_" "_D_" "_B D S(X)
 S X="",$E(X,5)="Dispensed at: (EHR Outside Medication)" D S(X)
 Q
 ;
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 I $G(SIGT)="S" S Z=G Q
 NEW P S Z="" F P=1:1:$L(G," ") S X=$P(G," ",P) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(G," ",P-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S Z=Z_X_" "
 Q
 ;
SITE ;DETERMINE IF OUTSIDE LOCATION INFO PRESENT
 S S=""
 I $D(^AUPNVSIT(V,21))#2 S S=$P(^(21),U) Q
 Q:$P(^AUPNVSIT(V,0),U,6)=""
 I $P(^AUPNVSIT(V,0),U,6)'=DUZ(2) S S=$E($P(^DIC(4,$P(^AUPNVSIT(V,0),U,6),0),U),1,30)
 Q
S(Y,F,C,T) ;set up array
 NEW X
 I '$G(F) S F=0
 I '$G(T) S T=0
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 I '$D(^TMP("APCHSMEDS",$J,I,0)) S ^TMP("APCHSMEDS",$J,I,0)=0
 S %=$P(^TMP("APCHSMEDS",$J,I,0),U)+1,$P(^TMP("APCHSMEDS",$J,I,0),U)=%
 S ^TMP("APCHSMEDS",$J,I,%)=X
 Q
