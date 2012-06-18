APCDDLAB ; IHS/CMI/LAB - DISPLAY EXISTING LAB DATA FOR VISIT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;called from data entry input templates
 ;APCDVSIT must = visit dfn
 ;
START ;
 I '$D(^AUPNVLAB("AD",APCDVSIT)) W !!?18,"No Lab Tests currently entered for this visit.",! Q
 W !!?18,"CURRENT LAB TESTS AND RESULTS FOR THIS VISIT",!,"Visit Date: " S Y=APCDDATE D DD^%DT W Y W ?35,"Patient Name: ",$P(^DPT(AUPNPAT,0),U)
 S APCDDLAB("X")=0 F  S APCDDLAB("X")=$O(^AUPNVLAB("AD",APCDVSIT,APCDDLAB("X"))) Q:APCDDLAB("X")=""  D
 . W !,$P(^LAB(60,$P(^AUPNVLAB(APCDDLAB("X"),0),U),0),U),?35,$P(^AUPNVLAB(APCDDLAB("X"),0),U,4)
 . Q
 K APCDDLAB,Y
 Q
