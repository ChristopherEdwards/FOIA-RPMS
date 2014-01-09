BQIJTXW ;GDIT/HS/ALA-CREATED BY ^ATXSTX ON AUG 14, 2012;
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;;BQI HIV ID SPEC CONFIRM LOINC
 ;
 ; This routine loads Taxonomy BQI HIV ID SPEC CONFIRM LOINC
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
 ;;21,"13499-9 ")
 ;;1
 ;;21,"28052-9 ")
 ;;2
 ;;21,"43185-8 ")
 ;;3
 ;;9002226,1932,.01)
 ;;BQI HIV ID SPEC CONFIRM LOINC
 ;;9002226,1932,.02)
 ;;ID Specific Confirm LOINCs
 ;;9002226,1932,.04)
 ;;@
 ;;9002226,1932,.06)
 ;;@
 ;;9002226,1932,.08)
 ;;0
 ;;9002226,1932,.09)
 ;;3110926
 ;;9002226,1932,.11)
 ;;@
 ;;9002226,1932,.12)
 ;;@
 ;;9002226,1932,.13)
 ;;1
 ;;9002226,1932,.14)
 ;;FIHS
 ;;9002226,1932,.15)
 ;;95.3
 ;;9002226,1932,.16)
 ;;@
 ;;9002226,1932,.17)
 ;;@
 ;;9002226,1932,3101)
 ;;@
 ;;9002226.02101,"1932,13499-9 ",.01)
 ;;13499-9
 ;;9002226.02101,"1932,13499-9 ",.02)
 ;;13499-9
 ;;9002226.02101,"1932,28052-9 ",.01)
 ;;28052-9
 ;;9002226.02101,"1932,28052-9 ",.02)
 ;;28052-9
 ;;9002226.02101,"1932,43185-8 ",.01)
 ;;43185-8
 ;;9002226.02101,"1932,43185-8 ",.02)
 ;;43185-8
 ;
OTHER ; OTHER ROUTINES
 Q