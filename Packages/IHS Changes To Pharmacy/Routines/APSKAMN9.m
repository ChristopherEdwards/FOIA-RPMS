APSKAMN9 ;IHS/ANMC/SFB/MRS - CALC WITHOUT REGRESSION ANALY[ 09/28/94  10:54 AM ]
 ;;1.0;Aminoglycoside Kinetics;;OCT 31,1994
 S IOP=ION S %ZIS("B")=""
 D ^%ZIS
NOREG ;EP - DETERMINES DOSE AND INTERVAL WITHOUT A REGRESSION ANALYSIS.
 I APSKPTIN=0 D NOINFO^APSKAMN Q
 S APSKM=2
 W @IOF
 W !,"Please enter known or estimated parameters:"
 K DIR S DIR(0)="N" W !!
 S DIR("A")="Infusion rate (k0) in mg/hr"
 D ^DIR G END:$D(DIRUT) S APSKK0=Y
 K DIR S DIR(0)="N" W !!
 S DIR("A")="Length of infusion (T') in hr"
 D ^DIR G END:$D(DIRUT) S APSKT0=Y
 K DIR S DIR(0)="N^.1:5:1" W !!
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 S DIR("A")="Elimination rate constant (Kd) in hr-1"
 D ^DIR G END:$D(DIRUT)
 S APSKK1=Y
 I ($L(APSKK1)=2)&(APSKK1[".") S APSKK1=0_APSKK1
 K DIR S DIR(0)="N" W !!
 S DIR("A")="TOTAL volume of distribution (Vd) in liters"
 D ^DIR G END:$D(DIRUT) S APSKV1=Y
 S APSKK1=$P(APSKK1*100+.5,".",1)/100
 S APSKT1=0.693/APSKK1
 S APSKV2=APSKV1/APSKWT
 S APSKT1=$P(100*APSKT1+.5,".",1)/100
 S APSKV2=$P(100*APSKV2+.5,".",1)/100
 G DOSING^APSKAMN4
 ;
END Q
