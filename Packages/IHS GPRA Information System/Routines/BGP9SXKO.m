BGP9SXKO ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON MAR 25, 2009 ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"729,52959-0295-50 ",.02)
 ;;52959-0295-50
 ;;9002226.02101,"729,52959-0306-06 ",.01)
 ;;52959-0306-06
 ;;9002226.02101,"729,52959-0306-06 ",.02)
 ;;52959-0306-06
 ;;9002226.02101,"729,52959-0306-20 ",.01)
 ;;52959-0306-20
 ;;9002226.02101,"729,52959-0306-20 ",.02)
 ;;52959-0306-20
 ;;9002226.02101,"729,52959-0306-30 ",.01)
 ;;52959-0306-30
 ;;9002226.02101,"729,52959-0306-30 ",.02)
 ;;52959-0306-30
 ;;9002226.02101,"729,52959-0369-00 ",.01)
 ;;52959-0369-00
 ;;9002226.02101,"729,52959-0369-00 ",.02)
 ;;52959-0369-00
 ;;9002226.02101,"729,52959-0369-06 ",.01)
 ;;52959-0369-06
 ;;9002226.02101,"729,52959-0369-06 ",.02)
 ;;52959-0369-06
 ;;9002226.02101,"729,52959-0369-30 ",.01)
 ;;52959-0369-30
 ;;9002226.02101,"729,52959-0369-30 ",.02)
 ;;52959-0369-30
 ;;9002226.02101,"729,52959-0369-40 ",.01)
 ;;52959-0369-40
 ;;9002226.02101,"729,52959-0369-40 ",.02)
 ;;52959-0369-40
 ;;9002226.02101,"729,54569-0173-00 ",.01)
 ;;54569-0173-00
 ;;9002226.02101,"729,54569-0173-00 ",.02)
 ;;54569-0173-00
 ;;9002226.02101,"729,54569-0936-00 ",.01)
 ;;54569-0936-00
 ;;9002226.02101,"729,54569-0936-00 ",.02)
 ;;54569-0936-00
 ;;9002226.02101,"729,54569-0936-02 ",.01)
 ;;54569-0936-02
 ;;9002226.02101,"729,54569-0936-02 ",.02)
 ;;54569-0936-02
 ;;9002226.02101,"729,54569-0936-03 ",.01)
 ;;54569-0936-03
 ;;9002226.02101,"729,54569-0936-03 ",.02)
 ;;54569-0936-03
 ;;9002226.02101,"729,54569-0936-04 ",.01)
 ;;54569-0936-04
 ;;9002226.02101,"729,54569-0936-04 ",.02)
 ;;54569-0936-04
 ;;9002226.02101,"729,54569-0936-05 ",.01)
 ;;54569-0936-05
 ;;9002226.02101,"729,54569-0936-05 ",.02)
 ;;54569-0936-05
 ;;9002226.02101,"729,54569-0936-06 ",.01)
 ;;54569-0936-06
 ;;9002226.02101,"729,54569-0936-06 ",.02)
 ;;54569-0936-06
 ;;9002226.02101,"729,54569-0936-07 ",.01)
 ;;54569-0936-07
 ;;9002226.02101,"729,54569-0936-07 ",.02)
 ;;54569-0936-07
 ;;9002226.02101,"729,54569-0936-08 ",.01)
 ;;54569-0936-08
 ;;9002226.02101,"729,54569-0936-08 ",.02)
 ;;54569-0936-08
 ;;9002226.02101,"729,54569-0936-09 ",.01)
 ;;54569-0936-09
 ;;9002226.02101,"729,54569-0936-09 ",.02)
 ;;54569-0936-09
 ;;9002226.02101,"729,54569-0947-00 ",.01)
 ;;54569-0947-00
 ;;9002226.02101,"729,54569-0947-00 ",.02)
 ;;54569-0947-00
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
 ;;9002226.02101,"729,54569-1413-00 ",.01)
 ;;54569-1413-00
 ;;9002226.02101,"729,54569-1413-00 ",.02)
 ;;54569-1413-00
 ;;9002226.02101,"729,54569-2376-02 ",.01)
 ;;54569-2376-02
 ;;9002226.02101,"729,54569-2376-02 ",.02)
 ;;54569-2376-02
 ;;9002226.02101,"729,54569-2775-00 ",.01)
 ;;54569-2775-00
 ;;9002226.02101,"729,54569-2775-00 ",.02)
 ;;54569-2775-00
 ;;9002226.02101,"729,54569-4167-00 ",.01)
 ;;54569-4167-00
 ;;9002226.02101,"729,54569-4167-00 ",.02)
 ;;54569-4167-00
 ;;9002226.02101,"729,54569-4764-00 ",.01)
 ;;54569-4764-00
 ;;9002226.02101,"729,54569-4764-00 ",.02)
 ;;54569-4764-00
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
 ;;9002226.02101,"729,54868-0501-00 ",.01)
 ;;54868-0501-00