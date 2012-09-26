BGP21F58 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1195,58016-0771-30 ",.01)
 ;;58016-0771-30
 ;;9002226.02101,"1195,58016-0771-30 ",.02)
 ;;58016-0771-30
 ;;9002226.02101,"1195,58016-0771-60 ",.01)
 ;;58016-0771-60
 ;;9002226.02101,"1195,58016-0771-60 ",.02)
 ;;58016-0771-60
 ;;9002226.02101,"1195,58016-0859-00 ",.01)
 ;;58016-0859-00
 ;;9002226.02101,"1195,58016-0859-00 ",.02)
 ;;58016-0859-00
 ;;9002226.02101,"1195,58016-0859-30 ",.01)
 ;;58016-0859-30
 ;;9002226.02101,"1195,58016-0859-30 ",.02)
 ;;58016-0859-30
 ;;9002226.02101,"1195,58016-0859-60 ",.01)
 ;;58016-0859-60
 ;;9002226.02101,"1195,58016-0859-60 ",.02)
 ;;58016-0859-60
 ;;9002226.02101,"1195,58016-0859-90 ",.01)
 ;;58016-0859-90
 ;;9002226.02101,"1195,58016-0859-90 ",.02)
 ;;58016-0859-90
 ;;9002226.02101,"1195,58016-0974-00 ",.01)
 ;;58016-0974-00
 ;;9002226.02101,"1195,58016-0974-00 ",.02)
 ;;58016-0974-00
 ;;9002226.02101,"1195,58016-0974-30 ",.01)
 ;;58016-0974-30
 ;;9002226.02101,"1195,58016-0974-30 ",.02)
 ;;58016-0974-30
 ;;9002226.02101,"1195,58016-0974-60 ",.01)
 ;;58016-0974-60
 ;;9002226.02101,"1195,58016-0974-60 ",.02)
 ;;58016-0974-60
 ;;9002226.02101,"1195,58016-0974-90 ",.01)
 ;;58016-0974-90
 ;;9002226.02101,"1195,58016-0974-90 ",.02)
 ;;58016-0974-90
 ;;9002226.02101,"1195,58177-0293-04 ",.01)
 ;;58177-0293-04
 ;;9002226.02101,"1195,58177-0293-04 ",.02)
 ;;58177-0293-04
 ;;9002226.02101,"1195,58177-0293-09 ",.01)
 ;;58177-0293-09
 ;;9002226.02101,"1195,58177-0293-09 ",.02)
 ;;58177-0293-09
 ;;9002226.02101,"1195,58177-0293-11 ",.01)
 ;;58177-0293-11
 ;;9002226.02101,"1195,58177-0293-11 ",.02)
 ;;58177-0293-11
 ;;9002226.02101,"1195,58177-0358-04 ",.01)
 ;;58177-0358-04
 ;;9002226.02101,"1195,58177-0358-04 ",.02)
 ;;58177-0358-04
 ;;9002226.02101,"1195,58177-0358-09 ",.01)
 ;;58177-0358-09
 ;;9002226.02101,"1195,58177-0358-09 ",.02)
 ;;58177-0358-09
 ;;9002226.02101,"1195,58177-0368-04 ",.01)
 ;;58177-0368-04
 ;;9002226.02101,"1195,58177-0368-04 ",.02)
 ;;58177-0368-04
 ;;9002226.02101,"1195,58177-0368-09 ",.01)
 ;;58177-0368-09
 ;;9002226.02101,"1195,58177-0368-09 ",.02)
 ;;58177-0368-09
 ;;9002226.02101,"1195,58177-0368-11 ",.01)
 ;;58177-0368-11
 ;;9002226.02101,"1195,58177-0368-11 ",.02)
 ;;58177-0368-11
 ;;9002226.02101,"1195,58177-0369-04 ",.01)
 ;;58177-0369-04
 ;;9002226.02101,"1195,58177-0369-04 ",.02)
 ;;58177-0369-04
 ;;9002226.02101,"1195,58177-0369-09 ",.01)
 ;;58177-0369-09
 ;;9002226.02101,"1195,58177-0369-09 ",.02)
 ;;58177-0369-09
 ;;9002226.02101,"1195,58177-0369-11 ",.01)
 ;;58177-0369-11
 ;;9002226.02101,"1195,58177-0369-11 ",.02)
 ;;58177-0369-11
 ;;9002226.02101,"1195,58864-0016-01 ",.01)
 ;;58864-0016-01
 ;;9002226.02101,"1195,58864-0016-01 ",.02)
 ;;58864-0016-01
 ;;9002226.02101,"1195,58864-0016-28 ",.01)
 ;;58864-0016-28
 ;;9002226.02101,"1195,58864-0016-28 ",.02)
 ;;58864-0016-28
 ;;9002226.02101,"1195,58864-0016-30 ",.01)
 ;;58864-0016-30
 ;;9002226.02101,"1195,58864-0016-30 ",.02)
 ;;58864-0016-30
 ;;9002226.02101,"1195,58864-0016-60 ",.01)
 ;;58864-0016-60
 ;;9002226.02101,"1195,58864-0016-60 ",.02)
 ;;58864-0016-60
 ;;9002226.02101,"1195,58864-0065-01 ",.01)
 ;;58864-0065-01
 ;;9002226.02101,"1195,58864-0065-01 ",.02)
 ;;58864-0065-01
 ;;9002226.02101,"1195,58864-0065-30 ",.01)
 ;;58864-0065-30
 ;;9002226.02101,"1195,58864-0065-30 ",.02)
 ;;58864-0065-30
 ;;9002226.02101,"1195,58864-0363-30 ",.01)
 ;;58864-0363-30
 ;;9002226.02101,"1195,58864-0363-30 ",.02)
 ;;58864-0363-30
 ;;9002226.02101,"1195,58864-0367-01 ",.01)
 ;;58864-0367-01
 ;;9002226.02101,"1195,58864-0367-01 ",.02)
 ;;58864-0367-01
 ;;9002226.02101,"1195,58864-0368-01 ",.01)
 ;;58864-0368-01
 ;;9002226.02101,"1195,58864-0368-01 ",.02)
 ;;58864-0368-01
 ;;9002226.02101,"1195,58864-0431-60 ",.01)
 ;;58864-0431-60
 ;;9002226.02101,"1195,58864-0431-60 ",.02)
 ;;58864-0431-60
 ;;9002226.02101,"1195,58864-0645-56 ",.01)
 ;;58864-0645-56
 ;;9002226.02101,"1195,58864-0645-56 ",.02)
 ;;58864-0645-56
 ;;9002226.02101,"1195,58864-0680-30 ",.01)
 ;;58864-0680-30
 ;;9002226.02101,"1195,58864-0680-30 ",.02)
 ;;58864-0680-30
 ;;9002226.02101,"1195,58864-0695-30 ",.01)
 ;;58864-0695-30
 ;;9002226.02101,"1195,58864-0695-30 ",.02)
 ;;58864-0695-30
 ;;9002226.02101,"1195,58864-0717-30 ",.01)
 ;;58864-0717-30
 ;;9002226.02101,"1195,58864-0717-30 ",.02)
 ;;58864-0717-30
 ;;9002226.02101,"1195,58864-0727-30 ",.01)
 ;;58864-0727-30
 ;;9002226.02101,"1195,58864-0727-30 ",.02)
 ;;58864-0727-30
 ;;9002226.02101,"1195,58864-0737-30 ",.01)
 ;;58864-0737-30
 ;;9002226.02101,"1195,58864-0737-30 ",.02)
 ;;58864-0737-30
 ;;9002226.02101,"1195,58864-0749-30 ",.01)
 ;;58864-0749-30
 ;;9002226.02101,"1195,58864-0749-30 ",.02)
 ;;58864-0749-30
 ;;9002226.02101,"1195,58864-0749-90 ",.01)
 ;;58864-0749-90
 ;;9002226.02101,"1195,58864-0749-90 ",.02)
 ;;58864-0749-90
 ;;9002226.02101,"1195,58864-0759-30 ",.01)
 ;;58864-0759-30
 ;;9002226.02101,"1195,58864-0759-30 ",.02)
 ;;58864-0759-30
 ;;9002226.02101,"1195,58864-0765-30 ",.01)
 ;;58864-0765-30
 ;;9002226.02101,"1195,58864-0765-30 ",.02)
 ;;58864-0765-30
 ;;9002226.02101,"1195,58864-0784-30 ",.01)
 ;;58864-0784-30
 ;;9002226.02101,"1195,58864-0784-30 ",.02)
 ;;58864-0784-30
 ;;9002226.02101,"1195,59762-1258-01 ",.01)
 ;;59762-1258-01
