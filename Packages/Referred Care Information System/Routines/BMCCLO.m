BMCCLO ; IHS/PHXAO/TMJ - CLOSE OUT A REFERRAL ;     [ 09/27/2006  1:32 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**1,2**;JAN 09, 2006
 ;
 ; This option allows the RCIS manager to select and close out
 ; referrals.
 ;
START ;
 S BMCCLOSE=1
 F  D MAIN Q:BMCQ  D HDR^BMC
 D EOJ
 Q
 ;
MAIN ;
 S BMCQ=0
 D REFERRAL ;             get referral record to close out
 Q:BMCQ
 D FINAL ;                get final values
 D STATUS ;               get final status
 Q:BMCQ
 D VERIFY ;               make sure all required fields present
 Q:BMCQ
 D CLOSE ;                close out referral
 D PCCL
 Q
 ;
REFERRAL ; GET REFERRAL TO CLOSE
 S BMCQ=1
 W !
 ;S DIC="^BMCREF(",DIC(0)="AEMQ",DIC("S")="I $$FILTER^BMCFLTR(2,BMCCURFY,0)",DIC("A")="Select RCIS REFERRAL by Patient or by Referral Date or #: "
 S DIC="^BMCREF(",DIC(0)="AEMQ",DIC("S")="I $$FILTER^BMCFLTR(2,BMCCURFY,2)",DIC("A")="Select RCIS REFERRAL by Patient or by Referral Date or #: "
 D DIC^BMCFMC
 Q:Y<1
 S BMCRIEN=+Y
 S BMCQ=0
 Q
 ;
FINAL ; GET FINAL VALUES
 S DIR(0)="YO",DIR("A")="Do you want to enter final values",DIR("B")="Y" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 Q:'Y
 S (BMCDXT,BMCPXT)="F"
 S BMCMODE="M"   ;BMC*4.0*1 IHS/OIT/FCJ 1.19.06
 F  D TYPE^BMCMOD Q:BMCQ  ;      modify referral
 S BMCQ=0
 Q
 ;
STATUS ; GET FINAL STATUS
 W !!
 F  D STATUS2 Q:BMCQ!(BMCSTAT]"")
 Q
 ;
STATUS2 ;
 ;BMC 4.0*2 8/17/06 IHS/OIT/FCJ REMOVED "A" AS AN OPTION NXT SECTION
 S BMCSTAT=""
 ;S DIR(0)="90001,.15",DIR("A")="Enter Final Status",DIR("B")="C1" K DA D ^DIR K DIR
 S DIR(0)="S^C1:CLOSED COMPLETED;X:CLOSED NOT COMPLETED"
 S DIR("A")="Enter Final Status",DIR("B")="C1" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQ=1 Q
 S BMCSTAT=Y
 ;I BMCSTAT="A" S BMCSTAT="" W "    Final status cannot be 'ACTIVE'",!,*7 Q
 Q
 ;
VERIFY ; MAKE SURE ALL REQUIRED FIELDS ARE PRESENT
 Q:BMCSTAT'="C1"
 F  D VERIFY2 Q:BMCLQ
 Q
 ;
VERIFY2 ;
 S BMCLQ=0
 D VERIFY3
 Q:BMCLQ
 W !,*7
 S DIR(0)="Y",DIR("A")="Required fields missing.  Do you want to enter them",DIR("B")="Y" K DA D ^DIR K DIR
 I 'Y S (BMCLQ,BMCQ)=1 Q
 S DIE="^BMCREF(",DA=BMCRIEN
 D DIE^BMCFMC
 Q
 ;
VERIFY3 ;
 S DR=""
 I BMCRTYPE="C" S X=.07 D VERIFYRQ
 I BMCRTYPE="I" S X=.08 D VERIFYRQ
 ; should require either .07 or .09 if type='o'
 F X=1102,1104,1106,1108 D VERIFYRQ
 I BMCRIO="I" S X=1110 D VERIFYRQ
 S:$E(DR)=";" $E(DR)=""
 I DR="" S BMCLQ=1 K DR Q
 Q
 ;
VERIFYRQ ; CHK REQUIRED FIELDS
 I $$VALI^XBDIQ1(90001,BMCRIEN,X)="" S DR=DR_";"_X
 Q
 ;
CLOSE ; CLOSE REFERRAL RECORD
 S DIE="^BMCREF(",DR="[BMC REFERRAL STATUS]",DA=BMCRIEN
 D DIE^BMCFMC
 Q
 ;
PCCL ; PCC LINK
 I $$VALI^XBDIQ1(90001,BMCRIEN,".15")="C1" D ^BMCPCCL
 Q
 ;
EOJ ; END OF JOB
 K BMCMODE D ^BMCKILL ;BMC*4.0*1 IHS/OIT/FCJ 1.19.06
 ;D ^BMCKILL
 Q
