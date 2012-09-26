BGP2WY ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 28, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PAP LOINC CODES
 ;
 ; This routine loads Taxonomy BGP PAP LOINC CODES
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
 ;;21,"10524-7 ")
 ;;1
 ;;21,"18500-9 ")
 ;;2
 ;;21,"19762-4 ")
 ;;3
 ;;21,"19763-2 ")
 ;;4
 ;;21,"19764-0 ")
 ;;5
 ;;21,"19765-7 ")
 ;;6
 ;;21,"19766-5 ")
 ;;7
 ;;21,"19767-3 ")
 ;;8
 ;;21,"19768-1 ")
 ;;9
 ;;21,"19769-9 ")
 ;;10
 ;;21,"19770-7 ")
 ;;11
 ;;21,"19771-5 ")
 ;;12
 ;;21,"19772-3 ")
 ;;13
 ;;21,"19773-1 ")
 ;;14
 ;;21,"19774-9 ")
 ;;15
 ;;21,"33717-0 ")
 ;;16
 ;;21,"47527-7 ")
 ;;17
 ;;21,"47528-5 ")
 ;;18
 ;;21,"49034-2 ")
 ;;19
 ;;9002226,338,.01)
 ;;BGP PAP LOINC CODES
 ;;9002226,338,.02)
 ;;@
 ;;9002226,338,.04)
 ;;n
 ;;9002226,338,.06)
 ;;@
 ;;9002226,338,.08)
 ;;@
 ;;9002226,338,.09)
 ;;@
 ;;9002226,338,.11)
 ;;@
 ;;9002226,338,.12)
 ;;@
 ;;9002226,338,.13)
 ;;1
 ;;9002226,338,.14)
 ;;FIHS
 ;;9002226,338,.15)
 ;;95.3
 ;;9002226,338,.16)
 ;;@
 ;;9002226,338,.17)
 ;;@
 ;;9002226,338,3101)
 ;;@
 ;;9002226.02101,"338,10524-7 ",.01)
 ;;10524-7
 ;;9002226.02101,"338,10524-7 ",.02)
 ;;10524-7
 ;;9002226.02101,"338,18500-9 ",.01)
 ;;18500-9
 ;;9002226.02101,"338,18500-9 ",.02)
 ;;18500-9
 ;;9002226.02101,"338,19762-4 ",.01)
 ;;19762-4
 ;;9002226.02101,"338,19762-4 ",.02)
 ;;19762-4
 ;;9002226.02101,"338,19763-2 ",.01)
 ;;19763-2
 ;;9002226.02101,"338,19763-2 ",.02)
 ;;19763-2
 ;;9002226.02101,"338,19764-0 ",.01)
 ;;19764-0
 ;;9002226.02101,"338,19764-0 ",.02)
 ;;19764-0
 ;;9002226.02101,"338,19765-7 ",.01)
 ;;19765-7
 ;;9002226.02101,"338,19765-7 ",.02)
 ;;19765-7
 ;;9002226.02101,"338,19766-5 ",.01)
 ;;19766-5
 ;;9002226.02101,"338,19766-5 ",.02)
 ;;19766-5
 ;;9002226.02101,"338,19767-3 ",.01)
 ;;19767-3
 ;;9002226.02101,"338,19767-3 ",.02)
 ;;19767-3
 ;;9002226.02101,"338,19768-1 ",.01)
 ;;19768-1
 ;;9002226.02101,"338,19768-1 ",.02)
 ;;19768-1
 ;;9002226.02101,"338,19769-9 ",.01)
 ;;19769-9
 ;;9002226.02101,"338,19769-9 ",.02)
 ;;19769-9
 ;;9002226.02101,"338,19770-7 ",.01)
 ;;19770-7
 ;;9002226.02101,"338,19770-7 ",.02)
 ;;19770-7
 ;;9002226.02101,"338,19771-5 ",.01)
 ;;19771-5
 ;;9002226.02101,"338,19771-5 ",.02)
 ;;19771-5
 ;;9002226.02101,"338,19772-3 ",.01)
 ;;19772-3
 ;;9002226.02101,"338,19772-3 ",.02)
 ;;19772-3
 ;;9002226.02101,"338,19773-1 ",.01)
 ;;19773-1
 ;;9002226.02101,"338,19773-1 ",.02)
 ;;19773-1
 ;;9002226.02101,"338,19774-9 ",.01)
 ;;19774-9
 ;;9002226.02101,"338,19774-9 ",.02)
 ;;19774-9
 ;;9002226.02101,"338,33717-0 ",.01)
 ;;33717-0
 ;;9002226.02101,"338,33717-0 ",.02)
 ;;33717-0
 ;;9002226.02101,"338,47527-7 ",.01)
 ;;47527-7
 ;;9002226.02101,"338,47527-7 ",.02)
 ;;47527-7
 ;;9002226.02101,"338,47528-5 ",.01)
 ;;47528-5
 ;;9002226.02101,"338,47528-5 ",.02)
 ;;47528-5
 ;;9002226.02101,"338,49034-2 ",.01)
 ;;49034-2
 ;;9002226.02101,"338,49034-2 ",.02)
 ;;49034-2
 ;
OTHER ; OTHER ROUTINES
 Q
