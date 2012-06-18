LRMITRZA ;AVAMC/REG,SLC/BA- MICRO TREND SHEET ; 10/9/87  16:19 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
 ;from LRMITRZ
SBUG F I=0:0 S %=2 W !!,"Will all reports be for a single bacterium" D YN^DICN Q:%'=0  W !,"Do you want all antibiotic trend data for just one organism?"
 I %<0 S LREND=1 Q
 I %=1 S DIC="61.2",DIC(0)="AEMOQZ",DIC("A")="Select Bacterium: ",DIC("S")="I $P(^(0),U,5)=""B""" D ^DIC K DIC S:X=U LREND=1 Q:X=U  I Y>0 S LRSGL=+Y,LRM("O")="S",LRM("O","S")=LRSGL
LOS F I=0:0 W !!,"Number of days from patient's admission date to collection date of specimen",! R "to be excluded from all reports.  0// ",X:DTIME S:X="" X=0 Q:X[U!(X?1N.N)  W !,"Enter number of days to exclude."
 W ! I X[U S LREND=1 Q
 S LRLOS=X
AP K LRAP F I=0:0 W !!,"Will all reports require a specific antibiotic pattern" S %=2 D YN^DICN Q:%  W !,"You may restrict all reports to only those that have specific antibiotic",!,"interpretations."
 I %=-1 S LREND=1 Q
 I %=1 S DIC=62.06,DIC(0)="AEMOQZ",DIC("A")="Select Antibiotic: ",DIC("S")="I +$P(^(0),U,2),$L($P(^(0),U,5))" F I=0:0 D ^DIC Q:Y<1  S LRBN=$P(Y(0),U,2) F I=0:0 R !,"Select Interpretation: ",X:DTIME Q:X[U!'$L(X)  S LROK=0 D CHECK Q:LROK
PROMPT K DIC F LRASK="O","S","L","D","P","C" D:'(LRASK="O"&($D(LRSGL))) ASK Q:LREND
 Q
ASK S LRPROMPT=$S(LRASK="L":"Location",LRASK="O":"Organism",LRASK="D":"Physician",LRASK="P":"Patient",LRASK="C":"Collection Sample",1:"Site/Specimen") W !,"Report by:  ",LRPROMPT
 F I=0:0 W !,"(A)ll ",LRPROMPT,"s, (S)ingle ",LRPROMPT,", or (N)o ",LRPROMPT," Report? ",LRM(LRASK) R "// ",X:DTIME S:X="" X=LRM(LRASK) S:"ANS"[X LRM(LRASK)=X Q:X="A"!(X="N")!(X=U)  D:X'="S" INFO I X="S" D SINGLE Q
 I X=U S LREND=1 Q
 Q
SINGLE I LRASK="L" S DIC="44",DIC(0)="AEMOQZ",DIC("A")="Select Location: " D ^DIC K DIC Q:Y<1  S LRM(LRASK,"S")=$P(^SC(+Y,0),U,2) Q
 I LRASK="O" S DIC="61.2",DIC(0)="AEMOQZ",DIC("A")="Select Organism: ",DIC("S")="I $P(^(0),U,5)=""B""" D ^DIC K DIC Q:Y<1  S LRM(LRASK,"S")=+Y Q
 I LRASK="D" S DIC="6",DIC(0)="AEQMZ",DIC("A")="Select Physician: " D ^DIC K DIC Q:Y<1  S LRM(LRASK,"S")=$P(^DIC(16,+Y,0),U) Q
 I LRASK="S" S DIC="61" S DIC(0)="AEMOQZ",DIC("A")="Select Site/Specimen: " D ^DIC K DIC Q:Y<1  S LRM(LRASK,"S")=$P(^LAB(61,+Y,0),U) Q
 I LRASK="P" K DIC,DFN S DIC(0)="EMQZ",PNM="" D ^LRDPA Q:LRDFN=-1!($D(DUOUT))!($D(DTOUT))  S LRM(LRASK,"S")=PNM Q
 I LRASK="C" S DIC="62" S DIC(0)="AEMOQZ",DIC("A")="Select Collection Sample: " D ^DIC K DIC Q:Y<1  S LRM(LRASK,"S")=$P(^LAB(62,+Y,0),U)
 Q
CHECK I '$D(^LAB(62.06,"AJ",LRBN,X)) W:X'="?" !,"Not an interpretation for this antibiotic." S J=0 W !,"You must use:" F I=0:0 S J=$O(^LAB(62.06,"AJ",LRBN,J)) Q:J=""  W !,?5,J
 I $D(^LAB(62.06,"AJ",LRBN,X)) S LROK=1,LRAP(LRBN)=X
 Q
INFO W !,"Select 'A' to obtain a report grouped by all ",LRPROMPT,"s.",!,"Select 'S' to obtain a report grouped for only one ",LRPROMPT,".",!,"Select 'N' if you DO NOT want a report grouped by ",LRPROMPT,".",!,"'^' to exit",!
 Q
