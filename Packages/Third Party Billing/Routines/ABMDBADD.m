ABMDBADD ; IHS/ASDST/DMJ - Add Bill Manually Submitted ;   
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
DOC ;
 ; LSL - 12/30/97 - Modified for readability.  Changed ABM array to ABMD
 ;       array as ABMAPASS and A/R routines stomp all over ABM array.
 ;       Also, add the storage of Approved Date and Time for A/R usage.
 ;       Will be date and time bill is manually created.
 ; LSL - 1/23/98 - Added the storage of the 13 multiple to the bill 
 ;       file.  Many other programs in 3PB and A/R assume it exists.
 ; LSL - 2/2/98 - Allow duplicate bills if user ok.  Also allow 
 ;       multiple clinics on same visit date.
 ; LSL - 3/25/98 - Lost value of %, so set approval date variable sooner
 ; 
 ; IHS/ASDS/SDH - 03/09/01 - V2.4 Patch 9 - NOIS LTA-0600-160017
 ;       Modified to check if service thru date is less than service
 ;       from date
 ;
 ; IHS/ASDS/SDH - 10/16/01 - V2.4 Patch 9 - NOIS UOB-0701-170024
 ;       Modified to use ABM utility to get claim number so manually
 ;       generated claims will have unique numbers.  Also made gross
 ;       amount the same as bill amount.
 ;
 ; IHS/SD/SDR - 9/26/2002 - V2.5 P2 - UOB-0102-170068
 ;       Modified routine to do date check for future dates of 
 ;       service/admission
 ;       
 ; IHS/SD/SDR - v2.5 p8 - IM11831
 ;    Modified to prompt for visit location
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user isn't logged into cashiering session they can't do
 ;   this option.  Also added so if they enter a bill using this option
 ;   it will add to cashiering session
 ; IHS/SD/SDR - abm*2.6*1 - HEAT7431 - <SUBSCR>V^DIED (vars from previous
 ;   FM call still defined.
 ;
 ; *********************************************************************
 ;
START ;EP
 K ABMD
 W !!?5,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 W " This program should only be utilized when an entry in the"
 W !?11,"Accounts Receivable File is needed to reflect a bill that"
 W !?11,"was manually prepared and submitted.",!
 S DIR(0)="Y"
 S DIR("A")="Proceed"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 Q:Y'=1
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
ASK ; ask what visit location if Parent/Satellite is set up
 S ABMARPS=$P($G(^ABMDPARM(DUZ(2),1,4)),U,9)  ;A/R P/S?
 I ABMARPS D
 .K DIC
 .S DIC="^BAR(90052.05,DUZ(2),"
 .S DIC(0)="AME"
 .S DIC("A")="Visit Location: "
 .S DIC("B")=DUZ(2)
 .D ^DIC
 Q:$D(DUOUT)!$D(DTOUT)
 Q:+Y<0
ADD ;
 I ABMARPS D
 .S ABMDUZ2=DUZ(2)
 .S ABMUDUZ2=+Y
 .S DUZ(2)=ABMUDUZ2
 S ABMD("DFN")=$$NXNM^ABMDUTL
 K DINUM
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="L"
 S X=ABMD("DFN")
 K DD,DO D FILE^DICN                     ; Add entry to 3P BILL 
 I +Y<1 D  G XIT
 .W *7
 .W !!,"ERROR: BILL NOT CREATED, ensure your Fileman ACCESS CODE contains a 'V'.",!!
 S ABMD("DFN")=+Y                        ; 3P BILL ien
 ;
EDIT ;
 L +^ABMDBILL(DUZ(2),ABMD("DFN")):1      ; Lock entry in 3P BILL
 I '$T W *7,!!,"Bill not created, Bill File in use by another user, try Later!" G XIT
E2 ;
 ;BYPASS LOCK
 W !
 K DIC,DIE,DA,DR,X,Y  ;abm*2.6*1 HEAT7431
 S DA=ABMD("DFN")                        ; 3P BILL ien
 S DIE="^ABMDBILL(DUZ(2),"               ; 3P BILL file
 S DR=".03////"_DUZ(2)                   ; Facility
 S DR=DR_";.05R~Patient........: "       ; Patient pointer
 S DR=DR_";.07R~Visit Type.....: "       ; Visit type
 S DR=DR_";.1R~Clinic.........: "        ; clinic
 D ^DIE                                  ; add fields to 3P BILL entry
 G KILL:$D(Y)                            ; if ^ out, kill entry
 ;
 ; If not inpatient ask Serv date from and thru and No of 
 ; outpatient visits.
SVDTS ;   
 I $P(^ABMDBILL(DUZ(2),DA,0),U,7)'=111 D  G KILL:$D(Y)
 .S DR=".71R~Serv Date From.: "
 .D ^DIE
 .Q:$D(Y)
 .S ABMSVFRM=X
 .I X>DT D  I Y=0 K Y G SVDTS
 ..S DIR(0)="Y"
 ..S DIR("A")="Wait!  You are entering a DOS in the future...Do you wish to proceed?"
 ..S DIR("B")="N"
 ..D ^DIR
 .S DR=".72////"_$P(^ABMDBILL(DUZ(2),DA,7),U)
 .D ^DIE
 .S DR=".72Serv Date Thru.: "
 .D ^DIE
 .Q:$D(Y)
 .S ABMSVTRU=X
 .I X>DT D  I Y=0 K Y G SVDTS
 ..S DIR(0)="Y"
 ..S DIR("A")="Wait!  You are entering a DOS in the future...Do you wish to proceed?"
 ..S DIR("B")="N"
 ..D ^DIR
 .I ABMSVTRU<ABMSVFRM W !,"Service Thru Date cannot be less than Service From Date....",! G SVDTS
 .S DR=".69R~No. of Visits..: //1"
 .D ^DIE
 .Q:$D(Y)
 ;
 ; If inpatient ask Adm and Dsch date, set Serv to and from dates
 ; based on Adm and Dsch dates, calc covered days, and delete
 ; No of outpatient visits.
ADMDTS I $P(^ABMDBILL(DUZ(2),DA,0),U,7)=111 D  G KILL:$D(Y)
 .S DR=".61R~Admission Date.: "
 .D ^DIE
 .Q:$D(Y)
 .I X>DT D  I Y=0 K Y G ADMDTS
 ..S DIR(0)="Y"
 ..S DIR("A")="Wait!  You are entering a DOS in the future...Do you wish to proceed?"
 ..S DIR("B")="N"
 ..D ^DIR
 .S DR=".63R~Discharge Date.: "
 .D ^DIE
 .Q:$D(Y)
 .I X>DT D  I Y=0 K Y G ADMDTS
 ..S DIR(0)="Y"
 ..S DIR("A")="Wait!  You are entering a DOS in the future...Do you wish to proceed?"
 ..S DIR("B")="N"
 ..D ^DIR
 .S X2=$P(^ABMDBILL(DUZ(2),DA,6),U)
 .S X1=$P(^ABMDBILL(DUZ(2),DA,6),U,3)
 .D ^%DTC
 .S ABMD("DAYS")=$S(X>0:X,1:1)
 .S DR=".71////"_$P(^ABMDBILL(DUZ(2),ABMD("DFN"),6),U)
 .S DR=DR_";.72////"_$P(^(6),U,3)
 .S DR=DR_";.73////"_ABMD("DAYS")
 .S DR=DR_";.69///@"
 .D ^DIE
 .Q:$D(Y)
 ;
CHK ;
 S ABMD(0)=$G(^ABMDBILL(DUZ(2),ABMD("DFN"),0))
 S ABMD("DUP")=0
 S ABMD("R")=""
 S ABMD("P")=$P(ABMD(0),U,5)             ; Patient pointer
 S ABMD("L")=$P(ABMD(0),U,3)             ; Facility
 S ABMD("T")=$P(ABMD(0),U,7)             ; Visit type
 S ABMD("C")=$P(ABMD(0),U,10)            ; clinic IEN
 S ABMD("D")=$P(^ABMDBILL(DUZ(2),ABMD("DFN"),7),U)  ; Serv date from
 ; Check Serv date from cross-ref for duplicate bills
 F  S ABMD("R")=$O(^ABMDBILL(DUZ(2),"AD",ABMD("D"),ABMD("R"))) Q:'ABMD("R")  D
 .Q:ABMD("R")=ABMD("DFN")               ; Q if this bill number
 .I '$D(^ABMDBILL(DUZ(2),ABMD("R"),0)) K ^ABMDBILL(DUZ(2),"AD",ABMD("D"),ABMD("R")) Q                                   ; if no data, kill cross-ref,Q
 .S ABMD(0)=^ABMDBILL(DUZ(2),ABMD("R"),0)  ; 0 node of new bill found
 .I $P(ABMD(0),U,3)=ABMD("L"),$P(ABMD(0),U,7)=ABMD("T"),$P(ABMD(0),U,5)=ABMD("P") D
 ..S ABMD("DUP")=1
 ..S ABMD("Z",$P(ABMD(0),U))=$P($G(^DIC(40.7,$P(ABMD(0),U,10),0)),U)
 ..I $P(ABMD(0),U,10)=ABMD("C") S $P(ABMD("Z",$P(ABMD(0),U)),U,2)="D"
 I ABMD("DUP") D  G KILL:ABMD("DUP")
 .W !!,"This patient also has the following bills on file for this visit date:",!
 .S ABMD("B")=""
 .F  S ABMD("B")=$O(ABMD("Z",ABMD("B"))) Q:'ABMD("B")  D
 ..W !,"BILL:  ",ABMD("B"),?18,"CLINIC:  ",$P(ABMD("Z",ABMD("B")),U)
 ..I $P(ABMD("Z",ABMD("B")),U,2)="D" W ?50,"(**DUPLICATE**)"
 .W !
 .S DIR("A")="Proceed"
 .S DIR("B")="NO"
 .S DIR(0)="Y"
 .D ^DIR
 .K DIR
 .S:Y=1 ABMD("DUP")=0
 ;
INS ;
 S DR=".08R~Insurer........: "
 S DR=DR_";.21R~Amount Billed..: "
 D ^DIE
 G KILL:$D(Y)
 S ABMAMT=$P($G(^ABMDBILL(DUZ(2),ABMD("DFN"),2)),U)
 S DR=".23////"_ABMAMT
 D ^DIE
 W !
 S ABMD("INS")=$P(^ABMDBILL(DUZ(2),ABMD("DFN"),0),U,8)
 I $P($G(^AUTNINS(ABMD("INS"),0)),U,11)="",($P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1) D  G KILL
 .W !,"Insurer ",$P($G(^AUTNINS(ABMD("INS"),0)),U)
 .W !,"is missing Tax Identification Number.  Please add in the Insurer file."
 D ELG^ABMDLCK("",.ABML,ABMD("P"),ABMD("D"))  ; Call Eligibility Checker
 S Y=ABMD("D")
 D DD^%DT
 S ABMD("ED")=Y                               ; external visit date
 S ABMD("PRI")=""
 F  S ABMD("PRI")=$O(ABML(ABMD("PRI"))) Q:'ABMD("PRI")  D
 .I $D(ABML(ABMD("PRI"),ABMD("INS"))) D
 ..S ABMD("ITYP")=$P(ABML(ABMD("PRI"),ABMD("INS")),U,3)
 ..S ABMD("ELG")=$P(ABML(ABMD("PRI"),ABMD("INS")),U,2)
 ..S ABMD("MCD")=$P(ABML(ABMD("PRI"),ABMD("INS")),U)
 K ABML
 I '$D(ABMD("ELG")) D
 .W !,$P(^DPT($P(^AUPNPAT(ABMD("P"),0),U),0),U)
 .W " has NO ELIGIBILITY for "
 .W $P(^AUTNINS(ABMD("INS"),0),U)
 .W " on ",ABMD("ED"),!
 S DIR(0)="Y"
 S DIR("A")="File Bill"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 I Y'=1 G E2  ; If not file bill, ask info again.
 ; Insurer Type
 S ABMD("IT")=$P($G(^AUTNINS(ABMD("INS"),2)),U,1)
 S:"FHM"[ABMD("IT") ABMD("IT")="P"
 D NOW^%DTC
 S ABMD("APDT")=%
 S DA=1
 S DIC="^ABMDBILL(DUZ(2),DA(1),13,"
 S DA(1)=ABMD("DFN")
 S X=ABMD("INS")                               ; Insurer
 S DIC(0)="LE"
 S DIC("P")=$P(^DD(9002274.4,13,0),U,2)
 S DIC("DR")=".02///1"                         ; Priority
 S DIC("DR")=DIC("DR")_";.03///INITIATED"      ; Status
 I $D(ABMD("ELG")) D
 .I ABMD("ITYP")?1(1"P",1"W",1"A") S DIC("DR")=DIC("DR")_";.08///"_ABMD("ELG")
 .I ABMD("ITYP")="M" S DIC("DR")=DIC("DR")_".04///"_ABMD("ELG")
 .I ABMD("ITYP")="R" S DIC("DR")=DIC("DR")_".05///"_ABMD("ELG")
 .I ABMD("ITYP")="D" D
 ..S DIC("DR")=DIC("DR")_".07///"_ABMD("ELG")
 ..S DIC("DR")=DIC("DR")_".06////"_ABMD("MCD")
 K DD,DO D FILE^DICN
 S DA=ABMD("DFN")
 S DR=".14////"_DUZ                      ; Approving Official
 S DR=DR_";.15////"_ABMD("APDT")         ; Approval date and time
 S DR=DR_";.22////"_ABMD("IT")           ; Insurer Type
 S DR=DR_";.04////B"                     ; Bill Status
 S DR=DR_";.16////A"                     ; Export Status
 S ABMAPOK=1                 ; Set so .04 x-ref will call ABMAPASS
 D ^DIE
 I ABMARPS S DUZ(2)=ABMUDUZ2
 W !,"Bill # ",$P(^ABMDBILL(DUZ(2),DA,0),"^",1)," Filed.",!
 D ADDBENTR^ABMUCUTL("ABILL",ABMP("BDFN"))  ;add bill to UFMS Cash. Session
 ;
XIT ;
 L -^ABMDBILL(DUZ(2),ABMD("DFN"))
 K DIR
 S DIR(0)="E"
 D ^DIR
 K ABMD,ABMAPOK
 I ABMARPS S DUZ(2)=ABMDUZ2
 Q
 ;
KILL ;
 W !!,*7,"<Data Incomplete: Entry Deleted>"
 S DIK=DIE
 D ^DIK
 G XIT
