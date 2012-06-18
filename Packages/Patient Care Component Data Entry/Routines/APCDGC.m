APCDGC ; IHS/CMI/LAB - DATA ENTRY ENTER MODE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;;
 ;;PLEASE NOTE:  This routine was given to me by Cameron Schlehuber (VA).
 ;;I copied it into APCDGC so I could distribute it with the APCD package.
 ;;file 882 if from the VA, PED is a VA namespace.
 ;;
 ;;
 ;^APCDPED(D0,0)= (#.01) NAME [1F] ^ 
 ;^APCDPED(D0,1,0)=^882.01SA^^  (#1) SEX
 ;^APCDPED(D0,1,D1,0)= (#.01) SEX [1S] ^ 
 ;^APCDPED(D0,1,D1,1,0)=^882.11^^  (#1) AGE or LENGTH or HEIGHT
 ;^APCDPED(D0,1,D1,1,D2,0)= (#.01) AGE or LENGTH or HEIGHT [1N] ^ 
 ;^APCDPED(D0,1,D1,1,D2,1,0)=^882.111^^  (#1) PERCENTILE
 ;^APCDPED(D0,1,D1,1,D2,1,D3,0)= (#.01) PERCENTILE [1N] ^ (#1) VALUE [2N] ^ 
 ;^APCDPED(D0,1,D1,1,D2,2)= (#2) L  [1N] ^ (#3) M  [2N] ^ (#4) S  [3N] ^ 
 ; D0 = 1 WTAGEINF - WEIGHT AGE INFANT
 ; D0 = 2 LENAGEINF - LENGTH FOR AGE INFANT
 ; D0 = 3 WTLENINF - WEIGHT FOR RECUMBENT LENGTH
 ; D0 = 4 HCAGEINF - HEAD CIRCUMFERENCE FOR AGE
 ; D0 = 5 WTSTAT - WEIGHT FOR STATURE
 ; D0 = 6 WTAGE - WEIGHT FOR AGE
 ; D0 = 7 STATAGE - STATURE FOR AGE
 ; D0 = 8 BMIAGE - BODY MASS INDEX FOR AGE
CHART ;EP
 N AGEL,AIEN,CHART,DIR,DIRUT,ECHO,L,M,P,S,SEX,WT,X,Y,Z
 S DIR(0)="SO^1:WEIGHT FOR AGE INFANT;2:LENGTH FOR AGE INFANT;3:WEIGHT FOR RECUMBENT LENGTH;4:HEAD CIRCUMFERENCE FOR AGE;5:WEIGHT FOR STATURE;6:WEIGHT FOR AGE;7:STATURE FOR AGE;8:BODY MASS INDEX FOR AGE"
 S DIR("A")="Growth Chart" D ^DIR Q:$D(DIRUT)  S CHART=Y,ECHO=Y(0)
 S DIR(0)="SO^1:MALE;2:FEMALE"
 S DIR("A")="Sex" D ^DIR G:$D(DIRUT) CHART S SEX=Y
 I "124678"[CHART D
 . S DIR(0)="NO^"_$S("124"[CHART:0,CHART=3:45,CHART=5:77,"678"[CHART:24)_":"_$S("14"[CHART:36,CHART=2:36.9,CHART=3:103.9,CHART=5:121.9,"678"[CHART:240)_":1"
 . S DIR("A")="Age in months" D ^DIR Q:$D(DIRUT)
 . S AGEL=$S(CHART=1&(Y=0!(Y=36)):Y,CHART=3&(Y=45):Y,CHART=5&(Y=77):Y,"678"[CHART&(Y=24!(Y=240)):Y,1:$P(Y,".")+.5) W !!,"Age approximated to ",AGEL," months."
 G:$D(DIRUT) CHART
 I CHART=3 D
 . S DIR(0)="NO^45:103.9:1"
 . S DIR("A")="Length in centimeters" D ^DIR Q:$D(DIRUT)  S AGEL=$P(Y,".")+.5 W !!,"Length approximated to ",AGEL," centimeters."
 G:$D(DIRUT) CHART
 I CHART=5 D
 . S DIR(0)="NO^77:121.9:1"
 . S DIR("A")="Height in centimeters" D ^DIR Q:$D(DIRUT)  S AGEL=$P(Y,".")+.5 W !!,"Height approximated to ",AGEL," centimeters."
 G:$D(DIRUT) CHART
 S AIEN=+$O(^APCDPED(CHART,1,SEX,1,"B",AGEL,"")) I '$D(^APCDPED(CHART,1,SEX,1,AIEN,0)) W !,"Not on the chart." G CHART
 I "13568"[CHART S DIR(0)="NO^.1:90:3",DIR("A")="Weight in kilograms" D ^DIR G:$D(DIRUT) CHART S X=Y G:CHART'=8 COMPUTE S:CHART=8 WT=X
 I CHART=2 S DIR(0)="NO^40:110:1",DIR("A")="Length in centimeters" D ^DIR G:$D(DIRUT) CHART S X=Y G COMPUTE
 I CHART=4 S DIR(0)="NO^28:60:1",DIR("A")="Head circumference in centimeters" D ^DIR G:$D(DIRUT) CHART S X=Y G COMPUTE
 I "78"[CHART S DIR(0)="NO^75:200:1",DIR("A")="Height in centimeters" D ^DIR G:$D(DIRUT) CHART S X=Y G:CHART'=8 COMPUTE
 I CHART=8 S X=10000*WT/(X**2) W !!,"Body Mass Index is ",$J(X,1,2)
 ;I CHART=8 S DIR(0)="NO^12:40:1",DIR("A")="Body Mass Index (killograms/meters squared)" D ^DIR G:$D(DIRUT) CHART S X=Y G COMPUTE
COMPUTE S L=$P(^APCDPED(CHART,1,SEX,1,AIEN,2),U),M=$P(^(2),U,2),S=$P(^(2),U,3)
 S Z=(((X/M)**L)-1)/(L*S)
 ;And from P=1-1/SQRT(2*3.14159265)*EXP(-(ABS(Z)**2)/2)*(0.4361836*(1/(1+0.33267*ABS(Z)))-0.1201676*(1/(1+0.33267*ABS(Z)))**2+0.937298*(1/(1+0.33267*ABS(Z)))**3)
 S P=1-((1/$$SQRT^XLFMTH(2*3.14159265))*$$EXP^XLFMTH(-($$ABS^XLFMTH(Z)**2)/2)*(0.4361836*(1/(1+(0.33267*$$ABS^XLFMTH(Z))))-(0.1201676*((1/(1+(0.33267*$$ABS^XLFMTH(Z))))**2))+(0.937298*((1/(1+(0.33267*$$ABS^XLFMTH(Z))))**3))))
 I Z>0 S P=P*100
 E  S P=100-(P*100)
 W !!,"Percentile for ",ECHO," is ",$J(P,1,1)
 G CHART
