BGP06A47 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAY 23, 2010;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"974,54569-4338-00 ",.01)
 ;;54569-4338-00
 ;;9002226.02101,"974,54569-4338-00 ",.02)
 ;;54569-4338-00
 ;;9002226.02101,"974,54569-4338-01 ",.01)
 ;;54569-4338-01
 ;;9002226.02101,"974,54569-4338-01 ",.02)
 ;;54569-4338-01
 ;;9002226.02101,"974,54569-4352-00 ",.01)
 ;;54569-4352-00
 ;;9002226.02101,"974,54569-4352-00 ",.02)
 ;;54569-4352-00
 ;;9002226.02101,"974,54569-4353-00 ",.01)
 ;;54569-4353-00
 ;;9002226.02101,"974,54569-4353-00 ",.02)
 ;;54569-4353-00
 ;;9002226.02101,"974,54569-4363-00 ",.01)
 ;;54569-4363-00
 ;;9002226.02101,"974,54569-4363-00 ",.02)
 ;;54569-4363-00
 ;;9002226.02101,"974,54569-4391-00 ",.01)
 ;;54569-4391-00
 ;;9002226.02101,"974,54569-4391-00 ",.02)
 ;;54569-4391-00
 ;;9002226.02101,"974,54569-4391-01 ",.01)
 ;;54569-4391-01
 ;;9002226.02101,"974,54569-4391-01 ",.02)
 ;;54569-4391-01
 ;;9002226.02101,"974,54569-4391-02 ",.01)
 ;;54569-4391-02
 ;;9002226.02101,"974,54569-4391-02 ",.02)
 ;;54569-4391-02
 ;;9002226.02101,"974,54569-4391-03 ",.01)
 ;;54569-4391-03
 ;;9002226.02101,"974,54569-4391-03 ",.02)
 ;;54569-4391-03
 ;;9002226.02101,"974,54569-4417-00 ",.01)
 ;;54569-4417-00
 ;;9002226.02101,"974,54569-4417-00 ",.02)
 ;;54569-4417-00
 ;;9002226.02101,"974,54569-4458-00 ",.01)
 ;;54569-4458-00
 ;;9002226.02101,"974,54569-4458-00 ",.02)
 ;;54569-4458-00
 ;;9002226.02101,"974,54569-4458-01 ",.01)
 ;;54569-4458-01
 ;;9002226.02101,"974,54569-4458-01 ",.02)
 ;;54569-4458-01
 ;;9002226.02101,"974,54569-4458-02 ",.01)
 ;;54569-4458-02
 ;;9002226.02101,"974,54569-4458-02 ",.02)
 ;;54569-4458-02
 ;;9002226.02101,"974,54569-4463-00 ",.01)
 ;;54569-4463-00
 ;;9002226.02101,"974,54569-4463-00 ",.02)
 ;;54569-4463-00
 ;;9002226.02101,"974,54569-4463-01 ",.01)
 ;;54569-4463-01
 ;;9002226.02101,"974,54569-4463-01 ",.02)
 ;;54569-4463-01
 ;;9002226.02101,"974,54569-4489-00 ",.01)
 ;;54569-4489-00
 ;;9002226.02101,"974,54569-4489-00 ",.02)
 ;;54569-4489-00
 ;;9002226.02101,"974,54569-4489-01 ",.01)
 ;;54569-4489-01
 ;;9002226.02101,"974,54569-4489-01 ",.02)
 ;;54569-4489-01
 ;;9002226.02101,"974,54569-4489-02 ",.01)
 ;;54569-4489-02
 ;;9002226.02101,"974,54569-4489-02 ",.02)
 ;;54569-4489-02
 ;;9002226.02101,"974,54569-4489-03 ",.01)
 ;;54569-4489-03
 ;;9002226.02101,"974,54569-4489-03 ",.02)
 ;;54569-4489-03
 ;;9002226.02101,"974,54569-4489-04 ",.01)
 ;;54569-4489-04
 ;;9002226.02101,"974,54569-4489-04 ",.02)
 ;;54569-4489-04
 ;;9002226.02101,"974,54569-4497-00 ",.01)
 ;;54569-4497-00
 ;;9002226.02101,"974,54569-4497-00 ",.02)
 ;;54569-4497-00
 ;;9002226.02101,"974,54569-4522-00 ",.01)
 ;;54569-4522-00
 ;;9002226.02101,"974,54569-4522-00 ",.02)
 ;;54569-4522-00
 ;;9002226.02101,"974,54569-4522-01 ",.01)
 ;;54569-4522-01
 ;;9002226.02101,"974,54569-4522-01 ",.02)
 ;;54569-4522-01
 ;;9002226.02101,"974,54569-4522-02 ",.01)
 ;;54569-4522-02
 ;;9002226.02101,"974,54569-4522-02 ",.02)
 ;;54569-4522-02
 ;;9002226.02101,"974,54569-4551-01 ",.01)
 ;;54569-4551-01
 ;;9002226.02101,"974,54569-4551-01 ",.02)
 ;;54569-4551-01
 ;;9002226.02101,"974,54569-4567-00 ",.01)
 ;;54569-4567-00
 ;;9002226.02101,"974,54569-4567-00 ",.02)
 ;;54569-4567-00
 ;;9002226.02101,"974,54569-4608-00 ",.01)
 ;;54569-4608-00
 ;;9002226.02101,"974,54569-4608-00 ",.02)
 ;;54569-4608-00
 ;;9002226.02101,"974,54569-4647-00 ",.01)
 ;;54569-4647-00
 ;;9002226.02101,"974,54569-4647-00 ",.02)
 ;;54569-4647-00
 ;;9002226.02101,"974,54569-4681-00 ",.01)
 ;;54569-4681-00
 ;;9002226.02101,"974,54569-4681-00 ",.02)
 ;;54569-4681-00
 ;;9002226.02101,"974,54569-4689-00 ",.01)
 ;;54569-4689-00
 ;;9002226.02101,"974,54569-4689-00 ",.02)
 ;;54569-4689-00
 ;;9002226.02101,"974,54569-4712-00 ",.01)
 ;;54569-4712-00
 ;;9002226.02101,"974,54569-4712-00 ",.02)
 ;;54569-4712-00
 ;;9002226.02101,"974,54569-4712-01 ",.01)
 ;;54569-4712-01
 ;;9002226.02101,"974,54569-4712-01 ",.02)
 ;;54569-4712-01
 ;;9002226.02101,"974,54569-4713-00 ",.01)
 ;;54569-4713-00
 ;;9002226.02101,"974,54569-4713-00 ",.02)
 ;;54569-4713-00
 ;;9002226.02101,"974,54569-4737-00 ",.01)
 ;;54569-4737-00
 ;;9002226.02101,"974,54569-4737-00 ",.02)
 ;;54569-4737-00
 ;;9002226.02101,"974,54569-4783-00 ",.01)
 ;;54569-4783-00
 ;;9002226.02101,"974,54569-4783-00 ",.02)
 ;;54569-4783-00
 ;;9002226.02101,"974,54569-4790-00 ",.01)
 ;;54569-4790-00
 ;;9002226.02101,"974,54569-4790-00 ",.02)
 ;;54569-4790-00
 ;;9002226.02101,"974,54569-4791-00 ",.01)
 ;;54569-4791-00
 ;;9002226.02101,"974,54569-4791-00 ",.02)
 ;;54569-4791-00
 ;;9002226.02101,"974,54569-4791-01 ",.01)
 ;;54569-4791-01
 ;;9002226.02101,"974,54569-4791-01 ",.02)
 ;;54569-4791-01
 ;;9002226.02101,"974,54569-4796-00 ",.01)
 ;;54569-4796-00
 ;;9002226.02101,"974,54569-4796-00 ",.02)
 ;;54569-4796-00
 ;;9002226.02101,"974,54569-4797-00 ",.01)
 ;;54569-4797-00
 ;;9002226.02101,"974,54569-4797-00 ",.02)
 ;;54569-4797-00
 ;;9002226.02101,"974,54569-4820-00 ",.01)
 ;;54569-4820-00
 ;;9002226.02101,"974,54569-4820-00 ",.02)
 ;;54569-4820-00
 ;;9002226.02101,"974,54569-4877-00 ",.01)
 ;;54569-4877-00
 ;;9002226.02101,"974,54569-4877-00 ",.02)
 ;;54569-4877-00
 ;;9002226.02101,"974,54569-4889-00 ",.01)
 ;;54569-4889-00
 ;;9002226.02101,"974,54569-4889-00 ",.02)
 ;;54569-4889-00
 ;;9002226.02101,"974,54569-4892-00 ",.01)
 ;;54569-4892-00
 ;;9002226.02101,"974,54569-4892-00 ",.02)
 ;;54569-4892-00
 ;;9002226.02101,"974,54569-4898-00 ",.01)
 ;;54569-4898-00
 ;;9002226.02101,"974,54569-4898-00 ",.02)
 ;;54569-4898-00
 ;;9002226.02101,"974,54569-4915-00 ",.01)
 ;;54569-4915-00
 ;;9002226.02101,"974,54569-4915-00 ",.02)
 ;;54569-4915-00
 ;;9002226.02101,"974,54569-4915-01 ",.01)
 ;;54569-4915-01
 ;;9002226.02101,"974,54569-4915-01 ",.02)
 ;;54569-4915-01
 ;;9002226.02101,"974,54569-4915-02 ",.01)
 ;;54569-4915-02
 ;;9002226.02101,"974,54569-4915-02 ",.02)
 ;;54569-4915-02
 ;;9002226.02101,"974,54569-4918-00 ",.01)
 ;;54569-4918-00
 ;;9002226.02101,"974,54569-4918-00 ",.02)
 ;;54569-4918-00
 ;;9002226.02101,"974,54569-4921-00 ",.01)
 ;;54569-4921-00
 ;;9002226.02101,"974,54569-4921-00 ",.02)
 ;;54569-4921-00
 ;;9002226.02101,"974,54569-4921-01 ",.01)
 ;;54569-4921-01
 ;;9002226.02101,"974,54569-4921-01 ",.02)
 ;;54569-4921-01
 ;;9002226.02101,"974,54569-4921-02 ",.01)
 ;;54569-4921-02
 ;;9002226.02101,"974,54569-4921-02 ",.02)
 ;;54569-4921-02
 ;;9002226.02101,"974,54569-4972-00 ",.01)
 ;;54569-4972-00
 ;;9002226.02101,"974,54569-4972-00 ",.02)
 ;;54569-4972-00
 ;;9002226.02101,"974,54569-5112-00 ",.01)
 ;;54569-5112-00
 ;;9002226.02101,"974,54569-5112-00 ",.02)
 ;;54569-5112-00
 ;;9002226.02101,"974,54569-5154-00 ",.01)
 ;;54569-5154-00
 ;;9002226.02101,"974,54569-5154-00 ",.02)
 ;;54569-5154-00
 ;;9002226.02101,"974,54569-5182-00 ",.01)
 ;;54569-5182-00
 ;;9002226.02101,"974,54569-5182-00 ",.02)
 ;;54569-5182-00
 ;;9002226.02101,"974,54569-5193-00 ",.01)
 ;;54569-5193-00
 ;;9002226.02101,"974,54569-5193-00 ",.02)
 ;;54569-5193-00
 ;;9002226.02101,"974,54569-5199-00 ",.01)
 ;;54569-5199-00
 ;;9002226.02101,"974,54569-5199-00 ",.02)
 ;;54569-5199-00
 ;;9002226.02101,"974,54569-5214-00 ",.01)
 ;;54569-5214-00
 ;;9002226.02101,"974,54569-5214-00 ",.02)
 ;;54569-5214-00
 ;;9002226.02101,"974,54569-5214-01 ",.01)
 ;;54569-5214-01
 ;;9002226.02101,"974,54569-5214-01 ",.02)
 ;;54569-5214-01
 ;;9002226.02101,"974,54569-5215-00 ",.01)
 ;;54569-5215-00
 ;;9002226.02101,"974,54569-5215-00 ",.02)
 ;;54569-5215-00
 ;;9002226.02101,"974,54569-5314-00 ",.01)
 ;;54569-5314-00
 ;;9002226.02101,"974,54569-5314-00 ",.02)
 ;;54569-5314-00
 ;;9002226.02101,"974,54569-5344-00 ",.01)
 ;;54569-5344-00
 ;;9002226.02101,"974,54569-5344-00 ",.02)
 ;;54569-5344-00
 ;;9002226.02101,"974,54569-5386-00 ",.01)
 ;;54569-5386-00
 ;;9002226.02101,"974,54569-5386-00 ",.02)
 ;;54569-5386-00
 ;;9002226.02101,"974,54569-5386-01 ",.01)
 ;;54569-5386-01
 ;;9002226.02101,"974,54569-5386-01 ",.02)
 ;;54569-5386-01
 ;;9002226.02101,"974,54569-5418-00 ",.01)
 ;;54569-5418-00
 ;;9002226.02101,"974,54569-5418-00 ",.02)
 ;;54569-5418-00
 ;;9002226.02101,"974,54569-5448-00 ",.01)
 ;;54569-5448-00
 ;;9002226.02101,"974,54569-5448-00 ",.02)
 ;;54569-5448-00
 ;;9002226.02101,"974,54569-5518-00 ",.01)
 ;;54569-5518-00
 ;;9002226.02101,"974,54569-5518-00 ",.02)
 ;;54569-5518-00
 ;;9002226.02101,"974,54569-5522-00 ",.01)
 ;;54569-5522-00
 ;;9002226.02101,"974,54569-5522-00 ",.02)
 ;;54569-5522-00
 ;;9002226.02101,"974,54569-5649-00 ",.01)
 ;;54569-5649-00
 ;;9002226.02101,"974,54569-5649-00 ",.02)
 ;;54569-5649-00
 ;;9002226.02101,"974,54569-5650-00 ",.01)
 ;;54569-5650-00
 ;;9002226.02101,"974,54569-5650-00 ",.02)
 ;;54569-5650-00
 ;;9002226.02101,"974,54569-5754-00 ",.01)
 ;;54569-5754-00
 ;;9002226.02101,"974,54569-5754-00 ",.02)
 ;;54569-5754-00
 ;;9002226.02101,"974,54569-5755-00 ",.01)
 ;;54569-5755-00
 ;;9002226.02101,"974,54569-5755-00 ",.02)
 ;;54569-5755-00
 ;;9002226.02101,"974,54569-6448-00 ",.01)
 ;;54569-6448-00
 ;;9002226.02101,"974,54569-6448-00 ",.02)
 ;;54569-6448-00
 ;;9002226.02101,"974,54569-8004-00 ",.01)
 ;;54569-8004-00
 ;;9002226.02101,"974,54569-8004-00 ",.02)
 ;;54569-8004-00
 ;;9002226.02101,"974,54569-8021-00 ",.01)
 ;;54569-8021-00
 ;;9002226.02101,"974,54569-8021-00 ",.02)
 ;;54569-8021-00
 ;;9002226.02101,"974,54807-0251-20 ",.01)
 ;;54807-0251-20
 ;;9002226.02101,"974,54807-0251-20 ",.02)
 ;;54807-0251-20
 ;;9002226.02101,"974,54868-0018-00 ",.01)
 ;;54868-0018-00
 ;;9002226.02101,"974,54868-0018-00 ",.02)
 ;;54868-0018-00
 ;;9002226.02101,"974,54868-0018-01 ",.01)
 ;;54868-0018-01
 ;;9002226.02101,"974,54868-0018-01 ",.02)
 ;;54868-0018-01
 ;;9002226.02101,"974,54868-0018-03 ",.01)
 ;;54868-0018-03
 ;;9002226.02101,"974,54868-0018-03 ",.02)
 ;;54868-0018-03
 ;;9002226.02101,"974,54868-0018-04 ",.01)
 ;;54868-0018-04
 ;;9002226.02101,"974,54868-0018-04 ",.02)
 ;;54868-0018-04
 ;;9002226.02101,"974,54868-0018-06 ",.01)
 ;;54868-0018-06
 ;;9002226.02101,"974,54868-0018-06 ",.02)
 ;;54868-0018-06
 ;;9002226.02101,"974,54868-0018-07 ",.01)
 ;;54868-0018-07
 ;;9002226.02101,"974,54868-0018-07 ",.02)
 ;;54868-0018-07
 ;;9002226.02101,"974,54868-0018-09 ",.01)
 ;;54868-0018-09
 ;;9002226.02101,"974,54868-0018-09 ",.02)
 ;;54868-0018-09
 ;;9002226.02101,"974,54868-0021-00 ",.01)
 ;;54868-0021-00
 ;;9002226.02101,"974,54868-0021-00 ",.02)
 ;;54868-0021-00
 ;;9002226.02101,"974,54868-0021-01 ",.01)
 ;;54868-0021-01
 ;;9002226.02101,"974,54868-0021-01 ",.02)
 ;;54868-0021-01
 ;;9002226.02101,"974,54868-0021-04 ",.01)
 ;;54868-0021-04
 ;;9002226.02101,"974,54868-0021-04 ",.02)
 ;;54868-0021-04
 ;;9002226.02101,"974,54868-0021-05 ",.01)
 ;;54868-0021-05
 ;;9002226.02101,"974,54868-0021-05 ",.02)
 ;;54868-0021-05
 ;;9002226.02101,"974,54868-0021-06 ",.01)
 ;;54868-0021-06
 ;;9002226.02101,"974,54868-0021-06 ",.02)
 ;;54868-0021-06
 ;;9002226.02101,"974,54868-0021-07 ",.01)
 ;;54868-0021-07
 ;;9002226.02101,"974,54868-0021-07 ",.02)
 ;;54868-0021-07
 ;;9002226.02101,"974,54868-0021-09 ",.01)
 ;;54868-0021-09
 ;;9002226.02101,"974,54868-0021-09 ",.02)
 ;;54868-0021-09
 ;;9002226.02101,"974,54868-0023-00 ",.01)
 ;;54868-0023-00
 ;;9002226.02101,"974,54868-0023-00 ",.02)
 ;;54868-0023-00
 ;;9002226.02101,"974,54868-0023-01 ",.01)
 ;;54868-0023-01
 ;;9002226.02101,"974,54868-0023-01 ",.02)
 ;;54868-0023-01
 ;;9002226.02101,"974,54868-0023-02 ",.01)
 ;;54868-0023-02
 ;;9002226.02101,"974,54868-0023-02 ",.02)
 ;;54868-0023-02
 ;;9002226.02101,"974,54868-0023-03 ",.01)
 ;;54868-0023-03
 ;;9002226.02101,"974,54868-0023-03 ",.02)
 ;;54868-0023-03
 ;;9002226.02101,"974,54868-0023-05 ",.01)
 ;;54868-0023-05
 ;;9002226.02101,"974,54868-0023-05 ",.02)
 ;;54868-0023-05
 ;;9002226.02101,"974,54868-0023-06 ",.01)
 ;;54868-0023-06
 ;;9002226.02101,"974,54868-0023-06 ",.02)
 ;;54868-0023-06
 ;;9002226.02101,"974,54868-0023-08 ",.01)
 ;;54868-0023-08
 ;;9002226.02101,"974,54868-0023-08 ",.02)
 ;;54868-0023-08
 ;;9002226.02101,"974,54868-0023-09 ",.01)
 ;;54868-0023-09
 ;;9002226.02101,"974,54868-0023-09 ",.02)
 ;;54868-0023-09
 ;;9002226.02101,"974,54868-0024-01 ",.01)
 ;;54868-0024-01
 ;;9002226.02101,"974,54868-0024-01 ",.02)
 ;;54868-0024-01
 ;;9002226.02101,"974,54868-0024-03 ",.01)
 ;;54868-0024-03
 ;;9002226.02101,"974,54868-0024-03 ",.02)
 ;;54868-0024-03
 ;;9002226.02101,"974,54868-0024-04 ",.01)
 ;;54868-0024-04
 ;;9002226.02101,"974,54868-0024-04 ",.02)
 ;;54868-0024-04
 ;;9002226.02101,"974,54868-0024-05 ",.01)
 ;;54868-0024-05
 ;;9002226.02101,"974,54868-0024-05 ",.02)
 ;;54868-0024-05
 ;;9002226.02101,"974,54868-0024-07 ",.01)
 ;;54868-0024-07
 ;;9002226.02101,"974,54868-0024-07 ",.02)
 ;;54868-0024-07
 ;;9002226.02101,"974,54868-0024-08 ",.01)
 ;;54868-0024-08
 ;;9002226.02101,"974,54868-0024-08 ",.02)
 ;;54868-0024-08
 ;;9002226.02101,"974,54868-0025-00 ",.01)
 ;;54868-0025-00
 ;;9002226.02101,"974,54868-0025-00 ",.02)
 ;;54868-0025-00
 ;;9002226.02101,"974,54868-0025-01 ",.01)
 ;;54868-0025-01
 ;;9002226.02101,"974,54868-0025-01 ",.02)
 ;;54868-0025-01
 ;;9002226.02101,"974,54868-0025-03 ",.01)
 ;;54868-0025-03
 ;;9002226.02101,"974,54868-0025-03 ",.02)
 ;;54868-0025-03
 ;;9002226.02101,"974,54868-0025-04 ",.01)
 ;;54868-0025-04
 ;;9002226.02101,"974,54868-0025-04 ",.02)
 ;;54868-0025-04
 ;;9002226.02101,"974,54868-0025-05 ",.01)
 ;;54868-0025-05
 ;;9002226.02101,"974,54868-0025-05 ",.02)
 ;;54868-0025-05
 ;;9002226.02101,"974,54868-0025-07 ",.01)
 ;;54868-0025-07
 ;;9002226.02101,"974,54868-0025-07 ",.02)
 ;;54868-0025-07