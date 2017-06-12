APCHPWHT ; IHS/CMI/LAB -- create/modify health summary type ; 06 Sep 2011  1:08 PM
 ;;2.0;IHS PCC SUITE;**6,7,11**;MAY 14, 2009;Build 58
 ;; ;
 ;routine to create/modify a health summary type
EP ;EP - called from option
 W !!!,"This option will allow you to create a new or modify an existing"
 W !,"Patient Wellness Handout type.",!!
 D ^XBFMK S DIC="^APCHPWHT(",DIC(0)="AEMQL" D ^DIC K DIC,DA,DR,DD,DO
 I Y=-1 W !!,"Goodbye",! D EOJ Q
 S %=$P(^APCHPWHT(+Y,0),U,2) I %]"",$D(^XUSEC(%,DUZ))[0 W !,"This Patient Wellness handout type is currently locked to prevent alteration.",! G EP
 S APCHPWHT=+Y
 S DIE="^APCHPWHT(",DA=APCHPWHT,DR=".01;.03" D ^DIE D ^XBFMK
 D EN
EOJ ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
EN ; -- main entry point for APCH CREATE/MODIFY TYPE
 D EN^VALM("APCH PWH CREATE/MODIFY TYPE")
 D CLEAR^VALM1
 D FULL^VALM1
 W:$D(IOF) @IOF
 D EOJ
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)="Patient Wellness Handout: " I $G(APCHPWHT),$D(^APCHPWHT(APCHPWHT)) S VALMHDR(1)=VALMHDR(1)_$P(^APCHPWHT(APCHPWHT,0),U)
 Q
 ;
INIT ;EP -- init variables and list array
 K ^TMP($J,"APCHTYPE")
 S APCHC=0
 NEW X,Y,O,C,M,T,A,I,V,W,B,E
 S A="",T="",I="",B="",E=""
 S X="STRUCTURE: " D S(X)
 S X="Order",$E(X,7)="Component" D S(X)
 S Y=0 F  S Y=$O(^APCHPWHT(APCHPWHT,1,Y)) Q:Y'=+Y  D
 .S A="",T="",I="",B="",E="",O=$P(^APCHPWHT(APCHPWHT,1,Y,0),U),C=$P(^APCHPWHT(APCHPWHT,1,Y,0),U,2),C=$P($G(^APCHPWHC(+C,0)),U,1)
 .I C="ALLERGIES" S A=Y
 .I C["TRANSPAR" S T=Y
 .I C["RECENT LAB" S B=Y
 .I C["INTAKE" S I=Y
 .I C["EDUCATION HANDOUT" S E=Y
 .S X=O,$E(X,7)=C D S(X) ;,$E(X,49)=M,$E(X,57)=T,$E(X,62)=A D S(X)
 .I A K Z S X="Source for Allergy component: " D ENPM^XBDIQ1(9001026.01,APCHPWHT_",0",".03","Z(") S X=X_$G(Z(A,.03)) D S(X)
 .I B K Z S X="Display Comments with Lab component: " D ENPM^XBDIQ1(9001026.01,APCHPWHT_",0",".04","Z(") S X=X_$G(Z(B,.04)) D S(X)
 .I T D
 ..D S("    Measures:")
 ..S V=0 F  S V=$O(^APCHPWHT(APCHPWHT,1,T,11,V)) Q:V'=+V  D
 ...S W=$P(^APCHPWHT(APCHPWHT,1,T,11,V,0),U,2)
 ...I W S W=$P(^APCHPWHE(W,0),U,1)
 ...S X="",$E(X,8)=V,$E(X,12)=W D S(X)
 .I I D
 ..D S("    Intake Forms:")
 ..S V=0 F  S V=$O(^APCHPWHT(APCHPWHT,1,I,12,V)) Q:V'=+V  D
 ...S W=$P(^APCHPWHT(APCHPWHT,1,I,12,V,0),U,2)
 ...I W S W=$P(^APCHPWHF(W,0),U,1)
 ...S X="",$E(X,8)=V,$E(X,12)=W D S(X)
 .I E D
 ..D S("    Education Handouts:")
 ..S V=0 F  S V=$O(^APCHPWHT(APCHPWHT,1,E,13,V)) Q:V'=+V  D
 ...S W=$P(^APCHPWHT(APCHPWHT,1,E,13,V,0),U,2)
 ...I W S W=$P(^APCHPWHF(W,0),U,1)
 ...S X="",$E(X,8)=V,$E(X,12)=W D S(X)
C ;
 S VALMCNT=$O(^TMP($J,"APCHTYPE",""),-1)
 Q
 ;
S(Y,F,C,T) ;EP - set up array
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
 S APCHC=APCHC+1
 S ^TMP($J,"APCHTYPE",APCHC,0)=X
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- EXIT code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;routine to create/modify a health summary type
 ;
BACK ;go back to listman
 D TERM^VALM0
 S VALMBCK="R"
 D INIT^APCHPWHT
 D HDR^APCHPWHT
 K DIR
 K X,Y,Z,I
 Q
 ;
COMP(S,C) ;EP
 NEW X,Y S Y=0,X=0 F  S X=$O(^APCHPWHT(S,1,X)) Q:X'=+X!(Y)  I $P(^APCHPWHT(S,1,X,0),U,2)=C S Y=1
 Q Y
 ;
DH ;EP called from protocol to generate PWH
 D FULL^VALM1
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." D BACK Q
 S DFN=+Y
 S Y=DFN D ^AUPNPAT
 S APCHSDFN=DFN
 S %=$P(^APCHPWHT(APCHPWHT,0),U)_" Patient Wellness Handout for "_$P(^DPT(APCHSDFN,0),U)
 D VIEWR^XBLM("EN1^APCHPWHG(APCHPWHT)",%)
 D BACK
 Q
 ;
PH ;EP called from protocol to generate PWH
 D FULL^VALM1
 S DFN=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 W !,"No Patient Selected." D BACK Q
 S DFN=+Y
 S Y=DFN D ^AUPNPAT
 S APCHSDFN=DFN
 S %=$P(^APCHPWHT(APCHPWHT,0),U)_" Patient Wellness Handout for "_$P(^DPT(APCHSDFN,0),U)
 S APCHITST=1
 D EN2^APCHPWHG(APCHPWHT,DFN)
 K APCHITST
 D BACK
 Q
 ;
AS ;EP
 D FULL^VALM1
 I '$$ALG(APCHPWHT) W !!,"You have not added Allergies as a component to this Patient Wellness Handout",!,"type.  Don't forget to do so.",!
 S DA=APCHPWHT,DIE="^APCHPWHT(",DR=".04" D ^DIE,^XBFMK
 D BACK
 Q
 ;
CCIP ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHPWHT,$O(^APCHPWHC("B","CCI MEASURES",0))) W !!,"WARNING:  CCI MEASURES has not been added to the Handout Structure.",!,"CCI MEASURES will not display until they are part of the handout",!,"structure."
 W !!,"You can add a new CCI Measure by entering a new sequence number",!,"and CCI Measure name.  To remove a CCI Measure from this handout type select the measure",!
 W "by sequence number and type an '@',",!
 S DA=APCHPWHT,DIE="^APCHPWHT(",DR=12 D ^DIE,^XBFMK
 D BACK
 Q
 ;
TQMP ;EP - called from protocol entry
 D FULL^VALM1
 I '$$COMP(APCHPWHT,$O(^APCHPWHC("B","QUALITY OF CARE TRANSPARENCY R",0))) D
 .W !!,"WARNING:  QUALITY OF CARE TRANSPARENCY REPORT CARD has not been added to the ",!,"Handout Structure.",!,"Quality Transparency MEASURES will not display until they are part of the",!," handout structure."
 W !!,"You can add a new Quality of Care Transparency Measure by entering a ",!,"new sequence number and measure name. ",!,"To remove a Measure from this handout type select the measure",!
 W "by sequence number and type an '@',",!
 S DA=APCHPWHT,DIE="^APCHPWHT(",DR=11 D ^DIE,^XBFMK
 D BACK
 Q
 ;
MS ;EP - called from protocol entry
 D FULL^VALM1
 W !!,"You can add a new component by entering a new order number and",!,"component name.  To remove a component from this PWH type select the",!,"component by name or order and then enter an '@'.",!
 S DA=APCHPWHT,DIE="^APCHPWHT(",DR="[APCH MODIFY TYPE]" D ^DIE,^XBFMK
 D BACK
 Q
PAUSE ;EP; -- ask user to press ENTER
 Q:IOST'["C-"
 NEW Y S Y=$$READ("E","Press ENTER to continue") D ^XBCLS Q
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ;EP; calls reader, returns response
 NEW DIR,X,Y
 S DIR(0)=TYPE
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
ALG(P) ;
 NEW A,B,G
 S G=""
 S A=0 F  S A=$O(^APCHPWHT(P,1,A)) Q:A'=+A  S B=$P(^APCHPWHT(P,1,A,0),U,2),B=$P(^APCHPWHC(+B,0),U) I B["ALLERG" S G=1
 Q G
 ;
CCI(P) ;
 NEW A,B,G
 S G=""
 S A=0 F  S A=$O(^APCHPWHT(P,1,A)) Q:A'=+A  S B=$P(^APCHPWHT(P,1,A,0),U,2),B=$P(^APCHPWHC(+B,0),U) I B["CCI" S G=1
 Q G
 ;
TQM(P) ;
 NEW A,B,G
 S G=""
 S A=0 F  S A=$O(^APCHPWHT(P,1,A)) Q:A'=+A  S B=$P(^APCHPWHT(P,1,A,0),U,2),B=$P(^APCHPWHC(+B,0),U) I B["TRANSPAR" S G=1
 Q G
 ;
