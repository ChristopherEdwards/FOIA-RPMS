BGP22B25 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1196,33358-0222-00 ",.01)
 ;;33358-0222-00
 ;;9002226.02101,"1196,33358-0222-00 ",.02)
 ;;33358-0222-00
 ;;9002226.02101,"1196,35356-0060-30 ",.01)
 ;;35356-0060-30
 ;;9002226.02101,"1196,35356-0060-30 ",.02)
 ;;35356-0060-30
 ;;9002226.02101,"1196,35356-0101-90 ",.01)
 ;;35356-0101-90
 ;;9002226.02101,"1196,35356-0101-90 ",.02)
 ;;35356-0101-90
 ;;9002226.02101,"1196,35356-0131-30 ",.01)
 ;;35356-0131-30
 ;;9002226.02101,"1196,35356-0131-30 ",.02)
 ;;35356-0131-30
 ;;9002226.02101,"1196,35356-0216-30 ",.01)
 ;;35356-0216-30
 ;;9002226.02101,"1196,35356-0216-30 ",.02)
 ;;35356-0216-30
 ;;9002226.02101,"1196,35356-0216-90 ",.01)
 ;;35356-0216-90
 ;;9002226.02101,"1196,35356-0216-90 ",.02)
 ;;35356-0216-90
 ;;9002226.02101,"1196,35356-0256-30 ",.01)
 ;;35356-0256-30
 ;;9002226.02101,"1196,35356-0256-30 ",.02)
 ;;35356-0256-30
 ;;9002226.02101,"1196,35356-0256-90 ",.01)
 ;;35356-0256-90
 ;;9002226.02101,"1196,35356-0256-90 ",.02)
 ;;35356-0256-90
 ;;9002226.02101,"1196,35356-0257-30 ",.01)
 ;;35356-0257-30
 ;;9002226.02101,"1196,35356-0257-30 ",.02)
 ;;35356-0257-30
 ;;9002226.02101,"1196,35356-0257-90 ",.01)
 ;;35356-0257-90
 ;;9002226.02101,"1196,35356-0257-90 ",.02)
 ;;35356-0257-90
 ;;9002226.02101,"1196,35356-0258-30 ",.01)
 ;;35356-0258-30
 ;;9002226.02101,"1196,35356-0258-30 ",.02)
 ;;35356-0258-30
 ;;9002226.02101,"1196,35356-0258-90 ",.01)
 ;;35356-0258-90
 ;;9002226.02101,"1196,35356-0258-90 ",.02)
 ;;35356-0258-90
 ;;9002226.02101,"1196,35356-0268-30 ",.01)
 ;;35356-0268-30
 ;;9002226.02101,"1196,35356-0268-30 ",.02)
 ;;35356-0268-30
 ;;9002226.02101,"1196,35356-0287-20 ",.01)
 ;;35356-0287-20
 ;;9002226.02101,"1196,35356-0287-20 ",.02)
 ;;35356-0287-20
 ;;9002226.02101,"1196,35356-0287-30 ",.01)
 ;;35356-0287-30
 ;;9002226.02101,"1196,35356-0287-30 ",.02)
 ;;35356-0287-30
 ;;9002226.02101,"1196,35356-0288-40 ",.01)
 ;;35356-0288-40
 ;;9002226.02101,"1196,35356-0288-40 ",.02)
 ;;35356-0288-40
 ;;9002226.02101,"1196,35356-0289-40 ",.01)
 ;;35356-0289-40
 ;;9002226.02101,"1196,35356-0289-40 ",.02)
 ;;35356-0289-40
 ;;9002226.02101,"1196,35356-0293-90 ",.01)
 ;;35356-0293-90
 ;;9002226.02101,"1196,35356-0293-90 ",.02)
 ;;35356-0293-90
 ;;9002226.02101,"1196,35356-0294-90 ",.01)
 ;;35356-0294-90
 ;;9002226.02101,"1196,35356-0294-90 ",.02)
 ;;35356-0294-90
 ;;9002226.02101,"1196,35356-0295-30 ",.01)
 ;;35356-0295-30
 ;;9002226.02101,"1196,35356-0295-30 ",.02)
 ;;35356-0295-30
 ;;9002226.02101,"1196,35356-0296-30 ",.01)
 ;;35356-0296-30
 ;;9002226.02101,"1196,35356-0296-30 ",.02)
 ;;35356-0296-30
 ;;9002226.02101,"1196,35356-0297-30 ",.01)
 ;;35356-0297-30
 ;;9002226.02101,"1196,35356-0297-30 ",.02)
 ;;35356-0297-30
 ;;9002226.02101,"1196,35356-0298-30 ",.01)
 ;;35356-0298-30
 ;;9002226.02101,"1196,35356-0298-30 ",.02)
 ;;35356-0298-30
 ;;9002226.02101,"1196,35356-0299-30 ",.01)
 ;;35356-0299-30
 ;;9002226.02101,"1196,35356-0299-30 ",.02)
 ;;35356-0299-30
 ;;9002226.02101,"1196,35356-0300-30 ",.01)
 ;;35356-0300-30
 ;;9002226.02101,"1196,35356-0300-30 ",.02)
 ;;35356-0300-30
 ;;9002226.02101,"1196,35356-0373-90 ",.01)
 ;;35356-0373-90
 ;;9002226.02101,"1196,35356-0373-90 ",.02)
 ;;35356-0373-90
 ;;9002226.02101,"1196,35356-0374-15 ",.01)
 ;;35356-0374-15
 ;;9002226.02101,"1196,35356-0374-15 ",.02)
 ;;35356-0374-15
 ;;9002226.02101,"1196,35356-0374-30 ",.01)
 ;;35356-0374-30
 ;;9002226.02101,"1196,35356-0374-30 ",.02)
 ;;35356-0374-30
 ;;9002226.02101,"1196,35356-0406-30 ",.01)
 ;;35356-0406-30
 ;;9002226.02101,"1196,35356-0406-30 ",.02)
 ;;35356-0406-30
 ;;9002226.02101,"1196,35356-0407-30 ",.01)
 ;;35356-0407-30
 ;;9002226.02101,"1196,35356-0407-30 ",.02)
 ;;35356-0407-30
 ;;9002226.02101,"1196,35356-0416-10 ",.01)
 ;;35356-0416-10
 ;;9002226.02101,"1196,35356-0416-10 ",.02)
 ;;35356-0416-10
 ;;9002226.02101,"1196,35356-0416-20 ",.01)
 ;;35356-0416-20
 ;;9002226.02101,"1196,35356-0416-20 ",.02)
 ;;35356-0416-20
 ;;9002226.02101,"1196,35356-0416-30 ",.01)
 ;;35356-0416-30
 ;;9002226.02101,"1196,35356-0416-30 ",.02)
 ;;35356-0416-30
 ;;9002226.02101,"1196,35356-0427-30 ",.01)
 ;;35356-0427-30
 ;;9002226.02101,"1196,35356-0427-30 ",.02)
 ;;35356-0427-30
 ;;9002226.02101,"1196,35356-0428-30 ",.01)
 ;;35356-0428-30
 ;;9002226.02101,"1196,35356-0428-30 ",.02)
 ;;35356-0428-30
 ;;9002226.02101,"1196,35356-0432-30 ",.01)
 ;;35356-0432-30
 ;;9002226.02101,"1196,35356-0432-30 ",.02)
 ;;35356-0432-30
 ;;9002226.02101,"1196,35356-0541-30 ",.01)
 ;;35356-0541-30
 ;;9002226.02101,"1196,35356-0541-30 ",.02)
 ;;35356-0541-30
 ;;9002226.02101,"1196,35356-0587-30 ",.01)
 ;;35356-0587-30
 ;;9002226.02101,"1196,35356-0587-30 ",.02)
 ;;35356-0587-30
 ;;9002226.02101,"1196,35356-0587-60 ",.01)
 ;;35356-0587-60
 ;;9002226.02101,"1196,35356-0587-60 ",.02)
 ;;35356-0587-60
 ;;9002226.02101,"1196,35356-0587-90 ",.01)
 ;;35356-0587-90
 ;;9002226.02101,"1196,35356-0587-90 ",.02)
 ;;35356-0587-90
 ;;9002226.02101,"1196,35356-0601-30 ",.01)
 ;;35356-0601-30
 ;;9002226.02101,"1196,35356-0601-30 ",.02)
 ;;35356-0601-30
 ;;9002226.02101,"1196,43063-0007-01 ",.01)
 ;;43063-0007-01
 ;;9002226.02101,"1196,43063-0007-01 ",.02)
 ;;43063-0007-01
 ;;9002226.02101,"1196,43063-0032-01 ",.01)
 ;;43063-0032-01
 ;;9002226.02101,"1196,43063-0032-01 ",.02)
 ;;43063-0032-01
 ;;9002226.02101,"1196,43063-0065-30 ",.01)
 ;;43063-0065-30
 ;;9002226.02101,"1196,43063-0065-30 ",.02)
 ;;43063-0065-30
 ;;9002226.02101,"1196,43063-0065-90 ",.01)
 ;;43063-0065-90
 ;;9002226.02101,"1196,43063-0065-90 ",.02)
 ;;43063-0065-90
 ;;9002226.02101,"1196,43063-0118-30 ",.01)
 ;;43063-0118-30
 ;;9002226.02101,"1196,43063-0118-30 ",.02)
 ;;43063-0118-30
 ;;9002226.02101,"1196,43063-0118-90 ",.01)
 ;;43063-0118-90
 ;;9002226.02101,"1196,43063-0118-90 ",.02)
 ;;43063-0118-90
 ;;9002226.02101,"1196,43063-0130-90 ",.01)
 ;;43063-0130-90
 ;;9002226.02101,"1196,43063-0130-90 ",.02)
 ;;43063-0130-90
 ;;9002226.02101,"1196,43063-0131-30 ",.01)
 ;;43063-0131-30
 ;;9002226.02101,"1196,43063-0131-30 ",.02)
 ;;43063-0131-30
 ;;9002226.02101,"1196,43063-0132-30 ",.01)
 ;;43063-0132-30
 ;;9002226.02101,"1196,43063-0132-30 ",.02)
 ;;43063-0132-30
 ;;9002226.02101,"1196,43063-0138-90 ",.01)
 ;;43063-0138-90
 ;;9002226.02101,"1196,43063-0138-90 ",.02)
 ;;43063-0138-90
 ;;9002226.02101,"1196,43063-0146-30 ",.01)
 ;;43063-0146-30
 ;;9002226.02101,"1196,43063-0146-30 ",.02)
 ;;43063-0146-30
 ;;9002226.02101,"1196,43063-0171-14 ",.01)
 ;;43063-0171-14
 ;;9002226.02101,"1196,43063-0171-14 ",.02)
 ;;43063-0171-14
 ;;9002226.02101,"1196,43063-0232-30 ",.01)
 ;;43063-0232-30
 ;;9002226.02101,"1196,43063-0232-30 ",.02)
 ;;43063-0232-30
 ;;9002226.02101,"1196,43063-0232-60 ",.01)
 ;;43063-0232-60
 ;;9002226.02101,"1196,43063-0232-60 ",.02)
 ;;43063-0232-60
 ;;9002226.02101,"1196,43063-0233-60 ",.01)
 ;;43063-0233-60
 ;;9002226.02101,"1196,43063-0233-60 ",.02)
 ;;43063-0233-60
 ;;9002226.02101,"1196,43063-0234-60 ",.01)
 ;;43063-0234-60
 ;;9002226.02101,"1196,43063-0234-60 ",.02)
 ;;43063-0234-60
 ;;9002226.02101,"1196,43063-0288-30 ",.01)
 ;;43063-0288-30
 ;;9002226.02101,"1196,43063-0288-30 ",.02)
 ;;43063-0288-30
 ;;9002226.02101,"1196,43063-0303-30 ",.01)
 ;;43063-0303-30
 ;;9002226.02101,"1196,43063-0303-30 ",.02)
 ;;43063-0303-30
 ;;9002226.02101,"1196,43353-0045-80 ",.01)
 ;;43353-0045-80
 ;;9002226.02101,"1196,43353-0045-80 ",.02)
 ;;43353-0045-80
 ;;9002226.02101,"1196,43353-0313-15 ",.01)
 ;;43353-0313-15
 ;;9002226.02101,"1196,43353-0313-15 ",.02)
 ;;43353-0313-15
 ;;9002226.02101,"1196,43353-0313-60 ",.01)
 ;;43353-0313-60
 ;;9002226.02101,"1196,43353-0313-60 ",.02)
 ;;43353-0313-60
 ;;9002226.02101,"1196,43353-0318-60 ",.01)
 ;;43353-0318-60
 ;;9002226.02101,"1196,43353-0318-60 ",.02)
 ;;43353-0318-60
 ;;9002226.02101,"1196,43353-0350-30 ",.01)
 ;;43353-0350-30
 ;;9002226.02101,"1196,43353-0350-30 ",.02)
 ;;43353-0350-30
 ;;9002226.02101,"1196,43353-0350-45 ",.01)
 ;;43353-0350-45
 ;;9002226.02101,"1196,43353-0350-45 ",.02)
 ;;43353-0350-45
 ;;9002226.02101,"1196,43353-0350-60 ",.01)
 ;;43353-0350-60
 ;;9002226.02101,"1196,43353-0350-60 ",.02)
 ;;43353-0350-60
 ;;9002226.02101,"1196,43353-0350-80 ",.01)
 ;;43353-0350-80
 ;;9002226.02101,"1196,43353-0350-80 ",.02)
 ;;43353-0350-80
 ;;9002226.02101,"1196,43353-0365-15 ",.01)
 ;;43353-0365-15
 ;;9002226.02101,"1196,43353-0365-15 ",.02)
 ;;43353-0365-15
 ;;9002226.02101,"1196,43353-0365-30 ",.01)
 ;;43353-0365-30
 ;;9002226.02101,"1196,43353-0365-30 ",.02)
 ;;43353-0365-30
 ;;9002226.02101,"1196,43353-0365-45 ",.01)
 ;;43353-0365-45
 ;;9002226.02101,"1196,43353-0365-45 ",.02)
 ;;43353-0365-45
 ;;9002226.02101,"1196,43353-0365-60 ",.01)
 ;;43353-0365-60
 ;;9002226.02101,"1196,43353-0365-60 ",.02)
 ;;43353-0365-60
 ;;9002226.02101,"1196,43353-0371-45 ",.01)
 ;;43353-0371-45
 ;;9002226.02101,"1196,43353-0371-45 ",.02)
 ;;43353-0371-45
 ;;9002226.02101,"1196,43353-0371-60 ",.01)
 ;;43353-0371-60
 ;;9002226.02101,"1196,43353-0371-60 ",.02)
 ;;43353-0371-60
 ;;9002226.02101,"1196,43353-0411-60 ",.01)
 ;;43353-0411-60
 ;;9002226.02101,"1196,43353-0411-60 ",.02)
 ;;43353-0411-60
 ;;9002226.02101,"1196,43353-0459-45 ",.01)
 ;;43353-0459-45
 ;;9002226.02101,"1196,43353-0459-45 ",.02)
 ;;43353-0459-45
 ;;9002226.02101,"1196,43353-0488-45 ",.01)
 ;;43353-0488-45
 ;;9002226.02101,"1196,43353-0488-45 ",.02)
 ;;43353-0488-45
 ;;9002226.02101,"1196,43353-0488-60 ",.01)
 ;;43353-0488-60
 ;;9002226.02101,"1196,43353-0488-60 ",.02)
 ;;43353-0488-60
 ;;9002226.02101,"1196,43353-0516-45 ",.01)
 ;;43353-0516-45
 ;;9002226.02101,"1196,43353-0516-45 ",.02)
 ;;43353-0516-45
 ;;9002226.02101,"1196,43353-0521-60 ",.01)
 ;;43353-0521-60
 ;;9002226.02101,"1196,43353-0521-60 ",.02)
 ;;43353-0521-60
 ;;9002226.02101,"1196,43353-0521-80 ",.01)
 ;;43353-0521-80
 ;;9002226.02101,"1196,43353-0521-80 ",.02)
 ;;43353-0521-80
 ;;9002226.02101,"1196,43353-0596-30 ",.01)
 ;;43353-0596-30
 ;;9002226.02101,"1196,43353-0596-30 ",.02)
 ;;43353-0596-30
 ;;9002226.02101,"1196,43353-0596-60 ",.01)
 ;;43353-0596-60
 ;;9002226.02101,"1196,43353-0596-60 ",.02)
 ;;43353-0596-60
 ;;9002226.02101,"1196,43353-0626-60 ",.01)
 ;;43353-0626-60
 ;;9002226.02101,"1196,43353-0626-60 ",.02)
 ;;43353-0626-60
 ;;9002226.02101,"1196,43353-0643-60 ",.01)
 ;;43353-0643-60
 ;;9002226.02101,"1196,43353-0643-60 ",.02)
 ;;43353-0643-60
 ;;9002226.02101,"1196,43353-0655-60 ",.01)
 ;;43353-0655-60
 ;;9002226.02101,"1196,43353-0655-60 ",.02)
 ;;43353-0655-60
 ;;9002226.02101,"1196,43353-0662-80 ",.01)
 ;;43353-0662-80
 ;;9002226.02101,"1196,43353-0662-80 ",.02)
 ;;43353-0662-80
 ;;9002226.02101,"1196,43353-0667-60 ",.01)
 ;;43353-0667-60
 ;;9002226.02101,"1196,43353-0667-60 ",.02)
 ;;43353-0667-60
 ;;9002226.02101,"1196,43353-0668-45 ",.01)
 ;;43353-0668-45
 ;;9002226.02101,"1196,43353-0668-45 ",.02)
 ;;43353-0668-45
 ;;9002226.02101,"1196,43353-0668-60 ",.01)
 ;;43353-0668-60
 ;;9002226.02101,"1196,43353-0668-60 ",.02)
 ;;43353-0668-60
 ;;9002226.02101,"1196,43353-0671-30 ",.01)
 ;;43353-0671-30
 ;;9002226.02101,"1196,43353-0671-30 ",.02)
 ;;43353-0671-30
 ;;9002226.02101,"1196,43353-0671-45 ",.01)
 ;;43353-0671-45
 ;;9002226.02101,"1196,43353-0671-45 ",.02)
 ;;43353-0671-45
 ;;9002226.02101,"1196,43353-0676-60 ",.01)
 ;;43353-0676-60
 ;;9002226.02101,"1196,43353-0676-60 ",.02)
 ;;43353-0676-60
 ;;9002226.02101,"1196,43353-0712-60 ",.01)
 ;;43353-0712-60
 ;;9002226.02101,"1196,43353-0712-60 ",.02)
 ;;43353-0712-60
 ;;9002226.02101,"1196,43683-0147-30 ",.01)
 ;;43683-0147-30
 ;;9002226.02101,"1196,43683-0147-30 ",.02)
 ;;43683-0147-30
 ;;9002226.02101,"1196,43683-0148-30 ",.01)
 ;;43683-0148-30
 ;;9002226.02101,"1196,43683-0148-30 ",.02)
 ;;43683-0148-30
 ;;9002226.02101,"1196,47463-0020-30 ",.01)
 ;;47463-0020-30
 ;;9002226.02101,"1196,47463-0020-30 ",.02)
 ;;47463-0020-30
 ;;9002226.02101,"1196,47463-0021-30 ",.01)
 ;;47463-0021-30
 ;;9002226.02101,"1196,47463-0021-30 ",.02)
 ;;47463-0021-30
 ;;9002226.02101,"1196,47463-0022-30 ",.01)
 ;;47463-0022-30
 ;;9002226.02101,"1196,47463-0022-30 ",.02)
 ;;47463-0022-30
 ;;9002226.02101,"1196,47463-0023-30 ",.01)
 ;;47463-0023-30
 ;;9002226.02101,"1196,47463-0023-30 ",.02)
 ;;47463-0023-30
 ;;9002226.02101,"1196,47463-0024-30 ",.01)
 ;;47463-0024-30
 ;;9002226.02101,"1196,47463-0024-30 ",.02)
 ;;47463-0024-30
 ;;9002226.02101,"1196,47463-0039-30 ",.01)
 ;;47463-0039-30
 ;;9002226.02101,"1196,47463-0039-30 ",.02)
 ;;47463-0039-30
 ;;9002226.02101,"1196,47463-0040-30 ",.01)
 ;;47463-0040-30
 ;;9002226.02101,"1196,47463-0040-30 ",.02)
 ;;47463-0040-30
 ;;9002226.02101,"1196,47463-0043-30 ",.01)
 ;;47463-0043-30
 ;;9002226.02101,"1196,47463-0043-30 ",.02)
 ;;47463-0043-30
 ;;9002226.02101,"1196,47463-0220-30 ",.01)
 ;;47463-0220-30
 ;;9002226.02101,"1196,47463-0220-30 ",.02)
 ;;47463-0220-30
 ;;9002226.02101,"1196,47463-0221-30 ",.01)
 ;;47463-0221-30
 ;;9002226.02101,"1196,47463-0221-30 ",.02)
 ;;47463-0221-30
 ;;9002226.02101,"1196,47463-0222-30 ",.01)
 ;;47463-0222-30
 ;;9002226.02101,"1196,47463-0222-30 ",.02)
 ;;47463-0222-30
 ;;9002226.02101,"1196,47463-0223-30 ",.01)
 ;;47463-0223-30
 ;;9002226.02101,"1196,47463-0223-30 ",.02)
 ;;47463-0223-30
 ;;9002226.02101,"1196,47463-0250-30 ",.01)
 ;;47463-0250-30
 ;;9002226.02101,"1196,47463-0250-30 ",.02)
 ;;47463-0250-30
 ;;9002226.02101,"1196,47463-0251-30 ",.01)
 ;;47463-0251-30
 ;;9002226.02101,"1196,47463-0251-30 ",.02)
 ;;47463-0251-30
 ;;9002226.02101,"1196,47463-0252-30 ",.01)
 ;;47463-0252-30