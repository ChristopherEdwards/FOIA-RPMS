BGP21F2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00173-0790-02 ")
 ;;2110
 ;;21,"00173-0791-01 ")
 ;;2099
 ;;21,"00173-0791-02 ")
 ;;2100
 ;;21,"00182-1001-89 ")
 ;;381
 ;;21,"00182-1812-89 ")
 ;;2137
 ;;21,"00182-1813-89 ")
 ;;2219
 ;;21,"00182-1814-89 ")
 ;;2307
 ;;21,"00182-1815-89 ")
 ;;2399
 ;;21,"00182-2632-89 ")
 ;;1888
 ;;21,"00182-2633-89 ")
 ;;1915
 ;;21,"00182-2634-89 ")
 ;;1949
 ;;21,"00182-8202-00 ")
 ;;1138
 ;;21,"00182-8202-89 ")
 ;;1139
 ;;21,"00182-8203-00 ")
 ;;1188
 ;;21,"00182-8203-89 ")
 ;;1189
 ;;21,"00182-8235-00 ")
 ;;397
 ;;21,"00182-8235-89 ")
 ;;398
 ;;21,"00182-8236-00 ")
 ;;555
 ;;21,"00182-8236-89 ")
 ;;556
 ;;21,"00185-0010-01 ")
 ;;1145
 ;;21,"00185-0010-05 ")
 ;;1146
 ;;21,"00185-0117-01 ")
 ;;1196
 ;;21,"00185-0117-05 ")
 ;;1197
 ;;21,"00185-0118-01 ")
 ;;1226
 ;;21,"00185-0118-05 ")
 ;;1227
 ;;21,"00185-0281-01 ")
 ;;1323
 ;;21,"00185-0281-10 ")
 ;;1324
 ;;21,"00185-0282-01 ")
 ;;1372
 ;;21,"00185-0282-10 ")
 ;;1373
 ;;21,"00185-0283-01 ")
 ;;1243
 ;;21,"00185-0283-10 ")
 ;;1244
 ;;21,"00185-0284-01 ")
 ;;1291
 ;;21,"00185-0284-10 ")
 ;;1292
 ;;21,"00185-0701-01 ")
 ;;113
 ;;21,"00185-0701-05 ")
 ;;114
 ;;21,"00185-0701-30 ")
 ;;115
 ;;21,"00185-0704-01 ")
 ;;147
 ;;21,"00185-0704-05 ")
 ;;148
 ;;21,"00185-0704-30 ")
 ;;149
 ;;21,"00185-0707-01 ")
 ;;74
 ;;21,"00185-0707-05 ")
 ;;75
 ;;21,"00185-0707-30 ")
 ;;76
 ;;21,"00185-0771-01 ")
 ;;772
 ;;21,"00185-0771-30 ")
 ;;773
 ;;21,"00185-0774-01 ")
 ;;751
 ;;21,"00185-0774-30 ")
 ;;752
 ;;21,"00186-1088-05 ")
 ;;1325
 ;;21,"00186-1088-39 ")
 ;;1326
 ;;21,"00186-1090-05 ")
 ;;1374
 ;;21,"00186-1090-39 ")
 ;;1375
 ;;21,"00186-1090-50 ")
 ;;1362
 ;;21,"00186-1092-05 ")
 ;;1245
 ;;21,"00186-1092-39 ")
 ;;1246
 ;;21,"00186-1094-05 ")
 ;;1293
 ;;21,"00186-7300-05 ")
 ;;1317
 ;;21,"00186-7301-05 ")
 ;;1361
 ;;21,"00186-7302-05 ")
 ;;1236
 ;;21,"00186-7303-05 ")
 ;;1287
 ;;21,"00228-2175-11 ")
 ;;980
 ;;21,"00228-2176-11 ")
 ;;1042
 ;;21,"00228-2177-11 ")
 ;;820
 ;;21,"00228-2178-11 ")
 ;;897
 ;;21,"00228-2358-10 ")
 ;;217
 ;;21,"00228-2358-50 ")
 ;;215
 ;;21,"00228-2358-96 ")
 ;;216
 ;;21,"00228-2360-10 ")
 ;;223
 ;;21,"00228-2650-10 ")
 ;;101
 ;;21,"00228-2651-10 ")
 ;;139
 ;;21,"00228-2652-03 ")
 ;;63
 ;;21,"00228-2778-11 ")
 ;;2044
 ;;21,"00228-2778-50 ")
 ;;2045
 ;;21,"00228-2779-11 ")
 ;;2072
 ;;21,"00228-2779-50 ")
 ;;2073
 ;;21,"00228-2780-11 ")
 ;;1996
 ;;21,"00228-2780-50 ")
 ;;1997
 ;;21,"00228-2781-11 ")
 ;;2021
 ;;21,"00228-2781-50 ")
 ;;2022
 ;;21,"00245-0084-10 ")
 ;;2046
 ;;21,"00245-0084-11 ")
 ;;2047
 ;;21,"00245-0085-10 ")
 ;;2074
 ;;21,"00245-0085-11 ")
 ;;2075
 ;;21,"00245-0086-10 ")
 ;;1998
 ;;21,"00245-0086-11 ")
 ;;1999
 ;;21,"00245-0087-10 ")
 ;;2023
 ;;21,"00245-0087-11 ")
 ;;2024
 ;;21,"00247-1012-00 ")
 ;;281
 ;;21,"00247-1050-04 ")
 ;;2143
 ;;21,"00247-1050-30 ")
 ;;2144
 ;;21,"00247-1050-52 ")
 ;;2145
 ;;21,"00247-1050-59 ")
 ;;2146
 ;;21,"00247-1050-60 ")
 ;;2147
 ;;21,"00247-1051-00 ")
 ;;2312
 ;;21,"00247-1051-30 ")
 ;;2313
 ;;21,"00247-1052-30 ")
 ;;220
 ;;21,"00247-1052-45 ")
 ;;221
 ;;21,"00247-1065-30 ")
 ;;1678
 ;;21,"00247-1072-30 ")
 ;;573
 ;;21,"00247-1072-60 ")
 ;;574
 ;;21,"00247-1119-14 ")
 ;;1679
 ;;21,"00247-1119-30 ")
 ;;1680
 ;;21,"00247-1119-52 ")
 ;;1681
 ;;21,"00247-1119-60 ")
 ;;1682
 ;;21,"00247-1120-30 ")
 ;;1461
 ;;21,"00247-1120-60 ")
 ;;1462
 ;;21,"00247-1121-30 ")
 ;;195
 ;;21,"00247-1121-60 ")
 ;;196
 ;;21,"00247-1122-30 ")
 ;;182
 ;;21,"00247-1122-60 ")
 ;;183
 ;;21,"00247-1123-30 ")
 ;;190
 ;;21,"00247-1123-60 ")
 ;;191
 ;;21,"00247-1146-30 ")
 ;;414
 ;;21,"00247-1146-60 ")
 ;;415
 ;;21,"00247-1273-00 ")
 ;;2229
 ;;21,"00247-1273-79 ")
 ;;2230
 ;;21,"00247-1274-00 ")
 ;;1247
 ;;21,"00247-1274-60 ")
 ;;1248
 ;;21,"00310-0101-10 ")
 ;;282
 ;;21,"00310-0105-10 ")
 ;;575
 ;;21,"00310-0105-34 ")
 ;;530
 ;;21,"00310-0107-10 ")
 ;;416
 ;;21,"00310-0115-10 ")
 ;;33
 ;;21,"00310-0117-10 ")
 ;;7
 ;;21,"00378-0018-01 ")
 ;;1581
 ;;21,"00378-0018-05 ")
 ;;1582
 ;;21,"00378-0018-91 ")
 ;;1583
 ;;21,"00378-0028-01 ")
 ;;1889
 ;;21,"00378-0032-01 ")
 ;;1683
 ;;21,"00378-0032-10 ")
 ;;1684
 ;;21,"00378-0047-01 ")
 ;;1463
 ;;21,"00378-0047-10 ")
 ;;1464
 ;;21,"00378-0052-01 ")
 ;;1988
 ;;21,"00378-0055-01 ")
 ;;2438
 ;;21,"00378-0096-01 ")
 ;;204
 ;;21,"00378-0099-01 ")
 ;;208
 ;;21,"00378-0127-01 ")
 ;;1982
 ;;21,"00378-0182-01 ")
 ;;2148
 ;;21,"00378-0182-10 ")
 ;;2149
 ;;21,"00378-0183-01 ")
 ;;2231
 ;;21,"00378-0183-10 ")
 ;;2232
 ;;21,"00378-0184-01 ")
 ;;2314
 ;;21,"00378-0184-10 ")
 ;;2315
 ;;21,"00378-0185-01 ")
 ;;2405
 ;;21,"00378-0185-05 ")
 ;;2406
 ;;21,"00378-0187-01 ")
 ;;2388
 ;;21,"00378-0218-01 ")
 ;;417
 ;;21,"00378-0218-10 ")
 ;;418
 ;;21,"00378-0221-01 ")
 ;;2430
 ;;21,"00378-0231-01 ")
 ;;576
 ;;21,"00378-0231-10 ")
 ;;577
 ;;21,"00378-0347-01 ")
 ;;226
 ;;21,"00378-0424-01 ")
 ;;197
