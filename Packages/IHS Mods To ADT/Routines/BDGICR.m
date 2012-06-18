BDGICR ; IHS/ANMC/LJF - INCOMPLETE CHART REPORTS ; 
 ;;5.3;PIMS;**1007**;APR 26, 2002
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,BDGA,X,Y,BDGQUIT
 F X=1:1:7 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 S Y=$$READ^BDGF("NO^1:7","Choose Setup Option","","","",.BDGA)
 Q:'Y  I Y=7 S XQH="BDG IC REPORTS" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3) Q:BDGRPT=""
 D @BDGRPT D EN^XBVK("VALM")
 Q
 ;
RPT ;;
 ;;Discharges by Date;;DSCDT^BDGICR;;
 ;;Day Surgeries by Date;;DSDT^BDGICR;;
 ;;Incomplete Charts by Patient;;^BDGICR1;;
 ;;Incomplete Charts by Provider;;^BDGICR2;;
 ;;Daily/Weekly Completed Charts;;^BDGICR5;;
 ;;Listing of Coded A Sheets;;^BDGICR4;;
 ;;On-line Help (Report Descriptions);;
 ;
DSCDT ;EP; call FM print template for discharges by date
 NEW L,DIC,FLDS,BY,FR,TO
 W ! S L=0,DIC="^BDGIC(",(FLDS,BY)="[BDG DISCHARGES]"
 D EN1^DIP,PAUSE^BDGF
 Q
 ;
DSDT ;EP; call FM print template for day surgeries by date
 NEW L,DIC,FLDS,BY,FR,TO
 W ! S L=0,DIC="^BDGIC(",(FLDS,BY)="[BDG DAY SURGERIES]"
 D EN1^DIP,PAUSE^BDGF
 Q
 ;
2 ;--cmi/anch/maw original lines from PRINT^BDGICR2 moved because of routine size limit
 ;cmi/anch/maw orig lines below 7/10/2007 patch 1007
 ;F BDGI=1:1:BDGCOP D
 ;. I BDGI>1 W @IOF   ;form feed between copies
 ;. K BDGPG D INIT^BDGF,HDG
 ;. ;
 ;. ; loop thru display array
 ;. S BDGX=0 F  S BDGX=$O(^TMP("BDGICR2",$J,BDGX)) Q:'BDGX  D
 ;.. S BDGLN=^TMP("BDGICR2",$J,BDGX,0)
 ;.. I BDGLN="@@@@@" D HDG Q
 ;.. I $Y>(IOSL-4) D HDG
 ;.. W !,BDGLN
 ;cmi/anch/maw end orig lines 7/10/2007 patch 1007
 ;
