FHASM4 ; HISC/REL/JH - Laboratory/Drug Data ;12/5/00  10:41
 ;;5.0;Dietetics;**18,21,26,30**;Oct 11, 1995
 S PX=3 D LAB G ^FHASM5
LAB ; Collect lab results
 K LRTST,^TMP($J,"LRTST") Q:'DFN
 S LRDFN=$P($G(^DPT(DFN,"LR")),"^",1) G:'LRDFN LKIL
 W:PX=3 !!,"Collecting laboratory data ... " D GET
 S X2=-$S($D(^FH(119.9,1,3)):$P(^(3),"^",2),1:90)
 S %DT="X",X="T" D ^%DT S DT=+Y,X1=DT D C^%DTC S A1=9999999-X
 F K=0:0 S K=$O(^LR(LRDFN,"CH",K)) Q:K<1!(K>A1)  F L=0:0 S L=$O(^LR(LRDFN,"CH",K,L)) Q:L'>0  I $D(LRTST(L)) S X=^(L) D STR
 S %=100 F L=0:0 S L=$O(LRTST(L)) Q:L'>0  F SP=0:0 S SP=$O(LRTST(L,SP)) Q:SP'>0  D
 .I $P(LRTST(L,SP),"^",6)="" K LRTST(L,SP) Q
 .S %=%+1,^TMP($J,"LRTST",$S($P(LRTST(L,SP),"^",8)'="":$P(LRTST(L,SP),"^",8),1:%))=LRTST(L,SP) Q
 K LRTST F L=0:0 S L=$O(^TMP($J,"LRTST",L)) Q:L<1  S LRTST(L)=^(L)
LKIL K %,%H,%I,%T,%DT,A1,FLG,GRP,HI,K,L,LO,LRCW,LRDFN,P60,PC,SP,THER,TNAM,TST,X,X0,X1,X2,Y Q
STR ;
 S SP=$P($G(^LR(LRDFN,"CH",K,0)),"^",5) Q:'SP
 I '$D(LRTST(L,SP)) Q
 I $P(LRTST(L,SP),"^",6)'="" Q
 S P60=$P(LRTST(L,SP),"^",2),SP=$P(LRTST(L,SP),"^",3),GRP=$P(LRTST(L,SP),"^",8)
 S FLG=$P(X,"^",2),X=$P(X,"^",1) Q:X=""  S PC=$P($G(^LAB(60,P60,.1)),"^",3)
 S LRCW=8 I PC="" S X=$J(X,LRCW)
 E  S @("X="_PC)
 S:FLG'="" X=X_" "_FLG
 S $P(LRTST(L,SP),"^",6,7)=X_"^"_(9999999-K)
 I GRP F %=0:0 S %=$O(LRTST(%)) Q:%=""  F P60=0:0 S P60=$O(LRTST(%,P60)) Q:P60=""  I $P(LRTST(%,P60),"^",8)=GRP,'(%=L&(P60=SP)) D
 .I $P(LRTST(L,SP),"^",7)>$P(LRTST(%,P60),"^",7) K LRTST(%,P60) Q
 .K LRTST(L,SP) Q
 Q
GET ; Get Lab Tests of interest from Site Parameter file
 F K=0:0 S K=$O(^FH(119.9,1,"L",K)) Q:K'>0  S X=^(K,0) I 'PX!($P(X,"^",PX)="Y") D G1
 Q
G1 S P60=+$P(X,"^",1),SP=$P(X,"^",2),GRP=$P(X,"^",5) Q:'SP  S X0=$G(^LAB(60,P60,0)) Q:X0=""
 S X1=$G(^LAB(60,P60,.1)),TST=$P($P(X0,"^",5),";",2) Q:'TST
 S TNAM=$P(X0,"^",1) I $L(TNAM)>20 S TNAM=$P(X1,"^",1)
 S X=$G(^LAB(60,P60,1,SP,0)) Q:'$L(X)  S THER=$S($L($P(X,U,11,12))>1:1,1:0) S LO=$S(THER:$P(X,U,11),1:$P(X,U,2)),HI=$S(THER:$P(X,U,12),1:$P(X,U,3))
 S @("LO="_$S($L(LO):LO,1:"""""")),@("HI="_$S($L(HI):HI,1:""""""))
 S LRTST(TST,SP)=TNAM_"^"_P60_"^"_SP_"^"_$P(X,"^",7)_"^"_$J(LO,4)_$S($L(HI):" - "_$J(HI,4),1:"")_"^^^"_GRP Q
DRUG ; Collect requested drugs 0=Outpatient 1=Inpatient
 K PC,PSD F K=0:0 S K=$O(^FH(119.9,1,"P",K)) Q:K'>0  S X=$P(^(K,0),"^",1),CLS=$E($P($G(^PS(50.605,+X,0)),"^",1),1,3) I CLS'="" S:$E(CLS,3)="0" CLS=$E(CLS,1,2) S PC(CLS)=""
 G:'$D(PC) PKIL D NOW^%DTC K PSD I 'PX D OUTP G PKIL
 F STRT=%:0 S STRT=$O(^PS(55,DFN,5,"AUS",STRT)) Q:'STRT  F PSORD=0:0 S PSORD=$O(^PS(55,DFN,5,"AUS",STRT,PSORD)) Q:'PSORD  D D1
PKIL K %,%H,%I,CLS,DRG,K,PC,PSORD,STRT,X Q
OUTP F STRT=(%\1)-1:0 S STRT=$O(^PS(55,DFN,"P","A",STRT)) Q:STRT'>0  F JX=0:0 S JX=$O(^PS(55,DFN,"P","A",STRT,JX)) Q:JX'>0  D
 . S X=JX D EN^PSOORDER(DFN,X)
 . S CLS=$P($P($G(^TMP("PSOR",$J,JX,0)),"^",4),";",1) I CLS'="A",CLS'="H",CLS'="S" Q
 . S DRG=$P($P($G(^TMP("PSOR",$J,JX,"DRUG",0)),U),";") D:DRG D2
 . Q
 Q
D1 S DRG=$P($G(^PS(55,DFN,5,PSORD,1,1,0)),"^",1) Q:'DRG
D2 S CLS=$P($G(^PSDRUG(DRG,0)),"^",2) Q:CLS=""  I '$D(PC($E(CLS,1,2))),'$D(PC($E(CLS,1,3))) Q
 S PSD(DRG)=$P(^PSDRUG(DRG,0),"^") Q
