BGP21L47 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,68382-0067-06 ",.02)
 ;;68382-0067-06
 ;;9002226.02101,"1201,68382-0067-10 ",.01)
 ;;68382-0067-10
 ;;9002226.02101,"1201,68382-0067-10 ",.02)
 ;;68382-0067-10
 ;;9002226.02101,"1201,68382-0067-14 ",.01)
 ;;68382-0067-14
 ;;9002226.02101,"1201,68382-0067-14 ",.02)
 ;;68382-0067-14
 ;;9002226.02101,"1201,68382-0067-16 ",.01)
 ;;68382-0067-16
 ;;9002226.02101,"1201,68382-0067-16 ",.02)
 ;;68382-0067-16
 ;;9002226.02101,"1201,68382-0067-24 ",.01)
 ;;68382-0067-24
 ;;9002226.02101,"1201,68382-0067-24 ",.02)
 ;;68382-0067-24
 ;;9002226.02101,"1201,68382-0068-05 ",.01)
 ;;68382-0068-05
 ;;9002226.02101,"1201,68382-0068-05 ",.02)
 ;;68382-0068-05
 ;;9002226.02101,"1201,68382-0068-06 ",.01)
 ;;68382-0068-06
 ;;9002226.02101,"1201,68382-0068-06 ",.02)
 ;;68382-0068-06
 ;;9002226.02101,"1201,68382-0068-10 ",.01)
 ;;68382-0068-10
 ;;9002226.02101,"1201,68382-0068-10 ",.02)
 ;;68382-0068-10
 ;;9002226.02101,"1201,68382-0068-14 ",.01)
 ;;68382-0068-14
 ;;9002226.02101,"1201,68382-0068-14 ",.02)
 ;;68382-0068-14
 ;;9002226.02101,"1201,68382-0068-16 ",.01)
 ;;68382-0068-16
 ;;9002226.02101,"1201,68382-0068-16 ",.02)
 ;;68382-0068-16
 ;;9002226.02101,"1201,68382-0068-40 ",.01)
 ;;68382-0068-40
 ;;9002226.02101,"1201,68382-0068-40 ",.02)
 ;;68382-0068-40
 ;;9002226.02101,"1201,68382-0069-05 ",.01)
 ;;68382-0069-05
 ;;9002226.02101,"1201,68382-0069-05 ",.02)
 ;;68382-0069-05
 ;;9002226.02101,"1201,68382-0069-06 ",.01)
 ;;68382-0069-06
 ;;9002226.02101,"1201,68382-0069-06 ",.02)
 ;;68382-0069-06
 ;;9002226.02101,"1201,68382-0069-10 ",.01)
 ;;68382-0069-10
 ;;9002226.02101,"1201,68382-0069-10 ",.02)
 ;;68382-0069-10
 ;;9002226.02101,"1201,68382-0069-14 ",.01)
 ;;68382-0069-14
 ;;9002226.02101,"1201,68382-0069-14 ",.02)
 ;;68382-0069-14
 ;;9002226.02101,"1201,68382-0069-16 ",.01)
 ;;68382-0069-16
 ;;9002226.02101,"1201,68382-0069-16 ",.02)
 ;;68382-0069-16
 ;;9002226.02101,"1201,68382-0070-05 ",.01)
 ;;68382-0070-05
 ;;9002226.02101,"1201,68382-0070-05 ",.02)
 ;;68382-0070-05
 ;;9002226.02101,"1201,68382-0070-16 ",.01)
 ;;68382-0070-16
 ;;9002226.02101,"1201,68382-0070-16 ",.02)
 ;;68382-0070-16
 ;;9002226.02101,"1201,68382-0071-05 ",.01)
 ;;68382-0071-05
 ;;9002226.02101,"1201,68382-0071-05 ",.02)
 ;;68382-0071-05
 ;;9002226.02101,"1201,68382-0071-16 ",.01)
 ;;68382-0071-16
 ;;9002226.02101,"1201,68382-0071-16 ",.02)
 ;;68382-0071-16
 ;;9002226.02101,"1201,68382-0072-05 ",.01)
 ;;68382-0072-05
 ;;9002226.02101,"1201,68382-0072-05 ",.02)
 ;;68382-0072-05
 ;;9002226.02101,"1201,68382-0072-16 ",.01)
 ;;68382-0072-16
 ;;9002226.02101,"1201,68382-0072-16 ",.02)
 ;;68382-0072-16
 ;;9002226.02101,"1201,68382-0073-05 ",.01)
 ;;68382-0073-05
 ;;9002226.02101,"1201,68382-0073-05 ",.02)
 ;;68382-0073-05
 ;;9002226.02101,"1201,68382-0073-16 ",.01)
 ;;68382-0073-16
 ;;9002226.02101,"1201,68382-0073-16 ",.02)
 ;;68382-0073-16
 ;;9002226.02101,"1201,68462-0195-05 ",.01)
 ;;68462-0195-05
 ;;9002226.02101,"1201,68462-0195-05 ",.02)
 ;;68462-0195-05
 ;;9002226.02101,"1201,68462-0195-90 ",.01)
 ;;68462-0195-90
 ;;9002226.02101,"1201,68462-0195-90 ",.02)
 ;;68462-0195-90
 ;;9002226.02101,"1201,68462-0196-05 ",.01)
 ;;68462-0196-05
 ;;9002226.02101,"1201,68462-0196-05 ",.02)
 ;;68462-0196-05
 ;;9002226.02101,"1201,68462-0196-90 ",.01)
 ;;68462-0196-90
 ;;9002226.02101,"1201,68462-0196-90 ",.02)
 ;;68462-0196-90
 ;;9002226.02101,"1201,68462-0197-05 ",.01)
 ;;68462-0197-05
 ;;9002226.02101,"1201,68462-0197-05 ",.02)
 ;;68462-0197-05
 ;;9002226.02101,"1201,68462-0197-90 ",.01)
 ;;68462-0197-90
 ;;9002226.02101,"1201,68462-0197-90 ",.02)
 ;;68462-0197-90
 ;;9002226.02101,"1201,68462-0198-05 ",.01)
 ;;68462-0198-05
 ;;9002226.02101,"1201,68462-0198-05 ",.02)
 ;;68462-0198-05
 ;;9002226.02101,"1201,68462-0198-90 ",.01)
 ;;68462-0198-90
 ;;9002226.02101,"1201,68462-0198-90 ",.02)
 ;;68462-0198-90
 ;;9002226.02101,"1201,68645-0262-54 ",.01)
 ;;68645-0262-54
 ;;9002226.02101,"1201,68645-0262-54 ",.02)
 ;;68645-0262-54
