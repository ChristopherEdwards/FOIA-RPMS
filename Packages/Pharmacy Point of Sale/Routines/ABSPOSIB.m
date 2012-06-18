ABSPOSIB ; IHS/FCS/DRS - branching logic ;  [ 09/12/2002  10:11 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1,3,6**;JUN 21, 2001
 Q
 ; Situation:  after inputting NDC #, there are a number of
 ; pop-up pages which could appear.  Process them in order.
 ; This is called from the Branching Logic of various places,
 ; starting with the NDC # prompt on the main page.
 ;
 ; When you detect a pop-up page that should be done,
 ; set DDSSTACK and it pops up the page.
 ; Then, at the bottom of that page, the branching logic will
 ; call this routine again, at an appropriate entry point,
 ; and DDSSTACK may be set again.
 ; 
 ; When it's all done, DDSSTACK is not set in here
 ; and the main page comes back.
 ;
 ; /IHS/OKCAO/POC /IHS/ASDST/lwj 1/9/02 override codes are not  
 ; working properly - call to NEWENTRY^ABSPOSIO at the THEASKS
 ; tag changed to call NEWENTR2 instead.
 ;
 ;-------------------------------------------------
 ;IHS/SD/lwj 7/14/03 new branching logic for the overrides added.
 ; This is done to accomodate the expanded override capabilities
 ; of NCPDP 5.1
 ;
 ;-------------------------------------------------
 ; 
PAGE1 ;EP - Branching logic for Page 1, Block ABSP PAGE 1 BOTTOM,
 ; Field 3, NDC DISP.
 ; X = what the user just put in for NDC #
 ;
 ;  Disable the Fill Date field.  (It will reenabled on a case-by-case
 ;  basis after inputting Prescription)
 ;
 D UNED^DDSUTL(6,3,1,1) ; field order 6, block 3, page 1, disabled
 ;
 ; If POSTAGE, then branch to the POSTAGE page.
 ; (And later, the POSTAGE page will decide whether to do any of
 ;  the subsequent pages, by DO POSTAGE^ABSPOSIB.)
 I X="POSTAGE" S DDSSTACK=X Q
 ;
POSTAGE ;EP - Branching logic for bottom of POSTAGE page is here
 ;
 ; If any of the other "asks" are set:  Insurance, Preauthorization,
 ; or Pricing - then pop up that page.
 ;
 I $$DOPAGE^ABSPOSI7 S DDSSTACK="THE ASKS" Q
 ;
 ;
THEASKS ;EP - Branching logic for bottom of THE ASKS page is here
 ; IHS/OKCAO/POS  IHS/ASDST/lwj 01/09/02 call to NEWENTRY
 ; remarked out - new call to NEWENTR2 added.  This was done
 ; to fix the override codes which were not working.
 ;----
 ;IHS/SD/lwj 7/14/03 branching logic alter so new page of
 ; override questions is asked - this is to accomodate
 ; expanded 5.1 capabilities  (NEWENTR2^ABSPOSIO is now
 ; called as part of the screen branching from page 13
 ; general overrides questions.) 
 ;
 I $$DOFIELD^ABSPOSI7(1.05) D
 . ;D NEWENTRY^ABSPOSIO     ;IHS/OKCAO/POC IHS/ASDST/lwj removed
 . ;D NEWENTR2^ABSPOSIO      ;IHS/OKCAO/POS IHS/ASDST/lwj added
 . ;S DDSSTACK="NCPDP OVERRIDES"  ;IHS/SD/lwj 7/14/03 removed
 . S DDSSTACK="OVERRIDE ASKS"   ;IHS/SD/lwj 7/14/03 new screen
 . ;S DDSSTACK="DUR 5.1 ENTRY"   ;IHS/SD/lwj 7/14/03 new screen
 ;
 ; Else no special branching; quit without setting DDSSTACK
 Q
FILLDATE ; EP - from EFFECTS^ABSPOSI1 - after the Prescription field,
 ; This is the BRANCHING LOGIC for the PRESCRIPTION field ; ABSP*1.0T7*7
 ; should we go to the Fill Date field?
 ;  Only if (1) the Fill Date field is enabled
 ;      and (2) it is a prescription
 ;      and (3) there are any refills.
 I X="" S DDSBR=2 Q  ; If PRESCRIPTION field empty, stay there. ; ABSP*1.0T7*7
 N DOFILLDT,RXI
 S DOFILLDT=$$DOFIELD^ABSPOSI7(1.04) ; the yes/no field must be "Yes"
 I DOFILLDT S RXI=$$GET^DDSVAL(DIE,.DA,1.01,,"I") I 'RXI S DOFILLDT=0
 I DOFILLDT S DOFILLDT=$O(^PSRX(RXI,1,0))>0
 D UNED^DDSUTL(6,3,1,'DOFILLDT) ; field 6, block 3, page 1
 I DOFILLDT S DDSBR=6 ; and branch to that field
 Q
