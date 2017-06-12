BGP53J2 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON FEB 23, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00247-1813-04 ")
 ;;394
 ;;21,"00247-1813-08 ")
 ;;395
 ;;21,"00247-1813-30 ")
 ;;396
 ;;21,"00247-1814-08 ")
 ;;397
 ;;21,"00247-1814-14 ")
 ;;398
 ;;21,"00247-1814-30 ")
 ;;399
 ;;21,"00247-1843-03 ")
 ;;400
 ;;21,"00247-1843-07 ")
 ;;401
 ;;21,"00247-1843-08 ")
 ;;402
 ;;21,"00247-1843-14 ")
 ;;403
 ;;21,"00247-1850-04 ")
 ;;404
 ;;21,"00247-1850-08 ")
 ;;405
 ;;21,"00247-1850-30 ")
 ;;406
 ;;21,"00247-1893-00 ")
 ;;407
 ;;21,"00247-1893-07 ")
 ;;408
 ;;21,"00247-1893-30 ")
 ;;409
 ;;21,"00247-1893-60 ")
 ;;410
 ;;21,"00247-1893-77 ")
 ;;411
 ;;21,"00247-1893-90 ")
 ;;412
 ;;21,"00247-1894-07 ")
 ;;413
 ;;21,"00247-1894-30 ")
 ;;414
 ;;21,"00247-1894-60 ")
 ;;415
 ;;21,"00247-1894-77 ")
 ;;416
 ;;21,"00247-1894-90 ")
 ;;417
 ;;21,"00247-1915-03 ")
 ;;418
 ;;21,"00247-1915-07 ")
 ;;419
 ;;21,"00247-1915-30 ")
 ;;420
 ;;21,"00247-1915-90 ")
 ;;421
 ;;21,"00247-1918-15 ")
 ;;422
 ;;21,"00247-1918-30 ")
 ;;423
 ;;21,"00247-1961-00 ")
 ;;424
 ;;21,"00247-1961-14 ")
 ;;425
 ;;21,"00247-1961-30 ")
 ;;426
 ;;21,"00247-1961-60 ")
 ;;427
 ;;21,"00247-1964-30 ")
 ;;428
 ;;21,"00247-1964-90 ")
 ;;429
 ;;21,"00247-1965-00 ")
 ;;430
 ;;21,"00247-1965-03 ")
 ;;431
 ;;21,"00247-1965-14 ")
 ;;432
 ;;21,"00247-1965-30 ")
 ;;433
 ;;21,"00247-1965-60 ")
 ;;434
 ;;21,"00247-1965-90 ")
 ;;435
 ;;21,"00247-1965-99 ")
 ;;436
 ;;21,"00247-2052-00 ")
 ;;437
 ;;21,"00247-2052-07 ")
 ;;438
 ;;21,"00247-2052-30 ")
 ;;439
 ;;21,"00247-2052-90 ")
 ;;440
 ;;21,"00247-2077-30 ")
 ;;441
 ;;21,"00247-2077-60 ")
 ;;442
 ;;21,"00247-2083-30 ")
 ;;443
 ;;21,"00247-2083-60 ")
 ;;444
 ;;21,"00247-2083-90 ")
 ;;445
 ;;21,"00247-2084-30 ")
 ;;446
 ;;21,"00247-2084-60 ")
 ;;447
 ;;21,"00247-2085-30 ")
 ;;448
 ;;21,"00247-2094-30 ")
 ;;449
 ;;21,"00247-2094-90 ")
 ;;450
 ;;21,"00247-2117-30 ")
 ;;451
 ;;21,"00247-2132-00 ")
 ;;452
 ;;21,"00247-2132-07 ")
 ;;453
 ;;21,"00247-2132-30 ")
 ;;454
 ;;21,"00247-2132-60 ")
 ;;455
 ;;21,"00247-2132-90 ")
 ;;456
 ;;21,"00247-2133-00 ")
 ;;457
 ;;21,"00247-2133-07 ")
 ;;458
 ;;21,"00247-2133-30 ")
 ;;459
 ;;21,"00247-2133-60 ")
 ;;460
 ;;21,"00247-2133-90 ")
 ;;461
 ;;21,"00247-2134-00 ")
 ;;462
 ;;21,"00247-2134-07 ")
 ;;463
 ;;21,"00247-2134-30 ")
 ;;464
 ;;21,"00247-2134-60 ")
 ;;465
 ;;21,"00247-2134-90 ")
 ;;466
 ;;21,"00247-2262-30 ")
 ;;467
 ;;21,"00247-2265-30 ")
 ;;468
 ;;21,"00247-2265-60 ")
 ;;469
 ;;21,"00247-2265-90 ")
 ;;470
 ;;21,"00247-2271-30 ")
 ;;471
 ;;21,"00247-2272-00 ")
 ;;472
 ;;21,"00247-2272-30 ")
 ;;473
 ;;21,"00247-2272-60 ")
 ;;474
 ;;21,"00247-2272-90 ")
 ;;475
 ;;21,"00247-2299-00 ")
 ;;476
 ;;21,"00247-2299-90 ")
 ;;477
 ;;21,"00247-2314-00 ")
 ;;478
 ;;21,"00247-2314-30 ")
 ;;479
 ;;21,"00247-2314-60 ")
 ;;480
 ;;21,"00247-2314-77 ")
 ;;481
 ;;21,"00247-2314-90 ")
 ;;482
 ;;21,"00247-2337-30 ")
 ;;483
 ;;21,"00247-2337-60 ")
 ;;484
 ;;21,"00247-2337-90 ")
 ;;485
 ;;21,"00247-2356-00 ")
 ;;486
 ;;21,"00247-2356-30 ")
 ;;487
 ;;21,"00258-3695-01 ")
 ;;488
 ;;21,"00258-3695-05 ")
 ;;489
 ;;21,"00258-3696-01 ")
 ;;490
 ;;21,"00258-3697-01 ")
 ;;491
 ;;21,"00378-0042-01 ")
 ;;492
 ;;21,"00378-0060-01 ")
 ;;493
 ;;21,"00378-0073-01 ")
 ;;494
 ;;21,"00378-0087-01 ")
 ;;495
 ;;21,"00378-0092-01 ")
 ;;496
 ;;21,"00378-0211-01 ")
 ;;497
 ;;21,"00378-0211-05 ")
 ;;498
 ;;21,"00378-0277-01 ")
 ;;499
 ;;21,"00378-0277-05 ")
 ;;500
 ;;21,"00378-0330-01 ")
 ;;501
 ;;21,"00378-0330-05 ")
 ;;502
 ;;21,"00378-0407-01 ")
 ;;503
 ;;21,"00378-0412-01 ")
 ;;504
 ;;21,"00378-0414-01 ")
 ;;505
 ;;21,"00378-0433-01 ")
 ;;506
 ;;21,"00378-0433-05 ")
 ;;507
 ;;21,"00378-0435-01 ")
 ;;508
 ;;21,"00378-0435-05 ")
 ;;509
 ;;21,"00378-0442-01 ")
 ;;510
 ;;21,"00378-0442-05 ")
 ;;511
 ;;21,"00378-0574-01 ")
 ;;512
 ;;21,"00378-0574-05 ")
 ;;513
 ;;21,"00378-0734-01 ")
 ;;514
 ;;21,"00378-0734-93 ")
 ;;515
 ;;21,"00378-0735-01 ")
 ;;516
 ;;21,"00378-0735-93 ")
 ;;517
 ;;21,"00378-1049-01 ")
 ;;518
 ;;21,"00378-1049-10 ")
 ;;519
 ;;21,"00378-2003-05 ")
 ;;520
 ;;21,"00378-2003-93 ")
 ;;521
 ;;21,"00378-2004-05 ")
 ;;522
 ;;21,"00378-2004-93 ")
 ;;523
 ;;21,"00378-2005-93 ")
 ;;524
 ;;21,"00378-2006-93 ")
 ;;525
 ;;21,"00378-2008-77 ")
 ;;526
 ;;21,"00378-2009-05 ")
 ;;527
 ;;21,"00378-2610-01 ")
 ;;528
 ;;21,"00378-2610-10 ")
 ;;529
 ;;21,"00378-2625-01 ")
 ;;530
 ;;21,"00378-2625-10 ")
 ;;531
 ;;21,"00378-2650-01 ")
 ;;532
 ;;21,"00378-2650-10 ")
 ;;533
 ;;21,"00378-2675-01 ")
 ;;534
 ;;21,"00378-2675-93 ")
 ;;535
 ;;21,"00378-2685-01 ")
 ;;536
 ;;21,"00378-2685-93 ")
 ;;537
 ;;21,"00378-2695-01 ")
 ;;538
 ;;21,"00378-2695-93 ")
 ;;539
 ;;21,"00378-3025-01 ")
 ;;540
 ;;21,"00378-3050-01 ")
 ;;541
 ;;21,"00378-3075-01 ")
 ;;542
 ;;21,"00378-3125-01 ")
 ;;543
 ;;21,"00378-3125-10 ")
 ;;544
 ;;21,"00378-3411-01 ")
 ;;545
 ;;21,"00378-3411-05 ")
 ;;546
 ;;21,"00378-3412-01 ")
 ;;547
 ;;21,"00378-3412-05 ")
 ;;548
 ;;21,"00378-3413-01 ")
 ;;549
 ;;21,"00378-3413-05 ")
 ;;550
 ;;21,"00378-3471-01 ")
 ;;551
 ;;21,"00378-3472-01 ")
 ;;552
 ;;21,"00378-3472-10 ")
 ;;553
 ;;21,"00378-3473-01 ")
 ;;554
 ;;21,"00378-3473-10 ")
 ;;555
 ;;21,"00378-3474-01 ")
 ;;556
 ;;21,"00378-3515-10 ")
 ;;557
 ;;21,"00378-3515-93 ")
 ;;558
 ;;21,"00378-3530-05 ")
 ;;559
 ;;21,"00378-3530-93 ")
 ;;560
 ;;21,"00378-3545-05 ")
 ;;561
 ;;21,"00378-3545-93 ")
 ;;562
 ;;21,"00378-3855-77 ")
 ;;563
 ;;21,"00378-3855-93 ")
 ;;564
 ;;21,"00378-3856-10 ")
 ;;565
 ;;21,"00378-3856-77 ")
 ;;566
 ;;21,"00378-3856-93 ")
 ;;567
 ;;21,"00378-3857-10 ")
 ;;568
 ;;21,"00378-3857-77 ")
 ;;569
 ;;21,"00378-3857-93 ")
 ;;570
 ;;21,"00378-4186-01 ")
 ;;571
 ;;21,"00378-4186-05 ")
 ;;572
 ;;21,"00378-4186-93 ")
 ;;573
 ;;21,"00378-4187-01 ")
 ;;574
 ;;21,"00378-4187-05 ")
 ;;575
 ;;21,"00378-4187-93 ")
 ;;576
 ;;21,"00378-4188-01 ")
 ;;577
 ;;21,"00378-4188-05 ")
 ;;578
 ;;21,"00378-4188-93 ")
 ;;579
 ;;21,"00378-4210-01 ")
 ;;580
 ;;21,"00378-4220-01 ")
 ;;581
 ;;21,"00378-4250-01 ")
 ;;582
 ;;21,"00378-4250-10 ")
 ;;583
 ;;21,"00378-4350-93 ")
 ;;584
 ;;21,"00378-4881-01 ")
 ;;585
 ;;21,"00378-4882-01 ")
 ;;586
 ;;21,"00378-4883-01 ")
 ;;587
 ;;21,"00378-4884-01 ")
 ;;588
 ;;21,"00378-4885-01 ")
 ;;589
 ;;21,"00378-5131-05 ")
 ;;590
 ;;21,"00378-5132-05 ")
 ;;591
 ;;21,"00378-5133-05 ")
 ;;592
 ;;21,"00378-5375-01 ")
 ;;593
 ;;21,"00378-5375-10 ")
 ;;594
 ;;21,"00378-5410-28 ")
 ;;595
 ;;21,"00378-5420-28 ")
 ;;596
 ;;21,"00378-5521-01 ")
 ;;597
 ;;21,"00378-6231-01 ")
 ;;598
 ;;21,"00378-6231-05 ")
 ;;599
 ;;21,"00378-6232-01 ")
 ;;600
 ;;21,"00378-6232-05 ")
 ;;601
 ;;21,"00378-6233-01 ")
 ;;602
 ;;21,"00378-6233-05 ")
 ;;603
 ;;21,"00378-6410-01 ")
 ;;604
 ;;21,"00378-6410-10 ")
 ;;605
 ;;21,"00378-7001-10 ")
 ;;606
 ;;21,"00378-7001-93 ")
 ;;607
 ;;21,"00378-7002-10 ")
 ;;608
 ;;21,"00378-7002-93 ")
 ;;609
 ;;21,"00378-7003-10 ")
 ;;610
 ;;21,"00378-7003-93 ")
 ;;611
 ;;21,"00378-7004-10 ")
 ;;612
 ;;21,"00378-7004-93 ")
 ;;613
 ;;21,"00378-8011-01 ")
 ;;614
 ;;21,"00378-8011-05 ")
 ;;615
 ;;21,"00378-8121-01 ")
 ;;616
 ;;21,"00378-8121-05 ")
 ;;617
 ;;21,"00378-8127-01 ")
 ;;618
 ;;21,"00378-8127-05 ")
 ;;619
 ;;21,"00406-0661-01 ")
 ;;620
 ;;21,"00406-0661-05 ")
 ;;621
 ;;21,"00406-0661-91 ")
 ;;622
 ;;21,"00406-0663-01 ")
 ;;623
 ;;21,"00406-0663-03 ")
 ;;624
 ;;21,"00406-0663-05 ")
 ;;625
 ;;21,"00406-0663-62 ")
 ;;626
 ;;21,"00406-0663-91 ")
 ;;627
 ;;21,"00406-0667-01 ")
 ;;628
 ;;21,"00406-2001-03 ")
 ;;629
 ;;21,"00406-2001-05 ")
 ;;630
 ;;21,"00406-2001-90 ")
 ;;631
 ;;21,"00406-2097-03 ")
 ;;632
 ;;21,"00406-2097-05 ")
 ;;633
 ;;21,"00406-2097-90 ")
 ;;634
 ;;21,"00406-2098-01 ")
 ;;635
 ;;21,"00406-2098-03 ")
 ;;636
 ;;21,"00406-2098-05 ")
 ;;637
 ;;21,"00406-2098-90 ")
 ;;638
 ;;21,"00406-2099-03 ")
 ;;639
 ;;21,"00406-2099-05 ")
 ;;640
 ;;21,"00406-2099-90 ")
 ;;641
 ;;21,"00406-9906-01 ")
 ;;642
 ;;21,"00406-9906-03 ")
 ;;643
 ;;21,"00406-9906-62 ")
 ;;644
 ;;21,"00406-9907-01 ")
 ;;645
 ;;21,"00406-9907-03 ")
 ;;646
 ;;21,"00406-9907-62 ")
 ;;647
 ;;21,"00406-9908-01 ")
 ;;648
 ;;21,"00406-9908-03 ")
 ;;649
 ;;21,"00406-9910-01 ")
 ;;650
 ;;21,"00406-9910-03 ")
 ;;651
 ;;21,"00406-9911-01 ")
 ;;652
 ;;21,"00406-9911-03 ")
 ;;653
 ;;21,"00406-9912-01 ")
 ;;654
 ;;21,"00406-9912-03 ")
 ;;655
 ;;21,"00406-9913-01 ")
 ;;656
 ;;21,"00406-9913-03 ")
 ;;657
 ;;21,"00406-9920-03 ")
 ;;658
 ;;21,"00406-9921-03 ")
 ;;659
 ;;21,"00406-9922-01 ")
 ;;660
 ;;21,"00406-9922-03 ")
 ;;661
 ;;21,"00406-9923-01 ")
 ;;662
 ;;21,"00406-9923-03 ")
 ;;663
 ;;21,"00406-9924-01 ")
 ;;664
 ;;21,"00406-9924-03 ")
 ;;665
 ;;21,"00406-9925-01 ")
 ;;666
 ;;21,"00406-9925-03 ")
 ;;667
 ;;21,"00406-9926-01 ")
 ;;668
 ;;21,"00406-9926-03 ")
 ;;669
 ;;21,"00406-9931-03 ")
 ;;670
 ;;21,"00406-9932-03 ")
 ;;671
 ;;21,"00406-9933-03 ")
 ;;672
 ;;21,"00406-9934-03 ")
 ;;673
 ;;21,"00430-0210-14 ")
 ;;674
 ;;21,"00430-0215-14 ")
 ;;675
 ;;21,"00430-0220-14 ")
 ;;676
 ;;21,"00440-7090-30 ")
 ;;677
 ;;21,"00440-7091-30 ")
 ;;678
 ;;21,"00440-7092-30 ")
 ;;679
 ;;21,"00440-7477-30 ")
 ;;680
 ;;21,"00440-7478-30 ")
 ;;681
 ;;21,"00440-7521-30 ")
 ;;682
 ;;21,"00440-8575-20 ")
 ;;683
 ;;21,"00440-8576-30 ")
 ;;684
 ;;21,"00456-1100-31 ")
 ;;685
 ;;21,"00456-1110-30 ")
 ;;686
 ;;21,"00456-1120-30 ")
 ;;687
 ;;21,"00456-1140-30 ")
 ;;688
 ;;21,"00456-2005-01 ")
 ;;689
 ;;21,"00456-2010-01 ")
 ;;690
 ;;21,"00456-2010-11 ")
 ;;691
 ;;21,"00456-2010-63 ")
 ;;692
 ;;21,"00456-2020-01 ")
 ;;693
 ;;21,"00456-2020-11 ")
 ;;694
 ;;21,"00456-2020-63 ")
 ;;695
 ;;21,"00456-2101-08 ")
 ;;696
 ;;21,"00456-4010-01 ")
 ;;697
 ;;21,"00456-4020-01 ")
 ;;698
 ;;21,"00456-4020-63 ")
 ;;699
 ;;21,"00456-4040-01 ")
 ;;700
 ;;21,"00456-4130-08 ")
 ;;701
 ;;21,"00490-0034-00 ")
 ;;702
 ;;21,"00490-0034-30 ")
 ;;703
 ;;21,"00490-0034-60 ")
 ;;704
 ;;21,"00490-0034-90 ")
 ;;705
 ;;21,"00490-0114-00 ")
 ;;706
 ;;21,"00490-0114-30 ")
 ;;707
 ;;21,"00490-0114-60 ")
 ;;708
 ;;21,"00490-0114-90 ")
 ;;709
 ;;21,"00490-0163-00 ")
 ;;710
 ;;21,"00490-0163-30 ")
 ;;711
 ;;21,"00490-0163-60 ")
 ;;712
 ;;21,"00490-0163-90 ")
 ;;713
 ;;21,"00555-0201-01 ")
 ;;714
 ;;21,"00555-0241-71 ")
 ;;715
 ;;21,"00555-0242-71 ")
 ;;716
 ;;21,"00555-0489-02 ")
 ;;717
 ;;21,"00555-0489-04 ")
 ;;718
 ;;21,"00555-0490-02 ")
 ;;719
 ;;21,"00555-0490-04 ")
 ;;720
 ;;21,"00555-0594-02 ")
 ;;721
 ;;21,"00555-0595-02 ")
 ;;722
 ;;21,"00555-0732-02 ")
 ;;723
 ;;21,"00555-0732-04 ")
 ;;724
 ;;21,"00555-0733-02 ")
 ;;725
 ;;21,"00555-0871-54 ")
 ;;726
 ;;21,"00555-0871-88 ")
 ;;727
 ;;21,"00555-0876-02 ")
 ;;728
 ;;21,"00555-0877-02 ")
 ;;729
 ;;21,"00555-0877-04 ")
 ;;730
 ;;21,"00555-0877-05 ")
 ;;731
 ;;21,"00555-0877-07 ")
 ;;732
 ;;21,"00555-0967-02 ")
 ;;733
 ;;21,"00555-0968-02 ")
 ;;734
 ;;21,"00555-0969-02 ")
 ;;735
 ;;21,"00591-0764-60 ")
 ;;736
 ;;21,"00591-0767-60 ")
 ;;737
 ;;21,"00591-0809-01 ")
 ;;738
 ;;21,"00591-0809-05 ")
 ;;739
 ;;21,"00591-0839-25 ")
 ;;740
 ;;21,"00591-0839-60 ")
 ;;741
 ;;21,"00591-0858-60 ")
 ;;742
 ;;21,"00591-1117-10 ")
 ;;743
 ;;21,"00591-1117-30 ")
 ;;744
 ;;21,"00591-1118-10 ")
 ;;745
 ;;21,"00591-1118-30 ")
 ;;746
 ;;21,"00591-1119-30 ")
 ;;747
 ;;21,"00591-2114-01 ")
 ;;748
 ;;21,"00591-2230-15 ")
 ;;749
 ;;21,"00591-2231-15 ")
 ;;750
 ;;21,"00591-2469-15 ")
 ;;751
 ;;21,"00591-2470-15 ")
 ;;752
 ;;21,"00591-3176-01 ")
 ;;753
 ;;21,"00591-3176-05 ")
 ;;754
 ;;21,"00591-3177-01 ")
 ;;755
 ;;21,"00591-3177-05 ")
 ;;756
 ;;21,"00591-3178-01 ")
 ;;757
 ;;21,"00591-3178-05 ")
 ;;758
 ;;21,"00591-3331-05 ")
 ;;759
 ;;21,"00591-3331-19 ")
 ;;760
 ;;21,"00591-3331-30 ")
 ;;761
 ;;21,"00591-3332-05 ")
 ;;762
 ;;21,"00591-3332-30 ")
 ;;763
 ;;21,"00591-3540-05 ")
 ;;764
 ;;21,"00591-3540-60 ")
 ;;765
 ;;21,"00591-3541-05 ")
 ;;766
 ;;21,"00591-3541-25 ")
 ;;767
 ;;21,"00591-3541-60 ")
 ;;768
 ;;21,"00591-3542-60 ")
 ;;769
 ;;21,"00591-3543-60 ")
 ;;770
 ;;21,"00591-3543-76 ")
 ;;771
 ;;21,"00591-5599-01 ")
 ;;772
 ;;21,"00591-5599-10 ")
 ;;773
 ;;21,"00591-5600-01 ")
 ;;774
 ;;21,"00591-5600-10 ")
 ;;775
 ;;21,"00591-5629-01 ")
 ;;776
 ;;21,"00591-5631-01 ")
 ;;777
 ;;21,"00591-5631-10 ")
 ;;778
 ;;21,"00591-5632-01 ")
 ;;779
 ;;21,"00591-5633-01 ")
 ;;780
 ;;21,"00591-5713-01 ")
 ;;781
 ;;21,"00591-5714-01 ")
 ;;782
 ;;21,"00591-5715-01 ")
 ;;783
 ;;21,"00591-5716-30 ")
 ;;784
 ;;21,"00591-5786-01 ")
 ;;785
 ;;21,"00591-5786-05 ")
 ;;786
 ;;21,"00591-5787-01 ")
 ;;787
 ;;21,"00591-5787-05 ")
 ;;788
 ;;21,"00591-5787-10 ")
 ;;789