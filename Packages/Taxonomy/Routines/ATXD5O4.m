ATXD5O4 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"V53.9XXA ")
 ;;1362
 ;;21,"V53.9XXD ")
 ;;1363
 ;;21,"V53.9XXS ")
 ;;1364
 ;;21,"V54.0XXA ")
 ;;1365
 ;;21,"V54.0XXD ")
 ;;1366
 ;;21,"V54.0XXS ")
 ;;1367
 ;;21,"V54.1XXA ")
 ;;1368
 ;;21,"V54.1XXD ")
 ;;1369
 ;;21,"V54.1XXS ")
 ;;1370
 ;;21,"V54.2XXA ")
 ;;1371
 ;;21,"V54.2XXD ")
 ;;1372
 ;;21,"V54.2XXS ")
 ;;1373
 ;;21,"V54.3XXA ")
 ;;1374
 ;;21,"V54.3XXD ")
 ;;1375
 ;;21,"V54.3XXS ")
 ;;1376
 ;;21,"V54.4XXA ")
 ;;1377
 ;;21,"V54.4XXD ")
 ;;1378
 ;;21,"V54.4XXS ")
 ;;1379
 ;;21,"V54.5XXA ")
 ;;1380
 ;;21,"V54.5XXD ")
 ;;1381
 ;;21,"V54.5XXS ")
 ;;1382
 ;;21,"V54.6XXA ")
 ;;1383
 ;;21,"V54.6XXD ")
 ;;1384
 ;;21,"V54.6XXS ")
 ;;1385
 ;;21,"V54.7XXA ")
 ;;1386
 ;;21,"V54.7XXD ")
 ;;1387
 ;;21,"V54.7XXS ")
 ;;1388
 ;;21,"V54.9XXA ")
 ;;1389
 ;;21,"V54.9XXD ")
 ;;1390
 ;;21,"V54.9XXS ")
 ;;1391
 ;;21,"V55.0XXA ")
 ;;1392
 ;;21,"V55.0XXD ")
 ;;1393
 ;;21,"V55.0XXS ")
 ;;1394
 ;;21,"V55.1XXA ")
 ;;1395
 ;;21,"V55.1XXD ")
 ;;1396
 ;;21,"V55.1XXS ")
 ;;1397
 ;;21,"V55.2XXA ")
 ;;1398
 ;;21,"V55.2XXD ")
 ;;1399
 ;;21,"V55.2XXS ")
 ;;1400
 ;;21,"V55.3XXA ")
 ;;1401
 ;;21,"V55.3XXD ")
 ;;1402
 ;;21,"V55.3XXS ")
 ;;1403
 ;;21,"V55.4XXA ")
 ;;1404
 ;;21,"V55.4XXD ")
 ;;1405
 ;;21,"V55.4XXS ")
 ;;1406
 ;;21,"V55.5XXA ")
 ;;1407
 ;;21,"V55.5XXD ")
 ;;1408
 ;;21,"V55.5XXS ")
 ;;1409
 ;;21,"V55.6XXA ")
 ;;1410
 ;;21,"V55.6XXD ")
 ;;1411
 ;;21,"V55.6XXS ")
 ;;1412
 ;;21,"V55.7XXA ")
 ;;1413
 ;;21,"V55.7XXD ")
 ;;1414
 ;;21,"V55.7XXS ")
 ;;1415
 ;;21,"V55.9XXA ")
 ;;1416
 ;;21,"V55.9XXD ")
 ;;1417
 ;;21,"V55.9XXS ")
 ;;1418
 ;;21,"V56.0XXA ")
 ;;1419
 ;;21,"V56.0XXD ")
 ;;1420
 ;;21,"V56.0XXS ")
 ;;1421
 ;;21,"V56.1XXA ")
 ;;1422
 ;;21,"V56.1XXD ")
 ;;1423
 ;;21,"V56.1XXS ")
 ;;1424
 ;;21,"V56.2XXA ")
 ;;1425
 ;;21,"V56.2XXD ")
 ;;1426
 ;;21,"V56.2XXS ")
 ;;1427
 ;;21,"V56.3XXA ")
 ;;1428
 ;;21,"V56.3XXD ")
 ;;1429
 ;;21,"V56.3XXS ")
 ;;1430
 ;;21,"V56.4XXA ")
 ;;1431
 ;;21,"V56.4XXD ")
 ;;1432
 ;;21,"V56.4XXS ")
 ;;1433
 ;;21,"V56.5XXA ")
 ;;1434
 ;;21,"V56.5XXD ")
 ;;1435
 ;;21,"V56.5XXS ")
 ;;1436
 ;;21,"V56.6XXA ")
 ;;1437
 ;;21,"V56.6XXD ")
 ;;1438
 ;;21,"V56.6XXS ")
 ;;1439
 ;;21,"V56.7XXA ")
 ;;1440
 ;;21,"V56.7XXD ")
 ;;1441
 ;;21,"V56.7XXS ")
 ;;1442
 ;;21,"V56.9XXA ")
 ;;1443
 ;;21,"V56.9XXD ")
 ;;1444
 ;;21,"V56.9XXS ")
 ;;1445
 ;;21,"V57.0XXA ")
 ;;1446
 ;;21,"V57.0XXD ")
 ;;1447
 ;;21,"V57.0XXS ")
 ;;1448
 ;;21,"V57.1XXA ")
 ;;1449
 ;;21,"V57.1XXD ")
 ;;1450
 ;;21,"V57.1XXS ")
 ;;1451
 ;;21,"V57.2XXA ")
 ;;1452
 ;;21,"V57.2XXD ")
 ;;1453
 ;;21,"V57.2XXS ")
 ;;1454
 ;;21,"V57.3XXA ")
 ;;1455
 ;;21,"V57.3XXD ")
 ;;1456
 ;;21,"V57.3XXS ")
 ;;1457
 ;;21,"V57.4XXA ")
 ;;1458
 ;;21,"V57.4XXD ")
 ;;1459
 ;;21,"V57.4XXS ")
 ;;1460
 ;;21,"V57.5XXA ")
 ;;1461
 ;;21,"V57.5XXD ")
 ;;1462
 ;;21,"V57.5XXS ")
 ;;1463
 ;;21,"V57.6XXA ")
 ;;1464
 ;;21,"V57.6XXD ")
 ;;1465
 ;;21,"V57.6XXS ")
 ;;1466
 ;;21,"V57.7XXA ")
 ;;1467
 ;;21,"V57.7XXD ")
 ;;1468
 ;;21,"V57.7XXS ")
 ;;1469
 ;;21,"V57.9XXA ")
 ;;1470
 ;;21,"V57.9XXD ")
 ;;1471
 ;;21,"V57.9XXS ")
 ;;1472
 ;;21,"V58.0XXA ")
 ;;1473
 ;;21,"V58.0XXD ")
 ;;1474
 ;;21,"V58.0XXS ")
 ;;1475
 ;;21,"V58.1XXA ")
 ;;1476
 ;;21,"V58.1XXD ")
 ;;1477
 ;;21,"V58.1XXS ")
 ;;1478
 ;;21,"V58.2XXA ")
 ;;1479
 ;;21,"V58.2XXD ")
 ;;1480
 ;;21,"V58.2XXS ")
 ;;1481
 ;;21,"V58.3XXA ")
 ;;1482
 ;;21,"V58.3XXD ")
 ;;1483
 ;;21,"V58.3XXS ")
 ;;1484
 ;;21,"V58.4XXA ")
 ;;1485
 ;;21,"V58.4XXD ")
 ;;1486
 ;;21,"V58.4XXS ")
 ;;1487
 ;;21,"V58.5XXA ")
 ;;1488
 ;;21,"V58.5XXD ")
 ;;1489
 ;;21,"V58.5XXS ")
 ;;1490
 ;;21,"V58.6XXA ")
 ;;1491
 ;;21,"V58.6XXD ")
 ;;1492
 ;;21,"V58.6XXS ")
 ;;1493
 ;;21,"V58.7XXA ")
 ;;1494
 ;;21,"V58.7XXD ")
 ;;1495
 ;;21,"V58.7XXS ")
 ;;1496
 ;;21,"V58.9XXA ")
 ;;1497
 ;;21,"V58.9XXD ")
 ;;1498
 ;;21,"V58.9XXS ")
 ;;1499
 ;;21,"V59.00XA ")
 ;;1500
 ;;21,"V59.00XD ")
 ;;1501
 ;;21,"V59.00XS ")
 ;;1502
 ;;21,"V59.09XA ")
 ;;1503
 ;;21,"V59.09XD ")
 ;;1504
 ;;21,"V59.09XS ")
 ;;1505
 ;;21,"V59.10XA ")
 ;;1506
 ;;21,"V59.10XD ")
 ;;1507
 ;;21,"V59.10XS ")
 ;;1508
 ;;21,"V59.19XA ")
 ;;1509
 ;;21,"V59.19XD ")
 ;;1510
 ;;21,"V59.19XS ")
 ;;1511
 ;;21,"V59.20XA ")
 ;;1512
 ;;21,"V59.20XD ")
 ;;1513
 ;;21,"V59.20XS ")
 ;;1514
 ;;21,"V59.29XA ")
 ;;1515
 ;;21,"V59.29XD ")
 ;;1516
 ;;21,"V59.29XS ")
 ;;1517
 ;;21,"V59.3XXA ")
 ;;1518
 ;;21,"V59.3XXD ")
 ;;1519
 ;;21,"V59.3XXS ")
 ;;1520
 ;;21,"V59.40XA ")
 ;;1521
 ;;21,"V59.40XD ")
 ;;1522
 ;;21,"V59.40XS ")
 ;;1523
 ;;21,"V59.49XA ")
 ;;1524
 ;;21,"V59.49XD ")
 ;;1525
 ;;21,"V59.49XS ")
 ;;1526
 ;;21,"V59.50XA ")
 ;;1527
 ;;21,"V59.50XD ")
 ;;1528
 ;;21,"V59.50XS ")
 ;;1529
 ;;21,"V59.59XA ")
 ;;1530
 ;;21,"V59.59XD ")
 ;;1531
 ;;21,"V59.59XS ")
 ;;1532
 ;;21,"V59.60XA ")
 ;;1533
 ;;21,"V59.60XD ")
 ;;1534
 ;;21,"V59.60XS ")
 ;;1535
 ;;21,"V59.69XA ")
 ;;1536
 ;;21,"V59.69XD ")
 ;;1537
 ;;21,"V59.69XS ")
 ;;1538
 ;;21,"V59.81XA ")
 ;;1539
 ;;21,"V59.81XD ")
 ;;1540
 ;;21,"V59.81XS ")
 ;;1541
 ;;21,"V59.88XA ")
 ;;1542
 ;;21,"V59.88XD ")
 ;;1543
 ;;21,"V59.88XS ")
 ;;1544
 ;;21,"V59.9XXA ")
 ;;1545
 ;;21,"V59.9XXD ")
 ;;1546
 ;;21,"V59.9XXS ")
 ;;1547
 ;;21,"V60.0XXA ")
 ;;1548
 ;;21,"V60.0XXD ")
 ;;1549
 ;;21,"V60.0XXS ")
 ;;1550
 ;;21,"V60.1XXA ")
 ;;1551
 ;;21,"V60.1XXD ")
 ;;1552
 ;;21,"V60.1XXS ")
 ;;1553
 ;;21,"V60.2XXA ")
 ;;1554
 ;;21,"V60.2XXD ")
 ;;1555
 ;;21,"V60.2XXS ")
 ;;1556
 ;;21,"V60.3XXA ")
 ;;1557
 ;;21,"V60.3XXD ")
 ;;1558
 ;;21,"V60.3XXS ")
 ;;1559
 ;;21,"V60.4XXA ")
 ;;1560
 ;;21,"V60.4XXD ")
 ;;1561
 ;;21,"V60.4XXS ")
 ;;1562
 ;;21,"V60.5XXA ")
 ;;1563
 ;;21,"V60.5XXD ")
 ;;1564
 ;;21,"V60.5XXS ")
 ;;1565
 ;;21,"V60.6XXA ")
 ;;1566
 ;;21,"V60.6XXD ")
 ;;1567
 ;;21,"V60.6XXS ")
 ;;1568
 ;;21,"V60.7XXA ")
 ;;1569
 ;;21,"V60.7XXD ")
 ;;1570
 ;;21,"V60.7XXS ")
 ;;1571
 ;;21,"V60.9XXA ")
 ;;1572
 ;;21,"V60.9XXD ")
 ;;1573
 ;;21,"V60.9XXS ")
 ;;1574
 ;;21,"V61.0XXA ")
 ;;1575
 ;;21,"V61.0XXD ")
 ;;1576
 ;;21,"V61.0XXS ")
 ;;1577
 ;;21,"V61.1XXA ")
 ;;1578
 ;;21,"V61.1XXD ")
 ;;1579
 ;;21,"V61.1XXS ")
 ;;1580
 ;;21,"V61.2XXA ")
 ;;1581
 ;;21,"V61.2XXD ")
 ;;1582
 ;;21,"V61.2XXS ")
 ;;1583
 ;;21,"V61.3XXA ")
 ;;1584
 ;;21,"V61.3XXD ")
 ;;1585
 ;;21,"V61.3XXS ")
 ;;1586
 ;;21,"V61.4XXA ")
 ;;1587
 ;;21,"V61.4XXD ")
 ;;1588
 ;;21,"V61.4XXS ")
 ;;1589
 ;;21,"V61.5XXA ")
 ;;1590
 ;;21,"V61.5XXD ")
 ;;1591
 ;;21,"V61.5XXS ")
 ;;1592
 ;;21,"V61.6XXA ")
 ;;1593
 ;;21,"V61.6XXD ")
 ;;1594
 ;;21,"V61.6XXS ")
 ;;1595
 ;;21,"V61.7XXA ")
 ;;1596
 ;;21,"V61.7XXD ")
 ;;1597
 ;;21,"V61.7XXS ")
 ;;1598
 ;;21,"V61.9XXA ")
 ;;1599
 ;;21,"V61.9XXD ")
 ;;1600
 ;;21,"V61.9XXS ")
 ;;1601
 ;;21,"V62.0XXA ")
 ;;1602
 ;;21,"V62.0XXD ")
 ;;1603
 ;;21,"V62.0XXS ")
 ;;1604
 ;;21,"V62.1XXA ")
 ;;1605
 ;;21,"V62.1XXD ")
 ;;1606
 ;;21,"V62.1XXS ")
 ;;1607
 ;;21,"V62.2XXA ")
 ;;1608
 ;;21,"V62.2XXD ")
 ;;1609
 ;;21,"V62.2XXS ")
 ;;1610
 ;;21,"V62.3XXA ")
 ;;1611
 ;;21,"V62.3XXD ")
 ;;1612
 ;;21,"V62.3XXS ")
 ;;1613
 ;;21,"V62.4XXA ")
 ;;1614
 ;;21,"V62.4XXD ")
 ;;1615
 ;;21,"V62.4XXS ")
 ;;1616
 ;;21,"V62.5XXA ")
 ;;1617
 ;;21,"V62.5XXD ")
 ;;1618
 ;;21,"V62.5XXS ")
 ;;1619
 ;;21,"V62.6XXA ")
 ;;1620
 ;;21,"V62.6XXD ")
 ;;1621
 ;;21,"V62.6XXS ")
 ;;1622
 ;;21,"V62.7XXA ")
 ;;1623
 ;;21,"V62.7XXD ")
 ;;1624
 ;;21,"V62.7XXS ")
 ;;1625
 ;;21,"V62.9XXA ")
 ;;1626
 ;;21,"V62.9XXD ")
 ;;1627
 ;;21,"V62.9XXS ")
 ;;1628
 ;;21,"V63.0XXA ")
 ;;1629
 ;;21,"V63.0XXD ")
 ;;1630
 ;;21,"V63.0XXS ")
 ;;1631
 ;;21,"V63.1XXA ")
 ;;1632
 ;;21,"V63.1XXD ")
 ;;1633
 ;;21,"V63.1XXS ")
 ;;1634
 ;;21,"V63.2XXA ")
 ;;1635
 ;;21,"V63.2XXD ")
 ;;1636
 ;;21,"V63.2XXS ")
 ;;1637
 ;;21,"V63.3XXA ")
 ;;1638
 ;;21,"V63.3XXD ")
 ;;1639
 ;;21,"V63.3XXS ")
 ;;1640
 ;;21,"V63.4XXA ")
 ;;1641
 ;;21,"V63.4XXD ")
 ;;1642
 ;;21,"V63.4XXS ")
 ;;1643
 ;;21,"V63.5XXA ")
 ;;1644
 ;;21,"V63.5XXD ")
 ;;1645
 ;;21,"V63.5XXS ")
 ;;1646
 ;;21,"V63.6XXA ")
 ;;1647
 ;;21,"V63.6XXD ")
 ;;1648
 ;;21,"V63.6XXS ")
 ;;1649
 ;;21,"V63.7XXA ")
 ;;1650
 ;;21,"V63.7XXD ")
 ;;1651
 ;;21,"V63.7XXS ")
 ;;1652
 ;;21,"V63.9XXA ")
 ;;1653
 ;;21,"V63.9XXD ")
 ;;1654
 ;;21,"V63.9XXS ")
 ;;1655
 ;;21,"V64.0XXA ")
 ;;1656
 ;;21,"V64.0XXD ")
 ;;1657
 ;;21,"V64.0XXS ")
 ;;1658
 ;;21,"V64.1XXA ")
 ;;1659
 ;;21,"V64.1XXD ")
 ;;1660
 ;;21,"V64.1XXS ")
 ;;1661
 ;;21,"V64.2XXA ")
 ;;1662
 ;;21,"V64.2XXD ")
 ;;1663
 ;;21,"V64.2XXS ")
 ;;1664
 ;;21,"V64.3XXA ")
 ;;1665
 ;;21,"V64.3XXD ")
 ;;1666
 ;;21,"V64.3XXS ")
 ;;1667
 ;;21,"V64.4XXA ")
 ;;1668
 ;;21,"V64.4XXD ")
 ;;1669
 ;;21,"V64.4XXS ")
 ;;1670
 ;;21,"V64.5XXA ")
 ;;1671
 ;;21,"V64.5XXD ")
 ;;1672
 ;;21,"V64.5XXS ")
 ;;1673
 ;;21,"V64.6XXA ")
 ;;1674
 ;;21,"V64.6XXD ")
 ;;1675
 ;;21,"V64.6XXS ")
 ;;1676
 ;;21,"V64.7XXA ")
 ;;1677
 ;;21,"V64.7XXD ")
 ;;1678
 ;;21,"V64.7XXS ")
 ;;1679
 ;;21,"V64.9XXA ")
 ;;1680
 ;;21,"V64.9XXD ")
 ;;1681
 ;;21,"V64.9XXS ")
 ;;1682
 ;;21,"V65.0XXA ")
 ;;1683
 ;;21,"V65.0XXD ")
 ;;1684
 ;;21,"V65.0XXS ")
 ;;1685
 ;;21,"V65.1XXA ")
 ;;1686
 ;;21,"V65.1XXD ")
 ;;1687
 ;;21,"V65.1XXS ")
 ;;1688
 ;;21,"V65.2XXA ")
 ;;1689
 ;;21,"V65.2XXD ")
 ;;1690
 ;;21,"V65.2XXS ")
 ;;1691
 ;;21,"V65.3XXA ")
 ;;1692
 ;;21,"V65.3XXD ")
 ;;1693
 ;;21,"V65.3XXS ")
 ;;1694
 ;;21,"V65.4XXA ")
 ;;1695
 ;;21,"V65.4XXD ")
 ;;1696
 ;;21,"V65.4XXS ")
 ;;1697
 ;;21,"V65.5XXA ")
 ;;1698
 ;;21,"V65.5XXD ")
 ;;1699
 ;;21,"V65.5XXS ")
 ;;1700
 ;;21,"V65.6XXA ")
 ;;1701
 ;;21,"V65.6XXD ")
 ;;1702
 ;;21,"V65.6XXS ")
 ;;1703
 ;;21,"V65.7XXA ")
 ;;1704
 ;;21,"V65.7XXD ")
 ;;1705
 ;;21,"V65.7XXS ")
 ;;1706
 ;;21,"V65.9XXA ")
 ;;1707
 ;;21,"V65.9XXD ")
 ;;1708
 ;;21,"V65.9XXS ")
 ;;1709
 ;;21,"V66.0XXA ")
 ;;1710
 ;;21,"V66.0XXD ")
 ;;1711
 ;;21,"V66.0XXS ")
 ;;1712
 ;;21,"V66.1XXA ")
 ;;1713
 ;;21,"V66.1XXD ")
 ;;1714
 ;;21,"V66.1XXS ")
 ;;1715
 ;;21,"V66.2XXA ")
 ;;1716
 ;;21,"V66.2XXD ")
 ;;1717
 ;;21,"V66.2XXS ")
 ;;1718
 ;;21,"V66.3XXA ")
 ;;1719
 ;;21,"V66.3XXD ")
 ;;1720
 ;;21,"V66.3XXS ")
 ;;1721
 ;;21,"V66.4XXA ")
 ;;1722
 ;;21,"V66.4XXD ")
 ;;1723
 ;;21,"V66.4XXS ")
 ;;1724
 ;;21,"V66.5XXA ")
 ;;1725
 ;;21,"V66.5XXD ")
 ;;1726
 ;;21,"V66.5XXS ")
 ;;1727
 ;;21,"V66.6XXA ")
 ;;1728
 ;;21,"V66.6XXD ")
 ;;1729
 ;;21,"V66.6XXS ")
 ;;1730
 ;;21,"V66.7XXA ")
 ;;1731
 ;;21,"V66.7XXD ")
 ;;1732
 ;;21,"V66.7XXS ")
 ;;1733
 ;;21,"V66.9XXA ")
 ;;1734
 ;;21,"V66.9XXD ")
 ;;1735
 ;;21,"V66.9XXS ")
 ;;1736
 ;;21,"V67.0XXA ")
 ;;1737
 ;;21,"V67.0XXD ")
 ;;1738
 ;;21,"V67.0XXS ")
 ;;1739
 ;;21,"V67.1XXA ")
 ;;1740
 ;;21,"V67.1XXD ")
 ;;1741
 ;;21,"V67.1XXS ")
 ;;1742
 ;;21,"V67.2XXA ")
 ;;1743
 ;;21,"V67.2XXD ")
 ;;1744
 ;;21,"V67.2XXS ")
 ;;1745
 ;;21,"V67.3XXA ")
 ;;1746
 ;;21,"V67.3XXD ")
 ;;1747
 ;;21,"V67.3XXS ")
 ;;1748
 ;;21,"V67.4XXA ")
 ;;1749
 ;;21,"V67.4XXD ")
 ;;1750
 ;;21,"V67.4XXS ")
 ;;1751
 ;;21,"V67.5XXA ")
 ;;1752
 ;;21,"V67.5XXD ")
 ;;1753
 ;;21,"V67.5XXS ")
 ;;1754
 ;;21,"V67.6XXA ")
 ;;1755
 ;;21,"V67.6XXD ")
 ;;1756
 ;;21,"V67.6XXS ")
 ;;1757
 ;;21,"V67.7XXA ")
 ;;1758
 ;;21,"V67.7XXD ")
 ;;1759
 ;;21,"V67.7XXS ")
 ;;1760
 ;;21,"V67.9XXA ")
 ;;1761
 ;;21,"V67.9XXD ")
 ;;1762
 ;;21,"V67.9XXS ")
 ;;1763
 ;;21,"V68.0XXA ")
 ;;1764
 ;;21,"V68.0XXD ")
 ;;1765
 ;;21,"V68.0XXS ")
 ;;1766
 ;;21,"V68.1XXA ")
 ;;1767
 ;;21,"V68.1XXD ")
 ;;1768
 ;;21,"V68.1XXS ")
 ;;1769
 ;;21,"V68.2XXA ")
 ;;1770
 ;;21,"V68.2XXD ")
 ;;1771
 ;;21,"V68.2XXS ")
 ;;1772
 ;;21,"V68.3XXA ")
 ;;1773
 ;;21,"V68.3XXD ")
 ;;1774
 ;;21,"V68.3XXS ")
 ;;1775
 ;;21,"V68.4XXA ")
 ;;1776
 ;;21,"V68.4XXD ")
 ;;1777
 ;;21,"V68.4XXS ")
 ;;1778
 ;;21,"V68.5XXA ")
 ;;1779
 ;;21,"V68.5XXD ")
 ;;1780
 ;;21,"V68.5XXS ")
 ;;1781
 ;;21,"V68.6XXA ")
 ;;1782
 ;;21,"V68.6XXD ")
 ;;1783
 ;;21,"V68.6XXS ")
 ;;1784
 ;;21,"V68.7XXA ")
 ;;1785
 ;;21,"V68.7XXD ")
 ;;1786
 ;;21,"V68.7XXS ")
 ;;1787
 ;;21,"V68.9XXA ")
 ;;1788
 ;;21,"V68.9XXD ")
 ;;1789
 ;;21,"V68.9XXS ")
 ;;1790
 ;;21,"V69.00XA ")
 ;;1791
 ;;21,"V69.00XD ")
 ;;1792
 ;;21,"V69.00XS ")
 ;;1793
 ;;21,"V69.09XA ")
 ;;1794
 ;;21,"V69.09XD ")
 ;;1795
 ;;21,"V69.09XS ")
 ;;1796
 ;;21,"V69.10XA ")
 ;;1797
 ;;21,"V69.10XD ")
 ;;1798
 ;;21,"V69.10XS ")
 ;;1799
 ;;21,"V69.19XA ")
 ;;1800
 ;;21,"V69.19XD ")
 ;;1801
 ;;21,"V69.19XS ")
 ;;1802
 ;;21,"V69.20XA ")
 ;;1803
 ;;21,"V69.20XD ")
 ;;1804
 ;;21,"V69.20XS ")
 ;;1805
 ;;21,"V69.29XA ")
 ;;1806