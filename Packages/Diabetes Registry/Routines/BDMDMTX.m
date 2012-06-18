BDMDMTX ; IHS/CMI/LAB - display audit logic ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;
EP ;EP - CALLED FROM OPTION
 ;select year
 S BDMYR=""
 W:$D(IOF) @IOF
 W !!,"Select the Audit Year",!!
 S DIC="^BDMDMTX(",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G EOJ
 S BDMYR=+Y
 D EN
 Q
EOJ ;EP
 I '$D(BDMGUI) D EN^XBVK("BDM")
 Q
 ;; ;
EN ; -- main entry point for BDM DM LOGIC DISPLAY
 D EN^VALM("BDM DM LOGIC DISPLAY")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="DM Logic Display"
 Q
 ;
INIT ; -- init variables and list array
 K BDMDISP,BDMSEL,BDMHIGH,BDMLIST,BDMCSEL
 S BDMO=$S($O(^BDMDMTX(BDMYR,11,"AO",0)):"AO",1:"B")
 S BDMHIGH=0,X=0,O=0 F  S O=$O(^BDMDMTX(BDMYR,11,BDMO,O)) Q:O'=+O  S X=$O(^BDMDMTX(BDMYR,11,BDMO,O,0)) S BDMHIGH=BDMHIGH+1,BDMSEL(BDMHIGH)=X
 S BDMCUT=((BDMHIGH/3)+1)\1
 ;S BDMCUT=(BDMHIGH/3)\1
 S (C,I)=0,J=1,K=1 F  S I=$O(BDMSEL(I)) Q:I'=+I!($D(BDMDISP(I)))  D
 .S C=C+1,BDMLIST(C,0)=I_") "_$S($D(BDMCSEL(I)):"*",1:" ")_$E($P(^BDMDMTX(BDMYR,11,BDMSEL(I),0),U),1,20) S BDMDISP(I)="",BDMLIST("IDX",C,C)=BDMSEL(I)
 .S J=I+BDMCUT I $D(BDMSEL(J)),'$D(BDMDISP(J)) S $E(BDMLIST(C,0),28)=J_") "_$S($D(BDMCSEL(J)):"*",1:" ")_$E($P(^BDMDMTX(BDMYR,11,BDMSEL(J),0),U),1,20) S BDMDISP(J)="",BDMLIST("IDX",J,J)=BDMSEL(J)
 .S K=J+BDMCUT I $D(BDMSEL(K)),'$D(BDMDISP(K)) S $E(BDMLIST(C,0),55)=K_") "_$S($D(BDMCSEL(K)):"*",1:" ")_$E($P(^BDMDMTX(BDMYR,11,BDMSEL(K),0),U),1,20) S BDMDISP(K)="",BDMLIST("IDX",K,K)=BDMSEL(K)
 K BDMDISP
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
 W ! S DIR(0)="LO^1:"_BDMHIGH,DIR("A")="Which item(s)" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y="" W !,"No items selected." G ADDX
 I $D(DIRUT) W !,"No items selected." G ADDX
 D FULL^VALM1 W:$D(IOF) @IOF
 S BDMANS=Y,BDMC="" F BDMI=1:1 S BDMC=$P(BDMANS,",",BDMI) Q:BDMC=""  S BDMCSEL(BDMC)=""
 D DISPLAY
ADDX ;
 D BACK
 Q
ADDALL ;
 F X=1:1:BDMHIGH S BDMCSEL(X)=""
 D DISPLAY
 D BACK
 Q
 ;
DISPLAY ;gather in ^TMP and display
 K ^TMP("BDMDMTX",$J)
 S ^TMP("BDMDMTX",$J,0)=0
 S BDMC=0
 S BDMX=0 F  S BDMX=$O(BDMCSEL(BDMX)) Q:BDMX'=+BDMX  S BDMY=BDMLIST("IDX",BDMX,BDMX),Y=$P(^BDMDMTX(BDMYR,11,BDMY,0),U) S BDMC=BDMC+1 D S(Y,$S(BDMC=1:0,1:2),1) D
 .S Y=0 F  S Y=$O(^BDMDMTX(BDMYR,11,BDMY,11,Y)) Q:Y'=+Y  S Z=^BDMDMTX(BDMYR,11,BDMY,11,Y,0) D S(Z)
 .Q
 K ^TMP("BDMDMTX",$J,0)
 D ARRAY^XBLM("^TMP(""BDMDMTX"",$J,","DM AUDIT LOGIC DESCRIPTIONS")
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
 S %=$P(^TMP("BDMDMTX",$J,0),U)+1,$P(^TMP("BDMDMTX",$J,0),U)=%
 S ^TMP("BDMDMTX",$J,%,0)=X
 Q
