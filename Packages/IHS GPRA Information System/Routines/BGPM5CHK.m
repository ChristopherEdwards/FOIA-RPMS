BGPM5CHK ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON AUG 04, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;
ENV S IN="IHS CLINICAL REPORTING 11.1",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the IHS CLINICAL REPORTING 11.1 before installing this patch"
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"IHS CLINICAL REPORTING 11.1  must be completely installed before installing this patch"
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
PRE ;PRE-INSTALL ROUTINE
 K ^BGPMUIND(90595.11)
 K ^BGPMUIND(90596.11)
 D PRE^BGP1DPA9
 Q
POST ;Post-Install routine
 ;S X=$$RENAME^XPDMENU("BGPMU HOSPITAL PERF MEASURES","HOS")
 ;I 'X W "Attempt to add BGPMU MAIN MENU option failed." H 3
 D POST^BGP1DPA9
 D START^BGPM5
 Q
PATCHCK(XPXPCH) ;
 S X=$$PATCH^XPDUTL(XPXPCH)
 W !!,$$C^XBFUNC("Need "_XPXPCH_"....."_XPXPCH_" "_$S(X:"Is",1:"Is Not")_" Present")
 Q X
