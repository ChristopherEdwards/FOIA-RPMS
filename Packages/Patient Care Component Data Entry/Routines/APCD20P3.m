APCD20P3 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 3 [ 09/03/00  6:52 PM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**3**;MAR 09, 1999
 D ^APCD20P2
 ;
 D NMI
 D CC
 D NRF
 D AOP
 D ^APC3INIT
 NEW X
 S X=$$ADD^XPDMENU("APCD MENU ENTER DATA","APCDEDMUPD","DMU",80)
 I 'X W "Attempt to add DM Data Entry option failed." H 3
 S X=$$ADD^XPDMENU("APCDMENU","APCD PRINT ENCOUNTER FORM","PEF",52)
 I 'X W "Attempt to add Print Encounter Form option failed." H 3
 D DENTAL
 D ^APCDBUL
 Q
DENTAL ;
 Q:$D(^AUTTEXAM("B","DENTAL EXAM"))
 Q:$D(^AUTTEXAM("C",30))
 D ^XBFMK
 S X="DENTAL EXAM",DIC("DR")=".02///30",DIC="^AUTTEXAM(",DIC(0)="L",DLAYGO=9999999.15,DIADD=1 K DD,D0,DO D FILE^DICN
 K DIADD,DLAYGO
 D ^XBFMK
 Q
NMI ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","NMI"))
 S X="NMI",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD NMI];.06///Not Medically Indicated;.07///0;.08///0;.09///9000022"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding NMI mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
NRF ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","NRF"))
 S X="NRF",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD NRF];.06///No Response to Followup;.07///0;.08///0;.09///9000022"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding NRF mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
AOP ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","AOP"))
 S X="AOP",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD AOP];.06///Anesthesia Operation;.07///0;.08///1;.09///9000010.08"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding AOP mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
CC ;chief complaint mnemonic
 D ^XBFMK
 Q:$D(^APCDTKW("B","CC"))
 S X="CC",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD CC];.06///Chief Complaint;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding CC mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
