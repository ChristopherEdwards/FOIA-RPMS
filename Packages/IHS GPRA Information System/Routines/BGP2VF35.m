BGP2VF35 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"798,52959-0717-30 ",.01)
 ;;52959-0717-30
 ;;9002226.02101,"798,52959-0717-30 ",.02)
 ;;52959-0717-30
 ;;9002226.02101,"798,52959-0732-00 ",.01)
 ;;52959-0732-00
 ;;9002226.02101,"798,52959-0732-00 ",.02)
 ;;52959-0732-00
 ;;9002226.02101,"798,52959-0732-10 ",.01)
 ;;52959-0732-10
 ;;9002226.02101,"798,52959-0732-10 ",.02)
 ;;52959-0732-10
 ;;9002226.02101,"798,52959-0732-14 ",.01)
 ;;52959-0732-14
 ;;9002226.02101,"798,52959-0732-14 ",.02)
 ;;52959-0732-14
 ;;9002226.02101,"798,52959-0732-15 ",.01)
 ;;52959-0732-15
 ;;9002226.02101,"798,52959-0732-15 ",.02)
 ;;52959-0732-15
 ;;9002226.02101,"798,52959-0732-20 ",.01)
 ;;52959-0732-20
 ;;9002226.02101,"798,52959-0732-20 ",.02)
 ;;52959-0732-20
 ;;9002226.02101,"798,52959-0732-30 ",.01)
 ;;52959-0732-30
 ;;9002226.02101,"798,52959-0732-30 ",.02)
 ;;52959-0732-30
 ;;9002226.02101,"798,52959-0732-40 ",.01)
 ;;52959-0732-40
 ;;9002226.02101,"798,52959-0732-40 ",.02)
 ;;52959-0732-40
 ;;9002226.02101,"798,52959-0732-50 ",.01)
 ;;52959-0732-50
 ;;9002226.02101,"798,52959-0732-50 ",.02)
 ;;52959-0732-50
 ;;9002226.02101,"798,52959-0732-60 ",.01)
 ;;52959-0732-60
 ;;9002226.02101,"798,52959-0732-60 ",.02)
 ;;52959-0732-60
 ;;9002226.02101,"798,52959-0732-90 ",.01)
 ;;52959-0732-90
 ;;9002226.02101,"798,52959-0732-90 ",.02)
 ;;52959-0732-90
 ;;9002226.02101,"798,52959-0771-60 ",.01)
 ;;52959-0771-60
 ;;9002226.02101,"798,52959-0771-60 ",.02)
 ;;52959-0771-60
 ;;9002226.02101,"798,52959-0773-30 ",.01)
 ;;52959-0773-30
 ;;9002226.02101,"798,52959-0773-30 ",.02)
 ;;52959-0773-30
 ;;9002226.02101,"798,52959-0773-52 ",.01)
 ;;52959-0773-52
 ;;9002226.02101,"798,52959-0773-52 ",.02)
 ;;52959-0773-52
 ;;9002226.02101,"798,52959-0773-60 ",.01)
 ;;52959-0773-60
 ;;9002226.02101,"798,52959-0773-60 ",.02)
 ;;52959-0773-60
 ;;9002226.02101,"798,52959-0774-30 ",.01)
 ;;52959-0774-30
 ;;9002226.02101,"798,52959-0774-30 ",.02)
 ;;52959-0774-30
 ;;9002226.02101,"798,52959-0774-60 ",.01)
 ;;52959-0774-60
 ;;9002226.02101,"798,52959-0774-60 ",.02)
 ;;52959-0774-60
 ;;9002226.02101,"798,52959-0775-30 ",.01)
 ;;52959-0775-30
 ;;9002226.02101,"798,52959-0775-30 ",.02)
 ;;52959-0775-30
 ;;9002226.02101,"798,52959-0775-50 ",.01)
 ;;52959-0775-50
 ;;9002226.02101,"798,52959-0775-50 ",.02)
 ;;52959-0775-50
 ;;9002226.02101,"798,52959-0775-60 ",.01)
 ;;52959-0775-60
 ;;9002226.02101,"798,52959-0775-60 ",.02)
 ;;52959-0775-60
 ;;9002226.02101,"798,52959-0776-30 ",.01)
 ;;52959-0776-30
 ;;9002226.02101,"798,52959-0776-30 ",.02)
 ;;52959-0776-30
 ;;9002226.02101,"798,52959-0776-60 ",.01)
 ;;52959-0776-60
 ;;9002226.02101,"798,52959-0776-60 ",.02)
 ;;52959-0776-60
 ;;9002226.02101,"798,52959-0781-30 ",.01)
 ;;52959-0781-30
 ;;9002226.02101,"798,52959-0781-30 ",.02)
 ;;52959-0781-30
 ;;9002226.02101,"798,52959-0781-60 ",.01)
 ;;52959-0781-60
 ;;9002226.02101,"798,52959-0781-60 ",.02)
 ;;52959-0781-60
 ;;9002226.02101,"798,52959-0787-30 ",.01)
 ;;52959-0787-30
 ;;9002226.02101,"798,52959-0787-30 ",.02)
 ;;52959-0787-30
 ;;9002226.02101,"798,52959-0791-30 ",.01)
 ;;52959-0791-30
 ;;9002226.02101,"798,52959-0791-30 ",.02)
 ;;52959-0791-30
 ;;9002226.02101,"798,52959-0792-30 ",.01)
 ;;52959-0792-30
 ;;9002226.02101,"798,52959-0792-30 ",.02)
 ;;52959-0792-30
 ;;9002226.02101,"798,52959-0805-60 ",.01)
 ;;52959-0805-60
 ;;9002226.02101,"798,52959-0805-60 ",.02)
 ;;52959-0805-60
 ;;9002226.02101,"798,52959-0806-30 ",.01)
 ;;52959-0806-30
 ;;9002226.02101,"798,52959-0806-30 ",.02)
 ;;52959-0806-30
 ;;9002226.02101,"798,52959-0806-60 ",.01)
 ;;52959-0806-60
 ;;9002226.02101,"798,52959-0806-60 ",.02)
 ;;52959-0806-60
 ;;9002226.02101,"798,52959-0818-30 ",.01)
 ;;52959-0818-30
 ;;9002226.02101,"798,52959-0818-30 ",.02)
 ;;52959-0818-30
 ;;9002226.02101,"798,52959-0818-60 ",.01)
 ;;52959-0818-60
 ;;9002226.02101,"798,52959-0818-60 ",.02)
 ;;52959-0818-60
 ;;9002226.02101,"798,52959-0820-60 ",.01)
 ;;52959-0820-60
 ;;9002226.02101,"798,52959-0820-60 ",.02)
 ;;52959-0820-60
 ;;9002226.02101,"798,52959-0840-60 ",.01)
 ;;52959-0840-60
 ;;9002226.02101,"798,52959-0840-60 ",.02)
 ;;52959-0840-60
 ;;9002226.02101,"798,52959-0869-30 ",.01)
 ;;52959-0869-30
 ;;9002226.02101,"798,52959-0869-30 ",.02)
 ;;52959-0869-30
 ;;9002226.02101,"798,52959-0872-30 ",.01)
 ;;52959-0872-30
 ;;9002226.02101,"798,52959-0872-30 ",.02)
 ;;52959-0872-30
 ;;9002226.02101,"798,52959-0872-60 ",.01)
 ;;52959-0872-60
 ;;9002226.02101,"798,52959-0872-60 ",.02)
 ;;52959-0872-60
 ;;9002226.02101,"798,52959-0875-30 ",.01)
 ;;52959-0875-30
 ;;9002226.02101,"798,52959-0875-30 ",.02)
 ;;52959-0875-30
 ;;9002226.02101,"798,52959-0875-60 ",.01)
 ;;52959-0875-60
 ;;9002226.02101,"798,52959-0875-60 ",.02)
 ;;52959-0875-60
 ;;9002226.02101,"798,52959-0875-90 ",.01)
 ;;52959-0875-90
 ;;9002226.02101,"798,52959-0875-90 ",.02)
 ;;52959-0875-90
 ;;9002226.02101,"798,52959-0876-30 ",.01)
 ;;52959-0876-30
 ;;9002226.02101,"798,52959-0876-30 ",.02)
 ;;52959-0876-30
 ;;9002226.02101,"798,52959-0876-60 ",.01)
 ;;52959-0876-60
 ;;9002226.02101,"798,52959-0876-60 ",.02)
 ;;52959-0876-60
 ;;9002226.02101,"798,52959-0890-30 ",.01)
 ;;52959-0890-30
 ;;9002226.02101,"798,52959-0890-30 ",.02)
 ;;52959-0890-30
 ;;9002226.02101,"798,52959-0890-60 ",.01)
 ;;52959-0890-60
 ;;9002226.02101,"798,52959-0890-60 ",.02)
 ;;52959-0890-60
 ;;9002226.02101,"798,52959-0890-90 ",.01)
 ;;52959-0890-90
 ;;9002226.02101,"798,52959-0890-90 ",.02)
 ;;52959-0890-90
 ;;9002226.02101,"798,52959-0892-30 ",.01)
 ;;52959-0892-30
 ;;9002226.02101,"798,52959-0892-30 ",.02)
 ;;52959-0892-30
 ;;9002226.02101,"798,52959-0892-60 ",.01)
 ;;52959-0892-60
 ;;9002226.02101,"798,52959-0892-60 ",.02)
 ;;52959-0892-60
 ;;9002226.02101,"798,52959-0894-30 ",.01)
 ;;52959-0894-30
 ;;9002226.02101,"798,52959-0894-30 ",.02)
 ;;52959-0894-30
 ;;9002226.02101,"798,52959-0894-60 ",.01)
 ;;52959-0894-60
 ;;9002226.02101,"798,52959-0894-60 ",.02)
 ;;52959-0894-60
 ;;9002226.02101,"798,52959-0898-60 ",.01)
 ;;52959-0898-60
 ;;9002226.02101,"798,52959-0898-60 ",.02)
 ;;52959-0898-60
 ;;9002226.02101,"798,52959-0900-30 ",.01)
 ;;52959-0900-30
 ;;9002226.02101,"798,52959-0900-30 ",.02)
 ;;52959-0900-30
 ;;9002226.02101,"798,52959-0901-30 ",.01)
 ;;52959-0901-30
 ;;9002226.02101,"798,52959-0901-30 ",.02)
 ;;52959-0901-30
 ;;9002226.02101,"798,52959-0986-30 ",.01)
 ;;52959-0986-30
 ;;9002226.02101,"798,52959-0986-30 ",.02)
 ;;52959-0986-30
 ;;9002226.02101,"798,52959-0991-30 ",.01)
 ;;52959-0991-30
 ;;9002226.02101,"798,52959-0991-30 ",.02)
 ;;52959-0991-30
 ;;9002226.02101,"798,53489-0104-01 ",.01)
 ;;53489-0104-01
 ;;9002226.02101,"798,53489-0104-01 ",.02)
 ;;53489-0104-01
 ;;9002226.02101,"798,53489-0105-01 ",.01)
 ;;53489-0105-01
 ;;9002226.02101,"798,53489-0105-01 ",.02)
 ;;53489-0105-01
 ;;9002226.02101,"798,53489-0106-01 ",.01)
 ;;53489-0106-01
 ;;9002226.02101,"798,53489-0106-01 ",.02)
 ;;53489-0106-01
 ;;9002226.02101,"798,53489-0107-01 ",.01)
 ;;53489-0107-01
 ;;9002226.02101,"798,53489-0107-01 ",.02)
 ;;53489-0107-01
 ;;9002226.02101,"798,53489-0108-01 ",.01)
 ;;53489-0108-01
 ;;9002226.02101,"798,53489-0108-01 ",.02)
 ;;53489-0108-01
 ;;9002226.02101,"798,53489-0109-01 ",.01)
 ;;53489-0109-01
 ;;9002226.02101,"798,53489-0109-01 ",.02)
 ;;53489-0109-01
 ;;9002226.02101,"798,53489-0330-01 ",.01)
 ;;53489-0330-01
 ;;9002226.02101,"798,53489-0330-01 ",.02)
 ;;53489-0330-01
 ;;9002226.02101,"798,53489-0331-01 ",.01)
 ;;53489-0331-01
 ;;9002226.02101,"798,53489-0331-01 ",.02)
 ;;53489-0331-01
 ;;9002226.02101,"798,53489-0332-01 ",.01)
 ;;53489-0332-01
 ;;9002226.02101,"798,53489-0332-01 ",.02)
 ;;53489-0332-01
 ;;9002226.02101,"798,53489-0373-06 ",.01)
 ;;53489-0373-06
 ;;9002226.02101,"798,53489-0373-06 ",.02)
 ;;53489-0373-06
 ;;9002226.02101,"798,53489-0373-07 ",.01)
 ;;53489-0373-07
 ;;9002226.02101,"798,53489-0373-07 ",.02)
 ;;53489-0373-07
 ;;9002226.02101,"798,53489-0374-06 ",.01)
 ;;53489-0374-06
 ;;9002226.02101,"798,53489-0374-06 ",.02)
 ;;53489-0374-06
 ;;9002226.02101,"798,53489-0374-07 ",.01)
 ;;53489-0374-07
 ;;9002226.02101,"798,53489-0374-07 ",.02)
 ;;53489-0374-07
 ;;9002226.02101,"798,53489-0510-01 ",.01)
 ;;53489-0510-01
 ;;9002226.02101,"798,53489-0510-01 ",.02)
 ;;53489-0510-01
 ;;9002226.02101,"798,53489-0511-01 ",.01)
 ;;53489-0511-01
 ;;9002226.02101,"798,53489-0511-01 ",.02)
 ;;53489-0511-01
 ;;9002226.02101,"798,53489-0517-01 ",.01)
 ;;53489-0517-01
 ;;9002226.02101,"798,53489-0517-01 ",.02)
 ;;53489-0517-01
 ;;9002226.02101,"798,54348-0511-30 ",.01)
 ;;54348-0511-30
 ;;9002226.02101,"798,54348-0511-30 ",.02)
 ;;54348-0511-30
 ;;9002226.02101,"798,54458-0944-10 ",.01)
 ;;54458-0944-10
 ;;9002226.02101,"798,54458-0944-10 ",.02)
 ;;54458-0944-10
 ;;9002226.02101,"798,54458-0945-10 ",.01)
 ;;54458-0945-10
 ;;9002226.02101,"798,54458-0945-10 ",.02)
 ;;54458-0945-10
 ;;9002226.02101,"798,54458-0947-10 ",.01)
 ;;54458-0947-10
 ;;9002226.02101,"798,54458-0947-10 ",.02)
 ;;54458-0947-10
 ;;9002226.02101,"798,54458-0960-10 ",.01)
 ;;54458-0960-10
 ;;9002226.02101,"798,54458-0960-10 ",.02)
 ;;54458-0960-10
 ;;9002226.02101,"798,54458-0961-10 ",.01)
 ;;54458-0961-10
 ;;9002226.02101,"798,54458-0961-10 ",.02)
 ;;54458-0961-10
 ;;9002226.02101,"798,54458-0980-10 ",.01)
 ;;54458-0980-10
 ;;9002226.02101,"798,54458-0980-10 ",.02)
 ;;54458-0980-10
 ;;9002226.02101,"798,54458-0981-10 ",.01)
 ;;54458-0981-10
 ;;9002226.02101,"798,54458-0981-10 ",.02)
 ;;54458-0981-10
 ;;9002226.02101,"798,54458-0988-10 ",.01)
 ;;54458-0988-10
 ;;9002226.02101,"798,54458-0988-10 ",.02)
 ;;54458-0988-10
 ;;9002226.02101,"798,54458-0989-10 ",.01)
 ;;54458-0989-10
 ;;9002226.02101,"798,54458-0989-10 ",.02)
 ;;54458-0989-10
 ;;9002226.02101,"798,54458-0990-10 ",.01)
 ;;54458-0990-10
 ;;9002226.02101,"798,54458-0990-10 ",.02)
 ;;54458-0990-10
 ;;9002226.02101,"798,54569-0172-00 ",.01)
 ;;54569-0172-00
 ;;9002226.02101,"798,54569-0172-00 ",.02)
 ;;54569-0172-00
 ;;9002226.02101,"798,54569-0172-01 ",.01)
 ;;54569-0172-01
 ;;9002226.02101,"798,54569-0172-01 ",.02)
 ;;54569-0172-01
 ;;9002226.02101,"798,54569-0172-02 ",.01)
 ;;54569-0172-02
 ;;9002226.02101,"798,54569-0172-02 ",.02)
 ;;54569-0172-02
 ;;9002226.02101,"798,54569-0172-04 ",.01)
 ;;54569-0172-04
 ;;9002226.02101,"798,54569-0172-04 ",.02)
 ;;54569-0172-04
 ;;9002226.02101,"798,54569-0173-00 ",.01)
 ;;54569-0173-00
 ;;9002226.02101,"798,54569-0173-00 ",.02)
 ;;54569-0173-00
 ;;9002226.02101,"798,54569-0175-00 ",.01)
 ;;54569-0175-00
 ;;9002226.02101,"798,54569-0175-00 ",.02)
 ;;54569-0175-00
 ;;9002226.02101,"798,54569-0175-01 ",.01)
 ;;54569-0175-01
 ;;9002226.02101,"798,54569-0175-01 ",.02)
 ;;54569-0175-01
 ;;9002226.02101,"798,54569-0175-02 ",.01)
 ;;54569-0175-02
 ;;9002226.02101,"798,54569-0175-02 ",.02)
 ;;54569-0175-02
 ;;9002226.02101,"798,54569-0175-03 ",.01)
 ;;54569-0175-03
 ;;9002226.02101,"798,54569-0175-03 ",.02)
 ;;54569-0175-03
 ;;9002226.02101,"798,54569-0175-04 ",.01)
 ;;54569-0175-04
 ;;9002226.02101,"798,54569-0175-04 ",.02)
 ;;54569-0175-04
 ;;9002226.02101,"798,54569-0175-05 ",.01)
 ;;54569-0175-05
 ;;9002226.02101,"798,54569-0175-05 ",.02)
 ;;54569-0175-05
 ;;9002226.02101,"798,54569-0175-06 ",.01)
 ;;54569-0175-06
 ;;9002226.02101,"798,54569-0175-06 ",.02)
 ;;54569-0175-06
 ;;9002226.02101,"798,54569-0175-08 ",.01)
 ;;54569-0175-08
 ;;9002226.02101,"798,54569-0175-08 ",.02)
 ;;54569-0175-08
 ;;9002226.02101,"798,54569-0194-00 ",.01)
 ;;54569-0194-00
 ;;9002226.02101,"798,54569-0194-00 ",.02)
 ;;54569-0194-00
 ;;9002226.02101,"798,54569-0194-02 ",.01)
 ;;54569-0194-02
 ;;9002226.02101,"798,54569-0194-02 ",.02)
 ;;54569-0194-02
 ;;9002226.02101,"798,54569-0196-03 ",.01)
 ;;54569-0196-03
 ;;9002226.02101,"798,54569-0196-03 ",.02)
 ;;54569-0196-03
 ;;9002226.02101,"798,54569-0196-04 ",.01)
 ;;54569-0196-04
 ;;9002226.02101,"798,54569-0196-04 ",.02)
 ;;54569-0196-04
 ;;9002226.02101,"798,54569-0225-00 ",.01)
 ;;54569-0225-00
 ;;9002226.02101,"798,54569-0225-00 ",.02)
 ;;54569-0225-00
 ;;9002226.02101,"798,54569-0404-00 ",.01)
 ;;54569-0404-00
 ;;9002226.02101,"798,54569-0404-00 ",.02)
 ;;54569-0404-00
 ;;9002226.02101,"798,54569-0404-01 ",.01)
 ;;54569-0404-01
 ;;9002226.02101,"798,54569-0404-01 ",.02)
 ;;54569-0404-01
 ;;9002226.02101,"798,54569-1470-00 ",.01)
 ;;54569-1470-00
 ;;9002226.02101,"798,54569-1470-00 ",.02)
 ;;54569-1470-00
 ;;9002226.02101,"798,54569-1470-01 ",.01)
 ;;54569-1470-01
 ;;9002226.02101,"798,54569-1470-01 ",.02)
 ;;54569-1470-01
 ;;9002226.02101,"798,54569-1470-06 ",.01)
 ;;54569-1470-06
 ;;9002226.02101,"798,54569-1470-06 ",.02)
 ;;54569-1470-06
 ;;9002226.02101,"798,54569-1470-08 ",.01)
 ;;54569-1470-08
 ;;9002226.02101,"798,54569-1470-08 ",.02)
 ;;54569-1470-08
 ;;9002226.02101,"798,54569-1470-09 ",.01)
 ;;54569-1470-09
 ;;9002226.02101,"798,54569-1470-09 ",.02)
 ;;54569-1470-09
 ;;9002226.02101,"798,54569-1519-00 ",.01)
 ;;54569-1519-00
 ;;9002226.02101,"798,54569-1519-00 ",.02)
 ;;54569-1519-00
 ;;9002226.02101,"798,54569-1519-01 ",.01)
 ;;54569-1519-01
 ;;9002226.02101,"798,54569-1519-01 ",.02)
 ;;54569-1519-01
 ;;9002226.02101,"798,54569-1519-02 ",.01)
 ;;54569-1519-02
 ;;9002226.02101,"798,54569-1519-02 ",.02)
 ;;54569-1519-02
 ;;9002226.02101,"798,54569-1519-03 ",.01)
 ;;54569-1519-03
 ;;9002226.02101,"798,54569-1519-03 ",.02)
 ;;54569-1519-03
 ;;9002226.02101,"798,54569-1696-00 ",.01)
 ;;54569-1696-00
 ;;9002226.02101,"798,54569-1696-00 ",.02)
 ;;54569-1696-00
