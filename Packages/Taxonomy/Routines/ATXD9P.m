ATXD9P ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 13, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;APCH EXAM 19 VISION
 ;
 ; This routine loads Taxonomy APCH EXAM 19 VISION
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
 ;;21,"V72.0 ")
 ;;1
 ;;21,"Z01.00 ")
 ;;2
 ;;21,"Z01.01 ")
 ;;3
 ;;9002226,1800,.01)
 ;;APCH EXAM 19 VISION
 ;;9002226,1800,.02)
 ;;@
 ;;9002226,1800,.04)
 ;;n
 ;;9002226,1800,.06)
 ;;@
 ;;9002226,1800,.08)
 ;;@
 ;;9002226,1800,.09)
 ;;3131113
 ;;9002226,1800,.11)
 ;;@
 ;;9002226,1800,.12)
 ;;31
 ;;9002226,1800,.13)
 ;;1
 ;;9002226,1800,.14)
 ;;@
 ;;9002226,1800,.15)
 ;;80
 ;;9002226,1800,.16)
 ;;@
 ;;9002226,1800,.17)
 ;;@
 ;;9002226,1800,3101)
 ;;@
 ;;9002226.02101,"1800,V72.0 ",.01)
 ;;V72.0 
 ;;9002226.02101,"1800,V72.0 ",.02)
 ;;V72.0 
 ;;9002226.02101,"1800,V72.0 ",.03)
 ;;1
 ;;9002226.02101,"1800,Z01.00 ",.01)
 ;;Z01.00 
 ;;9002226.02101,"1800,Z01.00 ",.02)
 ;;Z01.00 
 ;;9002226.02101,"1800,Z01.00 ",.03)
 ;;30
 ;;9002226.02101,"1800,Z01.01 ",.01)
 ;;Z01.01 
 ;;9002226.02101,"1800,Z01.01 ",.02)
 ;;Z01.01 
 ;;9002226.02101,"1800,Z01.01 ",.03)
 ;;30
 ;
OTHER ; OTHER ROUTINES
 Q