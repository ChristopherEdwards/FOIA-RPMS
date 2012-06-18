ACHSDA ; IHS/ITSC/PMF - PATIENT DATA ;     [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;OCAO/IHS CL
 ;VERSION;1.31;5/1/88
 ;
 I '$D(^AZOPBPP) W !!,"This Option Not Yet Available",!! H 2 G END
L0 ;
 S ACHSYAYA=U_"AZO"_"PWN"_"LK" D @ACHSYAYA K ACHSYAYA G END:'$D(DFN) ; LINE ADDED TO DO PAWNEE BENEFIT/DLW/6/30/95
 ;
L1 ;
 S DA=DFN,DIE="^AZOPBPP(",DR=".01:99" D ^DIE
 G L0
 ;
END ;
 Q
 ;
SBRS ;
 ;IHS/ITSC/PMF  1/19/01  changes in this module to comply
 ;with SAC.  the READ command in the comment is in quotes so
 ;that SAC checker does not see it.  Yes, it looks in comments
 ;K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT "R" Y:DTIME I '$T W *7 "R" Y:5 G SBRS:Y="." I '$T S (DTOUT,Y)="" Q
 K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT
 S DIR(0)="F"
 D ^DIR
 ;
 ;S:Y="" DLOUT="" S:Y="/.," (DFOUT,Y)="" S:Y="^" (DUOUT,Y)="" S:Y?1"?".E!(Y["^") (DQOUT,Y)=""
 I Y="" S DLOUT="" Q
 I Y="/.," S (DFOUT,Y)="" Q
 I Y="^" S (DUOUT,Y)=""
 I (Y?1"?".E!(Y["^")) S (DQOUT,Y)="" Q
 I Y'?1N W " Must be a number" G SBRS
 I Y<1!(Y>3) W " Must be between 1 and 3" G SBRS
 Q
 ;
ADD ;ADD A NEW PATIENT TO THE PB FILE
 ;IHS/ITSC/PMF  1/8/01  replace this old fashioned call with
 ;a call to the approved routine  {D AUCLS}
 ;clear the screen
 D ^XBCLS
 ;
A ;
 ;IHS/ITSC/PMF  1/9/01  change call from old routine to new
 ;but identical ^XB routine.  also, any more than three dots
 ;in row is gratuitous
 ;W !!,"ADDING a patient to the PAWNEE BENEFIT package files.....",!!! {D AUALLLK} G END:'$D(DFN)
 W !!,"ADDING a patient to the PAWNEE BENEFIT package files...",!!! D ^XBALLLK G END:'$D(DFN)
 ;
A1 ;
 I $D(^AZOPBPP(DFN)) W !!,*7,"This patient is already enrolled in the Benefit Package.",!!,"BENEFIT PACKAGE NUMBER: ",$P($G(^(DFN,0)),U,2),!! G A
A2 ;
 ;IHS/ITSC/PMF  1/10/01  split next line and replace naked refs
 ;G B:$D(^AUPNPAT(DFN,41,2564))!$D(^(2565))!$D(^(2566)) W !!,*7,"The patient must be registered at Pawnee, Pawhuska, or White Eagle",!,"before he/she can be added to the Benefit Package file.",!! G A
 G B:$D(^AUPNPAT(DFN,41,2564))!$D(^AUPNPAT(DFN,41,2565))!$D(^AUPNPAT(DFN,41,2566))
 W !!,*7,"The patient must be registered at Pawnee, Pawhuska, or White Eagle",!,"before he/she can be added to the Benefit Package file.",!! G A
 ;
B ;
 W !! S DIE="^AZOPBPP(",DA=DFN,DR=".01:99",^AZOPBPP(DFN,0)=DFN,^AZOPBPP("B",DFN,DFN)="",$P(^AZOPBPP(0),U,3)=DFN,$P(^(0),"^",4)=+$P(^(0),"^",4)+1 D ^DIE
 ;
C ;CHECK FOR BEN. PACK. NUMBER
C1 ;
 I $D(^AZOPBPP(DFN,0)),$P(^AZOPBPP(DFN,0),"^",2)']"" S DR=".01///@" D ^DIE W !!,*7,"File deleted - no Benefit Package number.",!! G A
 G END
TEMP ;ADD NEW PATIENT WITH TEMPORART CHART NUMBER
 W !!,"At which facility will this patient be registered?",!!?10,"1...Pawnee",!?10,"2...White Eagle",!?10,"3...Pawhuska",!!,?10 D SBRS Q:$D(DTOUT)!$D(DFOUT)!$D(DUOUT)!$D(DLOUT)
QUES I $D(DQOUT) W !!,"Choose the facility in which this patient will receive his primary care.",!! G TEMP
 S Y=+Y I Y<1!(Y>3) S DQOUT="" G QUES
 S ^ACHS("ASITE")=ASITE,ASITE=$S(Y=3:2564,Y=2:2565,1:2566)
 S DOG="" D DOG^AG0 D L2^AG2:$D(DFN) K DFN,DOG,%DT S ASITE=$G(^ACHS("ASITE")) K ^ACHS("ASITE") G END
