BWUCVRC ;IHS/CIA/DKM - Import race from patient file. ;29-Oct-2003 21:39;PLS
 ;;2.0;WOMEN'S HEALTH;**8,9**;22-May-2003 14:55
 ;=================================================================
 W "Program to import patient race into BW PATIENT file",!
 W "Only those races supported by the BW RACE MAPPINGS file ",!
 W "will be imported. If a race is not found, the race will ",!
 W "be inferred using tribal affliation.",!
 W "Use entry point START to initiate process.",!!
 Q
START ; EP
 N DFN,IEN,RC,CNT,ALL
 W "Importing race from PATIENT file into BW PATIENT file"
 S (ALL,DFN)=0
 F  S DFN=$O(^BWP(DFN)) Q:'DFN  D:'$O(^(DFN,2,0))
 .W "."
 .S (IEN,CNT)=0
 .F  S IEN=$O(^AUPNPAT(DFN,62,IEN)) Q:'IEN  S RC=+$G(^(IEN,0)) D
 ..D ADDRC(+$E("513427",RC))
 .I 'CNT D
 ..S RC=+$P($G(^AUPNPAT(DFN,11)),U,8)
 ..Q:'RC
 ..S RC=+$O(^BWRACE("C",RC,0))
 ..S:'RC RC=5
 ..D ADDRC(RC)
 .S:CNT ^BWP(DFN,2,0)="^9002086.07P^"_CNT_U_CNT,ALL=ALL+1
 W !!,"Import completed for ",ALL," patients.",!!
 Q
ADDRC(RC) ;
 S:RC CNT=CNT+1,^BWP(DFN,2,CNT,0)=RC,^BWP(DFN,2,"B",RC,CNT)=""
 Q
