BGP9OXQ ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON MAR 25, 2009 ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;;BGP PRE DM MET SYN DX
 ;
 ; This routine loads Taxonomy BGP PRE DM MET SYN DX
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
 ;;21,"277.7 ")
 ;;1
 ;;9002226,778,.01)
 ;;BGP PRE DM MET SYN DX
 ;;9002226,778,.02)
 ;;BGP PRE DM MET SYN DX
 ;;9002226,778,.04)
 ;;n
 ;;9002226,778,.06)
 ;;@
 ;;9002226,778,.08)
 ;;0
 ;;9002226,778,.09)
 ;;3060526
 ;;9002226,778,.11)
 ;;@
 ;;9002226,778,.12)
 ;;31
 ;;9002226,778,.13)
 ;;1
 ;;9002226,778,.14)
 ;;@
 ;;9002226,778,.15)
 ;;80
 ;;9002226,778,.16)
 ;;@
 ;;9002226,778,.17)
 ;;@
 ;;9002226,778,3101)
 ;;@
 ;;9002226.02101,"778,277.7 ",.01)
 ;;277.7
 ;;9002226.02101,"778,277.7 ",.02)
 ;;277.7
 ;
OTHER ; OTHER ROUTINES
 Q