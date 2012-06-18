ADGCRB1 ; IHS/ADC/PDW/ENM - A SHEET lines 1&2 ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D INI,HDH,H1,L1,H2,L2,^ADGCRB2,^ADGCRB3,^ADGCRB4 Q
 ;
INI ; -- initialize variables
 S (DGLIN,DGLIN1)="",$P(DGLIN,"=",80)="",$P(DGLIN1,"-",80)=""
 S DGN=$S(DGDS:^ADGDS(DFN,"DS",+DGDS,0),1:^DGPM(DGFN,0))
 S DGN0=^DPT(DFN,0),DGN11=$G(^AUPNPAT(DFN,11)) Q
 ;
HDH ; -- print heading
 W $S(DGDS:"DAY SURGERY WORKSHEET",1:"CLINICAL RECORD BRIEF")
 W " **Confidential Patient Data Covered by Privacy Act** "
 W:'DGDS $$N1 W !,DGLIN Q
 ;
H1 ; -- sub heading 1
 W !,"1 IHS Unit No.",?16,"2 Soc Sec No",?30,"10 Classif."
 W ?44,"11 Facility",?60,"12 Facility Code",! Q
 ; 
L1 ; -- data line 1
 W ?3,$$HRCN^ADGF,?17,$$SSN,?33,$$CLS,?47,$$FACN,?63,$$FACC Q
 ;
H2 ; -- sub heading 2
 W !,DGLIN1,!,"3 Last Name, First, Middle",?29,"13 Age"
 I DGDS W ?37,"14 Religion",?53,"15 Hr Arrvd",?66,"16 Visit Type",! Q
 W ?37,"14 Religion",?53,"15 Hr Admit",?66,"16 Admit Code",! Q
 ;
L2 ; -- data line 2
 W ?2,$P(DGN0,U),?32,$$AGE,?40,$$REL,?58,$$TIM,?69,$$CDE Q
 ;
SSN() ; -- social security number
 Q:$P(DGN0,U,9)="" "UNKNOWN"
 Q $E($P(DGN0,U,9),1,3)_"-"_$E($P(DGN0,U,9),4,5)_"-"_$E($P(DGN0,U,9),6,9)
 ;
CLS() ; -- classification/beneficiary & classif code     
 Q $E($P($G(^AUTTBEN(+$P(DGN11,U,11),0)),U),1,3)_"-"_$P($G(^(0)),U,2)
 ;
FACN() ; -- facility
 Q $P($G(^AUTTLOC(+DUZ(2),0)),U,2)
 ;
FACC() ; -- facility code
 N X I '$D(DUZ(2))!('$D(^AUTTLOC(DUZ(2),0))) Q "UNKNOWN"
 S X=$P(^AUTTLOC(DUZ(2),0),U,10) Q $E(X,1,2)_"-"_$E(X,3,4)_"-"_$E(X,5,6)
 ;
AGE() ; -- age
 N X K ^UTILITY("DIQ1",$J) S DIC=2,DR=.033,DA=DFN D EN^DIQ1
 S X=^UTILITY("DIQ1",$J,2,DA,.033) K ^UTILITY("DIQ1",$J),DIC,DR,DA Q X
 ;
REL() ; -- religion
 Q $E($P($G(^DIC(13,+$P(DGN0,U,8),0)),U),1,12)
 ;
TIM() ; -- admit time
 Q $E(($P(+DGN,".",2)_"000"),1,4)
 ;
CDE() ; -- admission code
 Q $S(DGDS:"DAY SURGERY",1:" "_$P(DGN,U,4))
 ;
N1() ; -- number of admissions
 N X,Y S (X,Y)=0 F  S Y=$O(^DGPM("APTT1",DFN,Y)) Q:'Y  S X=X+1
 Q "#"_X
