BGP14E2 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON APR 14, 2011 ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1107,59930-1560-02 ",.01)
 ;;59930-1560-02
 ;;9002226.02101,"1107,59930-1560-02 ",.02)
 ;;59930-1560-02
 ;;9002226.02101,"1107,62037-0794-44 ",.01)
 ;;62037-0794-44
 ;;9002226.02101,"1107,62037-0794-44 ",.02)
 ;;62037-0794-44
 ;;9002226.02101,"1107,63402-0510-01 ",.01)
 ;;63402-0510-01
 ;;9002226.02101,"1107,63402-0510-01 ",.02)
 ;;63402-0510-01
 ;;9002226.02101,"1107,66116-0664-17 ",.01)
 ;;66116-0664-17
 ;;9002226.02101,"1107,66116-0664-17 ",.02)
 ;;66116-0664-17
 ;;9002226.02101,"1107,66267-0995-17 ",.01)
 ;;66267-0995-17
 ;;9002226.02101,"1107,66267-0995-17 ",.02)
 ;;66267-0995-17
 ;;9002226.02101,"1107,68115-0769-17 ",.01)
 ;;68115-0769-17
 ;;9002226.02101,"1107,68115-0769-17 ",.02)
 ;;68115-0769-17
 ;;9002226.02101,"1107,68115-0995-17 ",.01)
 ;;68115-0995-17
 ;;9002226.02101,"1107,68115-0995-17 ",.02)
 ;;68115-0995-17
 ;;9002226.02101,"1107,68258-3037-06 ",.01)
 ;;68258-3037-06
 ;;9002226.02101,"1107,68258-3037-06 ",.02)
 ;;68258-3037-06