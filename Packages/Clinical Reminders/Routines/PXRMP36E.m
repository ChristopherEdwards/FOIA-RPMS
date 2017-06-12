PXRMP36E ;SLC/PKR - Exchange inits for PXRM*2.0*36 ;01/23/2014
 ;;2.0;CLINICAL REMINDERS;**36**;Feb 04, 2005;Build 207
 ;====================================================
EXARRAY(MODE,ARRAY) ;List of exchange entries used by delete and install
 ;MODE values: I for include in build, A for include action.
 N LN
 S LN=0
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-PNEUMOCOCCAL REMINDERS"
 I MODE["I" S ARRAY(LN,2)="01/21/2014@17:21:28"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="PATCH 36 WH TAXONOMIES (5)"
 I MODE["I" S ARRAY(LN,2)="09/10/2013@09:02:24"
 I MODE["A" S ARRAY(LN,3)="I"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="VA-PATCH 36 POST COMPONENTS"
 I MODE["I" S ARRAY(LN,2)="11/19/2013@10:39:18"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
 ;
 Q
 ;
