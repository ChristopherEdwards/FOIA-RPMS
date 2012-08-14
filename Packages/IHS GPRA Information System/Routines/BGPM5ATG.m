BGPM5ATG ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON AUG 29, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;;BGPMU LAB LOINC STREP TEST
 ;
 ; This routine loads Taxonomy BGPMU LAB LOINC STREP TEST
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
 ;;21,"11268-0 ")
 ;;6
 ;;21,"17656-0 ")
 ;;7
 ;;21,"18481-2 ")
 ;;8
 ;;21,"31971-5 ")
 ;;9
 ;;21,"49610-9 ")
 ;;10
 ;;21,"5036-9 ")
 ;;2
 ;;21,"626-2 ")
 ;;1
 ;;21,"6556-5 ")
 ;;3
 ;;21,"6558-1 ")
 ;;4
 ;;21,"6559-9 ")
 ;;11
 ;;9002226,1031,.01)
 ;;BGPMU LAB LOINC STREP TEST
 ;;9002226,1031,.02)
 ;;Strep throat Loinc tests
 ;;9002226,1031,.04)
 ;;n
 ;;9002226,1031,.06)
 ;;@
 ;;9002226,1031,.08)
 ;;@
 ;;9002226,1031,.09)
 ;;3110829
 ;;9002226,1031,.11)
 ;;@
 ;;9002226,1031,.12)
 ;;@
 ;;9002226,1031,.13)
 ;;@
 ;;9002226,1031,.14)
 ;;@
 ;;9002226,1031,.15)
 ;;95.3
 ;;9002226,1031,.16)
 ;;@
 ;;9002226,1031,.17)
 ;;@
 ;;9002226,1031,3101)
 ;;@
 ;;9002226.02101,"1031,11268-0 ",.01)
 ;;11268-0
 ;;9002226.02101,"1031,11268-0 ",.02)
 ;;11268-0
 ;;9002226.02101,"1031,17656-0 ",.01)
 ;;17656-0
 ;;9002226.02101,"1031,17656-0 ",.02)
 ;;17656-0
 ;;9002226.02101,"1031,18481-2 ",.01)
 ;;18481-2
 ;;9002226.02101,"1031,18481-2 ",.02)
 ;;18481-2
 ;;9002226.02101,"1031,31971-5 ",.01)
 ;;31971-5
 ;;9002226.02101,"1031,31971-5 ",.02)
 ;;31971-5
 ;;9002226.02101,"1031,49610-9 ",.01)
 ;;49610-9
 ;;9002226.02101,"1031,49610-9 ",.02)
 ;;49610-9
 ;;9002226.02101,"1031,5036-9 ",.01)
 ;;5036-9
 ;;9002226.02101,"1031,5036-9 ",.02)
 ;;5036-9
 ;;9002226.02101,"1031,626-2 ",.01)
 ;;626-2
 ;;9002226.02101,"1031,626-2 ",.02)
 ;;626-2
 ;;9002226.02101,"1031,6556-5 ",.01)
 ;;6556-5
 ;;9002226.02101,"1031,6556-5 ",.02)
 ;;6556-5
 ;;9002226.02101,"1031,6558-1 ",.01)
 ;;6558-1
 ;;9002226.02101,"1031,6558-1 ",.02)
 ;;6558-1
 ;;9002226.02101,"1031,6559-9 ",.01)
 ;;6559-9
 ;;9002226.02101,"1031,6559-9 ",.02)
 ;;6559-9
 ;
OTHER ; OTHER ROUTINES
 Q