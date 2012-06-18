AZHZCL2 ;DSD/PDW - print patients with ()&/ edits : tests active patients  ; AUGUST 14, 1992
 ;;1.0;AZHZ;;AUG 14, 1992
 ;---------------------------------------------------------------------
PUNPRT ;
 ;---------------------------------------------------------------------
ACTIVE ;ENTRY POINT for testing to see if patient is active
 ;SETS AZHZAAP=1 if patient has active HRN records
 S AZHZAAP=0 I $D(^AUPNPAT(DFN,41,0)),+$O(^(0)) S AZHZAS=0 F  S AZHZAS=$O(^AUPNPAT(DFN,41,AZHZAS)) Q:'+AZHZAS  S:$P(^(AZHZAS,0),U,3)="" AZHZAAP=1
EACT K AZHZAS Q  ;----
 ;---------------------------------------------------------------------
