ADGPM1 ; IHS/ADC/PDW/ENM - VIEW ADMISSION HISTORY ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 W @IOF W !!?20,"VIEW A PATIENT'S ADMISSION HISTORY",!!
A ; -- main
 D SP I Y<0 D Q Q
 D HD1,CS,HD2,L1,Q Q
 ;
SP ; -- patient 
 S DIC="^DPT(",DIC(0)="AZQEM" D ^DIC I Y<0 Q
 S DFN=+Y,DGDPTN0=Y(0) Q
 ;
HD1 ; -- heading 1
 W @IOF,?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,$P(DGDPTN0,U),?32,"DOB: ",$$DOB
 W ?50,"Age: ",$$AGE,?60,"CHART #: ",$$HRCN^ADGF
 S X="CURRENT STATUS" W !!?80-$L(X)/2,X S X="",$P(X,"=",80)="" W !,X
 Q
 ;
HD2 ; -- heading 2
 S X="ADMISSION HISTORY" W !!?80-$L(X)/2,X,! S X="",$P(X,"=",80)="" W X
 W !!?8,"Admit Date",?25,"Ward",?32,"Service",?43,"Rm/Bed"
 W ?51,"Discharge",?66,"Provider"
 W !?3,"-----------------",?24,"------",?31,"---------",?43,"------"
 W ?51,"-----------",?64,"--------------" Q
 ;
CS ; -- current status
 D INP^DGRPD Q
 ;
L1 ; -- loop admissions
 S DGDT=0 N X S X=0
 F  S DGDT=$O(^DGPM("APTT1",DFN,DGDT)) Q:'DGDT  D
 . S DGPMDA=0
 . F  S DGPMDA=$O(^DGPM("APTT1",DFN,DGDT,DGPMDA)) Q:'DGPMDA  D
 .. D PRNT
 W ! Q
 ;
PRNT ; -- print admission data
 Q:'$D(^DGPM(DGPMDA,0))  S DGPMN0=^(0),X=X+1
 W !,"(",X,") ",$$ADT,?24,$$WD,?31,$$TS,?44,$$RM
 W ?52,$$DS,?65,$$PR Q
 ;
Q ; -- cleanup
 D PRTOPT^ADGVAR
 K DGPMDA,DGPMN0,DFN,DGDPTN0,DGDT,DIC,X,Y,DA,DR,E Q
 ;
WD() ; -- ward
 Q $E($P($G(^DIC(42,+$P(DGPMN0,U,6),0)),U),1,6)
 ;
RM() ; -- room
 Q $P($G(^DG(405.4,+$P(DGPMN0,U,7),0)),U)
 ;
TS() ; -- treating specialty
 N X S X=$O(^DGPM("APHY",DGPMDA,0)) Q:'X ""
 S X=$P(^DGPM(X,0),U,9) Q:'X "" Q $E($P(^DIC(45.7,X,0),U),1,9)
 ;
PR() ; -- provider
 N X S X=$O(^DGPM("APHY",DGPMDA,0)) Q:'X ""
 S X=$P(^DGPM(X,0),U,8) Q:'X ""
 Q $E($P($P($G(^VA(200,+X,0)),U),",",1),1,13)
 ;
DS() ; -- discharge
 N X S X=$P(DGPMN0,U,17) Q:'X "" S X=+^DGPM(X,0) Q:'X ""
 Q $E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)
 ;
DOB() ; -- date of birth
 N Y S Y=$P(DGDPTN0,U,3) Q:'Y "" X ^DD("DD") Q Y
 ;
ADT() ; -- admission date
 N X S X=+DGPMN0 Q:'X ""
 S Y=$P(X,".",2)_"000",Y=$E(Y,1,2)_":"_$E(Y,3,4)
 Q $E(X,4,5)_"-"_$E(X,6,7)_"-"_$E(X,2,3)_" ("_Y_")"
 ;
AGE() ; -- age
 N X K ^UTILITY("DIQ1",$J) S DIC=2,DR=.033,DA=DFN D EN^DIQ1
 S X=^UTILITY("DIQ1",$J,2,DFN,.033) K ^UTILITY("DIQ1",$J) Q X
