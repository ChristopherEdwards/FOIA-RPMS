BDGIMPL ; IHS/ANMC/LJF - ADT IMPLEMENTATION ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
EN ;EP; called by installer from programmer mode
 ; runs through items on ADT System Definition Menu after install
 ;    while users still off system
 ;
 NEW BDGDIV D VAR^BDGVAR   ;set up system wide variables
 ;
ACTION ; -- choose which action to perform
 NEW BDGACT,BDGA,X,Y,BDGQUIT
 W !!
 F X=1:1:5 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:5","Choose Implementation Action","","","",.BDGA)
 Q:'Y  I Y=5 S XQH="BDG IMPLEMENT" D EN^XQH G ACTION
 S BDGACT=$P($T(RPT+Y),";;",3) X BDGACT D EN^XBVK("VALM")
 D ACTION
 Q
 ;
RPT ;;
 ;;Edit ADT Parameters;;D ^BDGPARM;;
 ;;Set Up ADT Files;;D ^BDGSYS;;
 ;;Check ADT-PCC Link;;NEW X S X=$$CHECK^BDGVAR(2);;
 ;;Initialize Census Files;;D ^BDGCENI;;
 ;;On-line Help;;
