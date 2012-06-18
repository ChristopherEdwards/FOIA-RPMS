ABSPOSIO ; IHS/FCS/DRS - NCPDP Overrides form ;   [ 06/03/2002  4:40 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1**;JUN 21, 2001
 ; Property of Indian Health Service
 ;
 ; IHS/OKCAO/POS  IHS/ASDST/lwj  1/9/02  added logic for overrides
 ; For the "new" claim option, the adding and updating of 
 ; override codes was not functioning properly - Patrick wrote
 ; code to first look up existing overrides for the prescription
 ; and/or add new overrides when requested.
 ; The original call from ABSPOSIB (at tag THEASKS) was altered
 ; to call into NEWENTR2 instead of to NEWENTRY.
 Q
NEWENTRY ;EP - create new entry if needed
 I '$$GET^DDSVAL(DIE,.DA,1.09) D
 .;W "Creating a new entry for Overrides",! R ">> ",%,!
 .D PUT^DDSVAL(DIE,.DA,1.09,$$NEW^ABSPOSO2,,"I")
 ;W "Field 1.09 = ",$$GET^DDSVAL(DIE,.DA,1.09,,"I"),!
 ;N % R ">>",%,!
 Q
NEWENTR1()         ;EP  ;from a function call IHS/OKCAO/POS 1/9/02 overrides
 ; No routines are calling into this point at this time.
 ;
 ;
NEWENTR2 ;EP - IHS/OKCAO/POS  IHS/ASDST/lwj 1/9/02  updating of overrides
 ; The original logic for the maintaining of the override codes
 ; in the "new" claim feature was not correct - this routine
 ; will replace that logic.
 ;
 ; Called from ABSPOSIB
 ;  If there isn't an RX - routine will simply quit
 ;  If there is a RX, and it already has overrides, the overrides
 ;   will be retrieved for updating
 ;  If there is a RX, and it doesn't have overrides, a new override
 ;   will be created to store with the transaction
 ;
 N RXI,RXR,OVERRIDE,FFDA,STRING
 ;
 ; get the prescription information
 S RXI=$$GET^DDSVAL(DIE,.DA,1.01)    ;RX IEN
 S RXR=$$GET^DDSVAL(DIE,.DA,1.02)    ;RX Refill IEN
 I 'RXI D NEWENTRY Q:$Q OVERRIDE Q
 ;
 ; figure out if prescription already has override information
 S OVERRIDE=$$GETIEN^ABSPOSO(RXI,RXR)   ;get override number
 ;
 ; if overrides exist - put on screen for updating
 I $G(OVERRIDE) D         ;override exists
 . S STRING(1)="Will add override from IEN RX  "_RXI  ;msg on scrn
 . S:+RXR STRING(1)=STRING(1)_"   IEN Refill  "_RXR
 . D HLP^DDSUTL(.STRING)      ;displays what is happening
 ;
 ; if override doesn't exist - create new code for use in trans file
 I '$G(OVERRIDE) D
 . S OVERRIDE=$$NEW^ABSPOSO2    ;get new code
 . S STRING(1)="Will add new Override  "_OVERRIDE
 . D HLP^DDSUTL(.STRING)
 . ;
 . I '+$G(RXR) D     ;if not a refill
 .. S FFDA(52,RXI_",",9999999.12)=OVERRIDE
 .. D FILE^DIE("","FFDA","")
 . ;
 . I +$G(RXR) D     ;refill
 .. S FFDA(52.1,RXR_","_RXI_",",9999999.12)=OVERRIDE
 .. D FILE^DIE("","FFDA","")
 ;
 ; now- update the input data file with the override code
 D PUT^DDSVAL(DIE,.DA,1.09,OVERRIDE,,"I")
 ;
 Q:$Q OVERRIDE Q
