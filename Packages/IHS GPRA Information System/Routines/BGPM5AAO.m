BGPM5AAO ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON JUL 22, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;;BGPMU NON-ACUTE INPT CPT
 ;
 ; This routine loads Taxonomy BGPMU NON-ACUTE INPT CPT
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
 ;;21,"99304 ")
 ;;1
 ;;21,"99315 ")
 ;;2
 ;;21,"99318 ")
 ;;5
 ;;21,"99324 ")
 ;;3
 ;;21,"99334 ")
 ;;4
 ;;9002226,844,.01)
 ;;BGPMU NON-ACUTE INPT CPT
 ;;9002226,844,.02)
 ;;Non-Acute Inpt CPT
 ;;9002226,844,.04)
 ;;n
 ;;9002226,844,.06)
 ;;@
 ;;9002226,844,.08)
 ;;@
 ;;9002226,844,.09)
 ;;3110310
 ;;9002226,844,.11)
 ;;@
 ;;9002226,844,.12)
 ;;@
 ;;9002226,844,.13)
 ;;@
 ;;9002226,844,.14)
 ;;@
 ;;9002226,844,.15)
 ;;81
 ;;9002226,844,.16)
 ;;1
 ;;9002226,844,.17)
 ;;@
 ;;9002226,844,3101)
 ;;@
 ;;9002226.02101,"844,99304 ",.01)
 ;;99304
 ;;9002226.02101,"844,99304 ",.02)
 ;;99310
 ;;9002226.02101,"844,99315 ",.01)
 ;;99315
 ;;9002226.02101,"844,99315 ",.02)
 ;;99316
 ;;9002226.02101,"844,99318 ",.01)
 ;;99318
 ;;9002226.02101,"844,99318 ",.02)
 ;;99318
 ;;9002226.02101,"844,99324 ",.01)
 ;;99324
 ;;9002226.02101,"844,99324 ",.02)
 ;;99328
 ;;9002226.02101,"844,99334 ",.01)
 ;;99334
 ;;9002226.02101,"844,99334 ",.02)
 ;;99337
 ;
OTHER ; OTHER ROUTINES
 Q