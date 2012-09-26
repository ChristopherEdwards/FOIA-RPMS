BGP21F60 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,60346-0719-62 ",.01)
 ;;60346-0719-62
 ;;9002226.02101,"1195,60346-0719-62 ",.02)
 ;;60346-0719-62
 ;;9002226.02101,"1195,60346-0719-90 ",.01)
 ;;60346-0719-90
 ;;9002226.02101,"1195,60346-0719-90 ",.02)
 ;;60346-0719-90
 ;;9002226.02101,"1195,60346-0719-94 ",.01)
 ;;60346-0719-94
 ;;9002226.02101,"1195,60346-0719-94 ",.02)
 ;;60346-0719-94
 ;;9002226.02101,"1195,60346-0775-30 ",.01)
 ;;60346-0775-30
 ;;9002226.02101,"1195,60346-0775-30 ",.02)
 ;;60346-0775-30
 ;;9002226.02101,"1195,60346-0806-30 ",.01)
 ;;60346-0806-30
 ;;9002226.02101,"1195,60346-0806-30 ",.02)
 ;;60346-0806-30
 ;;9002226.02101,"1195,60346-0806-60 ",.01)
 ;;60346-0806-60
 ;;9002226.02101,"1195,60346-0806-60 ",.02)
 ;;60346-0806-60
 ;;9002226.02101,"1195,60346-0806-90 ",.01)
 ;;60346-0806-90
 ;;9002226.02101,"1195,60346-0806-90 ",.02)
 ;;60346-0806-90
 ;;9002226.02101,"1195,60346-0836-30 ",.01)
 ;;60346-0836-30
 ;;9002226.02101,"1195,60346-0836-30 ",.02)
 ;;60346-0836-30
 ;;9002226.02101,"1195,60346-0914-30 ",.01)
 ;;60346-0914-30
 ;;9002226.02101,"1195,60346-0914-30 ",.02)
 ;;60346-0914-30
 ;;9002226.02101,"1195,60346-0914-60 ",.01)
 ;;60346-0914-60
 ;;9002226.02101,"1195,60346-0914-60 ",.02)
 ;;60346-0914-60
 ;;9002226.02101,"1195,60346-0914-90 ",.01)
 ;;60346-0914-90
 ;;9002226.02101,"1195,60346-0914-90 ",.02)
 ;;60346-0914-90
 ;;9002226.02101,"1195,60346-0914-94 ",.01)
 ;;60346-0914-94
 ;;9002226.02101,"1195,60346-0914-94 ",.02)
 ;;60346-0914-94
 ;;9002226.02101,"1195,60346-0967-30 ",.01)
 ;;60346-0967-30
 ;;9002226.02101,"1195,60346-0967-30 ",.02)
 ;;60346-0967-30
 ;;9002226.02101,"1195,60346-0967-60 ",.01)
 ;;60346-0967-60
 ;;9002226.02101,"1195,60346-0967-60 ",.02)
 ;;60346-0967-60
 ;;9002226.02101,"1195,60346-0967-90 ",.01)
 ;;60346-0967-90
 ;;9002226.02101,"1195,60346-0967-90 ",.02)
 ;;60346-0967-90
 ;;9002226.02101,"1195,60429-0025-30 ",.01)
 ;;60429-0025-30
 ;;9002226.02101,"1195,60429-0025-30 ",.02)
 ;;60429-0025-30
 ;;9002226.02101,"1195,60429-0025-90 ",.01)
 ;;60429-0025-90
 ;;9002226.02101,"1195,60429-0025-90 ",.02)
 ;;60429-0025-90
 ;;9002226.02101,"1195,60429-0026-30 ",.01)
 ;;60429-0026-30
 ;;9002226.02101,"1195,60429-0026-30 ",.02)
 ;;60429-0026-30
 ;;9002226.02101,"1195,60429-0126-30 ",.01)
 ;;60429-0126-30
 ;;9002226.02101,"1195,60429-0126-30 ",.02)
 ;;60429-0126-30
 ;;9002226.02101,"1195,60429-0126-60 ",.01)
 ;;60429-0126-60
 ;;9002226.02101,"1195,60429-0126-60 ",.02)
 ;;60429-0126-60
 ;;9002226.02101,"1195,60429-0127-30 ",.01)
 ;;60429-0127-30
 ;;9002226.02101,"1195,60429-0127-30 ",.02)
 ;;60429-0127-30
 ;;9002226.02101,"1195,60429-0211-90 ",.01)
 ;;60429-0211-90
 ;;9002226.02101,"1195,60429-0211-90 ",.02)
 ;;60429-0211-90
 ;;9002226.02101,"1195,60429-0753-01 ",.01)
 ;;60429-0753-01
 ;;9002226.02101,"1195,60429-0753-01 ",.02)
 ;;60429-0753-01
 ;;9002226.02101,"1195,60429-0754-01 ",.01)
 ;;60429-0754-01
 ;;9002226.02101,"1195,60429-0754-01 ",.02)
 ;;60429-0754-01
 ;;9002226.02101,"1195,60505-2606-01 ",.01)
 ;;60505-2606-01
 ;;9002226.02101,"1195,60505-2606-01 ",.02)
 ;;60505-2606-01
 ;;9002226.02101,"1195,60505-2606-08 ",.01)
 ;;60505-2606-08
 ;;9002226.02101,"1195,60505-2606-08 ",.02)
 ;;60505-2606-08
 ;;9002226.02101,"1195,60505-2607-01 ",.01)
 ;;60505-2607-01
 ;;9002226.02101,"1195,60505-2607-01 ",.02)
 ;;60505-2607-01
 ;;9002226.02101,"1195,60505-2607-08 ",.01)
 ;;60505-2607-08
 ;;9002226.02101,"1195,60505-2607-08 ",.02)
 ;;60505-2607-08
 ;;9002226.02101,"1195,60505-2608-01 ",.01)
 ;;60505-2608-01
 ;;9002226.02101,"1195,60505-2608-01 ",.02)
 ;;60505-2608-01
 ;;9002226.02101,"1195,60505-2608-08 ",.01)
 ;;60505-2608-08
 ;;9002226.02101,"1195,60505-2608-08 ",.02)
 ;;60505-2608-08
 ;;9002226.02101,"1195,60505-2609-01 ",.01)
 ;;60505-2609-01
 ;;9002226.02101,"1195,60505-2609-01 ",.02)
 ;;60505-2609-01
 ;;9002226.02101,"1195,60505-2609-08 ",.01)
 ;;60505-2609-08
 ;;9002226.02101,"1195,60505-2609-08 ",.02)
 ;;60505-2609-08
 ;;9002226.02101,"1195,60793-0283-01 ",.01)
 ;;60793-0283-01
 ;;9002226.02101,"1195,60793-0283-01 ",.02)
 ;;60793-0283-01
 ;;9002226.02101,"1195,60793-0284-01 ",.01)
 ;;60793-0284-01
 ;;9002226.02101,"1195,60793-0284-01 ",.02)
 ;;60793-0284-01
 ;;9002226.02101,"1195,60793-0800-01 ",.01)
 ;;60793-0800-01
 ;;9002226.02101,"1195,60793-0800-01 ",.02)
 ;;60793-0800-01
 ;;9002226.02101,"1195,60793-0801-01 ",.01)
 ;;60793-0801-01
 ;;9002226.02101,"1195,60793-0801-01 ",.02)
 ;;60793-0801-01
 ;;9002226.02101,"1195,60793-0802-01 ",.01)
 ;;60793-0802-01
 ;;9002226.02101,"1195,60793-0802-01 ",.02)
 ;;60793-0802-01
 ;;9002226.02101,"1195,60951-0782-70 ",.01)
 ;;60951-0782-70
 ;;9002226.02101,"1195,60951-0782-70 ",.02)
 ;;60951-0782-70
 ;;9002226.02101,"1195,60976-0346-43 ",.01)
 ;;60976-0346-43
 ;;9002226.02101,"1195,60976-0346-43 ",.02)
 ;;60976-0346-43
 ;;9002226.02101,"1195,60976-0346-44 ",.01)
 ;;60976-0346-44
 ;;9002226.02101,"1195,60976-0346-44 ",.02)
 ;;60976-0346-44
 ;;9002226.02101,"1195,60976-0346-47 ",.01)
 ;;60976-0346-47
 ;;9002226.02101,"1195,60976-0346-47 ",.02)
 ;;60976-0346-47
 ;;9002226.02101,"1195,61570-0175-01 ",.01)
 ;;61570-0175-01
 ;;9002226.02101,"1195,61570-0175-01 ",.02)
 ;;61570-0175-01
 ;;9002226.02101,"1195,61570-0176-01 ",.01)
 ;;61570-0176-01
