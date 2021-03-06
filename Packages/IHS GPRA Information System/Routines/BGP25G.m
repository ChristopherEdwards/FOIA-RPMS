BGP25G ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP ADV EFF SALICYLATES
 ;
 ; This routine loads Taxonomy BGP ADV EFF SALICYLATES
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
 ;;21,"E935.3 ")
 ;;1
 ;;9002226,1497,.01)
 ;;BGP ADV EFF SALICYLATES
 ;;9002226,1497,.02)
 ;;@
 ;;9002226,1497,.04)
 ;;@
 ;;9002226,1497,.06)
 ;;@
 ;;9002226,1497,.08)
 ;;0
 ;;9002226,1497,.09)
 ;;3120216
 ;;9002226,1497,.11)
 ;;@
 ;;9002226,1497,.12)
 ;;157
 ;;9002226,1497,.13)
 ;;1
 ;;9002226,1497,.14)
 ;;@
 ;;9002226,1497,.15)
 ;;80
 ;;9002226,1497,.16)
 ;;@
 ;;9002226,1497,.17)
 ;;@
 ;;9002226,1497,3101)
 ;;@
 ;;9002226.02101,"1497,E935.3 ",.01)
 ;;E935.3 
 ;;9002226.02101,"1497,E935.3 ",.02)
 ;;E935.3 
 ;
OTHER ; OTHER ROUTINES
 Q
