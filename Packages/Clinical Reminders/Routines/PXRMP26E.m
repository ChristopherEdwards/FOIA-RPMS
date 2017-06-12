PXRMP26E ;SLC/PKR - Exchange inits for PXRM*2.0*26 ;6/24/2014
 ;;2.0;CLINICAL REMINDERS;**26**;Feb 04, 2005;Build 404
 ;====================================================
EXARRAY(MODE,ARRAY) ;List of exchange entries used by delete and install
 ;MODE values: I for include in build, A for include action.
 N LN
 S LN=0
 ;
 S LN=LN+1
 S ARRAY(LN,1)="PXRM PATCH 26 DIALOG UPDATES"
 I MODE["I" S ARRAY(LN,2)="09/17/2013@19:18:42"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="PXRM PATCH 26 ECOE UPDATE"
 I MODE["I" S ARRAY(LN,2)="04/17/2014@17:06:32"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="PXRM PATCH 26 PALLIATIVE CARE UPDATE"
 I MODE["I" S ARRAY(LN,2)="04/17/2014@17:05:45"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 S LN=LN+1
 S ARRAY(LN,1)="PXRM*2*26 NATIONAL TAXONOMIES"
 I MODE["I" S ARRAY(LN,2)="06/24/2014@09:51:15"
 I MODE["A" S ARRAY(LN,3)="O"
 ;
 I MODE="IA" D BMES^XPDUTL("There are "_LN_" Reminder Exchange entries to be installed.")
 Q
 ;
