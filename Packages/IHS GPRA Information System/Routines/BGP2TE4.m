BGP2TE4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"52544-0778-01 ")
 ;;1281
 ;;21,"52544-0865-10 ")
 ;;976
 ;;21,"52959-0050-30 ")
 ;;2293
 ;;21,"52959-0072-01 ")
 ;;849
 ;;21,"52959-0209-90 ")
 ;;402
 ;;21,"52959-0910-90 ")
 ;;539
 ;;21,"52959-0911-30 ")
 ;;671
 ;;21,"52959-0911-90 ")
 ;;672
 ;;21,"52959-0982-60 ")
 ;;1733
 ;;21,"52959-0996-60 ")
 ;;1675
 ;;21,"53002-1129-00 ")
 ;;2291
 ;;21,"53002-1129-03 ")
 ;;2292
 ;;21,"53002-1205-00 ")
 ;;2235
 ;;21,"53002-1205-03 ")
 ;;2236
 ;;21,"53002-1467-00 ")
 ;;2168
 ;;21,"53002-1467-03 ")
 ;;2169
 ;;21,"53489-0368-01 ")
 ;;1479
 ;;21,"53489-0369-01 ")
 ;;1504
 ;;21,"53489-0370-01 ")
 ;;1428
 ;;21,"53746-0006-01 ")
 ;;540
 ;;21,"53746-0006-05 ")
 ;;541
 ;;21,"53746-0007-01 ")
 ;;669
 ;;21,"53746-0007-05 ")
 ;;670
 ;;21,"53746-0008-01 ")
 ;;396
 ;;21,"53746-0008-05 ")
 ;;397
 ;;21,"54458-0948-08 ")
 ;;1827
 ;;21,"54458-0950-10 ")
 ;;1778
 ;;21,"54569-0639-00 ")
 ;;2114
 ;;21,"54569-0639-01 ")
 ;;2115
 ;;21,"54569-0639-02 ")
 ;;2116
 ;;21,"54569-0646-00 ")
 ;;2046
 ;;21,"54569-0646-01 ")
 ;;2047
 ;;21,"54569-0646-02 ")
 ;;2048
 ;;21,"54569-2780-00 ")
 ;;1805
 ;;21,"54569-2780-01 ")
 ;;1806
 ;;21,"54569-2780-02 ")
 ;;1807
 ;;21,"54569-2780-03 ")
 ;;1808
 ;;21,"54569-2781-00 ")
 ;;1856
 ;;21,"54569-2781-01 ")
 ;;1857
 ;;21,"54569-2912-02 ")
 ;;799
 ;;21,"54569-3055-00 ")
 ;;1899
 ;;21,"54569-3055-02 ")
 ;;1900
 ;;21,"54569-3665-00 ")
 ;;1343
 ;;21,"54569-3665-01 ")
 ;;1344
 ;;21,"54569-3667-00 ")
 ;;1389
 ;;21,"54569-3667-01 ")
 ;;1390
 ;;21,"54569-3667-02 ")
 ;;1391
 ;;21,"54569-3691-00 ")
 ;;2290
 ;;21,"54569-3718-00 ")
 ;;1549
 ;;21,"54569-3718-03 ")
 ;;1550
 ;;21,"54569-3719-00 ")
 ;;1473
 ;;21,"54569-3784-00 ")
 ;;793
 ;;21,"54569-3785-00 ")
 ;;803
 ;;21,"54569-3785-02 ")
 ;;804
 ;;21,"54569-3786-00 ")
 ;;784
 ;;21,"54569-3786-01 ")
 ;;785
 ;;21,"54569-3802-00 ")
 ;;2253
 ;;21,"54569-3803-00 ")
 ;;939
 ;;21,"54569-3804-00 ")
 ;;989
 ;;21,"54569-3866-00 ")
 ;;765
 ;;21,"54569-3866-01 ")
 ;;766
 ;;21,"54569-3866-02 ")
 ;;767
 ;;21,"54569-3891-00 ")
 ;;1619
 ;;21,"54569-3891-01 ")
 ;;1620
 ;;21,"54569-3892-00 ")
 ;;1681
 ;;21,"54569-3893-00 ")
 ;;1740
 ;;21,"54569-4183-00 ")
 ;;1500
 ;;21,"54569-4211-00 ")
 ;;831
 ;;21,"54569-4447-00 ")
 ;;2237
 ;;21,"54569-4447-01 ")
 ;;2238
 ;;21,"54569-4447-04 ")
 ;;2239
 ;;21,"54569-4455-00 ")
 ;;884
 ;;21,"54569-4472-00 ")
 ;;487
 ;;21,"54569-4472-01 ")
 ;;488
 ;;21,"54569-4498-00 ")
 ;;2357
 ;;21,"54569-4499-00 ")
 ;;2358
 ;;21,"54569-4622-00 ")
 ;;1920
 ;;21,"54569-4623-00 ")
 ;;1934
 ;;21,"54569-4696-00 ")
 ;;112
 ;;21,"54569-4696-01 ")
 ;;113
 ;;21,"54569-4715-00 ")
 ;;1165
 ;;21,"54569-4716-00 ")
 ;;1190
 ;;21,"54569-4717-00 ")
 ;;1214
 ;;21,"54569-4913-00 ")
 ;;975
 ;;21,"54569-4914-00 ")
 ;;1031
 ;;21,"54569-4924-00 ")
 ;;1072
 ;;21,"54569-4991-00 ")
 ;;1912
 ;;21,"54569-4992-00 ")
 ;;1943
 ;;21,"54569-5155-00 ")
 ;;1780
 ;;21,"54569-5156-00 ")
 ;;1828
 ;;21,"54569-5157-00 ")
 ;;1866
 ;;21,"54569-5232-00 ")
 ;;155
 ;;21,"54569-5232-01 ")
 ;;156
 ;;21,"54569-5282-00 ")
 ;;76
 ;;21,"54569-5370-00 ")
 ;;582
 ;;21,"54569-5431-00 ")
 ;;893
 ;;21,"54569-5704-00 ")
 ;;306
 ;;21,"54569-5878-00 ")
 ;;42
 ;;21,"54569-5881-00 ")
 ;;264
 ;;21,"54569-5901-00 ")
 ;;667
 ;;21,"54569-5901-01 ")
 ;;668
 ;;21,"54569-5902-00 ")
 ;;400
 ;;21,"54569-5902-01 ")
 ;;401
 ;;21,"54569-5937-00 ")
 ;;89
 ;;21,"54569-5938-00 ")
 ;;133
 ;;21,"54569-5951-00 ")
 ;;274
 ;;21,"54569-6099-00 ")
 ;;281
 ;;21,"54569-6117-00 ")
 ;;1448
 ;;21,"54738-0904-01 ")
 ;;1476
 ;;21,"54738-0904-03 ")
 ;;1477
 ;;21,"54738-0904-90 ")
 ;;1478
 ;;21,"54738-0905-01 ")
 ;;1501
 ;;21,"54738-0905-03 ")
 ;;1502
 ;;21,"54738-0905-90 ")
 ;;1503
 ;;21,"54738-0906-01 ")
 ;;1429
 ;;21,"54738-0906-03 ")
 ;;1430
 ;;21,"54738-0906-90 ")
 ;;1431
 ;;21,"54868-0120-00 ")
 ;;2109
 ;;21,"54868-0120-01 ")
 ;;2110
 ;;21,"54868-0120-02 ")
 ;;2111
 ;;21,"54868-0120-03 ")
 ;;2112
 ;;21,"54868-0120-04 ")
 ;;2113
 ;;21,"54868-0121-00 ")
 ;;2049
 ;;21,"54868-0121-01 ")
 ;;2050
 ;;21,"54868-0121-02 ")
 ;;2051
 ;;21,"54868-0121-05 ")
 ;;2052
 ;;21,"54868-0121-06 ")
 ;;2053
 ;;21,"54868-0671-00 ")
 ;;1348
 ;;21,"54868-0823-00 ")
 ;;1487
 ;;21,"54868-0826-00 ")
 ;;1445
 ;;21,"54868-0826-01 ")
 ;;1446
 ;;21,"54868-0826-02 ")
 ;;1447
 ;;21,"54868-0933-00 ")
 ;;2003
 ;;21,"54868-1005-00 ")
 ;;780
 ;;21,"54868-1006-02 ")
 ;;1803
 ;;21,"54868-1006-03 ")
 ;;1804
 ;;21,"54868-1008-00 ")
 ;;1853
 ;;21,"54868-1008-01 ")
 ;;1854
 ;;21,"54868-1008-02 ")
 ;;1855
 ;;21,"54868-1207-00 ")
 ;;311
 ;;21,"54868-1207-01 ")
 ;;312
 ;;21,"54868-1283-00 ")
 ;;2276
 ;;21,"54868-1283-01 ")
 ;;2277
 ;;21,"54868-1443-03 ")
 ;;1898
 ;;21,"54868-1550-03 ")
 ;;2202
 ;;21,"54868-2147-02 ")
 ;;2151
 ;;21,"54868-2148-03 ")
 ;;933
 ;;21,"54868-2149-00 ")
 ;;994
 ;;21,"54868-2149-02 ")
 ;;995
 ;;21,"54868-2150-01 ")
 ;;1048
 ;;21,"54868-2167-00 ")
 ;;1536
 ;;21,"54868-2167-02 ")
 ;;1537
 ;;21,"54868-2168-02 ")
 ;;1465
 ;;21,"54868-2168-03 ")
 ;;1466
 ;;21,"54868-2200-00 ")
 ;;1989
 ;;21,"54868-2200-02 ")
 ;;1990
 ;;21,"54868-2207-00 ")
 ;;2324
 ;;21,"54868-2207-01 ")
 ;;2325
 ;;21,"54868-2207-02 ")
 ;;2326
 ;;21,"54868-2207-03 ")
 ;;2327
 ;;21,"54868-2207-04 ")
 ;;2328
 ;;21,"54868-2207-05 ")
 ;;2329
 ;;21,"54868-2207-06 ")
 ;;2330
 ;;21,"54868-2207-07 ")
 ;;2331
 ;;21,"54868-2211-00 ")
 ;;1951
 ;;21,"54868-2276-01 ")
 ;;1359
 ;;21,"54868-2276-02 ")
 ;;1360
 ;;21,"54868-2277-00 ")
 ;;1416
 ;;21,"54868-2290-00 ")
 ;;1298
 ;;21,"54868-2290-01 ")
 ;;1299
 ;;21,"54868-2290-02 ")
 ;;1300
 ;;21,"54868-2290-03 ")
 ;;1301
 ;;21,"54868-2290-04 ")
 ;;1302
 ;;21,"54868-2322-01 ")
 ;;832
 ;;21,"54868-2322-02 ")
 ;;833
 ;;21,"54868-2322-03 ")
 ;;834
 ;;21,"54868-2469-00 ")
 ;;1551
 ;;21,"54868-2469-01 ")
 ;;1552
 ;;21,"54868-2868-00 ")
 ;;1632
 ;;21,"54868-2868-01 ")
 ;;1633
 ;;21,"54868-2868-02 ")
 ;;1634
 ;;21,"54868-2868-05 ")
 ;;1635
 ;;21,"54868-2869-00 ")
 ;;1691
 ;;21,"54868-2869-01 ")
 ;;1692
 ;;21,"54868-2869-03 ")
 ;;1693
 ;;21,"54868-2870-00 ")
 ;;1746
 ;;21,"54868-2873-00 ")
 ;;760
 ;;21,"54868-2873-01 ")
 ;;761
 ;;21,"54868-2873-03 ")
 ;;762
 ;;21,"54868-2873-04 ")
 ;;763
 ;;21,"54868-2873-05 ")
 ;;764
 ;;21,"54868-2885-00 ")
 ;;2085
 ;;21,"54868-2975-02 ")
 ;;857
 ;;21,"54868-2975-03 ")
 ;;858
 ;;21,"54868-3102-00 ")
 ;;808
 ;;21,"54868-3102-03 ")
 ;;809
 ;;21,"54868-3103-00 ")
 ;;817
 ;;21,"54868-3103-02 ")
 ;;818
 ;;21,"54868-3103-03 ")
 ;;819
 ;;21,"54868-3103-04 ")
 ;;820
 ;;21,"54868-3103-05 ")
 ;;821
 ;;21,"54868-3214-00 ")
 ;;796
 ;;21,"54868-3214-01 ")
 ;;797
 ;;21,"54868-3287-00 ")
 ;;301
 ;;21,"54868-3287-01 ")
 ;;302
 ;;21,"54868-3300-00 ")
 ;;2217
 ;;21,"54868-3300-01 ")
 ;;2218
 ;;21,"54868-3300-02 ")
 ;;2219
 ;;21,"54868-3300-03 ")
 ;;2220
 ;;21,"54868-3300-04 ")
 ;;2221
 ;;21,"54868-3464-01 ")
 ;;485
 ;;21,"54868-3464-02 ")
 ;;486
 ;;21,"54868-3774-00 ")
 ;;1162
 ;;21,"54868-3817-00 ")
 ;;1608
 ;;21,"54868-3853-01 ")
 ;;579
 ;;21,"54868-3853-02 ")
 ;;580
 ;;21,"54868-3853-03 ")
 ;;581
 ;;21,"54868-3956-00 ")
 ;;1185
 ;;21,"54868-3956-01 ")
 ;;1186
 ;;21,"54868-3956-02 ")
 ;;1187
 ;;21,"54868-3958-00 ")
 ;;1211
 ;;21,"54868-4011-00 ")
 ;;1906
 ;;21,"54868-4011-01 ")
 ;;1907
 ;;21,"54868-4011-02 ")
 ;;1908
 ;;21,"54868-4011-03 ")
 ;;1909
 ;;21,"54868-4064-00 ")
 ;;1560
 ;;21,"54868-4064-01 ")
 ;;1561
 ;;21,"54868-4066-00 ")
 ;;77
 ;;21,"54868-4066-01 ")
 ;;78
 ;;21,"54868-4068-00 ")
 ;;1259
 ;;21,"54868-4073-00 ")
 ;;116
 ;;21,"54868-4073-01 ")
 ;;117
 ;;21,"54868-4073-02 ")
 ;;118
 ;;21,"54868-4073-03 ")
 ;;119
 ;;21,"54868-4074-00 ")
 ;;160
 ;;21,"54868-4074-01 ")
 ;;161
 ;;21,"54868-4074-02 ")
 ;;162
 ;;21,"54868-4074-03 ")
 ;;163
 ;;21,"54868-4074-04 ")
 ;;164
 ;;21,"54868-4184-00 ")
 ;;866
 ;;21,"54868-4184-01 ")
 ;;867
 ;;21,"54868-4184-02 ")
 ;;868
 ;;21,"54868-4186-00 ")
 ;;842
 ;;21,"54868-4186-01 ")
 ;;843
 ;;21,"54868-4186-02 ")
 ;;844
 ;;21,"54868-4186-03 ")
 ;;845
 ;;21,"54868-4200-00 ")
 ;;1922
 ;;21,"54868-4200-01 ")
 ;;1923
 ;;21,"54868-4200-02 ")
 ;;1924
 ;;21,"54868-4202-00 ")
 ;;1944
 ;;21,"54868-4202-01 ")
 ;;1945
 ;;21,"54868-4418-00 ")
 ;;1233
 ;;21,"54868-4432-00 ")
 ;;2178
 ;;21,"54868-4432-01 ")
 ;;2179
 ;;21,"54868-4531-00 ")
 ;;1721
 ;;21,"54868-4531-01 ")
 ;;1722
 ;;21,"54868-4531-02 ")
 ;;1723
 ;;21,"54868-4531-03 ")
 ;;1724
 ;;21,"54868-4531-04 ")
 ;;1725
 ;;21,"54868-4532-00 ")
 ;;1663
 ;;21,"54868-4532-01 ")
 ;;1664
 ;;21,"54868-4532-02 ")
 ;;1665
 ;;21,"54868-4532-03 ")
 ;;1666
 ;;21,"54868-4532-04 ")
 ;;1667
 ;;21,"54868-4808-00 ")
 ;;1085
 ;;21,"54868-4868-00 ")
 ;;1012
 ;;21,"54868-4868-01 ")
 ;;1013
 ;;21,"54868-4868-02 ")
 ;;1014
 ;;21,"54868-4870-00 ")
 ;;39
 ;;21,"54868-4870-01 ")
 ;;40
 ;;21,"54868-4870-02 ")
 ;;41
 ;;21,"54868-4875-00 ")
 ;;1876
 ;;21,"54868-4875-01 ")
 ;;1877
 ;;21,"54868-4875-02 ")
 ;;1878
 ;;21,"54868-4970-00 ")
 ;;908
 ;;21,"54868-4970-01 ")
 ;;909
 ;;21,"54868-4970-02 ")
 ;;910
 ;;21,"54868-4992-00 ")
 ;;1060
 ;;21,"54868-4992-01 ")
 ;;1061
 ;;21,"54868-5053-00 ")
 ;;1270
 ;;21,"54868-5053-01 ")
 ;;1271
 ;;21,"54868-5081-00 ")
 ;;960
 ;;21,"54868-5150-00 ")
 ;;947
 ;;21,"54868-5179-00 ")
 ;;316
 ;;21,"54868-5197-00 ")
 ;;1517
 ;;21,"54868-5197-01 ")
 ;;1518
 ;;21,"54868-5197-02 ")
 ;;1519
 ;;21,"54868-5200-00 ")
 ;;278
 ;;21,"54868-5200-01 ")
 ;;279
 ;;21,"54868-5208-00 ")
 ;;1248
 ;;21,"54868-5208-01 ")
 ;;1249
 ;;21,"54868-5209-00 ")
 ;;270
 ;;21,"54868-5209-01 ")
 ;;271
 ;;21,"54868-5301-00 ")
 ;;1104
 ;;21,"54868-5311-00 ")
 ;;193
 ;;21,"54868-5311-01 ")
 ;;194
 ;;21,"54868-5316-00 ")
 ;;997
 ;;21,"54868-5320-00 ")
 ;;200
 ;;21,"54868-5320-01 ")
 ;;201
 ;;21,"54868-5320-02 ")
 ;;202
 ;;21,"54868-5320-03 ")
 ;;203
 ;;21,"54868-5320-04 ")
 ;;204
 ;;21,"54868-5420-00 ")
 ;;320
 ;;21,"54868-5476-00 ")
 ;;1573
 ;;21,"54868-5523-00 ")
 ;;284
 ;;21,"54868-5523-01 ")
 ;;285
 ;;21,"54868-5548-00 ")
 ;;184
 ;;21,"54868-5548-01 ")
 ;;185
 ;;21,"54868-5548-02 ")
 ;;186
 ;;21,"54868-5561-00 ")
 ;;1562
 ;;21,"54868-5561-01 ")
 ;;1563
 ;;21,"54868-5567-00 ")
 ;;263
 ;;21,"54868-5672-00 ")
 ;;292
 ;;21,"54868-5690-00 ")
 ;;53
 ;;21,"54868-5690-01 ")
 ;;54
 ;;21,"54868-5690-02 ")
 ;;55
 ;;21,"54868-5690-03 ")
 ;;56
 ;;21,"54868-5699-00 ")
 ;;296
 ;;21,"54868-5761-00 ")
 ;;683
 ;;21,"54868-5761-01 ")
 ;;684
 ;;21,"54868-5761-02 ")
 ;;685
 ;;21,"54868-5762-00 ")
 ;;411
 ;;21,"54868-5762-01 ")
 ;;412
 ;;21,"54868-5762-02 ")
 ;;413
 ;;21,"54868-5764-00 ")
 ;;542
 ;;21,"54868-5764-01 ")
 ;;543
 ;;21,"54868-5781-00 ")
 ;;1
 ;;21,"54868-5781-01 ")
 ;;2
 ;;21,"54868-5781-02 ")
 ;;3
 ;;21,"54868-5781-03 ")
 ;;4
 ;;21,"54868-5782-00 ")
 ;;123
 ;;21,"54868-5782-01 ")
 ;;124
 ;;21,"54868-5782-02 ")
 ;;125
 ;;21,"54868-5782-03 ")
 ;;126
 ;;21,"54868-5782-04 ")
 ;;127
 ;;21,"54868-5783-00 ")
 ;;175
 ;;21,"54868-5783-01 ")
 ;;176
 ;;21,"54868-5792-00 ")
 ;;82
 ;;21,"54868-5792-01 ")
 ;;83
 ;;21,"54868-5792-02 ")
 ;;84
 ;;21,"54868-5793-00 ")
 ;;67
 ;;21,"54868-5793-01 ")
 ;;68
 ;;21,"54868-5804-00 ")
 ;;225
 ;;21,"54868-5841-00 ")
 ;;1991
 ;;21,"54868-5841-01 ")
 ;;1992
 ;;21,"54868-5841-02 ")
 ;;1993
 ;;21,"54868-5931-00 ")
 ;;1939
 ;;21,"54868-5931-01 ")
 ;;1940
 ;;21,"54868-5983-00 ")
 ;;229
 ;;21,"54868-5983-01 ")
 ;;230
 ;;21,"54868-5984-00 ")
 ;;2000
 ;;21,"54868-5984-01 ")
 ;;2001
 ;;21,"54868-5993-00 ")
 ;;1928
 ;;21,"54868-5993-01 ")
 ;;1929
 ;;21,"54868-5996-00 ")
 ;;238
 ;;21,"54868-5996-01 ")
 ;;239
 ;;21,"54868-5997-00 ")
 ;;232
 ;;21,"54868-5997-01 ")
 ;;233
 ;;21,"54868-6036-00 ")
 ;;218
 ;;21,"54868-6123-00 ")
 ;;247
 ;;21,"54868-6124-00 ")
 ;;1977
 ;;21,"54868-6124-01 ")
 ;;1978
 ;;21,"54868-6250-00 ")
 ;;217
 ;;21,"55045-1858-08 ")
 ;;996
 ;;21,"55045-1921-08 ")
 ;;932
 ;;21,"55045-2321-08 ")
 ;;2278
 ;;21,"55045-2321-09 ")
 ;;2279
 ;;21,"55045-2357-08 ")
 ;;1361
 ;;21,"55045-2846-08 ")
 ;;846
 ;;21,"55045-3017-06 ")
 ;;2057
 ;;21,"55045-3043-09 ")
 ;;2222
 ;;21,"55045-3344-01 ")
 ;;757
 ;;21,"55045-3499-01 ")
 ;;482
 ;;21,"55045-3791-01 ")
 ;;1306
 ;;21,"55045-3792-01 ")
 ;;1415
 ;;21,"55045-3794-09 ")
 ;;680
 ;;21,"55045-3795-09 ")
 ;;544
 ;;21,"55045-3796-09 ")
 ;;405
 ;;21,"55048-0018-30 ")
 ;;406
 ;;21,"55048-0018-90 ")
 ;;407
 ;;21,"55048-0019-30 ")
 ;;678
 ;;21,"55048-0019-90 ")
 ;;679
 ;;21,"55048-0020-30 ")
 ;;81
 ;;21,"55048-0021-30 ")
 ;;7
 ;;21,"55048-0022-30 ")
 ;;120
 ;;21,"55048-0023-30 ")
 ;;231
 ;;21,"55048-0024-30 ")
 ;;234
 ;;21,"55111-0269-90 ")
 ;;545
 ;;21,"55111-0270-05 ")
 ;;676
 ;;21,"55111-0270-90 ")
 ;;677
 ;;21,"55111-0271-05 ")
 ;;408
