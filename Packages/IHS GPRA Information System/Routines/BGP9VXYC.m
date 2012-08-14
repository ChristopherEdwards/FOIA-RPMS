BGP9VXYC ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON MAR 25, 2009 ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"889,00135-0198-07 ",.01)
 ;;00135-0198-07
 ;;9002226.02101,"889,00135-0198-07 ",.02)
 ;;00135-0198-07
 ;;9002226.02101,"889,00135-0208-01 ",.01)
 ;;00135-0208-01
 ;;9002226.02101,"889,00135-0208-01 ",.02)
 ;;00135-0208-01
 ;;9002226.02101,"889,00135-0209-01 ",.01)
 ;;00135-0209-01
 ;;9002226.02101,"889,00135-0209-01 ",.02)
 ;;00135-0209-01
 ;;9002226.02101,"889,00173-0135-55 ",.01)
 ;;00173-0135-55
 ;;9002226.02101,"889,00173-0135-55 ",.02)
 ;;00173-0135-55
 ;;9002226.02101,"889,00173-0177-55 ",.01)
 ;;00173-0177-55
 ;;9002226.02101,"889,00173-0177-55 ",.02)
 ;;00173-0177-55
 ;;9002226.02101,"889,00173-0178-55 ",.01)
 ;;00173-0178-55
 ;;9002226.02101,"889,00173-0178-55 ",.02)
 ;;00173-0178-55
 ;;9002226.02101,"889,00173-0556-01 ",.01)
 ;;00173-0556-01
 ;;9002226.02101,"889,00173-0556-01 ",.02)
 ;;00173-0556-01
 ;;9002226.02101,"889,00173-0556-02 ",.01)
 ;;00173-0556-02
 ;;9002226.02101,"889,00173-0556-02 ",.02)
 ;;00173-0556-02
 ;;9002226.02101,"889,00173-0730-01 ",.01)
 ;;00173-0730-01
 ;;9002226.02101,"889,00173-0730-01 ",.02)
 ;;00173-0730-01
 ;;9002226.02101,"889,00173-0730-02 ",.01)
 ;;00173-0730-02
 ;;9002226.02101,"889,00173-0730-02 ",.02)
 ;;00173-0730-02
 ;;9002226.02101,"889,00173-0947-55 ",.01)
 ;;00173-0947-55
 ;;9002226.02101,"889,00173-0947-55 ",.02)
 ;;00173-0947-55
 ;;9002226.02101,"889,00185-0410-01 ",.01)
 ;;00185-0410-01
 ;;9002226.02101,"889,00185-0410-01 ",.02)
 ;;00185-0410-01
 ;;9002226.02101,"889,00185-0410-05 ",.01)
 ;;00185-0410-05
 ;;9002226.02101,"889,00185-0410-05 ",.02)
 ;;00185-0410-05
 ;;9002226.02101,"889,00185-0410-60 ",.01)
 ;;00185-0410-60
 ;;9002226.02101,"889,00185-0410-60 ",.02)
 ;;00185-0410-60
 ;;9002226.02101,"889,00185-0415-01 ",.01)
 ;;00185-0415-01
 ;;9002226.02101,"889,00185-0415-01 ",.02)
 ;;00185-0415-01
 ;;9002226.02101,"889,00185-0415-05 ",.01)
 ;;00185-0415-05
 ;;9002226.02101,"889,00185-0415-05 ",.02)
 ;;00185-0415-05
 ;;9002226.02101,"889,00185-0415-60 ",.01)
 ;;00185-0415-60
 ;;9002226.02101,"889,00185-0415-60 ",.02)
 ;;00185-0415-60
 ;;9002226.02101,"889,00364-2890-30 ",.01)
 ;;00364-2890-30
 ;;9002226.02101,"889,00364-2890-30 ",.02)
 ;;00364-2890-30
 ;;9002226.02101,"889,00364-2893-30 ",.01)
 ;;00364-2893-30
 ;;9002226.02101,"889,00364-2893-30 ",.02)
 ;;00364-2893-30
 ;;9002226.02101,"889,00378-0433-01 ",.01)
 ;;00378-0433-01
 ;;9002226.02101,"889,00378-0433-01 ",.02)
 ;;00378-0433-01
 ;;9002226.02101,"889,00378-0435-01 ",.01)
 ;;00378-0435-01
 ;;9002226.02101,"889,00378-0435-01 ",.02)
 ;;00378-0435-01
 ;;9002226.02101,"889,00501-6304-96 ",.01)
 ;;00501-6304-96
 ;;9002226.02101,"889,00501-6304-96 ",.02)
 ;;00501-6304-96
 ;;9002226.02101,"889,00501-6306-04 ",.01)
 ;;00501-6306-04
 ;;9002226.02101,"889,00501-6306-04 ",.02)
 ;;00501-6306-04
 ;;9002226.02101,"889,00536-1362-06 ",.01)
 ;;00536-1362-06
 ;;9002226.02101,"889,00536-1362-06 ",.02)
 ;;00536-1362-06
 ;;9002226.02101,"889,00536-1362-23 ",.01)
 ;;00536-1362-23
 ;;9002226.02101,"889,00536-1362-23 ",.02)
 ;;00536-1362-23
 ;;9002226.02101,"889,00536-1362-34 ",.01)
 ;;00536-1362-34
 ;;9002226.02101,"889,00536-1362-34 ",.02)
 ;;00536-1362-34
 ;;9002226.02101,"889,00536-1372-06 ",.01)
 ;;00536-1372-06
 ;;9002226.02101,"889,00536-1372-06 ",.02)
 ;;00536-1372-06
 ;;9002226.02101,"889,00536-1372-23 ",.01)
 ;;00536-1372-23
 ;;9002226.02101,"889,00536-1372-23 ",.02)
 ;;00536-1372-23
 ;;9002226.02101,"889,00536-1372-34 ",.01)
 ;;00536-1372-34
 ;;9002226.02101,"889,00536-1372-34 ",.02)
 ;;00536-1372-34
 ;;9002226.02101,"889,00536-3106-06 ",.01)
 ;;00536-3106-06
 ;;9002226.02101,"889,00536-3106-06 ",.02)
 ;;00536-3106-06
 ;;9002226.02101,"889,00536-3106-23 ",.01)
 ;;00536-3106-23
 ;;9002226.02101,"889,00536-3106-23 ",.02)
 ;;00536-3106-23
 ;;9002226.02101,"889,00536-3106-34 ",.01)
 ;;00536-3106-34
 ;;9002226.02101,"889,00536-3106-34 ",.02)
 ;;00536-3106-34
 ;;9002226.02101,"889,00536-3107-06 ",.01)
 ;;00536-3107-06
 ;;9002226.02101,"889,00536-3107-06 ",.02)
 ;;00536-3107-06
 ;;9002226.02101,"889,00536-3107-23 ",.01)
 ;;00536-3107-23
 ;;9002226.02101,"889,00536-3107-23 ",.02)
 ;;00536-3107-23
 ;;9002226.02101,"889,00536-3107-34 ",.01)
 ;;00536-3107-34
 ;;9002226.02101,"889,00536-3107-34 ",.02)
 ;;00536-3107-34
 ;;9002226.02101,"889,00591-0839-25 ",.01)
 ;;00591-0839-25
 ;;9002226.02101,"889,00591-0839-25 ",.02)
 ;;00591-0839-25
 ;;9002226.02101,"889,00591-0839-60 ",.01)
 ;;00591-0839-60
 ;;9002226.02101,"889,00591-0839-60 ",.02)
 ;;00591-0839-60
 ;;9002226.02101,"889,00591-0858-60 ",.01)
 ;;00591-0858-60
 ;;9002226.02101,"889,00591-0858-60 ",.02)
 ;;00591-0858-60
 ;;9002226.02101,"889,00591-0867-60 ",.01)
 ;;00591-0867-60
 ;;9002226.02101,"889,00591-0867-60 ",.02)
 ;;00591-0867-60
 ;;9002226.02101,"889,00591-0867-76 ",.01)
 ;;00591-0867-76
 ;;9002226.02101,"889,00591-0867-76 ",.02)
 ;;00591-0867-76
 ;;9002226.02101,"889,00591-2890-30 ",.01)
 ;;00591-2890-30
 ;;9002226.02101,"889,00591-2890-30 ",.02)
 ;;00591-2890-30
 ;;9002226.02101,"889,00591-2893-30 ",.01)
 ;;00591-2893-30
 ;;9002226.02101,"889,00591-2893-30 ",.02)
 ;;00591-2893-30
 ;;9002226.02101,"889,00591-2901-30 ",.01)
 ;;00591-2901-30
 ;;9002226.02101,"889,00591-2901-30 ",.02)
 ;;00591-2901-30