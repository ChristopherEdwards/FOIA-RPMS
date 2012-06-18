FHDCR11 ; HISC/REL/NCA - Build Diet Cards (Cont.) ;3/27/96  10:20
 ;;5.0;Dietetics;**2,34**;Mar 25, 1996
BLD ; Build Diet Card list for a patient
 S X1=$G(^FHPT(+DFN,"A",+ADM,0)),FHORD=$P(X1,"^",2),SVC=$P(X1,"^",5),SF=$P(X1,"^",7),IS=$P(X1,"^",10),FHD=$P(X1,"^",16),(FHOR,X)=""
 I FHPAR'="Y" Q:SVC="C"
 I SVC="C" S:SP'=SP1 SP=SP1 Q:'SP
 Q:'FHORD  S X=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,0))
 S MPD=$P(X,"^",13),FHOR=$P(X,"^",2,6) Q:"^^^^"[FHOR
 I IS S IS=$G(^FH(119.4,+IS,0)) S:IS'="" SVC=SVC_"-"_$P(IS,"^",2)_$P(IS,"^",3)
 S:SF SVC=SVC_"  "_"SF"_"("_$S($P($G(^FHPT(DFN,"A",ADM,"SF",+SF,0)),"^",34)="Y":"M",1:"I")_")"
 I UPD D OLD^FHMTK11 I OLD=FHOR S FLG2=0 D EVT^FHDCR2 Q:'FLG2
 S STR=$G(^FHPT(DFN,"A",ADM,"DI",FHORD,2))
 S DPAT=$O(^FH(111.1,"AB",FHOR,0))
 F MEAL="B","N","E" D
 .K FP(MEAL),MP(MEAL),N2(MEAL) I $P(STR,";",$S(MEAL="B":1,MEAL="N":2,1:3))'="" D DECOD^FHDCR1B
 .S PD=MPD
 .I DPAT S PD=$P($G(^FH(111.1,DPAT,0)),"^",7) D
 ..I $P(STR,";",$S(MEAL="B":1,MEAL="N":2,1:3))="",$O(MP(MEAL,""))="" F X8=0:0 S X8=$O(^FH(111.1,DPAT,MEAL,X8)) Q:X8<1  S Z1=$G(^(X8,0)) D
 ...S ZZ=$G(^FH(114.1,+Z1,0)),NAM=$P(ZZ,"^",1)
 ...S K4=$P(ZZ,"^",3),K4=$S('K4:99,K4<10:"0"_K4,1:K4)
 ...S MP(MEAL,K4_"~"_+Z1_"~"_NAM)=$P(Z1,"^",2) Q
 ..Q
 .Q:PD=""  S PD=$P($G(^FH(116.2,PD,0)),"^",2) Q:PD=""
 I NBR=2 D PRT^FHDCR1C K ^TMP($J,"MP"),^TMP($J,0),PP,S,TT S NBR=0
 Q:PD=""  S NBR=NBR+1 D PID^FHDPA
 S Y0=$P($G(^DPT(DFN,0)),"^",1)_" ("_BID_")"_"  "_SVC,N1=0,S(NBR)=0
 D CUR^FHORD7 S N1=N1+1 I $L(Y)<60 S PP(N1,NBR)=Y
 E  S L=$S($L($P(Y,",",1,4))<60:4,1:3) S PP(N1,NBR)=$P(Y,",",1,L),N1=N1+1,PP(N1,NBR)=$E($P(Y,",",L+1,5),2,99)
 S ^TMP($J,0,NBR)=Y0_"^"_WRDN_"^"_RM
 D ALG^FHCLN S ALG="ALLGS.: "_$S(ALG="":"NONE ON FILE",1:ALG) S J=0 D BRK^FHDCR1B
 S S(NBR)=S(NBR)+1
 S ^TMP($J,"MP",S(NBR),NBR)="   Breakfast                Noon               Evening"
 K NN F MEAL="B","N","E" D
 .S X8="" F  S X8=$O(MP(MEAL,X8)) Q:X8=""  S X1=+$G(MP(MEAL,X8)) D
 ..;Q:'X1  S Z1=$P(X8,"~",2),QTY=$S(+X1#1>0:$J(+X1,3,1),1:+X1_"  ")_" "
 ..Q:'X1  S Z1=$P(X8,"~",2),PAD=$E("    ",1,5-$L(X1)),QTY=+X1_PAD
 ..S NN(MEAL,X8)=QTY_$E($P(X8,"~",3),1,15)
 ..Q
 .Q
 K TT,SRT F MEAL="B","N","E" D
 .S TT(MEAL)=0
 .S X8="" F  S X8=$O(NN(MEAL,X8)) Q:X8=""  D
 ..S TT(MEAL)=TT(MEAL)+1,SRT(TT(MEAL),MEAL)=$G(NN(MEAL,X8)) Q
 .D SO^FHDCR1B,DISL^FHDCR1B Q
 F N1=1:1 Q:'$D(SRT(N1))  D
 .S STR="" F MEAL="B","N","E" D
 ..I '$D(SRT(N1,MEAL)) S STR=STR_$J("",20) Q
 ..S STR=STR_SRT(N1,MEAL)
 ..S:MEAL'="E" STR=STR_$J("",20-$L(SRT(N1,MEAL)))
 ..Q
 .S S(NBR)=S(NBR)+1
 .S ^TMP($J,"MP",S(NBR),NBR)=STR
 .Q
 Q
