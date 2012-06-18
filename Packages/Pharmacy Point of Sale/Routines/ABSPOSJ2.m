ABSPOSJ2 ;IHS/OIT/SCR - pre and post init for V1.0 patch 28 [ 10/31/2002  10:58 AM ]
 ;;1.0;Pharmacy Point of Sale;**29,39**;Jun 21,2001
 ;
 ; Pre and Post init routine use in absp0100.29k
 ;------------------------------------------------------------------
 ;
 ; Pre and Post init routine to use in absp0100.29k
 ;
 ; Purpose of new subroutines:
 ; the routine ABSPOSJ1 contained routines to process claims in the ABSPHOLD fild
 ; and then delete that file upon completion.  Patch 29 isolates this functionality
 ; from other pre and post functions to reduce the file size and because this code
 ; is suspected of not working well for at least some sites
 ;
 ;IHS/OIT/SCR = 09/22/08 - Patch 28
 ; look for HELD claims in pre-init routines and print report if they are there
 ; Remove file  ^ABSPHOLD in post-init routine
 ; Remove outdated comments to get routine block size under 1500
 ;  ;------------------------------------------------------------------
 ;IHS/OIT/SCR = 02/06/09 - Patch 29
 ; Remove OPTION 'ABSP MEDICARE PART D ELIG CHK' from OPTION 'ABSP MENU RPT CLAIM STATUS'
 ; in post install since it doesn't go away with the new menu 
 Q
 ;IHS/OIT/SCR 09/22/08 Patch 28 - remove release any HELD claims START new code
HOLDCHK  ;
 N ABSPCHK,ABSPHIEN
 S ABSPCHK=$O(^ABSPHOLD(0))
 I ABSPCHK D
 .D MES^XPDUTL("There are claims in the HOLD Queue which is being eliminated!")
 .D MES^XPDUTL("These claims are being released from the HOLD status")
 .S ABSPHIEN=0
 .;now release for processing
 .F  S ABSPHIEN=$O(^ABSPHOLD(ABSPHIEN)) Q:'+ABSPHIEN  D CHKHOLD(ABSPHIEN)
 Q
 ; taken from ABSPOSBH
CHKHOLD(HOLDIEN) ; Process to check the hold claim.
 N HOLD57,HOLDTYP,HOLDREC,HOLDLOC,HOLDVDT,HOLDINS,HOLDFLG,HOLDDA
 S HOLD57=$P($G(^ABSPHOLD(HOLDIEN,0)),U)
 S HOLDTYP=$P($G(^ABSPHOLD(HOLDIEN,0)),U,2)
 I HOLDTYP="P" D
 . S HOLDREC=$G(^ABSPHOLD(HOLDIEN,"P"))
 . S HOLDLOC=$P(HOLDREC,U,7)
 . S HOLDVDT=$P(HOLDREC,U,4)
 . S HOLDINS=$P(HOLDREC,U,8)
 I HOLDTYP="R" D
 . S HOLDREC=$G(^ABSPHOLD(HOLDIEN,"R"))
 . S HOLDLOC=$P(HOLDREC,U,1)
 . S HOLDVDT=$P(HOLDREC,U,2)
 . S HOLDINS=$P(HOLDREC,U,3)
 I HOLDTYP'="P"&(HOLDTYP'="R") Q
 I HOLDTYP="P" D POSTIT
 I HOLDTYP="R" D REVERSIT
 ;
 I HOLDDA]"" D
 . N FDA,IEN,MSG
 . S FDA(9002313.57,HOLD57_",",.15)=HOLDDA
 . D FILE^DIE(,"FDA","MSG")
 D ^XBFMK      ;kill FileMan variables
 S DIK="^ABSPHOLD("
 S DA=HOLDIEN
 D ^DIK
 ;
 Q
POSTIT ;
 N ABSP,ABSPOST,HOLDREC2
 ;
 S ABSP(.21)=$P(HOLDREC,U,1)                 ; Bill amount
 S ABSP(.23)=$P(HOLDREC,U,2)                 ; Gross amount
 S ABSP(.05)=$P(HOLDREC,U,3)                 ; Patient
 S ABSP(.71)=$P(HOLDREC,U,4)                 ; Service date from
 S ABSP(.72)=$P(HOLDREC,U,5)                 ; Service date to
 S ABSP(.1)=$P(HOLDREC,U,6)                  ; Clinic
 S ABSP(.03)=$P(HOLDREC,U,7)                 ; Visit location
 S ABSP(.08)=$P(HOLDREC,U,8)                 ; Active insurer
 S ABSP(.58)=$P(HOLDREC,U,9)                 ; Prior Authorization
 S ABSP(.14)=$P(HOLDREC,U,10)                ; Approving Official
 S HOLDREC2=$G(^ABSPHOLD(HOLDIEN,"P2"))
 S ABSP(41,.01)=$P(HOLDREC2,U,1)             ; Provider
 S ABSP(23,.01)=$P(HOLDREC2,U,2)             ; Medication
 S ABSP(23,.03)=$P(HOLDREC2,U,3)             ; Quantity
 S ABSP(23,.04)=$P(HOLDREC2,U,4)             ; Unit Price
 S ABSP(23,.05)=$P(HOLDREC2,U,5)             ; Dispensing Fee
 S ABSP(23,19)=$P(HOLDREC2,U,6)              ; New/Refill code
 S ABSP(23,.06)=$P(HOLDREC2,U,7)             ; Prescription
 S ABSP(23,14)=$P(HOLDREC2,U,8)              ; Date filled
 S ABSP(23,20)=$P(HOLDREC2,U,9)              ; Days supply
 S ABSP("OTHIDENT")=$P(HOLDREC2,U,10)        ; Other Bill Identifier
 S INSDFN=ABSP(.08)
 D LOG^ABSPOSL("Posting transaction "_HOLD57_".")
 S ABSPOST=$$EN^ABMPSAPI(.ABSP)              ; Call published 3PB API
 D SETFLAG(HOLD57,0) ; clear the "needs billing" flag
 S HOLDDA=ABSPOST
 Q
REVERSIT ;
 N ABSP,ABSPWOFF,ABSCAN
 S ABSP("CREDIT")=$P(HOLDREC,U,4)            ; $$ to reverse
 S ABSP("ARLOC")=$P(HOLDREC,U,5)             ; A/R Bill location
 S ABSP("TRAN TYPE")=$P(HOLDREC,U,6)         ; Adjustment
 S ABSP("ADJ CAT")=$P(HOLDREC,U,7)           ; Write off
 S ABSP("ADJ TYPE")=$P(HOLDREC,U,8)          ; Billed in error
 S ABSP("USER")=$P(HOLDREC,U,9)              ; User who entered tran
 D LOG^ABSPOSL("Reversing transaction "_HOLD57_".")
 S ABSPWOFF=$$EN^BARPSAPI(.ABSP)             ; Call published A/R API
 S ABSCAN=$$CAN^ABMPSAPI(ABSPWOFF)           ; Cancel bill in 3PB
 D SETFLAG(HOLD57,0) ; clear the "needs billing" flag
 S HOLDDA=ABSPWOFF
 Q
SETFLAG(IEN57,VALUE) ;EP -
 D
 . N FDA,MSG ; clear the "needs billing" flag
 . S FDA(9002313.57,IEN57_",",.16)=VALUE
SF1 . D FILE^DIE(,"FDA","MSG")
 Q
 ;IHS/OIT/CNI/RAN Following two routines added for PATCH 39.
CLNREJ ;Clean out the unrecognized reject codes in response file.
 N RESP,NUMB,RJNUMB,RJCTCODE,COUNT
 S RESP=""
 F  S RESP=$O(^ABSPR(RESP)) Q:RESP=""  D
 . Q:'$D(^ABSPR(RESP,1000))
 . S NUMB=0
 . F  S NUMB=$O(^ABSPR(RESP,1000,NUMB)) Q:+NUMB=0  D
 . . Q:'$D(^ABSPR(RESP,1000,NUMB,511))
 . . S RJNUMB=0
 . . F  S RJNUMB=$O(^ABSPR(RESP,1000,NUMB,511,RJNUMB))  Q:+RJNUMB=0  D
 . . . S RJCTCODE=$G(^ABSPR(RESP,1000,NUMB,511,RJNUMB,0))
 . . . I RJCTCODE[" " D CLEANUP(RESP,NUMB,RJNUMB,RJCTCODE)
 Q
CLEANUP(RESP,NUMB,RJNUMB,RJCTCODE) ;Clean up that particular resp file entry
 N NRJCTCD,DR,DA,DIE
 S NRJCTCD=$TR(RJCTCODE," ","")
 S DR=".01////"_NRJCTCD
 S DA(2)=RESP
 S DA(1)=NUMB
 S DA=RJNUMB
 S DIE="^ABSPR("_DA(2)_",1000,"_DA(1)_",511,"
 L +^ABSPR(DA(2)):0 I $T D ^DIE L -^ABSPR(DA(2))
 Q
