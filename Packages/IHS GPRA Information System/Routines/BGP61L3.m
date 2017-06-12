BGP61L3 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"35356-0303-01 ")
 ;;736
 ;;21,"35356-0304-01 ")
 ;;737
 ;;21,"35356-0305-01 ")
 ;;738
 ;;21,"35356-0360-30 ")
 ;;739
 ;;21,"35356-0360-60 ")
 ;;740
 ;;21,"35356-0360-90 ")
 ;;741
 ;;21,"35356-0691-60 ")
 ;;742
 ;;21,"35356-0792-30 ")
 ;;743
 ;;21,"35356-0875-30 ")
 ;;744
 ;;21,"35356-0875-60 ")
 ;;745
 ;;21,"35356-0886-30 ")
 ;;746
 ;;21,"35356-0886-60 ")
 ;;747
 ;;21,"35356-0886-90 ")
 ;;748
 ;;21,"35356-0896-30 ")
 ;;749
 ;;21,"35356-0897-30 ")
 ;;750
 ;;21,"35356-0897-60 ")
 ;;751
 ;;21,"35356-0899-30 ")
 ;;752
 ;;21,"35356-0899-60 ")
 ;;753
 ;;21,"35356-0899-90 ")
 ;;754
 ;;21,"35356-0922-60 ")
 ;;755
 ;;21,"35356-0931-30 ")
 ;;756
 ;;21,"35356-0931-60 ")
 ;;757
 ;;21,"35356-0931-90 ")
 ;;758
 ;;21,"35356-0932-30 ")
 ;;759
 ;;21,"35356-0932-60 ")
 ;;760
 ;;21,"35356-0932-90 ")
 ;;761
 ;;21,"35356-0959-30 ")
 ;;762
 ;;21,"35356-0959-60 ")
 ;;763
 ;;21,"35356-0959-90 ")
 ;;764
 ;;21,"35356-0970-30 ")
 ;;765
 ;;21,"35356-0970-60 ")
 ;;766
 ;;21,"35356-0970-90 ")
 ;;767
 ;;21,"35356-0995-30 ")
 ;;768
 ;;21,"35356-0995-60 ")
 ;;769
 ;;21,"35356-0995-90 ")
 ;;770
 ;;21,"42254-0071-30 ")
 ;;771
 ;;21,"42254-0090-30 ")
 ;;772
 ;;21,"42254-0090-60 ")
 ;;773
 ;;21,"42254-0090-90 ")
 ;;774
 ;;21,"42254-0281-30 ")
 ;;775
 ;;21,"42254-0281-90 ")
 ;;776
 ;;21,"42291-0305-01 ")
 ;;777
 ;;21,"42291-0306-01 ")
 ;;778
 ;;21,"42291-0316-50 ")
 ;;779
 ;;21,"42291-0317-10 ")
 ;;780
 ;;21,"42291-0592-60 ")
 ;;781
 ;;21,"42291-0593-60 ")
 ;;782
 ;;21,"42291-0605-10 ")
 ;;783
 ;;21,"42291-0605-12 ")
 ;;784
 ;;21,"42291-0605-18 ")
 ;;785
 ;;21,"42291-0605-27 ")
 ;;786
 ;;21,"42291-0605-36 ")
 ;;787
 ;;21,"42291-0605-45 ")
 ;;788
 ;;21,"42291-0605-60 ")
 ;;789
 ;;21,"42291-0605-90 ")
 ;;790
 ;;21,"42291-0606-10 ")
 ;;791
 ;;21,"42291-0606-18 ")
 ;;792
 ;;21,"42291-0606-27 ")
 ;;793
 ;;21,"42291-0606-90 ")
 ;;794
 ;;21,"42291-0607-10 ")
 ;;795
 ;;21,"42291-0607-18 ")
 ;;796
 ;;21,"42291-0607-60 ")
 ;;797
 ;;21,"42291-0607-90 ")
 ;;798
 ;;21,"42291-0610-10 ")
 ;;799
 ;;21,"42291-0610-18 ")
 ;;800
 ;;21,"42291-0610-36 ")
 ;;801
 ;;21,"42291-0610-90 ")
 ;;802
 ;;21,"42291-0611-18 ")
 ;;803
 ;;21,"42291-0611-27 ")
 ;;804
 ;;21,"42291-0611-50 ")
 ;;805
 ;;21,"42291-0611-90 ")
 ;;806
 ;;21,"42291-0693-60 ")
 ;;807
 ;;21,"42291-0694-60 ")
 ;;808
 ;;21,"42291-0719-90 ")
 ;;809
 ;;21,"42291-0720-90 ")
 ;;810
 ;;21,"42549-0498-30 ")
 ;;811
 ;;21,"42549-0499-30 ")
 ;;812
 ;;21,"42571-0100-01 ")
 ;;813
 ;;21,"42571-0100-05 ")
 ;;814
 ;;21,"42571-0101-01 ")
 ;;815
 ;;21,"42571-0101-05 ")
 ;;816
 ;;21,"42571-0103-01 ")
 ;;817
 ;;21,"42571-0103-05 ")
 ;;818
 ;;21,"43063-0012-01 ")
 ;;819
 ;;21,"43063-0012-60 ")
 ;;820
 ;;21,"43063-0012-86 ")
 ;;821
 ;;21,"43063-0012-90 ")
 ;;822
 ;;21,"43063-0012-93 ")
 ;;823
 ;;21,"43063-0012-94 ")
 ;;824
 ;;21,"43063-0034-30 ")
 ;;825
 ;;21,"43063-0034-90 ")
 ;;826
 ;;21,"43063-0119-90 ")
 ;;827
 ;;21,"43063-0120-90 ")
 ;;828
 ;;21,"43063-0121-30 ")
 ;;829
 ;;21,"43063-0121-90 ")
 ;;830
 ;;21,"43063-0122-30 ")
 ;;831
 ;;21,"43063-0122-90 ")
 ;;832
 ;;21,"43063-0372-30 ")
 ;;833
 ;;21,"43063-0397-86 ")
 ;;834
 ;;21,"43063-0428-30 ")
 ;;835
 ;;21,"43063-0428-90 ")
 ;;836
 ;;21,"43063-0428-93 ")
 ;;837
 ;;21,"43063-0428-94 ")
 ;;838
 ;;21,"43063-0429-93 ")
 ;;839
 ;;21,"43063-0429-94 ")
 ;;840
 ;;21,"43063-0430-30 ")
 ;;841
 ;;21,"43063-0430-60 ")
 ;;842
 ;;21,"43063-0430-90 ")
 ;;843
 ;;21,"43063-0430-93 ")
 ;;844
 ;;21,"43063-0430-94 ")
 ;;845
 ;;21,"43063-0430-98 ")
 ;;846
 ;;21,"43063-0433-14 ")
 ;;847
 ;;21,"43063-0433-30 ")
 ;;848
 ;;21,"43063-0433-86 ")
 ;;849
 ;;21,"43063-0433-90 ")
 ;;850
 ;;21,"43063-0433-93 ")
 ;;851
 ;;21,"43063-0507-30 ")
 ;;852
 ;;21,"43063-0507-60 ")
 ;;853
 ;;21,"43063-0507-90 ")
 ;;854
 ;;21,"43063-0527-20 ")
 ;;855
 ;;21,"43063-0527-30 ")
 ;;856
 ;;21,"43063-0527-60 ")
 ;;857
 ;;21,"43063-0527-90 ")
 ;;858
 ;;21,"43063-0527-93 ")
 ;;859
 ;;21,"43063-0539-86 ")
 ;;860
 ;;21,"43063-0539-90 ")
 ;;861
 ;;21,"43063-0539-93 ")
 ;;862
 ;;21,"43063-0539-94 ")
 ;;863
 ;;21,"43063-0539-96 ")
 ;;864
 ;;21,"43063-0545-90 ")
 ;;865
 ;;21,"43063-0545-93 ")
 ;;866
 ;;21,"43063-0545-94 ")
 ;;867
 ;;21,"43063-0546-30 ")
 ;;868
 ;;21,"43063-0546-60 ")
 ;;869
 ;;21,"43063-0546-90 ")
 ;;870
 ;;21,"43063-0546-93 ")
 ;;871
 ;;21,"43063-0546-94 ")
 ;;872
 ;;21,"43063-0546-98 ")
 ;;873
 ;;21,"43353-0340-30 ")
 ;;874
 ;;21,"43353-0340-53 ")
 ;;875
 ;;21,"43353-0340-60 ")
 ;;876
 ;;21,"43353-0340-70 ")
 ;;877
 ;;21,"43353-0340-75 ")
 ;;878
 ;;21,"43353-0340-80 ")
 ;;879
 ;;21,"43353-0340-92 ")
 ;;880
 ;;21,"43353-0340-94 ")
 ;;881
 ;;21,"43353-0340-96 ")
 ;;882
 ;;21,"43353-0344-53 ")
 ;;883
 ;;21,"43353-0344-60 ")
 ;;884
 ;;21,"43353-0344-80 ")
 ;;885
 ;;21,"43353-0344-92 ")
 ;;886
 ;;21,"43353-0349-30 ")
 ;;887
 ;;21,"43353-0349-45 ")
 ;;888
 ;;21,"43353-0349-53 ")
 ;;889
 ;;21,"43353-0349-60 ")
 ;;890
 ;;21,"43353-0349-73 ")
 ;;891
 ;;21,"43353-0349-80 ")
 ;;892
 ;;21,"43353-0349-86 ")
 ;;893
 ;;21,"43353-0369-53 ")
 ;;894
 ;;21,"43353-0369-60 ")
 ;;895
 ;;21,"43353-0369-70 ")
 ;;896
 ;;21,"43353-0369-80 ")
 ;;897
 ;;21,"43353-0369-92 ")
 ;;898
 ;;21,"43353-0369-94 ")
 ;;899
 ;;21,"43353-0379-60 ")
 ;;900
 ;;21,"43353-0379-73 ")
 ;;901
 ;;21,"43353-0379-80 ")
 ;;902
 ;;21,"43353-0379-92 ")
 ;;903
 ;;21,"43353-0379-98 ")
 ;;904
 ;;21,"43353-0477-30 ")
 ;;905
 ;;21,"43353-0477-53 ")
 ;;906
 ;;21,"43353-0477-60 ")
 ;;907
 ;;21,"43353-0477-70 ")
 ;;908
 ;;21,"43353-0477-80 ")
 ;;909
 ;;21,"43353-0477-92 ")
 ;;910
 ;;21,"43353-0477-94 ")
 ;;911
 ;;21,"43353-0477-96 ")
 ;;912
 ;;21,"43353-0514-30 ")
 ;;913
 ;;21,"43353-0514-45 ")
 ;;914
 ;;21,"43353-0514-53 ")
 ;;915
 ;;21,"43353-0514-60 ")
 ;;916
 ;;21,"43353-0514-73 ")
 ;;917
 ;;21,"43353-0514-80 ")
 ;;918
 ;;21,"43353-0514-86 ")
 ;;919
 ;;21,"43353-0520-60 ")
 ;;920
 ;;21,"43353-0520-80 ")
 ;;921
 ;;21,"43353-0530-60 ")
 ;;922
 ;;21,"43353-0530-80 ")
 ;;923
 ;;21,"43353-0582-80 ")
 ;;924
 ;;21,"43353-0585-94 ")
 ;;925
 ;;21,"43353-0589-30 ")
 ;;926
 ;;21,"43353-0589-53 ")
 ;;927
 ;;21,"43353-0589-60 ")
 ;;928
 ;;21,"43353-0589-70 ")
 ;;929
 ;;21,"43353-0589-75 ")
 ;;930
 ;;21,"43353-0589-80 ")
 ;;931
 ;;21,"43353-0589-92 ")
 ;;932
 ;;21,"43353-0589-94 ")
 ;;933
 ;;21,"43353-0589-96 ")
 ;;934
 ;;21,"43353-0656-53 ")
 ;;935
 ;;21,"43353-0656-60 ")
 ;;936
 ;;21,"43353-0656-70 ")
 ;;937
 ;;21,"43353-0656-80 ")
 ;;938
 ;;21,"43353-0656-90 ")
 ;;939
 ;;21,"43353-0656-92 ")
 ;;940
 ;;21,"43353-0656-94 ")
 ;;941
 ;;21,"43353-0659-60 ")
 ;;942
 ;;21,"43353-0659-80 ")
 ;;943
 ;;21,"43353-0811-53 ")
 ;;944
 ;;21,"43353-0842-30 ")
 ;;945
 ;;21,"43353-0885-45 ")
 ;;946
 ;;21,"43353-0885-73 ")
 ;;947
 ;;21,"43353-0885-86 ")
 ;;948
 ;;21,"43353-0894-30 ")
 ;;949
 ;;21,"43353-0936-30 ")
 ;;950
 ;;21,"43353-0936-45 ")
 ;;951
 ;;21,"43353-0936-73 ")
 ;;952
 ;;21,"43353-0936-86 ")
 ;;953
 ;;21,"43353-0982-30 ")
 ;;954
 ;;21,"43353-0987-30 ")
 ;;955
 ;;21,"43353-0987-45 ")
 ;;956
 ;;21,"43353-0987-73 ")
 ;;957
 ;;21,"43353-0987-80 ")
 ;;958
 ;;21,"43353-0987-86 ")
 ;;959
 ;;21,"43547-0248-10 ")
 ;;960
 ;;21,"43547-0248-11 ")
 ;;961
 ;;21,"43547-0248-50 ")
 ;;962
 ;;21,"43547-0249-10 ")
 ;;963
 ;;21,"43547-0249-11 ")
 ;;964
 ;;21,"43547-0249-50 ")
 ;;965
 ;;21,"43547-0250-10 ")
 ;;966
 ;;21,"43547-0250-11 ")
 ;;967
 ;;21,"43547-0250-50 ")
 ;;968
 ;;21,"43547-0320-10 ")
 ;;969
 ;;21,"43547-0320-11 ")
 ;;970
 ;;21,"43547-0320-50 ")
 ;;971
 ;;21,"43547-0321-10 ")
 ;;972
 ;;21,"43547-0321-50 ")
 ;;973
 ;;21,"43547-0322-10 ")
 ;;974
 ;;21,"43547-0322-50 ")
 ;;975
 ;;21,"43547-0357-10 ")
 ;;976
 ;;21,"43547-0357-11 ")
 ;;977
 ;;21,"43547-0357-50 ")
 ;;978
 ;;21,"43547-0358-10 ")
 ;;979
 ;;21,"43547-0358-50 ")
 ;;980
 ;;21,"43547-0359-10 ")
 ;;981
 ;;21,"43547-0359-50 ")
 ;;982
 ;;21,"43683-0123-60 ")
 ;;983
 ;;21,"43683-0124-30 ")
 ;;984
 ;;21,"43683-0131-30 ")
 ;;985
 ;;21,"43683-0131-60 ")
 ;;986
 ;;21,"43683-0132-30 ")
 ;;987
 ;;21,"43683-0132-60 ")
 ;;988
 ;;21,"45802-0770-78 ")
 ;;989
 ;;21,"45802-0822-78 ")
 ;;990
 ;;21,"45802-0947-78 ")
 ;;991
 ;;21,"45963-0753-02 ")
 ;;992
 ;;21,"47463-0241-30 ")
 ;;993
 ;;21,"47463-0242-30 ")
 ;;994
 ;;21,"47463-0243-30 ")
 ;;995
 ;;21,"47463-0243-60 ")
 ;;996
 ;;21,"47463-0244-30 ")
 ;;997
 ;;21,"47463-0245-30 ")
 ;;998
 ;;21,"47463-0245-60 ")
 ;;999
 ;;21,"47463-0246-30 ")
 ;;1000
 ;;21,"47463-0247-30 ")
 ;;1001
 ;;21,"47463-0248-90 ")
 ;;1002
 ;;21,"47463-0434-60 ")
 ;;1003
 ;;21,"47463-0435-60 ")
 ;;1004
 ;;21,"47463-0508-30 ")
 ;;1005
 ;;21,"47463-0509-30 ")
 ;;1006
 ;;21,"47463-0509-60 ")
 ;;1007
 ;;21,"47463-0509-74 ")
 ;;1008
 ;;21,"47463-0509-90 ")
 ;;1009
 ;;21,"47463-0510-30 ")
 ;;1010
 ;;21,"47463-0510-60 ")
 ;;1011
 ;;21,"47463-0510-71 ")
 ;;1012
 ;;21,"47463-0510-74 ")
 ;;1013
 ;;21,"47463-0510-90 ")
 ;;1014
 ;;21,"47463-0583-30 ")
 ;;1015
 ;;21,"47463-0584-30 ")
 ;;1016
 ;;21,"47463-0585-30 ")
 ;;1017
 ;;21,"47463-0611-60 ")
 ;;1018
 ;;21,"47463-0611-74 ")
 ;;1019
 ;;21,"47463-0612-30 ")
 ;;1020
 ;;21,"47463-0764-60 ")
 ;;1021
 ;;21,"47463-0765-30 ")
 ;;1022
 ;;21,"47463-0766-30 ")
 ;;1023
 ;;21,"47463-0777-30 ")
 ;;1024
 ;;21,"49884-0745-01 ")
 ;;1025
 ;;21,"49884-0745-05 ")
 ;;1026
 ;;21,"49884-0746-01 ")
 ;;1027
 ;;21,"49884-0746-05 ")
 ;;1028
 ;;21,"49884-0984-01 ")
 ;;1029
 ;;21,"49884-0985-01 ")
 ;;1030
 ;;21,"49999-0106-00 ")
 ;;1031
 ;;21,"49999-0106-01 ")
 ;;1032
 ;;21,"49999-0106-28 ")
 ;;1033
 ;;21,"49999-0106-30 ")
 ;;1034
 ;;21,"49999-0106-60 ")
 ;;1035
 ;;21,"49999-0106-90 ")
 ;;1036
 ;;21,"49999-0107-00 ")
 ;;1037
 ;;21,"49999-0107-20 ")
 ;;1038
 ;;21,"49999-0107-30 ")
 ;;1039
 ;;21,"49999-0107-60 ")
 ;;1040
 ;;21,"49999-0107-90 ")
 ;;1041
 ;;21,"49999-0108-00 ")
 ;;1042
 ;;21,"49999-0108-30 ")
 ;;1043
 ;;21,"49999-0108-60 ")
 ;;1044
 ;;21,"49999-0108-90 ")
 ;;1045
 ;;21,"49999-0113-00 ")
 ;;1046
 ;;21,"49999-0113-01 ")
 ;;1047
 ;;21,"49999-0113-30 ")
 ;;1048
 ;;21,"49999-0113-60 ")
 ;;1049
 ;;21,"49999-0113-90 ")
 ;;1050
 ;;21,"49999-0116-00 ")
 ;;1051
 ;;21,"49999-0116-30 ")
 ;;1052
 ;;21,"49999-0116-60 ")
 ;;1053
 ;;21,"49999-0304-30 ")
 ;;1054
 ;;21,"49999-0401-30 ")
 ;;1055
 ;;21,"49999-0401-60 ")
 ;;1056
 ;;21,"49999-0401-90 ")
 ;;1057
 ;;21,"49999-0449-15 ")
 ;;1058
 ;;21,"49999-0449-30 ")
 ;;1059
 ;;21,"49999-0450-30 ")
 ;;1060
 ;;21,"49999-0451-30 ")
 ;;1061
 ;;21,"49999-0495-30 ")
 ;;1062
 ;;21,"49999-0495-60 ")
 ;;1063
 ;;21,"49999-0514-30 ")
 ;;1064
 ;;21,"49999-0571-60 ")
 ;;1065
 ;;21,"49999-0660-30 ")
 ;;1066
 ;;21,"49999-0660-60 ")
 ;;1067
 ;;21,"49999-0781-00 ")
 ;;1068
 ;;21,"49999-0781-30 ")
 ;;1069
 ;;21,"49999-0781-60 ")
 ;;1070
 ;;21,"49999-0781-90 ")
 ;;1071
 ;;21,"49999-0807-00 ")
 ;;1072
 ;;21,"49999-0807-30 ")
 ;;1073
 ;;21,"49999-0807-60 ")
 ;;1074
 ;;21,"49999-0807-90 ")
 ;;1075
 ;;21,"49999-0808-00 ")
 ;;1076
 ;;21,"49999-0820-30 ")
 ;;1077
 ;;21,"49999-0820-60 ")
 ;;1078
 ;;21,"49999-0820-90 ")
 ;;1079
 ;;21,"49999-0935-30 ")
 ;;1080
 ;;21,"50268-0531-11 ")
 ;;1081
 ;;21,"50268-0531-15 ")
 ;;1082
 ;;21,"50268-0532-11 ")
 ;;1083
 ;;21,"50268-0532-13 ")
 ;;1084
 ;;21,"50458-0140-30 ")
 ;;1085
 ;;21,"50458-0140-90 ")
 ;;1086
 ;;21,"50458-0141-30 ")
 ;;1087
 ;;21,"50458-0141-90 ")
 ;;1088
 ;;21,"50458-0540-60 ")
 ;;1089
 ;;21,"50458-0541-60 ")
 ;;1090
 ;;21,"50458-0542-60 ")
 ;;1091
 ;;21,"50458-0543-60 ")
 ;;1092
 ;;21,"50742-0154-01 ")
 ;;1093
 ;;21,"50742-0154-05 ")
 ;;1094
 ;;21,"50742-0154-10 ")
 ;;1095
 ;;21,"50742-0154-90 ")
 ;;1096
 ;;21,"50742-0155-01 ")
 ;;1097
 ;;21,"50742-0155-05 ")
 ;;1098
 ;;21,"50742-0155-10 ")
 ;;1099
 ;;21,"50742-0155-90 ")
 ;;1100
 ;;21,"50742-0156-01 ")
 ;;1101