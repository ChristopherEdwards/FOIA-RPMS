BGP21H26 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,00440-8609-30 ",.02)
 ;;00440-8609-30
 ;;9002226.02101,"1197,00440-8609-60 ",.01)
 ;;00440-8609-60
 ;;9002226.02101,"1197,00440-8609-60 ",.02)
 ;;00440-8609-60
 ;;9002226.02101,"1197,00440-8609-90 ",.01)
 ;;00440-8609-90
 ;;9002226.02101,"1197,00440-8609-90 ",.02)
 ;;00440-8609-90
 ;;9002226.02101,"1197,00440-8609-94 ",.01)
 ;;00440-8609-94
 ;;9002226.02101,"1197,00440-8609-94 ",.02)
 ;;00440-8609-94
 ;;9002226.02101,"1197,00440-8610-10 ",.01)
 ;;00440-8610-10
 ;;9002226.02101,"1197,00440-8610-10 ",.02)
 ;;00440-8610-10
 ;;9002226.02101,"1197,00440-8610-30 ",.01)
 ;;00440-8610-30
 ;;9002226.02101,"1197,00440-8610-30 ",.02)
 ;;00440-8610-30
 ;;9002226.02101,"1197,00440-8610-60 ",.01)
 ;;00440-8610-60
 ;;9002226.02101,"1197,00440-8610-60 ",.02)
 ;;00440-8610-60
 ;;9002226.02101,"1197,00440-8610-90 ",.01)
 ;;00440-8610-90
 ;;9002226.02101,"1197,00440-8610-90 ",.02)
 ;;00440-8610-90
 ;;9002226.02101,"1197,00440-8610-94 ",.01)
 ;;00440-8610-94
 ;;9002226.02101,"1197,00440-8610-94 ",.02)
 ;;00440-8610-94
 ;;9002226.02101,"1197,00456-2612-00 ",.01)
 ;;00456-2612-00
 ;;9002226.02101,"1197,00456-2612-00 ",.02)
 ;;00456-2612-00
 ;;9002226.02101,"1197,00456-2612-30 ",.01)
 ;;00456-2612-30
 ;;9002226.02101,"1197,00456-2612-30 ",.02)
 ;;00456-2612-30
 ;;9002226.02101,"1197,00456-2612-63 ",.01)
 ;;00456-2612-63
 ;;9002226.02101,"1197,00456-2612-63 ",.02)
 ;;00456-2612-63
 ;;9002226.02101,"1197,00456-2612-90 ",.01)
 ;;00456-2612-90
 ;;9002226.02101,"1197,00456-2612-90 ",.02)
 ;;00456-2612-90
 ;;9002226.02101,"1197,00456-2613-00 ",.01)
 ;;00456-2613-00
 ;;9002226.02101,"1197,00456-2613-00 ",.02)
 ;;00456-2613-00
 ;;9002226.02101,"1197,00456-2613-30 ",.01)
 ;;00456-2613-30
 ;;9002226.02101,"1197,00456-2613-30 ",.02)
 ;;00456-2613-30
 ;;9002226.02101,"1197,00456-2613-63 ",.01)
 ;;00456-2613-63
 ;;9002226.02101,"1197,00456-2613-63 ",.02)
 ;;00456-2613-63
 ;;9002226.02101,"1197,00456-2613-90 ",.01)
 ;;00456-2613-90
 ;;9002226.02101,"1197,00456-2613-90 ",.02)
 ;;00456-2613-90
 ;;9002226.02101,"1197,00456-2614-00 ",.01)
 ;;00456-2614-00
 ;;9002226.02101,"1197,00456-2614-00 ",.02)
 ;;00456-2614-00
 ;;9002226.02101,"1197,00456-2614-30 ",.01)
 ;;00456-2614-30
 ;;9002226.02101,"1197,00456-2614-30 ",.02)
 ;;00456-2614-30
 ;;9002226.02101,"1197,00456-2614-63 ",.01)
 ;;00456-2614-63
 ;;9002226.02101,"1197,00456-2614-63 ",.02)
 ;;00456-2614-63
 ;;9002226.02101,"1197,00456-2614-90 ",.01)
 ;;00456-2614-90
 ;;9002226.02101,"1197,00456-2614-90 ",.02)
 ;;00456-2614-90
 ;;9002226.02101,"1197,00456-2615-00 ",.01)
 ;;00456-2615-00
 ;;9002226.02101,"1197,00456-2615-00 ",.02)
 ;;00456-2615-00
 ;;9002226.02101,"1197,00456-2615-30 ",.01)
 ;;00456-2615-30
 ;;9002226.02101,"1197,00456-2615-30 ",.02)
 ;;00456-2615-30
 ;;9002226.02101,"1197,00456-2615-63 ",.01)
 ;;00456-2615-63
 ;;9002226.02101,"1197,00456-2615-63 ",.02)
 ;;00456-2615-63
 ;;9002226.02101,"1197,00456-2615-90 ",.01)
 ;;00456-2615-90
 ;;9002226.02101,"1197,00456-2615-90 ",.02)
 ;;00456-2615-90
 ;;9002226.02101,"1197,00456-2616-00 ",.01)
 ;;00456-2616-00
 ;;9002226.02101,"1197,00456-2616-00 ",.02)
 ;;00456-2616-00
 ;;9002226.02101,"1197,00456-2616-30 ",.01)
 ;;00456-2616-30
 ;;9002226.02101,"1197,00456-2616-30 ",.02)
 ;;00456-2616-30
 ;;9002226.02101,"1197,00456-2616-63 ",.01)
 ;;00456-2616-63
 ;;9002226.02101,"1197,00456-2616-63 ",.02)
 ;;00456-2616-63
 ;;9002226.02101,"1197,00456-2616-90 ",.01)
 ;;00456-2616-90
 ;;9002226.02101,"1197,00456-2616-90 ",.02)
 ;;00456-2616-90
 ;;9002226.02101,"1197,00456-2617-00 ",.01)
 ;;00456-2617-00
 ;;9002226.02101,"1197,00456-2617-00 ",.02)
 ;;00456-2617-00
 ;;9002226.02101,"1197,00456-2617-30 ",.01)
 ;;00456-2617-30
 ;;9002226.02101,"1197,00456-2617-30 ",.02)
 ;;00456-2617-30
 ;;9002226.02101,"1197,00456-2617-90 ",.01)
 ;;00456-2617-90
 ;;9002226.02101,"1197,00456-2617-90 ",.02)
 ;;00456-2617-90
 ;;9002226.02101,"1197,00490-0126-00 ",.01)
 ;;00490-0126-00
 ;;9002226.02101,"1197,00490-0126-00 ",.02)
 ;;00490-0126-00
 ;;9002226.02101,"1197,00490-0126-30 ",.01)
 ;;00490-0126-30
 ;;9002226.02101,"1197,00490-0126-30 ",.02)
 ;;00490-0126-30
 ;;9002226.02101,"1197,00490-0126-60 ",.01)
 ;;00490-0126-60
 ;;9002226.02101,"1197,00490-0126-60 ",.02)
 ;;00490-0126-60
 ;;9002226.02101,"1197,00490-0126-90 ",.01)
 ;;00490-0126-90
 ;;9002226.02101,"1197,00490-0126-90 ",.02)
 ;;00490-0126-90
 ;;9002226.02101,"1197,00555-1069-02 ",.01)
 ;;00555-1069-02
 ;;9002226.02101,"1197,00555-1069-02 ",.02)
 ;;00555-1069-02
 ;;9002226.02101,"1197,00555-1070-02 ",.01)
 ;;00555-1070-02
 ;;9002226.02101,"1197,00555-1070-02 ",.02)
 ;;00555-1070-02
 ;;9002226.02101,"1197,00591-0343-01 ",.01)
 ;;00591-0343-01
 ;;9002226.02101,"1197,00591-0343-01 ",.02)
 ;;00591-0343-01
 ;;9002226.02101,"1197,00591-0343-05 ",.01)
 ;;00591-0343-05
 ;;9002226.02101,"1197,00591-0343-05 ",.02)
 ;;00591-0343-05
 ;;9002226.02101,"1197,00591-0343-10 ",.01)
 ;;00591-0343-10
 ;;9002226.02101,"1197,00591-0343-10 ",.02)
 ;;00591-0343-10
 ;;9002226.02101,"1197,00591-0344-01 ",.01)
 ;;00591-0344-01
 ;;9002226.02101,"1197,00591-0344-01 ",.02)
 ;;00591-0344-01
 ;;9002226.02101,"1197,00591-0344-05 ",.01)
 ;;00591-0344-05
 ;;9002226.02101,"1197,00591-0344-05 ",.02)
 ;;00591-0344-05
