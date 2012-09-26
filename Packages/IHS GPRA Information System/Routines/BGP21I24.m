BGP21I24 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1198,54868-5973-00 ",.01)
 ;;54868-5973-00
 ;;9002226.02101,"1198,54868-5973-00 ",.02)
 ;;54868-5973-00
 ;;9002226.02101,"1198,55045-2504-01 ",.01)
 ;;55045-2504-01
 ;;9002226.02101,"1198,55045-2504-01 ",.02)
 ;;55045-2504-01
 ;;9002226.02101,"1198,55045-2904-00 ",.01)
 ;;55045-2904-00
 ;;9002226.02101,"1198,55045-2904-00 ",.02)
 ;;55045-2904-00
 ;;9002226.02101,"1198,55045-2904-02 ",.01)
 ;;55045-2904-02
 ;;9002226.02101,"1198,55045-2904-02 ",.02)
 ;;55045-2904-02
 ;;9002226.02101,"1198,55045-2904-06 ",.01)
 ;;55045-2904-06
 ;;9002226.02101,"1198,55045-2904-06 ",.02)
 ;;55045-2904-06
 ;;9002226.02101,"1198,55045-2905-00 ",.01)
 ;;55045-2905-00
 ;;9002226.02101,"1198,55045-2905-00 ",.02)
 ;;55045-2905-00
 ;;9002226.02101,"1198,55045-2905-08 ",.01)
 ;;55045-2905-08
 ;;9002226.02101,"1198,55045-2905-08 ",.02)
 ;;55045-2905-08
 ;;9002226.02101,"1198,55045-2906-00 ",.01)
 ;;55045-2906-00
 ;;9002226.02101,"1198,55045-2906-00 ",.02)
 ;;55045-2906-00
 ;;9002226.02101,"1198,55045-2906-01 ",.01)
 ;;55045-2906-01
 ;;9002226.02101,"1198,55045-2906-01 ",.02)
 ;;55045-2906-01
 ;;9002226.02101,"1198,55045-2906-02 ",.01)
 ;;55045-2906-02
 ;;9002226.02101,"1198,55045-2906-02 ",.02)
 ;;55045-2906-02
 ;;9002226.02101,"1198,55045-2906-06 ",.01)
 ;;55045-2906-06
 ;;9002226.02101,"1198,55045-2906-06 ",.02)
 ;;55045-2906-06
 ;;9002226.02101,"1198,55045-2906-08 ",.01)
 ;;55045-2906-08
 ;;9002226.02101,"1198,55045-2906-08 ",.02)
 ;;55045-2906-08
 ;;9002226.02101,"1198,55045-2906-09 ",.01)
 ;;55045-2906-09
 ;;9002226.02101,"1198,55045-2906-09 ",.02)
 ;;55045-2906-09
 ;;9002226.02101,"1198,55045-3045-01 ",.01)
 ;;55045-3045-01
 ;;9002226.02101,"1198,55045-3045-01 ",.02)
 ;;55045-3045-01
 ;;9002226.02101,"1198,55045-3045-06 ",.01)
 ;;55045-3045-06
 ;;9002226.02101,"1198,55045-3045-06 ",.02)
 ;;55045-3045-06
 ;;9002226.02101,"1198,55045-3045-08 ",.01)
 ;;55045-3045-08
 ;;9002226.02101,"1198,55045-3045-08 ",.02)
 ;;55045-3045-08
 ;;9002226.02101,"1198,55045-3761-08 ",.01)
 ;;55045-3761-08
 ;;9002226.02101,"1198,55045-3761-08 ",.02)
 ;;55045-3761-08
 ;;9002226.02101,"1198,55111-0695-01 ",.01)
 ;;55111-0695-01
 ;;9002226.02101,"1198,55111-0695-01 ",.02)
 ;;55111-0695-01
 ;;9002226.02101,"1198,55111-0696-01 ",.01)
 ;;55111-0696-01
 ;;9002226.02101,"1198,55111-0696-01 ",.02)
 ;;55111-0696-01
 ;;9002226.02101,"1198,55111-0696-10 ",.01)
 ;;55111-0696-10
 ;;9002226.02101,"1198,55111-0696-10 ",.02)
 ;;55111-0696-10
 ;;9002226.02101,"1198,55111-0697-01 ",.01)
 ;;55111-0697-01
 ;;9002226.02101,"1198,55111-0697-01 ",.02)
 ;;55111-0697-01
 ;;9002226.02101,"1198,55111-0697-10 ",.01)
 ;;55111-0697-10
 ;;9002226.02101,"1198,55111-0697-10 ",.02)
 ;;55111-0697-10
 ;;9002226.02101,"1198,55289-0211-60 ",.01)
 ;;55289-0211-60
 ;;9002226.02101,"1198,55289-0211-60 ",.02)
 ;;55289-0211-60
 ;;9002226.02101,"1198,55289-0281-30 ",.01)
 ;;55289-0281-30
 ;;9002226.02101,"1198,55289-0281-30 ",.02)
 ;;55289-0281-30
 ;;9002226.02101,"1198,55289-0281-60 ",.01)
 ;;55289-0281-60
 ;;9002226.02101,"1198,55289-0281-60 ",.02)
 ;;55289-0281-60
 ;;9002226.02101,"1198,55289-0281-86 ",.01)
 ;;55289-0281-86
 ;;9002226.02101,"1198,55289-0281-86 ",.02)
 ;;55289-0281-86
 ;;9002226.02101,"1198,55289-0281-90 ",.01)
 ;;55289-0281-90
 ;;9002226.02101,"1198,55289-0281-90 ",.02)
 ;;55289-0281-90
 ;;9002226.02101,"1198,55289-0384-30 ",.01)
 ;;55289-0384-30
 ;;9002226.02101,"1198,55289-0384-30 ",.02)
 ;;55289-0384-30
 ;;9002226.02101,"1198,55289-0384-60 ",.01)
 ;;55289-0384-60
 ;;9002226.02101,"1198,55289-0384-60 ",.02)
 ;;55289-0384-60
 ;;9002226.02101,"1198,55289-0384-86 ",.01)
 ;;55289-0384-86
 ;;9002226.02101,"1198,55289-0384-86 ",.02)
 ;;55289-0384-86
 ;;9002226.02101,"1198,55289-0384-90 ",.01)
 ;;55289-0384-90
 ;;9002226.02101,"1198,55289-0384-90 ",.02)
 ;;55289-0384-90
 ;;9002226.02101,"1198,55289-0384-93 ",.01)
 ;;55289-0384-93
 ;;9002226.02101,"1198,55289-0384-93 ",.02)
 ;;55289-0384-93
 ;;9002226.02101,"1198,55289-0384-94 ",.01)
 ;;55289-0384-94
 ;;9002226.02101,"1198,55289-0384-94 ",.02)
 ;;55289-0384-94
 ;;9002226.02101,"1198,55289-0615-14 ",.01)
 ;;55289-0615-14
 ;;9002226.02101,"1198,55289-0615-14 ",.02)
 ;;55289-0615-14
 ;;9002226.02101,"1198,55289-0615-30 ",.01)
 ;;55289-0615-30
 ;;9002226.02101,"1198,55289-0615-30 ",.02)
 ;;55289-0615-30
 ;;9002226.02101,"1198,55289-0615-60 ",.01)
 ;;55289-0615-60
 ;;9002226.02101,"1198,55289-0615-60 ",.02)
 ;;55289-0615-60
 ;;9002226.02101,"1198,55289-0615-86 ",.01)
 ;;55289-0615-86
 ;;9002226.02101,"1198,55289-0615-86 ",.02)
 ;;55289-0615-86
 ;;9002226.02101,"1198,55289-0615-90 ",.01)
 ;;55289-0615-90
 ;;9002226.02101,"1198,55289-0615-90 ",.02)
 ;;55289-0615-90
 ;;9002226.02101,"1198,55289-0615-93 ",.01)
 ;;55289-0615-93
 ;;9002226.02101,"1198,55289-0615-93 ",.02)
 ;;55289-0615-93
 ;;9002226.02101,"1198,55289-0615-94 ",.01)
 ;;55289-0615-94
 ;;9002226.02101,"1198,55289-0615-94 ",.02)
 ;;55289-0615-94
 ;;9002226.02101,"1198,55289-0615-98 ",.01)
 ;;55289-0615-98
 ;;9002226.02101,"1198,55289-0615-98 ",.02)
 ;;55289-0615-98
 ;;9002226.02101,"1198,55289-0919-30 ",.01)
 ;;55289-0919-30
 ;;9002226.02101,"1198,55289-0919-30 ",.02)
 ;;55289-0919-30
 ;;9002226.02101,"1198,55289-0919-60 ",.01)
 ;;55289-0919-60
