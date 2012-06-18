APCLSRT1 ; IHS/CMI/LAB - APCLSRT SUBROUTINE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
SD W !!
 S %DT("A")="Start with what date: ",%DT="AEQ" D ^%DT
 I X=U S APCLQUIT="" Q
 I X="" S Y=X
 S APCLBEGD=Y
 S $P(FR,",",APCLN)=Y
 S %DT("A")="End with what date: ",%DT="AEQ" D ^%DT
 I X=U S APCLQUIT="" Q
 I X="" S Y=X
 I Y]"",APCLBEGD]"",APCLBEGD>Y W $C(7),$C(7),!!,"ENDING DATE MUST BE GREATER THAN START DATE!" G SD
 S $P(TO,",",APCLN)=Y
 Q
 ;
SA W !!
GAGE W "Start with what AGE: " R X:DTIME I '$T S APCLQUIT="" Q
 I X="" S Y=0 G GAGEA
 I X=U S APCLQUIT="" Q
 I X?1."?" W !,"Enter any AGE in years (including 0)",!! G GAGE
 I X'?1.3N W "  ??",$C(7),! G GAGE
GAGEA S Y=X,$P(FR,",",APCLN)=Y
SAGE ;S Y=X,Z=DT-(X*10000)
 W !
GAGE1 W "Go to what AGE: " R X:DTIME I '$T S APCLQUIT="" Q
 I X="" S X=188 G SAGE1
 I X=U S APCLQUIT="" Q
 I X?1."?" W !,"Enter any AGE in years (must be at least ",Y,")",!! G GAGE1
 I X?1.3N,X'<Y G SAGE1
 W "  ??",$C(7),! G GAGE1
SAGE1 S $P(TO,",",APCLN)=X
 ;S $P(FR,",",APCLN)=1+(DT-((X+1)*10000)),$P(TO,",",APCLN)=Z
 Q
 ;
SS W !!
 S %=$P(^APCLSRT(APCLSNO,0),U,5),X=$P(^(0),U,8),%=U_%_"0)",%=+$P(@%,U,2),%=^DD(%,X,0),APCLSET=";"_$P(%,U,3)
 W "Do you want to sort by a particular ",APCLSNA
 S %=2 D YN^DICN
 I %Y=U S APCLQUIT="" Q
 I "Nn"[$E(%Y) Q
 D SL
 I %Y?1."?" G SS
SSG W !!,"Your choice: " R X:DTIME I '$T S APCLQUIT="" Q
 I X=U S APCLQUIT="" Q
 I X="" Q
 I X?1."?" W !,"Type either the code or the text of the item you wish to select",!! G SSG
 S %=APCLSET,Y=$F(%,(";"_X))
 I Y S Z=$E(%,Y,99),Z=$P(Z,":",2),Z=$P(Z,";"),$P(FR,",",APCLN)=Z,$P(TO,",",APCLN)=Z W " = ",Z Q
 F I=2:1 S Z=$P(%,":",I) Q:Z=""  I $E(Z,1,$L(X))=X S Z=$P(Z,";"),$P(FR,",",APCLN)=Z,$P(TO,",",APCLN)=Z W $E(Z,$L(X)+1,99) Q
 I Z="" W "  ??",$C(7) G SSG
 Q
 ;
SL W !!,"You may select one of the following choices",!
 F I=2:1 S %=$P(APCLSET,";",I) Q:%=""  S X=$P(%,":"),Y=$P(%,":",2) W !?5,X," = ",Y
 Q
 ;
SP W !!
 S DIC=U_$P(^APCLSRT(APCLSNO,0),U,7)
 W "Do you want to sort by a particular ",APCLSNA
 S %=2 D YN^DICN
 I %Y=U S APCLQUIT="" Q
 I "Nn"[$E(%Y) Q
SPQ S DIC("A")="Which "_APCLSNA_": "
 I $D(APCLDM),DIC["41," S DIC("S")="I $P(^APCL(41,+Y,0),U)=APCLRG"
 S DIC(0)="AEMQ"
 D DIC K APCLDIC1
 I X=U S APCLQUIT="" Q
 I X="" Q
SPQ1 I BY["[" G SPQ11
 N X,Z,% S X=$L(BY,","),%=$P(BY,",",X)
 I %="" Q
 I %'[";" S BY=BY_":NUMBER="_+Y Q
 S Z=$P(%,";")
 S $P(%,";")=Z_":NUMBER="_+Y
 S $P(BY,",",X)=%
 Q
SPQ11 S FR=$P(Y,U,2),TO=FR_"z" Q
 ;
SF W !!
 W "Do you want to sort by a particular ",APCLSNA
 S %=2 D YN^DICN
 I %Y=U S APCLQUIT="" Q
 I "Nn"[$E(%Y) Q
SFQ S DIC("A")="Which "_APCLSNA_": "
 S DIC(0)="AEMQZ",DIC=APCLDIC
 I APCLSNA["CURRENT COMMUNITY" S DIC="^AUTTCOM("
 D DIC
 I X=U S APCLQUIT="" Q
 I X="" Q
 I FR="" S FR=Y(0,0)
 E  S FR=FR_","_Y(0,0)
 I TO="" S TO=Y(0,0)_"z"
 E  S TO=TO_","_Y(0,0)_"z"
 Q
DIC W ! D ^DIC K DIC Q
