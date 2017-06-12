BGP61D3 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"42549-0559-60 ")
 ;;736
 ;;21,"42549-0641-30 ")
 ;;737
 ;;21,"42549-0641-60 ")
 ;;738
 ;;21,"42549-0641-90 ")
 ;;739
 ;;21,"42549-0650-30 ")
 ;;740
 ;;21,"42549-0652-30 ")
 ;;741
 ;;21,"42549-0652-60 ")
 ;;742
 ;;21,"42549-0652-90 ")
 ;;743
 ;;21,"42549-0682-07 ")
 ;;744
 ;;21,"42549-0682-15 ")
 ;;745
 ;;21,"42549-0682-20 ")
 ;;746
 ;;21,"42549-0682-28 ")
 ;;747
 ;;21,"42549-0682-30 ")
 ;;748
 ;;21,"42549-0682-40 ")
 ;;749
 ;;21,"42549-0682-45 ")
 ;;750
 ;;21,"42549-0682-56 ")
 ;;751
 ;;21,"42549-0682-60 ")
 ;;752
 ;;21,"42549-0682-62 ")
 ;;753
 ;;21,"42549-0682-72 ")
 ;;754
 ;;21,"42549-0682-82 ")
 ;;755
 ;;21,"42549-0682-84 ")
 ;;756
 ;;21,"42549-0682-90 ")
 ;;757
 ;;21,"43063-0050-03 ")
 ;;758
 ;;21,"43063-0050-04 ")
 ;;759
 ;;21,"43063-0050-06 ")
 ;;760
 ;;21,"43063-0239-10 ")
 ;;761
 ;;21,"43063-0239-15 ")
 ;;762
 ;;21,"43063-0239-20 ")
 ;;763
 ;;21,"43063-0239-21 ")
 ;;764
 ;;21,"43063-0239-30 ")
 ;;765
 ;;21,"43063-0239-40 ")
 ;;766
 ;;21,"43063-0239-60 ")
 ;;767
 ;;21,"43063-0239-90 ")
 ;;768
 ;;21,"43063-0239-98 ")
 ;;769
 ;;21,"43063-0302-10 ")
 ;;770
 ;;21,"43063-0302-14 ")
 ;;771
 ;;21,"43063-0302-15 ")
 ;;772
 ;;21,"43063-0302-20 ")
 ;;773
 ;;21,"43063-0302-21 ")
 ;;774
 ;;21,"43063-0302-24 ")
 ;;775
 ;;21,"43063-0302-30 ")
 ;;776
 ;;21,"43063-0302-40 ")
 ;;777
 ;;21,"43063-0302-60 ")
 ;;778
 ;;21,"43063-0302-98 ")
 ;;779
 ;;21,"43063-0407-20 ")
 ;;780
 ;;21,"43063-0407-30 ")
 ;;781
 ;;21,"43063-0407-60 ")
 ;;782
 ;;21,"43063-0409-01 ")
 ;;783
 ;;21,"43063-0409-10 ")
 ;;784
 ;;21,"43063-0409-14 ")
 ;;785
 ;;21,"43063-0409-15 ")
 ;;786
 ;;21,"43063-0409-20 ")
 ;;787
 ;;21,"43063-0409-28 ")
 ;;788
 ;;21,"43063-0409-30 ")
 ;;789
 ;;21,"43063-0409-40 ")
 ;;790
 ;;21,"43063-0409-60 ")
 ;;791
 ;;21,"43063-0409-90 ")
 ;;792
 ;;21,"43063-0409-93 ")
 ;;793
 ;;21,"43063-0419-01 ")
 ;;794
 ;;21,"43063-0419-10 ")
 ;;795
 ;;21,"43063-0419-12 ")
 ;;796
 ;;21,"43063-0419-14 ")
 ;;797
 ;;21,"43063-0419-20 ")
 ;;798
 ;;21,"43063-0419-24 ")
 ;;799
 ;;21,"43063-0419-28 ")
 ;;800
 ;;21,"43063-0419-30 ")
 ;;801
 ;;21,"43063-0419-40 ")
 ;;802
 ;;21,"43063-0419-60 ")
 ;;803
 ;;21,"43063-0419-90 ")
 ;;804
 ;;21,"43063-0419-93 ")
 ;;805
 ;;21,"43063-0460-10 ")
 ;;806
 ;;21,"43063-0460-90 ")
 ;;807
 ;;21,"43063-0494-10 ")
 ;;808
 ;;21,"43063-0494-14 ")
 ;;809
 ;;21,"43063-0494-15 ")
 ;;810
 ;;21,"43063-0494-21 ")
 ;;811
 ;;21,"43063-0494-30 ")
 ;;812
 ;;21,"43063-0494-60 ")
 ;;813
 ;;21,"43063-0516-03 ")
 ;;814
 ;;21,"43063-0516-04 ")
 ;;815
 ;;21,"43063-0516-06 ")
 ;;816
 ;;21,"43063-0516-09 ")
 ;;817
 ;;21,"43063-0516-10 ")
 ;;818
 ;;21,"43063-0516-12 ")
 ;;819
 ;;21,"43063-0516-14 ")
 ;;820
 ;;21,"43063-0516-15 ")
 ;;821
 ;;21,"43063-0516-20 ")
 ;;822
 ;;21,"43063-0516-21 ")
 ;;823
 ;;21,"43063-0516-30 ")
 ;;824
 ;;21,"43063-0516-42 ")
 ;;825
 ;;21,"43063-0516-60 ")
 ;;826
 ;;21,"43063-0516-90 ")
 ;;827
 ;;21,"43093-0101-01 ")
 ;;828
 ;;21,"43353-0183-21 ")
 ;;829
 ;;21,"43353-0183-30 ")
 ;;830
 ;;21,"43353-0183-45 ")
 ;;831
 ;;21,"43353-0183-53 ")
 ;;832
 ;;21,"43353-0183-60 ")
 ;;833
 ;;21,"43353-0183-80 ")
 ;;834
 ;;21,"43353-0183-92 ")
 ;;835
 ;;21,"43353-0436-53 ")
 ;;836
 ;;21,"43353-0436-60 ")
 ;;837
 ;;21,"43353-0436-70 ")
 ;;838
 ;;21,"43353-0436-80 ")
 ;;839
 ;;21,"43353-0779-30 ")
 ;;840
 ;;21,"43353-0779-53 ")
 ;;841
 ;;21,"43353-0779-60 ")
 ;;842
 ;;21,"43353-0779-70 ")
 ;;843
 ;;21,"43353-0779-80 ")
 ;;844
 ;;21,"43353-0779-90 ")
 ;;845
 ;;21,"43353-0779-92 ")
 ;;846
 ;;21,"43353-0791-53 ")
 ;;847
 ;;21,"43353-0791-60 ")
 ;;848
 ;;21,"43353-0791-70 ")
 ;;849
 ;;21,"43353-0948-30 ")
 ;;850
 ;;21,"43353-0948-53 ")
 ;;851
 ;;21,"43353-0948-60 ")
 ;;852
 ;;21,"43353-0948-70 ")
 ;;853
 ;;21,"43353-0948-80 ")
 ;;854
 ;;21,"43353-0948-90 ")
 ;;855
 ;;21,"43353-0948-92 ")
 ;;856
 ;;21,"43353-0949-53 ")
 ;;857
 ;;21,"43353-0949-60 ")
 ;;858
 ;;21,"43353-0949-70 ")
 ;;859
 ;;21,"43353-0949-80 ")
 ;;860
 ;;21,"43386-0480-24 ")
 ;;861
 ;;21,"43386-0480-26 ")
 ;;862
 ;;21,"43386-0480-28 ")
 ;;863
 ;;21,"43547-0225-10 ")
 ;;864
 ;;21,"43547-0225-50 ")
 ;;865
 ;;21,"43547-0226-10 ")
 ;;866
 ;;21,"43547-0226-50 ")
 ;;867
 ;;21,"43683-0120-30 ")
 ;;868
 ;;21,"45861-0013-00 ")
 ;;869
 ;;21,"45861-0103-01 ")
 ;;870
 ;;21,"45861-0112-01 ")
 ;;871
 ;;21,"45861-0112-02 ")
 ;;872
 ;;21,"45861-0112-03 ")
 ;;873
 ;;21,"47463-0055-15 ")
 ;;874
 ;;21,"47463-0055-20 ")
 ;;875
 ;;21,"47463-0055-30 ")
 ;;876
 ;;21,"47463-0055-40 ")
 ;;877
 ;;21,"47463-0055-60 ")
 ;;878
 ;;21,"47463-0055-71 ")
 ;;879
 ;;21,"47463-0055-90 ")
 ;;880
 ;;21,"47463-0080-15 ")
 ;;881
 ;;21,"47463-0080-20 ")
 ;;882
 ;;21,"47463-0080-30 ")
 ;;883
 ;;21,"47463-0080-40 ")
 ;;884
 ;;21,"47463-0080-60 ")
 ;;885
 ;;21,"47463-0080-71 ")
 ;;886
 ;;21,"47463-0080-90 ")
 ;;887
 ;;21,"47463-0081-30 ")
 ;;888
 ;;21,"47463-0082-30 ")
 ;;889
 ;;21,"47463-0082-40 ")
 ;;890
 ;;21,"47463-0082-60 ")
 ;;891
 ;;21,"47463-0082-90 ")
 ;;892
 ;;21,"47463-0107-90 ")
 ;;893
 ;;21,"47463-0263-90 ")
 ;;894
 ;;21,"47463-0507-60 ")
 ;;895
 ;;21,"47463-0507-84 ")
 ;;896
 ;;21,"47463-0507-90 ")
 ;;897
 ;;21,"47463-0514-30 ")
 ;;898
 ;;21,"47463-0514-60 ")
 ;;899
 ;;21,"47463-0514-90 ")
 ;;900
 ;;21,"47463-0515-20 ")
 ;;901
 ;;21,"47463-0515-30 ")
 ;;902
 ;;21,"47463-0515-60 ")
 ;;903
 ;;21,"47463-0515-71 ")
 ;;904
 ;;21,"47463-0515-90 ")
 ;;905
 ;;21,"47463-0616-90 ")
 ;;906
 ;;21,"47463-0622-60 ")
 ;;907
 ;;21,"47463-0848-90 ")
 ;;908
 ;;21,"47463-0849-60 ")
 ;;909
 ;;21,"47463-0849-90 ")
 ;;910
 ;;21,"49999-0034-01 ")
 ;;911
 ;;21,"49999-0034-07 ")
 ;;912
 ;;21,"49999-0034-10 ")
 ;;913
 ;;21,"49999-0034-12 ")
 ;;914
 ;;21,"49999-0034-15 ")
 ;;915
 ;;21,"49999-0034-20 ")
 ;;916
 ;;21,"49999-0034-21 ")
 ;;917
 ;;21,"49999-0034-30 ")
 ;;918
 ;;21,"49999-0034-60 ")
 ;;919
 ;;21,"49999-0034-90 ")
 ;;920
 ;;21,"49999-0044-10 ")
 ;;921
 ;;21,"49999-0044-14 ")
 ;;922
 ;;21,"49999-0044-15 ")
 ;;923
 ;;21,"49999-0044-18 ")
 ;;924
 ;;21,"49999-0044-20 ")
 ;;925
 ;;21,"49999-0044-30 ")
 ;;926
 ;;21,"49999-0044-40 ")
 ;;927
 ;;21,"49999-0044-60 ")
 ;;928
 ;;21,"49999-0044-90 ")
 ;;929
 ;;21,"49999-0046-14 ")
 ;;930
 ;;21,"49999-0046-20 ")
 ;;931
 ;;21,"49999-0046-30 ")
 ;;932
 ;;21,"49999-0046-60 ")
 ;;933
 ;;21,"49999-0048-01 ")
 ;;934
 ;;21,"49999-0048-20 ")
 ;;935
 ;;21,"49999-0048-30 ")
 ;;936
 ;;21,"49999-0048-40 ")
 ;;937
 ;;21,"49999-0048-60 ")
 ;;938
 ;;21,"49999-0048-90 ")
 ;;939
 ;;21,"49999-0064-00 ")
 ;;940
 ;;21,"49999-0064-01 ")
 ;;941
 ;;21,"49999-0064-06 ")
 ;;942
 ;;21,"49999-0064-07 ")
 ;;943
 ;;21,"49999-0064-10 ")
 ;;944
 ;;21,"49999-0064-14 ")
 ;;945
 ;;21,"49999-0064-15 ")
 ;;946
 ;;21,"49999-0064-18 ")
 ;;947
 ;;21,"49999-0064-20 ")
 ;;948
 ;;21,"49999-0064-30 ")
 ;;949
 ;;21,"49999-0064-40 ")
 ;;950
 ;;21,"49999-0064-50 ")
 ;;951
 ;;21,"49999-0064-60 ")
 ;;952
 ;;21,"49999-0064-90 ")
 ;;953
 ;;21,"49999-0065-01 ")
 ;;954
 ;;21,"49999-0065-12 ")
 ;;955
 ;;21,"49999-0065-20 ")
 ;;956
 ;;21,"49999-0065-30 ")
 ;;957
 ;;21,"49999-0065-40 ")
 ;;958
 ;;21,"49999-0065-60 ")
 ;;959
 ;;21,"49999-0065-90 ")
 ;;960
 ;;21,"49999-0363-01 ")
 ;;961
 ;;21,"49999-0363-15 ")
 ;;962
 ;;21,"49999-0363-16 ")
 ;;963
 ;;21,"49999-0363-18 ")
 ;;964
 ;;21,"49999-0363-20 ")
 ;;965
 ;;21,"49999-0363-30 ")
 ;;966
 ;;21,"49999-0363-60 ")
 ;;967
 ;;21,"49999-0363-90 ")
 ;;968
 ;;21,"49999-0791-00 ")
 ;;969
 ;;21,"49999-0791-21 ")
 ;;970
 ;;21,"49999-0791-30 ")
 ;;971
 ;;21,"50111-0563-01 ")
 ;;972
 ;;21,"50111-0563-02 ")
 ;;973
 ;;21,"50111-0563-03 ")
 ;;974
 ;;21,"50268-0190-11 ")
 ;;975
 ;;21,"50268-0190-15 ")
 ;;976
 ;;21,"50268-0530-11 ")
 ;;977
 ;;21,"50268-0530-15 ")
 ;;978
 ;;21,"50268-0536-11 ")
 ;;979
 ;;21,"50268-0536-15 ")
 ;;980
 ;;21,"50268-0537-11 ")
 ;;981
 ;;21,"50268-0537-15 ")
 ;;982
 ;;21,"50436-3024-01 ")
 ;;983
 ;;21,"50436-3024-02 ")
 ;;984
 ;;21,"50436-3024-03 ")
 ;;985
 ;;21,"50436-3435-01 ")
 ;;986
 ;;21,"50436-3435-02 ")
 ;;987
 ;;21,"50436-3435-03 ")
 ;;988
 ;;21,"50436-3435-04 ")
 ;;989
 ;;21,"50436-3444-03 ")
 ;;990
 ;;21,"50436-3444-04 ")
 ;;991
 ;;21,"50436-4026-01 ")
 ;;992
 ;;21,"50436-4026-03 ")
 ;;993
 ;;21,"50436-4027-01 ")
 ;;994
 ;;21,"50436-4027-02 ")
 ;;995
 ;;21,"50436-4027-03 ")
 ;;996
 ;;21,"50436-4027-04 ")
 ;;997
 ;;21,"50436-4027-05 ")
 ;;998
 ;;21,"50436-4841-01 ")
 ;;999
 ;;21,"50436-4841-02 ")
 ;;1000
 ;;21,"50436-4841-03 ")
 ;;1001
 ;;21,"50436-4841-04 ")
 ;;1002
 ;;21,"50436-4842-01 ")
 ;;1003
 ;;21,"50436-4842-02 ")
 ;;1004
 ;;21,"50436-4842-03 ")
 ;;1005
 ;;21,"50436-4842-04 ")
 ;;1006
 ;;21,"50436-7601-01 ")
 ;;1007
 ;;21,"50436-9802-01 ")
 ;;1008
 ;;21,"50436-9802-03 ")
 ;;1009
 ;;21,"50436-9802-05 ")
 ;;1010
 ;;21,"50436-9802-06 ")
 ;;1011
 ;;21,"50458-0625-60 ")
 ;;1012
 ;;21,"51079-0644-01 ")
 ;;1013
 ;;21,"51079-0644-17 ")
 ;;1014
 ;;21,"51079-0644-19 ")
 ;;1015
 ;;21,"51079-0644-20 ")
 ;;1016
 ;;21,"51079-0819-01 ")
 ;;1017
 ;;21,"51079-0819-20 ")
 ;;1018
 ;;21,"51525-5901-01 ")
 ;;1019
 ;;21,"51655-0376-52 ")
 ;;1020
 ;;21,"51655-0440-54 ")
 ;;1021
 ;;21,"51991-0467-01 ")
 ;;1022
 ;;21,"51991-0468-01 ")
 ;;1023
 ;;21,"51991-0468-10 ")
 ;;1024
 ;;21,"52244-0429-10 ")
 ;;1025
 ;;21,"52244-0449-10 ")
 ;;1026
 ;;21,"52959-0026-00 ")
 ;;1027
 ;;21,"52959-0026-03 ")
 ;;1028
 ;;21,"52959-0026-06 ")
 ;;1029
 ;;21,"52959-0026-10 ")
 ;;1030
 ;;21,"52959-0026-12 ")
 ;;1031
 ;;21,"52959-0026-14 ")
 ;;1032
 ;;21,"52959-0026-15 ")
 ;;1033
 ;;21,"52959-0026-20 ")
 ;;1034
 ;;21,"52959-0026-21 ")
 ;;1035
 ;;21,"52959-0026-24 ")
 ;;1036
 ;;21,"52959-0026-25 ")
 ;;1037
 ;;21,"52959-0026-28 ")
 ;;1038
 ;;21,"52959-0026-30 ")
 ;;1039
 ;;21,"52959-0026-32 ")
 ;;1040
 ;;21,"52959-0026-40 ")
 ;;1041
 ;;21,"52959-0026-45 ")
 ;;1042
 ;;21,"52959-0026-50 ")
 ;;1043
 ;;21,"52959-0026-52 ")
 ;;1044
 ;;21,"52959-0026-56 ")
 ;;1045
 ;;21,"52959-0026-60 ")
 ;;1046
 ;;21,"52959-0026-80 ")
 ;;1047
 ;;21,"52959-0026-90 ")
 ;;1048
 ;;21,"52959-0035-00 ")
 ;;1049
 ;;21,"52959-0035-01 ")
 ;;1050
 ;;21,"52959-0035-10 ")
 ;;1051
 ;;21,"52959-0035-20 ")
 ;;1052
 ;;21,"52959-0035-21 ")
 ;;1053
 ;;21,"52959-0035-28 ")
 ;;1054
 ;;21,"52959-0035-30 ")
 ;;1055
 ;;21,"52959-0035-40 ")
 ;;1056
 ;;21,"52959-0035-56 ")
 ;;1057
 ;;21,"52959-0035-60 ")
 ;;1058
 ;;21,"52959-0035-70 ")
 ;;1059
 ;;21,"52959-0035-90 ")
 ;;1060
 ;;21,"52959-0042-00 ")
 ;;1061
 ;;21,"52959-0042-02 ")
 ;;1062
 ;;21,"52959-0042-04 ")
 ;;1063
 ;;21,"52959-0042-07 ")
 ;;1064
 ;;21,"52959-0042-10 ")
 ;;1065
 ;;21,"52959-0042-12 ")
 ;;1066
 ;;21,"52959-0042-14 ")
 ;;1067
 ;;21,"52959-0042-15 ")
 ;;1068
 ;;21,"52959-0042-20 ")
 ;;1069
 ;;21,"52959-0042-21 ")
 ;;1070
 ;;21,"52959-0042-25 ")
 ;;1071
 ;;21,"52959-0042-28 ")
 ;;1072
 ;;21,"52959-0042-30 ")
 ;;1073
 ;;21,"52959-0042-35 ")
 ;;1074
 ;;21,"52959-0042-40 ")
 ;;1075
 ;;21,"52959-0042-45 ")
 ;;1076
 ;;21,"52959-0042-60 ")
 ;;1077
 ;;21,"52959-0042-90 ")
 ;;1078
 ;;21,"52959-0099-00 ")
 ;;1079
 ;;21,"52959-0099-03 ")
 ;;1080
 ;;21,"52959-0099-10 ")
 ;;1081
 ;;21,"52959-0099-15 ")
 ;;1082
 ;;21,"52959-0099-20 ")
 ;;1083
 ;;21,"52959-0099-21 ")
 ;;1084
 ;;21,"52959-0099-28 ")
 ;;1085
 ;;21,"52959-0099-30 ")
 ;;1086
 ;;21,"52959-0099-40 ")
 ;;1087
 ;;21,"52959-0099-45 ")
 ;;1088
 ;;21,"52959-0099-50 ")
 ;;1089
 ;;21,"52959-0099-60 ")
 ;;1090
 ;;21,"52959-0099-90 ")
 ;;1091
 ;;21,"52959-0167-00 ")
 ;;1092
 ;;21,"52959-0167-03 ")
 ;;1093
 ;;21,"52959-0167-10 ")
 ;;1094
 ;;21,"52959-0167-12 ")
 ;;1095
 ;;21,"52959-0167-15 ")
 ;;1096
 ;;21,"52959-0167-20 ")
 ;;1097
 ;;21,"52959-0167-21 ")
 ;;1098
 ;;21,"52959-0167-24 ")
 ;;1099
 ;;21,"52959-0167-30 ")
 ;;1100
 ;;21,"52959-0167-40 ")
 ;;1101