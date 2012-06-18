BDGCENL ; IHS/ANMC/LJF - PAT MOVEMENT OPTIONS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,X,Y,BDGA
 F X=1:1:5 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:5","Choose Report from List","","","",.BDGA)
 Q:'Y  I Y=5 S XQH="BDG PAT MOVEMENTS" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3) X BDGRPT
 Q
 ;
RPT ;;
 ;;Reprint Admissions & Discharges Sheet;;N BDGREP S BDGREP=1 D ^DGPMGL
 ;;Selected Patient Movements;;D ^DGOPATM;;
 ;;Census Movement Worksheet;;D ^BDGCEN3;;
 ;;Track Census by Ward;;D ^BDGCEN;;
 ;;On-line Help (Report Descriptions);;
