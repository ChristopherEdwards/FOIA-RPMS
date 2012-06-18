PSNLOOK ;BIR/WRT-Look up into drug file ; 06/19/03 15:00
 ;;4.0; NATIONAL DRUG FILE;**2,3,5,11,22,27,62,70**; 30 Oct 98
 ;
 ; Reference to ^PSDRUG supported by DBIA# 2192
 ; Reference to ^PS(50.606 supported by DBIA# 2174
 ;
BEGIN D ASK F ZZ=0:0 W ! D LOOK Q:Y<0
KILL K CL,NODE,ZZ,IFN,BB,BILL,DA,DIR,CSFS,FRM,FS,GR,ID,INDT,IST,IUN,IUT,K,MIDD,MISD,MXCD,MXDD,MXSD,NFN,NOD,PMIS,PR,QQ,SEV,SP,STR,TR,UN,UNT,VADU,VPN,DUDA,CC,DF,NUM,SCL,X,Y,RE,WRT,MAP,ENG Q
ASK W !,"This option will allow you to look up entries in your local DRUG file. It will",!,"display National Drug File software match information.",!! S PR=" (Primary) "
 Q
LOOK S DIC="^PSDRUG(",DIC(0)="EM",DIC("S")="I $S('$D(^PSDRUG(+Y,""I"")):1,'^(""I""):1,DT'>^(""I""):1,1:0)" R !!,"Select DRUG GENERIC NAME :  ",BILL:DTIME S:'$T BILL="^" S X=BILL D ^DIC K DIC G:$E(BILL)["?" LOOK I Y>0 S IFN=+Y D DSPLY Q
 Q
DSPLY W @IOF W !?14,"DRUG Generic Name:  ",$P(^PSDRUG(IFN,0),"^") I $D(^PSDRUG(IFN,"ND")) S CL=$P(^("ND"),"^",6) I $D(^PS(50.605,CL)) ; W $P(^PS(50.605,CL,0),"^",1),"    ",$P(^PS(50.605,CL,0),"^",2)
 I $D(^PSDRUG(IFN,"ND")),$P(^PSDRUG(IFN,"ND"),"^",2)]"" S NODE=^PSDRUG(IFN,"ND") S (CSFS,MXSD,MISD,MXDD,MIDD,MXCD,SP,INDT)="" D DSPLY1,DSPLY2,PRODF,DSP,ING,SV,DSP1,RESTN
 I $D(^PSDRUG(IFN,"ND")),$P(^PSDRUG(IFN,"ND"),"^",2)']"" W !?8,"*** NO NATIONAL DRUG FILE INFORMATION ***",!
 Q
DSPLY1 W !?5,"VA Product Name: ",$P(NODE,"^",2)
 W !?5,"VA Generic Name: ",$P(^PSNDF(50.6,$P(NODE,"^",1),0),"^",1)
 Q
DSPLY2 S VPN="",ID="",VADU="",TR="",DA=$P(NODE,"^"),K=$P(NODE,"^",3),X=$$PROD2^PSNAPIS(DA,K) I X]"",$P(X,"^")]"" S VPN=$P(X,"^"),ID=$P(X,"^",2),TR=$P(X,"^",3),VADU=$P(X,"^",4)
 K PMIS I X]"" S QQ=$P(^PSNDF(50.68,K,1),"^",5) D GCN I QQ]"" D GCN1
 Q
GCN I QQ']"" S PMIS="None" Q
GCN1 I $D(^PS(50.623,"B",QQ)) S MAP=$O(^PS(50.623,"B",QQ,0)),ENG=$P(^PS(50.623,MAP,0),"^",2),PMIS=$P(^PS(50.621,+ENG,0),"^")
 I '$D(^PS(50.623,"B",QQ)) S PMIS="None"
 Q
DSPLY3 W ?50,"Transmit To CMOP: "
 I TR=1 W "YES"
 I TR=0 W "NO"
 Q
PRODF S X=$$PROD0^PSNAPIS(DA,K),DF=$P(X,"^",2),STR=$P(X,"^",3),UN=+$P(X,"^",4),FRM=$P(^PS(50.606,DF,0),"^"),UNT=$P($G(^PS(50.607,UN,0)),"^"),NFN=$P(^PSNDF(50.68,K,0),"^",6)
 Q
ING I $D(^PSNDF(50.68,K,2,0)) F BB=0:0 S BB=$O(^PSNDF(50.68,K,2,BB)) Q:'BB  S NOD=^PSNDF(50.68,K,2,BB,0),GR=$P(^PS(50.416,$P(NOD,"^",1),0),"^"),IST=$P(NOD,"^",2),IUT=$P(NOD,"^",3) D ING1,IN2
 Q
IN2 W ?3,GR,?50,"Str: ",STR W:IUT]"" ?65,"Unt: ",IUN W !
 Q
ING1 S:$P(^PS(50.416,$P(NOD,"^"),0),"^",2)="" GR=GR_PR I IUT]"" S IUN=$P(^PS(50.607,IUT,0),"^")
 Q
SC I $D(^PSNDF(50.68,K,4,0)) W !,"Secondary Class(es): ",! S NUM=$P(^PSNDF(50.68,K,4,0),"^",4) F CC=0:0 S CC=$O(^PSNDF(50.68,K,4,CC)) Q:'CC  S SCL=$P(^PS(50.605,$P(^PSNDF(50.68,K,4,CC,0),"^"),0),"^") D SC1
 Q
SC1 W "   ",SCL
 Q
SV S SEV=$G(^PSNDF(50.68,K,7)) I SEV]"" S CSFS=$P(SEV,"^"),MXSD=$P(SEV,"^",4),MISD=$P(SEV,"^",5),MXDD=$P(SEV,"^",6),MIDD=$P(SEV,"^",7),MXCD=$P(SEV,"^",8),SP=$P(SEV,"^",2) S:SP="M" SP="Multi" S:SP="S" SP="Single" D SV1
 Q
SV1 S FS=$S(CSFS=0:"Unscheduled",CSFS=1:"Schedule I",CSFS=2:"Schedule II",CSFS=3:"Schedule III",CSFS=4:"Schedule IV",CSFS=5:"Schedule V",1:"None"),INDT=$P(^PSNDF(50.68,K,7),"^",3)
 Q
DSP W !,"Dosage Form: ",FRM,?30,"Strength: ",STR W:$G(UNT) ?50,"Units: ",UNT W !,"National Formulary Name: ",NFN,!,"VA Print Name: ",VPN,!,"VA Product Identifier: ",ID D DSPLY3 W !,"VA Dispense Unit: ",VADU I $D(PMIS) W !,"PMIS: ",PMIS
 W !,"Active Ingredients: ",!
 Q
DSP1 D HG W "Primary Drug Class: ",$P(^PS(50.605,CL,0),"^") D SC W !,"CS Federal Schedule: ",CSFS,?45,"Single/Multi Source Product: ",SP
 I INDT]"" W !,"Inactivation Date: " S Y=INDT D DD^%DT W Y
 W !,"Max Single Dose: ",MXSD,?45,"Min Single Dose: ",MISD
 W !,"Max Daily Dose: ",MXDD,?45,"Min Daily Dose: ",MIDD,!,"Max Cumulative Dose: ",MXCD
 W !,"National Formulary Indicator: " I $D(^PSNDF(50.68,K,5)) W:$P(^PSNDF(50.68,K,5),"^")=0 "No" W:$P(^PSNDF(50.68,K,5),"^")=1 "Yes"
 I $G(^PSNDF(50.68,K,8)) W !!,"Exclude Drg-Drg Interaction Ck: Yes (No check for Drug-Drug Interactions)"
 W !
 Q
RESTN I $D(^PSNDF(50.68,K,6,0)) W !,"Restriction: " F RE=0:0 S RE=$O(^PSNDF(50.68,K,6,RE)) Q:'RE  S WRT=^PSNDF(50.68,K,6,RE,0) W !,WRT
 Q
HG K DIR S DIR(0)="E",DIR("A")="Press <Return> to Continue" D ^DIR
 W @IOF
 Q
