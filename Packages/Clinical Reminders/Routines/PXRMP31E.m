PXRMP31E ;SLC/PKR - Exchange inits for PXRM*2.0*31 ;01/21/2014
 ;;2.0;CLINICAL REMINDERS;**31**;Feb 04, 2005;Build 206
 ;====================================================
EXARRAY(MODE,ARRAY) ;List of exchange entries used by delete and install
 ;MODE values: I for include in build, A for include action.
 N LN
 S LN=0
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-PALLIATIVE CARE CONSULT"
 I MODE["I" S ARRAY(LN,2)="01/16/2014@11:19:52"
 I MODE["A" S ARRAY(LN,3)="I"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-PATCH 31 POST HS COMPONENTS"
 I MODE["I" S ARRAY(LN,2)="12/12/2013@12:52:09"
 I MODE["A" S ARRAY(LN,3)="I"
 ;
 I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
 Q
 ;
