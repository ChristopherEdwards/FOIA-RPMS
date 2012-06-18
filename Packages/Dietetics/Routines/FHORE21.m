FHORE21 ; HISC/REL/NCA - List Early/Late Trays (cont) ;11/9/94  13:33 
 ;;5.0;Dietetics;**38,39**;Oct 11, 1995
 S D1=DTE,COUNT=0,LINE=1 K ^TMP($J) S ANS=""
F2 S D1=$O(^FHPT("ADLT",D1)) G:D1<1!(D1\1'=DTE) P0 S DFN=0
F3 S DFN=$O(^FHPT("ADLT",D1,DFN)) G:DFN<1 F2 S ADM=0
F4 S ADM=$O(^FHPT("ADLT",D1,DFN,ADM)) G:ADM<1 F3
 I $S($D(^DGPM(ADM,0)):$P(^(0),"^",17),1:1) G F7
 S Y(0)=$G(^FHPT(DFN,"A",ADM,"EL",D1,0)) G:Y(0)="" F7
 S X=$G(^FHPT(DFN,"A",ADM,0)),OLW=$P(X,"^",11),IS=$P(X,"^",10)
 S W1=$P(X,"^",8),X2=$G(^FH(119.6,+W1,0)),WARD=$P(X2,"^",1)
 G:WARD="" F4 S P0=$P(X2,"^",8) I FHP,P0'=FHP G F4
 S M1=$P(Y(0),"^",2) I MEAL'="A",M1'=MEAL G F4
 D CUR G:FHLD'="" F4 S O1=Y
 S ^TMP($J,"EL",D1_"-"_$P(Y(0),"^",6),DFN_"-"_ADM)=WARD_"^"_P0_"^"_OLW_"^"_IS_"^"_O1_"^"_$P(Y(0),"^",2,4) G F4
P0 D NOW^%DTC S DTP=% D DTP^FH S H1=DTP,DTP=DTE\1 D DTP^FH S L1=DTP
 I LAB S LAB=$P($G(^FH(119.9,1,"D",IOS,0)),"^",2) S:'LAB LAB=1
 S S1=LAB=2*5+36
P1 S M2="Z",PG=0 D:'LAB HDR
 S N1="" F  S N1=$O(^TMP($J,"EL",N1)) Q:N1=""!(ANS="^")  S N2="" F  S N2=$O(^TMP($J,"EL",N1,N2)) Q:N2=""  S Y=^(N2) D P2 Q:ANS="^"
 I LAB>2 D DPLL^FHLABEL K ^TMP($J) Q
 I LAB<3 F K=1:1:$S('LAB:1,1:18) W !
 Q
P2 S DFN=+N2,WARD=$P(Y,"^",1),P0=$P(Y,"^",2),OLW=$P(Y,"^",3),IS=$P(Y,"^",4),O1=$P(Y,"^",5),M1=$P(Y,"^",6),TIM=$P(Y,"^",7),BAG=$P(Y,"^",8)
 I IS S IS=^FH(119.4,IS,0),IS=$P(IS,"^",2)_$P(IS,"^",3)
 S Y=^DPT(DFN,0),P1=$P(Y,"^",1) D PID^FHDPA
 S RM=$G(^DPT(DFN,.101)) I LAB>2 D LL Q
 G:LAB P3
 I $Y>(IOSL-10) D HDR Q:ANS="^"  W !!?59,$S(M1="B":"Break",M1="N":"Noon",1:"Even"),?65,$J(TIM,6),! S M2=M1_TIM
 S X=M1_TIM I X'=M2 W !!?59,$S(M1="B":"Break",M1="N":"Noon",1:"Even"),?65,$J(TIM,6),! S M2=X
 W !,$S(WARD'="":$E(WARD,1,10),1:"")_$S(RM'="":"/"_$E(RM,1,10),1:""),?24,$E(P1,1,22),?50,BID,?61,$S(IS'="":IS,1:""),?67,$S(BAG="Y":"YES",1:""),?73,O1
 Q
P3 S P1=$E(P1,1,22),WARD=$E(WARD,1,15),RM=$E(RM,1,10)
 W !,$S(M1="B":"Breakfast",M1="N":"  Noon ",1:" Evening"),?10,TIM,?(S1-12),L1 W:LAB=2 !
 W !,$E(P1,1,S1-5-$L(WARD)),?(S1-3-$L(WARD)),WARD
 W !,BID W:IS'="" ?(S1-3\2),IS W ?(S1-3-$L(RM)),RM W:LAB=2 !
 I $L(O1)<S1 W !,O1,!!
 E  S L=$S($L($P(O1,",",1,3))<S1:3,1:2) W !,$P(O1,",",1,L),!,$E($P(O1,",",L+1,5),2,99),!
 W:LAB=2 ! Q
F7 K ^FHPT("ADLT",D1,DFN,ADM) G F4
CUR S A1=0,(Y,FHLD,FHOR)="" F KK=0:0 S KK=$O(^FHPT(DFN,"A",ADM,"AC",KK)) Q:KK<1!(KK>D1)  S A1=KK
 Q:'A1  S FHORD=$P(^FHPT(DFN,"A",ADM,"AC",A1,0),"^",2),X=^FHPT(DFN,"A",ADM,"DI",FHORD,0),FHOR=$P(X,"^",2,6),FHLD=$P(X,"^",7)
 I FHLD'="" S FHDU=";"_$P(^DD(115.02,6,0),"^",3),%=$F(FHDU,";"_FHLD_":") Q:%<1  S Y=$P($E(FHDU,%,999),";",1) Q
 S Y="" F A1=1:1:5 S D3=$P(FHOR,"^",A1) I D3 S:Y'="" Y=Y_", " S Y=Y_$P(^FH(111,D3,0),"^",7)
 Q
DP K N S Y=$G(^FH(119.73,+P0,1))
 F KK=1,2,3,7,8,9,13,14,15 S X=$P(Y,"^",KK) I X'="" S N($S(KK<7:"B",KK<13:"N",1:"E"),X)=""
 Q
HDR ; Print Header
 I PG,IOST?1"C-".E R !!,"Press RETURN to continue or ""^"" to exit. ",ANS:DTIME S:'$T!(ANS["^") ANS="^" Q:ANS="^"  I "^"'[ANS W !,"Enter Return or ""^""." G HDR
 W:'($E(IOST,1,2)'="C-"&'PG) @IOF S PG=PG+1
 W !?50,"E A R L Y / L A T E   T R A Y S",?110,H1
 W !,$S('FHP:"Consolidated",1:$P(^FH(119.73,FHP,0),"^",1)),?61,L1,?121,"Page ",PG
 W !!,"Ward/Room",?24,"Patient",?50,"ID#",?61,"Iso   Bag   Current-Diet",! Q
LL ;
 S FHCOL=$S(LAB=3:3,1:2)
 I LABSTART>1 F FHLABST=1:1:(LABSTART-1)*FHCOL D  S LABSTART=1
 .I LAB=3 S (PCL1,PCL2,PCL3,PCL4,PCL5,PCL6)="" D LL3^FHLABEL
 .I LAB=4 S (PCL1,PCL2,PCL3,PCL4,PCL5,PCL6,PCL7,PCL8)="" D LL4^FHLABEL
 .Q
 S SL1=$S(LAB=3:25,1:38)
 S MEALTM=$S(M1="B":"Breakfast",M1="N":"Noon",1:"Evening")_"  "_TIM
 S BIDIS=BID_$E("        ",1,12-$L(BID))_IS
 S WARD=$E(WARD,1,15),WLN=$L(WARD),RM=$E(RM,1,10)
 I LAB=3 D
 .S P1=$E(P1,1,24-WLN)
 .S (PCL1,PCL6)="",PCL2=MEALTM_$J(L1,25-$L(MEALTM))
 .S PCL3=P1_$J(WARD,25-$L(P1)),PCL4=BIDIS_$J(RM,25-$L(BIDIS))
 .S PCL5=$E(O1,1,29) D LL3^FHLABEL
 I LAB=4 D
 .S P1=$E(P1,1,37-WLN)
 .S (PCL1,PCL2,PCL7,PCL8)="",PCL3=MEALTM_$J(L1,38-$L(MEALTM))
 .S PCL4=P1_$J(WARD,38-$L(P1)),PCL5=BIDIS_$J(RM,38-$L(BIDIS))
 .S PCL6=$E(O1,1,42) D LL4^FHLABEL
 Q
