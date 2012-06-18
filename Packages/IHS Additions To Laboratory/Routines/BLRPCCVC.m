BLRPCCVC ;IHS/OIT/MKK - IHS LAB LINK TO PCC ;JUL 06, 2010 3:14 PM
 ;;5.2;IHS LABORATORY;**1022,1024,1025,1027**;NOV 01, 1997
 ;
 ; Create BLRAPI4 INPUT array so that call to GETVISIT^APCDAPI4 will have
 ; valid INPUT variables.
EP ; EP
 K BLRAPI4                                       ; Initialize the array
 NEW OUT,SCIEN,TODAY,USER,VISITDT
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EP^BLRPCCVC 0.0","APCDALVR")
 ;
 S BLRAPI4("NEVER ADD")=1                        ; Try to find PCC Visit first
 ;
 ; ----- BEGIN IHS/OIT/MKK LR*5.2*1024 MODIFICATIONS
 S BLRAPI4("ANCILLARY")=1                        ; Create Noon Visit
 ; ----- END IHS/OIT/MKK LR*5.2*1024 MODIFICATIONS
 ;
 S BLRAPI4("PAT")=APCDALVR("APCDPAT")            ; Patient IEN
 ;
 S TODAY=$P($$NOW^XLFDT,".",1)                   ; Today -- Date only
 ;
 ; If order is today, then use Order Date/Time to try to match
 I $P($G(BLRODT),".",1)=TODAY S VISITDT=BLRODT
 ; Use Collection Date/Time if Order Date/Time not today
 I $P($G(BLRODT),".",1)'=TODAY S VISITDT=$G(BLRCDT)
 ;
 ; ----- BEGIN IHS/OIT/MKK LR*5.2*1025 MODIFICATIONS
 ; Use Collection Date/Time if FAST BYPASS option selected
 I $$UP^XLFSTR($G(BLROPT))["FASTORD" S VISITDT=$G(BLRCDT)
 ; ----- END IHS/OIT/MKK LR*5.2*1025 MODIFICATIONS
 ;
 ; Use NOW if no Collection Date/Time and Order Date/Time not today
 I $G(BLRCDT)=""&($P($G(BLRODT),".",1)'=TODAY) S VISITDT=$$NOW^XLFDT
 ;
 S BLRAPI4("VISIT DATE")=VISITDT
 ;
 I +$G(BLRORDL1)>0 S BLRAPI4("SITE")=BLRORDL1    ; Order site
 ;
 ; If no Order Site
 I +$G(BLRORDL1)<1 D
 . I +$G(BLRQSITE)>0 S BLRAPI4("SITE")=+$G(BLRQSITE)  ; Default
 . I +$G(BLRQSITE)<1 S BLRAPI4("SITE")=+$G(DUZ(2))    ; User's Site
 ;
 ; VISIT TYPE stored in PCC MASTER CONTROL file in the
 ; "type of visit" field
 S BLRAPI4("VISIT TYPE")=$P($G(^APCCCTRL(DUZ(2),0)),"^",4)
 ;
 ; Service Category IEN
 S BLRAPI4("SRV CAT")=$G(BLRVCAT)
 S BLRAPI4("TIME RANGE")=-1                      ; Don't use Time Range
 ;
 ; Try to determine the user who entered the data
 I +$G(BLRLOGDA)>0 S USER=$P($G(^BLRTXLOG(BLRLOGDA,20)),"^",6)
 I +$G(USER)<1 S USER=$G(BLRDUZ)  ; IHS/OIT/MKK MODIFICATIONS LR*5.2*1027
 I +$G(USER)<1 S USER=DUZ
 S BLRAPI4("USR")=USER
 ;
 ; Optional - Provider (Dict 200), if possible
 S:+$G(BLROPRV)>0 BLRAPI4("PROVIDER")=BLROPRV
 ;
 ; Optional - Set Hospital Location (Dict. 44), if possible
 S:+$G(BLRORDL)>0 BLRAPI4("HOS LOC")=BLRORDL
 S:+$G(BLRORDL)<1&(+$G(ORDLOC)>0) BLRAPI4("HOS LOC")=ORDLOC
 ;
 ; Optional - Default Clinic Code (Dict 40.7), if possible
 S:$G(BLRCLIN)'="" BLRAPI4("CLINIC CODE")=$P(BLRCLIN,"`",2)
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("EP^BLRPCCVC 9.0","BLRAPI4")
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK LR*5.2*1027
 ; PCC VISIT -- VISIT CREATED BY field is populated by the DUZ.
 ;              LOC. OF ENCOUNTER field is populated by DUZ(2)
RESETDUZ ; EP
 NEW USER,TSTR,NEWDUZ2,TMPORD,TMP1,TMP2
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDUZ^BLRPCCVC 0.0","DUZ")
 ;
 ; If ^BLRTXLOG Txn # existent, try VERIFIER field
 S USER=$P($G(^BLRTXLOG(+$G(BLRLOGDA),20)),"^",6)
 I +$G(USER)>0 D  Q
 . S TSTR="DUZ"_"=USER"
 . S @TSTR
 . D RESETDZ2
 . D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDUZ^BLRPCCVC 4.0","DUZ")
 ;
 ; If still not changed
 S USER=$P($G(^LRO(68,+$G(BLRAA),1,+$G(BLRAD),1,+$G(BLRAN),0)),"^",10)
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDUZ^BLRPCCVC 5.0","DUZ")
 I +$G(USER)<1 Q
 ;
 S TSTR="DUZ"_"=USER"
 S @TSTR
 ;
 D RESETDZ2
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDUZ^BLRPCCVC 9.0","DUZ")
 Q
 ;
RESETDZ2 ; EP -- Reset DUZ(2), if possible
 NEW REDO
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDZ2^BLRPCCVC 0.0","DUZ")
 S NEWDUZ2=$P($G(^BLRTXLOG(+$G(BLRLOGDA),0)),"^",9)
 S REDO="DUZ(2)"_"=NEWDUZ2"
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDZ2^BLRPCCVC 1.0","DUZ")
 I $G(NEWDUZ2)'="" S @REDO  Q
 ;
 ; If possible, reset DUZ(2) to Order Site
 S REDO="DUZ(2)"_"=BLRORDL1"
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDZ2^BLRPCCVC 2.0","DUZ")
 I +$G(BLRORDL1)>0 S @REDO  Q
 ;
 ; If still not reset, try default
 S REDO="DUZ(2)"_"=BLRQSITE"
 I +$G(BLRQSITE)>0 S @REDO
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("RESETDZ2^BLRPCCVC 9.0","DUZ")
 Q
 ; ----- END IHS/OIT/MKK LR*5.2*1027
