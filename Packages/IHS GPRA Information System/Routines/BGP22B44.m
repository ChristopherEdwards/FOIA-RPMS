BGP22B44 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 21, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"1196,65862-0045-01 ",.02)
 ;;65862-0045-01
 ;;9002226.02101,"1196,65862-0045-05 ",.01)
 ;;65862-0045-05
 ;;9002226.02101,"1196,65862-0045-05 ",.02)
 ;;65862-0045-05
 ;;9002226.02101,"1196,65862-0116-01 ",.01)
 ;;65862-0116-01
 ;;9002226.02101,"1196,65862-0116-01 ",.02)
 ;;65862-0116-01
 ;;9002226.02101,"1196,65862-0117-01 ",.01)
 ;;65862-0117-01
 ;;9002226.02101,"1196,65862-0117-01 ",.02)
 ;;65862-0117-01
 ;;9002226.02101,"1196,65862-0118-01 ",.01)
 ;;65862-0118-01
 ;;9002226.02101,"1196,65862-0118-01 ",.02)
 ;;65862-0118-01
 ;;9002226.02101,"1196,65862-0161-90 ",.01)
 ;;65862-0161-90
 ;;9002226.02101,"1196,65862-0161-90 ",.02)
 ;;65862-0161-90
 ;;9002226.02101,"1196,65862-0162-30 ",.01)
 ;;65862-0162-30
 ;;9002226.02101,"1196,65862-0162-30 ",.02)
 ;;65862-0162-30
 ;;9002226.02101,"1196,65862-0162-90 ",.01)
 ;;65862-0162-90
 ;;9002226.02101,"1196,65862-0162-90 ",.02)
 ;;65862-0162-90
 ;;9002226.02101,"1196,65862-0163-90 ",.01)
 ;;65862-0163-90
 ;;9002226.02101,"1196,65862-0163-90 ",.02)
 ;;65862-0163-90
 ;;9002226.02101,"1196,65862-0164-01 ",.01)
 ;;65862-0164-01
 ;;9002226.02101,"1196,65862-0164-01 ",.02)
 ;;65862-0164-01
 ;;9002226.02101,"1196,65862-0165-01 ",.01)
 ;;65862-0165-01
 ;;9002226.02101,"1196,65862-0165-01 ",.02)
 ;;65862-0165-01
 ;;9002226.02101,"1196,65862-0166-01 ",.01)
 ;;65862-0166-01
 ;;9002226.02101,"1196,65862-0166-01 ",.02)
 ;;65862-0166-01
 ;;9002226.02101,"1196,65862-0201-90 ",.01)
 ;;65862-0201-90
 ;;9002226.02101,"1196,65862-0201-90 ",.02)
 ;;65862-0201-90
 ;;9002226.02101,"1196,65862-0201-99 ",.01)
 ;;65862-0201-99
 ;;9002226.02101,"1196,65862-0201-99 ",.02)
 ;;65862-0201-99
 ;;9002226.02101,"1196,65862-0202-30 ",.01)
 ;;65862-0202-30
 ;;9002226.02101,"1196,65862-0202-30 ",.02)
 ;;65862-0202-30
 ;;9002226.02101,"1196,65862-0202-90 ",.01)
 ;;65862-0202-90
 ;;9002226.02101,"1196,65862-0202-90 ",.02)
 ;;65862-0202-90
 ;;9002226.02101,"1196,65862-0202-99 ",.01)
 ;;65862-0202-99
 ;;9002226.02101,"1196,65862-0202-99 ",.02)
 ;;65862-0202-99
 ;;9002226.02101,"1196,65862-0203-30 ",.01)
 ;;65862-0203-30
 ;;9002226.02101,"1196,65862-0203-30 ",.02)
 ;;65862-0203-30
 ;;9002226.02101,"1196,65862-0203-90 ",.01)
 ;;65862-0203-90
 ;;9002226.02101,"1196,65862-0203-90 ",.02)
 ;;65862-0203-90
 ;;9002226.02101,"1196,65862-0203-99 ",.01)
 ;;65862-0203-99
 ;;9002226.02101,"1196,65862-0203-99 ",.02)
 ;;65862-0203-99
 ;;9002226.02101,"1196,65862-0286-01 ",.01)
 ;;65862-0286-01
 ;;9002226.02101,"1196,65862-0286-01 ",.02)
 ;;65862-0286-01
 ;;9002226.02101,"1196,65862-0287-01 ",.01)
 ;;65862-0287-01
 ;;9002226.02101,"1196,65862-0287-01 ",.02)
 ;;65862-0287-01
 ;;9002226.02101,"1196,65862-0288-01 ",.01)
 ;;65862-0288-01
 ;;9002226.02101,"1196,65862-0288-01 ",.02)
 ;;65862-0288-01
 ;;9002226.02101,"1196,65862-0308-01 ",.01)
 ;;65862-0308-01
 ;;9002226.02101,"1196,65862-0308-01 ",.02)
 ;;65862-0308-01
 ;;9002226.02101,"1196,65862-0309-01 ",.01)
 ;;65862-0309-01
 ;;9002226.02101,"1196,65862-0309-01 ",.02)
 ;;65862-0309-01
 ;;9002226.02101,"1196,65862-0468-30 ",.01)
 ;;65862-0468-30
 ;;9002226.02101,"1196,65862-0468-30 ",.02)
 ;;65862-0468-30
 ;;9002226.02101,"1196,65862-0468-90 ",.01)
 ;;65862-0468-90
 ;;9002226.02101,"1196,65862-0468-90 ",.02)
 ;;65862-0468-90
 ;;9002226.02101,"1196,65862-0468-99 ",.01)
 ;;65862-0468-99
 ;;9002226.02101,"1196,65862-0468-99 ",.02)
 ;;65862-0468-99
 ;;9002226.02101,"1196,65862-0469-30 ",.01)
 ;;65862-0469-30
 ;;9002226.02101,"1196,65862-0469-30 ",.02)
 ;;65862-0469-30
 ;;9002226.02101,"1196,65862-0469-90 ",.01)
 ;;65862-0469-90
 ;;9002226.02101,"1196,65862-0469-90 ",.02)
 ;;65862-0469-90
 ;;9002226.02101,"1196,65862-0469-99 ",.01)
 ;;65862-0469-99
 ;;9002226.02101,"1196,65862-0469-99 ",.02)
 ;;65862-0469-99
 ;;9002226.02101,"1196,65862-0470-30 ",.01)
 ;;65862-0470-30
 ;;9002226.02101,"1196,65862-0470-30 ",.02)
 ;;65862-0470-30
 ;;9002226.02101,"1196,65862-0470-90 ",.01)
 ;;65862-0470-90
 ;;9002226.02101,"1196,65862-0470-90 ",.02)
 ;;65862-0470-90
 ;;9002226.02101,"1196,65862-0470-99 ",.01)
 ;;65862-0470-99
 ;;9002226.02101,"1196,65862-0470-99 ",.02)
 ;;65862-0470-99
 ;;9002226.02101,"1196,66105-0503-01 ",.01)
 ;;66105-0503-01
 ;;9002226.02101,"1196,66105-0503-01 ",.02)
 ;;66105-0503-01
 ;;9002226.02101,"1196,66105-0503-03 ",.01)
 ;;66105-0503-03
 ;;9002226.02101,"1196,66105-0503-03 ",.02)
 ;;66105-0503-03
 ;;9002226.02101,"1196,66105-0503-06 ",.01)
 ;;66105-0503-06
 ;;9002226.02101,"1196,66105-0503-06 ",.02)
 ;;66105-0503-06
 ;;9002226.02101,"1196,66105-0503-09 ",.01)
 ;;66105-0503-09
 ;;9002226.02101,"1196,66105-0503-09 ",.02)
 ;;66105-0503-09
 ;;9002226.02101,"1196,66105-0503-15 ",.01)
 ;;66105-0503-15
 ;;9002226.02101,"1196,66105-0503-15 ",.02)
 ;;66105-0503-15
 ;;9002226.02101,"1196,66105-0504-01 ",.01)
 ;;66105-0504-01
 ;;9002226.02101,"1196,66105-0504-01 ",.02)
 ;;66105-0504-01
 ;;9002226.02101,"1196,66105-0504-03 ",.01)
 ;;66105-0504-03
 ;;9002226.02101,"1196,66105-0504-03 ",.02)
 ;;66105-0504-03
 ;;9002226.02101,"1196,66105-0504-06 ",.01)
 ;;66105-0504-06
 ;;9002226.02101,"1196,66105-0504-06 ",.02)
 ;;66105-0504-06
 ;;9002226.02101,"1196,66105-0504-09 ",.01)
 ;;66105-0504-09
 ;;9002226.02101,"1196,66105-0504-09 ",.02)
 ;;66105-0504-09
 ;;9002226.02101,"1196,66105-0504-15 ",.01)
 ;;66105-0504-15
 ;;9002226.02101,"1196,66105-0504-15 ",.02)
 ;;66105-0504-15
 ;;9002226.02101,"1196,66105-0545-01 ",.01)
 ;;66105-0545-01
 ;;9002226.02101,"1196,66105-0545-01 ",.02)
 ;;66105-0545-01
 ;;9002226.02101,"1196,66105-0545-03 ",.01)
 ;;66105-0545-03
 ;;9002226.02101,"1196,66105-0545-03 ",.02)
 ;;66105-0545-03
 ;;9002226.02101,"1196,66105-0545-06 ",.01)
 ;;66105-0545-06
 ;;9002226.02101,"1196,66105-0545-06 ",.02)
 ;;66105-0545-06
 ;;9002226.02101,"1196,66105-0545-09 ",.01)
 ;;66105-0545-09
 ;;9002226.02101,"1196,66105-0545-09 ",.02)
 ;;66105-0545-09
 ;;9002226.02101,"1196,66105-0545-10 ",.01)
 ;;66105-0545-10
 ;;9002226.02101,"1196,66105-0545-10 ",.02)
 ;;66105-0545-10
 ;;9002226.02101,"1196,66105-0553-03 ",.01)
 ;;66105-0553-03
 ;;9002226.02101,"1196,66105-0553-03 ",.02)
 ;;66105-0553-03
 ;;9002226.02101,"1196,66105-0663-03 ",.01)
 ;;66105-0663-03
 ;;9002226.02101,"1196,66105-0663-03 ",.02)
 ;;66105-0663-03
 ;;9002226.02101,"1196,66105-0669-03 ",.01)
 ;;66105-0669-03
 ;;9002226.02101,"1196,66105-0669-03 ",.02)
 ;;66105-0669-03
 ;;9002226.02101,"1196,66105-0842-03 ",.01)
 ;;66105-0842-03
 ;;9002226.02101,"1196,66105-0842-03 ",.02)
 ;;66105-0842-03
 ;;9002226.02101,"1196,66105-0842-06 ",.01)
 ;;66105-0842-06
 ;;9002226.02101,"1196,66105-0842-06 ",.02)
 ;;66105-0842-06
 ;;9002226.02101,"1196,66105-0842-09 ",.01)
 ;;66105-0842-09
 ;;9002226.02101,"1196,66105-0842-09 ",.02)
 ;;66105-0842-09
 ;;9002226.02101,"1196,66105-0842-10 ",.01)
 ;;66105-0842-10
 ;;9002226.02101,"1196,66105-0842-10 ",.02)
 ;;66105-0842-10
 ;;9002226.02101,"1196,66105-0842-28 ",.01)
 ;;66105-0842-28
 ;;9002226.02101,"1196,66105-0842-28 ",.02)
 ;;66105-0842-28
 ;;9002226.02101,"1196,66116-0237-30 ",.01)
 ;;66116-0237-30
 ;;9002226.02101,"1196,66116-0237-30 ",.02)
 ;;66116-0237-30
 ;;9002226.02101,"1196,66116-0279-30 ",.01)
 ;;66116-0279-30
 ;;9002226.02101,"1196,66116-0279-30 ",.02)
 ;;66116-0279-30
 ;;9002226.02101,"1196,66116-0435-30 ",.01)
 ;;66116-0435-30
 ;;9002226.02101,"1196,66116-0435-30 ",.02)
 ;;66116-0435-30
 ;;9002226.02101,"1196,66116-0436-30 ",.01)
 ;;66116-0436-30
 ;;9002226.02101,"1196,66116-0436-30 ",.02)
 ;;66116-0436-30
 ;;9002226.02101,"1196,66267-0253-30 ",.01)
 ;;66267-0253-30
 ;;9002226.02101,"1196,66267-0253-30 ",.02)
 ;;66267-0253-30
 ;;9002226.02101,"1196,66267-0323-30 ",.01)
 ;;66267-0323-30
 ;;9002226.02101,"1196,66267-0323-30 ",.02)
 ;;66267-0323-30
 ;;9002226.02101,"1196,66267-0323-60 ",.01)
 ;;66267-0323-60
 ;;9002226.02101,"1196,66267-0323-60 ",.02)
 ;;66267-0323-60
 ;;9002226.02101,"1196,66267-0323-90 ",.01)
 ;;66267-0323-90
 ;;9002226.02101,"1196,66267-0323-90 ",.02)
 ;;66267-0323-90
 ;;9002226.02101,"1196,66267-0323-91 ",.01)
 ;;66267-0323-91
 ;;9002226.02101,"1196,66267-0323-91 ",.02)
 ;;66267-0323-91
 ;;9002226.02101,"1196,66267-0380-30 ",.01)
 ;;66267-0380-30
 ;;9002226.02101,"1196,66267-0380-30 ",.02)
 ;;66267-0380-30
 ;;9002226.02101,"1196,66267-0380-60 ",.01)
 ;;66267-0380-60
 ;;9002226.02101,"1196,66267-0380-60 ",.02)
 ;;66267-0380-60
 ;;9002226.02101,"1196,66267-0380-90 ",.01)
 ;;66267-0380-90
 ;;9002226.02101,"1196,66267-0380-90 ",.02)
 ;;66267-0380-90
 ;;9002226.02101,"1196,66267-0380-91 ",.01)
 ;;66267-0380-91
 ;;9002226.02101,"1196,66267-0380-91 ",.02)
 ;;66267-0380-91
 ;;9002226.02101,"1196,66267-0413-30 ",.01)
 ;;66267-0413-30
 ;;9002226.02101,"1196,66267-0413-30 ",.02)
 ;;66267-0413-30
 ;;9002226.02101,"1196,66267-0413-60 ",.01)
 ;;66267-0413-60
 ;;9002226.02101,"1196,66267-0413-60 ",.02)
 ;;66267-0413-60
 ;;9002226.02101,"1196,66267-0413-90 ",.01)
 ;;66267-0413-90
 ;;9002226.02101,"1196,66267-0413-90 ",.02)
 ;;66267-0413-90
 ;;9002226.02101,"1196,66267-0413-92 ",.01)
 ;;66267-0413-92
 ;;9002226.02101,"1196,66267-0413-92 ",.02)
 ;;66267-0413-92
 ;;9002226.02101,"1196,66267-0523-30 ",.01)
 ;;66267-0523-30
 ;;9002226.02101,"1196,66267-0523-30 ",.02)
 ;;66267-0523-30
 ;;9002226.02101,"1196,66267-0523-60 ",.01)
 ;;66267-0523-60
 ;;9002226.02101,"1196,66267-0523-60 ",.02)
 ;;66267-0523-60
 ;;9002226.02101,"1196,66267-0751-30 ",.01)
 ;;66267-0751-30
 ;;9002226.02101,"1196,66267-0751-30 ",.02)
 ;;66267-0751-30
 ;;9002226.02101,"1196,66267-0751-90 ",.01)
 ;;66267-0751-90
 ;;9002226.02101,"1196,66267-0751-90 ",.02)
 ;;66267-0751-90
 ;;9002226.02101,"1196,66267-0752-30 ",.01)
 ;;66267-0752-30
 ;;9002226.02101,"1196,66267-0752-30 ",.02)
 ;;66267-0752-30
 ;;9002226.02101,"1196,66267-0752-90 ",.01)
 ;;66267-0752-90
 ;;9002226.02101,"1196,66267-0752-90 ",.02)
 ;;66267-0752-90
 ;;9002226.02101,"1196,66267-1009-00 ",.01)
 ;;66267-1009-00
 ;;9002226.02101,"1196,66267-1009-00 ",.02)
 ;;66267-1009-00
 ;;9002226.02101,"1196,66336-0124-30 ",.01)
 ;;66336-0124-30
 ;;9002226.02101,"1196,66336-0124-30 ",.02)
 ;;66336-0124-30
 ;;9002226.02101,"1196,66336-0169-30 ",.01)
 ;;66336-0169-30
 ;;9002226.02101,"1196,66336-0169-30 ",.02)
 ;;66336-0169-30
 ;;9002226.02101,"1196,66336-0232-30 ",.01)
 ;;66336-0232-30
 ;;9002226.02101,"1196,66336-0232-30 ",.02)
 ;;66336-0232-30
 ;;9002226.02101,"1196,66336-0387-30 ",.01)
 ;;66336-0387-30
 ;;9002226.02101,"1196,66336-0387-30 ",.02)
 ;;66336-0387-30
 ;;9002226.02101,"1196,66336-0389-30 ",.01)
 ;;66336-0389-30
 ;;9002226.02101,"1196,66336-0389-30 ",.02)
 ;;66336-0389-30
 ;;9002226.02101,"1196,66336-0389-60 ",.01)
 ;;66336-0389-60
 ;;9002226.02101,"1196,66336-0389-60 ",.02)
 ;;66336-0389-60
 ;;9002226.02101,"1196,66336-0391-30 ",.01)
 ;;66336-0391-30
 ;;9002226.02101,"1196,66336-0391-30 ",.02)
 ;;66336-0391-30
 ;;9002226.02101,"1196,66336-0391-60 ",.01)
 ;;66336-0391-60
 ;;9002226.02101,"1196,66336-0391-60 ",.02)
 ;;66336-0391-60
 ;;9002226.02101,"1196,66336-0393-30 ",.01)
 ;;66336-0393-30
 ;;9002226.02101,"1196,66336-0393-30 ",.02)
 ;;66336-0393-30
 ;;9002226.02101,"1196,66336-0393-60 ",.01)
 ;;66336-0393-60
 ;;9002226.02101,"1196,66336-0393-60 ",.02)
 ;;66336-0393-60
 ;;9002226.02101,"1196,66336-0572-30 ",.01)
 ;;66336-0572-30
 ;;9002226.02101,"1196,66336-0572-30 ",.02)
 ;;66336-0572-30
 ;;9002226.02101,"1196,66336-0618-60 ",.01)
 ;;66336-0618-60
 ;;9002226.02101,"1196,66336-0618-60 ",.02)
 ;;66336-0618-60
 ;;9002226.02101,"1196,66336-0665-15 ",.01)
 ;;66336-0665-15
 ;;9002226.02101,"1196,66336-0665-15 ",.02)
 ;;66336-0665-15
 ;;9002226.02101,"1196,66336-0665-30 ",.01)
 ;;66336-0665-30
 ;;9002226.02101,"1196,66336-0665-30 ",.02)
 ;;66336-0665-30
 ;;9002226.02101,"1196,66336-0666-30 ",.01)
 ;;66336-0666-30
 ;;9002226.02101,"1196,66336-0666-30 ",.02)
 ;;66336-0666-30
 ;;9002226.02101,"1196,66336-0672-60 ",.01)
 ;;66336-0672-60
 ;;9002226.02101,"1196,66336-0672-60 ",.02)
 ;;66336-0672-60
 ;;9002226.02101,"1196,66336-0691-30 ",.01)
 ;;66336-0691-30
 ;;9002226.02101,"1196,66336-0691-30 ",.02)
 ;;66336-0691-30
 ;;9002226.02101,"1196,66336-0691-90 ",.01)
 ;;66336-0691-90
 ;;9002226.02101,"1196,66336-0691-90 ",.02)
 ;;66336-0691-90
 ;;9002226.02101,"1196,66336-0741-30 ",.01)
 ;;66336-0741-30
 ;;9002226.02101,"1196,66336-0741-30 ",.02)
 ;;66336-0741-30
 ;;9002226.02101,"1196,66336-0741-60 ",.01)
 ;;66336-0741-60
 ;;9002226.02101,"1196,66336-0741-60 ",.02)
 ;;66336-0741-60
 ;;9002226.02101,"1196,66336-0741-90 ",.01)
 ;;66336-0741-90
 ;;9002226.02101,"1196,66336-0741-90 ",.02)
 ;;66336-0741-90
 ;;9002226.02101,"1196,66336-0750-30 ",.01)
 ;;66336-0750-30
 ;;9002226.02101,"1196,66336-0750-30 ",.02)
 ;;66336-0750-30
 ;;9002226.02101,"1196,66336-0750-60 ",.01)
 ;;66336-0750-60
 ;;9002226.02101,"1196,66336-0750-60 ",.02)
 ;;66336-0750-60
 ;;9002226.02101,"1196,66336-0750-90 ",.01)
 ;;66336-0750-90
 ;;9002226.02101,"1196,66336-0750-90 ",.02)
 ;;66336-0750-90
 ;;9002226.02101,"1196,66336-0773-30 ",.01)
 ;;66336-0773-30
 ;;9002226.02101,"1196,66336-0773-30 ",.02)
 ;;66336-0773-30
 ;;9002226.02101,"1196,66336-0773-90 ",.01)
 ;;66336-0773-90
 ;;9002226.02101,"1196,66336-0773-90 ",.02)
 ;;66336-0773-90
 ;;9002226.02101,"1196,66336-0794-60 ",.01)
 ;;66336-0794-60
 ;;9002226.02101,"1196,66336-0794-60 ",.02)
 ;;66336-0794-60
 ;;9002226.02101,"1196,66336-0805-30 ",.01)
 ;;66336-0805-30
 ;;9002226.02101,"1196,66336-0805-30 ",.02)
 ;;66336-0805-30
 ;;9002226.02101,"1196,66336-0805-90 ",.01)
 ;;66336-0805-90
 ;;9002226.02101,"1196,66336-0805-90 ",.02)
 ;;66336-0805-90
