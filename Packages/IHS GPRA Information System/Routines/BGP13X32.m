BGP13X32 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON APR 14, 2011 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1100,54868-4605-00 ",.01)
 ;;54868-4605-00
 ;;9002226.02101,"1100,54868-4605-00 ",.02)
 ;;54868-4605-00
 ;;9002226.02101,"1100,54868-4605-01 ",.01)
 ;;54868-4605-01
 ;;9002226.02101,"1100,54868-4605-01 ",.02)
 ;;54868-4605-01
 ;;9002226.02101,"1100,54868-4605-02 ",.01)
 ;;54868-4605-02
 ;;9002226.02101,"1100,54868-4605-02 ",.02)
 ;;54868-4605-02
 ;;9002226.02101,"1100,54868-4612-00 ",.01)
 ;;54868-4612-00
 ;;9002226.02101,"1100,54868-4612-00 ",.02)
 ;;54868-4612-00
 ;;9002226.02101,"1100,54868-4637-00 ",.01)
 ;;54868-4637-00
 ;;9002226.02101,"1100,54868-4637-00 ",.02)
 ;;54868-4637-00
 ;;9002226.02101,"1100,54868-4637-01 ",.01)
 ;;54868-4637-01
 ;;9002226.02101,"1100,54868-4637-01 ",.02)
 ;;54868-4637-01
 ;;9002226.02101,"1100,54868-4637-02 ",.01)
 ;;54868-4637-02
 ;;9002226.02101,"1100,54868-4637-02 ",.02)
 ;;54868-4637-02
 ;;9002226.02101,"1100,54868-4637-03 ",.01)
 ;;54868-4637-03
 ;;9002226.02101,"1100,54868-4637-03 ",.02)
 ;;54868-4637-03
 ;;9002226.02101,"1100,54868-4637-04 ",.01)
 ;;54868-4637-04
 ;;9002226.02101,"1100,54868-4637-04 ",.02)
 ;;54868-4637-04
 ;;9002226.02101,"1100,54868-4645-00 ",.01)
 ;;54868-4645-00
 ;;9002226.02101,"1100,54868-4645-00 ",.02)
 ;;54868-4645-00
 ;;9002226.02101,"1100,54868-4645-01 ",.01)
 ;;54868-4645-01
 ;;9002226.02101,"1100,54868-4645-01 ",.02)
 ;;54868-4645-01
 ;;9002226.02101,"1100,54868-4645-02 ",.01)
 ;;54868-4645-02
 ;;9002226.02101,"1100,54868-4645-02 ",.02)
 ;;54868-4645-02
 ;;9002226.02101,"1100,54868-4645-03 ",.01)
 ;;54868-4645-03
 ;;9002226.02101,"1100,54868-4645-03 ",.02)
 ;;54868-4645-03
 ;;9002226.02101,"1100,54868-4646-00 ",.01)
 ;;54868-4646-00
 ;;9002226.02101,"1100,54868-4646-00 ",.02)
 ;;54868-4646-00
 ;;9002226.02101,"1100,54868-4646-02 ",.01)
 ;;54868-4646-02
 ;;9002226.02101,"1100,54868-4646-02 ",.02)
 ;;54868-4646-02
 ;;9002226.02101,"1100,54868-4646-03 ",.01)
 ;;54868-4646-03
 ;;9002226.02101,"1100,54868-4646-03 ",.02)
 ;;54868-4646-03
 ;;9002226.02101,"1100,54868-4646-04 ",.01)
 ;;54868-4646-04
 ;;9002226.02101,"1100,54868-4646-04 ",.02)
 ;;54868-4646-04
 ;;9002226.02101,"1100,54868-4652-00 ",.01)
 ;;54868-4652-00
 ;;9002226.02101,"1100,54868-4652-00 ",.02)
 ;;54868-4652-00
 ;;9002226.02101,"1100,54868-4652-01 ",.01)
 ;;54868-4652-01
 ;;9002226.02101,"1100,54868-4652-01 ",.02)
 ;;54868-4652-01
 ;;9002226.02101,"1100,54868-4652-02 ",.01)
 ;;54868-4652-02
 ;;9002226.02101,"1100,54868-4652-02 ",.02)
 ;;54868-4652-02
 ;;9002226.02101,"1100,54868-4652-03 ",.01)
 ;;54868-4652-03
 ;;9002226.02101,"1100,54868-4652-03 ",.02)
 ;;54868-4652-03
 ;;9002226.02101,"1100,54868-4652-04 ",.01)
 ;;54868-4652-04
 ;;9002226.02101,"1100,54868-4652-04 ",.02)
 ;;54868-4652-04
 ;;9002226.02101,"1100,54868-4652-05 ",.01)
 ;;54868-4652-05
 ;;9002226.02101,"1100,54868-4652-05 ",.02)
 ;;54868-4652-05
 ;;9002226.02101,"1100,54868-4656-00 ",.01)
 ;;54868-4656-00
 ;;9002226.02101,"1100,54868-4656-00 ",.02)
 ;;54868-4656-00
 ;;9002226.02101,"1100,54868-4656-01 ",.01)
 ;;54868-4656-01
 ;;9002226.02101,"1100,54868-4656-01 ",.02)
 ;;54868-4656-01
 ;;9002226.02101,"1100,54868-4656-02 ",.01)
 ;;54868-4656-02
 ;;9002226.02101,"1100,54868-4656-02 ",.02)
 ;;54868-4656-02
 ;;9002226.02101,"1100,54868-4656-03 ",.01)
 ;;54868-4656-03
 ;;9002226.02101,"1100,54868-4656-03 ",.02)
 ;;54868-4656-03
 ;;9002226.02101,"1100,54868-4657-00 ",.01)
 ;;54868-4657-00
 ;;9002226.02101,"1100,54868-4657-00 ",.02)
 ;;54868-4657-00
 ;;9002226.02101,"1100,54868-4657-01 ",.01)
 ;;54868-4657-01
 ;;9002226.02101,"1100,54868-4657-01 ",.02)
 ;;54868-4657-01
 ;;9002226.02101,"1100,54868-4657-02 ",.01)
 ;;54868-4657-02
 ;;9002226.02101,"1100,54868-4657-02 ",.02)
 ;;54868-4657-02
 ;;9002226.02101,"1100,54868-4657-04 ",.01)
 ;;54868-4657-04
 ;;9002226.02101,"1100,54868-4657-04 ",.02)
 ;;54868-4657-04
 ;;9002226.02101,"1100,54868-4657-05 ",.01)
 ;;54868-4657-05
 ;;9002226.02101,"1100,54868-4657-05 ",.02)
 ;;54868-4657-05
 ;;9002226.02101,"1100,54868-4657-06 ",.01)
 ;;54868-4657-06
 ;;9002226.02101,"1100,54868-4657-06 ",.02)
 ;;54868-4657-06
 ;;9002226.02101,"1100,54868-4658-00 ",.01)
 ;;54868-4658-00
 ;;9002226.02101,"1100,54868-4658-00 ",.02)
 ;;54868-4658-00
 ;;9002226.02101,"1100,54868-4658-01 ",.01)
 ;;54868-4658-01
 ;;9002226.02101,"1100,54868-4658-01 ",.02)
 ;;54868-4658-01
 ;;9002226.02101,"1100,54868-4658-02 ",.01)
 ;;54868-4658-02
 ;;9002226.02101,"1100,54868-4658-02 ",.02)
 ;;54868-4658-02
 ;;9002226.02101,"1100,54868-4658-03 ",.01)
 ;;54868-4658-03
 ;;9002226.02101,"1100,54868-4658-03 ",.02)
 ;;54868-4658-03
 ;;9002226.02101,"1100,54868-4658-04 ",.01)
 ;;54868-4658-04
 ;;9002226.02101,"1100,54868-4658-04 ",.02)
 ;;54868-4658-04
 ;;9002226.02101,"1100,54868-4678-00 ",.01)
 ;;54868-4678-00
 ;;9002226.02101,"1100,54868-4678-00 ",.02)
 ;;54868-4678-00
 ;;9002226.02101,"1100,54868-4678-01 ",.01)
 ;;54868-4678-01
 ;;9002226.02101,"1100,54868-4678-01 ",.02)
 ;;54868-4678-01
 ;;9002226.02101,"1100,54868-4678-02 ",.01)
 ;;54868-4678-02
 ;;9002226.02101,"1100,54868-4678-02 ",.02)
 ;;54868-4678-02
 ;;9002226.02101,"1100,54868-4720-00 ",.01)
 ;;54868-4720-00
 ;;9002226.02101,"1100,54868-4720-00 ",.02)
 ;;54868-4720-00
 ;;9002226.02101,"1100,54868-4720-01 ",.01)
 ;;54868-4720-01
 ;;9002226.02101,"1100,54868-4720-01 ",.02)
 ;;54868-4720-01
 ;;9002226.02101,"1100,54868-4720-02 ",.01)
 ;;54868-4720-02
 ;;9002226.02101,"1100,54868-4720-02 ",.02)
 ;;54868-4720-02
 ;;9002226.02101,"1100,54868-4720-03 ",.01)
 ;;54868-4720-03
 ;;9002226.02101,"1100,54868-4720-03 ",.02)
 ;;54868-4720-03
 ;;9002226.02101,"1100,54868-4729-00 ",.01)
 ;;54868-4729-00
 ;;9002226.02101,"1100,54868-4729-00 ",.02)
 ;;54868-4729-00
 ;;9002226.02101,"1100,54868-4780-00 ",.01)
 ;;54868-4780-00
 ;;9002226.02101,"1100,54868-4780-00 ",.02)
 ;;54868-4780-00
 ;;9002226.02101,"1100,54868-4780-01 ",.01)
 ;;54868-4780-01
 ;;9002226.02101,"1100,54868-4780-01 ",.02)
 ;;54868-4780-01
 ;;9002226.02101,"1100,54868-4785-00 ",.01)
 ;;54868-4785-00
 ;;9002226.02101,"1100,54868-4785-00 ",.02)
 ;;54868-4785-00
 ;;9002226.02101,"1100,54868-4785-01 ",.01)
 ;;54868-4785-01
 ;;9002226.02101,"1100,54868-4785-01 ",.02)
 ;;54868-4785-01
 ;;9002226.02101,"1100,54868-4785-02 ",.01)
 ;;54868-4785-02
 ;;9002226.02101,"1100,54868-4785-02 ",.02)
 ;;54868-4785-02
 ;;9002226.02101,"1100,54868-4785-03 ",.01)
 ;;54868-4785-03
 ;;9002226.02101,"1100,54868-4785-03 ",.02)
 ;;54868-4785-03
 ;;9002226.02101,"1100,54868-4869-00 ",.01)
 ;;54868-4869-00
 ;;9002226.02101,"1100,54868-4869-00 ",.02)
 ;;54868-4869-00
 ;;9002226.02101,"1100,54868-4870-00 ",.01)
 ;;54868-4870-00
 ;;9002226.02101,"1100,54868-4870-00 ",.02)
 ;;54868-4870-00
 ;;9002226.02101,"1100,54868-4870-01 ",.01)
 ;;54868-4870-01
 ;;9002226.02101,"1100,54868-4870-01 ",.02)
 ;;54868-4870-01
 ;;9002226.02101,"1100,54868-4870-02 ",.01)
 ;;54868-4870-02
 ;;9002226.02101,"1100,54868-4870-02 ",.02)
 ;;54868-4870-02
 ;;9002226.02101,"1100,54868-4883-00 ",.01)
 ;;54868-4883-00
 ;;9002226.02101,"1100,54868-4883-00 ",.02)
 ;;54868-4883-00
 ;;9002226.02101,"1100,54868-4883-01 ",.01)
 ;;54868-4883-01
 ;;9002226.02101,"1100,54868-4883-01 ",.02)
 ;;54868-4883-01
 ;;9002226.02101,"1100,54868-4883-02 ",.01)
 ;;54868-4883-02
 ;;9002226.02101,"1100,54868-4883-02 ",.02)
 ;;54868-4883-02
 ;;9002226.02101,"1100,54868-4885-00 ",.01)
 ;;54868-4885-00
 ;;9002226.02101,"1100,54868-4885-00 ",.02)
 ;;54868-4885-00
 ;;9002226.02101,"1100,54868-4885-01 ",.01)
 ;;54868-4885-01
 ;;9002226.02101,"1100,54868-4885-01 ",.02)
 ;;54868-4885-01
 ;;9002226.02101,"1100,54868-4904-00 ",.01)
 ;;54868-4904-00
 ;;9002226.02101,"1100,54868-4904-00 ",.02)
 ;;54868-4904-00
 ;;9002226.02101,"1100,54868-4904-01 ",.01)
 ;;54868-4904-01
 ;;9002226.02101,"1100,54868-4904-01 ",.02)
 ;;54868-4904-01
 ;;9002226.02101,"1100,54868-4977-00 ",.01)
 ;;54868-4977-00
 ;;9002226.02101,"1100,54868-4977-00 ",.02)
 ;;54868-4977-00
 ;;9002226.02101,"1100,54868-4977-01 ",.01)
 ;;54868-4977-01
 ;;9002226.02101,"1100,54868-4977-01 ",.02)
 ;;54868-4977-01
 ;;9002226.02101,"1100,54868-4977-02 ",.01)
 ;;54868-4977-02
 ;;9002226.02101,"1100,54868-4977-02 ",.02)
 ;;54868-4977-02
 ;;9002226.02101,"1100,54868-4986-00 ",.01)
 ;;54868-4986-00
 ;;9002226.02101,"1100,54868-4986-00 ",.02)
 ;;54868-4986-00
 ;;9002226.02101,"1100,54868-4986-01 ",.01)
 ;;54868-4986-01
 ;;9002226.02101,"1100,54868-4986-01 ",.02)
 ;;54868-4986-01
 ;;9002226.02101,"1100,54868-4986-02 ",.01)
 ;;54868-4986-02
 ;;9002226.02101,"1100,54868-4986-02 ",.02)
 ;;54868-4986-02
 ;;9002226.02101,"1100,54868-5001-00 ",.01)
 ;;54868-5001-00
 ;;9002226.02101,"1100,54868-5001-00 ",.02)
 ;;54868-5001-00
 ;;9002226.02101,"1100,54868-5001-01 ",.01)
 ;;54868-5001-01
 ;;9002226.02101,"1100,54868-5001-01 ",.02)
 ;;54868-5001-01
 ;;9002226.02101,"1100,54868-5055-00 ",.01)
 ;;54868-5055-00
 ;;9002226.02101,"1100,54868-5055-00 ",.02)
 ;;54868-5055-00
 ;;9002226.02101,"1100,54868-5064-00 ",.01)
 ;;54868-5064-00
 ;;9002226.02101,"1100,54868-5064-00 ",.02)
 ;;54868-5064-00
 ;;9002226.02101,"1100,54868-5064-01 ",.01)
 ;;54868-5064-01
 ;;9002226.02101,"1100,54868-5064-01 ",.02)
 ;;54868-5064-01
 ;;9002226.02101,"1100,54868-5075-00 ",.01)
 ;;54868-5075-00
 ;;9002226.02101,"1100,54868-5075-00 ",.02)
 ;;54868-5075-00
 ;;9002226.02101,"1100,54868-5075-01 ",.01)
 ;;54868-5075-01
 ;;9002226.02101,"1100,54868-5075-01 ",.02)
 ;;54868-5075-01
 ;;9002226.02101,"1100,54868-5077-00 ",.01)
 ;;54868-5077-00
 ;;9002226.02101,"1100,54868-5077-00 ",.02)
 ;;54868-5077-00
 ;;9002226.02101,"1100,54868-5078-00 ",.01)
 ;;54868-5078-00
 ;;9002226.02101,"1100,54868-5078-00 ",.02)
 ;;54868-5078-00
 ;;9002226.02101,"1100,54868-5078-01 ",.01)
 ;;54868-5078-01
 ;;9002226.02101,"1100,54868-5078-01 ",.02)
 ;;54868-5078-01
 ;;9002226.02101,"1100,54868-5079-00 ",.01)
 ;;54868-5079-00
 ;;9002226.02101,"1100,54868-5079-00 ",.02)
 ;;54868-5079-00
 ;;9002226.02101,"1100,54868-5079-01 ",.01)
 ;;54868-5079-01
 ;;9002226.02101,"1100,54868-5079-01 ",.02)
 ;;54868-5079-01
 ;;9002226.02101,"1100,54868-5082-00 ",.01)
 ;;54868-5082-00
 ;;9002226.02101,"1100,54868-5082-00 ",.02)
 ;;54868-5082-00
 ;;9002226.02101,"1100,54868-5082-01 ",.01)
 ;;54868-5082-01
 ;;9002226.02101,"1100,54868-5082-01 ",.02)
 ;;54868-5082-01
 ;;9002226.02101,"1100,54868-5082-02 ",.01)
 ;;54868-5082-02
 ;;9002226.02101,"1100,54868-5082-02 ",.02)
 ;;54868-5082-02
 ;;9002226.02101,"1100,54868-5082-03 ",.01)
 ;;54868-5082-03
 ;;9002226.02101,"1100,54868-5082-03 ",.02)
 ;;54868-5082-03
 ;;9002226.02101,"1100,54868-5099-00 ",.01)
 ;;54868-5099-00
 ;;9002226.02101,"1100,54868-5099-00 ",.02)
 ;;54868-5099-00
 ;;9002226.02101,"1100,54868-5099-01 ",.01)
 ;;54868-5099-01
 ;;9002226.02101,"1100,54868-5099-01 ",.02)
 ;;54868-5099-01
 ;;9002226.02101,"1100,54868-5100-00 ",.01)
 ;;54868-5100-00
 ;;9002226.02101,"1100,54868-5100-00 ",.02)
 ;;54868-5100-00
 ;;9002226.02101,"1100,54868-5100-02 ",.01)
 ;;54868-5100-02
 ;;9002226.02101,"1100,54868-5100-02 ",.02)
 ;;54868-5100-02
 ;;9002226.02101,"1100,54868-5170-00 ",.01)
 ;;54868-5170-00
 ;;9002226.02101,"1100,54868-5170-00 ",.02)
 ;;54868-5170-00
 ;;9002226.02101,"1100,54868-5170-01 ",.01)
 ;;54868-5170-01
 ;;9002226.02101,"1100,54868-5170-01 ",.02)
 ;;54868-5170-01
 ;;9002226.02101,"1100,54868-5182-00 ",.01)
 ;;54868-5182-00
 ;;9002226.02101,"1100,54868-5182-00 ",.02)
 ;;54868-5182-00
 ;;9002226.02101,"1100,54868-5182-01 ",.01)
 ;;54868-5182-01
 ;;9002226.02101,"1100,54868-5182-01 ",.02)
 ;;54868-5182-01
 ;;9002226.02101,"1100,54868-5182-02 ",.01)
 ;;54868-5182-02
 ;;9002226.02101,"1100,54868-5182-02 ",.02)
 ;;54868-5182-02
 ;;9002226.02101,"1100,54868-5196-00 ",.01)
 ;;54868-5196-00
 ;;9002226.02101,"1100,54868-5196-00 ",.02)
 ;;54868-5196-00
 ;;9002226.02101,"1100,54868-5196-01 ",.01)
 ;;54868-5196-01
 ;;9002226.02101,"1100,54868-5196-01 ",.02)
 ;;54868-5196-01
 ;;9002226.02101,"1100,54868-5196-02 ",.01)
 ;;54868-5196-02
 ;;9002226.02101,"1100,54868-5196-02 ",.02)
 ;;54868-5196-02
 ;;9002226.02101,"1100,54868-5204-00 ",.01)
 ;;54868-5204-00
 ;;9002226.02101,"1100,54868-5204-00 ",.02)
 ;;54868-5204-00
 ;;9002226.02101,"1100,54868-5204-01 ",.01)
 ;;54868-5204-01
 ;;9002226.02101,"1100,54868-5204-01 ",.02)
 ;;54868-5204-01
 ;;9002226.02101,"1100,54868-5204-02 ",.01)
 ;;54868-5204-02
 ;;9002226.02101,"1100,54868-5204-02 ",.02)
 ;;54868-5204-02
 ;;9002226.02101,"1100,54868-5204-03 ",.01)
 ;;54868-5204-03
 ;;9002226.02101,"1100,54868-5204-03 ",.02)
 ;;54868-5204-03
 ;;9002226.02101,"1100,54868-5241-00 ",.01)
 ;;54868-5241-00
 ;;9002226.02101,"1100,54868-5241-00 ",.02)
 ;;54868-5241-00