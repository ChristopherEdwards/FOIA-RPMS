ACMSRT1 ; IHS/TUCSON/TMJ - ACMSRT SUBROUTINE ;
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
SD I BY["DATE LAST PRINTED" S FR=FR_",",TO=TO_"," Q
 W !!
 S %DT("A")="Start with what date: ",%DT="AEQ" D ^%DT
 I X=U S ACMQUIT="" Q
 I X="" S Y=X
 S $P(FR,",",ACMN)=Y
 S %DT("A")="End with what date: ",%DT="AEQ" D ^%DT
 I X=U S ACMQUIT="" Q
 I X="" S Y=X
 S $P(TO,",",ACMN)=Y
 Q
 ;
SA W !!
GAGE S DIR(0)="NOA^0:120",DIR("A")="Start with what AGE: ",DIR("?")="Enter any AGE in years (including 0)"
 D ^DIR K DIR
 I $E(X)=U S ACMQUIT="" Q
 I X="" S Y=0
 S ACMYX=Y
GAGEA S $P(FR,",",ACMN)=Y
SAGE W !
GAGE1 S DIR(0)="NOA^0:120",DIR("A")="Go to what AGE: ",DIR("?")="Enter any AGE in years (must be at least "_ACMYX_")"
 D ^DIR K DIR
 I $E(X)=U S ACMQUIT="" Q
 I X="" S Y=188
 S ACMYX=Y
SAGE1 S $P(TO,",",ACMN)=Y
 Q
 ;
SS W !!
 S %=$P(^ACM(48.5,ACMSNO,0),U,5),ACMYX=$P(^(0),U,8),%=U_%_"0)",%=+$P(@%,U,2),%=^DD(%,ACMYX,0),ACMSET=";"_$P(%,U,3)
 W "Do you want to sort by a particular ",ACMSNA
 S %=2 D YN^DICN
 I %Y=U S ACMQUIT="" Q
 I "Nn"[$E(%Y) Q
 D SL
 I %Y?1."?" G SS
SSG S DIR(0)="FOA^1:10",DIR("A")="Your choice: ",DIR("?")="Type either the code or the text of the item you wish to select"
 D ^DIR K DIR
 I U[$E(X) S ACMQUIT="" Q
 Q:X=""
 S ACMYX=Y
 S %=ACMSET,Y=$F(%,(";"_ACMYX))
 I Y S ACMYZ=$E(%,Y,99),ACMYZ=$P(ACMYZ,":",2),ACMYZ=$P(ACMYZ,";"),$P(FR,",",ACMN)=ACMYZ,$P(TO,",",ACMN)=ACMYZ W " = ",ACMYZ Q
 F ACMI=2:1 S ACMYZ=$P(%,":",ACMI) Q:ACMYZ=""  I $E(ACMYZ,1,$L(ACMYX))=ACMYX S ACMYZ=$P(ACMYZ,";"),$P(FR,",",ACMN)=ACMYZ,$P(TO,",",ACMN)=ACMYZ W $E(ACMYZ,$L(ACMYX)+1,99) Q
 I ACMYZ="" W "  ??",*7 G SSG
 Q
 ;
SL W !!,"You may select one of the following choices",!
 F ACMI=2:1 S %=$P(ACMSET,";",ACMI) Q:%=""  S ACMYX=$P(%,":"),Y=$P(%,":",2) W !,?5,ACMYX," = ",Y
 Q
 ;
SP W !!
 S DIC=U_$P(^ACM(48.5,ACMSNO,0),U,7)
 S ACMDIC1=U_$P($P(ACMNAV,U,7),",")_")"
 W "Do you want to sort by a particular ",ACMSNA
 S %=2 D YN^DICN
 I %Y=U S ACMQUIT="" Q
 I "Nn"[$E(%Y) Q
SPQ S DIC("A")="Which "_ACMSNA_": "
 I '$P(^ACM(41.1,ACMRG,0),U,8) S:ACMDIC'=41&(ACMDIC'=46)&(ACMDIC'=57)&(ACMDIC'=50)&(DIC'["DPT")&(DIC'["AUTT")&(DIC'["VA")&(ACMDIC1'["^ACM(42.3") DIC("S")="I $D(@ACMDIC1@(+Y,""RG"",""B"",ACMRG))"
 I $D(ACMDM),DIC["41," S DIC("S")="I $P(^(0),U)=ACMRG"
 I $D(ACMDM),DIC["DPT" S DIC("S")="I $D(^ACM(41,""AC"",+Y,ACMRG))"
 S DIC(0)="AEMIQZ"
 N I D DIC K ACMDIC1
 I X=U S ACMQUIT="" Q
 I X="" Q
SPQ1 I BY["[" G SPQ11
 N ACMYX,ACMYZ,% S ACMYX=$L(BY,","),%=$P(BY,",",ACMYX)
 I %="" Q
 I %'[";" S BY=BY_":NUMBER="_+Y Q
 S ACMYZ=$P(%,";")
 S $P(%,";",1)=ACMYZ_":NUMBER="_+Y
 S $P(BY,",",ACMYX)=%
 Q
SPQ11 S FR=$P(Y,U,2),TO=FR_"z" Q
 ;
SF W !!
 W "Do you want to sort by a particular ",ACMSNA
 S %=2 D YN^DICN
 I %Y=U S ACMQUIT="" Q
 I "Nn"[$E(%Y) Q
SFQ S DIC("A")="Which "_ACMSNA_": "
 S DIC(0)="AEMQZ",DIC=ACMDIC
 I ACMSNA["CURRENT COMMUNITY" S DIC="^AUTTCOM("
 I ACMSNA["REGISTER-" S DIC="^ACM(41.1,"
 D DIC
 I X=U S ACMQUIT="" Q
 I X="" Q
 I ACMSNA["REGISTER-" S FR=Y(0,0),TO=FR_"z" Q
 I FR="" S FR=Y(0,0)
 E  S FR=FR_","_Y(0,0)
 I TO="" S TO=Y(0,0)_"z"
 E  S TO=TO_","_Y(0,0)_"z"
 Q
DIC W ! D ^DIC K DIC Q
EXIT ;EP;TO KILL VARIABLES
 K ACMYX,Y,ACMYZ,%Y,%DT,ACMZ,ACMZZ,ACMDIC,ACMN,ACMPTMP,BY,FR,TO,FLDS,I
 K ACMSNO,ACMSNA,ACMU,ACMUB,ACMXZ,ACMQUIT,ACMJ1,ACMUB,ACMU,ACMYII
 K ACMX,ACMY,ACMRPT,ACMSET,ACMMAND,ACMCSTG,ACMMANN,ACMMAN,ACMFILE,ACMSRT
 K APCRREG,APCRREGP,APCRN,APCHSPAT,APCHSTYP,ACMYZ
 D ^%ZISC
 S IOP=ION D ^%ZIS Q
PS ;EP - called from acmsrt
 S DIR(0)="SOA^P:Patient;S:Statistical",DIR("A")="     'P'atient or 'S'tatistical report? ==> ",DIR("?")="Enter 'P' for patient or 'S' for statistical reports"
 W !
 D ^DIR K DIR
 I U=$E(X)!(X="") S ACMQUIT="" Q
 S ACMX=Y
 Q:ACMX="P"
 S FLDS="[ACM "_ACMRPT_" COUNT]"
 F ACMJ="@","#" I $D(BY),BY[ACMJ F ACMI=0:0 S ACMBY1=$P(BY,ACMJ),ACMBY2=$P(BY,ACMJ,2),BY=ACMBY1_ACMBY2 Q:BY'[ACMJ
 I $D(BY) S ACMBC=$L(BY,",") F ACMJ=1:1:ACMBC S $P(BY,",",ACMJ)="+"_$P(BY,",",ACMJ)
 K ACMX,ACMBC
 Q
