BGP47E3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 16, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00456-4010-01 ")
 ;;790
 ;;21,"00456-4020-01 ")
 ;;791
 ;;21,"00456-4020-63 ")
 ;;792
 ;;21,"00456-4040-01 ")
 ;;793
 ;;21,"00456-4130-08 ")
 ;;794
 ;;21,"00490-0034-00 ")
 ;;795
 ;;21,"00490-0034-30 ")
 ;;796
 ;;21,"00490-0034-60 ")
 ;;797
 ;;21,"00490-0034-90 ")
 ;;798
 ;;21,"00490-0114-00 ")
 ;;799
 ;;21,"00490-0114-30 ")
 ;;800
 ;;21,"00490-0114-60 ")
 ;;801
 ;;21,"00490-0114-90 ")
 ;;802
 ;;21,"00490-0163-00 ")
 ;;803
 ;;21,"00490-0163-30 ")
 ;;804
 ;;21,"00490-0163-60 ")
 ;;805
 ;;21,"00490-0163-90 ")
 ;;806
 ;;21,"00555-0201-01 ")
 ;;807
 ;;21,"00555-0241-71 ")
 ;;808
 ;;21,"00555-0242-71 ")
 ;;809
 ;;21,"00555-0489-02 ")
 ;;810
 ;;21,"00555-0489-04 ")
 ;;811
 ;;21,"00555-0490-02 ")
 ;;812
 ;;21,"00555-0490-04 ")
 ;;813
 ;;21,"00555-0594-02 ")
 ;;814
 ;;21,"00555-0595-02 ")
 ;;815
 ;;21,"00555-0732-02 ")
 ;;816
 ;;21,"00555-0732-04 ")
 ;;817
 ;;21,"00555-0733-02 ")
 ;;818
 ;;21,"00555-0871-54 ")
 ;;819
 ;;21,"00555-0871-88 ")
 ;;820
 ;;21,"00555-0876-02 ")
 ;;821
 ;;21,"00555-0877-02 ")
 ;;822
 ;;21,"00555-0877-04 ")
 ;;823
 ;;21,"00555-0877-05 ")
 ;;824
 ;;21,"00555-0877-07 ")
 ;;825
 ;;21,"00555-0967-02 ")
 ;;826
 ;;21,"00555-0968-02 ")
 ;;827
 ;;21,"00555-0969-02 ")
 ;;828
 ;;21,"00591-0764-60 ")
 ;;829
 ;;21,"00591-0767-60 ")
 ;;830
 ;;21,"00591-0809-01 ")
 ;;831
 ;;21,"00591-0809-05 ")
 ;;832
 ;;21,"00591-0839-25 ")
 ;;833
 ;;21,"00591-0839-60 ")
 ;;834
 ;;21,"00591-0858-60 ")
 ;;835
 ;;21,"00591-1117-10 ")
 ;;836
 ;;21,"00591-1117-30 ")
 ;;837
 ;;21,"00591-1118-10 ")
 ;;838
 ;;21,"00591-1118-30 ")
 ;;839
 ;;21,"00591-1119-30 ")
 ;;840
 ;;21,"00591-2114-01 ")
 ;;841
 ;;21,"00591-2230-15 ")
 ;;842
 ;;21,"00591-2231-15 ")
 ;;843
 ;;21,"00591-3176-01 ")
 ;;844
 ;;21,"00591-3176-05 ")
 ;;845
 ;;21,"00591-3177-01 ")
 ;;846
 ;;21,"00591-3177-05 ")
 ;;847
 ;;21,"00591-3178-01 ")
 ;;848
 ;;21,"00591-3178-05 ")
 ;;849
 ;;21,"00591-3331-05 ")
 ;;850
 ;;21,"00591-3331-19 ")
 ;;851
 ;;21,"00591-3331-30 ")
 ;;852
 ;;21,"00591-3332-05 ")
 ;;853
 ;;21,"00591-3332-30 ")
 ;;854
 ;;21,"00591-3385-60 ")
 ;;855
 ;;21,"00591-3540-05 ")
 ;;856
 ;;21,"00591-3540-60 ")
 ;;857
 ;;21,"00591-3541-05 ")
 ;;858
 ;;21,"00591-3541-25 ")
 ;;859
 ;;21,"00591-3541-60 ")
 ;;860
 ;;21,"00591-3542-60 ")
 ;;861
 ;;21,"00591-3543-60 ")
 ;;862
 ;;21,"00591-3543-76 ")
 ;;863
 ;;21,"00591-5599-01 ")
 ;;864
 ;;21,"00591-5599-10 ")
 ;;865
 ;;21,"00591-5600-01 ")
 ;;866
 ;;21,"00591-5600-10 ")
 ;;867
 ;;21,"00591-5629-01 ")
 ;;868
 ;;21,"00591-5631-01 ")
 ;;869
 ;;21,"00591-5631-10 ")
 ;;870
 ;;21,"00591-5632-01 ")
 ;;871
 ;;21,"00591-5633-01 ")
 ;;872
 ;;21,"00591-5713-01 ")
 ;;873
 ;;21,"00591-5714-01 ")
 ;;874
 ;;21,"00591-5715-01 ")
 ;;875
 ;;21,"00591-5716-30 ")
 ;;876
 ;;21,"00591-5786-01 ")
 ;;877
 ;;21,"00591-5786-05 ")
 ;;878
 ;;21,"00591-5787-01 ")
 ;;879
 ;;21,"00591-5787-05 ")
 ;;880
 ;;21,"00591-5787-10 ")
 ;;881
 ;;21,"00591-5788-01 ")
 ;;882
 ;;21,"00591-5788-05 ")
 ;;883
 ;;21,"00591-5789-01 ")
 ;;884
 ;;21,"00603-2212-02 ")
 ;;885
 ;;21,"00603-2212-16 ")
 ;;886
 ;;21,"00603-2212-21 ")
 ;;887
 ;;21,"00603-2212-32 ")
 ;;888
 ;;21,"00603-2213-21 ")
 ;;889
 ;;21,"00603-2213-30 ")
 ;;890
 ;;21,"00603-2213-32 ")
 ;;891
 ;;21,"00603-2214-21 ")
 ;;892
 ;;21,"00603-2214-32 ")
 ;;893
 ;;21,"00603-2215-21 ")
 ;;894
 ;;21,"00603-2216-21 ")
 ;;895
 ;;21,"00603-2216-25 ")
 ;;896
 ;;21,"00603-2217-21 ")
 ;;897
 ;;21,"00603-6147-21 ")
 ;;898
 ;;21,"00603-6147-32 ")
 ;;899
 ;;21,"00603-6148-21 ")
 ;;900
 ;;21,"00603-6148-32 ")
 ;;901
 ;;21,"00603-6149-21 ")
 ;;902
 ;;21,"00603-6150-16 ")
 ;;903
 ;;21,"00603-6150-21 ")
 ;;904
 ;;21,"00603-6150-25 ")
 ;;905
 ;;21,"00603-6151-21 ")
 ;;906
 ;;21,"00603-6151-25 ")
 ;;907
 ;;21,"00603-6156-21 ")
 ;;908
 ;;21,"00603-6157-21 ")
 ;;909
 ;;21,"00603-6157-25 ")
 ;;910
 ;;21,"00603-6160-02 ")
 ;;911
 ;;21,"00603-6160-13 ")
 ;;912
 ;;21,"00603-6160-16 ")
 ;;913
 ;;21,"00603-6160-20 ")
 ;;914
 ;;21,"00603-6160-21 ")
 ;;915
 ;;21,"00603-6160-28 ")
 ;;916
 ;;21,"00603-6160-32 ")
 ;;917
 ;;21,"00603-6161-02 ")
 ;;918
 ;;21,"00603-6161-04 ")
 ;;919
 ;;21,"00603-6161-16 ")
 ;;920
 ;;21,"00603-6161-20 ")
 ;;921
 ;;21,"00603-6161-21 ")
 ;;922
 ;;21,"00603-6161-28 ")
 ;;923
 ;;21,"00603-6161-32 ")
 ;;924
 ;;21,"00641-4513-86 ")
 ;;925
 ;;21,"00777-3104-02 ")
 ;;926
 ;;21,"00777-3105-02 ")
 ;;927
 ;;21,"00777-3105-07 ")
 ;;928
 ;;21,"00777-3105-30 ")
 ;;929
 ;;21,"00777-3105-33 ")
 ;;930
 ;;21,"00777-3107-30 ")
 ;;931
 ;;21,"00781-1053-01 ")
 ;;932
 ;;21,"00781-1053-10 ")
 ;;933
 ;;21,"00781-1064-01 ")
 ;;934
 ;;21,"00781-1064-10 ")
 ;;935
 ;;21,"00781-1486-01 ")
 ;;936
 ;;21,"00781-1486-10 ")
 ;;937
 ;;21,"00781-1487-01 ")
 ;;938
 ;;21,"00781-1487-10 ")
 ;;939
 ;;21,"00781-1488-01 ")
 ;;940
 ;;21,"00781-1488-10 ")
 ;;941
 ;;21,"00781-1489-01 ")
 ;;942
 ;;21,"00781-1490-01 ")
 ;;943
 ;;21,"00781-1491-01 ")
 ;;944
 ;;21,"00781-1529-60 ")
 ;;945
 ;;21,"00781-1762-01 ")
 ;;946
 ;;21,"00781-1764-01 ")
 ;;947
 ;;21,"00781-1764-10 ")
 ;;948
 ;;21,"00781-1764-13 ")
 ;;949
 ;;21,"00781-1766-01 ")
 ;;950
 ;;21,"00781-1766-10 ")
 ;;951
 ;;21,"00781-1766-13 ")
 ;;952
 ;;21,"00781-1971-01 ")
 ;;953
 ;;21,"00781-1972-01 ")
 ;;954
 ;;21,"00781-1973-01 ")
 ;;955
 ;;21,"00781-1974-01 ")
 ;;956
 ;;21,"00781-1975-01 ")
 ;;957
 ;;21,"00781-1976-50 ")
 ;;958
 ;;21,"00781-2027-01 ")
 ;;959
 ;;21,"00781-2037-01 ")
 ;;960
 ;;21,"00781-2047-01 ")
 ;;961
 ;;21,"00781-2191-31 ")
 ;;962
 ;;21,"00781-2192-31 ")
 ;;963
 ;;21,"00781-2193-31 ")
 ;;964
 ;;21,"00781-2194-31 ")
 ;;965
 ;;21,"00781-2195-31 ")
 ;;966
 ;;21,"00781-2822-01 ")
 ;;967
 ;;21,"00781-2822-10 ")
 ;;968
 ;;21,"00781-2823-01 ")
 ;;969
 ;;21,"00781-2823-10 ")
 ;;970
 ;;21,"00781-2824-01 ")
 ;;971
 ;;21,"00781-2824-10 ")
 ;;972
 ;;21,"00781-2824-31 ")
 ;;973
 ;;21,"00781-2827-08 ")
 ;;974
 ;;21,"00781-2828-08 ")
 ;;975
 ;;21,"00781-5157-01 ")
 ;;976
 ;;21,"00781-5169-60 ")
 ;;977
 ;;21,"00904-0201-61 ")
 ;;978
 ;;21,"00904-0202-61 ")
 ;;979
 ;;21,"00904-1261-61 ")
 ;;980
 ;;21,"00904-3991-61 ")
 ;;981
 ;;21,"00904-5219-60 ")
 ;;982
 ;;21,"00904-5676-61 ")
 ;;983
 ;;21,"00904-5677-61 ")
 ;;984
 ;;21,"00904-5678-61 ")
 ;;985
 ;;21,"00904-5679-61 ")
 ;;986
 ;;21,"00904-5784-61 ")
 ;;987
 ;;21,"00904-5785-61 ")
 ;;988
 ;;21,"00904-5866-61 ")
 ;;989
 ;;21,"00904-5867-61 ")
 ;;990
 ;;21,"00904-5868-61 ")
 ;;991
 ;;21,"00904-5913-61 ")
 ;;992
 ;;21,"00904-5914-61 ")
 ;;993
 ;;21,"00904-6084-61 ")
 ;;994
 ;;21,"00904-6085-61 ")
 ;;995
 ;;21,"00904-6086-61 ")
 ;;996
 ;;21,"00904-6087-61 ")
 ;;997
 ;;21,"00904-6088-61 ")
 ;;998
 ;;21,"00904-6089-61 ")
 ;;999
 ;;21,"00904-6093-61 ")
 ;;1000
 ;;21,"00904-6109-61 ")
 ;;1001
 ;;21,"00904-6110-61 ")
 ;;1002
 ;;21,"00904-6111-61 ")
 ;;1003
 ;;21,"00904-6112-61 ")
 ;;1004
 ;;21,"00904-6129-61 ")
 ;;1005
 ;;21,"00904-6246-61 ")
 ;;1006
 ;;21,"00904-6247-61 ")
 ;;1007
 ;;21,"00904-6248-61 ")
 ;;1008
 ;;21,"00904-6314-61 ")
 ;;1009
 ;;21,"00904-6315-61 ")
 ;;1010
 ;;21,"00904-6331-61 ")
 ;;1011
 ;;21,"00904-6332-61 ")
 ;;1012
 ;;21,"00904-6333-61 ")
 ;;1013
 ;;21,"10370-0101-00 ")
 ;;1014
 ;;21,"10370-0101-03 ")
 ;;1015
 ;;21,"10370-0101-50 ")
 ;;1016
 ;;21,"10370-0102-00 ")
 ;;1017
 ;;21,"10370-0102-03 ")
 ;;1018
 ;;21,"10370-0102-50 ")
 ;;1019
 ;;21,"10370-0159-06 ")
 ;;1020
 ;;21,"10370-0160-06 ")
 ;;1021
 ;;21,"10370-0160-10 ")
 ;;1022
 ;;21,"10370-0160-50 ")
 ;;1023
 ;;21,"10370-0161-06 ")
 ;;1024
 ;;21,"10370-0175-11 ")
 ;;1025
 ;;21,"10370-0176-11 ")
 ;;1026
 ;;21,"10544-0329-30 ")
 ;;1027
 ;;21,"10544-0336-30 ")
 ;;1028
 ;;21,"10544-0346-30 ")
 ;;1029
 ;;21,"10544-0346-60 ")
 ;;1030
 ;;21,"10544-0405-30 ")
 ;;1031
 ;;21,"10544-0413-30 ")
 ;;1032
 ;;21,"10768-7060-03 ")
 ;;1033
 ;;21,"10768-7191-03 ")
 ;;1034
 ;;21,"10768-7616-03 ")
 ;;1035
 ;;21,"12280-0011-00 ")
 ;;1036
 ;;21,"12280-0011-60 ")
 ;;1037
 ;;21,"12280-0016-15 ")
 ;;1038
 ;;21,"12280-0017-15 ")
 ;;1039
 ;;21,"12280-0018-15 ")
 ;;1040
 ;;21,"12280-0023-15 ")
 ;;1041
 ;;21,"12280-0032-00 ")
 ;;1042
 ;;21,"12280-0065-00 ")
 ;;1043
 ;;21,"12280-0074-00 ")
 ;;1044
 ;;21,"12280-0163-15 ")
 ;;1045
 ;;21,"12280-0163-30 ")
 ;;1046
 ;;21,"12280-0169-00 ")
 ;;1047
 ;;21,"12280-0169-30 ")
 ;;1048
 ;;21,"12280-0170-60 ")
 ;;1049
 ;;21,"12280-0171-15 ")
 ;;1050
 ;;21,"12280-0171-30 ")
 ;;1051
 ;;21,"12280-0171-60 ")
 ;;1052
 ;;21,"12280-0211-00 ")
 ;;1053
 ;;21,"13107-0003-05 ")
 ;;1054
 ;;21,"13107-0003-30 ")
 ;;1055
 ;;21,"13107-0003-34 ")
 ;;1056
 ;;21,"13107-0005-01 ")
 ;;1057
 ;;21,"13107-0005-05 ")
 ;;1058
 ;;21,"13107-0006-01 ")
 ;;1059
 ;;21,"13107-0006-05 ")
 ;;1060
 ;;21,"13107-0007-01 ")
 ;;1061
 ;;21,"13107-0007-05 ")
 ;;1062
 ;;21,"13107-0031-05 ")
 ;;1063
 ;;21,"13107-0031-30 ")
 ;;1064
 ;;21,"13107-0031-34 ")
 ;;1065
 ;;21,"13107-0032-05 ")
 ;;1066
 ;;21,"13107-0032-30 ")
 ;;1067
 ;;21,"13107-0032-34 ")
 ;;1068
 ;;21,"13107-0154-05 ")
 ;;1069
 ;;21,"13107-0154-30 ")
 ;;1070
 ;;21,"13107-0155-05 ")
 ;;1071
 ;;21,"13107-0155-30 ")
 ;;1072
 ;;21,"13107-0155-99 ")
 ;;1073
 ;;21,"13107-0156-05 ")
 ;;1074
 ;;21,"13107-0156-30 ")
 ;;1075
 ;;21,"13107-0156-99 ")
 ;;1076
 ;;21,"13107-0157-05 ")
 ;;1077
 ;;21,"13107-0157-30 ")
 ;;1078
 ;;21,"13107-0157-99 ")
 ;;1079
 ;;21,"13411-0100-03 ")
 ;;1080
 ;;21,"13411-0109-01 ")
 ;;1081
 ;;21,"13411-0109-06 ")
 ;;1082
 ;;21,"13411-0109-09 ")
 ;;1083
 ;;21,"13411-0109-10 ")
 ;;1084
 ;;21,"13411-0110-01 ")
 ;;1085
 ;;21,"13411-0110-03 ")
 ;;1086
 ;;21,"13411-0110-06 ")
 ;;1087
 ;;21,"13411-0110-09 ")
 ;;1088
 ;;21,"13411-0110-10 ")
 ;;1089
 ;;21,"13411-0152-01 ")
 ;;1090
 ;;21,"13411-0152-03 ")
 ;;1091
 ;;21,"13411-0152-06 ")
 ;;1092
 ;;21,"13411-0152-09 ")
 ;;1093
 ;;21,"13411-0152-15 ")
 ;;1094
 ;;21,"13411-0153-01 ")
 ;;1095
 ;;21,"13411-0153-03 ")
 ;;1096
 ;;21,"13411-0153-06 ")
 ;;1097
 ;;21,"13411-0153-09 ")
 ;;1098
 ;;21,"13411-0153-15 ")
 ;;1099
 ;;21,"13411-0172-01 ")
 ;;1100
 ;;21,"13411-0172-03 ")
 ;;1101
 ;;21,"13411-0172-06 ")
 ;;1102
 ;;21,"13411-0172-09 ")
 ;;1103
 ;;21,"13411-0172-10 ")
 ;;1104
 ;;21,"13411-0173-01 ")
 ;;1105
 ;;21,"13411-0173-03 ")
 ;;1106
 ;;21,"13411-0173-06 ")
 ;;1107
 ;;21,"13411-0173-09 ")
 ;;1108
 ;;21,"13411-0173-10 ")
 ;;1109
 ;;21,"13668-0004-01 ")
 ;;1110
 ;;21,"13668-0004-05 ")
 ;;1111
 ;;21,"13668-0004-10 ")
 ;;1112
 ;;21,"13668-0004-30 ")
 ;;1113
 ;;21,"13668-0004-50 ")
 ;;1114
 ;;21,"13668-0004-90 ")
 ;;1115
 ;;21,"13668-0005-01 ")
 ;;1116
 ;;21,"13668-0005-05 ")
 ;;1117
 ;;21,"13668-0005-10 ")
 ;;1118
 ;;21,"13668-0005-30 ")
 ;;1119
 ;;21,"13668-0005-50 ")
 ;;1120
 ;;21,"13668-0005-90 ")
 ;;1121
 ;;21,"13668-0006-01 ")
 ;;1122
 ;;21,"13668-0006-05 ")
 ;;1123
 ;;21,"13668-0006-10 ")
 ;;1124
 ;;21,"13668-0006-30 ")
 ;;1125
 ;;21,"13668-0006-50 ")
 ;;1126
 ;;21,"13668-0006-90 ")
 ;;1127
 ;;21,"13668-0009-01 ")
 ;;1128
 ;;21,"13668-0009-05 ")
 ;;1129
 ;;21,"13668-0009-09 ")
 ;;1130
 ;;21,"13668-0009-30 ")
 ;;1131
 ;;21,"13668-0009-74 ")
 ;;1132
 ;;21,"13668-0010-01 ")
 ;;1133
 ;;21,"13668-0010-05 ")
 ;;1134
 ;;21,"13668-0010-06 ")
 ;;1135
 ;;21,"13668-0010-30 ")
 ;;1136
 ;;21,"13668-0010-74 ")
 ;;1137
 ;;21,"13668-0011-01 ")
 ;;1138
 ;;21,"13668-0011-05 ")
 ;;1139
 ;;21,"13668-0011-08 ")
 ;;1140
 ;;21,"13668-0011-30 ")
 ;;1141
 ;;21,"13668-0011-74 ")
 ;;1142
 ;;21,"13668-0018-01 ")
 ;;1143
 ;;21,"13668-0018-05 ")
 ;;1144
 ;;21,"13668-0018-30 ")
 ;;1145
 ;;21,"13668-0018-74 ")
 ;;1146
 ;;21,"13668-0018-90 ")
 ;;1147
 ;;21,"13668-0019-01 ")
 ;;1148
 ;;21,"13668-0019-05 ")
 ;;1149
 ;;21,"13668-0019-30 ")
 ;;1150
 ;;21,"13668-0019-74 ")
 ;;1151
 ;;21,"13668-0019-90 ")
 ;;1152
 ;;21,"13668-0020-01 ")
 ;;1153
 ;;21,"13668-0020-05 ")
 ;;1154
 ;;21,"13668-0020-30 ")
 ;;1155
 ;;21,"13668-0020-74 ")
 ;;1156
 ;;21,"13668-0020-90 ")
 ;;1157
 ;;21,"13668-0135-01 ")
 ;;1158
 ;;21,"13668-0135-05 ")
 ;;1159
 ;;21,"13668-0136-01 ")
 ;;1160
 ;;21,"13668-0136-05 ")
 ;;1161
 ;;21,"13668-0137-01 ")
 ;;1162
 ;;21,"13668-0137-05 ")
 ;;1163
 ;;21,"16241-0759-01 ")
 ;;1164
 ;;21,"16252-0533-30 ")
 ;;1165
 ;;21,"16252-0533-50 ")
 ;;1166
 ;;21,"16252-0534-30 ")
 ;;1167
 ;;21,"16252-0534-50 ")
 ;;1168
 ;;21,"16252-0534-90 ")
 ;;1169
 ;;21,"16252-0535-30 ")
 ;;1170
 ;;21,"16252-0535-50 ")
 ;;1171
 ;;21,"16252-0535-90 ")
 ;;1172
 ;;21,"16590-0011-30 ")
 ;;1173
 ;;21,"16590-0011-56 ")
 ;;1174
 ;;21,"16590-0011-60 ")
 ;;1175
 ;;21,"16590-0011-72 ")
 ;;1176
 ;;21,"16590-0011-90 ")
 ;;1177
 ;;21,"16590-0012-15 ")
 ;;1178
 ;;21,"16590-0012-30 ")
 ;;1179
 ;;21,"16590-0012-60 ")
 ;;1180