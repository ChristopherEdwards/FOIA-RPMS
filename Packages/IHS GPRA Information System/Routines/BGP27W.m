BGP27W ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 29, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED AOD DXS
 ;
 ; This routine loads Taxonomy BGP PED AOD DXS
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
 ;;21,"286.7 ")
 ;;1
 ;;21,"303.00 ")
 ;;2
 ;;9002226,1583,.01)
 ;;BGP PED AOD DXS
 ;;9002226,1583,.02)
 ;;@
 ;;9002226,1583,.04)
 ;;@
 ;;9002226,1583,.06)
 ;;@
 ;;9002226,1583,.08)
 ;;0
 ;;9002226,1583,.09)
 ;;3120329
 ;;9002226,1583,.11)
 ;;@
 ;;9002226,1583,.12)
 ;;31
 ;;9002226,1583,.13)
 ;;1
 ;;9002226,1583,.14)
 ;;@
 ;;9002226,1583,.15)
 ;;80
 ;;9002226,1583,.16)
 ;;@
 ;;9002226,1583,.17)
 ;;@
 ;;9002226,1583,3101)
 ;;@
 ;;9002226.02101,"1583,286.7 ",.01)
 ;;286.7 
 ;;9002226.02101,"1583,286.7 ",.02)
 ;;286.9 
 ;;9002226.02101,"1583,303.00 ",.01)
 ;;303.00 
 ;;9002226.02101,"1583,303.00 ",.02)
 ;;305.99 
 ;
OTHER ; OTHER ROUTINES
 Q
