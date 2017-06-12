BGP63E4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 11, 2016;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54458-0992-10 ")
 ;;1237
 ;;21,"54458-0993-09 ")
 ;;1174
 ;;21,"54569-4437-00 ")
 ;;304
 ;;21,"54569-4438-00 ")
 ;;380
 ;;21,"54569-4572-00 ")
 ;;79
 ;;21,"54569-4696-00 ")
 ;;764
 ;;21,"54569-4698-00 ")
 ;;524
 ;;21,"54569-4714-00 ")
 ;;12
 ;;21,"54569-4719-00 ")
 ;;35
 ;;21,"54569-4719-01 ")
 ;;36
 ;;21,"54569-4722-00 ")
 ;;1414
 ;;21,"54569-4722-01 ")
 ;;1415
 ;;21,"54569-4766-00 ")
 ;;1693
 ;;21,"54569-4766-03 ")
 ;;1694
 ;;21,"54569-4767-00 ")
 ;;1628
 ;;21,"54569-4767-03 ")
 ;;1629
 ;;21,"54569-4829-00 ")
 ;;1175
 ;;21,"54569-4895-00 ")
 ;;147
 ;;21,"54569-5232-00 ")
 ;;798
 ;;21,"54569-5361-00 ")
 ;;609
 ;;21,"54569-5362-00 ")
 ;;525
 ;;21,"54569-5606-00 ")
 ;;429
 ;;21,"54569-5665-00 ")
 ;;1588
 ;;21,"54569-5666-00 ")
 ;;553
 ;;21,"54569-5667-00 ")
 ;;1735
 ;;21,"54569-5685-00 ")
 ;;957
 ;;21,"54569-5685-01 ")
 ;;958
 ;;21,"54569-5801-00 ")
 ;;987
 ;;21,"54569-5867-00 ")
 ;;188
 ;;21,"54569-5878-00 ")
 ;;703
 ;;21,"54569-5880-01 ")
 ;;1464
 ;;21,"54569-5903-00 ")
 ;;1529
 ;;21,"54569-5937-00 ")
 ;;765
 ;;21,"54569-5938-00 ")
 ;;799
 ;;21,"54569-5998-00 ")
 ;;1521
 ;;21,"54569-5999-00 ")
 ;;1365
 ;;21,"54569-6091-00 ")
 ;;1176
 ;;21,"54569-6091-01 ")
 ;;1177
 ;;21,"54569-6092-00 ")
 ;;1238
 ;;21,"54569-6092-01 ")
 ;;1239
 ;;21,"54569-6110-01 ")
 ;;1662
 ;;21,"54569-6173-00 ")
 ;;381
 ;;21,"54569-6173-01 ")
 ;;382
 ;;21,"54569-6180-00 ")
 ;;1465
 ;;21,"54569-6180-01 ")
 ;;1466
 ;;21,"54569-6182-00 ")
 ;;1366
 ;;21,"54569-6182-01 ")
 ;;1367
 ;;21,"54569-6223-00 ")
 ;;1416
 ;;21,"54569-6228-00 ")
 ;;1307
 ;;21,"54569-6228-01 ")
 ;;1308
 ;;21,"54569-6294-00 ")
 ;;305
 ;;21,"54569-6294-01 ")
 ;;306
 ;;21,"54569-6297-00 ")
 ;;238
 ;;21,"54569-6309-00 ")
 ;;80
 ;;21,"54569-8595-00 ")
 ;;1022
 ;;21,"54868-0009-00 ")
 ;;1055
 ;;21,"54868-0009-01 ")
 ;;1056
 ;;21,"54868-1802-00 ")
 ;;1542
 ;;21,"54868-2335-00 ")
 ;;239
 ;;21,"54868-2335-01 ")
 ;;240
 ;;21,"54868-3443-00 ")
 ;;1506
 ;;21,"54868-3443-01 ")
 ;;1507
 ;;21,"54868-3726-00 ")
 ;;383
 ;;21,"54868-3726-01 ")
 ;;384
 ;;21,"54868-3726-02 ")
 ;;385
 ;;21,"54868-3906-00 ")
 ;;933
 ;;21,"54868-3906-01 ")
 ;;934
 ;;21,"54868-4003-00 ")
 ;;1240
 ;;21,"54868-4062-00 ")
 ;;1006
 ;;21,"54868-4062-01 ")
 ;;1007
 ;;21,"54868-4066-00 ")
 ;;742
 ;;21,"54868-4066-01 ")
 ;;743
 ;;21,"54868-4073-00 ")
 ;;766
 ;;21,"54868-4073-01 ")
 ;;767
 ;;21,"54868-4073-02 ")
 ;;768
 ;;21,"54868-4073-03 ")
 ;;769
 ;;21,"54868-4074-00 ")
 ;;800
 ;;21,"54868-4074-01 ")
 ;;801
 ;;21,"54868-4074-02 ")
 ;;802
 ;;21,"54868-4074-03 ")
 ;;803
 ;;21,"54868-4074-04 ")
 ;;804
 ;;21,"54868-4199-00 ")
 ;;81
 ;;21,"54868-4199-01 ")
 ;;82
 ;;21,"54868-4199-02 ")
 ;;83
 ;;21,"54868-4341-00 ")
 ;;1467
 ;;21,"54868-4341-01 ")
 ;;1468
 ;;21,"54868-4413-00 ")
 ;;13
 ;;21,"54868-4414-00 ")
 ;;148
 ;;21,"54868-4425-00 ")
 ;;1695
 ;;21,"54868-4425-01 ")
 ;;1696
 ;;21,"54868-4425-02 ")
 ;;1697
 ;;21,"54868-4428-00 ")
 ;;1630
 ;;21,"54868-4428-01 ")
 ;;1631
 ;;21,"54868-4428-02 ")
 ;;1632
 ;;21,"54868-4479-00 ")
 ;;1508
 ;;21,"54868-4479-01 ")
 ;;1509
 ;;21,"54868-4479-02 ")
 ;;1510
 ;;21,"54868-4494-00 ")
 ;;1104
 ;;21,"54868-4526-01 ")
 ;;1134
 ;;21,"54868-4539-01 ")
 ;;479
 ;;21,"54868-4540-01 ")
 ;;1589
 ;;21,"54868-4605-01 ")
 ;;496
 ;;21,"54868-4612-00 ")
 ;;23
 ;;21,"54868-4637-00 ")
 ;;1241
 ;;21,"54868-4637-01 ")
 ;;1242
 ;;21,"54868-4637-02 ")
 ;;1243
 ;;21,"54868-4637-03 ")
 ;;1244
 ;;21,"54868-4637-04 ")
 ;;1245
 ;;21,"54868-4645-00 ")
 ;;526
 ;;21,"54868-4645-01 ")
 ;;527
 ;;21,"54868-4645-02 ")
 ;;528
 ;;21,"54868-4652-00 ")
 ;;610
 ;;21,"54868-4652-01 ")
 ;;611
 ;;21,"54868-4652-02 ")
 ;;612
 ;;21,"54868-4652-03 ")
 ;;613
 ;;21,"54868-4729-00 ")
 ;;979
 ;;21,"54868-4785-00 ")
 ;;1309
 ;;21,"54868-4785-01 ")
 ;;1310
 ;;21,"54868-4785-02 ")
 ;;1311
 ;;21,"54868-4785-03 ")
 ;;1312
 ;;21,"54868-4869-00 ")
 ;;988
 ;;21,"54868-4870-00 ")
 ;;704
 ;;21,"54868-4870-01 ")
 ;;705
 ;;21,"54868-4870-02 ")
 ;;706
 ;;21,"54868-4885-00 ")
 ;;445
 ;;21,"54868-4885-01 ")
 ;;446
 ;;21,"54868-4904-00 ")
 ;;935
 ;;21,"54868-4904-01 ")
 ;;936
 ;;21,"54868-4977-00 ")
 ;;1178
 ;;21,"54868-4977-01 ")
 ;;1179
 ;;21,"54868-4977-02 ")
 ;;1180
 ;;21,"54868-4986-00 ")
 ;;430
 ;;21,"54868-4986-01 ")
 ;;431
 ;;21,"54868-4986-02 ")
 ;;432
 ;;21,"54868-5075-00 ")
 ;;1522
 ;;21,"54868-5075-01 ")
 ;;1523
 ;;21,"54868-5077-00 ")
 ;;307
 ;;21,"54868-5078-00 ")
 ;;1530
 ;;21,"54868-5078-01 ")
 ;;1531
 ;;21,"54868-5082-00 ")
 ;;554
 ;;21,"54868-5082-01 ")
 ;;555
 ;;21,"54868-5082-02 ")
 ;;556
 ;;21,"54868-5082-03 ")
 ;;557
 ;;21,"54868-5100-00 ")
 ;;1023
 ;;21,"54868-5100-01 ")
 ;;1024
 ;;21,"54868-5170-00 ")
 ;;1515
 ;;21,"54868-5170-01 ")
 ;;1516
 ;;21,"54868-5256-00 ")
 ;;918
 ;;21,"54868-5281-00 ")
 ;;1052
 ;;21,"54868-5281-01 ")
 ;;1053
 ;;21,"54868-5296-00 ")
 ;;959
 ;;21,"54868-5297-00 ")
 ;;1600
 ;;21,"54868-5313-00 ")
 ;;960
 ;;21,"54868-5313-01 ")
 ;;961
 ;;21,"54868-5323-00 ")
 ;;1736
 ;;21,"54868-5346-00 ")
 ;;1060
 ;;21,"54868-5346-01 ")
 ;;1061
 ;;21,"54868-5418-00 ")
 ;;1577
 ;;21,"54868-5465-00 ")
 ;;1141
 ;;21,"54868-5466-00 ")
 ;;42
 ;;21,"54868-5466-01 ")
 ;;43
 ;;21,"54868-5469-00 ")
 ;;1071
 ;;21,"54868-5469-01 ")
 ;;1072
 ;;21,"54868-5475-00 ")
 ;;1564
 ;;21,"54868-5489-00 ")
 ;;37
 ;;21,"54868-5503-00 ")
 ;;1042
 ;;21,"54868-5503-01 ")
 ;;1043
 ;;21,"54868-5591-00 ")
 ;;29
 ;;21,"54868-5607-00 ")
 ;;1759
 ;;21,"54868-5690-01 ")
 ;;727
 ;;21,"54868-5690-02 ")
 ;;728
 ;;21,"54868-5705-00 ")
 ;;1368
 ;;21,"54868-5780-00 ")
 ;;1663
 ;;21,"54868-5781-00 ")
 ;;707
 ;;21,"54868-5781-02 ")
 ;;708
 ;;21,"54868-5782-00 ")
 ;;805
 ;;21,"54868-5782-01 ")
 ;;806
 ;;21,"54868-5782-02 ")
 ;;807
 ;;21,"54868-5782-03 ")
 ;;808
 ;;21,"54868-5782-04 ")
 ;;809
 ;;21,"54868-5783-00 ")
 ;;830
 ;;21,"54868-5783-01 ")
 ;;831
 ;;21,"54868-5787-00 ")
 ;;1001
 ;;21,"54868-5792-00 ")
 ;;770
 ;;21,"54868-5792-01 ")
 ;;771
 ;;21,"54868-5804-00 ")
 ;;874
 ;;21,"54868-5977-00 ")
 ;;577
 ;;21,"54868-5983-00 ")
 ;;884
 ;;21,"54868-5983-01 ")
 ;;885
 ;;21,"54868-5996-00 ")
 ;;903
 ;;21,"54868-5997-00 ")
 ;;894
 ;;21,"54868-6036-00 ")
 ;;843
 ;;21,"54868-6123-00 ")
 ;;666
 ;;21,"55045-3170-00 ")
 ;;962
 ;;21,"55045-3225-06 ")
 ;;1313
 ;;21,"55045-3373-08 ")
 ;;1044
 ;;21,"55045-3401-08 ")
 ;;386
 ;;21,"55045-3409-09 ")
 ;;614
 ;;21,"55111-0133-01 ")
 ;;1045
 ;;21,"55111-0134-01 ")
 ;;1025
 ;;21,"55111-0338-01 ")
 ;;744
 ;;21,"55111-0339-01 ")
 ;;772
 ;;21,"55111-0339-05 ")
 ;;773
 ;;21,"55111-0340-01 ")
 ;;810
 ;;21,"55111-0340-05 ")
 ;;811
 ;;21,"55111-0341-01 ")
 ;;709
 ;;21,"55111-0341-05 ")
 ;;710
 ;;21,"55111-0586-01 ")
 ;;729
 ;;21,"55111-0587-01 ")
 ;;832
 ;;21,"55289-0039-30 ")
 ;;812
 ;;21,"55289-0096-30 ")
 ;;774
 ;;21,"55289-0238-30 ")
 ;;241
 ;;21,"55289-0436-30 ")
 ;;447
 ;;21,"55289-0443-30 ")
 ;;1532
 ;;21,"55289-0484-30 ")
 ;;1026
 ;;21,"55289-0522-30 ")
 ;;1469
 ;;21,"55289-0573-30 ")
 ;;1314
 ;;21,"55289-0815-30 ")
 ;;1698
 ;;21,"55289-0817-30 ")
 ;;529
 ;;21,"55289-0820-30 ")
 ;;1737
 ;;21,"55289-0825-30 ")
 ;;615
 ;;21,"55289-0838-30 ")
 ;;1633
 ;;21,"55289-0876-30 ")
 ;;558
 ;;21,"55289-0878-30 ")
 ;;1315
 ;;21,"55289-0878-90 ")
 ;;1316
 ;;21,"55289-0981-30 ")
 ;;711
 ;;21,"55390-0712-01 ")
 ;;1046
 ;;21,"55887-0102-30 ")
 ;;149
 ;;21,"55887-0103-30 ")
 ;;189
 ;;21,"55887-0105-30 ")
 ;;84
 ;;21,"55887-0175-30 ")
 ;;937
 ;;21,"55887-0307-30 ")
 ;;616
 ;;21,"55887-0366-30 ")
 ;;919
 ;;21,"55887-0425-30 ")
 ;;1181
 ;;21,"55887-0425-60 ")
 ;;1182
 ;;21,"55887-0425-90 ")
 ;;1183
 ;;21,"55887-0426-20 ")
 ;;1246
 ;;21,"55887-0426-60 ")
 ;;1247
 ;;21,"55887-0426-90 ")
 ;;1248
 ;;21,"55887-0432-30 ")
 ;;308
 ;;21,"55887-0432-60 ")
 ;;309
 ;;21,"55887-0432-90 ")
 ;;310
 ;;21,"55887-0532-60 ")
 ;;1317
 ;;21,"55887-0594-30 ")
 ;;1047
 ;;21,"55887-0594-90 ")
 ;;1048
 ;;21,"55887-0595-30 ")
 ;;1027
 ;;21,"55887-0595-90 ")
 ;;1028
 ;;21,"57237-0026-01 ")
 ;;1062
 ;;21,"57237-0026-30 ")
 ;;1063
 ;;21,"57237-0027-01 ")
 ;;1073
 ;;21,"57237-0027-30 ")
 ;;1074
 ;;21,"58016-0053-00 ")
 ;;448
 ;;21,"58016-0053-30 ")
 ;;449
 ;;21,"58016-0053-60 ")
 ;;450
 ;;21,"58016-0053-90 ")
 ;;451
 ;;21,"58016-0065-00 ")
 ;;938
 ;;21,"58016-0065-30 ")
 ;;939
 ;;21,"58016-0065-60 ")
 ;;940
 ;;21,"58016-0065-90 ")
 ;;941
 ;;21,"58016-0066-00 ")
 ;;433
 ;;21,"58016-0066-30 ")
 ;;434
 ;;21,"58016-0066-60 ")
 ;;435
 ;;21,"58016-0066-90 ")
 ;;436
 ;;21,"58016-0228-00 ")
 ;;1249
 ;;21,"58016-0228-02 ")
 ;;1250
 ;;21,"58016-0228-30 ")
 ;;1251
 ;;21,"58016-0228-60 ")
 ;;1252
 ;;21,"58016-0228-90 ")
 ;;1253
 ;;21,"58016-4631-01 ")
 ;;1590
 ;;21,"58864-0605-30 ")
 ;;530
 ;;21,"58864-0659-30 ")
 ;;1470
 ;;21,"58864-0661-30 ")
 ;;1493
 ;;21,"58864-0662-30 ")
 ;;387
 ;;21,"58864-0681-30 ")
 ;;617
 ;;21,"58864-0726-15 ")
 ;;85
 ;;21,"58864-0726-30 ")
 ;;86
 ;;21,"58864-0771-15 ")
 ;;150
 ;;21,"58864-0807-30 ")
 ;;311
 ;;21,"58864-0838-30 ")
 ;;1511
 ;;21,"59746-0333-10 ")
 ;;312
 ;;21,"59746-0333-90 ")
 ;;313
 ;;21,"59746-0334-10 ")
 ;;388
 ;;21,"59746-0334-30 ")
 ;;389
 ;;21,"59746-0334-90 ")
 ;;390
 ;;21,"59746-0335-10 ")
 ;;242
 ;;21,"59746-0335-30 ")
 ;;243
 ;;21,"59746-0335-90 ")
 ;;244
 ;;21,"59746-0337-90 ")
 ;;1417
 ;;21,"59746-0338-90 ")
 ;;1369
 ;;21,"59746-0339-30 ")
 ;;1471
 ;;21,"59746-0339-90 ")
 ;;1472
 ;;21,"59746-0360-30 ")
 ;;578
 ;;21,"59746-0361-90 ")
 ;;618
 ;;21,"59746-0362-90 ")
 ;;531
 ;;21,"59746-0363-90 ")
 ;;559
 ;;21,"59762-0011-01 ")
 ;;1418
 ;;21,"59762-0011-02 ")
 ;;1419
 ;;21,"59762-0012-01 ")
 ;;1370
 ;;21,"59762-0012-02 ")
 ;;1371
 ;;21,"59762-0015-01 ")
 ;;1473
 ;;21,"59762-0015-02 ")
 ;;1474
 ;;21,"59762-0070-01 ")
 ;;314
 ;;21,"59762-0071-01 ")
 ;;391
 ;;21,"59762-0071-02 ")
 ;;392
 ;;21,"59762-0072-01 ")
 ;;245
 ;;21,"59762-0072-02 ")
 ;;246
 ;;21,"59762-0220-01 ")
 ;;1553
 ;;21,"59762-0222-01 ")
 ;;1543
 ;;21,"59762-0223-01 ")
 ;;1565
 ;;21,"59762-3293-01 ")
 ;;1184
 ;;21,"59762-3293-02 ")
 ;;1185
 ;;21,"59762-3293-03 ")
 ;;1186
 ;;21,"59762-3293-04 ")
 ;;1187
 ;;21,"59762-3294-01 ")
 ;;1254
 ;;21,"59762-3294-02 ")
 ;;1255
 ;;21,"59762-3294-03 ")
 ;;1256
 ;;21,"59762-3294-04 ")
 ;;1257
 ;;21,"59762-3295-01 ")
 ;;1318
 ;;21,"59762-3295-02 ")
 ;;1319
 ;;21,"59762-3295-03 ")
 ;;1320
 ;;21,"59762-3295-04 ")
 ;;1321
 ;;21,"59762-5250-01 ")
 ;;1064
 ;;21,"59762-5250-04 ")
 ;;1065
 ;;21,"59762-5251-01 ")
 ;;1075
 ;;21,"59762-5251-04 ")
 ;;1076
 ;;21,"60429-0044-01 ")
 ;;1188
 ;;21,"60429-0044-10 ")
 ;;1189
 ;;21,"60429-0045-01 ")
 ;;1258
 ;;21,"60429-0045-10 ")
 ;;1259
 ;;21,"60429-0046-01 ")
 ;;1322
 ;;21,"60429-0046-10 ")
 ;;1323
 ;;21,"60505-0205-03 ")
 ;;1190
 ;;21,"60505-0206-03 ")
 ;;1260
 ;;21,"60505-0207-03 ")
 ;;1324
 ;;21,"60505-0208-01 ")
 ;;1049
 ;;21,"60505-0209-01 ")
 ;;1029
 ;;21,"60505-0261-01 ")
 ;;973
 ;;21,"60505-0262-01 ")
 ;;920