ABSPOSN8 ; IHS/FCS/DRS - NCPDP Fms F ILC A/R ;  [ 09/12/2002  10:17 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;--------------------------------------------------------------------
 ; Calculate payments F billing ITEM.
 ;
 ; Inputs:   BITEMIEN  - Billing ITEM internal entry number.
 ;
 ; Returns:  TotPay    - Total of payments.
 ;--------------------------------------------------------------------
PAYINFO(BITEMIEN) ;
 N TOTPAY,J
 ;
 Q:$G(BITEMIEN)="" 0
 ;
 ; Loop through the payment multiple of the billing ITEMs file.
 S (TOTPAY,J)=0
 F  S J=$O(^ABSBITMS(9002302,BITEMIEN,7,J)) Q:'J  D
 . S TOTPAY=TOTPAY+$P($G(^ABSBITMS(9002302,BITEMIEN,7,J,0)),U,2)
 ;
 Q TOTPAY
