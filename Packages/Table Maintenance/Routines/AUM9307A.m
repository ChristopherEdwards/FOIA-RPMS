AUM9307A ; DSD/GTH - STANDARD TABLE UPDATES DATA A, 08JUL93 MEMO ; [ 07/08/93  4:32 PM ]
 ;;93.1;TABLE MAINTENANCE;**5**;MARCH 23, 1993
 ;
 ;  Only those new entries whose last piece is "Y" will be entered.
 ;  If you do not want the entry made in your area, remove the last
 ;    piece whose value is "Y".
 ;
 ;  Only those modified entries whose 'TO' line ends in "Y" will be
 ;    modified.
 ;  If you don't want the modification performed in your area, remove
 ;    the last piece whose value is "Y".
 ;
LOCNEW ; A.  NEW LOCATION CODES: AREA^S.U.^FAC.^NAME
 ;;18^22^33^LAKE DELTON HL^Y
 ;;45^43^12^FLATHEAD TRIBAL CLINIC^Y
 ;;66^17^11^X-L HEALTH CENTER^Y
 ;;END
COMMNEW ; B.  NEW COMMUNITY CODES: STATE^CNTY^COMM^NAME^AREA^S.U.
 ;;06^12^350^BLUE LAKE^66^26^Y
 ;;06^18^840^WESTWOOD^66^30^Y
 ;;06^18^841^JANESVILLE^66^30^Y
 ;;06^18^842^JOHNSTONVILLE^66^30^Y
 ;;06^18^843^DOLYE^66^30^Y
 ;;06^18^844^MILFORD^66^30^Y
 ;;END
COMMMOD ; C.  COMMUNITY CODE CHANGES: STATE^CNTY^COMM^NAME^AREA^S.U.
 ;;FROM^04^11^011^APACHE JUNCTION^60^67
 ;;  TO^04^11^011^APACHE JUNCTION^60^66^Y
 ;;FROM^04^07^129^MESA^60^67
 ;;  TO^04^07^129^MESA^60^66^Y
 ;;FROM^26^15^001^CHARLEVOIX^11^00
 ;;  TO^26^15^017^CHARLEVOIX^18^23^Y
 ;;FROM^26^15^016^BEAVER ISLAND^11^00
 ;;  TO^26^15^016^BEAVER ISLAND^18^23^Y
 ;;END
