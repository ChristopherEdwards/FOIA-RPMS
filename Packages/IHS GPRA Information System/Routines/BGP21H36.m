BGP21H36 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,49999-0499-10 ",.02)
 ;;49999-0499-10
 ;;9002226.02101,"1197,49999-0572-10 ",.01)
 ;;49999-0572-10
 ;;9002226.02101,"1197,49999-0572-10 ",.02)
 ;;49999-0572-10
 ;;9002226.02101,"1197,49999-0821-10 ",.01)
 ;;49999-0821-10
 ;;9002226.02101,"1197,49999-0821-10 ",.02)
 ;;49999-0821-10
 ;;9002226.02101,"1197,49999-0946-30 ",.01)
 ;;49999-0946-30
 ;;9002226.02101,"1197,49999-0946-30 ",.02)
 ;;49999-0946-30
 ;;9002226.02101,"1197,49999-0947-30 ",.01)
 ;;49999-0947-30
 ;;9002226.02101,"1197,49999-0947-30 ",.02)
 ;;49999-0947-30
 ;;9002226.02101,"1197,49999-0948-30 ",.01)
 ;;49999-0948-30
 ;;9002226.02101,"1197,49999-0948-30 ",.02)
 ;;49999-0948-30
 ;;9002226.02101,"1197,49999-0989-30 ",.01)
 ;;49999-0989-30
 ;;9002226.02101,"1197,49999-0989-30 ",.02)
 ;;49999-0989-30
 ;;9002226.02101,"1197,50111-0486-01 ",.01)
 ;;50111-0486-01
 ;;9002226.02101,"1197,50111-0486-01 ",.02)
 ;;50111-0486-01
 ;;9002226.02101,"1197,50111-0486-02 ",.01)
 ;;50111-0486-02
 ;;9002226.02101,"1197,50111-0486-02 ",.02)
 ;;50111-0486-02
 ;;9002226.02101,"1197,50111-0486-03 ",.01)
 ;;50111-0486-03
 ;;9002226.02101,"1197,50111-0486-03 ",.02)
 ;;50111-0486-03
 ;;9002226.02101,"1197,50111-0487-01 ",.01)
 ;;50111-0487-01
 ;;9002226.02101,"1197,50111-0487-01 ",.02)
 ;;50111-0487-01
 ;;9002226.02101,"1197,50111-0487-02 ",.01)
 ;;50111-0487-02
 ;;9002226.02101,"1197,50111-0487-02 ",.02)
 ;;50111-0487-02
 ;;9002226.02101,"1197,51079-0400-01 ",.01)
 ;;51079-0400-01
 ;;9002226.02101,"1197,51079-0400-01 ",.02)
 ;;51079-0400-01
 ;;9002226.02101,"1197,51079-0400-20 ",.01)
 ;;51079-0400-20
 ;;9002226.02101,"1197,51079-0400-20 ",.02)
 ;;51079-0400-20
 ;;9002226.02101,"1197,51079-0450-01 ",.01)
 ;;51079-0450-01
 ;;9002226.02101,"1197,51079-0450-01 ",.02)
 ;;51079-0450-01
 ;;9002226.02101,"1197,51079-0450-20 ",.01)
 ;;51079-0450-20
 ;;9002226.02101,"1197,51079-0450-20 ",.02)
 ;;51079-0450-20
 ;;9002226.02101,"1197,51079-0450-63 ",.01)
 ;;51079-0450-63
 ;;9002226.02101,"1197,51079-0450-63 ",.02)
 ;;51079-0450-63
 ;;9002226.02101,"1197,51079-0451-01 ",.01)
 ;;51079-0451-01
 ;;9002226.02101,"1197,51079-0451-01 ",.02)
 ;;51079-0451-01
 ;;9002226.02101,"1197,51079-0451-17 ",.01)
 ;;51079-0451-17
 ;;9002226.02101,"1197,51079-0451-17 ",.02)
 ;;51079-0451-17
 ;;9002226.02101,"1197,51079-0451-19 ",.01)
 ;;51079-0451-19
 ;;9002226.02101,"1197,51079-0451-19 ",.02)
 ;;51079-0451-19
 ;;9002226.02101,"1197,51079-0451-20 ",.01)
 ;;51079-0451-20
 ;;9002226.02101,"1197,51079-0451-20 ",.02)
 ;;51079-0451-20
 ;;9002226.02101,"1197,51079-0451-56 ",.01)
 ;;51079-0451-56
 ;;9002226.02101,"1197,51079-0451-56 ",.02)
 ;;51079-0451-56
 ;;9002226.02101,"1197,51079-0451-69 ",.01)
 ;;51079-0451-69
 ;;9002226.02101,"1197,51079-0451-69 ",.02)
 ;;51079-0451-69
 ;;9002226.02101,"1197,51079-0452-01 ",.01)
 ;;51079-0452-01
 ;;9002226.02101,"1197,51079-0452-01 ",.02)
 ;;51079-0452-01
 ;;9002226.02101,"1197,51079-0452-17 ",.01)
 ;;51079-0452-17
 ;;9002226.02101,"1197,51079-0452-17 ",.02)
 ;;51079-0452-17
 ;;9002226.02101,"1197,51079-0452-19 ",.01)
 ;;51079-0452-19
 ;;9002226.02101,"1197,51079-0452-19 ",.02)
 ;;51079-0452-19
 ;;9002226.02101,"1197,51079-0452-20 ",.01)
 ;;51079-0452-20
 ;;9002226.02101,"1197,51079-0452-20 ",.02)
 ;;51079-0452-20
 ;;9002226.02101,"1197,51079-0452-30 ",.01)
 ;;51079-0452-30
 ;;9002226.02101,"1197,51079-0452-30 ",.02)
 ;;51079-0452-30
 ;;9002226.02101,"1197,51079-0452-56 ",.01)
 ;;51079-0452-56
 ;;9002226.02101,"1197,51079-0452-56 ",.02)
 ;;51079-0452-56
 ;;9002226.02101,"1197,51079-0467-01 ",.01)
 ;;51079-0467-01
 ;;9002226.02101,"1197,51079-0467-01 ",.02)
 ;;51079-0467-01
 ;;9002226.02101,"1197,51079-0467-20 ",.01)
 ;;51079-0467-20
 ;;9002226.02101,"1197,51079-0467-20 ",.02)
 ;;51079-0467-20
 ;;9002226.02101,"1197,51079-0468-01 ",.01)
 ;;51079-0468-01
 ;;9002226.02101,"1197,51079-0468-01 ",.02)
 ;;51079-0468-01
 ;;9002226.02101,"1197,51079-0468-20 ",.01)
 ;;51079-0468-20
 ;;9002226.02101,"1197,51079-0468-20 ",.02)
 ;;51079-0468-20
 ;;9002226.02101,"1197,51079-0682-01 ",.01)
 ;;51079-0682-01
 ;;9002226.02101,"1197,51079-0682-01 ",.02)
 ;;51079-0682-01
 ;;9002226.02101,"1197,51079-0682-17 ",.01)
 ;;51079-0682-17
 ;;9002226.02101,"1197,51079-0682-17 ",.02)
 ;;51079-0682-17
 ;;9002226.02101,"1197,51079-0682-19 ",.01)
 ;;51079-0682-19
 ;;9002226.02101,"1197,51079-0682-19 ",.02)
 ;;51079-0682-19
 ;;9002226.02101,"1197,51079-0682-20 ",.01)
 ;;51079-0682-20
 ;;9002226.02101,"1197,51079-0682-20 ",.02)
 ;;51079-0682-20
 ;;9002226.02101,"1197,51079-0683-01 ",.01)
 ;;51079-0683-01
 ;;9002226.02101,"1197,51079-0683-01 ",.02)
 ;;51079-0683-01
 ;;9002226.02101,"1197,51079-0683-20 ",.01)
 ;;51079-0683-20
 ;;9002226.02101,"1197,51079-0683-20 ",.02)
 ;;51079-0683-20
 ;;9002226.02101,"1197,51079-0745-01 ",.01)
 ;;51079-0745-01
 ;;9002226.02101,"1197,51079-0745-01 ",.02)
 ;;51079-0745-01
 ;;9002226.02101,"1197,51079-0745-17 ",.01)
 ;;51079-0745-17
 ;;9002226.02101,"1197,51079-0745-17 ",.02)
 ;;51079-0745-17
 ;;9002226.02101,"1197,51079-0745-19 ",.01)
 ;;51079-0745-19
 ;;9002226.02101,"1197,51079-0745-19 ",.02)
 ;;51079-0745-19
 ;;9002226.02101,"1197,51079-0745-20 ",.01)
 ;;51079-0745-20
 ;;9002226.02101,"1197,51079-0745-20 ",.02)
 ;;51079-0745-20
