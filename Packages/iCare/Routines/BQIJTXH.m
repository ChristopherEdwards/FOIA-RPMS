BQIJTXH ;GDIT/HS/ALA-CREATED BY ^ATXSTX ON AUG 14, 2012;
 ;;2.3;ICARE MANAGEMENT SYSTEM;**1**;Apr 18, 2012;Build 43
 ;;BQI HEP B CORE TEST LOINC
 ;
 ; This routine loads Taxonomy BQI HEP B CORE TEST LOINC
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
 ;;21,"22319-8 ")
 ;;1
 ;;21,"24113-3 ")
 ;;2
 ;;21,"31204-1 ")
 ;;3
 ;;21,"5185-4 ")
 ;;4
 ;;21,"5186-2 ")
 ;;5
 ;;21,"51914-0 ")
 ;;6
 ;;9002226,1917,.01)
 ;;BQI HEP B CORE TEST LOINC
 ;;9002226,1917,.02)
 ;;HEP B core lab LOINCs
 ;;9002226,1917,.04)
 ;;@
 ;;9002226,1917,.06)
 ;;@
 ;;9002226,1917,.08)
 ;;0
 ;;9002226,1917,.09)
 ;;3110926
 ;;9002226,1917,.11)
 ;;@
 ;;9002226,1917,.12)
 ;;@
 ;;9002226,1917,.13)
 ;;1
 ;;9002226,1917,.14)
 ;;FIHS
 ;;9002226,1917,.15)
 ;;95.3
 ;;9002226,1917,.16)
 ;;@
 ;;9002226,1917,.17)
 ;;@
 ;;9002226,1917,3101)
 ;;@
 ;;9002226.02101,"1917,22319-8 ",.01)
 ;;22319-8
 ;;9002226.02101,"1917,22319-8 ",.02)
 ;;22319-8
 ;;9002226.02101,"1917,24113-3 ",.01)
 ;;24113-3
 ;;9002226.02101,"1917,24113-3 ",.02)
 ;;24113-3
 ;;9002226.02101,"1917,31204-1 ",.01)
 ;;31204-1
 ;;9002226.02101,"1917,31204-1 ",.02)
 ;;31204-1
 ;;9002226.02101,"1917,5185-4 ",.01)
 ;;5185-4
 ;;9002226.02101,"1917,5185-4 ",.02)
 ;;5185-4
 ;;9002226.02101,"1917,5186-2 ",.01)
 ;;5186-2
 ;;9002226.02101,"1917,5186-2 ",.02)
 ;;5186-2
 ;;9002226.02101,"1917,51914-0 ",.01)
 ;;51914-0
 ;;9002226.02101,"1917,51914-0 ",.02)
 ;;51914-0
 ;
OTHER ; OTHER ROUTINES
 Q