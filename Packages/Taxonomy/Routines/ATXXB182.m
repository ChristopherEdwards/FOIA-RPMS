ATXXB182 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,B33JYZZ ",.02)
 ;;B33JYZZ 
 ;;9002226.02101,"1804,B33JYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33JZZZ ",.01)
 ;;B33JZZZ 
 ;;9002226.02101,"1804,B33JZZZ ",.02)
 ;;B33JZZZ 
 ;;9002226.02101,"1804,B33JZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33KY0Z ",.01)
 ;;B33KY0Z 
 ;;9002226.02101,"1804,B33KY0Z ",.02)
 ;;B33KY0Z 
 ;;9002226.02101,"1804,B33KY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,B33KYZZ ",.01)
 ;;B33KYZZ 
 ;;9002226.02101,"1804,B33KYZZ ",.02)
 ;;B33KYZZ 
 ;;9002226.02101,"1804,B33KYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33KZZZ ",.01)
 ;;B33KZZZ 
 ;;9002226.02101,"1804,B33KZZZ ",.02)
 ;;B33KZZZ 
 ;;9002226.02101,"1804,B33KZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33MY0Z ",.01)
 ;;B33MY0Z 
 ;;9002226.02101,"1804,B33MY0Z ",.02)
 ;;B33MY0Z 
 ;;9002226.02101,"1804,B33MY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,B33MYZZ ",.01)
 ;;B33MYZZ 
 ;;9002226.02101,"1804,B33MYZZ ",.02)
 ;;B33MYZZ 
 ;;9002226.02101,"1804,B33MYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33MZZZ ",.01)
 ;;B33MZZZ 
 ;;9002226.02101,"1804,B33MZZZ ",.02)
 ;;B33MZZZ 
 ;;9002226.02101,"1804,B33MZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33QY0Z ",.01)
 ;;B33QY0Z 
 ;;9002226.02101,"1804,B33QY0Z ",.02)
 ;;B33QY0Z 
 ;;9002226.02101,"1804,B33QY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,B33QYZZ ",.01)
 ;;B33QYZZ 
 ;;9002226.02101,"1804,B33QYZZ ",.02)
 ;;B33QYZZ 
 ;;9002226.02101,"1804,B33QYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33QZZZ ",.01)
 ;;B33QZZZ 
 ;;9002226.02101,"1804,B33QZZZ ",.02)
 ;;B33QZZZ 
 ;;9002226.02101,"1804,B33QZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33RY0Z ",.01)
 ;;B33RY0Z 
 ;;9002226.02101,"1804,B33RY0Z ",.02)
 ;;B33RY0Z 
 ;;9002226.02101,"1804,B33RY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,B33RYZZ ",.01)
 ;;B33RYZZ 
 ;;9002226.02101,"1804,B33RYZZ ",.02)
 ;;B33RYZZ 
 ;;9002226.02101,"1804,B33RYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B33RZZZ ",.01)
 ;;B33RZZZ 
 ;;9002226.02101,"1804,B33RZZZ ",.02)
 ;;B33RZZZ 
 ;;9002226.02101,"1804,B33RZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B340ZZZ ",.01)
 ;;B340ZZZ 
 ;;9002226.02101,"1804,B340ZZZ ",.02)
 ;;B340ZZZ 
 ;;9002226.02101,"1804,B340ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B341ZZZ ",.01)
 ;;B341ZZZ 
 ;;9002226.02101,"1804,B341ZZZ ",.02)
 ;;B341ZZZ 
 ;;9002226.02101,"1804,B341ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B342ZZZ ",.01)
 ;;B342ZZZ 
 ;;9002226.02101,"1804,B342ZZZ ",.02)
 ;;B342ZZZ 
 ;;9002226.02101,"1804,B342ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B343ZZZ ",.01)
 ;;B343ZZZ 
 ;;9002226.02101,"1804,B343ZZZ ",.02)
 ;;B343ZZZ 
 ;;9002226.02101,"1804,B343ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B344ZZZ ",.01)
 ;;B344ZZZ 
 ;;9002226.02101,"1804,B344ZZZ ",.02)
 ;;B344ZZZ 
 ;;9002226.02101,"1804,B344ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B345ZZZ ",.01)
 ;;B345ZZZ 
 ;;9002226.02101,"1804,B345ZZZ ",.02)
 ;;B345ZZZ 
 ;;9002226.02101,"1804,B345ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B346ZZZ ",.01)
 ;;B346ZZZ 
 ;;9002226.02101,"1804,B346ZZZ ",.02)
 ;;B346ZZZ 
 ;;9002226.02101,"1804,B346ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B347ZZZ ",.01)
 ;;B347ZZZ 
 ;;9002226.02101,"1804,B347ZZZ ",.02)
 ;;B347ZZZ 
 ;;9002226.02101,"1804,B347ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B348ZZZ ",.01)
 ;;B348ZZZ 
 ;;9002226.02101,"1804,B348ZZZ ",.02)
 ;;B348ZZZ 
 ;;9002226.02101,"1804,B348ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34HZZZ ",.01)
 ;;B34HZZZ 
 ;;9002226.02101,"1804,B34HZZZ ",.02)
 ;;B34HZZZ 
 ;;9002226.02101,"1804,B34HZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34JZZZ ",.01)
 ;;B34JZZZ 
 ;;9002226.02101,"1804,B34JZZZ ",.02)
 ;;B34JZZZ 
 ;;9002226.02101,"1804,B34JZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34KZZZ ",.01)
 ;;B34KZZZ 
 ;;9002226.02101,"1804,B34KZZZ ",.02)
 ;;B34KZZZ 
 ;;9002226.02101,"1804,B34KZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34RZZZ ",.01)
 ;;B34RZZZ 
 ;;9002226.02101,"1804,B34RZZZ ",.02)
 ;;B34RZZZ 
 ;;9002226.02101,"1804,B34RZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34SZZZ ",.01)
 ;;B34SZZZ 
 ;;9002226.02101,"1804,B34SZZZ ",.02)
 ;;B34SZZZ 
 ;;9002226.02101,"1804,B34SZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34TZZZ ",.01)
 ;;B34TZZZ 
 ;;9002226.02101,"1804,B34TZZZ ",.02)
 ;;B34TZZZ 
 ;;9002226.02101,"1804,B34TZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B34VZZZ ",.01)
 ;;B34VZZZ 
 ;;9002226.02101,"1804,B34VZZZ ",.02)
 ;;B34VZZZ 
 ;;9002226.02101,"1804,B34VZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4000ZZ ",.01)
 ;;B4000ZZ 
 ;;9002226.02101,"1804,B4000ZZ ",.02)
 ;;B4000ZZ 
 ;;9002226.02101,"1804,B4000ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4001ZZ ",.01)
 ;;B4001ZZ 
 ;;9002226.02101,"1804,B4001ZZ ",.02)
 ;;B4001ZZ 
 ;;9002226.02101,"1804,B4001ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B400YZZ ",.01)
 ;;B400YZZ 
 ;;9002226.02101,"1804,B400YZZ ",.02)
 ;;B400YZZ 
 ;;9002226.02101,"1804,B400YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4020ZZ ",.01)
 ;;B4020ZZ 
 ;;9002226.02101,"1804,B4020ZZ ",.02)
 ;;B4020ZZ 
 ;;9002226.02101,"1804,B4020ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4021ZZ ",.01)
 ;;B4021ZZ 
 ;;9002226.02101,"1804,B4021ZZ ",.02)
 ;;B4021ZZ 
 ;;9002226.02101,"1804,B4021ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B402YZZ ",.01)
 ;;B402YZZ 
 ;;9002226.02101,"1804,B402YZZ ",.02)
 ;;B402YZZ 
 ;;9002226.02101,"1804,B402YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4030ZZ ",.01)
 ;;B4030ZZ 
 ;;9002226.02101,"1804,B4030ZZ ",.02)
 ;;B4030ZZ 
 ;;9002226.02101,"1804,B4030ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4031ZZ ",.01)
 ;;B4031ZZ 
 ;;9002226.02101,"1804,B4031ZZ ",.02)
 ;;B4031ZZ 
 ;;9002226.02101,"1804,B4031ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B403YZZ ",.01)
 ;;B403YZZ 
 ;;9002226.02101,"1804,B403YZZ ",.02)
 ;;B403YZZ 
 ;;9002226.02101,"1804,B403YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4040ZZ ",.01)
 ;;B4040ZZ 
 ;;9002226.02101,"1804,B4040ZZ ",.02)
 ;;B4040ZZ 
 ;;9002226.02101,"1804,B4040ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4041ZZ ",.01)
 ;;B4041ZZ 
 ;;9002226.02101,"1804,B4041ZZ ",.02)
 ;;B4041ZZ 
 ;;9002226.02101,"1804,B4041ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B404YZZ ",.01)
 ;;B404YZZ 
 ;;9002226.02101,"1804,B404YZZ ",.02)
 ;;B404YZZ 
 ;;9002226.02101,"1804,B404YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4050ZZ ",.01)
 ;;B4050ZZ 
 ;;9002226.02101,"1804,B4050ZZ ",.02)
 ;;B4050ZZ 
 ;;9002226.02101,"1804,B4050ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4051ZZ ",.01)
 ;;B4051ZZ 
 ;;9002226.02101,"1804,B4051ZZ ",.02)
 ;;B4051ZZ 
 ;;9002226.02101,"1804,B4051ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B405YZZ ",.01)
 ;;B405YZZ 
 ;;9002226.02101,"1804,B405YZZ ",.02)
 ;;B405YZZ 
 ;;9002226.02101,"1804,B405YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4060ZZ ",.01)
 ;;B4060ZZ 
 ;;9002226.02101,"1804,B4060ZZ ",.02)
 ;;B4060ZZ 
 ;;9002226.02101,"1804,B4060ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4061ZZ ",.01)
 ;;B4061ZZ 
 ;;9002226.02101,"1804,B4061ZZ ",.02)
 ;;B4061ZZ 
 ;;9002226.02101,"1804,B4061ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B406YZZ ",.01)
 ;;B406YZZ 
 ;;9002226.02101,"1804,B406YZZ ",.02)
 ;;B406YZZ 
 ;;9002226.02101,"1804,B406YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4070ZZ ",.01)
 ;;B4070ZZ 
 ;;9002226.02101,"1804,B4070ZZ ",.02)
 ;;B4070ZZ 
 ;;9002226.02101,"1804,B4070ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4071ZZ ",.01)
 ;;B4071ZZ 
 ;;9002226.02101,"1804,B4071ZZ ",.02)
 ;;B4071ZZ 
 ;;9002226.02101,"1804,B4071ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B407YZZ ",.01)
 ;;B407YZZ 
 ;;9002226.02101,"1804,B407YZZ ",.02)
 ;;B407YZZ 
 ;;9002226.02101,"1804,B407YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4080ZZ ",.01)
 ;;B4080ZZ 
 ;;9002226.02101,"1804,B4080ZZ ",.02)
 ;;B4080ZZ 
 ;;9002226.02101,"1804,B4080ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4081ZZ ",.01)
 ;;B4081ZZ 
 ;;9002226.02101,"1804,B4081ZZ ",.02)
 ;;B4081ZZ 
 ;;9002226.02101,"1804,B4081ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B408YZZ ",.01)
 ;;B408YZZ 
 ;;9002226.02101,"1804,B408YZZ ",.02)
 ;;B408YZZ 
 ;;9002226.02101,"1804,B408YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4090ZZ ",.01)
 ;;B4090ZZ 
 ;;9002226.02101,"1804,B4090ZZ ",.02)
 ;;B4090ZZ 
 ;;9002226.02101,"1804,B4090ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4091ZZ ",.01)
 ;;B4091ZZ 
 ;;9002226.02101,"1804,B4091ZZ ",.02)
 ;;B4091ZZ 
 ;;9002226.02101,"1804,B4091ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B409YZZ ",.01)
 ;;B409YZZ 
 ;;9002226.02101,"1804,B409YZZ ",.02)
 ;;B409YZZ 
 ;;9002226.02101,"1804,B409YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40B0ZZ ",.01)
 ;;B40B0ZZ 
 ;;9002226.02101,"1804,B40B0ZZ ",.02)
 ;;B40B0ZZ 
 ;;9002226.02101,"1804,B40B0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40B1ZZ ",.01)
 ;;B40B1ZZ 
 ;;9002226.02101,"1804,B40B1ZZ ",.02)
 ;;B40B1ZZ 
 ;;9002226.02101,"1804,B40B1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40BYZZ ",.01)
 ;;B40BYZZ 
 ;;9002226.02101,"1804,B40BYZZ ",.02)
 ;;B40BYZZ 
 ;;9002226.02101,"1804,B40BYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40C0ZZ ",.01)
 ;;B40C0ZZ 
 ;;9002226.02101,"1804,B40C0ZZ ",.02)
 ;;B40C0ZZ 
 ;;9002226.02101,"1804,B40C0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40C1ZZ ",.01)
 ;;B40C1ZZ 
 ;;9002226.02101,"1804,B40C1ZZ ",.02)
 ;;B40C1ZZ 
 ;;9002226.02101,"1804,B40C1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40CYZZ ",.01)
 ;;B40CYZZ 
 ;;9002226.02101,"1804,B40CYZZ ",.02)
 ;;B40CYZZ 
 ;;9002226.02101,"1804,B40CYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40D0ZZ ",.01)
 ;;B40D0ZZ 
 ;;9002226.02101,"1804,B40D0ZZ ",.02)
 ;;B40D0ZZ 
 ;;9002226.02101,"1804,B40D0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40D1ZZ ",.01)
 ;;B40D1ZZ 
 ;;9002226.02101,"1804,B40D1ZZ ",.02)
 ;;B40D1ZZ 
 ;;9002226.02101,"1804,B40D1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40DYZZ ",.01)
 ;;B40DYZZ 
 ;;9002226.02101,"1804,B40DYZZ ",.02)
 ;;B40DYZZ 
 ;;9002226.02101,"1804,B40DYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40F0ZZ ",.01)
 ;;B40F0ZZ 
 ;;9002226.02101,"1804,B40F0ZZ ",.02)
 ;;B40F0ZZ 
 ;;9002226.02101,"1804,B40F0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40F1ZZ ",.01)
 ;;B40F1ZZ 
 ;;9002226.02101,"1804,B40F1ZZ ",.02)
 ;;B40F1ZZ 
 ;;9002226.02101,"1804,B40F1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40FYZZ ",.01)
 ;;B40FYZZ 
 ;;9002226.02101,"1804,B40FYZZ ",.02)
 ;;B40FYZZ 
 ;;9002226.02101,"1804,B40FYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40G0ZZ ",.01)
 ;;B40G0ZZ 
 ;;9002226.02101,"1804,B40G0ZZ ",.02)
 ;;B40G0ZZ 
 ;;9002226.02101,"1804,B40G0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40G1ZZ ",.01)
 ;;B40G1ZZ 
 ;;9002226.02101,"1804,B40G1ZZ ",.02)
 ;;B40G1ZZ 
 ;;9002226.02101,"1804,B40G1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40GYZZ ",.01)
 ;;B40GYZZ 
 ;;9002226.02101,"1804,B40GYZZ ",.02)
 ;;B40GYZZ 
 ;;9002226.02101,"1804,B40GYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40J0ZZ ",.01)
 ;;B40J0ZZ 
 ;;9002226.02101,"1804,B40J0ZZ ",.02)
 ;;B40J0ZZ 
 ;;9002226.02101,"1804,B40J0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40J1ZZ ",.01)
 ;;B40J1ZZ 
 ;;9002226.02101,"1804,B40J1ZZ ",.02)
 ;;B40J1ZZ 
 ;;9002226.02101,"1804,B40J1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40JYZZ ",.01)
 ;;B40JYZZ 
 ;;9002226.02101,"1804,B40JYZZ ",.02)
 ;;B40JYZZ 
 ;;9002226.02101,"1804,B40JYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40M0ZZ ",.01)
 ;;B40M0ZZ 
 ;;9002226.02101,"1804,B40M0ZZ ",.02)
 ;;B40M0ZZ 
 ;;9002226.02101,"1804,B40M0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40M1ZZ ",.01)
 ;;B40M1ZZ 
 ;;9002226.02101,"1804,B40M1ZZ ",.02)
 ;;B40M1ZZ 
 ;;9002226.02101,"1804,B40M1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B40MYZZ ",.01)
 ;;B40MYZZ 
 ;;9002226.02101,"1804,B40MYZZ ",.02)
 ;;B40MYZZ 
 ;;9002226.02101,"1804,B40MYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,B4100ZZ ",.01)
 ;;B4100ZZ 
 ;;9002226.02101,"1804,B4100ZZ ",.02)
 ;;B4100ZZ 