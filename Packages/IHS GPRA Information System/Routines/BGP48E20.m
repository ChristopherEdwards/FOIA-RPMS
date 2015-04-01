BGP48E20 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1774,49884-0740-01 ",.01)
 ;;49884-0740-01
 ;;9002226.02101,"1774,49884-0740-01 ",.02)
 ;;49884-0740-01
 ;;9002226.02101,"1774,49884-0740-05 ",.01)
 ;;49884-0740-05
 ;;9002226.02101,"1774,49884-0740-05 ",.02)
 ;;49884-0740-05
 ;;9002226.02101,"1774,49884-0741-01 ",.01)
 ;;49884-0741-01
 ;;9002226.02101,"1774,49884-0741-01 ",.02)
 ;;49884-0741-01
 ;;9002226.02101,"1774,49884-0741-05 ",.01)
 ;;49884-0741-05
 ;;9002226.02101,"1774,49884-0741-05 ",.02)
 ;;49884-0741-05
 ;;9002226.02101,"1774,49884-0745-01 ",.01)
 ;;49884-0745-01
 ;;9002226.02101,"1774,49884-0745-01 ",.02)
 ;;49884-0745-01
 ;;9002226.02101,"1774,49884-0745-05 ",.01)
 ;;49884-0745-05
 ;;9002226.02101,"1774,49884-0745-05 ",.02)
 ;;49884-0745-05
 ;;9002226.02101,"1774,49884-0746-01 ",.01)
 ;;49884-0746-01
 ;;9002226.02101,"1774,49884-0746-01 ",.02)
 ;;49884-0746-01
 ;;9002226.02101,"1774,49884-0746-05 ",.01)
 ;;49884-0746-05
 ;;9002226.02101,"1774,49884-0746-05 ",.02)
 ;;49884-0746-05
 ;;9002226.02101,"1774,49884-0845-01 ",.01)
 ;;49884-0845-01
 ;;9002226.02101,"1774,49884-0845-01 ",.02)
 ;;49884-0845-01
 ;;9002226.02101,"1774,49884-0846-01 ",.01)
 ;;49884-0846-01
 ;;9002226.02101,"1774,49884-0846-01 ",.02)
 ;;49884-0846-01
 ;;9002226.02101,"1774,49884-0847-01 ",.01)
 ;;49884-0847-01
 ;;9002226.02101,"1774,49884-0847-01 ",.02)
 ;;49884-0847-01
 ;;9002226.02101,"1774,49884-0921-01 ",.01)
 ;;49884-0921-01
 ;;9002226.02101,"1774,49884-0921-01 ",.02)
 ;;49884-0921-01
 ;;9002226.02101,"1774,49884-0921-05 ",.01)
 ;;49884-0921-05
 ;;9002226.02101,"1774,49884-0921-05 ",.02)
 ;;49884-0921-05
 ;;9002226.02101,"1774,49884-0967-01 ",.01)
 ;;49884-0967-01
 ;;9002226.02101,"1774,49884-0967-01 ",.02)
 ;;49884-0967-01
 ;;9002226.02101,"1774,49884-0967-05 ",.01)
 ;;49884-0967-05
 ;;9002226.02101,"1774,49884-0967-05 ",.02)
 ;;49884-0967-05
 ;;9002226.02101,"1774,49884-0968-01 ",.01)
 ;;49884-0968-01
 ;;9002226.02101,"1774,49884-0968-01 ",.02)
 ;;49884-0968-01
 ;;9002226.02101,"1774,49884-0968-05 ",.01)
 ;;49884-0968-05
 ;;9002226.02101,"1774,49884-0968-05 ",.02)
 ;;49884-0968-05
 ;;9002226.02101,"1774,49884-0969-01 ",.01)
 ;;49884-0969-01
 ;;9002226.02101,"1774,49884-0969-01 ",.02)
 ;;49884-0969-01
 ;;9002226.02101,"1774,49884-0969-05 ",.01)
 ;;49884-0969-05
 ;;9002226.02101,"1774,49884-0969-05 ",.02)
 ;;49884-0969-05
 ;;9002226.02101,"1774,49884-0984-01 ",.01)
 ;;49884-0984-01
 ;;9002226.02101,"1774,49884-0984-01 ",.02)
 ;;49884-0984-01
 ;;9002226.02101,"1774,49884-0985-01 ",.01)
 ;;49884-0985-01
 ;;9002226.02101,"1774,49884-0985-01 ",.02)
 ;;49884-0985-01
 ;;9002226.02101,"1774,49999-0106-00 ",.01)
 ;;49999-0106-00
 ;;9002226.02101,"1774,49999-0106-00 ",.02)
 ;;49999-0106-00
 ;;9002226.02101,"1774,49999-0106-01 ",.01)
 ;;49999-0106-01
 ;;9002226.02101,"1774,49999-0106-01 ",.02)
 ;;49999-0106-01
 ;;9002226.02101,"1774,49999-0106-28 ",.01)
 ;;49999-0106-28
 ;;9002226.02101,"1774,49999-0106-28 ",.02)
 ;;49999-0106-28
 ;;9002226.02101,"1774,49999-0106-30 ",.01)
 ;;49999-0106-30
 ;;9002226.02101,"1774,49999-0106-30 ",.02)
 ;;49999-0106-30
 ;;9002226.02101,"1774,49999-0106-60 ",.01)
 ;;49999-0106-60
 ;;9002226.02101,"1774,49999-0106-60 ",.02)
 ;;49999-0106-60
 ;;9002226.02101,"1774,49999-0106-90 ",.01)
 ;;49999-0106-90
 ;;9002226.02101,"1774,49999-0106-90 ",.02)
 ;;49999-0106-90
 ;;9002226.02101,"1774,49999-0107-00 ",.01)
 ;;49999-0107-00
 ;;9002226.02101,"1774,49999-0107-00 ",.02)
 ;;49999-0107-00
 ;;9002226.02101,"1774,49999-0107-20 ",.01)
 ;;49999-0107-20
 ;;9002226.02101,"1774,49999-0107-20 ",.02)
 ;;49999-0107-20
 ;;9002226.02101,"1774,49999-0107-30 ",.01)
 ;;49999-0107-30
 ;;9002226.02101,"1774,49999-0107-30 ",.02)
 ;;49999-0107-30
 ;;9002226.02101,"1774,49999-0107-60 ",.01)
 ;;49999-0107-60
 ;;9002226.02101,"1774,49999-0107-60 ",.02)
 ;;49999-0107-60
 ;;9002226.02101,"1774,49999-0107-90 ",.01)
 ;;49999-0107-90
 ;;9002226.02101,"1774,49999-0107-90 ",.02)
 ;;49999-0107-90
 ;;9002226.02101,"1774,49999-0108-00 ",.01)
 ;;49999-0108-00
 ;;9002226.02101,"1774,49999-0108-00 ",.02)
 ;;49999-0108-00
 ;;9002226.02101,"1774,49999-0108-30 ",.01)
 ;;49999-0108-30
 ;;9002226.02101,"1774,49999-0108-30 ",.02)
 ;;49999-0108-30
 ;;9002226.02101,"1774,49999-0108-60 ",.01)
 ;;49999-0108-60
 ;;9002226.02101,"1774,49999-0108-60 ",.02)
 ;;49999-0108-60
 ;;9002226.02101,"1774,49999-0108-90 ",.01)
 ;;49999-0108-90
 ;;9002226.02101,"1774,49999-0108-90 ",.02)
 ;;49999-0108-90
 ;;9002226.02101,"1774,49999-0113-00 ",.01)
 ;;49999-0113-00
 ;;9002226.02101,"1774,49999-0113-00 ",.02)
 ;;49999-0113-00
 ;;9002226.02101,"1774,49999-0113-01 ",.01)
 ;;49999-0113-01
 ;;9002226.02101,"1774,49999-0113-01 ",.02)
 ;;49999-0113-01
 ;;9002226.02101,"1774,49999-0113-30 ",.01)
 ;;49999-0113-30
 ;;9002226.02101,"1774,49999-0113-30 ",.02)
 ;;49999-0113-30
 ;;9002226.02101,"1774,49999-0113-60 ",.01)
 ;;49999-0113-60
 ;;9002226.02101,"1774,49999-0113-60 ",.02)
 ;;49999-0113-60
 ;;9002226.02101,"1774,49999-0113-90 ",.01)
 ;;49999-0113-90
 ;;9002226.02101,"1774,49999-0113-90 ",.02)
 ;;49999-0113-90
 ;;9002226.02101,"1774,49999-0116-00 ",.01)
 ;;49999-0116-00
 ;;9002226.02101,"1774,49999-0116-00 ",.02)
 ;;49999-0116-00
 ;;9002226.02101,"1774,49999-0116-30 ",.01)
 ;;49999-0116-30
 ;;9002226.02101,"1774,49999-0116-30 ",.02)
 ;;49999-0116-30
 ;;9002226.02101,"1774,49999-0116-60 ",.01)
 ;;49999-0116-60
 ;;9002226.02101,"1774,49999-0116-60 ",.02)
 ;;49999-0116-60
 ;;9002226.02101,"1774,49999-0304-30 ",.01)
 ;;49999-0304-30
 ;;9002226.02101,"1774,49999-0304-30 ",.02)
 ;;49999-0304-30
 ;;9002226.02101,"1774,49999-0401-30 ",.01)
 ;;49999-0401-30
 ;;9002226.02101,"1774,49999-0401-30 ",.02)
 ;;49999-0401-30
 ;;9002226.02101,"1774,49999-0401-60 ",.01)
 ;;49999-0401-60
 ;;9002226.02101,"1774,49999-0401-60 ",.02)
 ;;49999-0401-60
 ;;9002226.02101,"1774,49999-0401-90 ",.01)
 ;;49999-0401-90
 ;;9002226.02101,"1774,49999-0401-90 ",.02)
 ;;49999-0401-90
 ;;9002226.02101,"1774,49999-0449-15 ",.01)
 ;;49999-0449-15
 ;;9002226.02101,"1774,49999-0449-15 ",.02)
 ;;49999-0449-15
 ;;9002226.02101,"1774,49999-0449-30 ",.01)
 ;;49999-0449-30
 ;;9002226.02101,"1774,49999-0449-30 ",.02)
 ;;49999-0449-30
 ;;9002226.02101,"1774,49999-0450-30 ",.01)
 ;;49999-0450-30
 ;;9002226.02101,"1774,49999-0450-30 ",.02)
 ;;49999-0450-30
 ;;9002226.02101,"1774,49999-0451-30 ",.01)
 ;;49999-0451-30
 ;;9002226.02101,"1774,49999-0451-30 ",.02)
 ;;49999-0451-30
 ;;9002226.02101,"1774,49999-0451-90 ",.01)
 ;;49999-0451-90
 ;;9002226.02101,"1774,49999-0451-90 ",.02)
 ;;49999-0451-90
 ;;9002226.02101,"1774,49999-0495-30 ",.01)
 ;;49999-0495-30
 ;;9002226.02101,"1774,49999-0495-30 ",.02)
 ;;49999-0495-30
 ;;9002226.02101,"1774,49999-0495-60 ",.01)
 ;;49999-0495-60
 ;;9002226.02101,"1774,49999-0495-60 ",.02)
 ;;49999-0495-60
 ;;9002226.02101,"1774,49999-0514-30 ",.01)
 ;;49999-0514-30
 ;;9002226.02101,"1774,49999-0514-30 ",.02)
 ;;49999-0514-30
 ;;9002226.02101,"1774,49999-0571-60 ",.01)
 ;;49999-0571-60
 ;;9002226.02101,"1774,49999-0571-60 ",.02)
 ;;49999-0571-60
 ;;9002226.02101,"1774,49999-0660-30 ",.01)
 ;;49999-0660-30
 ;;9002226.02101,"1774,49999-0660-30 ",.02)
 ;;49999-0660-30
 ;;9002226.02101,"1774,49999-0660-60 ",.01)
 ;;49999-0660-60
 ;;9002226.02101,"1774,49999-0660-60 ",.02)
 ;;49999-0660-60
 ;;9002226.02101,"1774,49999-0781-00 ",.01)
 ;;49999-0781-00
 ;;9002226.02101,"1774,49999-0781-00 ",.02)
 ;;49999-0781-00
 ;;9002226.02101,"1774,49999-0781-30 ",.01)
 ;;49999-0781-30
 ;;9002226.02101,"1774,49999-0781-30 ",.02)
 ;;49999-0781-30
 ;;9002226.02101,"1774,49999-0781-60 ",.01)
 ;;49999-0781-60
 ;;9002226.02101,"1774,49999-0781-60 ",.02)
 ;;49999-0781-60
 ;;9002226.02101,"1774,49999-0781-90 ",.01)
 ;;49999-0781-90
 ;;9002226.02101,"1774,49999-0781-90 ",.02)
 ;;49999-0781-90
 ;;9002226.02101,"1774,49999-0807-00 ",.01)
 ;;49999-0807-00
 ;;9002226.02101,"1774,49999-0807-00 ",.02)
 ;;49999-0807-00
 ;;9002226.02101,"1774,49999-0807-30 ",.01)
 ;;49999-0807-30
 ;;9002226.02101,"1774,49999-0807-30 ",.02)
 ;;49999-0807-30
 ;;9002226.02101,"1774,49999-0807-60 ",.01)
 ;;49999-0807-60
 ;;9002226.02101,"1774,49999-0807-60 ",.02)
 ;;49999-0807-60
 ;;9002226.02101,"1774,49999-0807-90 ",.01)
 ;;49999-0807-90
 ;;9002226.02101,"1774,49999-0807-90 ",.02)
 ;;49999-0807-90
 ;;9002226.02101,"1774,49999-0808-00 ",.01)
 ;;49999-0808-00
 ;;9002226.02101,"1774,49999-0808-00 ",.02)
 ;;49999-0808-00
 ;;9002226.02101,"1774,49999-0820-30 ",.01)
 ;;49999-0820-30
 ;;9002226.02101,"1774,49999-0820-30 ",.02)
 ;;49999-0820-30
 ;;9002226.02101,"1774,49999-0820-60 ",.01)
 ;;49999-0820-60
 ;;9002226.02101,"1774,49999-0820-60 ",.02)
 ;;49999-0820-60
 ;;9002226.02101,"1774,49999-0820-90 ",.01)
 ;;49999-0820-90
 ;;9002226.02101,"1774,49999-0820-90 ",.02)
 ;;49999-0820-90
 ;;9002226.02101,"1774,49999-0935-30 ",.01)
 ;;49999-0935-30
 ;;9002226.02101,"1774,49999-0935-30 ",.02)
 ;;49999-0935-30
 ;;9002226.02101,"1774,50111-0372-01 ",.01)
 ;;50111-0372-01
 ;;9002226.02101,"1774,50111-0372-01 ",.02)
 ;;50111-0372-01
 ;;9002226.02101,"1774,50111-0372-03 ",.01)
 ;;50111-0372-03
 ;;9002226.02101,"1774,50111-0372-03 ",.02)
 ;;50111-0372-03
 ;;9002226.02101,"1774,50111-0373-01 ",.01)
 ;;50111-0373-01
 ;;9002226.02101,"1774,50111-0373-01 ",.02)
 ;;50111-0373-01
 ;;9002226.02101,"1774,50111-0373-03 ",.01)
 ;;50111-0373-03
 ;;9002226.02101,"1774,50111-0373-03 ",.02)
 ;;50111-0373-03
 ;;9002226.02101,"1774,50111-0584-01 ",.01)
 ;;50111-0584-01
 ;;9002226.02101,"1774,50111-0584-01 ",.02)
 ;;50111-0584-01
 ;;9002226.02101,"1774,50111-0584-02 ",.01)
 ;;50111-0584-02
 ;;9002226.02101,"1774,50111-0584-02 ",.02)
 ;;50111-0584-02
 ;;9002226.02101,"1774,50111-0585-01 ",.01)
 ;;50111-0585-01
 ;;9002226.02101,"1774,50111-0585-01 ",.02)
 ;;50111-0585-01
 ;;9002226.02101,"1774,50111-0585-02 ",.01)
 ;;50111-0585-02
 ;;9002226.02101,"1774,50111-0585-02 ",.02)
 ;;50111-0585-02
 ;;9002226.02101,"1774,50268-0531-15 ",.01)
 ;;50268-0531-15
 ;;9002226.02101,"1774,50268-0531-15 ",.02)
 ;;50268-0531-15
 ;;9002226.02101,"1774,50458-0140-30 ",.01)
 ;;50458-0140-30
 ;;9002226.02101,"1774,50458-0140-30 ",.02)
 ;;50458-0140-30
 ;;9002226.02101,"1774,50458-0140-90 ",.01)
 ;;50458-0140-90
 ;;9002226.02101,"1774,50458-0140-90 ",.02)
 ;;50458-0140-90
 ;;9002226.02101,"1774,50458-0141-30 ",.01)
 ;;50458-0141-30
 ;;9002226.02101,"1774,50458-0141-30 ",.02)
 ;;50458-0141-30
 ;;9002226.02101,"1774,50458-0141-90 ",.01)
 ;;50458-0141-90
 ;;9002226.02101,"1774,50458-0141-90 ",.02)
 ;;50458-0141-90
 ;;9002226.02101,"1774,51079-0062-01 ",.01)
 ;;51079-0062-01
 ;;9002226.02101,"1774,51079-0062-01 ",.02)
 ;;51079-0062-01
 ;;9002226.02101,"1774,51079-0062-03 ",.01)
 ;;51079-0062-03
 ;;9002226.02101,"1774,51079-0062-03 ",.02)
 ;;51079-0062-03
 ;;9002226.02101,"1774,51079-0172-01 ",.01)
 ;;51079-0172-01
 ;;9002226.02101,"1774,51079-0172-01 ",.02)
 ;;51079-0172-01
 ;;9002226.02101,"1774,51079-0172-20 ",.01)
 ;;51079-0172-20
 ;;9002226.02101,"1774,51079-0172-20 ",.02)
 ;;51079-0172-20
 ;;9002226.02101,"1774,51079-0173-01 ",.01)
 ;;51079-0173-01
 ;;9002226.02101,"1774,51079-0173-01 ",.02)
 ;;51079-0173-01
 ;;9002226.02101,"1774,51079-0173-08 ",.01)
 ;;51079-0173-08
 ;;9002226.02101,"1774,51079-0173-08 ",.02)
 ;;51079-0173-08
 ;;9002226.02101,"1774,51079-0174-01 ",.01)
 ;;51079-0174-01
 ;;9002226.02101,"1774,51079-0174-01 ",.02)
 ;;51079-0174-01
 ;;9002226.02101,"1774,51079-0174-20 ",.01)
 ;;51079-0174-20
 ;;9002226.02101,"1774,51079-0174-20 ",.02)
 ;;51079-0174-20
 ;;9002226.02101,"1774,51079-0202-01 ",.01)
 ;;51079-0202-01
 ;;9002226.02101,"1774,51079-0202-01 ",.02)
 ;;51079-0202-01
 ;;9002226.02101,"1774,51079-0202-20 ",.01)
 ;;51079-0202-20
 ;;9002226.02101,"1774,51079-0202-20 ",.02)
 ;;51079-0202-20
 ;;9002226.02101,"1774,51079-0203-01 ",.01)
 ;;51079-0203-01
 ;;9002226.02101,"1774,51079-0203-01 ",.02)
 ;;51079-0203-01
 ;;9002226.02101,"1774,51079-0203-20 ",.01)
 ;;51079-0203-20
 ;;9002226.02101,"1774,51079-0203-20 ",.02)
 ;;51079-0203-20
 ;;9002226.02101,"1774,51079-0292-20 ",.01)
 ;;51079-0292-20
 ;;9002226.02101,"1774,51079-0292-20 ",.02)
 ;;51079-0292-20
 ;;9002226.02101,"1774,51079-0293-20 ",.01)
 ;;51079-0293-20
 ;;9002226.02101,"1774,51079-0293-20 ",.02)
 ;;51079-0293-20
 ;;9002226.02101,"1774,51079-0425-01 ",.01)
 ;;51079-0425-01
 ;;9002226.02101,"1774,51079-0425-01 ",.02)
 ;;51079-0425-01
 ;;9002226.02101,"1774,51079-0425-20 ",.01)
 ;;51079-0425-20
 ;;9002226.02101,"1774,51079-0425-20 ",.02)
 ;;51079-0425-20
 ;;9002226.02101,"1774,51079-0426-01 ",.01)
 ;;51079-0426-01
 ;;9002226.02101,"1774,51079-0426-01 ",.02)
 ;;51079-0426-01
 ;;9002226.02101,"1774,51079-0426-20 ",.01)
 ;;51079-0426-20
 ;;9002226.02101,"1774,51079-0426-20 ",.02)
 ;;51079-0426-20
 ;;9002226.02101,"1774,51079-0513-01 ",.01)
 ;;51079-0513-01
 ;;9002226.02101,"1774,51079-0513-01 ",.02)
 ;;51079-0513-01
 ;;9002226.02101,"1774,51079-0513-20 ",.01)
 ;;51079-0513-20
 ;;9002226.02101,"1774,51079-0513-20 ",.02)
 ;;51079-0513-20
 ;;9002226.02101,"1774,51079-0514-01 ",.01)
 ;;51079-0514-01
 ;;9002226.02101,"1774,51079-0514-01 ",.02)
 ;;51079-0514-01
 ;;9002226.02101,"1774,51079-0514-20 ",.01)
 ;;51079-0514-20
 ;;9002226.02101,"1774,51079-0514-20 ",.02)
 ;;51079-0514-20
 ;;9002226.02101,"1774,51079-0515-01 ",.01)
 ;;51079-0515-01
 ;;9002226.02101,"1774,51079-0515-01 ",.02)
 ;;51079-0515-01
 ;;9002226.02101,"1774,51079-0515-20 ",.01)
 ;;51079-0515-20
 ;;9002226.02101,"1774,51079-0515-20 ",.02)
 ;;51079-0515-20
 ;;9002226.02101,"1774,51079-0560-01 ",.01)
 ;;51079-0560-01