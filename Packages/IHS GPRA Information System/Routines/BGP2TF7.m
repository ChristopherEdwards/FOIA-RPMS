BGP2TF7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1198,21695-0472-60 ",.02)
 ;;21695-0472-60
 ;;9002226.02101,"1198,21695-0473-00 ",.01)
 ;;21695-0473-00
 ;;9002226.02101,"1198,21695-0473-00 ",.02)
 ;;21695-0473-00
 ;;9002226.02101,"1198,21695-0473-30 ",.01)
 ;;21695-0473-30
 ;;9002226.02101,"1198,21695-0473-30 ",.02)
 ;;21695-0473-30
 ;;9002226.02101,"1198,21695-0473-60 ",.01)
 ;;21695-0473-60
 ;;9002226.02101,"1198,21695-0473-60 ",.02)
 ;;21695-0473-60
 ;;9002226.02101,"1198,21695-0473-78 ",.01)
 ;;21695-0473-78
 ;;9002226.02101,"1198,21695-0473-78 ",.02)
 ;;21695-0473-78
 ;;9002226.02101,"1198,21695-0473-90 ",.01)
 ;;21695-0473-90
 ;;9002226.02101,"1198,21695-0473-90 ",.02)
 ;;21695-0473-90
 ;;9002226.02101,"1198,21695-0568-30 ",.01)
 ;;21695-0568-30
 ;;9002226.02101,"1198,21695-0568-30 ",.02)
 ;;21695-0568-30
 ;;9002226.02101,"1198,21695-0828-30 ",.01)
 ;;21695-0828-30
 ;;9002226.02101,"1198,21695-0828-30 ",.02)
 ;;21695-0828-30
 ;;9002226.02101,"1198,21695-0828-60 ",.01)
 ;;21695-0828-60
 ;;9002226.02101,"1198,21695-0828-60 ",.02)
 ;;21695-0828-60
 ;;9002226.02101,"1198,21695-0828-90 ",.01)
 ;;21695-0828-90
 ;;9002226.02101,"1198,21695-0828-90 ",.02)
 ;;21695-0828-90
 ;;9002226.02101,"1198,21695-0894-00 ",.01)
 ;;21695-0894-00
 ;;9002226.02101,"1198,21695-0894-00 ",.02)
 ;;21695-0894-00
 ;;9002226.02101,"1198,23155-0102-01 ",.01)
 ;;23155-0102-01
 ;;9002226.02101,"1198,23155-0102-01 ",.02)
 ;;23155-0102-01
 ;;9002226.02101,"1198,23155-0102-05 ",.01)
 ;;23155-0102-05
 ;;9002226.02101,"1198,23155-0102-05 ",.02)
 ;;23155-0102-05
 ;;9002226.02101,"1198,23155-0102-10 ",.01)
 ;;23155-0102-10
 ;;9002226.02101,"1198,23155-0102-10 ",.02)
 ;;23155-0102-10
 ;;9002226.02101,"1198,23155-0103-01 ",.01)
 ;;23155-0103-01
 ;;9002226.02101,"1198,23155-0103-01 ",.02)
 ;;23155-0103-01
 ;;9002226.02101,"1198,23155-0103-05 ",.01)
 ;;23155-0103-05
 ;;9002226.02101,"1198,23155-0103-05 ",.02)
 ;;23155-0103-05
 ;;9002226.02101,"1198,23155-0103-10 ",.01)
 ;;23155-0103-10
 ;;9002226.02101,"1198,23155-0103-10 ",.02)
 ;;23155-0103-10
 ;;9002226.02101,"1198,23155-0104-01 ",.01)
 ;;23155-0104-01
 ;;9002226.02101,"1198,23155-0104-01 ",.02)
 ;;23155-0104-01
 ;;9002226.02101,"1198,23155-0104-05 ",.01)
 ;;23155-0104-05
 ;;9002226.02101,"1198,23155-0104-05 ",.02)
 ;;23155-0104-05
 ;;9002226.02101,"1198,23155-0104-10 ",.01)
 ;;23155-0104-10
 ;;9002226.02101,"1198,23155-0104-10 ",.02)
 ;;23155-0104-10
 ;;9002226.02101,"1198,23155-0115-01 ",.01)
 ;;23155-0115-01
 ;;9002226.02101,"1198,23155-0115-01 ",.02)
 ;;23155-0115-01
 ;;9002226.02101,"1198,23155-0116-01 ",.01)
 ;;23155-0116-01
 ;;9002226.02101,"1198,23155-0116-01 ",.02)
 ;;23155-0116-01
 ;;9002226.02101,"1198,23155-0117-01 ",.01)
 ;;23155-0117-01
 ;;9002226.02101,"1198,23155-0117-01 ",.02)
 ;;23155-0117-01
 ;;9002226.02101,"1198,23490-6838-01 ",.01)
 ;;23490-6838-01
 ;;9002226.02101,"1198,23490-6838-01 ",.02)
 ;;23490-6838-01
 ;;9002226.02101,"1198,23490-6838-02 ",.01)
 ;;23490-6838-02
 ;;9002226.02101,"1198,23490-6838-02 ",.02)
 ;;23490-6838-02
 ;;9002226.02101,"1198,23490-6838-03 ",.01)
 ;;23490-6838-03
 ;;9002226.02101,"1198,23490-6838-03 ",.02)
 ;;23490-6838-03
 ;;9002226.02101,"1198,23490-6838-04 ",.01)
 ;;23490-6838-04
 ;;9002226.02101,"1198,23490-6838-04 ",.02)
 ;;23490-6838-04
 ;;9002226.02101,"1198,23490-6839-01 ",.01)
 ;;23490-6839-01
 ;;9002226.02101,"1198,23490-6839-01 ",.02)
 ;;23490-6839-01
 ;;9002226.02101,"1198,23490-6839-02 ",.01)
 ;;23490-6839-02
 ;;9002226.02101,"1198,23490-6839-02 ",.02)
 ;;23490-6839-02
 ;;9002226.02101,"1198,23490-7260-01 ",.01)
 ;;23490-7260-01
 ;;9002226.02101,"1198,23490-7260-01 ",.02)
 ;;23490-7260-01
 ;;9002226.02101,"1198,23490-7260-02 ",.01)
 ;;23490-7260-02
 ;;9002226.02101,"1198,23490-7260-02 ",.02)
 ;;23490-7260-02
 ;;9002226.02101,"1198,23490-7260-03 ",.01)
 ;;23490-7260-03
 ;;9002226.02101,"1198,23490-7260-03 ",.02)
 ;;23490-7260-03
 ;;9002226.02101,"1198,23490-7260-04 ",.01)
 ;;23490-7260-04
 ;;9002226.02101,"1198,23490-7260-04 ",.02)
 ;;23490-7260-04
 ;;9002226.02101,"1198,23490-7448-03 ",.01)
 ;;23490-7448-03
 ;;9002226.02101,"1198,23490-7448-03 ",.02)
 ;;23490-7448-03
 ;;9002226.02101,"1198,23490-7448-06 ",.01)
 ;;23490-7448-06
 ;;9002226.02101,"1198,23490-7448-06 ",.02)
 ;;23490-7448-06
 ;;9002226.02101,"1198,23490-7449-01 ",.01)
 ;;23490-7449-01
 ;;9002226.02101,"1198,23490-7449-01 ",.02)
 ;;23490-7449-01
 ;;9002226.02101,"1198,23490-7449-06 ",.01)
 ;;23490-7449-06
 ;;9002226.02101,"1198,23490-7449-06 ",.02)
 ;;23490-7449-06
 ;;9002226.02101,"1198,23490-7449-09 ",.01)
 ;;23490-7449-09
 ;;9002226.02101,"1198,23490-7449-09 ",.02)
 ;;23490-7449-09
 ;;9002226.02101,"1198,23490-7458-03 ",.01)
 ;;23490-7458-03
 ;;9002226.02101,"1198,23490-7458-03 ",.02)
 ;;23490-7458-03
 ;;9002226.02101,"1198,23490-7458-06 ",.01)
 ;;23490-7458-06
 ;;9002226.02101,"1198,23490-7458-06 ",.02)
 ;;23490-7458-06
 ;;9002226.02101,"1198,33261-0145-02 ",.01)
 ;;33261-0145-02
 ;;9002226.02101,"1198,33261-0145-02 ",.02)
 ;;33261-0145-02
 ;;9002226.02101,"1198,33261-0145-30 ",.01)
 ;;33261-0145-30
 ;;9002226.02101,"1198,33261-0145-30 ",.02)
 ;;33261-0145-30
 ;;9002226.02101,"1198,33261-0145-60 ",.01)
 ;;33261-0145-60
 ;;9002226.02101,"1198,33261-0145-60 ",.02)
 ;;33261-0145-60
 ;;9002226.02101,"1198,33261-0145-90 ",.01)
 ;;33261-0145-90
 ;;9002226.02101,"1198,33261-0145-90 ",.02)
 ;;33261-0145-90
 ;;9002226.02101,"1198,33261-0157-02 ",.01)
 ;;33261-0157-02
 ;;9002226.02101,"1198,33261-0157-02 ",.02)
 ;;33261-0157-02
 ;;9002226.02101,"1198,33261-0157-30 ",.01)
 ;;33261-0157-30
 ;;9002226.02101,"1198,33261-0157-30 ",.02)
 ;;33261-0157-30
 ;;9002226.02101,"1198,33261-0157-60 ",.01)
 ;;33261-0157-60
 ;;9002226.02101,"1198,33261-0157-60 ",.02)
 ;;33261-0157-60
 ;;9002226.02101,"1198,33261-0157-90 ",.01)
 ;;33261-0157-90
 ;;9002226.02101,"1198,33261-0157-90 ",.02)
 ;;33261-0157-90
 ;;9002226.02101,"1198,33261-0372-30 ",.01)
 ;;33261-0372-30
 ;;9002226.02101,"1198,33261-0372-30 ",.02)
 ;;33261-0372-30
 ;;9002226.02101,"1198,33261-0372-60 ",.01)
 ;;33261-0372-60
 ;;9002226.02101,"1198,33261-0372-60 ",.02)
 ;;33261-0372-60
 ;;9002226.02101,"1198,33261-0372-90 ",.01)
 ;;33261-0372-90
 ;;9002226.02101,"1198,33261-0372-90 ",.02)
 ;;33261-0372-90
 ;;9002226.02101,"1198,33358-0234-00 ",.01)
 ;;33358-0234-00
 ;;9002226.02101,"1198,33358-0234-00 ",.02)
 ;;33358-0234-00
 ;;9002226.02101,"1198,33358-0234-30 ",.01)
 ;;33358-0234-30
 ;;9002226.02101,"1198,33358-0234-30 ",.02)
 ;;33358-0234-30
 ;;9002226.02101,"1198,33358-0234-60 ",.01)
 ;;33358-0234-60
 ;;9002226.02101,"1198,33358-0234-60 ",.02)
 ;;33358-0234-60
 ;;9002226.02101,"1198,33358-0235-60 ",.01)
 ;;33358-0235-60
 ;;9002226.02101,"1198,33358-0235-60 ",.02)
 ;;33358-0235-60
 ;;9002226.02101,"1198,33358-0236-30 ",.01)
 ;;33358-0236-30
 ;;9002226.02101,"1198,33358-0236-30 ",.02)
 ;;33358-0236-30
 ;;9002226.02101,"1198,33358-0236-60 ",.01)
 ;;33358-0236-60
 ;;9002226.02101,"1198,33358-0236-60 ",.02)
 ;;33358-0236-60
 ;;9002226.02101,"1198,33358-0237-30 ",.01)
 ;;33358-0237-30
 ;;9002226.02101,"1198,33358-0237-30 ",.02)
 ;;33358-0237-30
 ;;9002226.02101,"1198,33358-0237-60 ",.01)
 ;;33358-0237-60
 ;;9002226.02101,"1198,33358-0237-60 ",.02)
 ;;33358-0237-60
 ;;9002226.02101,"1198,35356-0130-60 ",.01)
 ;;35356-0130-60
 ;;9002226.02101,"1198,35356-0130-60 ",.02)
 ;;35356-0130-60
 ;;9002226.02101,"1198,35356-0136-60 ",.01)
 ;;35356-0136-60
 ;;9002226.02101,"1198,35356-0136-60 ",.02)
 ;;35356-0136-60
 ;;9002226.02101,"1198,35356-0269-28 ",.01)
 ;;35356-0269-28
 ;;9002226.02101,"1198,35356-0269-28 ",.02)
 ;;35356-0269-28
 ;;9002226.02101,"1198,42291-0610-18 ",.01)
 ;;42291-0610-18
 ;;9002226.02101,"1198,42291-0610-18 ",.02)
 ;;42291-0610-18
 ;;9002226.02101,"1198,42291-0610-36 ",.01)
 ;;42291-0610-36
 ;;9002226.02101,"1198,42291-0610-36 ",.02)
 ;;42291-0610-36
 ;;9002226.02101,"1198,42291-0610-90 ",.01)
 ;;42291-0610-90
 ;;9002226.02101,"1198,42291-0610-90 ",.02)
 ;;42291-0610-90
 ;;9002226.02101,"1198,42291-0611-18 ",.01)
 ;;42291-0611-18
 ;;9002226.02101,"1198,42291-0611-18 ",.02)
 ;;42291-0611-18
 ;;9002226.02101,"1198,43063-0012-01 ",.01)
 ;;43063-0012-01
 ;;9002226.02101,"1198,43063-0012-01 ",.02)
 ;;43063-0012-01
 ;;9002226.02101,"1198,43353-0340-30 ",.01)
 ;;43353-0340-30
 ;;9002226.02101,"1198,43353-0340-30 ",.02)
 ;;43353-0340-30
 ;;9002226.02101,"1198,43353-0340-53 ",.01)
 ;;43353-0340-53
 ;;9002226.02101,"1198,43353-0340-53 ",.02)
 ;;43353-0340-53
 ;;9002226.02101,"1198,43353-0340-60 ",.01)
 ;;43353-0340-60
 ;;9002226.02101,"1198,43353-0340-60 ",.02)
 ;;43353-0340-60
 ;;9002226.02101,"1198,43353-0340-70 ",.01)
 ;;43353-0340-70
 ;;9002226.02101,"1198,43353-0340-70 ",.02)
 ;;43353-0340-70
 ;;9002226.02101,"1198,43353-0340-75 ",.01)
 ;;43353-0340-75
 ;;9002226.02101,"1198,43353-0340-75 ",.02)
 ;;43353-0340-75
 ;;9002226.02101,"1198,43353-0340-80 ",.01)
 ;;43353-0340-80
 ;;9002226.02101,"1198,43353-0340-80 ",.02)
 ;;43353-0340-80
 ;;9002226.02101,"1198,43353-0340-92 ",.01)
 ;;43353-0340-92
 ;;9002226.02101,"1198,43353-0340-92 ",.02)
 ;;43353-0340-92
 ;;9002226.02101,"1198,43353-0340-94 ",.01)
 ;;43353-0340-94
 ;;9002226.02101,"1198,43353-0340-94 ",.02)
 ;;43353-0340-94
 ;;9002226.02101,"1198,43353-0340-96 ",.01)
 ;;43353-0340-96
 ;;9002226.02101,"1198,43353-0340-96 ",.02)
 ;;43353-0340-96
 ;;9002226.02101,"1198,43353-0344-53 ",.01)
 ;;43353-0344-53
 ;;9002226.02101,"1198,43353-0344-53 ",.02)
 ;;43353-0344-53
 ;;9002226.02101,"1198,43353-0344-60 ",.01)
 ;;43353-0344-60
 ;;9002226.02101,"1198,43353-0344-60 ",.02)
 ;;43353-0344-60
 ;;9002226.02101,"1198,43353-0344-80 ",.01)
 ;;43353-0344-80
 ;;9002226.02101,"1198,43353-0344-80 ",.02)
 ;;43353-0344-80
 ;;9002226.02101,"1198,43353-0344-92 ",.01)
 ;;43353-0344-92
 ;;9002226.02101,"1198,43353-0344-92 ",.02)
 ;;43353-0344-92
 ;;9002226.02101,"1198,43353-0349-30 ",.01)
 ;;43353-0349-30
 ;;9002226.02101,"1198,43353-0349-30 ",.02)
 ;;43353-0349-30
 ;;9002226.02101,"1198,43353-0349-45 ",.01)
 ;;43353-0349-45
 ;;9002226.02101,"1198,43353-0349-45 ",.02)
 ;;43353-0349-45
 ;;9002226.02101,"1198,43353-0349-53 ",.01)
 ;;43353-0349-53
 ;;9002226.02101,"1198,43353-0349-53 ",.02)
 ;;43353-0349-53
 ;;9002226.02101,"1198,43353-0349-60 ",.01)
 ;;43353-0349-60
 ;;9002226.02101,"1198,43353-0349-60 ",.02)
 ;;43353-0349-60
 ;;9002226.02101,"1198,43353-0349-73 ",.01)
 ;;43353-0349-73
 ;;9002226.02101,"1198,43353-0349-73 ",.02)
 ;;43353-0349-73
 ;;9002226.02101,"1198,43353-0349-80 ",.01)
 ;;43353-0349-80
 ;;9002226.02101,"1198,43353-0349-80 ",.02)
 ;;43353-0349-80
 ;;9002226.02101,"1198,43353-0349-86 ",.01)
 ;;43353-0349-86
 ;;9002226.02101,"1198,43353-0349-86 ",.02)
 ;;43353-0349-86
 ;;9002226.02101,"1198,43353-0477-30 ",.01)
 ;;43353-0477-30
 ;;9002226.02101,"1198,43353-0477-30 ",.02)
 ;;43353-0477-30
 ;;9002226.02101,"1198,43353-0477-53 ",.01)
 ;;43353-0477-53
 ;;9002226.02101,"1198,43353-0477-53 ",.02)
 ;;43353-0477-53
 ;;9002226.02101,"1198,43353-0477-60 ",.01)
 ;;43353-0477-60
 ;;9002226.02101,"1198,43353-0477-60 ",.02)
 ;;43353-0477-60
 ;;9002226.02101,"1198,43353-0477-70 ",.01)
 ;;43353-0477-70
 ;;9002226.02101,"1198,43353-0477-70 ",.02)
 ;;43353-0477-70
 ;;9002226.02101,"1198,43353-0477-80 ",.01)
 ;;43353-0477-80
 ;;9002226.02101,"1198,43353-0477-80 ",.02)
 ;;43353-0477-80
 ;;9002226.02101,"1198,43353-0477-92 ",.01)
 ;;43353-0477-92
 ;;9002226.02101,"1198,43353-0477-92 ",.02)
 ;;43353-0477-92
 ;;9002226.02101,"1198,43353-0477-94 ",.01)
 ;;43353-0477-94
 ;;9002226.02101,"1198,43353-0477-94 ",.02)
 ;;43353-0477-94
 ;;9002226.02101,"1198,43353-0477-96 ",.01)
 ;;43353-0477-96
 ;;9002226.02101,"1198,43353-0477-96 ",.02)
 ;;43353-0477-96
 ;;9002226.02101,"1198,43353-0514-30 ",.01)
 ;;43353-0514-30
 ;;9002226.02101,"1198,43353-0514-30 ",.02)
 ;;43353-0514-30
 ;;9002226.02101,"1198,43353-0514-45 ",.01)
 ;;43353-0514-45
 ;;9002226.02101,"1198,43353-0514-45 ",.02)
 ;;43353-0514-45
 ;;9002226.02101,"1198,43353-0514-53 ",.01)
 ;;43353-0514-53
 ;;9002226.02101,"1198,43353-0514-53 ",.02)
 ;;43353-0514-53
 ;;9002226.02101,"1198,43353-0514-60 ",.01)
 ;;43353-0514-60
 ;;9002226.02101,"1198,43353-0514-60 ",.02)
 ;;43353-0514-60
 ;;9002226.02101,"1198,43353-0514-73 ",.01)
 ;;43353-0514-73
 ;;9002226.02101,"1198,43353-0514-73 ",.02)
 ;;43353-0514-73
 ;;9002226.02101,"1198,43353-0514-80 ",.01)
 ;;43353-0514-80
 ;;9002226.02101,"1198,43353-0514-80 ",.02)
 ;;43353-0514-80
 ;;9002226.02101,"1198,43353-0514-86 ",.01)
 ;;43353-0514-86
 ;;9002226.02101,"1198,43353-0514-86 ",.02)
 ;;43353-0514-86
 ;;9002226.02101,"1198,43353-0520-60 ",.01)
 ;;43353-0520-60
 ;;9002226.02101,"1198,43353-0520-60 ",.02)
 ;;43353-0520-60
 ;;9002226.02101,"1198,43353-0520-80 ",.01)
 ;;43353-0520-80
 ;;9002226.02101,"1198,43353-0520-80 ",.02)
 ;;43353-0520-80
 ;;9002226.02101,"1198,43353-0530-60 ",.01)
 ;;43353-0530-60
 ;;9002226.02101,"1198,43353-0530-60 ",.02)
 ;;43353-0530-60
 ;;9002226.02101,"1198,43353-0530-80 ",.01)
 ;;43353-0530-80
 ;;9002226.02101,"1198,43353-0530-80 ",.02)
 ;;43353-0530-80
 ;;9002226.02101,"1198,43353-0585-94 ",.01)
 ;;43353-0585-94
 ;;9002226.02101,"1198,43353-0585-94 ",.02)
 ;;43353-0585-94
 ;;9002226.02101,"1198,43353-0589-30 ",.01)
 ;;43353-0589-30
 ;;9002226.02101,"1198,43353-0589-30 ",.02)
 ;;43353-0589-30
 ;;9002226.02101,"1198,43353-0589-53 ",.01)
 ;;43353-0589-53
 ;;9002226.02101,"1198,43353-0589-53 ",.02)
 ;;43353-0589-53
 ;;9002226.02101,"1198,43353-0589-60 ",.01)
 ;;43353-0589-60
 ;;9002226.02101,"1198,43353-0589-60 ",.02)
 ;;43353-0589-60
