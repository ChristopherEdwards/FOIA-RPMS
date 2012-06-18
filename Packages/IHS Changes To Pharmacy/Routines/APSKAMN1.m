APSKAMN1 ;IHS/ANMC/SFB/MRS - REGRESSION ANALYSIS CALC[ 09/28/94  11:16 AM ]
 ;;1.0;Aminoglycoside Kinetics;;OCT 31,1994
 S IOP=ION S %ZIS("B")=""
 D ^%ZIS
 ;
CHOICE2 ;EP - CHOOSE REGRESSION OR DOSING USING ASSUMED PARAMETERS
 W !!
 K DIR S DIR(0)="S^1:REGRESSION ANALYSIS;2:DOSING USING ASSUMED PARAMETERS"
 S DIR("A")="ENTER '1' or '2' "
 D ^DIR G END:$D(DIRUT) K DIR S APSKM=Y
 ;===>CONTROL PASSED TO THE NOREG SECTION OF APSKAMN5
 ;===>IF NO REGRESSION ANALYSIS IS PERFORMED
 I APSKM="2" G NOREG^APSKAMN9
 W @IOF
 W !,"     SERUM SAMPLES MUST BE OBTAINED WITHIN A 24 HR PERIOD ! "
 W !!,"     The following are examples of valid time inputs: "
 W !!,"07:00  07AM   7AM  715AM  19:00  07PM  7PM  715PM"
 W !,"For additional information, enter '?' at any prompt that request"
 W !,"the time."
 W !!
 ;
START1 ;EP-INFUSION START TIME
 W !! K %DT S %DT="AER",%DT("A")="Time at START of infusion: "
 D ^%DT G END:$D(DTOUT),END:X="^"
 I (Y=-1)!(X="") D RR^APSKAMN0 G START1
 X ^DD("DD")
 S APSKZ1T=Y
 S APSKZ(1)=$P(Y,"@",2)
 ;
END1 ;===>INFUSION END TIME
 W !! K %DT S %DT="AER",%DT("A")="Time at END of infusion: "
 D ^%DT G END:$D(DTOUT),END:X="^"
 I (Y=-1)!(X="") D RR^APSKAMN0 G END1
 X ^DD("DD")
 S APSKZ2T=Y
 S APSKZ(2)=$P(Y,"@",2)
 I APSKZ1T=APSKZ2T W !,"End time and Start time are the same. Please enter a new End time or enter '^' to quit. "  G END1
 I APSKZ2T<APSKZ1T W !,"End time is before Start time.  Please enter a new End time or enter '^' to quit. " G END1
 W !!
 ;===>AMOUNT INFUSED
TD K DIR S DIR(0)="N"
 S DIR("A")="Total DOSE infused (in mg.)"
 D ^DIR G END:$D(DTOUT),END:X="^"
 I Y="" D RR^APSKAMN0 G TD
 S APSKD=Y
 W @IOF
PL K DIR S DIR(0)="Y"
 S DIR("A")="Do you have a measurable PRE LEVEL <Y/N>"
 D ^DIR G END:$D(DIRUT)
 I Y="" D RR^APSKAMN0 G PL
 S APSKPL=Y
 I APSKPL="0" G POST^APSKAMN7
 ;
PRELEVEL W !! K %DT S %DT="AER" S %DT("A")="Time of PRE LEVEL: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G PRELEVEL
 S APSKZ13T=Y
 S APSKZ(13)=$P(Y,"@",2)
 I APSKZ1T=APSKZ13T W !,"PreLevel time and Start time are the same. Please enter a new PreLevel time or enter '^' to quit. "  G PRELEVEL
 I APSKZ2T=APSKZ13T W !,"PreLevel time and End time are the same. Please enter a new PreLevel time or enter '^' to quit. "  G PRELEVEL
CPL K DIR S DIR(0)="N^.1:10:1" W !
 S DIR("A")="Concentration of PRE LEVEL (mcg/ml)"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DIRUT)
 I Y="" D RR^APSKAMN0 G CPL
 S APSKC(13)=Y
 I ($L(APSKC(13))=2)&(APSKC(13)[".") S APSKC(13)=0_APSKC(13)
 K DIR S DIR(0)="Y",DIR("B")="YES"
 S DIR("A")="Is this data from a peak/trough check <Y/N>"
 D ^DIR G END:$D(DIRUT) K DIR S APSKSE=Y
 I APSKSE="0" G POST^APSKAMN7
 ;
POSTLEVL W !! K %DT
 S %DT="AER",%DT("A")="Time of POST LEVEL: "
 D ^%DT G END:$D(DTOUT),END:$D(DUOUT) X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G POSTLEVL
 S APSKZ3T=Y
 S APSKZ(3)=$P(Y,"@",2)
 ;
 I APSKZ1T=APSKZ3T W !,"POST LEVEL time and Start time are the same. Please enter a new POST LEVEL time or enter '^' to quit. "  G POSTLEVL
 I APSKZ2T=APSKZ3T W !,"POST LEVEL time and End time are the same. Please enter a new POST LEVEL time or enter '^' to quit. "  G POSTLEVL
 ;
COMPL K DIR S DIR(0)="N^.1:10:1"
 S DIR("A")="Concentration of POST LEVEL (mcg/ml)"
 S DIR("?")="To enter 0.1 - 0.9, do not enter the '0'. Ex. .1, .2, etc."
 D ^DIR G END:$D(DIRUT),COMPL:Y="" K DIR S APSKC(3)=Y
 ;
INFUSION W !! K %DT S %DT="AER",%DT("A")="Time at end of previous infusion: "
 D ^%DT G END:$D(DTOUT),END:X="^" X ^DD("DD")
 I (Y=-1)!(X="") D RR^APSKAMN0 G INFUSION
 S APSKZ14T=Y
 S APSKZ(14)=$P(Y,"@",2)
 I APSKZ1T=APSKZ14T W !,"Previous infusion time and Start time are the same. Please enter a new infusion time or enter '^' to quit. "  G INFUSION
 I APSKZ2T=APSKZ14T W !,"Previous infusion time and End time are the same. Please enter a new infusion time or enter '^' to quit. "  G INFUSION
 I APSKZ3T=APSKZ14T W !,"Previous infusion time and POST LEVEL time are the same. Please enter a new infusion time or enter '^' to quit. "  G INFUSION
 G CVTIME^APSKAMN2
 ;
END Q
