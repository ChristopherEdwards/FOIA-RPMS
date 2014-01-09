BGP33Q5 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON JAN 23, 2013;
 ;;13.0;IHS CLINICAL REPORTING;**1**;NOV 20, 2012;Build 7
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"58177-0293-09 ")
 ;;1567
 ;;21,"58177-0293-11 ")
 ;;1568
 ;;21,"58177-0358-04 ")
 ;;1569
 ;;21,"58177-0358-09 ")
 ;;1570
 ;;21,"58177-0368-04 ")
 ;;1571
 ;;21,"58177-0368-09 ")
 ;;1572
 ;;21,"58177-0368-11 ")
 ;;1573
 ;;21,"58177-0369-04 ")
 ;;1574
 ;;21,"58177-0369-09 ")
 ;;1575
 ;;21,"58177-0369-11 ")
 ;;1576
 ;;21,"58864-0016-01 ")
 ;;1577
 ;;21,"58864-0016-28 ")
 ;;1578
 ;;21,"58864-0016-30 ")
 ;;1579
 ;;21,"58864-0016-60 ")
 ;;1580
 ;;21,"58864-0065-01 ")
 ;;1581
 ;;21,"58864-0065-30 ")
 ;;1582
 ;;21,"58864-0363-30 ")
 ;;1583
 ;;21,"58864-0645-56 ")
 ;;1584
 ;;21,"58864-0680-30 ")
 ;;1585
 ;;21,"58864-0695-30 ")
 ;;1586
 ;;21,"58864-0717-30 ")
 ;;1587
 ;;21,"58864-0727-30 ")
 ;;1588
 ;;21,"58864-0737-30 ")
 ;;1589
 ;;21,"58864-0749-30 ")
 ;;1590
 ;;21,"58864-0749-90 ")
 ;;1591
 ;;21,"58864-0759-30 ")
 ;;1592
 ;;21,"58864-0765-30 ")
 ;;1593
 ;;21,"58864-0784-30 ")
 ;;1594
 ;;21,"59762-1258-01 ")
 ;;1595
 ;;21,"59762-1258-02 ")
 ;;1596
 ;;21,"59762-1261-01 ")
 ;;1597
 ;;21,"59762-1261-02 ")
 ;;1598
 ;;21,"59762-1300-01 ")
 ;;1599
 ;;21,"59762-1300-03 ")
 ;;1600
 ;;21,"59762-1301-01 ")
 ;;1601
 ;;21,"59762-1301-03 ")
 ;;1602
 ;;21,"59762-1302-01 ")
 ;;1603
 ;;21,"59762-1302-03 ")
 ;;1604
 ;;21,"59772-2462-01 ")
 ;;1605
 ;;21,"59772-2463-03 ")
 ;;1606
 ;;21,"60346-0523-06 ")
 ;;1607
 ;;21,"60429-0748-01 ")
 ;;1608
 ;;21,"60429-0749-01 ")
 ;;1609
 ;;21,"60429-0750-01 ")
 ;;1610
 ;;21,"60429-0751-01 ")
 ;;1611
 ;;21,"60429-0753-01 ")
 ;;1612
 ;;21,"60429-0754-01 ")
 ;;1613
 ;;21,"60429-0948-01 ")
 ;;1614
 ;;21,"60429-0949-01 ")
 ;;1615
 ;;21,"60429-0950-01 ")
 ;;1616
 ;;21,"60429-0951-01 ")
 ;;1617
 ;;21,"60505-0080-00 ")
 ;;1618
 ;;21,"60505-0081-00 ")
 ;;1619
 ;;21,"60505-0082-00 ")
 ;;1620
 ;;21,"60505-0159-00 ")
 ;;1621
 ;;21,"60505-0222-01 ")
 ;;1622
 ;;21,"60505-0223-01 ")
 ;;1623
 ;;21,"60505-0224-01 ")
 ;;1624
 ;;21,"60505-2606-01 ")
 ;;1625
 ;;21,"60505-2606-08 ")
 ;;1626
 ;;21,"60505-2607-01 ")
 ;;1627
 ;;21,"60505-2607-08 ")
 ;;1628
 ;;21,"60505-2608-01 ")
 ;;1629
 ;;21,"60505-2608-08 ")
 ;;1630
 ;;21,"60505-2609-01 ")
 ;;1631
 ;;21,"60505-2609-08 ")
 ;;1632
 ;;21,"60793-0283-01 ")
 ;;1633
 ;;21,"60793-0284-01 ")
 ;;1634
 ;;21,"60793-0800-01 ")
 ;;1635
 ;;21,"60793-0801-01 ")
 ;;1636
 ;;21,"60793-0802-01 ")
 ;;1637
 ;;21,"60814-0710-01 ")
 ;;1638
 ;;21,"60814-0710-10 ")
 ;;1639
 ;;21,"60814-0711-01 ")
 ;;1640
 ;;21,"60814-0711-10 ")
 ;;1641
 ;;21,"60976-0346-43 ")
 ;;1642
 ;;21,"60976-0346-44 ")
 ;;1643
 ;;21,"60976-0346-47 ")
 ;;1644
 ;;21,"61392-0018-30 ")
 ;;1645
 ;;21,"61392-0018-31 ")
 ;;1646
 ;;21,"61392-0018-32 ")
 ;;1647
 ;;21,"61392-0018-39 ")
 ;;1648
 ;;21,"61392-0018-45 ")
 ;;1649
 ;;21,"61392-0018-51 ")
 ;;1650
 ;;21,"61392-0018-54 ")
 ;;1651
 ;;21,"61392-0018-56 ")
 ;;1652
 ;;21,"61392-0018-60 ")
 ;;1653
 ;;21,"61392-0018-90 ")
 ;;1654
 ;;21,"61392-0018-91 ")
 ;;1655
 ;;21,"61392-0069-30 ")
 ;;1656
 ;;21,"61392-0069-31 ")
 ;;1657
 ;;21,"61392-0069-32 ")
 ;;1658
 ;;21,"61392-0069-39 ")
 ;;1659
 ;;21,"61392-0069-45 ")
 ;;1660
 ;;21,"61392-0069-51 ")
 ;;1661
 ;;21,"61392-0069-54 ")
 ;;1662
 ;;21,"61392-0069-60 ")
 ;;1663
 ;;21,"61392-0069-90 ")
 ;;1664
 ;;21,"61392-0069-91 ")
 ;;1665
 ;;21,"61392-0280-45 ")
 ;;1666
 ;;21,"61392-0280-56 ")
 ;;1667
 ;;21,"61392-0280-91 ")
 ;;1668
 ;;21,"61392-0286-45 ")
 ;;1669
 ;;21,"61392-0286-56 ")
 ;;1670
 ;;21,"61392-0286-91 ")
 ;;1671
 ;;21,"61392-0395-31 ")
 ;;1672
 ;;21,"61392-0395-32 ")
 ;;1673
 ;;21,"61392-0395-39 ")
 ;;1674
 ;;21,"61392-0395-45 ")
 ;;1675
 ;;21,"61392-0395-54 ")
 ;;1676
 ;;21,"61392-0395-56 ")
 ;;1677
 ;;21,"61392-0395-91 ")
 ;;1678
 ;;21,"61392-0420-34 ")
 ;;1679
 ;;21,"61392-0420-45 ")
 ;;1680
 ;;21,"61392-0420-56 ")
 ;;1681
 ;;21,"61392-0420-91 ")
 ;;1682
 ;;21,"61392-0423-34 ")
 ;;1683
 ;;21,"61392-0423-45 ")
 ;;1684
 ;;21,"61392-0423-56 ")
 ;;1685
 ;;21,"61392-0423-91 ")
 ;;1686
 ;;21,"61392-0427-30 ")
 ;;1687
 ;;21,"61392-0427-31 ")
 ;;1688
 ;;21,"61392-0427-32 ")
 ;;1689
 ;;21,"61392-0427-39 ")
 ;;1690
 ;;21,"61392-0427-45 ")
 ;;1691
 ;;21,"61392-0427-51 ")
 ;;1692
 ;;21,"61392-0427-54 ")
 ;;1693
 ;;21,"61392-0427-56 ")
 ;;1694
 ;;21,"61392-0427-60 ")
 ;;1695
 ;;21,"61392-0427-90 ")
 ;;1696
 ;;21,"61392-0427-91 ")
 ;;1697
 ;;21,"61392-0430-45 ")
 ;;1698
 ;;21,"61392-0430-56 ")
 ;;1699
 ;;21,"61392-0430-91 ")
 ;;1700
 ;;21,"61392-0542-45 ")
 ;;1701
 ;;21,"61392-0542-51 ")
 ;;1702
 ;;21,"61392-0542-54 ")
 ;;1703
 ;;21,"61392-0542-91 ")
 ;;1704
 ;;21,"61392-0543-45 ")
 ;;1705
 ;;21,"61392-0543-54 ")
 ;;1706
 ;;21,"61392-0543-56 ")
 ;;1707
 ;;21,"61392-0543-91 ")
 ;;1708
 ;;21,"61392-0546-30 ")
 ;;1709
 ;;21,"61392-0546-31 ")
 ;;1710
 ;;21,"61392-0546-32 ")
 ;;1711
 ;;21,"61392-0546-39 ")
 ;;1712
 ;;21,"61392-0546-45 ")
 ;;1713
 ;;21,"61392-0546-51 ")
 ;;1714
 ;;21,"61392-0546-54 ")
 ;;1715
 ;;21,"61392-0546-56 ")
 ;;1716
 ;;21,"61392-0546-60 ")
 ;;1717
 ;;21,"61392-0546-90 ")
 ;;1718
 ;;21,"61392-0546-91 ")
 ;;1719
 ;;21,"61570-0201-01 ")
 ;;1720
 ;;21,"61570-0202-01 ")
 ;;1721
 ;;21,"62037-0830-01 ")
 ;;1722
 ;;21,"62037-0830-10 ")
 ;;1723
 ;;21,"62037-0831-01 ")
 ;;1724
 ;;21,"62037-0831-10 ")
 ;;1725
 ;;21,"62037-0832-01 ")
 ;;1726
 ;;21,"62037-0832-10 ")
 ;;1727
 ;;21,"62037-0833-01 ")
 ;;1728
 ;;21,"62037-0833-10 ")
 ;;1729
 ;;21,"62584-0265-01 ")
 ;;1730
 ;;21,"62584-0265-11 ")
 ;;1731
 ;;21,"62584-0266-01 ")
 ;;1732
 ;;21,"62584-0266-11 ")
 ;;1733
 ;;21,"62584-0267-01 ")
 ;;1734
 ;;21,"62584-0267-11 ")
 ;;1735
 ;;21,"62584-0467-01 ")
 ;;1736
 ;;21,"62584-0467-11 ")
 ;;1737
 ;;21,"62584-0467-80 ")
 ;;1738
 ;;21,"62584-0467-85 ")
 ;;1739
 ;;21,"62584-0715-01 ")
 ;;1740
 ;;21,"62584-0715-11 ")
 ;;1741
 ;;21,"62584-0788-01 ")
 ;;1742
 ;;21,"62584-0788-11 ")
 ;;1743
 ;;21,"62584-0842-01 ")
 ;;1744
 ;;21,"62584-0842-85 ")
 ;;1745
 ;;21,"62584-0843-01 ")
 ;;1746
 ;;21,"62584-0843-85 ")
 ;;1747
 ;;21,"62756-0368-88 ")
 ;;1748
 ;;21,"62756-0369-88 ")
 ;;1749
 ;;21,"62756-0370-88 ")
 ;;1750
 ;;21,"63304-0579-01 ")
 ;;1751
 ;;21,"63304-0579-10 ")
 ;;1752
 ;;21,"63304-0580-01 ")
 ;;1753
 ;;21,"63304-0580-10 ")
 ;;1754
 ;;21,"63304-0581-01 ")
 ;;1755
 ;;21,"63304-0581-10 ")
 ;;1756
 ;;21,"63304-0621-01 ")
 ;;1757
 ;;21,"63304-0621-10 ")
 ;;1758
 ;;21,"63304-0622-01 ")
 ;;1759
 ;;21,"63304-0622-10 ")
 ;;1760
 ;;21,"63304-0623-01 ")
 ;;1761
 ;;21,"63304-0623-10 ")
 ;;1762
 ;;21,"63629-1423-01 ")
 ;;1763
 ;;21,"63629-1423-02 ")
 ;;1764
 ;;21,"63629-1462-01 ")
 ;;1765
 ;;21,"63629-1462-02 ")
 ;;1766
 ;;21,"63629-1463-01 ")
 ;;1767
 ;;21,"63629-1463-02 ")
 ;;1768
 ;;21,"63629-1463-03 ")
 ;;1769
 ;;21,"63629-1463-04 ")
 ;;1770
 ;;21,"63629-2570-01 ")
 ;;1771
 ;;21,"63629-2570-02 ")
 ;;1772
 ;;21,"63629-2570-03 ")
 ;;1773
 ;;21,"63629-2909-01 ")
 ;;1774
 ;;21,"63629-2909-02 ")
 ;;1775
 ;;21,"63629-2909-03 ")
 ;;1776
 ;;21,"63629-2909-04 ")
 ;;1777
 ;;21,"63739-0027-01 ")
 ;;1778
 ;;21,"63739-0027-03 ")
 ;;1779
 ;;21,"63739-0027-10 ")
 ;;1780
 ;;21,"63739-0027-15 ")
 ;;1781
 ;;21,"63739-0028-01 ")
 ;;1782
 ;;21,"63739-0028-03 ")
 ;;1783
 ;;21,"63739-0028-10 ")
 ;;1784
 ;;21,"63739-0028-15 ")
 ;;1785
 ;;21,"63739-0173-01 ")
 ;;1786
 ;;21,"63739-0173-03 ")
 ;;1787
 ;;21,"63739-0173-10 ")
 ;;1788
 ;;21,"63739-0173-15 ")
 ;;1789
 ;;21,"63739-0366-10 ")
 ;;1790
 ;;21,"63739-0405-10 ")
 ;;1791
 ;;21,"63739-0428-10 ")
 ;;1792
 ;;21,"63739-0453-10 ")
 ;;1793
 ;;21,"63739-0454-10 ")
 ;;1794
 ;;21,"63874-0332-01 ")
 ;;1795
 ;;21,"63874-0332-02 ")
 ;;1796
 ;;21,"63874-0332-07 ")
 ;;1797
 ;;21,"63874-0332-10 ")
 ;;1798
 ;;21,"63874-0332-14 ")
 ;;1799
 ;;21,"63874-0332-15 ")
 ;;1800
 ;;21,"63874-0332-20 ")
 ;;1801
 ;;21,"63874-0332-30 ")
 ;;1802
 ;;21,"63874-0332-60 ")
 ;;1803
 ;;21,"63874-0332-90 ")
 ;;1804
 ;;21,"63874-0368-01 ")
 ;;1805
 ;;21,"63874-0368-02 ")
 ;;1806
 ;;21,"63874-0368-15 ")
 ;;1807
 ;;21,"63874-0368-20 ")
 ;;1808
 ;;21,"63874-0368-28 ")
 ;;1809
 ;;21,"63874-0368-30 ")
 ;;1810
 ;;21,"63874-0368-60 ")
 ;;1811
 ;;21,"63874-0388-01 ")
 ;;1812
 ;;21,"63874-0388-07 ")
 ;;1813
 ;;21,"63874-0388-10 ")
 ;;1814
 ;;21,"63874-0388-12 ")
 ;;1815
 ;;21,"63874-0388-15 ")
 ;;1816
 ;;21,"63874-0388-20 ")
 ;;1817
 ;;21,"63874-0388-30 ")
 ;;1818
 ;;21,"63874-0406-01 ")
 ;;1819
 ;;21,"63874-0406-10 ")
 ;;1820
 ;;21,"63874-0406-14 ")
 ;;1821
 ;;21,"63874-0406-15 ")
 ;;1822
 ;;21,"63874-0406-20 ")
 ;;1823
 ;;21,"63874-0406-28 ")
 ;;1824
 ;;21,"63874-0406-30 ")
 ;;1825
 ;;21,"63874-0406-60 ")
 ;;1826
 ;;21,"63874-0407-01 ")
 ;;1827
 ;;21,"63874-0407-10 ")
 ;;1828
 ;;21,"63874-0407-15 ")
 ;;1829
 ;;21,"63874-0407-20 ")
 ;;1830
 ;;21,"63874-0407-30 ")
 ;;1831
 ;;21,"63874-0407-60 ")
 ;;1832
 ;;21,"63874-0407-90 ")
 ;;1833
 ;;21,"63874-0454-01 ")
 ;;1834
 ;;21,"63874-0454-02 ")
 ;;1835
 ;;21,"63874-0454-04 ")
 ;;1836
 ;;21,"63874-0454-15 ")
 ;;1837
 ;;21,"63874-0454-20 ")
 ;;1838
 ;;21,"63874-0454-30 ")
 ;;1839
 ;;21,"63874-0454-60 ")
 ;;1840
 ;;21,"63874-0468-01 ")
 ;;1841
 ;;21,"63874-0468-10 ")
 ;;1842
 ;;21,"63874-0468-14 ")
 ;;1843
 ;;21,"63874-0468-15 ")
 ;;1844
 ;;21,"63874-0468-20 ")
 ;;1845
 ;;21,"63874-0468-30 ")
 ;;1846
 ;;21,"63874-0468-60 ")
 ;;1847
 ;;21,"63874-0468-90 ")
 ;;1848
 ;;21,"63874-0486-01 ")
 ;;1849
 ;;21,"63874-0486-02 ")
 ;;1850
 ;;21,"63874-0486-15 ")
 ;;1851
 ;;21,"63874-0486-30 ")
 ;;1852
 ;;21,"63874-0486-40 ")
 ;;1853
 ;;21,"63874-0486-60 ")
 ;;1854
 ;;21,"63874-0676-01 ")
 ;;1855
 ;;21,"63874-0676-12 ")
 ;;1856
 ;;21,"63874-0676-15 ")
 ;;1857
 ;;21,"63874-0676-20 ")
 ;;1858
 ;;21,"64376-0503-01 ")
 ;;1859
 ;;21,"64376-0503-10 ")
 ;;1860
 ;;21,"64679-0734-02 ")
 ;;1861
 ;;21,"64679-0734-03 ")
 ;;1862
 ;;21,"64679-0735-02 ")
 ;;1863
 ;;21,"64679-0735-03 ")
 ;;1864
 ;;21,"64679-0735-08 ")
 ;;1865
 ;;21,"64679-0736-02 ")
 ;;1866
 ;;21,"64679-0736-03 ")
 ;;1867
 ;;21,"64679-0736-08 ")
 ;;1868
 ;;21,"64679-0737-02 ")
 ;;1869
 ;;21,"64679-0737-03 ")
 ;;1870
 ;;21,"65162-0669-10 ")
 ;;1871
 ;;21,"65162-0670-10 ")
 ;;1872
 ;;21,"65162-0725-10 ")
 ;;1873
 ;;21,"65162-0727-10 ")
 ;;1874
 ;;21,"65162-0731-10 ")
 ;;1875
 ;;21,"65243-0014-03 ")
 ;;1876
 ;;21,"65243-0232-03 ")
 ;;1877
 ;;21,"65243-0265-03 ")
 ;;1878
 ;;21,"65243-0329-03 ")
 ;;1879
 ;;21,"65483-0391-10 ")
 ;;1880
 ;;21,"65483-0391-11 ")
 ;;1881
 ;;21,"65483-0391-50 ")
 ;;1882
 ;;21,"65483-0392-10 ")
 ;;1883
 ;;21,"65483-0392-22 ")
 ;;1884
 ;;21,"65483-0392-50 ")
 ;;1885
 ;;21,"65483-0393-10 ")
 ;;1886
 ;;21,"65483-0393-33 ")
 ;;1887
 ;;21,"65483-0393-50 ")
 ;;1888
 ;;21,"65726-0250-10 ")
 ;;1889
 ;;21,"65726-0250-25 ")
 ;;1890
 ;;21,"65726-0251-10 ")
 ;;1891
 ;;21,"65726-0251-25 ")
 ;;1892
 ;;21,"65862-0062-01 ")
 ;;1893
 ;;21,"65862-0062-99 ")
 ;;1894
 ;;21,"65862-0063-01 ")
 ;;1895
 ;;21,"65862-0063-99 ")
 ;;1896
 ;;21,"65862-0064-01 ")
 ;;1897
 ;;21,"65862-0064-99 ")
 ;;1898
 ;;21,"65862-0086-01 ")
 ;;1899
 ;;21,"65862-0086-30 ")
 ;;1900
 ;;21,"65862-0087-01 ")
 ;;1901
 ;;21,"65862-0087-30 ")
 ;;1902
 ;;21,"65862-0142-01 ")
 ;;1903
 ;;21,"65862-0142-05 ")
 ;;1904
 ;;21,"65862-0143-01 ")
 ;;1905
 ;;21,"65862-0143-05 ")
 ;;1906
 ;;21,"65862-0144-01 ")
 ;;1907
 ;;21,"65862-0144-05 ")
 ;;1908
 ;;21,"65862-0145-01 ")
 ;;1909
 ;;21,"65862-0145-05 ")
 ;;1910
 ;;21,"65862-0168-01 ")
 ;;1911
 ;;21,"65862-0168-99 ")
 ;;1912
 ;;21,"65862-0169-01 ")
 ;;1913
 ;;21,"65862-0169-99 ")
 ;;1914
 ;;21,"65862-0170-01 ")
 ;;1915
 ;;21,"65862-0170-99 ")
 ;;1916
 ;;21,"66105-0994-03 ")
 ;;1917
 ;;21,"66105-0994-06 ")
 ;;1918
 ;;21,"66105-0994-10 ")
 ;;1919
 ;;21,"66105-0994-11 ")
 ;;1920
 ;;21,"66105-0994-15 ")
 ;;1921
 ;;21,"66105-0996-03 ")
 ;;1922
 ;;21,"66105-0996-06 ")
 ;;1923
 ;;21,"66105-0996-10 ")
 ;;1924
 ;;21,"66105-0996-11 ")
 ;;1925
 ;;21,"66105-0996-15 ")
 ;;1926
 ;;21,"66267-0031-30 ")
 ;;1927
 ;;21,"66336-0514-30 ")
 ;;1928
 ;;21,"66336-0514-60 ")
 ;;1929
 ;;21,"66336-0523-30 ")
 ;;1930
 ;;21,"66336-0523-60 ")
 ;;1931
 ;;21,"66336-0587-00 ")
 ;;1932
 ;;21,"66336-0587-30 ")
 ;;1933
 ;;21,"66336-0587-60 ")
 ;;1934
 ;;21,"66336-0587-90 ")
 ;;1935
 ;;21,"66336-0612-90 ")
 ;;1936
 ;;21,"66336-0719-30 ")
 ;;1937
 ;;21,"66336-0719-60 ")
 ;;1938
 ;;21,"66336-0719-90 ")
 ;;1939
 ;;21,"66336-0772-30 ")
 ;;1940
 ;;21,"66336-0808-30 ")
 ;;1941
 ;;21,"66336-0808-60 ")
 ;;1942
 ;;21,"66336-0837-30 ")
 ;;1943
 ;;21,"66336-0914-30 ")
 ;;1944
 ;;21,"66336-0914-60 ")
 ;;1945
 ;;21,"66336-0914-90 ")
 ;;1946
 ;;21,"67046-0030-30 ")
 ;;1947
 ;;21,"67046-0475-30 ")
 ;;1948
 ;;21,"67046-0476-30 ")
 ;;1949
 ;;21,"67046-0590-60 ")
 ;;1950
 ;;21,"67253-0420-10 ")
 ;;1951
 ;;21,"67253-0420-11 ")
 ;;1952