BGP2VZ2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"737,51079-0068-01 ",.01)
 ;;51079-0068-01
 ;;9002226.02101,"737,51079-0068-01 ",.02)
 ;;51079-0068-01
 ;;9002226.02101,"737,51079-0068-20 ",.01)
 ;;51079-0068-20
 ;;9002226.02101,"737,51079-0068-20 ",.02)
 ;;51079-0068-20
 ;;9002226.02101,"737,51079-0069-01 ",.01)
 ;;51079-0069-01
 ;;9002226.02101,"737,51079-0069-01 ",.02)
 ;;51079-0069-01
 ;;9002226.02101,"737,51079-0069-20 ",.01)
 ;;51079-0069-20
 ;;9002226.02101,"737,51079-0069-20 ",.02)
 ;;51079-0069-20
 ;;9002226.02101,"737,51079-0070-01 ",.01)
 ;;51079-0070-01
 ;;9002226.02101,"737,51079-0070-01 ",.02)
 ;;51079-0070-01
 ;;9002226.02101,"737,51079-0070-20 ",.01)
 ;;51079-0070-20
 ;;9002226.02101,"737,51079-0070-20 ",.02)
 ;;51079-0070-20
 ;;9002226.02101,"737,52152-0265-02 ",.01)
 ;;52152-0265-02
 ;;9002226.02101,"737,52152-0265-02 ",.02)
 ;;52152-0265-02
 ;;9002226.02101,"737,52152-0265-05 ",.01)
 ;;52152-0265-05
 ;;9002226.02101,"737,52152-0265-05 ",.02)
 ;;52152-0265-05
 ;;9002226.02101,"737,52152-0266-02 ",.01)
 ;;52152-0266-02
 ;;9002226.02101,"737,52152-0266-02 ",.02)
 ;;52152-0266-02
 ;;9002226.02101,"737,52152-0266-05 ",.01)
 ;;52152-0266-05
 ;;9002226.02101,"737,52152-0266-05 ",.02)
 ;;52152-0266-05
 ;;9002226.02101,"737,53489-0281-01 ",.01)
 ;;53489-0281-01
 ;;9002226.02101,"737,53489-0281-01 ",.02)
 ;;53489-0281-01
 ;;9002226.02101,"737,53489-0281-05 ",.01)
 ;;53489-0281-05
 ;;9002226.02101,"737,53489-0281-05 ",.02)
 ;;53489-0281-05
 ;;9002226.02101,"737,53489-0281-10 ",.01)
 ;;53489-0281-10
 ;;9002226.02101,"737,53489-0281-10 ",.02)
 ;;53489-0281-10
 ;;9002226.02101,"737,54569-0466-00 ",.01)
 ;;54569-0466-00
 ;;9002226.02101,"737,54569-0466-00 ",.02)
 ;;54569-0466-00
 ;;9002226.02101,"737,54569-0468-01 ",.01)
 ;;54569-0468-01
 ;;9002226.02101,"737,54569-0468-01 ",.02)
 ;;54569-0468-01
 ;;9002226.02101,"737,54569-0470-00 ",.01)
 ;;54569-0470-00
 ;;9002226.02101,"737,54569-0470-00 ",.02)
 ;;54569-0470-00
 ;;9002226.02101,"737,54868-0042-01 ",.01)
 ;;54868-0042-01
 ;;9002226.02101,"737,54868-0042-01 ",.02)
 ;;54868-0042-01
 ;;9002226.02101,"737,54868-0042-04 ",.01)
 ;;54868-0042-04
 ;;9002226.02101,"737,54868-0042-04 ",.02)
 ;;54868-0042-04
 ;;9002226.02101,"737,54868-0043-00 ",.01)
 ;;54868-0043-00
 ;;9002226.02101,"737,54868-0043-00 ",.02)
 ;;54868-0043-00
 ;;9002226.02101,"737,54868-0043-01 ",.01)
 ;;54868-0043-01
 ;;9002226.02101,"737,54868-0043-01 ",.02)
 ;;54868-0043-01
 ;;9002226.02101,"737,54868-0043-02 ",.01)
 ;;54868-0043-02
 ;;9002226.02101,"737,54868-0043-02 ",.02)
 ;;54868-0043-02
 ;;9002226.02101,"737,54868-0043-03 ",.01)
 ;;54868-0043-03
 ;;9002226.02101,"737,54868-0043-03 ",.02)
 ;;54868-0043-03
 ;;9002226.02101,"737,54868-0044-00 ",.01)
 ;;54868-0044-00
 ;;9002226.02101,"737,54868-0044-00 ",.02)
 ;;54868-0044-00
 ;;9002226.02101,"737,54868-0044-02 ",.01)
 ;;54868-0044-02
 ;;9002226.02101,"737,54868-0044-02 ",.02)
 ;;54868-0044-02
 ;;9002226.02101,"737,54868-0899-00 ",.01)
 ;;54868-0899-00
 ;;9002226.02101,"737,54868-0899-00 ",.02)
 ;;54868-0899-00
 ;;9002226.02101,"737,54868-1288-00 ",.01)
 ;;54868-1288-00
 ;;9002226.02101,"737,54868-1288-00 ",.02)
 ;;54868-1288-00
 ;;9002226.02101,"737,54868-1464-00 ",.01)
 ;;54868-1464-00
 ;;9002226.02101,"737,54868-1464-00 ",.02)
 ;;54868-1464-00
 ;;9002226.02101,"737,55289-0748-97 ",.01)
 ;;55289-0748-97
 ;;9002226.02101,"737,55289-0748-97 ",.02)
 ;;55289-0748-97
 ;;9002226.02101,"737,59743-0086-10 ",.01)
 ;;59743-0086-10
 ;;9002226.02101,"737,59743-0086-10 ",.02)
 ;;59743-0086-10
 ;;9002226.02101,"737,61392-0111-30 ",.01)
 ;;61392-0111-30
 ;;9002226.02101,"737,61392-0111-30 ",.02)
 ;;61392-0111-30
 ;;9002226.02101,"737,61392-0111-31 ",.01)
 ;;61392-0111-31
 ;;9002226.02101,"737,61392-0111-31 ",.02)
 ;;61392-0111-31
 ;;9002226.02101,"737,61392-0111-32 ",.01)
 ;;61392-0111-32
 ;;9002226.02101,"737,61392-0111-32 ",.02)
 ;;61392-0111-32
 ;;9002226.02101,"737,61392-0111-39 ",.01)
 ;;61392-0111-39
 ;;9002226.02101,"737,61392-0111-39 ",.02)
 ;;61392-0111-39
 ;;9002226.02101,"737,61392-0111-45 ",.01)
 ;;61392-0111-45
 ;;9002226.02101,"737,61392-0111-45 ",.02)
 ;;61392-0111-45
 ;;9002226.02101,"737,61392-0111-51 ",.01)
 ;;61392-0111-51
 ;;9002226.02101,"737,61392-0111-51 ",.02)
 ;;61392-0111-51
 ;;9002226.02101,"737,61392-0111-54 ",.01)
 ;;61392-0111-54
 ;;9002226.02101,"737,61392-0111-54 ",.02)
 ;;61392-0111-54
 ;;9002226.02101,"737,61392-0111-60 ",.01)
 ;;61392-0111-60
 ;;9002226.02101,"737,61392-0111-60 ",.02)
 ;;61392-0111-60
 ;;9002226.02101,"737,61392-0111-90 ",.01)
 ;;61392-0111-90
 ;;9002226.02101,"737,61392-0111-90 ",.02)
 ;;61392-0111-90
 ;;9002226.02101,"737,61392-0111-91 ",.01)
 ;;61392-0111-91
 ;;9002226.02101,"737,61392-0111-91 ",.02)
 ;;61392-0111-91
 ;;9002226.02101,"737,61392-0549-34 ",.01)
 ;;61392-0549-34
 ;;9002226.02101,"737,61392-0549-34 ",.02)
 ;;61392-0549-34
 ;;9002226.02101,"737,61392-0549-45 ",.01)
 ;;61392-0549-45
 ;;9002226.02101,"737,61392-0549-45 ",.02)
 ;;61392-0549-45
 ;;9002226.02101,"737,61392-0549-56 ",.01)
 ;;61392-0549-56
 ;;9002226.02101,"737,61392-0549-56 ",.02)
 ;;61392-0549-56
 ;;9002226.02101,"737,61392-0549-91 ",.01)
 ;;61392-0549-91
 ;;9002226.02101,"737,61392-0549-91 ",.02)
 ;;61392-0549-91
 ;;9002226.02101,"737,61392-0552-31 ",.01)
 ;;61392-0552-31
 ;;9002226.02101,"737,61392-0552-31 ",.02)
 ;;61392-0552-31
 ;;9002226.02101,"737,61392-0552-45 ",.01)
 ;;61392-0552-45
 ;;9002226.02101,"737,61392-0552-45 ",.02)
 ;;61392-0552-45
 ;;9002226.02101,"737,61392-0552-56 ",.01)
 ;;61392-0552-56
 ;;9002226.02101,"737,61392-0552-56 ",.02)
 ;;61392-0552-56
 ;;9002226.02101,"737,64980-0133-01 ",.01)
 ;;64980-0133-01
 ;;9002226.02101,"737,64980-0133-01 ",.02)
 ;;64980-0133-01
 ;;9002226.02101,"737,64980-0133-10 ",.01)
 ;;64980-0133-10
 ;;9002226.02101,"737,64980-0133-10 ",.02)
 ;;64980-0133-10
 ;;9002226.02101,"737,64980-0134-01 ",.01)
 ;;64980-0134-01
 ;;9002226.02101,"737,64980-0134-01 ",.02)
 ;;64980-0134-01
 ;;9002226.02101,"737,64980-0134-10 ",.01)
 ;;64980-0134-10
 ;;9002226.02101,"737,64980-0134-10 ",.02)
 ;;64980-0134-10
 ;;9002226.02101,"737,64980-0135-01 ",.01)
 ;;64980-0135-01
 ;;9002226.02101,"737,64980-0135-01 ",.02)
 ;;64980-0135-01
 ;;9002226.02101,"737,64980-0135-10 ",.01)
 ;;64980-0135-10
 ;;9002226.02101,"737,64980-0135-10 ",.02)
 ;;64980-0135-10
 ;;9002226.02101,"737,68115-0663-00 ",.01)
 ;;68115-0663-00
 ;;9002226.02101,"737,68115-0663-00 ",.02)
 ;;68115-0663-00
 ;;9002226.02101,"737,68382-0187-01 ",.01)
 ;;68382-0187-01
 ;;9002226.02101,"737,68382-0187-01 ",.02)
 ;;68382-0187-01
 ;;9002226.02101,"737,68382-0187-10 ",.01)
 ;;68382-0187-10
 ;;9002226.02101,"737,68382-0187-10 ",.02)
 ;;68382-0187-10
 ;;9002226.02101,"737,68382-0188-01 ",.01)
 ;;68382-0188-01
 ;;9002226.02101,"737,68382-0188-01 ",.02)
 ;;68382-0188-01
 ;;9002226.02101,"737,68382-0188-10 ",.01)
 ;;68382-0188-10
 ;;9002226.02101,"737,68382-0188-10 ",.02)
 ;;68382-0188-10
 ;;9002226.02101,"737,68382-0189-01 ",.01)
 ;;68382-0189-01
 ;;9002226.02101,"737,68382-0189-01 ",.02)
 ;;68382-0189-01
 ;;9002226.02101,"737,68382-0189-10 ",.01)
 ;;68382-0189-10
 ;;9002226.02101,"737,68382-0189-10 ",.02)
 ;;68382-0189-10
 ;;9002226.02101,"737,68462-0116-01 ",.01)
 ;;68462-0116-01
 ;;9002226.02101,"737,68462-0116-01 ",.02)
 ;;68462-0116-01
 ;;9002226.02101,"737,68462-0116-10 ",.01)
 ;;68462-0116-10
 ;;9002226.02101,"737,68462-0116-10 ",.02)
 ;;68462-0116-10
 ;;9002226.02101,"737,68462-0117-01 ",.01)
 ;;68462-0117-01
 ;;9002226.02101,"737,68462-0117-01 ",.02)
 ;;68462-0117-01
 ;;9002226.02101,"737,68462-0117-10 ",.01)
 ;;68462-0117-10
 ;;9002226.02101,"737,68462-0117-10 ",.02)
 ;;68462-0117-10
 ;;9002226.02101,"737,68462-0118-01 ",.01)
 ;;68462-0118-01
 ;;9002226.02101,"737,68462-0118-01 ",.02)
 ;;68462-0118-01
 ;;9002226.02101,"737,68462-0118-10 ",.01)
 ;;68462-0118-10
 ;;9002226.02101,"737,68462-0118-10 ",.02)
 ;;68462-0118-10
