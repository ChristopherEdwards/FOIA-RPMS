BGP50M4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON AUG 06, 2014;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"54868-5200-01 ")
 ;;1992
 ;;21,"54868-5209-00 ")
 ;;1979
 ;;21,"54868-5209-01 ")
 ;;1980
 ;;21,"54868-5250-00 ")
 ;;1845
 ;;21,"54868-5259-00 ")
 ;;1882
 ;;21,"54868-5259-01 ")
 ;;1883
 ;;21,"54868-5341-00 ")
 ;;708
 ;;21,"54868-5341-01 ")
 ;;709
 ;;21,"54868-5358-00 ")
 ;;701
 ;;21,"54868-5420-00 ")
 ;;1956
 ;;21,"54868-5523-00 ")
 ;;2002
 ;;21,"54868-5523-01 ")
 ;;2003
 ;;21,"54868-5567-00 ")
 ;;1966
 ;;21,"54868-5576-00 ")
 ;;823
 ;;21,"54868-5576-01 ")
 ;;824
 ;;21,"54868-5577-00 ")
 ;;898
 ;;21,"54868-5577-01 ")
 ;;899
 ;;21,"54868-5578-00 ")
 ;;994
 ;;21,"54868-5578-01 ")
 ;;995
 ;;21,"54868-5578-02 ")
 ;;996
 ;;21,"54868-5579-00 ")
 ;;1055
 ;;21,"54868-5579-01 ")
 ;;1056
 ;;21,"54868-5627-00 ")
 ;;1182
 ;;21,"54868-5627-01 ")
 ;;1183
 ;;21,"54868-5628-00 ")
 ;;1349
 ;;21,"54868-5628-01 ")
 ;;1350
 ;;21,"54868-5628-02 ")
 ;;1351
 ;;21,"54868-5629-00 ")
 ;;1505
 ;;21,"54868-5629-01 ")
 ;;1506
 ;;21,"54868-5629-02 ")
 ;;1507
 ;;21,"54868-5629-03 ")
 ;;1508
 ;;21,"54868-5629-04 ")
 ;;1509
 ;;21,"54868-5630-00 ")
 ;;1676
 ;;21,"54868-5630-01 ")
 ;;1677
 ;;21,"54868-5653-00 ")
 ;;1812
 ;;21,"54868-5653-01 ")
 ;;1813
 ;;21,"54868-5672-00 ")
 ;;1905
 ;;21,"54868-5699-00 ")
 ;;1912
 ;;21,"54868-5886-00 ")
 ;;1816
 ;;21,"54868-5886-01 ")
 ;;1817
 ;;21,"54868-5904-00 ")
 ;;1822
 ;;21,"54868-5904-01 ")
 ;;1823
 ;;21,"54868-5907-00 ")
 ;;1820
 ;;21,"54868-5907-01 ")
 ;;1821
 ;;21,"54868-6066-00 ")
 ;;1137
 ;;21,"54868-6169-00 ")
 ;;1827
 ;;21,"54868-6319-00 ")
 ;;28
 ;;21,"54868-6320-00 ")
 ;;120
 ;;21,"54868-6321-00 ")
 ;;208
 ;;21,"54868-6322-00 ")
 ;;308
 ;;21,"54868-6335-00 ")
 ;;1995
 ;;21,"55045-3014-08 ")
 ;;527
 ;;21,"55045-3015-08 ")
 ;;629
 ;;21,"55045-3655-08 ")
 ;;1181
 ;;21,"55048-0031-30 ")
 ;;29
 ;;21,"55048-0032-30 ")
 ;;119
 ;;21,"55048-0033-30 ")
 ;;209
 ;;21,"55048-0033-90 ")
 ;;210
 ;;21,"55048-0034-30 ")
 ;;307
 ;;21,"55048-0095-30 ")
 ;;710
 ;;21,"55048-0096-30 ")
 ;;736
 ;;21,"55048-0097-30 ")
 ;;762
 ;;21,"55048-0394-30 ")
 ;;627
 ;;21,"55048-0394-90 ")
 ;;628
 ;;21,"55048-0395-30 ")
 ;;528
 ;;21,"55048-0449-30 ")
 ;;626
 ;;21,"55048-0470-30 ")
 ;;529
 ;;21,"55048-0596-30 ")
 ;;993
 ;;21,"55048-0597-30 ")
 ;;900
 ;;21,"55048-0598-30 ")
 ;;1057
 ;;21,"55048-0647-30 ")
 ;;889
 ;;21,"55048-0648-30 ")
 ;;974
 ;;21,"55048-0774-30 ")
 ;;1491
 ;;21,"55048-0774-90 ")
 ;;1492
 ;;21,"55048-0775-30 ")
 ;;1337
 ;;21,"55048-0775-90 ")
 ;;1338
 ;;21,"55048-0776-30 ")
 ;;1665
 ;;21,"55048-0776-90 ")
 ;;1666
 ;;21,"55048-0821-30 ")
 ;;1852
 ;;21,"55048-0822-30 ")
 ;;1876
 ;;21,"55048-0823-30 ")
 ;;1884
 ;;21,"55048-0864-30 ")
 ;;1328
 ;;21,"55048-0865-30 ")
 ;;1487
 ;;21,"55048-0866-30 ")
 ;;1488
 ;;21,"55111-0121-05 ")
 ;;30
 ;;21,"55111-0121-90 ")
 ;;31
 ;;21,"55111-0122-05 ")
 ;;121
 ;;21,"55111-0122-90 ")
 ;;122
 ;;21,"55111-0123-05 ")
 ;;211
 ;;21,"55111-0123-90 ")
 ;;212
 ;;21,"55111-0124-05 ")
 ;;309
 ;;21,"55111-0124-90 ")
 ;;310
 ;;21,"55111-0197-05 ")
 ;;1126
 ;;21,"55111-0197-30 ")
 ;;1127
 ;;21,"55111-0197-90 ")
 ;;1128
 ;;21,"55111-0198-05 ")
 ;;1171
 ;;21,"55111-0198-30 ")
 ;;1172
 ;;21,"55111-0198-90 ")
 ;;1173
 ;;21,"55111-0199-05 ")
 ;;1333
 ;;21,"55111-0199-10 ")
 ;;1334
 ;;21,"55111-0199-30 ")
 ;;1335
 ;;21,"55111-0199-90 ")
 ;;1336
 ;;21,"55111-0200-05 ")
 ;;1493
 ;;21,"55111-0200-10 ")
 ;;1494
 ;;21,"55111-0200-30 ")
 ;;1495
 ;;21,"55111-0200-90 ")
 ;;1496
 ;;21,"55111-0229-05 ")
 ;;819
 ;;21,"55111-0229-90 ")
 ;;820
 ;;21,"55111-0230-05 ")
 ;;887
 ;;21,"55111-0230-90 ")
 ;;888
 ;;21,"55111-0231-05 ")
 ;;975
 ;;21,"55111-0231-90 ")
 ;;976
 ;;21,"55111-0268-05 ")
 ;;1667
 ;;21,"55111-0268-30 ")
 ;;1668
 ;;21,"55111-0268-90 ")
 ;;1669
 ;;21,"55111-0274-05 ")
 ;;1068
 ;;21,"55111-0274-90 ")
 ;;1069
 ;;21,"55111-0735-10 ")
 ;;1165
 ;;21,"55111-0735-30 ")
 ;;1166
 ;;21,"55111-0735-90 ")
 ;;1167
 ;;21,"55111-0740-10 ")
 ;;1302
 ;;21,"55111-0740-30 ")
 ;;1303
 ;;21,"55111-0740-90 ")
 ;;1304
 ;;21,"55111-0749-10 ")
 ;;1484
 ;;21,"55111-0749-30 ")
 ;;1485
 ;;21,"55111-0749-90 ")
 ;;1486
 ;;21,"55111-0750-10 ")
 ;;1662
 ;;21,"55111-0750-30 ")
 ;;1663
 ;;21,"55111-0750-90 ")
 ;;1664
 ;;21,"55289-0280-30 ")
 ;;1875
 ;;21,"55289-0293-14 ")
 ;;1329
 ;;21,"55289-0293-30 ")
 ;;1330
 ;;21,"55289-0293-90 ")
 ;;1331
 ;;21,"55289-0338-14 ")
 ;;1168
 ;;21,"55289-0338-30 ")
 ;;1169
 ;;21,"55289-0338-90 ")
 ;;1170
 ;;21,"55289-0395-30 ")
 ;;1489
 ;;21,"55289-0395-90 ")
 ;;1490
 ;;21,"55289-0400-30 ")
 ;;590
 ;;21,"55289-0520-30 ")
 ;;1885
 ;;21,"55289-0548-30 ")
 ;;694
 ;;21,"55289-0692-14 ")
 ;;630
 ;;21,"55289-0692-30 ")
 ;;631
 ;;21,"55289-0800-30 ")
 ;;172
 ;;21,"55289-0861-30 ")
 ;;274
 ;;21,"55289-0870-30 ")
 ;;81
 ;;21,"55289-0871-30 ")
 ;;858
 ;;21,"55289-0873-30 ")
 ;;955
 ;;21,"55289-0874-30 ")
 ;;1661
 ;;21,"55289-0881-30 ")
 ;;508
 ;;21,"55289-0932-30 ")
 ;;756
 ;;21,"55289-0935-30 ")
 ;;741
 ;;21,"55289-0980-21 ")
 ;;1853
 ;;21,"55700-0021-90 ")
 ;;1332
 ;;21,"55700-0034-30 ")
 ;;311
 ;;21,"58016-0006-00 ")
 ;;1497
 ;;21,"58016-0006-30 ")
 ;;1498
 ;;21,"58016-0006-60 ")
 ;;1499
 ;;21,"58016-0006-90 ")
 ;;1500
 ;;21,"58016-0007-00 ")
 ;;1339
 ;;21,"58016-0007-30 ")
 ;;1340
 ;;21,"58016-0007-60 ")
 ;;1341
 ;;21,"58016-0007-90 ")
 ;;1342
 ;;21,"58016-0008-00 ")
 ;;1174
 ;;21,"58016-0008-30 ")
 ;;1175
 ;;21,"58016-0008-60 ")
 ;;1176
 ;;21,"58016-0008-90 ")
 ;;1177
 ;;21,"58016-0012-00 ")
 ;;977
 ;;21,"58016-0012-30 ")
 ;;978
 ;;21,"58016-0012-60 ")
 ;;979
 ;;21,"58016-0012-90 ")
 ;;980
 ;;21,"58016-0013-00 ")
 ;;883
 ;;21,"58016-0013-30 ")
 ;;884
 ;;21,"58016-0013-60 ")
 ;;885
 ;;21,"58016-0013-90 ")
 ;;886
 ;;21,"58016-0037-00 ")
 ;;742
 ;;21,"58016-0037-30 ")
 ;;743
 ;;21,"58016-0037-60 ")
 ;;744
 ;;21,"58016-0037-90 ")
 ;;745
 ;;21,"58016-0051-00 ")
 ;;360
 ;;21,"58016-0051-30 ")
 ;;361
 ;;21,"58016-0051-60 ")
 ;;362
 ;;21,"58016-0051-90 ")
 ;;363
 ;;21,"58016-0052-00 ")
 ;;752
 ;;21,"58016-0052-30 ")
 ;;753
 ;;21,"58016-0052-60 ")
 ;;754
 ;;21,"58016-0052-90 ")
 ;;755
 ;;21,"58016-0071-00 ")
 ;;794
 ;;21,"58016-0071-30 ")
 ;;795
 ;;21,"58016-0071-60 ")
 ;;796
 ;;21,"58016-0071-90 ")
 ;;797
 ;;21,"58016-0364-00 ")
 ;;1298
 ;;21,"58016-0364-30 ")
 ;;1299
 ;;21,"58016-0364-60 ")
 ;;1300
 ;;21,"58016-0364-90 ")
 ;;1301
 ;;21,"58016-0365-00 ")
 ;;1657
 ;;21,"58016-0365-30 ")
 ;;1658
 ;;21,"58016-0365-60 ")
 ;;1659
 ;;21,"58016-0365-90 ")
 ;;1660
 ;;21,"58016-0385-00 ")
 ;;1473
 ;;21,"58016-0385-30 ")
 ;;1474
 ;;21,"58016-0385-60 ")
 ;;1475
 ;;21,"58016-0385-90 ")
 ;;1476
 ;;21,"58016-0425-00 ")
 ;;859
 ;;21,"58016-0425-30 ")
 ;;860
 ;;21,"58016-0425-60 ")
 ;;861
 ;;21,"58016-0425-90 ")
 ;;862
 ;;21,"58016-0900-00 ")
 ;;503
 ;;21,"58016-0900-02 ")
 ;;504
 ;;21,"58016-0900-30 ")
 ;;505
 ;;21,"58016-0900-60 ")
 ;;506
 ;;21,"58016-0900-90 ")
 ;;507
 ;;21,"58016-0922-00 ")
 ;;632
 ;;21,"58016-0922-02 ")
 ;;633
 ;;21,"58016-0922-30 ")
 ;;634
 ;;21,"58016-0922-60 ")
 ;;635
 ;;21,"58016-0922-90 ")
 ;;636
 ;;21,"58016-0979-00 ")
 ;;464
 ;;21,"58016-0979-02 ")
 ;;465
 ;;21,"58016-0979-20 ")
 ;;466
 ;;21,"58016-0979-30 ")
 ;;467
 ;;21,"58016-0979-60 ")
 ;;468
 ;;21,"58016-0979-90 ")
 ;;469
 ;;21,"58118-0005-03 ")
 ;;1343
 ;;21,"58118-0005-09 ")
 ;;1344
 ;;21,"58118-0007-08 ")
 ;;1670
 ;;21,"58118-0007-09 ")
 ;;1671
 ;;21,"58118-0168-03 ")
 ;;817
 ;;21,"58118-0168-06 ")
 ;;818
 ;;21,"58118-0169-03 ")
 ;;890
 ;;21,"58118-0469-03 ")
 ;;640
 ;;21,"58118-0478-03 ")
 ;;1178
 ;;21,"58118-1170-03 ")
 ;;981
 ;;21,"58118-1170-09 ")
 ;;982
 ;;21,"58118-1323-03 ")
 ;;1066
 ;;21,"58118-1323-09 ")
 ;;1067
 ;;21,"58517-0001-30 ")
 ;;218
 ;;21,"58864-0608-30 ")
 ;;80
 ;;21,"58864-0623-15 ")
 ;;272
 ;;21,"58864-0623-30 ")
 ;;273
 ;;21,"58864-0682-30 ")
 ;;1656
 ;;21,"58864-0685-30 ")
 ;;171
 ;;21,"58864-0739-30 ")
 ;;1159
 ;;21,"58864-0743-15 ")
 ;;953
 ;;21,"58864-0743-30 ")
 ;;954
 ;;21,"58864-0760-30 ")
 ;;1472
 ;;21,"58864-0780-30 ")
 ;;501
 ;;21,"58864-0780-60 ")
 ;;502
 ;;21,"58864-0781-30 ")
 ;;470
 ;;21,"58864-0834-30 ")
 ;;359
 ;;21,"59630-0628-30 ")
 ;;698
 ;;21,"59630-0629-30 ")
 ;;699
 ;;21,"59630-0630-30 ")
 ;;700
 ;;21,"59762-0155-01 ")
 ;;32
 ;;21,"59762-0155-02 ")
 ;;33
 ;;21,"59762-0156-01 ")
 ;;123
 ;;21,"59762-0156-02 ")
 ;;124
 ;;21,"59762-0157-01 ")
 ;;213
 ;;21,"59762-0157-02 ")
 ;;214
 ;;21,"59762-0158-01 ")
 ;;312
 ;;21,"59762-0158-02 ")
 ;;313
 ;;21,"59762-6710-01 ")
 ;;1898
 ;;21,"59762-6711-01 ")
 ;;1900
 ;;21,"59762-6712-01 ")
 ;;1908
 ;;21,"59762-6720-01 ")
 ;;1914
 ;;21,"59762-6720-05 ")
 ;;1915
 ;;21,"59762-6721-01 ")
 ;;1929
 ;;21,"59762-6721-05 ")
 ;;1930
 ;;21,"59762-6722-01 ")
 ;;1941
 ;;21,"59762-6722-05 ")
 ;;1942
 ;;21,"59762-6723-01 ")
 ;;1952
 ;;21,"59762-6730-01 ")
 ;;1958
 ;;21,"59762-6730-05 ")
 ;;1959
 ;;21,"59762-6731-01 ")
 ;;1970
 ;;21,"59762-6731-05 ")
 ;;1971
 ;;21,"59762-6732-01 ")
 ;;1982
 ;;21,"59762-6732-05 ")
 ;;1983
 ;;21,"59762-6733-01 ")
 ;;1997
 ;;21,"60429-0248-10 ")
 ;;471
 ;;21,"60429-0248-60 ")
 ;;472
 ;;21,"60429-0249-10 ")
 ;;499
 ;;21,"60429-0249-60 ")
 ;;500
 ;;21,"60429-0250-10 ")
 ;;637
 ;;21,"60429-0250-60 ")
 ;;638
 ;;21,"60429-0250-90 ")
 ;;639
 ;;21,"60429-0323-01 ")
 ;;34
 ;;21,"60429-0323-10 ")
 ;;35
 ;;21,"60429-0323-90 ")
 ;;36
 ;;21,"60429-0324-01 ")
 ;;125
 ;;21,"60429-0324-10 ")
 ;;126
 ;;21,"60429-0324-90 ")
 ;;127
 ;;21,"60429-0325-01 ")
 ;;215
 ;;21,"60429-0325-05 ")
 ;;216
 ;;21,"60429-0325-90 ")
 ;;217
 ;;21,"60429-0326-01 ")
 ;;314
 ;;21,"60429-0326-05 ")
 ;;315
 ;;21,"60429-0326-90 ")
 ;;316
 ;;21,"60429-0367-05 ")
 ;;816
 ;;21,"60429-0367-45 ")
 ;;798
 ;;21,"60429-0367-90 ")
 ;;813
 ;;21,"60429-0368-05 ")
 ;;893
 ;;21,"60429-0368-45 ")
 ;;894
 ;;21,"60429-0368-90 ")
 ;;895
 ;;21,"60429-0369-05 ")
 ;;983
 ;;21,"60429-0369-45 ")
 ;;984
 ;;21,"60429-0369-90 ")
 ;;985
 ;;21,"60429-0370-05 ")
 ;;1063
 ;;21,"60429-0370-45 ")
 ;;1064
 ;;21,"60429-0370-90 ")
 ;;1065
 ;;21,"60505-0168-05 ")
 ;;814
 ;;21,"60505-0168-09 ")
 ;;815
 ;;21,"60505-0169-07 ")
 ;;891
 ;;21,"60505-0169-09 ")
 ;;892
 ;;21,"60505-0170-07 ")
 ;;986
 ;;21,"60505-0170-08 ")
 ;;987
 ;;21,"60505-0170-09 ")
 ;;988
 ;;21,"60505-0177-00 ")
 ;;473
 ;;21,"60505-0178-00 ")
 ;;494
 ;;21,"60505-0179-00 ")
 ;;643
 ;;21,"60505-1323-05 ")
 ;;1061
 ;;21,"60505-1323-09 ")
 ;;1062
 ;;21,"60505-2578-08 ")
 ;;37
 ;;21,"60505-2578-09 ")
 ;;38
 ;;21,"60505-2579-08 ")
 ;;132
 ;;21,"60505-2579-09 ")
 ;;133
 ;;21,"60505-2580-08 ")
 ;;222
 ;;21,"60505-2580-09 ")
 ;;223
 ;;21,"60505-2671-08 ")
 ;;319
 ;;21,"60505-2671-09 ")
 ;;320
 ;;21,"60760-0005-30 ")
 ;;1347
 ;;21,"60760-0005-90 ")
 ;;1348
 ;;21,"60760-0006-30 ")
 ;;1501
 ;;21,"60760-0006-90 ")
 ;;1502
 ;;21,"60760-0019-30 ")
 ;;1675
 ;;21,"60760-0077-30 ")
 ;;896
 ;;21,"60760-0077-90 ")
 ;;897
 ;;21,"60760-0078-30 ")
 ;;989
 ;;21,"60760-0078-90 ")
 ;;990
 ;;21,"60760-0355-30 ")
 ;;219
 ;;21,"60760-0370-30 ")
 ;;495
 ;;21,"60760-0371-30 ")
 ;;474
 ;;21,"61442-0141-01 ")
 ;;475
 ;;21,"61442-0141-10 ")
 ;;476
 ;;21,"61442-0141-60 ")
 ;;477
 ;;21,"61442-0142-01 ")
 ;;490
 ;;21,"61442-0142-05 ")
 ;;491
 ;;21,"61442-0142-10 ")
 ;;492
 ;;21,"61442-0142-60 ")
 ;;493
 ;;21,"61442-0143-01 ")
 ;;644
 ;;21,"61442-0143-05 ")
 ;;645
 ;;21,"61442-0143-10 ")
 ;;646
 ;;21,"61442-0143-60 ")
 ;;647
 ;;21,"62175-0890-43 ")
 ;;39
 ;;21,"62175-0890-46 ")
 ;;40
 ;;21,"62175-0891-43 ")
 ;;130
 ;;21,"62175-0891-46 ")
 ;;131
 ;;21,"62175-0892-41 ")
 ;;224
 ;;21,"62175-0892-46 ")
 ;;225
 ;;21,"62175-0897-41 ")
 ;;317
 ;;21,"62175-0897-46 ")
 ;;318
 ;;21,"63304-0499-30 ")
 ;;1951
 ;;21,"63304-0500-30 ")
 ;;1984
 ;;21,"63304-0501-30 ")
 ;;1897
 ;;21,"63304-0502-30 ")
 ;;1901
 ;;21,"63304-0503-30 ")
 ;;1907
 ;;21,"63304-0587-30 ")
 ;;1916
 ;;21,"63304-0588-30 ")
 ;;1928
 ;;21,"63304-0589-30 ")
 ;;1943
 ;;21,"63304-0590-30 ")
 ;;1960
 ;;21,"63304-0591-30 ")
 ;;1969
 ;;21,"63304-0603-30 ")
 ;;1996
 ;;21,"63304-0789-10 ")
 ;;1129
 ;;21,"63304-0789-90 ")
 ;;1130
 ;;21,"63304-0790-10 ")
 ;;1179
 ;;21,"63304-0790-90 ")
 ;;1180
 ;;21,"63304-0791-10 ")
 ;;1345
 ;;21,"63304-0791-90 ")
 ;;1346
 ;;21,"63304-0792-10 ")
 ;;1503
 ;;21,"63304-0792-90 ")
 ;;1504
 ;;21,"63304-0793-10 ")
 ;;1672
 ;;21,"63304-0793-50 ")
 ;;1673
 ;;21,"63304-0793-90 ")
 ;;1674
 ;;21,"63304-0827-05 ")
 ;;41
 ;;21,"63304-0827-90 ")
 ;;42
 ;;21,"63304-0828-05 ")
 ;;128
 ;;21,"63304-0828-90 ")
 ;;129
 ;;21,"63304-0829-05 ")
 ;;220
 ;;21,"63304-0829-90 ")
 ;;221
 ;;21,"63304-0830-05 ")
 ;;321
 ;;21,"63304-0830-90 ")
 ;;322
 ;;21,"63629-1447-01 ")
 ;;170
 ;;21,"63629-1464-01 ")
 ;;496