ATXXB200 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1804,BP3EZZZ ",.02)
 ;;BP3EZZZ 
 ;;9002226.02101,"1804,BP3EZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3FY0Z ",.01)
 ;;BP3FY0Z 
 ;;9002226.02101,"1804,BP3FY0Z ",.02)
 ;;BP3FY0Z 
 ;;9002226.02101,"1804,BP3FY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3FYZZ ",.01)
 ;;BP3FYZZ 
 ;;9002226.02101,"1804,BP3FYZZ ",.02)
 ;;BP3FYZZ 
 ;;9002226.02101,"1804,BP3FYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3FZZZ ",.01)
 ;;BP3FZZZ 
 ;;9002226.02101,"1804,BP3FZZZ ",.02)
 ;;BP3FZZZ 
 ;;9002226.02101,"1804,BP3FZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3GY0Z ",.01)
 ;;BP3GY0Z 
 ;;9002226.02101,"1804,BP3GY0Z ",.02)
 ;;BP3GY0Z 
 ;;9002226.02101,"1804,BP3GY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3GYZZ ",.01)
 ;;BP3GYZZ 
 ;;9002226.02101,"1804,BP3GYZZ ",.02)
 ;;BP3GYZZ 
 ;;9002226.02101,"1804,BP3GYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3GZZZ ",.01)
 ;;BP3GZZZ 
 ;;9002226.02101,"1804,BP3GZZZ ",.02)
 ;;BP3GZZZ 
 ;;9002226.02101,"1804,BP3GZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3HY0Z ",.01)
 ;;BP3HY0Z 
 ;;9002226.02101,"1804,BP3HY0Z ",.02)
 ;;BP3HY0Z 
 ;;9002226.02101,"1804,BP3HY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3HYZZ ",.01)
 ;;BP3HYZZ 
 ;;9002226.02101,"1804,BP3HYZZ ",.02)
 ;;BP3HYZZ 
 ;;9002226.02101,"1804,BP3HYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3HZZZ ",.01)
 ;;BP3HZZZ 
 ;;9002226.02101,"1804,BP3HZZZ ",.02)
 ;;BP3HZZZ 
 ;;9002226.02101,"1804,BP3HZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3JY0Z ",.01)
 ;;BP3JY0Z 
 ;;9002226.02101,"1804,BP3JY0Z ",.02)
 ;;BP3JY0Z 
 ;;9002226.02101,"1804,BP3JY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3JYZZ ",.01)
 ;;BP3JYZZ 
 ;;9002226.02101,"1804,BP3JYZZ ",.02)
 ;;BP3JYZZ 
 ;;9002226.02101,"1804,BP3JYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3JZZZ ",.01)
 ;;BP3JZZZ 
 ;;9002226.02101,"1804,BP3JZZZ ",.02)
 ;;BP3JZZZ 
 ;;9002226.02101,"1804,BP3JZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3KY0Z ",.01)
 ;;BP3KY0Z 
 ;;9002226.02101,"1804,BP3KY0Z ",.02)
 ;;BP3KY0Z 
 ;;9002226.02101,"1804,BP3KY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3KYZZ ",.01)
 ;;BP3KYZZ 
 ;;9002226.02101,"1804,BP3KYZZ ",.02)
 ;;BP3KYZZ 
 ;;9002226.02101,"1804,BP3KYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3KZZZ ",.01)
 ;;BP3KZZZ 
 ;;9002226.02101,"1804,BP3KZZZ ",.02)
 ;;BP3KZZZ 
 ;;9002226.02101,"1804,BP3KZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3LY0Z ",.01)
 ;;BP3LY0Z 
 ;;9002226.02101,"1804,BP3LY0Z ",.02)
 ;;BP3LY0Z 
 ;;9002226.02101,"1804,BP3LY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3LYZZ ",.01)
 ;;BP3LYZZ 
 ;;9002226.02101,"1804,BP3LYZZ ",.02)
 ;;BP3LYZZ 
 ;;9002226.02101,"1804,BP3LYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3LZZZ ",.01)
 ;;BP3LZZZ 
 ;;9002226.02101,"1804,BP3LZZZ ",.02)
 ;;BP3LZZZ 
 ;;9002226.02101,"1804,BP3LZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3MY0Z ",.01)
 ;;BP3MY0Z 
 ;;9002226.02101,"1804,BP3MY0Z ",.02)
 ;;BP3MY0Z 
 ;;9002226.02101,"1804,BP3MY0Z ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3MYZZ ",.01)
 ;;BP3MYZZ 
 ;;9002226.02101,"1804,BP3MYZZ ",.02)
 ;;BP3MYZZ 
 ;;9002226.02101,"1804,BP3MYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP3MZZZ ",.01)
 ;;BP3MZZZ 
 ;;9002226.02101,"1804,BP3MZZZ ",.02)
 ;;BP3MZZZ 
 ;;9002226.02101,"1804,BP3MZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP48ZZ1 ",.01)
 ;;BP48ZZ1 
 ;;9002226.02101,"1804,BP48ZZ1 ",.02)
 ;;BP48ZZ1 
 ;;9002226.02101,"1804,BP48ZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP48ZZZ ",.01)
 ;;BP48ZZZ 
 ;;9002226.02101,"1804,BP48ZZZ ",.02)
 ;;BP48ZZZ 
 ;;9002226.02101,"1804,BP48ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP49ZZ1 ",.01)
 ;;BP49ZZ1 
 ;;9002226.02101,"1804,BP49ZZ1 ",.02)
 ;;BP49ZZ1 
 ;;9002226.02101,"1804,BP49ZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP49ZZZ ",.01)
 ;;BP49ZZZ 
 ;;9002226.02101,"1804,BP49ZZZ ",.02)
 ;;BP49ZZZ 
 ;;9002226.02101,"1804,BP49ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4GZZ1 ",.01)
 ;;BP4GZZ1 
 ;;9002226.02101,"1804,BP4GZZ1 ",.02)
 ;;BP4GZZ1 
 ;;9002226.02101,"1804,BP4GZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4GZZZ ",.01)
 ;;BP4GZZZ 
 ;;9002226.02101,"1804,BP4GZZZ ",.02)
 ;;BP4GZZZ 
 ;;9002226.02101,"1804,BP4GZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4HZZ1 ",.01)
 ;;BP4HZZ1 
 ;;9002226.02101,"1804,BP4HZZ1 ",.02)
 ;;BP4HZZ1 
 ;;9002226.02101,"1804,BP4HZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4HZZZ ",.01)
 ;;BP4HZZZ 
 ;;9002226.02101,"1804,BP4HZZZ ",.02)
 ;;BP4HZZZ 
 ;;9002226.02101,"1804,BP4HZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4LZZ1 ",.01)
 ;;BP4LZZ1 
 ;;9002226.02101,"1804,BP4LZZ1 ",.02)
 ;;BP4LZZ1 
 ;;9002226.02101,"1804,BP4LZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4LZZZ ",.01)
 ;;BP4LZZZ 
 ;;9002226.02101,"1804,BP4LZZZ ",.02)
 ;;BP4LZZZ 
 ;;9002226.02101,"1804,BP4LZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4MZZ1 ",.01)
 ;;BP4MZZ1 
 ;;9002226.02101,"1804,BP4MZZ1 ",.02)
 ;;BP4MZZ1 
 ;;9002226.02101,"1804,BP4MZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4MZZZ ",.01)
 ;;BP4MZZZ 
 ;;9002226.02101,"1804,BP4MZZZ ",.02)
 ;;BP4MZZZ 
 ;;9002226.02101,"1804,BP4MZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4NZZ1 ",.01)
 ;;BP4NZZ1 
 ;;9002226.02101,"1804,BP4NZZ1 ",.02)
 ;;BP4NZZ1 
 ;;9002226.02101,"1804,BP4NZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4NZZZ ",.01)
 ;;BP4NZZZ 
 ;;9002226.02101,"1804,BP4NZZZ ",.02)
 ;;BP4NZZZ 
 ;;9002226.02101,"1804,BP4NZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4PZZ1 ",.01)
 ;;BP4PZZ1 
 ;;9002226.02101,"1804,BP4PZZ1 ",.02)
 ;;BP4PZZ1 
 ;;9002226.02101,"1804,BP4PZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BP4PZZZ ",.01)
 ;;BP4PZZZ 
 ;;9002226.02101,"1804,BP4PZZZ ",.02)
 ;;BP4PZZZ 
 ;;9002226.02101,"1804,BP4PZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ000ZZ ",.01)
 ;;BQ000ZZ 
 ;;9002226.02101,"1804,BQ000ZZ ",.02)
 ;;BQ000ZZ 
 ;;9002226.02101,"1804,BQ000ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ001ZZ ",.01)
 ;;BQ001ZZ 
 ;;9002226.02101,"1804,BQ001ZZ ",.02)
 ;;BQ001ZZ 
 ;;9002226.02101,"1804,BQ001ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ00YZZ ",.01)
 ;;BQ00YZZ 
 ;;9002226.02101,"1804,BQ00YZZ ",.02)
 ;;BQ00YZZ 
 ;;9002226.02101,"1804,BQ00YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ00ZZ1 ",.01)
 ;;BQ00ZZ1 
 ;;9002226.02101,"1804,BQ00ZZ1 ",.02)
 ;;BQ00ZZ1 
 ;;9002226.02101,"1804,BQ00ZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ00ZZZ ",.01)
 ;;BQ00ZZZ 
 ;;9002226.02101,"1804,BQ00ZZZ ",.02)
 ;;BQ00ZZZ 
 ;;9002226.02101,"1804,BQ00ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ010ZZ ",.01)
 ;;BQ010ZZ 
 ;;9002226.02101,"1804,BQ010ZZ ",.02)
 ;;BQ010ZZ 
 ;;9002226.02101,"1804,BQ010ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ011ZZ ",.01)
 ;;BQ011ZZ 
 ;;9002226.02101,"1804,BQ011ZZ ",.02)
 ;;BQ011ZZ 
 ;;9002226.02101,"1804,BQ011ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ01YZZ ",.01)
 ;;BQ01YZZ 
 ;;9002226.02101,"1804,BQ01YZZ ",.02)
 ;;BQ01YZZ 
 ;;9002226.02101,"1804,BQ01YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ01ZZ1 ",.01)
 ;;BQ01ZZ1 
 ;;9002226.02101,"1804,BQ01ZZ1 ",.02)
 ;;BQ01ZZ1 
 ;;9002226.02101,"1804,BQ01ZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ01ZZZ ",.01)
 ;;BQ01ZZZ 
 ;;9002226.02101,"1804,BQ01ZZZ ",.02)
 ;;BQ01ZZZ 
 ;;9002226.02101,"1804,BQ01ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ03ZZ1 ",.01)
 ;;BQ03ZZ1 
 ;;9002226.02101,"1804,BQ03ZZ1 ",.02)
 ;;BQ03ZZ1 
 ;;9002226.02101,"1804,BQ03ZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ03ZZZ ",.01)
 ;;BQ03ZZZ 
 ;;9002226.02101,"1804,BQ03ZZZ ",.02)
 ;;BQ03ZZZ 
 ;;9002226.02101,"1804,BQ03ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ04ZZ1 ",.01)
 ;;BQ04ZZ1 
 ;;9002226.02101,"1804,BQ04ZZ1 ",.02)
 ;;BQ04ZZ1 
 ;;9002226.02101,"1804,BQ04ZZ1 ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ04ZZZ ",.01)
 ;;BQ04ZZZ 
 ;;9002226.02101,"1804,BQ04ZZZ ",.02)
 ;;BQ04ZZZ 
 ;;9002226.02101,"1804,BQ04ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ070ZZ ",.01)
 ;;BQ070ZZ 
 ;;9002226.02101,"1804,BQ070ZZ ",.02)
 ;;BQ070ZZ 
 ;;9002226.02101,"1804,BQ070ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ071ZZ ",.01)
 ;;BQ071ZZ 
 ;;9002226.02101,"1804,BQ071ZZ ",.02)
 ;;BQ071ZZ 
 ;;9002226.02101,"1804,BQ071ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ07YZZ ",.01)
 ;;BQ07YZZ 
 ;;9002226.02101,"1804,BQ07YZZ ",.02)
 ;;BQ07YZZ 
 ;;9002226.02101,"1804,BQ07YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ07ZZZ ",.01)
 ;;BQ07ZZZ 
 ;;9002226.02101,"1804,BQ07ZZZ ",.02)
 ;;BQ07ZZZ 
 ;;9002226.02101,"1804,BQ07ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ080ZZ ",.01)
 ;;BQ080ZZ 
 ;;9002226.02101,"1804,BQ080ZZ ",.02)
 ;;BQ080ZZ 
 ;;9002226.02101,"1804,BQ080ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ081ZZ ",.01)
 ;;BQ081ZZ 
 ;;9002226.02101,"1804,BQ081ZZ ",.02)
 ;;BQ081ZZ 
 ;;9002226.02101,"1804,BQ081ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ08YZZ ",.01)
 ;;BQ08YZZ 
 ;;9002226.02101,"1804,BQ08YZZ ",.02)
 ;;BQ08YZZ 
 ;;9002226.02101,"1804,BQ08YZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ08ZZZ ",.01)
 ;;BQ08ZZZ 
 ;;9002226.02101,"1804,BQ08ZZZ ",.02)
 ;;BQ08ZZZ 
 ;;9002226.02101,"1804,BQ08ZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0DZZZ ",.01)
 ;;BQ0DZZZ 
 ;;9002226.02101,"1804,BQ0DZZZ ",.02)
 ;;BQ0DZZZ 
 ;;9002226.02101,"1804,BQ0DZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0FZZZ ",.01)
 ;;BQ0FZZZ 
 ;;9002226.02101,"1804,BQ0FZZZ ",.02)
 ;;BQ0FZZZ 
 ;;9002226.02101,"1804,BQ0FZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0G0ZZ ",.01)
 ;;BQ0G0ZZ 
 ;;9002226.02101,"1804,BQ0G0ZZ ",.02)
 ;;BQ0G0ZZ 
 ;;9002226.02101,"1804,BQ0G0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0G1ZZ ",.01)
 ;;BQ0G1ZZ 
 ;;9002226.02101,"1804,BQ0G1ZZ ",.02)
 ;;BQ0G1ZZ 
 ;;9002226.02101,"1804,BQ0G1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0GYZZ ",.01)
 ;;BQ0GYZZ 
 ;;9002226.02101,"1804,BQ0GYZZ ",.02)
 ;;BQ0GYZZ 
 ;;9002226.02101,"1804,BQ0GYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0GZZZ ",.01)
 ;;BQ0GZZZ 
 ;;9002226.02101,"1804,BQ0GZZZ ",.02)
 ;;BQ0GZZZ 
 ;;9002226.02101,"1804,BQ0GZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0H0ZZ ",.01)
 ;;BQ0H0ZZ 
 ;;9002226.02101,"1804,BQ0H0ZZ ",.02)
 ;;BQ0H0ZZ 
 ;;9002226.02101,"1804,BQ0H0ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0H1ZZ ",.01)
 ;;BQ0H1ZZ 
 ;;9002226.02101,"1804,BQ0H1ZZ ",.02)
 ;;BQ0H1ZZ 
 ;;9002226.02101,"1804,BQ0H1ZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0HYZZ ",.01)
 ;;BQ0HYZZ 
 ;;9002226.02101,"1804,BQ0HYZZ ",.02)
 ;;BQ0HYZZ 
 ;;9002226.02101,"1804,BQ0HYZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0HZZZ ",.01)
 ;;BQ0HZZZ 
 ;;9002226.02101,"1804,BQ0HZZZ ",.02)
 ;;BQ0HZZZ 
 ;;9002226.02101,"1804,BQ0HZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0JZZZ ",.01)
 ;;BQ0JZZZ 
 ;;9002226.02101,"1804,BQ0JZZZ ",.02)
 ;;BQ0JZZZ 
 ;;9002226.02101,"1804,BQ0JZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0KZZZ ",.01)
 ;;BQ0KZZZ 
 ;;9002226.02101,"1804,BQ0KZZZ ",.02)
 ;;BQ0KZZZ 
 ;;9002226.02101,"1804,BQ0KZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0LZZZ ",.01)
 ;;BQ0LZZZ 
 ;;9002226.02101,"1804,BQ0LZZZ ",.02)
 ;;BQ0LZZZ 
 ;;9002226.02101,"1804,BQ0LZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0MZZZ ",.01)
 ;;BQ0MZZZ 
 ;;9002226.02101,"1804,BQ0MZZZ ",.02)
 ;;BQ0MZZZ 
 ;;9002226.02101,"1804,BQ0MZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0PZZZ ",.01)
 ;;BQ0PZZZ 
 ;;9002226.02101,"1804,BQ0PZZZ ",.02)
 ;;BQ0PZZZ 
 ;;9002226.02101,"1804,BQ0PZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0QZZZ ",.01)
 ;;BQ0QZZZ 
 ;;9002226.02101,"1804,BQ0QZZZ ",.02)
 ;;BQ0QZZZ 
 ;;9002226.02101,"1804,BQ0QZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0VZZZ ",.01)
 ;;BQ0VZZZ 
 ;;9002226.02101,"1804,BQ0VZZZ ",.02)
 ;;BQ0VZZZ 
 ;;9002226.02101,"1804,BQ0VZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0WZZZ ",.01)
 ;;BQ0WZZZ 
 ;;9002226.02101,"1804,BQ0WZZZ ",.02)
 ;;BQ0WZZZ 
 ;;9002226.02101,"1804,BQ0WZZZ ",.03)
 ;;31
 ;;9002226.02101,"1804,BQ0X0ZZ ",.01)
 ;;BQ0X0ZZ 
 ;;9002226.02101,"1804,BQ0X0ZZ ",.02)
 ;;BQ0X0ZZ 