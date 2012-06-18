ABSPOSBV ; IHS/FCS/DRS - ILC A/R billing interface ;   
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ;
VCPT() ;EP - from ABSPOSQB
 ; create new VCPT entry based on ^ABSPTL(IEN57,...)
 ; First, lookup in charge file, possibly having to create a new entry
 N CPTIEN S CPTIEN=$$CPTIEN^ABSPOS57
 I 'CPTIEN S CPTIEN=$$NEWCPT I 'CPTIEN Q ""
 ; Now that it exists in the charge file, you can create VCPT
 N VCPTIEN,FDA,IEN,MSG,FN,PLUS1 S FN=9002301,PLUS1="+1,"
 ; The .01 field points to the charge file
 S FDA(FN,PLUS1,.01)=CPTIEN
 ;
 ; FDA setup specific to the type of charge:
 ;
 I $$TYPE=1!($$TYPE=2) D  ; prescription or postage, either one
 . S FDA(FN,PLUS1,1.5)=$$FILLDATE^ABSPOS57
 . ; VCPT, (#58) DATE OF SERVICE - take fill date, not the visit date.
 . ; ex. Mt. Edgecumbe, presc. `341641 has PCC link to a 1990 visit
 . ;  but a May, 2000 fill date
 . S FDA(FN,PLUS1,58)=FDA(FN,PLUS1,1.5) ; DATE OF SERVICE, same
 . I $D(^DD(FN,74)) D  ; Sitka didn't have this field on 06/21/2000
 . . S FDA(FN,PLUS1,74)=$$PROVIDER^ABSPOS57
 . S FDA(FN,PLUS1,56)=$$RXI^ABSPOS57
 . S FDA(FN,PLUS1,56.2)=$$VMED^ABSPOS57
 . S FDA(FN,PLUS1,56.3)=$$RXR^ABSPOS57
 E  I $$TYPE=3 D
 . S FDA(FN,PLUS1,58)=$$FILLDATE^ABSPOS57 ;$P(^AUPNVSIT($$VISITIEN,0),U)
 ;
 ; FDA setup regardless of type of charge
 ;
 S FDA(FN,PLUS1,.02)=$$PATIENT^ABSPOS57
 S FDA(FN,PLUS1,.03)=$$VISITIEN^ABSPOS57
 S FDA(FN,PLUS1,2)=$$CHG^ABSPOS57
 S FDA(FN,PLUS1,4)=$$USER^ABSPOS57
 S FDA(FN,PLUS1,4.5)=$$NOW^ABSPOS57
 S FDA(FN,PLUS1,52)=$$VCN^ABSPOS57
 S FDA(FN,PLUS1,53)=$$QTY^ABSPOS57
 ;
 I $D(^DD(FN,59.2)) D  ; Sitka didn't have this field on 06/21/2000
 . S FDA(FN,PLUS1,59.2)=$P(^ABSCPT(9002300,CPTIEN,0),U,6) ; REV CODE
 D UPDATE^DIE("S","FDA","IEN","MSG")
 I $D(MSG) D
 . D LOG^ABSPOSL("Failed to create VCPT entry!")
 . D LOGARRAY("FDA"),LOGARRAY("IEN"),LOGARRAY("MSG")
 Q $G(IEN(1))
LOGARRAY(X) D LOGARRAY^ABSPOSL(X) Q
NEWCPT() ; create new CPT entry based on ^ABSPTL(IEN57,...)
 N FDA,MSG,FN,PLUS1 S FN=9002300,PLUS1="+1,"
 D LOG^ABSPOSL("Creating new CPT code for IEN57="_IEN57)
 I $$TYPE=1 D
 . S FDA(FN,PLUS1,.01)=$$NDC^ABSPOS57 ; CODE
 . S FDA(FN,PLUS1,1)=$$DRGNAME^ABSPOS57 ; SHORT DESCRIPTION
 . S FDA(FN,PLUS1,2)=$$DRGNAME^ABSPOS57 ; LONG DESCRIPTION
 . ; S FDA(FN,PLUS1,3) ; LOOKUP
 . S FDA(FN,PLUS1,4)=$P($G(^ABSPTL(IEN57,5)),U,2) ; RATE
 . ;S FDA(FN,PLUS1,5)=$O(^ABSREV(
 . S FDA(FN,PLUS1,101)=$$DRGDFN^ABSPOS57 ; DRUG FILE POINTER
 . S FDA(FN,PLUS1,102)=$$NDC^ABSPOS57 ; NDC #
 . ; 103)=BRAND NAME ; could get from ^APSAMDF?
 E  I $$TYPE=2 D
 . D IMPOSS^ABSPOSUE("P","TI","New charge file entry for postage items not yet implemented",,"NEWCPT",$T(+0))
 E  I $$TYPE=3 D
 . D IMPOSS^ABSPOSUE("P","TI","New charge file entry for supply items not yet implemented",,"NEWCPT",$T(+0))
 E  D IMPOSS^ABSPOSUE("P","TI","Unaccounted-for $$TYPE="_$$TYPE,,"NEWCPT",$T(+0))
NEW8 D UPDATE^DIE("S","FDA","IEN","MSG")
 I $D(MSG) D  G NEW8:$$IMPOSS^ABSPOSUE("FM","TRI","UPDATE^DIE failed",.MSG,"NEWCPT",$T(+0))
 . D LOG^ABSPOSL("Failed to create a new CPT code!")
 . D LOGARRAY("FDA"),LOGARRAY("IEN"),LOGARRAY("MSG")
 E  D
 . D LOG^ABSPOSL("New CPT code is at ^ABSCPT(9002300,"_IEN(1)_")")
 Q $G(IEN(1))
TYPE() Q $$TYPE^ABSPOS57 ; and it traps out-of-range values
