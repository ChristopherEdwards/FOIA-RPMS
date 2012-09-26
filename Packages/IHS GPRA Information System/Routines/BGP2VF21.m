BGP2VF21 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 08, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"798,00378-4350-93 ",.01)
 ;;00378-4350-93
 ;;9002226.02101,"798,00378-4350-93 ",.02)
 ;;00378-4350-93
 ;;9002226.02101,"798,00378-4881-01 ",.01)
 ;;00378-4881-01
 ;;9002226.02101,"798,00378-4881-01 ",.02)
 ;;00378-4881-01
 ;;9002226.02101,"798,00378-4882-01 ",.01)
 ;;00378-4882-01
 ;;9002226.02101,"798,00378-4882-01 ",.02)
 ;;00378-4882-01
 ;;9002226.02101,"798,00378-4883-01 ",.01)
 ;;00378-4883-01
 ;;9002226.02101,"798,00378-4883-01 ",.02)
 ;;00378-4883-01
 ;;9002226.02101,"798,00378-4884-01 ",.01)
 ;;00378-4884-01
 ;;9002226.02101,"798,00378-4884-01 ",.02)
 ;;00378-4884-01
 ;;9002226.02101,"798,00378-4885-01 ",.01)
 ;;00378-4885-01
 ;;9002226.02101,"798,00378-4885-01 ",.02)
 ;;00378-4885-01
 ;;9002226.02101,"798,00378-5375-01 ",.01)
 ;;00378-5375-01
 ;;9002226.02101,"798,00378-5375-01 ",.02)
 ;;00378-5375-01
 ;;9002226.02101,"798,00378-5375-10 ",.01)
 ;;00378-5375-10
 ;;9002226.02101,"798,00378-5375-10 ",.02)
 ;;00378-5375-10
 ;;9002226.02101,"798,00378-5410-28 ",.01)
 ;;00378-5410-28
 ;;9002226.02101,"798,00378-5410-28 ",.02)
 ;;00378-5410-28
 ;;9002226.02101,"798,00378-5420-28 ",.01)
 ;;00378-5420-28
 ;;9002226.02101,"798,00378-5420-28 ",.02)
 ;;00378-5420-28
 ;;9002226.02101,"798,00378-5521-01 ",.01)
 ;;00378-5521-01
 ;;9002226.02101,"798,00378-5521-01 ",.02)
 ;;00378-5521-01
 ;;9002226.02101,"798,00378-6231-01 ",.01)
 ;;00378-6231-01
 ;;9002226.02101,"798,00378-6231-01 ",.02)
 ;;00378-6231-01
 ;;9002226.02101,"798,00378-6231-05 ",.01)
 ;;00378-6231-05
 ;;9002226.02101,"798,00378-6231-05 ",.02)
 ;;00378-6231-05
 ;;9002226.02101,"798,00378-6232-01 ",.01)
 ;;00378-6232-01
 ;;9002226.02101,"798,00378-6232-01 ",.02)
 ;;00378-6232-01
 ;;9002226.02101,"798,00378-6232-05 ",.01)
 ;;00378-6232-05
 ;;9002226.02101,"798,00378-6232-05 ",.02)
 ;;00378-6232-05
 ;;9002226.02101,"798,00378-6233-01 ",.01)
 ;;00378-6233-01
 ;;9002226.02101,"798,00378-6233-01 ",.02)
 ;;00378-6233-01
 ;;9002226.02101,"798,00378-6233-05 ",.01)
 ;;00378-6233-05
 ;;9002226.02101,"798,00378-6233-05 ",.02)
 ;;00378-6233-05
 ;;9002226.02101,"798,00378-6410-01 ",.01)
 ;;00378-6410-01
 ;;9002226.02101,"798,00378-6410-01 ",.02)
 ;;00378-6410-01
 ;;9002226.02101,"798,00378-6410-10 ",.01)
 ;;00378-6410-10
 ;;9002226.02101,"798,00378-6410-10 ",.02)
 ;;00378-6410-10
 ;;9002226.02101,"798,00378-7001-10 ",.01)
 ;;00378-7001-10
 ;;9002226.02101,"798,00378-7001-10 ",.02)
 ;;00378-7001-10
 ;;9002226.02101,"798,00378-7001-93 ",.01)
 ;;00378-7001-93
 ;;9002226.02101,"798,00378-7001-93 ",.02)
 ;;00378-7001-93
 ;;9002226.02101,"798,00378-7002-10 ",.01)
 ;;00378-7002-10
 ;;9002226.02101,"798,00378-7002-10 ",.02)
 ;;00378-7002-10
 ;;9002226.02101,"798,00378-7002-93 ",.01)
 ;;00378-7002-93
 ;;9002226.02101,"798,00378-7002-93 ",.02)
 ;;00378-7002-93
 ;;9002226.02101,"798,00378-7003-10 ",.01)
 ;;00378-7003-10
 ;;9002226.02101,"798,00378-7003-10 ",.02)
 ;;00378-7003-10
 ;;9002226.02101,"798,00378-7003-93 ",.01)
 ;;00378-7003-93
 ;;9002226.02101,"798,00378-7003-93 ",.02)
 ;;00378-7003-93
 ;;9002226.02101,"798,00378-7004-10 ",.01)
 ;;00378-7004-10
 ;;9002226.02101,"798,00378-7004-10 ",.02)
 ;;00378-7004-10
 ;;9002226.02101,"798,00378-7004-93 ",.01)
 ;;00378-7004-93
 ;;9002226.02101,"798,00378-7004-93 ",.02)
 ;;00378-7004-93
 ;;9002226.02101,"798,00406-0661-01 ",.01)
 ;;00406-0661-01
 ;;9002226.02101,"798,00406-0661-01 ",.02)
 ;;00406-0661-01
 ;;9002226.02101,"798,00406-0661-05 ",.01)
 ;;00406-0661-05
 ;;9002226.02101,"798,00406-0661-05 ",.02)
 ;;00406-0661-05
 ;;9002226.02101,"798,00406-0661-91 ",.01)
 ;;00406-0661-91
 ;;9002226.02101,"798,00406-0661-91 ",.02)
 ;;00406-0661-91
 ;;9002226.02101,"798,00406-0663-01 ",.01)
 ;;00406-0663-01
 ;;9002226.02101,"798,00406-0663-01 ",.02)
 ;;00406-0663-01
 ;;9002226.02101,"798,00406-0663-03 ",.01)
 ;;00406-0663-03
 ;;9002226.02101,"798,00406-0663-03 ",.02)
 ;;00406-0663-03
 ;;9002226.02101,"798,00406-0663-05 ",.01)
 ;;00406-0663-05
 ;;9002226.02101,"798,00406-0663-05 ",.02)
 ;;00406-0663-05
 ;;9002226.02101,"798,00406-0663-62 ",.01)
 ;;00406-0663-62
 ;;9002226.02101,"798,00406-0663-62 ",.02)
 ;;00406-0663-62
 ;;9002226.02101,"798,00406-0663-91 ",.01)
 ;;00406-0663-91
 ;;9002226.02101,"798,00406-0663-91 ",.02)
 ;;00406-0663-91
 ;;9002226.02101,"798,00406-0667-01 ",.01)
 ;;00406-0667-01
 ;;9002226.02101,"798,00406-0667-01 ",.02)
 ;;00406-0667-01
 ;;9002226.02101,"798,00406-2001-03 ",.01)
 ;;00406-2001-03
 ;;9002226.02101,"798,00406-2001-03 ",.02)
 ;;00406-2001-03
 ;;9002226.02101,"798,00406-2001-05 ",.01)
 ;;00406-2001-05
 ;;9002226.02101,"798,00406-2001-05 ",.02)
 ;;00406-2001-05
 ;;9002226.02101,"798,00406-2001-90 ",.01)
 ;;00406-2001-90
 ;;9002226.02101,"798,00406-2001-90 ",.02)
 ;;00406-2001-90
 ;;9002226.02101,"798,00406-2097-03 ",.01)
 ;;00406-2097-03
 ;;9002226.02101,"798,00406-2097-03 ",.02)
 ;;00406-2097-03
 ;;9002226.02101,"798,00406-2097-05 ",.01)
 ;;00406-2097-05
 ;;9002226.02101,"798,00406-2097-05 ",.02)
 ;;00406-2097-05
 ;;9002226.02101,"798,00406-2097-90 ",.01)
 ;;00406-2097-90
 ;;9002226.02101,"798,00406-2097-90 ",.02)
 ;;00406-2097-90
 ;;9002226.02101,"798,00406-2098-01 ",.01)
 ;;00406-2098-01
 ;;9002226.02101,"798,00406-2098-01 ",.02)
 ;;00406-2098-01
 ;;9002226.02101,"798,00406-2098-03 ",.01)
 ;;00406-2098-03
 ;;9002226.02101,"798,00406-2098-03 ",.02)
 ;;00406-2098-03
 ;;9002226.02101,"798,00406-2098-05 ",.01)
 ;;00406-2098-05
 ;;9002226.02101,"798,00406-2098-05 ",.02)
 ;;00406-2098-05
 ;;9002226.02101,"798,00406-2098-90 ",.01)
 ;;00406-2098-90
 ;;9002226.02101,"798,00406-2098-90 ",.02)
 ;;00406-2098-90
 ;;9002226.02101,"798,00406-2099-03 ",.01)
 ;;00406-2099-03
 ;;9002226.02101,"798,00406-2099-03 ",.02)
 ;;00406-2099-03
 ;;9002226.02101,"798,00406-2099-05 ",.01)
 ;;00406-2099-05
 ;;9002226.02101,"798,00406-2099-05 ",.02)
 ;;00406-2099-05
 ;;9002226.02101,"798,00406-2099-90 ",.01)
 ;;00406-2099-90
 ;;9002226.02101,"798,00406-2099-90 ",.02)
 ;;00406-2099-90
 ;;9002226.02101,"798,00406-9906-01 ",.01)
 ;;00406-9906-01
 ;;9002226.02101,"798,00406-9906-01 ",.02)
 ;;00406-9906-01
 ;;9002226.02101,"798,00406-9906-03 ",.01)
 ;;00406-9906-03
 ;;9002226.02101,"798,00406-9906-03 ",.02)
 ;;00406-9906-03
 ;;9002226.02101,"798,00406-9906-62 ",.01)
 ;;00406-9906-62
 ;;9002226.02101,"798,00406-9906-62 ",.02)
 ;;00406-9906-62
 ;;9002226.02101,"798,00406-9907-01 ",.01)
 ;;00406-9907-01
 ;;9002226.02101,"798,00406-9907-01 ",.02)
 ;;00406-9907-01
 ;;9002226.02101,"798,00406-9907-03 ",.01)
 ;;00406-9907-03
 ;;9002226.02101,"798,00406-9907-03 ",.02)
 ;;00406-9907-03
 ;;9002226.02101,"798,00406-9907-62 ",.01)
 ;;00406-9907-62
 ;;9002226.02101,"798,00406-9907-62 ",.02)
 ;;00406-9907-62
 ;;9002226.02101,"798,00406-9908-01 ",.01)
 ;;00406-9908-01
 ;;9002226.02101,"798,00406-9908-01 ",.02)
 ;;00406-9908-01
 ;;9002226.02101,"798,00406-9908-03 ",.01)
 ;;00406-9908-03
 ;;9002226.02101,"798,00406-9908-03 ",.02)
 ;;00406-9908-03
 ;;9002226.02101,"798,00406-9910-01 ",.01)
 ;;00406-9910-01
 ;;9002226.02101,"798,00406-9910-01 ",.02)
 ;;00406-9910-01
 ;;9002226.02101,"798,00406-9910-03 ",.01)
 ;;00406-9910-03
 ;;9002226.02101,"798,00406-9910-03 ",.02)
 ;;00406-9910-03
 ;;9002226.02101,"798,00406-9911-01 ",.01)
 ;;00406-9911-01
 ;;9002226.02101,"798,00406-9911-01 ",.02)
 ;;00406-9911-01
 ;;9002226.02101,"798,00406-9911-03 ",.01)
 ;;00406-9911-03
 ;;9002226.02101,"798,00406-9911-03 ",.02)
 ;;00406-9911-03
 ;;9002226.02101,"798,00406-9912-01 ",.01)
 ;;00406-9912-01
 ;;9002226.02101,"798,00406-9912-01 ",.02)
 ;;00406-9912-01
 ;;9002226.02101,"798,00406-9912-03 ",.01)
 ;;00406-9912-03
 ;;9002226.02101,"798,00406-9912-03 ",.02)
 ;;00406-9912-03
 ;;9002226.02101,"798,00406-9913-01 ",.01)
 ;;00406-9913-01
 ;;9002226.02101,"798,00406-9913-01 ",.02)
 ;;00406-9913-01
 ;;9002226.02101,"798,00406-9913-03 ",.01)
 ;;00406-9913-03
 ;;9002226.02101,"798,00406-9913-03 ",.02)
 ;;00406-9913-03
 ;;9002226.02101,"798,00406-9918-16 ",.01)
 ;;00406-9918-16
 ;;9002226.02101,"798,00406-9918-16 ",.02)
 ;;00406-9918-16
 ;;9002226.02101,"798,00406-9920-01 ",.01)
 ;;00406-9920-01
 ;;9002226.02101,"798,00406-9920-01 ",.02)
 ;;00406-9920-01
 ;;9002226.02101,"798,00406-9920-03 ",.01)
 ;;00406-9920-03
 ;;9002226.02101,"798,00406-9920-03 ",.02)
 ;;00406-9920-03
 ;;9002226.02101,"798,00406-9921-01 ",.01)
 ;;00406-9921-01
 ;;9002226.02101,"798,00406-9921-01 ",.02)
 ;;00406-9921-01
 ;;9002226.02101,"798,00406-9921-03 ",.01)
 ;;00406-9921-03
 ;;9002226.02101,"798,00406-9921-03 ",.02)
 ;;00406-9921-03
 ;;9002226.02101,"798,00406-9922-01 ",.01)
 ;;00406-9922-01
 ;;9002226.02101,"798,00406-9922-01 ",.02)
 ;;00406-9922-01
 ;;9002226.02101,"798,00406-9922-03 ",.01)
 ;;00406-9922-03
 ;;9002226.02101,"798,00406-9922-03 ",.02)
 ;;00406-9922-03
 ;;9002226.02101,"798,00406-9923-01 ",.01)
 ;;00406-9923-01
 ;;9002226.02101,"798,00406-9923-01 ",.02)
 ;;00406-9923-01
 ;;9002226.02101,"798,00406-9923-03 ",.01)
 ;;00406-9923-03
 ;;9002226.02101,"798,00406-9923-03 ",.02)
 ;;00406-9923-03
 ;;9002226.02101,"798,00406-9924-01 ",.01)
 ;;00406-9924-01
 ;;9002226.02101,"798,00406-9924-01 ",.02)
 ;;00406-9924-01
 ;;9002226.02101,"798,00406-9924-03 ",.01)
 ;;00406-9924-03
 ;;9002226.02101,"798,00406-9924-03 ",.02)
 ;;00406-9924-03
 ;;9002226.02101,"798,00406-9925-01 ",.01)
 ;;00406-9925-01
 ;;9002226.02101,"798,00406-9925-01 ",.02)
 ;;00406-9925-01
 ;;9002226.02101,"798,00406-9925-03 ",.01)
 ;;00406-9925-03
 ;;9002226.02101,"798,00406-9925-03 ",.02)
 ;;00406-9925-03
 ;;9002226.02101,"798,00406-9926-01 ",.01)
 ;;00406-9926-01
 ;;9002226.02101,"798,00406-9926-01 ",.02)
 ;;00406-9926-01
 ;;9002226.02101,"798,00406-9926-03 ",.01)
 ;;00406-9926-03
 ;;9002226.02101,"798,00406-9926-03 ",.02)
 ;;00406-9926-03
 ;;9002226.02101,"798,00406-9931-03 ",.01)
 ;;00406-9931-03
 ;;9002226.02101,"798,00406-9931-03 ",.02)
 ;;00406-9931-03
 ;;9002226.02101,"798,00406-9932-03 ",.01)
 ;;00406-9932-03
 ;;9002226.02101,"798,00406-9932-03 ",.02)
 ;;00406-9932-03
 ;;9002226.02101,"798,00406-9933-03 ",.01)
 ;;00406-9933-03
 ;;9002226.02101,"798,00406-9933-03 ",.02)
 ;;00406-9933-03
 ;;9002226.02101,"798,00406-9934-03 ",.01)
 ;;00406-9934-03
 ;;9002226.02101,"798,00406-9934-03 ",.02)
 ;;00406-9934-03
 ;;9002226.02101,"798,00430-0210-14 ",.01)
 ;;00430-0210-14
 ;;9002226.02101,"798,00430-0210-14 ",.02)
 ;;00430-0210-14
 ;;9002226.02101,"798,00430-0215-14 ",.01)
 ;;00430-0215-14
 ;;9002226.02101,"798,00430-0215-14 ",.02)
 ;;00430-0215-14
 ;;9002226.02101,"798,00430-0220-14 ",.01)
 ;;00430-0220-14
 ;;9002226.02101,"798,00430-0220-14 ",.02)
 ;;00430-0220-14
 ;;9002226.02101,"798,00430-0435-14 ",.01)
 ;;00430-0435-14
 ;;9002226.02101,"798,00430-0435-14 ",.02)
 ;;00430-0435-14
 ;;9002226.02101,"798,00430-0436-14 ",.01)
 ;;00430-0436-14
 ;;9002226.02101,"798,00430-0436-14 ",.02)
 ;;00430-0436-14
 ;;9002226.02101,"798,00440-7090-30 ",.01)
 ;;00440-7090-30
 ;;9002226.02101,"798,00440-7090-30 ",.02)
 ;;00440-7090-30
 ;;9002226.02101,"798,00440-7091-30 ",.01)
 ;;00440-7091-30
 ;;9002226.02101,"798,00440-7091-30 ",.02)
 ;;00440-7091-30
 ;;9002226.02101,"798,00440-7092-30 ",.01)
 ;;00440-7092-30
 ;;9002226.02101,"798,00440-7092-30 ",.02)
 ;;00440-7092-30
 ;;9002226.02101,"798,00440-7477-30 ",.01)
 ;;00440-7477-30
 ;;9002226.02101,"798,00440-7477-30 ",.02)
 ;;00440-7477-30
 ;;9002226.02101,"798,00440-7478-30 ",.01)
 ;;00440-7478-30
 ;;9002226.02101,"798,00440-7478-30 ",.02)
 ;;00440-7478-30
 ;;9002226.02101,"798,00440-7521-30 ",.01)
 ;;00440-7521-30
 ;;9002226.02101,"798,00440-7521-30 ",.02)
 ;;00440-7521-30
 ;;9002226.02101,"798,00440-8575-20 ",.01)
 ;;00440-8575-20
 ;;9002226.02101,"798,00440-8575-20 ",.02)
 ;;00440-8575-20
 ;;9002226.02101,"798,00440-8576-30 ",.01)
 ;;00440-8576-30
 ;;9002226.02101,"798,00440-8576-30 ",.02)
 ;;00440-8576-30
 ;;9002226.02101,"798,00456-1110-30 ",.01)
 ;;00456-1110-30
 ;;9002226.02101,"798,00456-1110-30 ",.02)
 ;;00456-1110-30
 ;;9002226.02101,"798,00456-1120-30 ",.01)
 ;;00456-1120-30
 ;;9002226.02101,"798,00456-1120-30 ",.02)
 ;;00456-1120-30
 ;;9002226.02101,"798,00456-1140-30 ",.01)
 ;;00456-1140-30
 ;;9002226.02101,"798,00456-1140-30 ",.02)
 ;;00456-1140-30
 ;;9002226.02101,"798,00456-2005-01 ",.01)
 ;;00456-2005-01
 ;;9002226.02101,"798,00456-2005-01 ",.02)
 ;;00456-2005-01
 ;;9002226.02101,"798,00456-2010-01 ",.01)
 ;;00456-2010-01
 ;;9002226.02101,"798,00456-2010-01 ",.02)
 ;;00456-2010-01
 ;;9002226.02101,"798,00456-2010-11 ",.01)
 ;;00456-2010-11
 ;;9002226.02101,"798,00456-2010-11 ",.02)
 ;;00456-2010-11
 ;;9002226.02101,"798,00456-2010-63 ",.01)
 ;;00456-2010-63
 ;;9002226.02101,"798,00456-2010-63 ",.02)
 ;;00456-2010-63
 ;;9002226.02101,"798,00456-2020-01 ",.01)
 ;;00456-2020-01
 ;;9002226.02101,"798,00456-2020-01 ",.02)
 ;;00456-2020-01
 ;;9002226.02101,"798,00456-2020-11 ",.01)
 ;;00456-2020-11
 ;;9002226.02101,"798,00456-2020-11 ",.02)
 ;;00456-2020-11
 ;;9002226.02101,"798,00456-2020-63 ",.01)
 ;;00456-2020-63
 ;;9002226.02101,"798,00456-2020-63 ",.02)
 ;;00456-2020-63
 ;;9002226.02101,"798,00456-2101-08 ",.01)
 ;;00456-2101-08
 ;;9002226.02101,"798,00456-2101-08 ",.02)
 ;;00456-2101-08
 ;;9002226.02101,"798,00456-4010-01 ",.01)
 ;;00456-4010-01
 ;;9002226.02101,"798,00456-4010-01 ",.02)
 ;;00456-4010-01
 ;;9002226.02101,"798,00456-4020-01 ",.01)
 ;;00456-4020-01
 ;;9002226.02101,"798,00456-4020-01 ",.02)
 ;;00456-4020-01
 ;;9002226.02101,"798,00456-4020-63 ",.01)
 ;;00456-4020-63
 ;;9002226.02101,"798,00456-4020-63 ",.02)
 ;;00456-4020-63
