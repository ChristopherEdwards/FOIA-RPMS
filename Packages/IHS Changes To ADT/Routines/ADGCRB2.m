ADGCRB2 ; IHS/ADC/PDW/ENM - A SHEET lines 3&4 ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- driver
 D H3,L3,H4,L4 Q
 ;
H3 ; -- sub heading 3
 W !,DGLIN1,!,"4 Birthdate",?18,"5 Sex",?26,"6 Tribe"
 I DGDS W ?36,"17&18 Service & Code",?62,"19 Surgery Date",! Q
 W ?36,"17&18 Admit Srvc & Code",?62,"19 Admit Date",! Q
 ;
L3 ; -- data line 3
 W ?2,$$DOB,?21,$P(DGN0,U,2),?28,$$TRB,?44,$$SRV,?65,$$ADT Q
 ;
H4 ; -- sub heading 4
 W !,DGLIN1,!,"8 Community, County, State Code",?36,"Ward"
 I DGDS W ?43,"Provider",?62,"20 Release Date",! Q
 W ?43,"Provider",?62,"20 Discharge Date",! Q
 ;
L4 ; -- data line 4
 W ?6,$$COM,?37,$$WRD,?43,$$PRV,?65,$$DDT Q
 ;
DOB() ; -- date of birth
 N Y S Y=$P(DGN0,U,3) X ^DD("DD") Q Y
 ;
TRB() ; -- tribe
 Q $E($P($G(^AUTTTRI(+$P(DGN11,U,8),0)),U),1,3)_$P($G(^(0)),U,2)
 ;
ADT() ; -- admission date
 N Y S Y=$P(+DGN,".") X ^DD("DD") Q Y
 ;
COM() ; -- community
 N X
 S X=$S(+$P(DGN11,U,17):$P(DGN11,U,17),1:$O(^AUTTCOM("B",$P(DGN11,U,18),0)))
 S X=$P($G(^AUTTCOM(+X,0)),U,8) Q:X="" ""
 Q $E(X,5,7)_"-"_$E(X,3,4)_"-"_$E(X,1,2)
 ;
WRD() ; -- ward 
 Q $E($P($G(^DIC(42,+$S(DGDS:$P(DGN,U,3),1:$P(DGN,U,6)),0)),U),1,3)
 ;
DDT() ; -- discharge date
 I DGDS N Y S Y=$P($G(^ADGDS(DFN,"DS",+DGDS,2)),U) X ^DD("DD") Q $P(Y,"@")
 N Y S Y=$P($G(^DGPM(+$P(DGN,U,17),0)),".") X ^DD("DD") Q $P(Y,"@")
 ;
PRV() ; -- provider
 Q:DGDS $E($P($G(^VA(200,+$P(DGN,U,6),0)),U),1,14)
 Q $E($P($G(^VA(200,+$P($G(^DGPM(+$O(^DGPM("APHY",DGFN,0)),0)),U,8),0)),U),1,14)
 ;
SRV() ; -- treating specialty & code
 Q:DGDS $E($P($G(^DIC(45.7,+$P(DGN,U,5),0)),U),1,3)_"  "_$P($G(^(9999999)),U)
 Q $E($P($G(^DIC(45.7,+$P($G(^DGPM(+$O(^DGPM("APHY",DGFN,0)),0)),U,9),0)),U),1,3)_"  "_$P($G(^(9999999)),U)
