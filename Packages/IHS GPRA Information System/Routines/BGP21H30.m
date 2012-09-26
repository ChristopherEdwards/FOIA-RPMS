BGP21H30 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,12280-0300-30 ",.02)
 ;;12280-0300-30
 ;;9002226.02101,"1197,12280-0304-15 ",.01)
 ;;12280-0304-15
 ;;9002226.02101,"1197,12280-0304-15 ",.02)
 ;;12280-0304-15
 ;;9002226.02101,"1197,12280-0304-30 ",.01)
 ;;12280-0304-30
 ;;9002226.02101,"1197,12280-0304-30 ",.02)
 ;;12280-0304-30
 ;;9002226.02101,"1197,12280-0305-15 ",.01)
 ;;12280-0305-15
 ;;9002226.02101,"1197,12280-0305-15 ",.02)
 ;;12280-0305-15
 ;;9002226.02101,"1197,12280-0305-30 ",.01)
 ;;12280-0305-30
 ;;9002226.02101,"1197,12280-0305-30 ",.02)
 ;;12280-0305-30
 ;;9002226.02101,"1197,12280-0311-30 ",.01)
 ;;12280-0311-30
 ;;9002226.02101,"1197,12280-0311-30 ",.02)
 ;;12280-0311-30
 ;;9002226.02101,"1197,12280-0397-30 ",.01)
 ;;12280-0397-30
 ;;9002226.02101,"1197,12280-0397-30 ",.02)
 ;;12280-0397-30
 ;;9002226.02101,"1197,12280-0398-30 ",.01)
 ;;12280-0398-30
 ;;9002226.02101,"1197,12280-0398-30 ",.02)
 ;;12280-0398-30
 ;;9002226.02101,"1197,12280-0399-30 ",.01)
 ;;12280-0399-30
 ;;9002226.02101,"1197,12280-0399-30 ",.02)
 ;;12280-0399-30
 ;;9002226.02101,"1197,13411-0148-01 ",.01)
 ;;13411-0148-01
 ;;9002226.02101,"1197,13411-0148-01 ",.02)
 ;;13411-0148-01
 ;;9002226.02101,"1197,13411-0148-03 ",.01)
 ;;13411-0148-03
 ;;9002226.02101,"1197,13411-0148-03 ",.02)
 ;;13411-0148-03
 ;;9002226.02101,"1197,13411-0148-06 ",.01)
 ;;13411-0148-06
 ;;9002226.02101,"1197,13411-0148-06 ",.02)
 ;;13411-0148-06
 ;;9002226.02101,"1197,13411-0148-09 ",.01)
 ;;13411-0148-09
 ;;9002226.02101,"1197,13411-0148-09 ",.02)
 ;;13411-0148-09
 ;;9002226.02101,"1197,13411-0148-10 ",.01)
 ;;13411-0148-10
 ;;9002226.02101,"1197,13411-0148-10 ",.02)
 ;;13411-0148-10
 ;;9002226.02101,"1197,13411-0157-01 ",.01)
 ;;13411-0157-01
 ;;9002226.02101,"1197,13411-0157-01 ",.02)
 ;;13411-0157-01
 ;;9002226.02101,"1197,13411-0157-03 ",.01)
 ;;13411-0157-03
 ;;9002226.02101,"1197,13411-0157-03 ",.02)
 ;;13411-0157-03
 ;;9002226.02101,"1197,13411-0157-06 ",.01)
 ;;13411-0157-06
 ;;9002226.02101,"1197,13411-0157-06 ",.02)
 ;;13411-0157-06
 ;;9002226.02101,"1197,13411-0157-09 ",.01)
 ;;13411-0157-09
 ;;9002226.02101,"1197,13411-0157-09 ",.02)
 ;;13411-0157-09
 ;;9002226.02101,"1197,13411-0157-10 ",.01)
 ;;13411-0157-10
 ;;9002226.02101,"1197,13411-0157-10 ",.02)
 ;;13411-0157-10
 ;;9002226.02101,"1197,13411-0158-01 ",.01)
 ;;13411-0158-01
 ;;9002226.02101,"1197,13411-0158-01 ",.02)
 ;;13411-0158-01
 ;;9002226.02101,"1197,13411-0158-03 ",.01)
 ;;13411-0158-03
 ;;9002226.02101,"1197,13411-0158-03 ",.02)
 ;;13411-0158-03
 ;;9002226.02101,"1197,13411-0158-06 ",.01)
 ;;13411-0158-06
 ;;9002226.02101,"1197,13411-0158-06 ",.02)
 ;;13411-0158-06
 ;;9002226.02101,"1197,13411-0158-09 ",.01)
 ;;13411-0158-09
 ;;9002226.02101,"1197,13411-0158-09 ",.02)
 ;;13411-0158-09
 ;;9002226.02101,"1197,13411-0158-10 ",.01)
 ;;13411-0158-10
 ;;9002226.02101,"1197,13411-0158-10 ",.02)
 ;;13411-0158-10
 ;;9002226.02101,"1197,13551-0201-01 ",.01)
 ;;13551-0201-01
 ;;9002226.02101,"1197,13551-0201-01 ",.02)
 ;;13551-0201-01
 ;;9002226.02101,"1197,13551-0301-01 ",.01)
 ;;13551-0301-01
 ;;9002226.02101,"1197,13551-0301-01 ",.02)
 ;;13551-0301-01
 ;;9002226.02101,"1197,13551-0401-01 ",.01)
 ;;13551-0401-01
 ;;9002226.02101,"1197,13551-0401-01 ",.02)
 ;;13551-0401-01
 ;;9002226.02101,"1197,13551-0401-05 ",.01)
 ;;13551-0401-05
 ;;9002226.02101,"1197,13551-0401-05 ",.02)
 ;;13551-0401-05
 ;;9002226.02101,"1197,13668-0022-03 ",.01)
 ;;13668-0022-03
 ;;9002226.02101,"1197,13668-0022-03 ",.02)
 ;;13668-0022-03
 ;;9002226.02101,"1197,13668-0022-05 ",.01)
 ;;13668-0022-05
 ;;9002226.02101,"1197,13668-0022-05 ",.02)
 ;;13668-0022-05
 ;;9002226.02101,"1197,13668-0023-03 ",.01)
 ;;13668-0023-03
 ;;9002226.02101,"1197,13668-0023-03 ",.02)
 ;;13668-0023-03
 ;;9002226.02101,"1197,13668-0023-05 ",.01)
 ;;13668-0023-05
 ;;9002226.02101,"1197,13668-0023-05 ",.02)
 ;;13668-0023-05
 ;;9002226.02101,"1197,13668-0024-05 ",.01)
 ;;13668-0024-05
 ;;9002226.02101,"1197,13668-0024-05 ",.02)
 ;;13668-0024-05
 ;;9002226.02101,"1197,13668-0024-10 ",.01)
 ;;13668-0024-10
 ;;9002226.02101,"1197,13668-0024-10 ",.02)
 ;;13668-0024-10
 ;;9002226.02101,"1197,15330-0041-01 ",.01)
 ;;15330-0041-01
 ;;9002226.02101,"1197,15330-0041-01 ",.02)
 ;;15330-0041-01
 ;;9002226.02101,"1197,15330-0041-05 ",.01)
 ;;15330-0041-05
 ;;9002226.02101,"1197,15330-0041-05 ",.02)
 ;;15330-0041-05
 ;;9002226.02101,"1197,15330-0042-01 ",.01)
 ;;15330-0042-01
 ;;9002226.02101,"1197,15330-0042-01 ",.02)
 ;;15330-0042-01
 ;;9002226.02101,"1197,15330-0042-05 ",.01)
 ;;15330-0042-05
 ;;9002226.02101,"1197,15330-0042-05 ",.02)
 ;;15330-0042-05
 ;;9002226.02101,"1197,16252-0539-01 ",.01)
 ;;16252-0539-01
 ;;9002226.02101,"1197,16252-0539-01 ",.02)
 ;;16252-0539-01
 ;;9002226.02101,"1197,16252-0540-01 ",.01)
 ;;16252-0540-01
 ;;9002226.02101,"1197,16252-0540-01 ",.02)
 ;;16252-0540-01
 ;;9002226.02101,"1197,16252-0544-90 ",.01)
 ;;16252-0544-90
 ;;9002226.02101,"1197,16252-0544-90 ",.02)
 ;;16252-0544-90
 ;;9002226.02101,"1197,16252-0545-50 ",.01)
 ;;16252-0545-50
 ;;9002226.02101,"1197,16252-0545-50 ",.02)
 ;;16252-0545-50
 ;;9002226.02101,"1197,16252-0545-90 ",.01)
 ;;16252-0545-90
 ;;9002226.02101,"1197,16252-0545-90 ",.02)
 ;;16252-0545-90
