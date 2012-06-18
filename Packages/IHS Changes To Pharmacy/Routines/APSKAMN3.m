APSKAMN3 ;IHS/ANMC/SFB/MRS - DISPLAYS OUTPUT[ 09/28/94  10:51 AM ]
 ;;1.0;Aminoglycoside Kinetics;;OCT 31,1994
 S IOP=ION S %ZIS("B")="" D ^%ZIS
OUTPUT ;EP - DISPLAY OF RESULTS
 W @IOF
 W !!,"The duration of the infusion (T') = ",APSKT0," hours"
 W !!,"The infusion rate (K0) = ",$J(APSKK0,5,1)," mg per hours"
 W !!,"The coefficient of determination (R^2) = ",$J(APSKR2,2,2)
 W !!,"The extrapolated peak serum conc. (Cp0) = ",$J(APSKC1,2,2)," mcg/ml"
 W !!,"The elimination rate constant (Kd) = ",$J(APSKK1,2,3)," hr-1"
 W !!,"Therefore the half-life = ",$J(APSKT1,2,2)," hours"
 W !!,"The volume of distribution = ",$J(APSKV1,2,2)
 W " liters ",$J(APSKV2,2,2),"L/Kg"
 W !!!,"Do you wish to:"
 W !,"       (1) continue with dosage determination or"
 W !,"       (2) repeat the regression analysis? "
 ;===>IF USER CONTINUES WITH DOSAGE DETERMINATION, CONTROL IS
 ;===>PASSED TO DOSING FOUND IN THE APSKAMN4 ROUTINE.
 ;===>OTHERWISE, THE BEGINNING MENU IS DISPLAYED
 K DIR S DIR(0)="N^1:2" W !
 S DIR("A")="CHOOSE ONE (By Number)"
 D ^DIR G END:$D(DIRUT) K DIR
 S APSKB=Y
 I APSKB=2 D INITIAL
 S APSKX=$S(APSKB=1:"DOSING^APSKAMN4",APSKB=2:"CHOICE2^APSKAMN1",1:"")
 G @APSKX
 ;
INITIAL ;EP
 F APSKX1=1:1:16 S (APSKT(APSKX1),APSKH(APSKX1),APSKC(APSKX1),APSKZ(APSKX1),APSKS(APSKX1))=0
 S (APSKSE,APSKC,APSKD,APSKM,APSKPK)=0
END Q
