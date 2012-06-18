XBTM4 ; IHS/ADC/GTH - TECH MANUAL : OPTIONS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A,B,C,T,XB
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 S T=$P(^DD(19,4,0),U,3)
 F %=1:1 Q:'$L($P(T,";",%))  S T($P($P(T,";",%),":"))=$P($P(T,";",%),":",2)
 S XB="XB"
 D OP("XAz")
 S XB="ZIB"
 D OP("ZIAz")
 Q
 ;
OP(A) ; Print info on options in namespace A.
 F  S A=$O(^DIC(19,"B",A)) Q:'($E(A,1,$L(XB))=XB)  S B=$O(^(A,0)) D
 . D PR("|_|"_$P(^DIC(19,B,0),U)_"|_|"_$S('$D(^DIC(19,"AD",B)):" ** no parents **",1:"")),^DIWW
 . Q:$D(DUOUT)
 . D PR("TYPE:  "_T($P(^DIC(19,B,0),U,4))),^DIWW
 . Q:$D(DUOUT)
 . D PR("TEXT:  "_$P(^DIC(19,B,0),U,2)),^DIWW
 . Q:$D(DUOUT)
 . I $L($P(^DIC(19,B,0),U,6)) D PR("LOCK:  "_$P(^(0),U,6)),^DIWW
 . I $L($G(^DIC(19,B,20))) D PR("ENTRY ACTION:  "_^DIC(19,B,20)),^DIWW
 . I $L($G(^DIC(19,B,15))) D PR("EXIT ACTION :  "_^DIC(19,B,15)),^DIWW
 . D PR("DESCRIPTION :  ")
 . Q:$D(DUOUT)
 . S C=0
 . F  S C=$O(^DIC(19,B,1,C)) Q:'C  D PR(^(C,0)) Q:$D(DUOUT)
 . Q:$D(DUOUT)
 . D ^DIWW
 . F C=30:1:36,50,51,60:1:69,69.1:.1:69.3,71:1:73,79:1:82 I $L($G(^DIC(19,B,C))) D PR($P(^DD(19,C,0),U)_": "_^DIC(19,B,C)),^DIWW Q:$D(DUOUT)
 . Q:$D(DUOUT)
 . W !
 .Q
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) NEW A,B,C,T,XB D PR^XBTM(X) Q
 ;;There are no options distributed with the package.
 ;;|SETTAB("C")||TAB| 
 ;;There is one option associated with the Remote Patch
 ;;Installer (ZIBRPI), which is used to schedule the task.
 ;;That option is installed by ZIBRPI when the local facility
 ;;installs it.
 ;;|SETTAB("C")||TAB| 
 ;;If you have Remote Error Reporting (ZIBRER) installed, there
 ;;will be options in that namespace.
 ;;|SETTAB("C")||TAB| 
 ;;Any other XB or ZIB listed option
 ;;will have been created on your local machine.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
