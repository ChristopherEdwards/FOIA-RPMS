BGP20E ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED GER DXS
 ;
 ; This routine loads Taxonomy BGP PED GER DXS
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
 ;;21,"530.81 ")
 ;;1
 ;;9002226,1616,.01)
 ;;BGP PED GER DXS
 ;;9002226,1616,.02)
 ;;@
 ;;9002226,1616,.04)
 ;;@
 ;;9002226,1616,.06)
 ;;@
 ;;9002226,1616,.08)
 ;;0
 ;;9002226,1616,.09)
 ;;3120219
 ;;9002226,1616,.11)
 ;;@
 ;;9002226,1616,.12)
 ;;31
 ;;9002226,1616,.13)
 ;;1
 ;;9002226,1616,.14)
 ;;@
 ;;9002226,1616,.15)
 ;;80
 ;;9002226,1616,.16)
 ;;@
 ;;9002226,1616,.17)
 ;;@
 ;;9002226,1616,3101)
 ;;@
 ;;9002226.02101,"1616,530.81 ",.01)
 ;;530.81 
 ;;9002226.02101,"1616,530.81 ",.02)
 ;;530.81 
 ;
OTHER ; OTHER ROUTINES
 Q
