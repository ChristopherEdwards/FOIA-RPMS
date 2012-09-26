BGP21D ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 11, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;;BGP PCI CM PROCS
 ;
 ; This routine loads Taxonomy BGP PCI CM PROCS
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
 ;;21,"00.66 ")
 ;;1
 ;;21,"36.01 ")
 ;;2
 ;;21,"36.05 ")
 ;;3
 ;;21,"36.06 ")
 ;;4
 ;;9002226,1219,.01)
 ;;BGP PCI CM PROCS
 ;;9002226,1219,.02)
 ;;@
 ;;9002226,1219,.04)
 ;;@
 ;;9002226,1219,.06)
 ;;@
 ;;9002226,1219,.08)
 ;;0
 ;;9002226,1219,.09)
 ;;3111011
 ;;9002226,1219,.11)
 ;;@
 ;;9002226,1219,.12)
 ;;255
 ;;9002226,1219,.13)
 ;;1
 ;;9002226,1219,.14)
 ;;@
 ;;9002226,1219,.15)
 ;;80.1
 ;;9002226,1219,.16)
 ;;@
 ;;9002226,1219,.17)
 ;;@
 ;;9002226,1219,3101)
 ;;@
 ;;9002226.02101,"1219,00.66 ",.01)
 ;;00.66 
 ;;9002226.02101,"1219,00.66 ",.02)
 ;;00.66 
 ;;9002226.02101,"1219,36.01 ",.01)
 ;;36.01 
 ;;9002226.02101,"1219,36.01 ",.02)
 ;;36.02 
 ;;9002226.02101,"1219,36.05 ",.01)
 ;;36.05 
 ;;9002226.02101,"1219,36.05 ",.02)
 ;;36.05 
 ;;9002226.02101,"1219,36.06 ",.01)
 ;;36.06 
 ;;9002226.02101,"1219,36.06 ",.02)
 ;;36.07 
 ;
OTHER ; OTHER ROUTINES
 Q
