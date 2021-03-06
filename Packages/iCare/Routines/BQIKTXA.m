BQIKTXA ;GDIT/HS/ALA-CREATED BY ^ATXSTX ON AUG 14, 2012;
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;;BQI HIV QUAL NUC ACID LOINC
 ;
 ; This routine loads Taxonomy BQI HIV QUAL NUC ACID LOINC
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
 ;;21,"25835-0 ")
 ;;1
 ;;21,"25841-8 ")
 ;;2
 ;;21,"25842-6 ")
 ;;3
 ;;21,"30245-5 ")
 ;;4
 ;;21,"34699-9 ")
 ;;5
 ;;21,"38998-1 ")
 ;;6
 ;;21,"42917-5 ")
 ;;7
 ;;21,"44871-2 ")
 ;;8
 ;;21,"47359-5 ")
 ;;9
 ;;21,"48023-6 ")
 ;;10
 ;;21,"5017-9 ")
 ;;11
 ;;21,"5018-7 ")
 ;;12
 ;;21,"9836-8 ")
 ;;13
 ;;21,"9837-6 ")
 ;;14
 ;;9002226,1933,.01)
 ;;BQI HIV QUAL NUC ACID LOINC
 ;;9002226,1933,.02)
 ;;Qualitative Nucleic Acid
 ;;9002226,1933,.04)
 ;;@
 ;;9002226,1933,.06)
 ;;@
 ;;9002226,1933,.08)
 ;;0
 ;;9002226,1933,.09)
 ;;3110926
 ;;9002226,1933,.11)
 ;;@
 ;;9002226,1933,.12)
 ;;@
 ;;9002226,1933,.13)
 ;;1
 ;;9002226,1933,.14)
 ;;FIHS
 ;;9002226,1933,.15)
 ;;95.3
 ;;9002226,1933,.16)
 ;;@
 ;;9002226,1933,.17)
 ;;@
 ;;9002226,1933,3101)
 ;;@
 ;;9002226.02101,"1933,25835-0 ",.01)
 ;;25835-0
 ;;9002226.02101,"1933,25835-0 ",.02)
 ;;25835-0
 ;;9002226.02101,"1933,25841-8 ",.01)
 ;;25841-8
 ;;9002226.02101,"1933,25841-8 ",.02)
 ;;25841-8
 ;;9002226.02101,"1933,25842-6 ",.01)
 ;;25842-6
 ;;9002226.02101,"1933,25842-6 ",.02)
 ;;25842-6
 ;;9002226.02101,"1933,30245-5 ",.01)
 ;;30245-5
 ;;9002226.02101,"1933,30245-5 ",.02)
 ;;30245-5
 ;;9002226.02101,"1933,34699-9 ",.01)
 ;;34699-9
 ;;9002226.02101,"1933,34699-9 ",.02)
 ;;34699-9
 ;;9002226.02101,"1933,38998-1 ",.01)
 ;;38998-1
 ;;9002226.02101,"1933,38998-1 ",.02)
 ;;38998-1
 ;;9002226.02101,"1933,42917-5 ",.01)
 ;;42917-5
 ;;9002226.02101,"1933,42917-5 ",.02)
 ;;42917-5
 ;;9002226.02101,"1933,44871-2 ",.01)
 ;;44871-2
 ;;9002226.02101,"1933,44871-2 ",.02)
 ;;44871-2
 ;;9002226.02101,"1933,47359-5 ",.01)
 ;;47359-5
 ;;9002226.02101,"1933,47359-5 ",.02)
 ;;47359-5
 ;;9002226.02101,"1933,48023-6 ",.01)
 ;;48023-6
 ;;9002226.02101,"1933,48023-6 ",.02)
 ;;48023-6
 ;;9002226.02101,"1933,5017-9 ",.01)
 ;;5017-9
 ;;9002226.02101,"1933,5017-9 ",.02)
 ;;5017-9
 ;;9002226.02101,"1933,5018-7 ",.01)
 ;;5018-7
 ;;9002226.02101,"1933,5018-7 ",.02)
 ;;5018-7
 ;;9002226.02101,"1933,9836-8 ",.01)
 ;;9836-8
 ;;9002226.02101,"1933,9836-8 ",.02)
 ;;9836-8
 ;;9002226.02101,"1933,9837-6 ",.01)
 ;;9837-6
 ;;9002226.02101,"1933,9837-6 ",.02)
 ;;9837-6
 ;
OTHER ; OTHER ROUTINES
 Q
