BGP2VT3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"732,58914-0013-10 ",.02)
 ;;58914-0013-10
 ;;9002226.02101,"732,58914-0015-16 ",.01)
 ;;58914-0015-16
 ;;9002226.02101,"732,58914-0015-16 ",.02)
 ;;58914-0015-16
 ;;9002226.02101,"732,60429-0155-01 ",.01)
 ;;60429-0155-01
 ;;9002226.02101,"732,60429-0155-01 ",.02)
 ;;60429-0155-01
 ;;9002226.02101,"732,60429-0155-10 ",.01)
 ;;60429-0155-10
 ;;9002226.02101,"732,60429-0155-10 ",.02)
 ;;60429-0155-10
 ;;9002226.02101,"732,60429-0156-01 ",.01)
 ;;60429-0156-01
 ;;9002226.02101,"732,60429-0156-01 ",.02)
 ;;60429-0156-01
 ;;9002226.02101,"732,60429-0156-10 ",.01)
 ;;60429-0156-10
 ;;9002226.02101,"732,60429-0156-10 ",.02)
 ;;60429-0156-10
 ;;9002226.02101,"732,61392-0041-45 ",.01)
 ;;61392-0041-45
 ;;9002226.02101,"732,61392-0041-45 ",.02)
 ;;61392-0041-45
 ;;9002226.02101,"732,61392-0041-54 ",.01)
 ;;61392-0041-54
 ;;9002226.02101,"732,61392-0041-54 ",.02)
 ;;61392-0041-54
 ;;9002226.02101,"732,61392-0041-56 ",.01)
 ;;61392-0041-56
 ;;9002226.02101,"732,61392-0041-56 ",.02)
 ;;61392-0041-56
 ;;9002226.02101,"732,61392-0041-91 ",.01)
 ;;61392-0041-91
 ;;9002226.02101,"732,61392-0041-91 ",.02)
 ;;61392-0041-91
 ;;9002226.02101,"732,63629-1299-01 ",.01)
 ;;63629-1299-01
 ;;9002226.02101,"732,63629-1299-01 ",.02)
 ;;63629-1299-01
 ;;9002226.02101,"732,63874-0463-01 ",.01)
 ;;63874-0463-01
 ;;9002226.02101,"732,63874-0463-01 ",.02)
 ;;63874-0463-01
 ;;9002226.02101,"732,63874-0463-02 ",.01)
 ;;63874-0463-02
 ;;9002226.02101,"732,63874-0463-02 ",.02)
 ;;63874-0463-02
 ;;9002226.02101,"732,63874-0463-04 ",.01)
 ;;63874-0463-04
 ;;9002226.02101,"732,63874-0463-04 ",.02)
 ;;63874-0463-04
 ;;9002226.02101,"732,63874-0463-10 ",.01)
 ;;63874-0463-10
 ;;9002226.02101,"732,63874-0463-10 ",.02)
 ;;63874-0463-10
 ;;9002226.02101,"732,63874-0463-12 ",.01)
 ;;63874-0463-12
 ;;9002226.02101,"732,63874-0463-12 ",.02)
 ;;63874-0463-12
 ;;9002226.02101,"732,63874-0463-20 ",.01)
 ;;63874-0463-20
 ;;9002226.02101,"732,63874-0463-20 ",.02)
 ;;63874-0463-20
 ;;9002226.02101,"732,63874-0463-21 ",.01)
 ;;63874-0463-21
 ;;9002226.02101,"732,63874-0463-21 ",.02)
 ;;63874-0463-21
 ;;9002226.02101,"732,63874-0463-28 ",.01)
 ;;63874-0463-28
 ;;9002226.02101,"732,63874-0463-28 ",.02)
 ;;63874-0463-28
 ;;9002226.02101,"732,63874-0463-30 ",.01)
 ;;63874-0463-30
 ;;9002226.02101,"732,63874-0463-30 ",.02)
 ;;63874-0463-30
 ;;9002226.02101,"732,63874-0463-60 ",.01)
 ;;63874-0463-60
 ;;9002226.02101,"732,63874-0463-60 ",.02)
 ;;63874-0463-60
 ;;9002226.02101,"732,63874-0463-90 ",.01)
 ;;63874-0463-90
 ;;9002226.02101,"732,63874-0463-90 ",.02)
 ;;63874-0463-90
 ;;9002226.02101,"732,66267-0074-30 ",.01)
 ;;66267-0074-30
 ;;9002226.02101,"732,66267-0074-30 ",.02)
 ;;66267-0074-30
 ;;9002226.02101,"732,66336-0911-30 ",.01)
 ;;66336-0911-30
 ;;9002226.02101,"732,66336-0911-30 ",.02)
 ;;66336-0911-30
 ;;9002226.02101,"732,68115-0106-20 ",.01)
 ;;68115-0106-20
 ;;9002226.02101,"732,68115-0106-20 ",.02)
 ;;68115-0106-20
 ;;9002226.02101,"732,68115-0106-30 ",.01)
 ;;68115-0106-30
 ;;9002226.02101,"732,68115-0106-30 ",.02)
 ;;68115-0106-30
 ;;9002226.02101,"732,68115-0106-60 ",.01)
 ;;68115-0106-60
 ;;9002226.02101,"732,68115-0106-60 ",.02)
 ;;68115-0106-60
 ;;9002226.02101,"732,68115-0107-10 ",.01)
 ;;68115-0107-10
 ;;9002226.02101,"732,68115-0107-10 ",.02)
 ;;68115-0107-10
 ;;9002226.02101,"732,68115-0107-15 ",.01)
 ;;68115-0107-15
 ;;9002226.02101,"732,68115-0107-15 ",.02)
 ;;68115-0107-15
 ;;9002226.02101,"732,68115-0107-20 ",.01)
 ;;68115-0107-20
 ;;9002226.02101,"732,68115-0107-20 ",.02)
 ;;68115-0107-20
 ;;9002226.02101,"732,68115-0107-30 ",.01)
 ;;68115-0107-30
 ;;9002226.02101,"732,68115-0107-30 ",.02)
 ;;68115-0107-30
