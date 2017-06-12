BGP62Y40 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 11, 2016;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"868,16590-0424-20 ",.02)
 ;;16590-0424-20
 ;;9002226.02101,"868,16590-0424-30 ",.01)
 ;;16590-0424-30
 ;;9002226.02101,"868,16590-0424-30 ",.02)
 ;;16590-0424-30
 ;;9002226.02101,"868,16590-0424-40 ",.01)
 ;;16590-0424-40
 ;;9002226.02101,"868,16590-0424-40 ",.02)
 ;;16590-0424-40
 ;;9002226.02101,"868,16590-0735-14 ",.01)
 ;;16590-0735-14
 ;;9002226.02101,"868,16590-0735-14 ",.02)
 ;;16590-0735-14
 ;;9002226.02101,"868,16590-0735-20 ",.01)
 ;;16590-0735-20
 ;;9002226.02101,"868,16590-0735-20 ",.02)
 ;;16590-0735-20
 ;;9002226.02101,"868,16590-0735-28 ",.01)
 ;;16590-0735-28
 ;;9002226.02101,"868,16590-0735-28 ",.02)
 ;;16590-0735-28
 ;;9002226.02101,"868,16714-0202-01 ",.01)
 ;;16714-0202-01
 ;;9002226.02101,"868,16714-0202-01 ",.02)
 ;;16714-0202-01
 ;;9002226.02101,"868,16714-0203-01 ",.01)
 ;;16714-0203-01
 ;;9002226.02101,"868,16714-0203-01 ",.02)
 ;;16714-0203-01
 ;;9002226.02101,"868,16714-0203-02 ",.01)
 ;;16714-0203-02
 ;;9002226.02101,"868,16714-0203-02 ",.02)
 ;;16714-0203-02
 ;;9002226.02101,"868,16714-0204-02 ",.01)
 ;;16714-0204-02
 ;;9002226.02101,"868,16714-0204-02 ",.02)
 ;;16714-0204-02
 ;;9002226.02101,"868,16714-0204-03 ",.01)
 ;;16714-0204-03
 ;;9002226.02101,"868,16714-0204-03 ",.02)
 ;;16714-0204-03
 ;;9002226.02101,"868,16714-0205-01 ",.01)
 ;;16714-0205-01
 ;;9002226.02101,"868,16714-0205-01 ",.02)
 ;;16714-0205-01
 ;;9002226.02101,"868,16714-0205-02 ",.01)
 ;;16714-0205-02
 ;;9002226.02101,"868,16714-0205-02 ",.02)
 ;;16714-0205-02
 ;;9002226.02101,"868,16714-0205-04 ",.01)
 ;;16714-0205-04
 ;;9002226.02101,"868,16714-0205-04 ",.02)
 ;;16714-0205-04
 ;;9002226.02101,"868,16714-0206-01 ",.01)
 ;;16714-0206-01
 ;;9002226.02101,"868,16714-0206-01 ",.02)
 ;;16714-0206-01
 ;;9002226.02101,"868,16714-0206-02 ",.01)
 ;;16714-0206-02
 ;;9002226.02101,"868,16714-0206-02 ",.02)
 ;;16714-0206-02
 ;;9002226.02101,"868,16714-0207-01 ",.01)
 ;;16714-0207-01
 ;;9002226.02101,"868,16714-0207-01 ",.02)
 ;;16714-0207-01
 ;;9002226.02101,"868,16714-0207-02 ",.01)
 ;;16714-0207-02
 ;;9002226.02101,"868,16714-0207-02 ",.02)
 ;;16714-0207-02
 ;;9002226.02101,"868,16714-0208-01 ",.01)
 ;;16714-0208-01
 ;;9002226.02101,"868,16714-0208-01 ",.02)
 ;;16714-0208-01
 ;;9002226.02101,"868,16714-0209-01 ",.01)
 ;;16714-0209-01
 ;;9002226.02101,"868,16714-0209-01 ",.02)
 ;;16714-0209-01
 ;;9002226.02101,"868,16714-0212-01 ",.01)
 ;;16714-0212-01
 ;;9002226.02101,"868,16714-0212-01 ",.02)
 ;;16714-0212-01
 ;;9002226.02101,"868,16714-0215-01 ",.01)
 ;;16714-0215-01
 ;;9002226.02101,"868,16714-0215-01 ",.02)
 ;;16714-0215-01
 ;;9002226.02101,"868,16714-0215-02 ",.01)
 ;;16714-0215-02
 ;;9002226.02101,"868,16714-0215-02 ",.02)
 ;;16714-0215-02
 ;;9002226.02101,"868,16714-0215-03 ",.01)
 ;;16714-0215-03
 ;;9002226.02101,"868,16714-0215-03 ",.02)
 ;;16714-0215-03
 ;;9002226.02101,"868,16714-0216-01 ",.01)
 ;;16714-0216-01
 ;;9002226.02101,"868,16714-0216-01 ",.02)
 ;;16714-0216-01
 ;;9002226.02101,"868,16714-0216-02 ",.01)
 ;;16714-0216-02
 ;;9002226.02101,"868,16714-0216-02 ",.02)
 ;;16714-0216-02
 ;;9002226.02101,"868,16714-0216-03 ",.01)
 ;;16714-0216-03
 ;;9002226.02101,"868,16714-0216-03 ",.02)
 ;;16714-0216-03
 ;;9002226.02101,"868,16714-0232-01 ",.01)
 ;;16714-0232-01
 ;;9002226.02101,"868,16714-0232-01 ",.02)
 ;;16714-0232-01
 ;;9002226.02101,"868,16714-0232-02 ",.01)
 ;;16714-0232-02
 ;;9002226.02101,"868,16714-0232-02 ",.02)
 ;;16714-0232-02
 ;;9002226.02101,"868,16714-0233-01 ",.01)
 ;;16714-0233-01
 ;;9002226.02101,"868,16714-0233-01 ",.02)
 ;;16714-0233-01
 ;;9002226.02101,"868,16714-0233-02 ",.01)
 ;;16714-0233-02
 ;;9002226.02101,"868,16714-0233-02 ",.02)
 ;;16714-0233-02
 ;;9002226.02101,"868,16714-0234-01 ",.01)
 ;;16714-0234-01
 ;;9002226.02101,"868,16714-0234-01 ",.02)
 ;;16714-0234-01
 ;;9002226.02101,"868,16714-0234-02 ",.01)
 ;;16714-0234-02
 ;;9002226.02101,"868,16714-0234-02 ",.02)
 ;;16714-0234-02
 ;;9002226.02101,"868,16714-0235-01 ",.01)
 ;;16714-0235-01
 ;;9002226.02101,"868,16714-0235-01 ",.02)
 ;;16714-0235-01
 ;;9002226.02101,"868,16714-0235-02 ",.01)
 ;;16714-0235-02
 ;;9002226.02101,"868,16714-0235-02 ",.02)
 ;;16714-0235-02
 ;;9002226.02101,"868,16714-0292-01 ",.01)
 ;;16714-0292-01
 ;;9002226.02101,"868,16714-0292-01 ",.02)
 ;;16714-0292-01
 ;;9002226.02101,"868,16714-0292-02 ",.01)
 ;;16714-0292-02
 ;;9002226.02101,"868,16714-0292-02 ",.02)
 ;;16714-0292-02
 ;;9002226.02101,"868,16714-0292-03 ",.01)
 ;;16714-0292-03
 ;;9002226.02101,"868,16714-0292-03 ",.02)
 ;;16714-0292-03
 ;;9002226.02101,"868,16714-0293-01 ",.01)
 ;;16714-0293-01
 ;;9002226.02101,"868,16714-0293-01 ",.02)
 ;;16714-0293-01
 ;;9002226.02101,"868,16714-0293-02 ",.01)
 ;;16714-0293-02
 ;;9002226.02101,"868,16714-0293-02 ",.02)
 ;;16714-0293-02
 ;;9002226.02101,"868,16714-0293-03 ",.01)
 ;;16714-0293-03
 ;;9002226.02101,"868,16714-0293-03 ",.02)
 ;;16714-0293-03
 ;;9002226.02101,"868,16714-0294-01 ",.01)
 ;;16714-0294-01
 ;;9002226.02101,"868,16714-0294-01 ",.02)
 ;;16714-0294-01
 ;;9002226.02101,"868,16714-0294-02 ",.01)
 ;;16714-0294-02
 ;;9002226.02101,"868,16714-0294-02 ",.02)
 ;;16714-0294-02
 ;;9002226.02101,"868,16714-0294-03 ",.01)
 ;;16714-0294-03
 ;;9002226.02101,"868,16714-0294-03 ",.02)
 ;;16714-0294-03
 ;;9002226.02101,"868,16714-0295-01 ",.01)
 ;;16714-0295-01
 ;;9002226.02101,"868,16714-0295-01 ",.02)
 ;;16714-0295-01
 ;;9002226.02101,"868,16714-0296-01 ",.01)
 ;;16714-0296-01
 ;;9002226.02101,"868,16714-0296-01 ",.02)
 ;;16714-0296-01
 ;;9002226.02101,"868,16714-0297-01 ",.01)
 ;;16714-0297-01
 ;;9002226.02101,"868,16714-0297-01 ",.02)
 ;;16714-0297-01
 ;;9002226.02101,"868,16714-0297-02 ",.01)
 ;;16714-0297-02
 ;;9002226.02101,"868,16714-0297-02 ",.02)
 ;;16714-0297-02
 ;;9002226.02101,"868,16714-0298-01 ",.01)
 ;;16714-0298-01
 ;;9002226.02101,"868,16714-0298-01 ",.02)
 ;;16714-0298-01
 ;;9002226.02101,"868,16714-0298-02 ",.01)
 ;;16714-0298-02
 ;;9002226.02101,"868,16714-0298-02 ",.02)
 ;;16714-0298-02
 ;;9002226.02101,"868,16714-0299-02 ",.01)
 ;;16714-0299-02
 ;;9002226.02101,"868,16714-0299-02 ",.02)
 ;;16714-0299-02
 ;;9002226.02101,"868,16714-0299-03 ",.01)
 ;;16714-0299-03
 ;;9002226.02101,"868,16714-0299-03 ",.02)
 ;;16714-0299-03
 ;;9002226.02101,"868,16714-0299-04 ",.01)
 ;;16714-0299-04
 ;;9002226.02101,"868,16714-0299-04 ",.02)
 ;;16714-0299-04
 ;;9002226.02101,"868,16714-0386-01 ",.01)
 ;;16714-0386-01
 ;;9002226.02101,"868,16714-0386-01 ",.02)
 ;;16714-0386-01
 ;;9002226.02101,"868,16714-0386-02 ",.01)
 ;;16714-0386-02
 ;;9002226.02101,"868,16714-0386-02 ",.02)
 ;;16714-0386-02
 ;;9002226.02101,"868,16714-0386-03 ",.01)
 ;;16714-0386-03
 ;;9002226.02101,"868,16714-0386-03 ",.02)
 ;;16714-0386-03
 ;;9002226.02101,"868,16714-0387-01 ",.01)
 ;;16714-0387-01
 ;;9002226.02101,"868,16714-0387-01 ",.02)
 ;;16714-0387-01
 ;;9002226.02101,"868,16714-0387-02 ",.01)
 ;;16714-0387-02
 ;;9002226.02101,"868,16714-0387-02 ",.02)
 ;;16714-0387-02
 ;;9002226.02101,"868,16714-0387-03 ",.01)
 ;;16714-0387-03
 ;;9002226.02101,"868,16714-0387-03 ",.02)
 ;;16714-0387-03
 ;;9002226.02101,"868,16714-0388-01 ",.01)
 ;;16714-0388-01
 ;;9002226.02101,"868,16714-0388-01 ",.02)
 ;;16714-0388-01
 ;;9002226.02101,"868,16714-0388-02 ",.01)
 ;;16714-0388-02
 ;;9002226.02101,"868,16714-0388-02 ",.02)
 ;;16714-0388-02
 ;;9002226.02101,"868,16714-0389-01 ",.01)
 ;;16714-0389-01
 ;;9002226.02101,"868,16714-0389-01 ",.02)
 ;;16714-0389-01
 ;;9002226.02101,"868,16714-0390-01 ",.01)
 ;;16714-0390-01
 ;;9002226.02101,"868,16714-0390-01 ",.02)
 ;;16714-0390-01
 ;;9002226.02101,"868,16714-0390-02 ",.01)
 ;;16714-0390-02
 ;;9002226.02101,"868,16714-0390-02 ",.02)
 ;;16714-0390-02
 ;;9002226.02101,"868,16714-0391-01 ",.01)
 ;;16714-0391-01
 ;;9002226.02101,"868,16714-0391-01 ",.02)
 ;;16714-0391-01
 ;;9002226.02101,"868,16714-0391-02 ",.01)
 ;;16714-0391-02
 ;;9002226.02101,"868,16714-0391-02 ",.02)
 ;;16714-0391-02
 ;;9002226.02101,"868,16714-0392-01 ",.01)
 ;;16714-0392-01
 ;;9002226.02101,"868,16714-0392-01 ",.02)
 ;;16714-0392-01
 ;;9002226.02101,"868,16714-0392-02 ",.01)
 ;;16714-0392-02
 ;;9002226.02101,"868,16714-0392-02 ",.02)
 ;;16714-0392-02
 ;;9002226.02101,"868,16714-0393-01 ",.01)
 ;;16714-0393-01
 ;;9002226.02101,"868,16714-0393-01 ",.02)
 ;;16714-0393-01
 ;;9002226.02101,"868,16714-0393-02 ",.01)
 ;;16714-0393-02
 ;;9002226.02101,"868,16714-0393-02 ",.02)
 ;;16714-0393-02
 ;;9002226.02101,"868,16714-0394-01 ",.01)
 ;;16714-0394-01
 ;;9002226.02101,"868,16714-0394-01 ",.02)
 ;;16714-0394-01
 ;;9002226.02101,"868,16714-0395-01 ",.01)
 ;;16714-0395-01
 ;;9002226.02101,"868,16714-0395-01 ",.02)
 ;;16714-0395-01
 ;;9002226.02101,"868,16714-0396-01 ",.01)
 ;;16714-0396-01
 ;;9002226.02101,"868,16714-0396-01 ",.02)
 ;;16714-0396-01
 ;;9002226.02101,"868,16714-0396-02 ",.01)
 ;;16714-0396-02
 ;;9002226.02101,"868,16714-0396-02 ",.02)
 ;;16714-0396-02
 ;;9002226.02101,"868,16714-0396-03 ",.01)
 ;;16714-0396-03
 ;;9002226.02101,"868,16714-0396-03 ",.02)
 ;;16714-0396-03
 ;;9002226.02101,"868,16714-0397-01 ",.01)
 ;;16714-0397-01
 ;;9002226.02101,"868,16714-0397-01 ",.02)
 ;;16714-0397-01
 ;;9002226.02101,"868,16714-0397-02 ",.01)
 ;;16714-0397-02
 ;;9002226.02101,"868,16714-0397-02 ",.02)
 ;;16714-0397-02
 ;;9002226.02101,"868,16714-0397-03 ",.01)
 ;;16714-0397-03
 ;;9002226.02101,"868,16714-0397-03 ",.02)
 ;;16714-0397-03
 ;;9002226.02101,"868,16714-0398-01 ",.01)
 ;;16714-0398-01
 ;;9002226.02101,"868,16714-0398-01 ",.02)
 ;;16714-0398-01
 ;;9002226.02101,"868,16714-0399-01 ",.01)
 ;;16714-0399-01
 ;;9002226.02101,"868,16714-0399-01 ",.02)
 ;;16714-0399-01
 ;;9002226.02101,"868,16714-0400-01 ",.01)
 ;;16714-0400-01
 ;;9002226.02101,"868,16714-0400-01 ",.02)
 ;;16714-0400-01
 ;;9002226.02101,"868,16714-0400-02 ",.01)
 ;;16714-0400-02
 ;;9002226.02101,"868,16714-0400-02 ",.02)
 ;;16714-0400-02
 ;;9002226.02101,"868,16714-0401-01 ",.01)
 ;;16714-0401-01
 ;;9002226.02101,"868,16714-0401-01 ",.02)
 ;;16714-0401-01
 ;;9002226.02101,"868,16714-0401-02 ",.01)
 ;;16714-0401-02
 ;;9002226.02101,"868,16714-0401-02 ",.02)
 ;;16714-0401-02
 ;;9002226.02101,"868,16714-0402-01 ",.01)
 ;;16714-0402-01
 ;;9002226.02101,"868,16714-0402-01 ",.02)
 ;;16714-0402-01
 ;;9002226.02101,"868,16714-0402-02 ",.01)
 ;;16714-0402-02
 ;;9002226.02101,"868,16714-0402-02 ",.02)
 ;;16714-0402-02
 ;;9002226.02101,"868,16714-0403-01 ",.01)
 ;;16714-0403-01
 ;;9002226.02101,"868,16714-0403-01 ",.02)
 ;;16714-0403-01
 ;;9002226.02101,"868,16714-0403-02 ",.01)
 ;;16714-0403-02
 ;;9002226.02101,"868,16714-0403-02 ",.02)
 ;;16714-0403-02
 ;;9002226.02101,"868,16714-0641-02 ",.01)
 ;;16714-0641-02
 ;;9002226.02101,"868,16714-0641-02 ",.02)
 ;;16714-0641-02
 ;;9002226.02101,"868,16714-0641-03 ",.01)
 ;;16714-0641-03
 ;;9002226.02101,"868,16714-0641-03 ",.02)
 ;;16714-0641-03
 ;;9002226.02101,"868,16714-0642-02 ",.01)
 ;;16714-0642-02
 ;;9002226.02101,"868,16714-0642-02 ",.02)
 ;;16714-0642-02
 ;;9002226.02101,"868,16714-0642-03 ",.01)
 ;;16714-0642-03
 ;;9002226.02101,"868,16714-0642-03 ",.02)
 ;;16714-0642-03
 ;;9002226.02101,"868,16714-0651-02 ",.01)
 ;;16714-0651-02
 ;;9002226.02101,"868,16714-0651-02 ",.02)
 ;;16714-0651-02
 ;;9002226.02101,"868,16714-0652-02 ",.01)
 ;;16714-0652-02
 ;;9002226.02101,"868,16714-0652-02 ",.02)
 ;;16714-0652-02
 ;;9002226.02101,"868,16714-0652-04 ",.01)
 ;;16714-0652-04
 ;;9002226.02101,"868,16714-0652-04 ",.02)
 ;;16714-0652-04
 ;;9002226.02101,"868,16714-0653-01 ",.01)
 ;;16714-0653-01
 ;;9002226.02101,"868,16714-0653-01 ",.02)
 ;;16714-0653-01
 ;;9002226.02101,"868,16781-0400-60 ",.01)
 ;;16781-0400-60