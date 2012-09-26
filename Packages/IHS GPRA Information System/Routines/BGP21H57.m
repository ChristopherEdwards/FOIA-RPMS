BGP21H57 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,62175-0486-37 ",.01)
 ;;62175-0486-37
 ;;9002226.02101,"1197,62175-0486-37 ",.02)
 ;;62175-0486-37
 ;;9002226.02101,"1197,62175-0487-37 ",.01)
 ;;62175-0487-37
 ;;9002226.02101,"1197,62175-0487-37 ",.02)
 ;;62175-0487-37
 ;;9002226.02101,"1197,62451-0733-19 ",.01)
 ;;62451-0733-19
 ;;9002226.02101,"1197,62451-0733-19 ",.02)
 ;;62451-0733-19
 ;;9002226.02101,"1197,62451-0734-19 ",.01)
 ;;62451-0734-19
 ;;9002226.02101,"1197,62451-0734-19 ",.02)
 ;;62451-0734-19
 ;;9002226.02101,"1197,62451-8841-54 ",.01)
 ;;62451-8841-54
 ;;9002226.02101,"1197,62451-8841-54 ",.02)
 ;;62451-8841-54
 ;;9002226.02101,"1197,62451-8841-72 ",.01)
 ;;62451-8841-72
 ;;9002226.02101,"1197,62451-8841-72 ",.02)
 ;;62451-8841-72
 ;;9002226.02101,"1197,62451-8851-54 ",.01)
 ;;62451-8851-54
 ;;9002226.02101,"1197,62451-8851-54 ",.02)
 ;;62451-8851-54
 ;;9002226.02101,"1197,62451-8851-72 ",.01)
 ;;62451-8851-72
 ;;9002226.02101,"1197,62451-8851-72 ",.02)
 ;;62451-8851-72
 ;;9002226.02101,"1197,62451-8861-51 ",.01)
 ;;62451-8861-51
 ;;9002226.02101,"1197,62451-8861-51 ",.02)
 ;;62451-8861-51
 ;;9002226.02101,"1197,62584-0366-33 ",.01)
 ;;62584-0366-33
 ;;9002226.02101,"1197,62584-0366-33 ",.02)
 ;;62584-0366-33
 ;;9002226.02101,"1197,62584-0367-01 ",.01)
 ;;62584-0367-01
 ;;9002226.02101,"1197,62584-0367-01 ",.02)
 ;;62584-0367-01
 ;;9002226.02101,"1197,62584-0367-33 ",.01)
 ;;62584-0367-33
 ;;9002226.02101,"1197,62584-0367-33 ",.02)
 ;;62584-0367-33
 ;;9002226.02101,"1197,62584-0974-01 ",.01)
 ;;62584-0974-01
 ;;9002226.02101,"1197,62584-0974-01 ",.02)
 ;;62584-0974-01
 ;;9002226.02101,"1197,62584-0974-11 ",.01)
 ;;62584-0974-11
 ;;9002226.02101,"1197,62584-0974-11 ",.02)
 ;;62584-0974-11
 ;;9002226.02101,"1197,62584-0974-30 ",.01)
 ;;62584-0974-30
 ;;9002226.02101,"1197,62584-0974-30 ",.02)
 ;;62584-0974-30
 ;;9002226.02101,"1197,62584-0974-80 ",.01)
 ;;62584-0974-80
 ;;9002226.02101,"1197,62584-0974-80 ",.02)
 ;;62584-0974-80
 ;;9002226.02101,"1197,62584-0974-85 ",.01)
 ;;62584-0974-85
 ;;9002226.02101,"1197,62584-0974-85 ",.02)
 ;;62584-0974-85
 ;;9002226.02101,"1197,62584-0974-90 ",.01)
 ;;62584-0974-90
 ;;9002226.02101,"1197,62584-0974-90 ",.02)
 ;;62584-0974-90
 ;;9002226.02101,"1197,62584-0975-01 ",.01)
 ;;62584-0975-01
 ;;9002226.02101,"1197,62584-0975-01 ",.02)
 ;;62584-0975-01
 ;;9002226.02101,"1197,62584-0975-11 ",.01)
 ;;62584-0975-11
 ;;9002226.02101,"1197,62584-0975-11 ",.02)
 ;;62584-0975-11
 ;;9002226.02101,"1197,62584-0975-30 ",.01)
 ;;62584-0975-30
 ;;9002226.02101,"1197,62584-0975-30 ",.02)
 ;;62584-0975-30
 ;;9002226.02101,"1197,62584-0975-80 ",.01)
 ;;62584-0975-80
 ;;9002226.02101,"1197,62584-0975-80 ",.02)
 ;;62584-0975-80
 ;;9002226.02101,"1197,62584-0975-85 ",.01)
 ;;62584-0975-85
 ;;9002226.02101,"1197,62584-0975-85 ",.02)
 ;;62584-0975-85
 ;;9002226.02101,"1197,62584-0975-90 ",.01)
 ;;62584-0975-90
 ;;9002226.02101,"1197,62584-0975-90 ",.02)
 ;;62584-0975-90
 ;;9002226.02101,"1197,62584-0976-01 ",.01)
 ;;62584-0976-01
 ;;9002226.02101,"1197,62584-0976-01 ",.02)
 ;;62584-0976-01
 ;;9002226.02101,"1197,62584-0976-11 ",.01)
 ;;62584-0976-11
 ;;9002226.02101,"1197,62584-0976-11 ",.02)
 ;;62584-0976-11
 ;;9002226.02101,"1197,62584-0976-30 ",.01)
 ;;62584-0976-30
 ;;9002226.02101,"1197,62584-0976-30 ",.02)
 ;;62584-0976-30
 ;;9002226.02101,"1197,62584-0976-80 ",.01)
 ;;62584-0976-80
 ;;9002226.02101,"1197,62584-0976-80 ",.02)
 ;;62584-0976-80
 ;;9002226.02101,"1197,62584-0976-85 ",.01)
 ;;62584-0976-85
 ;;9002226.02101,"1197,62584-0976-85 ",.02)
 ;;62584-0976-85
 ;;9002226.02101,"1197,62584-0976-90 ",.01)
 ;;62584-0976-90
 ;;9002226.02101,"1197,62584-0976-90 ",.02)
 ;;62584-0976-90
 ;;9002226.02101,"1197,62584-0977-01 ",.01)
 ;;62584-0977-01
 ;;9002226.02101,"1197,62584-0977-01 ",.02)
 ;;62584-0977-01
 ;;9002226.02101,"1197,62584-0977-11 ",.01)
 ;;62584-0977-11
 ;;9002226.02101,"1197,62584-0977-11 ",.02)
 ;;62584-0977-11
 ;;9002226.02101,"1197,62584-0977-30 ",.01)
 ;;62584-0977-30
 ;;9002226.02101,"1197,62584-0977-30 ",.02)
 ;;62584-0977-30
 ;;9002226.02101,"1197,62584-0977-90 ",.01)
 ;;62584-0977-90
 ;;9002226.02101,"1197,62584-0977-90 ",.02)
 ;;62584-0977-90
 ;;9002226.02101,"1197,62682-6034-06 ",.01)
 ;;62682-6034-06
 ;;9002226.02101,"1197,62682-6034-06 ",.02)
 ;;62682-6034-06
 ;;9002226.02101,"1197,62682-6035-06 ",.01)
 ;;62682-6035-06
 ;;9002226.02101,"1197,62682-6035-06 ",.02)
 ;;62682-6035-06
 ;;9002226.02101,"1197,63304-0435-01 ",.01)
 ;;63304-0435-01
 ;;9002226.02101,"1197,63304-0435-01 ",.02)
 ;;63304-0435-01
 ;;9002226.02101,"1197,63304-0436-01 ",.01)
 ;;63304-0436-01
 ;;9002226.02101,"1197,63304-0436-01 ",.02)
 ;;63304-0436-01
 ;;9002226.02101,"1197,63304-0437-01 ",.01)
 ;;63304-0437-01
 ;;9002226.02101,"1197,63304-0437-01 ",.02)
 ;;63304-0437-01
 ;;9002226.02101,"1197,63304-0488-01 ",.01)
 ;;63304-0488-01
 ;;9002226.02101,"1197,63304-0488-01 ",.02)
 ;;63304-0488-01
 ;;9002226.02101,"1197,63304-0489-01 ",.01)
 ;;63304-0489-01
 ;;9002226.02101,"1197,63304-0489-01 ",.02)
 ;;63304-0489-01
 ;;9002226.02101,"1197,63304-0490-01 ",.01)
 ;;63304-0490-01
 ;;9002226.02101,"1197,63304-0490-01 ",.02)
 ;;63304-0490-01
 ;;9002226.02101,"1197,63304-0490-05 ",.01)
 ;;63304-0490-05
