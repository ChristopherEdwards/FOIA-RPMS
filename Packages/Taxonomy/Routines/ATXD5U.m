ATXD5U ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;APCL INJ UNDETERMINED
 ;
 ; This routine loads Taxonomy APCL INJ UNDETERMINED
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
 ;;21,"E988.8 ")
 ;;1
 ;;21,"T36.0X4A ")
 ;;2
 ;;21,"T36.0X4D ")
 ;;3
 ;;21,"T36.0X4S ")
 ;;4
 ;;21,"T36.1X4A ")
 ;;5
 ;;21,"T36.1X4D ")
 ;;6
 ;;21,"T36.1X4S ")
 ;;7
 ;;21,"T36.2X4A ")
 ;;8
 ;;21,"T36.2X4D ")
 ;;9
 ;;21,"T36.2X4S ")
 ;;10
 ;;21,"T36.3X4A ")
 ;;11
 ;;21,"T36.3X4D ")
 ;;12
 ;;21,"T36.3X4S ")
 ;;13
 ;;21,"T36.4X4A ")
 ;;14
 ;;21,"T36.4X4D ")
 ;;15
 ;;21,"T36.4X4S ")
 ;;16
 ;;21,"T36.5X4A ")
 ;;17
 ;;21,"T36.5X4D ")
 ;;18
 ;;21,"T36.5X4S ")
 ;;19
 ;;21,"T36.6X4A ")
 ;;20
 ;;21,"T36.6X4D ")
 ;;21
 ;;21,"T36.6X4S ")
 ;;22
 ;;21,"T36.7X4A ")
 ;;23
 ;;21,"T36.7X4D ")
 ;;24
 ;;21,"T36.7X4S ")
 ;;25
 ;;21,"T36.8X4A ")
 ;;26
 ;;21,"T36.8X4D ")
 ;;27
 ;;21,"T36.8X4S ")
 ;;28
 ;;21,"T36.94XA ")
 ;;29
 ;;21,"T36.94XD ")
 ;;30
 ;;21,"T36.94XS ")
 ;;31
 ;;21,"T37.0X4A ")
 ;;32
 ;;21,"T37.0X4D ")
 ;;33
 ;;21,"T37.0X4S ")
 ;;34
 ;;21,"T37.1X4A ")
 ;;35
 ;;21,"T37.1X4D ")
 ;;36
 ;;21,"T37.1X4S ")
 ;;37
 ;;21,"T37.2X4A ")
 ;;38
 ;;21,"T37.2X4D ")
 ;;39
 ;;21,"T37.2X4S ")
 ;;40
 ;;21,"T37.3X4A ")
 ;;41
 ;;21,"T37.3X4D ")
 ;;42
 ;;21,"T37.3X4S ")
 ;;43
 ;;21,"T37.4X4A ")
 ;;44
 ;;21,"T37.4X4D ")
 ;;45
 ;;21,"T37.4X4S ")
 ;;46
 ;;21,"T37.5X4A ")
 ;;47
 ;;21,"T37.5X4D ")
 ;;48
 ;;21,"T37.5X4S ")
 ;;49
 ;;21,"T37.8X4A ")
 ;;50
 ;;21,"T37.8X4D ")
 ;;51
 ;;21,"T37.8X4S ")
 ;;52
 ;;21,"T37.94XA ")
 ;;53
 ;;21,"T37.94XD ")
 ;;54
 ;;21,"T37.94XS ")
 ;;55
 ;;21,"T38.0X4A ")
 ;;56
 ;;21,"T38.0X4D ")
 ;;57
 ;;21,"T38.0X4S ")
 ;;58
 ;;21,"T38.1X4A ")
 ;;59
 ;;21,"T38.1X4D ")
 ;;60
 ;;21,"T38.1X4S ")
 ;;61
 ;;21,"T38.2X4A ")
 ;;62
 ;;21,"T38.2X4D ")
 ;;63
 ;;21,"T38.2X4S ")
 ;;64
 ;;21,"T38.3X4A ")
 ;;65
 ;;21,"T38.3X4D ")
 ;;66
 ;;21,"T38.3X4S ")
 ;;67
 ;;21,"T38.4X4A ")
 ;;68
 ;;21,"T38.4X4D ")
 ;;69
 ;;21,"T38.4X4S ")
 ;;70
 ;;21,"T38.5X4A ")
 ;;71
 ;;21,"T38.5X4D ")
 ;;72
 ;;21,"T38.5X4S ")
 ;;73
 ;;21,"T38.6X4A ")
 ;;74
 ;;21,"T38.6X4D ")
 ;;75
 ;;21,"T38.6X4S ")
 ;;76
 ;;21,"T38.7X4A ")
 ;;77
 ;;21,"T38.7X4D ")
 ;;78
 ;;21,"T38.7X4S ")
 ;;79
 ;;21,"T38.804A ")
 ;;80
 ;;21,"T38.804D ")
 ;;81
 ;;21,"T38.804S ")
 ;;82
 ;;21,"T38.814A ")
 ;;83
 ;;21,"T38.814D ")
 ;;84
 ;;21,"T38.814S ")
 ;;85
 ;;21,"T38.894A ")
 ;;86
 ;;21,"T38.894D ")
 ;;87
 ;;21,"T38.894S ")
 ;;88
 ;;21,"T38.904A ")
 ;;89
 ;;21,"T38.904D ")
 ;;90
 ;;21,"T38.904S ")
 ;;91
 ;;21,"T38.994A ")
 ;;92
 ;;21,"T38.994D ")
 ;;93
 ;;21,"T38.994S ")
 ;;94
 ;;21,"T39.014A ")
 ;;95
 ;;21,"T39.014D ")
 ;;96
 ;;21,"T39.014S ")
 ;;97
 ;;21,"T39.094A ")
 ;;98
 ;;21,"T39.094D ")
 ;;99
 ;;21,"T39.094S ")
 ;;100
 ;;21,"T39.1X4A ")
 ;;101
 ;;21,"T39.1X4D ")
 ;;102
 ;;21,"T39.1X4S ")
 ;;103
 ;;21,"T39.2X4A ")
 ;;104
 ;;21,"T39.2X4D ")
 ;;105
 ;;21,"T39.2X4S ")
 ;;106
 ;;21,"T39.314A ")
 ;;107
 ;;21,"T39.314D ")
 ;;108
 ;;21,"T39.314S ")
 ;;109
 ;;21,"T39.394A ")
 ;;110
 ;;21,"T39.394D ")
 ;;111
 ;;21,"T39.394S ")
 ;;112
 ;;21,"T39.4X4A ")
 ;;113
 ;;21,"T39.4X4D ")
 ;;114
 ;;21,"T39.4X4S ")
 ;;115
 ;;21,"T39.8X4A ")
 ;;116
 ;;21,"T39.8X4D ")
 ;;117
 ;;21,"T39.8X4S ")
 ;;118
 ;;21,"T39.94XA ")
 ;;119
 ;;21,"T39.94XD ")
 ;;120
 ;;21,"T39.94XS ")
 ;;121
 ;;21,"T40.0X4A ")
 ;;122
 ;;21,"T40.0X4D ")
 ;;123
 ;;21,"T40.0X4S ")
 ;;124
 ;;21,"T40.1X4A ")
 ;;125
 ;;21,"T40.1X4D ")
 ;;126
 ;;21,"T40.1X4S ")
 ;;127
 ;;21,"T40.2X4A ")
 ;;128
 ;;21,"T40.2X4D ")
 ;;129
 ;;21,"T40.2X4S ")
 ;;130
 ;;21,"T40.3X4A ")
 ;;131
 ;;21,"T40.3X4D ")
 ;;132
 ;;21,"T40.3X4S ")
 ;;133
 ;;21,"T40.4X4A ")
 ;;134
 ;;21,"T40.4X4D ")
 ;;135
 ;;21,"T40.4X4S ")
 ;;136
 ;;21,"T40.5X4A ")
 ;;137
 ;;21,"T40.5X4D ")
 ;;138
 ;;21,"T40.5X4S ")
 ;;139
 ;;21,"T40.604A ")
 ;;140
 ;;21,"T40.604D ")
 ;;141
 ;;21,"T40.604S ")
 ;;142
 ;;21,"T40.694A ")
 ;;143
 ;;21,"T40.694D ")
 ;;144
 ;;21,"T40.694S ")
 ;;145
 ;;21,"T40.7X4A ")
 ;;146
 ;;21,"T40.7X4D ")
 ;;147
 ;;21,"T40.7X4S ")
 ;;148
 ;;21,"T40.8X4A ")
 ;;149
 ;;21,"T40.8X4D ")
 ;;150
 ;;21,"T40.8X4S ")
 ;;151
 ;;21,"T40.904A ")
 ;;152
 ;;21,"T40.904D ")
 ;;153
 ;;21,"T40.904S ")
 ;;154
 ;;21,"T40.994A ")
 ;;155
 ;;21,"T40.994D ")
 ;;156
 ;;21,"T40.994S ")
 ;;157
 ;;21,"T41.0X4A ")
 ;;158
 ;;21,"T41.0X4D ")
 ;;159
 ;;21,"T41.0X4S ")
 ;;160
 ;;21,"T41.1X4A ")
 ;;161
 ;;21,"T41.1X4D ")
 ;;162
 ;;21,"T41.1X4S ")
 ;;163
 ;;21,"T41.204A ")
 ;;164
 ;;21,"T41.204D ")
 ;;165
 ;;21,"T41.204S ")
 ;;166
 ;;21,"T41.294A ")
 ;;167
 ;;21,"T41.294D ")
 ;;168
 ;;21,"T41.294S ")
 ;;169
 ;;21,"T41.3X4A ")
 ;;170
 ;;21,"T41.3X4D ")
 ;;171
 ;;21,"T41.3X4S ")
 ;;172
 ;;21,"T41.44XA ")
 ;;173
 ;;21,"T41.44XD ")
 ;;174
 ;;21,"T41.44XS ")
 ;;175
 ;;21,"T41.5X4A ")
 ;;176
 ;;21,"T41.5X4D ")
 ;;177
 ;;21,"T41.5X4S ")
 ;;178
 ;;21,"T42.0X4A ")
 ;;179
 ;;21,"T42.0X4D ")
 ;;180
 ;;21,"T42.0X4S ")
 ;;181
 ;;21,"T42.1X4A ")
 ;;182
 ;;21,"T42.1X4D ")
 ;;183
 ;;21,"T42.1X4S ")
 ;;184
 ;;21,"T42.2X4A ")
 ;;185
 ;;21,"T42.2X4D ")
 ;;186
 ;;21,"T42.2X4S ")
 ;;187
 ;;21,"T42.3X4A ")
 ;;188
 ;;21,"T42.3X4D ")
 ;;189
 ;;21,"T42.3X4S ")
 ;;190
 ;;21,"T42.4X4A ")
 ;;191
 ;;21,"T42.4X4D ")
 ;;192
 ;;21,"T42.4X4S ")
 ;;193
 ;;21,"T42.5X4A ")
 ;;194
 ;;21,"T42.5X4D ")
 ;;195
 ;;21,"T42.5X4S ")
 ;;196
 ;;21,"T42.6X4A ")
 ;;197
 ;;21,"T42.6X4D ")
 ;;198
 ;;21,"T42.6X4S ")
 ;;199
 ;;21,"T42.74XA ")
 ;;200
 ;;21,"T42.74XD ")
 ;;201
 ;;21,"T42.74XS ")
 ;;202
 ;;21,"T42.8X4A ")
 ;;203
 ;;21,"T42.8X4D ")
 ;;204
 ;;21,"T42.8X4S ")
 ;;205
 ;;21,"T43.014A ")
 ;;206
 ;;21,"T43.014D ")
 ;;207
 ;;21,"T43.014S ")
 ;;208
 ;;21,"T43.024A ")
 ;;209
 ;;21,"T43.024D ")
 ;;210
 ;;21,"T43.024S ")
 ;;211
 ;;21,"T43.1X4A ")
 ;;212
 ;;21,"T43.1X4D ")
 ;;213
 ;;21,"T43.1X4S ")
 ;;214
 ;;21,"T43.204A ")
 ;;215
 ;;21,"T43.204D ")
 ;;216
 ;;21,"T43.204S ")
 ;;217
 ;;21,"T43.214A ")
 ;;218
 ;;21,"T43.214D ")
 ;;219
 ;;21,"T43.214S ")
 ;;220
 ;;21,"T43.224A ")
 ;;221
 ;;21,"T43.224D ")
 ;;222
 ;;21,"T43.224S ")
 ;;223
 ;;21,"T43.294A ")
 ;;224
 ;;21,"T43.294D ")
 ;;225
 ;;21,"T43.294S ")
 ;;226
 ;;21,"T43.3X4A ")
 ;;227
 ;;21,"T43.3X4D ")
 ;;228
 ;;21,"T43.3X4S ")
 ;;229
 ;;21,"T43.4X4A ")
 ;;230
 ;;21,"T43.4X4D ")
 ;;231
 ;;21,"T43.4X4S ")
 ;;232
 ;;21,"T43.504A ")
 ;;233
 ;;21,"T43.504D ")
 ;;234
 ;;21,"T43.504S ")
 ;;235
 ;;21,"T43.594A ")
 ;;236
 ;;21,"T43.594D ")
 ;;237
 ;;21,"T43.594S ")
 ;;238
 ;;21,"T43.604A ")
 ;;239
 ;;21,"T43.604D ")
 ;;240
 ;;21,"T43.604S ")
 ;;241
 ;;21,"T43.614A ")
 ;;242
 ;;21,"T43.614D ")
 ;;243
 ;;21,"T43.614S ")
 ;;244
 ;;21,"T43.624A ")
 ;;245
 ;;21,"T43.624D ")
 ;;246
 ;;21,"T43.624S ")
 ;;247
 ;;21,"T43.634A ")
 ;;248
 ;;21,"T43.634D ")
 ;;249
 ;;21,"T43.634S ")
 ;;250
 ;;21,"T43.694A ")
 ;;251
 ;;21,"T43.694D ")
 ;;252
 ;;21,"T43.694S ")
 ;;253
 ;;21,"T43.8X4A ")
 ;;254
 ;;21,"T43.8X4D ")
 ;;255
 ;;21,"T43.8X4S ")
 ;;256
 ;;21,"T43.94XA ")
 ;;257
 ;;21,"T43.94XD ")
 ;;258
 ;;21,"T43.94XS ")
 ;;259
 ;;21,"T44.0X4A ")
 ;;260
 ;;21,"T44.0X4D ")
 ;;261
 ;;21,"T44.0X4S ")
 ;;262
 ;;21,"T44.1X4A ")
 ;;263
 ;;21,"T44.1X4D ")
 ;;264
 ;;21,"T44.1X4S ")
 ;;265
 ;;21,"T44.2X4A ")
 ;;266
 ;;21,"T44.2X4D ")
 ;;267
 ;;21,"T44.2X4S ")
 ;;268
 ;;21,"T44.3X4A ")
 ;;269
 ;;21,"T44.3X4D ")
 ;;270
 ;;21,"T44.3X4S ")
 ;;271
 ;;21,"T44.4X4A ")
 ;;272
 ;;21,"T44.4X4D ")
 ;;273
 ;;21,"T44.4X4S ")
 ;;274
 ;;21,"T44.5X4A ")
 ;;275
 ;;21,"T44.5X4D ")
 ;;276
 ;;21,"T44.5X4S ")
 ;;277
 ;;21,"T44.6X4A ")
 ;;278
 ;;21,"T44.6X4D ")
 ;;279
 ;;21,"T44.6X4S ")
 ;;280
 ;;21,"T44.7X4A ")
 ;;281
 ;;21,"T44.7X4D ")
 ;;282
 ;;21,"T44.7X4S ")
 ;;283
 ;;21,"T44.8X4A ")
 ;;284
 ;;21,"T44.8X4D ")
 ;;285
 ;;21,"T44.8X4S ")
 ;;286
 ;;21,"T44.904A ")
 ;;287
 ;;21,"T44.904D ")
 ;;288
 ;;21,"T44.904S ")
 ;;289
 ;;21,"T44.994A ")
 ;;290
 ;;21,"T44.994D ")
 ;;291
 ;;21,"T44.994S ")
 ;;292
 ;;21,"T45.0X4A ")
 ;;293
 ;;21,"T45.0X4D ")
 ;;294
 ;;21,"T45.0X4S ")
 ;;295
 ;;21,"T45.1X4A ")
 ;;296
 ;;21,"T45.1X4D ")
 ;;297
 ;;21,"T45.1X4S ")
 ;;298
 ;;21,"T45.2X4A ")
 ;;299
 ;;21,"T45.2X4D ")
 ;;300
 ;;21,"T45.2X4S ")
 ;;301
 ;;21,"T45.3X4A ")
 ;;302
 ;;21,"T45.3X4D ")
 ;;303
 ;;21,"T45.3X4S ")
 ;;304
 ;;21,"T45.4X4A ")
 ;;305
 ;;21,"T45.4X4D ")
 ;;306
 ;;21,"T45.4X4S ")
 ;;307
 ;;21,"T45.514A ")
 ;;308
 ;;21,"T45.514D ")
 ;;309
 ;;21,"T45.514S ")
 ;;310
 ;;21,"T45.524A ")
 ;;311
 ;;21,"T45.524D ")
 ;;312
 ;;21,"T45.524S ")
 ;;313
 ;;21,"T45.604A ")
 ;;314
 ;;21,"T45.604D ")
 ;;315
 ;;21,"T45.604S ")
 ;;316
 ;;21,"T45.614A ")
 ;;317
 ;;21,"T45.614D ")
 ;;318
 ;;21,"T45.614S ")
 ;;319
 ;;21,"T45.624A ")
 ;;320
 ;;21,"T45.624D ")
 ;;321
 ;;21,"T45.624S ")
 ;;322
 ;;21,"T45.694A ")
 ;;323
 ;;21,"T45.694D ")
 ;;324
 ;;21,"T45.694S ")
 ;;325
 ;;21,"T45.7X4A ")
 ;;326
 ;;21,"T45.7X4D ")
 ;;327
 ;;21,"T45.7X4S ")
 ;;328
 ;;21,"T45.8X4A ")
 ;;329
 ;;21,"T45.8X4D ")
 ;;330
 ;;21,"T45.8X4S ")
 ;;331
 ;;21,"T45.94XA ")
 ;;332
 ;;21,"T45.94XD ")
 ;;333
 ;;21,"T45.94XS ")
 ;;334
 ;;21,"T46.0X4A ")
 ;;335
 ;;21,"T46.0X4D ")
 ;;336
 ;;21,"T46.0X4S ")
 ;;337
 ;;21,"T46.1X4A ")
 ;;338
 ;;21,"T46.1X4D ")
 ;;339
 ;;21,"T46.1X4S ")
 ;;340
 ;;21,"T46.2X4A ")
 ;;341
 ;;21,"T46.2X4D ")
 ;;342
 ;;21,"T46.2X4S ")
 ;;343
 ;;21,"T46.3X4A ")
 ;;344
 ;;21,"T46.3X4D ")
 ;;345
 ;;21,"T46.3X4S ")
 ;;346
 ;;21,"T46.4X4A ")
 ;;347
 ;;21,"T46.4X4D ")
 ;;348
 ;;21,"T46.4X4S ")
 ;;349
 ;;21,"T46.5X4A ")
 ;;350
 ;;21,"T46.5X4D ")
 ;;351
 ;;21,"T46.5X4S ")
 ;;352
 ;;21,"T46.6X4A ")
 ;;353
 ;;21,"T46.6X4D ")
 ;;354
 ;;21,"T46.6X4S ")
 ;;355
 ;;21,"T46.7X4A ")
 ;;356
 ;;21,"T46.7X4D ")
 ;;357
 ;;21,"T46.7X4S ")
 ;;358
 ;;21,"T46.8X4A ")
 ;;359
 ;;21,"T46.8X4D ")
 ;;360
 ;;21,"T46.8X4S ")
 ;;361
 ;;21,"T46.904A ")
 ;;362
 ;;21,"T46.904D ")
 ;;363
 ;;21,"T46.904S ")
 ;;364
 ;;21,"T46.994A ")
 ;;365
 ;;21,"T46.994D ")
 ;;366
 ;;21,"T46.994S ")
 ;;367
 ;;21,"T47.0X4A ")
 ;;368
 ;;21,"T47.0X4D ")
 ;;369
 ;;21,"T47.0X4S ")
 ;;370
 ;;21,"T47.1X4A ")
 ;;371
 ;;21,"T47.1X4D ")
 ;;372
 ;;21,"T47.1X4S ")
 ;;373
 ;;21,"T47.2X4A ")
 ;;374
 ;;21,"T47.2X4D ")
 ;;375
 ;;21,"T47.2X4S ")
 ;;376
 ;;21,"T47.3X4A ")
 ;;377
 ;;21,"T47.3X4D ")
 ;;378
 ;;21,"T47.3X4S ")
 ;;379
 ;;21,"T47.4X4A ")
 ;;380
 ;;21,"T47.4X4D ")
 ;;381
 ;;21,"T47.4X4S ")
 ;;382
 ;;21,"T47.5X4A ")
 ;;383
 ;;21,"T47.5X4D ")
 ;;384
 ;;21,"T47.5X4S ")
 ;;385
 ;;21,"T47.6X4A ")
 ;;386
 ;;21,"T47.6X4D ")
 ;;387
 ;;21,"T47.6X4S ")
 ;;388
 ;;21,"T47.7X4A ")
 ;;389
 ;;21,"T47.7X4D ")
 ;;390
 ;;21,"T47.7X4S ")
 ;;391
 ;;21,"T47.8X4A ")
 ;;392
 ;;21,"T47.8X4D ")
 ;;393
 ;;21,"T47.8X4S ")
 ;;394
 ;;21,"T47.94XA ")
 ;;395
 ;;21,"T47.94XD ")
 ;;396
 ;;21,"T47.94XS ")
 ;;397
 ;;21,"T48.0X4A ")
 ;;398
 ;;21,"T48.0X4D ")
 ;;399
 ;;21,"T48.0X4S ")
 ;;400
 ;;21,"T48.1X4A ")
 ;;401
 ;;21,"T48.1X4D ")
 ;;402
 ;;21,"T48.1X4S ")
 ;;403
 ;;21,"T48.204A ")
 ;;404
 ;;21,"T48.204D ")
 ;;405
 ;;21,"T48.204S ")
 ;;406
 ;;21,"T48.294A ")
 ;;407
 ;;21,"T48.294D ")
 ;;408
 ;;21,"T48.294S ")
 ;;409
 ;;21,"T48.3X4A ")
 ;;410
 ;;21,"T48.3X4D ")
 ;;411
 ;;21,"T48.3X4S ")
 ;;412
 ;;21,"T48.4X4A ")
 ;;413
 ;;21,"T48.4X4D ")
 ;;414
 ;;21,"T48.4X4S ")
 ;;415
 ;;21,"T48.5X4A ")
 ;;416
 ;;21,"T48.5X4D ")
 ;;417
 ;;21,"T48.5X4S ")
 ;;418
 ;;21,"T48.6X4A ")
 ;;419
 ;;21,"T48.6X4D ")
 ;;420
 ;;21,"T48.6X4S ")
 ;;421
 ;;21,"T48.904A ")
 ;;422
 ;;21,"T48.904D ")
 ;;423
 ;;21,"T48.904S ")
 ;;424
 ;;21,"T48.994A ")
 ;;425
 ;;21,"T48.994D ")
 ;;426
 ;;21,"T48.994S ")
 ;;427
 ;;21,"T49.0X4A ")
 ;;428
 ;;21,"T49.0X4D ")
 ;;429
 ;;21,"T49.0X4S ")
 ;;430
 ;;21,"T49.1X4A ")
 ;;431
 ;;21,"T49.1X4D ")
 ;;432
 ;;21,"T49.1X4S ")
 ;;433
 ;;21,"T49.2X4A ")
 ;;434
 ;;21,"T49.2X4D ")
 ;;435
 ;;21,"T49.2X4S ")
 ;;436
 ;;21,"T49.3X4A ")
 ;;437
 ;;21,"T49.3X4D ")
 ;;438
 ;;21,"T49.3X4S ")
 ;;439
 ;;21,"T49.4X4A ")
 ;;440
 ;;21,"T49.4X4D ")
 ;;441
 ;;21,"T49.4X4S ")
 ;;442
 ;;21,"T49.5X4A ")
 ;;443
 ;;21,"T49.5X4D ")
 ;;444
 ;;21,"T49.5X4S ")
 ;;445
 ;;21,"T49.6X4A ")
 ;;446
 ;;21,"T49.6X4D ")
 ;;447
 ;;21,"T49.6X4S ")
 ;;448
 ;;21,"T49.7X4A ")
 ;;449
 ;;21,"T49.7X4D ")
 ;;450
 ;;21,"T49.7X4S ")
 ;;451
 ;;21,"T49.8X4A ")
 ;;452
 ;;21,"T49.8X4D ")
 ;;453
 ;;21,"T49.8X4S ")
 ;;454
 ;;21,"T49.94XA ")
 ;;455
 ;
OTHER ; OTHER ROUTINES
 D ^ATXD5U10
 D ^ATXD5U11
 D ^ATXD5U12
 D ^ATXD5U13
 D ^ATXD5U14
 D ^ATXD5U2
 D ^ATXD5U3
 D ^ATXD5U4
 D ^ATXD5U5
 D ^ATXD5U6
 D ^ATXD5U7
 D ^ATXD5U8
 D ^ATXD5U9
 Q