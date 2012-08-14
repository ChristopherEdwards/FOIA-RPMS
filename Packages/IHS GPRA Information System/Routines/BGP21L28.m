BGP21L28 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1201,53489-0608-01 ",.01)
 ;;53489-0608-01
 ;;9002226.02101,"1201,53489-0608-01 ",.02)
 ;;53489-0608-01
 ;;9002226.02101,"1201,53489-0608-06 ",.01)
 ;;53489-0608-06
 ;;9002226.02101,"1201,53489-0608-06 ",.02)
 ;;53489-0608-06
 ;;9002226.02101,"1201,53489-0608-10 ",.01)
 ;;53489-0608-10
 ;;9002226.02101,"1201,53489-0608-10 ",.02)
 ;;53489-0608-10
 ;;9002226.02101,"1201,53489-0609-01 ",.01)
 ;;53489-0609-01
 ;;9002226.02101,"1201,53489-0609-01 ",.02)
 ;;53489-0609-01
 ;;9002226.02101,"1201,53489-0609-06 ",.01)
 ;;53489-0609-06
 ;;9002226.02101,"1201,53489-0609-06 ",.02)
 ;;53489-0609-06
 ;;9002226.02101,"1201,53489-0609-10 ",.01)
 ;;53489-0609-10
 ;;9002226.02101,"1201,53489-0609-10 ",.02)
 ;;53489-0609-10
 ;;9002226.02101,"1201,54458-0925-10 ",.01)
 ;;54458-0925-10
 ;;9002226.02101,"1201,54458-0925-10 ",.02)
 ;;54458-0925-10
 ;;9002226.02101,"1201,54458-0926-10 ",.01)
 ;;54458-0926-10
 ;;9002226.02101,"1201,54458-0926-10 ",.02)
 ;;54458-0926-10
 ;;9002226.02101,"1201,54458-0928-04 ",.01)
 ;;54458-0928-04
 ;;9002226.02101,"1201,54458-0928-04 ",.02)
 ;;54458-0928-04
 ;;9002226.02101,"1201,54458-0932-10 ",.01)
 ;;54458-0932-10
 ;;9002226.02101,"1201,54458-0932-10 ",.02)
 ;;54458-0932-10
 ;;9002226.02101,"1201,54458-0933-10 ",.01)
 ;;54458-0933-10
 ;;9002226.02101,"1201,54458-0933-10 ",.02)
 ;;54458-0933-10
 ;;9002226.02101,"1201,54458-0934-10 ",.01)
 ;;54458-0934-10
 ;;9002226.02101,"1201,54458-0934-10 ",.02)
 ;;54458-0934-10
 ;;9002226.02101,"1201,54458-0936-10 ",.01)
 ;;54458-0936-10
 ;;9002226.02101,"1201,54458-0936-10 ",.02)
 ;;54458-0936-10
 ;;9002226.02101,"1201,54458-0937-10 ",.01)
 ;;54458-0937-10
 ;;9002226.02101,"1201,54458-0937-10 ",.02)
 ;;54458-0937-10
 ;;9002226.02101,"1201,54458-0938-10 ",.01)
 ;;54458-0938-10
 ;;9002226.02101,"1201,54458-0938-10 ",.02)
 ;;54458-0938-10
 ;;9002226.02101,"1201,54458-0982-10 ",.01)
 ;;54458-0982-10
 ;;9002226.02101,"1201,54458-0982-10 ",.02)
 ;;54458-0982-10
 ;;9002226.02101,"1201,54458-0983-10 ",.01)
 ;;54458-0983-10
 ;;9002226.02101,"1201,54458-0983-10 ",.02)
 ;;54458-0983-10
 ;;9002226.02101,"1201,54458-0984-10 ",.01)
 ;;54458-0984-10
 ;;9002226.02101,"1201,54458-0984-10 ",.02)
 ;;54458-0984-10
 ;;9002226.02101,"1201,54458-0985-07 ",.01)
 ;;54458-0985-07
 ;;9002226.02101,"1201,54458-0985-07 ",.02)
 ;;54458-0985-07
 ;;9002226.02101,"1201,54458-0985-10 ",.01)
 ;;54458-0985-10
 ;;9002226.02101,"1201,54458-0985-10 ",.02)
 ;;54458-0985-10
 ;;9002226.02101,"1201,54458-0986-10 ",.01)
 ;;54458-0986-10
 ;;9002226.02101,"1201,54458-0986-10 ",.02)
 ;;54458-0986-10
 ;;9002226.02101,"1201,54458-0987-09 ",.01)
 ;;54458-0987-09
 ;;9002226.02101,"1201,54458-0987-09 ",.02)
 ;;54458-0987-09
 ;;9002226.02101,"1201,54569-0613-00 ",.01)
 ;;54569-0613-00
 ;;9002226.02101,"1201,54569-0613-00 ",.02)
 ;;54569-0613-00
 ;;9002226.02101,"1201,54569-0613-02 ",.01)
 ;;54569-0613-02
 ;;9002226.02101,"1201,54569-0613-02 ",.02)
 ;;54569-0613-02
 ;;9002226.02101,"1201,54569-3256-00 ",.01)
 ;;54569-3256-00
 ;;9002226.02101,"1201,54569-3256-00 ",.02)
 ;;54569-3256-00
 ;;9002226.02101,"1201,54569-3256-01 ",.01)
 ;;54569-3256-01
 ;;9002226.02101,"1201,54569-3256-01 ",.02)
 ;;54569-3256-01
 ;;9002226.02101,"1201,54569-3821-00 ",.01)
 ;;54569-3821-00
 ;;9002226.02101,"1201,54569-3821-00 ",.02)
 ;;54569-3821-00
 ;;9002226.02101,"1201,54569-3821-01 ",.01)
 ;;54569-3821-01
 ;;9002226.02101,"1201,54569-3821-01 ",.02)
 ;;54569-3821-01
 ;;9002226.02101,"1201,54569-4071-00 ",.01)
 ;;54569-4071-00
 ;;9002226.02101,"1201,54569-4071-00 ",.02)
 ;;54569-4071-00
 ;;9002226.02101,"1201,54569-4180-01 ",.01)
 ;;54569-4180-01
 ;;9002226.02101,"1201,54569-4180-01 ",.02)
 ;;54569-4180-01
 ;;9002226.02101,"1201,54569-4346-01 ",.01)
 ;;54569-4346-01
 ;;9002226.02101,"1201,54569-4346-01 ",.02)
 ;;54569-4346-01
 ;;9002226.02101,"1201,54569-4403-00 ",.01)
 ;;54569-4403-00
 ;;9002226.02101,"1201,54569-4403-00 ",.02)
 ;;54569-4403-00
 ;;9002226.02101,"1201,54569-4404-00 ",.01)
 ;;54569-4404-00
 ;;9002226.02101,"1201,54569-4404-00 ",.02)
 ;;54569-4404-00
 ;;9002226.02101,"1201,54569-4466-00 ",.01)
 ;;54569-4466-00
 ;;9002226.02101,"1201,54569-4466-00 ",.02)
 ;;54569-4466-00
 ;;9002226.02101,"1201,54569-4466-01 ",.01)
 ;;54569-4466-01
 ;;9002226.02101,"1201,54569-4466-01 ",.02)
 ;;54569-4466-01
 ;;9002226.02101,"1201,54569-4466-02 ",.01)
 ;;54569-4466-02
 ;;9002226.02101,"1201,54569-4466-02 ",.02)
 ;;54569-4466-02
 ;;9002226.02101,"1201,54569-4467-00 ",.01)
 ;;54569-4467-00
 ;;9002226.02101,"1201,54569-4467-00 ",.02)
 ;;54569-4467-00
 ;;9002226.02101,"1201,54569-4467-01 ",.01)
 ;;54569-4467-01
 ;;9002226.02101,"1201,54569-4467-01 ",.02)
 ;;54569-4467-01
 ;;9002226.02101,"1201,54569-4584-00 ",.01)
 ;;54569-4584-00
 ;;9002226.02101,"1201,54569-4584-00 ",.02)
 ;;54569-4584-00
 ;;9002226.02101,"1201,54569-4587-00 ",.01)
 ;;54569-4587-00
 ;;9002226.02101,"1201,54569-4587-00 ",.02)
 ;;54569-4587-00
 ;;9002226.02101,"1201,54569-4587-01 ",.01)
 ;;54569-4587-01
 ;;9002226.02101,"1201,54569-4587-01 ",.02)
 ;;54569-4587-01
 ;;9002226.02101,"1201,54569-4610-00 ",.01)
 ;;54569-4610-00
 ;;9002226.02101,"1201,54569-4610-00 ",.02)
 ;;54569-4610-00
 ;;9002226.02101,"1201,54569-4761-00 ",.01)
 ;;54569-4761-00