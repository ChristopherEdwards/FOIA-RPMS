BGP2YB ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED SARS DXS
 ;
 ; This routine loads Taxonomy BGP PED SARS DXS
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
 ;;21,"079.82 ")
 ;;1
 ;;9002226,1691,.01)
 ;;BGP PED SARS DXS
 ;;9002226,1691,.02)
 ;;@
 ;;9002226,1691,.04)
 ;;@
 ;;9002226,1691,.06)
 ;;@
 ;;9002226,1691,.08)
 ;;0
 ;;9002226,1691,.09)
 ;;3120219
 ;;9002226,1691,.11)
 ;;@
 ;;9002226,1691,.12)
 ;;31
 ;;9002226,1691,.13)
 ;;1
 ;;9002226,1691,.14)
 ;;@
 ;;9002226,1691,.15)
 ;;80
 ;;9002226,1691,.16)
 ;;@
 ;;9002226,1691,.17)
 ;;@
 ;;9002226,1691,3101)
 ;;@
 ;;9002226.02101,"1691,079.82 ",.01)
 ;;079.82 
 ;;9002226.02101,"1691,079.82 ",.02)
 ;;079.82 
 ;
OTHER ; OTHER ROUTINES
 Q
