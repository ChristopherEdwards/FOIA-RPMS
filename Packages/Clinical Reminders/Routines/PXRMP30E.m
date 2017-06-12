PXRMP30E ;SLC/PKR - Exchange inits for PXRM*2.0*30 ;08/28/2013
 ;;2.0;CLINICAL REMINDERS;**30**;Feb 04, 2005;Build 206
 ;====================================================
EXARRAY(MODE,ARRAY) ;List of exchange entries used by delete and install
 ;MODE values: I for include in build, A for include action.
 N LN
 S LN=0
 ;
 S LN=LN+1
 S ARRAY(LN,1)="ECOE REMINDER DIALOGS"
 I MODE["I" S ARRAY(LN,2)="08/28/2013@09:38:02"
 I MODE["A" S ARRAY(LN,3)="U"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-URL UPDATE CARRIER ELEMENT"
 I MODE["I" S ARRAY(LN,2)="04/04/2013@08:01:11"
 I MODE["A" S ARRAY(LN,3)="O"
 S LN=LN+1
 S ARRAY(LN,1)="VA-URL UPDATE CARRIER ELEMENT 2"
 I MODE["I" S ARRAY(LN,2)="04/10/2013@10:00:23"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
 Q
 ;
