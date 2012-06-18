XBTM3 ; IHS/ADC/GTH - TECH MANUAL : SECURITY KEYS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A,B,C
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 F A="XAz","ZIBz" D SK(A) Q:$D(DUOUT)
 Q
 ;
SK(A) ; Print info on security keys for namespace A.
 F  S A=$O(^DIC(19.1,"B",A)) Q:'($E(A,1,4)="XB")  S B=$O(^(A,0)) D
 . S DIWF="WN"
 . D PR("|_|"_$P(^DIC(19.1,B,0),U)_"|_|")
 . Q:$D(DUOUT)
 . I '$O(^DIC(19,"AOL",A,0)) D PR("   --> KEY NOT USED <--") I 1
 . E  S C=0 F  S C=$O(^DIC(19,"AOL",A,C)) Q:'C  D PR("Locks "_$P(^DIC(19,C,0),U)_", '"_$P(^DIC(19,C,0),U,2)_"'.")
 . Q:$D(DUOUT)
 . S DIWF="W"
 . D PR("DESCRIPTION: ")
 . Q:$D(DUOUT)
 . S C=0
 . F  S C=$O(^DIC(19.1,B,1,C)) Q:'C  D PR(^(C,0))
 . Q:$D(DUOUT)
 . D ^DIWW
 . W !
 .Q
 D ^DIWW
 Q
 ;
PR(X) NEW A,B,C D PR^XBTM(X) Q
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
