AGCHTMP ; IHS/ASDS/EFG - ASSIGN A TEMPORARY CHART NUMBER ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
QUES ;
 K AG("TEMP CHART")
 W !!!,"Do you need a temporary chart number for this new patient? (Y/N)  N// "
 D READ^AG
 S Y=$E(Y_"N")
 G END:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)!(Y="N")
 I $D(DQOUT)!(Y'="Y") D  G QUES
 . W !!,"If you cannot give this patient an OFFICIAL chart number at"
 . W !," this time,",!,"answer ""YES"" to this question."
 S AGCH=999999
 S AGTCH=0
 F I=0:0 S AGCH=$O(^AUPNPAT("D",AGCH)) Q:AGCH=""  S AGTCH=AGCH
 S:AGTCH=0 AGTCH="T00000"
 S AGTCH=$E(AGTCH,2,6)
 S AGTCH=AGTCH+1
 S AGTCH="T"_$E(100000+AGTCH,2,6)
 S AG("TEMP CHART")=AGTCH
 W !!,"The new patient's TEMPORARY chart number is ",AG("TEMP CHART")
 W !!,"Press RETURN..."
 D READ^AG
END ;
 K AG("EDIT"),AGCH,AGTCH
 Q
