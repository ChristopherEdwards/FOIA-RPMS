BGP21O8 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1204,00904-1612-80 ",.01)
 ;;00904-1612-80
 ;;9002226.02101,"1204,00904-1612-80 ",.02)
 ;;00904-1612-80
 ;;9002226.02101,"1204,00904-5887-61 ",.01)
 ;;00904-5887-61
 ;;9002226.02101,"1204,00904-5887-61 ",.02)
 ;;00904-5887-61
 ;;9002226.02101,"1204,00904-5888-61 ",.01)
 ;;00904-5888-61
 ;;9002226.02101,"1204,00904-5888-61 ",.02)
 ;;00904-5888-61
 ;;9002226.02101,"1204,00904-5889-61 ",.01)
 ;;00904-5889-61
 ;;9002226.02101,"1204,00904-5889-61 ",.02)
 ;;00904-5889-61
 ;;9002226.02101,"1204,00904-7849-60 ",.01)
 ;;00904-7849-60
 ;;9002226.02101,"1204,00904-7849-60 ",.02)
 ;;00904-7849-60
 ;;9002226.02101,"1204,10122-0901-12 ",.01)
 ;;10122-0901-12
 ;;9002226.02101,"1204,10122-0901-12 ",.02)
 ;;10122-0901-12
 ;;9002226.02101,"1204,10122-0902-12 ",.01)
 ;;10122-0902-12
 ;;9002226.02101,"1204,10122-0902-12 ",.02)
 ;;10122-0902-12
 ;;9002226.02101,"1204,12280-0042-90 ",.01)
 ;;12280-0042-90
 ;;9002226.02101,"1204,12280-0042-90 ",.02)
 ;;12280-0042-90
 ;;9002226.02101,"1204,12280-0173-60 ",.01)
 ;;12280-0173-60
 ;;9002226.02101,"1204,12280-0173-60 ",.02)
 ;;12280-0173-60
 ;;9002226.02101,"1204,13411-0151-01 ",.01)
 ;;13411-0151-01
 ;;9002226.02101,"1204,13411-0151-01 ",.02)
 ;;13411-0151-01
 ;;9002226.02101,"1204,13411-0151-03 ",.01)
 ;;13411-0151-03
 ;;9002226.02101,"1204,13411-0151-03 ",.02)
 ;;13411-0151-03
 ;;9002226.02101,"1204,13411-0151-06 ",.01)
 ;;13411-0151-06
 ;;9002226.02101,"1204,13411-0151-06 ",.02)
 ;;13411-0151-06
 ;;9002226.02101,"1204,13411-0151-09 ",.01)
 ;;13411-0151-09
 ;;9002226.02101,"1204,13411-0151-09 ",.02)
 ;;13411-0151-09
 ;;9002226.02101,"1204,13411-0151-15 ",.01)
 ;;13411-0151-15
 ;;9002226.02101,"1204,13411-0151-15 ",.02)
 ;;13411-0151-15
 ;;9002226.02101,"1204,13411-0160-01 ",.01)
 ;;13411-0160-01
 ;;9002226.02101,"1204,13411-0160-01 ",.02)
 ;;13411-0160-01
 ;;9002226.02101,"1204,13411-0160-03 ",.01)
 ;;13411-0160-03
 ;;9002226.02101,"1204,13411-0160-03 ",.02)
 ;;13411-0160-03
 ;;9002226.02101,"1204,13411-0160-06 ",.01)
 ;;13411-0160-06
 ;;9002226.02101,"1204,13411-0160-06 ",.02)
 ;;13411-0160-06
 ;;9002226.02101,"1204,13411-0160-09 ",.01)
 ;;13411-0160-09
 ;;9002226.02101,"1204,13411-0160-09 ",.02)
 ;;13411-0160-09
 ;;9002226.02101,"1204,13411-0160-15 ",.01)
 ;;13411-0160-15
 ;;9002226.02101,"1204,13411-0160-15 ",.02)
 ;;13411-0160-15
 ;;9002226.02101,"1204,16571-0011-10 ",.01)
 ;;16571-0011-10
 ;;9002226.02101,"1204,16571-0011-10 ",.02)
 ;;16571-0011-10
 ;;9002226.02101,"1204,16590-0025-20 ",.01)
 ;;16590-0025-20
 ;;9002226.02101,"1204,16590-0025-20 ",.02)
 ;;16590-0025-20
 ;;9002226.02101,"1204,16590-0860-71 ",.01)
 ;;16590-0860-71
 ;;9002226.02101,"1204,16590-0860-71 ",.02)
 ;;16590-0860-71
 ;;9002226.02101,"1204,16590-0860-73 ",.01)
 ;;16590-0860-73
 ;;9002226.02101,"1204,16590-0860-73 ",.02)
 ;;16590-0860-73
 ;;9002226.02101,"1204,17236-0324-01 ",.01)
 ;;17236-0324-01
 ;;9002226.02101,"1204,17236-0324-01 ",.02)
 ;;17236-0324-01
 ;;9002226.02101,"1204,17236-0324-10 ",.01)
 ;;17236-0324-10
 ;;9002226.02101,"1204,17236-0324-10 ",.02)
 ;;17236-0324-10
 ;;9002226.02101,"1204,17236-0325-01 ",.01)
 ;;17236-0325-01
 ;;9002226.02101,"1204,17236-0325-01 ",.02)
 ;;17236-0325-01
 ;;9002226.02101,"1204,17236-0325-10 ",.01)
 ;;17236-0325-10
 ;;9002226.02101,"1204,17236-0325-10 ",.02)
 ;;17236-0325-10
 ;;9002226.02101,"1204,17236-0335-01 ",.01)
 ;;17236-0335-01
 ;;9002226.02101,"1204,17236-0335-01 ",.02)
 ;;17236-0335-01
 ;;9002226.02101,"1204,17236-0335-05 ",.01)
 ;;17236-0335-05
 ;;9002226.02101,"1204,17236-0335-05 ",.02)
 ;;17236-0335-05
 ;;9002226.02101,"1204,21695-0196-01 ",.01)
 ;;21695-0196-01
 ;;9002226.02101,"1204,21695-0196-01 ",.02)
 ;;21695-0196-01
 ;;9002226.02101,"1204,21695-0197-01 ",.01)
 ;;21695-0197-01
 ;;9002226.02101,"1204,21695-0197-01 ",.02)
 ;;21695-0197-01
 ;;9002226.02101,"1204,21695-0221-30 ",.01)
 ;;21695-0221-30
 ;;9002226.02101,"1204,21695-0221-30 ",.02)
 ;;21695-0221-30
 ;;9002226.02101,"1204,21695-0565-30 ",.01)
 ;;21695-0565-30
 ;;9002226.02101,"1204,21695-0565-30 ",.02)
 ;;21695-0565-30
 ;;9002226.02101,"1204,23490-0144-03 ",.01)
 ;;23490-0144-03
 ;;9002226.02101,"1204,23490-0144-03 ",.02)
 ;;23490-0144-03
 ;;9002226.02101,"1204,23490-0145-03 ",.01)
 ;;23490-0145-03
 ;;9002226.02101,"1204,23490-0145-03 ",.02)
 ;;23490-0145-03
 ;;9002226.02101,"1204,23490-7355-01 ",.01)
 ;;23490-7355-01
 ;;9002226.02101,"1204,23490-7355-01 ",.02)
 ;;23490-7355-01
 ;;9002226.02101,"1204,23490-7541-01 ",.01)
 ;;23490-7541-01
 ;;9002226.02101,"1204,23490-7541-01 ",.02)
 ;;23490-7541-01
 ;;9002226.02101,"1204,23490-7542-01 ",.01)
 ;;23490-7542-01
 ;;9002226.02101,"1204,23490-7542-01 ",.02)
 ;;23490-7542-01
 ;;9002226.02101,"1204,23490-8018-03 ",.01)
 ;;23490-8018-03
 ;;9002226.02101,"1204,23490-8018-03 ",.02)
 ;;23490-8018-03
 ;;9002226.02101,"1204,23490-9405-00 ",.01)
 ;;23490-9405-00
 ;;9002226.02101,"1204,23490-9405-00 ",.02)
 ;;23490-9405-00
 ;;9002226.02101,"1204,29033-0001-01 ",.01)
 ;;29033-0001-01
 ;;9002226.02101,"1204,29033-0001-01 ",.02)
 ;;29033-0001-01
 ;;9002226.02101,"1204,29033-0002-01 ",.01)
 ;;29033-0002-01
 ;;9002226.02101,"1204,29033-0002-01 ",.02)
 ;;29033-0002-01
 ;;9002226.02101,"1204,35356-0099-14 ",.01)
 ;;35356-0099-14
