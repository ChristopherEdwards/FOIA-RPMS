BCHUIN ; IHS/CMI/LAB - INITIALIZE AND SET UP PARAMETERS ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
 ;
START ;EP - called from BCHLE
 I '$D(IOF) D HOME^%ZIS
 S BCHDASH="--------------------------------------------------------------------------------"
 S APCDOVRR="" ;FOR PROVIDER NARRATIVE LOOKUP
 S BCHUIN="" ;variable to let system know we're in CHR DE
 S BCHPKG=$O(^DIC(9.4,"C","BCH",""))
 K BCHPKG
 Q
