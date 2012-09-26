BGP2YF ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED SEX DXS
 ;
 ; This routine loads Taxonomy BGP PED SEX DXS
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
 ;;21,"302.0 ")
 ;;1
 ;;9002226,1695,.01)
 ;;BGP PED SEX DXS
 ;;9002226,1695,.02)
 ;;@
 ;;9002226,1695,.04)
 ;;@
 ;;9002226,1695,.06)
 ;;@
 ;;9002226,1695,.08)
 ;;0
 ;;9002226,1695,.09)
 ;;3120219
 ;;9002226,1695,.11)
 ;;@
 ;;9002226,1695,.12)
 ;;31
 ;;9002226,1695,.13)
 ;;1
 ;;9002226,1695,.14)
 ;;@
 ;;9002226,1695,.15)
 ;;80
 ;;9002226,1695,.16)
 ;;@
 ;;9002226,1695,.17)
 ;;@
 ;;9002226,1695,3101)
 ;;@
 ;;9002226.02101,"1695,302.0 ",.01)
 ;;302.0 
 ;;9002226.02101,"1695,302.0 ",.02)
 ;;302.9 
 ;
OTHER ; OTHER ROUTINES
 Q
