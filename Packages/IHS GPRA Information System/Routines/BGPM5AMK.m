BGPM5AMK ;IHS/MSC/MMT-CREATED BY ^ATXSTX ON JUL 18, 2011;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 ;;BGPMU LAB LOINC MICROALBUMIN
 ;
 ; This routine loads Taxonomy BGPMU LAB LOINC MICROALBUMIN
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
 ;;21,"20454-5 ")
 ;;1
 ;;21,"50561-0 ")
 ;;2
 ;;21,"53525-2 ")
 ;;3
 ;;21,"5804-0 ")
 ;;4
 ;;9002226,853,.01)
 ;;BGPMU LAB LOINC MICROALBUMIN
 ;;9002226,853,.02)
 ;;Microalbumin LOINC
 ;;9002226,853,.04)
 ;;n
 ;;9002226,853,.06)
 ;;@
 ;;9002226,853,.08)
 ;;@
 ;;9002226,853,.09)
 ;;3110310
 ;;9002226,853,.11)
 ;;@
 ;;9002226,853,.12)
 ;;@
 ;;9002226,853,.13)
 ;;@
 ;;9002226,853,.14)
 ;;@
 ;;9002226,853,.15)
 ;;95.3
 ;;9002226,853,.16)
 ;;1
 ;;9002226,853,.17)
 ;;@
 ;;9002226,853,3101)
 ;;@
 ;;9002226.02101,"853,20454-5 ",.01)
 ;;20454-5
 ;;9002226.02101,"853,20454-5 ",.02)
 ;;20454-5
 ;;9002226.02101,"853,50561-0 ",.01)
 ;;50561-0
 ;;9002226.02101,"853,50561-0 ",.02)
 ;;50561-0
 ;;9002226.02101,"853,53525-2 ",.01)
 ;;53525-2
 ;;9002226.02101,"853,53525-2 ",.02)
 ;;53525-2
 ;;9002226.02101,"853,5804-0 ",.01)
 ;;5804-0
 ;;9002226.02101,"853,5804-0 ",.02)
 ;;5804-0
 ;
OTHER ; OTHER ROUTINES
 Q