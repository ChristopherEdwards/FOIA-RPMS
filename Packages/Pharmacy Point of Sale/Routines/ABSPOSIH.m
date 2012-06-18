ABSPOSIH ; IHS/FCS/DRS - NCPDP 5.1 DUR Overrides form ;   [ 06/03/2002  4:40 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**6**;JUN 21, 2001
 ; Property of Indian Health Service
 ;
 Q
PREINIT ;EP - check for existing record
 ; This is the pre-init routine tied to the
 ; ABSP INPUT 5.1 DUR INPUT block on the ABSP Input Data screen
 ; This is used during the creation of the "new" claim from
 ; within POS  (called from the "USER" screen) to capture
 ; NCPDP 5.1 DUR override values.
 ;
 ;
 N RXI,RXR,OVERDUR,FDA,STRING
 ;
 ; get the prescription information
 S RXI=$$GET^DDSVAL(DIE,.DA,1.01)    ;RX IEN
 S RXR=$$GET^DDSVAL(DIE,.DA,1.02)    ;RX Refill IEN
 S OVERDUR=""
 ;
 Q:$G(RXI)=""  ;no pres - get out  
 ;
 S OVERDUR=$$GETDUR^ABSPOSO(RXI,RXR)   ;get dur override number
 ;
 I $G(OVERDUR)'="" D         ;override exists
 . S STRING(1)="Will add override from IEN RX  "_RXI  ;msg on scrn
 . S:+RXR STRING(1)=STRING(1)_"   IEN Refill  "_RXR
 . D HLP^DDSUTL(.STRING)      ;displays what is happening
 . ;
 I $G(OVERDUR)="" D        ;override doesn't exist yet
 . S OVERDUR=$$NEW^ABSPOSD2
 . S STRING(1)="Will add new Override  "_OVERDUR
 . D HLP^DDSUTL(.STRING)
 ;
 ; create empty entries for adding new data
 D NEWSUB^ABSPOSD2(OVERDUR)
 ;
 ; now- update the input data file and the prescription
 D UPDRX(RXI,RXR,OVERDUR)
 D PUT^DDSVAL(DIE,.DA,1.13,OVERDUR,,"I")
 ;
 ; theres a chance they won't file the claim - hold on to the
 ; dur so we can clean up empty records if its not filed
 ;
 S ^TMP("ABSPOSIH",$J,OVERDUR)=RXI_"^"_RXR
 ;
 Q
 ;
CLNDUR(IEN,ENTRY) ;EP - clean up the DUR file of empty entries
 ; and update the RX file when no override information
 ; was actually entered for the 5.1 DUR segment.
 ; This routine called from ABSPOSIZ - subroutine FILE
 ;
 ;
 N OVERDUR,DATAREC
 ;
 S DATAREC=$G(^ABSP(9002313.51,IEN,2,ENTRY,1))
 ;
 S OVERDUR=$P(DATAREC,"^",10)
 Q:OVERDUR=""   ;IHS/SD/lwj 8/4/03 just quit
 ;
 S RXI=$P(DATAREC,"^")
 S RXR=$P(DATAREC,"^",2)
 ;
 S OVERDUR=$$CHKDUR^ABSPOSD2(OVERDUR)  ;good data input?
 ;
 I $G(OVERDUR)="" D   ;nothing input - delete it
 . D UPDRX(RXI,RXR,OVERDUR)
 . N FDA
 . S FDA(9002313.51,ENTRY_","_IEN_",",1.13)=OVERDUR
 . D FILE^DIE("","FDA","")
 ;
 Q
 ;
UPDRX(RXI,RXR,OVERDUR) ; update the prescription with the DUR 5.1 information
 ; and the ABSP Data Input file with the appropriate value
 ;
 ;
 ; OVERDUR set within POSTINIT
 ; RXR - rx refill IEN
 ; RXI - rx IEN
 ; OVERDUR - NCPDP 5.1 DUR segment pointer
 ;
 I '+$G(RXR) D    ;NOT a refill
 . S FDA(52,RXI_",",9999999.13)=OVERDUR
 . D FILE^DIE("","FDA","")
 ;
 I +$G(RXR)  D    ;refill
 . S FDA(52.1,RXR_","_RXI_",",9999999.13)=OVERDUR
 . D FILE^DIE("","FDA","")
 ;
 Q
 ;
NOCLM ;EP - called from ABSPOSI when the claims are NOT filed - we
 ; still must clean up the empty records if they called upon
 ; the DUR overrides
 ;
 N DURIEN,CLNDUR
 S DURIEN=0
 ;
 F  S DURIEN=$O(^TMP("ABSPOSIH",$J,DURIEN)) Q:DURIEN=""  D
 .  N CLNDUR,RXI,RXR,DURREC
 .  S DURREC=$G(^TMP("ABSPOSIH",$J,DURIEN))
 .  S RXI=$P(DURREC,"^")    ;internal RX number
 .  S RXR=$P(DURREC,"^",2)  ;refill number
 .  S CLNDUR=$$CHKDUR^ABSPOSD2(DURIEN)
 .  D:$G(CLNDUR)="" UPDRX(RXI,RXR,CLNDUR)
 ;
 ;
 Q
