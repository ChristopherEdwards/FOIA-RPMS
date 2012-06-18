FHASP1 ; HISC/REL/JH - Nutrition Profile (cont) ;5/2/01  10:14
 ;;5.0;Dietetics;**9,18,29,37**;Jun 07, 1995
 S X1=DT,X2=-1095 D C^%DTC S DTE=X,N1=0 W !!?22,"Dietetic Encounters Last Three Years"
 F DTE=DTE:0 S DTE=$O(^FHEN("AP",DFN,DTE)) Q:DTE<1!(ANS="^")  F ASN=0:0 S ASN=$O(^FHEN("AP",DFN,DTE,ASN)) Q:ASN<1  D:$Y'<S1 HF^FHASP Q:ANS="^"  D LST
 Q:ANS="^"
 I 'N1 W !!?5,"No Encounters recorded last three years."
 S FADM=$O(^FHPT(DFN,"A",""),-1) S FADM=$S($G(ADM):$G(ADM),FADM:FADM,1:"") G:FADM="" F1
 D:$Y'<(S1-6) HF^FHASP Q:ANS="^"  W !!?28,$S($G(ADM):"Current",1:"Last")," Admission Monitors" S N1=0
 ; F NDT=0:0 S NDT=$O(^FHPT(DFN,"A",FADM,"MO","AC",NDT)) Q:NDT<1  F K=0:0 S K=$O(^FHPT(DFN,"A",FADM,"MO","AC",NDT,K)) Q:K<1  D MO
 S FHTTLM="",FHTTLM=$P($G(^FHPT(DFN,"A",FADM,"MO",0)),U,3)
 I FHTTLM="" W !,"No Monitors on file." G F1
 S FHMONS=$S(FHTTLM-FHNUM<0:0,1:FHTTLM-FHNUM)
 F NDT=FHMONS:0 S NDT=$O(^FHPT(DFN,"A",FADM,"MO",NDT)) Q:NDT<1!(ANS="^")  S K=NDT D MO
 Q:ANS="^"  I 'N1 W !,"No Monitors on file."
F1 D:$Y'<(S1-6) HF^FHASP Q:ANS="^"  W !!?32,"Food Preferences" D DISP
 W !!?27,"Future Clinic Appointments" S N1=0
 F NDT=NOW:0 S NDT=$O(^DPT(DFN,"S",NDT)) Q:NDT'>0  S Z=^(NDT,0) I "I"[$P(Z,"^",2) D CLIN Q:ANS="^"
 Q:ANS="^"
 I 'N1 W !!?5,"No scheduled appointments."
 D FOOT^FHASP Q
LST S X0=$G(^FHEN(ASN,0)) Q:$P(X0,"^",4)<3
 S X1=$G(^FHEN(ASN,"P",DFN,0))
 W:'N1 ! S N1=N1+1,DTP=$P(X0,"^",2) D DTP^FH W !?5,$E(DTP,1,9),"  " S Y=$P(X0,"^",4),Y=$P($G(^FH(115.6,+Y,0)),"^",1) W Y I $P(X0,"^",7)="F" W " (FU)"
 S Y=$P(X0,"^",9) W ", ",$S(Y="G":"Group",1:"Individual")
 S Y=$P(X0,"^",11) W:Y'="" !?10,Y S Y=$P(X1,"^",4) W:Y'="" !?10,Y Q
CLIN S SC=+$P(Z,"^",1),Y=$P($G(^SC(SC,0)),"^",1) Q:Y=""
 D:$Y'<S1 HF^FHASP Q:ANS="^"  W:'N1 ! S N1=N1+1,DTP=NDT D DTP^FH W !?5,DTP,?25,Y W:$P(Z,"^",11) " (Collateral)" Q
DISP ; Display Food Preferences
 W !?26,"Likes",?58,"DisLikes",!
 K P S P1=1 F K=0:0 S K=$O(^FHPT(DFN,"P",K)) Q:K<1  S X=^(K,0) D SP
 W ! S (M,MM)="" F  S M=$O(P(M)) Q:M=""  I $D(P(M)) W $P(M,"~",2) D  S MM=M
 .  S (P1,P2)=0 F  S:P1'="" P1=$O(P(M,"L",P1)) S X1=$S(P1>0:P(M,"L",P1),1:"") S:P2'="" P2=$O(P(M,"D",P2)) S X2=$S(P2>0:P(M,"D",P2),1:"") Q:P1=""&(P2="")  D P0 Q:ANS="^"  W:MM'=M !
 .  Q
 Q:ANS="^"
 I $O(P(""))="" W !,"No Food Preferences on file",!
 Q
P0 I X1'="" W ?12 S X=X1 D P1 S X1=X
 I X2'="" W ?46 S X=X2 D P1 S X2=X
 Q:X1=""&(X2="")  D:$Y'<S1 HF^FHASP Q:ANS="^"  W ! G P0
P1 I $L(X)<34 W X S X="" Q
 F KK=35:-1:1 Q:$E(X,KK-1,KK)=", "
 W $E(X,1,KK-2) S X=$E(X,KK+1,999) Q
SP Q:'$P(X,U)  S M1=$P(X,"^",2) S:M1="A" M1="BNE" S Z=$G(^FH(115.2,+X,0)) Q:$P(Z,U)=""!($P(Z,U,2)="")  S L1=$P(Z,"^",1),KK=$P(Z,"^",2),M="",DAS=$P(X,"^",4)
 I KK="L" S Q=$P(X,"^",3),L1=$S(Q:Q,1:1)_" "_L1
 I M1="BNE" S M="1~All Meals" G SP1
 S Z1=$E(M1,1) I Z1'="" S M=$S(Z1="B":"2~Break",Z1="N":"3~Noon",1:"4~Even")
 S Z1=$E(M1,2) I Z1'="" S M=M_","_$S(Z1="B":"Break",Z1="N":"Noon",1:"Even")
SP1 S:'$D(P(M,KK,P1)) P(M,KK,P1)="" I $L(P(M,KK,P1))+$L(L1)<255 S P(M,KK,P1)=P(M,KK,P1)_$S(P(M,KK,P1)="":"",1:", ")_L1_$S(DAS="Y":" (D)",1:"")
 E  S:'$D(P(M,KK,K)) P(M,KK,K)="" S P(M,KK,K)=L1_$S(DAS="Y":" (D)",1:"") S P1=K
 Q
MO ; Display Monitors
 S Y=$G(^FHPT(DFN,"A",FADM,"MO",K,0)) Q:Y=""  S N1=N1+1
 D:$Y'<S1 HF^FHASP Q:ANS="^"
 W !,$P(Y,"^",1) S DTP=$P(Y,"^",2) D DTP^FH W ", ",DTP
 S COM=$P(Y,"^",3) W:COM'="" !?5,"Action: ",COM Q
