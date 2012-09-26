BGP21J24 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1199,54868-3335-00 ",.01)
 ;;54868-3335-00
 ;;9002226.02101,"1199,54868-3335-00 ",.02)
 ;;54868-3335-00
 ;;9002226.02101,"1199,54868-3335-01 ",.01)
 ;;54868-3335-01
 ;;9002226.02101,"1199,54868-3335-01 ",.02)
 ;;54868-3335-01
 ;;9002226.02101,"1199,54868-3335-02 ",.01)
 ;;54868-3335-02
 ;;9002226.02101,"1199,54868-3335-02 ",.02)
 ;;54868-3335-02
 ;;9002226.02101,"1199,54868-3335-03 ",.01)
 ;;54868-3335-03
 ;;9002226.02101,"1199,54868-3335-03 ",.02)
 ;;54868-3335-03
 ;;9002226.02101,"1199,54868-3377-00 ",.01)
 ;;54868-3377-00
 ;;9002226.02101,"1199,54868-3377-00 ",.02)
 ;;54868-3377-00
 ;;9002226.02101,"1199,54868-3377-01 ",.01)
 ;;54868-3377-01
 ;;9002226.02101,"1199,54868-3377-01 ",.02)
 ;;54868-3377-01
 ;;9002226.02101,"1199,54868-3377-02 ",.01)
 ;;54868-3377-02
 ;;9002226.02101,"1199,54868-3377-02 ",.02)
 ;;54868-3377-02
 ;;9002226.02101,"1199,54868-3426-00 ",.01)
 ;;54868-3426-00
 ;;9002226.02101,"1199,54868-3426-00 ",.02)
 ;;54868-3426-00
 ;;9002226.02101,"1199,54868-3426-01 ",.01)
 ;;54868-3426-01
 ;;9002226.02101,"1199,54868-3426-01 ",.02)
 ;;54868-3426-01
 ;;9002226.02101,"1199,54868-3711-00 ",.01)
 ;;54868-3711-00
 ;;9002226.02101,"1199,54868-3711-00 ",.02)
 ;;54868-3711-00
 ;;9002226.02101,"1199,54868-3711-01 ",.01)
 ;;54868-3711-01
 ;;9002226.02101,"1199,54868-3711-01 ",.02)
 ;;54868-3711-01
 ;;9002226.02101,"1199,54868-4091-00 ",.01)
 ;;54868-4091-00
 ;;9002226.02101,"1199,54868-4091-00 ",.02)
 ;;54868-4091-00
 ;;9002226.02101,"1199,54868-4091-01 ",.01)
 ;;54868-4091-01
 ;;9002226.02101,"1199,54868-4091-01 ",.02)
 ;;54868-4091-01
 ;;9002226.02101,"1199,54868-4091-02 ",.01)
 ;;54868-4091-02
 ;;9002226.02101,"1199,54868-4091-02 ",.02)
 ;;54868-4091-02
 ;;9002226.02101,"1199,54868-4091-03 ",.01)
 ;;54868-4091-03
 ;;9002226.02101,"1199,54868-4091-03 ",.02)
 ;;54868-4091-03
 ;;9002226.02101,"1199,54868-4205-00 ",.01)
 ;;54868-4205-00
 ;;9002226.02101,"1199,54868-4205-00 ",.02)
 ;;54868-4205-00
 ;;9002226.02101,"1199,54868-4205-01 ",.01)
 ;;54868-4205-01
 ;;9002226.02101,"1199,54868-4205-01 ",.02)
 ;;54868-4205-01
 ;;9002226.02101,"1199,54868-4205-02 ",.01)
 ;;54868-4205-02
 ;;9002226.02101,"1199,54868-4205-02 ",.02)
 ;;54868-4205-02
 ;;9002226.02101,"1199,54868-4206-00 ",.01)
 ;;54868-4206-00
 ;;9002226.02101,"1199,54868-4206-00 ",.02)
 ;;54868-4206-00
 ;;9002226.02101,"1199,54868-4206-01 ",.01)
 ;;54868-4206-01
 ;;9002226.02101,"1199,54868-4206-01 ",.02)
 ;;54868-4206-01
 ;;9002226.02101,"1199,54868-4206-03 ",.01)
 ;;54868-4206-03
 ;;9002226.02101,"1199,54868-4206-03 ",.02)
 ;;54868-4206-03
 ;;9002226.02101,"1199,54868-4206-04 ",.01)
 ;;54868-4206-04
 ;;9002226.02101,"1199,54868-4206-04 ",.02)
 ;;54868-4206-04
 ;;9002226.02101,"1199,54868-4412-00 ",.01)
 ;;54868-4412-00
 ;;9002226.02101,"1199,54868-4412-00 ",.02)
 ;;54868-4412-00
 ;;9002226.02101,"1199,54868-4412-01 ",.01)
 ;;54868-4412-01
 ;;9002226.02101,"1199,54868-4412-01 ",.02)
 ;;54868-4412-01
 ;;9002226.02101,"1199,54868-4412-02 ",.01)
 ;;54868-4412-02
 ;;9002226.02101,"1199,54868-4412-02 ",.02)
 ;;54868-4412-02
 ;;9002226.02101,"1199,54868-4420-00 ",.01)
 ;;54868-4420-00
 ;;9002226.02101,"1199,54868-4420-00 ",.02)
 ;;54868-4420-00
 ;;9002226.02101,"1199,54868-4529-00 ",.01)
 ;;54868-4529-00
 ;;9002226.02101,"1199,54868-4529-00 ",.02)
 ;;54868-4529-00
 ;;9002226.02101,"1199,54868-4529-01 ",.01)
 ;;54868-4529-01
 ;;9002226.02101,"1199,54868-4529-01 ",.02)
 ;;54868-4529-01
 ;;9002226.02101,"1199,54868-4529-02 ",.01)
 ;;54868-4529-02
 ;;9002226.02101,"1199,54868-4529-02 ",.02)
 ;;54868-4529-02
 ;;9002226.02101,"1199,54868-4529-03 ",.01)
 ;;54868-4529-03
 ;;9002226.02101,"1199,54868-4529-03 ",.02)
 ;;54868-4529-03
 ;;9002226.02101,"1199,54868-4609-00 ",.01)
 ;;54868-4609-00
 ;;9002226.02101,"1199,54868-4609-00 ",.02)
 ;;54868-4609-00
 ;;9002226.02101,"1199,54868-4609-01 ",.01)
 ;;54868-4609-01
 ;;9002226.02101,"1199,54868-4609-01 ",.02)
 ;;54868-4609-01
 ;;9002226.02101,"1199,54868-4842-00 ",.01)
 ;;54868-4842-00
 ;;9002226.02101,"1199,54868-4842-00 ",.02)
 ;;54868-4842-00
 ;;9002226.02101,"1199,54868-4842-01 ",.01)
 ;;54868-4842-01
 ;;9002226.02101,"1199,54868-4842-01 ",.02)
 ;;54868-4842-01
 ;;9002226.02101,"1199,54868-4842-02 ",.01)
 ;;54868-4842-02
 ;;9002226.02101,"1199,54868-4842-02 ",.02)
 ;;54868-4842-02
 ;;9002226.02101,"1199,54868-4906-00 ",.01)
 ;;54868-4906-00
 ;;9002226.02101,"1199,54868-4906-00 ",.02)
 ;;54868-4906-00
 ;;9002226.02101,"1199,54868-4988-00 ",.01)
 ;;54868-4988-00
 ;;9002226.02101,"1199,54868-4988-00 ",.02)
 ;;54868-4988-00
 ;;9002226.02101,"1199,54868-4988-01 ",.01)
 ;;54868-4988-01
 ;;9002226.02101,"1199,54868-4988-01 ",.02)
 ;;54868-4988-01
 ;;9002226.02101,"1199,54868-4988-02 ",.01)
 ;;54868-4988-02
 ;;9002226.02101,"1199,54868-4988-02 ",.02)
 ;;54868-4988-02
 ;;9002226.02101,"1199,54868-4988-03 ",.01)
 ;;54868-4988-03
 ;;9002226.02101,"1199,54868-4988-03 ",.02)
 ;;54868-4988-03
 ;;9002226.02101,"1199,54868-4988-04 ",.01)
 ;;54868-4988-04
 ;;9002226.02101,"1199,54868-4988-04 ",.02)
 ;;54868-4988-04
 ;;9002226.02101,"1199,54868-5148-00 ",.01)
 ;;54868-5148-00
 ;;9002226.02101,"1199,54868-5148-00 ",.02)
 ;;54868-5148-00
 ;;9002226.02101,"1199,54868-5148-01 ",.01)
 ;;54868-5148-01
