BGP21J31 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1199,59762-5033-02 ",.02)
 ;;59762-5033-02
 ;;9002226.02101,"1199,59762-7020-09 ",.01)
 ;;59762-7020-09
 ;;9002226.02101,"1199,59762-7020-09 ",.02)
 ;;59762-7020-09
 ;;9002226.02101,"1199,59762-7021-05 ",.01)
 ;;59762-7021-05
 ;;9002226.02101,"1199,59762-7021-05 ",.02)
 ;;59762-7021-05
 ;;9002226.02101,"1199,59762-7021-09 ",.01)
 ;;59762-7021-09
 ;;9002226.02101,"1199,59762-7021-09 ",.02)
 ;;59762-7021-09
 ;;9002226.02101,"1199,59762-7022-05 ",.01)
 ;;59762-7022-05
 ;;9002226.02101,"1199,59762-7022-05 ",.02)
 ;;59762-7022-05
 ;;9002226.02101,"1199,59762-7022-09 ",.01)
 ;;59762-7022-09
 ;;9002226.02101,"1199,59762-7022-09 ",.02)
 ;;59762-7022-09
 ;;9002226.02101,"1199,60346-0457-30 ",.01)
 ;;60346-0457-30
 ;;9002226.02101,"1199,60346-0457-30 ",.02)
 ;;60346-0457-30
 ;;9002226.02101,"1199,60346-0513-60 ",.01)
 ;;60346-0513-60
 ;;9002226.02101,"1199,60346-0513-60 ",.02)
 ;;60346-0513-60
 ;;9002226.02101,"1199,60346-0613-30 ",.01)
 ;;60346-0613-30
 ;;9002226.02101,"1199,60346-0613-30 ",.02)
 ;;60346-0613-30
 ;;9002226.02101,"1199,60346-0633-30 ",.01)
 ;;60346-0633-30
 ;;9002226.02101,"1199,60346-0633-30 ",.02)
 ;;60346-0633-30
 ;;9002226.02101,"1199,60346-0633-60 ",.01)
 ;;60346-0633-60
 ;;9002226.02101,"1199,60346-0633-60 ",.02)
 ;;60346-0633-60
 ;;9002226.02101,"1199,60346-0633-90 ",.01)
 ;;60346-0633-90
 ;;9002226.02101,"1199,60346-0633-90 ",.02)
 ;;60346-0633-90
 ;;9002226.02101,"1199,60346-0662-30 ",.01)
 ;;60346-0662-30
 ;;9002226.02101,"1199,60346-0662-30 ",.02)
 ;;60346-0662-30
 ;;9002226.02101,"1199,60346-0662-60 ",.01)
 ;;60346-0662-60
 ;;9002226.02101,"1199,60346-0662-60 ",.02)
 ;;60346-0662-60
 ;;9002226.02101,"1199,60346-0730-30 ",.01)
 ;;60346-0730-30
 ;;9002226.02101,"1199,60346-0730-30 ",.02)
 ;;60346-0730-30
 ;;9002226.02101,"1199,60346-0730-60 ",.01)
 ;;60346-0730-60
 ;;9002226.02101,"1199,60346-0730-60 ",.02)
 ;;60346-0730-60
 ;;9002226.02101,"1199,60346-0784-30 ",.01)
 ;;60346-0784-30
 ;;9002226.02101,"1199,60346-0784-30 ",.02)
 ;;60346-0784-30
 ;;9002226.02101,"1199,60346-0890-30 ",.01)
 ;;60346-0890-30
 ;;9002226.02101,"1199,60346-0890-30 ",.02)
 ;;60346-0890-30
 ;;9002226.02101,"1199,60346-0938-07 ",.01)
 ;;60346-0938-07
 ;;9002226.02101,"1199,60346-0938-07 ",.02)
 ;;60346-0938-07
 ;;9002226.02101,"1199,60346-0938-30 ",.01)
 ;;60346-0938-30
 ;;9002226.02101,"1199,60346-0938-30 ",.02)
 ;;60346-0938-30
 ;;9002226.02101,"1199,60429-0082-30 ",.01)
 ;;60429-0082-30
 ;;9002226.02101,"1199,60429-0082-30 ",.02)
 ;;60429-0082-30
 ;;9002226.02101,"1199,60429-0082-60 ",.01)
 ;;60429-0082-60
 ;;9002226.02101,"1199,60429-0082-60 ",.02)
 ;;60429-0082-60
 ;;9002226.02101,"1199,60429-0083-12 ",.01)
 ;;60429-0083-12
 ;;9002226.02101,"1199,60429-0083-12 ",.02)
 ;;60429-0083-12
 ;;9002226.02101,"1199,60429-0083-30 ",.01)
 ;;60429-0083-30
 ;;9002226.02101,"1199,60429-0083-30 ",.02)
 ;;60429-0083-30
 ;;9002226.02101,"1199,60429-0083-60 ",.01)
 ;;60429-0083-60
 ;;9002226.02101,"1199,60429-0083-60 ",.02)
 ;;60429-0083-60
 ;;9002226.02101,"1199,60429-0085-12 ",.01)
 ;;60429-0085-12
 ;;9002226.02101,"1199,60429-0085-12 ",.02)
 ;;60429-0085-12
 ;;9002226.02101,"1199,60429-0085-18 ",.01)
 ;;60429-0085-18
 ;;9002226.02101,"1199,60429-0085-18 ",.02)
 ;;60429-0085-18
 ;;9002226.02101,"1199,60429-0085-27 ",.01)
 ;;60429-0085-27
 ;;9002226.02101,"1199,60429-0085-27 ",.02)
 ;;60429-0085-27
 ;;9002226.02101,"1199,60429-0085-30 ",.01)
 ;;60429-0085-30
 ;;9002226.02101,"1199,60429-0085-30 ",.02)
 ;;60429-0085-30
 ;;9002226.02101,"1199,60429-0085-36 ",.01)
 ;;60429-0085-36
 ;;9002226.02101,"1199,60429-0085-36 ",.02)
 ;;60429-0085-36
 ;;9002226.02101,"1199,60429-0085-60 ",.01)
 ;;60429-0085-60
 ;;9002226.02101,"1199,60429-0085-60 ",.02)
 ;;60429-0085-60
 ;;9002226.02101,"1199,60429-0085-90 ",.01)
 ;;60429-0085-90
 ;;9002226.02101,"1199,60429-0085-90 ",.02)
 ;;60429-0085-90
 ;;9002226.02101,"1199,60505-0141-00 ",.01)
 ;;60505-0141-00
 ;;9002226.02101,"1199,60505-0141-00 ",.02)
 ;;60505-0141-00
 ;;9002226.02101,"1199,60505-0141-01 ",.01)
 ;;60505-0141-01
 ;;9002226.02101,"1199,60505-0141-01 ",.02)
 ;;60505-0141-01
 ;;9002226.02101,"1199,60505-0141-02 ",.01)
 ;;60505-0141-02
 ;;9002226.02101,"1199,60505-0141-02 ",.02)
 ;;60505-0141-02
 ;;9002226.02101,"1199,60505-0141-08 ",.01)
 ;;60505-0141-08
 ;;9002226.02101,"1199,60505-0141-08 ",.02)
 ;;60505-0141-08
 ;;9002226.02101,"1199,60505-0142-00 ",.01)
 ;;60505-0142-00
 ;;9002226.02101,"1199,60505-0142-00 ",.02)
 ;;60505-0142-00
 ;;9002226.02101,"1199,60505-0142-01 ",.01)
 ;;60505-0142-01
 ;;9002226.02101,"1199,60505-0142-01 ",.02)
 ;;60505-0142-01
 ;;9002226.02101,"1199,60505-0142-02 ",.01)
 ;;60505-0142-02
 ;;9002226.02101,"1199,60505-0142-02 ",.02)
 ;;60505-0142-02
 ;;9002226.02101,"1199,60505-0142-04 ",.01)
 ;;60505-0142-04
 ;;9002226.02101,"1199,60505-0142-04 ",.02)
 ;;60505-0142-04
 ;;9002226.02101,"1199,60951-0714-70 ",.01)
 ;;60951-0714-70
 ;;9002226.02101,"1199,60951-0714-70 ",.02)
 ;;60951-0714-70
 ;;9002226.02101,"1199,60951-0714-85 ",.01)
 ;;60951-0714-85
 ;;9002226.02101,"1199,60951-0714-85 ",.02)
 ;;60951-0714-85
 ;;9002226.02101,"1199,61442-0115-01 ",.01)
 ;;61442-0115-01
 ;;9002226.02101,"1199,61442-0115-01 ",.02)
 ;;61442-0115-01
