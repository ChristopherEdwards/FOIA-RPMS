BGP21W ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 16, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PCI CPTS
 ;
 ; This routine loads Taxonomy BGP PCI CPTS
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
 ;;21,"92980 ")
 ;;2
 ;;21,"92982 ")
 ;;3
 ;;21,"92995 ")
 ;;4
 ;;9002226,814,.01)
 ;;BGP PCI CPTS
 ;;9002226,814,.02)
 ;;@
 ;;9002226,814,.04)
 ;;@
 ;;9002226,814,.06)
 ;;@
 ;;9002226,814,.08)
 ;;0
 ;;9002226,814,.09)
 ;;3110503
 ;;9002226,814,.11)
 ;;@
 ;;9002226,814,.12)
 ;;455
 ;;9002226,814,.13)
 ;;1
 ;;9002226,814,.14)
 ;;@
 ;;9002226,814,.15)
 ;;81
 ;;9002226,814,.16)
 ;;@
 ;;9002226,814,.17)
 ;;@
 ;;9002226,814,3101)
 ;;@
 ;;9002226.02101,"814,92980 ",.01)
 ;;92980 
 ;;9002226.02101,"814,92980 ",.02)
 ;;92980 
 ;;9002226.02101,"814,92982 ",.01)
 ;;92982 
 ;;9002226.02101,"814,92982 ",.02)
 ;;92982 
 ;;9002226.02101,"814,92995 ",.01)
 ;;92995 
 ;;9002226.02101,"814,92995 ",.02)
 ;;92995 
 ;
OTHER ; OTHER ROUTINES
 Q
