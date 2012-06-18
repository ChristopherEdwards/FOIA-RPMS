LRWU1 ;DALOI/RWF/FHS/RLM-ORDERING/ACCESSION UTILITIES ;6/5/89 16:25 [ 04/25/2003  9:03 AM ]
 ;;5.2;LR;**1004,1018,1020**;Sep 13, 2005
 ;;5.2;LAB SERVICE;**153,272**;Sep 27, 1994
 ; Reference to ^DIC supported by IA #10007
 ; Reference to ^%DT supported by IA #10003
 ; Reference to YN^DICN supported by IA #10009
 ; Reference to INP^VADPT supported by IA #10061
 ; Reference to ^VA(200 supported by IA #10060
 ;
URGG W !,"For ",$P(LRSTIK(LRSSX),U,2) D URG^LRORD2 Q
MICRO W !,"Is there one sample for this patient's order" S %=1 D YN^DICN I %=2!(%=-1) Q
 I %=0 W !,"The collection sample and site/specimen will be used for all tests ordered",!,"at this time for this patient." G MICRO
 D GSNO^LRORD3 Q:LREND
 I +LRSAMP=-1&(LRSPEC=-1) W !,"Incompletely defined." G MICRO
 S LRSAME=LRSAMP_U_LRSPEC
 S LRECOM=0 D GCOM^LRORD2
 Q
TIME ;
 S %DT="ET" R !,"Collection Date@Time: NOW//",X:DTIME I '$T!(X="^") S LRCDT=-1 G TE
 S:X="" X="N"
 W:X["?" !!,"You may enter ""T@U"" or just ""U"", for Today at Unknown time",!!
 I X["@U",$P(X,"@U",2)="" S X=$P(X,"@U",1) D ^%DT G TIME:Y<1 S LRCDT=+Y_"^1" G TE
 S:X="U" LRCDT=DT_"^1"
 I X'="U" D ^%DT G TIME:X["?" S LRCDT=+Y_"^" G TIME:Y'["."
TE K %DT Q
PRAC ;
 I $G(LRORDRR)="R" D  Q
 . S LRPRAC="REF:"_+LRRSITE("RSITE")
 N %
 D:'$D(LRPARAM) ^LRPARAM K DIC S LREND=0,(VA200,DIC("B"))=""
 S DFN=$P(^LR(LRDFN,0),U,3) S LRDPF=$P(^LR(LRDFN,0),U,2)
 I LRDPF=2,$L($G(VAIN(2))) S DIC("B")=$P(VAIN(2),U)
 I LRDPF=2,'$D(VAIN(2)) D
 .; N I,Y,X,N D INP^VADPT S (DIC("B"),LRPRAC)=$P(VAIN(2),U)
 .;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 . ;N I,Y,X,N D INP^BLRDPT S (DIC("B"),LRPRAC)=$P(VAIN(2),U)  ;IHS/DIR TUC/AAB 06/25/98
 . N I,Y,X,N D @$S($$ISPIMS^BLRUTIL:"INP^VADPT",1:"INP^BLRDPT") S (DIC("B"),LRPRAC)=$P(VAIN(2),U)
 .;----- END IHS MODIFICATIONS
 I $D(LRLABKY),'DIC("B"),$P(LRPARAM,U,16) S DIC("B")=$S($D(^LR(LRDFN,.2)):+^(.2),1:"")
P1 I $D(^VA(200,+DIC("B"),0))#2 S:'$D(^VA(200,"AK.PROVIDER",$P($G(^VA(200,+DIC("B"),0)),U))) DIC("B")=""
 S DIC("B")=$P($G(^VA(200,+DIC("B"),0)),U) D P S:Y>0 (^LR(LRDFN,.2),LRPRAC)=+Y
 Q
 ;----- BEGIN IHS/OIT/MKK MODIFICATIONS LR*5.2*1020 - Use IHS Version of $$ACTIVE
P ; S DIC="^VA(200,",DIC(0)="AMNEQ",DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U))),$$ACTIVE^XUSER(Y)",LRPRAC="",DIC("A")="PROVIDER: ",D="AK.PROVIDER"
 S DIC="^VA(200,",DIC(0)="AMNEQ",DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P(^(0),U))),$$ACTIVE^BLRUTIL2(Y)",LRPRAC="",DIC("A")="PROVIDER: ",D="AK.PROVIDER"
 ;----- END IHS/OIT/MKK MOD LR*5.2*1020
 S DIC("W")="Q" D ^DIC K DIC G:Y<0 QUIT S LRPRAC=+Y
 Q
QUIT S LREND=1 Q
