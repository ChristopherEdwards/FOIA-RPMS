BGP50M5 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 06, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"63629-1464-02 ")
 ;;497
 ;;21,"63629-1464-03 ")
 ;;498
 ;;21,"63629-1606-01 ")
 ;;991
 ;;21,"63629-1606-02 ")
 ;;992
 ;;21,"63629-1784-01 ")
 ;;641
 ;;21,"63629-1784-02 ")
 ;;642
 ;;21,"63629-3366-01 ")
 ;;370
 ;;21,"63629-3366-02 ")
 ;;371
 ;;21,"63629-3366-03 ")
 ;;372
 ;;21,"63629-3366-04 ")
 ;;373
 ;;21,"63629-3381-01 ")
 ;;746
 ;;21,"63629-3381-02 ")
 ;;747
 ;;21,"63629-3381-03 ")
 ;;748
 ;;21,"63629-3381-04 ")
 ;;749
 ;;21,"63629-3385-01 ")
 ;;1535
 ;;21,"63629-3385-02 ")
 ;;1536
 ;;21,"63629-3385-03 ")
 ;;1537
 ;;21,"63629-3385-04 ")
 ;;1538
 ;;21,"63629-3385-05 ")
 ;;1539
 ;;21,"63629-3392-01 ")
 ;;1203
 ;;21,"63629-3393-01 ")
 ;;1369
 ;;21,"63629-3393-02 ")
 ;;1370
 ;;21,"63629-3393-03 ")
 ;;1371
 ;;21,"63629-3393-04 ")
 ;;1372
 ;;21,"63629-3408-01 ")
 ;;1691
 ;;21,"63629-3408-02 ")
 ;;1692
 ;;21,"63629-3408-03 ")
 ;;1693
 ;;21,"63629-3408-04 ")
 ;;1694
 ;;21,"63629-3563-01 ")
 ;;880
 ;;21,"63629-3583-01 ")
 ;;481
 ;;21,"63629-3583-02 ")
 ;;482
 ;;21,"63629-3583-03 ")
 ;;483
 ;;21,"63739-0281-10 ")
 ;;484
 ;;21,"63739-0282-10 ")
 ;;654
 ;;21,"63739-0435-10 ")
 ;;1138
 ;;21,"63739-0436-10 ")
 ;;1202
 ;;21,"63739-0437-04 ")
 ;;1373
 ;;21,"63739-0437-10 ")
 ;;1374
 ;;21,"63739-0438-10 ")
 ;;1534
 ;;21,"63739-0570-10 ")
 ;;1139
 ;;21,"63739-0571-10 ")
 ;;1201
 ;;21,"63739-0572-10 ")
 ;;1375
 ;;21,"63739-0573-10 ")
 ;;1533
 ;;21,"63874-0319-10 ")
 ;;285
 ;;21,"63874-0319-15 ")
 ;;286
 ;;21,"63874-0319-30 ")
 ;;287
 ;;21,"63874-0319-90 ")
 ;;288
 ;;21,"63874-0589-01 ")
 ;;95
 ;;21,"63874-0589-10 ")
 ;;96
 ;;21,"63874-0589-30 ")
 ;;97
 ;;21,"63874-0589-90 ")
 ;;98
 ;;21,"63874-0590-01 ")
 ;;185
 ;;21,"63874-0590-10 ")
 ;;186
 ;;21,"63874-0590-15 ")
 ;;187
 ;;21,"63874-0590-30 ")
 ;;188
 ;;21,"63874-0590-90 ")
 ;;189
 ;;21,"65243-0065-15 ")
 ;;1384
 ;;21,"65243-0065-45 ")
 ;;1385
 ;;21,"65243-0082-15 ")
 ;;1525
 ;;21,"65243-0082-45 ")
 ;;1526
 ;;21,"65243-0127-45 ")
 ;;1701
 ;;21,"65243-0348-15 ")
 ;;1382
 ;;21,"65243-0348-45 ")
 ;;1383
 ;;21,"65243-0349-15 ")
 ;;1527
 ;;21,"65243-0349-45 ")
 ;;1528
 ;;21,"65243-0350-45 ")
 ;;1699
 ;;21,"65243-0352-03 ")
 ;;655
 ;;21,"65243-0352-09 ")
 ;;656
 ;;21,"65243-0352-45 ")
 ;;657
 ;;21,"65243-0360-09 ")
 ;;1380
 ;;21,"65243-0360-45 ")
 ;;1381
 ;;21,"65243-0361-45 ")
 ;;1700
 ;;21,"65243-0365-45 ")
 ;;1540
 ;;21,"65243-0367-03 ")
 ;;1686
 ;;21,"65243-0367-09 ")
 ;;1687
 ;;21,"65243-0367-45 ")
 ;;1688
 ;;21,"65862-0050-30 ")
 ;;1140
 ;;21,"65862-0050-90 ")
 ;;1141
 ;;21,"65862-0051-26 ")
 ;;1197
 ;;21,"65862-0051-30 ")
 ;;1198
 ;;21,"65862-0051-90 ")
 ;;1199
 ;;21,"65862-0051-99 ")
 ;;1200
 ;;21,"65862-0052-26 ")
 ;;1376
 ;;21,"65862-0052-30 ")
 ;;1377
 ;;21,"65862-0052-90 ")
 ;;1378
 ;;21,"65862-0052-99 ")
 ;;1379
 ;;21,"65862-0053-22 ")
 ;;1529
 ;;21,"65862-0053-30 ")
 ;;1530
 ;;21,"65862-0053-90 ")
 ;;1531
 ;;21,"65862-0053-99 ")
 ;;1532
 ;;21,"65862-0054-30 ")
 ;;1695
 ;;21,"65862-0054-39 ")
 ;;1696
 ;;21,"65862-0054-90 ")
 ;;1697
 ;;21,"65862-0054-99 ")
 ;;1698
 ;;21,"66105-0121-01 ")
 ;;863
 ;;21,"66105-0121-03 ")
 ;;864
 ;;21,"66105-0121-06 ")
 ;;865
 ;;21,"66105-0121-09 ")
 ;;866
 ;;21,"66105-0121-15 ")
 ;;867
 ;;21,"66105-0122-01 ")
 ;;956
 ;;21,"66105-0122-03 ")
 ;;957
 ;;21,"66105-0122-06 ")
 ;;958
 ;;21,"66105-0122-09 ")
 ;;959
 ;;21,"66105-0122-15 ")
 ;;960
 ;;21,"66105-0147-01 ")
 ;;391
 ;;21,"66105-0147-03 ")
 ;;392
 ;;21,"66105-0147-06 ")
 ;;393
 ;;21,"66105-0147-09 ")
 ;;394
 ;;21,"66105-0147-10 ")
 ;;395
 ;;21,"66105-0506-01 ")
 ;;1647
 ;;21,"66105-0506-03 ")
 ;;1648
 ;;21,"66105-0506-06 ")
 ;;1649
 ;;21,"66105-0506-09 ")
 ;;1650
 ;;21,"66105-0506-10 ")
 ;;1651
 ;;21,"66105-0988-03 ")
 ;;750
 ;;21,"66116-0238-30 ")
 ;;868
 ;;21,"66116-0276-30 ")
 ;;99
 ;;21,"66116-0277-30 ")
 ;;485
 ;;21,"66267-0561-30 ")
 ;;651
 ;;21,"66267-0561-60 ")
 ;;652
 ;;21,"66267-0561-90 ")
 ;;653
 ;;21,"66267-1260-01 ")
 ;;1204
 ;;21,"66267-1261-01 ")
 ;;1366
 ;;21,"66336-0310-05 ")
 ;;486
 ;;21,"66336-0310-30 ")
 ;;487
 ;;21,"66336-0310-60 ")
 ;;488
 ;;21,"66336-0310-90 ")
 ;;489
 ;;21,"66336-0412-05 ")
 ;;648
 ;;21,"66336-0412-30 ")
 ;;649
 ;;21,"66336-0412-90 ")
 ;;650
 ;;21,"66336-0602-05 ")
 ;;478
 ;;21,"66336-0602-30 ")
 ;;479
 ;;21,"66336-0602-90 ")
 ;;480
 ;;21,"66336-0674-30 ")
 ;;751
 ;;21,"66336-0685-30 ")
 ;;881
 ;;21,"66336-0685-90 ")
 ;;882
 ;;21,"66336-0813-30 ")
 ;;972
 ;;21,"66336-0813-90 ")
 ;;973
 ;;21,"66336-0953-30 ")
 ;;1541
 ;;21,"66336-0953-90 ")
 ;;1542
 ;;21,"66336-0954-30 ")
 ;;1367
 ;;21,"66336-0954-90 ")
 ;;1368
 ;;21,"66336-0986-30 ")
 ;;1689
 ;;21,"66336-0986-90 ")
 ;;1690
 ;;21,"66582-0311-01 ")
 ;;1840
 ;;21,"66582-0311-28 ")
 ;;1841
 ;;21,"66582-0311-31 ")
 ;;1842
 ;;21,"66582-0311-54 ")
 ;;1843
 ;;21,"66582-0311-82 ")
 ;;1844
 ;;21,"66582-0312-01 ")
 ;;1854
 ;;21,"66582-0312-28 ")
 ;;1855
 ;;21,"66582-0312-31 ")
 ;;1856
 ;;21,"66582-0312-54 ")
 ;;1857
 ;;21,"66582-0312-82 ")
 ;;1858
 ;;21,"66582-0312-87 ")
 ;;1859
 ;;21,"66582-0313-01 ")
 ;;1869
 ;;21,"66582-0313-31 ")
 ;;1870
 ;;21,"66582-0313-52 ")
 ;;1871
 ;;21,"66582-0313-54 ")
 ;;1872
 ;;21,"66582-0313-74 ")
 ;;1873
 ;;21,"66582-0313-86 ")
 ;;1874
 ;;21,"66582-0315-01 ")
 ;;1886
 ;;21,"66582-0315-31 ")
 ;;1887
 ;;21,"66582-0315-52 ")
 ;;1888
 ;;21,"66582-0315-54 ")
 ;;1889
 ;;21,"66582-0315-66 ")
 ;;1890
 ;;21,"66582-0315-74 ")
 ;;1891
 ;;21,"66582-0320-10 ")
 ;;1830
 ;;21,"66582-0320-30 ")
 ;;1828
 ;;21,"66582-0320-54 ")
 ;;1829
 ;;21,"66582-0321-10 ")
 ;;1833
 ;;21,"66582-0321-30 ")
 ;;1831
 ;;21,"66582-0321-54 ")
 ;;1832
 ;;21,"66582-0322-10 ")
 ;;1836
 ;;21,"66582-0322-30 ")
 ;;1834
 ;;21,"66582-0322-54 ")
 ;;1835
 ;;21,"66582-0323-10 ")
 ;;1839
 ;;21,"66582-0323-30 ")
 ;;1837
 ;;21,"66582-0323-54 ")
 ;;1838
 ;;21,"66869-0104-90 ")
 ;;703
 ;;21,"66869-0204-90 ")
 ;;705
 ;;21,"66869-0404-90 ")
 ;;707
 ;;21,"67544-0050-15 ")
 ;;1291
 ;;21,"67544-0050-30 ")
 ;;1292
 ;;21,"67544-0050-45 ")
 ;;1293
 ;;21,"67544-0050-53 ")
 ;;1294
 ;;21,"67544-0050-60 ")
 ;;1295
 ;;21,"67544-0051-15 ")
 ;;1799
 ;;21,"67544-0051-16 ")
 ;;1800
 ;;21,"67544-0051-45 ")
 ;;1801
 ;;21,"67544-0051-53 ")
 ;;1802
 ;;21,"67544-0060-15 ")
 ;;374
 ;;21,"67544-0060-30 ")
 ;;375
 ;;21,"67544-0060-45 ")
 ;;376
 ;;21,"67544-0060-60 ")
 ;;377
 ;;21,"67544-0081-15 ")
 ;;1477
 ;;21,"67544-0081-30 ")
 ;;1478
 ;;21,"67544-0081-45 ")
 ;;1479
 ;;21,"67544-0081-60 ")
 ;;1480
 ;;21,"67544-0082-15 ")
 ;;1636
 ;;21,"67544-0082-45 ")
 ;;1637
 ;;21,"67544-0106-15 ")
 ;;573
 ;;21,"67544-0106-30 ")
 ;;574
 ;;21,"67544-0106-45 ")
 ;;575
 ;;21,"67544-0106-53 ")
 ;;576
 ;;21,"67544-0106-60 ")
 ;;577
 ;;21,"67544-0106-80 ")
 ;;578
 ;;21,"67544-0225-15 ")
 ;;599
 ;;21,"67544-0225-30 ")
 ;;600
 ;;21,"67544-0225-45 ")
 ;;601
 ;;21,"67544-0225-53 ")
 ;;602
 ;;21,"67544-0225-60 ")
 ;;603
 ;;21,"67544-0225-80 ")
 ;;604
 ;;21,"67544-0245-30 ")
 ;;421
 ;;21,"67544-0245-60 ")
 ;;422
 ;;21,"67544-0247-15 ")
 ;;290
 ;;21,"67544-0247-30 ")
 ;;291
 ;;21,"67544-0247-45 ")
 ;;292
 ;;21,"67544-0854-45 ")
 ;;1268
 ;;21,"67544-0854-60 ")
 ;;1269
 ;;21,"67544-0855-15 ")
 ;;1318
 ;;21,"67544-0855-30 ")
 ;;1319
 ;;21,"67544-0855-45 ")
 ;;1320
 ;;21,"67544-0855-60 ")
 ;;1321
 ;;21,"67544-0856-15 ")
 ;;1618
 ;;21,"67544-0856-45 ")
 ;;1619
 ;;21,"67544-0857-15 ")
 ;;1775
 ;;21,"67544-0857-45 ")
 ;;1776
 ;;21,"67544-0857-60 ")
 ;;1777
 ;;21,"67544-1001-30 ")
 ;;1155
 ;;21,"67544-1001-60 ")
 ;;1156
 ;;21,"67544-1003-15 ")
 ;;1778
 ;;21,"67544-1003-45 ")
 ;;1779
 ;;21,"67544-1003-53 ")
 ;;1780
 ;;21,"67544-1029-99 ")
 ;;409
 ;;21,"67544-1030-99 ")
 ;;408
 ;;21,"67544-1032-15 ")
 ;;778
 ;;21,"67544-1032-45 ")
 ;;779
 ;;21,"67544-1032-82 ")
 ;;780
 ;;21,"67544-1032-99 ")
 ;;781
 ;;21,"67544-1078-30 ")
 ;;1620
 ;;21,"67544-1254-15 ")
 ;;1621
 ;;21,"67544-1254-45 ")
 ;;1622
 ;;21,"67544-1255-15 ")
 ;;1772
 ;;21,"67544-1255-30 ")
 ;;1773
 ;;21,"67544-1255-45 ")
 ;;1774
 ;;21,"67544-1256-15 ")
 ;;1325
 ;;21,"67544-1256-30 ")
 ;;1326
 ;;21,"67544-1256-45 ")
 ;;1327
 ;;21,"67544-1257-45 ")
 ;;1265
 ;;21,"67544-1257-60 ")
 ;;1266
 ;;21,"68001-0213-00 ")
 ;;423
 ;;21,"68001-0213-06 ")
 ;;424
 ;;21,"68001-0213-08 ")
 ;;425
 ;;21,"68001-0214-00 ")
 ;;596
 ;;21,"68001-0214-06 ")
 ;;597
 ;;21,"68001-0214-08 ")
 ;;598
 ;;21,"68001-0224-00 ")
 ;;570
 ;;21,"68001-0224-06 ")
 ;;571
 ;;21,"68001-0224-08 ")
 ;;572
 ;;21,"68071-0154-30 ")
 ;;190
 ;;21,"68071-0263-30 ")
 ;;777
 ;;21,"68071-0310-30 ")
 ;;289
 ;;21,"68071-0399-30 ")
 ;;102
 ;;21,"68071-0433-30 ")
 ;;720
 ;;21,"68071-0699-30 ")
 ;;1322
 ;;21,"68071-0716-30 ")
 ;;1267
 ;;21,"68071-0784-30 ")
 ;;717
 ;;21,"68071-0914-30 ")
 ;;18
 ;;21,"68071-0915-30 ")
 ;;107
 ;;21,"68071-0916-30 ")
 ;;196
 ;;21,"68084-0097-01 ")
 ;;16
 ;;21,"68084-0097-11 ")
 ;;17
 ;;21,"68084-0098-01 ")
 ;;108
 ;;21,"68084-0098-11 ")
 ;;109
 ;;21,"68084-0099-01 ")
 ;;199
 ;;21,"68084-0099-11 ")
 ;;200
 ;;21,"68084-0133-01 ")
 ;;594
 ;;21,"68084-0133-11 ")
 ;;595
 ;;21,"68084-0161-01 ")
 ;;1153
 ;;21,"68084-0161-11 ")
 ;;1154
 ;;21,"68084-0163-01 ")
 ;;1323
 ;;21,"68084-0163-11 ")
 ;;1324
 ;;21,"68084-0165-01 ")
 ;;1781
 ;;21,"68084-0165-11 ")
 ;;1782
 ;;21,"68084-0186-01 ")
 ;;809
 ;;21,"68084-0186-11 ")
 ;;810
 ;;21,"68084-0187-01 ")
 ;;872
 ;;21,"68084-0187-11 ")
 ;;873
 ;;21,"68084-0188-01 ")
 ;;968
 ;;21,"68084-0188-11 ")
 ;;969
 ;;21,"68084-0500-01 ")
 ;;811
 ;;21,"68084-0500-11 ")
 ;;812
 ;;21,"68084-0501-01 ")
 ;;870
 ;;21,"68084-0501-11 ")
 ;;871
 ;;21,"68084-0502-01 ")
 ;;970
 ;;21,"68084-0502-11 ")
 ;;971
 ;;21,"68084-0510-01 ")
 ;;1151
 ;;21,"68084-0510-11 ")
 ;;1152
 ;;21,"68084-0511-01 ")
 ;;1270
 ;;21,"68084-0511-11 ")
 ;;1271
 ;;21,"68084-0512-01 ")
 ;;1316
 ;;21,"68084-0512-11 ")
 ;;1317
 ;;21,"68084-0513-01 ")
 ;;1623
 ;;21,"68084-0513-11 ")
 ;;1624
 ;;21,"68084-0514-01 ")
 ;;1786
 ;;21,"68084-0514-11 ")
 ;;1787
 ;;21,"68084-0558-01 ")
 ;;417
 ;;21,"68084-0558-11 ")
 ;;416
 ;;21,"68084-0559-01 ")
 ;;583
 ;;21,"68084-0559-11 ")
 ;;584
 ;;21,"68084-0560-01 ")
 ;;605
 ;;21,"68084-0560-11 ")
 ;;593
 ;;21,"68084-0564-01 ")
 ;;19
 ;;21,"68084-0564-11 ")
 ;;20
 ;;21,"68084-0565-01 ")
 ;;116
 ;;21,"68084-0565-11 ")
 ;;106
 ;;21,"68084-0589-01 ")
 ;;197
 ;;21,"68084-0589-11 ")
 ;;198
 ;;21,"68084-0590-25 ")
 ;;304
 ;;21,"68084-0590-95 ")
 ;;299
 ;;21,"68084-0746-25 ")
 ;;1051
 ;;21,"68084-0746-95 ")
 ;;1052
 ;;21,"68180-0467-01 ")
 ;;418
 ;;21,"68180-0467-03 ")
 ;;419
 ;;21,"68180-0467-07 ")
 ;;420
 ;;21,"68180-0468-01 ")
 ;;579
 ;;21,"68180-0468-03 ")
 ;;580
 ;;21,"68180-0468-05 ")
 ;;581
 ;;21,"68180-0468-07 ")
 ;;582
 ;;21,"68180-0469-01 ")
 ;;606
 ;;21,"68180-0469-03 ")
 ;;607
 ;;21,"68180-0469-05 ")
 ;;608
 ;;21,"68180-0469-07 ")
 ;;609
 ;;21,"68180-0478-01 ")
 ;;1274
 ;;21,"68180-0478-02 ")
 ;;1275
 ;;21,"68180-0478-03 ")
 ;;1276
 ;;21,"68180-0479-01 ")
 ;;1313
 ;;21,"68180-0479-02 ")
 ;;1314
 ;;21,"68180-0479-03 ")
 ;;1315
 ;;21,"68180-0480-01 ")
 ;;1625
 ;;21,"68180-0480-02 ")
 ;;1626
 ;;21,"68180-0480-03 ")
 ;;1627
 ;;21,"68180-0481-01 ")
 ;;1783
 ;;21,"68180-0481-02 ")
 ;;1784
 ;;21,"68180-0481-03 ")
 ;;1785
 ;;21,"68180-0482-06 ")
 ;;1142
 ;;21,"68180-0482-09 ")
 ;;1143
 ;;21,"68180-0485-02 ")
 ;;807
 ;;21,"68180-0485-09 ")
 ;;808
 ;;21,"68180-0486-02 ")
 ;;874
 ;;21,"68180-0486-09 ")
 ;;875
 ;;21,"68180-0487-02 ")
 ;;966
 ;;21,"68180-0487-09 ")
 ;;967
 ;;21,"68180-0488-02 ")
 ;;1045
 ;;21,"68180-0488-09 ")
 ;;1046
 ;;21,"68258-6000-03 ")
 ;;100
 ;;21,"68258-6000-09 ")
 ;;101
 ;;21,"68258-6001-03 ")
 ;;191
 ;;21,"68258-6001-09 ")
 ;;192
 ;;21,"68258-6002-03 ")
 ;;293
 ;;21,"68258-6002-09 ")
 ;;294
 ;;21,"68258-6009-03 ")
 ;;1272
 ;;21,"68258-6009-09 ")
 ;;1273
 ;;21,"68258-6013-03 ")
 ;;1053
 ;;21,"68258-6013-09 ")
 ;;1054
 ;;21,"68258-6016-03 ")
 ;;719
 ;;21,"68258-6017-03 ")
 ;;718
 ;;21,"68258-6041-03 ")
 ;;21
 ;;21,"68258-6042-03 ")
 ;;115
 ;;21,"68258-6043-03 ")
 ;;201
 ;;21,"68258-6043-09 ")
 ;;202
 ;;21,"68258-6044-03 ")
 ;;300
 ;;21,"68258-6044-09 ")
 ;;301
 ;;21,"68258-6049-03 ")
 ;;806
 ;;21,"68258-6050-03 ")
 ;;1144
 ;;21,"68258-6970-03 ")
 ;;1864
 ;;21,"68258-6983-03 ")
 ;;782
 ;;21,"68258-6984-03 ")
 ;;1865
 ;;21,"68258-6985-09 ")
 ;;1150
 ;;21,"68258-6992-09 ")
 ;;22
 ;;21,"68258-6993-09 ")
 ;;114
 ;;21,"68382-0065-05 ")
 ;;1145
 ;;21,"68382-0065-06 ")
 ;;1146
 ;;21,"68382-0065-10 ")
 ;;1147
 ;;21,"68382-0065-14 ")
 ;;1148
 ;;21,"68382-0065-16 ")
 ;;1149
 ;;21,"68382-0066-05 ")
 ;;1277
 ;;21,"68382-0066-06 ")
 ;;1278
 ;;21,"68382-0066-10 ")
 ;;1279
 ;;21,"68382-0066-14 ")
 ;;1280