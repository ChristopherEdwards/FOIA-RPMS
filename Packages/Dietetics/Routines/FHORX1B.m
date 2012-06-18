FHORX1B ; HISC/REL - Diet Activity Labels ;8/26/94  12:10
 ;;5.0;Dietetics;**2,38**;Mar 25, 1996
 S S2=LAB=2*5+36 I LAB<3 D LHD
 S COUNT=0,LINE=1
 S P0="",NN=0 F  S P0=$O(^TMP($J,"P",P0)) Q:P0=""  D LST
 I LAB<3 F L=1:1:18 W !
 S $P(^FH(119.73,FHP,0),"^",3)=NOW
 I LAB>2 D DPLL^FHLABEL
 Q
LST K PP S NP=0,LOC=0 F DA=0:0 S DA=$O(^TMP($J,"P",P0,DA)) Q:DA<1  S Z=^(DA) D L1
 Q:LOC
 D:$D(PP) L2 Q
L1 ; Process event
 S ADM=$P(Z,"^",1),TYP=$P(Z,"^",2),ACT=$P(Z,"^",3),FHORD=$P(Z,"^",4),TXT=$P(Z,"^",5)
 Q:"DIL"'[TYP  I 'FHORD S NN=NN+1,FHORD=NN
 I "DI"[TYP D
 .I $D(PP(TYP,ADM_"~"_FHORD)),ACT="C" K PP(TYP,ADM_"~"_FHORD) Q
 .K PP(TYP) S PP(TYP,ADM_"~"_FHORD)=ACT_"^"_TXT Q
 I TYP="L" D
 .I ACT="D" S LOC=1 Q
 .S PP(TYP,ADM_"~"_FHORD)=ACT_"^"_TXT S:ACT="A" NP=1 Q
 Q
L2 S W1=$P(P0,"~",2),R1=$P(P0,"~",4),DFN=$P(P0,"~",5),Y0=$G(^DPT(DFN,0))
 S N1=$P(Y0,"^",1) D PID^FHDPA
 S TC=$P($G(^FHPT(DFN,"A",ADM,0)),"^",5),IS=$P($G(^(0)),"^",10),FHORD=+$P($G(^(0)),"^",2) Q:'FHORD
 I IS S IS=$G(^FH(119.4,IS,0)) I IS'="" S TC=TC_"-"_$P(IS,"^",2)_$P(IS,"^",3)
 S X=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0)) D CUR
 I LAB>2 D LL Q
 W !,$E(N1,1,S2-5-$L(W1)),?(S2-3-$L(W1)),W1,!,BID W:NP " *"
 W @FHIO("EON") W ?(S2-3\2),TC W @FHIO("EOF") W ?(S2-3-$L(R1)),R1 W @FHIO("EON") I $L(Y)<S2 W:LAB=2 ! W !!,Y,!!
 E  S L=$S($L($P(Y,",",1,3))<S2:3,1:2) W !!,$P(Y,",",1,L) W:LAB=2 ! W !,$E($P(Y,",",L+1,5),2,99),!
 W @FHIO("EOF") W:LAB=2 ?(S2-20),$P(H1," - ",2),!! Q
LHD S A1=S2-30\2 W:LAB=2 ! W !?A1,"***************************",!?A1,"*",?(A1+26),"*",!?A1,"*",?(A1+5),$P(H1," - ",2),?(A1+26),"*"
 W !?A1,"*",?(A1+26),"*",!?A1,"***************************",! W:LAB=2 !! Q
CUR S Y="" Q:X=""  S FHOR=$P(X,"^",2,6),FHLD=$P(X,"^",7)
 I FHLD'="" S FHDU=";"_$P(^DD(115.02,6,0),"^",3),%=$F(FHDU,";"_FHLD_":") Q:%<1  S Y=$P($E(FHDU,%,999),";",1) Q
 F A1=1:1:5 S D3=$P(FHOR,"^",A1) I D3 S:Y'="" Y=Y_", " S Y=Y_$P(^FH(111,D3,0),"^",7)
 Q
LL ;
 S X1=TC S:NP BID=BID_" *"
 D LAB^FHLABEL Q
