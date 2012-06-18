BDGICS ; IHS/ANMC/LJF - INCOMPLETE CHART STATISTICS ; 
 ;;5.3;PIMS;**1004,1005**;MAY 28, 2004
 ;IHS/OIT/LJF 09/29/2005 PATCH 1004 fixed prompt
 ;            02/16/2006 PATCH 1005 added observation coding report
 ;            04/06/2006 PATCH 1005 added Stats by Provider report
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,BDGA,X,Y,BDGQUIT
 ;
 ;IHS/OIT/LJF 09/29/2005 PATCH 1004; 04/06/2006 PATCH 1005 up to 6 choices
 ;F X=1:1:4 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 ;S Y=$$READ^BDGF("NO^1:4","Choose Setup Option","","","",.BDGA)
 ;Q:'Y  I Y=4 S XQH="BDG IC STATS" D EN^XQH G REPORT
 F X=1:1:6 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:6","Choose Report To Print","","","",.BDGA)
 Q:'Y  I Y=6 S XQH="BDG IC STATS" D EN^XQH G REPORT
 ;
 S BDGRPT=$P($T(RPT+Y),";;",3) Q:BDGRPT=""
 D @BDGRPT D EN^XBVK("VALM")
 Q
 ;
RPT ;;
 ;;Inpatient Coding Status Report;;^BDGICS1;;
 ;;Day Surgery Coding Status Report;;^BDGICS2;;
 ;;Observation Coding Status Report;;^BDGICS3;;;;IHS/OIT/LJF 02/16/2006 PATCH 1005 added report
 ;;Workload Report (Completion Times);;^BDGICS4;;
 ;;Incomplete/Delinquent Statistics by Provider;;^BDGICS5;;IHS/OIT/LJF 04/06/2006 PATCH 1005 added report
 ;;On-line Help (Report Descriptions);;
