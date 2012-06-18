ABSPOSI7 ; IHS/FCS/DRS - utilities to go with Page 7 ;  [ 08/30/2002  7:20 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------
 ;IHS/SD/lwj 8/29/02  NCPDP 5.1 changes
 ; new field added to the insurance/prior authorization screen
 ; to capture the Prior Authorization Type Code.  Changed
 ; ENAB subroutine to enable and disable this field.  The 
 ; field will be enabled when the preauthorization code is 
 ; enabled, and disabled when the preauth is disable.
 ; The only time the value of this field will be recorded in 
 ; the claim is when the format for the claims is 5.1.
 ;----------------------------------------------------------
 Q
DOPAGE() ;EP - should we do page 7? Only if one or more of the ques. are enabled
 ; this is used by the BRANCH logic of the NDC/CPT/HCPCS field
 ; to figure whether to set DDSSTACK="THE ASKS"
 ; Actual enabling is done by ENAB
 N DOIT
 I $$DOFIELD(1.01) S DOIT=1 ; insurance
 E  I $$DOFIELD(1.02) S DOIT=1 ; preauth
 E  I $$DOFIELD(1.03) S DOIT=1 ; pricing
 E  S DOIT=0
 Q DOIT
ISCPT() ; non-prescription, CPT code - detected by absence of RXI
 Q $$GET^DDSVAL(DIE,.DA,1.01)=""
DOFIELD(N) ;EP - context: form, page 1, block ABSP PAGE 1 BOTTOM 
 ; DIE = "^ABSP(9002313.51,DA(1),2,DA,"
 ; DA(1), DA point to the line item.
 ; But we're looking at the yes/no's at ^ABSP(9002313.51,DA(1),*)
 N RET S RET=$$GET^DDSVAL(9002313.51,DA(1),N)
 ; For insurance, you have to have had lines set up for insurance, too
 I N=1.01,RET S RET=RET&$D(^ABSP(9002313.51,DA(1),2,DA,"I",1))
 ; for pricing, this can't be POSTAGE (it's done on Page 11, not 7)
 I N=1.03 D
 . ; Do not ask pricing for POSTAGE; it has its own pricing page
 . I $$GET^DDSVAL(DIE,.DA,.03)="POSTAGE" S RET=0 Q
 . ; Do ask pricing for CPT codes (detected by absence of RXI)
 . I $$ISCPT S RET=1 Q
 Q RET
ENAB ; enable/disable blocks,fields based on settings in fields 1.01 ff
 ; done on entry to page 7
 D ENAB1(1.01,4,1) ; insurance
 ;
 ;IHS/SD/lwj 8/30/02 NCPDP 5.1 changes
 ; A new field for the prior auth type code was needed- to have
 ; the screen flow, the new field, and the existing preauthorization
 ; field were reversed - field 1 is now the type, and field 2 is the
 ; prior auth number (formally preauthorization)
 D ENAB1(1.02,1,2)  ;IHS/SD/lwj 8/30/02 now the prior auth type
 ;
 D ENAB1(1.02,2,2)  ;IHS/SD/lwj 8/30/02 this is the prior auth number 
 ;
 ;IHS/OIT/SCR 11/20/08 modified line to include incentive amount
 ;N F F F=11,12,14 D ENAB1(1.03,F,3) ; qty, unit price, dispense fee
 N F F F=11,12,17,14 D ENAB1(1.03,F,3) ; qty, unit price, dispense fee,incentive amount
 ; set up some pricing defaults if nothing is set up yet
 I $$DOFIELD(1.03),$$GET^DDSVAL(DIE,.DA,5.02)="" D PAGE7^ABSPOSQP
 ; set up some insurance defaults if nothing is set up yet
 I $$DOFIELD(1.01),$$GET^DDSVAL(DIE,.DA,7.01)="" D INIT^ABSPOSI8
 Q
ENAB1(ORIG,FIELD,BLOCK,PAGE)         ;EP
 I '$G(PAGE) S PAGE=7
 D UNED^DDSUTL(FIELD,BLOCK,PAGE,'$$DOFIELD(ORIG))
 Q
RECALC1 ;EP - from ABSPOSI2,ABSPOSQP 
 ; when you change quantity or unit price
 N X S X=$$GET^DDSVAL(DIE,.DA,5.01)
 N Y S Y=$$GET^DDSVAL(DIE,.DA,5.02)
 N Z S Z=X*Y
 S Z=$$ROUND(Z)
 D PUT^DDSVAL(DIE,.DA,5.03,$J(Z,0,2))
 D RECALC2 ; and then that affects the total price
 Q
RECALC2 ; when you change dispense fee
 N X S X=$$GET^DDSVAL(DIE,.DA,5.03)
 N Y S Y=$$GET^DDSVAL(DIE,.DA,5.04)
 ;IHS/OIT/SCR 11/20/08
 N ABSPINCT S ABSPINCT=$$GET^DDSVAL(DIE,.DA,5.07)
 ; N Z S Z=X+Y
 N Z S Z=X+Y+ABSPINCT
 S Z=$$ROUND(Z)
 D PUT^DDSVAL(DIE,.DA,5.05,$J(Z,0,2))
 Q
ROUND(X) Q X*100+.5\1/100
