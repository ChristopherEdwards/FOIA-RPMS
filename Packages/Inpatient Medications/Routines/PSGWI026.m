PSGWI026 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(59.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(59.4,4.5,21,6,0)
 ;;="Data for AMIS Stats - Print" option and the "Show AOU Status for
 ;;^DD(59.4,4.5,21,7,0)
 ;;=AMIS" option.  When you are sure that the data is accurate, then
 ;;^DD(59.4,4.5,21,8,0)
 ;;=AND ONLY THEN, set this site parameter to "YES".  Once the parameter
 ;;^DD(59.4,4.5,21,9,0)
 ;;=is set to "YES", you should under NO CIRCUMSTANCES flip the setting
 ;;^DD(59.4,4.5,21,10,0)
 ;;=back and forth.  While this parameter is set to "NO", NO DATA is
 ;;^DD(59.4,4.5,21,11,0)
 ;;=collected in the AR/WS Stats File - 58.5 for AMIS statistics!
 ;;^DD(59.4,4.5,"DT")
 ;;=2870904
 ;;^DD(59.4,5,0)
 ;;=PRINT RETURN COLUMNS?^S^1:YES;0:NO;^0;6^Q
 ;;^DD(59.4,5,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.4,5,20,1,0)
 ;;=PSGW
 ;;^DD(59.4,5,21,0)
 ;;=^^3^3^2890907^^^^
 ;;^DD(59.4,5,21,1,0)
 ;;=If 1, the return quantity column and the return reason column will appear
 ;;^DD(59.4,5,21,2,0)
 ;;=on the inventory sheet in the Automatic Replenishment package.
 ;;^DD(59.4,5,21,3,0)
 ;;=If 0, the return columns do not appear on the inventory sheet.
 ;;^DD(59.4,5,"DT")
 ;;=2850719
 ;;^DD(59.4,5.5,0)
 ;;=IS SITE SELECTABLE FOR AR/WS?^S^1:YES;0:NO;^0;26^Q
 ;;^DD(59.4,5.5,.1)
 ;;=INPATIENT PACKAGE USE
 ;;^DD(59.4,5.5,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.4,5.5,20,1,0)
 ;;=PSGW
 ;;^DD(59.4,5.5,21,0)
 ;;=^^6^6^2890725^^^^
 ;;^DD(59.4,5.5,21,1,0)
 ;;=Should this inpatient site name be shown for use by AR/WS users?  When
 ;;^DD(59.4,5.5,21,2,0)
 ;;=users sign into the module to carry out AR/WS functions, should this site
 ;;^DD(59.4,5.5,21,3,0)
 ;;=name be displayed?  If you answer "yes", the software will display or
 ;;^DD(59.4,5.5,21,4,0)
 ;;=allow you to pick this site name when you enter the module.  If you answer
 ;;^DD(59.4,5.5,21,5,0)
 ;;="no", the software will "screen out" the site name so that AR/WS users
 ;;^DD(59.4,5.5,21,6,0)
 ;;=will not see or be able to select the site name while in the AR/WS module.
 ;;^DD(59.4,5.5,"DT")
 ;;=2871211
 ;;^DD(59.4,5.6,0)
 ;;=PROMPT FOR BAR CODES?^S^1:YES;0:NO;^0;27^Q
 ;;^DD(59.4,5.6,3)
 ;;=* NOTE * This field is not in use at this time.  In a future version, if this field is answered 'Yes', users will be offered the opportunity to use bar code readers for On-Demands.
 ;;^DD(59.4,5.6,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.4,5.6,20,1,0)
 ;;=PSGW
 ;;^DD(59.4,5.6,21,0)
 ;;=^^3^3^2901012^^^^
 ;;^DD(59.4,5.6,21,1,0)
 ;;=* NOTE * This field is not in use at this time, it is for a future version.
 ;;^DD(59.4,5.6,21,2,0)
 ;;=This field will control whether or not users will be given the opportunity
 ;;^DD(59.4,5.6,21,3,0)
 ;;=to use bar code readers to enter On-Demands.
 ;;^DD(59.4,5.6,"DT")
 ;;=2900712
