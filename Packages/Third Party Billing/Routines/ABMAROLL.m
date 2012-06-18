ABMAROLL ; IHS/ASDST/DMJ - A/R ROLL OVER ;     
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
 ; IHS/DSD/LSL 03/30/98  - Don't complete a cancelled
 ;             bill.  This will cause errors on productivity
 ;             report and previous payments of bills.
 ;
 ; IHS/DSD/DMJ 07/23/99 - NOIS PEB-0799-90049 Patch 3 #8
 ;     Changed from the DIC("DR") method to updating each field
 ;     individually.  Apparently if one field in the string fails,
 ;     fileman doesn't file anything.
 ;
 ; IHS/ASDS/SDH - 08/14/01 - V2.4 Patch 9 - NOIS NDA-1199-180065
 ;     Modified routine to subtract refund instead of add (two negatives
 ;     makes a positive)
 ;
 ; IHS/SD/SDR - 5/28/02 - V2.5 P2 - NOIS HQW-1201-100023
 ;     Modified so that the export date will not be deleted anymore.
 ;     This was causing problems with some reports not showing correct
 ;     data because of this date missing.
 ;
 ; IHS/SD/SDR - 6/6/05 V2.5 p8
 ;    Made LKUP and FILE published entry points per A/R
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19622
 ;    Fixed so replacement insurer is checked when updating status
 ;
 ; IHS/SD/SDR - v2.5 p 13 - NO IM
 ;
 ; *********************************************************************
 ;
START(X,ABM,Z,ZZ) ;EP - FROM A/R
 ;
 ; This routine is called from A/R ^BARROLL.  The purpose is to 
 ; file payment information into the Payment multiple of 3P BILL.
 ; After filing this data, the bill is marked as completed.
 ; Variables are then set in preparation of calling the Eligibility
 ; Checker.  This is done to find other billable sources that have
 ; not yet been billed in relation to this claim.  If other billable
 ; sources exist and the user holds the 3PB key, they are asked if 
 ; the claim should be re-opened for future billing.  Otherwise, the
 ; claim is automatically reopened.
 ; Rtn has been modified to work if called by either A/R 1.0 or 1.1
 ;
 ; Input:  X   = BILL INTERNAL ENTRY NUMBER^VISIT LOCATION
 ;         ABM = PAYMENT ARRAY from 1.1
 ;               TOTAL PAYMENT AMT FROM 1.0
 ;         Z   = BILL NAME from 1.1
 ;               Not passed by 1.0
 ;         ZZ  = A/R MESSAGE
 ;
 S ABMP("BDFN")=+X              ; IEN to 3PB BILL
 S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",1)  ; Bill #
 I '$D(Z) D                  ; Z UNDEF IFF rtn called by A/R 1.0
 .S ABMP("AR1.0")=""
 .S Y=ABM
 .K ABM
 .S ABM("AMT")=Y
 I $G(Z)]"",ABMP("BILL")'=Z D LKUP
 I 'ABMP("BDFN") D  Q
 .W !,"Cannot locate bill ",Z," in 3P Bill file.",!
 D FILE          ; File A/R data in payment multiple of 3P BILL
 D SET           ; Set variables necessary for Eligibility Checker
 D REST          ; Look for unused billable sources
 K ABM,ABMP,ABMA
 Q
 ;
LKUP ; PEP - LOOK UP ABMP("BDFN")
 S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"B",Z,0))
 Q:'ABMP("BDFN")
 S ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",1)
 Q
 ;
FILE ; PEP - FILE PAYMENT INFORMATION
 ; OK for both 1.0 and 1.1
 ; The payment multiple will contain cumulative data about that bill
 ; 
 ;   3PB field    = A/R field
 ; 
 ; Payment Amount = Payments + 3P Previous Payments + Payment 
 ;                  Adjustments - Refunds
 ; Deductible     = Deductible
 ; Co-Insurance   = Co-pay
 ; Write Offs     = Write Offs
 ; Non-covered    = Non payments
 ; Penalties      = Penalties
 ;
 I $D(ABMP("AR1.0")) D
 .S:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),3)) ^(3,0)="^9002274.403D^^"
 E  D
 .K ^ABMDBILL(DUZ(2),ABMP("BDFN"),3)   ; Payment multiple
 .S ^ABMDBILL(DUZ(2),ABMP("BDFN"),3,0)="^9002274.403D^^"
 S DA(1)=ABMP("BDFN")
 S X=DT
 S DIC="^ABMDBILL(DUZ(2),DA(1),3,"
 S DIC(0)="L"
 K DD,DO D FILE^DICN
 S DA=+Y
 S DIE=DIC
 I $D(ABMP("AR1.0")) D
 .Q:Y<0
 .S DR=".02///"_ABM("AMT") D ^DIE
 I '$D(ABMP("AR1.0")) D
 .Q:Y<0
 .S ABM("NPAY")=+$G(ABM("PAY"))+$G(ABM("3P"))+$G(ABM("PCR"))+$G(ABM("RF"))
 .S DR=".02///"_ABM("NPAY") D ^DIE                  ;Payment Amount
 .I $G(ABM("DED")) S DR=".03///"_ABM("DED") D ^DIE  ;Deductible
 .I $G(ABM("COP")) S DR=".04///"_ABM("COP") D ^DIE  ; Co-Insurance
 .I $G(ABM("WO")) S DR=".06///"_ABM("WO") D ^DIE    ; Write Offs
 .I $G(ABM("NP")) S DR=".07///"_ABM("NP") D ^DIE    ; Non-covered
 .I $G(ABM("PEN")) S DR=".09///"_ABM("PEN") D ^DIE  ; Penalties
 .I $G(ABM("PAY")) S DR=".1///"_ABM("PAY") D ^DIE   ; A/R Payments
 .I $G(ABM("3P")) S DR=".11///"_ABM("3P") D ^DIE    ; 3P Prev Payments
 .I $G(ABM("GRP")) S DR=".12///"_ABM("GRP") D ^DIE  ; Grouper Allowance
 .I $G(ABM("RF")) S DR=".13///"_ABM("RF") D ^DIE    ; A/R Refund
 .I $G(ABM("PCR")) S DR=".14///"_ABM("PCR") D ^DIE  ; A/R Pymt Adjust
 D CBIL                 ; Close the bill
 Q
CBIL ;
 ; EP for Closing Bill
 ; OK for both 1.0 and 1.1
 Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,4)="X"    ; Q if cancelled bill
 ; Mark bill status "complete" (.04) and delete export number (.17)
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".04////C"
 D ^DIE
 K DR
 Q
 ;
SET ;
 ; set up needed variables for Eligibility Checker
 S ABMP("PDFN")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",5)  ; Patient
 S ABMP("INS")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",8)   ; Active Ins
 S ABMP("VDT")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),"^",1)   ; Srv dt frm
 Q
 ;
REST ;
 ; Quit if billed manually. . . no other sources to find
 I +ABMP("BILL")=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U) Q
 ; Check to see if the claim has been cancelled.
 S ABMP("CDFN")=+ABMP("BILL")
 I '$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)) W !,"CLAIM #",ABMP("CDFN")," HAS BEEN CANCELLED.",! Q
 N I
 S I=0,DA=0
 ;
 ; Loop through the insurer multiple, if the insurer is active and is
 ; the same as the active insurer, mark that insurer as complete.
 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I)) Q:'I  D
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I",$P(^(0),"^",1)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",8) S DA=I
 .I $P(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0),"^",3)="I",$P(^(0),"^",11)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",8) S DA=I
 I DA D
 .S DA(1)=ABMP("CDFN")
 .Q:'$D(^ABMDCLM(DUZ(2),DA(1),13,DA))
 .S DIE="^ABMDCLM("_DUZ(2)_","_DA(1)_",13,"
 .S DR=".03////C"
 .D ^DIE
 .K DR
 ; Quit if claim is already in edit status
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",4)="E" D  Q
 . W !,"Claim is already in edit status.",!
 ;
UNBILL ;
 ; Look for additional sources that have not yet been billed
 W !!,"CHECKING FOR UNBILLED SOURCES.",!
 S (ABM("HIT"),ABM("CNT"))=0
 ; Eligibility checker. . .add any other insurers and prioritize
 D ELG^ABMDLCK("",.ABML,ABMP("PDFN"),ABMP("VDT"))
 N I
 S I=0
 ;
 ; Loop through insurers in order of priority and update the 
 ; insurer multiple in 3P BILL w/ insurer and coverage data.
 F  S I=$O(ABML(I)) Q:'I  D
 .N J
 .S J=0
 .F  S J=$O(ABML(I,J)) Q:'J  D
 ..S ABM("PRI")=I
 ..S ABM("INS")=J
 ..D ADDCHK^ABMDE2E
 ;
 ; Determine if source (insurer) is billable
 ; Loop through insurer multiple in priority order (C x-ref), if the
 ; claim status is Pending, active, flagged or partial and patient is
 ; non-indian and insurer is billable. . .display as a billable 
 ; source.
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM  D
 .S ABM("X")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,0))
 .I '$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("X"),0)) K ^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,ABM("X")) Q
 .I "PIFL"[$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("X"),0),U,3) D
 ..S ABM("INSCO")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("X"),0),"^",1)
 ..Q:$P($G(^AUTNINS(ABM("INSCO"),2)),U)="I"
 ..Q:$P($G(^AUTNINS(ABM("INSCO"),1)),U,7)=4
 ..W:ABM("CNT") !
 ..S ABM("CNT")=ABM("CNT")+1
 ..W ?18,"[",ABM("CNT"),"]  ",$P(^AUTNINS(ABM("INSCO"),0),U)
 ..S ABM(ABM("CNT"))=ABM("X")
 ;
 ; No other billable sources so mark claim as complete
 I ABM("CNT")=0 D  K ABM,ABMP Q
 .D CCLM             ; mark claim as complete
 .W "NONE",!!,"Since there are no unbilled sources no further billing is possible."
 S ABM("HIT")=ABM(1)
 S Y=1  ; flag used for reopening a claim
 ; If user access to below option, ask to reopen claim
 ; Note that if this key name gets changed this code needs changing
 I $D(^XUSEC("ABMDZ EDIT CLAIM AND EXPORT",DUZ)) D
 .W !
 .S DIR(0)="Y"
 .S DIR("A")="Re-open claim for further billing? (Y/N)"
 .D ^DIR
 .K DIR
 .Q:$D(DIRUT)
 ; If answer is no, complete the claim
 I Y'=1 D CCLM K ABM,ABMP Q
 ; Else reopen the claim
 S DIE="^ABMDBILL(DUZ(2),"
 S DA=ABMP("BDFN")
 S DR=".24////"_Y
 D ^DIE
 D OCLM      ; Open claim for editing
 S DA(1)=ABMP("CDFN")
 S DIE="^ABMDCLM("_DUZ(2)_","_DA(1)_",13,"
 S DA=ABM("HIT")
 S DR=".03////I"
 D ^DIE      ; Make insurer status (multiple) active
 K ABM,ABMP
 Q
 ;
ADD ;
 ; Add bill not currently in 3P BILL
 ; MAYBE WILL DO LATER
 Q
 ;
OCLM ;
 ; Open claim for editing
 S DA=ABMP("CDFN")
 S DIE="^ABMDCLM("_DUZ(2)_","
 S DR=".04////O;.08////"_$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("HIT"),0),U)
 D ^DIE
 ;put remark if billed insurer is tribal self-insured and Medicare insurer is next
 I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),U,11)="Y"&($P($G(^AUTNINS(ABM(1),2)),U)="R") D
 .K DIC,DIE,X,Y,DA
 .S DA(1)=ABMP("CDFN")
 .S DIC="^ABMDCLM("_DUZ(2)_","_DA(1)_",61,"
 .S DIC(0)="L"
 .S DIC("P")=$P(^DD(9002274.3,61,0),U,2)
 .S X="PT HAS TRIBAL SELF-FUNDED INSURANCE"
 .D ^DIC
 W !!,"Claim Number: ",+ABMP("BILL")," is now Open for Editing!",!
 Q
 ;
CCLM ;
 ; Complete a claim
 S DA=ABMP("CDFN")
 S DIE="^ABMDCLM("_DUZ(2)_","
 S DR=".04////C"
 D ^DIE
 Q
