BDGICF ; IHS/ANMC/LJF - INCOMPLETE CHART FORMS ; 
 ;;5.3;PIMS;**1004**;MAY 28, 2004
 ;IHS/OIT/LJF 09/29/2005 PATCH 1004 Fixed prompt
 ;
REPORT ; -- choose which report to print
 NEW BDGRPT,BDGA,X,Y,BDGQUIT
 W !! F X=1:1:5 S BDGA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)
 ;S Y=$$READ^BDGF("NO^1:5","Choose Setup Option","","","",.BDGA)
 S Y=$$READ^BDGF("NO^1:5","Choose Form To Print","","","",.BDGA)  ;IHS/OIT/LJF 09/29/2005 PATCH 1004
 Q:'Y  I Y=5 S XQH="BDG IC FORMS" D EN^XQH G REPORT
 S BDGRPT=$P($T(RPT+Y),";;",3)
 D @BDGRPT D EN^XBVK("VALM")
 Q
 ;
RPT ;;
 ;;Discharge Outguides;;OUT^BDGICF;;
 ;;Deficiency Worksheets;;^BDGICF1;;
 ;;Incomplete Chart Summary;;^BDGICF2;;
 ;;Final A Sheet/Bill Prep Worksheet;;NOPAT^BDGCRB(1);;
 ;;On-line Help (Report Descriptions);;
 ;
 ;
OUT ;EP; call FM print template form discharge outguides
 NEW L,DIC,FLDS,BY,FR,TO
 S L=0,DIC="^DGPM(",(FLDS,BY)="[BDG DISCHARGE OUTGUIDE]"
 D EN1^DIP
 Q
