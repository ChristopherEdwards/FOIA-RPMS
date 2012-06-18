BDGSYS ; IHS/ANMC/LJF - SYSTEM FILES SETUP ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,BDGA,X,Y,BDGQUIT
 W !! F X=1:1:8 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:8","Choose Setup Option","","","",.BDGA)
 Q:'Y  I Y=8 S XQH="BDG SYS SETUP" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3)
 D @BDGRPT D EN^XBVK("VALM")
 D REPORT
 Q
 ;
RPT ;;
 ;;Hospital Service Setup;;^BDGSYS1;;
 ;;Treating Specialty Setup;;^BDGSYS2;;
 ;;Wards Setup;;^BDGSYS3;;
 ;;Room-Bed Setup;;^BDGSYS4;;
 ;;Transfer Facilities Setup;;^BDGSYS7
 ;;ADT Event Driver View;;^BDGSYS5;;
 ;;Add Mail Groups to PIMS Bulletins;;^BDGSYS6;;
 ;;On-line Help (Report Descriptions);;
