PXRMP34E ;SLC/PKR - Exchange inits for PXRM*2.0*34 ;11/05/2013
 ;;2.0;CLINICAL REMINDERS;**34**;Feb 04, 2005;Build 195
 ;====================================================
EXARRAY(MODE,ARRAY) ;List of exchange entries used by delete and install
 ;MODE values: I for include in build, A for include action.
 N LN
 S LN=0
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-TERATOGENIC MEDICATIONS ORDER CHECKS (UPDATE #1)"
 I MODE["I" S ARRAY(LN,2)="11/05/2013@10:52:08"
 I MODE["A" S ARRAY(LN,3)="I"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-ECOE PATCH 30 ELEMENT UPDATE"
 I MODE["I" S ARRAY(LN,2)="10/28/2013@08:21:36"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
 Q
 ;
