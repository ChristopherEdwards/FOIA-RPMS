BGP2TA10 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1064,00172-4195-80 ",.02)
 ;;00172-4195-80
 ;;9002226.02101,"1064,00172-4196-10 ",.01)
 ;;00172-4196-10
 ;;9002226.02101,"1064,00172-4196-10 ",.02)
 ;;00172-4196-10
 ;;9002226.02101,"1064,00172-4196-60 ",.01)
 ;;00172-4196-60
 ;;9002226.02101,"1064,00172-4196-60 ",.02)
 ;;00172-4196-60
 ;;9002226.02101,"1064,00172-4196-80 ",.01)
 ;;00172-4196-80
 ;;9002226.02101,"1064,00172-4196-80 ",.02)
 ;;00172-4196-80
 ;;9002226.02101,"1064,00172-4196-85 ",.01)
 ;;00172-4196-85
 ;;9002226.02101,"1064,00172-4196-85 ",.02)
 ;;00172-4196-85
 ;;9002226.02101,"1064,00172-4197-10 ",.01)
 ;;00172-4197-10
 ;;9002226.02101,"1064,00172-4197-10 ",.02)
 ;;00172-4197-10
 ;;9002226.02101,"1064,00172-4197-60 ",.01)
 ;;00172-4197-60
 ;;9002226.02101,"1064,00172-4197-60 ",.02)
 ;;00172-4197-60
 ;;9002226.02101,"1064,00172-4197-80 ",.01)
 ;;00172-4197-80
 ;;9002226.02101,"1064,00172-4197-80 ",.02)
 ;;00172-4197-80
 ;;9002226.02101,"1064,00172-4198-00 ",.01)
 ;;00172-4198-00
 ;;9002226.02101,"1064,00172-4198-00 ",.02)
 ;;00172-4198-00
 ;;9002226.02101,"1064,00172-4198-10 ",.01)
 ;;00172-4198-10
 ;;9002226.02101,"1064,00172-4198-10 ",.02)
 ;;00172-4198-10
 ;;9002226.02101,"1064,00172-4198-60 ",.01)
 ;;00172-4198-60
 ;;9002226.02101,"1064,00172-4198-60 ",.02)
 ;;00172-4198-60
 ;;9002226.02101,"1064,00172-4198-80 ",.01)
 ;;00172-4198-80
 ;;9002226.02101,"1064,00172-4198-80 ",.02)
 ;;00172-4198-80
 ;;9002226.02101,"1064,00172-5032-00 ",.01)
 ;;00172-5032-00
 ;;9002226.02101,"1064,00172-5032-00 ",.02)
 ;;00172-5032-00
 ;;9002226.02101,"1064,00172-5032-10 ",.01)
 ;;00172-5032-10
 ;;9002226.02101,"1064,00172-5032-10 ",.02)
 ;;00172-5032-10
 ;;9002226.02101,"1064,00172-5032-60 ",.01)
 ;;00172-5032-60
 ;;9002226.02101,"1064,00172-5032-60 ",.02)
 ;;00172-5032-60
 ;;9002226.02101,"1064,00172-5032-70 ",.01)
 ;;00172-5032-70
 ;;9002226.02101,"1064,00172-5032-70 ",.02)
 ;;00172-5032-70
 ;;9002226.02101,"1064,00172-5033-00 ",.01)
 ;;00172-5033-00
 ;;9002226.02101,"1064,00172-5033-00 ",.02)
 ;;00172-5033-00
 ;;9002226.02101,"1064,00172-5033-10 ",.01)
 ;;00172-5033-10
 ;;9002226.02101,"1064,00172-5033-10 ",.02)
 ;;00172-5033-10
 ;;9002226.02101,"1064,00172-5033-60 ",.01)
 ;;00172-5033-60
 ;;9002226.02101,"1064,00172-5033-60 ",.02)
 ;;00172-5033-60
 ;;9002226.02101,"1064,00172-5033-70 ",.01)
 ;;00172-5033-70
 ;;9002226.02101,"1064,00172-5033-70 ",.02)
 ;;00172-5033-70
 ;;9002226.02101,"1064,00172-5034-00 ",.01)
 ;;00172-5034-00
 ;;9002226.02101,"1064,00172-5034-00 ",.02)
 ;;00172-5034-00
 ;;9002226.02101,"1064,00172-5034-10 ",.01)
 ;;00172-5034-10
 ;;9002226.02101,"1064,00172-5034-10 ",.02)
 ;;00172-5034-10
 ;;9002226.02101,"1064,00172-5034-60 ",.01)
 ;;00172-5034-60
 ;;9002226.02101,"1064,00172-5034-60 ",.02)
 ;;00172-5034-60
 ;;9002226.02101,"1064,00172-5034-70 ",.01)
 ;;00172-5034-70
 ;;9002226.02101,"1064,00172-5034-70 ",.02)
 ;;00172-5034-70
 ;;9002226.02101,"1064,00172-5350-60 ",.01)
 ;;00172-5350-60
 ;;9002226.02101,"1064,00172-5350-60 ",.02)
 ;;00172-5350-60
 ;;9002226.02101,"1064,00172-5351-10 ",.01)
 ;;00172-5351-10
 ;;9002226.02101,"1064,00172-5351-10 ",.02)
 ;;00172-5351-10
 ;;9002226.02101,"1064,00172-5351-60 ",.01)
 ;;00172-5351-60
 ;;9002226.02101,"1064,00172-5351-60 ",.02)
 ;;00172-5351-60
 ;;9002226.02101,"1064,00172-5352-60 ",.01)
 ;;00172-5352-60
 ;;9002226.02101,"1064,00172-5352-60 ",.02)
 ;;00172-5352-60
 ;;9002226.02101,"1064,00172-5353-60 ",.01)
 ;;00172-5353-60
 ;;9002226.02101,"1064,00172-5353-60 ",.02)
 ;;00172-5353-60
 ;;9002226.02101,"1064,00172-5360-60 ",.01)
 ;;00172-5360-60
 ;;9002226.02101,"1064,00172-5360-60 ",.02)
 ;;00172-5360-60
 ;;9002226.02101,"1064,00172-5361-60 ",.01)
 ;;00172-5361-60
 ;;9002226.02101,"1064,00172-5361-60 ",.02)
 ;;00172-5361-60
 ;;9002226.02101,"1064,00172-5361-70 ",.01)
 ;;00172-5361-70
 ;;9002226.02101,"1064,00172-5361-70 ",.02)
 ;;00172-5361-70
 ;;9002226.02101,"1064,00172-5362-60 ",.01)
 ;;00172-5362-60
 ;;9002226.02101,"1064,00172-5362-60 ",.02)
 ;;00172-5362-60
 ;;9002226.02101,"1064,00172-5362-70 ",.01)
 ;;00172-5362-70
 ;;9002226.02101,"1064,00172-5362-70 ",.02)
 ;;00172-5362-70
 ;;9002226.02101,"1064,00172-5363-60 ",.01)
 ;;00172-5363-60
 ;;9002226.02101,"1064,00172-5363-60 ",.02)
 ;;00172-5363-60
 ;;9002226.02101,"1064,00172-5363-70 ",.01)
 ;;00172-5363-70
 ;;9002226.02101,"1064,00172-5363-70 ",.02)
 ;;00172-5363-70
 ;;9002226.02101,"1064,00182-2622-01 ",.01)
 ;;00182-2622-01
 ;;9002226.02101,"1064,00182-2622-01 ",.02)
 ;;00182-2622-01
 ;;9002226.02101,"1064,00182-2622-05 ",.01)
 ;;00182-2622-05
 ;;9002226.02101,"1064,00182-2622-05 ",.02)
 ;;00182-2622-05
 ;;9002226.02101,"1064,00182-2622-10 ",.01)
 ;;00182-2622-10
 ;;9002226.02101,"1064,00182-2622-10 ",.02)
 ;;00182-2622-10
 ;;9002226.02101,"1064,00182-2623-01 ",.01)
 ;;00182-2623-01
 ;;9002226.02101,"1064,00182-2623-01 ",.02)
 ;;00182-2623-01
 ;;9002226.02101,"1064,00182-2623-05 ",.01)
 ;;00182-2623-05
 ;;9002226.02101,"1064,00182-2623-05 ",.02)
 ;;00182-2623-05
 ;;9002226.02101,"1064,00182-2623-10 ",.01)
 ;;00182-2623-10
 ;;9002226.02101,"1064,00182-2623-10 ",.02)
 ;;00182-2623-10
 ;;9002226.02101,"1064,00182-2623-89 ",.01)
 ;;00182-2623-89
 ;;9002226.02101,"1064,00182-2623-89 ",.02)
 ;;00182-2623-89
 ;;9002226.02101,"1064,00182-2624-01 ",.01)
 ;;00182-2624-01
 ;;9002226.02101,"1064,00182-2624-01 ",.02)
 ;;00182-2624-01
 ;;9002226.02101,"1064,00182-2624-05 ",.01)
 ;;00182-2624-05
 ;;9002226.02101,"1064,00182-2624-05 ",.02)
 ;;00182-2624-05
 ;;9002226.02101,"1064,00182-2624-10 ",.01)
 ;;00182-2624-10
 ;;9002226.02101,"1064,00182-2624-10 ",.02)
 ;;00182-2624-10
 ;;9002226.02101,"1064,00182-2625-01 ",.01)
 ;;00182-2625-01
 ;;9002226.02101,"1064,00182-2625-01 ",.02)
 ;;00182-2625-01
 ;;9002226.02101,"1064,00185-0025-01 ",.01)
 ;;00185-0025-01
 ;;9002226.02101,"1064,00185-0025-01 ",.02)
 ;;00185-0025-01
 ;;9002226.02101,"1064,00185-0025-10 ",.01)
 ;;00185-0025-10
 ;;9002226.02101,"1064,00185-0025-10 ",.02)
 ;;00185-0025-10
 ;;9002226.02101,"1064,00185-0041-09 ",.01)
 ;;00185-0041-09
 ;;9002226.02101,"1064,00185-0041-09 ",.02)
 ;;00185-0041-09
 ;;9002226.02101,"1064,00185-0041-10 ",.01)
 ;;00185-0041-10
 ;;9002226.02101,"1064,00185-0041-10 ",.02)
 ;;00185-0041-10
 ;;9002226.02101,"1064,00185-0042-09 ",.01)
 ;;00185-0042-09
 ;;9002226.02101,"1064,00185-0042-09 ",.02)
 ;;00185-0042-09
 ;;9002226.02101,"1064,00185-0042-10 ",.01)
 ;;00185-0042-10
 ;;9002226.02101,"1064,00185-0042-10 ",.02)
 ;;00185-0042-10
 ;;9002226.02101,"1064,00185-0047-09 ",.01)
 ;;00185-0047-09
 ;;9002226.02101,"1064,00185-0047-09 ",.02)
 ;;00185-0047-09
 ;;9002226.02101,"1064,00185-0047-10 ",.01)
 ;;00185-0047-10
 ;;9002226.02101,"1064,00185-0047-10 ",.02)
 ;;00185-0047-10
 ;;9002226.02101,"1064,00185-0048-01 ",.01)
 ;;00185-0048-01
 ;;9002226.02101,"1064,00185-0048-01 ",.02)
 ;;00185-0048-01
 ;;9002226.02101,"1064,00185-0048-05 ",.01)
 ;;00185-0048-05
 ;;9002226.02101,"1064,00185-0048-05 ",.02)
 ;;00185-0048-05
 ;;9002226.02101,"1064,00185-0053-01 ",.01)
 ;;00185-0053-01
 ;;9002226.02101,"1064,00185-0053-01 ",.02)
 ;;00185-0053-01
 ;;9002226.02101,"1064,00185-0053-05 ",.01)
 ;;00185-0053-05
 ;;9002226.02101,"1064,00185-0053-05 ",.02)
 ;;00185-0053-05
 ;;9002226.02101,"1064,00185-0101-01 ",.01)
 ;;00185-0101-01
 ;;9002226.02101,"1064,00185-0101-01 ",.02)
 ;;00185-0101-01
 ;;9002226.02101,"1064,00185-0101-10 ",.01)
 ;;00185-0101-10
 ;;9002226.02101,"1064,00185-0101-10 ",.02)
 ;;00185-0101-10
 ;;9002226.02101,"1064,00185-0101-33 ",.01)
 ;;00185-0101-33
 ;;9002226.02101,"1064,00185-0101-33 ",.02)
 ;;00185-0101-33
 ;;9002226.02101,"1064,00185-0102-01 ",.01)
 ;;00185-0102-01
 ;;9002226.02101,"1064,00185-0102-01 ",.02)
 ;;00185-0102-01
 ;;9002226.02101,"1064,00185-0102-10 ",.01)
 ;;00185-0102-10
 ;;9002226.02101,"1064,00185-0102-10 ",.02)
 ;;00185-0102-10
 ;;9002226.02101,"1064,00185-0102-33 ",.01)
 ;;00185-0102-33
 ;;9002226.02101,"1064,00185-0102-33 ",.02)
 ;;00185-0102-33
 ;;9002226.02101,"1064,00185-0103-01 ",.01)
 ;;00185-0103-01
 ;;9002226.02101,"1064,00185-0103-01 ",.02)
 ;;00185-0103-01
 ;;9002226.02101,"1064,00185-0103-10 ",.01)
 ;;00185-0103-10
 ;;9002226.02101,"1064,00185-0103-10 ",.02)
 ;;00185-0103-10
 ;;9002226.02101,"1064,00185-0104-01 ",.01)
 ;;00185-0104-01
 ;;9002226.02101,"1064,00185-0104-01 ",.02)
 ;;00185-0104-01
 ;;9002226.02101,"1064,00185-0104-10 ",.01)
 ;;00185-0104-10
 ;;9002226.02101,"1064,00185-0104-10 ",.02)
 ;;00185-0104-10
 ;;9002226.02101,"1064,00185-0114-01 ",.01)
 ;;00185-0114-01
 ;;9002226.02101,"1064,00185-0114-01 ",.02)
 ;;00185-0114-01
 ;;9002226.02101,"1064,00185-0114-10 ",.01)
 ;;00185-0114-10
 ;;9002226.02101,"1064,00185-0114-10 ",.02)
 ;;00185-0114-10
 ;;9002226.02101,"1064,00185-0114-50 ",.01)
 ;;00185-0114-50
 ;;9002226.02101,"1064,00185-0114-50 ",.02)
 ;;00185-0114-50
 ;;9002226.02101,"1064,00185-0124-01 ",.01)
 ;;00185-0124-01
 ;;9002226.02101,"1064,00185-0124-01 ",.02)
 ;;00185-0124-01
 ;;9002226.02101,"1064,00185-0127-01 ",.01)
 ;;00185-0127-01
 ;;9002226.02101,"1064,00185-0127-01 ",.02)
 ;;00185-0127-01
 ;;9002226.02101,"1064,00185-0127-10 ",.01)
 ;;00185-0127-10
 ;;9002226.02101,"1064,00185-0127-10 ",.02)
 ;;00185-0127-10
 ;;9002226.02101,"1064,00185-0127-50 ",.01)
 ;;00185-0127-50
 ;;9002226.02101,"1064,00185-0127-50 ",.02)
 ;;00185-0127-50
 ;;9002226.02101,"1064,00185-0147-01 ",.01)
 ;;00185-0147-01
 ;;9002226.02101,"1064,00185-0147-01 ",.02)
 ;;00185-0147-01
 ;;9002226.02101,"1064,00185-0147-10 ",.01)
 ;;00185-0147-10
 ;;9002226.02101,"1064,00185-0147-10 ",.02)
 ;;00185-0147-10
 ;;9002226.02101,"1064,00185-0147-50 ",.01)
 ;;00185-0147-50
 ;;9002226.02101,"1064,00185-0147-50 ",.02)
 ;;00185-0147-50
 ;;9002226.02101,"1064,00185-0151-01 ",.01)
 ;;00185-0151-01
 ;;9002226.02101,"1064,00185-0151-01 ",.02)
 ;;00185-0151-01
 ;;9002226.02101,"1064,00185-0152-01 ",.01)
 ;;00185-0152-01
 ;;9002226.02101,"1064,00185-0152-01 ",.02)
 ;;00185-0152-01
 ;;9002226.02101,"1064,00185-0152-10 ",.01)
 ;;00185-0152-10
 ;;9002226.02101,"1064,00185-0152-10 ",.02)
 ;;00185-0152-10
 ;;9002226.02101,"1064,00185-0172-01 ",.01)
 ;;00185-0172-01
 ;;9002226.02101,"1064,00185-0172-01 ",.02)
 ;;00185-0172-01
 ;;9002226.02101,"1064,00185-0172-10 ",.01)
 ;;00185-0172-10
 ;;9002226.02101,"1064,00185-0172-10 ",.02)
 ;;00185-0172-10
 ;;9002226.02101,"1064,00185-0173-01 ",.01)
 ;;00185-0173-01
 ;;9002226.02101,"1064,00185-0173-01 ",.02)
 ;;00185-0173-01
 ;;9002226.02101,"1064,00185-0173-10 ",.01)
 ;;00185-0173-10
 ;;9002226.02101,"1064,00185-0173-10 ",.02)
 ;;00185-0173-10
 ;;9002226.02101,"1064,00185-0204-01 ",.01)
 ;;00185-0204-01
 ;;9002226.02101,"1064,00185-0204-01 ",.02)
 ;;00185-0204-01
 ;;9002226.02101,"1064,00185-0211-01 ",.01)
 ;;00185-0211-01
 ;;9002226.02101,"1064,00185-0211-01 ",.02)
 ;;00185-0211-01
 ;;9002226.02101,"1064,00185-0214-01 ",.01)
 ;;00185-0214-01
 ;;9002226.02101,"1064,00185-0214-01 ",.02)
 ;;00185-0214-01
 ;;9002226.02101,"1064,00185-0214-10 ",.01)
 ;;00185-0214-10
 ;;9002226.02101,"1064,00185-0214-10 ",.02)
 ;;00185-0214-10
 ;;9002226.02101,"1064,00185-0214-50 ",.01)
 ;;00185-0214-50
 ;;9002226.02101,"1064,00185-0214-50 ",.02)
 ;;00185-0214-50
 ;;9002226.02101,"1064,00185-0277-01 ",.01)
 ;;00185-0277-01
 ;;9002226.02101,"1064,00185-0277-01 ",.02)
 ;;00185-0277-01
 ;;9002226.02101,"1064,00185-0341-01 ",.01)
 ;;00185-0341-01
 ;;9002226.02101,"1064,00185-0341-01 ",.02)
 ;;00185-0341-01
 ;;9002226.02101,"1064,00185-0342-01 ",.01)
 ;;00185-0342-01
 ;;9002226.02101,"1064,00185-0342-01 ",.02)
 ;;00185-0342-01
 ;;9002226.02101,"1064,00185-0505-01 ",.01)
 ;;00185-0505-01
 ;;9002226.02101,"1064,00185-0505-01 ",.02)
 ;;00185-0505-01
 ;;9002226.02101,"1064,00185-0505-05 ",.01)
 ;;00185-0505-05
 ;;9002226.02101,"1064,00185-0505-05 ",.02)
 ;;00185-0505-05
 ;;9002226.02101,"1064,00185-0820-01 ",.01)
 ;;00185-0820-01
 ;;9002226.02101,"1064,00185-0820-01 ",.02)
 ;;00185-0820-01
 ;;9002226.02101,"1064,00185-0820-05 ",.01)
 ;;00185-0820-05
 ;;9002226.02101,"1064,00185-0820-05 ",.02)
 ;;00185-0820-05
 ;;9002226.02101,"1064,00185-5400-01 ",.01)
 ;;00185-5400-01
 ;;9002226.02101,"1064,00185-5400-01 ",.02)
 ;;00185-5400-01
 ;;9002226.02101,"1064,00185-5400-10 ",.01)
 ;;00185-5400-10
 ;;9002226.02101,"1064,00185-5400-10 ",.02)
 ;;00185-5400-10
 ;;9002226.02101,"1064,00185-7100-01 ",.01)
 ;;00185-7100-01
 ;;9002226.02101,"1064,00185-7100-01 ",.02)
 ;;00185-7100-01
 ;;9002226.02101,"1064,00185-7100-10 ",.01)
 ;;00185-7100-10
 ;;9002226.02101,"1064,00185-7100-10 ",.02)
 ;;00185-7100-10
 ;;9002226.02101,"1064,00228-2658-11 ",.01)
 ;;00228-2658-11
 ;;9002226.02101,"1064,00228-2658-11 ",.02)
 ;;00228-2658-11
 ;;9002226.02101,"1064,00228-2658-96 ",.01)
 ;;00228-2658-96
 ;;9002226.02101,"1064,00228-2658-96 ",.02)
 ;;00228-2658-96
 ;;9002226.02101,"1064,00228-2659-11 ",.01)
 ;;00228-2659-11
 ;;9002226.02101,"1064,00228-2659-11 ",.02)
 ;;00228-2659-11
 ;;9002226.02101,"1064,00228-2659-96 ",.01)
 ;;00228-2659-96
 ;;9002226.02101,"1064,00228-2659-96 ",.02)
 ;;00228-2659-96
 ;;9002226.02101,"1064,00228-2660-11 ",.01)
 ;;00228-2660-11
 ;;9002226.02101,"1064,00228-2660-11 ",.02)
 ;;00228-2660-11
 ;;9002226.02101,"1064,00228-2660-96 ",.01)
 ;;00228-2660-96
 ;;9002226.02101,"1064,00228-2660-96 ",.02)
 ;;00228-2660-96
 ;;9002226.02101,"1064,00228-2661-11 ",.01)
 ;;00228-2661-11
 ;;9002226.02101,"1064,00228-2661-11 ",.02)
 ;;00228-2661-11
 ;;9002226.02101,"1064,00228-2661-96 ",.01)
 ;;00228-2661-96
 ;;9002226.02101,"1064,00228-2661-96 ",.02)
 ;;00228-2661-96
