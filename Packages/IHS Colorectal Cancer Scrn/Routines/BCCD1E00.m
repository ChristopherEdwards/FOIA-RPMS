BCCD1E00 ;GDIT/HS/GCD-Pre-Install Environment Check; 18 Apr 2013  12:51 PM
 ;;1.0;CCDA;;Feb 21, 2014
 ;
 ; Run pre-install checks
 N VERSION,EXEC,ROLES,OK,BMWDT,BMWRV
 ;
 ; Verify that BMW classes exist and we have the correct version.
 S BMWRV="01/02/2014"  ; Required version
 S BMWDT=$G(^BMW("fm2class","GenDate"))
 I BMWDT="" D BMES^XPDUTL("Cannot retrieve BMW version") S XPDQUIT=2 I 1
 E  I '$$DTCMP(BMWDT,BMWRV) D BMES^XPDUTL("BMW version "_BMWRV_" or higher required. Current version: "_BMWDT) S XPDQUIT=2
 ;
 ; Add code to check for Ensemble version greater or equal to 2012
 S VERSION=$$VERSION^%ZOSV
 I VERSION<2012.2 D BMES^XPDUTL("Ensemble 2012.2 or later is required!") S XPDQUIT=2
 ;
 ; Check for EHR 1.1 patch 13 by checking for one of its constituent patches
 I '$$PATCH^XPDUTL("BEHO*1.1*001010") D BMES^XPDUTL("EHR patch 13 is required.") S XPDQUIT=2
 ;
 ; Check for C32 1.0 patch 4 iff C32 is installed
 I $$VERSION^XPDUTL("BJMD")="1.0",'$$PATCH^XPDUTL("BJMD*1.0*4") D BMES^XPDUTL("C32 patch 4 is required.") S XPDQUIT=2
 ;
 ; Verify that installer has proper roles
 S EXEC="S ROLES=$roles" X EXEC
 S ROLES=","_ROLES_",",U="^"
 I ROLES'[",%All," D BMES^XPDUTL("Your Ensemble account MUST have ""%All"" role to proceed") S XPDQUIT=2
 ;
 ; Verify the presence of the following two packages
 I '$D(^DD(52.0113)) D BMES^XPDUTL("The package that added Medication Instructions to Prescriptions") D BMES^XPDUTL("file is not installed") S XPDQUIT=2
 I '$D(^DD(50,9999999.145)) D BMES^XPDUTL("The package that added DISPENSE UNIT NCPDP CODE field to Drug") D BMES^XPDUTL("file is not installed") S XPDQUIT=2
 ;
 ; Verify that installation has Long Strings enabled
 S EXEC="S OK=($SYSTEM.SYS.MaxLocalLength()>3600000)" X EXEC
 I 'OK D BMES^XPDUTL("Long Strings are not enabled. Ensemble is not configured correctly.") S XPDQUIT=2
 ;
Q ;
 Q
 ;
 ; Compare two dates in MM/DD/YYYY format. Return 1 if DT1 is equal to or later than DT2.
 ; The second space piece (i.e., the time) for each date is ignored.
DTCMP(DT1,DT2) ;
 I $G(DT1)=""!($G(DT2)="") Q ""
 N DATE1,DATE2
 S DATE1=$P(DT1," "),DATE2=$P(DT2," ")
 ; Parse dates
 S DATE1("Y")=$P(DATE1,"/",3),DATE1("M")=$P(DATE1,"/"),DATE1("D")=$P(DATE1,"/",2)
 S DATE2("Y")=$P(DATE2,"/",3),DATE2("M")=$P(DATE2,"/"),DATE2("D")=$P(DATE2,"/",2)
 ; Compare years
 I DATE1("Y")<DATE2("Y") Q 0
 I DATE1("Y")>DATE2("Y") Q 1
 ; Years are equal, so compare months
 I DATE1("M")<DATE2("M") Q 0
 I DATE1("M")>DATE2("M") Q 1
 ; Years and months are equal, so compare days
 I DATE1("D")<DATE2("D") Q 0
 Q 1
