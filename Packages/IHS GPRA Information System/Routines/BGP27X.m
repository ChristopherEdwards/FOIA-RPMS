BGP27X ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 19, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PED ASM DXS
 ;
 ; This routine loads Taxonomy BGP PED ASM DXS
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
 ;;21,"493.00 ")
 ;;1
 ;;9002226,1558,.01)
 ;;BGP PED ASM DXS
 ;;9002226,1558,.02)
 ;;@
 ;;9002226,1558,.04)
 ;;@
 ;;9002226,1558,.06)
 ;;@
 ;;9002226,1558,.08)
 ;;0
 ;;9002226,1558,.09)
 ;;3120218
 ;;9002226,1558,.11)
 ;;@
 ;;9002226,1558,.12)
 ;;31
 ;;9002226,1558,.13)
 ;;1
 ;;9002226,1558,.14)
 ;;@
 ;;9002226,1558,.15)
 ;;80
 ;;9002226,1558,.16)
 ;;@
 ;;9002226,1558,.17)
 ;;@
 ;;9002226,1558,3101)
 ;;@
 ;;9002226.02101,"1558,493.00 ",.01)
 ;;493.00 
 ;;9002226.02101,"1558,493.00 ",.02)
 ;;493.92 
 ;
OTHER ; OTHER ROUTINES
 Q
