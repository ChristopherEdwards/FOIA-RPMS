ASU3ISQA ; IHS/ITSC/LMH -QUANTITY ADJUST TO STANDARD PACK ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine checks an index item in the station master for a
 ;;standard pack quantity.  If one exists, the quantity requested on
 ;;an issue is adjusted to a multiple of standard pack quantity if
 ;;that quantity is within an acceptable upper and lower range of the
 ;;quantity requested.
SPQ(X,Y) ;EP; ADJUST TO STANDARD PACK QUANTITY 
 ; X=QTY REQUESTED
 ; Y=QTY TO ISSUE
 ; Z=FORMULA VARIABLES AND CONSTANTS
 N Z S Z("LOBG")=0,Z("LOND")=.11,Z("HIBG")=.89,Z("HIND")=1
START ;
 S Y=X
 Q:ASUMS("SPQ")'>0  Q:X=ASUMS("SPQ")
 I X>ASUMS("SPQ") D
 .S Z=X F  S Z("ADJ")=Z-ASUMS("SPQ"),Z=Z("ADJ") Q:ASUMS("SPQ")>Z("ADJ")
 E  D
 .S Z("ADJ")=X
 S Z("DEC")=Z("ADJ")/ASUMS("SPQ")
 I Z("DEC")'<Z("HIBG")&(Z("DEC")<Z("HIND")) D
 .S Z("ADJ")=ASUMS("SPQ")-Z("ADJ"),Y=X+Z("ADJ")
 E  D
 .I X<ASUMS("SPQ") Q
 .I (Z("DEC")>Z("LOBG"))&(Z("DEC")<Z("LOND")) D
 ..S Y=X-Z("ADJ"),Z("ADJ")=Z("ADJ")*-1
 Q
EOQ(X,Y) ;EP; SET RANGE FOR ECONOMIC ORDER QUANTITY
 N Z S Z("LOBG")=0,Z("LOND")=.49999999999999999,Z("HIBG")=.5,Z("HIND")=1
 G START
