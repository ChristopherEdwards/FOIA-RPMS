BGP53W ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 16, 2015;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;;BGP GLUCOSE LOINC
 ;
 ; This routine loads Taxonomy BGP GLUCOSE LOINC
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 D OTHER
 I $O(^TMP("ATX",$J,3.6,0)) D BULL^ATXSTX2
 I $O(^TMP("ATX",$J,9002226,0)) D TAX^ATXSTX2
 D KILL^ATXSTX2
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"10449-7 ")
 ;;1
 ;;21,"10450-5 ")
 ;;2
 ;;21,"10832-4 ")
 ;;3
 ;;21,"10968-6 ")
 ;;4
 ;;21,"11032-0 ")
 ;;5
 ;;21,"11142-7 ")
 ;;6
 ;;21,"11143-5 ")
 ;;7
 ;;21,"12219-2 ")
 ;;8
 ;;21,"12220-0 ")
 ;;9
 ;;21,"12607-8 ")
 ;;10
 ;;21,"12610-2 ")
 ;;11
 ;;21,"12611-0 ")
 ;;12
 ;;21,"12613-6 ")
 ;;13
 ;;21,"12614-4 ")
 ;;14
 ;;21,"12615-1 ")
 ;;15
 ;;21,"12616-9 ")
 ;;16
 ;;21,"12617-7 ")
 ;;17
 ;;21,"12618-5 ")
 ;;18
 ;;21,"12619-3 ")
 ;;19
 ;;21,"12620-1 ")
 ;;20
 ;;21,"12621-9 ")
 ;;21
 ;;21,"12622-7 ")
 ;;22
 ;;21,"12623-5 ")
 ;;23
 ;;21,"12624-3 ")
 ;;24
 ;;21,"12625-0 ")
 ;;25
 ;;21,"12626-8 ")
 ;;26
 ;;21,"12627-6 ")
 ;;27
 ;;21,"12631-8 ")
 ;;28
 ;;21,"12632-6 ")
 ;;29
 ;;21,"12635-9 ")
 ;;30
 ;;21,"12636-7 ")
 ;;31
 ;;21,"12637-5 ")
 ;;32
 ;;21,"12638-3 ")
 ;;33
 ;;21,"12639-1 ")
 ;;34
 ;;21,"12640-9 ")
 ;;35
 ;;21,"12641-7 ")
 ;;36
 ;;21,"12642-5 ")
 ;;37
 ;;21,"12643-3 ")
 ;;38
 ;;21,"12644-1 ")
 ;;39
 ;;21,"12645-8 ")
 ;;40
 ;;21,"12646-6 ")
 ;;41
 ;;21,"12647-4 ")
 ;;42
 ;;21,"12648-2 ")
 ;;43
 ;;21,"12649-0 ")
 ;;44
 ;;21,"12650-8 ")
 ;;45
 ;;21,"12651-6 ")
 ;;46
 ;;21,"12652-4 ")
 ;;47
 ;;21,"12653-2 ")
 ;;48
 ;;21,"12654-0 ")
 ;;49
 ;;21,"12655-7 ")
 ;;50
 ;;21,"12656-5 ")
 ;;51
 ;;21,"12657-3 ")
 ;;52
 ;;21,"12658-1 ")
 ;;53
 ;;21,"12659-9 ")
 ;;54
 ;;21,"13453-6 ")
 ;;55
 ;;21,"13606-9 ")
 ;;56
 ;;21,"13607-7 ")
 ;;57
 ;;21,"13865-1 ")
 ;;58
 ;;21,"13866-9 ")
 ;;59
 ;;21,"14137-4 ")
 ;;60
 ;;21,"14743-9 ")
 ;;61
 ;;21,"14749-6 ")
 ;;62
 ;;21,"14751-2 ")
 ;;63
 ;;21,"14752-0 ")
 ;;64
 ;;21,"14753-8 ")
 ;;65
 ;;21,"14754-6 ")
 ;;66
 ;;21,"14755-3 ")
 ;;67
 ;;21,"14756-1 ")
 ;;68
 ;;21,"14757-9 ")
 ;;69
 ;;21,"14758-7 ")
 ;;70
 ;;21,"14759-5 ")
 ;;71
 ;;21,"14760-3 ")
 ;;72
 ;;21,"14761-1 ")
 ;;73
 ;;21,"14762-9 ")
 ;;74
 ;;21,"14763-7 ")
 ;;75
 ;;21,"14764-5 ")
 ;;76
 ;;21,"14765-2 ")
 ;;77
 ;;21,"14766-0 ")
 ;;78
 ;;21,"14767-8 ")
 ;;79
 ;;21,"14768-6 ")
 ;;80
 ;;21,"14769-4 ")
 ;;81
 ;;21,"14770-2 ")
 ;;82
 ;;21,"14771-0 ")
 ;;83
 ;;21,"1491-0 ")
 ;;84
 ;;21,"1492-8 ")
 ;;85
 ;;21,"1493-6 ")
 ;;86
 ;;21,"1494-4 ")
 ;;87
 ;;21,"1496-9 ")
 ;;88
 ;;21,"1497-7 ")
 ;;89
 ;;21,"1498-5 ")
 ;;90
 ;;21,"1499-3 ")
 ;;91
 ;;21,"14995-5 ")
 ;;92
 ;;21,"14996-3 ")
 ;;93
 ;;21,"1500-8 ")
 ;;94
 ;;21,"1501-6 ")
 ;;95
 ;;21,"1502-4 ")
 ;;96
 ;;21,"1504-0 ")
 ;;97
 ;;21,"1506-5 ")
 ;;98
 ;;21,"1507-3 ")
 ;;99
 ;;21,"15074-8 ")
 ;;100
 ;;21,"1508-1 ")
 ;;101
 ;;21,"1510-7 ")
 ;;102
 ;;21,"1511-5 ")
 ;;103
 ;;21,"1512-3 ")
 ;;104
 ;;21,"1513-1 ")
 ;;105
 ;;21,"1514-9 ")
 ;;106
 ;;21,"1515-6 ")
 ;;107
 ;;21,"1517-2 ")
 ;;108
 ;;21,"1518-0 ")
 ;;109
 ;;21,"1519-8 ")
 ;;110
 ;;21,"1521-4 ")
 ;;111
 ;;21,"1522-2 ")
 ;;112
 ;;21,"1523-0 ")
 ;;113
 ;;21,"1524-8 ")
 ;;114
 ;;21,"1525-5 ")
 ;;115
 ;;21,"1526-3 ")
 ;;116
 ;;21,"1527-1 ")
 ;;117
 ;;21,"1528-9 ")
 ;;118
 ;;21,"1529-7 ")
 ;;119
 ;;21,"1530-5 ")
 ;;120
 ;;21,"1531-3 ")
 ;;121
 ;;21,"1532-1 ")
 ;;122
 ;;21,"1533-9 ")
 ;;123
 ;;21,"1534-7 ")
 ;;124
 ;;21,"1535-4 ")
 ;;125
 ;;21,"1536-2 ")
 ;;126
 ;;21,"1537-0 ")
 ;;127
 ;;21,"1538-8 ")
 ;;128
 ;;21,"1539-6 ")
 ;;129
 ;;21,"1540-4 ")
 ;;130
 ;;21,"1541-2 ")
 ;;131
 ;;21,"1542-0 ")
 ;;132
 ;;21,"1543-8 ")
 ;;133
 ;;21,"1544-6 ")
 ;;134
 ;;21,"1545-3 ")
 ;;135
 ;;21,"1547-9 ")
 ;;136
 ;;21,"1548-7 ")
 ;;137
 ;;21,"1549-5 ")
 ;;138
 ;;21,"1550-3 ")
 ;;139
 ;;21,"1551-1 ")
 ;;140
 ;;21,"1552-9 ")
 ;;141
 ;;21,"1553-7 ")
 ;;142
 ;;21,"1554-5 ")
 ;;143
 ;;21,"1555-2 ")
 ;;144
 ;;21,"1556-0 ")
 ;;145
 ;;21,"1557-8 ")
 ;;146
 ;;21,"1558-6 ")
 ;;147
 ;;21,"16165-3 ")
 ;;148
 ;;21,"16166-1 ")
 ;;149
 ;;21,"16167-9 ")
 ;;150
 ;;21,"16168-7 ")
 ;;151
 ;;21,"16169-5 ")
 ;;152
 ;;21,"16170-3 ")
 ;;153
 ;;21,"16906-0 ")
 ;;154
 ;;21,"16907-8 ")
 ;;155
 ;;21,"16908-6 ")
 ;;156
 ;;21,"16909-4 ")
 ;;157
 ;;21,"16910-2 ")
 ;;158
 ;;21,"16911-0 ")
 ;;159
 ;;21,"16912-8 ")
 ;;160
 ;;21,"16913-6 ")
 ;;161
 ;;21,"16914-4 ")
 ;;162
 ;;21,"16915-1 ")
 ;;163
 ;;21,"17865-7 ")
 ;;164
 ;;21,"18296-4 ")
 ;;165
 ;;21,"18342-6 ")
 ;;166
 ;;21,"18353-3 ")
 ;;167
 ;;21,"18354-1 ")
 ;;168
 ;;21,"19104-9 ")
 ;;169
 ;;21,"19105-6 ")
 ;;170
 ;;21,"20436-2 ")
 ;;171
 ;;21,"20437-0 ")
 ;;172
 ;;21,"20438-8 ")
 ;;173
 ;;21,"20439-6 ")
 ;;174
 ;;21,"20440-4 ")
 ;;175
 ;;21,"20441-2 ")
 ;;176
 ;;21,"21004-7 ")
 ;;177
 ;;21,"21308-2 ")
 ;;178
 ;;21,"21309-0 ")
 ;;179
 ;;21,"21310-8 ")
 ;;180
 ;;21,"2339-0 ")
 ;;181
 ;;21,"2340-8 ")
 ;;182
 ;;21,"2341-6 ")
 ;;183
 ;;21,"2345-7 ")
 ;;184
 ;;21,"25663-6 ")
 ;;185
 ;;21,"25665-1 ")
 ;;186
 ;;21,"25666-9 ")
 ;;187
 ;;21,"25668-5 ")
 ;;188
 ;;21,"25669-3 ")
 ;;189
 ;;21,"25671-9 ")
 ;;190
 ;;21,"25672-7 ")
 ;;191
 ;;21,"25673-5 ")
 ;;192
 ;;21,"25674-3 ")
 ;;193
 ;;21,"25676-8 ")
 ;;194
 ;;21,"25677-6 ")
 ;;195
 ;;21,"25679-2 ")
 ;;196
 ;;21,"25680-0 ")
 ;;197
 ;;21,"26538-9 ")
 ;;198
 ;;21,"26539-7 ")
 ;;199
 ;;21,"26540-5 ")
 ;;200
 ;;21,"26541-3 ")
 ;;201
 ;;21,"26543-9 ")
 ;;202
 ;;21,"26544-7 ")
 ;;203
 ;;21,"26548-8 ")
 ;;204
 ;;21,"26549-6 ")
 ;;205
 ;;21,"26552-0 ")
 ;;206
 ;;21,"26554-6 ")
 ;;207
 ;;21,"26555-3 ")
 ;;208
 ;;21,"26695-7 ")
 ;;209
 ;;21,"26777-3 ")
 ;;210
 ;;21,"26778-1 ")
 ;;211
 ;;21,"26779-9 ")
 ;;212
 ;;21,"26780-7 ")
 ;;213
 ;;21,"26781-5 ")
 ;;214
 ;;21,"26782-3 ")
 ;;215
 ;;21,"26783-1 ")
 ;;216
 ;;21,"26817-7 ")
 ;;217
 ;;21,"26853-2 ")
 ;;218
 ;;21,"26854-0 ")
 ;;219
 ;;21,"27353-2 ")
 ;;220
 ;;21,"27432-4 ")
 ;;221
 ;;21,"29329-0 ")
 ;;222
 ;;21,"29330-8 ")
 ;;223
 ;;21,"29331-6 ")
 ;;224
 ;;21,"29332-4 ")
 ;;225
 ;;21,"29412-4 ")
 ;;226
 ;;21,"30251-3 ")
 ;;227
 ;;21,"30252-1 ")
 ;;228
 ;;21,"30253-9 ")
 ;;229
 ;;21,"30263-8 ")
 ;;230
 ;;21,"30264-6 ")
 ;;231
 ;;21,"30265-3 ")
 ;;232
 ;;21,"30266-1 ")
 ;;233
 ;;21,"30267-9 ")
 ;;234
 ;;21,"30344-6 ")
 ;;235
 ;;21,"30345-3 ")
 ;;236
 ;;21,"30346-1 ")
 ;;237
 ;;21,"32016-8 ")
 ;;238
 ;;21,"32319-6 ")
 ;;239
 ;;21,"32320-4 ")
 ;;240
 ;;21,"32321-2 ")
 ;;241
 ;;21,"32322-0 ")
 ;;242
 ;;21,"32359-2 ")
 ;;243
 ;;21,"32820-3 ")
 ;;244
 ;;21,"33024-1 ")
 ;;245
 ;;21,"34056-2 ")
 ;;246
 ;;21,"34057-0 ")
 ;;247
 ;;21,"34058-8 ")
 ;;248
 ;;21,"34059-6 ")
 ;;249
 ;;21,"34060-4 ")
 ;;250
 ;;21,"35184-1 ")
 ;;251
 ;;21,"35211-2 ")
 ;;252
 ;;21,"39480-9 ")
 ;;253
 ;;21,"39481-7 ")
 ;;254
 ;;21,"39561-6 ")
 ;;255
 ;;21,"39562-4 ")
 ;;256
 ;;21,"39563-2 ")
 ;;257
 ;;21,"39997-2 ")
 ;;258
 ;;21,"39998-0 ")
 ;;259
 ;;21,"39999-8 ")
 ;;260
 ;;21,"40000-2 ")
 ;;261
 ;;21,"40001-0 ")
 ;;262
 ;;21,"40002-8 ")
 ;;263
 ;;21,"40003-6 ")
 ;;264
 ;;21,"40004-4 ")
 ;;265
 ;;21,"40005-1 ")
 ;;266
 ;;21,"40006-9 ")
 ;;267
 ;;21,"40007-7 ")
 ;;268
 ;;21,"40008-5 ")
 ;;269
 ;;21,"40009-3 ")
 ;;270
 ;;21,"40010-1 ")
 ;;271
 ;;21,"40011-9 ")
 ;;272
 ;;21,"40012-7 ")
 ;;273
 ;;21,"40013-5 ")
 ;;274
 ;;21,"40014-3 ")
 ;;275
 ;;21,"40015-0 ")
 ;;276
 ;;21,"40016-8 ")
 ;;277
 ;;21,"40017-6 ")
 ;;278
 ;;21,"40018-4 ")
 ;;279
 ;;21,"40019-2 ")
 ;;280
 ;;21,"40020-0 ")
 ;;281
 ;;21,"40021-8 ")
 ;;282
 ;;21,"40022-6 ")
 ;;283
 ;;21,"40023-4 ")
 ;;284
 ;;21,"40024-2 ")
 ;;285
 ;;21,"40025-9 ")
 ;;286
 ;;21,"40026-7 ")
 ;;287
 ;;21,"40027-5 ")
 ;;288
 ;;21,"40028-3 ")
 ;;289
 ;;21,"40029-1 ")
 ;;290
 ;;21,"40030-9 ")
 ;;291
 ;;21,"40031-7 ")
 ;;292
 ;;21,"40032-5 ")
 ;;293
 ;;21,"40033-3 ")
 ;;294
 ;;21,"40034-1 ")
 ;;295
 ;;21,"40035-8 ")
 ;;296
 ;;21,"40036-6 ")
 ;;297
 ;;21,"40037-4 ")
 ;;298
 ;;21,"40038-2 ")
 ;;299
 ;;21,"40039-0 ")
 ;;300
 ;;21,"40040-8 ")
 ;;301
 ;;21,"40041-6 ")
 ;;302
 ;;21,"40042-4 ")
 ;;303
 ;;21,"40043-2 ")
 ;;304
 ;;21,"40044-0 ")
 ;;305
 ;;21,"40045-7 ")
 ;;306
 ;;21,"40148-9 ")
 ;;307
 ;;21,"40149-7 ")
 ;;308
 ;;21,"40150-5 ")
 ;;309
 ;;21,"40151-3 ")
 ;;310
 ;;21,"40152-1 ")
 ;;311
 ;;21,"40153-9 ")
 ;;312
 ;;21,"40154-7 ")
 ;;313
 ;;21,"40155-4 ")
 ;;314
 ;;21,"40156-2 ")
 ;;315
 ;;21,"40157-0 ")
 ;;316
 ;;21,"40158-8 ")
 ;;317
 ;;21,"40159-6 ")
 ;;318
 ;;21,"40160-4 ")
 ;;319
 ;;21,"40161-2 ")
 ;;320
 ;;21,"40162-0 ")
 ;;321
 ;;21,"40163-8 ")
 ;;322
 ;;21,"40164-6 ")
 ;;323
 ;;21,"40165-3 ")
 ;;324
 ;;21,"40166-1 ")
 ;;325
 ;;21,"40167-9 ")
 ;;326
 ;;21,"40168-7 ")
 ;;327
 ;;21,"40169-5 ")
 ;;328
 ;;21,"40170-3 ")
 ;;329
 ;;21,"40171-1 ")
 ;;330
 ;;21,"40172-9 ")
 ;;331
 ;;21,"40173-7 ")
 ;;332
 ;;21,"40174-5 ")
 ;;333
 ;;21,"40175-2 ")
 ;;334
 ;;21,"40176-0 ")
 ;;335
 ;;21,"40177-8 ")
 ;;336
 ;;21,"40178-6 ")
 ;;337
 ;;21,"40179-4 ")
 ;;338
 ;;21,"40180-2 ")
 ;;339
 ;;21,"40181-0 ")
 ;;340
 ;;21,"40182-8 ")
 ;;341
 ;;21,"40183-6 ")
 ;;342
 ;;21,"40184-4 ")
 ;;343
 ;;21,"40185-1 ")
 ;;344
 ;;21,"40186-9 ")
 ;;345
 ;;21,"40187-7 ")
 ;;346
 ;;21,"40188-5 ")
 ;;347
 ;;21,"40189-3 ")
 ;;348
 ;;21,"40190-1 ")
 ;;349
 ;;21,"40191-9 ")
 ;;350
 ;;21,"40192-7 ")
 ;;351
 ;;21,"40193-5 ")
 ;;352
 ;;21,"40194-3 ")
 ;;353
 ;;21,"40195-0 ")
 ;;354
 ;;21,"40196-8 ")
 ;;355
 ;;21,"40197-6 ")
 ;;356
 ;;21,"40198-4 ")
 ;;357
 ;;21,"40199-2 ")
 ;;358
 ;;21,"40200-8 ")
 ;;359
 ;;21,"40201-6 ")
 ;;360
 ;;21,"40202-4 ")
 ;;361
 ;;21,"40203-2 ")
 ;;362
 ;;21,"40204-0 ")
 ;;363
 ;;21,"40205-7 ")
 ;;364
 ;;21,"40206-5 ")
 ;;365
 ;;21,"40207-3 ")
 ;;366
 ;;21,"40208-1 ")
 ;;367
 ;;21,"40209-9 ")
 ;;368
 ;;21,"40210-7 ")
 ;;369
 ;;21,"40211-5 ")
 ;;370
 ;;21,"40212-3 ")
 ;;371
 ;;21,"40213-1 ")
 ;;372
 ;;21,"40214-9 ")
 ;;373
 ;;21,"40215-6 ")
 ;;374
 ;;21,"40216-4 ")
 ;;375
 ;;21,"40217-2 ")
 ;;376
 ;;21,"40218-0 ")
 ;;377
 ;;21,"40219-8 ")
 ;;378
 ;;21,"40220-6 ")
 ;;379
 ;;21,"40221-4 ")
 ;;380
 ;;21,"40222-2 ")
 ;;381
 ;;21,"40259-4 ")
 ;;382
 ;;21,"40260-2 ")
 ;;383
 ;;21,"40261-0 ")
 ;;384
 ;;21,"40262-8 ")
 ;;385
 ;;21,"40263-6 ")
 ;;386
 ;;21,"40276-8 ")
 ;;387
 ;;21,"40277-6 ")
 ;;388
 ;;21,"40278-4 ")
 ;;389
 ;;21,"40279-2 ")
 ;;390
 ;;21,"40280-0 ")
 ;;391
 ;;21,"40285-9 ")
 ;;392
 ;;21,"40286-7 ")
 ;;393
 ;;21,"40287-5 ")
 ;;394
 ;;21,"40318-8 ")
 ;;395
 ;;21,"40319-6 ")
 ;;396
 ;;21,"40320-4 ")
 ;;397
 ;;21,"40321-2 ")
 ;;398
 ;;21,"40322-0 ")
 ;;399
 ;;21,"40323-8 ")
 ;;400
 ;;21,"40324-6 ")
 ;;401
 ;;21,"40858-3 ")
 ;;402
 ;;21,"40875-7 ")
 ;;403
 ;;21,"41024-1 ")
 ;;404
 ;;21,"41604-0 ")
 ;;405
 ;;21,"41651-1 ")
 ;;406
 ;;21,"41652-9 ")
 ;;407
 ;
OTHER ; OTHER ROUTINES
 D ^BGP53W2
 D ^BGP53W3
 D ^BGP53W4
 D ^BGP53W5
 D ^BGP53W6
 D ^BGP53W7
 Q