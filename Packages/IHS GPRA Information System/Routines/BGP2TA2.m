BGP2TA2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00247-1023-95 ")
 ;;1743
 ;;21,"00247-1090-30 ")
 ;;2423
 ;;21,"00247-1090-60 ")
 ;;2424
 ;;21,"00247-1091-03 ")
 ;;2511
 ;;21,"00247-1091-30 ")
 ;;2512
 ;;21,"00247-1091-60 ")
 ;;2513
 ;;21,"00247-1124-30 ")
 ;;295
 ;;21,"00247-1125-10 ")
 ;;121
 ;;21,"00247-1125-30 ")
 ;;122
 ;;21,"00247-1125-60 ")
 ;;123
 ;;21,"00247-1126-10 ")
 ;;181
 ;;21,"00247-1126-30 ")
 ;;182
 ;;21,"00247-1126-60 ")
 ;;183
 ;;21,"00247-1127-10 ")
 ;;242
 ;;21,"00247-1127-30 ")
 ;;243
 ;;21,"00247-1131-30 ")
 ;;1037
 ;;21,"00247-1131-60 ")
 ;;1038
 ;;21,"00247-1132-30 ")
 ;;1079
 ;;21,"00247-1132-60 ")
 ;;1080
 ;;21,"00247-1147-10 ")
 ;;1497
 ;;21,"00247-1147-30 ")
 ;;1498
 ;;21,"00247-1147-60 ")
 ;;1499
 ;;21,"00247-1148-10 ")
 ;;2099
 ;;21,"00247-1149-30 ")
 ;;1479
 ;;21,"00247-1149-60 ")
 ;;2588
 ;;21,"00247-1150-30 ")
 ;;2593
 ;;21,"00247-1150-60 ")
 ;;2594
 ;;21,"00247-1222-00 ")
 ;;538
 ;;21,"00247-1277-00 ")
 ;;2234
 ;;21,"00247-1380-14 ")
 ;;723
 ;;21,"00247-1381-14 ")
 ;;434
 ;;21,"00247-1381-30 ")
 ;;435
 ;;21,"00247-1381-60 ")
 ;;436
 ;;21,"00247-1381-90 ")
 ;;437
 ;;21,"00247-1396-30 ")
 ;;1668
 ;;21,"00247-1439-04 ")
 ;;1471
 ;;21,"00247-1440-04 ")
 ;;1467
 ;;21,"00247-1525-30 ")
 ;;2309
 ;;21,"00247-1525-59 ")
 ;;2310
 ;;21,"00247-1525-90 ")
 ;;2311
 ;;21,"00247-1635-30 ")
 ;;379
 ;;21,"00247-1636-00 ")
 ;;438
 ;;21,"00247-1636-01 ")
 ;;439
 ;;21,"00247-1636-14 ")
 ;;440
 ;;21,"00247-1636-30 ")
 ;;441
 ;;21,"00247-1636-60 ")
 ;;442
 ;;21,"00247-1636-90 ")
 ;;443
 ;;21,"00247-1636-99 ")
 ;;444
 ;;21,"00247-1637-00 ")
 ;;539
 ;;21,"00247-1637-30 ")
 ;;540
 ;;21,"00247-1637-60 ")
 ;;541
 ;;21,"00247-1881-02 ")
 ;;902
 ;;21,"00247-1881-05 ")
 ;;903
 ;;21,"00247-1881-30 ")
 ;;904
 ;;21,"00247-1881-60 ")
 ;;905
 ;;21,"00247-1882-30 ")
 ;;606
 ;;21,"00247-1882-60 ")
 ;;607
 ;;21,"00247-1882-99 ")
 ;;608
 ;;21,"00247-1919-30 ")
 ;;1500
 ;;21,"00247-1920-30 ")
 ;;1744
 ;;21,"00247-1921-30 ")
 ;;1968
 ;;21,"00247-1955-30 ")
 ;;2276
 ;;21,"00247-1955-60 ")
 ;;2277
 ;;21,"00247-1955-90 ")
 ;;2278
 ;;21,"00247-1956-30 ")
 ;;2372
 ;;21,"00247-1956-60 ")
 ;;2373
 ;;21,"00247-1956-90 ")
 ;;2374
 ;;21,"00247-1957-30 ")
 ;;2340
 ;;21,"00247-1957-60 ")
 ;;2341
 ;;21,"00247-1957-90 ")
 ;;2342
 ;;21,"00247-2001-06 ")
 ;;1501
 ;;21,"00247-2001-30 ")
 ;;1502
 ;;21,"00247-2021-00 ")
 ;;1745
 ;;21,"00247-2021-30 ")
 ;;1746
 ;;21,"00247-2021-60 ")
 ;;1747
 ;;21,"00247-2058-30 ")
 ;;1039
 ;;21,"00247-2107-00 ")
 ;;1244
 ;;21,"00247-2107-30 ")
 ;;1245
 ;;21,"00247-2107-60 ")
 ;;1246
 ;;21,"00247-2107-79 ")
 ;;1247
 ;;21,"00247-2107-90 ")
 ;;1248
 ;;21,"00247-2136-30 ")
 ;;296
 ;;21,"00247-2136-60 ")
 ;;297
 ;;21,"00247-2137-30 ")
 ;;124
 ;;21,"00247-2151-30 ")
 ;;244
 ;;21,"00247-2151-60 ")
 ;;245
 ;;21,"00247-2155-30 ")
 ;;791
 ;;21,"00247-2155-60 ")
 ;;792
 ;;21,"00247-2155-90 ")
 ;;793
 ;;21,"00247-2171-30 ")
 ;;1081
 ;;21,"00247-2237-00 ")
 ;;1969
 ;;21,"00247-2237-30 ")
 ;;1970
 ;;21,"00247-2305-30 ")
 ;;1115
 ;;21,"00247-2305-60 ")
 ;;1116
 ;;21,"00247-2305-90 ")
 ;;1117
 ;;21,"00247-2306-30 ")
 ;;724
 ;;21,"00247-2306-60 ")
 ;;725
 ;;21,"00247-2306-90 ")
 ;;726
 ;;21,"00247-2318-30 ")
 ;;2100
 ;;21,"00247-2318-60 ")
 ;;2101
 ;;21,"00247-2318-90 ")
 ;;2102
 ;;21,"00247-2320-30 ")
 ;;2375
 ;;21,"00247-2320-60 ")
 ;;2376
 ;;21,"00247-2320-90 ")
 ;;2377
 ;;21,"00310-0130-10 ")
 ;;2103
 ;;21,"00310-0130-11 ")
 ;;2104
 ;;21,"00310-0130-34 ")
 ;;2105
 ;;21,"00310-0130-39 ")
 ;;2106
 ;;21,"00310-0131-10 ")
 ;;1503
 ;;21,"00310-0131-11 ")
 ;;1504
 ;;21,"00310-0131-34 ")
 ;;1505
 ;;21,"00310-0132-10 ")
 ;;1748
 ;;21,"00310-0132-11 ")
 ;;1749
 ;;21,"00310-0133-10 ")
 ;;1910
 ;;21,"00310-0133-11 ")
 ;;1911
 ;;21,"00310-0134-10 ")
 ;;1971
 ;;21,"00310-0134-11 ")
 ;;1972
 ;;21,"00310-0135-10 ")
 ;;1669
 ;;21,"00310-0135-11 ")
 ;;1670
 ;;21,"00310-0141-10 ")
 ;;1474
 ;;21,"00310-0141-11 ")
 ;;1475
 ;;21,"00310-0142-10 ")
 ;;2589
 ;;21,"00310-0142-11 ")
 ;;2590
 ;;21,"00310-0145-10 ")
 ;;2595
 ;;21,"00310-0145-11 ")
 ;;2596
 ;;21,"00364-2698-01 ")
 ;;727
 ;;21,"00364-2698-02 ")
 ;;728
 ;;21,"00364-2701-01 ")
 ;;906
 ;;21,"00364-2701-02 ")
 ;;907
 ;;21,"00364-2727-01 ")
 ;;609
 ;;21,"00364-2727-02 ")
 ;;610
 ;;21,"00364-2734-01 ")
 ;;794
 ;;21,"00364-2734-02 ")
 ;;795
 ;;21,"00378-0017-77 ")
 ;;2378
 ;;21,"00378-0081-01 ")
 ;;332
 ;;21,"00378-0083-01 ")
 ;;336
 ;;21,"00378-0084-01 ")
 ;;341
 ;;21,"00378-0086-01 ")
 ;;345
 ;;21,"00378-0226-77 ")
 ;;2279
 ;;21,"00378-0254-77 ")
 ;;2312
 ;;21,"00378-0272-77 ")
 ;;2343
 ;;21,"00378-0441-01 ")
 ;;298
 ;;21,"00378-0443-01 ")
 ;;125
 ;;21,"00378-0444-01 ")
 ;;184
 ;;21,"00378-0447-01 ")
 ;;246
 ;;21,"00378-0542-77 ")
 ;;1364
 ;;21,"00378-0543-77 ")
 ;;1367
 ;;21,"00378-0544-77 ")
 ;;1371
 ;;21,"00378-0712-01 ")
 ;;1151
 ;;21,"00378-0723-01 ")
 ;;1017
 ;;21,"00378-1012-01 ")
 ;;1192
 ;;21,"00378-1051-01 ")
 ;;729
 ;;21,"00378-1051-05 ")
 ;;730
 ;;21,"00378-1052-01 ")
 ;;908
 ;;21,"00378-1052-10 ")
 ;;909
 ;;21,"00378-1053-01 ")
 ;;611
 ;;21,"00378-1053-10 ")
 ;;612
 ;;21,"00378-1054-01 ")
 ;;796
 ;;21,"00378-1054-05 ")
 ;;797
 ;;21,"00378-1117-77 ")
 ;;2379
 ;;21,"00378-2012-01 ")
 ;;1249
 ;;21,"00378-2025-01 ")
 ;;1307
 ;;21,"00378-2072-01 ")
 ;;1671
 ;;21,"00378-2073-01 ")
 ;;2107
 ;;21,"00378-2073-10 ")
 ;;2108
 ;;21,"00378-2074-01 ")
 ;;1506
 ;;21,"00378-2074-10 ")
 ;;1507
 ;;21,"00378-2075-01 ")
 ;;1750
 ;;21,"00378-2075-10 ")
 ;;1751
 ;;21,"00378-2076-01 ")
 ;;1973
 ;;21,"00378-2076-05 ")
 ;;1974
 ;;21,"00378-2077-01 ")
 ;;1912
 ;;21,"00378-3007-01 ")
 ;;380
 ;;21,"00378-3007-10 ")
 ;;381
 ;;21,"00378-3012-01 ")
 ;;445
 ;;21,"00378-3012-10 ")
 ;;446
 ;;21,"00378-3017-01 ")
 ;;542
 ;;21,"00378-3017-10 ")
 ;;543
 ;;21,"00378-3022-01 ")
 ;;354
 ;;21,"00378-3241-01 ")
 ;;2554
 ;;21,"00378-3242-01 ")
 ;;2566
 ;;21,"00378-3243-01 ")
 ;;2578
 ;;21,"00378-4725-01 ")
 ;;322
 ;;21,"00378-4735-01 ")
 ;;70
 ;;21,"00378-4745-01 ")
 ;;82
 ;;21,"00378-4775-01 ")
 ;;100
 ;;21,"00440-7231-60 ")
 ;;447
 ;;21,"00440-7232-60 ")
 ;;544
 ;;21,"00440-7674-90 ")
 ;;2109
 ;;21,"00440-7675-90 ")
 ;;1508
 ;;21,"00440-7676-90 ")
 ;;1752
 ;;21,"00490-0067-00 ")
 ;;1018
 ;;21,"00490-0067-30 ")
 ;;1019
 ;;21,"00490-0067-60 ")
 ;;1020
 ;;21,"00490-0067-90 ")
 ;;1021
 ;;21,"00490-7030-00 ")
 ;;1152
 ;;21,"00490-7030-30 ")
 ;;1153
 ;;21,"00490-7030-60 ")
 ;;1154
 ;;21,"00490-7030-90 ")
 ;;1155
 ;;21,"00574-0110-01 ")
 ;;2247
 ;;21,"00574-0112-15 ")
 ;;2235
 ;;21,"00574-0133-01 ")
 ;;1354
 ;;21,"00574-0134-01 ")
 ;;1349
 ;;21,"00574-0135-01 ")
 ;;1359
 ;;21,"00591-0405-01 ")
 ;;1672
 ;;21,"00591-0405-05 ")
 ;;1673
 ;;21,"00591-0406-01 ")
 ;;2110
 ;;21,"00591-0406-10 ")
 ;;2111
 ;;21,"00591-0407-01 ")
 ;;1509
 ;;21,"00591-0407-10 ")
 ;;1510
 ;;21,"00591-0408-01 ")
 ;;1753
 ;;21,"00591-0408-10 ")
 ;;1754
 ;;21,"00591-0409-01 ")
 ;;1975
 ;;21,"00591-0409-05 ")
 ;;1976
 ;;21,"00591-0409-75 ")
 ;;1977
 ;;21,"00591-0668-01 ")
 ;;731
 ;;21,"00591-0668-05 ")
 ;;732
 ;;21,"00591-0669-01 ")
 ;;910
 ;;21,"00591-0669-05 ")
 ;;911
 ;;21,"00591-0670-01 ")
 ;;613
 ;;21,"00591-0670-05 ")
 ;;614
 ;;21,"00591-0671-01 ")
 ;;798
 ;;21,"00591-0671-05 ")
 ;;799
 ;;21,"00591-0671-10 ")
 ;;800
 ;;21,"00591-0860-01 ")
 ;;1193
 ;;21,"00591-0860-05 ")
 ;;1194
 ;;21,"00591-0861-01 ")
 ;;1250
 ;;21,"00591-0861-05 ")
 ;;1251
 ;;21,"00591-0862-01 ")
 ;;1308
 ;;21,"00591-0862-05 ")
 ;;1309
 ;;21,"00591-0885-01 ")
 ;;1913
 ;;21,"00591-3757-01 ")
 ;;25
 ;;21,"00591-3758-01 ")
 ;;33
 ;;21,"00591-3758-05 ")
 ;;34
 ;;21,"00591-3759-01 ")
 ;;48
 ;;21,"00591-3759-05 ")
 ;;49
 ;;21,"00591-3760-01 ")
 ;;6
 ;;21,"00591-3760-05 ")
 ;;7
 ;;21,"00603-4209-21 ")
 ;;1674
 ;;21,"00603-4209-28 ")
 ;;1675
 ;;21,"00603-4210-02 ")
 ;;2112
 ;;21,"00603-4210-16 ")
 ;;2113
 ;;21,"00603-4210-21 ")
 ;;2114
 ;;21,"00603-4210-28 ")
 ;;2115
 ;;21,"00603-4210-32 ")
 ;;2116
 ;;21,"00603-4210-60 ")
 ;;2117
 ;;21,"00603-4211-02 ")
 ;;1511
 ;;21,"00603-4211-21 ")
 ;;1512
 ;;21,"00603-4211-28 ")
 ;;1513
 ;;21,"00603-4211-32 ")
 ;;1514
 ;;21,"00603-4211-34 ")
 ;;1515
 ;;21,"00603-4211-60 ")
 ;;1516
 ;;21,"00603-4212-02 ")
 ;;1755
 ;;21,"00603-4212-21 ")
 ;;1756
 ;;21,"00603-4212-28 ")
 ;;1757
 ;;21,"00603-4212-32 ")
 ;;1758
 ;;21,"00603-4212-34 ")
 ;;1759
 ;;21,"00603-4212-60 ")
 ;;1760
 ;;21,"00603-4213-21 ")
 ;;1914
 ;;21,"00603-4213-28 ")
 ;;1915
 ;;21,"00603-4214-02 ")
 ;;1978
 ;;21,"00603-4214-04 ")
 ;;1979
 ;;21,"00603-4214-21 ")
 ;;1980
 ;;21,"00603-4214-28 ")
 ;;1981
 ;;21,"00603-4214-30 ")
 ;;1982
 ;;21,"00603-4214-32 ")
 ;;1983
 ;;21,"00603-4214-60 ")
 ;;1984
 ;;21,"00615-4519-53 ")
 ;;382
 ;;21,"00615-4519-63 ")
 ;;383
 ;;21,"00615-4520-53 ")
 ;;448
 ;;21,"00615-4520-63 ")
 ;;449
 ;;21,"00615-4521-65 ")
 ;;545
 ;;21,"00781-1176-01 ")
 ;;1252
 ;;21,"00781-1178-01 ")
 ;;1310
 ;;21,"00781-1229-01 ")
 ;;733
 ;;21,"00781-1229-10 ")
 ;;734
 ;;21,"00781-1229-13 ")
 ;;735
 ;;21,"00781-1231-01 ")
 ;;912
 ;;21,"00781-1231-13 ")
 ;;913
 ;;21,"00781-1232-10 ")
 ;;615
 ;;21,"00781-1232-13 ")
 ;;616
 ;;21,"00781-1233-10 ")
 ;;801
 ;;21,"00781-1665-01 ")
 ;;2118
 ;;21,"00781-1666-01 ")
 ;;1517
 ;;21,"00781-1667-01 ")
 ;;1761
 ;;21,"00781-1668-01 ")
 ;;1985
 ;;21,"00781-1669-01 ")
 ;;1676
 ;;21,"00781-1673-01 ")
 ;;1916
 ;;21,"00781-1828-01 ")
 ;;384
 ;;21,"00781-1839-01 ")
 ;;355
 ;;21,"00781-1848-01 ")
 ;;1195
 ;;21,"00781-1891-01 ")
 ;;299
 ;;21,"00781-1892-01 ")
 ;;126
 ;;21,"00781-1893-01 ")
 ;;185
 ;;21,"00781-1894-01 ")
 ;;247
 ;;21,"00781-2126-01 ")
 ;;2398
 ;;21,"00781-2127-01 ")
 ;;2468
 ;;21,"00781-2127-05 ")
 ;;2469
 ;;21,"00781-2128-01 ")
 ;;2514
 ;;21,"00781-2128-05 ")
 ;;2515
 ;;21,"00781-2129-01 ")
 ;;2425
 ;;21,"00781-2129-05 ")
 ;;2426
 ;;21,"00781-2271-01 ")
 ;;26
 ;;21,"00781-2272-01 ")
 ;;35
 ;;21,"00781-2272-10 ")
 ;;36
 ;;21,"00781-2273-01 ")
 ;;50
 ;;21,"00781-2273-10 ")
 ;;51
 ;;21,"00781-2274-01 ")
 ;;8
 ;;21,"00781-2274-10 ")
 ;;9
 ;;21,"00781-2277-01 ")
 ;;63
 ;;21,"00781-2279-01 ")
 ;;20
 ;;21,"00781-5083-10 ")
 ;;1040
 ;;21,"00781-5083-92 ")
 ;;1041
 ;;21,"00781-5084-10 ")
 ;;1082
 ;;21,"00781-5084-92 ")
 ;;1083
 ;;21,"00781-5085-92 ")
 ;;1118
 ;;21,"00781-5131-01 ")
 ;;323
 ;;21,"00781-5132-01 ")
 ;;71
 ;;21,"00781-5133-01 ")
 ;;83
 ;;21,"00781-5134-01 ")
 ;;101
 ;;21,"00781-5320-01 ")
 ;;2555
 ;;21,"00781-5321-01 ")
 ;;2567
 ;;21,"00781-5322-01 ")
 ;;2579
 ;;21,"00781-5441-01 ")
 ;;736
 ;;21,"00781-5441-10 ")
 ;;737
 ;;21,"00781-5442-01 ")
 ;;914
 ;;21,"00781-5442-10 ")
 ;;915
 ;;21,"00781-5443-01 ")
 ;;617
 ;;21,"00781-5443-10 ")
 ;;618
 ;;21,"00781-5444-01 ")
 ;;802
 ;;21,"00781-5444-10 ")
 ;;803
 ;;21,"00904-5045-61 ")
 ;;385
 ;;21,"00904-5046-61 ")
 ;;450
 ;;21,"00904-5047-40 ")
 ;;546
 ;;21,"00904-5047-61 ")
 ;;547
 ;;21,"00904-5502-61 ")
 ;;916
 ;;21,"00904-5502-80 ")
 ;;917
 ;;21,"00904-5503-60 ")
 ;;619
 ;;21,"00904-5504-60 ")
 ;;804
 ;;21,"00904-5609-60 ")
 ;;738
 ;;21,"00904-5609-61 ")
 ;;739
 ;;21,"00904-5610-61 ")
 ;;620
 ;;21,"00904-5611-61 ")
 ;;805
 ;;21,"00904-5638-43 ")
 ;;2119
 ;;21,"00904-5638-46 ")
 ;;2120
 ;;21,"00904-5638-61 ")
 ;;2121
 ;;21,"00904-5638-89 ")
 ;;2122
 ;;21,"00904-5639-43 ")
 ;;1518
 ;;21,"00904-5639-46 ")
 ;;1519
 ;;21,"00904-5639-48 ")
 ;;1520
 ;;21,"00904-5639-61 ")
 ;;1521
 ;;21,"00904-5639-89 ")
 ;;1522
 ;;21,"00904-5639-93 ")
 ;;1523
 ;;21,"00904-5640-43 ")
 ;;1762
 ;;21,"00904-5640-46 ")
 ;;1763
 ;;21,"00904-5640-48 ")
 ;;1764
 ;;21,"00904-5640-61 ")
 ;;1765
 ;;21,"00904-5640-89 ")
 ;;1766
 ;;21,"00904-5640-93 ")
 ;;1767
 ;;21,"00904-5642-43 ")
 ;;1986
 ;;21,"00904-5642-46 ")
 ;;1987
 ;;21,"00904-5642-48 ")
 ;;1988
 ;;21,"00904-5642-52 ")
 ;;1989
 ;;21,"00904-5642-61 ")
 ;;1990
 ;;21,"00904-5642-89 ")
 ;;1991
 ;;21,"00904-5642-93 ")
 ;;1992
 ;;21,"00904-5778-89 ")
 ;;1677
 ;;21,"00904-5808-43 ")
 ;;1524
 ;;21,"00904-5808-46 ")
 ;;1525
 ;;21,"00904-5808-48 ")
 ;;1526
 ;;21,"00904-5808-61 ")
 ;;1527
 ;;21,"00904-5808-80 ")
 ;;1528
 ;;21,"00904-5808-89 ")
 ;;1529
 ;;21,"00904-5808-93 ")
 ;;1530
 ;;21,"00904-5809-43 ")
 ;;1768
 ;;21,"00904-5809-46 ")
 ;;1769
 ;;21,"00904-5809-48 ")
 ;;1770
 ;;21,"00904-5809-61 ")
 ;;1771
 ;;21,"00904-5809-80 ")
 ;;1772
 ;;21,"00904-5809-89 ")
 ;;1773
 ;;21,"00904-5809-93 ")
 ;;1774
 ;;21,"00904-5810-43 ")
 ;;1993
 ;;21,"00904-5810-46 ")
 ;;1994
 ;;21,"00904-5810-48 ")
 ;;1995
 ;;21,"00904-5810-52 ")
 ;;1996
 ;;21,"00904-5810-61 ")
 ;;1997
 ;;21,"00904-5810-80 ")
 ;;1998
 ;;21,"00904-5810-89 ")
 ;;1999
 ;;21,"00904-5810-93 ")
 ;;2000
 ;;21,"00904-5811-43 ")
 ;;2123
