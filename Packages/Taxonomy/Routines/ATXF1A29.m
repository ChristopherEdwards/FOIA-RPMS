ATXF1A29 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JUL 22, 2015;
 ;;5.1;TAXONOMY;**12**;FEB 04, 1997;Build 5
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1075,O66.6 ",.03)
 ;;30
 ;;9002226.02101,"1075,O66.8 ",.01)
 ;;O66.8 
 ;;9002226.02101,"1075,O66.8 ",.02)
 ;;O66.8 
 ;;9002226.02101,"1075,O66.8 ",.03)
 ;;30
 ;;9002226.02101,"1075,O66.9 ",.01)
 ;;O66.9 
 ;;9002226.02101,"1075,O66.9 ",.02)
 ;;O66.9 
 ;;9002226.02101,"1075,O66.9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O68. ",.01)
 ;;O68. 
 ;;9002226.02101,"1075,O68. ",.02)
 ;;O68. 
 ;;9002226.02101,"1075,O68. ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX0 ",.01)
 ;;O69.0XX0 
 ;;9002226.02101,"1075,O69.0XX0 ",.02)
 ;;O69.0XX0 
 ;;9002226.02101,"1075,O69.0XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX1 ",.01)
 ;;O69.0XX1 
 ;;9002226.02101,"1075,O69.0XX1 ",.02)
 ;;O69.0XX1 
 ;;9002226.02101,"1075,O69.0XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX2 ",.01)
 ;;O69.0XX2 
 ;;9002226.02101,"1075,O69.0XX2 ",.02)
 ;;O69.0XX2 
 ;;9002226.02101,"1075,O69.0XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX3 ",.01)
 ;;O69.0XX3 
 ;;9002226.02101,"1075,O69.0XX3 ",.02)
 ;;O69.0XX3 
 ;;9002226.02101,"1075,O69.0XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX4 ",.01)
 ;;O69.0XX4 
 ;;9002226.02101,"1075,O69.0XX4 ",.02)
 ;;O69.0XX4 
 ;;9002226.02101,"1075,O69.0XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX5 ",.01)
 ;;O69.0XX5 
 ;;9002226.02101,"1075,O69.0XX5 ",.02)
 ;;O69.0XX5 
 ;;9002226.02101,"1075,O69.0XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.0XX9 ",.01)
 ;;O69.0XX9 
 ;;9002226.02101,"1075,O69.0XX9 ",.02)
 ;;O69.0XX9 
 ;;9002226.02101,"1075,O69.0XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX0 ",.01)
 ;;O69.1XX0 
 ;;9002226.02101,"1075,O69.1XX0 ",.02)
 ;;O69.1XX0 
 ;;9002226.02101,"1075,O69.1XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX1 ",.01)
 ;;O69.1XX1 
 ;;9002226.02101,"1075,O69.1XX1 ",.02)
 ;;O69.1XX1 
 ;;9002226.02101,"1075,O69.1XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX2 ",.01)
 ;;O69.1XX2 
 ;;9002226.02101,"1075,O69.1XX2 ",.02)
 ;;O69.1XX2 
 ;;9002226.02101,"1075,O69.1XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX3 ",.01)
 ;;O69.1XX3 
 ;;9002226.02101,"1075,O69.1XX3 ",.02)
 ;;O69.1XX3 
 ;;9002226.02101,"1075,O69.1XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX4 ",.01)
 ;;O69.1XX4 
 ;;9002226.02101,"1075,O69.1XX4 ",.02)
 ;;O69.1XX4 
 ;;9002226.02101,"1075,O69.1XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX5 ",.01)
 ;;O69.1XX5 
 ;;9002226.02101,"1075,O69.1XX5 ",.02)
 ;;O69.1XX5 
 ;;9002226.02101,"1075,O69.1XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.1XX9 ",.01)
 ;;O69.1XX9 
 ;;9002226.02101,"1075,O69.1XX9 ",.02)
 ;;O69.1XX9 
 ;;9002226.02101,"1075,O69.1XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX0 ",.01)
 ;;O69.2XX0 
 ;;9002226.02101,"1075,O69.2XX0 ",.02)
 ;;O69.2XX0 
 ;;9002226.02101,"1075,O69.2XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX1 ",.01)
 ;;O69.2XX1 
 ;;9002226.02101,"1075,O69.2XX1 ",.02)
 ;;O69.2XX1 
 ;;9002226.02101,"1075,O69.2XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX2 ",.01)
 ;;O69.2XX2 
 ;;9002226.02101,"1075,O69.2XX2 ",.02)
 ;;O69.2XX2 
 ;;9002226.02101,"1075,O69.2XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX3 ",.01)
 ;;O69.2XX3 
 ;;9002226.02101,"1075,O69.2XX3 ",.02)
 ;;O69.2XX3 
 ;;9002226.02101,"1075,O69.2XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX4 ",.01)
 ;;O69.2XX4 
 ;;9002226.02101,"1075,O69.2XX4 ",.02)
 ;;O69.2XX4 
 ;;9002226.02101,"1075,O69.2XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX5 ",.01)
 ;;O69.2XX5 
 ;;9002226.02101,"1075,O69.2XX5 ",.02)
 ;;O69.2XX5 
 ;;9002226.02101,"1075,O69.2XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.2XX9 ",.01)
 ;;O69.2XX9 
 ;;9002226.02101,"1075,O69.2XX9 ",.02)
 ;;O69.2XX9 
 ;;9002226.02101,"1075,O69.2XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX0 ",.01)
 ;;O69.3XX0 
 ;;9002226.02101,"1075,O69.3XX0 ",.02)
 ;;O69.3XX0 
 ;;9002226.02101,"1075,O69.3XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX1 ",.01)
 ;;O69.3XX1 
 ;;9002226.02101,"1075,O69.3XX1 ",.02)
 ;;O69.3XX1 
 ;;9002226.02101,"1075,O69.3XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX2 ",.01)
 ;;O69.3XX2 
 ;;9002226.02101,"1075,O69.3XX2 ",.02)
 ;;O69.3XX2 
 ;;9002226.02101,"1075,O69.3XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX3 ",.01)
 ;;O69.3XX3 
 ;;9002226.02101,"1075,O69.3XX3 ",.02)
 ;;O69.3XX3 
 ;;9002226.02101,"1075,O69.3XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX4 ",.01)
 ;;O69.3XX4 
 ;;9002226.02101,"1075,O69.3XX4 ",.02)
 ;;O69.3XX4 
 ;;9002226.02101,"1075,O69.3XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX5 ",.01)
 ;;O69.3XX5 
 ;;9002226.02101,"1075,O69.3XX5 ",.02)
 ;;O69.3XX5 
 ;;9002226.02101,"1075,O69.3XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.3XX9 ",.01)
 ;;O69.3XX9 
 ;;9002226.02101,"1075,O69.3XX9 ",.02)
 ;;O69.3XX9 
 ;;9002226.02101,"1075,O69.3XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX0 ",.01)
 ;;O69.4XX0 
 ;;9002226.02101,"1075,O69.4XX0 ",.02)
 ;;O69.4XX0 
 ;;9002226.02101,"1075,O69.4XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX1 ",.01)
 ;;O69.4XX1 
 ;;9002226.02101,"1075,O69.4XX1 ",.02)
 ;;O69.4XX1 
 ;;9002226.02101,"1075,O69.4XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX2 ",.01)
 ;;O69.4XX2 
 ;;9002226.02101,"1075,O69.4XX2 ",.02)
 ;;O69.4XX2 
 ;;9002226.02101,"1075,O69.4XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX3 ",.01)
 ;;O69.4XX3 
 ;;9002226.02101,"1075,O69.4XX3 ",.02)
 ;;O69.4XX3 
 ;;9002226.02101,"1075,O69.4XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX4 ",.01)
 ;;O69.4XX4 
 ;;9002226.02101,"1075,O69.4XX4 ",.02)
 ;;O69.4XX4 
 ;;9002226.02101,"1075,O69.4XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX5 ",.01)
 ;;O69.4XX5 
 ;;9002226.02101,"1075,O69.4XX5 ",.02)
 ;;O69.4XX5 
 ;;9002226.02101,"1075,O69.4XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.4XX9 ",.01)
 ;;O69.4XX9 
 ;;9002226.02101,"1075,O69.4XX9 ",.02)
 ;;O69.4XX9 
 ;;9002226.02101,"1075,O69.4XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX0 ",.01)
 ;;O69.5XX0 
 ;;9002226.02101,"1075,O69.5XX0 ",.02)
 ;;O69.5XX0 
 ;;9002226.02101,"1075,O69.5XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX1 ",.01)
 ;;O69.5XX1 
 ;;9002226.02101,"1075,O69.5XX1 ",.02)
 ;;O69.5XX1 
 ;;9002226.02101,"1075,O69.5XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX2 ",.01)
 ;;O69.5XX2 
 ;;9002226.02101,"1075,O69.5XX2 ",.02)
 ;;O69.5XX2 
 ;;9002226.02101,"1075,O69.5XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX3 ",.01)
 ;;O69.5XX3 
 ;;9002226.02101,"1075,O69.5XX3 ",.02)
 ;;O69.5XX3 
 ;;9002226.02101,"1075,O69.5XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX4 ",.01)
 ;;O69.5XX4 
 ;;9002226.02101,"1075,O69.5XX4 ",.02)
 ;;O69.5XX4 
 ;;9002226.02101,"1075,O69.5XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX5 ",.01)
 ;;O69.5XX5 
 ;;9002226.02101,"1075,O69.5XX5 ",.02)
 ;;O69.5XX5 
 ;;9002226.02101,"1075,O69.5XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.5XX9 ",.01)
 ;;O69.5XX9 
 ;;9002226.02101,"1075,O69.5XX9 ",.02)
 ;;O69.5XX9 
 ;;9002226.02101,"1075,O69.5XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X0 ",.01)
 ;;O69.81X0 
 ;;9002226.02101,"1075,O69.81X0 ",.02)
 ;;O69.81X0 
 ;;9002226.02101,"1075,O69.81X0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X1 ",.01)
 ;;O69.81X1 
 ;;9002226.02101,"1075,O69.81X1 ",.02)
 ;;O69.81X1 
 ;;9002226.02101,"1075,O69.81X1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X2 ",.01)
 ;;O69.81X2 
 ;;9002226.02101,"1075,O69.81X2 ",.02)
 ;;O69.81X2 
 ;;9002226.02101,"1075,O69.81X2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X3 ",.01)
 ;;O69.81X3 
 ;;9002226.02101,"1075,O69.81X3 ",.02)
 ;;O69.81X3 
 ;;9002226.02101,"1075,O69.81X3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X4 ",.01)
 ;;O69.81X4 
 ;;9002226.02101,"1075,O69.81X4 ",.02)
 ;;O69.81X4 
 ;;9002226.02101,"1075,O69.81X4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X5 ",.01)
 ;;O69.81X5 
 ;;9002226.02101,"1075,O69.81X5 ",.02)
 ;;O69.81X5 
 ;;9002226.02101,"1075,O69.81X5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.81X9 ",.01)
 ;;O69.81X9 
 ;;9002226.02101,"1075,O69.81X9 ",.02)
 ;;O69.81X9 
 ;;9002226.02101,"1075,O69.81X9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X0 ",.01)
 ;;O69.82X0 
 ;;9002226.02101,"1075,O69.82X0 ",.02)
 ;;O69.82X0 
 ;;9002226.02101,"1075,O69.82X0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X1 ",.01)
 ;;O69.82X1 
 ;;9002226.02101,"1075,O69.82X1 ",.02)
 ;;O69.82X1 
 ;;9002226.02101,"1075,O69.82X1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X2 ",.01)
 ;;O69.82X2 
 ;;9002226.02101,"1075,O69.82X2 ",.02)
 ;;O69.82X2 
 ;;9002226.02101,"1075,O69.82X2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X3 ",.01)
 ;;O69.82X3 
 ;;9002226.02101,"1075,O69.82X3 ",.02)
 ;;O69.82X3 
 ;;9002226.02101,"1075,O69.82X3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X4 ",.01)
 ;;O69.82X4 
 ;;9002226.02101,"1075,O69.82X4 ",.02)
 ;;O69.82X4 
 ;;9002226.02101,"1075,O69.82X4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X5 ",.01)
 ;;O69.82X5 
 ;;9002226.02101,"1075,O69.82X5 ",.02)
 ;;O69.82X5 
 ;;9002226.02101,"1075,O69.82X5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.82X9 ",.01)
 ;;O69.82X9 
 ;;9002226.02101,"1075,O69.82X9 ",.02)
 ;;O69.82X9 
 ;;9002226.02101,"1075,O69.82X9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X0 ",.01)
 ;;O69.89X0 
 ;;9002226.02101,"1075,O69.89X0 ",.02)
 ;;O69.89X0 
 ;;9002226.02101,"1075,O69.89X0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X1 ",.01)
 ;;O69.89X1 
 ;;9002226.02101,"1075,O69.89X1 ",.02)
 ;;O69.89X1 
 ;;9002226.02101,"1075,O69.89X1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X2 ",.01)
 ;;O69.89X2 
 ;;9002226.02101,"1075,O69.89X2 ",.02)
 ;;O69.89X2 
 ;;9002226.02101,"1075,O69.89X2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X3 ",.01)
 ;;O69.89X3 
 ;;9002226.02101,"1075,O69.89X3 ",.02)
 ;;O69.89X3 
 ;;9002226.02101,"1075,O69.89X3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X4 ",.01)
 ;;O69.89X4 
 ;;9002226.02101,"1075,O69.89X4 ",.02)
 ;;O69.89X4 
 ;;9002226.02101,"1075,O69.89X4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X5 ",.01)
 ;;O69.89X5 
 ;;9002226.02101,"1075,O69.89X5 ",.02)
 ;;O69.89X5 
 ;;9002226.02101,"1075,O69.89X5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.89X9 ",.01)
 ;;O69.89X9 
 ;;9002226.02101,"1075,O69.89X9 ",.02)
 ;;O69.89X9 
 ;;9002226.02101,"1075,O69.89X9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX0 ",.01)
 ;;O69.9XX0 
 ;;9002226.02101,"1075,O69.9XX0 ",.02)
 ;;O69.9XX0 
 ;;9002226.02101,"1075,O69.9XX0 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX1 ",.01)
 ;;O69.9XX1 
 ;;9002226.02101,"1075,O69.9XX1 ",.02)
 ;;O69.9XX1 
 ;;9002226.02101,"1075,O69.9XX1 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX2 ",.01)
 ;;O69.9XX2 
 ;;9002226.02101,"1075,O69.9XX2 ",.02)
 ;;O69.9XX2 
 ;;9002226.02101,"1075,O69.9XX2 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX3 ",.01)
 ;;O69.9XX3 
 ;;9002226.02101,"1075,O69.9XX3 ",.02)
 ;;O69.9XX3 
 ;;9002226.02101,"1075,O69.9XX3 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX4 ",.01)
 ;;O69.9XX4 
 ;;9002226.02101,"1075,O69.9XX4 ",.02)
 ;;O69.9XX4 
 ;;9002226.02101,"1075,O69.9XX4 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX5 ",.01)
 ;;O69.9XX5 
 ;;9002226.02101,"1075,O69.9XX5 ",.02)
 ;;O69.9XX5 
 ;;9002226.02101,"1075,O69.9XX5 ",.03)
 ;;30
 ;;9002226.02101,"1075,O69.9XX9 ",.01)
 ;;O69.9XX9 
 ;;9002226.02101,"1075,O69.9XX9 ",.02)
 ;;O69.9XX9 
 ;;9002226.02101,"1075,O69.9XX9 ",.03)
 ;;30
 ;;9002226.02101,"1075,O71.00 ",.01)
 ;;O71.00 
 ;;9002226.02101,"1075,O71.00 ",.02)
 ;;O71.00 
 ;;9002226.02101,"1075,O71.00 ",.03)
 ;;30
 ;;9002226.02101,"1075,O71.02 ",.01)
 ;;O71.02 
 ;;9002226.02101,"1075,O71.02 ",.02)
 ;;O71.02 
 ;;9002226.02101,"1075,O71.02 ",.03)
 ;;30
 ;;9002226.02101,"1075,O71.03 ",.01)
 ;;O71.03 
 ;;9002226.02101,"1075,O71.03 ",.02)
 ;;O71.03 
 ;;9002226.02101,"1075,O71.03 ",.03)
 ;;30