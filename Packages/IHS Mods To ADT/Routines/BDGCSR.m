BDGCSR ; IHS/ANMC/LJF - CODING STATUS REPORTS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,X,Y,BDGA
 F X=1:1:6 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:6","Choose Report from List","","","",.BDGA)
 Q:'Y  I Y=6 S XQH="BDG CODING STATUS" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3) D @BDGRPT
 Q
 ;
RPT ;;
 ;;Inpatient Coding Status;;^BDGCSR1;;
 ;;Day Surgery Coding Status;;^BDGCSR2;;
 ;;List Coded/Exported Inpatient Visits;^BDGCSR3;;
 ;;List Coded/Exported Day Surgeries;;^BDGCSR4;;
 ;;List PCC Visits with Codes;;^BDGCSR5;;
 ;;On-line Help (Report Descriptions);;
