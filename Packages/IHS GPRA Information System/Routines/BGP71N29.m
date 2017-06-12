BGP71N29 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 30, 2016 ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1799,68047-0721-01 ",.01)
 ;;68047-0721-01
 ;;9002226.02101,"1799,68047-0721-01 ",.02)
 ;;68047-0721-01
 ;;9002226.02101,"1799,68071-0304-30 ",.01)
 ;;68071-0304-30
 ;;9002226.02101,"1799,68071-0304-30 ",.02)
 ;;68071-0304-30
 ;;9002226.02101,"1799,68071-0361-30 ",.01)
 ;;68071-0361-30
 ;;9002226.02101,"1799,68071-0361-30 ",.02)
 ;;68071-0361-30
 ;;9002226.02101,"1799,68071-0414-30 ",.01)
 ;;68071-0414-30
 ;;9002226.02101,"1799,68071-0414-30 ",.02)
 ;;68071-0414-30
 ;;9002226.02101,"1799,68071-0421-30 ",.01)
 ;;68071-0421-30
 ;;9002226.02101,"1799,68071-0421-30 ",.02)
 ;;68071-0421-30
 ;;9002226.02101,"1799,68071-0421-60 ",.01)
 ;;68071-0421-60
 ;;9002226.02101,"1799,68071-0421-60 ",.02)
 ;;68071-0421-60
 ;;9002226.02101,"1799,68071-0421-90 ",.01)
 ;;68071-0421-90
 ;;9002226.02101,"1799,68071-0421-90 ",.02)
 ;;68071-0421-90
 ;;9002226.02101,"1799,68071-0698-10 ",.01)
 ;;68071-0698-10
 ;;9002226.02101,"1799,68071-0698-10 ",.02)
 ;;68071-0698-10
 ;;9002226.02101,"1799,68071-0698-14 ",.01)
 ;;68071-0698-14
 ;;9002226.02101,"1799,68071-0698-14 ",.02)
 ;;68071-0698-14
 ;;9002226.02101,"1799,68071-0698-20 ",.01)
 ;;68071-0698-20
 ;;9002226.02101,"1799,68071-0698-20 ",.02)
 ;;68071-0698-20
 ;;9002226.02101,"1799,68071-0698-30 ",.01)
 ;;68071-0698-30
 ;;9002226.02101,"1799,68071-0698-30 ",.02)
 ;;68071-0698-30
 ;;9002226.02101,"1799,68071-0698-60 ",.01)
 ;;68071-0698-60
 ;;9002226.02101,"1799,68071-0698-60 ",.02)
 ;;68071-0698-60
 ;;9002226.02101,"1799,68071-0703-14 ",.01)
 ;;68071-0703-14
 ;;9002226.02101,"1799,68071-0703-14 ",.02)
 ;;68071-0703-14
 ;;9002226.02101,"1799,68071-0703-30 ",.01)
 ;;68071-0703-30
 ;;9002226.02101,"1799,68071-0703-30 ",.02)
 ;;68071-0703-30
 ;;9002226.02101,"1799,68071-0703-45 ",.01)
 ;;68071-0703-45
 ;;9002226.02101,"1799,68071-0703-45 ",.02)
 ;;68071-0703-45
 ;;9002226.02101,"1799,68071-0703-60 ",.01)
 ;;68071-0703-60
 ;;9002226.02101,"1799,68071-0703-60 ",.02)
 ;;68071-0703-60
 ;;9002226.02101,"1799,68071-0788-30 ",.01)
 ;;68071-0788-30
 ;;9002226.02101,"1799,68071-0788-30 ",.02)
 ;;68071-0788-30
 ;;9002226.02101,"1799,68071-0789-30 ",.01)
 ;;68071-0789-30
 ;;9002226.02101,"1799,68071-0789-30 ",.02)
 ;;68071-0789-30
 ;;9002226.02101,"1799,68071-2007-03 ",.01)
 ;;68071-2007-03
 ;;9002226.02101,"1799,68071-2007-03 ",.02)
 ;;68071-2007-03
 ;;9002226.02101,"1799,68071-2007-06 ",.01)
 ;;68071-2007-06
 ;;9002226.02101,"1799,68071-2007-06 ",.02)
 ;;68071-2007-06
 ;;9002226.02101,"1799,68084-0189-01 ",.01)
 ;;68084-0189-01
 ;;9002226.02101,"1799,68084-0189-01 ",.02)
 ;;68084-0189-01
 ;;9002226.02101,"1799,68084-0189-11 ",.01)
 ;;68084-0189-11
 ;;9002226.02101,"1799,68084-0189-11 ",.02)
 ;;68084-0189-11
 ;;9002226.02101,"1799,68084-0200-01 ",.01)
 ;;68084-0200-01
 ;;9002226.02101,"1799,68084-0200-01 ",.02)
 ;;68084-0200-01
 ;;9002226.02101,"1799,68084-0200-11 ",.01)
 ;;68084-0200-11
 ;;9002226.02101,"1799,68084-0200-11 ",.02)
 ;;68084-0200-11
 ;;9002226.02101,"1799,68084-0225-01 ",.01)
 ;;68084-0225-01
 ;;9002226.02101,"1799,68084-0225-01 ",.02)
 ;;68084-0225-01
 ;;9002226.02101,"1799,68084-0225-11 ",.01)
 ;;68084-0225-11
 ;;9002226.02101,"1799,68084-0225-11 ",.02)
 ;;68084-0225-11
 ;;9002226.02101,"1799,68084-0226-01 ",.01)
 ;;68084-0226-01
 ;;9002226.02101,"1799,68084-0226-01 ",.02)
 ;;68084-0226-01
 ;;9002226.02101,"1799,68084-0226-11 ",.01)
 ;;68084-0226-11
 ;;9002226.02101,"1799,68084-0226-11 ",.02)
 ;;68084-0226-11
 ;;9002226.02101,"1799,68084-0396-01 ",.01)
 ;;68084-0396-01
 ;;9002226.02101,"1799,68084-0396-01 ",.02)
 ;;68084-0396-01
 ;;9002226.02101,"1799,68084-0396-11 ",.01)
 ;;68084-0396-11
 ;;9002226.02101,"1799,68084-0396-11 ",.02)
 ;;68084-0396-11
 ;;9002226.02101,"1799,68084-0396-65 ",.01)
 ;;68084-0396-65
 ;;9002226.02101,"1799,68084-0396-65 ",.02)
 ;;68084-0396-65
 ;;9002226.02101,"1799,68084-0523-11 ",.01)
 ;;68084-0523-11
 ;;9002226.02101,"1799,68084-0523-11 ",.02)
 ;;68084-0523-11
 ;;9002226.02101,"1799,68084-0523-21 ",.01)
 ;;68084-0523-21
 ;;9002226.02101,"1799,68084-0523-21 ",.02)
 ;;68084-0523-21
 ;;9002226.02101,"1799,68084-0790-11 ",.01)
 ;;68084-0790-11
 ;;9002226.02101,"1799,68084-0790-11 ",.02)
 ;;68084-0790-11
 ;;9002226.02101,"1799,68084-0790-21 ",.01)
 ;;68084-0790-21
 ;;9002226.02101,"1799,68084-0790-21 ",.02)
 ;;68084-0790-21
 ;;9002226.02101,"1799,68084-0790-25 ",.01)
 ;;68084-0790-25
 ;;9002226.02101,"1799,68084-0790-25 ",.02)
 ;;68084-0790-25
 ;;9002226.02101,"1799,68084-0790-95 ",.01)
 ;;68084-0790-95
 ;;9002226.02101,"1799,68084-0790-95 ",.02)
 ;;68084-0790-95
 ;;9002226.02101,"1799,68084-0814-11 ",.01)
 ;;68084-0814-11
 ;;9002226.02101,"1799,68084-0814-11 ",.02)
 ;;68084-0814-11
 ;;9002226.02101,"1799,68084-0814-21 ",.01)
 ;;68084-0814-21
 ;;9002226.02101,"1799,68084-0814-21 ",.02)
 ;;68084-0814-21
 ;;9002226.02101,"1799,68084-0818-25 ",.01)
 ;;68084-0818-25
 ;;9002226.02101,"1799,68084-0818-25 ",.02)
 ;;68084-0818-25
 ;;9002226.02101,"1799,68084-0818-95 ",.01)
 ;;68084-0818-95
 ;;9002226.02101,"1799,68084-0818-95 ",.02)
 ;;68084-0818-95
 ;;9002226.02101,"1799,68084-0889-11 ",.01)
 ;;68084-0889-11
 ;;9002226.02101,"1799,68084-0889-11 ",.02)
 ;;68084-0889-11
 ;;9002226.02101,"1799,68084-0889-21 ",.01)
 ;;68084-0889-21
 ;;9002226.02101,"1799,68084-0889-21 ",.02)
 ;;68084-0889-21
 ;;9002226.02101,"1799,68084-0934-32 ",.01)
 ;;68084-0934-32
 ;;9002226.02101,"1799,68084-0934-32 ",.02)
 ;;68084-0934-32
 ;;9002226.02101,"1799,68084-0934-33 ",.01)
 ;;68084-0934-33
 ;;9002226.02101,"1799,68084-0934-33 ",.02)
 ;;68084-0934-33
 ;;9002226.02101,"1799,68084-0989-25 ",.01)
 ;;68084-0989-25
 ;;9002226.02101,"1799,68084-0989-25 ",.02)
 ;;68084-0989-25
 ;;9002226.02101,"1799,68084-0989-95 ",.01)
 ;;68084-0989-95
 ;;9002226.02101,"1799,68084-0989-95 ",.02)
 ;;68084-0989-95
 ;;9002226.02101,"1799,68084-0995-25 ",.01)
 ;;68084-0995-25
 ;;9002226.02101,"1799,68084-0995-25 ",.02)
 ;;68084-0995-25
 ;;9002226.02101,"1799,68084-0995-95 ",.01)
 ;;68084-0995-95
 ;;9002226.02101,"1799,68084-0995-95 ",.02)
 ;;68084-0995-95
 ;;9002226.02101,"1799,68180-0311-01 ",.01)
 ;;68180-0311-01
 ;;9002226.02101,"1799,68180-0311-01 ",.02)
 ;;68180-0311-01
 ;;9002226.02101,"1799,68180-0312-01 ",.01)
 ;;68180-0312-01
 ;;9002226.02101,"1799,68180-0312-01 ",.02)
 ;;68180-0312-01
 ;;9002226.02101,"1799,68180-0313-01 ",.01)
 ;;68180-0313-01
 ;;9002226.02101,"1799,68180-0313-01 ",.02)
 ;;68180-0313-01
 ;;9002226.02101,"1799,68180-0314-06 ",.01)
 ;;68180-0314-06
 ;;9002226.02101,"1799,68180-0314-06 ",.02)
 ;;68180-0314-06
 ;;9002226.02101,"1799,68180-0315-06 ",.01)
 ;;68180-0315-06
 ;;9002226.02101,"1799,68180-0315-06 ",.02)
 ;;68180-0315-06
 ;;9002226.02101,"1799,68180-0316-06 ",.01)
 ;;68180-0316-06
 ;;9002226.02101,"1799,68180-0316-06 ",.02)
 ;;68180-0316-06
 ;;9002226.02101,"1799,68180-0317-06 ",.01)
 ;;68180-0317-06
 ;;9002226.02101,"1799,68180-0317-06 ",.02)
 ;;68180-0317-06
 ;;9002226.02101,"1799,68180-0322-01 ",.01)
 ;;68180-0322-01
 ;;9002226.02101,"1799,68180-0322-01 ",.02)
 ;;68180-0322-01
 ;;9002226.02101,"1799,68180-0323-01 ",.01)
 ;;68180-0323-01
 ;;9002226.02101,"1799,68180-0323-01 ",.02)
 ;;68180-0323-01
 ;;9002226.02101,"1799,68180-0324-01 ",.01)
 ;;68180-0324-01
 ;;9002226.02101,"1799,68180-0324-01 ",.02)
 ;;68180-0324-01
 ;;9002226.02101,"1799,68180-0779-01 ",.01)
 ;;68180-0779-01
 ;;9002226.02101,"1799,68180-0779-01 ",.02)
 ;;68180-0779-01
 ;;9002226.02101,"1799,68180-0780-01 ",.01)
 ;;68180-0780-01
 ;;9002226.02101,"1799,68180-0780-01 ",.02)
 ;;68180-0780-01
 ;;9002226.02101,"1799,68258-2012-09 ",.01)
 ;;68258-2012-09
 ;;9002226.02101,"1799,68258-2012-09 ",.02)
 ;;68258-2012-09
 ;;9002226.02101,"1799,68258-7048-03 ",.01)
 ;;68258-7048-03
 ;;9002226.02101,"1799,68258-7048-03 ",.02)
 ;;68258-7048-03
 ;;9002226.02101,"1799,68258-7049-03 ",.01)
 ;;68258-7049-03
 ;;9002226.02101,"1799,68258-7049-03 ",.02)
 ;;68258-7049-03
 ;;9002226.02101,"1799,68258-7160-03 ",.01)
 ;;68258-7160-03
 ;;9002226.02101,"1799,68258-7160-03 ",.02)
 ;;68258-7160-03
 ;;9002226.02101,"1799,68308-0219-01 ",.01)
 ;;68308-0219-01
 ;;9002226.02101,"1799,68308-0219-01 ",.02)
 ;;68308-0219-01
 ;;9002226.02101,"1799,68308-0220-01 ",.01)
 ;;68308-0220-01
 ;;9002226.02101,"1799,68308-0220-01 ",.02)
 ;;68308-0220-01
 ;;9002226.02101,"1799,68308-0312-10 ",.01)
 ;;68308-0312-10
 ;;9002226.02101,"1799,68308-0312-10 ",.02)
 ;;68308-0312-10
 ;;9002226.02101,"1799,68308-0554-10 ",.01)
 ;;68308-0554-10
 ;;9002226.02101,"1799,68308-0554-10 ",.02)
 ;;68308-0554-10
 ;;9002226.02101,"1799,68387-0520-12 ",.01)
 ;;68387-0520-12
 ;;9002226.02101,"1799,68387-0520-12 ",.02)
 ;;68387-0520-12
 ;;9002226.02101,"1799,68387-0520-30 ",.01)
 ;;68387-0520-30
 ;;9002226.02101,"1799,68387-0520-30 ",.02)
 ;;68387-0520-30
 ;;9002226.02101,"1799,68387-0520-60 ",.01)
 ;;68387-0520-60
 ;;9002226.02101,"1799,68387-0520-60 ",.02)
 ;;68387-0520-60
 ;;9002226.02101,"1799,68387-0520-90 ",.01)
 ;;68387-0520-90
 ;;9002226.02101,"1799,68387-0520-90 ",.02)
 ;;68387-0520-90
 ;;9002226.02101,"1799,68405-0023-26 ",.01)
 ;;68405-0023-26
 ;;9002226.02101,"1799,68405-0023-26 ",.02)
 ;;68405-0023-26
 ;;9002226.02101,"1799,68405-0044-26 ",.01)
 ;;68405-0044-26
 ;;9002226.02101,"1799,68405-0044-26 ",.02)
 ;;68405-0044-26
 ;;9002226.02101,"1799,68405-0053-26 ",.01)
 ;;68405-0053-26
 ;;9002226.02101,"1799,68405-0053-26 ",.02)
 ;;68405-0053-26
 ;;9002226.02101,"1799,68453-0170-10 ",.01)
 ;;68453-0170-10
 ;;9002226.02101,"1799,68453-0170-10 ",.02)
 ;;68453-0170-10
 ;;9002226.02101,"1799,68462-0279-01 ",.01)
 ;;68462-0279-01
 ;;9002226.02101,"1799,68462-0279-01 ",.02)
 ;;68462-0279-01
 ;;9002226.02101,"1799,68462-0279-05 ",.01)
 ;;68462-0279-05
 ;;9002226.02101,"1799,68462-0279-05 ",.02)
 ;;68462-0279-05
 ;;9002226.02101,"1799,68462-0280-01 ",.01)
 ;;68462-0280-01
 ;;9002226.02101,"1799,68462-0280-01 ",.02)
 ;;68462-0280-01
 ;;9002226.02101,"1799,68462-0280-05 ",.01)
 ;;68462-0280-05
 ;;9002226.02101,"1799,68462-0280-05 ",.02)
 ;;68462-0280-05
 ;;9002226.02101,"1799,68462-0382-01 ",.01)
 ;;68462-0382-01
 ;;9002226.02101,"1799,68462-0382-01 ",.02)
 ;;68462-0382-01
 ;;9002226.02101,"1799,68462-0383-01 ",.01)
 ;;68462-0383-01
 ;;9002226.02101,"1799,68462-0383-01 ",.02)
 ;;68462-0383-01
 ;;9002226.02101,"1799,68462-0384-01 ",.01)
 ;;68462-0384-01
 ;;9002226.02101,"1799,68462-0384-01 ",.02)
 ;;68462-0384-01
 ;;9002226.02101,"1799,68645-0230-59 ",.01)
 ;;68645-0230-59
 ;;9002226.02101,"1799,68645-0230-59 ",.02)
 ;;68645-0230-59
 ;;9002226.02101,"1799,68788-0748-03 ",.01)
 ;;68788-0748-03
 ;;9002226.02101,"1799,68788-0748-03 ",.02)
 ;;68788-0748-03
 ;;9002226.02101,"1799,68788-0748-06 ",.01)
 ;;68788-0748-06
 ;;9002226.02101,"1799,68788-0748-06 ",.02)
 ;;68788-0748-06
 ;;9002226.02101,"1799,68788-0748-09 ",.01)
 ;;68788-0748-09
 ;;9002226.02101,"1799,68788-0748-09 ",.02)
 ;;68788-0748-09
 ;;9002226.02101,"1799,68788-2212-03 ",.01)
 ;;68788-2212-03
 ;;9002226.02101,"1799,68788-2212-03 ",.02)
 ;;68788-2212-03
 ;;9002226.02101,"1799,68788-2212-06 ",.01)
 ;;68788-2212-06
 ;;9002226.02101,"1799,68788-2212-06 ",.02)
 ;;68788-2212-06
 ;;9002226.02101,"1799,68788-2212-09 ",.01)
 ;;68788-2212-09
 ;;9002226.02101,"1799,68788-2212-09 ",.02)
 ;;68788-2212-09
 ;;9002226.02101,"1799,68788-2213-03 ",.01)
 ;;68788-2213-03
 ;;9002226.02101,"1799,68788-2213-03 ",.02)
 ;;68788-2213-03
 ;;9002226.02101,"1799,68788-2213-06 ",.01)
 ;;68788-2213-06
 ;;9002226.02101,"1799,68788-2213-06 ",.02)
 ;;68788-2213-06
 ;;9002226.02101,"1799,68788-8923-01 ",.01)
 ;;68788-8923-01
 ;;9002226.02101,"1799,68788-8923-01 ",.02)
 ;;68788-8923-01
 ;;9002226.02101,"1799,68788-8923-02 ",.01)
 ;;68788-8923-02