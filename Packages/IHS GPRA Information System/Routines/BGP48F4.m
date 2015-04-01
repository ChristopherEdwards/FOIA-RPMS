BGP48F4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54569-5834-00 ")
 ;;1680
 ;;21,"54569-5834-01 ")
 ;;1681
 ;;21,"54569-5834-02 ")
 ;;1682
 ;;21,"54569-5834-03 ")
 ;;1683
 ;;21,"54569-5834-04 ")
 ;;1684
 ;;21,"54569-5881-00 ")
 ;;2153
 ;;21,"54569-5951-00 ")
 ;;2162
 ;;21,"54569-6054-01 ")
 ;;877
 ;;21,"54569-6099-00 ")
 ;;2167
 ;;21,"54569-6113-00 ")
 ;;1851
 ;;21,"54569-6113-01 ")
 ;;1852
 ;;21,"54569-6282-00 ")
 ;;48
 ;;21,"54569-6282-01 ")
 ;;49
 ;;21,"54569-6283-00 ")
 ;;144
 ;;21,"54569-6283-01 ")
 ;;145
 ;;21,"54569-6284-00 ")
 ;;239
 ;;21,"54569-6284-01 ")
 ;;240
 ;;21,"54569-6285-00 ")
 ;;352
 ;;21,"54569-6285-01 ")
 ;;353
 ;;21,"54569-6302-00 ")
 ;;1421
 ;;21,"54569-6302-01 ")
 ;;1422
 ;;21,"54569-6428-00 ")
 ;;899
 ;;21,"54569-6428-01 ")
 ;;900
 ;;21,"54569-6450-00 ")
 ;;1241
 ;;21,"54868-0686-01 ")
 ;;629
 ;;21,"54868-0686-02 ")
 ;;630
 ;;21,"54868-0686-03 ")
 ;;631
 ;;21,"54868-0686-04 ")
 ;;632
 ;;21,"54868-1087-00 ")
 ;;769
 ;;21,"54868-1087-01 ")
 ;;770
 ;;21,"54868-1207-00 ")
 ;;2133
 ;;21,"54868-1207-01 ")
 ;;2134
 ;;21,"54868-1890-00 ")
 ;;863
 ;;21,"54868-1890-01 ")
 ;;864
 ;;21,"54868-1968-00 ")
 ;;510
 ;;21,"54868-2288-00 ")
 ;;973
 ;;21,"54868-2288-01 ")
 ;;974
 ;;21,"54868-2288-02 ")
 ;;975
 ;;21,"54868-2639-00 ")
 ;;1434
 ;;21,"54868-2639-01 ")
 ;;1435
 ;;21,"54868-3104-00 ")
 ;;1649
 ;;21,"54868-3104-01 ")
 ;;1650
 ;;21,"54868-3270-00 ")
 ;;1062
 ;;21,"54868-3270-01 ")
 ;;1063
 ;;21,"54868-3270-02 ")
 ;;1064
 ;;21,"54868-3287-00 ")
 ;;2126
 ;;21,"54868-3287-01 ")
 ;;2127
 ;;21,"54868-3329-00 ")
 ;;406
 ;;21,"54868-3934-00 ")
 ;;71
 ;;21,"54868-3934-01 ")
 ;;72
 ;;21,"54868-3934-02 ")
 ;;73
 ;;21,"54868-3934-03 ")
 ;;74
 ;;21,"54868-3934-04 ")
 ;;75
 ;;21,"54868-3946-00 ")
 ;;171
 ;;21,"54868-3946-01 ")
 ;;172
 ;;21,"54868-3946-02 ")
 ;;173
 ;;21,"54868-3946-03 ")
 ;;174
 ;;21,"54868-3946-04 ")
 ;;175
 ;;21,"54868-4157-00 ")
 ;;1819
 ;;21,"54868-4157-01 ")
 ;;1820
 ;;21,"54868-4157-02 ")
 ;;1821
 ;;21,"54868-4181-00 ")
 ;;1990
 ;;21,"54868-4181-01 ")
 ;;1991
 ;;21,"54868-4224-00 ")
 ;;415
 ;;21,"54868-4224-01 ")
 ;;416
 ;;21,"54868-4229-00 ")
 ;;279
 ;;21,"54868-4229-01 ")
 ;;280
 ;;21,"54868-4229-02 ")
 ;;281
 ;;21,"54868-4229-03 ")
 ;;282
 ;;21,"54868-4585-00 ")
 ;;598
 ;;21,"54868-4585-01 ")
 ;;599
 ;;21,"54868-4585-02 ")
 ;;600
 ;;21,"54868-4585-03 ")
 ;;601
 ;;21,"54868-4593-00 ")
 ;;439
 ;;21,"54868-4593-01 ")
 ;;440
 ;;21,"54868-4593-02 ")
 ;;441
 ;;21,"54868-4601-00 ")
 ;;423
 ;;21,"54868-4634-00 ")
 ;;1176
 ;;21,"54868-4774-00 ")
 ;;662
 ;;21,"54868-4774-01 ")
 ;;663
 ;;21,"54868-4774-02 ")
 ;;664
 ;;21,"54868-4774-03 ")
 ;;665
 ;;21,"54868-4807-00 ")
 ;;2010
 ;;21,"54868-4807-01 ")
 ;;2011
 ;;21,"54868-4807-02 ")
 ;;2012
 ;;21,"54868-4934-00 ")
 ;;358
 ;;21,"54868-4934-01 ")
 ;;359
 ;;21,"54868-4934-02 ")
 ;;360
 ;;21,"54868-4934-03 ")
 ;;361
 ;;21,"54868-4963-00 ")
 ;;801
 ;;21,"54868-4963-01 ")
 ;;802
 ;;21,"54868-4963-02 ")
 ;;803
 ;;21,"54868-4963-03 ")
 ;;804
 ;;21,"54868-5085-00 ")
 ;;848
 ;;21,"54868-5085-01 ")
 ;;849
 ;;21,"54868-5085-02 ")
 ;;850
 ;;21,"54868-5085-03 ")
 ;;851
 ;;21,"54868-5085-04 ")
 ;;852
 ;;21,"54868-5087-00 ")
 ;;2017
 ;;21,"54868-5179-00 ")
 ;;2139
 ;;21,"54868-5187-00 ")
 ;;2063
 ;;21,"54868-5187-01 ")
 ;;2064
 ;;21,"54868-5187-02 ")
 ;;2065
 ;;21,"54868-5189-00 ")
 ;;2079
 ;;21,"54868-5189-01 ")
 ;;2080
 ;;21,"54868-5200-00 ")
 ;;2169
 ;;21,"54868-5200-01 ")
 ;;2170
 ;;21,"54868-5209-00 ")
 ;;2160
 ;;21,"54868-5209-01 ")
 ;;2161
 ;;21,"54868-5250-00 ")
 ;;2049
 ;;21,"54868-5259-00 ")
 ;;2095
 ;;21,"54868-5259-01 ")
 ;;2096
 ;;21,"54868-5341-00 ")
 ;;797
 ;;21,"54868-5341-01 ")
 ;;798
 ;;21,"54868-5358-00 ")
 ;;782
 ;;21,"54868-5420-00 ")
 ;;2144
 ;;21,"54868-5523-00 ")
 ;;2176
 ;;21,"54868-5523-01 ")
 ;;2177
 ;;21,"54868-5567-00 ")
 ;;2152
 ;;21,"54868-5576-00 ")
 ;;949
 ;;21,"54868-5576-01 ")
 ;;950
 ;;21,"54868-5577-00 ")
 ;;1052
 ;;21,"54868-5577-01 ")
 ;;1053
 ;;21,"54868-5578-00 ")
 ;;1168
 ;;21,"54868-5578-01 ")
 ;;1169
 ;;21,"54868-5578-02 ")
 ;;1170
 ;;21,"54868-5579-00 ")
 ;;1210
 ;;21,"54868-5579-01 ")
 ;;1211
 ;;21,"54868-5627-00 ")
 ;;1313
 ;;21,"54868-5627-01 ")
 ;;1314
 ;;21,"54868-5628-00 ")
 ;;1458
 ;;21,"54868-5628-01 ")
 ;;1459
 ;;21,"54868-5628-02 ")
 ;;1460
 ;;21,"54868-5629-00 ")
 ;;1661
 ;;21,"54868-5629-01 ")
 ;;1662
 ;;21,"54868-5629-02 ")
 ;;1663
 ;;21,"54868-5629-03 ")
 ;;1664
 ;;21,"54868-5629-04 ")
 ;;1665
 ;;21,"54868-5630-00 ")
 ;;1857
 ;;21,"54868-5630-01 ")
 ;;1858
 ;;21,"54868-5653-00 ")
 ;;2020
 ;;21,"54868-5653-01 ")
 ;;2021
 ;;21,"54868-5672-00 ")
 ;;2111
 ;;21,"54868-5699-00 ")
 ;;2116
 ;;21,"54868-5886-00 ")
 ;;2024
 ;;21,"54868-5886-01 ")
 ;;2025
 ;;21,"54868-5904-00 ")
 ;;2030
 ;;21,"54868-5904-01 ")
 ;;2031
 ;;21,"54868-5907-00 ")
 ;;2028
 ;;21,"54868-5907-01 ")
 ;;2029
 ;;21,"54868-6066-00 ")
 ;;1244
 ;;21,"54868-6169-00 ")
 ;;2035
 ;;21,"54868-6319-00 ")
 ;;39
 ;;21,"54868-6320-00 ")
 ;;138
 ;;21,"54868-6321-00 ")
 ;;233
 ;;21,"54868-6322-00 ")
 ;;340
 ;;21,"54868-6335-00 ")
 ;;2174
 ;;21,"55045-3014-08 ")
 ;;602
 ;;21,"55045-3015-08 ")
 ;;666
 ;;21,"55045-3655-08 ")
 ;;1416
 ;;21,"55048-0031-30 ")
 ;;57
 ;;21,"55048-0032-30 ")
 ;;158
 ;;21,"55048-0033-30 ")
 ;;257
 ;;21,"55048-0033-90 ")
 ;;258
 ;;21,"55048-0034-30 ")
 ;;356
 ;;21,"55048-0095-30 ")
 ;;791
 ;;21,"55048-0096-30 ")
 ;;829
 ;;21,"55048-0097-30 ")
 ;;838
 ;;21,"55048-0394-30 ")
 ;;713
 ;;21,"55048-0394-90 ")
 ;;714
 ;;21,"55048-0395-30 ")
 ;;536
 ;;21,"55048-0449-30 ")
 ;;704
 ;;21,"55048-0470-30 ")
 ;;537
 ;;21,"55048-0596-30 ")
 ;;1088
 ;;21,"55048-0597-30 ")
 ;;991
 ;;21,"55048-0598-30 ")
 ;;1203
 ;;21,"55048-0647-30 ")
 ;;992
 ;;21,"55048-0648-30 ")
 ;;1086
 ;;21,"55048-0774-30 ")
 ;;1796
 ;;21,"55048-0774-90 ")
 ;;1797
 ;;21,"55048-0775-30 ")
 ;;1600
 ;;21,"55048-0775-90 ")
 ;;1601
 ;;21,"55048-0776-30 ")
 ;;1968
 ;;21,"55048-0776-90 ")
 ;;1969
 ;;21,"55048-0821-30 ")
 ;;2054
 ;;21,"55048-0822-30 ")
 ;;2089
 ;;21,"55048-0823-30 ")
 ;;2091
 ;;21,"55048-0864-30 ")
 ;;1466
 ;;21,"55048-0865-30 ")
 ;;1656
 ;;21,"55048-0866-30 ")
 ;;1657
 ;;21,"55111-0121-05 ")
 ;;44
 ;;21,"55111-0121-90 ")
 ;;45
 ;;21,"55111-0122-05 ")
 ;;156
 ;;21,"55111-0122-90 ")
 ;;157
 ;;21,"55111-0123-05 ")
 ;;253
 ;;21,"55111-0123-90 ")
 ;;254
 ;;21,"55111-0124-05 ")
 ;;342
 ;;21,"55111-0124-90 ")
 ;;343
 ;;21,"55111-0197-05 ")
 ;;1233
 ;;21,"55111-0197-30 ")
 ;;1234
 ;;21,"55111-0197-90 ")
 ;;1235
 ;;21,"55111-0198-05 ")
 ;;1310
 ;;21,"55111-0198-30 ")
 ;;1311
 ;;21,"55111-0198-90 ")
 ;;1312
 ;;21,"55111-0199-05 ")
 ;;1461
 ;;21,"55111-0199-10 ")
 ;;1462
 ;;21,"55111-0199-30 ")
 ;;1463
 ;;21,"55111-0199-90 ")
 ;;1464
 ;;21,"55111-0200-05 ")
 ;;1658
 ;;21,"55111-0200-10 ")
 ;;1659
 ;;21,"55111-0200-30 ")
 ;;1660
 ;;21,"55111-0200-90 ")
 ;;1671
 ;;21,"55111-0229-05 ")
 ;;944
 ;;21,"55111-0229-90 ")
 ;;945
 ;;21,"55111-0230-05 ")
 ;;1057
 ;;21,"55111-0230-90 ")
 ;;1058
 ;;21,"55111-0231-05 ")
 ;;1171
 ;;21,"55111-0231-90 ")
 ;;1172
 ;;21,"55111-0268-05 ")
 ;;1853
 ;;21,"55111-0268-30 ")
 ;;1854
 ;;21,"55111-0268-90 ")
 ;;1855
 ;;21,"55111-0274-05 ")
 ;;1218
 ;;21,"55111-0274-90 ")
 ;;1219
 ;;21,"55111-0726-10 ")
 ;;1227
 ;;21,"55111-0726-30 ")
 ;;1228
 ;;21,"55111-0726-90 ")
 ;;1229
 ;;21,"55111-0735-10 ")
 ;;1318
 ;;21,"55111-0735-30 ")
 ;;1319
 ;;21,"55111-0735-90 ")
 ;;1320
 ;;21,"55111-0740-10 ")
 ;;1488
 ;;21,"55111-0740-30 ")
 ;;1489
 ;;21,"55111-0740-90 ")
 ;;1490
 ;;21,"55111-0749-10 ")
 ;;1677
 ;;21,"55111-0749-30 ")
 ;;1678
 ;;21,"55111-0749-90 ")
 ;;1679
 ;;21,"55111-0750-10 ")
 ;;1865
 ;;21,"55111-0750-30 ")
 ;;1866
 ;;21,"55111-0750-90 ")
 ;;1867
 ;;21,"55289-0104-30 ")
 ;;894
 ;;21,"55289-0280-30 ")
 ;;2084
 ;;21,"55289-0293-14 ")
 ;;1550
 ;;21,"55289-0293-30 ")
 ;;1551
 ;;21,"55289-0293-90 ")
 ;;1552
 ;;21,"55289-0338-14 ")
 ;;1405
 ;;21,"55289-0338-30 ")
 ;;1406
 ;;21,"55289-0338-90 ")
 ;;1407
 ;;21,"55289-0395-30 ")
 ;;1798
 ;;21,"55289-0395-90 ")
 ;;1799
 ;;21,"55289-0400-30 ")
 ;;633
 ;;21,"55289-0476-30 ")
 ;;419
 ;;21,"55289-0520-30 ")
 ;;2103
 ;;21,"55289-0548-30 ")
 ;;768
 ;;21,"55289-0692-14 ")
 ;;680
 ;;21,"55289-0692-30 ")
 ;;681
 ;;21,"55289-0740-60 ")
 ;;407
 ;;21,"55289-0800-30 ")
 ;;167
 ;;21,"55289-0861-30 ")
 ;;268
 ;;21,"55289-0870-30 ")
 ;;66
 ;;21,"55289-0871-30 ")
 ;;956
 ;;21,"55289-0873-30 ")
 ;;1065
 ;;21,"55289-0874-30 ")
 ;;1847
 ;;21,"55289-0881-30 ")
 ;;581
 ;;21,"55289-0932-30 ")
 ;;861
 ;;21,"55289-0935-30 ")
 ;;805
 ;;21,"55289-0980-21 ")
 ;;2072
 ;;21,"55700-0021-90 ")
 ;;1465
 ;;21,"55700-0034-30 ")
 ;;341
 ;;21,"55887-0192-90 ")
 ;;1087
 ;;21,"55887-0203-30 ")
 ;;983
 ;;21,"55887-0203-90 ")
 ;;984
 ;;21,"55887-0350-30 ")
 ;;474
 ;;21,"55887-0350-60 ")
 ;;475
 ;;21,"55887-0350-90 ")
 ;;476
 ;;21,"55887-0369-30 ")
 ;;705
 ;;21,"55887-0369-60 ")
 ;;706
 ;;21,"55887-0369-90 ")
 ;;707
 ;;21,"55887-0624-20 ")
 ;;81
 ;;21,"55887-0624-30 ")
 ;;82
 ;;21,"55887-0624-40 ")
 ;;83
 ;;21,"55887-0624-60 ")
 ;;84
 ;;21,"55887-0624-82 ")
 ;;85
 ;;21,"55887-0624-90 ")
 ;;86
 ;;21,"55887-0858-10 ")
 ;;1800
 ;;21,"55887-0858-30 ")
 ;;1801
 ;;21,"55887-0858-60 ")
 ;;1802
 ;;21,"55887-0858-90 ")
 ;;1803
 ;;21,"55887-0929-90 ")
 ;;265
 ;;21,"55887-0974-30 ")
 ;;570
 ;;21,"57866-3932-01 ")
 ;;1149
 ;;21,"57866-6400-01 ")
 ;;501
 ;;21,"57866-6500-01 ")
 ;;745
 ;;21,"57866-6601-01 ")
 ;;590
 ;;21,"57866-7982-01 ")
 ;;1626
 ;;21,"57866-7983-01 ")
 ;;1822
 ;;21,"57866-7986-01 ")
 ;;1429
 ;;21,"57866-8615-01 ")
 ;;79
 ;;21,"58016-0006-00 ")
 ;;1792
 ;;21,"58016-0006-30 ")
 ;;1793
 ;;21,"58016-0006-60 ")
 ;;1794
 ;;21,"58016-0006-90 ")
 ;;1795
 ;;21,"58016-0007-00 ")
 ;;1602
 ;;21,"58016-0007-30 ")
 ;;1603
 ;;21,"58016-0007-60 ")
 ;;1604
 ;;21,"58016-0007-90 ")
 ;;1605
 ;;21,"58016-0008-00 ")
 ;;1408
 ;;21,"58016-0008-30 ")
 ;;1409
 ;;21,"58016-0008-60 ")
 ;;1410
 ;;21,"58016-0008-90 ")
 ;;1411
 ;;21,"58016-0012-00 ")
 ;;1092
 ;;21,"58016-0012-30 ")
 ;;1093
 ;;21,"58016-0012-60 ")
 ;;1094
 ;;21,"58016-0012-90 ")
 ;;1095
 ;;21,"58016-0013-00 ")
 ;;987
 ;;21,"58016-0013-30 ")
 ;;988
 ;;21,"58016-0013-60 ")
 ;;989
 ;;21,"58016-0013-90 ")
 ;;990
 ;;21,"58016-0037-00 ")
 ;;806
 ;;21,"58016-0037-30 ")
 ;;807
 ;;21,"58016-0037-60 ")
 ;;808
 ;;21,"58016-0037-90 ")
 ;;809
 ;;21,"58016-0051-00 ")
 ;;362
 ;;21,"58016-0051-30 ")
 ;;363
 ;;21,"58016-0051-60 ")
 ;;364
 ;;21,"58016-0051-90 ")
 ;;365
 ;;21,"58016-0052-00 ")
 ;;834
 ;;21,"58016-0052-30 ")
 ;;835
 ;;21,"58016-0052-60 ")
 ;;836
 ;;21,"58016-0052-90 ")
 ;;837
 ;;21,"58016-0071-00 ")
 ;;878
 ;;21,"58016-0071-30 ")
 ;;879
 ;;21,"58016-0071-60 ")
 ;;880
 ;;21,"58016-0071-90 ")
 ;;881
 ;;21,"58016-0364-00 ")
 ;;1430
 ;;21,"58016-0364-30 ")
 ;;1431
 ;;21,"58016-0364-60 ")
 ;;1432
 ;;21,"58016-0364-90 ")
 ;;1433
 ;;21,"58016-0365-00 ")
 ;;1823
 ;;21,"58016-0365-30 ")
 ;;1824
 ;;21,"58016-0365-60 ")
 ;;1825
 ;;21,"58016-0365-90 ")
 ;;1826
 ;;21,"58016-0385-00 ")
 ;;1645
 ;;21,"58016-0385-30 ")
 ;;1646
 ;;21,"58016-0385-60 ")
 ;;1647
 ;;21,"58016-0385-90 ")
 ;;1648
 ;;21,"58016-0425-00 ")
 ;;952
 ;;21,"58016-0425-30 ")
 ;;953
 ;;21,"58016-0425-60 ")
 ;;954
 ;;21,"58016-0425-90 ")
 ;;955
 ;;21,"58016-0900-00 ")
 ;;613
 ;;21,"58016-0900-02 ")
 ;;614
 ;;21,"58016-0900-30 ")
 ;;615
 ;;21,"58016-0900-60 ")
 ;;616
 ;;21,"58016-0900-90 ")
 ;;617
 ;;21,"58016-0922-00 ")
 ;;656
 ;;21,"58016-0922-02 ")
 ;;657
 ;;21,"58016-0922-30 ")
 ;;658
 ;;21,"58016-0922-60 ")
 ;;659
 ;;21,"58016-0922-90 ")
 ;;660
 ;;21,"58016-0979-00 ")
 ;;444
 ;;21,"58016-0979-02 ")
 ;;445
 ;;21,"58016-0979-20 ")
 ;;446
 ;;21,"58016-0979-30 ")
 ;;447
 ;;21,"58016-0979-60 ")
 ;;448
 ;;21,"58016-0979-90 ")
 ;;449
 ;;21,"58118-0005-03 ")
 ;;1620
 ;;21,"58118-0005-09 ")
 ;;1621
 ;;21,"58118-0007-08 ")
 ;;1988
 ;;21,"58118-0007-09 ")
 ;;1989
 ;;21,"58118-0168-03 ")
 ;;895
 ;;21,"58118-0168-06 ")
 ;;896
 ;;21,"58118-0169-03 ")
 ;;980
 ;;21,"58118-0469-03 ")
 ;;661
 ;;21,"58118-0478-03 ")
 ;;1322
 ;;21,"58118-1170-03 ")
 ;;1158
 ;;21,"58118-1170-09 ")
 ;;1159
 ;;21,"58118-1323-03 ")
 ;;1220
 ;;21,"58118-1323-09 ")
 ;;1217
 ;;21,"58517-0001-30 ")
 ;;238
 ;;21,"58864-0608-30 ")
 ;;65
 ;;21,"58864-0623-15 ")
 ;;266
 ;;21,"58864-0623-30 ")
 ;;267
 ;;21,"58864-0653-30 ")
 ;;885
 ;;21,"58864-0682-30 ")
 ;;1846
 ;;21,"58864-0685-30 ")
 ;;165
 ;;21,"58864-0739-30 ")
 ;;1306
 ;;21,"58864-0743-15 ")
 ;;1059
 ;;21,"58864-0743-30 ")
 ;;1060
 ;;21,"58864-0760-30 ")
 ;;1653
 ;;21,"58864-0780-30 ")
 ;;596
 ;;21,"58864-0780-60 ")
 ;;597
 ;;21,"58864-0781-30 ")
 ;;452