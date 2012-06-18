ABSPOSBH ; IHS/SD/RLT - POS billing - HOLD ;        [ 09/12/2007  11:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**22,28**;SEP 12, 2007
 ;
 ; Code to hold claims from being sent to 3PB if the site
 ; affiliation is IHS and the insurer does not have a tax id.
 ; 
 ; This routine handles the holding and releasing of these claims.
 ; 
 ; -------------------------------------------------------------------------------------
 ; IHS/OIT/SCR 9/16/08 patch 28 REMOVED all functionality to put claims in HOLD
 ;   status.
 ; -------------------------------------------------------------------------------------
 Q
 ; IHS/OIT/SCR 9/23/08 - Patch 28 START CHANGES
 ;HOLDFLG(LOC,VISDT,INSDFN) ;EP - ABSPOSBB
 ;
 ; Claims from sites flagged as IHS must have insurer tax ids
 ; to send to 3PB.
 ;
 ; 1 = don't send to 3PB put on hold
 ; 0 = send to 3PB
 ; Get affiliation.
 ;     1 = IHS
 ;N CLASSFND,CLASS,BEGDT,ENDDT,AFFL
 ;S AFFL=""
 ;S CLASSFND=0
 ;S CLASS="A"
 ;F  S CLASS=$O(^AUTTLOC(LOC,11,CLASS),-1) Q:CLASS=0!(CLASSFND)  D
 ;. S BEGDT=$S($P(^AUTTLOC(LOC,11,CLASS,0),U)]"":$P(^AUTTLOC(LOC,11,CLASS,0),U),1:0)
 ;. S ENDDT=$S($P(^AUTTLOC(LOC,11,CLASS,0),U,2)]"":$P(^AUTTLOC(LOC,11,CLASS,0),U,2),1:9999999)
 ;. I VISDT'<BEGDT&(VISDT'>ENDDT) S AFFL=$P(^AUTTLOC(LOC,11,CLASS,0),U,3),CLASSFND=1
 ;;
 ;; Get insurer tax id.
 ;N TAXID
 ;S TAXID=$P($G(^AUTNINS(INSDFN,0)),U,11)
 ;
 ; If affiliation is IHS and no insurer tax id don't send to 3PB put on hold.
 ;I AFFL=1&(TAXID="") Q 1
 ;Q 0
 ;HOLDITP(ABSP) ;EP - ABSPOSBB
 ; Put post on hold.
 ;
 ;N LOG
 ;D NOW^%DTC
 ;S LOG=%
 ;
 ;D ^XBFMK      ;kill FileMan variables
 ;K DD,DO
 ;S DIC="^ABSPHOLD("
 ;S DIC(0)="L"
 ;S DINUM=LOG
 ;S DINUM=ABSP57
 ;S X=ABSP57
 ;
 ;D FILE^DICN
 ;
 ;Q:+Y<0
 ;
 ;S $P(^ABSPHOLD(ABSP57,0),U,2)="P"
 ;
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,1)=ABSP(.21)             ; Bill amount
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,2)=ABSP(.23)             ; Gross amount
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,3)=ABSP(.05)             ; Patient
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,4)=ABSP(.71)             ; Service date from
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,5)=ABSP(.72)             ; Service date to
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,6)=ABSP(.1)              ; Clinic
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,7)=ABSP(.03)             ; Visit location
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,8)=ABSP(.08)             ; Active insurer
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,9)=ABSP(.58)             ; Prior Authorization
 ;S $P(^ABSPHOLD(ABSP57,"P"),U,10)=ABSP(.14)            ; Approving Official
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,1)=ABSP(41,.01)         ; Provider
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,2)=ABSP(23,.01)         ; Medication
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,3)=ABSP(23,.03)         ; Quantity
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,4)=ABSP(23,.04)         ; Unit Price
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,5)=ABSP(23,.05)         ; Dispensing Fee
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,6)=ABSP(23,19)          ; New/Refill code
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,7)=ABSP(23,.06)         ; Prescription
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,8)=ABSP(23,14)          ; Date filled
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,9)=ABSP(23,20)          ; Days supply
 ;S $P(^ABSPHOLD(ABSP57,"P2"),U,10)=ABSP("OTHIDENT")    ; Other Bill Identifier
 ;Q
 ;HOLDITR(ABSP) ;EP - ABSPOSBB
 ; Put reversal on hold.
 ;
 ;N LOG
 ;D NOW^%DTC
 ;S LOG=%
 ;
 ;D ^XBFMK      ;kill FileMan variables
 ;K DD,DO
 ;S DIC="^ABSPHOLD("
 ;S DIC(0)="L"
 ;S DINUM=LOG
 ;S DINUM=ABSP57
 ;S X=ABSP57
 ;
 ;D FILE^DICN
 ;
 ;Q:+Y<0
 ;
 ;S $P(^ABSPHOLD(ABSP57,0),U,2)="R"
 ;
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,1)=LOC
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,2)=VISDT
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,3)=INSDFN
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,4)=ABSP("CREDIT")        ; $$ to reverse
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,5)=ABSP("ARLOC")         ; A/R Bill location
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,6)=ABSP("TRAN TYPE")     ; Adjustment
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,7)=ABSP("ADJ CAT")       ; Write off
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,8)=ABSP("ADJ TYPE")      ; Billed in error
 ;S $P(^ABSPHOLD(ABSP57,"R"),U,9)=ABSP("USER")          ; User who entered tran
 ;Q
 ; CHKHOLD ;EP - ABSPOSBD
 ;CHKHOLD(HOLDIEN) ;EP - ABSPOSJ1 (pre-init routine that calls to clear HOLD queue)
 ; Process to check the hold claim.
 ;
 ;N HOLD57,HOLDTYP,HOLDREC,HOLDLOC,HOLDVDT,HOLDINS,HOLDFLG,HOLDDA
 ;
 ;S HOLD57=$P($G(^ABSPHOLD(HOLDIEN,0)),U)
 ;S HOLDTYP=$P($G(^ABSPHOLD(HOLDIEN,0)),U,2)
 ;I HOLDTYP="P" D
 ;. S HOLDREC=$G(^ABSPHOLD(HOLDIEN,"P"))
 ;. S HOLDLOC=$P(HOLDREC,U,7)
 ;. S HOLDVDT=$P(HOLDREC,U,4)
 ;. S HOLDINS=$P(HOLDREC,U,8)
 ;I HOLDTYP="R" D
 ;. S HOLDREC=$G(^ABSPHOLD(HOLDIEN,"R"))
 ;. S HOLDLOC=$P(HOLDREC,U,1)
 ;. S HOLDVDT=$P(HOLDREC,U,2)
 ;. S HOLDINS=$P(HOLDREC,U,3)
 ;I HOLDTYP'="P"&(HOLDTYP'="R") Q
 ;S HOLDFLG=$$HOLDFLG^ABSPOSBH(HOLDLOC,HOLDVDT,HOLDINS)
 ; Tax id still not found leave on hold
 ;I HOLDFLG D  Q
 ;. ;D LOG^ABSPOSL("Holding for taxid "_HOLD57_".")
 ;. S HOLDCNT=HOLDCNT+1
 ;
 ; Tax id found send to 3PB
 ;I HOLDTYP="P" D POSTIT
 ;I HOLDTYP="R" D REVERSIT
 ;
 ;I HOLDDA]"" D
 ;. N FDA,IEN,MSG
 ;. S FDA(9002313.57,HOLD57_",",.15)=HOLDDA
 ;. D FILE^DIE(,"FDA","MSG")
 ;
 ; Transaction processed remove entry from hold file
 ;D ^XBFMK      ;kill FileMan variables
 ;S DIK="^ABSPHOLD("
 ;S DA=HOLDIEN
 ;D ^DIK
 ;
 ;Q
 ;POSTIT ;
 ;N ABSP,ABSPOST,HOLDREC2
 ;
 ;S ABSP(.21)=$P(HOLDREC,U,1)                 ; Bill amount
 ;S ABSP(.23)=$P(HOLDREC,U,2)                 ; Gross amount
 ;S ABSP(.05)=$P(HOLDREC,U,3)                 ; Patient
 ;S ABSP(.71)=$P(HOLDREC,U,4)                 ; Service date from
 ;S ABSP(.72)=$P(HOLDREC,U,5)                 ; Service date to
 ;S ABSP(.1)=$P(HOLDREC,U,6)                  ; Clinic
 ;S ABSP(.03)=$P(HOLDREC,U,7)                 ; Visit location
 ;S ABSP(.08)=$P(HOLDREC,U,8)                 ; Active insurer
 ;S ABSP(.58)=$P(HOLDREC,U,9)                 ; Prior Authorization
 ;S ABSP(.14)=$P(HOLDREC,U,10)                ; Approving Official
 ;S HOLDREC2=$G(^ABSPHOLD(HOLDIEN,"P2"))
 ;S ABSP(41,.01)=$P(HOLDREC2,U,1)             ; Provider
 ;S ABSP(23,.01)=$P(HOLDREC2,U,2)             ; Medication
 ;S ABSP(23,.03)=$P(HOLDREC2,U,3)             ; Quantity
 ;S ABSP(23,.04)=$P(HOLDREC2,U,4)             ; Unit Price
 ;S ABSP(23,.05)=$P(HOLDREC2,U,5)             ; Dispensing Fee
 ;S ABSP(23,19)=$P(HOLDREC2,U,6)              ; New/Refill code
 ;S ABSP(23,.06)=$P(HOLDREC2,U,7)             ; Prescription
 ;S ABSP(23,14)=$P(HOLDREC2,U,8)              ; Date filled
 ;S ABSP(23,20)=$P(HOLDREC2,U,9)              ; Days supply
 ;S ABSP("OTHIDENT")=$P(HOLDREC2,U,10)        ; Other Bill Identifier
 ;S INSDFN=ABSP(.08)
 ;
 ;D LOG^ABSPOSL("Posting transaction "_HOLD57_".")
 ;S ABSPOST=$$EN^ABMPSAPI(.ABSP)              ; Call published 3PB API
 ;D SETFLAG^ABSPOSBC(HOLD57,0) ; clear the "needs billing" flag
 ;S HOLDDA=ABSPOST
 ;Q
 ;REVERSIT ;
 ;N ABSP,ABSPWOFF,ABSCAN
 ;S ABSP("CREDIT")=$P(HOLDREC,U,4)            ; $$ to reverse
 ;S ABSP("ARLOC")=$P(HOLDREC,U,5)             ; A/R Bill location
 ;S ABSP("TRAN TYPE")=$P(HOLDREC,U,6)         ; Adjustment
 ;S ABSP("ADJ CAT")=$P(HOLDREC,U,7)           ; Write off
 ;S ABSP("ADJ TYPE")=$P(HOLDREC,U,8)          ; Billed in error
 ;S ABSP("USER")=$P(HOLDREC,U,9)              ; User who entered tran
 ;
 ;D LOG^ABSPOSL("Reversing transaction "_HOLD57_".")
 ;S ABSPWOFF=$$EN^BARPSAPI(.ABSP)             ; Call published A/R API
 ;S ABSCAN=$$CAN^ABMPSAPI(ABSPWOFF)           ; Cancel bill in 3PB
 ;D SETFLAG^ABSPOSBC(HOLD57,0) ; clear the "needs billing" flag
 ;S HOLDDA=ABSPWOFF
 ;
 ;Q
 ;HOLDSCR ;EP - ABSPMHDR
 ;
 ;N HOLDCNT
 ;S HOLDCNT=+$P($G(^ABSPHOLD(0)),U,4)
 ;Q:HOLDCNT=0
 ;N DASH
 ;S $P(DASH,"*",61)=""
 ;W @IOF
 ;W !!!
 ;W !,?10,DASH
 ;W !,?10,"*",?69,"*"
 ;W !,?10,"*"," There are ",HOLDCNT," POS Claims not being passed to 3PB",?69,"*"
 ;W !,?10,"*"," due to missing tax id.",?69,"*"
 ;W !,?10,"*",?69,"*"
 ;W !,?10,"*"," Please run the following report for more information:",?69,"*"
 ;W !,?10,"*",?69,"*"
 ;W !,?10,"*","     HELD   Count of POS Claims not Passed to 3PB",?69,"*"
 ;W !,?10,"*",?69,"*"
 ;W !,?10,"*"," To run the report select options RPT/CLA/HELD.",?69,"*"
 ;W !,?10,"*",?69,"*"
 ;W !,?10,DASH
 ;W !!!
 ;D PRESSANY^ABSPOSU5()
 ;Q
 ; IHS/OIT/SCR 9/23/08 - Patch 28 END CHANGES
