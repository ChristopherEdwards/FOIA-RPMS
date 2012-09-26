BGP21F16 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 14, 2011;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"67544-0305-30 ")
 ;;874
 ;;21,"67544-0305-53 ")
 ;;875
 ;;21,"67544-0305-60 ")
 ;;876
 ;;21,"67544-0326-15 ")
 ;;704
 ;;21,"67544-0326-30 ")
 ;;705
 ;;21,"67544-0326-45 ")
 ;;706
 ;;21,"67544-0326-60 ")
 ;;707
 ;;21,"67544-0326-73 ")
 ;;708
 ;;21,"67544-0326-80 ")
 ;;709
 ;;21,"67544-0332-60 ")
 ;;371
 ;;21,"67544-0376-30 ")
 ;;710
 ;;21,"67544-0376-45 ")
 ;;711
 ;;21,"67544-0376-60 ")
 ;;712
 ;;21,"67544-0376-70 ")
 ;;713
 ;;21,"67544-0376-73 ")
 ;;714
 ;;21,"67544-0376-80 ")
 ;;715
 ;;21,"67544-0387-30 ")
 ;;1615
 ;;21,"67544-0387-60 ")
 ;;1616
 ;;21,"67544-0387-80 ")
 ;;1617
 ;;21,"67544-0491-45 ")
 ;;1274
 ;;21,"67544-0491-53 ")
 ;;1275
 ;;21,"67544-0491-60 ")
 ;;1276
 ;;21,"67544-0491-80 ")
 ;;1277
 ;;21,"67544-0491-82 ")
 ;;1278
 ;;21,"67544-0491-99 ")
 ;;1279
 ;;21,"67544-0565-60 ")
 ;;514
 ;;21,"67544-0567-30 ")
 ;;1618
 ;;21,"67544-0567-60 ")
 ;;1619
 ;;21,"67544-0567-80 ")
 ;;1620
 ;;21,"67544-0573-82 ")
 ;;1312
 ;;21,"67544-0573-99 ")
 ;;1313
 ;;21,"67544-0627-53 ")
 ;;1576
 ;;21,"67544-0627-60 ")
 ;;1567
 ;;21,"67544-0627-80 ")
 ;;1568
 ;;21,"67544-0911-30 ")
 ;;1848
 ;;21,"67544-0911-45 ")
 ;;1849
 ;;21,"67544-0911-53 ")
 ;;1850
 ;;21,"67544-0911-60 ")
 ;;1851
 ;;21,"67544-0911-70 ")
 ;;1852
 ;;21,"67544-0911-73 ")
 ;;1853
 ;;21,"67544-0911-80 ")
 ;;1854
 ;;21,"67544-0911-92 ")
 ;;1855
 ;;21,"67544-0911-94 ")
 ;;1856
 ;;21,"67544-0911-98 ")
 ;;1857
 ;;21,"67544-0929-60 ")
 ;;2361
 ;;21,"67544-1055-30 ")
 ;;175
 ;;21,"67544-1123-53 ")
 ;;956
 ;;21,"67544-1135-30 ")
 ;;957
 ;;21,"67544-1135-53 ")
 ;;958
 ;;21,"67544-1135-60 ")
 ;;959
 ;;21,"67544-1143-53 ")
 ;;1101
 ;;21,"67544-1143-60 ")
 ;;1102
 ;;21,"67544-1143-80 ")
 ;;1103
 ;;21,"67544-1145-53 ")
 ;;1024
 ;;21,"67544-1145-60 ")
 ;;1025
 ;;21,"67544-1146-30 ")
 ;;877
 ;;21,"67544-1146-60 ")
 ;;878
 ;;21,"67544-1159-30 ")
 ;;960
 ;;21,"67544-1159-53 ")
 ;;961
 ;;21,"67544-1159-60 ")
 ;;962
 ;;21,"67544-1159-80 ")
 ;;963
 ;;21,"67544-1160-82 ")
 ;;1280
 ;;21,"67544-1182-53 ")
 ;;1104
 ;;21,"67544-1182-80 ")
 ;;1105
 ;;21,"67544-1187-30 ")
 ;;879
 ;;21,"67544-1187-53 ")
 ;;880
 ;;21,"67544-1187-60 ")
 ;;881
 ;;21,"67544-1199-99 ")
 ;;1314
 ;;21,"67544-1200-30 ")
 ;;1363
 ;;21,"67544-1200-42 ")
 ;;1364
 ;;21,"67544-1200-45 ")
 ;;1365
 ;;21,"67857-0700-01 ")
 ;;245
 ;;21,"67857-0701-01 ")
 ;;253
 ;;21,"68084-0209-01 ")
 ;;2060
 ;;21,"68084-0209-11 ")
 ;;2061
 ;;21,"68084-0210-01 ")
 ;;2091
 ;;21,"68084-0210-11 ")
 ;;2092
 ;;21,"68084-0211-01 ")
 ;;2013
 ;;21,"68084-0211-11 ")
 ;;2014
 ;;21,"68084-0212-01 ")
 ;;2034
 ;;21,"68084-0212-11 ")
 ;;2035
 ;;21,"68084-0261-01 ")
 ;;1026
 ;;21,"68084-0261-11 ")
 ;;1027
 ;;21,"68084-0262-01 ")
 ;;1106
 ;;21,"68084-0262-11 ")
 ;;1107
 ;;21,"68084-0263-01 ")
 ;;882
 ;;21,"68084-0263-11 ")
 ;;883
 ;;21,"68084-0264-01 ")
 ;;964
 ;;21,"68084-0264-11 ")
 ;;965
 ;;21,"68084-0301-01 ")
 ;;1281
 ;;21,"68084-0301-11 ")
 ;;1282
 ;;21,"68084-0302-11 ")
 ;;1315
 ;;21,"68084-0302-21 ")
 ;;1316
 ;;21,"68084-0303-01 ")
 ;;1355
 ;;21,"68084-0303-11 ")
 ;;1356
 ;;21,"68084-0304-01 ")
 ;;1423
 ;;21,"68084-0304-11 ")
 ;;1424
 ;;21,"68084-0456-01 ")
 ;;1209
 ;;21,"68084-0456-11 ")
 ;;1210
 ;;21,"68084-0457-01 ")
 ;;1234
 ;;21,"68084-0457-11 ")
 ;;1235
 ;;21,"68115-0038-30 ")
 ;;273
 ;;21,"68115-0039-30 ")
 ;;402
 ;;21,"68115-0039-60 ")
 ;;403
 ;;21,"68115-0039-90 ")
 ;;404
 ;;21,"68115-0040-15 ")
 ;;557
 ;;21,"68115-0040-30 ")
 ;;558
 ;;21,"68115-0040-60 ")
 ;;559
 ;;21,"68115-0040-90 ")
 ;;560
 ;;21,"68115-0238-00 ")
 ;;1444
 ;;21,"68115-0238-30 ")
 ;;1445
 ;;21,"68115-0238-60 ")
 ;;1446
 ;;21,"68115-0238-90 ")
 ;;1447
 ;;21,"68115-0239-30 ")
 ;;1658
 ;;21,"68115-0239-60 ")
 ;;1659
 ;;21,"68115-0239-90 ")
 ;;1660
 ;;21,"68115-0239-97 ")
 ;;1661
 ;;21,"68115-0307-30 ")
 ;;2138
 ;;21,"68115-0307-60 ")
 ;;2139
 ;;21,"68115-0308-60 ")
 ;;2223
 ;;21,"68115-0308-99 ")
 ;;2224
 ;;21,"68115-0309-30 ")
 ;;2308
 ;;21,"68115-0309-60 ")
 ;;2309
 ;;21,"68115-0309-90 ")
 ;;2310
 ;;21,"68115-0310-30 ")
 ;;2400
 ;;21,"68115-0310-60 ")
 ;;2401
 ;;21,"68115-0419-30 ")
 ;;1318
 ;;21,"68115-0458-30 ")
 ;;31
 ;;21,"68115-0551-00 ")
 ;;1040
 ;;21,"68115-0629-00 ")
 ;;2373
 ;;21,"68115-0629-30 ")
 ;;2374
 ;;21,"68115-0715-00 ")
 ;;1288
 ;;21,"68115-0727-00 ")
 ;;893
 ;;21,"68115-0727-30 ")
 ;;894
 ;;21,"68115-0741-00 ")
 ;;1319
 ;;21,"68258-1005-01 ")
 ;;565
 ;;21,"68258-1075-01 ")
 ;;275
 ;;21,"68258-1078-01 ")
 ;;407
 ;;21,"68258-1082-01 ")
 ;;1667
 ;;21,"68258-1083-01 ")
 ;;1452
 ;;21,"68258-6010-01 ")
 ;;2285
 ;;21,"68258-6011-09 ")
 ;;2355
 ;;21,"68258-6015-03 ")
 ;;1036
 ;;21,"68258-9004-01 ")
 ;;819
 ;;21,"68258-9005-01 ")
 ;;896
 ;;21,"68258-9006-01 ")
 ;;979
 ;;21,"68258-9007-01 ")
 ;;1041
 ;;21,"68258-9023-01 ")
 ;;739
 ;;21,"68258-9037-01 ")
 ;;730
 ;;21,"68258-9150-01 ")
 ;;1578
