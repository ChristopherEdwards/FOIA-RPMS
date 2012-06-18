FHORX1A ; HISC/REL/NCA - Diet Activity Report (cont) ;3/17/95  10:06
 ;;5.0;Dietetics;**30**;Oct 11, 1995
 S PG=0 D HDR
 S P0="",NN=0 F  S P0=$O(^TMP($J,"P",P0)) Q:P0=""  D LST
 W ! S $P(^FH(119.73,FHP,0),"^",2)=NOW
 Q
LST K PP S NP=0 F DA=0:0 S DA=$O(^TMP($J,"P",P0,DA)) Q:DA<1  S Z=^(DA) D L1
 D L2 Q
L1 ; Process event
 S ADM=$P(Z,"^",1),TYP=$P(Z,"^",2),ACT=$P(Z,"^",3),FHORD=$P(Z,"^",4),TXT=$P(Z,"^",5),CLK=$P(Z,"^",6)
 I 'FHORD S NN=NN+1,FHORD=NN
 I "DIT"[TYP D
 .I TYP="D",FHORD=1 S NP=1
 .I $D(PP(TYP,ADM_"~"_FHORD)),ACT="C" K PP(TYP,ADM_"~"_FHORD) Q
 .K PP(TYP) S PP(TYP,ADM_"~"_FHORD)=ACT_"^"_TXT_"^"_CLK Q
 I "OPSF"[TYP D
 .I $D(PP(TYP,ADM_"~"_FHORD)),ACT="C" K PP(TYP,ADM_"~"_FHORD) Q
 .S PP(TYP,ADM_"~"_FHORD)=ACT_"^"_TXT_"^"_CLK Q
 I "LM"[TYP S PP(TYP,ADM_"~"_FHORD)=ACT_"^"_TXT_"^"_CLK
 Q
L2 S W1=$P(P0,"~",2),R1=$P(P0,"~",4),DFN=$P(P0,"~",5),Y0=$G(^DPT(DFN,0))
 S N1=$P(Y0,"^",1) D PID^FHDPA
 S TC=$P($G(^FHPT(DFN,"A",ADM,0)),"^",5),SF=$P($G(^(0)),"^",7),SO=$D(^FHPT("ASP",DFN,ADM))
 D:$Y>54 HDR W !!,$E(W1_" "_R1,1,20),?22,N1,?54,BID,?63,$S(SF:"SF",1:""),?66,$S(SO:"SO",1:""),?73,TC,!
 D ^FHORX1C D:NP NEWP Q
HDR W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1 W !?20,"D I E T   A C T I V I T Y   R E P O R T",?72,"Page ",PG
 W !!?(80-$L(H1)\2),H1
 W !!,"Ward-Room",?22,"Patient",?55,"ID#",?62,"Sup/Std  Service" Q
NEWP D ALG^FHCLN I ALG'="" S EVT="Allergies: "_ALG,TYP="A" D LNE^FHORX1C
 S X1="Pref:" F K=0:0 S K=$O(^FHPT(DFN,"P",K)) Q:K<1  S X=^(K,0) D N1
 W:$L(X1)>6 !?12,X1 Q
N1 S Y=$G(^FH(115.2,+X,0)) Q:$P(Y,"^",2)'="D"
 S Y=" "_$P(Y,"^",1)_" ("_$P(X,"^",2)_")"_$S($P(X,"^",4)="Y":" (D)",1:"") I $L(X1)+$L(Y)>48 W !?12,X1 S X1="Pref:"
 S X1=X1_Y Q
