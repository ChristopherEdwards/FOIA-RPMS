BGP26A ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP FLU IZ DX V04.8
 ;
 ; This routine loads Taxonomy BGP FLU IZ DX V04.8
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
 ;;21,"V04.8 ")
 ;;1
 ;;9002226,1513,.01)
 ;;BGP FLU IZ DX V04.8
 ;;9002226,1513,.02)
 ;;@
 ;;9002226,1513,.04)
 ;;@
 ;;9002226,1513,.06)
 ;;@
 ;;9002226,1513,.08)
 ;;0
 ;;9002226,1513,.09)
 ;;3120216
 ;;9002226,1513,.11)
 ;;@
 ;;9002226,1513,.12)
 ;;31
 ;;9002226,1513,.13)
 ;;1
 ;;9002226,1513,.14)
 ;;@
 ;;9002226,1513,.15)
 ;;80
 ;;9002226,1513,.16)
 ;;@
 ;;9002226,1513,.17)
 ;;@
 ;;9002226,1513,3101)
 ;;@
 ;;9002226.02101,"1513,V04.8 ",.01)
 ;;V04.8 
 ;;9002226.02101,"1513,V04.8 ",.02)
 ;;V04.8 
 ;
OTHER ; OTHER ROUTINES
 Q
