A4A7PCH5 ;SF-ISC/RWF - PATCH FOR NEW PERSON FILE ;9/25/91  16:27 ;
 ;;A4A7*1.01*5;
A W !!,"NEW PERSON FILE PATCH 5",!,"First run the 'A4B7INIT'" D ^A4B7INIT
 S U="^" W !!,"Now to see that next entries will get the same number in 3-16-200"
 S X=$$MAX($P(^DIC(3,0),U,3),$$MAX($P(^DIC(16,0),U,3),$P(^VA(200,0),U,3)))
 S $P(^DIC(3,0),U,3)=X,$P(^DIC(16,0),U,3)=X,$P(^VA(200,0),U,3)=X
 W !!,"Now to make the DUZ field in file 3 uneditable"
 I $D(^DD(3,.001,0)),$P(^(0),U,2)'["I" S $P(^(0),U,2)=$P(^(0),U,2)_"I"
 D PROV
 Q
PROV W !,"Give active providers the 'PROVIDER' key",!,"Add the Key" K DIC,DIK,DIE,DA
 S X="PROVIDER",DIC="^DIC(19.1,",DIC(0)="ML",DLAYGO=19 D ^DIC S XUKEY=+Y
 Q:XUKEY'>0
 S DR=".03///l;.04///YES",DIE=DIC,DA=XUKEY D ^DIE
 W !,"Now give keys  ."
 F DA6=0:0 S DA6=$O(^DIC(6,DA6)) Q:DA6'>0  I $D(^(DA6,0)) S DA16=+^(0),%=$G(^("I")),DA200=$G(^DIC(16,DA16,"A3")) I $S(%:%>DT,1:1),DA200>0 D PR2
 Q
PR2 I $D(^VA(200,DA200,0))[0 S ^VA(200,DA200,0)=$P(^DIC(16,DA16,0),"^") S:'$D(^DIC(3,DA200,0))[0 ^DIC(3,DA200,0)=^VA(200,DA200,0),$P(^DIC(3,DA200,0),"^",16)=DA16
 I $D(^DIC(19.1,"D",DA200,XUKEY)) Q
 K DD,DO S DIC="^DIC(19.1,XUKEY,2,",DIC("P")=19.12,DA(1)=XUKEY,X=DA200,DIC(0)="ML" D FILE^DICN W:$P(Y,U,3) "."
 Q
MAX(A,B) ;
 S:A["." A=A\1+1 S:B["." B=B\1+1
 Q $S(A>B:A,1:B)
