APCHTPU ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 15-NOV-2000 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;; ;
EP ;EP - called from option to select and display a TP
 W:$D(IOF) @IOF
 W !!,"This option will allow a site to specify sex, age ranges and frequencies for",!,"a health maintenance reminder.",!!
 D ^XBFMK
 S DIC="^APCHSURV(",DIC("A")="Select BEST PRACTICE PROMPT to Modify: ",DIC(0)="AEMQ",DIC("S")="I $P(^(0),U,3)'=""D"",$P(^(0),U,7)=""T""" D ^DIC
 I Y=-1 D EXIT Q
 S APCHTP=+Y
EN ; -- main entry point for APCH MODIFY TP
 D EN^VALM("APCH MODIFY TP")
 D CLEAR^VALM1
 D FULL^VALM1
 D EXIT
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="Modify Best Practice Prompt Criteria"
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("APCHTPU",$J)
 S ^TMP("APCHTPU",$J,0)=0
 ;gather up reminder for display
 S C=0,X="",X="Best Practice Prompt:",$E(X,20)=$P(^APCHSURV(APCHTP,0),U) D S(X)
 S X="",X="Status:",$E(X,20)=$$VAL^XBDIQ1(9001018,APCHTP,.03) D S(X)
 S X="Description:" D S(X,1)
 S Y=0 F  S Y=$O(^APCHSURV(APCHTP,1,Y)) Q:Y'=+Y  S X="",$E(X,2)=^APCHSURV(APCHTP,1,Y,0) D S(X)
 S X="Best Practice Prompt Text: " D S(X,1)
 S Y=0 F  S Y=$O(^APCHSURV(APCHTP,12,Y)) Q:Y'=+Y  S X="",$E(X,2)=^APCHSURV(APCHTP,12,Y,0) D S(X)
 S X="Currently Defined Criteria in Use at this Facility" D S(X,1)
 S Y=0 F  S Y=$O(^APCHSURV(APCHTP,11,Y)) Q:Y'=+Y  D
 .S Z="",$E(Z,5)="Sex:  "_$S($P(^APCHSURV(APCHTP,11,Y,0),U)="F":"FEMALE",$P(^APCHSURV(APCHTP,11,Y,0),U)="M":"MALE",$P(^APCHSURV(APCHTP,11,Y,0),U)="B":"BOTH",1:"")
 .S J=0 F  S J=$O(^APCHSURV(APCHTP,11,Y,11,J)) Q:J'=+J  D
 ..S X=Z,$E(X,21)="Mininum Age: "_$P(^APCHSURV(APCHTP,11,Y,11,J,0),U),$E(X,40)="Maximum Age: "_$P(^APCHSURV(APCHTP,11,Y,11,J,0),U,2),$E(X,60)="Frequency: "_$P(^APCHSURV(APCHTP,11,Y,11,J,0),U,3) D S(X)
 ..Q
 .Q
 S X="Currently defined on the following summary types:" D S(X,1)
 S J=0 F  S J=$O(^APCHSCTL(J)) Q:J'=+J  D
 .S K=0 F  S K=$O(^APCHSCTL(J,5,K)) Q:K'=+K  I $P(^APCHSCTL(J,5,K,0),U,2)=APCHTP S X="",$E(X,15)=$P(^APCHSCTL(J,0),U) D S(X)
 S VALMCNT=^TMP("APCHTPU",$J,0)
 K ^TMP("APCHTPU",$J,0)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D EN^XBVK("APCH")
 Q
 ;
EXPND ; -- expand code
 Q
 ;
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
 S %=$P(^TMP("APCHTPU",$J,0),U)+1,$P(^TMP("APCHTPU",$J,0),U)=%
 S ^TMP("APCHTPU",$J,%,0)=X
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
MOD ;EP - called from protocol
 I '$G(APCHTP) W !,"Protocol entry not defined." H 3 D BACK Q
 D FULL^VALM1
 D HM
 D BACK
 Q
HM ;EP - update methods
 W:$D(IOF) @IOF
 W !,"You may add a new sex, age range, frequency combination or edit and existing",!,"one for the ",$P(^APCHSURV(APCHTP,0),U)," reminder.",!
 D DISPHM
 I APCHC=0 W !,"No local criteria currently defined.",! S DIR(0)="Y",DIR("A")="Do you wish to ADD some",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1 Q:$D(DIRUT)  Q:'Y  D AHM G HM
 ;add or edit one of above
 W ! S DIR(0)="S^A:ADD a new one;D:DELETE one of the above;Q:QUIT",DIR("A")="Do you wish to" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !!,"Bye." Q
 I Y="Q" W !!,"Bye." Q
 D @(Y_"HM")
 G HM
DISPHM ;
 S APCHC=0 K APCHSEL
 Q:'$D(^APCHSURV(APCHTP,11))
 S (APCHQUIT,APCHC)=0 K APCHSEL
 S APCHGIEN=0 F  S APCHGIEN=$O(^APCHSURV(APCHTP,11,APCHGIEN)) Q:APCHGIEN'=+APCHGIEN!(APCHQUIT)  S APCHSEX=$P(^APCHSURV(APCHTP,11,APCHGIEN,0),U),APCHSEXR=$S(APCHSEX="F":"FEMALE",APCHSEX="M":"MALE",APCHSEX="B":"BOTH GENDERS",1:"") D
 .S APCHA=0 F  S APCHA=$O(^APCHSURV(APCHTP,11,APCHGIEN,11,APCHA)) Q:APCHA'=+APCHA!(APCHQUIT)  D
 ..S APCHC=APCHC+1,APCHSEL(APCHC)=APCHTP_U_APCHGIEN_U_APCHA W !?5,APCHC,")  ",?9,APCHSEXR,?22,$$WAGE(APCHTP,APCHGIEN,APCHA),?50,$$WF(APCHTP,APCHGIEN,APCHA)
 .Q  ;quit when necessary
 Q
AHM ;add a new pov
 S APCH1=""
 S DIR(0)="S^F:FEMALE;M:MALE;B:BOTH",DIR("A")="Enter GENDER" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 S APCH1=Y
MIN ;min age apch2
 W !!,"Now enter the minimum age in the age range.  It must be entered in the following",!,"format:  1Y, 2M, 30D, 10Y, where Y=years, M=months, D=days"
 S APCH2=""
 S DIR(0)="F^2:10",DIR("A")="Enter MINIMUM Age" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G AHM
 D INP^APCHSMU G:'$D(X) MIN
 S APCH2=Y
MAX ;
 W !!,"Now enter the maximum age in the age range.  It must be entered in the following",!,"format:  1Y, 2M, 30D, 10Y, where Y=years, M=months, D=days"
 S APCH3=""
 S DIR(0)="FO^2:10",DIR("A")="Enter MAXIMUM Age" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G AHM
 I X]"" D INP^APCHSMU G:'$D(X) MAX
 S APCH3=Y
FREQ ;
 W !!,"Now enter the frequency for ",$S(APCH1="F":"FEMALES",APCH1="M":"MALES",APCH1="B":"BOTH GENDERS"),", ages ",$$W(APCH2)," to ",$$W(APCH3),!,"It must be in the form: 2Y for every 2 years, 3M for every 3 months, etc.",!
 S APCH4=""
 S DIR(0)="F^2:10",DIR("A")="Enter FREQUENCY" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G AHM
 D INP^APCHSMU G:'$D(X) FREQ
 S APCH4=Y
 W !!,"The following will be added:",!,?5,$S(APCH1="F":"FEMALES",APCH1="M":"MALES",APCH1="B":"BOTH GENDERS"),", ages ",$$W(APCH2)," to ",$$W(APCH3)," reminder due every ",$$W(APCH4)
CONTA ;
 S DIR(0)="Y",DIR("A")="Everything okay?  Do you wish to continue and add it",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) K APCH1,APCH2,APCH3,APCH4 Q
 I 'Y K APCH1,APCH2,APCH3,APCH4 Q
 ;add to multiple
 S (X,N,G,C)=0 F  S X=$O(^APCHSURV(APCHTP,11,X)) Q:X'=+X  S:$P(^APCHSURV(APCHTP,11,X,0),U)=APCH1 G=X S N=X,C=C+1
 I 'G S N=N+1,G=N
 ;G is first level subscript , C is total number of entries
 S ^APCHSURV(APCHTP,11,0)="^9001018.11S^"_G_"^"_C
 S ^APCHSURV(APCHTP,11,G,0)=APCH1
 S (N,X)=0 F  S X=$O(^APCHSURV(APCHTP,11,G,11,X)) Q:X'=+X  S N=X
 S N=N+1  ;N is second level subscript
 S ^APCHSURV(APCHTP,11,G,11,0)="^9001018.1111^"_N_"^"_N
 S ^APCHSURV(APCHTP,11,G,11,N,0)=APCH2_U_APCH3_U_APCH4
 S DA=APCHTP,DIK="^APCHSURV(" D IX^DIK
 Q
 Q
DHM ;delete pov
 W:$D(IOF) @IOF
 D DISPHM
 S DIR(0)="N^1:"_APCHC_":",DIR("A")="Which one do you wish to DELETE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 Q:'Y
 S APCHC=Y
 I '$D(APCHSEL(APCHC)) W !!,"Invalid choice." Q
 ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this age range/frequency",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I 'Y W !,"Okay, not deleted." Q
 S DA(2)=$P(APCHSEL(APCHC),U),DA(1)=$P(APCHSEL(APCHC),U,2),DA=$P(APCHSEL(APCHC),U,3),DIK="^APCHSURV("_DA(2)_",11,"_DA(1)_",11," D ^DIK
 D BACK
 Q
 ;
WAGE(H,G,A) ;
 NEW X,Y,Z,B,E
 S X=$P(^APCHSURV(H,11,G,11,A,0),U,1)
 S Y=$P(^APCHSURV(H,11,G,11,A,0),U,2)
 I X["Y" S B=+X_$S(+X=1:" year",1:" years")
 I X["D" S B=+X_$S(+X=1:" day",1:" days")
 I X["M" S B=+X_$S(+X=1:" month",1:" months")
 I Y["Y" S E=+Y_$S(+Y=1:" year",1:" years")
 I Y["D" S E=+Y_$S(+Y=1:" day",1:" days")
 I Y["M" S E=+Y_$S(+Y=1:" month",1:" months")
 Q B_"-"_E
WF(H,G,A) ;
 NEW X,Y,Z,B,E
 S X=$P(^APCHSURV(H,11,G,11,A,0),U,3)
 I X["Y" S B=+X_$S(+X=1:" year",1:" years")
 I X["D" S B=+X_$S(+X=1:" day",1:" days")
 I X["M" S B=+X_$S(+X=1:" month",1:" months")
 Q B
 ;
W(A) ;
 NEW B
 I A["Y" S B=+A_$S(+A=1:" year",1:" years")
 I A["D" S B=+A_$S(+A=1:" day",1:" days")
 I A["M" S B=+A_$S(+A=1:" month",1:" months")
 Q B
