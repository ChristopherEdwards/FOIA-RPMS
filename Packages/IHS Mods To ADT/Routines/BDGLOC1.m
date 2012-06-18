BDGLOC1 ; IHS/ANMC/LJF - LOCATOR CARD - print ;
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/22/2007 added code to print attending provider PATCH 1007 item 1007.42
 ;
EN ;EP; entry point from queuing
 Q:'$G(DFN)  Q:'$G(BDGN)
 S BDGN=$P($G(^DGPM(BDGN,0)),U,14) Q:'BDGN  ;make sure is admission ien
 ;
 ; -- patient demographics
 U IO W !!!?8,"***Confidential Patient Data***",!
 W ?5,$E($$GET1^DIQ(2,DFN,.01),1,25)
 W ?29,"Chart #: ",$$HRCN^BDGF2(DFN,DUZ(2))
 W !?5,"Age: ",$$GET1^DIQ(9000001,DFN,1102.98)
 W ?23,"Date of Birth: ",$$GET1^DIQ(2,DFN,.03)
 W !?5,"Sex: ",$$GET1^DIQ(2,DFN,.02,"I")
 W ?28,"Religion: ",$$GET1^DIQ(2,DFN,.08)
 ;
 ; -- mailing address
 S X=$$GET1^DIQ(2,DFN,.111)
 W !!?5,"Patient's Address: ",!
 W ?5,$$GET1^DIQ(2,DFN,.111),"  ",$$GET1^DIQ(2,DFN,.114)
 W ", ",$$GET1^DIQ(5,+$$GET1^DIQ(2,DFN,.115,"I"),1)   ;state abbrev
 W "  ",$$GET1^DIQ(2,DFN,.116)
 ;
 ; -- next of kin
 W !!?5,"Next of Kin:"
 W !?5,$$GET1^DIQ(2,DFN,.211),?37,$$GET1^DIQ(2,DFN,.212)
 W !?5,$$GET1^DIQ(2,DFN,.213),"  ",$$GET1^DIQ(2,DFN,.216)
 W $$GET1^DIQ(2,DFN,.217)
 W "  ",$$GET1^DIQ(5,+$$GET1^DIQ(2,DFN,.218,"I"),1)   ;state abbrev
 S X=$$GET1^DIQ(2,DFN,.219) I X]"" W !?5,"Phone: ",X
 ;
 ; -- admission info
 W !!?5,"Admission Date: "
 W ?20,$$FMTE^XLFDT(+$$GET1^DIQ(405,BDGN,.01,"I"),"P")
 I $G(^DPT(DFN,.105))=BDGN D
 . W !?8,"Ward/Room-Bed: ",$G(^DPT(DFN,.1))," / ",$G(^DPT(DFN,.101))
 ;cmi/anch/maw 2/22/2007 add attending provider if there PATCH 1007 item 1007.42
 W !,?5,"Attending Provider: "
 W ?25,$$LASTPRV^BDGF1(BDGN,DFN)
 ;cmi/anch/maw 2/22/2007 end of additions
 ;
 D ^%ZISC K DFN,BDGN
 D KILL^AUPNPAT
 Q
 ;
