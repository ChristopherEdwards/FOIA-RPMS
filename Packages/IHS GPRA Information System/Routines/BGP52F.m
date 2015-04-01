BGP52F ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 04, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;;BGP PED RH DXS
 ;
 ; This routine loads Taxonomy BGP PED RH DXS
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
 ;;21,"251.2 ")
 ;;1
 ;;9002226,1931,.01)
 ;;BGP PED RH DXS
 ;;9002226,1931,.02)
 ;;@
 ;;9002226,1931,.04)
 ;;n
 ;;9002226,1931,.06)
 ;;@
 ;;9002226,1931,.08)
 ;;0
 ;;9002226,1931,.09)
 ;;3120219
 ;;9002226,1931,.11)
 ;;@
 ;;9002226,1931,.12)
 ;;31
 ;;9002226,1931,.13)
 ;;1
 ;;9002226,1931,.14)
 ;;@
 ;;9002226,1931,.15)
 ;;80
 ;;9002226,1931,.16)
 ;;@
 ;;9002226,1931,.17)
 ;;@
 ;;9002226,1931,3101)
 ;;@
 ;;9002226.02101,"1931,251.2 ",.01)
 ;;251.2 
 ;;9002226.02101,"1931,251.2 ",.02)
 ;;251.2 
 ;
OTHER ; OTHER ROUTINES
 Q