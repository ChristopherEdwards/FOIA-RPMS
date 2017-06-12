BGP61V2 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"51426-5 ")
 ;;440
 ;;21,"51596-5 ")
 ;;441
 ;;21,"51597-3 ")
 ;;442
 ;;21,"51766-4 ")
 ;;443
 ;;21,"51767-2 ")
 ;;444
 ;;21,"51768-0 ")
 ;;445
 ;;21,"51769-8 ")
 ;;446
 ;;21,"53049-3 ")
 ;;447
 ;;21,"53093-1 ")
 ;;448
 ;;21,"53094-9 ")
 ;;449
 ;;21,"53474-3 ")
 ;;450
 ;;21,"53475-0 ")
 ;;451
 ;;21,"53476-8 ")
 ;;452
 ;;21,"53480-0 ")
 ;;453
 ;;21,"53481-8 ")
 ;;454
 ;;21,"53482-6 ")
 ;;455
 ;;21,"53483-4 ")
 ;;456
 ;;21,"53484-2 ")
 ;;457
 ;;21,"53485-9 ")
 ;;458
 ;;21,"53486-7 ")
 ;;459
 ;;21,"53487-5 ")
 ;;460
 ;;21,"53553-4 ")
 ;;550
 ;;21,"53928-8 ")
 ;;461
 ;;21,"53929-6 ")
 ;;462
 ;;21,"54248-0 ")
 ;;463
 ;;21,"54249-8 ")
 ;;464
 ;;21,"54250-6 ")
 ;;465
 ;;21,"54251-4 ")
 ;;466
 ;;21,"54252-2 ")
 ;;467
 ;;21,"54253-0 ")
 ;;468
 ;;21,"54254-8 ")
 ;;469
 ;;21,"54255-5 ")
 ;;470
 ;;21,"54256-3 ")
 ;;471
 ;;21,"54257-1 ")
 ;;472
 ;;21,"54258-9 ")
 ;;473
 ;;21,"54259-7 ")
 ;;474
 ;;21,"54260-5 ")
 ;;475
 ;;21,"54261-3 ")
 ;;476
 ;;21,"54262-1 ")
 ;;477
 ;;21,"54263-9 ")
 ;;478
 ;;21,"54264-7 ")
 ;;479
 ;;21,"54265-4 ")
 ;;480
 ;;21,"54266-2 ")
 ;;481
 ;;21,"54267-0 ")
 ;;482
 ;;21,"54268-8 ")
 ;;483
 ;;21,"54269-6 ")
 ;;484
 ;;21,"54270-4 ")
 ;;485
 ;;21,"54271-2 ")
 ;;486
 ;;21,"54272-0 ")
 ;;487
 ;;21,"54273-8 ")
 ;;488
 ;;21,"54274-6 ")
 ;;489
 ;;21,"54275-3 ")
 ;;490
 ;;21,"54276-1 ")
 ;;491
 ;;21,"54277-9 ")
 ;;492
 ;;21,"54392-6 ")
 ;;493
 ;;21,"54393-4 ")
 ;;494
 ;;21,"54394-2 ")
 ;;495
 ;;21,"54395-9 ")
 ;;496
 ;;21,"54396-7 ")
 ;;497
 ;;21,"54397-5 ")
 ;;498
 ;;21,"54398-3 ")
 ;;499
 ;;21,"54399-1 ")
 ;;500
 ;;21,"54400-7 ")
 ;;501
 ;;21,"54401-5 ")
 ;;502
 ;;21,"54495-7 ")
 ;;503
 ;;21,"54496-5 ")
 ;;504
 ;;21,"54497-3 ")
 ;;505
 ;;21,"54498-1 ")
 ;;506
 ;;21,"54499-9 ")
 ;;507
 ;;21,"55351-1 ")
 ;;508
 ;;21,"55352-9 ")
 ;;509
 ;;21,"55381-8 ")
 ;;510
 ;;21,"56751-1 ")
 ;;511
 ;;21,"57350-1 ")
 ;;512
 ;;21,"57971-4 ")
 ;;513
 ;;21,"57972-2 ")
 ;;514
 ;;21,"5914-7 ")
 ;;515
 ;;21,"59157-8 ")
 ;;516
 ;;21,"59791-4 ")
 ;;517
 ;;21,"59792-2 ")
 ;;518
 ;;21,"59793-0 ")
 ;;519
 ;;21,"59794-8 ")
 ;;520
 ;;21,"59795-5 ")
 ;;521
 ;;21,"59796-3 ")
 ;;522
 ;;21,"59797-1 ")
 ;;523
 ;;21,"59812-8 ")
 ;;524
 ;;21,"59813-6 ")
 ;;525
 ;;21,"59814-4 ")
 ;;526
 ;;21,"59815-1 ")
 ;;527
 ;;21,"6689-4 ")
 ;;528
 ;;21,"6749-6 ")
 ;;529
 ;;21,"6752-0 ")
 ;;530
 ;;21,"6756-1 ")
 ;;531
 ;;21,"6760-3 ")
 ;;532
 ;;21,"6762-9 ")
 ;;533
 ;;21,"6777-7 ")
 ;;534
 ;;21,"69941-3 ")
 ;;535
 ;;21,"69942-1 ")
 ;;536
 ;;21,"69943-9 ")
 ;;537
 ;;21,"69944-7 ")
 ;;538
 ;;21,"70208-4 ")
 ;;539
 ;;21,"72171-2 ")
 ;;540
 ;;21,"72516-8 ")
 ;;541
 ;;21,"72895-6 ")
 ;;542
 ;;21,"72896-4 ")
 ;;543
 ;;21,"74084-5 ")
 ;;544
 ;;21,"74774-1 ")
 ;;545
 ;;21,"75405-1 ")
 ;;551
 ;;21,"9375-7 ")
 ;;546
 ;;21,"9376-5 ")
 ;;547
 ;;21,"9377-3 ")
 ;;548
 ;;21,"9378-1 ")
 ;;549
 ;;9002226,614,.01)
 ;;BGP GLUCOSE LOINC
 ;;9002226,614,.02)
 ;;@
 ;;9002226,614,.04)
 ;;n
 ;;9002226,614,.06)
 ;;@
 ;;9002226,614,.08)
 ;;@
 ;;9002226,614,.09)
 ;;@
 ;;9002226,614,.11)
 ;;@
 ;;9002226,614,.12)
 ;;@
 ;;9002226,614,.13)
 ;;1
 ;;9002226,614,.14)
 ;;FIHS
 ;;9002226,614,.15)
 ;;95.3
 ;;9002226,614,.16)
 ;;@
 ;;9002226,614,.17)
 ;;@
 ;;9002226,614,3101)
 ;;@
 ;;9002226.02101,"614,10449-7 ",.01)
 ;;10449-7
 ;;9002226.02101,"614,10449-7 ",.02)
 ;;10449-7
 ;;9002226.02101,"614,10450-5 ",.01)
 ;;10450-5
 ;;9002226.02101,"614,10450-5 ",.02)
 ;;10450-5
 ;;9002226.02101,"614,10832-4 ",.01)
 ;;10832-4
 ;;9002226.02101,"614,10832-4 ",.02)
 ;;10832-4
 ;;9002226.02101,"614,11032-0 ",.01)
 ;;11032-0
 ;;9002226.02101,"614,11032-0 ",.02)
 ;;11032-0
 ;;9002226.02101,"614,11142-7 ",.01)
 ;;11142-7
 ;;9002226.02101,"614,11142-7 ",.02)
 ;;11142-7
 ;;9002226.02101,"614,11143-5 ",.01)
 ;;11143-5
 ;;9002226.02101,"614,11143-5 ",.02)
 ;;11143-5
 ;;9002226.02101,"614,12219-2 ",.01)
 ;;12219-2
 ;;9002226.02101,"614,12219-2 ",.02)
 ;;12219-2
 ;;9002226.02101,"614,12220-0 ",.01)
 ;;12220-0
 ;;9002226.02101,"614,12220-0 ",.02)
 ;;12220-0
 ;;9002226.02101,"614,12607-8 ",.01)
 ;;12607-8
 ;;9002226.02101,"614,12607-8 ",.02)
 ;;12607-8
 ;;9002226.02101,"614,12610-2 ",.01)
 ;;12610-2
 ;;9002226.02101,"614,12610-2 ",.02)
 ;;12610-2
 ;;9002226.02101,"614,12611-0 ",.01)
 ;;12611-0
 ;;9002226.02101,"614,12611-0 ",.02)
 ;;12611-0
 ;;9002226.02101,"614,12613-6 ",.01)
 ;;12613-6
 ;;9002226.02101,"614,12613-6 ",.02)
 ;;12613-6
 ;;9002226.02101,"614,12614-4 ",.01)
 ;;12614-4
 ;;9002226.02101,"614,12614-4 ",.02)
 ;;12614-4
 ;;9002226.02101,"614,12615-1 ",.01)
 ;;12615-1
 ;;9002226.02101,"614,12615-1 ",.02)
 ;;12615-1
 ;;9002226.02101,"614,12616-9 ",.01)
 ;;12616-9
 ;;9002226.02101,"614,12616-9 ",.02)
 ;;12616-9
 ;;9002226.02101,"614,12617-7 ",.01)
 ;;12617-7
 ;;9002226.02101,"614,12617-7 ",.02)
 ;;12617-7
 ;;9002226.02101,"614,12618-5 ",.01)
 ;;12618-5
 ;;9002226.02101,"614,12618-5 ",.02)
 ;;12618-5
 ;;9002226.02101,"614,12619-3 ",.01)
 ;;12619-3
 ;;9002226.02101,"614,12619-3 ",.02)
 ;;12619-3
 ;;9002226.02101,"614,12620-1 ",.01)
 ;;12620-1
 ;;9002226.02101,"614,12620-1 ",.02)
 ;;12620-1
 ;;9002226.02101,"614,12621-9 ",.01)
 ;;12621-9
 ;;9002226.02101,"614,12621-9 ",.02)
 ;;12621-9
 ;;9002226.02101,"614,12622-7 ",.01)
 ;;12622-7
 ;;9002226.02101,"614,12622-7 ",.02)
 ;;12622-7
 ;;9002226.02101,"614,12623-5 ",.01)
 ;;12623-5
 ;;9002226.02101,"614,12623-5 ",.02)
 ;;12623-5
 ;;9002226.02101,"614,12624-3 ",.01)
 ;;12624-3
 ;;9002226.02101,"614,12624-3 ",.02)
 ;;12624-3
 ;;9002226.02101,"614,12625-0 ",.01)
 ;;12625-0
 ;;9002226.02101,"614,12625-0 ",.02)
 ;;12625-0
 ;;9002226.02101,"614,12626-8 ",.01)
 ;;12626-8
 ;;9002226.02101,"614,12626-8 ",.02)
 ;;12626-8
 ;;9002226.02101,"614,12627-6 ",.01)
 ;;12627-6
 ;;9002226.02101,"614,12627-6 ",.02)
 ;;12627-6
 ;;9002226.02101,"614,12631-8 ",.01)
 ;;12631-8
 ;;9002226.02101,"614,12631-8 ",.02)
 ;;12631-8
 ;;9002226.02101,"614,12632-6 ",.01)
 ;;12632-6
 ;;9002226.02101,"614,12632-6 ",.02)
 ;;12632-6
 ;;9002226.02101,"614,12635-9 ",.01)
 ;;12635-9
 ;;9002226.02101,"614,12635-9 ",.02)
 ;;12635-9
 ;;9002226.02101,"614,12636-7 ",.01)
 ;;12636-7
 ;;9002226.02101,"614,12636-7 ",.02)
 ;;12636-7
 ;;9002226.02101,"614,12637-5 ",.01)
 ;;12637-5
 ;;9002226.02101,"614,12637-5 ",.02)
 ;;12637-5
 ;;9002226.02101,"614,12638-3 ",.01)
 ;;12638-3
 ;;9002226.02101,"614,12638-3 ",.02)
 ;;12638-3
 ;;9002226.02101,"614,12639-1 ",.01)
 ;;12639-1
 ;;9002226.02101,"614,12639-1 ",.02)
 ;;12639-1
 ;;9002226.02101,"614,12640-9 ",.01)
 ;;12640-9
 ;;9002226.02101,"614,12640-9 ",.02)
 ;;12640-9
 ;;9002226.02101,"614,12641-7 ",.01)
 ;;12641-7
 ;;9002226.02101,"614,12641-7 ",.02)
 ;;12641-7
 ;;9002226.02101,"614,12642-5 ",.01)
 ;;12642-5
 ;;9002226.02101,"614,12642-5 ",.02)
 ;;12642-5
 ;;9002226.02101,"614,12643-3 ",.01)
 ;;12643-3
 ;;9002226.02101,"614,12643-3 ",.02)
 ;;12643-3
 ;;9002226.02101,"614,12644-1 ",.01)
 ;;12644-1
 ;;9002226.02101,"614,12644-1 ",.02)
 ;;12644-1
 ;;9002226.02101,"614,12645-8 ",.01)
 ;;12645-8
 ;;9002226.02101,"614,12645-8 ",.02)
 ;;12645-8
 ;;9002226.02101,"614,12646-6 ",.01)
 ;;12646-6
 ;;9002226.02101,"614,12646-6 ",.02)
 ;;12646-6
 ;;9002226.02101,"614,12647-4 ",.01)
 ;;12647-4
 ;;9002226.02101,"614,12647-4 ",.02)
 ;;12647-4
 ;;9002226.02101,"614,12648-2 ",.01)
 ;;12648-2
 ;;9002226.02101,"614,12648-2 ",.02)
 ;;12648-2
 ;;9002226.02101,"614,12649-0 ",.01)
 ;;12649-0
 ;;9002226.02101,"614,12649-0 ",.02)
 ;;12649-0
 ;;9002226.02101,"614,12650-8 ",.01)
 ;;12650-8
 ;;9002226.02101,"614,12650-8 ",.02)
 ;;12650-8
 ;;9002226.02101,"614,12651-6 ",.01)
 ;;12651-6
 ;;9002226.02101,"614,12651-6 ",.02)
 ;;12651-6
 ;;9002226.02101,"614,12652-4 ",.01)
 ;;12652-4
 ;;9002226.02101,"614,12652-4 ",.02)
 ;;12652-4
 ;;9002226.02101,"614,12653-2 ",.01)
 ;;12653-2
 ;;9002226.02101,"614,12653-2 ",.02)
 ;;12653-2
 ;;9002226.02101,"614,12654-0 ",.01)
 ;;12654-0
 ;;9002226.02101,"614,12654-0 ",.02)
 ;;12654-0
 ;;9002226.02101,"614,12655-7 ",.01)
 ;;12655-7
 ;;9002226.02101,"614,12655-7 ",.02)
 ;;12655-7
 ;;9002226.02101,"614,12656-5 ",.01)
 ;;12656-5
 ;;9002226.02101,"614,12656-5 ",.02)
 ;;12656-5
 ;;9002226.02101,"614,12657-3 ",.01)
 ;;12657-3
 ;;9002226.02101,"614,12657-3 ",.02)
 ;;12657-3
 ;;9002226.02101,"614,12658-1 ",.01)
 ;;12658-1
 ;;9002226.02101,"614,12658-1 ",.02)
 ;;12658-1
 ;;9002226.02101,"614,12659-9 ",.01)
 ;;12659-9
 ;;9002226.02101,"614,12659-9 ",.02)
 ;;12659-9
 ;;9002226.02101,"614,13453-6 ",.01)
 ;;13453-6
 ;;9002226.02101,"614,13453-6 ",.02)
 ;;13453-6
 ;;9002226.02101,"614,13606-9 ",.01)
 ;;13606-9
 ;;9002226.02101,"614,13606-9 ",.02)
 ;;13606-9
 ;;9002226.02101,"614,13607-7 ",.01)
 ;;13607-7
 ;;9002226.02101,"614,13607-7 ",.02)
 ;;13607-7
 ;;9002226.02101,"614,13865-1 ",.01)
 ;;13865-1
 ;;9002226.02101,"614,13865-1 ",.02)
 ;;13865-1
 ;;9002226.02101,"614,13866-9 ",.01)
 ;;13866-9
 ;;9002226.02101,"614,13866-9 ",.02)
 ;;13866-9
 ;;9002226.02101,"614,14137-4 ",.01)
 ;;14137-4
 ;;9002226.02101,"614,14137-4 ",.02)
 ;;14137-4
 ;;9002226.02101,"614,14743-9 ",.01)
 ;;14743-9
 ;;9002226.02101,"614,14743-9 ",.02)
 ;;14743-9
 ;;9002226.02101,"614,14749-6 ",.01)
 ;;14749-6
 ;;9002226.02101,"614,14749-6 ",.02)
 ;;14749-6
 ;;9002226.02101,"614,14751-2 ",.01)
 ;;14751-2
 ;;9002226.02101,"614,14751-2 ",.02)
 ;;14751-2
 ;;9002226.02101,"614,14752-0 ",.01)
 ;;14752-0
 ;;9002226.02101,"614,14752-0 ",.02)
 ;;14752-0
 ;;9002226.02101,"614,14753-8 ",.01)
 ;;14753-8
 ;;9002226.02101,"614,14753-8 ",.02)
 ;;14753-8
 ;;9002226.02101,"614,14754-6 ",.01)
 ;;14754-6
 ;;9002226.02101,"614,14754-6 ",.02)
 ;;14754-6
 ;;9002226.02101,"614,14755-3 ",.01)
 ;;14755-3
 ;;9002226.02101,"614,14755-3 ",.02)
 ;;14755-3
 ;;9002226.02101,"614,14756-1 ",.01)
 ;;14756-1
 ;;9002226.02101,"614,14756-1 ",.02)
 ;;14756-1
 ;;9002226.02101,"614,14757-9 ",.01)
 ;;14757-9
 ;;9002226.02101,"614,14757-9 ",.02)
 ;;14757-9
 ;;9002226.02101,"614,14758-7 ",.01)
 ;;14758-7
 ;;9002226.02101,"614,14758-7 ",.02)
 ;;14758-7
 ;;9002226.02101,"614,14759-5 ",.01)
 ;;14759-5
 ;;9002226.02101,"614,14759-5 ",.02)
 ;;14759-5
 ;;9002226.02101,"614,14760-3 ",.01)
 ;;14760-3
 ;;9002226.02101,"614,14760-3 ",.02)
 ;;14760-3
 ;;9002226.02101,"614,14761-1 ",.01)
 ;;14761-1
 ;;9002226.02101,"614,14761-1 ",.02)
 ;;14761-1
 ;;9002226.02101,"614,14762-9 ",.01)
 ;;14762-9
 ;;9002226.02101,"614,14762-9 ",.02)
 ;;14762-9
 ;;9002226.02101,"614,14763-7 ",.01)
 ;;14763-7
 ;;9002226.02101,"614,14763-7 ",.02)
 ;;14763-7
 ;;9002226.02101,"614,14764-5 ",.01)
 ;;14764-5
 ;;9002226.02101,"614,14764-5 ",.02)
 ;;14764-5
 ;;9002226.02101,"614,14765-2 ",.01)
 ;;14765-2
 ;;9002226.02101,"614,14765-2 ",.02)
 ;;14765-2
 ;;9002226.02101,"614,14766-0 ",.01)
 ;;14766-0
 ;;9002226.02101,"614,14766-0 ",.02)
 ;;14766-0
 ;;9002226.02101,"614,14767-8 ",.01)
 ;;14767-8
 ;;9002226.02101,"614,14767-8 ",.02)
 ;;14767-8
 ;;9002226.02101,"614,14768-6 ",.01)
 ;;14768-6
 ;;9002226.02101,"614,14768-6 ",.02)
 ;;14768-6
 ;;9002226.02101,"614,14769-4 ",.01)
 ;;14769-4
 ;;9002226.02101,"614,14769-4 ",.02)
 ;;14769-4
 ;;9002226.02101,"614,14770-2 ",.01)
 ;;14770-2
 ;;9002226.02101,"614,14770-2 ",.02)
 ;;14770-2
 ;;9002226.02101,"614,14771-0 ",.01)
 ;;14771-0
 ;;9002226.02101,"614,14771-0 ",.02)
 ;;14771-0
 ;;9002226.02101,"614,1492-8 ",.01)
 ;;1492-8
 ;;9002226.02101,"614,1492-8 ",.02)
 ;;1492-8
 ;;9002226.02101,"614,1493-6 ",.01)
 ;;1493-6
 ;;9002226.02101,"614,1493-6 ",.02)
 ;;1493-6
 ;;9002226.02101,"614,1494-4 ",.01)
 ;;1494-4
 ;;9002226.02101,"614,1494-4 ",.02)
 ;;1494-4
 ;;9002226.02101,"614,1496-9 ",.01)
 ;;1496-9
 ;;9002226.02101,"614,1496-9 ",.02)
 ;;1496-9
 ;;9002226.02101,"614,1497-7 ",.01)
 ;;1497-7
 ;;9002226.02101,"614,1497-7 ",.02)
 ;;1497-7
 ;;9002226.02101,"614,1498-5 ",.01)
 ;;1498-5
 ;;9002226.02101,"614,1498-5 ",.02)
 ;;1498-5
 ;;9002226.02101,"614,1499-3 ",.01)
 ;;1499-3
 ;;9002226.02101,"614,1499-3 ",.02)
 ;;1499-3
 ;;9002226.02101,"614,14995-5 ",.01)
 ;;14995-5
 ;;9002226.02101,"614,14995-5 ",.02)
 ;;14995-5
 ;;9002226.02101,"614,14996-3 ",.01)
 ;;14996-3