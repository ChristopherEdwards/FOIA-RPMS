ATXXB27 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON APR 29, 2014;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"9WB4XLZ ")
 ;;10315
 ;;21,"9WB5XBZ ")
 ;;10316
 ;;21,"9WB5XCZ ")
 ;;10317
 ;;21,"9WB5XDZ ")
 ;;10318
 ;;21,"9WB5XFZ ")
 ;;10319
 ;;21,"9WB5XGZ ")
 ;;10320
 ;;21,"9WB5XHZ ")
 ;;10321
 ;;21,"9WB5XJZ ")
 ;;10322
 ;;21,"9WB5XKZ ")
 ;;10323
 ;;21,"9WB5XLZ ")
 ;;10324
 ;;21,"9WB6XBZ ")
 ;;10325
 ;;21,"9WB6XCZ ")
 ;;10326
 ;;21,"9WB6XDZ ")
 ;;10327
 ;;21,"9WB6XFZ ")
 ;;10328
 ;;21,"9WB6XGZ ")
 ;;10329
 ;;21,"9WB6XHZ ")
 ;;10330
 ;;21,"9WB6XJZ ")
 ;;10331
 ;;21,"9WB6XKZ ")
 ;;10332
 ;;21,"9WB6XLZ ")
 ;;10333
 ;;21,"9WB7XBZ ")
 ;;10334
 ;;21,"9WB7XCZ ")
 ;;10335
 ;;21,"9WB7XDZ ")
 ;;10336
 ;;21,"9WB7XFZ ")
 ;;10337
 ;;21,"9WB7XGZ ")
 ;;10338
 ;;21,"9WB7XHZ ")
 ;;10339
 ;;21,"9WB7XJZ ")
 ;;10340
 ;;21,"9WB7XKZ ")
 ;;10341
 ;;21,"9WB7XLZ ")
 ;;10342
 ;;21,"9WB8XBZ ")
 ;;10343
 ;;21,"9WB8XCZ ")
 ;;10344
 ;;21,"9WB8XDZ ")
 ;;10345
 ;;21,"9WB8XFZ ")
 ;;10346
 ;;21,"9WB8XGZ ")
 ;;10347
 ;;21,"9WB8XHZ ")
 ;;10348
 ;;21,"9WB8XJZ ")
 ;;10349
 ;;21,"9WB8XKZ ")
 ;;10350
 ;;21,"9WB8XLZ ")
 ;;10351
 ;;21,"9WB9XBZ ")
 ;;10352
 ;;21,"9WB9XCZ ")
 ;;10353
 ;;21,"9WB9XDZ ")
 ;;10354
 ;;21,"9WB9XFZ ")
 ;;10355
 ;;21,"9WB9XGZ ")
 ;;10356
 ;;21,"9WB9XHZ ")
 ;;10357
 ;;21,"9WB9XJZ ")
 ;;10358
 ;;21,"9WB9XKZ ")
 ;;10359
 ;;21,"9WB9XLZ ")
 ;;10360
 ;;21,"B00B0ZZ ")
 ;;10361
 ;;21,"B00B1ZZ ")
 ;;10362
 ;;21,"B00BYZZ ")
 ;;10363
 ;;21,"B00BZZZ ")
 ;;10364
 ;;21,"B01B0ZZ ")
 ;;10365
 ;;21,"B01B1ZZ ")
 ;;10366
 ;;21,"B01BYZZ ")
 ;;10367
 ;;21,"B01BZZZ ")
 ;;10368
 ;;21,"B02000Z ")
 ;;10369
 ;;21,"B0200ZZ ")
 ;;10370
 ;;21,"B02010Z ")
 ;;10371
 ;;21,"B0201ZZ ")
 ;;10372
 ;;21,"B020Y0Z ")
 ;;10373
 ;;21,"B020YZZ ")
 ;;10374
 ;;21,"B020ZZZ ")
 ;;10375
 ;;21,"B02700Z ")
 ;;10376
 ;;21,"B0270ZZ ")
 ;;10377
 ;;21,"B02710Z ")
 ;;10378
 ;;21,"B0271ZZ ")
 ;;10379
 ;;21,"B027Y0Z ")
 ;;10380
 ;;21,"B027YZZ ")
 ;;10381
 ;;21,"B027ZZZ ")
 ;;10382
 ;;21,"B02800Z ")
 ;;10383
 ;;21,"B0280ZZ ")
 ;;10384
 ;;21,"B02810Z ")
 ;;10385
 ;;21,"B0281ZZ ")
 ;;10386
 ;;21,"B028Y0Z ")
 ;;10387
 ;;21,"B028YZZ ")
 ;;10388
 ;;21,"B028ZZZ ")
 ;;10389
 ;;21,"B02900Z ")
 ;;10390
 ;;21,"B0290ZZ ")
 ;;10391
 ;;21,"B02910Z ")
 ;;10392
 ;;21,"B0291ZZ ")
 ;;10393
 ;;21,"B029Y0Z ")
 ;;10394
 ;;21,"B029YZZ ")
 ;;10395
 ;;21,"B029ZZZ ")
 ;;10396
 ;;21,"B02B00Z ")
 ;;10397
 ;;21,"B02B0ZZ ")
 ;;10398
 ;;21,"B02B10Z ")
 ;;10399
 ;;21,"B02B1ZZ ")
 ;;10400
 ;;21,"B02BY0Z ")
 ;;10401
 ;;21,"B02BYZZ ")
 ;;10402
 ;;21,"B02BZZZ ")
 ;;10403
 ;;21,"B030Y0Z ")
 ;;10404
 ;;21,"B030YZZ ")
 ;;10405
 ;;21,"B030ZZZ ")
 ;;10406
 ;;21,"B039Y0Z ")
 ;;10407
 ;;21,"B039YZZ ")
 ;;10408
 ;;21,"B039ZZZ ")
 ;;10409
 ;;21,"B03BY0Z ")
 ;;10410
 ;;21,"B03BYZZ ")
 ;;10411
 ;;21,"B03BZZZ ")
 ;;10412
 ;;21,"B03CY0Z ")
 ;;10413
 ;;21,"B03CYZZ ")
 ;;10414
 ;;21,"B03CZZZ ")
 ;;10415
 ;;21,"B040ZZZ ")
 ;;10416
 ;;21,"B04BZZZ ")
 ;;10417
 ;;21,"B2000ZZ ")
 ;;10418
 ;;21,"B2001ZZ ")
 ;;10419
 ;;21,"B200YZZ ")
 ;;10420
 ;;21,"B2010ZZ ")
 ;;10421
 ;;21,"B2011ZZ ")
 ;;10422
 ;;21,"B201YZZ ")
 ;;10423
 ;;21,"B2020ZZ ")
 ;;10424
 ;;21,"B2021ZZ ")
 ;;10425
 ;;21,"B202YZZ ")
 ;;10426
 ;;21,"B2030ZZ ")
 ;;10427
 ;;21,"B2031ZZ ")
 ;;10428
 ;;21,"B203YZZ ")
 ;;10429
 ;;21,"B2040ZZ ")
 ;;10430
 ;;21,"B2041ZZ ")
 ;;10431
 ;;21,"B204YZZ ")
 ;;10432
 ;;21,"B2050ZZ ")
 ;;10433
 ;;21,"B2051ZZ ")
 ;;10434
 ;;21,"B205YZZ ")
 ;;10435
 ;;21,"B2060ZZ ")
 ;;10436
 ;;21,"B2061ZZ ")
 ;;10437
 ;;21,"B206YZZ ")
 ;;10438
 ;;21,"B2070ZZ ")
 ;;10439
 ;;21,"B2071ZZ ")
 ;;10440
 ;;21,"B207YZZ ")
 ;;10441
 ;;21,"B2080ZZ ")
 ;;10442
 ;;21,"B2081ZZ ")
 ;;10443
 ;;21,"B208YZZ ")
 ;;10444
 ;;21,"B20F0ZZ ")
 ;;10445
 ;;21,"B20F1ZZ ")
 ;;10446
 ;;21,"B20FYZZ ")
 ;;10447
 ;;21,"B210010 ")
 ;;10448
 ;;21,"B2100ZZ ")
 ;;10449
 ;;21,"B210110 ")
 ;;10450
 ;;21,"B2101ZZ ")
 ;;10451
 ;;21,"B210Y10 ")
 ;;10452
 ;;21,"B210YZZ ")
 ;;10453
 ;;21,"B211010 ")
 ;;10454
 ;;21,"B2110ZZ ")
 ;;10455
 ;;21,"B211110 ")
 ;;10456
 ;;21,"B2111ZZ ")
 ;;10457
 ;;21,"B211Y10 ")
 ;;10458
 ;;21,"B211YZZ ")
 ;;10459
 ;;21,"B212010 ")
 ;;10460
 ;;21,"B2120ZZ ")
 ;;10461
 ;;21,"B212110 ")
 ;;10462
 ;;21,"B2121ZZ ")
 ;;10463
 ;;21,"B212Y10 ")
 ;;10464
 ;;21,"B212YZZ ")
 ;;10465
 ;;21,"B213010 ")
 ;;10466
 ;;21,"B2130ZZ ")
 ;;10467
 ;;21,"B213110 ")
 ;;10468
 ;;21,"B2131ZZ ")
 ;;10469
 ;;21,"B213Y10 ")
 ;;10470
 ;;21,"B213YZZ ")
 ;;10471
 ;;21,"B2140ZZ ")
 ;;10472
 ;;21,"B2141ZZ ")
 ;;10473
 ;;21,"B214YZZ ")
 ;;10474
 ;;21,"B2150ZZ ")
 ;;10475
 ;;21,"B2151ZZ ")
 ;;10476
 ;;21,"B215YZZ ")
 ;;10477
 ;;21,"B2160ZZ ")
 ;;10478
 ;;21,"B2161ZZ ")
 ;;10479
 ;;21,"B216YZZ ")
 ;;10480
 ;;21,"B2170ZZ ")
 ;;10481
 ;;21,"B2171ZZ ")
 ;;10482
 ;;21,"B217YZZ ")
 ;;10483
 ;;21,"B2180ZZ ")
 ;;10484
 ;;21,"B2181ZZ ")
 ;;10485
 ;;21,"B218YZZ ")
 ;;10486
 ;;21,"B21F0ZZ ")
 ;;10487
 ;;21,"B21F1ZZ ")
 ;;10488
 ;;21,"B21FYZZ ")
 ;;10489
 ;;21,"B22100Z ")
 ;;10490
 ;;21,"B2210ZZ ")
 ;;10491
 ;;21,"B22110Z ")
 ;;10492
 ;;21,"B2211ZZ ")
 ;;10493
 ;;21,"B221Y0Z ")
 ;;10494
 ;;21,"B221YZZ ")
 ;;10495
 ;;21,"B221ZZZ ")
 ;;10496
 ;;21,"B22300Z ")
 ;;10497
 ;;21,"B2230ZZ ")
 ;;10498
 ;;21,"B22310Z ")
 ;;10499
 ;;21,"B2231ZZ ")
 ;;10500
 ;;21,"B223Y0Z ")
 ;;10501
 ;;21,"B223YZZ ")
 ;;10502
 ;;21,"B223ZZZ ")
 ;;10503
 ;;21,"B22600Z ")
 ;;10504
 ;;21,"B2260ZZ ")
 ;;10505
 ;;21,"B22610Z ")
 ;;10506
 ;;21,"B2261ZZ ")
 ;;10507
 ;;21,"B226Y0Z ")
 ;;10508
 ;;21,"B226YZZ ")
 ;;10509
 ;;21,"B226ZZZ ")
 ;;10510
 ;;21,"B231Y0Z ")
 ;;10511
 ;;21,"B231YZZ ")
 ;;10512
 ;;21,"B231ZZZ ")
 ;;10513
 ;;21,"B233Y0Z ")
 ;;10514
 ;;21,"B233YZZ ")
 ;;10515
 ;;21,"B233ZZZ ")
 ;;10516
 ;;21,"B236Y0Z ")
 ;;10517
 ;;21,"B236YZZ ")
 ;;10518
 ;;21,"B236ZZZ ")
 ;;10519
 ;;21,"B240YZZ ")
 ;;10520
 ;;21,"B240ZZ4 ")
 ;;10521
 ;;21,"B240ZZZ ")
 ;;10522
 ;;21,"B241YZZ ")
 ;;10523
 ;;21,"B241ZZ4 ")
 ;;10524
 ;;21,"B241ZZZ ")
 ;;10525
 ;;21,"B244YZZ ")
 ;;10526
 ;;21,"B244ZZ4 ")
 ;;10527
 ;;21,"B244ZZZ ")
 ;;10528
 ;;21,"B245YZZ ")
 ;;10529
 ;;21,"B245ZZ4 ")
 ;;10530
 ;;21,"B245ZZZ ")
 ;;10531
 ;;21,"B246YZZ ")
 ;;10532
 ;;21,"B246ZZ4 ")
 ;;10533
 ;;21,"B246ZZZ ")
 ;;10534
 ;;21,"B24BYZZ ")
 ;;10535
 ;;21,"B24BZZ4 ")
 ;;10536
 ;;21,"B24BZZZ ")
 ;;10537
 ;;21,"B24CYZZ ")
 ;;10538
 ;;21,"B24CZZ4 ")
 ;;10539
 ;;21,"B24CZZZ ")
 ;;10540
 ;;21,"B24DYZZ ")
 ;;10541
 ;;21,"B24DZZ4 ")
 ;;10542
 ;;21,"B24DZZZ ")
 ;;10543
 ;;21,"B3000ZZ ")
 ;;10544
 ;;21,"B3001ZZ ")
 ;;10545
 ;;21,"B300YZZ ")
 ;;10546
 ;;21,"B300ZZZ ")
 ;;10547
 ;;21,"B3010ZZ ")
 ;;10548
 ;;21,"B3011ZZ ")
 ;;10549
 ;;21,"B301YZZ ")
 ;;10550
 ;;21,"B301ZZZ ")
 ;;10551
 ;;21,"B3020ZZ ")
 ;;10552
 ;;21,"B3021ZZ ")
 ;;10553
 ;;21,"B302YZZ ")
 ;;10554
 ;;21,"B302ZZZ ")
 ;;10555
 ;;21,"B3030ZZ ")
 ;;10556
 ;;21,"B3031ZZ ")
 ;;10557
 ;;21,"B303YZZ ")
 ;;10558
 ;;21,"B303ZZZ ")
 ;;10559
 ;;21,"B3040ZZ ")
 ;;10560
 ;;21,"B3041ZZ ")
 ;;10561
 ;;21,"B304YZZ ")
 ;;10562
 ;;21,"B304ZZZ ")
 ;;10563
 ;;21,"B3050ZZ ")
 ;;10564
 ;;21,"B3051ZZ ")
 ;;10565
 ;;21,"B305YZZ ")
 ;;10566
 ;;21,"B305ZZZ ")
 ;;10567
 ;;21,"B3060ZZ ")
 ;;10568
 ;;21,"B3061ZZ ")
 ;;10569
 ;;21,"B306YZZ ")
 ;;10570
 ;;21,"B306ZZZ ")
 ;;10571
 ;;21,"B3070ZZ ")
 ;;10572
 ;;21,"B3071ZZ ")
 ;;10573
 ;;21,"B307YZZ ")
 ;;10574
 ;;21,"B307ZZZ ")
 ;;10575
 ;;21,"B3080ZZ ")
 ;;10576
 ;;21,"B3081ZZ ")
 ;;10577
 ;;21,"B308YZZ ")
 ;;10578
 ;;21,"B308ZZZ ")
 ;;10579
 ;;21,"B3090ZZ ")
 ;;10580
 ;;21,"B3091ZZ ")
 ;;10581
 ;;21,"B309YZZ ")
 ;;10582
 ;;21,"B309ZZZ ")
 ;;10583
 ;;21,"B30B0ZZ ")
 ;;10584
 ;;21,"B30B1ZZ ")
 ;;10585
 ;;21,"B30BYZZ ")
 ;;10586
 ;;21,"B30BZZZ ")
 ;;10587
 ;;21,"B30C0ZZ ")
 ;;10588
 ;;21,"B30C1ZZ ")
 ;;10589
 ;;21,"B30CYZZ ")
 ;;10590
 ;;21,"B30CZZZ ")
 ;;10591
 ;;21,"B30D0ZZ ")
 ;;10592
 ;;21,"B30D1ZZ ")
 ;;10593
 ;;21,"B30DYZZ ")
 ;;10594
 ;;21,"B30DZZZ ")
 ;;10595
 ;;21,"B30F0ZZ ")
 ;;10596
 ;;21,"B30F1ZZ ")
 ;;10597
 ;;21,"B30FYZZ ")
 ;;10598
 ;;21,"B30FZZZ ")
 ;;10599
 ;;21,"B30G0ZZ ")
 ;;10600
 ;;21,"B30G1ZZ ")
 ;;10601
 ;;21,"B30GYZZ ")
 ;;10602
 ;;21,"B30GZZZ ")
 ;;10603
 ;;21,"B30H0ZZ ")
 ;;10604
 ;;21,"B30H1ZZ ")
 ;;10605
 ;;21,"B30HYZZ ")
 ;;10606
 ;;21,"B30HZZZ ")
 ;;10607
 ;;21,"B30J0ZZ ")
 ;;10608
 ;;21,"B30J1ZZ ")
 ;;10609
 ;;21,"B30JYZZ ")
 ;;10610
 ;;21,"B30JZZZ ")
 ;;10611
 ;;21,"B30K0ZZ ")
 ;;10612
 ;;21,"B30K1ZZ ")
 ;;10613
 ;;21,"B30KYZZ ")
 ;;10614
 ;;21,"B30KZZZ ")
 ;;10615
 ;;21,"B30L0ZZ ")
 ;;10616
 ;;21,"B30L1ZZ ")
 ;;10617
 ;;21,"B30LYZZ ")
 ;;10618
 ;;21,"B30LZZZ ")
 ;;10619
 ;;21,"B30M0ZZ ")
 ;;10620
 ;;21,"B30M1ZZ ")
 ;;10621
 ;;21,"B30MYZZ ")
 ;;10622
 ;;21,"B30MZZZ ")
 ;;10623
 ;;21,"B30N0ZZ ")
 ;;10624
 ;;21,"B30N1ZZ ")
 ;;10625
 ;;21,"B30NYZZ ")
 ;;10626
 ;;21,"B30NZZZ ")
 ;;10627
 ;;21,"B30P0ZZ ")
 ;;10628
 ;;21,"B30P1ZZ ")
 ;;10629
 ;;21,"B30PYZZ ")
 ;;10630
 ;;21,"B30PZZZ ")
 ;;10631
 ;;21,"B30Q0ZZ ")
 ;;10632
 ;;21,"B30Q1ZZ ")
 ;;10633
 ;;21,"B30QYZZ ")
 ;;10634
 ;;21,"B30QZZZ ")
 ;;10635
 ;;21,"B30R0ZZ ")
 ;;10636
 ;;21,"B30R1ZZ ")
 ;;10637
 ;;21,"B30RYZZ ")
 ;;10638
 ;;21,"B30RZZZ ")
 ;;10639
 ;;21,"B30S0ZZ ")
 ;;10640
 ;;21,"B30S1ZZ ")
 ;;10641
 ;;21,"B30SYZZ ")
 ;;10642
 ;;21,"B30SZZZ ")
 ;;10643
 ;;21,"B30T0ZZ ")
 ;;10644
 ;;21,"B30T1ZZ ")
 ;;10645
 ;;21,"B30TYZZ ")
 ;;10646
 ;;21,"B30TZZZ ")
 ;;10647
 ;;21,"B3100ZZ ")
 ;;10648
 ;;21,"B3101ZZ ")
 ;;10649
 ;;21,"B310YZZ ")
 ;;10650
 ;;21,"B310ZZZ ")
 ;;10651
 ;;21,"B3110ZZ ")
 ;;10652
 ;;21,"B3111ZZ ")
 ;;10653
 ;;21,"B311YZZ ")
 ;;10654
 ;;21,"B311ZZZ ")
 ;;10655
 ;;21,"B3120ZZ ")
 ;;10656
 ;;21,"B3121ZZ ")
 ;;10657
 ;;21,"B312YZZ ")
 ;;10658
 ;;21,"B312ZZZ ")
 ;;10659
 ;;21,"B3130ZZ ")
 ;;10660
 ;;21,"B3131ZZ ")
 ;;10661
 ;;21,"B313YZZ ")
 ;;10662
 ;;21,"B313ZZZ ")
 ;;10663
 ;;21,"B3140ZZ ")
 ;;10664
 ;;21,"B3141ZZ ")
 ;;10665
 ;;21,"B314YZZ ")
 ;;10666
 ;;21,"B314ZZZ ")
 ;;10667
 ;;21,"B3150ZZ ")
 ;;10668
 ;;21,"B3151ZZ ")
 ;;10669
 ;;21,"B315YZZ ")
 ;;10670
 ;;21,"B315ZZZ ")
 ;;10671
 ;;21,"B3160ZZ ")
 ;;10672
 ;;21,"B3161ZZ ")
 ;;10673
 ;;21,"B316YZZ ")
 ;;10674
 ;;21,"B316ZZZ ")
 ;;10675
 ;;21,"B3170ZZ ")
 ;;10676
 ;;21,"B3171ZZ ")
 ;;10677
 ;;21,"B317YZZ ")
 ;;10678
 ;;21,"B317ZZZ ")
 ;;10679
 ;;21,"B3180ZZ ")
 ;;10680
 ;;21,"B3181ZZ ")
 ;;10681
 ;;21,"B318YZZ ")
 ;;10682
 ;;21,"B318ZZZ ")
 ;;10683
 ;;21,"B3190ZZ ")
 ;;10684
 ;;21,"B3191ZZ ")
 ;;10685
 ;;21,"B319YZZ ")
 ;;10686
 ;;21,"B319ZZZ ")
 ;;10687
 ;;21,"B31B0ZZ ")
 ;;10688
 ;;21,"B31B1ZZ ")
 ;;10689
 ;;21,"B31BYZZ ")
 ;;10690
 ;;21,"B31BZZZ ")
 ;;10691
 ;;21,"B31C0ZZ ")
 ;;10692
 ;;21,"B31C1ZZ ")
 ;;10693
 ;;21,"B31CYZZ ")
 ;;10694
 ;;21,"B31CZZZ ")
 ;;10695
 ;;21,"B31D0ZZ ")
 ;;10696
 ;;21,"B31D1ZZ ")
 ;;10697
 ;;21,"B31DYZZ ")
 ;;10698