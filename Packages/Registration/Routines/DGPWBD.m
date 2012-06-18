DGPWBD ;ALB/CAW - Device Specifications for Patient Wristband ;2/14/95
 ;;5.3;Registration;**62,82,246,385,1004,1009**;Aug 13, 1993
 ;IHS/OIT/LJF 11/04/2005 PATCH 1004 barcode will be facility code & chart #
 ;cmi/anch/maw 02/18/2008 PATCH 1009 requirement 3
 ;
BL ; Barcode Blazer
 N LINE
 U IO
 S LINE=$G(^%ZIS(2,IOST(0),203)) W LINE,LINE1,!
 S LINE=$G(^%ZIS(2,IOST(0),205)) W LINE,LINE2,!
 S LINE=$G(^%ZIS(2,IOST(0),207)) W LINE,LINE3,!
 S LINE=$G(^%ZIS(2,IOST(0),209)) W LINE,LINE4,!
 ;
 ;IHS/OIT/LJF 11/04/2005 PATCH 1004 using facility code_chart # (12 digits)
 ;S VARIABLE=$P(VADM(2),U)
 ;VARIABLE is the SSN without dashes.
 S VARIABLE=$$HRCNF^BDGF2(DFN,DUZ(2))
 ;
 I $L($G(^%ZIS(2,+IOST(0),"BAR1"))) W @^%ZIS(2,IOST(0),"BAR1")
 W VARIABLE  ;cmi/maw 2/18/2008 PATCH 1009 requirement 3
 Q
ADD ; Add different barcode set up here
 Q
