BGP21J14 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1199,00440-7565-30 ",.01)
 ;;00440-7565-30
 ;;9002226.02101,"1199,00440-7565-30 ",.02)
 ;;00440-7565-30
 ;;9002226.02101,"1199,00440-7565-60 ",.01)
 ;;00440-7565-60
 ;;9002226.02101,"1199,00440-7565-60 ",.02)
 ;;00440-7565-60
 ;;9002226.02101,"1199,00440-7565-90 ",.01)
 ;;00440-7565-90
 ;;9002226.02101,"1199,00440-7565-90 ",.02)
 ;;00440-7565-90
 ;;9002226.02101,"1199,00440-7566-30 ",.01)
 ;;00440-7566-30
 ;;9002226.02101,"1199,00440-7566-30 ",.02)
 ;;00440-7566-30
 ;;9002226.02101,"1199,00440-7566-60 ",.01)
 ;;00440-7566-60
 ;;9002226.02101,"1199,00440-7566-60 ",.02)
 ;;00440-7566-60
 ;;9002226.02101,"1199,00440-7566-90 ",.01)
 ;;00440-7566-90
 ;;9002226.02101,"1199,00440-7566-90 ",.02)
 ;;00440-7566-90
 ;;9002226.02101,"1199,00440-7566-91 ",.01)
 ;;00440-7566-91
 ;;9002226.02101,"1199,00440-7566-91 ",.02)
 ;;00440-7566-91
 ;;9002226.02101,"1199,00440-7566-92 ",.01)
 ;;00440-7566-92
 ;;9002226.02101,"1199,00440-7566-92 ",.02)
 ;;00440-7566-92
 ;;9002226.02101,"1199,00440-7568-90 ",.01)
 ;;00440-7568-90
 ;;9002226.02101,"1199,00440-7568-90 ",.02)
 ;;00440-7568-90
 ;;9002226.02101,"1199,00440-7568-92 ",.01)
 ;;00440-7568-92
 ;;9002226.02101,"1199,00440-7568-92 ",.02)
 ;;00440-7568-92
 ;;9002226.02101,"1199,00440-7569-90 ",.01)
 ;;00440-7569-90
 ;;9002226.02101,"1199,00440-7569-90 ",.02)
 ;;00440-7569-90
 ;;9002226.02101,"1199,00440-7569-92 ",.01)
 ;;00440-7569-92
 ;;9002226.02101,"1199,00440-7569-92 ",.02)
 ;;00440-7569-92
 ;;9002226.02101,"1199,00440-7570-20 ",.01)
 ;;00440-7570-20
 ;;9002226.02101,"1199,00440-7570-20 ",.02)
 ;;00440-7570-20
 ;;9002226.02101,"1199,00440-7571-14 ",.01)
 ;;00440-7571-14
 ;;9002226.02101,"1199,00440-7571-14 ",.02)
 ;;00440-7571-14
 ;;9002226.02101,"1199,00440-7571-30 ",.01)
 ;;00440-7571-30
 ;;9002226.02101,"1199,00440-7571-30 ",.02)
 ;;00440-7571-30
 ;;9002226.02101,"1199,00440-7571-60 ",.01)
 ;;00440-7571-60
 ;;9002226.02101,"1199,00440-7571-60 ",.02)
 ;;00440-7571-60
 ;;9002226.02101,"1199,00440-7571-90 ",.01)
 ;;00440-7571-90
 ;;9002226.02101,"1199,00440-7571-90 ",.02)
 ;;00440-7571-90
 ;;9002226.02101,"1199,00440-7571-91 ",.01)
 ;;00440-7571-91
 ;;9002226.02101,"1199,00440-7571-91 ",.02)
 ;;00440-7571-91
 ;;9002226.02101,"1199,00440-7571-92 ",.01)
 ;;00440-7571-92
 ;;9002226.02101,"1199,00440-7571-92 ",.02)
 ;;00440-7571-92
 ;;9002226.02101,"1199,00440-7571-94 ",.01)
 ;;00440-7571-94
 ;;9002226.02101,"1199,00440-7571-94 ",.02)
 ;;00440-7571-94
 ;;9002226.02101,"1199,00440-7571-95 ",.01)
 ;;00440-7571-95
 ;;9002226.02101,"1199,00440-7571-95 ",.02)
 ;;00440-7571-95
 ;;9002226.02101,"1199,00440-7585-90 ",.01)
 ;;00440-7585-90
 ;;9002226.02101,"1199,00440-7585-90 ",.02)
 ;;00440-7585-90
 ;;9002226.02101,"1199,00440-7587-90 ",.01)
 ;;00440-7587-90
 ;;9002226.02101,"1199,00440-7587-90 ",.02)
 ;;00440-7587-90
 ;;9002226.02101,"1199,00440-7589-90 ",.01)
 ;;00440-7589-90
 ;;9002226.02101,"1199,00440-7589-90 ",.02)
 ;;00440-7589-90
 ;;9002226.02101,"1199,00440-8563-90 ",.01)
 ;;00440-8563-90
 ;;9002226.02101,"1199,00440-8563-90 ",.02)
 ;;00440-8563-90
 ;;9002226.02101,"1199,00555-0442-02 ",.01)
 ;;00555-0442-02
 ;;9002226.02101,"1199,00555-0442-02 ",.02)
 ;;00555-0442-02
 ;;9002226.02101,"1199,00555-0443-02 ",.01)
 ;;00555-0443-02
 ;;9002226.02101,"1199,00555-0443-02 ",.02)
 ;;00555-0443-02
 ;;9002226.02101,"1199,00555-0625-02 ",.01)
 ;;00555-0625-02
 ;;9002226.02101,"1199,00555-0625-02 ",.02)
 ;;00555-0625-02
 ;;9002226.02101,"1199,00555-0626-02 ",.01)
 ;;00555-0626-02
 ;;9002226.02101,"1199,00555-0626-02 ",.02)
 ;;00555-0626-02
 ;;9002226.02101,"1199,00555-0627-02 ",.01)
 ;;00555-0627-02
 ;;9002226.02101,"1199,00555-0627-02 ",.02)
 ;;00555-0627-02
 ;;9002226.02101,"1199,00591-0460-01 ",.01)
 ;;00591-0460-01
 ;;9002226.02101,"1199,00591-0460-01 ",.02)
 ;;00591-0460-01
 ;;9002226.02101,"1199,00591-0460-05 ",.01)
 ;;00591-0460-05
 ;;9002226.02101,"1199,00591-0460-05 ",.02)
 ;;00591-0460-05
 ;;9002226.02101,"1199,00591-0460-10 ",.01)
 ;;00591-0460-10
 ;;9002226.02101,"1199,00591-0460-10 ",.02)
 ;;00591-0460-10
 ;;9002226.02101,"1199,00591-0461-01 ",.01)
 ;;00591-0461-01
 ;;9002226.02101,"1199,00591-0461-01 ",.02)
 ;;00591-0461-01
 ;;9002226.02101,"1199,00591-0461-05 ",.01)
 ;;00591-0461-05
 ;;9002226.02101,"1199,00591-0461-05 ",.02)
 ;;00591-0461-05
 ;;9002226.02101,"1199,00591-0461-10 ",.01)
 ;;00591-0461-10
 ;;9002226.02101,"1199,00591-0461-10 ",.02)
 ;;00591-0461-10
 ;;9002226.02101,"1199,00591-0844-01 ",.01)
 ;;00591-0844-01
 ;;9002226.02101,"1199,00591-0844-01 ",.02)
 ;;00591-0844-01
 ;;9002226.02101,"1199,00591-0844-10 ",.01)
 ;;00591-0844-10
 ;;9002226.02101,"1199,00591-0844-10 ",.02)
 ;;00591-0844-10
 ;;9002226.02101,"1199,00591-0844-15 ",.01)
 ;;00591-0844-15
 ;;9002226.02101,"1199,00591-0844-15 ",.02)
 ;;00591-0844-15
 ;;9002226.02101,"1199,00591-0845-01 ",.01)
 ;;00591-0845-01
 ;;9002226.02101,"1199,00591-0845-01 ",.02)
 ;;00591-0845-01
 ;;9002226.02101,"1199,00591-0845-10 ",.01)
 ;;00591-0845-10
 ;;9002226.02101,"1199,00591-0845-10 ",.02)
 ;;00591-0845-10
 ;;9002226.02101,"1199,00591-0845-15 ",.01)
 ;;00591-0845-15
 ;;9002226.02101,"1199,00591-0845-15 ",.02)
 ;;00591-0845-15
 ;;9002226.02101,"1199,00591-0900-30 ",.01)
 ;;00591-0900-30