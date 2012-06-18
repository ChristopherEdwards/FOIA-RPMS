ANSEAV1 ;IHS/OIRM/DSD/CSC - ENTER/EDIT ACUITY DATA; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;ENTER/EDIT ACUITY DATA CON'T
A1 D HEAD
 Q:'$D(^DPT(+$G(ANSDFN),0))
 S X=$P(^DPT(ANSDFN,0),U)
 W !!,$P(X,","),", ",$P(X,",",2,99)
 S X=$P($G(^AUPNPAT(ANSDFN,41,ANSSITE,0)),U,2)
 I X]"" W "    (",X,")"
 D SUBH
 S T=0
 W !!
 D CARH
 F I=1:1:5 D SB1
 W !!,"Adj. Factors: "
 I ANSAF="" W "None Listed"
 E  F I=1:1 S X=$P(ANSAF,U,I) Q:X=""  D A2
 S L=$O(^ANSD(51.1,1,"K",T-1))
 Q:'$D(^ANSD(51.1,1,"K",+L,0))
 S L=$P(^ANSD(51.1,1,"K",L,0),U,2),X=$P(^(0),U,3)
 W !!,"Total Weight: "
 I T>33 W:IOST["C-" @ANSRVON W " ",T,@ANSSPAC W:IOST["C-" @ANSRVOF
 E  W:T<34 T
 W ?25,"Nursing Care Level: "
 I L'["V" W L," - ",X
 E  W:IOST["C-" @ANSRVON W L," - ",X,@ANSSPAC W:IOST["C-" @ANSRVOF
 Q
SB1 W !
 S S=I
 W S
 D AREA
 S S=S+5
 W ?40,$J(S,2)
 D AREA
 Q
AREA N X
 S X=$G(^ANSD(59,S,0)) W " ",$P(X,U),"(",$P(X,U,2)," levs)"
 W ?30
 W:$X>40 ?73
 S L=$P(ANSCL,U,S)
 W L
 I L>4,$G(X)]"",$P(X,U,L) S L=$P(X,U,L)
 S T=T+L,ANSTOT=T
 Q
A2 I $D(^ANSD(59.3,X,0)) S X=$P(^(0),U,2),S=$P(^(0),U,3),L=$L(X) D
 .W:$X+L>74 !,?14
 .W:I>1 ","
 .W:IOST["C-" @ANSRVON
 .W @ANSSPAC,X,@ANSSPAC
 .W:IOST["C-" @ANSRVOF
 .I S]"" S @("T=T"_S_"4")
 Q
CARH W ?6,"Care Area",?25,"Current Level",?46,"Care Area",?67,"Current Level"
 W !,"-----------------------",?25,"-------------",?40,"-------------------------",?67,"-------------"
 Q
HEAD D HEAD^ANSEAV
 Q
SUBH S Y=ANSDT
 X ^DD("DD")
 W !!,?3,Y
 S Y="",ANSS=$P(ANSPAR,U,5)
 I $D(ANSSH) S X=$T(@ANSS),Y=$P($P(X,";;",ANSSH+1),U,2) W ?22,Y," Shift"
 Q:'$D(^ANSD(59.1,+$G(ANSUN),0))
 S Z=$P(^ANSD(59.1,ANSUN,0),U)
 W ?45,"Unit ",Z
 S Y=$P(ANSDX,U,3)
 I Y,$D(^ANSD(59.1,ANSUN,"R",Y,0)) D
 .W "  Rm ",$P(^ANSD(59.1,ANSUN,"R",Y,0),U)
 .S Y=$P(ANSDX,U,4)
 .I Y,$D(^ANSD(59.1,ANSUN,"R",Y,"B",Y,0)) W "-",$P(^(0),U)
 Q
DISP D HEAD,SUBH
 W !
 Q
2 ;;1^DAY;;2^NIGHT
3 ;;1^DAY;;2^EVENING;;3^NIGHT
