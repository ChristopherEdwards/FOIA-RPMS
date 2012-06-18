APSKAMN4 ;IHS/ANMC/SFB/MRS - CALC MIN & MAX SERUM CONC.,DOSING INTERVALS & RATE; [ 09/28/94  10:51 AM ]
 ;;1.0;Aminoglycoside Kinetics;;OCT 31,1994
 ;
DOSING ;EP - USER ENTER'S MINIMUM AND MAXIMUM SERUM CONCENTRATIONS
 W @IOF
MIN ;EP
 K DIR S DIR(0)="N^.1:2:1"
 S DIR("A")="desired MINIMUM serum concentration in MCG/ML"
 S DIR("?")="To enter 0.1 -0.9, do not enter the 0.  Ex. .1, .2, etc"
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT),MIN:Y=-1 K DIR
 S APSKC2=Y
 I ($L(APSKC2))=2&(APSKC2[".") S APSKC2=APSKC2=0_APSKC2
MAX ;EP - User enter's Max serum concentration
 K DIR S DIR(0)="N^1:10:1" W !!
 S DIR("A")="desired MAXIMUM serum concentration in MCG/ML"
 S DIR("?")="Required response. Enter '^' to exit"
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT),MAX:Y=-1 K DIR
 S APSKC3=Y
 I APSKC3<APSKC2 D ERROR1 G MAX
 ;
INFUSTM ;===>ENTER INFUSION TIME IN HOURS
 ;===>CALCULATES 'EXACT' DOSING INTERVAL AND 'EXACT' INFUSION RATE
 K DIR S DIR(0)="N^.1:24:2" W !!
 S DIR("A")="recommended infusion time in HOURS (T')"
 S DIR("?")="Required response. Enter '^' to exit"
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT),INFUSTM:Y=-1 K DIR S APSKT0=Y
 S APSKXX=(APSKC2/APSKC3) D LN^APSKAMN6
 S APSKT2=((-APSKLNN)/APSKK1)+APSKT0
 S APSKT2=$P(100*APSKT2+.5,".",1)/100
 W !!!,"To maintain the ratio of MAX to MIN serum conc. that you"
 W !,"have specified, the EXACT dosing interval would be ",APSKT2," hours"
DI W !!! K DIR S DIR(0)="N"
 S DIR("A")="Please enter a clinically acceptable dosing interval (in hrs)"
 S DIR("?")="Required response. Enter '^' to exit"
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT),DI:Y=-1 K DIR S APSKT3=Y
 S APSKXX=(-APSKK1*APSKT3) D EXP^APSKAMN6 S APSKEE1=1-APSKEE
 S APSKXX=(-APSKK1*APSKT0) D EXP^APSKAMN6 S APSKEE2=1-APSKEE
 S APSKK2A=APSKK1*APSKV1*APSKC3*(APSKEE1/APSKEE2)
 S APSKK2=$P(100*APSKK2A+.5,".",1)/100
 W !!,"Assuming ",APSKT3," hour dosing, the EXACT infusion rate to produce"
 W !,"peak serum levels of ",APSKC3," mcg/ml is ",APSKK2," mg/hour given"
 W !,"over a ",APSKT0," hour period."
IR K DIR W !!! S DIR(0)="N"
 S DIR("A")="Please enter a clinically acceptable infusion rate (in mg/hr)"
 S DIR("?")="Required response. Enter '^' to exit"
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT),IR:Y=-1 K DIR S APSKK3=Y
 G LOOP^APSKAMN5
ERROR1 W !!
 W !,"The Maximum serum concentration you entered is less"
 W !,"than the Minimum serum concentration.  Please enter"
 W !,"a new Maximum serum concentration",!!
 Q
 ;
END Q
