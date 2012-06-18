APSKAMN7 ;IHS/ANMC/SFB/MRS - RECIEVES POST INFUSIONS [ 09/28/94  10:52 AM ]
 ;;1.0;Aminoglycoside Kinetics;;OCT 31,1994
 S IOP=ION  S %ZIS("B")=""
 D ^ZIS
POST ;EP - POST INFUSION SAMPLES
 W @IOF
 I APSKPTIN=0 D NOINFO^APSKAMN Q
 K DIR S DIR(0)="N^2:5" W !
 S DIR("A")="How many post infusion samples do you have"
 D ^DIR G END:$D(DIRUT) S APSKS(1)=Y
 ;===>USER INPUTS THE TIME AND CONCENTRATION OF EACH
 ;===>ONE OF THE POST INFUSION SAMPLES.
POST1 W !! K %DT S %DT="AER",%DT("A")="Time of first sample: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G POST1
 S APSKZ3T=Y
 S APSKZ(3)=$P(Y,"@",2)
 I APSKZ1T=APSKZ3T W !,"First and Start times are the same." D SAMETM G POST1
 I APSKZ2T=APSKZ3T W !,"First and End times are the same." D SAMETM G POST1
 I APSKZ13T=APSKZ3T W !,"First and PRE LEVEL times are the same." D SAMETM G POST1
 K DIR S DIR(0)="N^.1:20:1" W !
 S DIR("A")="Conc of first sample"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT) G POST1:Y=""
 S APSKC(3)=Y
 I ($L(APSKC(3))=2)&(APSKC(3)[".") S APSKC(3)=APSKC(3)
POST2 W !! K %DT S %DT="AER",%DT("A")="Time of second sample: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G POST2
 S APSKZ4T=Y
 S APSKZ(4)=$P(Y,"@",2)
 I APSKZ1T=APSKZ4T W !,"Second and Start times are the same." D SAMETM G POST2
 I APSKZ2T=APSKZ4T W !,"Second and End times are the same." D SAMETM G POST2
 I APSKZ3T=APSKZ4T W !,"First and Second times are the same." D SAMETM G POST2
 I APSKZ13T=APSKZ4T W !,"Second and PRE LEVEL times are the same." D SAMETM G POST2
 K DIR S DIR(0)="N^.1:20:1" W !
 S DIR("A")="Conc of second sample"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT) G POST2:Y=""
 S APSKC(4)=Y
 I ($L(APSKC(4))=2)&(APSKC(4)[".") S APSKC(4)=0_APSKC(4)
 I APSKS(1)=2 G CALC^APSKAMN2
POST3 W !! K %DT S %DT="AER",%DT("A")="Time of third sample: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G POST3
 S APSKZ5T=Y
 S APSKZ(5)=$P(Y,"@",2)
 I APSKZ1T=APSKZ5T W !,"Third and Start times are the same." D SAMETM G POST3
 I APSKZ2T=APSKZ5T W !,"Third and End times are the same." D SAMETM G POST3
 I APSKZ3T=APSKZ5T W !,"Third and First times are the same." D SAMETM G POST3
 I APSKZ4T=APSKZ5T W !,"Third and Second times are the same." D SAMETM G POST3
 I APSKZ13T=APSKZ5T W !,"Third and PRE LEVEL times are the same." D SAMETM G POST3
 K DIR S DIR(0)="N^.1:20:1" W !
 S DIR("A")="Conc of third sample"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT) G POST3:Y=""
 S APSKC(5)=Y
 I ($L(APSKC(5))=2)&(APSKC(5)[".") S APSKC(5)=APSKC(5)
 I APSKS(1)=3 G CALC^APSKAMN2
POST4 W !! K %DT S %DT="AER",%DT("A")="Time of fourth sample: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G POST4
 S APSKZ6T=Y
 S APSKZ(6)=$P(Y,"@",2)
 I APSKZ1T=APSKZ6T W !,"Fourth and Start times are the same." D SAMETM G POST4
 I APSKZ2T=APSKZ6T W !,"Fourth and End times are the same." D SAMETM G POST4
 I APSKZ3T=APSKZ6T W !,"Fourth and First times are the same." D SAMETM G POST4
 I APSKZ4T=APSKZ6T W !,"Fourth and Second times are the same." D SAMETM G POST4
 I APSKZ5T=APSKZ6T W !,"Fourth and Third times are the same." D SAMETM G POST4
 I APSKZ13T=APSKZ6T W !,"Fourth and PRE LEVEL times are the same." D SAMETM G POST4
 K DIR S DIR(0)="N^.1:20:1" W !
 S DIR("A")="Conc of fourth sample"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT) G POST4:Y=""
 S APSKC(6)=Y
 I ($L(APSKC(6))=2)&(APSKC(6)[".") S APSKC(6)=0_APSKC(6)
 I APSKS(1)=4 G CALC^APSKAMN2
POST5 W !! K %DT S %DT="AER",%DT("A")="Time of fifth sample: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G POST2
 S APSKZ7T=Y
 S APSKZ(7)=$P(Y,"@",2)
 I APSKZ1T=APSKZ7T W !,"Fifth and Start times are the same." D SAMETM G POST5
 I APSKZ2T=APSKZ7T W !,"Fifth and End times are the same." D SAMETM G POST5
 I APSKZ3T=APSKZ7T W !,"Fifth and First times are the same." D SAMETM G POST5
 I APSKZ4T=APSKZ7T W !,"Fifth and Second times are the same." D SAMETM G POST5
 I APSKZ5T=APSKZ7T W !,"Fifth and Third times are the same." D SAMETM G POST5
 I APSKZ6T=APSKZ7T W !,"Fifth and Fourth times are the same." D SAMETM G POST5
 I APSKZ13T=APSKZ7T W !,"Fifth and PRE LEVEL times are the same." D SAMETM G POST5
 K DIR S DIR(0)="N^.1:20:1" W !
 S DIR("A")="Conc of fifth sample"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DTOUT),END:$D(DUOUT) G POST5:Y=""
 S APSKC(7)=Y
 I ($L(APSKC(7))=2)&(APSKC(7)[".") S APSKC(7)=0_APSKC(7)
 I APSKS(1)=5 G CALC^APSKAMN2
 ;
SAMETM ;EP
 W !,"Please enter a different time or '^' to exit"
END Q
