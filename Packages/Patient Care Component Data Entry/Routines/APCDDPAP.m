APCDDPAP ; IHS/CMI/LAB - DISPLAY EXISTING LAB DATA FOR PATIENT ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;called from data entry input templates
 ;APCDVSIT must = visit dfn
 ;
START ;
 NEW X
 W !!?29,"PAP SMEAR RESULTS",!!,"Patient Name: ",$P(^DPT(AUPNPAT,0),U),"     ","Patient Age: ",$J((AUPNDAYS/365.25),6,1)," years"
 W !!?5,"Date/Time of Visit",?28,"Pap Smear Result",?55,"Test Name",!?5,"------------------",?28,"----------------",?55,"---------"
 I '$D(^AUPNVLAB("AC",AUPNPAT)) W !,"NO Pap Smear Lab Tests on File",! Q
 S DIC="^LAB(60,",X="PAP SMEAR",DIC(0)="M" D ^DIC K DIC I Y=-1 W !,$C(7),$C(7),"PAP SMEAR NOT FOUND IN LABORATORY TEST FILE" K Y Q
 S APCDDPAP("TEST",+Y)=""
 S T=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 I T S (X,Y)=0 F  S X=$O(^ATXLAB(T,21,"B",X)) Q:X'=+X  S APCDDPAP("TEST",X)=""
 ;I '$D(^AUPNVLAB("AA",AUPNPAT,+Y)) W !,"NO Pap Smear Lab Tests on File",! K Y Q
 S X="" F  S X=$O(APCDDPAP("TEST",X)) Q:X'=+X  D
 .S APCDDPAP("IDATE")=0 F  S APCDDPAP("IDATE")=$O(^AUPNVLAB("AA",AUPNPAT,X,APCDDPAP("IDATE"))) Q:APCDDPAP("IDATE")=""  D
 .. S APCDDPAP("X")=0 F  S APCDDPAP("X")=$O(^AUPNVLAB("AA",AUPNPAT,X,APCDDPAP("IDATE"),APCDDPAP("X"))) Q:APCDDPAP("X")=""  D
 ... S APCDDPAP("VDFN")=$P(^AUPNVLAB(APCDDPAP("X"),0),U,3),Y=$P(^AUPNVSIT(APCDDPAP("VDFN"),0),U) D DD^%DT S APCDDPAP("VDATE")=Y
 ... W !?5,APCDDPAP("VDATE"),?28,$S($P(^AUPNVLAB(APCDDPAP("X"),0),U,4)]"":$P(^AUPNVLAB(APCDDPAP("X"),0),U,4),1:"NO RESULTS ON FILE"),?55,$P(^LAB(60,X,0),U)
 ... Q
 . Q
 K APCDDPAP,Y
 Q
