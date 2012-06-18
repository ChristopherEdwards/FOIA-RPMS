AMHLEMD ; IHS/CMI/LAB - PART 7 OF AMHS -- SUMMARY PRODUCTION COMPONENTS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
GETMEDS(DFN,Y,Z,SIGT) ;EP - return array of meds for patient P
 NEW A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,%
 K ^TMP($J,"AMHSAOM"),^TMP("AMHSMEDS",$J)
 I '$G(DFN) Q
 I '$D(^DPT(DFN)) Q  ;not a valid patient
 I '$G(Y) S Y=""
 I '$G(Z) S Z=""
 ;store dates
 I Y S Y=9999999-Y
 E  S Y=9999999
 I Z S Z=9999999-Z
 E  S Z=9999999
OTH ;gather up all others by date range in components, get last of each
 NEW I S I=0 F  S I=$O(^AUPNVMED("AA",DFN,I)) Q:I=""!(I>Y)  D
 .S X=0 F  S X=$O(^AUPNVMED("AA",DFN,I,X)) Q:X=""  D
 ..I $D(^TMP($J,"AMHSAOM",$P(^AUPNVMED(X,0),U))) Q
 ..S ^TMP($J,"AMHSAOM",$P(^AUPNVMED(X,0),U))=X
 ..S ^TMP($J,"AMHSAOM","DATE ORDER",I,$P(^AUPNVMED(X,0),U))=X
 ..Q
 .Q
REORDER ;
 ;reorder by NDC or by name
 ;NEW I,N,O,S,A S (C,I)=0 F  S I=$O(^TMP($J,"AMHSAOM",I)) Q:I'=+I  S C=C+1,N=$$VAL^XBDIQ1(50,I,25),O="ZZZ-"_$$VAL^XBDIQ1(50,I,.01) S S=$S(N]"":N,1:O),A(S,C)=^TMP($J,"AMHSAOM",I)
 ;NEW AMHSX,AMHSC,I,N S AMHSX=0,I="A" F  S AMHSX=$O(A(AMHSX)) Q:AMHSX=""  S AMHSC=0 F  S AMHSC=$O(A(AMHSX,AMHSC)) Q:AMHSC'=+AMHSC  S N=A(AMHSX,AMHSC) D SETARRAY
 NEW AMHSC,AMHSX,I,N S I="A" S AMHSX=0 F  S AMHSX=$O(^TMP($J,"AMHSAOM","DATE ORDER",AMHSX)) Q:AMHSX=""  D
 .S AMHSC=0 F  S AMHSC=$O(^TMP($J,"AMHSAOM","DATE ORDER",AMHSX,AMHSC)) Q:AMHSC=""  S N=^TMP($J,"AMHSAOM","DATE ORDER",AMHSX,AMHSC) D SETARRAY
 K ^TMP("AMHSMEDS",$J,"A",0)
 K ^TMP($J,"AMHSAOM")
 Q
SETARRAY ;DISPLAY MEDICATION
 S %=^AUPNVMED(N,0)
 I +%,'$D(^PSDRUG(+%,0)) Q  ;drug deleted
 ;d = external value of date, t=internal value of date
 S V=$P(%,U,3) I V S T=$P($P(^AUPNVSIT(V,0),U),"."),D=$$FMTE^XLFDT(T,"2D")
 I 'V S (D,T)="<???>"
 S E=$P(%,U,8),Q=$P(%,U,6),G=$P(%,U,5)
 S K=$S($P(N,U,4)="":$P(^PSDRUG(+%,0),U,1),1:$P(N,U,4))
 I E S E="--  D/C "_$$FMTE^XLFDT(E,"2D")
 D SIG S G=Z
 D SITE I S]"" S G=G_"  ["_S_"]"
 S X="",$E(X,5)=K,$E(X,40)="# "_$S(Q:Q,1:"?"),$E(X,58)=D D S(X)
 S X="     Sig: "_G D S(X)
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
 I $D(^AUPNVSIT($P(%,U,3),21))#2 S S=$P(^(21),U)
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
 I '$D(^TMP("AMHSMEDS",$J,I,0)) S ^TMP("AMHSMEDS",$J,I,0)=0
 S %=$P(^TMP("AMHSMEDS",$J,I,0),U)+1,$P(^TMP("AMHSMEDS",$J,I,0),U)=%
 S ^TMP("AMHSMEDS",$J,I,%)=X
 Q
