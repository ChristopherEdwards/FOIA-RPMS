BJPC2UNB ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 17, 2009;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"746,00085-1806-01 ",.02)
 ;;00085-1806-01
 ;;9002226.02101,"746,00172-6405-44 ",.01)
 ;;00172-6405-44
 ;;9002226.02101,"746,00172-6405-44 ",.02)
 ;;00172-6405-44
 ;;9002226.02101,"746,00172-6405-49 ",.01)
 ;;00172-6405-49
 ;;9002226.02101,"746,00172-6405-49 ",.02)
 ;;00172-6405-49
 ;;9002226.02101,"746,00173-0419-00 ",.01)
 ;;00173-0419-00
 ;;9002226.02101,"746,00173-0419-00 ",.02)
 ;;00173-0419-00
 ;;9002226.02101,"746,00182-6014-65 ",.01)
 ;;00182-6014-65
 ;;9002226.02101,"746,00182-6014-65 ",.02)
 ;;00182-6014-65
 ;;9002226.02101,"746,00182-8010-26 ",.01)
 ;;00182-8010-26
 ;;9002226.02101,"746,00182-8010-26 ",.02)
 ;;00182-8010-26
 ;;9002226.02101,"746,00247-0871-20 ",.01)
 ;;00247-0871-20
 ;;9002226.02101,"746,00247-0871-20 ",.02)
 ;;00247-0871-20
 ;;9002226.02101,"746,00403-3507-18 ",.01)
 ;;00403-3507-18
 ;;9002226.02101,"746,00403-3507-18 ",.02)
 ;;00403-3507-18
 ;;9002226.02101,"746,00403-4672-18 ",.01)
 ;;00403-4672-18
 ;;9002226.02101,"746,00403-4672-18 ",.02)
 ;;00403-4672-18
 ;;9002226.02101,"746,00405-2130-52 ",.01)
 ;;00405-2130-52
 ;;9002226.02101,"746,00405-2130-52 ",.02)
 ;;00405-2130-52
 ;;9002226.02101,"746,00405-2131-31 ",.01)
 ;;00405-2131-31
 ;;9002226.02101,"746,00405-2131-31 ",.02)
 ;;00405-2131-31
 ;;9002226.02101,"746,00472-0831-23 ",.01)
 ;;00472-0831-23
 ;;9002226.02101,"746,00472-0831-23 ",.02)
 ;;00472-0831-23
 ;;9002226.02101,"746,00472-0831-30 ",.01)
 ;;00472-0831-30
 ;;9002226.02101,"746,00472-0831-30 ",.02)
 ;;00472-0831-30
 ;;9002226.02101,"746,00472-0831-60 ",.01)
 ;;00472-0831-60
 ;;9002226.02101,"746,00472-0831-60 ",.02)
 ;;00472-0831-60
 ;;9002226.02101,"746,00472-0832-20 ",.01)
 ;;00472-0832-20
 ;;9002226.02101,"746,00472-0832-20 ",.02)
 ;;00472-0832-20
 ;;9002226.02101,"746,00472-0832-30 ",.01)
 ;;00472-0832-30
 ;;9002226.02101,"746,00472-0832-30 ",.02)
 ;;00472-0832-30
 ;;9002226.02101,"746,00487-9501-01 ",.01)
 ;;00487-9501-01
 ;;9002226.02101,"746,00487-9501-01 ",.02)
 ;;00487-9501-01
 ;;9002226.02101,"746,00487-9501-02 ",.01)
 ;;00487-9501-02
 ;;9002226.02101,"746,00487-9501-02 ",.02)
 ;;00487-9501-02
 ;;9002226.02101,"746,00487-9501-03 ",.01)
 ;;00487-9501-03
 ;;9002226.02101,"746,00487-9501-03 ",.02)
 ;;00487-9501-03
 ;;9002226.02101,"746,00487-9501-25 ",.01)
 ;;00487-9501-25
 ;;9002226.02101,"746,00487-9501-25 ",.02)
 ;;00487-9501-25
 ;;9002226.02101,"746,00487-9501-60 ",.01)
 ;;00487-9501-60
 ;;9002226.02101,"746,00487-9501-60 ",.02)
 ;;00487-9501-60
 ;;9002226.02101,"746,00487-9901-02 ",.01)
 ;;00487-9901-02
 ;;9002226.02101,"746,00487-9901-02 ",.02)
 ;;00487-9901-02
 ;;9002226.02101,"746,00487-9901-30 ",.01)
 ;;00487-9901-30
 ;;9002226.02101,"746,00487-9901-30 ",.02)
 ;;00487-9901-30
 ;;9002226.02101,"746,00487-9904-01 ",.01)
 ;;00487-9904-01
 ;;9002226.02101,"746,00487-9904-01 ",.02)
 ;;00487-9904-01
 ;;9002226.02101,"746,00487-9904-02 ",.01)
 ;;00487-9904-02
 ;;9002226.02101,"746,00487-9904-02 ",.02)
 ;;00487-9904-02
 ;;9002226.02101,"746,00536-0007-73 ",.01)
 ;;00536-0007-73
 ;;9002226.02101,"746,00536-0007-73 ",.02)
 ;;00536-0007-73
 ;;9002226.02101,"746,00536-2675-73 ",.01)
 ;;00536-2675-73
 ;;9002226.02101,"746,00536-2675-73 ",.02)
 ;;00536-2675-73
 ;;9002226.02101,"746,00536-2677-04 ",.01)
 ;;00536-2677-04
 ;;9002226.02101,"746,00536-2677-04 ",.02)
 ;;00536-2677-04
 ;;9002226.02101,"746,00603-1005-40 ",.01)
 ;;00603-1005-40
 ;;9002226.02101,"746,00603-1005-40 ",.02)
 ;;00603-1005-40
 ;;9002226.02101,"746,00603-1006-43 ",.01)
 ;;00603-1006-43
 ;;9002226.02101,"746,00603-1006-43 ",.02)
 ;;00603-1006-43
 ;;9002226.02101,"746,00677-1522-72 ",.01)
 ;;00677-1522-72
 ;;9002226.02101,"746,00677-1522-72 ",.02)
 ;;00677-1522-72
 ;;9002226.02101,"746,00677-1522-73 ",.01)
 ;;00677-1522-73
 ;;9002226.02101,"746,00677-1522-73 ",.02)
 ;;00677-1522-73
 ;;9002226.02101,"746,00781-9150-93 ",.01)
 ;;00781-9150-93
 ;;9002226.02101,"746,00781-9150-93 ",.02)
 ;;00781-9150-93
 ;;9002226.02101,"746,00839-7730-97 ",.01)
 ;;00839-7730-97
 ;;9002226.02101,"746,00839-7730-97 ",.02)
 ;;00839-7730-97
 ;;9002226.02101,"746,00839-7816-10 ",.01)
 ;;00839-7816-10
 ;;9002226.02101,"746,00839-7816-10 ",.02)
 ;;00839-7816-10
 ;;9002226.02101,"746,00904-7658-55 ",.01)
 ;;00904-7658-55
 ;;9002226.02101,"746,00904-7658-55 ",.02)
 ;;00904-7658-55
 ;;9002226.02101,"746,00904-7731-17 ",.01)
 ;;00904-7731-17
 ;;9002226.02101,"746,00904-7731-17 ",.02)
 ;;00904-7731-17
 ;;9002226.02101,"746,12280-0241-25 ",.01)
 ;;12280-0241-25
 ;;9002226.02101,"746,12280-0241-25 ",.02)
 ;;12280-0241-25
 ;;9002226.02101,"746,24208-0347-20 ",.01)
 ;;24208-0347-20
 ;;9002226.02101,"746,24208-0347-20 ",.02)
 ;;24208-0347-20
 ;;9002226.02101,"746,38245-0640-09 ",.01)
 ;;38245-0640-09
 ;;9002226.02101,"746,38245-0640-09 ",.02)
 ;;38245-0640-09
 ;;9002226.02101,"746,49502-0105-01 ",.01)
 ;;49502-0105-01
 ;;9002226.02101,"746,49502-0105-01 ",.02)
 ;;49502-0105-01
 ;;9002226.02101,"746,49502-0692-03 ",.01)
 ;;49502-0692-03
 ;;9002226.02101,"746,49502-0692-03 ",.02)
 ;;49502-0692-03
 ;;9002226.02101,"746,49502-0693-03 ",.01)
 ;;49502-0693-03
 ;;9002226.02101,"746,49502-0693-03 ",.02)
 ;;49502-0693-03
 ;;9002226.02101,"746,49502-0697-03 ",.01)
 ;;49502-0697-03