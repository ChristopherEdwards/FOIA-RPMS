BGPMU4E ;IHS/MSC/SAT - ENVIRONMENT CHECK ROUTINE ;JUN 22, 2011;MMT
 ;;11.0;IHS CLINICAL REPORTING;**4**;JAN 06, 2011;Build 84
 ;
ENV S IN="IHS CLINICAL REPORTING 11.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the IHS CLINICAL REPORTING 11.0 before installing this patch"
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"IHS CLINICAL REPORTING 11.0  must be completely installed before installing this patch"
 I '$$PATCHCK("BGP*11.0*1") D  Q
 .W !,"You must first install the IHS CLINICAL REPORTING 11.0 patch 1 before installing this patch"
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;PRE-INSTALL ROUTINE
 K ^BGPMUIND(90595.11)
 Q
POST ;Post-Install routine
 S X=$$ADD^XPDMENU("BGP 11 REPORTS MENU","BGPMU MAIN MENU","MUP",50)
 I 'X W "Attempt to add BGPMU MAIN MENU option failed." H 3
 S X=$$ADD^XPDMENU("BGPMU MAIN MENU","BGPMU HOSPITAL PERF MEASURES","HOS",20)
 I 'X W "Attempt to add BGPMU HOSPITAL PERF MEASURES option failed." H 3
 D DELDD
 D START^BGPMTX
 D START^BGPM3
 Q
 ;
DELDD ; Delete DD for OLD fields/SubFiles in BGPMU 11 MEASURES
 N DIU
 F DIU=90595.25,90595.35,90595.111,90595.151,90595.153,90595.155,90595.116 D
 .S DIU(0)="SD"
 .D EN^DIU2
 Q
PATCHCK(XPXPCH) ;
 S X=$$PATCH^XPDUTL(XPXPCH)
 W !!,$$C^XBFUNC("Need "_XPXPCH_"....."_XPXPCH_" "_$S(X:"Is",1:"Is Not")_" Present")
 Q X
