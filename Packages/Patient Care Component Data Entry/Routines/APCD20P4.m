APCD20P4 ; IHS/CMI/TUCSON - DATA ENTRY PATCH 4 [ 03/27/01  8:55 AM ]
 ;;2.0;IHS RPMS/PCC Data Entry;**4**;MAR 09, 1999
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
 ;
POST ;
P4P ;patch 4 post init
 NEW APCDT,APCDJ,APCDX,APCDM,APCD17,APCD18
 ;populate cohort list entry in all mnemonics
 S APCDT="CLO" F APCDJ=1:1 S APCDX=$T(@APCDT+APCDJ) Q:APCDX=""  D
 .S APCDM=$P(APCDX,";;",2),APCD17=$P(APCDX,";;",3),APCD18=$P(APCDX,";;",4)
 .S DA=$O(^APCDTKW("B",APCDM,0))
 .I 'DA W !,"Could not find mnemonic ",APCDM," to update." H 3 Q
 .S DIE="^APCDTKW(",DR=".17///"_APCD17_";.18///"_APCD18 D ^DIE
 .I $D(Y) W !,"Failure updating mnemonic ",APCDM,"." H 3 Q
 .K DIE,DA,DR,DIU,DIV,DIW,Y,X
 .Q
 D OVR
 D HFOB
 D HSIG
 D HBE
 D HCOL
 D ECO2
 D ECO3
 D TRC
 D UNH
 D ^APC4INIT
 NEW X
 S X=$$ADD^XPDMENU("APCD MENU ENTER DATA","APCDECOHORT ENTRY","EC",82)
 I 'X W "Attempt to add COHORT Data Entry option failed." H 3
 D ^APCDBUL4
 Q
HFOB ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HFOB"))
 S X="HFOB",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HFOB];.06///Historical FOBT (GUAIAC);.07///0;.08///0;.09///9000010.18;.12///Historical FOBT;.15///31;.16///31"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HFOB mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HBE ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HBE"))
 S X="HBE",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HBE];.06///Historical Barium Enema;.07///0;.08///0;.09///9000010.18;.12///Historical BE;.15///33;.16///33"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HBE mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HCOL ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HCOL"))
 S X="HCOL",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HCOL];.06///Historical Colonoscopy;.07///0;.08///0;.09///9000010.18;.12///Hist. Colonoscopy;.15///34;.16///34"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HCOL mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
HSIG ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","HSIG"))
 S X="HSIG",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD HSIG];.06///Historical Sigmoidoscopy;.07///0;.08///0;.09///9000010.18;.12///Hist. Sigmoidoscopy;.15///32;.16///32"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding HSIG mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
OVR ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","OVR"))
 S X="OVR",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000001;.04///[APCD OVR];.06///Health Reminder Override;.07///0;.08///0;.09///9000025"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding OVR mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
CPE ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","3MCPE"))
 S X="3MCPE",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD 3MCPE];.06///CPE Mnemonic to File 3m CPT;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding 3MCPE mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
UNH ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","UNH"))
 S X="UNH",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD UNH];.06///Auditory Evoked Potential Exam;.07///0;.08///1;.09///9000010.38;.12///Auditory Evoked Exam;.13///22;.14///9000010.38"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding UNH mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
TRC ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","TRC"))
 S X="TRC",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".03///9000010;.04///[APCD TRC];.06///Treatment Contracts;.07///0;.08///1;.09///9000010.39"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding TRC mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
ECO2 ;chief complaint mnemonic
 D ^XBFMK
 Q:$D(^APCDTKW("B","ECO2"))
 S X="ECO2",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD ECO2];.06///Append a 2nd E-Code to a POV;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding ECO2 mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
 ;
ECO3 ;
 D ^XBFMK
 Q:$D(^APCDTKW("B","ECO3"))
 S X="ECO3",DIC(0)="L",DIC="^APCDTKW(",DIC("DR")=".02///S;.03///9000010;.04///[APCD ECO3];.06///Append a 3rd E-Code to a POV;.07///0;.08///1"
 K DD,D0,DO
 D FILE^DICN
 I Y=-1 W !!,"Adding ECO3 mnemonic failed." H 4
 K DIC,DD,D0,DO
 Q
 ;
CLO ;
 ;;AG;;;;5.0
 ;;AL;;;;65.0
 ;;APPT;;;;70.0
 ;;AT;;160.0;;
 ;;AUD;;;;40.0
 ;;BM;;;;62.0
 ;;BP;;15.0;;
 ;;BS;;115.0;;
 ;;BT;;;;85.0
 ;;CBC;;120.0
 ;;CC;;;;90.0
 ;;CHT;;;;45.0
 ;;CKO;;;;75.0
 ;;CPT;;75.0
 ;;CXD;;;;10.0
 ;;DC;;;;95.0
 ;;ED;;;;15.0
 ;;EDC;;197.0
 ;;EFF;;;;20.0
 ;;EKG;;155.0
 ;;EL;;175.0
 ;;EM;;65.0
 ;;ER;;170.0
 ;;EX;;78.0
 ;;FHX;;;;100.0
 ;;FM;;190.0
 ;;FP;;195.0
 ;;FT;;;;25.0
 ;;GP;;;;110.0
 ;;GWT;;;;50.0
 ;;HC;;30.0
 ;;HCT;;105.0
 ;;HE;;35.0
 ;;HF;;145.0
 ;;HT;;20.0
 ;;IM;;80.0
 ;;KWT;;;;55.0
 ;;LAB;;95.0
 ;;LMP;;185.0
 ;;NMI;;;;125.0
 ;;NRF;;;;130.0
 ;;OP;;70.0
 ;;PAP;;110.0
 ;;PCP;;;;96.0
 ;;PED;;140.0
 ;;PHN;;165.0
 ;;PHX;;;;105.0
 ;;PR;;;;30.0
 ;;PRV;;5.0
 ;;PRX;;125.0
 ;;PT;;130.0
 ;;PU;;55.0
 ;;PV;;10.0
 ;;RAD;;150.0
 ;;REF;;;;120.0
 ;;RF;;180.0
 ;;RS;;60.0
 ;;ST;;85.0
 ;;STG;;;;115.0
 ;;STN;;;;35.0
 ;;STP;;90.0
 ;;TA;;;;76.0
 ;;TD;;;;80.0
 ;;TMP;;50.0
 ;;TON;;;;60.0
 ;;TP;;135.00
 ;;UA;;100.0
 ;;VC;;45.0
 ;;VU;;40.0
 ;;WT;;25.0
