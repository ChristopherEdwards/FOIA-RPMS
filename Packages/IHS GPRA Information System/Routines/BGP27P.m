BGP27P ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED ACNE DXS
 ;
 ; This routine loads Taxonomy BGP PED ACNE DXS
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
 ;;21,"695.3 ")
 ;;1
 ;;21,"706.0 ")
 ;;2
 ;;9002226,1550,.01)
 ;;BGP PED ACNE DXS
 ;;9002226,1550,.02)
 ;;@
 ;;9002226,1550,.04)
 ;;@
 ;;9002226,1550,.06)
 ;;@
 ;;9002226,1550,.08)
 ;;0
 ;;9002226,1550,.09)
 ;;3120217
 ;;9002226,1550,.11)
 ;;@
 ;;9002226,1550,.12)
 ;;31
 ;;9002226,1550,.13)
 ;;1
 ;;9002226,1550,.14)
 ;;@
 ;;9002226,1550,.15)
 ;;80
 ;;9002226,1550,.16)
 ;;@
 ;;9002226,1550,.17)
 ;;@
 ;;9002226,1550,3101)
 ;;@
 ;;9002226.02101,"1550,695.3 ",.01)
 ;;695.3 
 ;;9002226.02101,"1550,695.3 ",.02)
 ;;695.3 
 ;;9002226.02101,"1550,706.0 ",.01)
 ;;706.0 
 ;;9002226.02101,"1550,706.0 ",.02)
 ;;706.19 
 ;
OTHER ; OTHER ROUTINES
 Q
