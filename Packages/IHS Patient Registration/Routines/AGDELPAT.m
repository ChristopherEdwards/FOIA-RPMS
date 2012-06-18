AGDELPAT ; IHS/ASDS/EFG - DELETE HRN ;  
 ;;7.1;PATIENT REGISTRATION;**5,9**;AUG 25, 2005
 ;
NODFN ;EP - Without Pre-Defined Patient.
 K DIC S AUPNLK("INAC")="" D PTLK^AG K AUPNLK("INAC")
 Q:'$D(DFN)  S AG("NAME")=$P(^DPT(DFN,0),U)
NODFN1 W !!,"You wish to delete the Health Record Number for """,AG("NAME"),""".",!,"  CORRECT? (Y/N)  N// "
 D READ^AG G END:$D(DTOUT)!$D(DFOUT),NODFN:$D(DUOUT) S Y=$E(Y_"N") I $D(DQOUT)!("YN"'[Y) D YN^AG G NODFN1
 G NODFN:Y'="Y"
DFN ;
 I +$P(^AUPNPAT(DFN,41,0),U,4)=1,$P(^DPT(DFN,0),U,9)]"" D SSN G:Y="S" END
 D INITL^AGMAN D NOW^%DTC S X=% ; Do not Delay export of delete.
 S ^AGPATCH(X,DUZ(2),DFN)=DUZ(2)_U_$P(^AUPNPAT(DFN,41,DUZ(2),0),U,2)_"^^"_AG("INITL")_U_$P(^DPT(DFN,0),U,2)
 S DA(1)=DFN,DA=DUZ(2),DIE="^AUPNPAT("_DA(1)_",41,",DR=".03////"_DT_";.05////D" D ^DIE
 W !!,"The Health Record Number for ",AG("NAME")," is deleted.",!!
 S ^XTMP("AGHL7AG",DUZ(2),DFN,"UPDATE")=""  ;fje 07082009 AG*7.1*5 ;AG*7.1*9 - Added DUZ(2) subscript
 K DFOUT,DTOUT,DUOUT,DQOUT,DLOUT
 K DIR
 S DIR(0)="E"
 S DIR("A")="Press RETURN..."
 D ^DIR
END K AGDT,DFN
 Q
SSN W *7,!!,"This is the only HRN for this patient.",!,"If the HRN and/or SSN (",$P(^DPT(DFN,0),U,9),") were entered in error,",!,"and you want to use the SSN for another entry,",!,"you must delete the SSN before deleting the HRN.",!
 F AGZ("I")=1:1 W !?10,"[S]top, [C]ontinue with HRN delete? (S/C)  S// " D READ^AG S Y=$E(Y_"S") Q:"SC"[Y&('$D(DQOUT))  W *7,!,"Please enter 'S' or 'C'."
 Q
