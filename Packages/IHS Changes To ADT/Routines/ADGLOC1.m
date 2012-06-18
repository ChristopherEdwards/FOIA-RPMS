ADGLOC1 ; IHS/ADC/PDW/ENM - LOCATOR CARD - print ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- patient demographic
 N N0,N11,N21,N
 Q:'$D(DFN)  S N0=$G(^DPT(DFN,0)),N11=$G(^AUPNPAT(DFN,11))
 U IO W !!!?8,"***Confidential Patient Data***",!
 W ?5,$E($P(N0,U),1,25),?29,"Chart #: ",$$HRCN^ADGF
 W !!?5,"SSN: ",$$SSN,?29,"Classif: ",$$CLS
 W !?5,"Age: ",$$AGE,?23,"Date of Birth: ",$$DOB
 W !?5,"Sex: ",$P(N0,U,2),?28,"Religion: ",$$REL
 ; -- mailing address
 I $D(^DPT(DFN,.11)) S N11=^(.11) D
 . W !!?5,"Patient's Address: ",!
 . W ?5,$P(N11,U),"  ",$P(N11,U,4),", ",$$STM," ",$P(N11,U,6)
 ; -- next of kin
 I $D(^DPT(DFN,.21)) S N21=^(.21) D
 . W !?5,"Next of Kin:",!?5,$P(N21,U),?37,$$NOKR,!?5,$P(N21,U,3),"  "
 . W $P(N21,U,6),", ",$$STN," ",$P(N21,U,8),!?26,"Phone: ",$P(N21,U,9)
 ; -- admission info
 Q:'$D(IFN)  S N=$G(^DGPM(IFN,0))
 W !!?5,"Admission Date: ",?20,$$ADT,"  ",$$TIM,!!?5,$P(N0,U)
 W:$D(^DPT(DFN,.1)) ?36,$E(^(.1),1,3) W ?41,$$TS,@IOF Q
 ;
NOKR() ; -- nok relationship
 Q $P($G(^AUPNPAT(DFN,28)),U,2)
 ;
DOB() ; -- date of birth
 Q $E($P(N0,U,3),4,5)_"/"_$E($P(N0,U,3),6,7)_"/"_$E($P(N0,U,3),2,3)
 ;
TS() ; -- treating specialty
 Q $E($P($G(^DIC(45.7,+$G(^DPT(DFN,.103)),0)),U),1,3)
 ;
ADT() ; -- admission date
 N Y S Y=$P(+N,".") X ^DD("DD") Q Y
 ;
TIM() ; -- admission time
 N Y S Y=+N X ^DD("DD") Q $P(Y,"@",2)
 ;
SSN() ; -- social security number
 Q $E($P(N0,U,9),1,3)_"-"_$E($P(N0,U,9),4,5)_"-"_$E($P(N0,U,9),6,9)
 ;
CLS() ; -- classification/beneficiary & classif code     
 Q $E($P($G(^AUTTBEN(+$P(N11,U,11),0)),U),1,3)_"-"_$P($G(^(0)),U,2)
 ;
REL() ; -- religion
 Q $P($G(^DIC(13,+$P(N0,U,8),0)),U)
 ;
STM() ; -- state, mailing
 Q $P($G(^DIC(5,+$P(N11,U,5),0)),U,2)
 ;
STN() ; -- state, nok
 Q $P($G(^DIC(5,+$P(N21,U,7),0)),U,2)
 ;
AGE() ; -- age
 N X,DIC,DR,DA K ^UTILITY("DIQ1",$J) S DIC=2,DR=.033,DA=DFN D EN^DIQ1
 S X=^UTILITY("DIQ1",$J,2,DA,.033) K ^UTILITY("DIQ1",$J) Q X
