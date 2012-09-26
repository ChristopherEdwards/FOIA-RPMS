BGP21F26 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,00440-7786-60 ",.01)
 ;;00440-7786-60
 ;;9002226.02101,"1195,00440-7786-60 ",.02)
 ;;00440-7786-60
 ;;9002226.02101,"1195,00440-7786-92 ",.01)
 ;;00440-7786-92
 ;;9002226.02101,"1195,00440-7786-92 ",.02)
 ;;00440-7786-92
 ;;9002226.02101,"1195,00440-7786-94 ",.01)
 ;;00440-7786-94
 ;;9002226.02101,"1195,00440-7786-94 ",.02)
 ;;00440-7786-94
 ;;9002226.02101,"1195,00440-8230-60 ",.01)
 ;;00440-8230-60
 ;;9002226.02101,"1195,00440-8230-60 ",.02)
 ;;00440-8230-60
 ;;9002226.02101,"1195,00440-8230-90 ",.01)
 ;;00440-8230-90
 ;;9002226.02101,"1195,00440-8230-90 ",.02)
 ;;00440-8230-90
 ;;9002226.02101,"1195,00440-8230-91 ",.01)
 ;;00440-8230-91
 ;;9002226.02101,"1195,00440-8230-91 ",.02)
 ;;00440-8230-91
 ;;9002226.02101,"1195,00440-8230-92 ",.01)
 ;;00440-8230-92
 ;;9002226.02101,"1195,00440-8230-92 ",.02)
 ;;00440-8230-92
 ;;9002226.02101,"1195,00440-8230-94 ",.01)
 ;;00440-8230-94
 ;;9002226.02101,"1195,00440-8230-94 ",.02)
 ;;00440-8230-94
 ;;9002226.02101,"1195,00440-8230-99 ",.01)
 ;;00440-8230-99
 ;;9002226.02101,"1195,00440-8230-99 ",.02)
 ;;00440-8230-99
 ;;9002226.02101,"1195,00440-8231-60 ",.01)
 ;;00440-8231-60
 ;;9002226.02101,"1195,00440-8231-60 ",.02)
 ;;00440-8231-60
 ;;9002226.02101,"1195,00440-8231-90 ",.01)
 ;;00440-8231-90
 ;;9002226.02101,"1195,00440-8231-90 ",.02)
 ;;00440-8231-90
 ;;9002226.02101,"1195,00440-8231-92 ",.01)
 ;;00440-8231-92
 ;;9002226.02101,"1195,00440-8231-92 ",.02)
 ;;00440-8231-92
 ;;9002226.02101,"1195,00440-8231-94 ",.01)
 ;;00440-8231-94
 ;;9002226.02101,"1195,00440-8231-94 ",.02)
 ;;00440-8231-94
 ;;9002226.02101,"1195,00440-8232-30 ",.01)
 ;;00440-8232-30
 ;;9002226.02101,"1195,00440-8232-30 ",.02)
 ;;00440-8232-30
 ;;9002226.02101,"1195,00440-8232-90 ",.01)
 ;;00440-8232-90
 ;;9002226.02101,"1195,00440-8232-90 ",.02)
 ;;00440-8232-90
 ;;9002226.02101,"1195,00440-8232-94 ",.01)
 ;;00440-8232-94
 ;;9002226.02101,"1195,00440-8232-94 ",.02)
 ;;00440-8232-94
 ;;9002226.02101,"1195,00440-8233-90 ",.01)
 ;;00440-8233-90
 ;;9002226.02101,"1195,00440-8233-90 ",.02)
 ;;00440-8233-90
 ;;9002226.02101,"1195,00440-8233-94 ",.01)
 ;;00440-8233-94
 ;;9002226.02101,"1195,00440-8233-94 ",.02)
 ;;00440-8233-94
 ;;9002226.02101,"1195,00440-8234-90 ",.01)
 ;;00440-8234-90
 ;;9002226.02101,"1195,00440-8234-90 ",.02)
 ;;00440-8234-90
 ;;9002226.02101,"1195,00440-8234-94 ",.01)
 ;;00440-8234-94
 ;;9002226.02101,"1195,00440-8234-94 ",.02)
 ;;00440-8234-94
 ;;9002226.02101,"1195,00456-1402-01 ",.01)
 ;;00456-1402-01
 ;;9002226.02101,"1195,00456-1402-01 ",.02)
 ;;00456-1402-01
 ;;9002226.02101,"1195,00456-1402-30 ",.01)
 ;;00456-1402-30
 ;;9002226.02101,"1195,00456-1402-30 ",.02)
 ;;00456-1402-30
 ;;9002226.02101,"1195,00456-1402-63 ",.01)
 ;;00456-1402-63
 ;;9002226.02101,"1195,00456-1402-63 ",.02)
 ;;00456-1402-63
 ;;9002226.02101,"1195,00456-1405-01 ",.01)
 ;;00456-1405-01
 ;;9002226.02101,"1195,00456-1405-01 ",.02)
 ;;00456-1405-01
 ;;9002226.02101,"1195,00456-1405-30 ",.01)
 ;;00456-1405-30
 ;;9002226.02101,"1195,00456-1405-30 ",.02)
 ;;00456-1405-30
 ;;9002226.02101,"1195,00456-1405-63 ",.01)
 ;;00456-1405-63
 ;;9002226.02101,"1195,00456-1405-63 ",.02)
 ;;00456-1405-63
 ;;9002226.02101,"1195,00456-1410-01 ",.01)
 ;;00456-1410-01
 ;;9002226.02101,"1195,00456-1410-01 ",.02)
 ;;00456-1410-01
 ;;9002226.02101,"1195,00456-1410-30 ",.01)
 ;;00456-1410-30
 ;;9002226.02101,"1195,00456-1410-30 ",.02)
 ;;00456-1410-30
 ;;9002226.02101,"1195,00456-1410-63 ",.01)
 ;;00456-1410-63
 ;;9002226.02101,"1195,00456-1410-63 ",.02)
 ;;00456-1410-63
 ;;9002226.02101,"1195,00456-1420-01 ",.01)
 ;;00456-1420-01
 ;;9002226.02101,"1195,00456-1420-01 ",.02)
 ;;00456-1420-01
 ;;9002226.02101,"1195,00456-1420-30 ",.01)
 ;;00456-1420-30
 ;;9002226.02101,"1195,00456-1420-30 ",.02)
 ;;00456-1420-30
 ;;9002226.02101,"1195,00490-0053-00 ",.01)
 ;;00490-0053-00
 ;;9002226.02101,"1195,00490-0053-00 ",.02)
 ;;00490-0053-00
 ;;9002226.02101,"1195,00490-0053-30 ",.01)
 ;;00490-0053-30
 ;;9002226.02101,"1195,00490-0053-30 ",.02)
 ;;00490-0053-30
 ;;9002226.02101,"1195,00490-0053-60 ",.01)
 ;;00490-0053-60
 ;;9002226.02101,"1195,00490-0053-60 ",.02)
 ;;00490-0053-60
 ;;9002226.02101,"1195,00490-0053-90 ",.01)
 ;;00490-0053-90
 ;;9002226.02101,"1195,00490-0053-90 ",.02)
 ;;00490-0053-90
 ;;9002226.02101,"1195,00591-0437-01 ",.01)
 ;;00591-0437-01
 ;;9002226.02101,"1195,00591-0437-01 ",.02)
 ;;00591-0437-01
 ;;9002226.02101,"1195,00591-0438-01 ",.01)
 ;;00591-0438-01
 ;;9002226.02101,"1195,00591-0438-01 ",.02)
 ;;00591-0438-01
 ;;9002226.02101,"1195,00591-0462-01 ",.01)
 ;;00591-0462-01
 ;;9002226.02101,"1195,00591-0462-01 ",.02)
 ;;00591-0462-01
 ;;9002226.02101,"1195,00591-0462-10 ",.01)
 ;;00591-0462-10
 ;;9002226.02101,"1195,00591-0462-10 ",.02)
 ;;00591-0462-10
 ;;9002226.02101,"1195,00591-0463-01 ",.01)
 ;;00591-0463-01
 ;;9002226.02101,"1195,00591-0463-01 ",.02)
 ;;00591-0463-01
 ;;9002226.02101,"1195,00591-0463-10 ",.01)
 ;;00591-0463-10
 ;;9002226.02101,"1195,00591-0463-10 ",.02)
 ;;00591-0463-10
 ;;9002226.02101,"1195,00591-0605-01 ",.01)
 ;;00591-0605-01
 ;;9002226.02101,"1195,00591-0605-01 ",.02)
 ;;00591-0605-01
 ;;9002226.02101,"1195,00591-0605-05 ",.01)
 ;;00591-0605-05
