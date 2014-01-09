DGCRP3 ;ALB/RJS - BRIDGE ROUTINE TO IBCF13 FROM A/R TO IB ; 20-OCT-92
 ;;5.3;Registration;**1015**;Aug 13, 1993;Build 21
 ;
 ;Entry point for Ar to print 2nd and 3rd notice bills
 ;Device handling to be done by calling routine
 ;Requires Input: - PRCASV("ARREC") = internal number of bill
 ;                - PRCASV("NOTICE") = number of notice
 ;Outputs:        - DGCRAR("ERR") = error message
 ;                - DGCRAR("OKAY") = 1 normal finish, 0 not finished
 ;
REPRNT ;
 Q  ;ihs/cmi/maw 02/08/2012 patch 1014 no IB
 D REPRNT^IBCF13
 S DGCRAR("OKAY")=IBAR("OKAY")
 I $D(IBAR("ERR")) S DGCRAR("ERR")=IBAR("ERR")
 K IBAR
 Q
