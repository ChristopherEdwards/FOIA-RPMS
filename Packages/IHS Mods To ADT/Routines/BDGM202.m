BDGM202 ; IHS/ANMC/LJF - HSA-202 QUEUE ;  [ 03/04/2004  1:55 PM ]
 ;;5.3;PIMS;**1004**;MAY 28, 2004
 ;IHS/OIT/LJF 07/15/2005 PATCH 1004 added check for earliest date
 ;
ONE ;EP; entry point for M202 (one month)
 NEW BDGBM,BDGEM
 ;IHS/ITSC/WAR 3/2/04 Added loop and earliest date check.
 S BDGBM=0
 F  Q:BDGBM  D
 .S BDGBM=$$READ^BDGF("DO^:"_DT_":EP","Print Report for Which Month")
 .I +BDGBM'=0,(BDGBM<$$GET1^DIQ(43,1_",GL",10,"I")) D
 ..W !!,"Date can not be earlier than "_$$GET1^DIQ(43,1_",GL",10),!
 ..D PAUSE^BDGF
 ..S BDGBM=0
 .E  D
 ..I +BDGBM=0 S BDGBM=-1 Q
 Q:BDGBM<1
 S BDGEM=BDGBM
 ;
 D ZIS^BDGF("PQ","^BDGM202A","M202 REPORT","BDGBM;BDGEM")
 D HOME^%ZIS
 Q
 ;
 ;
RANGE ;EP; entry point for Y202 (range of months)
 ;NEW BDGBM,BDGEM
 S BDGBM=$$READ^BDGF("DO^::EP","Start Report with Which Month")
 ;
 ;IHS/OIT/LJF 7/15/2005 PATCH 1004 code added
 I +BDGBM'=0,(BDGBM<$$GET1^DIQ(43,1_",GL",10,"I")) D  Q
 . W !!,"Date can not be earlier than "_$$GET1^DIQ(43,1_",GL",10),!
 . D PAUSE^BDGF
 ;IHS/OIT/LJF end of new code
 ;
 Q:BDGBM<1
 S BDGEM=$$READ^BDGF("DO^::EP","End Report with Which Month")
 Q:BDGEM<1
 I BDGEM<BDGBM W !!,"Sorry, END date must not be less than START date" D RANGE Q
 ;
 D ZIS^BDGF("PQ","^BDGM202A","Y202 REPORT","BDGBM;BDGEM")
 D HOME^%ZIS
 Q
