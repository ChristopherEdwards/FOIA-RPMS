BGP2TE28 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1197,68115-0284-30 ",.01)
 ;;68115-0284-30
 ;;9002226.02101,"1197,68115-0284-30 ",.02)
 ;;68115-0284-30
 ;;9002226.02101,"1197,68115-0284-60 ",.01)
 ;;68115-0284-60
 ;;9002226.02101,"1197,68115-0284-60 ",.02)
 ;;68115-0284-60
 ;;9002226.02101,"1197,68115-0347-30 ",.01)
 ;;68115-0347-30
 ;;9002226.02101,"1197,68115-0347-30 ",.02)
 ;;68115-0347-30
 ;;9002226.02101,"1197,68115-0347-60 ",.01)
 ;;68115-0347-60
 ;;9002226.02101,"1197,68115-0347-60 ",.02)
 ;;68115-0347-60
 ;;9002226.02101,"1197,68115-0348-00 ",.01)
 ;;68115-0348-00
 ;;9002226.02101,"1197,68115-0348-00 ",.02)
 ;;68115-0348-00
 ;;9002226.02101,"1197,68115-0348-30 ",.01)
 ;;68115-0348-30
 ;;9002226.02101,"1197,68115-0348-30 ",.02)
 ;;68115-0348-30
 ;;9002226.02101,"1197,68115-0349-30 ",.01)
 ;;68115-0349-30
 ;;9002226.02101,"1197,68115-0349-30 ",.02)
 ;;68115-0349-30
 ;;9002226.02101,"1197,68115-0349-60 ",.01)
 ;;68115-0349-60
 ;;9002226.02101,"1197,68115-0349-60 ",.02)
 ;;68115-0349-60
 ;;9002226.02101,"1197,68115-0350-90 ",.01)
 ;;68115-0350-90
 ;;9002226.02101,"1197,68115-0350-90 ",.02)
 ;;68115-0350-90
 ;;9002226.02101,"1197,68115-0368-00 ",.01)
 ;;68115-0368-00
 ;;9002226.02101,"1197,68115-0368-00 ",.02)
 ;;68115-0368-00
 ;;9002226.02101,"1197,68115-0368-30 ",.01)
 ;;68115-0368-30
 ;;9002226.02101,"1197,68115-0368-30 ",.02)
 ;;68115-0368-30
 ;;9002226.02101,"1197,68115-0441-30 ",.01)
 ;;68115-0441-30
 ;;9002226.02101,"1197,68115-0441-30 ",.02)
 ;;68115-0441-30
 ;;9002226.02101,"1197,68115-0606-00 ",.01)
 ;;68115-0606-00
 ;;9002226.02101,"1197,68115-0606-00 ",.02)
 ;;68115-0606-00
 ;;9002226.02101,"1197,68115-0606-15 ",.01)
 ;;68115-0606-15
 ;;9002226.02101,"1197,68115-0606-15 ",.02)
 ;;68115-0606-15
 ;;9002226.02101,"1197,68115-0606-30 ",.01)
 ;;68115-0606-30
 ;;9002226.02101,"1197,68115-0606-30 ",.02)
 ;;68115-0606-30
 ;;9002226.02101,"1197,68115-0612-90 ",.01)
 ;;68115-0612-90
 ;;9002226.02101,"1197,68115-0612-90 ",.02)
 ;;68115-0612-90
 ;;9002226.02101,"1197,68115-0636-00 ",.01)
 ;;68115-0636-00
 ;;9002226.02101,"1197,68115-0636-00 ",.02)
 ;;68115-0636-00
 ;;9002226.02101,"1197,68115-0650-00 ",.01)
 ;;68115-0650-00
 ;;9002226.02101,"1197,68115-0650-00 ",.02)
 ;;68115-0650-00
 ;;9002226.02101,"1197,68115-0673-00 ",.01)
 ;;68115-0673-00
 ;;9002226.02101,"1197,68115-0673-00 ",.02)
 ;;68115-0673-00
 ;;9002226.02101,"1197,68115-0673-30 ",.01)
 ;;68115-0673-30
 ;;9002226.02101,"1197,68115-0673-30 ",.02)
 ;;68115-0673-30
 ;;9002226.02101,"1197,68115-0778-00 ",.01)
 ;;68115-0778-00
 ;;9002226.02101,"1197,68115-0778-00 ",.02)
 ;;68115-0778-00
 ;;9002226.02101,"1197,68115-0790-00 ",.01)
 ;;68115-0790-00
 ;;9002226.02101,"1197,68115-0790-00 ",.02)
 ;;68115-0790-00
 ;;9002226.02101,"1197,68115-0890-15 ",.01)
 ;;68115-0890-15
 ;;9002226.02101,"1197,68115-0890-15 ",.02)
 ;;68115-0890-15
 ;;9002226.02101,"1197,68115-0890-30 ",.01)
 ;;68115-0890-30
 ;;9002226.02101,"1197,68115-0890-30 ",.02)
 ;;68115-0890-30
 ;;9002226.02101,"1197,68115-0890-60 ",.01)
 ;;68115-0890-60
 ;;9002226.02101,"1197,68115-0890-60 ",.02)
 ;;68115-0890-60
 ;;9002226.02101,"1197,68115-0890-90 ",.01)
 ;;68115-0890-90
 ;;9002226.02101,"1197,68115-0890-90 ",.02)
 ;;68115-0890-90
 ;;9002226.02101,"1197,68180-0750-09 ",.01)
 ;;68180-0750-09
 ;;9002226.02101,"1197,68180-0750-09 ",.02)
 ;;68180-0750-09
 ;;9002226.02101,"1197,68180-0751-03 ",.01)
 ;;68180-0751-03
 ;;9002226.02101,"1197,68180-0751-03 ",.02)
 ;;68180-0751-03
 ;;9002226.02101,"1197,68180-0751-09 ",.01)
 ;;68180-0751-09
 ;;9002226.02101,"1197,68180-0751-09 ",.02)
 ;;68180-0751-09
 ;;9002226.02101,"1197,68180-0752-03 ",.01)
 ;;68180-0752-03
 ;;9002226.02101,"1197,68180-0752-03 ",.02)
 ;;68180-0752-03
 ;;9002226.02101,"1197,68180-0752-09 ",.01)
 ;;68180-0752-09
 ;;9002226.02101,"1197,68180-0752-09 ",.02)
 ;;68180-0752-09
 ;;9002226.02101,"1197,68180-0755-01 ",.01)
 ;;68180-0755-01
 ;;9002226.02101,"1197,68180-0755-01 ",.02)
 ;;68180-0755-01
 ;;9002226.02101,"1197,68180-0756-01 ",.01)
 ;;68180-0756-01
 ;;9002226.02101,"1197,68180-0756-01 ",.02)
 ;;68180-0756-01
 ;;9002226.02101,"1197,68180-0756-02 ",.01)
 ;;68180-0756-02
 ;;9002226.02101,"1197,68180-0756-02 ",.02)
 ;;68180-0756-02
 ;;9002226.02101,"1197,68180-0757-01 ",.01)
 ;;68180-0757-01
 ;;9002226.02101,"1197,68180-0757-01 ",.02)
 ;;68180-0757-01
 ;;9002226.02101,"1197,68180-0757-02 ",.01)
 ;;68180-0757-02
 ;;9002226.02101,"1197,68180-0757-02 ",.02)
 ;;68180-0757-02
 ;;9002226.02101,"1197,68180-0758-01 ",.01)
 ;;68180-0758-01
 ;;9002226.02101,"1197,68180-0758-01 ",.02)
 ;;68180-0758-01
 ;;9002226.02101,"1197,68180-0758-02 ",.01)
 ;;68180-0758-02
 ;;9002226.02101,"1197,68180-0758-02 ",.02)
 ;;68180-0758-02
 ;;9002226.02101,"1197,68180-0759-01 ",.01)
 ;;68180-0759-01
 ;;9002226.02101,"1197,68180-0759-01 ",.02)
 ;;68180-0759-01
 ;;9002226.02101,"1197,68180-0760-01 ",.01)
 ;;68180-0760-01
 ;;9002226.02101,"1197,68180-0760-01 ",.02)
 ;;68180-0760-01
 ;;9002226.02101,"1197,68258-1019-01 ",.01)
 ;;68258-1019-01
 ;;9002226.02101,"1197,68258-1019-01 ",.02)
 ;;68258-1019-01
 ;;9002226.02101,"1197,68258-1020-01 ",.01)
 ;;68258-1020-01
 ;;9002226.02101,"1197,68258-1020-01 ",.02)
 ;;68258-1020-01
 ;;9002226.02101,"1197,68258-1021-01 ",.01)
 ;;68258-1021-01
 ;;9002226.02101,"1197,68258-1021-01 ",.02)
 ;;68258-1021-01
 ;;9002226.02101,"1197,68258-6014-03 ",.01)
 ;;68258-6014-03
 ;;9002226.02101,"1197,68258-6014-03 ",.02)
 ;;68258-6014-03
 ;;9002226.02101,"1197,68258-6024-03 ",.01)
 ;;68258-6024-03
 ;;9002226.02101,"1197,68258-6024-03 ",.02)
 ;;68258-6024-03
 ;;9002226.02101,"1197,68258-6025-03 ",.01)
 ;;68258-6025-03
 ;;9002226.02101,"1197,68258-6025-03 ",.02)
 ;;68258-6025-03
 ;;9002226.02101,"1197,68258-6025-09 ",.01)
 ;;68258-6025-09
 ;;9002226.02101,"1197,68258-6025-09 ",.02)
 ;;68258-6025-09
 ;;9002226.02101,"1197,68258-6046-03 ",.01)
 ;;68258-6046-03
 ;;9002226.02101,"1197,68258-6046-03 ",.02)
 ;;68258-6046-03
 ;;9002226.02101,"1197,68258-9113-01 ",.01)
 ;;68258-9113-01
 ;;9002226.02101,"1197,68258-9113-01 ",.02)
 ;;68258-9113-01
 ;;9002226.02101,"1197,68382-0121-01 ",.01)
 ;;68382-0121-01
 ;;9002226.02101,"1197,68382-0121-01 ",.02)
 ;;68382-0121-01
 ;;9002226.02101,"1197,68382-0121-05 ",.01)
 ;;68382-0121-05
 ;;9002226.02101,"1197,68382-0121-05 ",.02)
 ;;68382-0121-05
 ;;9002226.02101,"1197,68382-0121-16 ",.01)
 ;;68382-0121-16
 ;;9002226.02101,"1197,68382-0121-16 ",.02)
 ;;68382-0121-16
 ;;9002226.02101,"1197,68382-0122-01 ",.01)
 ;;68382-0122-01
 ;;9002226.02101,"1197,68382-0122-01 ",.02)
 ;;68382-0122-01
 ;;9002226.02101,"1197,68382-0122-05 ",.01)
 ;;68382-0122-05
 ;;9002226.02101,"1197,68382-0122-05 ",.02)
 ;;68382-0122-05
 ;;9002226.02101,"1197,68382-0122-16 ",.01)
 ;;68382-0122-16
 ;;9002226.02101,"1197,68382-0122-16 ",.02)
 ;;68382-0122-16
 ;;9002226.02101,"1197,68382-0123-01 ",.01)
 ;;68382-0123-01
 ;;9002226.02101,"1197,68382-0123-01 ",.02)
 ;;68382-0123-01
 ;;9002226.02101,"1197,68382-0123-05 ",.01)
 ;;68382-0123-05
 ;;9002226.02101,"1197,68382-0123-05 ",.02)
 ;;68382-0123-05
 ;;9002226.02101,"1197,68382-0123-16 ",.01)
 ;;68382-0123-16
 ;;9002226.02101,"1197,68382-0123-16 ",.02)
 ;;68382-0123-16
 ;;9002226.02101,"1197,68462-0210-10 ",.01)
 ;;68462-0210-10
 ;;9002226.02101,"1197,68462-0210-10 ",.02)
 ;;68462-0210-10
 ;;9002226.02101,"1197,68462-0211-10 ",.01)
 ;;68462-0211-10
 ;;9002226.02101,"1197,68462-0211-10 ",.02)
 ;;68462-0211-10
 ;;9002226.02101,"1197,68462-0212-10 ",.01)
 ;;68462-0212-10
 ;;9002226.02101,"1197,68462-0212-10 ",.02)
 ;;68462-0212-10
 ;;9002226.02101,"1197,68462-0233-01 ",.01)
 ;;68462-0233-01
 ;;9002226.02101,"1197,68462-0233-01 ",.02)
 ;;68462-0233-01
 ;;9002226.02101,"1197,68462-0234-01 ",.01)
 ;;68462-0234-01
 ;;9002226.02101,"1197,68462-0234-01 ",.02)
 ;;68462-0234-01
 ;;9002226.02101,"1197,68462-0235-01 ",.01)
 ;;68462-0235-01
 ;;9002226.02101,"1197,68462-0235-01 ",.02)
 ;;68462-0235-01
 ;;9002226.02101,"1197,68462-0260-01 ",.01)
 ;;68462-0260-01
 ;;9002226.02101,"1197,68462-0260-01 ",.02)
 ;;68462-0260-01
 ;;9002226.02101,"1197,68462-0260-05 ",.01)
 ;;68462-0260-05
 ;;9002226.02101,"1197,68462-0260-05 ",.02)
 ;;68462-0260-05
 ;;9002226.02101,"1197,68462-0292-01 ",.01)
 ;;68462-0292-01
 ;;9002226.02101,"1197,68462-0292-01 ",.02)
 ;;68462-0292-01
 ;;9002226.02101,"1197,68462-0293-01 ",.01)
 ;;68462-0293-01
 ;;9002226.02101,"1197,68462-0293-01 ",.02)
 ;;68462-0293-01
 ;;9002226.02101,"1197,68462-0293-05 ",.01)
 ;;68462-0293-05
 ;;9002226.02101,"1197,68462-0293-05 ",.02)
 ;;68462-0293-05
 ;;9002226.02101,"1197,68462-0294-01 ",.01)
 ;;68462-0294-01
 ;;9002226.02101,"1197,68462-0294-01 ",.02)
 ;;68462-0294-01
 ;;9002226.02101,"1197,68462-0295-01 ",.01)
 ;;68462-0295-01
 ;;9002226.02101,"1197,68462-0295-01 ",.02)
 ;;68462-0295-01
 ;;9002226.02101,"1197,68462-0296-01 ",.01)
 ;;68462-0296-01
 ;;9002226.02101,"1197,68462-0296-01 ",.02)
 ;;68462-0296-01
 ;;9002226.02101,"1197,68462-0329-01 ",.01)
 ;;68462-0329-01
 ;;9002226.02101,"1197,68462-0329-01 ",.02)
 ;;68462-0329-01
 ;;9002226.02101,"1197,76282-0237-05 ",.01)
 ;;76282-0237-05
 ;;9002226.02101,"1197,76282-0237-05 ",.02)
 ;;76282-0237-05
 ;;9002226.02101,"1197,76282-0237-10 ",.01)
 ;;76282-0237-10
 ;;9002226.02101,"1197,76282-0237-10 ",.02)
 ;;76282-0237-10
 ;;9002226.02101,"1197,76282-0237-90 ",.01)
 ;;76282-0237-90
 ;;9002226.02101,"1197,76282-0237-90 ",.02)
 ;;76282-0237-90
 ;;9002226.02101,"1197,76282-0238-05 ",.01)
 ;;76282-0238-05
 ;;9002226.02101,"1197,76282-0238-05 ",.02)
 ;;76282-0238-05
 ;;9002226.02101,"1197,76282-0238-10 ",.01)
 ;;76282-0238-10
 ;;9002226.02101,"1197,76282-0238-10 ",.02)
 ;;76282-0238-10
 ;;9002226.02101,"1197,76282-0238-90 ",.01)
 ;;76282-0238-90
 ;;9002226.02101,"1197,76282-0238-90 ",.02)
 ;;76282-0238-90
 ;;9002226.02101,"1197,76282-0239-05 ",.01)
 ;;76282-0239-05
 ;;9002226.02101,"1197,76282-0239-05 ",.02)
 ;;76282-0239-05
 ;;9002226.02101,"1197,76282-0239-10 ",.01)
 ;;76282-0239-10
 ;;9002226.02101,"1197,76282-0239-10 ",.02)
 ;;76282-0239-10
 ;;9002226.02101,"1197,76282-0239-90 ",.01)
 ;;76282-0239-90
 ;;9002226.02101,"1197,76282-0239-90 ",.02)
 ;;76282-0239-90