BGP21I22 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1198,54868-2894-00 ",.01)
 ;;54868-2894-00
 ;;9002226.02101,"1198,54868-2894-00 ",.02)
 ;;54868-2894-00
 ;;9002226.02101,"1198,54868-3545-00 ",.01)
 ;;54868-3545-00
 ;;9002226.02101,"1198,54868-3545-00 ",.02)
 ;;54868-3545-00
 ;;9002226.02101,"1198,54868-3545-01 ",.01)
 ;;54868-3545-01
 ;;9002226.02101,"1198,54868-3545-01 ",.02)
 ;;54868-3545-01
 ;;9002226.02101,"1198,54868-3545-02 ",.01)
 ;;54868-3545-02
 ;;9002226.02101,"1198,54868-3545-02 ",.02)
 ;;54868-3545-02
 ;;9002226.02101,"1198,54868-3545-03 ",.01)
 ;;54868-3545-03
 ;;9002226.02101,"1198,54868-3545-03 ",.02)
 ;;54868-3545-03
 ;;9002226.02101,"1198,54868-3546-00 ",.01)
 ;;54868-3546-00
 ;;9002226.02101,"1198,54868-3546-00 ",.02)
 ;;54868-3546-00
 ;;9002226.02101,"1198,54868-3546-01 ",.01)
 ;;54868-3546-01
 ;;9002226.02101,"1198,54868-3546-01 ",.02)
 ;;54868-3546-01
 ;;9002226.02101,"1198,54868-4160-00 ",.01)
 ;;54868-4160-00
 ;;9002226.02101,"1198,54868-4160-00 ",.02)
 ;;54868-4160-00
 ;;9002226.02101,"1198,54868-4160-01 ",.01)
 ;;54868-4160-01
 ;;9002226.02101,"1198,54868-4160-01 ",.02)
 ;;54868-4160-01
 ;;9002226.02101,"1198,54868-4529-00 ",.01)
 ;;54868-4529-00
 ;;9002226.02101,"1198,54868-4529-00 ",.02)
 ;;54868-4529-00
 ;;9002226.02101,"1198,54868-4529-01 ",.01)
 ;;54868-4529-01
 ;;9002226.02101,"1198,54868-4529-01 ",.02)
 ;;54868-4529-01
 ;;9002226.02101,"1198,54868-4529-02 ",.01)
 ;;54868-4529-02
 ;;9002226.02101,"1198,54868-4529-02 ",.02)
 ;;54868-4529-02
 ;;9002226.02101,"1198,54868-4529-03 ",.01)
 ;;54868-4529-03
 ;;9002226.02101,"1198,54868-4529-03 ",.02)
 ;;54868-4529-03
 ;;9002226.02101,"1198,54868-4561-00 ",.01)
 ;;54868-4561-00
 ;;9002226.02101,"1198,54868-4561-00 ",.02)
 ;;54868-4561-00
 ;;9002226.02101,"1198,54868-4561-01 ",.01)
 ;;54868-4561-01
 ;;9002226.02101,"1198,54868-4561-01 ",.02)
 ;;54868-4561-01
 ;;9002226.02101,"1198,54868-4561-02 ",.01)
 ;;54868-4561-02
 ;;9002226.02101,"1198,54868-4561-02 ",.02)
 ;;54868-4561-02
 ;;9002226.02101,"1198,54868-4561-03 ",.01)
 ;;54868-4561-03
 ;;9002226.02101,"1198,54868-4561-03 ",.02)
 ;;54868-4561-03
 ;;9002226.02101,"1198,54868-4561-04 ",.01)
 ;;54868-4561-04
 ;;9002226.02101,"1198,54868-4561-04 ",.02)
 ;;54868-4561-04
 ;;9002226.02101,"1198,54868-4564-00 ",.01)
 ;;54868-4564-00
 ;;9002226.02101,"1198,54868-4564-00 ",.02)
 ;;54868-4564-00
 ;;9002226.02101,"1198,54868-4564-01 ",.01)
 ;;54868-4564-01
 ;;9002226.02101,"1198,54868-4564-01 ",.02)
 ;;54868-4564-01
 ;;9002226.02101,"1198,54868-4564-02 ",.01)
 ;;54868-4564-02
 ;;9002226.02101,"1198,54868-4564-02 ",.02)
 ;;54868-4564-02
 ;;9002226.02101,"1198,54868-4564-03 ",.01)
 ;;54868-4564-03
 ;;9002226.02101,"1198,54868-4564-03 ",.02)
 ;;54868-4564-03
 ;;9002226.02101,"1198,54868-4564-04 ",.01)
 ;;54868-4564-04
 ;;9002226.02101,"1198,54868-4564-04 ",.02)
 ;;54868-4564-04
 ;;9002226.02101,"1198,54868-4564-05 ",.01)
 ;;54868-4564-05
 ;;9002226.02101,"1198,54868-4564-05 ",.02)
 ;;54868-4564-05
 ;;9002226.02101,"1198,54868-4566-00 ",.01)
 ;;54868-4566-00
 ;;9002226.02101,"1198,54868-4566-00 ",.02)
 ;;54868-4566-00
 ;;9002226.02101,"1198,54868-4566-01 ",.01)
 ;;54868-4566-01
 ;;9002226.02101,"1198,54868-4566-01 ",.02)
 ;;54868-4566-01
 ;;9002226.02101,"1198,54868-4566-02 ",.01)
 ;;54868-4566-02
 ;;9002226.02101,"1198,54868-4566-02 ",.02)
 ;;54868-4566-02
 ;;9002226.02101,"1198,54868-4566-03 ",.01)
 ;;54868-4566-03
 ;;9002226.02101,"1198,54868-4566-03 ",.02)
 ;;54868-4566-03
 ;;9002226.02101,"1198,54868-4566-04 ",.01)
 ;;54868-4566-04
 ;;9002226.02101,"1198,54868-4566-04 ",.02)
 ;;54868-4566-04
 ;;9002226.02101,"1198,54868-4569-00 ",.01)
 ;;54868-4569-00
 ;;9002226.02101,"1198,54868-4569-00 ",.02)
 ;;54868-4569-00
 ;;9002226.02101,"1198,54868-4569-01 ",.01)
 ;;54868-4569-01
 ;;9002226.02101,"1198,54868-4569-01 ",.02)
 ;;54868-4569-01
 ;;9002226.02101,"1198,54868-4569-02 ",.01)
 ;;54868-4569-02
 ;;9002226.02101,"1198,54868-4569-02 ",.02)
 ;;54868-4569-02
 ;;9002226.02101,"1198,54868-4609-00 ",.01)
 ;;54868-4609-00
 ;;9002226.02101,"1198,54868-4609-00 ",.02)
 ;;54868-4609-00
 ;;9002226.02101,"1198,54868-4609-01 ",.01)
 ;;54868-4609-01
 ;;9002226.02101,"1198,54868-4609-01 ",.02)
 ;;54868-4609-01
 ;;9002226.02101,"1198,54868-4906-00 ",.01)
 ;;54868-4906-00
 ;;9002226.02101,"1198,54868-4906-00 ",.02)
 ;;54868-4906-00
 ;;9002226.02101,"1198,54868-4965-00 ",.01)
 ;;54868-4965-00
 ;;9002226.02101,"1198,54868-4965-00 ",.02)
 ;;54868-4965-00
 ;;9002226.02101,"1198,54868-4965-01 ",.01)
 ;;54868-4965-01
 ;;9002226.02101,"1198,54868-4965-01 ",.02)
 ;;54868-4965-01
 ;;9002226.02101,"1198,54868-4965-02 ",.01)
 ;;54868-4965-02
 ;;9002226.02101,"1198,54868-4965-02 ",.02)
 ;;54868-4965-02
 ;;9002226.02101,"1198,54868-5148-00 ",.01)
 ;;54868-5148-00
 ;;9002226.02101,"1198,54868-5148-00 ",.02)
 ;;54868-5148-00
 ;;9002226.02101,"1198,54868-5148-01 ",.01)
 ;;54868-5148-01
 ;;9002226.02101,"1198,54868-5148-01 ",.02)
 ;;54868-5148-01
 ;;9002226.02101,"1198,54868-5148-02 ",.01)
 ;;54868-5148-02
 ;;9002226.02101,"1198,54868-5148-02 ",.02)
 ;;54868-5148-02
 ;;9002226.02101,"1198,54868-5148-03 ",.01)
 ;;54868-5148-03
 ;;9002226.02101,"1198,54868-5148-03 ",.02)
 ;;54868-5148-03
 ;;9002226.02101,"1198,54868-5148-04 ",.01)
 ;;54868-5148-04
