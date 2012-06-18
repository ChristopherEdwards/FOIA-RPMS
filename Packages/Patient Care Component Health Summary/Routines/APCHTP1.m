APCHTP1 ; IHS/CMI/LAB - TP 1 ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
EP ;EP - CALLED FROM OPTION
 D EN
 Q
EOJ ;EP
 D EN^XBVK("APCH")
 Q
 ;; ;
EN ; -- main entry point for APCH TP DISPLAY
 D EN^VALM("APCH TP DISPLAY")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Best Practice Prompt Logic Display"
 Q
 ;
INIT ; -- init variables and list array
 K APCHDISP,APCHSEL,APCHHIGH,APCHLIST,APCHCSEL
 S APCHHIGH=0,X=0,N="" F  S N=$O(^APCHSURV("B",N)) Q:N=""  S X=0 F  S X=$O(^APCHSURV("B",N,X)) Q:X'=+X  I $P(^APCHSURV(X,0),U,3)'="D",$P(^APCHSURV(X,0),U,7)="T" S APCHHIGH=APCHHIGH+1,APCHSEL(APCHHIGH)=X
 S APCHCUT=((APCHHIGH/3)+1)\1
 ;S APCHCUT=(APCHHIGH/3)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(APCHSEL(I)) Q:I'=+I!($D(APCHDISP(I)))  D
 .S C=C+1,APCHLIST(C,0)=I_") "_$S($D(APCHCSEL(I)):"*",1:" ")_$E($P(^APCHSURV(APCHSEL(I),0),U),1,20) S APCHDISP(I)="",APCHLIST("IDX",C,C)=""
 .S J=I+APCHCUT I $D(APCHSEL(J)),'$D(APCHDISP(J)) S $E(APCHLIST(C,0),28)=J_") "_$S($D(APCHCSEL(J)):"*",1:" ")_$E($P(^APCHSURV(APCHSEL(J),0),U),1,20) S APCHDISP(J)=""
 .S K=J+APCHCUT I $D(APCHSEL(K)),'$D(APCHDISP(K)) S $E(APCHLIST(C,0),55)=K_") "_$S($D(APCHCSEL(K)):"*",1:" ")_$E($P(^APCHSURV(APCHSEL(K),0),U),1,20) S APCHDISP(K)=""
 K APCHDISP
 S VALMCNT=C
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT
 D HDR
 K DIR
 K X,Y,Z,I
 Q
 ;
ADD ;EP - add an item to the selected list - called from a protocol
 W ! S DIR(0)="LO^1:"_APCHHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S APCHANS=Y,APCHC="" F APCHI=1:1 S APCHC=$P(APCHANS,",",APCHI) Q:APCHC=""  S APCHCSEL(APCHC)=""
 D DISPLAY
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:APCHHIGH S APCHCSEL(X)=""
 D DISPLAY
 D BACK
 Q
 ;
DISPLAY ;gather in ^TMP and display
 K ^TMP("APCHTP1",$J)
 S ^TMP("APCHTP1",$J,0)=0
 S APCHC=0
 S APCHX=0 F  S APCHX=$O(APCHCSEL(APCHX)) Q:APCHX'=+APCHX  S APCHTP=APCHSEL(APCHX),Y="Best Practice Prompt:",$E(Y,24)=$P(^APCHSURV(APCHTP,0),U) S APCHC=APCHC+1 D S(Y,$S(APCHC=1:0,1:2)) D
 .S X="",X="Status:",$E(X,24)=$$VAL^XBDIQ1(9001018,APCHTP,.03) D S(X)
 .S X="Description:" D S(X,1)
 .S Y=0 F  S Y=$O(^APCHSURV(APCHTP,1,Y)) Q:Y'=+Y  S X="",$E(X,2)=^APCHSURV(APCHTP,1,Y,0) D S(X)
 .S X="Best Practice Prompt Text: " D S(X,1)
 .S Y=0 F  S Y=$O(^APCHSURV(APCHTP,12,Y)) Q:Y'=+Y  S X="",$E(X,2)=^APCHSURV(APCHTP,12,Y,0) D S(X)
 .S X="Currently Defined Criteria in Use at this Facility:" D S(X,1)
 .I '$O(^APCHSURV(APCHTP,11,0)) S X="<<< No Local Criteria defined >>>" D S(X)
 .S Y=0 F  S Y=$O(^APCHSURV(APCHTP,11,Y)) Q:Y'=+Y  D
 ..S Z="",$E(Z,5)="Sex:  "_$S($P(^APCHSURV(APCHTP,11,Y,0),U)="F":"FEMALE",$P(^APCHSURV(APCHTP,11,Y,0),U)="M":"MALE",$P(^APCHSURV(APCHTP,11,Y,0),U)="B":"BOTH",1:"")
 ..S J=0 F  S J=$O(^APCHSURV(APCHTP,11,Y,11,J)) Q:J'=+J  D
 ...S X=Z,$E(X,21)="Mininum Age: "_$P(^APCHSURV(APCHTP,11,Y,11,J,0),U),$E(X,40)="Maximum Age: "_$P(^APCHSURV(APCHTP,11,Y,11,J,0),U,2),$E(X,60)="Frequency: "_$P(^APCHSURV(APCHTP,11,Y,11,J,0),U,3) D S(X)
 ..Q
 .S X="Currently defined on the following summary types:" D S(X,1)
 .S J=0 F  S J=$O(^APCHSCTL(J)) Q:J'=+J  D
 ..S K=0 F  S K=$O(^APCHSCTL(J,5,K)) Q:K'=+K  I $P(^APCHSCTL(J,5,K,0),U,2)=APCHTP S X="",$E(X,15)=$P(^APCHSCTL(J,0),U) D S(X)
 .S X=$TR($J("",80)," ","*") D S(X,2)
 ;
 ;
 K ^TMP("APCHTP1",$J,0)
 D ARRAY^XBLM("^TMP(""APCHTP1"",$J,","BEST PRACTICE PROMPTS DESCRIPTIONS")
 Q
S(Y,F,C,T) ;set up array
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
 S %=$P(^TMP("APCHTP1",$J,0),U)+1,$P(^TMP("APCHTP1",$J,0),U)=%
 S ^TMP("APCHTP1",$J,%,0)=X
 Q
