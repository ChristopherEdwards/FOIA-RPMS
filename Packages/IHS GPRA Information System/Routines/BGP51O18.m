BGP51O18 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"804,53489-0591-10 ",.02)
 ;;53489-0591-10
 ;;9002226.02101,"804,54348-0108-09 ",.01)
 ;;54348-0108-09
 ;;9002226.02101,"804,54348-0108-09 ",.02)
 ;;54348-0108-09
 ;;9002226.02101,"804,54348-0108-10 ",.01)
 ;;54348-0108-10
 ;;9002226.02101,"804,54348-0108-10 ",.02)
 ;;54348-0108-10
 ;;9002226.02101,"804,54348-0109-20 ",.01)
 ;;54348-0109-20
 ;;9002226.02101,"804,54348-0109-20 ",.02)
 ;;54348-0109-20
 ;;9002226.02101,"804,54348-0931-10 ",.01)
 ;;54348-0931-10
 ;;9002226.02101,"804,54348-0931-10 ",.02)
 ;;54348-0931-10
 ;;9002226.02101,"804,54569-0838-00 ",.01)
 ;;54569-0838-00
 ;;9002226.02101,"804,54569-0838-00 ",.02)
 ;;54569-0838-00
 ;;9002226.02101,"804,54569-0838-01 ",.01)
 ;;54569-0838-01
 ;;9002226.02101,"804,54569-0838-01 ",.02)
 ;;54569-0838-01
 ;;9002226.02101,"804,54569-0838-02 ",.01)
 ;;54569-0838-02
 ;;9002226.02101,"804,54569-0838-02 ",.02)
 ;;54569-0838-02
 ;;9002226.02101,"804,54569-0838-05 ",.01)
 ;;54569-0838-05
 ;;9002226.02101,"804,54569-0838-05 ",.02)
 ;;54569-0838-05
 ;;9002226.02101,"804,54569-0838-06 ",.01)
 ;;54569-0838-06
 ;;9002226.02101,"804,54569-0838-06 ",.02)
 ;;54569-0838-06
 ;;9002226.02101,"804,54569-0838-07 ",.01)
 ;;54569-0838-07
 ;;9002226.02101,"804,54569-0838-07 ",.02)
 ;;54569-0838-07
 ;;9002226.02101,"804,54569-0843-00 ",.01)
 ;;54569-0843-00
 ;;9002226.02101,"804,54569-0843-00 ",.02)
 ;;54569-0843-00
 ;;9002226.02101,"804,54569-0843-01 ",.01)
 ;;54569-0843-01
 ;;9002226.02101,"804,54569-0843-01 ",.02)
 ;;54569-0843-01
 ;;9002226.02101,"804,54569-0843-02 ",.01)
 ;;54569-0843-02
 ;;9002226.02101,"804,54569-0843-02 ",.02)
 ;;54569-0843-02
 ;;9002226.02101,"804,54569-0843-03 ",.01)
 ;;54569-0843-03
 ;;9002226.02101,"804,54569-0843-03 ",.02)
 ;;54569-0843-03
 ;;9002226.02101,"804,54569-0843-04 ",.01)
 ;;54569-0843-04
 ;;9002226.02101,"804,54569-0843-04 ",.02)
 ;;54569-0843-04
 ;;9002226.02101,"804,54569-0843-06 ",.01)
 ;;54569-0843-06
 ;;9002226.02101,"804,54569-0843-06 ",.02)
 ;;54569-0843-06
 ;;9002226.02101,"804,54569-0843-07 ",.01)
 ;;54569-0843-07
 ;;9002226.02101,"804,54569-0843-07 ",.02)
 ;;54569-0843-07
 ;;9002226.02101,"804,54569-0852-00 ",.01)
 ;;54569-0852-00
 ;;9002226.02101,"804,54569-0852-00 ",.02)
 ;;54569-0852-00
 ;;9002226.02101,"804,54569-0852-01 ",.01)
 ;;54569-0852-01
 ;;9002226.02101,"804,54569-0852-01 ",.02)
 ;;54569-0852-01
 ;;9002226.02101,"804,54569-0852-03 ",.01)
 ;;54569-0852-03
 ;;9002226.02101,"804,54569-0852-03 ",.02)
 ;;54569-0852-03
 ;;9002226.02101,"804,54569-0852-04 ",.01)
 ;;54569-0852-04
 ;;9002226.02101,"804,54569-0852-04 ",.02)
 ;;54569-0852-04
 ;;9002226.02101,"804,54569-0852-05 ",.01)
 ;;54569-0852-05
 ;;9002226.02101,"804,54569-0852-05 ",.02)
 ;;54569-0852-05
 ;;9002226.02101,"804,54569-1709-00 ",.01)
 ;;54569-1709-00
 ;;9002226.02101,"804,54569-1709-00 ",.02)
 ;;54569-1709-00
 ;;9002226.02101,"804,54569-1709-01 ",.01)
 ;;54569-1709-01
 ;;9002226.02101,"804,54569-1709-01 ",.02)
 ;;54569-1709-01
 ;;9002226.02101,"804,54569-1709-02 ",.01)
 ;;54569-1709-02
 ;;9002226.02101,"804,54569-1709-02 ",.02)
 ;;54569-1709-02
 ;;9002226.02101,"804,54569-1709-03 ",.01)
 ;;54569-1709-03
 ;;9002226.02101,"804,54569-1709-03 ",.02)
 ;;54569-1709-03
 ;;9002226.02101,"804,54569-1709-04 ",.01)
 ;;54569-1709-04
 ;;9002226.02101,"804,54569-1709-04 ",.02)
 ;;54569-1709-04
 ;;9002226.02101,"804,54569-1709-07 ",.01)
 ;;54569-1709-07
 ;;9002226.02101,"804,54569-1709-07 ",.02)
 ;;54569-1709-07
 ;;9002226.02101,"804,54569-1709-08 ",.01)
 ;;54569-1709-08
 ;;9002226.02101,"804,54569-1709-08 ",.02)
 ;;54569-1709-08
 ;;9002226.02101,"804,54569-1709-09 ",.01)
 ;;54569-1709-09
 ;;9002226.02101,"804,54569-1709-09 ",.02)
 ;;54569-1709-09
 ;;9002226.02101,"804,54569-1970-00 ",.01)
 ;;54569-1970-00
 ;;9002226.02101,"804,54569-1970-00 ",.02)
 ;;54569-1970-00
 ;;9002226.02101,"804,54569-1970-01 ",.01)
 ;;54569-1970-01
 ;;9002226.02101,"804,54569-1970-01 ",.02)
 ;;54569-1970-01
 ;;9002226.02101,"804,54569-1970-02 ",.01)
 ;;54569-1970-02
 ;;9002226.02101,"804,54569-1970-02 ",.02)
 ;;54569-1970-02
 ;;9002226.02101,"804,54569-1970-03 ",.01)
 ;;54569-1970-03
 ;;9002226.02101,"804,54569-1970-03 ",.02)
 ;;54569-1970-03
 ;;9002226.02101,"804,54569-1970-04 ",.01)
 ;;54569-1970-04
 ;;9002226.02101,"804,54569-1970-04 ",.02)
 ;;54569-1970-04
 ;;9002226.02101,"804,54569-1970-05 ",.01)
 ;;54569-1970-05
 ;;9002226.02101,"804,54569-1970-05 ",.02)
 ;;54569-1970-05
 ;;9002226.02101,"804,54569-2573-00 ",.01)
 ;;54569-2573-00
 ;;9002226.02101,"804,54569-2573-00 ",.02)
 ;;54569-2573-00
 ;;9002226.02101,"804,54569-2573-01 ",.01)
 ;;54569-2573-01
 ;;9002226.02101,"804,54569-2573-01 ",.02)
 ;;54569-2573-01
 ;;9002226.02101,"804,54569-2573-02 ",.01)
 ;;54569-2573-02
 ;;9002226.02101,"804,54569-2573-02 ",.02)
 ;;54569-2573-02
 ;;9002226.02101,"804,54569-2573-03 ",.01)
 ;;54569-2573-03
 ;;9002226.02101,"804,54569-2573-03 ",.02)
 ;;54569-2573-03
 ;;9002226.02101,"804,54569-2573-04 ",.01)
 ;;54569-2573-04
 ;;9002226.02101,"804,54569-2573-04 ",.02)
 ;;54569-2573-04
 ;;9002226.02101,"804,54569-2573-06 ",.01)
 ;;54569-2573-06
 ;;9002226.02101,"804,54569-2573-06 ",.02)
 ;;54569-2573-06
 ;;9002226.02101,"804,54569-2573-07 ",.01)
 ;;54569-2573-07
 ;;9002226.02101,"804,54569-2573-07 ",.02)
 ;;54569-2573-07
 ;;9002226.02101,"804,54569-2573-08 ",.01)
 ;;54569-2573-08
 ;;9002226.02101,"804,54569-2573-08 ",.02)
 ;;54569-2573-08
 ;;9002226.02101,"804,54569-2573-09 ",.01)
 ;;54569-2573-09
 ;;9002226.02101,"804,54569-2573-09 ",.02)
 ;;54569-2573-09
 ;;9002226.02101,"804,54569-3193-01 ",.01)
 ;;54569-3193-01
 ;;9002226.02101,"804,54569-3193-01 ",.02)
 ;;54569-3193-01
 ;;9002226.02101,"804,54569-3193-05 ",.01)
 ;;54569-3193-05
 ;;9002226.02101,"804,54569-3193-05 ",.02)
 ;;54569-3193-05
 ;;9002226.02101,"804,54569-3193-08 ",.01)
 ;;54569-3193-08
 ;;9002226.02101,"804,54569-3193-08 ",.02)
 ;;54569-3193-08
 ;;9002226.02101,"804,54569-3403-00 ",.01)
 ;;54569-3403-00
 ;;9002226.02101,"804,54569-3403-00 ",.02)
 ;;54569-3403-00
 ;;9002226.02101,"804,54569-3403-01 ",.01)
 ;;54569-3403-01
 ;;9002226.02101,"804,54569-3403-01 ",.02)
 ;;54569-3403-01
 ;;9002226.02101,"804,54569-3403-04 ",.01)
 ;;54569-3403-04
 ;;9002226.02101,"804,54569-3403-04 ",.02)
 ;;54569-3403-04
 ;;9002226.02101,"804,54569-3403-05 ",.01)
 ;;54569-3403-05
 ;;9002226.02101,"804,54569-3403-05 ",.02)
 ;;54569-3403-05
 ;;9002226.02101,"804,54569-3403-09 ",.01)
 ;;54569-3403-09
 ;;9002226.02101,"804,54569-3403-09 ",.02)
 ;;54569-3403-09
 ;;9002226.02101,"804,54569-4048-04 ",.01)
 ;;54569-4048-04
 ;;9002226.02101,"804,54569-4048-04 ",.02)
 ;;54569-4048-04
 ;;9002226.02101,"804,54569-4614-00 ",.01)
 ;;54569-4614-00
 ;;9002226.02101,"804,54569-4614-00 ",.02)
 ;;54569-4614-00
 ;;9002226.02101,"804,54569-4614-02 ",.01)
 ;;54569-4614-02
 ;;9002226.02101,"804,54569-4614-02 ",.02)
 ;;54569-4614-02
 ;;9002226.02101,"804,54569-4614-04 ",.01)
 ;;54569-4614-04
 ;;9002226.02101,"804,54569-4614-04 ",.02)
 ;;54569-4614-04
 ;;9002226.02101,"804,54569-5030-01 ",.01)
 ;;54569-5030-01
 ;;9002226.02101,"804,54569-5030-01 ",.02)
 ;;54569-5030-01
 ;;9002226.02101,"804,54569-5184-00 ",.01)
 ;;54569-5184-00
 ;;9002226.02101,"804,54569-5184-00 ",.02)
 ;;54569-5184-00
 ;;9002226.02101,"804,54569-5477-00 ",.01)
 ;;54569-5477-00
 ;;9002226.02101,"804,54569-5477-00 ",.02)
 ;;54569-5477-00
 ;;9002226.02101,"804,54569-5477-01 ",.01)
 ;;54569-5477-01
 ;;9002226.02101,"804,54569-5477-01 ",.02)
 ;;54569-5477-01
 ;;9002226.02101,"804,54569-5477-02 ",.01)
 ;;54569-5477-02
 ;;9002226.02101,"804,54569-5477-02 ",.02)
 ;;54569-5477-02
 ;;9002226.02101,"804,54569-5477-05 ",.01)
 ;;54569-5477-05
 ;;9002226.02101,"804,54569-5477-05 ",.02)
 ;;54569-5477-05
 ;;9002226.02101,"804,54569-5477-06 ",.01)
 ;;54569-5477-06
 ;;9002226.02101,"804,54569-5477-06 ",.02)
 ;;54569-5477-06
 ;;9002226.02101,"804,54569-5782-00 ",.01)
 ;;54569-5782-00
 ;;9002226.02101,"804,54569-5782-00 ",.02)
 ;;54569-5782-00
 ;;9002226.02101,"804,54569-5782-01 ",.01)
 ;;54569-5782-01
 ;;9002226.02101,"804,54569-5782-01 ",.02)
 ;;54569-5782-01
 ;;9002226.02101,"804,54569-5782-02 ",.01)
 ;;54569-5782-02
 ;;9002226.02101,"804,54569-5782-02 ",.02)
 ;;54569-5782-02
 ;;9002226.02101,"804,54569-5966-00 ",.01)
 ;;54569-5966-00
 ;;9002226.02101,"804,54569-5966-00 ",.02)
 ;;54569-5966-00
 ;;9002226.02101,"804,54569-6064-00 ",.01)
 ;;54569-6064-00
 ;;9002226.02101,"804,54569-6064-00 ",.02)
 ;;54569-6064-00
 ;;9002226.02101,"804,54569-6064-01 ",.01)
 ;;54569-6064-01
 ;;9002226.02101,"804,54569-6064-01 ",.02)
 ;;54569-6064-01
 ;;9002226.02101,"804,54569-6064-02 ",.01)
 ;;54569-6064-02
 ;;9002226.02101,"804,54569-6064-02 ",.02)
 ;;54569-6064-02
 ;;9002226.02101,"804,54569-6186-00 ",.01)
 ;;54569-6186-00
 ;;9002226.02101,"804,54569-6186-00 ",.02)
 ;;54569-6186-00
 ;;9002226.02101,"804,54569-6186-01 ",.01)
 ;;54569-6186-01
 ;;9002226.02101,"804,54569-6186-01 ",.02)
 ;;54569-6186-01
 ;;9002226.02101,"804,54569-6186-02 ",.01)
 ;;54569-6186-02
 ;;9002226.02101,"804,54569-6186-02 ",.02)
 ;;54569-6186-02
 ;;9002226.02101,"804,54569-6186-03 ",.01)
 ;;54569-6186-03
 ;;9002226.02101,"804,54569-6186-03 ",.02)
 ;;54569-6186-03
 ;;9002226.02101,"804,54569-6186-04 ",.01)
 ;;54569-6186-04
 ;;9002226.02101,"804,54569-6186-04 ",.02)
 ;;54569-6186-04
 ;;9002226.02101,"804,54569-6243-00 ",.01)
 ;;54569-6243-00
 ;;9002226.02101,"804,54569-6243-00 ",.02)
 ;;54569-6243-00
 ;;9002226.02101,"804,54569-6329-00 ",.01)
 ;;54569-6329-00
 ;;9002226.02101,"804,54569-6329-00 ",.02)
 ;;54569-6329-00
 ;;9002226.02101,"804,54569-6360-00 ",.01)
 ;;54569-6360-00
 ;;9002226.02101,"804,54569-6360-00 ",.02)
 ;;54569-6360-00
 ;;9002226.02101,"804,54569-6360-01 ",.01)
 ;;54569-6360-01
 ;;9002226.02101,"804,54569-6360-01 ",.02)
 ;;54569-6360-01
 ;;9002226.02101,"804,54569-6360-02 ",.01)
 ;;54569-6360-02
 ;;9002226.02101,"804,54569-6360-02 ",.02)
 ;;54569-6360-02
 ;;9002226.02101,"804,54569-6360-03 ",.01)
 ;;54569-6360-03
 ;;9002226.02101,"804,54569-6360-03 ",.02)
 ;;54569-6360-03
 ;;9002226.02101,"804,54569-6360-04 ",.01)
 ;;54569-6360-04
 ;;9002226.02101,"804,54569-6360-04 ",.02)
 ;;54569-6360-04
 ;;9002226.02101,"804,54569-6472-00 ",.01)
 ;;54569-6472-00
 ;;9002226.02101,"804,54569-6472-00 ",.02)
 ;;54569-6472-00
 ;;9002226.02101,"804,54569-8302-00 ",.01)
 ;;54569-8302-00
 ;;9002226.02101,"804,54569-8302-00 ",.02)
 ;;54569-8302-00
 ;;9002226.02101,"804,54569-8317-00 ",.01)
 ;;54569-8317-00
 ;;9002226.02101,"804,54569-8317-00 ",.02)
 ;;54569-8317-00
 ;;9002226.02101,"804,54569-8328-00 ",.01)
 ;;54569-8328-00
 ;;9002226.02101,"804,54569-8328-00 ",.02)
 ;;54569-8328-00
 ;;9002226.02101,"804,54868-0586-02 ",.01)
 ;;54868-0586-02
 ;;9002226.02101,"804,54868-0586-02 ",.02)
 ;;54868-0586-02
 ;;9002226.02101,"804,54868-0586-03 ",.01)
 ;;54868-0586-03
 ;;9002226.02101,"804,54868-0586-03 ",.02)
 ;;54868-0586-03
 ;;9002226.02101,"804,54868-0586-06 ",.01)
 ;;54868-0586-06
 ;;9002226.02101,"804,54868-0586-06 ",.02)
 ;;54868-0586-06
 ;;9002226.02101,"804,54868-0586-07 ",.01)
 ;;54868-0586-07
 ;;9002226.02101,"804,54868-0586-07 ",.02)
 ;;54868-0586-07
 ;;9002226.02101,"804,54868-0586-08 ",.01)
 ;;54868-0586-08
 ;;9002226.02101,"804,54868-0586-08 ",.02)
 ;;54868-0586-08
 ;;9002226.02101,"804,54868-0604-00 ",.01)
 ;;54868-0604-00
 ;;9002226.02101,"804,54868-0604-00 ",.02)
 ;;54868-0604-00
 ;;9002226.02101,"804,54868-0735-00 ",.01)
 ;;54868-0735-00
 ;;9002226.02101,"804,54868-0735-00 ",.02)
 ;;54868-0735-00
 ;;9002226.02101,"804,54868-0735-02 ",.01)
 ;;54868-0735-02
 ;;9002226.02101,"804,54868-0735-02 ",.02)
 ;;54868-0735-02
 ;;9002226.02101,"804,54868-0735-03 ",.01)
 ;;54868-0735-03
 ;;9002226.02101,"804,54868-0735-03 ",.02)
 ;;54868-0735-03
 ;;9002226.02101,"804,54868-0735-04 ",.01)
 ;;54868-0735-04
 ;;9002226.02101,"804,54868-0735-04 ",.02)
 ;;54868-0735-04
 ;;9002226.02101,"804,54868-0735-05 ",.01)
 ;;54868-0735-05
 ;;9002226.02101,"804,54868-0735-05 ",.02)
 ;;54868-0735-05
 ;;9002226.02101,"804,54868-0735-07 ",.01)
 ;;54868-0735-07
 ;;9002226.02101,"804,54868-0735-07 ",.02)
 ;;54868-0735-07
 ;;9002226.02101,"804,54868-0735-08 ",.01)
 ;;54868-0735-08
 ;;9002226.02101,"804,54868-0735-08 ",.02)
 ;;54868-0735-08
 ;;9002226.02101,"804,54868-0816-00 ",.01)
 ;;54868-0816-00
 ;;9002226.02101,"804,54868-0816-00 ",.02)
 ;;54868-0816-00
 ;;9002226.02101,"804,54868-0816-02 ",.01)
 ;;54868-0816-02
 ;;9002226.02101,"804,54868-0816-02 ",.02)
 ;;54868-0816-02
 ;;9002226.02101,"804,54868-0816-03 ",.01)
 ;;54868-0816-03
 ;;9002226.02101,"804,54868-0816-03 ",.02)
 ;;54868-0816-03
 ;;9002226.02101,"804,54868-0816-04 ",.01)
 ;;54868-0816-04
 ;;9002226.02101,"804,54868-0816-04 ",.02)
 ;;54868-0816-04
 ;;9002226.02101,"804,54868-0816-05 ",.01)
 ;;54868-0816-05
 ;;9002226.02101,"804,54868-0816-05 ",.02)
 ;;54868-0816-05
 ;;9002226.02101,"804,54868-0816-06 ",.01)
 ;;54868-0816-06
 ;;9002226.02101,"804,54868-0816-06 ",.02)
 ;;54868-0816-06
 ;;9002226.02101,"804,54868-0816-07 ",.01)
 ;;54868-0816-07
 ;;9002226.02101,"804,54868-0816-07 ",.02)
 ;;54868-0816-07
 ;;9002226.02101,"804,54868-0816-08 ",.01)
 ;;54868-0816-08
 ;;9002226.02101,"804,54868-0816-08 ",.02)
 ;;54868-0816-08
 ;;9002226.02101,"804,54868-0816-09 ",.01)
 ;;54868-0816-09
 ;;9002226.02101,"804,54868-0816-09 ",.02)
 ;;54868-0816-09
 ;;9002226.02101,"804,54868-1017-00 ",.01)
 ;;54868-1017-00
 ;;9002226.02101,"804,54868-1017-00 ",.02)
 ;;54868-1017-00
 ;;9002226.02101,"804,54868-1103-01 ",.01)
 ;;54868-1103-01