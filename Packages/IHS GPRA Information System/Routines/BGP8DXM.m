BGP8DXM ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON SEP 28, 2007 ;
 ;;8.0;IHS CLINICAL REPORTING;;MAR 12, 2008
 ;;;BGP6;;SEP 28, 2007
 ;;BGP CPT ABORTION
 ;
 ; This routine loads Taxonomy BGP CPT ABORTION
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
 ;;21,"59100 ")
 ;;1
 ;;21,"59120 ")
 ;;2
 ;;21,"59130 ")
 ;;3
 ;;21,"59136 ")
 ;;4
 ;;21,"59150 ")
 ;;5
 ;;21,"59840 ")
 ;;6
 ;;21,"S2260 ")
 ;;7
 ;;9002226,581,.01)
 ;;BGP CPT ABORTION
 ;;9002226,581,.02)
 ;;@
 ;;9002226,581,.04)
 ;;@
 ;;9002226,581,.06)
 ;;@
 ;;9002226,581,.08)
 ;;0
 ;;9002226,581,.09)
 ;;3070806
 ;;9002226,581,.11)
 ;;@
 ;;9002226,581,.12)
 ;;455
 ;;9002226,581,.13)
 ;;1
 ;;9002226,581,.14)
 ;;@
 ;;9002226,581,.15)
 ;;81
 ;;9002226,581,.16)
 ;;@
 ;;9002226,581,.17)
 ;;@
 ;;9002226,581,3101)
 ;;@
 ;;9002226.02101,"581,59100 ",.01)
 ;;59100 
 ;;9002226.02101,"581,59100 ",.02)
 ;;59100 
 ;;9002226.02101,"581,59120 ",.01)
 ;;59120 
 ;;9002226.02101,"581,59120 ",.02)
 ;;59120 
 ;;9002226.02101,"581,59130 ",.01)
 ;;59130 
 ;;9002226.02101,"581,59130 ",.02)
 ;;59130 
 ;;9002226.02101,"581,59136 ",.01)
 ;;59136 
 ;;9002226.02101,"581,59136 ",.02)
 ;;59136 
 ;;9002226.02101,"581,59150 ",.01)
 ;;59150 
 ;;9002226.02101,"581,59150 ",.02)
 ;;59151 
 ;;9002226.02101,"581,59840 ",.01)
 ;;59840 
 ;;9002226.02101,"581,59840 ",.02)
 ;;59857 
 ;;9002226.02101,"581,S2260 ",.01)
 ;;S2260 
 ;;9002226.02101,"581,S2260 ",.02)
 ;;S2267 
 ;
OTHER ; OTHER ROUTINES
 Q