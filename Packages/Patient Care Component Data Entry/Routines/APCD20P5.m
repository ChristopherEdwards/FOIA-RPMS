APCD20P5 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 4 [ 03/12/03  11:34 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**4,5**;MAR 09, 1999
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
 ;
PRE ;EP
 I '$O(^DIC(19,"B","APCD ORPHANED VISIT MENU",0)) D
 .D RENAME^XPDMENU("APCD ORPHANED LAB MENU","APCD ORPHANED VISIT MENU")
 Q
POST ;
 ;D ^APC5INIT
 NEW X
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
 D IIM
 D ^APCDBUL5
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
