ABMDECAN ; IHS/ASDST/DMJ - Cancel Selected Claim ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; 03/10/04 V2.5 Patch 5 - Deny cancel claim if bill attached
 ;
 ; IHS/SD/SDR - V2.5 P8
 ;     Added code for cancellation reason
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20454
 ;   Fix cancellation when replacement insurer present
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option.  Also added call to populate cashiering session
 ;   with claim/bill number if they are cancelling.
 ;   Also added who cancelled bill, when, and reason (.111,.112,.113)
 ;   
 K ABMP
 S U="^"
 S ABMP("XMIT")=0
 ;
SEL ;
 W !!
 D ^ABMDEDIC
 G XIT:X=""!$D(DUOUT)!$D(DTOUT)!'+$G(ABMP("CDFN"))
 I +Y<1 G SEL
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),65)) D  G:ABMACBEX SEL
 .S ABMACBEX=0
 .S D1=0
 .F  S D1=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),65,D1)) Q:'D1  D
 ..I +^ABMDCLM(DUZ(2),ABMP("CDFN"),65,D1,0) S ABMACBEX=1
 .I $G(ABMACBEX) D
 ..W !,*7,"An active bill exists for this claim.  Cancelling of claim not allowed!"
 .K D1
 K ABMACBEX
 L +^ABMDCLM(DUZ(2),ABMP("CDFN")):0 I '$T W !?5,*7,"Another User is Editing this Record!" G SEL
 D ENT
 G XIT:$D(DUOUT)!$D(DTOUT),SEL
 ;
XIT ;
 L -^ABMDCLM(DUZ(2))
 K ABMP
 F  W ! Q:$Y+3>IOSL
 S DIR(0)="E" D ^DIR K DIR
 Q
 ;
ENT ;EP - to Cancel a Claim
 I '$D(^XUSEC("ABMDZ CANCEL CLAIM",DUZ)) W !!,"You don't have enough access to cancel claims",! Q
 W !,*7,"WARNING: If you cancel this Claim it will be deleted and no further Editing",!?9,"or Approvals can occur.",!
 ;
ENT2 ;EP - BYPASS THE WARNING
 S DIR(0)="Y"
 S DIR("A")="Do you wish Claim Number "_ABMP("CDFN")_" DELETED (Y/N)"
 D ^DIR
 I Y'=1 Q
 W !
 S DIE="^ABMCCLMS(DUZ(2),"
 S DA=ABMP("CDFN")
 S DIE("NO^")="OUTOK"
 S DR=".04////X;.114////"_DUZ_";.115///NOW;.118R~Cancellation REASON:"
 D ^DIE
 I $P($G(^ABMCCLMS(DUZ(2),ABMP("CDFN"),1)),U,8)="" D  Q
 .W !!,"CLAIM NOT CANCELLED"
 .S DIK="^ABMCCLMS(DUZ(2),"
 .S DA=ABMP("CDFN")
 .D ^DIK
 M ^ABMCCLMS(DUZ(2),ABMP("CDFN"),0)=^ABMDCLM(DUZ(2),ABMP("CDFN"),0)
 M ^ABMCCLMS(DUZ(2),ABMP("CDFN"),11)=^ABMDCLM(DUZ(2),ABMP("CDFN"),11)  ;PCC Visits
 M ^ABMCCLMS(DUZ(2),ABMP("CDFN"),41)=^ABMDCLM(DUZ(2),ABMP("CDFN"),41)  ;Providers
 S DIK="^ABMCCLMS(DUZ(2),"
 S DA=ABMP("CDFN")
 D IX^DIK  ;merged entries don't x-ref
 W !!,"OK, the claim is being deleted..."
 S DR=".04///1" D KCLM
 W !!,"Claim Number: ",ABMP("CDFN")," has been Deleted!"
 S ^ABMDTMP("KCLM",DT,ABMP("CDFN"))=DUZ
 Q
 ;
KCLM ;EP for Deleting Claim
 S DIE="^AUPNVSIT("
 S DA=0 F  S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,DA)) Q:'DA  D
 .Q:$O(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN"),""))]""
 .Q:'$D(^AUPNVSIT(DA,0))
 .D ^ABMDDIE
 S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),15,0))
 I DA D
 .Q:$O(^ABMDBILL(DUZ(2),"AS",ABMP("CDFN"),""))]""
 .Q:'$D(^AAPCRCDS(DA,0))
 .S ^AAPCRCDS("ACAN",DA)=ABMP("CDFN")
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D ADDBENTR^ABMUCUTL("CCLM",ABMP("CDFN"))  ;add clm to UFMS Cash. Session
 S DIK="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 D ^ABMDEDIK
 Q
 ;
BILL ;EP - to cancel a Bill
 W !
 K ABMP
 S U="^"
 S ABMP("XMIT")=0
 ;
BSEL ;
 ; Ask the user which bill to cancel
 K DIC
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="QEAM"
 S DIC("A")="Select BILL to CANCEL: "
 S DIC("S")="I $P(^(0),""^"",4)'=""X"""
 D BENT^ABMDBDIC
 G XIT:'$G(ABMP("BDFN"))!$D(DUOUT)!$D(DTOUT)
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),"^",4)="X" D  G XIT
 .W !,"Already canceled."
 .F  W ! Q:$Y+4>IOSL
 .S DIR(0)="E" D ^DIR K DIR
 S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)
 S (ABMP(0),ABMP)=0
 F  S ABMP=$O(^ABMDCLM(DUZ(2),+ABMP("BILL"),65,ABMP)) Q:'ABMP  D
 .S:ABMP=ABMP("BDFN") ABMP(0)=1
 .I ABMP'=ABMP("BDFN"),$D(^ABMDBILL(DUZ(2),ABMP)) S ABMP("SIS",ABMP)=""
 .Q
 K:'ABMP(0) ABMP("SIS")
 I '$D(ABMP("SIS")) G SINGL
 W !!,"The following Bills are all associated and can only be",!,"canceled in a group manner: ",ABMP("BILL")
 S ABMP=""
 F  S ABMP=$O(ABMP("SIS",ABMP)) Q:'ABMP  W ",",$P(^ABMDBILL(DUZ(2),ABMP,0),U)
 W !
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you want to CANCEL all of these Bills (Y/N)"
 D ^DIR
 I Y'=1!$D(DIRUT) G XIT
 G EXP
 ;
SINGL ;
 ; Cancel a single bill
 K DIR
 W !
 S DIR(0)="YO"
 S DIR("A")="Do you wish Bill Number "_ABMP("BILL")_" CANCELED (Y/N)"
 D ^DIR K DIR
 I Y'=1!$D(DIRUT) G XIT
 ;
EXP ;
 ; Check to see if bill was already exported "billed"
 I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,4)="B",ABMP("BILL")'=+ABMP("BILL") D
 .W *7,!!?5,"**** Bill Number ",ABMP("BILL")," was ALREADY PRINTED/EXPORTED! ****"
 .S ABMP("DEL")=""
 I  D
 .W !
 .S DIR(0)="YO"
 .S DIR("A")="Are you Positive that you want to CANCEL this Bill (Y/N)"
 .D ^DIR K DIR
 I Y'=1!$D(DIRUT) G XIT
 W !!,"Canceling..."
 ;
OPEN ;
 ; If bill was manually entered, cancel it and exit
 I ABMP("BILL")=+ABMP("BILL") D BKILL G XIT
 ; If claim does not exist cancel the bill and allow claim editing
 I '$D(^ABMDCLM(DUZ(2),+ABMP("BILL"),0)) W !!,"Claim Number: ",+ABMP("BILL")," has been Canceled, thus cannot be Opened for Editing!" G TRK
 L +^ABMDCLM(DUZ(2),+ABMP("BILL")):0 I '$T W !?5,*7,"Another User is Editing the CLAIM, try Later!" G XIT
 S ABMP("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)  ;Active ins
 S DA=+ABMP("BILL")
 S DIE="^ABMDCLM(DUZ(2),"
 S DR=".04////E;.08////"_ABMP("INS")
 D ^DIE  ; mark claim in edit status and stuff active ins
 K DR
 S DA(1)=DA
 S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 S DA=0
 ; Update insurer/provider multiple
 F  S DA=$O(^ABMDCLM(DUZ(2),DA(1),13,DA)) Q:'DA  D
 .I $P(^ABMDCLM(DUZ(2),DA(1),13,DA,0),U)=ABMP("INS")!($P($G(^ABMDCLM(DUZ(2),DA(1),13,DA,0)),U,11)=ABMP("INS")) D  Q
 ..S DR=".03////I"
 ..D ^DIE
 .I $P(^ABMDCLM(DUZ(2),DA(1),13,DA,0),U,3)="I",($P(^(0),U)'=ABMP("INS")!($P($G(^ABMDCLM(DUZ(2),DA(1),13,DA,0)),U,11)'=ABMP("INS"))) D
 ..S DR=".03////P"
 ..D ^DIE
 ;
TRK ;
 ; if bill already exported. . .
 I $D(ABMP("DEL")),$D(^ABPVFAC("B",ABMP("BILL"))) D
 .S DIK="^ABPVFAC("
 .S DA=$O(^ABPVFAC("B",ABMP("BILL"),0))
 .D ^DIK
 .Q
 D BKILL
 ; If single bill. . . 
 I '$D(ABMP("SIS")) G MSG
 ; Loop through and cancel all related bills.
 S ABMP("BDFN")=""
 F  S ABMP("BDFN")=$O(ABMP("SIS",ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 .S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)
 .D BKILL
 ;
MSG ;
 W !,"Claim Number: ",+ABMP("BILL")," is now Open for Editing!"
 G XIT
 ;
BKILL ;CANCEL BILL
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".04////X;.111////"_DUZ_";.112///NOW;.113R"
 D ^DIE
 D ADDBENTR^ABMUCUTL("CBILL",ABMP("BDFN"))  ;add bill to UFMS Cash. Session
 W !!,"Bill Number: ",ABMP("BILL")," has been Canceled!",!
 Q
