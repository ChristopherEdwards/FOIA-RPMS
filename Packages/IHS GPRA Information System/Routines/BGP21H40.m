BGP21H40 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,54569-2780-01 ",.02)
 ;;54569-2780-01
 ;;9002226.02101,"1197,54569-2780-02 ",.01)
 ;;54569-2780-02
 ;;9002226.02101,"1197,54569-2780-02 ",.02)
 ;;54569-2780-02
 ;;9002226.02101,"1197,54569-2780-03 ",.01)
 ;;54569-2780-03
 ;;9002226.02101,"1197,54569-2780-03 ",.02)
 ;;54569-2780-03
 ;;9002226.02101,"1197,54569-2781-00 ",.01)
 ;;54569-2781-00
 ;;9002226.02101,"1197,54569-2781-00 ",.02)
 ;;54569-2781-00
 ;;9002226.02101,"1197,54569-2781-01 ",.01)
 ;;54569-2781-01
 ;;9002226.02101,"1197,54569-2781-01 ",.02)
 ;;54569-2781-01
 ;;9002226.02101,"1197,54569-2912-02 ",.01)
 ;;54569-2912-02
 ;;9002226.02101,"1197,54569-2912-02 ",.02)
 ;;54569-2912-02
 ;;9002226.02101,"1197,54569-3055-00 ",.01)
 ;;54569-3055-00
 ;;9002226.02101,"1197,54569-3055-00 ",.02)
 ;;54569-3055-00
 ;;9002226.02101,"1197,54569-3055-02 ",.01)
 ;;54569-3055-02
 ;;9002226.02101,"1197,54569-3055-02 ",.02)
 ;;54569-3055-02
 ;;9002226.02101,"1197,54569-3665-00 ",.01)
 ;;54569-3665-00
 ;;9002226.02101,"1197,54569-3665-00 ",.02)
 ;;54569-3665-00
 ;;9002226.02101,"1197,54569-3665-01 ",.01)
 ;;54569-3665-01
 ;;9002226.02101,"1197,54569-3665-01 ",.02)
 ;;54569-3665-01
 ;;9002226.02101,"1197,54569-3667-00 ",.01)
 ;;54569-3667-00
 ;;9002226.02101,"1197,54569-3667-00 ",.02)
 ;;54569-3667-00
 ;;9002226.02101,"1197,54569-3667-01 ",.01)
 ;;54569-3667-01
 ;;9002226.02101,"1197,54569-3667-01 ",.02)
 ;;54569-3667-01
 ;;9002226.02101,"1197,54569-3667-02 ",.01)
 ;;54569-3667-02
 ;;9002226.02101,"1197,54569-3667-02 ",.02)
 ;;54569-3667-02
 ;;9002226.02101,"1197,54569-3691-00 ",.01)
 ;;54569-3691-00
 ;;9002226.02101,"1197,54569-3691-00 ",.02)
 ;;54569-3691-00
 ;;9002226.02101,"1197,54569-3718-00 ",.01)
 ;;54569-3718-00
 ;;9002226.02101,"1197,54569-3718-00 ",.02)
 ;;54569-3718-00
 ;;9002226.02101,"1197,54569-3718-03 ",.01)
 ;;54569-3718-03
 ;;9002226.02101,"1197,54569-3718-03 ",.02)
 ;;54569-3718-03
 ;;9002226.02101,"1197,54569-3719-00 ",.01)
 ;;54569-3719-00
 ;;9002226.02101,"1197,54569-3719-00 ",.02)
 ;;54569-3719-00
 ;;9002226.02101,"1197,54569-3784-00 ",.01)
 ;;54569-3784-00
 ;;9002226.02101,"1197,54569-3784-00 ",.02)
 ;;54569-3784-00
 ;;9002226.02101,"1197,54569-3785-00 ",.01)
 ;;54569-3785-00
 ;;9002226.02101,"1197,54569-3785-00 ",.02)
 ;;54569-3785-00
 ;;9002226.02101,"1197,54569-3785-02 ",.01)
 ;;54569-3785-02
 ;;9002226.02101,"1197,54569-3785-02 ",.02)
 ;;54569-3785-02
 ;;9002226.02101,"1197,54569-3786-00 ",.01)
 ;;54569-3786-00
 ;;9002226.02101,"1197,54569-3786-00 ",.02)
 ;;54569-3786-00
 ;;9002226.02101,"1197,54569-3786-01 ",.01)
 ;;54569-3786-01
 ;;9002226.02101,"1197,54569-3786-01 ",.02)
 ;;54569-3786-01
 ;;9002226.02101,"1197,54569-3802-00 ",.01)
 ;;54569-3802-00
 ;;9002226.02101,"1197,54569-3802-00 ",.02)
 ;;54569-3802-00
 ;;9002226.02101,"1197,54569-3803-00 ",.01)
 ;;54569-3803-00
 ;;9002226.02101,"1197,54569-3803-00 ",.02)
 ;;54569-3803-00
 ;;9002226.02101,"1197,54569-3804-00 ",.01)
 ;;54569-3804-00
 ;;9002226.02101,"1197,54569-3804-00 ",.02)
 ;;54569-3804-00
 ;;9002226.02101,"1197,54569-3866-00 ",.01)
 ;;54569-3866-00
 ;;9002226.02101,"1197,54569-3866-00 ",.02)
 ;;54569-3866-00
 ;;9002226.02101,"1197,54569-3866-01 ",.01)
 ;;54569-3866-01
 ;;9002226.02101,"1197,54569-3866-01 ",.02)
 ;;54569-3866-01
 ;;9002226.02101,"1197,54569-3866-02 ",.01)
 ;;54569-3866-02
 ;;9002226.02101,"1197,54569-3866-02 ",.02)
 ;;54569-3866-02
 ;;9002226.02101,"1197,54569-3891-00 ",.01)
 ;;54569-3891-00
 ;;9002226.02101,"1197,54569-3891-00 ",.02)
 ;;54569-3891-00
 ;;9002226.02101,"1197,54569-3891-01 ",.01)
 ;;54569-3891-01
 ;;9002226.02101,"1197,54569-3891-01 ",.02)
 ;;54569-3891-01
 ;;9002226.02101,"1197,54569-3892-00 ",.01)
 ;;54569-3892-00
 ;;9002226.02101,"1197,54569-3892-00 ",.02)
 ;;54569-3892-00
 ;;9002226.02101,"1197,54569-3893-00 ",.01)
 ;;54569-3893-00
 ;;9002226.02101,"1197,54569-3893-00 ",.02)
 ;;54569-3893-00
 ;;9002226.02101,"1197,54569-4183-00 ",.01)
 ;;54569-4183-00
 ;;9002226.02101,"1197,54569-4183-00 ",.02)
 ;;54569-4183-00
 ;;9002226.02101,"1197,54569-4211-00 ",.01)
 ;;54569-4211-00
 ;;9002226.02101,"1197,54569-4211-00 ",.02)
 ;;54569-4211-00
 ;;9002226.02101,"1197,54569-4447-00 ",.01)
 ;;54569-4447-00
 ;;9002226.02101,"1197,54569-4447-00 ",.02)
 ;;54569-4447-00
 ;;9002226.02101,"1197,54569-4447-01 ",.01)
 ;;54569-4447-01
 ;;9002226.02101,"1197,54569-4447-01 ",.02)
 ;;54569-4447-01
 ;;9002226.02101,"1197,54569-4447-04 ",.01)
 ;;54569-4447-04
 ;;9002226.02101,"1197,54569-4447-04 ",.02)
 ;;54569-4447-04
 ;;9002226.02101,"1197,54569-4455-00 ",.01)
 ;;54569-4455-00
 ;;9002226.02101,"1197,54569-4455-00 ",.02)
 ;;54569-4455-00
 ;;9002226.02101,"1197,54569-4472-00 ",.01)
 ;;54569-4472-00
 ;;9002226.02101,"1197,54569-4472-00 ",.02)
 ;;54569-4472-00
 ;;9002226.02101,"1197,54569-4472-01 ",.01)
 ;;54569-4472-01
 ;;9002226.02101,"1197,54569-4472-01 ",.02)
 ;;54569-4472-01
 ;;9002226.02101,"1197,54569-4498-00 ",.01)
 ;;54569-4498-00
 ;;9002226.02101,"1197,54569-4498-00 ",.02)
 ;;54569-4498-00
 ;;9002226.02101,"1197,54569-4499-00 ",.01)
 ;;54569-4499-00
 ;;9002226.02101,"1197,54569-4499-00 ",.02)
 ;;54569-4499-00
 ;;9002226.02101,"1197,54569-4622-00 ",.01)
 ;;54569-4622-00
 ;;9002226.02101,"1197,54569-4622-00 ",.02)
 ;;54569-4622-00
