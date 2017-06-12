BGP71P7 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 11, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1801,23155-0235-05 ",.01)
 ;;23155-0235-05
 ;;9002226.02101,"1801,23155-0235-05 ",.02)
 ;;23155-0235-05
 ;;9002226.02101,"1801,24979-0041-13 ",.01)
 ;;24979-0041-13
 ;;9002226.02101,"1801,24979-0041-13 ",.02)
 ;;24979-0041-13
 ;;9002226.02101,"1801,29336-0325-56 ",.01)
 ;;29336-0325-56
 ;;9002226.02101,"1801,29336-0325-56 ",.02)
 ;;29336-0325-56
 ;;9002226.02101,"1801,33261-0209-30 ",.01)
 ;;33261-0209-30
 ;;9002226.02101,"1801,33261-0209-30 ",.02)
 ;;33261-0209-30
 ;;9002226.02101,"1801,33261-0209-60 ",.01)
 ;;33261-0209-60
 ;;9002226.02101,"1801,33261-0209-60 ",.02)
 ;;33261-0209-60
 ;;9002226.02101,"1801,33261-0209-90 ",.01)
 ;;33261-0209-90
 ;;9002226.02101,"1801,33261-0209-90 ",.02)
 ;;33261-0209-90
 ;;9002226.02101,"1801,33261-0411-00 ",.01)
 ;;33261-0411-00
 ;;9002226.02101,"1801,33261-0411-00 ",.02)
 ;;33261-0411-00
 ;;9002226.02101,"1801,33261-0411-30 ",.01)
 ;;33261-0411-30
 ;;9002226.02101,"1801,33261-0411-30 ",.02)
 ;;33261-0411-30
 ;;9002226.02101,"1801,33261-0411-60 ",.01)
 ;;33261-0411-60
 ;;9002226.02101,"1801,33261-0411-60 ",.02)
 ;;33261-0411-60
 ;;9002226.02101,"1801,33261-0411-90 ",.01)
 ;;33261-0411-90
 ;;9002226.02101,"1801,33261-0411-90 ",.02)
 ;;33261-0411-90
 ;;9002226.02101,"1801,33261-0667-30 ",.01)
 ;;33261-0667-30
 ;;9002226.02101,"1801,33261-0667-30 ",.02)
 ;;33261-0667-30
 ;;9002226.02101,"1801,33261-0667-60 ",.01)
 ;;33261-0667-60
 ;;9002226.02101,"1801,33261-0667-60 ",.02)
 ;;33261-0667-60
 ;;9002226.02101,"1801,33261-0667-90 ",.01)
 ;;33261-0667-90
 ;;9002226.02101,"1801,33261-0667-90 ",.02)
 ;;33261-0667-90
 ;;9002226.02101,"1801,33261-0714-15 ",.01)
 ;;33261-0714-15
 ;;9002226.02101,"1801,33261-0714-15 ",.02)
 ;;33261-0714-15
 ;;9002226.02101,"1801,33261-0714-30 ",.01)
 ;;33261-0714-30
 ;;9002226.02101,"1801,33261-0714-30 ",.02)
 ;;33261-0714-30
 ;;9002226.02101,"1801,33261-0714-60 ",.01)
 ;;33261-0714-60
 ;;9002226.02101,"1801,33261-0714-60 ",.02)
 ;;33261-0714-60
 ;;9002226.02101,"1801,33261-0751-30 ",.01)
 ;;33261-0751-30
 ;;9002226.02101,"1801,33261-0751-30 ",.02)
 ;;33261-0751-30
 ;;9002226.02101,"1801,33261-0751-60 ",.01)
 ;;33261-0751-60
 ;;9002226.02101,"1801,33261-0751-60 ",.02)
 ;;33261-0751-60
 ;;9002226.02101,"1801,33261-0751-90 ",.01)
 ;;33261-0751-90
 ;;9002226.02101,"1801,33261-0751-90 ",.02)
 ;;33261-0751-90
 ;;9002226.02101,"1801,33261-0763-01 ",.01)
 ;;33261-0763-01
 ;;9002226.02101,"1801,33261-0763-01 ",.02)
 ;;33261-0763-01
 ;;9002226.02101,"1801,33261-0813-30 ",.01)
 ;;33261-0813-30
 ;;9002226.02101,"1801,33261-0813-30 ",.02)
 ;;33261-0813-30
 ;;9002226.02101,"1801,33261-0813-60 ",.01)
 ;;33261-0813-60
 ;;9002226.02101,"1801,33261-0813-60 ",.02)
 ;;33261-0813-60
 ;;9002226.02101,"1801,33261-0813-90 ",.01)
 ;;33261-0813-90
 ;;9002226.02101,"1801,33261-0813-90 ",.02)
 ;;33261-0813-90
 ;;9002226.02101,"1801,33261-0821-30 ",.01)
 ;;33261-0821-30
 ;;9002226.02101,"1801,33261-0821-30 ",.02)
 ;;33261-0821-30
 ;;9002226.02101,"1801,33261-0821-60 ",.01)
 ;;33261-0821-60
 ;;9002226.02101,"1801,33261-0821-60 ",.02)
 ;;33261-0821-60
 ;;9002226.02101,"1801,33261-0821-90 ",.01)
 ;;33261-0821-90
 ;;9002226.02101,"1801,33261-0821-90 ",.02)
 ;;33261-0821-90
 ;;9002226.02101,"1801,33261-0911-01 ",.01)
 ;;33261-0911-01
 ;;9002226.02101,"1801,33261-0911-01 ",.02)
 ;;33261-0911-01
 ;;9002226.02101,"1801,33358-0160-30 ",.01)
 ;;33358-0160-30
 ;;9002226.02101,"1801,33358-0160-30 ",.02)
 ;;33358-0160-30
 ;;9002226.02101,"1801,33358-0160-60 ",.01)
 ;;33358-0160-60
 ;;9002226.02101,"1801,33358-0160-60 ",.02)
 ;;33358-0160-60
 ;;9002226.02101,"1801,33358-0161-01 ",.01)
 ;;33358-0161-01
 ;;9002226.02101,"1801,33358-0161-01 ",.02)
 ;;33358-0161-01
 ;;9002226.02101,"1801,33358-0161-30 ",.01)
 ;;33358-0161-30
 ;;9002226.02101,"1801,33358-0161-30 ",.02)
 ;;33358-0161-30
 ;;9002226.02101,"1801,33358-0161-60 ",.01)
 ;;33358-0161-60
 ;;9002226.02101,"1801,33358-0161-60 ",.02)
 ;;33358-0161-60
 ;;9002226.02101,"1801,33358-0161-90 ",.01)
 ;;33358-0161-90
 ;;9002226.02101,"1801,33358-0161-90 ",.02)
 ;;33358-0161-90
 ;;9002226.02101,"1801,33358-0295-30 ",.01)
 ;;33358-0295-30
 ;;9002226.02101,"1801,33358-0295-30 ",.02)
 ;;33358-0295-30
 ;;9002226.02101,"1801,33358-0336-30 ",.01)
 ;;33358-0336-30
 ;;9002226.02101,"1801,33358-0336-30 ",.02)
 ;;33358-0336-30
 ;;9002226.02101,"1801,33358-0336-60 ",.01)
 ;;33358-0336-60
 ;;9002226.02101,"1801,33358-0336-60 ",.02)
 ;;33358-0336-60
 ;;9002226.02101,"1801,33358-0337-60 ",.01)
 ;;33358-0337-60
 ;;9002226.02101,"1801,33358-0337-60 ",.02)
 ;;33358-0337-60
 ;;9002226.02101,"1801,35356-0249-00 ",.01)
 ;;35356-0249-00
 ;;9002226.02101,"1801,35356-0249-00 ",.02)
 ;;35356-0249-00
 ;;9002226.02101,"1801,35356-0250-00 ",.01)
 ;;35356-0250-00
 ;;9002226.02101,"1801,35356-0250-00 ",.02)
 ;;35356-0250-00
 ;;9002226.02101,"1801,35356-0251-00 ",.01)
 ;;35356-0251-00
 ;;9002226.02101,"1801,35356-0251-00 ",.02)
 ;;35356-0251-00
 ;;9002226.02101,"1801,35356-0276-28 ",.01)
 ;;35356-0276-28
 ;;9002226.02101,"1801,35356-0276-28 ",.02)
 ;;35356-0276-28
 ;;9002226.02101,"1801,35356-0277-28 ",.01)
 ;;35356-0277-28
 ;;9002226.02101,"1801,35356-0277-28 ",.02)
 ;;35356-0277-28
 ;;9002226.02101,"1801,35356-0278-28 ",.01)
 ;;35356-0278-28
 ;;9002226.02101,"1801,35356-0278-28 ",.02)
 ;;35356-0278-28
 ;;9002226.02101,"1801,35356-0279-28 ",.01)
 ;;35356-0279-28
 ;;9002226.02101,"1801,35356-0279-28 ",.02)
 ;;35356-0279-28
 ;;9002226.02101,"1801,35356-0360-30 ",.01)
 ;;35356-0360-30
 ;;9002226.02101,"1801,35356-0360-30 ",.02)
 ;;35356-0360-30
 ;;9002226.02101,"1801,35356-0360-60 ",.01)
 ;;35356-0360-60
 ;;9002226.02101,"1801,35356-0360-60 ",.02)
 ;;35356-0360-60
 ;;9002226.02101,"1801,35356-0360-90 ",.01)
 ;;35356-0360-90
 ;;9002226.02101,"1801,35356-0360-90 ",.02)
 ;;35356-0360-90
 ;;9002226.02101,"1801,35356-0426-30 ",.01)
 ;;35356-0426-30
 ;;9002226.02101,"1801,35356-0426-30 ",.02)
 ;;35356-0426-30
 ;;9002226.02101,"1801,35356-0897-30 ",.01)
 ;;35356-0897-30
 ;;9002226.02101,"1801,35356-0897-30 ",.02)
 ;;35356-0897-30
 ;;9002226.02101,"1801,35356-0897-60 ",.01)
 ;;35356-0897-60
 ;;9002226.02101,"1801,35356-0897-60 ",.02)
 ;;35356-0897-60
 ;;9002226.02101,"1801,35356-0897-90 ",.01)
 ;;35356-0897-90
 ;;9002226.02101,"1801,35356-0897-90 ",.02)
 ;;35356-0897-90
 ;;9002226.02101,"1801,35356-0932-30 ",.01)
 ;;35356-0932-30
 ;;9002226.02101,"1801,35356-0932-30 ",.02)
 ;;35356-0932-30
 ;;9002226.02101,"1801,35356-0932-60 ",.01)
 ;;35356-0932-60
 ;;9002226.02101,"1801,35356-0932-60 ",.02)
 ;;35356-0932-60
 ;;9002226.02101,"1801,35356-0932-90 ",.01)
 ;;35356-0932-90
 ;;9002226.02101,"1801,35356-0932-90 ",.02)
 ;;35356-0932-90
 ;;9002226.02101,"1801,35356-0995-30 ",.01)
 ;;35356-0995-30
 ;;9002226.02101,"1801,35356-0995-30 ",.02)
 ;;35356-0995-30
 ;;9002226.02101,"1801,35356-0995-60 ",.01)
 ;;35356-0995-60
 ;;9002226.02101,"1801,35356-0995-60 ",.02)
 ;;35356-0995-60
 ;;9002226.02101,"1801,35356-0995-90 ",.01)
 ;;35356-0995-90
 ;;9002226.02101,"1801,35356-0995-90 ",.02)
 ;;35356-0995-90
 ;;9002226.02101,"1801,42192-0329-01 ",.01)
 ;;42192-0329-01
 ;;9002226.02101,"1801,42192-0329-01 ",.02)
 ;;42192-0329-01
 ;;9002226.02101,"1801,42192-0330-01 ",.01)
 ;;42192-0330-01
 ;;9002226.02101,"1801,42192-0330-01 ",.02)
 ;;42192-0330-01
 ;;9002226.02101,"1801,42192-0331-01 ",.01)
 ;;42192-0331-01
 ;;9002226.02101,"1801,42192-0331-01 ",.02)
 ;;42192-0331-01
 ;;9002226.02101,"1801,42254-0071-30 ",.01)
 ;;42254-0071-30
 ;;9002226.02101,"1801,42254-0071-30 ",.02)
 ;;42254-0071-30
 ;;9002226.02101,"1801,42254-0090-60 ",.01)
 ;;42254-0090-60
 ;;9002226.02101,"1801,42254-0090-60 ",.02)
 ;;42254-0090-60
 ;;9002226.02101,"1801,42254-0104-30 ",.01)
 ;;42254-0104-30
 ;;9002226.02101,"1801,42254-0104-30 ",.02)
 ;;42254-0104-30
 ;;9002226.02101,"1801,42254-0105-30 ",.01)
 ;;42254-0105-30
 ;;9002226.02101,"1801,42254-0105-30 ",.02)
 ;;42254-0105-30
 ;;9002226.02101,"1801,42254-0281-30 ",.01)
 ;;42254-0281-30
 ;;9002226.02101,"1801,42254-0281-30 ",.02)
 ;;42254-0281-30
 ;;9002226.02101,"1801,42254-0281-90 ",.01)
 ;;42254-0281-90
 ;;9002226.02101,"1801,42254-0281-90 ",.02)
 ;;42254-0281-90
 ;;9002226.02101,"1801,42291-0316-50 ",.01)
 ;;42291-0316-50
 ;;9002226.02101,"1801,42291-0316-50 ",.02)
 ;;42291-0316-50
 ;;9002226.02101,"1801,42291-0317-10 ",.01)
 ;;42291-0317-10
 ;;9002226.02101,"1801,42291-0317-10 ",.02)
 ;;42291-0317-10
 ;;9002226.02101,"1801,42291-0642-01 ",.01)
 ;;42291-0642-01
 ;;9002226.02101,"1801,42291-0642-01 ",.02)
 ;;42291-0642-01
 ;;9002226.02101,"1801,42291-0643-01 ",.01)
 ;;42291-0643-01
 ;;9002226.02101,"1801,42291-0643-01 ",.02)
 ;;42291-0643-01
 ;;9002226.02101,"1801,42291-0644-01 ",.01)
 ;;42291-0644-01
 ;;9002226.02101,"1801,42291-0644-01 ",.02)
 ;;42291-0644-01
 ;;9002226.02101,"1801,43063-0119-90 ",.01)
 ;;43063-0119-90
 ;;9002226.02101,"1801,43063-0119-90 ",.02)
 ;;43063-0119-90
 ;;9002226.02101,"1801,43063-0120-90 ",.01)
 ;;43063-0120-90
 ;;9002226.02101,"1801,43063-0120-90 ",.02)
 ;;43063-0120-90
 ;;9002226.02101,"1801,43063-0201-01 ",.01)
 ;;43063-0201-01
 ;;9002226.02101,"1801,43063-0201-01 ",.02)
 ;;43063-0201-01
 ;;9002226.02101,"1801,43063-0201-30 ",.01)
 ;;43063-0201-30
 ;;9002226.02101,"1801,43063-0201-30 ",.02)
 ;;43063-0201-30
 ;;9002226.02101,"1801,43063-0201-90 ",.01)
 ;;43063-0201-90
 ;;9002226.02101,"1801,43063-0201-90 ",.02)
 ;;43063-0201-90
 ;;9002226.02101,"1801,43063-0397-86 ",.01)
 ;;43063-0397-86
 ;;9002226.02101,"1801,43063-0397-86 ",.02)
 ;;43063-0397-86
 ;;9002226.02101,"1801,43063-0433-14 ",.01)
 ;;43063-0433-14
 ;;9002226.02101,"1801,43063-0433-14 ",.02)
 ;;43063-0433-14
 ;;9002226.02101,"1801,43063-0433-30 ",.01)
 ;;43063-0433-30
 ;;9002226.02101,"1801,43063-0433-30 ",.02)
 ;;43063-0433-30
 ;;9002226.02101,"1801,43063-0433-86 ",.01)
 ;;43063-0433-86
 ;;9002226.02101,"1801,43063-0433-86 ",.02)
 ;;43063-0433-86
 ;;9002226.02101,"1801,43063-0433-90 ",.01)
 ;;43063-0433-90
 ;;9002226.02101,"1801,43063-0433-90 ",.02)
 ;;43063-0433-90
 ;;9002226.02101,"1801,43063-0433-93 ",.01)
 ;;43063-0433-93
 ;;9002226.02101,"1801,43063-0433-93 ",.02)
 ;;43063-0433-93
 ;;9002226.02101,"1801,43063-0446-01 ",.01)
 ;;43063-0446-01
 ;;9002226.02101,"1801,43063-0446-01 ",.02)
 ;;43063-0446-01
 ;;9002226.02101,"1801,43063-0446-30 ",.01)
 ;;43063-0446-30
 ;;9002226.02101,"1801,43063-0446-30 ",.02)
 ;;43063-0446-30
 ;;9002226.02101,"1801,43063-0446-90 ",.01)
 ;;43063-0446-90
 ;;9002226.02101,"1801,43063-0446-90 ",.02)
 ;;43063-0446-90
 ;;9002226.02101,"1801,43063-0651-30 ",.01)
 ;;43063-0651-30
 ;;9002226.02101,"1801,43063-0651-30 ",.02)
 ;;43063-0651-30
 ;;9002226.02101,"1801,43353-0582-80 ",.01)
 ;;43353-0582-80
 ;;9002226.02101,"1801,43353-0582-80 ",.02)
 ;;43353-0582-80
 ;;9002226.02101,"1801,43353-0656-53 ",.01)
 ;;43353-0656-53
 ;;9002226.02101,"1801,43353-0656-53 ",.02)
 ;;43353-0656-53
 ;;9002226.02101,"1801,43353-0656-60 ",.01)
 ;;43353-0656-60
 ;;9002226.02101,"1801,43353-0656-60 ",.02)
 ;;43353-0656-60
 ;;9002226.02101,"1801,43353-0656-70 ",.01)
 ;;43353-0656-70
 ;;9002226.02101,"1801,43353-0656-70 ",.02)
 ;;43353-0656-70
 ;;9002226.02101,"1801,43353-0656-80 ",.01)
 ;;43353-0656-80
 ;;9002226.02101,"1801,43353-0656-80 ",.02)
 ;;43353-0656-80
 ;;9002226.02101,"1801,43353-0656-90 ",.01)
 ;;43353-0656-90
 ;;9002226.02101,"1801,43353-0656-90 ",.02)
 ;;43353-0656-90
 ;;9002226.02101,"1801,43353-0656-92 ",.01)
 ;;43353-0656-92
 ;;9002226.02101,"1801,43353-0656-92 ",.02)
 ;;43353-0656-92
 ;;9002226.02101,"1801,43353-0656-94 ",.01)
 ;;43353-0656-94
 ;;9002226.02101,"1801,43353-0656-94 ",.02)
 ;;43353-0656-94
 ;;9002226.02101,"1801,43353-0659-60 ",.01)
 ;;43353-0659-60