BGP21H22 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,00247-1100-30 ",.02)
 ;;00247-1100-30
 ;;9002226.02101,"1197,00247-1100-60 ",.01)
 ;;00247-1100-60
 ;;9002226.02101,"1197,00247-1100-60 ",.02)
 ;;00247-1100-60
 ;;9002226.02101,"1197,00247-1101-30 ",.01)
 ;;00247-1101-30
 ;;9002226.02101,"1197,00247-1101-30 ",.02)
 ;;00247-1101-30
 ;;9002226.02101,"1197,00247-1101-60 ",.01)
 ;;00247-1101-60
 ;;9002226.02101,"1197,00247-1101-60 ",.02)
 ;;00247-1101-60
 ;;9002226.02101,"1197,00247-1102-30 ",.01)
 ;;00247-1102-30
 ;;9002226.02101,"1197,00247-1102-30 ",.02)
 ;;00247-1102-30
 ;;9002226.02101,"1197,00247-1102-60 ",.01)
 ;;00247-1102-60
 ;;9002226.02101,"1197,00247-1102-60 ",.02)
 ;;00247-1102-60
 ;;9002226.02101,"1197,00247-1114-30 ",.01)
 ;;00247-1114-30
 ;;9002226.02101,"1197,00247-1114-30 ",.02)
 ;;00247-1114-30
 ;;9002226.02101,"1197,00247-1114-60 ",.01)
 ;;00247-1114-60
 ;;9002226.02101,"1197,00247-1114-60 ",.02)
 ;;00247-1114-60
 ;;9002226.02101,"1197,00247-1115-30 ",.01)
 ;;00247-1115-30
 ;;9002226.02101,"1197,00247-1115-30 ",.02)
 ;;00247-1115-30
 ;;9002226.02101,"1197,00247-1115-60 ",.01)
 ;;00247-1115-60
 ;;9002226.02101,"1197,00247-1115-60 ",.02)
 ;;00247-1115-60
 ;;9002226.02101,"1197,00247-1117-03 ",.01)
 ;;00247-1117-03
 ;;9002226.02101,"1197,00247-1117-03 ",.02)
 ;;00247-1117-03
 ;;9002226.02101,"1197,00247-1117-30 ",.01)
 ;;00247-1117-30
 ;;9002226.02101,"1197,00247-1117-30 ",.02)
 ;;00247-1117-30
 ;;9002226.02101,"1197,00247-1117-60 ",.01)
 ;;00247-1117-60
 ;;9002226.02101,"1197,00247-1117-60 ",.02)
 ;;00247-1117-60
 ;;9002226.02101,"1197,00247-1118-03 ",.01)
 ;;00247-1118-03
 ;;9002226.02101,"1197,00247-1118-03 ",.02)
 ;;00247-1118-03
 ;;9002226.02101,"1197,00247-1118-30 ",.01)
 ;;00247-1118-30
 ;;9002226.02101,"1197,00247-1118-30 ",.02)
 ;;00247-1118-30
 ;;9002226.02101,"1197,00247-1135-30 ",.01)
 ;;00247-1135-30
 ;;9002226.02101,"1197,00247-1135-30 ",.02)
 ;;00247-1135-30
 ;;9002226.02101,"1197,00247-1135-60 ",.01)
 ;;00247-1135-60
 ;;9002226.02101,"1197,00247-1135-60 ",.02)
 ;;00247-1135-60
 ;;9002226.02101,"1197,00247-1137-03 ",.01)
 ;;00247-1137-03
 ;;9002226.02101,"1197,00247-1137-03 ",.02)
 ;;00247-1137-03
 ;;9002226.02101,"1197,00247-1221-00 ",.01)
 ;;00247-1221-00
 ;;9002226.02101,"1197,00247-1221-00 ",.02)
 ;;00247-1221-00
 ;;9002226.02101,"1197,00247-1221-50 ",.01)
 ;;00247-1221-50
 ;;9002226.02101,"1197,00247-1221-50 ",.02)
 ;;00247-1221-50
 ;;9002226.02101,"1197,00247-1221-60 ",.01)
 ;;00247-1221-60
 ;;9002226.02101,"1197,00247-1221-60 ",.02)
 ;;00247-1221-60
 ;;9002226.02101,"1197,00258-3687-90 ",.01)
 ;;00258-3687-90
 ;;9002226.02101,"1197,00258-3687-90 ",.02)
 ;;00258-3687-90
 ;;9002226.02101,"1197,00258-3688-90 ",.01)
 ;;00258-3688-90
 ;;9002226.02101,"1197,00258-3688-90 ",.02)
 ;;00258-3688-90
 ;;9002226.02101,"1197,00258-3689-90 ",.01)
 ;;00258-3689-90
 ;;9002226.02101,"1197,00258-3689-90 ",.02)
 ;;00258-3689-90
 ;;9002226.02101,"1197,00258-3690-90 ",.01)
 ;;00258-3690-90
 ;;9002226.02101,"1197,00258-3690-90 ",.02)
 ;;00258-3690-90
 ;;9002226.02101,"1197,00258-3691-90 ",.01)
 ;;00258-3691-90
 ;;9002226.02101,"1197,00258-3691-90 ",.02)
 ;;00258-3691-90
 ;;9002226.02101,"1197,00258-3692-90 ",.01)
 ;;00258-3692-90
 ;;9002226.02101,"1197,00258-3692-90 ",.02)
 ;;00258-3692-90
 ;;9002226.02101,"1197,00310-0891-10 ",.01)
 ;;00310-0891-10
 ;;9002226.02101,"1197,00310-0891-10 ",.02)
 ;;00310-0891-10
 ;;9002226.02101,"1197,00310-0891-39 ",.01)
 ;;00310-0891-39
 ;;9002226.02101,"1197,00310-0891-39 ",.02)
 ;;00310-0891-39
 ;;9002226.02101,"1197,00310-0892-10 ",.01)
 ;;00310-0892-10
 ;;9002226.02101,"1197,00310-0892-10 ",.02)
 ;;00310-0892-10
 ;;9002226.02101,"1197,00310-0892-39 ",.01)
 ;;00310-0892-39
 ;;9002226.02101,"1197,00310-0892-39 ",.02)
 ;;00310-0892-39
 ;;9002226.02101,"1197,00310-0893-10 ",.01)
 ;;00310-0893-10
 ;;9002226.02101,"1197,00310-0893-10 ",.02)
 ;;00310-0893-10
 ;;9002226.02101,"1197,00310-0893-39 ",.01)
 ;;00310-0893-39
 ;;9002226.02101,"1197,00310-0893-39 ",.02)
 ;;00310-0893-39
 ;;9002226.02101,"1197,00310-0894-10 ",.01)
 ;;00310-0894-10
 ;;9002226.02101,"1197,00310-0894-10 ",.02)
 ;;00310-0894-10
 ;;9002226.02101,"1197,00364-2880-01 ",.01)
 ;;00364-2880-01
 ;;9002226.02101,"1197,00364-2880-01 ",.02)
 ;;00364-2880-01
 ;;9002226.02101,"1197,00364-2884-01 ",.01)
 ;;00364-2884-01
 ;;9002226.02101,"1197,00364-2884-01 ",.02)
 ;;00364-2884-01
 ;;9002226.02101,"1197,00364-2886-01 ",.01)
 ;;00364-2886-01
 ;;9002226.02101,"1197,00364-2886-01 ",.02)
 ;;00364-2886-01
 ;;9002226.02101,"1197,00378-0023-01 ",.01)
 ;;00378-0023-01
 ;;9002226.02101,"1197,00378-0023-01 ",.02)
 ;;00378-0023-01
 ;;9002226.02101,"1197,00378-0023-05 ",.01)
 ;;00378-0023-05
 ;;9002226.02101,"1197,00378-0023-05 ",.02)
 ;;00378-0023-05
 ;;9002226.02101,"1197,00378-0045-01 ",.01)
 ;;00378-0045-01
 ;;9002226.02101,"1197,00378-0045-01 ",.02)
 ;;00378-0045-01
 ;;9002226.02101,"1197,00378-0045-05 ",.01)
 ;;00378-0045-05
 ;;9002226.02101,"1197,00378-0045-05 ",.02)
 ;;00378-0045-05
 ;;9002226.02101,"1197,00378-0135-01 ",.01)
 ;;00378-0135-01
 ;;9002226.02101,"1197,00378-0135-01 ",.02)
 ;;00378-0135-01
 ;;9002226.02101,"1197,00378-0135-05 ",.01)
 ;;00378-0135-05
 ;;9002226.02101,"1197,00378-0135-05 ",.02)
 ;;00378-0135-05
