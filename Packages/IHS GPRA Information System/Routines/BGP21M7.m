BGP21M7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1202,13411-0191-06 ",.01)
 ;;13411-0191-06
 ;;9002226.02101,"1202,13411-0191-06 ",.02)
 ;;13411-0191-06
 ;;9002226.02101,"1202,13411-0191-09 ",.01)
 ;;13411-0191-09
 ;;9002226.02101,"1202,13411-0191-09 ",.02)
 ;;13411-0191-09
 ;;9002226.02101,"1202,13411-0191-10 ",.01)
 ;;13411-0191-10
 ;;9002226.02101,"1202,13411-0191-10 ",.02)
 ;;13411-0191-10
 ;;9002226.02101,"1202,13411-0192-02 ",.01)
 ;;13411-0192-02
 ;;9002226.02101,"1202,13411-0192-02 ",.02)
 ;;13411-0192-02
 ;;9002226.02101,"1202,13411-0192-03 ",.01)
 ;;13411-0192-03
 ;;9002226.02101,"1202,13411-0192-03 ",.02)
 ;;13411-0192-03
 ;;9002226.02101,"1202,13411-0192-06 ",.01)
 ;;13411-0192-06
 ;;9002226.02101,"1202,13411-0192-06 ",.02)
 ;;13411-0192-06
 ;;9002226.02101,"1202,13411-0192-09 ",.01)
 ;;13411-0192-09
 ;;9002226.02101,"1202,13411-0192-09 ",.02)
 ;;13411-0192-09
 ;;9002226.02101,"1202,13411-0192-10 ",.01)
 ;;13411-0192-10
 ;;9002226.02101,"1202,13411-0192-10 ",.02)
 ;;13411-0192-10
 ;;9002226.02101,"1202,13411-0193-02 ",.01)
 ;;13411-0193-02
 ;;9002226.02101,"1202,13411-0193-02 ",.02)
 ;;13411-0193-02
 ;;9002226.02101,"1202,13411-0193-03 ",.01)
 ;;13411-0193-03
 ;;9002226.02101,"1202,13411-0193-03 ",.02)
 ;;13411-0193-03
 ;;9002226.02101,"1202,13411-0193-06 ",.01)
 ;;13411-0193-06
 ;;9002226.02101,"1202,13411-0193-06 ",.02)
 ;;13411-0193-06
 ;;9002226.02101,"1202,13411-0193-09 ",.01)
 ;;13411-0193-09
 ;;9002226.02101,"1202,13411-0193-09 ",.02)
 ;;13411-0193-09
 ;;9002226.02101,"1202,13411-0193-10 ",.01)
 ;;13411-0193-10
 ;;9002226.02101,"1202,13411-0193-10 ",.02)
 ;;13411-0193-10
 ;;9002226.02101,"1202,15584-0101-01 ",.01)
 ;;15584-0101-01
 ;;9002226.02101,"1202,15584-0101-01 ",.02)
 ;;15584-0101-01
 ;;9002226.02101,"1202,16590-0061-06 ",.01)
 ;;16590-0061-06
 ;;9002226.02101,"1202,16590-0061-06 ",.02)
 ;;16590-0061-06
 ;;9002226.02101,"1202,16590-0061-10 ",.01)
 ;;16590-0061-10
 ;;9002226.02101,"1202,16590-0061-10 ",.02)
 ;;16590-0061-10
 ;;9002226.02101,"1202,16590-0061-20 ",.01)
 ;;16590-0061-20
 ;;9002226.02101,"1202,16590-0061-20 ",.02)
 ;;16590-0061-20
 ;;9002226.02101,"1202,16590-0061-30 ",.01)
 ;;16590-0061-30
 ;;9002226.02101,"1202,16590-0061-30 ",.02)
 ;;16590-0061-30
 ;;9002226.02101,"1202,16590-0064-18 ",.01)
 ;;16590-0064-18
 ;;9002226.02101,"1202,16590-0064-18 ",.02)
 ;;16590-0064-18
 ;;9002226.02101,"1202,16590-0064-30 ",.01)
 ;;16590-0064-30
 ;;9002226.02101,"1202,16590-0064-30 ",.02)
 ;;16590-0064-30
 ;;9002226.02101,"1202,16590-0064-60 ",.01)
 ;;16590-0064-60
 ;;9002226.02101,"1202,16590-0064-60 ",.02)
 ;;16590-0064-60
 ;;9002226.02101,"1202,16590-0064-90 ",.01)
 ;;16590-0064-90
 ;;9002226.02101,"1202,16590-0064-90 ",.02)
 ;;16590-0064-90
 ;;9002226.02101,"1202,21695-0362-12 ",.01)
 ;;21695-0362-12
 ;;9002226.02101,"1202,21695-0362-12 ",.02)
 ;;21695-0362-12
 ;;9002226.02101,"1202,21695-0366-18 ",.01)
 ;;21695-0366-18
 ;;9002226.02101,"1202,21695-0366-18 ",.02)
 ;;21695-0366-18
 ;;9002226.02101,"1202,21695-0367-06 ",.01)
 ;;21695-0367-06
 ;;9002226.02101,"1202,21695-0367-06 ",.02)
 ;;21695-0367-06
 ;;9002226.02101,"1202,21695-0369-18 ",.01)
 ;;21695-0369-18
 ;;9002226.02101,"1202,21695-0369-18 ",.02)
 ;;21695-0369-18
 ;;9002226.02101,"1202,21695-0846-06 ",.01)
 ;;21695-0846-06
 ;;9002226.02101,"1202,21695-0846-06 ",.02)
 ;;21695-0846-06
 ;;9002226.02101,"1202,23490-7087-06 ",.01)
 ;;23490-7087-06
 ;;9002226.02101,"1202,23490-7087-06 ",.02)
 ;;23490-7087-06
 ;;9002226.02101,"1202,31722-0509-60 ",.01)
 ;;31722-0509-60
 ;;9002226.02101,"1202,31722-0509-60 ",.02)
 ;;31722-0509-60
 ;;9002226.02101,"1202,31722-0515-60 ",.01)
 ;;31722-0515-60
 ;;9002226.02101,"1202,31722-0515-60 ",.02)
 ;;31722-0515-60
 ;;9002226.02101,"1202,31722-0516-60 ",.01)
 ;;31722-0516-60
 ;;9002226.02101,"1202,31722-0516-60 ",.02)
 ;;31722-0516-60
 ;;9002226.02101,"1202,31722-0517-60 ",.01)
 ;;31722-0517-60
 ;;9002226.02101,"1202,31722-0517-60 ",.02)
 ;;31722-0517-60
 ;;9002226.02101,"1202,31722-0518-60 ",.01)
 ;;31722-0518-60
 ;;9002226.02101,"1202,31722-0518-60 ",.02)
 ;;31722-0518-60
 ;;9002226.02101,"1202,35356-0064-06 ",.01)
 ;;35356-0064-06
 ;;9002226.02101,"1202,35356-0064-06 ",.02)
 ;;35356-0064-06
 ;;9002226.02101,"1202,35356-0064-30 ",.01)
 ;;35356-0064-30
 ;;9002226.02101,"1202,35356-0064-30 ",.02)
 ;;35356-0064-30
 ;;9002226.02101,"1202,35356-0065-30 ",.01)
 ;;35356-0065-30
 ;;9002226.02101,"1202,35356-0065-30 ",.02)
 ;;35356-0065-30
 ;;9002226.02101,"1202,35356-0066-24 ",.01)
 ;;35356-0066-24
 ;;9002226.02101,"1202,35356-0066-24 ",.02)
 ;;35356-0066-24
 ;;9002226.02101,"1202,35356-0067-06 ",.01)
 ;;35356-0067-06
 ;;9002226.02101,"1202,35356-0067-06 ",.02)
 ;;35356-0067-06
 ;;9002226.02101,"1202,35356-0067-60 ",.01)
 ;;35356-0067-60
 ;;9002226.02101,"1202,35356-0067-60 ",.02)
 ;;35356-0067-60
 ;;9002226.02101,"1202,35356-0068-06 ",.01)
 ;;35356-0068-06
 ;;9002226.02101,"1202,35356-0068-06 ",.02)
 ;;35356-0068-06
 ;;9002226.02101,"1202,35356-0068-60 ",.01)
 ;;35356-0068-60
 ;;9002226.02101,"1202,35356-0068-60 ",.02)
 ;;35356-0068-60
 ;;9002226.02101,"1202,35356-0069-90 ",.01)
 ;;35356-0069-90
 ;;9002226.02101,"1202,35356-0069-90 ",.02)
 ;;35356-0069-90
 ;;9002226.02101,"1202,35356-0070-06 ",.01)
 ;;35356-0070-06
