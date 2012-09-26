BGP21I12 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1198,00378-7186-05 ",.01)
 ;;00378-7186-05
 ;;9002226.02101,"1198,00378-7186-05 ",.02)
 ;;00378-7186-05
 ;;9002226.02101,"1198,00378-7187-05 ",.01)
 ;;00378-7187-05
 ;;9002226.02101,"1198,00378-7187-05 ",.02)
 ;;00378-7187-05
 ;;9002226.02101,"1198,00406-2028-01 ",.01)
 ;;00406-2028-01
 ;;9002226.02101,"1198,00406-2028-01 ",.02)
 ;;00406-2028-01
 ;;9002226.02101,"1198,00406-2028-05 ",.01)
 ;;00406-2028-05
 ;;9002226.02101,"1198,00406-2028-05 ",.02)
 ;;00406-2028-05
 ;;9002226.02101,"1198,00406-2028-10 ",.01)
 ;;00406-2028-10
 ;;9002226.02101,"1198,00406-2028-10 ",.02)
 ;;00406-2028-10
 ;;9002226.02101,"1198,00406-2029-01 ",.01)
 ;;00406-2029-01
 ;;9002226.02101,"1198,00406-2029-01 ",.02)
 ;;00406-2029-01
 ;;9002226.02101,"1198,00406-2029-05 ",.01)
 ;;00406-2029-05
 ;;9002226.02101,"1198,00406-2029-05 ",.02)
 ;;00406-2029-05
 ;;9002226.02101,"1198,00406-2029-10 ",.01)
 ;;00406-2029-10
 ;;9002226.02101,"1198,00406-2029-10 ",.02)
 ;;00406-2029-10
 ;;9002226.02101,"1198,00406-2030-01 ",.01)
 ;;00406-2030-01
 ;;9002226.02101,"1198,00406-2030-01 ",.02)
 ;;00406-2030-01
 ;;9002226.02101,"1198,00406-2030-05 ",.01)
 ;;00406-2030-05
 ;;9002226.02101,"1198,00406-2030-05 ",.02)
 ;;00406-2030-05
 ;;9002226.02101,"1198,00406-2030-10 ",.01)
 ;;00406-2030-10
 ;;9002226.02101,"1198,00406-2030-10 ",.02)
 ;;00406-2030-10
 ;;9002226.02101,"1198,00440-7562-92 ",.01)
 ;;00440-7562-92
 ;;9002226.02101,"1198,00440-7562-92 ",.02)
 ;;00440-7562-92
 ;;9002226.02101,"1198,00440-7562-95 ",.01)
 ;;00440-7562-95
 ;;9002226.02101,"1198,00440-7562-95 ",.02)
 ;;00440-7562-95
 ;;9002226.02101,"1198,00440-7585-90 ",.01)
 ;;00440-7585-90
 ;;9002226.02101,"1198,00440-7585-90 ",.02)
 ;;00440-7585-90
 ;;9002226.02101,"1198,00440-7587-90 ",.01)
 ;;00440-7587-90
 ;;9002226.02101,"1198,00440-7587-90 ",.02)
 ;;00440-7587-90
 ;;9002226.02101,"1198,00440-7589-90 ",.01)
 ;;00440-7589-90
 ;;9002226.02101,"1198,00440-7589-90 ",.02)
 ;;00440-7589-90
 ;;9002226.02101,"1198,00440-7739-14 ",.01)
 ;;00440-7739-14
 ;;9002226.02101,"1198,00440-7739-14 ",.02)
 ;;00440-7739-14
 ;;9002226.02101,"1198,00440-7739-60 ",.01)
 ;;00440-7739-60
 ;;9002226.02101,"1198,00440-7739-60 ",.02)
 ;;00440-7739-60
 ;;9002226.02101,"1198,00440-7739-90 ",.01)
 ;;00440-7739-90
 ;;9002226.02101,"1198,00440-7739-90 ",.02)
 ;;00440-7739-90
 ;;9002226.02101,"1198,00440-7739-92 ",.01)
 ;;00440-7739-92
 ;;9002226.02101,"1198,00440-7739-92 ",.02)
 ;;00440-7739-92
 ;;9002226.02101,"1198,00440-7739-94 ",.01)
 ;;00440-7739-94
 ;;9002226.02101,"1198,00440-7739-94 ",.02)
 ;;00440-7739-94
 ;;9002226.02101,"1198,00440-7739-95 ",.01)
 ;;00440-7739-95
 ;;9002226.02101,"1198,00440-7739-95 ",.02)
 ;;00440-7739-95
 ;;9002226.02101,"1198,00440-7745-90 ",.01)
 ;;00440-7745-90
 ;;9002226.02101,"1198,00440-7745-90 ",.02)
 ;;00440-7745-90
 ;;9002226.02101,"1198,00440-7745-92 ",.01)
 ;;00440-7745-92
 ;;9002226.02101,"1198,00440-7745-92 ",.02)
 ;;00440-7745-92
 ;;9002226.02101,"1198,00440-7746-90 ",.01)
 ;;00440-7746-90
 ;;9002226.02101,"1198,00440-7746-90 ",.02)
 ;;00440-7746-90
 ;;9002226.02101,"1198,00440-7746-92 ",.01)
 ;;00440-7746-92
 ;;9002226.02101,"1198,00440-7746-92 ",.02)
 ;;00440-7746-92
 ;;9002226.02101,"1198,00440-7748-90 ",.01)
 ;;00440-7748-90
 ;;9002226.02101,"1198,00440-7748-90 ",.02)
 ;;00440-7748-90
 ;;9002226.02101,"1198,00440-7748-92 ",.01)
 ;;00440-7748-92
 ;;9002226.02101,"1198,00440-7748-92 ",.02)
 ;;00440-7748-92
 ;;9002226.02101,"1198,00440-7748-99 ",.01)
 ;;00440-7748-99
 ;;9002226.02101,"1198,00440-7748-99 ",.02)
 ;;00440-7748-99
 ;;9002226.02101,"1198,00555-0107-02 ",.01)
 ;;00555-0107-02
 ;;9002226.02101,"1198,00555-0107-02 ",.02)
 ;;00555-0107-02
 ;;9002226.02101,"1198,00555-0385-02 ",.01)
 ;;00555-0385-02
 ;;9002226.02101,"1198,00555-0385-02 ",.02)
 ;;00555-0385-02
 ;;9002226.02101,"1198,00555-0385-04 ",.01)
 ;;00555-0385-04
 ;;9002226.02101,"1198,00555-0385-04 ",.02)
 ;;00555-0385-04
 ;;9002226.02101,"1198,00555-0386-02 ",.01)
 ;;00555-0386-02
 ;;9002226.02101,"1198,00555-0386-02 ",.02)
 ;;00555-0386-02
 ;;9002226.02101,"1198,00555-0387-02 ",.01)
 ;;00555-0387-02
 ;;9002226.02101,"1198,00555-0387-02 ",.02)
 ;;00555-0387-02
 ;;9002226.02101,"1198,00555-0625-02 ",.01)
 ;;00555-0625-02
 ;;9002226.02101,"1198,00555-0625-02 ",.02)
 ;;00555-0625-02
 ;;9002226.02101,"1198,00555-0626-02 ",.01)
 ;;00555-0626-02
 ;;9002226.02101,"1198,00555-0626-02 ",.02)
 ;;00555-0626-02
 ;;9002226.02101,"1198,00555-0627-02 ",.01)
 ;;00555-0627-02
 ;;9002226.02101,"1198,00555-0627-02 ",.02)
 ;;00555-0627-02
 ;;9002226.02101,"1198,00591-2455-01 ",.01)
 ;;00591-2455-01
 ;;9002226.02101,"1198,00591-2455-01 ",.02)
 ;;00591-2455-01
 ;;9002226.02101,"1198,00591-2455-05 ",.01)
 ;;00591-2455-05
 ;;9002226.02101,"1198,00591-2455-05 ",.02)
 ;;00591-2455-05
 ;;9002226.02101,"1198,00591-2713-01 ",.01)
 ;;00591-2713-01
 ;;9002226.02101,"1198,00591-2713-01 ",.02)
 ;;00591-2713-01
 ;;9002226.02101,"1198,00591-2713-05 ",.01)
 ;;00591-2713-05
 ;;9002226.02101,"1198,00591-2713-05 ",.02)
 ;;00591-2713-05
 ;;9002226.02101,"1198,00591-2775-01 ",.01)
 ;;00591-2775-01
 ;;9002226.02101,"1198,00591-2775-01 ",.02)
 ;;00591-2775-01
 ;;9002226.02101,"1198,00591-2775-25 ",.01)
 ;;00591-2775-25
