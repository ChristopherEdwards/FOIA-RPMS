BGP51Z6 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 19, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1204,68258-8961-06 ",.01)
 ;;68258-8961-06
 ;;9002226.02101,"1204,68258-8961-06 ",.02)
 ;;68258-8961-06
 ;;9002226.02101,"1204,68258-8964-08 ",.01)
 ;;68258-8964-08
 ;;9002226.02101,"1204,68258-8964-08 ",.02)
 ;;68258-8964-08
 ;;9002226.02101,"1204,68258-8966-01 ",.01)
 ;;68258-8966-01
 ;;9002226.02101,"1204,68258-8966-01 ",.02)
 ;;68258-8966-01
 ;;9002226.02101,"1204,68462-0356-01 ",.01)
 ;;68462-0356-01
 ;;9002226.02101,"1204,68462-0356-01 ",.02)
 ;;68462-0356-01
 ;;9002226.02101,"1204,68462-0380-01 ",.01)
 ;;68462-0380-01
 ;;9002226.02101,"1204,68462-0380-01 ",.02)
 ;;68462-0380-01
 ;;9002226.02101,"1204,68462-0392-05 ",.01)
 ;;68462-0392-05
 ;;9002226.02101,"1204,68462-0392-05 ",.02)
 ;;68462-0392-05
 ;;9002226.02101,"1204,68462-0392-30 ",.01)
 ;;68462-0392-30
 ;;9002226.02101,"1204,68462-0392-30 ",.02)
 ;;68462-0392-30
 ;;9002226.02101,"1204,68462-0392-90 ",.01)
 ;;68462-0392-90
 ;;9002226.02101,"1204,68462-0392-90 ",.02)
 ;;68462-0392-90
 ;;9002226.02101,"1204,68645-0466-54 ",.01)
 ;;68645-0466-54
 ;;9002226.02101,"1204,68645-0466-54 ",.02)
 ;;68645-0466-54
 ;;9002226.02101,"1204,68645-0484-70 ",.01)
 ;;68645-0484-70
 ;;9002226.02101,"1204,68645-0484-70 ",.02)
 ;;68645-0484-70
 ;;9002226.02101,"1204,75989-0550-12 ",.01)
 ;;75989-0550-12
 ;;9002226.02101,"1204,75989-0550-12 ",.02)
 ;;75989-0550-12