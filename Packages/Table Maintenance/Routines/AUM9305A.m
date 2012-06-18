AUM9305A ; DSM/GTH - STANDARD TABLE UPDATES DATA A, 7MAY93 MEMO ; [ 05/11/93  10:33 AM ]
 ;;93.1;TABLE MAINTENANCE;**2**;MAY 07, 1993
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
 ;  NOTE:  Taholah is being re-activated, and will probably exist in
 ;         the LOCATION file.  That's why it's listed as a Location
 ;         modification.
LOCMOD ; A.  NEW LOCATION CODES: AREA^S.U.^FAC.^NAME
 ;;FROM^70^78^10^TAHOLAH H CT
 ;;  TO^70^78^10^TAHOLAH HEALTH CENTER^Y
 ;;END
COMMNEW ; B.  NEW COMMUNITY CODES: STATE^CNTY^COMM^NAME^AREA^S.U.
 ;;16^20^001^GLENNS FERRY^70^00^Y
 ;;41^24^001^JEFFERSON^70^82^Y
 ;;55^34^940^BRYANT^18^22^Y
 ;;55^34^943^WHITE LAKE^18^22^Y
 ;;55^43^945^LENA^18^22^Y
 ;;55^43^946^MOUNTAIN^18^22^Y
 ;;55^43^947^OCONTO FALLS^18^22^Y
 ;;55^59^985^ANIWA^18^22^Y
 ;;END
CLINNEW ; C.  NEW CLINIC CODES
 ;;78^OTC MEDICATIONS^Y
 ;;END
 ;
