ABSPOSAZ ; IHS/FCS/DRS - JWS, ;  [ 09/12/2002  10:07 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ; $$GETSTAT returns $ZA^$ZB values
GETSTAT(DIALOUT)         ;
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 U IO Q $ZA_"^"_$ZB Q
 ; $$STATRPT displays info about a TCP terminal server connection (MSM)
STATRPT(DIALOUT)        ; report $ZA, $ZB for the socket
 ;
 N ZA,ZB S ZA=$$GETSTAT(DIALOUT),ZB=$P(ZA,"^",2),ZA=$P(ZA,"^") U $P
 W "$ZA = characters left in input buffer = ",ZA,!
 W "$ZB = ",ZB," " I ZB=0 W "(okay)",! Q
 I ZB>0 W "operating system error code",!
 E  I ZB=-1 W "end of input"
 E  I ZB=-2 W "socket not allocated"
 E  I ZB=-3 W "operation timed out"
 E  I ZB=-4 W "BREAK key"
 E  I ZB=-5 W "no server allocated (MSM-Unix)"
 E  I ZB=-6 W "socket already exists"
 E  I ZB=-7 W "no resource"
 E  I ZB=-8 W "license limit exceeded"
 E  I ZB=-9 W "socket operation failed (see docu)"
 E  I ZB=-10 W "variable length read timed out"
 E  W "(unknown reason?)"
 W !
 Q
