PSJENV ;BIR/LDT - ENVIRONMENT CHECK FOR PATCH 56 ; 02 Apr 98 / 1:05 PM
 ;;4.5; Inpatient Medications ;**56**;7 Oct 94
START ;
 I $$VERSION^XPDUTL("PHARMACY DATA MANAGEMENT")
 E  D
 .W !,"Pharmacy Data Management V. 1.0 is not installed on the system. This patch"
 .W !,"is only needed after this package is installed.  This patch DOES NOT need to be installed until after Pharmacy Data Management 1.0 is installed."
 .S XPDQUIT=1
 Q
