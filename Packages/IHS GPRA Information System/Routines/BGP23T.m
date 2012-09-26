BGP23T ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED OEX DXS
 ;
 ; This routine loads Taxonomy BGP PED OEX DXS
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
 ;;21,"112.82 ")
 ;;1
 ;;21,"380.10 ")
 ;;2
 ;;9002226,1657,.01)
 ;;BGP PED OEX DXS
 ;;9002226,1657,.02)
 ;;@
 ;;9002226,1657,.04)
 ;;@
 ;;9002226,1657,.06)
 ;;@
 ;;9002226,1657,.08)
 ;;0
 ;;9002226,1657,.09)
 ;;3120219
 ;;9002226,1657,.11)
 ;;@
 ;;9002226,1657,.12)
 ;;31
 ;;9002226,1657,.13)
 ;;1
 ;;9002226,1657,.14)
 ;;@
 ;;9002226,1657,.15)
 ;;80
 ;;9002226,1657,.16)
 ;;@
 ;;9002226,1657,.17)
 ;;@
 ;;9002226,1657,3101)
 ;;@
 ;;9002226.02101,"1657,112.82 ",.01)
 ;;112.82 
 ;;9002226.02101,"1657,112.82 ",.02)
 ;;112.82 
 ;;9002226.02101,"1657,380.10 ",.01)
 ;;380.10 
 ;;9002226.02101,"1657,380.10 ",.02)
 ;;380.23 
 ;
OTHER ; OTHER ROUTINES
 Q
