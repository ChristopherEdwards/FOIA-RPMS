BGP2YW ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED TB DXS
 ;
 ; This routine loads Taxonomy BGP PED TB DXS
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
 ;;21,"010.00 ")
 ;;1
 ;;9002226,1712,.01)
 ;;BGP PED TB DXS
 ;;9002226,1712,.02)
 ;;@
 ;;9002226,1712,.04)
 ;;@
 ;;9002226,1712,.06)
 ;;@
 ;;9002226,1712,.08)
 ;;0
 ;;9002226,1712,.09)
 ;;3120219
 ;;9002226,1712,.11)
 ;;@
 ;;9002226,1712,.12)
 ;;31
 ;;9002226,1712,.13)
 ;;1
 ;;9002226,1712,.14)
 ;;@
 ;;9002226,1712,.15)
 ;;80
 ;;9002226,1712,.16)
 ;;@
 ;;9002226,1712,.17)
 ;;@
 ;;9002226,1712,3101)
 ;;@
 ;;9002226.02101,"1712,010.00 ",.01)
 ;;010.00 
 ;;9002226.02101,"1712,010.00 ",.02)
 ;;018.96 
 ;
OTHER ; OTHER ROUTINES
 Q
