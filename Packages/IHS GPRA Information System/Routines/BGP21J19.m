BGP21J19 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1199,49884-0968-01 ",.02)
 ;;49884-0968-01
 ;;9002226.02101,"1199,49884-0968-05 ",.01)
 ;;49884-0968-05
 ;;9002226.02101,"1199,49884-0968-05 ",.02)
 ;;49884-0968-05
 ;;9002226.02101,"1199,49884-0969-01 ",.01)
 ;;49884-0969-01
 ;;9002226.02101,"1199,49884-0969-01 ",.02)
 ;;49884-0969-01
 ;;9002226.02101,"1199,49884-0969-05 ",.01)
 ;;49884-0969-05
 ;;9002226.02101,"1199,49884-0969-05 ",.02)
 ;;49884-0969-05
 ;;9002226.02101,"1199,49999-0107-00 ",.01)
 ;;49999-0107-00
 ;;9002226.02101,"1199,49999-0107-00 ",.02)
 ;;49999-0107-00
 ;;9002226.02101,"1199,49999-0107-20 ",.01)
 ;;49999-0107-20
 ;;9002226.02101,"1199,49999-0107-20 ",.02)
 ;;49999-0107-20
 ;;9002226.02101,"1199,49999-0107-30 ",.01)
 ;;49999-0107-30
 ;;9002226.02101,"1199,49999-0107-30 ",.02)
 ;;49999-0107-30
 ;;9002226.02101,"1199,49999-0107-60 ",.01)
 ;;49999-0107-60
 ;;9002226.02101,"1199,49999-0107-60 ",.02)
 ;;49999-0107-60
 ;;9002226.02101,"1199,49999-0107-90 ",.01)
 ;;49999-0107-90
 ;;9002226.02101,"1199,49999-0107-90 ",.02)
 ;;49999-0107-90
 ;;9002226.02101,"1199,49999-0108-00 ",.01)
 ;;49999-0108-00
 ;;9002226.02101,"1199,49999-0108-00 ",.02)
 ;;49999-0108-00
 ;;9002226.02101,"1199,49999-0108-30 ",.01)
 ;;49999-0108-30
 ;;9002226.02101,"1199,49999-0108-30 ",.02)
 ;;49999-0108-30
 ;;9002226.02101,"1199,49999-0108-60 ",.01)
 ;;49999-0108-60
 ;;9002226.02101,"1199,49999-0108-60 ",.02)
 ;;49999-0108-60
 ;;9002226.02101,"1199,49999-0113-00 ",.01)
 ;;49999-0113-00
 ;;9002226.02101,"1199,49999-0113-00 ",.02)
 ;;49999-0113-00
 ;;9002226.02101,"1199,49999-0113-01 ",.01)
 ;;49999-0113-01
 ;;9002226.02101,"1199,49999-0113-01 ",.02)
 ;;49999-0113-01
 ;;9002226.02101,"1199,49999-0113-30 ",.01)
 ;;49999-0113-30
 ;;9002226.02101,"1199,49999-0113-30 ",.02)
 ;;49999-0113-30
 ;;9002226.02101,"1199,49999-0113-60 ",.01)
 ;;49999-0113-60
 ;;9002226.02101,"1199,49999-0113-60 ",.02)
 ;;49999-0113-60
 ;;9002226.02101,"1199,49999-0113-90 ",.01)
 ;;49999-0113-90
 ;;9002226.02101,"1199,49999-0113-90 ",.02)
 ;;49999-0113-90
 ;;9002226.02101,"1199,49999-0401-30 ",.01)
 ;;49999-0401-30
 ;;9002226.02101,"1199,49999-0401-30 ",.02)
 ;;49999-0401-30
 ;;9002226.02101,"1199,49999-0401-60 ",.01)
 ;;49999-0401-60
 ;;9002226.02101,"1199,49999-0401-60 ",.02)
 ;;49999-0401-60
 ;;9002226.02101,"1199,49999-0514-30 ",.01)
 ;;49999-0514-30
 ;;9002226.02101,"1199,49999-0514-30 ",.02)
 ;;49999-0514-30
 ;;9002226.02101,"1199,49999-0571-60 ",.01)
 ;;49999-0571-60
 ;;9002226.02101,"1199,49999-0571-60 ",.02)
 ;;49999-0571-60
 ;;9002226.02101,"1199,49999-0660-30 ",.01)
 ;;49999-0660-30
 ;;9002226.02101,"1199,49999-0660-30 ",.02)
 ;;49999-0660-30
 ;;9002226.02101,"1199,49999-0660-60 ",.01)
 ;;49999-0660-60
 ;;9002226.02101,"1199,49999-0660-60 ",.02)
 ;;49999-0660-60
 ;;9002226.02101,"1199,49999-0781-00 ",.01)
 ;;49999-0781-00
 ;;9002226.02101,"1199,49999-0781-00 ",.02)
 ;;49999-0781-00
 ;;9002226.02101,"1199,49999-0807-00 ",.01)
 ;;49999-0807-00
 ;;9002226.02101,"1199,49999-0807-00 ",.02)
 ;;49999-0807-00
 ;;9002226.02101,"1199,49999-0808-00 ",.01)
 ;;49999-0808-00
 ;;9002226.02101,"1199,49999-0808-00 ",.02)
 ;;49999-0808-00
 ;;9002226.02101,"1199,50111-0372-01 ",.01)
 ;;50111-0372-01
 ;;9002226.02101,"1199,50111-0372-01 ",.02)
 ;;50111-0372-01
 ;;9002226.02101,"1199,50111-0372-03 ",.01)
 ;;50111-0372-03
 ;;9002226.02101,"1199,50111-0372-03 ",.02)
 ;;50111-0372-03
 ;;9002226.02101,"1199,50111-0373-01 ",.01)
 ;;50111-0373-01
 ;;9002226.02101,"1199,50111-0373-01 ",.02)
 ;;50111-0373-01
 ;;9002226.02101,"1199,50111-0373-03 ",.01)
 ;;50111-0373-03
 ;;9002226.02101,"1199,50111-0373-03 ",.02)
 ;;50111-0373-03
 ;;9002226.02101,"1199,50111-0584-01 ",.01)
 ;;50111-0584-01
 ;;9002226.02101,"1199,50111-0584-01 ",.02)
 ;;50111-0584-01
 ;;9002226.02101,"1199,50111-0584-02 ",.01)
 ;;50111-0584-02
 ;;9002226.02101,"1199,50111-0584-02 ",.02)
 ;;50111-0584-02
 ;;9002226.02101,"1199,50111-0585-01 ",.01)
 ;;50111-0585-01
 ;;9002226.02101,"1199,50111-0585-01 ",.02)
 ;;50111-0585-01
 ;;9002226.02101,"1199,50111-0585-02 ",.01)
 ;;50111-0585-02
 ;;9002226.02101,"1199,50111-0585-02 ",.02)
 ;;50111-0585-02
 ;;9002226.02101,"1199,51079-0202-01 ",.01)
 ;;51079-0202-01
 ;;9002226.02101,"1199,51079-0202-01 ",.02)
 ;;51079-0202-01
 ;;9002226.02101,"1199,51079-0202-20 ",.01)
 ;;51079-0202-20
 ;;9002226.02101,"1199,51079-0202-20 ",.02)
 ;;51079-0202-20
 ;;9002226.02101,"1199,51079-0203-01 ",.01)
 ;;51079-0203-01
 ;;9002226.02101,"1199,51079-0203-01 ",.02)
 ;;51079-0203-01
 ;;9002226.02101,"1199,51079-0203-20 ",.01)
 ;;51079-0203-20
 ;;9002226.02101,"1199,51079-0203-20 ",.02)
 ;;51079-0203-20
 ;;9002226.02101,"1199,51079-0292-20 ",.01)
 ;;51079-0292-20
 ;;9002226.02101,"1199,51079-0292-20 ",.02)
 ;;51079-0292-20
 ;;9002226.02101,"1199,51079-0293-20 ",.01)
 ;;51079-0293-20
 ;;9002226.02101,"1199,51079-0293-20 ",.02)
 ;;51079-0293-20
 ;;9002226.02101,"1199,51079-0425-01 ",.01)
 ;;51079-0425-01
 ;;9002226.02101,"1199,51079-0425-01 ",.02)
 ;;51079-0425-01
 ;;9002226.02101,"1199,51079-0425-20 ",.01)
 ;;51079-0425-20
 ;;9002226.02101,"1199,51079-0425-20 ",.02)
 ;;51079-0425-20
 ;;9002226.02101,"1199,51079-0426-01 ",.01)
 ;;51079-0426-01
 ;;9002226.02101,"1199,51079-0426-01 ",.02)
 ;;51079-0426-01
