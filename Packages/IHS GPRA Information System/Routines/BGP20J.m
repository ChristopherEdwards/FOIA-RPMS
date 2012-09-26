BGP20J ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED HA DXS
 ;
 ; This routine loads Taxonomy BGP PED HA DXS
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
 ;;21,"307.81 ")
 ;;1
 ;;21,"346.0 ")
 ;;2
 ;;21,"784.0 ")
 ;;3
 ;;9002226,1621,.01)
 ;;BGP PED HA DXS
 ;;9002226,1621,.02)
 ;;@
 ;;9002226,1621,.04)
 ;;@
 ;;9002226,1621,.06)
 ;;@
 ;;9002226,1621,.08)
 ;;0
 ;;9002226,1621,.09)
 ;;3120219
 ;;9002226,1621,.11)
 ;;@
 ;;9002226,1621,.12)
 ;;31
 ;;9002226,1621,.13)
 ;;1
 ;;9002226,1621,.14)
 ;;@
 ;;9002226,1621,.15)
 ;;80
 ;;9002226,1621,.16)
 ;;@
 ;;9002226,1621,.17)
 ;;@
 ;;9002226,1621,3101)
 ;;@
 ;;9002226.02101,"1621,307.81 ",.01)
 ;;307.81 
 ;;9002226.02101,"1621,307.81 ",.02)
 ;;307.81 
 ;;9002226.02101,"1621,346.0 ",.01)
 ;;346.0 
 ;;9002226.02101,"1621,346.0 ",.02)
 ;;346.91 
 ;;9002226.02101,"1621,784.0 ",.01)
 ;;784.0 
 ;;9002226.02101,"1621,784.0 ",.02)
 ;;784.0 
 ;
OTHER ; OTHER ROUTINES
 Q