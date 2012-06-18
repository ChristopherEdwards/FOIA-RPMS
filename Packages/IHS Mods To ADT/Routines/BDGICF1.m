BDGICF1 ; IHS/ANMC/LJF - DEFICIENCY WORKSHEETS ; 
 ;;5.3;PIMS;**1003,1005**;MAY 28, 2004
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 add screen to patient lookup
 ;IHS/OIT/LJF  02/16/2006 PATCH 1005 mark as delinquent chart
 ;                                   added coding date & who coded
 ;                                   added deficiency comments
 ;             02/24/2006 PATCH 1005 fixed code to include observations
 ;
 ;
 NEW BDGT,PROMPT,BDGPAT
 ;IHS/OIT/LJF 02/24/2006 PATCH 1005
 ;S BDGT=$$READ^BDGF("SO^1:Inpatients;2:Day Surgeries;3:Both","Select Records to Print") Q:'BDGT
 S BDGT=$$READ^BDGF("SO^1:Inpatients/Observations;2:Day Surgeries;3:Both","Select Records to Print") Q:'BDGT
 ;IHS/ITSC/LJF 5/13/2005 PATCH 1003 screen patient lookup based on previous question
 NEW SCREEN S SCREEN=""
 ;I BDGT=1 S SCREEN="I $$GET1^DIQ(9009016.1,+Y,.0392)=""HOSPITALIZATION"""
 I BDGT=1 S SCREEN="I $$GET1^DIQ(9009016.1,+Y,.0392)'=""DAY SURGERY"""   ;IHS/OIT/LJF 02/24/2006 PATCH 1005
 I BDGT=2 S SCREEN="I $$GET1^DIQ(9009016.1,+Y,.0392)=""DAY SURGERY"""
 ;
 K BDGPAT S Y=1 F  D  Q:Y<1
 . S PROMPT="Select "_$S($D(BDGPAT):"Another ",1:"")_"PATIENT Record"
 . ;
 . ;IHS/ITSC/LJF 5/13/2005 PATCH 1003 add screen to patient lookup
 . ;S Y=+$$READ^BDGF("PO^9009016.1:EQMZ",PROMPT) I Y>0 S BDGPAT(Y)=""
 . S Y=+$$READ^BDGF("PO^9009016.1:EQMZ",PROMPT,"","",SCREEN) I Y>0 S BDGPAT(Y)=""
 Q:'$D(BDGPAT)
 ;IHS/ITSC/LJF PATCH 1003 end of changes
 ;
 D ZIS^BDGF("PQ","PRINT^BDGICF1","DEFICIENCY WORKSHEETS","BDGT;BDGPAT(")
 Q
 ;
 ;
PRINT ;EP; entry point to print
 U IO
 ;
 ;IHS/OIT/LJF 02/16/2006 PATCH 1005 set delinquent date
 NEW BDGDELQ S BDGDELQ=$$FMADD^XLFDT(DT,-$$GET1^DIQ(9009020.1,$$DIV^BSDU,.12))
 ;
 NEW IEN
 S IEN=0 F  S IEN=$O(BDGPAT(IEN)) Q:'IEN  D
 . I $$GET1^DIQ(9009016.1,IEN,.14)]"" Q         ;not incomplete
 . I '$O(^BDGIC(IEN,1,0)) Q                     ;no deficiencies added yet
 . I BDGT=1 Q:$$GET1^DIQ(9009016.1,IEN,.02)=""  ;not inpt
 . I BDGT=2 Q:$$GET1^DIQ(9009016.1,IEN,.05)=""  ;not day surgery
 . D ONE
 ;
 D ^%ZISC
 Q
 ;
ONE ; print one worksheet
 ;IHS/OIT/LJF 02/16/2006 PATCH 1005 reworte subroutine to mark as delinquent,
 ;                         add coding status and deficiency comments
 NEW DFN,TYPE,PRV,PRVN,FIRST,ARRAY,DATE,X
 S DFN=+$G(^BDGIC(IEN,0)) Q:'DFN
 S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392)
 S DATE=$$GET1^DIQ(9009016.1,IEN,$S(TYPE["HOS":.02,TYPE["DAY":.05,1:.02),"I")
 I DATE<BDGDELQ W !!,?19,"DEFICIENCY WORKSHEET **DELINQUENT CHART**"
 E  W !!,?30,"DEFICIENCY WORKSHEET"
 ;
 ;IHS/OIT/LJF 02/24/2006 PATCH 1005
 W !?(80-$L(TYPE)/2),TYPE
 ;W !!!,"Chart #: ",$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 ;W ?20,$S(TYPE="HOSPITALIZATION":"Discharged on ",1:"Surgery on ")
 ;W $P($$GET1^DIQ(9009016.1,IEN,$S(TYPE["HOS":".02",1:".05")),"@")
 W !!,"Chart #: ",$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 W ?20,$S(TYPE="DAY SURGERY":"Surgery on ",1:"Discharged on ")
 W $P($$GET1^DIQ(9009016.1,IEN,$S(TYPE["DAY":".05",1:".02")),"@")
 ;
 W ?50,"Date Printed: ",$$FMTE^XLFDT(DT),!
 ;
 ; coding status and who coded
 S X=$$GET1^DIQ(9009016.1,IEN,.13)
 I X]"" W !,"Chart Coded On: ",X," by ",$$GET1^DIQ(9009016.1,IEN,.22),!
 ;
 ; find all deficiencies by provider
 S PRV=0 F  S PRV=$O(^BDGIC(IEN,1,"B",PRV)) Q:'PRV  D
 . S PRVN=0 F  S PRVN=$O(^BDGIC(IEN,1,"B",PRV,PRVN)) Q:'PRVN  D
 .. Q:$$GET1^DIQ(9009016.11,PRVN_","_IEN,.03)]""  ;resolved
 .. Q:$$GET1^DIQ(9009016.11,PRVN_","_IEN,.04)]""  ;deleted
 .. S ARRAY($$GET1^DIQ(200,PRV,.01),PRVN)=""  ;put in alpha order
 ;
 S FIRST=1,NAME=0 F  S NAME=$O(ARRAY(NAME)) Q:NAME=""  D
 . S PRV=0 F  S PRV=$O(ARRAY(NAME,PRV)) Q:'PRV  D
 .. I FIRST W !!,NAME,?35
 .. W $$GET1^DIQ(9009016.11,PRV_","_IEN,.02)                      ;deficiency name
 .. S X=$$GET1^DIQ(9009016.11,PRV_","_IEN,.06) I X]"" W !,?40,X   ;comments
 .. W !,?35
 ;
 W @IOF
 Q
 ;
