ASDCLDOW ; IHS/ADC/PDW/ENM - IHS CALLS FOR SDCLDOW ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ; -- called by SDCLDOW - Clinic List; Day of the Week
 ;
ASK ;EP; get clinic choices
 K ASDQ
 D ASK2^SDDIV I Y<0 S ASDQ="" Q
 S VAUTNI=1 D CLINIC^VAUTOMA I Y<0 S ASDQ="" Q
 NEW X
 S X=0 F  S X=$O(VAUTC(X)) Q:X=""  D
 . S Y=VAUTC(X),Z=0 F  S Z=$O(^SC("AIHSPC",Y,Z)) Q:Z=""  D
 .. S VAUTC($P(^SC(Z,0),U))=Z ;get indiv under prin clinic
 Q
