BGP53I3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 23, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00247-0812-01 ")
 ;;790
 ;;21,"00247-0928-01 ")
 ;;791
 ;;21,"00247-0928-02 ")
 ;;792
 ;;21,"00247-0940-15 ")
 ;;793
 ;;21,"00247-0941-01 ")
 ;;794
 ;;21,"00247-0942-00 ")
 ;;795
 ;;21,"00247-0942-50 ")
 ;;796
 ;;21,"00247-0942-75 ")
 ;;797
 ;;21,"00247-0943-00 ")
 ;;798
 ;;21,"00247-0943-50 ")
 ;;799
 ;;21,"00247-0943-75 ")
 ;;800
 ;;21,"00247-0949-00 ")
 ;;801
 ;;21,"00247-0949-78 ")
 ;;802
 ;;21,"00247-0949-79 ")
 ;;803
 ;;21,"00247-1009-00 ")
 ;;804
 ;;21,"00247-1009-02 ")
 ;;805
 ;;21,"00247-1009-03 ")
 ;;806
 ;;21,"00247-1009-06 ")
 ;;807
 ;;21,"00247-1009-30 ")
 ;;808
 ;;21,"00247-1181-28 ")
 ;;809
 ;;21,"00247-1181-56 ")
 ;;810
 ;;21,"00247-1183-20 ")
 ;;811
 ;;21,"00247-1261-00 ")
 ;;812
 ;;21,"00247-1261-50 ")
 ;;813
 ;;21,"00247-1261-79 ")
 ;;814
 ;;21,"00247-1288-03 ")
 ;;815
 ;;21,"00247-1333-20 ")
 ;;816
 ;;21,"00247-1383-00 ")
 ;;817
 ;;21,"00247-1383-50 ")
 ;;818
 ;;21,"00247-1386-00 ")
 ;;819
 ;;21,"00247-1386-50 ")
 ;;820
 ;;21,"00247-1468-02 ")
 ;;821
 ;;21,"00247-1468-04 ")
 ;;822
 ;;21,"00247-1468-10 ")
 ;;823
 ;;21,"00247-1468-14 ")
 ;;824
 ;;21,"00247-1468-20 ")
 ;;825
 ;;21,"00247-1518-05 ")
 ;;826
 ;;21,"00247-1518-50 ")
 ;;827
 ;;21,"00247-1519-05 ")
 ;;828
 ;;21,"00247-1519-10 ")
 ;;829
 ;;21,"00247-1519-15 ")
 ;;830
 ;;21,"00247-1519-50 ")
 ;;831
 ;;21,"00247-1524-06 ")
 ;;832
 ;;21,"00247-1623-00 ")
 ;;833
 ;;21,"00247-1623-50 ")
 ;;834
 ;;21,"00247-1624-30 ")
 ;;835
 ;;21,"00247-1624-60 ")
 ;;836
 ;;21,"00247-1624-77 ")
 ;;837
 ;;21,"00247-1624-90 ")
 ;;838
 ;;21,"00247-1666-30 ")
 ;;839
 ;;21,"00247-1669-30 ")
 ;;840
 ;;21,"00247-1707-02 ")
 ;;841
 ;;21,"00247-1707-07 ")
 ;;842
 ;;21,"00247-1707-10 ")
 ;;843
 ;;21,"00247-1707-20 ")
 ;;844
 ;;21,"00247-1707-50 ")
 ;;845
 ;;21,"00247-1708-01 ")
 ;;846
 ;;21,"00247-1708-07 ")
 ;;847
 ;;21,"00247-1708-10 ")
 ;;848
 ;;21,"00247-1708-14 ")
 ;;849
 ;;21,"00247-1708-20 ")
 ;;850
 ;;21,"00247-1708-50 ")
 ;;851
 ;;21,"00247-1729-00 ")
 ;;852
 ;;21,"00247-1729-79 ")
 ;;853
 ;;21,"00247-1951-20 ")
 ;;854
 ;;21,"00247-1963-02 ")
 ;;855
 ;;21,"00247-1963-10 ")
 ;;856
 ;;21,"00247-1963-20 ")
 ;;857
 ;;21,"00247-1977-00 ")
 ;;858
 ;;21,"00247-1990-02 ")
 ;;859
 ;;21,"00247-1990-03 ")
 ;;860
 ;;21,"00247-1990-04 ")
 ;;861
 ;;21,"00247-1990-09 ")
 ;;862
 ;;21,"00247-1990-12 ")
 ;;863
 ;;21,"00247-1990-15 ")
 ;;864
 ;;21,"00247-1990-20 ")
 ;;865
 ;;21,"00247-1990-21 ")
 ;;866
 ;;21,"00247-1990-30 ")
 ;;867
 ;;21,"00247-1991-00 ")
 ;;868
 ;;21,"00247-1991-02 ")
 ;;869
 ;;21,"00247-1991-04 ")
 ;;870
 ;;21,"00247-1991-06 ")
 ;;871
 ;;21,"00247-1991-14 ")
 ;;872
 ;;21,"00247-1991-20 ")
 ;;873
 ;;21,"00247-2018-00 ")
 ;;874
 ;;21,"00247-2018-50 ")
 ;;875
 ;;21,"00247-2018-75 ")
 ;;876
 ;;21,"00247-2042-00 ")
 ;;877
 ;;21,"00247-2042-01 ")
 ;;878
 ;;21,"00247-2042-02 ")
 ;;879
 ;;21,"00247-2042-03 ")
 ;;880
 ;;21,"00247-2042-04 ")
 ;;881
 ;;21,"00247-2042-06 ")
 ;;882
 ;;21,"00247-2042-09 ")
 ;;883
 ;;21,"00247-2042-10 ")
 ;;884
 ;;21,"00247-2042-14 ")
 ;;885
 ;;21,"00247-2042-20 ")
 ;;886
 ;;21,"00247-2042-28 ")
 ;;887
 ;;21,"00247-2042-30 ")
 ;;888
 ;;21,"00247-2044-00 ")
 ;;889
 ;;21,"00247-2044-02 ")
 ;;890
 ;;21,"00247-2044-04 ")
 ;;891
 ;;21,"00247-2044-06 ")
 ;;892
 ;;21,"00247-2044-10 ")
 ;;893
 ;;21,"00247-2044-14 ")
 ;;894
 ;;21,"00247-2044-20 ")
 ;;895
 ;;21,"00247-2044-28 ")
 ;;896
 ;;21,"00247-2075-20 ")
 ;;897
 ;;21,"00247-2177-20 ")
 ;;898
 ;;21,"00247-2209-01 ")
 ;;899
 ;;21,"00247-2209-10 ")
 ;;900
 ;;21,"00247-2209-20 ")
 ;;901
 ;;21,"00247-2210-01 ")
 ;;902
 ;;21,"00247-2210-10 ")
 ;;903
 ;;21,"00247-2211-01 ")
 ;;904
 ;;21,"00247-2211-10 ")
 ;;905
 ;;21,"00247-2216-20 ")
 ;;906
 ;;21,"00247-2217-00 ")
 ;;907
 ;;21,"00247-2217-50 ")
 ;;908
 ;;21,"00247-2217-75 ")
 ;;909
 ;;21,"00247-2233-00 ")
 ;;910
 ;;21,"00247-2233-50 ")
 ;;911
 ;;21,"00247-2233-75 ")
 ;;912
 ;;21,"00247-2258-15 ")
 ;;913
 ;;21,"00247-2279-00 ")
 ;;914
 ;;21,"00247-2279-01 ")
 ;;915
 ;;21,"00247-2279-30 ")
 ;;916
 ;;21,"00247-2279-58 ")
 ;;917
 ;;21,"00247-2358-01 ")
 ;;918
 ;;21,"00247-2358-02 ")
 ;;919
 ;;21,"00247-2358-06 ")
 ;;920
 ;;21,"00264-3102-11 ")
 ;;921
 ;;21,"00264-3103-11 ")
 ;;922
 ;;21,"00264-3105-11 ")
 ;;923
 ;;21,"00264-3112-11 ")
 ;;924
 ;;21,"00264-3114-11 ")
 ;;925
 ;;21,"00264-3153-11 ")
 ;;926
 ;;21,"00264-3155-11 ")
 ;;927
 ;;21,"00299-3822-30 ")
 ;;928
 ;;21,"00299-5960-02 ")
 ;;929
 ;;21,"00316-0142-01 ")
 ;;930
 ;;21,"00338-0960-37 ")
 ;;931
 ;;21,"00338-0960-48 ")
 ;;932
 ;;21,"00338-1021-41 ")
 ;;933
 ;;21,"00338-1023-41 ")
 ;;934
 ;;21,"00338-1025-41 ")
 ;;935
 ;;21,"00338-3502-41 ")
 ;;936
 ;;21,"00338-3503-41 ")
 ;;937
 ;;21,"00338-5002-41 ")
 ;;938
 ;;21,"00338-5003-41 ")
 ;;939
 ;;21,"00364-2033-50 ")
 ;;940
 ;;21,"00364-2464-34 ")
 ;;941
 ;;21,"00364-2466-93 ")
 ;;942
 ;;21,"00364-2906-38 ")
 ;;943
 ;;21,"00364-2908-61 ")
 ;;944
 ;;21,"00378-0145-89 ")
 ;;945
 ;;21,"00378-0148-05 ")
 ;;946
 ;;21,"00378-0148-89 ")
 ;;947
 ;;21,"00378-0167-05 ")
 ;;948
 ;;21,"00378-0167-89 ")
 ;;949
 ;;21,"00378-1215-89 ")
 ;;950
 ;;21,"00378-1217-89 ")
 ;;951
 ;;21,"00378-1221-94 ")
 ;;952
 ;;21,"00378-1322-01 ")
 ;;953
 ;;21,"00378-1323-01 ")
 ;;954
 ;;21,"00378-1323-05 ")
 ;;955
 ;;21,"00378-1324-89 ")
 ;;956
 ;;21,"00378-1533-56 ")
 ;;957
 ;;21,"00378-1533-83 ")
 ;;958
 ;;21,"00378-1743-89 ")
 ;;959
 ;;21,"00378-1745-89 ")
 ;;960
 ;;21,"00378-3030-01 ")
 ;;961
 ;;21,"00378-4296-01 ")
 ;;962
 ;;21,"00378-4296-93 ")
 ;;963
 ;;21,"00378-4297-01 ")
 ;;964
 ;;21,"00378-4297-93 ")
 ;;965
 ;;21,"00378-4298-01 ")
 ;;966
 ;;21,"00378-4298-93 ")
 ;;967
 ;;21,"00378-4531-91 ")
 ;;968
 ;;21,"00378-4532-01 ")
 ;;969
 ;;21,"00378-5475-91 ")
 ;;970
 ;;21,"00378-6021-01 ")
 ;;971
 ;;21,"00378-6022-01 ")
 ;;972
 ;;21,"00378-6023-89 ")
 ;;973
 ;;21,"00378-6124-93 ")
 ;;974
 ;;21,"00378-7097-01 ")
 ;;975
 ;;21,"00378-7098-01 ")
 ;;976
 ;;21,"00378-7099-89 ")
 ;;977
 ;;21,"00378-8250-91 ")
 ;;978
 ;;21,"00378-8500-91 ")
 ;;979
 ;;21,"00409-0144-10 ")
 ;;980
 ;;21,"00409-0144-11 ")
 ;;981
 ;;21,"00409-0528-13 ")
 ;;982
 ;;21,"00409-0528-23 ")
 ;;983
 ;;21,"00409-0528-31 ")
 ;;984
 ;;21,"00409-0802-01 ")
 ;;985
 ;;21,"00409-0803-01 ")
 ;;986
 ;;21,"00409-0805-01 ")
 ;;987
 ;;21,"00409-0806-01 ")
 ;;988
 ;;21,"00409-2585-01 ")
 ;;989
 ;;21,"00409-4050-01 ")
 ;;990
 ;;21,"00409-4051-01 ")
 ;;991
 ;;21,"00409-4052-01 ")
 ;;992
 ;;21,"00409-4053-03 ")
 ;;993
 ;;21,"00409-4054-03 ")
 ;;994
 ;;21,"00409-4055-03 ")
 ;;995
 ;;21,"00409-4197-01 ")
 ;;996
 ;;21,"00409-4765-86 ")
 ;;997
 ;;21,"00409-4777-02 ")
 ;;998
 ;;21,"00409-4777-23 ")
 ;;999
 ;;21,"00409-4777-49 ")
 ;;1000
 ;;21,"00409-4777-50 ")
 ;;1001
 ;;21,"00409-4777-61 ")
 ;;1002
 ;;21,"00409-4777-62 ")
 ;;1003
 ;;21,"00409-4778-86 ")
 ;;1004
 ;;21,"00409-6476-44 ")
 ;;1005
 ;;21,"00409-6478-44 ")
 ;;1006
 ;;21,"00409-6482-01 ")
 ;;1007
 ;;21,"00409-7332-01 ")
 ;;1008
 ;;21,"00409-7332-61 ")
 ;;1009
 ;;21,"00409-7333-04 ")
 ;;1010
 ;;21,"00409-7333-49 ")
 ;;1011
 ;;21,"00409-7334-10 ")
 ;;1012
 ;;21,"00409-7335-03 ")
 ;;1013
 ;;21,"00409-7335-61 ")
 ;;1014
 ;;21,"00409-7336-04 ")
 ;;1015
 ;;21,"00409-7336-49 ")
 ;;1016
 ;;21,"00409-7337-01 ")
 ;;1017
 ;;21,"00409-7338-01 ")
 ;;1018
 ;;21,"00430-0111-20 ")
 ;;1019
 ;;21,"00430-0111-96 ")
 ;;1020
 ;;21,"00430-0112-24 ")
 ;;1021
 ;;21,"00430-0112-96 ")
 ;;1022
 ;;21,"00430-0113-20 ")
 ;;1023
 ;;21,"00430-0114-20 ")
 ;;1024
 ;;21,"00430-0115-20 ")
 ;;1025
 ;;21,"00430-0115-95 ")
 ;;1026
 ;;21,"00430-2782-17 ")
 ;;1027
 ;;21,"00430-2783-17 ")
 ;;1028
 ;;21,"00440-1101-30 ")
 ;;1029
 ;;21,"00440-2406-20 ")
 ;;1030
 ;;21,"00440-7101-30 ")
 ;;1031
 ;;21,"00440-7105-30 ")
 ;;1032
 ;;21,"00440-7108-20 ")
 ;;1033
 ;;21,"00440-7175-06 ")
 ;;1034
 ;;21,"00440-7240-28 ")
 ;;1035
 ;;21,"00440-7241-21 ")
 ;;1036
 ;;21,"00440-7290-06 ")
 ;;1037
 ;;21,"00440-7291-20 ")
 ;;1038
 ;;21,"00440-7300-30 ")
 ;;1039
 ;;21,"00440-7381-40 ")
 ;;1040
 ;;21,"00440-7481-14 ")
 ;;1041
 ;;21,"00440-7483-92 ")
 ;;1042
 ;;21,"00440-7512-40 ")
 ;;1043
 ;;21,"00440-8050-40 ")
 ;;1044
 ;;21,"00440-8055-40 ")
 ;;1045
 ;;21,"00440-8056-20 ")
 ;;1046
 ;;21,"00440-8358-20 ")
 ;;1047
 ;;21,"00440-8406-03 ")
 ;;1048
 ;;21,"00440-8505-40 ")
 ;;1049
 ;;21,"00472-0850-10 ")
 ;;1050
 ;;21,"00472-1285-16 ")
 ;;1051
 ;;21,"00472-1285-33 ")
 ;;1052
 ;;21,"00490-0085-00 ")
 ;;1053
 ;;21,"00490-0085-30 ")
 ;;1054
 ;;21,"00490-0085-60 ")
 ;;1055
 ;;21,"00490-0085-90 ")
 ;;1056
 ;;21,"00517-8711-10 ")
 ;;1057
 ;;21,"00517-8722-10 ")
 ;;1058
 ;;21,"00517-8725-10 ")
 ;;1059
 ;;21,"00517-8750-10 ")
 ;;1060
 ;;21,"00527-1335-01 ")
 ;;1061
 ;;21,"00527-1336-01 ")
 ;;1062
 ;;21,"00527-1338-25 ")
 ;;1063
 ;;21,"00527-1338-50 ")
 ;;1064
 ;;21,"00527-1382-01 ")
 ;;1065
 ;;21,"00527-1383-01 ")
 ;;1066
 ;;21,"00527-1383-02 ")
 ;;1067
 ;;21,"00527-1384-01 ")
 ;;1068
 ;;21,"00527-1385-01 ")
 ;;1069
 ;;21,"00527-1386-50 ")
 ;;1070
 ;;21,"00527-1442-01 ")
 ;;1071
 ;;21,"00527-1443-01 ")
 ;;1072
 ;;21,"00527-1443-05 ")
 ;;1073
 ;;21,"00527-1535-01 ")
 ;;1074
 ;;21,"00527-1537-30 ")
 ;;1075
 ;;21,"00555-0010-02 ")
 ;;1076
 ;;21,"00555-0010-05 ")
 ;;1077
 ;;21,"00555-0011-02 ")
 ;;1078
 ;;21,"00555-0011-05 ")
 ;;1079
 ;;21,"00555-0178-01 ")
 ;;1080
 ;;21,"00555-0178-02 ")
 ;;1081
 ;;21,"00555-0179-01 ")
 ;;1082
 ;;21,"00555-0179-02 ")
 ;;1083
 ;;21,"00555-0180-01 ")
 ;;1084
 ;;21,"00555-0180-02 ")
 ;;1085
 ;;21,"00555-0259-02 ")
 ;;1086
 ;;21,"00555-0259-04 ")
 ;;1087
 ;;21,"00555-0379-87 ")
 ;;1088
 ;;21,"00555-0380-87 ")
 ;;1089
 ;;21,"00555-0445-22 ")
 ;;1090
 ;;21,"00555-0445-23 ")
 ;;1091
 ;;21,"00555-0816-10 ")
 ;;1092
 ;;21,"00574-0129-01 ")
 ;;1093
 ;;21,"00591-0410-01 ")
 ;;1094
 ;;21,"00591-0411-50 ")
 ;;1095
 ;;21,"00591-2234-01 ")
 ;;1096
 ;;21,"00591-2234-10 ")
 ;;1097
 ;;21,"00591-2235-01 ")
 ;;1098
 ;;21,"00591-2235-10 ")
 ;;1099
 ;;21,"00591-2365-69 ")
 ;;1100
 ;;21,"00591-2805-60 ")
 ;;1101
 ;;21,"00591-3120-01 ")
 ;;1102
 ;;21,"00591-3120-16 ")
 ;;1103
 ;;21,"00591-3153-01 ")
 ;;1104
 ;;21,"00591-3224-15 ")
 ;;1105
 ;;21,"00591-3549-69 ")
 ;;1106
 ;;21,"00591-3550-57 ")
 ;;1107
 ;;21,"00591-3550-68 ")
 ;;1108
 ;;21,"00591-5440-05 ")
 ;;1109
 ;;21,"00591-5440-50 ")
 ;;1110
 ;;21,"00591-5535-50 ")
 ;;1111
 ;;21,"00591-5553-05 ")
 ;;1112
 ;;21,"00591-5553-50 ")
 ;;1113
 ;;21,"00591-5571-01 ")
 ;;1114
 ;;21,"00591-5694-01 ")
 ;;1115
 ;;21,"00591-5694-60 ")
 ;;1116
 ;;21,"00591-5695-50 ")
 ;;1117
 ;;21,"00591-5708-01 ")
 ;;1118
 ;;21,"00603-1684-58 ")
 ;;1119
 ;;21,"00603-1685-58 ")
 ;;1120
 ;;21,"00603-3480-19 ")
 ;;1121
 ;;21,"00603-3481-19 ")
 ;;1122
 ;;21,"00603-3481-28 ")
 ;;1123
 ;;21,"00603-3482-19 ")
 ;;1124
 ;;21,"00603-3482-28 ")
 ;;1125
 ;;21,"00603-5780-21 ")
 ;;1126
 ;;21,"00603-5780-28 ")
 ;;1127
 ;;21,"00603-5781-21 ")
 ;;1128
 ;;21,"00603-5781-28 ")
 ;;1129
 ;;21,"00603-6500-84 ")
 ;;1130
 ;;21,"00603-8537-47 ")
 ;;1131
 ;;21,"00641-2764-43 ")
 ;;1132
 ;;21,"00686-3145-09 ")
 ;;1133
 ;;21,"00703-0315-01 ")
 ;;1134
 ;;21,"00703-0315-03 ")
 ;;1135
 ;;21,"00703-0325-03 ")
 ;;1136
 ;;21,"00703-0335-04 ")
 ;;1137
 ;;21,"00703-0346-03 ")
 ;;1138
 ;;21,"00703-0359-01 ")
 ;;1139
 ;;21,"00703-0956-01 ")
 ;;1140
 ;;21,"00703-0956-03 ")
 ;;1141
 ;;21,"00703-0958-01 ")
 ;;1142
 ;;21,"00703-0958-03 ")
 ;;1143
 ;;21,"00703-0960-31 ")
 ;;1144
 ;;21,"00703-0960-36 ")
 ;;1145
 ;;21,"00703-0969-31 ")
 ;;1146
 ;;21,"00703-0969-36 ")
 ;;1147
 ;;21,"00703-9089-01 ")
 ;;1148
 ;;21,"00703-9503-01 ")
 ;;1149
 ;;21,"00703-9503-03 ")
 ;;1150
 ;;21,"00703-9514-01 ")
 ;;1151
 ;;21,"00703-9514-03 ")
 ;;1152
 ;;21,"00703-9526-01 ")
 ;;1153
 ;;21,"00777-0869-02 ")
 ;;1154
 ;;21,"00777-0869-20 ")
 ;;1155
 ;;21,"00777-0871-02 ")
 ;;1156
 ;;21,"00777-0871-20 ")
 ;;1157
 ;;21,"00781-1205-01 ")
 ;;1158
 ;;21,"00781-1205-10 ")
 ;;1159
 ;;21,"00781-1496-31 ")
 ;;1160
 ;;21,"00781-1496-68 ")
 ;;1161
 ;;21,"00781-1496-69 ")
 ;;1162
 ;;21,"00781-1497-31 ")
 ;;1163
 ;;21,"00781-1619-66 ")
 ;;1164
 ;;21,"00781-1643-66 ")
 ;;1165
 ;;21,"00781-1655-01 ")
 ;;1166
 ;;21,"00781-1655-10 ")
 ;;1167
 ;;21,"00781-1831-20 ")
 ;;1168
 ;;21,"00781-1852-20 ")
 ;;1169
 ;;21,"00781-1874-31 ")
 ;;1170
 ;;21,"00781-1941-31 ")
 ;;1171
 ;;21,"00781-1941-33 ")
 ;;1172
 ;;21,"00781-1943-39 ")
 ;;1173
 ;;21,"00781-1943-82 ")
 ;;1174
 ;;21,"00781-1961-60 ")
 ;;1175
 ;;21,"00781-1962-60 ")
 ;;1176
 ;;21,"00781-2020-01 ")
 ;;1177
 ;;21,"00781-2020-05 ")
 ;;1178
 ;;21,"00781-2020-31 ")
 ;;1179
 ;;21,"00781-2020-76 ")
 ;;1180