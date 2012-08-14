BGP21B ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 11, 2011;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;;BGP CPT DTAP/DTP/TDAP
 ;
 ; This routine loads Taxonomy BGP CPT DTAP/DTP/TDAP
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
 ;;21,"90696 ")
 ;;1
 ;;21,"90700 ")
 ;;2
 ;;21,"90701 ")
 ;;3
 ;;21,"90711 ")
 ;;4
 ;;21,"90715 ")
 ;;5
 ;;21,"90720 ")
 ;;6
 ;;9002226,1419,.01)
 ;;BGP CPT DTAP/DTP/TDAP
 ;;9002226,1419,.02)
 ;;@
 ;;9002226,1419,.04)
 ;;@
 ;;9002226,1419,.06)
 ;;@
 ;;9002226,1419,.08)
 ;;0
 ;;9002226,1419,.09)
 ;;3111011
 ;;9002226,1419,.11)
 ;;@
 ;;9002226,1419,.12)
 ;;455
 ;;9002226,1419,.13)
 ;;1
 ;;9002226,1419,.14)
 ;;@
 ;;9002226,1419,.15)
 ;;81
 ;;9002226,1419,.16)
 ;;@
 ;;9002226,1419,.17)
 ;;@
 ;;9002226,1419,3101)
 ;;@
 ;;9002226.02101,"1419,90696 ",.01)
 ;;90696 
 ;;9002226.02101,"1419,90696 ",.02)
 ;;90698 
 ;;9002226.02101,"1419,90700 ",.01)
 ;;90700 
 ;;9002226.02101,"1419,90700 ",.02)
 ;;90700 
 ;;9002226.02101,"1419,90701 ",.01)
 ;;90701 
 ;;9002226.02101,"1419,90701 ",.02)
 ;;90701 
 ;;9002226.02101,"1419,90711 ",.01)
 ;;90711 
 ;;9002226.02101,"1419,90711 ",.02)
 ;;90711 
 ;;9002226.02101,"1419,90715 ",.01)
 ;;90715 
 ;;9002226.02101,"1419,90715 ",.02)
 ;;90715 
 ;;9002226.02101,"1419,90720 ",.01)
 ;;90720 
 ;;9002226.02101,"1419,90720 ",.02)
 ;;90723 
 ;
OTHER ; OTHER ROUTINES
 Q