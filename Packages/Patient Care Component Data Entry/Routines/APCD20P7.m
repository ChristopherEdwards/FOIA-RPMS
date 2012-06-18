APCD20P7 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 7 [ 03/18/04  2:18 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**7**;MAR 09, 1999
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
 ;
PRE ;EP
 F DA=1:1:200 S DIK="^APCDERR(" D ^DIK
 K DA,DIK
 I '$O(^DIC(19,"B","APCD ORPHANED VISIT MENU",0)) D
 .D RENAME^XPDMENU("APCD ORPHANED LAB MENU","APCD ORPHANED VISIT MENU")
 Q
POST ;
 NEW X
 S X=$$DELETE^XPDMENU("APCDSUPER","APCD NEW ALLERGY LIST")
 S X=$$DELETE^XPDMENU("APCDSUPER","APCD PL ALLERGY LIST")
 S X=$$ADD^XPDMENU("APCDMENU","APCD VISIT DISPLAY - LAB","DVB")
 I 'X W "Attempt to add visit display visit option failed." H 3
 S X=$$ADD^XPDMENU("APCDSUPER","APCD ALLERGY REPORTS","PLAL")
 I 'X W "Attempt to add patient allergy list option failed." H 3
 S X=$$ADD^XPDMENU("APCDSUPER","APCD UPDATE PCC MASTER CONTROL","UAPL")
 I 'X W "Attempt to add update pcc master control option failed." H 3
 S X=$$ADD^XPDMENU("APCD ORPHANED VISIT MENU","APCD COMP ORPHAN IMM VISITS","IM")
 I 'X W "Attempt to add Orphaned Immunization visit option failed." H 3
 S X=$$ADD^XPDMENU("APCD ORPHANED VISIT MENU","APCD COMP ORPHAN BLOOD BANK","BB")
 I 'X W "Attempt to add Orphaned Blood Bank visit option failed." H 3
 S X=$$ADD^XPDMENU("APCD ORPHANED VISIT MENU","APCD COMPLETE MICRO VISITS","MIC")
 I 'X W "Attempt to add Orphaned Microbiology visit option failed." H 3
 S X=$$ADD^XPDMENU("APCD LTM MENU","APCD TABLE CLINIC LIST","CL")
 I 'X W "Attempt to add clinic list visit option failed." H 3
 S X=$$ADD^XPDMENU("APCDMENU","APCD PRINT PCC VISIT","PDV")
 I 'X W "Attempt to add Print PCC form option failed." H 3
 S X=$$ADD^XPDMENU("APCD MENU UTILITIES","APCDVMDD","MR2")
 I 'X W "Attempt to add Merge 2 visits/2 days option failed." H 3
 S X=$$ADD^XPDMENU("APCD MENU UTILITIES","APCD REPRINT GROUP FORMS","RGF")
 I 'X W "Attempt to add re-print group forms option failed." H 3
 D AST
 D CC
 D COC
 D PCF
 D PF
 D HAST
 D O2
 D PA
 D CEF
 D IIM
 D HRX
 D ALG
 D HHF
 D UAS
 D ADA
 D HADA
 D ^APCDBUL7
 Q
ALG ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","ALG"))
 S X="ALG",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000001;.04///[APCD ALG];.06///Allergy Tracking Entry;.07///0;.08///0"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding ALG mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
ADA ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","ADA"))
 S X="ADA",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD ADA];.06///ADA Code Entry;.07///0;.08///1;.12///ADA codes;.14///9000010.05;.09///9000010.05"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding ADA mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
UAS ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","UAS"))
 S X="UAS",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD UAS];.06///Unable to Screen;.07///0;.08///0;.09///9000022"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding UAS mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HHF ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HHF"))
 S X="HHF",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HHF];.06///Historical Health Factor;.07///0;.08///0"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HHF mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HADA ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HADA"))
 S X="HADA",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HADA];.06///Historical ADA Code entry;.07///0;.08///0;.09///9000010.05;.12///Historical ADA codes;.14///9000010.05;.15///66;.16///66"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HADA mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HRX ;
 S DA=$O(^APCDTKW("B","HRX",0))
 Q:'DA
 S DR=".15///99;.16///99",DIE="^APCDTKW(" D ^DIE,^XBFMK
 Q
AST ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","AST"))
 S X="AST",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD AST];.06///Asthma;.07///0;.08///1;.09///9000010.41"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding AST mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
 ;
CC ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","CC"))
 S X="CC",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD CC];.06///Chief Complaint;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding CC mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
COC ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","COC"))
 S X="COC",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD COC];.06///Coded Chief Complaint;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding CC mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
PCF ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","PCF"))
 S X="PCF",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD PCF];.06///PCC+ Form;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding PCF mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
PF ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","PF"))
 S X="PF",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""PF"";.06///Peak Flow;.07///0;.08///1;.09///9000010.01"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding PF mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HAST ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HAST"))
 S X="HAST",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HAST];.06///Historical Asthma Data;.07///0;.08///0"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HAST mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
IIM ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","IIM"))
 S X="IIM",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD IIM];.06///In-Hospital Immunization Entry;.07///0;.08///0"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding IIM mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
PA ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","PA"))
 S X="PA",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""PA"";.06///Pain;.07///0;.08///1;.09///9000010.01"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding PA mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
CEF ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","CEF"))
 S X="CEF",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""CEF"";.06///Cardiac Ejection Fraction;.07///0;.08///1;.09///9000010.01"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding CEF mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
O2 ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","O2"))
 S X="O2",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD MEASUREMENT];.05///""O2"";.06///O2 Saturation;.07///0;.08///1;.09///9000010.01"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding O2 mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
 ;
