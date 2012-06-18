AICDGRP2 ; IHS/OHPRD/GIS - SUPERGROUPER DRGs REG-DAK/AVAMC 2/27/83 ;
 ;;3.51;IHS ICD/CPT lookup & grouper;;MAY 30, 1991
 ;ADT VERSION 3.32 ;FEB 15 1986
 ; MODIFIED AGAIN BY GIS/IHS/TPA 1/4/87 AND 6/6/88
 ;
 K AICDQUIT
ASK R !!,"Age: ",AGE:60 G QQ:"^"[AGE!('$T) G ASK:'+AGE
SEX R !,"Sex (M or F): ",SEX:60 G QQ:"^"[SEX!('$T) I SEX'="M"&(SEX'="F") W *7,!!,"Enter M for male or F for female" G SEX
CHECK W !,"Did patient die, transfer, or sign out AMA" S %=2 D YN^DICN G QQ:%<0 I '% W !,"Answer Yes or No" G CHECK
 I %=2 S (EXP,TRS,DAM)=0 Q
ALIVE W !,"Did patient die during this episode" S %=2 D YN^DICN G QQ:X=%<0 I '% W !,"Answer Yes or No" G ALIVE
 S EXP=$S(%=1:1,1:0) K DGFLG I EXP=1 S (TRS,DAM)=0 Q
TRS W !,"Discharge to transfer" S %=2 D YN^DICN G QQ:%<0 I '% W !!,"Enter 'Y' if the patient was discharged to transfer, 'N' if not.",!,*7 G TRS
 S TRS=$S(%=1:1,1:0),TAC=0 G DAM:'TRS
TAC W !,"Transfer to an acute care facility" S %=2 D YN^DICN G QQ:%<0 I '% W !!,"Enter 'Y' if the patient was transfered to an acute care facility, 'N' if not.",!,*7 G TAC
 S TAC=$S(%=1:1,1:0) Q
DAM W !,"Discharged against medical advice" S %=2 D YN^DICN G QQ:%<0 I '% W !!,"Enter 'Y' if the patient left against medical advice, 'N' if not.",!,*7 G DAM
 S DAM=$S(%=1:1,1:0)
 Q:$D(DGFLG)
 Q
Q S DGQU=1 Q
QQ S AICDQUIT="" Q
