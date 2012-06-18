BDGSTAT ; IHS/ANMC/LJF - INPT STATS REPORTS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,X,Y,BDGA
 F X=1:1:4 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:4","Choose Report from List","","","",.BDGA)
 Q:'Y  I Y=4 S XQH="BDG INPT STATS" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3) D @BDGRPT
 Q
 ;
RPT ;;
 ;;Average Daily Patient Load (ADPL);;^BDGSTAT1;;
 ;;Inpatient Statistics by Ward;;^BDGSTAT2;;
 ;;Inpatient Statistics by Service;;^BDGSTAT3;;
 ;;On-line Help (Report Descriptions);;
