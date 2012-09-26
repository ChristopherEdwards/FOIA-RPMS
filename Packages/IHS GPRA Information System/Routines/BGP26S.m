BGP26S ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP HYPERTENSION SCREEN DXS
 ;
 ; This routine loads Taxonomy BGP HYPERTENSION SCREEN DXS
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 D OTHER
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"V81.1 ")
 ;;1
 ;;9002226,1530,.01)
 ;;BGP HYPERTENSION SCREEN DXS
 ;;9002226,1530,.02)
 ;;@
 ;;9002226,1530,.04)
 ;;@
 ;;9002226,1530,.06)
 ;;@
 ;;9002226,1530,.08)
 ;;0
 ;;9002226,1530,.09)
 ;;3120216
 ;;9002226,1530,.11)
 ;;@
 ;;9002226,1530,.12)
 ;;31
 ;;9002226,1530,.13)
 ;;1
 ;;9002226,1530,.14)
 ;;@
 ;;9002226,1530,.15)
 ;;80
 ;;9002226,1530,.16)
 ;;@
 ;;9002226,1530,.17)
 ;;@
 ;;9002226,1530,3101)
 ;;@
 ;;9002226.02101,"1530,V81.1 ",.01)
 ;;V81.1 
 ;;9002226.02101,"1530,V81.1 ",.02)
 ;;V81.1 
 ;
OTHER ; OTHER ROUTINES
 Q
