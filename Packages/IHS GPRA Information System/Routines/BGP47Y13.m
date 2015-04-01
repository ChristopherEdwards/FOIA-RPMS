BGP47Y13 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"66336-0946-60 ")
 ;;429
 ;;21,"66336-0946-90 ")
 ;;430
 ;;21,"66336-0972-30 ")
 ;;1902
 ;;21,"66336-0972-62 ")
 ;;1903
 ;;21,"66336-0972-90 ")
 ;;1904
 ;;21,"66685-0301-00 ")
 ;;683
 ;;21,"66685-0301-02 ")
 ;;684
 ;;21,"66685-0302-00 ")
 ;;773
 ;;21,"66685-0302-02 ")
 ;;774
 ;;21,"66685-0303-00 ")
 ;;931
 ;;21,"66685-0303-02 ")
 ;;932
 ;;21,"66685-0304-00 ")
 ;;1096
 ;;21,"66685-0304-02 ")
 ;;1097
 ;;21,"66685-0701-01 ")
 ;;1465
 ;;21,"66685-0701-02 ")
 ;;1466
 ;;21,"66685-0702-01 ")
 ;;1545
 ;;21,"66685-0702-02 ")
 ;;1546
 ;;21,"66685-0702-03 ")
 ;;1547
 ;;21,"66685-0703-01 ")
 ;;1895
 ;;21,"66685-0703-02 ")
 ;;1896
 ;;21,"66685-0703-03 ")
 ;;1897
 ;;21,"66685-0704-01 ")
 ;;2035
 ;;21,"66685-0704-02 ")
 ;;2036
 ;;21,"66685-0704-03 ")
 ;;2037
 ;;21,"66685-0705-01 ")
 ;;2316
 ;;21,"66685-0705-02 ")
 ;;2317
 ;;21,"66685-0706-01 ")
 ;;2455
 ;;21,"66685-0706-02 ")
 ;;2456
 ;;21,"66685-0706-03 ")
 ;;2457
 ;;21,"66685-0706-04 ")
 ;;2458
 ;;21,"67253-0106-10 ")
 ;;2967
 ;;21,"67253-0107-10 ")
 ;;2987
 ;;21,"67253-0108-10 ")
 ;;3010
 ;;21,"67253-0671-10 ")
 ;;2734
 ;;21,"67253-0672-10 ")
 ;;2771
 ;;21,"67253-0672-11 ")
 ;;2772
 ;;21,"67253-0673-10 ")
 ;;2837
 ;;21,"67253-0673-11 ")
 ;;2838
 ;;21,"67253-0674-10 ")
 ;;2912
 ;;21,"67253-0674-11 ")
 ;;2913
 ;;21,"67263-0257-01 ")
 ;;239
 ;;21,"67263-0304-01 ")
 ;;1
 ;;21,"67263-0406-30 ")
 ;;3538
 ;;21,"67544-0042-15 ")
 ;;1367
 ;;21,"67544-0042-30 ")
 ;;1368
 ;;21,"67544-0042-45 ")
 ;;1369
 ;;21,"67544-0042-53 ")
 ;;1370
 ;;21,"67544-0042-60 ")
 ;;1371
 ;;21,"67544-0042-70 ")
 ;;1372
 ;;21,"67544-0042-73 ")
 ;;1373
 ;;21,"67544-0042-80 ")
 ;;1374
 ;;21,"67544-0042-92 ")
 ;;1375
 ;;21,"67544-0042-94 ")
 ;;1376
 ;;21,"67544-0062-30 ")
 ;;1451
 ;;21,"67544-0062-60 ")
 ;;1452
 ;;21,"67544-0062-82 ")
 ;;1453
 ;;21,"67544-0128-15 ")
 ;;1591
 ;;21,"67544-0128-30 ")
 ;;1592
 ;;21,"67544-0128-45 ")
 ;;1593
 ;;21,"67544-0128-53 ")
 ;;1594
 ;;21,"67544-0128-60 ")
 ;;1595
 ;;21,"67544-0134-15 ")
 ;;2003
 ;;21,"67544-0134-30 ")
 ;;2090
 ;;21,"67544-0134-45 ")
 ;;2091
 ;;21,"67544-0134-60 ")
 ;;2092
 ;;21,"67544-0134-80 ")
 ;;2093
 ;;21,"67544-0148-15 ")
 ;;2497
 ;;21,"67544-0148-30 ")
 ;;2498
 ;;21,"67544-0148-45 ")
 ;;2499
 ;;21,"67544-0148-53 ")
 ;;2500
 ;;21,"67544-0148-60 ")
 ;;2501
 ;;21,"67544-0148-80 ")
 ;;2502
 ;;21,"67544-0150-45 ")
 ;;344
 ;;21,"67544-0150-60 ")
 ;;345
 ;;21,"67544-0150-73 ")
 ;;346
 ;;21,"67544-0150-92 ")
 ;;347
 ;;21,"67544-0159-15 ")
 ;;1850
 ;;21,"67544-0159-30 ")
 ;;1851
 ;;21,"67544-0159-45 ")
 ;;1852
 ;;21,"67544-0159-58 ")
 ;;1853
 ;;21,"67544-0159-60 ")
 ;;1854
 ;;21,"67544-0159-80 ")
 ;;1855
 ;;21,"67544-0160-60 ")
 ;;1060
 ;;21,"67544-0160-80 ")
 ;;1061
 ;;21,"67544-0165-60 ")
 ;;885
 ;;21,"67544-0165-80 ")
 ;;886
 ;;21,"67544-0166-80 ")
 ;;752
 ;;21,"67544-0173-30 ")
 ;;1708
 ;;21,"67544-0173-45 ")
 ;;1709
 ;;21,"67544-0173-53 ")
 ;;1710
 ;;21,"67544-0173-60 ")
 ;;1711
 ;;21,"67544-0174-30 ")
 ;;2231
 ;;21,"67544-0174-45 ")
 ;;2232
 ;;21,"67544-0174-60 ")
 ;;2233
 ;;21,"67544-0174-80 ")
 ;;2234
 ;;21,"67544-0175-80 ")
 ;;887
 ;;21,"67544-0177-45 ")
 ;;3052
 ;;21,"67544-0192-30 ")
 ;;1712
 ;;21,"67544-0192-45 ")
 ;;1713
 ;;21,"67544-0192-53 ")
 ;;1714
 ;;21,"67544-0192-60 ")
 ;;1715
 ;;21,"67544-0201-45 ")
 ;;1443
 ;;21,"67544-0202-15 ")
 ;;1286
 ;;21,"67544-0202-30 ")
 ;;1287
 ;;21,"67544-0202-45 ")
 ;;1288
 ;;21,"67544-0202-80 ")
 ;;1289
 ;;21,"67544-0212-45 ")
 ;;3045
 ;;21,"67544-0212-53 ")
 ;;3046
 ;;21,"67544-0216-80 ")
 ;;933
 ;;21,"67544-0218-60 ")
 ;;1467
 ;;21,"67544-0218-82 ")
 ;;1468
 ;;21,"67544-0219-15 ")
 ;;1898
 ;;21,"67544-0219-30 ")
 ;;1899
 ;;21,"67544-0219-45 ")
 ;;1900
 ;;21,"67544-0219-60 ")
 ;;1901
 ;;21,"67544-0234-45 ")
 ;;3335
 ;;21,"67544-0234-53 ")
 ;;3336
 ;;21,"67544-0250-60 ")
 ;;4321
 ;;21,"67544-0250-80 ")
 ;;4322
 ;;21,"67544-0276-60 ")
 ;;4349
 ;;21,"67544-0276-80 ")
 ;;4350
 ;;21,"67544-0286-80 ")
 ;;1017
 ;;21,"67544-0300-15 ")
 ;;1432
 ;;21,"67544-0300-30 ")
 ;;1433
 ;;21,"67544-0300-45 ")
 ;;1434
 ;;21,"67544-0306-30 ")
 ;;1435
 ;;21,"67544-0306-40 ")
 ;;1436
 ;;21,"67544-0306-45 ")
 ;;1437
 ;;21,"67544-0306-60 ")
 ;;1438
 ;;21,"67544-0311-30 ")
 ;;1439
 ;;21,"67544-0311-45 ")
 ;;1440
 ;;21,"67544-0315-80 ")
 ;;1019
 ;;21,"67544-0321-15 ")
 ;;1262
 ;;21,"67544-0321-30 ")
 ;;1263
 ;;21,"67544-0321-60 ")
 ;;1264
 ;;21,"67544-0322-15 ")
 ;;1305
 ;;21,"67544-0322-30 ")
 ;;1306
 ;;21,"67544-0322-45 ")
 ;;1307
 ;;21,"67544-0322-53 ")
 ;;1308
 ;;21,"67544-0322-60 ")
 ;;1309
 ;;21,"67544-0322-70 ")
 ;;1310
 ;;21,"67544-0322-73 ")
 ;;1311
 ;;21,"67544-0322-80 ")
 ;;1312
 ;;21,"67544-0322-92 ")
 ;;1313
 ;;21,"67544-0322-94 ")
 ;;1314
 ;;21,"67544-0350-80 ")
 ;;749
 ;;21,"67544-0377-60 ")
 ;;4336
 ;;21,"67544-0380-30 ")
 ;;1245
 ;;21,"67544-0380-60 ")
 ;;1246
 ;;21,"67544-0381-15 ")
 ;;1352
 ;;21,"67544-0381-30 ")
 ;;1353
 ;;21,"67544-0381-45 ")
 ;;1354
 ;;21,"67544-0381-53 ")
 ;;1355
 ;;21,"67544-0381-60 ")
 ;;1356
 ;;21,"67544-0381-70 ")
 ;;1357
 ;;21,"67544-0381-73 ")
 ;;1358
 ;;21,"67544-0381-80 ")
 ;;1359
 ;;21,"67544-0381-92 ")
 ;;1360
 ;;21,"67544-0381-94 ")
 ;;1361
 ;;21,"67544-0382-30 ")
 ;;3256
 ;;21,"67544-0400-45 ")
 ;;3190
 ;;21,"67544-0403-30 ")
 ;;3623
 ;;21,"67544-0404-30 ")
 ;;3693
 ;;21,"67544-0418-30 ")
 ;;4333
 ;;21,"67544-0418-60 ")
 ;;4334
 ;;21,"67544-0418-80 ")
 ;;4335
 ;;21,"67544-0431-15 ")
 ;;1330
 ;;21,"67544-0431-30 ")
 ;;1378
 ;;21,"67544-0431-45 ")
 ;;1331
 ;;21,"67544-0431-53 ")
 ;;1332
 ;;21,"67544-0431-60 ")
 ;;1333
 ;;21,"67544-0431-70 ")
 ;;1334
 ;;21,"67544-0431-73 ")
 ;;1335
 ;;21,"67544-0431-80 ")
 ;;1336
 ;;21,"67544-0431-92 ")
 ;;1337
 ;;21,"67544-0431-94 ")
 ;;1338
 ;;21,"67544-0454-15 ")
 ;;1425
 ;;21,"67544-0454-30 ")
 ;;1426
 ;;21,"67544-0454-40 ")
 ;;1427
 ;;21,"67544-0454-45 ")
 ;;1428
 ;;21,"67544-0454-60 ")
 ;;1429
 ;;21,"67544-0489-15 ")
 ;;1276
 ;;21,"67544-0489-30 ")
 ;;1277
 ;;21,"67544-0489-60 ")
 ;;1278
 ;;21,"67544-0678-60 ")
 ;;1894
 ;;21,"67544-0992-30 ")
 ;;2235
 ;;21,"67544-0997-30 ")
 ;;2439
 ;;21,"67544-0999-60 ")
 ;;2236
 ;;21,"67544-0999-80 ")
 ;;2237
 ;;21,"67544-1010-30 ")
 ;;4238
 ;;21,"67544-1010-60 ")
 ;;4239
 ;;21,"67544-1038-30 ")
 ;;1411
 ;;21,"67544-1038-45 ")
 ;;1412
 ;;21,"67544-1042-45 ")
 ;;1413
 ;;21,"67544-1042-60 ")
 ;;1414
 ;;21,"67544-1054-30 ")
 ;;4399
 ;;21,"67544-1057-30 ")
 ;;4450
 ;;21,"67544-1082-45 ")
 ;;1317
 ;;21,"67544-1105-30 ")
 ;;1265
 ;;21,"67544-1105-45 ")
 ;;1266
 ;;21,"67544-1348-45 ")
 ;;1963
 ;;21,"67544-1348-60 ")
 ;;1964
 ;;21,"67544-1350-45 ")
 ;;2479
 ;;21,"67544-1350-60 ")
 ;;2480
 ;;21,"67544-1372-45 ")
 ;;1587
 ;;21,"67544-1386-30 ")
 ;;4310
 ;;21,"67544-1386-60 ")
 ;;4311
 ;;21,"67544-1387-45 ")
 ;;2071
 ;;21,"68030-6700-02 ")
 ;;1971
 ;;21,"68030-6701-02 ")
 ;;2242
 ;;21,"68071-0026-30 ")
 ;;277
 ;;21,"68071-0026-60 ")
 ;;278
 ;;21,"68071-0026-90 ")
 ;;279
 ;;21,"68071-0146-30 ")
 ;;149
 ;;21,"68071-0146-60 ")
 ;;150
 ;;21,"68071-0146-90 ")
 ;;151
 ;;21,"68071-0146-91 ")
 ;;152
 ;;21,"68071-0153-30 ")
 ;;4475
 ;;21,"68071-0153-60 ")
 ;;4476
 ;;21,"68071-0153-90 ")
 ;;4477
 ;;21,"68071-0785-30 ")
 ;;5051
 ;;21,"68071-0785-60 ")
 ;;5052
 ;;21,"68071-0786-30 ")
 ;;4996
 ;;21,"68071-0786-60 ")
 ;;4997
 ;;21,"68071-0787-60 ")
 ;;4744
 ;;21,"68071-0857-30 ")
 ;;3303
 ;;21,"68071-0884-30 ")
 ;;3403
 ;;21,"68071-1517-09 ")
 ;;3404
 ;;21,"68084-0007-11 ")
 ;;3154
 ;;21,"68084-0007-21 ")
 ;;3155
 ;;21,"68084-0058-01 ")
 ;;1514
 ;;21,"68084-0058-11 ")
 ;;1515
 ;;21,"68084-0060-01 ")
 ;;1659
 ;;21,"68084-0060-11 ")
 ;;1660
 ;;21,"68084-0061-01 ")
 ;;1765
 ;;21,"68084-0061-11 ")
 ;;1766
 ;;21,"68084-0062-01 ")
 ;;2168
 ;;21,"68084-0062-11 ")
 ;;2169
 ;;21,"68084-0064-01 ")
 ;;2398
 ;;21,"68084-0064-11 ")
 ;;2399
 ;;21,"68084-0266-01 ")
 ;;2781
 ;;21,"68084-0266-11 ")
 ;;2782
 ;;21,"68084-0267-01 ")
 ;;2855
 ;;21,"68084-0267-11 ")
 ;;2856
 ;;21,"68084-0268-01 ")
 ;;2927
 ;;21,"68084-0268-11 ")
 ;;2928
 ;;21,"68084-0294-11 ")
 ;;2731
 ;;21,"68084-0294-21 ")
 ;;2732
 ;;21,"68084-0346-01 ")
 ;;3300
 ;;21,"68084-0346-11 ")
 ;;3301
 ;;21,"68084-0347-01 ")
 ;;3400
 ;;21,"68084-0347-11 ")
 ;;3401
 ;;21,"68084-0348-01 ")
 ;;3500
 ;;21,"68084-0348-11 ")
 ;;3501
 ;;21,"68084-0349-11 ")
 ;;3788
 ;;21,"68084-0349-21 ")
 ;;3789
 ;;21,"68084-0350-01 ")
 ;;3848
 ;;21,"68084-0350-11 ")
 ;;3849
 ;;21,"68084-0351-11 ")
 ;;3916
 ;;21,"68084-0351-21 ")
 ;;3917
 ;;21,"68084-0390-01 ")
 ;;880
 ;;21,"68084-0390-11 ")
 ;;881
 ;;21,"68084-0391-01 ")
 ;;1015
 ;;21,"68084-0391-11 ")
 ;;1016
 ;;21,"68084-0392-01 ")
 ;;1191
 ;;21,"68084-0392-11 ")
 ;;1192
 ;;21,"68084-0518-11 ")
 ;;4266
 ;;21,"68084-0518-21 ")
 ;;4267
 ;;21,"68084-0519-11 ")
 ;;4485
 ;;21,"68084-0519-21 ")
 ;;4486
 ;;21,"68084-0644-11 ")
 ;;3152
 ;;21,"68084-0644-21 ")
 ;;3153
 ;;21,"68115-0059-00 ")
 ;;459
 ;;21,"68115-0059-30 ")
 ;;460
 ;;21,"68115-0059-60 ")
 ;;461
 ;;21,"68115-0059-90 ")
 ;;462
 ;;21,"68115-0060-30 ")
 ;;564
 ;;21,"68115-0060-60 ")
 ;;565
 ;;21,"68115-0060-90 ")
 ;;566
 ;;21,"68115-0127-00 ")
 ;;934
 ;;21,"68115-0127-15 ")
 ;;935
 ;;21,"68115-0127-30 ")
 ;;936
 ;;21,"68115-0127-60 ")
 ;;937
 ;;21,"68115-0128-00 ")
 ;;1092
 ;;21,"68115-0128-20 ")
 ;;1093
 ;;21,"68115-0128-30 ")
 ;;1094
 ;;21,"68115-0128-60 ")
 ;;1095
 ;;21,"68115-0129-30 ")
 ;;780
 ;;21,"68115-0129-60 ")
 ;;781
 ;;21,"68115-0207-30 ")
 ;;1925
 ;;21,"68115-0207-60 ")
 ;;1926
 ;;21,"68115-0207-90 ")
 ;;1927
 ;;21,"68115-0208-30 ")
 ;;2052
 ;;21,"68115-0208-60 ")
 ;;2053
 ;;21,"68115-0208-90 ")
 ;;2054
 ;;21,"68115-0209-30 ")
 ;;2503
 ;;21,"68115-0215-30 ")
 ;;126
 ;;21,"68115-0216-30 ")
 ;;228
 ;;21,"68115-0217-30 ")
 ;;313
 ;;21,"68115-0361-30 ")
 ;;2002
 ;;21,"68115-0362-00 ")
 ;;2259
 ;;21,"68115-0362-60 ")
 ;;2273
 ;;21,"68115-0363-30 ")
 ;;1745
 ;;21,"68115-0378-30 ")
 ;;2882
 ;;21,"68115-0378-60 ")
 ;;2883
 ;;21,"68115-0396-30 ")
 ;;1661
 ;;21,"68115-0425-90 ")
 ;;661
 ;;21,"68115-0490-30 ")
 ;;92
 ;;21,"68115-0490-60 ")
 ;;93
 ;;21,"68115-0491-30 ")
 ;;192
 ;;21,"68115-0530-00 ")
 ;;2743
 ;;21,"68115-0530-30 ")
 ;;2744
 ;;21,"68115-0530-60 ")
 ;;2745
 ;;21,"68115-0597-00 ")
 ;;240
 ;;21,"68115-0615-00 ")
 ;;91
 ;;21,"68115-0621-00 ")
 ;;39
 ;;21,"68115-0650-00 ")
 ;;3947
 ;;21,"68115-0654-00 ")
 ;;169
 ;;21,"68115-0669-00 ")
 ;;5004
 ;;21,"68115-0669-90 ")
 ;;5005
 ;;21,"68115-0673-00 ")
 ;;3858
 ;;21,"68115-0673-30 ")
 ;;3859
 ;;21,"68115-0677-00 ")
 ;;4312
 ;;21,"68115-0677-30 ")
 ;;4313
 ;;21,"68115-0703-30 ")
 ;;4640
 ;;21,"68115-0703-90 ")
 ;;4641
 ;;21,"68115-0733-00 ")
 ;;3324
 ;;21,"68115-0733-30 ")
 ;;3325
 ;;21,"68115-0733-90 ")
 ;;3326
 ;;21,"68115-0778-00 ")
 ;;3798
 ;;21,"68115-0812-00 ")
 ;;2801
 ;;21,"68115-0812-30 ")
 ;;2802
 ;;21,"68115-0812-60 ")
 ;;2803
 ;;21,"68115-0824-00 ")
 ;;41
 ;;21,"68115-0854-00 ")
 ;;3630
 ;;21,"68115-0854-90 ")
 ;;3631
 ;;21,"68115-0865-30 ")
 ;;4880
 ;;21,"68115-0889-90 ")
 ;;2642
 ;;21,"68180-0101-02 ")
 ;;5171
 ;;21,"68180-0101-09 ")
 ;;5172
 ;;21,"68180-0102-02 ")
 ;;5203
 ;;21,"68180-0102-09 ")
 ;;5204
 ;;21,"68180-0103-02 ")
 ;;5023
 ;;21,"68180-0103-09 ")
 ;;5024
 ;;21,"68180-0104-02 ")
 ;;5080
 ;;21,"68180-0104-09 ")
 ;;5081
 ;;21,"68180-0105-02 ")
 ;;5143
 ;;21,"68180-0105-09 ")
 ;;5144
 ;;21,"68180-0210-03 ")
 ;;3278
 ;;21,"68180-0210-09 ")
 ;;3279
 ;;21,"68180-0211-03 ")
 ;;3365
 ;;21,"68180-0211-09 ")
 ;;3366
 ;;21,"68180-0212-03 ")
 ;;3472
 ;;21,"68180-0212-09 ")
 ;;3473
 ;;21,"68180-0215-03 ")
 ;;4789
 ;;21,"68180-0215-06 ")
 ;;4790
 ;;21,"68180-0215-09 ")
 ;;4791
 ;;21,"68180-0216-03 ")
 ;;4854
 ;;21,"68180-0216-06 ")
 ;;4855
 ;;21,"68180-0216-09 ")
 ;;4856
 ;;21,"68180-0217-03 ")
 ;;4912
 ;;21,"68180-0217-06 ")
 ;;4913
 ;;21,"68180-0217-09 ")
 ;;4914
 ;;21,"68180-0235-01 ")
 ;;2566
 ;;21,"68180-0236-01 ")
 ;;2571
 ;;21,"68180-0237-01 ")
 ;;2577
 ;;21,"68180-0410-06 ")
 ;;3105
 ;;21,"68180-0410-09 ")
 ;;3106
 ;;21,"68180-0411-06 ")
 ;;3177
 ;;21,"68180-0411-09 ")
 ;;3178
 ;;21,"68180-0412-06 ")
 ;;3239
 ;;21,"68180-0412-09 ")
 ;;3240
 ;;21,"68180-0413-06 ")
 ;;4696
 ;;21,"68180-0413-09 ")
 ;;4697
 ;;21,"68180-0414-06 ")
 ;;4734
 ;;21,"68180-0414-09 ")
 ;;4735
 ;;21,"68180-0512-01 ")
 ;;1519
 ;;21,"68180-0512-02 ")
 ;;1520
 ;;21,"68180-0512-09 ")
 ;;1521
 ;;21,"68180-0513-01 ")
 ;;1670
 ;;21,"68180-0513-03 ")
 ;;1671
 ;;21,"68180-0513-09 ")
 ;;1672
 ;;21,"68180-0514-01 ")
 ;;1823
 ;;21,"68180-0514-03 ")
 ;;1824
 ;;21,"68180-0514-09 ")
 ;;1825
 ;;21,"68180-0515-01 ")
 ;;2110
 ;;21,"68180-0515-03 ")
 ;;2111