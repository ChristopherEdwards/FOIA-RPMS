ANSQPP1 ;IHS/OIRM/DSD/CSC - PRINT PATIENT ACUITY REPORT; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;PRINT PATIENT ACUITY REPORT
A1 Q:'$D(ANSDFN)
 Q:'$D(^DPT(ANSDFN,0))
 D HEAD
 S X=$P(^DPT(ANSDFN,0),U)
 W !,$P(X,",",1),", ",$P(X,",",2,99)
 I $D(^AUPNPAT(ANSDFN,41,ANSSITE,0)) S X=$P(^(0),U,2) I X]"" W "    (",X,")"
 D SUBH
A2 S T=0
 D CARH
 F I=1:1:10 D SBW I I=2!(I=7) D PAUSE^ANSDIC
 W !!,"Adj. Factors: "
 W:ANSAF="" "None Listed"
 F I=1:1 S X=$P(ANSAF,U,I) Q:X=""  D
 .I $D(^ANSD(59.3,X,0)) S X=$P(^(0),U,2),S=$P(^(0),U,3),L=$L(X) W:$X+L>74 !,?14 W:I>1 "," W:IOST["C-" @ANSRVON W @ANSSPAC,X,@ANSSPAC W:IOST["C-" @ANSRVOF I S]"" S @("T=T"_S_"4")
 S L=$O(^ANSD(51.1,1,"K",T-1))
 I L,$D(^ANSD(51.1,1,"K",L,0)) S L=$P(^(0),U,2),X=$P(^(0),U,3)
 W !,"Total Weight: "
 I T<34 W T
 E  W:IOST["C-" @ANSRVON W " ",T,@ANSSPAC W:IOST["C-" @ANSRVOF
 W ?25,"Nursing Care Level: "
 I X'["V" W L," - ",X
 E  D
 .W:IOST["C-" @ANSRVON
 .W L," - ",X W:IOST["C-" @ANSSPAC  ;CSC 10-28-96
 .W:IOST["C-" @ANSRVOF
 D PAUSE^ANSDIC
 Q
SBW W !
 S S=I
 W S
 D AREA
 Q
AREA I $D(^ANSD(59,S,0)) S ANS=^(0) W " ",$P(ANS,U),"(",$P(ANS,U,2)," levs)"
 S L=$P(ANSCL,U,S)
 Q:L<1
 I L>4,$P(^ANSD(59,S,0),U,L) S T=T+$P(^(0),U,L)
 E  S T=T+L
 I L>3 D  I 1
 .W ?29
 .W:IOST["C-" @ANSRVON
 .W "  ",L," *" W:IOST["C-" @ANSSPAC  ;CSC 10-28-96
 .W:IOST["C-" @ANSRVOF
 .W "     "
 E  W ?31,L
 S L="D"_L
 I $D(^ANSD(59,S,L)) S X=^(L) W ?40
 S (K,C)=0,M=$L(X," ")+1
S11 S K=K+1
 G S19:K=M
 S W=$P(X," ",K)
 I $L(W)+1+$X<79 W:C " " W W S C=1 G S11
 W !,?40,W
 S C=1
 G S11
S19 Q
CARH W !!,?6,"Care Area",?25,"Current Level",?54,"Description"
 W !,"-----------------------",?25,"-------------",?40,"---------------------------------------"
 Q
HEAD D HEAD^ANSEAV
 Q
SUBH S Y=ANSDT
 X ^DD("DD")
 W !!,?3,Y
 S Y="",ANSS=$P(ANSPAR,U,5)
 I $D(ANSSH) S X=$T(@ANSS),Y=$P($P(X,";;",ANSSH+1),U,2) W ?22,Y," Shift"
 G SUBH9:'ANSUN,SUBH9:'$D(^ANSD(59.1,ANSUN,0))
 S Z=$P(^ANSD(59.1,ANSUN,0),U)
 W ?45,"Unit ",Z
 S Y=$P(ANSDX,U,3)
 I Y,$D(^ANSD(59.1,ANSUN,"R",Y,0)) W "  Rm ",$P(^(0),U) S Y=$P(ANSDX,U,4) I Y,$D(^("B",Y,0)) W "-",$P(^(0),U)
SUBH9 W !!,"  Diagnosis: "
 W:IOST["C-" @ANSRVON
 W $P(ANSDX,U),@ANSSPAC
 W:IOST["C-" @ANSRVOF
 Q
DISP D HEAD,SUBH
 W !
 Q
2 ;;1^DAY;;2^NIGHT
3 ;;1^DAY;;2^EVENING;;3^NIGHT
