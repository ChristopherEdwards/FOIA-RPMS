BGP2VU7 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"729,54569-0947-03 ",.01)
 ;;54569-0947-03
 ;;9002226.02101,"729,54569-0947-03 ",.02)
 ;;54569-0947-03
 ;;9002226.02101,"729,54569-0948-00 ",.01)
 ;;54569-0948-00
 ;;9002226.02101,"729,54569-0948-00 ",.02)
 ;;54569-0948-00
 ;;9002226.02101,"729,54569-0949-00 ",.01)
 ;;54569-0949-00
 ;;9002226.02101,"729,54569-0949-00 ",.02)
 ;;54569-0949-00
 ;;9002226.02101,"729,54569-0949-01 ",.01)
 ;;54569-0949-01
 ;;9002226.02101,"729,54569-0949-01 ",.02)
 ;;54569-0949-01
 ;;9002226.02101,"729,54569-0949-02 ",.01)
 ;;54569-0949-02
 ;;9002226.02101,"729,54569-0949-02 ",.02)
 ;;54569-0949-02
 ;;9002226.02101,"729,54569-0949-03 ",.01)
 ;;54569-0949-03
 ;;9002226.02101,"729,54569-0949-03 ",.02)
 ;;54569-0949-03
 ;;9002226.02101,"729,54569-0949-04 ",.01)
 ;;54569-0949-04
 ;;9002226.02101,"729,54569-0949-04 ",.02)
 ;;54569-0949-04
 ;;9002226.02101,"729,54569-0949-05 ",.01)
 ;;54569-0949-05
 ;;9002226.02101,"729,54569-0949-05 ",.02)
 ;;54569-0949-05
 ;;9002226.02101,"729,54569-0949-06 ",.01)
 ;;54569-0949-06
 ;;9002226.02101,"729,54569-0949-06 ",.02)
 ;;54569-0949-06
 ;;9002226.02101,"729,54569-0949-07 ",.01)
 ;;54569-0949-07
 ;;9002226.02101,"729,54569-0949-07 ",.02)
 ;;54569-0949-07
 ;;9002226.02101,"729,54569-2376-02 ",.01)
 ;;54569-2376-02
 ;;9002226.02101,"729,54569-2376-02 ",.02)
 ;;54569-2376-02
 ;;9002226.02101,"729,54569-4764-00 ",.01)
 ;;54569-4764-00
 ;;9002226.02101,"729,54569-4764-00 ",.02)
 ;;54569-4764-00
 ;;9002226.02101,"729,54569-4764-03 ",.01)
 ;;54569-4764-03
 ;;9002226.02101,"729,54569-4764-03 ",.02)
 ;;54569-4764-03
 ;;9002226.02101,"729,54569-5354-03 ",.01)
 ;;54569-5354-03
 ;;9002226.02101,"729,54569-5354-03 ",.02)
 ;;54569-5354-03
 ;;9002226.02101,"729,54569-5354-04 ",.01)
 ;;54569-5354-04
 ;;9002226.02101,"729,54569-5354-04 ",.02)
 ;;54569-5354-04
 ;;9002226.02101,"729,54868-0030-00 ",.01)
 ;;54868-0030-00
 ;;9002226.02101,"729,54868-0030-00 ",.02)
 ;;54868-0030-00
 ;;9002226.02101,"729,54868-0030-02 ",.01)
 ;;54868-0030-02
 ;;9002226.02101,"729,54868-0030-02 ",.02)
 ;;54868-0030-02
 ;;9002226.02101,"729,54868-0030-03 ",.01)
 ;;54868-0030-03
 ;;9002226.02101,"729,54868-0030-03 ",.02)
 ;;54868-0030-03
 ;;9002226.02101,"729,54868-0030-04 ",.01)
 ;;54868-0030-04
 ;;9002226.02101,"729,54868-0030-04 ",.02)
 ;;54868-0030-04
 ;;9002226.02101,"729,54868-0030-05 ",.01)
 ;;54868-0030-05
 ;;9002226.02101,"729,54868-0030-05 ",.02)
 ;;54868-0030-05
 ;;9002226.02101,"729,54868-0059-00 ",.01)
 ;;54868-0059-00
 ;;9002226.02101,"729,54868-0059-00 ",.02)
 ;;54868-0059-00
 ;;9002226.02101,"729,54868-0059-01 ",.01)
 ;;54868-0059-01
 ;;9002226.02101,"729,54868-0059-01 ",.02)
 ;;54868-0059-01
 ;;9002226.02101,"729,54868-0059-02 ",.01)
 ;;54868-0059-02
 ;;9002226.02101,"729,54868-0059-02 ",.02)
 ;;54868-0059-02
 ;;9002226.02101,"729,54868-0059-03 ",.01)
 ;;54868-0059-03
 ;;9002226.02101,"729,54868-0059-03 ",.02)
 ;;54868-0059-03
 ;;9002226.02101,"729,54868-0059-04 ",.01)
 ;;54868-0059-04
 ;;9002226.02101,"729,54868-0059-04 ",.02)
 ;;54868-0059-04
 ;;9002226.02101,"729,54868-0059-05 ",.01)
 ;;54868-0059-05
 ;;9002226.02101,"729,54868-0059-05 ",.02)
 ;;54868-0059-05
 ;;9002226.02101,"729,54868-0059-06 ",.01)
 ;;54868-0059-06
 ;;9002226.02101,"729,54868-0059-06 ",.02)
 ;;54868-0059-06
 ;;9002226.02101,"729,54868-0059-08 ",.01)
 ;;54868-0059-08
 ;;9002226.02101,"729,54868-0059-08 ",.02)
 ;;54868-0059-08
 ;;9002226.02101,"729,54868-0059-09 ",.01)
 ;;54868-0059-09
 ;;9002226.02101,"729,54868-0059-09 ",.02)
 ;;54868-0059-09
 ;;9002226.02101,"729,54868-0070-00 ",.01)
 ;;54868-0070-00
 ;;9002226.02101,"729,54868-0070-00 ",.02)
 ;;54868-0070-00
 ;;9002226.02101,"729,54868-0092-01 ",.01)
 ;;54868-0092-01
 ;;9002226.02101,"729,54868-0092-01 ",.02)
 ;;54868-0092-01
 ;;9002226.02101,"729,54868-0092-02 ",.01)
 ;;54868-0092-02
 ;;9002226.02101,"729,54868-0092-02 ",.02)
 ;;54868-0092-02
 ;;9002226.02101,"729,54868-0093-00 ",.01)
 ;;54868-0093-00
 ;;9002226.02101,"729,54868-0093-00 ",.02)
 ;;54868-0093-00
 ;;9002226.02101,"729,54868-0093-01 ",.01)
 ;;54868-0093-01
 ;;9002226.02101,"729,54868-0093-01 ",.02)
 ;;54868-0093-01
 ;;9002226.02101,"729,54868-0426-00 ",.01)
 ;;54868-0426-00
 ;;9002226.02101,"729,54868-0426-00 ",.02)
 ;;54868-0426-00
 ;;9002226.02101,"729,54868-0501-00 ",.01)
 ;;54868-0501-00
 ;;9002226.02101,"729,54868-0501-00 ",.02)
 ;;54868-0501-00
 ;;9002226.02101,"729,54868-0675-01 ",.01)
 ;;54868-0675-01
 ;;9002226.02101,"729,54868-0675-01 ",.02)
 ;;54868-0675-01
 ;;9002226.02101,"729,54868-0703-00 ",.01)
 ;;54868-0703-00
 ;;9002226.02101,"729,54868-0703-00 ",.02)
 ;;54868-0703-00
 ;;9002226.02101,"729,54868-0703-01 ",.01)
 ;;54868-0703-01
 ;;9002226.02101,"729,54868-0703-01 ",.02)
 ;;54868-0703-01
 ;;9002226.02101,"729,54868-0703-02 ",.01)
 ;;54868-0703-02
 ;;9002226.02101,"729,54868-0703-02 ",.02)
 ;;54868-0703-02
 ;;9002226.02101,"729,54868-0703-03 ",.01)
 ;;54868-0703-03
 ;;9002226.02101,"729,54868-0703-03 ",.02)
 ;;54868-0703-03
 ;;9002226.02101,"729,54868-0987-00 ",.01)
 ;;54868-0987-00
 ;;9002226.02101,"729,54868-0987-00 ",.02)
 ;;54868-0987-00
 ;;9002226.02101,"729,54868-0987-01 ",.01)
 ;;54868-0987-01
 ;;9002226.02101,"729,54868-0987-01 ",.02)
 ;;54868-0987-01
 ;;9002226.02101,"729,54868-0988-00 ",.01)
 ;;54868-0988-00
 ;;9002226.02101,"729,54868-0988-00 ",.02)
 ;;54868-0988-00
 ;;9002226.02101,"729,54868-0988-01 ",.01)
 ;;54868-0988-01
 ;;9002226.02101,"729,54868-0988-01 ",.02)
 ;;54868-0988-01
 ;;9002226.02101,"729,54868-0988-02 ",.01)
 ;;54868-0988-02
 ;;9002226.02101,"729,54868-0988-02 ",.02)
 ;;54868-0988-02
 ;;9002226.02101,"729,54868-0988-05 ",.01)
 ;;54868-0988-05
 ;;9002226.02101,"729,54868-0988-05 ",.02)
 ;;54868-0988-05
 ;;9002226.02101,"729,54868-0988-09 ",.01)
 ;;54868-0988-09
 ;;9002226.02101,"729,54868-0988-09 ",.02)
 ;;54868-0988-09
 ;;9002226.02101,"729,54868-1534-00 ",.01)
 ;;54868-1534-00
 ;;9002226.02101,"729,54868-1534-00 ",.02)
 ;;54868-1534-00
 ;;9002226.02101,"729,54868-2126-01 ",.01)
 ;;54868-2126-01
 ;;9002226.02101,"729,54868-2126-01 ",.02)
 ;;54868-2126-01
 ;;9002226.02101,"729,54868-2126-02 ",.01)
 ;;54868-2126-02
 ;;9002226.02101,"729,54868-2126-02 ",.02)
 ;;54868-2126-02
 ;;9002226.02101,"729,54868-2126-03 ",.01)
 ;;54868-2126-03
 ;;9002226.02101,"729,54868-2126-03 ",.02)
 ;;54868-2126-03
 ;;9002226.02101,"729,54868-2126-04 ",.01)
 ;;54868-2126-04
 ;;9002226.02101,"729,54868-2126-04 ",.02)
 ;;54868-2126-04
 ;;9002226.02101,"729,54868-2206-01 ",.01)
 ;;54868-2206-01
 ;;9002226.02101,"729,54868-2206-01 ",.02)
 ;;54868-2206-01
 ;;9002226.02101,"729,54868-2463-00 ",.01)
 ;;54868-2463-00
 ;;9002226.02101,"729,54868-2463-00 ",.02)
 ;;54868-2463-00
 ;;9002226.02101,"729,55045-1171-00 ",.01)
 ;;55045-1171-00
 ;;9002226.02101,"729,55045-1171-00 ",.02)
 ;;55045-1171-00
 ;;9002226.02101,"729,55045-1171-01 ",.01)
 ;;55045-1171-01
 ;;9002226.02101,"729,55045-1171-01 ",.02)
 ;;55045-1171-01
 ;;9002226.02101,"729,55045-1171-02 ",.01)
 ;;55045-1171-02
 ;;9002226.02101,"729,55045-1171-02 ",.02)
 ;;55045-1171-02
 ;;9002226.02101,"729,55045-1171-03 ",.01)
 ;;55045-1171-03
 ;;9002226.02101,"729,55045-1171-03 ",.02)
 ;;55045-1171-03
 ;;9002226.02101,"729,55045-1171-04 ",.01)
 ;;55045-1171-04
 ;;9002226.02101,"729,55045-1171-04 ",.02)
 ;;55045-1171-04
 ;;9002226.02101,"729,55045-1171-05 ",.01)
 ;;55045-1171-05
 ;;9002226.02101,"729,55045-1171-05 ",.02)
 ;;55045-1171-05
 ;;9002226.02101,"729,55045-1171-06 ",.01)
 ;;55045-1171-06
 ;;9002226.02101,"729,55045-1171-06 ",.02)
 ;;55045-1171-06
 ;;9002226.02101,"729,55045-1171-07 ",.01)
 ;;55045-1171-07
 ;;9002226.02101,"729,55045-1171-07 ",.02)
 ;;55045-1171-07
 ;;9002226.02101,"729,55045-1171-08 ",.01)
 ;;55045-1171-08
 ;;9002226.02101,"729,55045-1171-08 ",.02)
 ;;55045-1171-08
 ;;9002226.02101,"729,55045-1171-09 ",.01)
 ;;55045-1171-09
 ;;9002226.02101,"729,55045-1171-09 ",.02)
 ;;55045-1171-09
 ;;9002226.02101,"729,55045-1212-07 ",.01)
 ;;55045-1212-07
 ;;9002226.02101,"729,55045-1212-07 ",.02)
 ;;55045-1212-07
 ;;9002226.02101,"729,55045-1212-08 ",.01)
 ;;55045-1212-08
 ;;9002226.02101,"729,55045-1212-08 ",.02)
 ;;55045-1212-08
 ;;9002226.02101,"729,55045-1477-00 ",.01)
 ;;55045-1477-00
 ;;9002226.02101,"729,55045-1477-00 ",.02)
 ;;55045-1477-00
 ;;9002226.02101,"729,55045-1477-01 ",.01)
 ;;55045-1477-01
 ;;9002226.02101,"729,55045-1477-01 ",.02)
 ;;55045-1477-01
 ;;9002226.02101,"729,55045-1477-03 ",.01)
 ;;55045-1477-03
 ;;9002226.02101,"729,55045-1477-03 ",.02)
 ;;55045-1477-03
 ;;9002226.02101,"729,55045-1477-04 ",.01)
 ;;55045-1477-04
 ;;9002226.02101,"729,55045-1477-04 ",.02)
 ;;55045-1477-04
 ;;9002226.02101,"729,55045-1477-06 ",.01)
 ;;55045-1477-06
 ;;9002226.02101,"729,55045-1477-06 ",.02)
 ;;55045-1477-06
 ;;9002226.02101,"729,55045-1477-07 ",.01)
 ;;55045-1477-07
 ;;9002226.02101,"729,55045-1477-07 ",.02)
 ;;55045-1477-07
 ;;9002226.02101,"729,55045-1477-08 ",.01)
 ;;55045-1477-08
 ;;9002226.02101,"729,55045-1477-08 ",.02)
 ;;55045-1477-08
 ;;9002226.02101,"729,55045-1477-09 ",.01)
 ;;55045-1477-09
 ;;9002226.02101,"729,55045-1477-09 ",.02)
 ;;55045-1477-09
 ;;9002226.02101,"729,55045-1624-00 ",.01)
 ;;55045-1624-00
 ;;9002226.02101,"729,55045-1624-00 ",.02)
 ;;55045-1624-00
 ;;9002226.02101,"729,55045-1624-01 ",.01)
 ;;55045-1624-01
 ;;9002226.02101,"729,55045-1624-01 ",.02)
 ;;55045-1624-01
 ;;9002226.02101,"729,55045-1624-02 ",.01)
 ;;55045-1624-02
 ;;9002226.02101,"729,55045-1624-02 ",.02)
 ;;55045-1624-02
 ;;9002226.02101,"729,55045-1624-04 ",.01)
 ;;55045-1624-04
 ;;9002226.02101,"729,55045-1624-04 ",.02)
 ;;55045-1624-04
 ;;9002226.02101,"729,55045-1624-05 ",.01)
 ;;55045-1624-05
 ;;9002226.02101,"729,55045-1624-05 ",.02)
 ;;55045-1624-05
 ;;9002226.02101,"729,55045-1624-06 ",.01)
 ;;55045-1624-06
 ;;9002226.02101,"729,55045-1624-06 ",.02)
 ;;55045-1624-06
 ;;9002226.02101,"729,55045-1624-08 ",.01)
 ;;55045-1624-08
 ;;9002226.02101,"729,55045-1624-08 ",.02)
 ;;55045-1624-08
 ;;9002226.02101,"729,55045-1624-09 ",.01)
 ;;55045-1624-09
 ;;9002226.02101,"729,55045-1624-09 ",.02)
 ;;55045-1624-09
 ;;9002226.02101,"729,55045-1781-08 ",.01)
 ;;55045-1781-08
 ;;9002226.02101,"729,55045-1781-08 ",.02)
 ;;55045-1781-08
 ;;9002226.02101,"729,55045-1922-00 ",.01)
 ;;55045-1922-00
 ;;9002226.02101,"729,55045-1922-00 ",.02)
 ;;55045-1922-00
 ;;9002226.02101,"729,55045-1922-02 ",.01)
 ;;55045-1922-02
 ;;9002226.02101,"729,55045-1922-02 ",.02)
 ;;55045-1922-02
 ;;9002226.02101,"729,55045-1922-04 ",.01)
 ;;55045-1922-04
 ;;9002226.02101,"729,55045-1922-04 ",.02)
 ;;55045-1922-04
 ;;9002226.02101,"729,55045-1922-06 ",.01)
 ;;55045-1922-06
 ;;9002226.02101,"729,55045-1922-06 ",.02)
 ;;55045-1922-06
 ;;9002226.02101,"729,55045-1922-08 ",.01)
 ;;55045-1922-08
 ;;9002226.02101,"729,55045-1922-08 ",.02)
 ;;55045-1922-08
 ;;9002226.02101,"729,55045-1922-09 ",.01)
 ;;55045-1922-09
 ;;9002226.02101,"729,55045-1922-09 ",.02)
 ;;55045-1922-09
 ;;9002226.02101,"729,55045-3284-02 ",.01)
 ;;55045-3284-02
 ;;9002226.02101,"729,55045-3284-02 ",.02)
 ;;55045-3284-02
 ;;9002226.02101,"729,55045-3284-03 ",.01)
 ;;55045-3284-03
 ;;9002226.02101,"729,55045-3284-03 ",.02)
 ;;55045-3284-03
 ;;9002226.02101,"729,55045-3284-04 ",.01)
 ;;55045-3284-04
 ;;9002226.02101,"729,55045-3284-04 ",.02)
 ;;55045-3284-04
 ;;9002226.02101,"729,55045-3284-09 ",.01)
 ;;55045-3284-09
 ;;9002226.02101,"729,55045-3284-09 ",.02)
 ;;55045-3284-09
 ;;9002226.02101,"729,55045-3299-01 ",.01)
 ;;55045-3299-01
 ;;9002226.02101,"729,55045-3299-01 ",.02)
 ;;55045-3299-01
 ;;9002226.02101,"729,55045-3299-09 ",.01)
 ;;55045-3299-09
 ;;9002226.02101,"729,55045-3299-09 ",.02)
 ;;55045-3299-09
 ;;9002226.02101,"729,55289-0038-30 ",.01)
 ;;55289-0038-30
 ;;9002226.02101,"729,55289-0038-30 ",.02)
 ;;55289-0038-30
 ;;9002226.02101,"729,55289-0061-06 ",.01)
 ;;55289-0061-06
 ;;9002226.02101,"729,55289-0061-06 ",.02)
 ;;55289-0061-06
 ;;9002226.02101,"729,55289-0062-17 ",.01)
 ;;55289-0062-17
 ;;9002226.02101,"729,55289-0062-17 ",.02)
 ;;55289-0062-17
 ;;9002226.02101,"729,55289-0062-30 ",.01)
 ;;55289-0062-30
 ;;9002226.02101,"729,55289-0062-30 ",.02)
 ;;55289-0062-30
 ;;9002226.02101,"729,55289-0062-60 ",.01)
 ;;55289-0062-60
 ;;9002226.02101,"729,55289-0062-60 ",.02)
 ;;55289-0062-60
 ;;9002226.02101,"729,55289-0091-06 ",.01)
 ;;55289-0091-06
 ;;9002226.02101,"729,55289-0091-06 ",.02)
 ;;55289-0091-06
 ;;9002226.02101,"729,55289-0091-09 ",.01)
 ;;55289-0091-09
 ;;9002226.02101,"729,55289-0091-09 ",.02)
 ;;55289-0091-09
 ;;9002226.02101,"729,55289-0091-10 ",.01)
 ;;55289-0091-10
 ;;9002226.02101,"729,55289-0091-10 ",.02)
 ;;55289-0091-10
 ;;9002226.02101,"729,55289-0091-12 ",.01)
 ;;55289-0091-12
 ;;9002226.02101,"729,55289-0091-12 ",.02)
 ;;55289-0091-12
 ;;9002226.02101,"729,55289-0091-15 ",.01)
 ;;55289-0091-15
 ;;9002226.02101,"729,55289-0091-15 ",.02)
 ;;55289-0091-15
 ;;9002226.02101,"729,55289-0091-21 ",.01)
 ;;55289-0091-21
 ;;9002226.02101,"729,55289-0091-21 ",.02)
 ;;55289-0091-21
 ;;9002226.02101,"729,55289-0091-30 ",.01)
 ;;55289-0091-30
 ;;9002226.02101,"729,55289-0091-30 ",.02)
 ;;55289-0091-30
 ;;9002226.02101,"729,55289-0091-60 ",.01)
 ;;55289-0091-60
 ;;9002226.02101,"729,55289-0091-60 ",.02)
 ;;55289-0091-60
 ;;9002226.02101,"729,55289-0091-90 ",.01)
 ;;55289-0091-90
 ;;9002226.02101,"729,55289-0091-90 ",.02)
 ;;55289-0091-90
 ;;9002226.02101,"729,55289-0091-97 ",.01)
 ;;55289-0091-97
 ;;9002226.02101,"729,55289-0091-97 ",.02)
 ;;55289-0091-97
