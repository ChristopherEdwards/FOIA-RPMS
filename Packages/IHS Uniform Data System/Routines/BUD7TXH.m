BUD7TXH ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON DEC 16, 2007 ;
 ;;6.0;IHS/RPMS UNIFORM DATA SYSTEM;;JAN 23, 2012;Build 25
 ;;BUD TABLE 6 LINE 16
 ;
 ; This routine loads Taxonomy BUD TABLE 6 LINE 16
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
 ;;21,"770.0 ")
 ;;1
 ;;21,"773.0 ")
 ;;2
 ;;21,"779.4 ")
 ;;3
 ;;9002226,609,.01)
 ;;BUD TABLE 6 LINE 16
 ;;9002226,609,.02)
 ;;@
 ;;9002226,609,.04)
 ;;n
 ;;9002226,609,.06)
 ;;@
 ;;9002226,609,.08)
 ;;0
 ;;9002226,609,.09)
 ;;3031006
 ;;9002226,609,.11)
 ;;@
 ;;9002226,609,.12)
 ;;31
 ;;9002226,609,.13)
 ;;1
 ;;9002226,609,.14)
 ;;@
 ;;9002226,609,.15)
 ;;80
 ;;9002226,609,.16)
 ;;@
 ;;9002226,609,.17)
 ;;@
 ;;9002226,609,3101)
 ;;@
 ;;9002226.02101,"609,770.0 ",.01)
 ;;770.0 
 ;;9002226.02101,"609,770.0 ",.02)
 ;;771.89 
 ;;9002226.02101,"609,773.0 ",.01)
 ;;773.0 
 ;;9002226.02101,"609,773.0 ",.02)
 ;;779.2 
 ;;9002226.02101,"609,779.4 ",.01)
 ;;779.4 
 ;;9002226.02101,"609,779.4 ",.02)
 ;;779.9 
 ;
OTHER ; OTHER ROUTINES
 Q