AUPNELIG ; IHS/CMI/LAB - IHS-CMB/TMD INPUT TRANSFORMS FOR INSURED FIELDS OF THE ELIGIBILTY FILES ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
  ;;93.1;IHS PATIENT DICTIONARIES.;;DEC 07, 1992
HLPPI S ABMDX="HELP-PI" G DIC
HLPMCD S ABMDX="HELP-MCD" G DIC
PI S ABMDX="PI" G DIC
MCD S ABMDX="MCD"
DIC S:X="?" X="??" S ABMDX(0)=DA,ABMDX("X")=X
 I ABMDX["PI" S ABMDX(1)=DA(1)
 N (ABMDX,DUZ,DT,DTIME,U,X) S DIC="^AUPN3PPH(",DIC(0)="E"
 I ABMDX["PI" S ABMDX("INSP")=$P(^AUPNPRVT(ABMDX(1),11,ABMDX(0),0),U),ABMDX("POLP")=$P(^(0),U,2),ABMDX("PAT")=ABMDX(1)
 I ABMDX["MCD" S ABMDX("STATE")=$P(^AUPNMCD(ABMDX(0),0),U,4),ABMDX("POLP")=$P(^(0),U,3),ABMDX("PAT")=$P(^(0),U),ABMDX("INSP")=$P(^(0),U,2) D
 .I ABMDX("INSP")=""!(ABMDX("STATE")="") Q
 .S:ABMDX("INSP")=$P($G(^AUTNINS(ABMDX("INSP"),13,ABMDX("STATE"),0)),U,2)]"" ABMDX("INSP")=$P(^(0),U,2)
 S DIC("S")="I $P(^(0),U,3)=ABMDX(""INSP"")!($P(^(0),U,3)="""")"
 I ABMDX'["HELP" W !!,"Searching POLICY HOLDER file ....",!
 S %=0 D ^DIC
 I ABMDX["HELP" G XIT
 I Y=-1 S X=ABMDX("X") G INSD3
 W ?15,$P(Y,U,2) S ABMDX("Y")=Y
 S ABMDX("INSD")=$P(^AUPN3PPH(+Y,0),U,3),ABMDX("POLD")=$P(^AUPN3PPH(+Y,0),U,4)
 I ABMDX("INSD")=ABMDX("INSP"),ABMDX("POLP")=ABMDX("POLD") S X=$P(Y,U,2) G INSDIE
 I ABMDX("INSD")="" S %=0 G INSD2
 I ABMDX("INSD")'=ABMDX("INSP") S X=ABMDX("X") G INSD3
 I ABMDX("POLD")=""!(ABMDX("POLP")="") S %=0 G INSD2
 I ABMDX("POLD")'=ABMDX("POLP") W *7,!!?10,"WARNING - Policy Numbers DO NOT MATCH!",*7 ;S X=ABMDX("X") G INSD3
 ;
INSD2 W !!?5,"Is the following person:",!!?10,"POLICY HOLDER",?25,"-  ",$P(Y,U,2),!?10,"INSURANCE CO.",?25,"-  " I ABMDX("INSD")]"",$D(^AUTNINS(ABMDX("INSD"),0)) W $P(^AUTNINS(ABMDX("INSD"),0),U)
 W !?10,"POLICY NUMBER",?25,"-  ",ABMDX("POLD")
 W !!?5,"the correct insured policy holder for ",$P(^DPT(ABMDX("PAT"),0),U)
 D YN^DICN I %<1 W *7,!!?15,"Enter 'Y' for YES or 'N' for NO" G INSD2
 I %'=1 S X=ABMDX("X") G INSD3
 S ABMDX("X")=$P(Y,U,2),ABMDX("Y")=Y,DIE="^AUPN3PPH(",DA=+Y
 I ABMDX("INSD")="" S DR=".03////"_ABMDX("INSP") D ^DIE
 I ABMDX("POLD")=""&(ABMDX("POLP")'="") S DR=".04////"_ABMDX("POLP") D ^DIE
 ;E  I ABMDX("POLP")'=ABMDX("POLD") S DA(1)=ABMDX(1),DIE="^AUPNPRVT("_DA(1)_",11,",DA=ABMDX(0),DR=".02////"_ABMDX("POLD") D ^DIE 
 S X=ABMDX("X"),Y=ABMDX("Y") G INSDIE
 ;
INSD3 K DIC S DIC="^DPT(",X=ABMDX("X"),DIC(0)="EM"
 W !!,"Searching PATIENT file ...." D ^DIC
 S X=ABMDX("X") I Y=-1 G CHK
 W "   ",$P(Y,U,2)
 I $P(Y,U,2)=X G ADD
PAT S ABMDX("Y")=Y W !!,"Is ",$P(Y,U,2)," the correct insured policy holder for ",$P(^DPT(ABMDX("PAT"),0),U)
 S %=1 D YN^DICN I %<1 W *7 G PAT
 I %=1 S (ABMDX("X"),X)=$P(^DPT(+ABMDX("Y"),0),U) G ADD2
CHK K:X[""""!(X'?1U.UNP)!(X'[",")!(X?.E1","." ")!(X?.E1","." "1",".E)!($L(X,",")>3)!($L(X)>30)!($L(X)<3) X I $D(X) F L=1:0 S L=$F(X," ",L) Q:L=0  S:$E(X,L-2)?1P!($E(X,L)?1P)!(L>$L(X)) X=$E(X,1,L-2)_$E(X,L,99),L=L-1
 I '$D(X) W !!?10,"No Lookup Match Found, or Improper Format for New Entry" G XIT
 ;
ADD W !!,"Do you wish to add ",X," as the Insured Policy Holder"
 S %=1 D YN^DICN I %'=1 K X G XIT
ADD2 S DIC="^AUPN3PPH(",DIC(0)="L" K DD,DO D FILE^DICN
 S ABMDX("Y")=Y,AMBDX("X")=$P(Y,U,2)
 S ABMDX("DR")=""
 I $D(^DPT("B",X))=10 S ABMDX("DR")=$O(^DPT("B",X,"")),ABMDX("DR")=".02////"_ABMDX("DR")_";"
 S DIE="^AUPN3PPH(",DR=ABMDX("DR")_".03////"_ABMDX("INSP")_";.04////"_ABMDX("POLP"),DA=+Y D ^DIE
 S X=ABMDX("X"),Y=ABMDX("Y")
 ;
INSDIE S ABMDX("DR")="" I $P(^AUPN3PPH(+ABMDX("Y"),0),U,2)']"" S ABMDX("DR")=".08;.09;.11;.12;.13;.14;.15;.21;.22;.23;.24;.25"
 S ABMDX("X")=X,DIE="^AUPN3PPH(",DA=+ABMDX("Y"),DR=ABMDX("DR")_".04;.05;.06;.07" D ^DIE
 ;I '$D(^AUPN3PPH(+ABMDX("Y"),11,0)) S ^AUPN3PPH(+ABMDX("Y"),11,0)="^9002274.0911P^^"
 ;I '$D(^AUPN3PPH(+ABMDX("Y"),11,ABMDX(1),0)) K DD,DO,DR S DIC="^AUPN3PPH(",DIC(0)="E" D DO^DIC1 S (X,DINUM)=$S(ABMDX["PI":ABMDX(1),1:ABMDX(0)),DA(1)=+ABMDX("Y"),DIC="^AUPN3PPH("_DA(1)_",11,",DIC(0)="L" D FILE^DICN
 ;
 ;
 I ABMDX["PI" S DA(1)=ABMDX(1),DIE="^AUPNPRVT("_DA(1)_",11,",DA=ABMDX(0),DR=".08////"_+ABMDX("Y") D ^DIE
 I ABMDX["MCD" S DIE="^AUPNMCD(",DA=ABMDX(0),DR=".09////"_+ABMDX("Y") D ^DIE
 S X=ABMDX("X")
XIT K ABMDX Q
