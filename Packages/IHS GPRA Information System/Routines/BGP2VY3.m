BGP2VY3 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 12, 2012;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54569-1970-01 ")
 ;;459
 ;;21,"54569-1970-02 ")
 ;;460
 ;;21,"54569-1970-04 ")
 ;;461
 ;;21,"54569-1970-05 ")
 ;;462
 ;;21,"54569-1970-06 ")
 ;;463
 ;;21,"54569-1970-09 ")
 ;;464
 ;;21,"54569-2562-02 ")
 ;;64
 ;;21,"54569-2562-03 ")
 ;;65
 ;;21,"54569-2573-00 ")
 ;;724
 ;;21,"54569-2573-01 ")
 ;;725
 ;;21,"54569-2573-02 ")
 ;;726
 ;;21,"54569-2573-03 ")
 ;;727
 ;;21,"54569-2573-04 ")
 ;;728
 ;;21,"54569-2573-06 ")
 ;;729
 ;;21,"54569-2573-07 ")
 ;;730
 ;;21,"54569-2573-08 ")
 ;;731
 ;;21,"54569-2573-09 ")
 ;;732
 ;;21,"54569-3193-00 ")
 ;;733
 ;;21,"54569-3193-01 ")
 ;;734
 ;;21,"54569-3193-05 ")
 ;;735
 ;;21,"54569-3193-07 ")
 ;;736
 ;;21,"54569-3193-08 ")
 ;;737
 ;;21,"54569-3193-09 ")
 ;;738
 ;;21,"54569-3403-00 ")
 ;;201
 ;;21,"54569-3403-01 ")
 ;;202
 ;;21,"54569-3403-04 ")
 ;;203
 ;;21,"54569-3403-05 ")
 ;;204
 ;;21,"54569-3403-06 ")
 ;;205
 ;;21,"54569-3403-07 ")
 ;;206
 ;;21,"54569-4008-00 ")
 ;;739
 ;;21,"54569-4008-01 ")
 ;;740
 ;;21,"54569-4048-04 ")
 ;;1462
 ;;21,"54569-4614-00 ")
 ;;1258
 ;;21,"54569-4614-02 ")
 ;;1259
 ;;21,"54569-5184-00 ")
 ;;741
 ;;21,"54569-5477-00 ")
 ;;1096
 ;;21,"54569-5477-01 ")
 ;;1097
 ;;21,"54569-5477-02 ")
 ;;1098
 ;;21,"54569-5477-05 ")
 ;;1099
 ;;21,"54569-5477-06 ")
 ;;1100
 ;;21,"54569-5538-00 ")
 ;;990
 ;;21,"54569-5782-00 ")
 ;;991
 ;;21,"54569-5966-00 ")
 ;;1463
 ;;21,"54868-0020-00 ")
 ;;207
 ;;21,"54868-0020-01 ")
 ;;208
 ;;21,"54868-0020-02 ")
 ;;209
 ;;21,"54868-0318-00 ")
 ;;742
 ;;21,"54868-0318-01 ")
 ;;743
 ;;21,"54868-0318-02 ")
 ;;744
 ;;21,"54868-0318-03 ")
 ;;745
 ;;21,"54868-0318-04 ")
 ;;746
 ;;21,"54868-0586-01 ")
 ;;1260
 ;;21,"54868-0586-02 ")
 ;;1261
 ;;21,"54868-0586-03 ")
 ;;1262
 ;;21,"54868-0586-05 ")
 ;;1263
 ;;21,"54868-0586-06 ")
 ;;1264
 ;;21,"54868-0586-07 ")
 ;;1265
 ;;21,"54868-0604-00 ")
 ;;1266
 ;;21,"54868-0735-00 ")
 ;;465
 ;;21,"54868-0735-01 ")
 ;;466
 ;;21,"54868-0735-02 ")
 ;;467
 ;;21,"54868-0735-03 ")
 ;;468
 ;;21,"54868-0735-04 ")
 ;;469
 ;;21,"54868-0735-05 ")
 ;;470
 ;;21,"54868-0735-07 ")
 ;;471
 ;;21,"54868-0735-08 ")
 ;;472
 ;;21,"54868-0735-09 ")
 ;;473
 ;;21,"54868-0816-01 ")
 ;;210
 ;;21,"54868-0816-02 ")
 ;;211
 ;;21,"54868-0816-03 ")
 ;;212
 ;;21,"54868-0816-04 ")
 ;;213
 ;;21,"54868-0816-05 ")
 ;;214
 ;;21,"54868-0816-06 ")
 ;;215
 ;;21,"54868-0816-07 ")
 ;;216
 ;;21,"54868-1017-00 ")
 ;;474
 ;;21,"54868-1103-00 ")
 ;;1464
 ;;21,"54868-1103-03 ")
 ;;1465
 ;;21,"54868-1103-06 ")
 ;;1466
 ;;21,"54868-1103-07 ")
 ;;1467
 ;;21,"54868-1103-08 ")
 ;;1468
 ;;21,"54868-1103-09 ")
 ;;1469
 ;;21,"54868-1110-00 ")
 ;;747
 ;;21,"54868-1110-02 ")
 ;;748
 ;;21,"54868-1110-03 ")
 ;;749
 ;;21,"54868-1110-05 ")
 ;;750
 ;;21,"54868-1110-08 ")
 ;;751
 ;;21,"54868-1110-09 ")
 ;;752
 ;;21,"54868-4102-00 ")
 ;;1647
 ;;21,"54868-4102-01 ")
 ;;1648
 ;;21,"54868-4102-02 ")
 ;;1649
 ;;21,"54868-4102-03 ")
 ;;1650
 ;;21,"54868-4102-04 ")
 ;;1651
 ;;21,"54868-4102-05 ")
 ;;1652
 ;;21,"54868-4733-00 ")
 ;;1101
 ;;21,"54868-4733-01 ")
 ;;1102
 ;;21,"54868-4733-02 ")
 ;;1103
 ;;21,"54868-4733-03 ")
 ;;1104
 ;;21,"54868-4733-04 ")
 ;;1105
 ;;21,"54868-4733-05 ")
 ;;1106
 ;;21,"54868-4733-06 ")
 ;;1107
 ;;21,"54868-4733-07 ")
 ;;1108
 ;;21,"54868-5375-00 ")
 ;;992
 ;;21,"54868-5375-01 ")
 ;;993
 ;;21,"54868-5597-00 ")
 ;;994
 ;;21,"54868-6022-00 ")
 ;;939
 ;;21,"55045-1325-00 ")
 ;;1653
 ;;21,"55045-1325-01 ")
 ;;1654
 ;;21,"55045-1325-02 ")
 ;;1655
 ;;21,"55045-1325-03 ")
 ;;1656
 ;;21,"55045-1325-05 ")
 ;;1657
 ;;21,"55045-1325-07 ")
 ;;1658
 ;;21,"55045-1325-08 ")
 ;;1659
 ;;21,"55045-1325-09 ")
 ;;1660
 ;;21,"55045-1386-00 ")
 ;;1470
 ;;21,"55045-1386-01 ")
 ;;1471
 ;;21,"55045-1386-02 ")
 ;;1472
 ;;21,"55045-1386-03 ")
 ;;1473
 ;;21,"55045-1386-04 ")
 ;;1474
 ;;21,"55045-1386-05 ")
 ;;1475
 ;;21,"55045-1386-06 ")
 ;;1476
 ;;21,"55045-1386-07 ")
 ;;1477
 ;;21,"55045-1386-08 ")
 ;;1478
 ;;21,"55045-1386-09 ")
 ;;1479
 ;;21,"55045-1433-00 ")
 ;;217
 ;;21,"55045-1433-01 ")
 ;;218
 ;;21,"55045-1433-02 ")
 ;;219
 ;;21,"55045-1433-03 ")
 ;;220
 ;;21,"55045-1433-04 ")
 ;;221
 ;;21,"55045-1433-05 ")
 ;;222
 ;;21,"55045-1433-06 ")
 ;;223
 ;;21,"55045-1433-07 ")
 ;;224
 ;;21,"55045-1433-08 ")
 ;;225
 ;;21,"55045-1433-09 ")
 ;;226
 ;;21,"55045-1531-00 ")
 ;;1267
 ;;21,"55045-1531-01 ")
 ;;1268
 ;;21,"55045-1531-02 ")
 ;;1269
 ;;21,"55045-1531-03 ")
 ;;1270
 ;;21,"55045-1531-04 ")
 ;;1271
 ;;21,"55045-1531-06 ")
 ;;1272
 ;;21,"55045-1531-08 ")
 ;;1273
 ;;21,"55045-1531-09 ")
 ;;1274
 ;;21,"55045-1566-00 ")
 ;;753
 ;;21,"55045-1566-01 ")
 ;;754
 ;;21,"55045-1566-02 ")
 ;;755
 ;;21,"55045-1566-03 ")
 ;;756
 ;;21,"55045-1566-04 ")
 ;;757
 ;;21,"55045-1566-05 ")
 ;;758
 ;;21,"55045-1566-06 ")
 ;;759
 ;;21,"55045-1566-07 ")
 ;;760
 ;;21,"55045-1566-08 ")
 ;;761
 ;;21,"55045-1566-09 ")
 ;;762
 ;;21,"55045-1594-00 ")
 ;;475
 ;;21,"55045-2777-06 ")
 ;;22
 ;;21,"55045-2972-00 ")
 ;;1109
 ;;21,"55045-2972-04 ")
 ;;1110
 ;;21,"55045-2972-05 ")
 ;;1111
 ;;21,"55045-2972-06 ")
 ;;1112
 ;;21,"55045-2972-07 ")
 ;;1113
 ;;21,"55045-2972-08 ")
 ;;1114
 ;;21,"55045-3058-01 ")
 ;;763
 ;;21,"55045-3058-04 ")
 ;;764
 ;;21,"55045-3058-05 ")
 ;;765
 ;;21,"55045-3058-06 ")
 ;;766
 ;;21,"55045-3058-09 ")
 ;;767
 ;;21,"55045-3123-06 ")
 ;;227
 ;;21,"55045-3123-09 ")
 ;;228
 ;;21,"55045-3229-01 ")
 ;;1480
 ;;21,"55045-3229-08 ")
 ;;1481
 ;;21,"55045-3487-01 ")
 ;;995
 ;;21,"55045-3717-01 ")
 ;;768
 ;;21,"55045-3718-04 ")
 ;;1275
 ;;21,"55253-0276-60 ")
 ;;940
 ;;21,"55253-0277-60 ")
 ;;946
 ;;21,"55289-0017-20 ")
 ;;1482
 ;;21,"55289-0017-40 ")
 ;;1483
 ;;21,"55289-0049-01 ")
 ;;229
 ;;21,"55289-0049-10 ")
 ;;230
 ;;21,"55289-0049-14 ")
 ;;231
 ;;21,"55289-0049-15 ")
 ;;232
 ;;21,"55289-0049-20 ")
 ;;233
 ;;21,"55289-0049-21 ")
 ;;234
 ;;21,"55289-0049-24 ")
 ;;235
 ;;21,"55289-0049-30 ")
 ;;236
 ;;21,"55289-0049-40 ")
 ;;237
 ;;21,"55289-0049-60 ")
 ;;238
 ;;21,"55289-0049-90 ")
 ;;239
 ;;21,"55289-0049-98 ")
 ;;240
 ;;21,"55289-0115-15 ")
 ;;769
 ;;21,"55289-0115-20 ")
 ;;770
 ;;21,"55289-0115-21 ")
 ;;771
 ;;21,"55289-0115-30 ")
 ;;772
 ;;21,"55289-0164-01 ")
 ;;1484
 ;;21,"55289-0164-10 ")
 ;;1485
 ;;21,"55289-0164-15 ")
 ;;1486
 ;;21,"55289-0164-20 ")
 ;;1487
 ;;21,"55289-0164-28 ")
 ;;1488
 ;;21,"55289-0164-30 ")
 ;;1489
 ;;21,"55289-0164-40 ")
 ;;1490
 ;;21,"55289-0164-60 ")
 ;;1491
 ;;21,"55289-0164-90 ")
 ;;1492
 ;;21,"55289-0164-93 ")
 ;;1493
 ;;21,"55289-0236-10 ")
 ;;996
 ;;21,"55289-0236-14 ")
 ;;997
 ;;21,"55289-0236-30 ")
 ;;998
 ;;21,"55289-0376-20 ")
 ;;399
 ;;21,"55289-0376-40 ")
 ;;400
 ;;21,"55289-0472-20 ")
 ;;34
 ;;21,"55289-0567-10 ")
 ;;773
 ;;21,"55289-0567-12 ")
 ;;774
 ;;21,"55289-0567-14 ")
 ;;775
 ;;21,"55289-0567-15 ")
 ;;776
 ;;21,"55289-0567-17 ")
 ;;777
 ;;21,"55289-0567-18 ")
 ;;778
 ;;21,"55289-0567-20 ")
 ;;779
 ;;21,"55289-0567-21 ")
 ;;780
 ;;21,"55289-0567-30 ")
 ;;781
 ;;21,"55289-0567-42 ")
 ;;782
 ;;21,"55289-0567-60 ")
 ;;783
 ;;21,"55289-0567-90 ")
 ;;784
 ;;21,"55289-0578-20 ")
 ;;241
 ;;21,"55289-0578-40 ")
 ;;242
 ;;21,"55289-0633-08 ")
 ;;476
 ;;21,"55289-0633-10 ")
 ;;477
 ;;21,"55289-0633-17 ")
 ;;478
 ;;21,"55289-0633-20 ")
 ;;479
 ;;21,"55289-0633-24 ")
 ;;480
 ;;21,"55289-0633-28 ")
 ;;481
 ;;21,"55289-0633-30 ")
 ;;482
 ;;21,"55289-0633-40 ")
 ;;483
 ;;21,"55289-0633-97 ")
 ;;484
 ;;21,"55289-0670-01 ")
 ;;1276
 ;;21,"55289-0670-10 ")
 ;;1277
 ;;21,"55289-0670-12 ")
 ;;1278
 ;;21,"55289-0670-14 ")
 ;;1279
 ;;21,"55289-0670-20 ")
 ;;1280
 ;;21,"55289-0670-24 ")
 ;;1281
 ;;21,"55289-0670-28 ")
 ;;1282
 ;;21,"55289-0670-30 ")
 ;;1283
 ;;21,"55289-0670-40 ")
 ;;1284
 ;;21,"55289-0670-60 ")
 ;;1285
 ;;21,"55289-0670-90 ")
 ;;1286
 ;;21,"55289-0670-93 ")
 ;;1287
 ;;21,"55289-0695-28 ")
 ;;66
 ;;21,"55289-0695-40 ")
 ;;67
 ;;21,"55289-0736-10 ")
 ;;1115
 ;;21,"55289-0736-15 ")
 ;;1116
 ;;21,"55289-0736-20 ")
 ;;1117
 ;;21,"55289-0736-21 ")
 ;;1118
 ;;21,"55289-0736-30 ")
 ;;1119
 ;;21,"55289-0745-10 ")
 ;;999
 ;;21,"55289-0745-20 ")
 ;;1000
 ;;21,"55289-0877-14 ")
 ;;1661
 ;;21,"55289-0877-20 ")
 ;;1662
 ;;21,"55289-0877-30 ")
 ;;1663
 ;;21,"55289-0888-24 ")
 ;;485
 ;;21,"55887-0435-30 ")
 ;;1001
 ;;21,"55887-0631-07 ")
 ;;1120
 ;;21,"55887-0631-12 ")
 ;;1121
 ;;21,"55887-0631-15 ")
 ;;1122
 ;;21,"55887-0631-20 ")
 ;;1123
 ;;21,"55887-0631-30 ")
 ;;1124
 ;;21,"55887-0631-40 ")
 ;;1125
 ;;21,"55887-0631-60 ")
 ;;1126
 ;;21,"55887-0670-15 ")
 ;;1664
 ;;21,"55887-0670-20 ")
 ;;1665
 ;;21,"55887-0670-30 ")
 ;;1666
 ;;21,"55887-0670-60 ")
 ;;1667
 ;;21,"55887-0670-90 ")
 ;;1668
 ;;21,"55887-0799-28 ")
 ;;486
 ;;21,"55887-0799-30 ")
 ;;487
 ;;21,"55887-0799-60 ")
 ;;488
 ;;21,"55887-0822-10 ")
 ;;1002
 ;;21,"55887-0822-14 ")
 ;;1003
 ;;21,"55887-0822-30 ")
 ;;1004
 ;;21,"55887-0822-60 ")
 ;;1005
 ;;21,"55887-0822-90 ")
 ;;1006
 ;;21,"55887-0860-14 ")
 ;;1494
 ;;21,"55887-0860-20 ")
 ;;1495
 ;;21,"55887-0860-28 ")
 ;;1496
 ;;21,"55887-0860-30 ")
 ;;1497
 ;;21,"55887-0860-40 ")
 ;;1498
 ;;21,"55887-0860-50 ")
 ;;1499
 ;;21,"55887-0860-82 ")
 ;;1500
 ;;21,"55887-0860-90 ")
 ;;1501
 ;;21,"55887-0907-14 ")
 ;;1288
 ;;21,"55887-0907-20 ")
 ;;1289
 ;;21,"55887-0907-28 ")
 ;;1290
 ;;21,"55887-0907-30 ")
 ;;1291
 ;;21,"55887-0907-60 ")
 ;;1292
 ;;21,"55887-0907-82 ")
 ;;1293
 ;;21,"55887-0989-10 ")
 ;;785
 ;;21,"55887-0989-12 ")
 ;;786
 ;;21,"55887-0989-15 ")
 ;;787
 ;;21,"55887-0989-16 ")
 ;;788
 ;;21,"55887-0989-20 ")
 ;;789
 ;;21,"55887-0989-21 ")
 ;;790
 ;;21,"55887-0989-30 ")
 ;;791
 ;;21,"55887-0989-40 ")
 ;;792
 ;;21,"55887-0989-50 ")
 ;;793
 ;;21,"55887-0989-60 ")
 ;;794
 ;;21,"55887-0989-82 ")
 ;;795
 ;;21,"55887-0989-90 ")
 ;;796
 ;;21,"55887-0989-92 ")
 ;;797
 ;;21,"55887-0990-10 ")
 ;;243
 ;;21,"55887-0990-14 ")
 ;;244
 ;;21,"55887-0990-20 ")
 ;;245
 ;;21,"55887-0990-25 ")
 ;;246
 ;;21,"55887-0990-28 ")
 ;;247
 ;;21,"55887-0990-30 ")
 ;;248
 ;;21,"55887-0990-40 ")
 ;;249
 ;;21,"55887-0990-60 ")
 ;;250
 ;;21,"55887-0990-82 ")
 ;;251
 ;;21,"55887-0990-90 ")
 ;;252
 ;;21,"57664-0122-13 ")
 ;;489
 ;;21,"57866-3444-01 ")
 ;;490
 ;;21,"57866-3444-04 ")
 ;;491
 ;;21,"57866-3444-06 ")
 ;;492
 ;;21,"57866-4026-01 ")
 ;;1294
 ;;21,"57866-4026-02 ")
 ;;1295
 ;;21,"57866-4027-01 ")
 ;;1502
 ;;21,"57866-4027-02 ")
 ;;1503
 ;;21,"57866-4027-04 ")
 ;;1504
 ;;21,"57866-4842-01 ")
 ;;798
 ;;21,"57866-4842-02 ")
 ;;799
 ;;21,"57866-4842-04 ")
 ;;800
 ;;21,"57866-4842-06 ")
 ;;801
 ;;21,"57866-4842-07 ")
 ;;802
 ;;21,"57866-4842-08 ")
 ;;803
 ;;21,"57866-7601-02 ")
 ;;1669
 ;;21,"57866-7601-03 ")
 ;;1670
 ;;21,"57866-7601-04 ")
 ;;1671
 ;;21,"57866-7601-05 ")
 ;;1672
 ;;21,"57866-7601-06 ")
 ;;1673
 ;;21,"58016-0038-00 ")
 ;;253
 ;;21,"58016-0038-30 ")
 ;;254
 ;;21,"58016-0038-60 ")
 ;;255
 ;;21,"58016-0038-90 ")
 ;;256
 ;;21,"58016-0070-00 ")
 ;;804
 ;;21,"58016-0070-30 ")
 ;;805
 ;;21,"58016-0070-60 ")
 ;;806
 ;;21,"58016-0070-90 ")
 ;;807
 ;;21,"58016-0076-00 ")
 ;;1007
 ;;21,"58016-0076-30 ")
 ;;1008
 ;;21,"58016-0076-60 ")
 ;;1009
 ;;21,"58016-0076-90 ")
 ;;1010
 ;;21,"58016-0076-99 ")
 ;;1011
 ;;21,"58016-0199-00 ")
 ;;35
 ;;21,"58016-0199-02 ")
 ;;36
 ;;21,"58016-0199-03 ")
 ;;37
 ;;21,"58016-0199-20 ")
 ;;38
 ;;21,"58016-0199-30 ")
 ;;39
 ;;21,"58016-0199-40 ")
 ;;40
 ;;21,"58016-0199-60 ")
 ;;41
 ;;21,"58016-0199-89 ")
 ;;42
 ;;21,"58016-0199-90 ")
 ;;43
 ;;21,"58016-0199-99 ")
 ;;44
 ;;21,"58016-0234-00 ")
 ;;808
 ;;21,"58016-0234-02 ")
 ;;809
 ;;21,"58016-0234-07 ")
 ;;810
 ;;21,"58016-0234-10 ")
 ;;811
 ;;21,"58016-0234-12 ")
 ;;812
 ;;21,"58016-0234-14 ")
 ;;813
 ;;21,"58016-0234-15 ")
 ;;814
 ;;21,"58016-0234-18 ")
 ;;815
 ;;21,"58016-0234-20 ")
 ;;816
 ;;21,"58016-0234-21 ")
 ;;817
 ;;21,"58016-0234-24 ")
 ;;818
 ;;21,"58016-0234-28 ")
 ;;819
 ;;21,"58016-0234-30 ")
 ;;820
 ;;21,"58016-0234-40 ")
 ;;821
 ;;21,"58016-0234-45 ")
 ;;822
 ;;21,"58016-0234-50 ")
 ;;823
 ;;21,"58016-0234-56 ")
 ;;824
 ;;21,"58016-0234-60 ")
 ;;825
 ;;21,"58016-0234-90 ")
 ;;826
 ;;21,"58016-0234-99 ")
 ;;827
 ;;21,"58016-0248-00 ")
 ;;1674
 ;;21,"58016-0248-07 ")
 ;;1675
 ;;21,"58016-0248-10 ")
 ;;1676
 ;;21,"58016-0248-12 ")
 ;;1677
 ;;21,"58016-0248-14 ")
 ;;1678
 ;;21,"58016-0248-15 ")
 ;;1679
 ;;21,"58016-0248-20 ")
 ;;1680
 ;;21,"58016-0248-21 ")
 ;;1681
 ;;21,"58016-0248-28 ")
 ;;1682
 ;;21,"58016-0248-30 ")
 ;;1683
 ;;21,"58016-0248-40 ")
 ;;1684
 ;;21,"58016-0248-42 ")
 ;;1685
 ;;21,"58016-0248-50 ")
 ;;1686
 ;;21,"58016-0248-60 ")
 ;;1687
 ;;21,"58016-0248-90 ")
 ;;1688
 ;;21,"58016-0257-00 ")
 ;;1296