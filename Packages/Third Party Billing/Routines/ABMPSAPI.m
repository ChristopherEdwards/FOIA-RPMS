ABMPSAPI ; IHS/ASDS/LSL - 3PB Pharmacy POS API   
 ;;2.6;IHS Third Party Billing System;**2,4,6**;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 05/17/2001 - V2.4 Patch 6 - New routine to accomodate
 ;     Pharmacy POS.  A somewhat generic API to accept info from
 ;     Pharmacy POS to create a bill in Third Party Billing and
 ;     therefore pass to Accounts Receivable.
 ; IHS/ASDS/LWJ - 06/01/2001 - V2.4 Patch 5 - altered ^DIC call for the
 ;     insurer to no longer access the special lookup routine AUTNKWII
 ; IHS/ASDS/LSL - 06/14/2001 - V2.4 Patch 5 - Added CAN line tag to 
 ;     mark POS bills as cancelled when reversed through POS.
 ; IHS/ASDS/LSL - 07/18/01 - V2.4 Patch 8
 ;     Resolve <DPARM>CAN+3^ABMPSAPI.
 ; IHS/SD/SDR - v2.5 p9 - IM15457
 ;    Use visit location for duz(2)
 ; IHS/SD/SR - v2.5 p9 - IM18926
 ;    Added capability to reprint in TPB on NCPDP format
 ; IHS/SD/SDR - v2.5 p10 - IM21800
 ;   Fix for <UNDEF>DBFX+10^ABMDEFIP
 ; IHS/SDR/SDR - v.25 p12 - UFMS
 ;   Changes to log POS claims for UFMS reporting/export
 ; IHS/SD/SDR - v2.5 p12 - IM25440
 ;   Changed default clinic to 39 (from 25)
 ; IHS/SD/SDR - v2.5 p13 - IM26096
 ;   Stop cashiering session creation for tribal sites
 ;   and don't display warning message
 ; IHS/SD/SDR - abm*2.6*4 - NO HEAT - populate INSURER TYPE
 ; IHS/SD/SDR - abm*2.6*6 - NOHEAT - populate OTHER BILL IDENTIFER in 3P Bill file
 ;
 Q
 ;
 ; *********************************************************************
EN(ABMPOS)         ; PEP
 ; Pass array sub field number.  ie:  ARRAY(Field #)
 ; If field is inside a 3P Bill multiple, array needs to be  
 ; ARRAY(Mult #,field #)
 ;
 ; ABMPOS(.21)             Bill amount
 ; ABMPOS(.23)             Gross amount
 ; ABMPOS(.05)             Patient
 ; ABMPOS(.71)             Service date from
 ; ABMPOS(.72)             Serviec date to
 ; ABMPOS(.1)              Clinic
 ; ABMPOS(.03)             Visit location
 ; ABMPOS(.08)             Active insurer
 ; ABMPOS(.58)             Pro Authorization number
 ; ABMPOS(.14)             Approving Official
 ; ABMPOS(11,.01)          Visit IEN  ;abm*2.6*2
 ; ABMPOS(41,.01)          Provider multiple, Provider
 ; ABMPOS(23,.01)          Pharmacy multiple, Medication
 ; ABMPOS(23,.03)          Pharmacy multiple, units
 ; ABMPOS(23,.04)          Pharmacy multiple, unit cost
 ; ABMPOS(23,.05)          Pharmacy multiple, dispense fee
 ; ABMPOS(23,19)           Pharmacy multiple, new/refill code
 ; ABMPOS(23,.06)          Pharmacy multiple, Prescription
 ; ABMPOS(23,14)           Pharmacy multiple, Date filled
 ; ABMPOS(23,20)           Pharmacy multiple, Days supply
 ; ABMPOS(73,"REJDATE")    POS Rejection Date  ;abm*2.6*2
 ; ABMPOS(73,CNTR,"CODE")  POS Rejection Code  ;abm*2.6*2
 ; ABMPOS(73,CNTR,"REASON")POS Rejection Reason  ;abm*2.6*2
 ; ABMPOS("OTHIDENT")      Other Bill Identifier for A/R
 ;
 ; First determine proper DUZ(2) (code borrowed from claim generator)
 ; 2 assumptions: 1. Pharmacy and POS do not manipulate DUZ(2) variable
 ;                2. DUZ(2) is always the parent (box user is on)
 K ABMDUZ2,ABMARPS,ABMHOLD,ABMAPOK,ABMBILL,ABMFLD,ABMULT,ABMPASAR
 K DINUM,DIC,DA,DIE,X,Y,DD,DO,DLAYGO
 S ABMDUZ2=ABMPOS(.03)
 S ABMARPS=$P($G(^ABMDPARM(DUZ(2),1,4)),U,9)    ; Use A/R parent/sat
 ; Use A/R parent/sat is yes and visit location not defined under parent
 ; in A/R Parent/Satellite file.
 I ABMARPS,'$D(^BAR(90052.05,DUZ(2),ABMPOS(.03),0)) S ABMDUZ2=ABMPOS(.03)
 ; Use A/R parent/sat is yes, but DUZ(2) is not the parent for this 
 ; visit location
 I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMPOS(.03),0)),U,3)'=DUZ(2) S ABMDUZ2=ABMPOS(.03)
 I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMPOS(.03),0)),U,6)>ABMPOS(.71) S ABMDUZ2=ABMPOS(.03)
 I ABMARPS,$P($G(^BAR(90052.05,DUZ(2),ABMPOS(.03),0)),U,7),$P(^(0),U,7)<ABMPOS(.71) S ABMDUZ2=ABMPOS(.03)
 I '$D(^ABMDPARM(ABMDUZ2,0)) Q "Not in 3P Parameters"
 S ABMHOLD=DUZ(2)                     ; Store DUZ(2)
 S DUZ(2)=ABMDUZ2
 ;
 D NOW^%DTC
 S ABMPOS(.15)=%                      ; Date/Time approved = now
 S ABMPOS(.02)=131                    ; Bill type = outpatient
 S ABMPOS(.06)=24                     ; export mode NCPDP
 S ABMPOS(.07)=901                    ; Visit type = 901 (only POS)
 S ABMPOS(13,.02)=1                   ; Insurer multiple, priority
 S ABMPOS(13,.03)="I"                 ; Insurer multiple, status
 S ABMPOS(41,.02)="A"                 ; Provider multiple, Attending
 S ABMPOS(.1)=39    ; always Pharmacy clinic
 ;
 S ABMAPOK=1                          ; Pass 3PB to A/R
 K DINUM,DIC
 S DIC(0)="LX"
 S DIC="^ABMDBILL(DUZ(2),"
 S X=$$NXNM^ABMDUTL                   ; Get next Claim number
 I 'X S DUZ(2)=ABMHOLD Q "Next claim number unsuccessful"
 S X=X_"A"                            ; Bill number
 K DD,DO,DA
 S DLAYGO=9002274.4
 D ^DIC
 I +Y<0 S DUZ(2)=ABMHOLD Q "3P Bill create unsuccessful"  ; Bill addition unsuccessful
 S (DA,ABMBILL)=+Y
 S DIE=DIC
 S ABMFLD=0
 F  S ABMFLD=$O(ABMPOS(ABMFLD)) Q:'+ABMFLD  D
 .Q:ABMFLD>1
 .Q:ABMPOS(ABMFLD)=""
 .S DR=ABMFLD_"////"_ABMPOS(ABMFLD)
 .D ^DIE
 ;start new code abm*2.6*4 NOHEAT
 S DR=".22////"_$P($G(^AUTNINS(ABMPOS(.08),2)),U)
 D ^DIE
 ;end new code abm*2.6*4 NOHEAT
 ;start new code abm*2.6*6 NOHEAT
 S DR=".115////"_ABMPOS("OTHIDENT")
 D ^DIE
 ;end new code abm*2.6*6 NOHEAT
 F ABMULT=13,23,41 D
 .K DINUM,DIC,DA
 .S DA(1)=ABMBILL
 .S DIC("P")=$P(^DD(9002274.4,ABMULT,0),U,2)
 .S DIC="^ABMDBILL(DUZ(2),"_DA(1)_","_ABMULT_","
 .S DIC(0)="LXIE"
 .S X=$S(ABMULT=13:$P(^AUTNINS(INSDFN,0),U),ABMULT=23:$P(^PSDRUG(ABMPOS(23,.01),0),U),1:$P(^VA(200,ABMPOS(41,.01),0),U))
 .S DLAYGO=9002274.4
 .K DD,DO
 .D ^DIC
 .I +Y<0 Q                           ; Addition of multiple unsuccess
 .S DA=+Y
 .S DIE=DIC
 .S ABMFLD=.01
 .F  S ABMFLD=$O(ABMPOS(ABMULT,ABMFLD)) Q:'+ABMFLD  D
 ..Q:ABMPOS(ABMULT,ABMFLD)=""
 ..S DR=ABMFLD_"////"_ABMPOS(ABMULT,ABMFLD)
 ..D ^DIE
 ;start new code abm*2.6*2
 ; abm*2.6*2 this section was taken out because it stops other claims from generating.
 ; Visits are being merged and with this code change, it stops claims from creating that should.
 ; Needs to be reviewed, further tested, and included in a future patch of ABM.
 ;K DINUM,DIC,DA,DIE,DR,DIE
 ;S DA(1)=ABMBILL
 ;S DIC("P")=$P(^DD(9002274.4,11,0),U,2)
 ;S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",11,"
 ;S DIC(0)="LE"
 ;S X=$G(ABMPOS(11,.01))
 ;S DLAYGO=9002274.4
 ;S DIC("DR")=".02////P"
 ;K DD,DO
 ;D FILE^DICN
 ;
 K DIC,DIE,DIR,X,Y,DA,DR
 I $D(ABMPOS(73)) D  ;rejection codes/reasons
 .S ABMCNT=0
 .F  S ABMCNT=$O(ABMPOS(73,ABMCNT)) Q:(+$G(ABMCNT)=0)  D
 ..K DIC,DIE,DIR,DA,DR,X,Y
 ..S DA(1)=ABMBILL
 ..S DIC="^ABMDBILL(DUZ(2),"_DA(1)_",73,"
 ..S DIC(0)="LE"
 ..S DIC("P")=$P(^DD(9002274.4,73,0),U,2)
 ..S X=$G(ABMPOS(73,ABMCNT,"CODE"))
 ..S DIC("DR")=".02////"_$G(ABMPOS(73,ABMCNT,"REASON"))_";.03////"_$G(ABMPOS(73,"REJDATE"))
 ..K DD,DO
 ..D ^DIC
 ;end new code abm*2.6*2
 ; This DIE call needs to be done last.  It's the x-ref on this field
 ; that creates the bill in A/R from 3PB. It also defines the A/R
 ; location field on the 3P bill [DUZ(2),DA].
 K DIE,DA,DR
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMBILL
 S DR=".04////B"                      ; Set bill status to B
 D ^DIE
 S ABMPASAR=$P($G(^ABMDBILL(DUZ(2),ABMBILL,2)),U,6)
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D POSUFMS  ;create/populate UFMS Cashiering session
 S DUZ(2)=ABMHOLD                     ; Restore DUZ(2) 
 K ABMDUZ2,ABMARPS,ABMHOLD,ABMAPOK,ABMBILL,ABMFLD,ABMULT,ABMPOS
 K DINUM,DIC,DA,DIE,X,Y,DD,DO,DLAYGO
 I ABMPASAR="" Q "A/R Bill population unsuccessful"
 Q ABMPASAR                          ; A/R DUZ(2),IEN
 ;
 ; *********************************************************************
POSUFMS ; create/populate UFMS Cashiering Session
 ;location
 K ABMP("LDFN")
 S ABMLOC=$$FINDLOC^ABMUCUTL
 K DIC,DIE,X,Y,DA
 S DIC="^ABMUCASH("
 S DIC(0)="LMN"
 S (X,DINUM)="`"_ABMLOC
 D ^DIC
 I Y<0 Q
 S ABMLOC=+Y
 ;
 ;user
 K DIC,DIE,X,Y,DA
 S DA(1)=ABMLOC
 S DIC="^ABMUCASH(DA(1),20,"
 S DIC(0)="LMN"
 S DIC("P")=$P(^DD(9002274.45,".03",0),U,2)
 S (X,DINUM)=1
 D ^DIC
 I Y<0 Q
 S ABMUSER=+Y
 ;
 ;sign in date
 ;check for existing open session
 I $D(^ABMUCASH(ABMLOC,20,1,20,0)) D
 .S ABMSDT=999999999
 .S ABMSFLG=0
 .F  S ABMSDT=$O(^ABMUCASH(ABMLOC,20,1,20,ABMSDT),-1) Q:+ABMSDT=0  D  Q:ABMSFLG=1
 ..Q:($P($G(^ABMUCASH(ABMLOC,20,1,20,ABMSDT,0)),U,4)'="O")
 ..S ABMSFLG=1
 I +$G(ABMSDT)=0 D
 .K DIC,DIE,X,Y,DA
 .S DA(2)=ABMLOC
 .S DA(1)=ABMUSER
 .S DIC="^ABMUCASH("_DA(2)_",20,"_DA(1)_",20,"
 .S X="NOW"
 .S DIC(0)="LMO"
 .S DIC("P")=$P(^DD(9002274.4503,".02",0),U,2)
 .S DIC("DR")=".04////O"
 .D ^DIC
 .Q:Y<0
 .S ABMSDT=+Y
 ;
 ;insurer type
 K DIC,DIE,X,Y,DA
 S DA(3)=ABMLOC
 S DA(2)=ABMUSER
 S DA(1)=ABMSDT
 S DIC="^ABMUCASH("_DA(3)_",20,"_DA(2)_",20,"_DA(1)_",11,"
 ;S DIC(0)="LM"  ;abm*2.6*6 HEAT28427
 S DIC(0)="LMX"  ;abm*2.6*6 HEAT28427
 S DIC("P")=$P(^DD(9002274.45302,11,0),U,2)
 S X=$P($G(^AUTNINS($P($G(^ABMDBILL(DUZ(2),ABMBILL,0)),U,8),2)),U)
 S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMBILL,0)),U,8)
 D ^DIC
 I +Y<0 W !,"NO ENTRY IN CASHIERING SESSION MADE",! H 2 Q
 S ABMBA=+Y
 ;
 ;bill entry
 K DIC,DIE,X,Y,DA
 S DA(4)=ABMLOC
 S DA(3)=ABMUSER
 S DA(2)=ABMSDT
 S DA(1)=ABMBA
 S DIC="^ABMUCASH("_DA(4)_",20,"_DA(3)_",20,"_DA(2)_",11,"_DA(1)_",2,"
 S X=$P($G(^ABMDBILL(DUZ(2),ABMBILL,0)),U)
 S DIC(0)="LMO"
 S DIC("P")=$P(^DD(9002274.4530211,".02",0),U,2)
 S DIC("DR")=".02////"_DUZ(2)_";.03////"_ABMBILL
 D ^DIC
 Q
 ; *********************************************************************
CAN(ABM,ABM2) ;
 ; For bills that reversed through Pharmacy POS, mark them as cancelled.
 ; Using bill location in A/R, find it in 3PB
 I '$G(ABM) Q ABM                     ; Don't know bill location
 S ABMDUZ2=$P(ABM,",")
 S ABMAR=$P(ABM,",",2)
 I ('+ABMDUZ2!('+ABMAR)) Q "Not valid a/r bill location"
 S ABMHOLD=DUZ(2)
 S DUZ(2)=ABMDUZ2
 S ABMBILL=$$GET1^DIQ(90050.01,ABMAR,.01)
 S ABMBILL=$P(ABMBILL,"-")
 S DUZ(2)=$P($G(^BARBL(ABMDUZ2,ABMAR,0)),U,22)           ; 3P DUZ(2)
 S:DUZ(2)="" DUZ(2)=$P($G(^BARBL(ABMDUZ2,ABMAR,1)),U,8)  ; visit loc
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="XM"
 S X=ABMBILL
 D ^DIC
 I Y'>0 D
 .S DUZ(2)=$P($G(^BARBL(ABMDUZ2,ABMAR,0)),U,8)          ; Parent
 .D ^DIC
 I Y'>0 Q "3P bill not found"
 S (DA,ABMDA)=+Y
 ;
 ; Bill found, so mark as cancelled.
 K DR,DIE,DIC,X,Y
 S DR=".04////X"
 S DIE="^ABMDBILL(DUZ(2),"
 D ^DIE
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D CPOSUFMS  ;create/populate UFMS Cashiering session
 Q "3P bill "_DUZ(2)_","_ABMDA_" cancelled"
CPOSUFMS ; create/populate UFMS Cashiering Session
 ;location
 K ABMP("LDFN")
 S ABMLOC=$$FINDLOC^ABMUCUTL
 K DIC,DIE,X,Y,DA
 S DIC="^ABMUCASH("
 S DIC(0)="LMN"
 S (X,DINUM)="`"_ABMLOC
 D ^DIC
 I Y<0 Q
 S ABMLOC=+Y
 ;
 ;user
 K DIC,DIE,X,Y,DA
 S DA(1)=ABMLOC
 S DIC="^ABMUCASH(DA(1),20,"
 S DIC(0)="LMN"
 S DIC("P")=$P(^DD(9002274.45,".03",0),U,2)
 S (X,DINUM)=1
 D ^DIC
 I Y<0 Q
 S ABMUSER=+Y
 ;
 ;sign in date
 ;check for existing open session
 I $D(^ABMUCASH(ABMLOC,20,1,20,0)) D
 .S ABMSDT=999999999
 .S ABMSFLG=0
 .F  S ABMSDT=$O(^ABMUCASH(ABMLOC,20,1,20,ABMSDT),-1) Q:+ABMSDT=0  D  Q:ABMSFLG=1
 ..Q:($P($G(^ABMUCASH(ABMLOC,20,1,20,ABMSDT,0)),U,4)'="O")
 ..S ABMSFLG=1
 I +$G(ABMSDT)=0 D
 .K DIC,DIE,X,Y,DA
 .S DA(2)=ABMLOC
 .S DA(1)=ABMUSER
 .S DIC="^ABMUCASH("_DA(2)_",20,"_DA(1)_",20,"
 .S X="NOW"
 .S DIC(0)="LMO"
 .S DIC("P")=$P(^DD(9002274.4503,".02",0),U,2)
 .S DIC("DR")=".04////O"
 .D ^DIC
 .Q:Y<0
 .S ABMSDT=+Y
 ;
 ;insurer type
 K DIC,DIE,X,Y,DA
 S DA(3)=ABMLOC
 S DA(2)=ABMUSER
 S DA(1)=ABMSDT
 S DIC="^ABMUCASH("_DA(3)_",20,"_DA(2)_",20,"_DA(1)_",11,"
 S DIC(0)="LM"
 S DIC("P")=$P(^DD(9002274.45302,11,0),U,2)
 S X=$P($G(^AUTNINS($P($G(^ABMDBILL(DUZ(2),ABMDA,0)),U,8),2)),U)
 S ABMP("INS")=$P($G(^ABMDBILL(DUZ(2),ABMDA,0)),U,8)
 D ^DIC
 I +Y<0 W !,"NO ENTRY IN CASHIERING SESSION MADE",! H 2 Q
 S ABMBA=+Y
 ;
 ;bill entry
 K DIC,DIE,X,Y,DA
 S DA(4)=ABMLOC
 S DA(3)=ABMUSER
 S DA(2)=ABMSDT
 S DA(1)=ABMBA
 S DIC="^ABMUCASH("_DA(4)_",20,"_DA(3)_",20,"_DA(2)_",11,"_DA(1)_",3,"
 S X=$P($G(^ABMDBILL(DUZ(2),ABMDA,0)),U)
 S DIC(0)="LMO"
 S DIC("P")=$P(^DD(9002274.45302112,".03",0),U,2)
 S DIC("DR")=".02////"_DUZ(2)_";.03////"_ABMDA
 D ^DIC
 Q
