BGP62Z60 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 11, 2016;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;9002226.02101,"869,61392-0153-32 ",.01)
 ;;61392-0153-32
 ;;9002226.02101,"869,61392-0153-32 ",.02)
 ;;61392-0153-32
 ;;9002226.02101,"869,61392-0153-39 ",.01)
 ;;61392-0153-39
 ;;9002226.02101,"869,61392-0153-39 ",.02)
 ;;61392-0153-39
 ;;9002226.02101,"869,61392-0153-45 ",.01)
 ;;61392-0153-45
 ;;9002226.02101,"869,61392-0153-45 ",.02)
 ;;61392-0153-45
 ;;9002226.02101,"869,61392-0153-54 ",.01)
 ;;61392-0153-54
 ;;9002226.02101,"869,61392-0153-54 ",.02)
 ;;61392-0153-54
 ;;9002226.02101,"869,61392-0153-56 ",.01)
 ;;61392-0153-56
 ;;9002226.02101,"869,61392-0153-56 ",.02)
 ;;61392-0153-56
 ;;9002226.02101,"869,61392-0153-91 ",.01)
 ;;61392-0153-91
 ;;9002226.02101,"869,61392-0153-91 ",.02)
 ;;61392-0153-91
 ;;9002226.02101,"869,61392-0234-30 ",.01)
 ;;61392-0234-30
 ;;9002226.02101,"869,61392-0234-30 ",.02)
 ;;61392-0234-30
 ;;9002226.02101,"869,61392-0234-51 ",.01)
 ;;61392-0234-51
 ;;9002226.02101,"869,61392-0234-51 ",.02)
 ;;61392-0234-51
 ;;9002226.02101,"869,61392-0234-54 ",.01)
 ;;61392-0234-54
 ;;9002226.02101,"869,61392-0234-54 ",.02)
 ;;61392-0234-54
 ;;9002226.02101,"869,61392-0234-56 ",.01)
 ;;61392-0234-56
 ;;9002226.02101,"869,61392-0234-56 ",.02)
 ;;61392-0234-56
 ;;9002226.02101,"869,61392-0234-60 ",.01)
 ;;61392-0234-60
 ;;9002226.02101,"869,61392-0234-60 ",.02)
 ;;61392-0234-60
 ;;9002226.02101,"869,61392-0234-90 ",.01)
 ;;61392-0234-90
 ;;9002226.02101,"869,61392-0234-90 ",.02)
 ;;61392-0234-90
 ;;9002226.02101,"869,61392-0234-91 ",.01)
 ;;61392-0234-91
 ;;9002226.02101,"869,61392-0234-91 ",.02)
 ;;61392-0234-91
 ;;9002226.02101,"869,61392-0235-15 ",.01)
 ;;61392-0235-15
 ;;9002226.02101,"869,61392-0235-15 ",.02)
 ;;61392-0235-15
 ;;9002226.02101,"869,61392-0235-30 ",.01)
 ;;61392-0235-30
 ;;9002226.02101,"869,61392-0235-30 ",.02)
 ;;61392-0235-30
 ;;9002226.02101,"869,61392-0235-45 ",.01)
 ;;61392-0235-45
 ;;9002226.02101,"869,61392-0235-45 ",.02)
 ;;61392-0235-45
 ;;9002226.02101,"869,61392-0235-51 ",.01)
 ;;61392-0235-51
 ;;9002226.02101,"869,61392-0235-51 ",.02)
 ;;61392-0235-51
 ;;9002226.02101,"869,61392-0235-54 ",.01)
 ;;61392-0235-54
 ;;9002226.02101,"869,61392-0235-54 ",.02)
 ;;61392-0235-54
 ;;9002226.02101,"869,61392-0235-56 ",.01)
 ;;61392-0235-56
 ;;9002226.02101,"869,61392-0235-56 ",.02)
 ;;61392-0235-56
 ;;9002226.02101,"869,61392-0235-60 ",.01)
 ;;61392-0235-60
 ;;9002226.02101,"869,61392-0235-60 ",.02)
 ;;61392-0235-60
 ;;9002226.02101,"869,61392-0235-90 ",.01)
 ;;61392-0235-90
 ;;9002226.02101,"869,61392-0235-90 ",.02)
 ;;61392-0235-90
 ;;9002226.02101,"869,61392-0235-91 ",.01)
 ;;61392-0235-91
 ;;9002226.02101,"869,61392-0235-91 ",.02)
 ;;61392-0235-91
 ;;9002226.02101,"869,61392-0361-45 ",.01)
 ;;61392-0361-45
 ;;9002226.02101,"869,61392-0361-45 ",.02)
 ;;61392-0361-45
 ;;9002226.02101,"869,61392-0361-56 ",.01)
 ;;61392-0361-56
 ;;9002226.02101,"869,61392-0361-56 ",.02)
 ;;61392-0361-56
 ;;9002226.02101,"869,61392-0361-91 ",.01)
 ;;61392-0361-91
 ;;9002226.02101,"869,61392-0361-91 ",.02)
 ;;61392-0361-91
 ;;9002226.02101,"869,61392-0364-45 ",.01)
 ;;61392-0364-45
 ;;9002226.02101,"869,61392-0364-45 ",.02)
 ;;61392-0364-45
 ;;9002226.02101,"869,61392-0364-56 ",.01)
 ;;61392-0364-56
 ;;9002226.02101,"869,61392-0364-56 ",.02)
 ;;61392-0364-56
 ;;9002226.02101,"869,61392-0364-91 ",.01)
 ;;61392-0364-91
 ;;9002226.02101,"869,61392-0364-91 ",.02)
 ;;61392-0364-91
 ;;9002226.02101,"869,61392-0367-45 ",.01)
 ;;61392-0367-45
 ;;9002226.02101,"869,61392-0367-45 ",.02)
 ;;61392-0367-45
 ;;9002226.02101,"869,61392-0367-56 ",.01)
 ;;61392-0367-56
 ;;9002226.02101,"869,61392-0367-56 ",.02)
 ;;61392-0367-56
 ;;9002226.02101,"869,61392-0367-91 ",.01)
 ;;61392-0367-91
 ;;9002226.02101,"869,61392-0367-91 ",.02)
 ;;61392-0367-91
 ;;9002226.02101,"869,61392-0370-45 ",.01)
 ;;61392-0370-45
 ;;9002226.02101,"869,61392-0370-45 ",.02)
 ;;61392-0370-45
 ;;9002226.02101,"869,61392-0370-54 ",.01)
 ;;61392-0370-54
 ;;9002226.02101,"869,61392-0370-54 ",.02)
 ;;61392-0370-54
 ;;9002226.02101,"869,61392-0370-56 ",.01)
 ;;61392-0370-56
 ;;9002226.02101,"869,61392-0370-56 ",.02)
 ;;61392-0370-56
 ;;9002226.02101,"869,61392-0370-91 ",.01)
 ;;61392-0370-91
 ;;9002226.02101,"869,61392-0370-91 ",.02)
 ;;61392-0370-91
 ;;9002226.02101,"869,61392-0487-45 ",.01)
 ;;61392-0487-45
 ;;9002226.02101,"869,61392-0487-45 ",.02)
 ;;61392-0487-45
 ;;9002226.02101,"869,61392-0487-56 ",.01)
 ;;61392-0487-56
 ;;9002226.02101,"869,61392-0487-56 ",.02)
 ;;61392-0487-56
 ;;9002226.02101,"869,61392-0487-91 ",.01)
 ;;61392-0487-91
 ;;9002226.02101,"869,61392-0487-91 ",.02)
 ;;61392-0487-91
 ;;9002226.02101,"869,61392-0490-15 ",.01)
 ;;61392-0490-15
 ;;9002226.02101,"869,61392-0490-15 ",.02)
 ;;61392-0490-15
 ;;9002226.02101,"869,61392-0490-45 ",.01)
 ;;61392-0490-45
 ;;9002226.02101,"869,61392-0490-45 ",.02)
 ;;61392-0490-45
 ;;9002226.02101,"869,61392-0490-56 ",.01)
 ;;61392-0490-56
 ;;9002226.02101,"869,61392-0490-56 ",.02)
 ;;61392-0490-56
 ;;9002226.02101,"869,61392-0490-91 ",.01)
 ;;61392-0490-91
 ;;9002226.02101,"869,61392-0490-91 ",.02)
 ;;61392-0490-91
 ;;9002226.02101,"869,61392-0491-30 ",.01)
 ;;61392-0491-30
 ;;9002226.02101,"869,61392-0491-30 ",.02)
 ;;61392-0491-30
 ;;9002226.02101,"869,61392-0491-31 ",.01)
 ;;61392-0491-31
 ;;9002226.02101,"869,61392-0491-31 ",.02)
 ;;61392-0491-31
 ;;9002226.02101,"869,61392-0491-32 ",.01)
 ;;61392-0491-32
 ;;9002226.02101,"869,61392-0491-32 ",.02)
 ;;61392-0491-32
 ;;9002226.02101,"869,61392-0491-39 ",.01)
 ;;61392-0491-39
 ;;9002226.02101,"869,61392-0491-39 ",.02)
 ;;61392-0491-39
 ;;9002226.02101,"869,61392-0491-45 ",.01)
 ;;61392-0491-45
 ;;9002226.02101,"869,61392-0491-45 ",.02)
 ;;61392-0491-45
 ;;9002226.02101,"869,61392-0491-51 ",.01)
 ;;61392-0491-51
 ;;9002226.02101,"869,61392-0491-51 ",.02)
 ;;61392-0491-51
 ;;9002226.02101,"869,61392-0491-54 ",.01)
 ;;61392-0491-54
 ;;9002226.02101,"869,61392-0491-54 ",.02)
 ;;61392-0491-54
 ;;9002226.02101,"869,61392-0491-60 ",.01)
 ;;61392-0491-60
 ;;9002226.02101,"869,61392-0491-60 ",.02)
 ;;61392-0491-60
 ;;9002226.02101,"869,61392-0491-90 ",.01)
 ;;61392-0491-90
 ;;9002226.02101,"869,61392-0491-90 ",.02)
 ;;61392-0491-90
 ;;9002226.02101,"869,61392-0491-91 ",.01)
 ;;61392-0491-91
 ;;9002226.02101,"869,61392-0491-91 ",.02)
 ;;61392-0491-91
 ;;9002226.02101,"869,61392-0726-32 ",.01)
 ;;61392-0726-32
 ;;9002226.02101,"869,61392-0726-32 ",.02)
 ;;61392-0726-32
 ;;9002226.02101,"869,61392-0726-45 ",.01)
 ;;61392-0726-45
 ;;9002226.02101,"869,61392-0726-45 ",.02)
 ;;61392-0726-45
 ;;9002226.02101,"869,61392-0726-51 ",.01)
 ;;61392-0726-51
 ;;9002226.02101,"869,61392-0726-51 ",.02)
 ;;61392-0726-51
 ;;9002226.02101,"869,61392-0726-54 ",.01)
 ;;61392-0726-54
 ;;9002226.02101,"869,61392-0726-54 ",.02)
 ;;61392-0726-54
 ;;9002226.02101,"869,61392-0726-91 ",.01)
 ;;61392-0726-91
 ;;9002226.02101,"869,61392-0726-91 ",.02)
 ;;61392-0726-91
 ;;9002226.02101,"869,61392-0727-31 ",.01)
 ;;61392-0727-31
 ;;9002226.02101,"869,61392-0727-31 ",.02)
 ;;61392-0727-31
 ;;9002226.02101,"869,61392-0727-32 ",.01)
 ;;61392-0727-32
 ;;9002226.02101,"869,61392-0727-32 ",.02)
 ;;61392-0727-32
 ;;9002226.02101,"869,61392-0727-45 ",.01)
 ;;61392-0727-45
 ;;9002226.02101,"869,61392-0727-45 ",.02)
 ;;61392-0727-45
 ;;9002226.02101,"869,61392-0727-51 ",.01)
 ;;61392-0727-51
 ;;9002226.02101,"869,61392-0727-51 ",.02)
 ;;61392-0727-51
 ;;9002226.02101,"869,61392-0727-54 ",.01)
 ;;61392-0727-54
 ;;9002226.02101,"869,61392-0727-54 ",.02)
 ;;61392-0727-54
 ;;9002226.02101,"869,61392-0727-90 ",.01)
 ;;61392-0727-90
 ;;9002226.02101,"869,61392-0727-90 ",.02)
 ;;61392-0727-90
 ;;9002226.02101,"869,61392-0727-91 ",.01)
 ;;61392-0727-91
 ;;9002226.02101,"869,61392-0727-91 ",.02)
 ;;61392-0727-91
 ;;9002226.02101,"869,61392-0728-45 ",.01)
 ;;61392-0728-45
 ;;9002226.02101,"869,61392-0728-45 ",.02)
 ;;61392-0728-45
 ;;9002226.02101,"869,61392-0728-51 ",.01)
 ;;61392-0728-51
 ;;9002226.02101,"869,61392-0728-51 ",.02)
 ;;61392-0728-51
 ;;9002226.02101,"869,61392-0728-54 ",.01)
 ;;61392-0728-54
 ;;9002226.02101,"869,61392-0728-54 ",.02)
 ;;61392-0728-54
 ;;9002226.02101,"869,61392-0728-91 ",.01)
 ;;61392-0728-91
 ;;9002226.02101,"869,61392-0728-91 ",.02)
 ;;61392-0728-91
 ;;9002226.02101,"869,61392-0729-30 ",.01)
 ;;61392-0729-30
 ;;9002226.02101,"869,61392-0729-30 ",.02)
 ;;61392-0729-30
 ;;9002226.02101,"869,61392-0729-32 ",.01)
 ;;61392-0729-32
 ;;9002226.02101,"869,61392-0729-32 ",.02)
 ;;61392-0729-32
 ;;9002226.02101,"869,61392-0729-45 ",.01)
 ;;61392-0729-45
 ;;9002226.02101,"869,61392-0729-45 ",.02)
 ;;61392-0729-45
 ;;9002226.02101,"869,61392-0729-51 ",.01)
 ;;61392-0729-51
 ;;9002226.02101,"869,61392-0729-51 ",.02)
 ;;61392-0729-51
 ;;9002226.02101,"869,61392-0729-54 ",.01)
 ;;61392-0729-54
 ;;9002226.02101,"869,61392-0729-54 ",.02)
 ;;61392-0729-54
 ;;9002226.02101,"869,61392-0729-60 ",.01)
 ;;61392-0729-60
 ;;9002226.02101,"869,61392-0729-60 ",.02)
 ;;61392-0729-60
 ;;9002226.02101,"869,61392-0729-91 ",.01)
 ;;61392-0729-91
 ;;9002226.02101,"869,61392-0729-91 ",.02)
 ;;61392-0729-91
 ;;9002226.02101,"869,61392-0730-30 ",.01)
 ;;61392-0730-30
 ;;9002226.02101,"869,61392-0730-30 ",.02)
 ;;61392-0730-30
 ;;9002226.02101,"869,61392-0730-31 ",.01)
 ;;61392-0730-31
 ;;9002226.02101,"869,61392-0730-31 ",.02)
 ;;61392-0730-31
 ;;9002226.02101,"869,61392-0730-32 ",.01)
 ;;61392-0730-32
 ;;9002226.02101,"869,61392-0730-32 ",.02)
 ;;61392-0730-32
 ;;9002226.02101,"869,61392-0730-39 ",.01)
 ;;61392-0730-39
 ;;9002226.02101,"869,61392-0730-39 ",.02)
 ;;61392-0730-39
 ;;9002226.02101,"869,61392-0730-45 ",.01)
 ;;61392-0730-45
 ;;9002226.02101,"869,61392-0730-45 ",.02)
 ;;61392-0730-45
 ;;9002226.02101,"869,61392-0730-51 ",.01)
 ;;61392-0730-51
 ;;9002226.02101,"869,61392-0730-51 ",.02)
 ;;61392-0730-51
 ;;9002226.02101,"869,61392-0730-60 ",.01)
 ;;61392-0730-60
 ;;9002226.02101,"869,61392-0730-60 ",.02)
 ;;61392-0730-60
 ;;9002226.02101,"869,61392-0730-90 ",.01)
 ;;61392-0730-90
 ;;9002226.02101,"869,61392-0730-90 ",.02)
 ;;61392-0730-90
 ;;9002226.02101,"869,61392-0730-91 ",.01)
 ;;61392-0730-91
 ;;9002226.02101,"869,61392-0730-91 ",.02)
 ;;61392-0730-91
 ;;9002226.02101,"869,62037-0539-05 ",.01)
 ;;62037-0539-05
 ;;9002226.02101,"869,62037-0539-05 ",.02)
 ;;62037-0539-05
 ;;9002226.02101,"869,62037-0539-10 ",.01)
 ;;62037-0539-10
 ;;9002226.02101,"869,62037-0539-10 ",.02)
 ;;62037-0539-10
 ;;9002226.02101,"869,62037-0753-10 ",.01)
 ;;62037-0753-10
 ;;9002226.02101,"869,62037-0753-10 ",.02)
 ;;62037-0753-10
 ;;9002226.02101,"869,62037-0753-30 ",.01)
 ;;62037-0753-30
 ;;9002226.02101,"869,62037-0753-30 ",.02)
 ;;62037-0753-30
 ;;9002226.02101,"869,62037-0754-10 ",.01)
 ;;62037-0754-10
 ;;9002226.02101,"869,62037-0754-10 ",.02)
 ;;62037-0754-10
 ;;9002226.02101,"869,62037-0754-30 ",.01)
 ;;62037-0754-30
 ;;9002226.02101,"869,62037-0754-30 ",.02)
 ;;62037-0754-30
 ;;9002226.02101,"869,62037-0755-10 ",.01)
 ;;62037-0755-10
 ;;9002226.02101,"869,62037-0755-10 ",.02)
 ;;62037-0755-10
 ;;9002226.02101,"869,62037-0755-30 ",.01)
 ;;62037-0755-30
 ;;9002226.02101,"869,62037-0755-30 ",.02)
 ;;62037-0755-30
 ;;9002226.02101,"869,62037-0845-30 ",.01)
 ;;62037-0845-30
 ;;9002226.02101,"869,62037-0845-30 ",.02)
 ;;62037-0845-30
 ;;9002226.02101,"869,62037-0846-01 ",.01)
 ;;62037-0846-01
 ;;9002226.02101,"869,62037-0846-01 ",.02)
 ;;62037-0846-01
 ;;9002226.02101,"869,62037-0846-10 ",.01)
 ;;62037-0846-10
 ;;9002226.02101,"869,62037-0846-10 ",.02)
 ;;62037-0846-10
 ;;9002226.02101,"869,62037-0846-30 ",.01)
 ;;62037-0846-30
 ;;9002226.02101,"869,62037-0846-30 ",.02)
 ;;62037-0846-30