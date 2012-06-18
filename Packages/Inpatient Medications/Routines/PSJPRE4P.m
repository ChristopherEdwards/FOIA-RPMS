PSJPRE4P ; B'ham ISC/CML3 - POST INIT ;2/11/92  16:49
 ;;3.2;;**28**
 ;
 D NOW^%DTC S Y=% X ^DD("DD") W !!,"POST INIT STARTED at ",Y,"..."
 W !,"...Updating the DRUG file for IV ADDITIVES and IV SOLUTIONS..."
 S PSIUX="I" F Q1=52.6,52.7 F Q2=0:0 S Q2=$O(^PS(Q1,Q2)) Q:'Q2  S PSIUDA=$P($G(^(Q2,0)),"^",2) I PSIUDA W "." D ENS^PSGIU
 W ! D ENAK
 W !!,"...I must delete and rebuild the 'B' cross-reference of your Drug File (50)..."
 K ^PSDRUG("B") S X=0 F Z=1:1 S X=$O(^PSDRUG(X)) Q:'X  S Y=$P($G(^(X,0)),"^") I Y]"" S ^PSDRUG("B",$E(Y,1,40),X)="" W:'(Z#100) "." R Q:0 I  W !,"...currently on entry number ",X,"  (",Y,")..."
 K PSIUX,PSIUDA,Q1,Q2 D NOW^%DTC S Y=%,$P(^PS(59.7,1,20),"^",13)=% X ^DD("DD") W !,"...POST INIT COMPLETED at ",Y,"." Q
 ;
ENAK ; assign keys
 K DIC S DIC="^DIC(19.1,",DIC(0)="LM",DLAYGO=19.1 F KEY="1^PSJ RPHARM","2^PSJ RNURSE","3^PSJ PHARM TECH" S X=$P(KEY,"^",2) W !,"...creating the ",X," key..." D ^DIC W "." D:Y'>0 FILE^DICN S @("KEY"_+KEY)=+Y
 W !!,"...creating key holders..."
 K PSJSF S KEYF=$D(^DD(19.12))>0+1,(HOLDER,PSJC,PSJSF,Q)=0 F  S Q=$O(^PS(59.4,Q)) Q:'Q  S PSJSF=PSJSF+1,PSJSF(PSJSF)=Q
 F  S HOLDER=$O(^XUSEC("PSJU RPH",HOLDER)) Q:'HOLDER  S KEY=KEY2 D  S PSJC=PSJC+1 W:'(PSJC#200) "."
 .F Q=1:1:PSJSF I $D(^PS(59.4,PSJSF(Q),1,"B",HOLDER)) S KEY=KEY1 Q
 .I '$D(^XUSEC($P("PSJ RPHARM^PSJ RNURSE","^",KEY=KEY2+1),HOLDER)) D @KEYF
 S KEY=KEY3 F  S HOLDER=$O(^XUSEC("PSJU PL",HOLDER)) Q:'HOLDER  I '$D(^XUSEC("PSJ RPHARM",HOLDER)),'$D(^XUSEC("PSJ PHARM TECH",HOLDER)) D @KEYF S PSJC=PSJC+1 W:'(PSJC#200) "."
 ;
KDONE ;
 K DA,DIC,DLAYGO,HOLDER,KEY,KEY1,KEY2,KEY3,KEYF,PSJC,PSJSF,Q,X,Y Q
 ;
1 ; laygo into key sub-file of 200
 K DA,DIC S:'$D(^VA(200,HOLDER,51,0)) ^VA(200,HOLDER,51,0)="^"_$P(^DD(200,51,0),"^",2)
 S DA(1)=HOLDER,DIC="^VA(200,"_HOLDER_",51,",DIC(0)="LM",DLAYGO=200.051,(DINUM,X)=KEY D FILE^DICN Q
 ;
2 ; laygo into holder sub-file of 19.1
 K DA,DIC S:'$D(^DIC(19.1,KEY,2,0)) ^DIC(19.1,KEY,2,0)="^"_$P(^DD(19.1,2,0),"^",2)
 S DA(1)=KEY,DIC="^DIC(19.1,"_KEY_",2,",DIC(0)="LM",DLAYGO=19.12,X=HOLDER D FILE^DICN Q
