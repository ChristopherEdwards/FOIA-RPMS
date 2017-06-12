ATXD5Q ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON NOV 12, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;APCL INJ POISONING
 ;
 ; This routine loads Taxonomy APCL INJ POISONING
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
 ;;21,"E850.0 ")
 ;;1
 ;;21,"E929.4 ")
 ;;2
 ;;21,"T36.0X1A ")
 ;;3
 ;;21,"T36.0X1D ")
 ;;4
 ;;21,"T36.0X1S ")
 ;;5
 ;;21,"T36.1X1A ")
 ;;6
 ;;21,"T36.1X1D ")
 ;;7
 ;;21,"T36.1X1S ")
 ;;8
 ;;21,"T36.2X1A ")
 ;;9
 ;;21,"T36.2X1D ")
 ;;10
 ;;21,"T36.2X1S ")
 ;;11
 ;;21,"T36.3X1A ")
 ;;12
 ;;21,"T36.3X1D ")
 ;;13
 ;;21,"T36.3X1S ")
 ;;14
 ;;21,"T36.4X1A ")
 ;;15
 ;;21,"T36.4X1D ")
 ;;16
 ;;21,"T36.4X1S ")
 ;;17
 ;;21,"T36.5X1A ")
 ;;18
 ;;21,"T36.5X1D ")
 ;;19
 ;;21,"T36.5X1S ")
 ;;20
 ;;21,"T36.6X1A ")
 ;;21
 ;;21,"T36.6X1D ")
 ;;22
 ;;21,"T36.6X1S ")
 ;;23
 ;;21,"T36.7X1A ")
 ;;24
 ;;21,"T36.7X1D ")
 ;;25
 ;;21,"T36.7X1S ")
 ;;26
 ;;21,"T36.8X1A ")
 ;;27
 ;;21,"T36.8X1D ")
 ;;28
 ;;21,"T36.8X1S ")
 ;;29
 ;;21,"T36.91XA ")
 ;;30
 ;;21,"T36.91XD ")
 ;;31
 ;;21,"T36.91XS ")
 ;;32
 ;;21,"T37.0X1A ")
 ;;33
 ;;21,"T37.0X1D ")
 ;;34
 ;;21,"T37.0X1S ")
 ;;35
 ;;21,"T37.1X1A ")
 ;;36
 ;;21,"T37.1X1D ")
 ;;37
 ;;21,"T37.1X1S ")
 ;;38
 ;;21,"T37.2X1A ")
 ;;39
 ;;21,"T37.2X1D ")
 ;;40
 ;;21,"T37.2X1S ")
 ;;41
 ;;21,"T37.3X1A ")
 ;;42
 ;;21,"T37.3X1D ")
 ;;43
 ;;21,"T37.3X1S ")
 ;;44
 ;;21,"T37.4X1A ")
 ;;45
 ;;21,"T37.4X1D ")
 ;;46
 ;;21,"T37.4X1S ")
 ;;47
 ;;21,"T37.5X1A ")
 ;;48
 ;;21,"T37.5X1D ")
 ;;49
 ;;21,"T37.5X1S ")
 ;;50
 ;;21,"T37.8X1A ")
 ;;51
 ;;21,"T37.8X1D ")
 ;;52
 ;;21,"T37.8X1S ")
 ;;53
 ;;21,"T37.91XA ")
 ;;54
 ;;21,"T37.91XD ")
 ;;55
 ;;21,"T37.91XS ")
 ;;56
 ;;21,"T38.0X1A ")
 ;;57
 ;;21,"T38.0X1D ")
 ;;58
 ;;21,"T38.0X1S ")
 ;;59
 ;;21,"T38.1X1A ")
 ;;60
 ;;21,"T38.1X1D ")
 ;;61
 ;;21,"T38.1X1S ")
 ;;62
 ;;21,"T38.2X1A ")
 ;;63
 ;;21,"T38.2X1D ")
 ;;64
 ;;21,"T38.2X1S ")
 ;;65
 ;;21,"T38.3X1A ")
 ;;66
 ;;21,"T38.3X1D ")
 ;;67
 ;;21,"T38.3X1S ")
 ;;68
 ;;21,"T38.4X1A ")
 ;;69
 ;;21,"T38.4X1D ")
 ;;70
 ;;21,"T38.4X1S ")
 ;;71
 ;;21,"T38.5X1A ")
 ;;72
 ;;21,"T38.5X1D ")
 ;;73
 ;;21,"T38.5X1S ")
 ;;74
 ;;21,"T38.6X1A ")
 ;;75
 ;;21,"T38.6X1D ")
 ;;76
 ;;21,"T38.6X1S ")
 ;;77
 ;;21,"T38.7X1A ")
 ;;78
 ;;21,"T38.7X1D ")
 ;;79
 ;;21,"T38.7X1S ")
 ;;80
 ;;21,"T38.801A ")
 ;;81
 ;;21,"T38.801D ")
 ;;82
 ;;21,"T38.801S ")
 ;;83
 ;;21,"T38.811A ")
 ;;84
 ;;21,"T38.811D ")
 ;;85
 ;;21,"T38.811S ")
 ;;86
 ;;21,"T38.891A ")
 ;;87
 ;;21,"T38.891D ")
 ;;88
 ;;21,"T38.891S ")
 ;;89
 ;;21,"T38.901A ")
 ;;90
 ;;21,"T38.901D ")
 ;;91
 ;;21,"T38.901S ")
 ;;92
 ;;21,"T38.991A ")
 ;;93
 ;;21,"T38.991D ")
 ;;94
 ;;21,"T38.991S ")
 ;;95
 ;;21,"T39.011A ")
 ;;96
 ;;21,"T39.011D ")
 ;;97
 ;;21,"T39.011S ")
 ;;98
 ;;21,"T39.091A ")
 ;;99
 ;;21,"T39.091D ")
 ;;100
 ;;21,"T39.091S ")
 ;;101
 ;;21,"T39.1X1A ")
 ;;102
 ;;21,"T39.1X1D ")
 ;;103
 ;;21,"T39.1X1S ")
 ;;104
 ;;21,"T39.2X1A ")
 ;;105
 ;;21,"T39.2X1D ")
 ;;106
 ;;21,"T39.2X1S ")
 ;;107
 ;;21,"T39.311A ")
 ;;108
 ;;21,"T39.311D ")
 ;;109
 ;;21,"T39.311S ")
 ;;110
 ;;21,"T39.391A ")
 ;;111
 ;;21,"T39.391D ")
 ;;112
 ;;21,"T39.391S ")
 ;;113
 ;;21,"T39.4X1A ")
 ;;114
 ;;21,"T39.4X1D ")
 ;;115
 ;;21,"T39.4X1S ")
 ;;116
 ;;21,"T39.8X1A ")
 ;;117
 ;;21,"T39.8X1D ")
 ;;118
 ;;21,"T39.8X1S ")
 ;;119
 ;;21,"T39.91XA ")
 ;;120
 ;;21,"T39.91XD ")
 ;;121
 ;;21,"T39.91XS ")
 ;;122
 ;;21,"T40.0X1A ")
 ;;123
 ;;21,"T40.0X1D ")
 ;;124
 ;;21,"T40.0X1S ")
 ;;125
 ;;21,"T40.1X1A ")
 ;;126
 ;;21,"T40.1X1D ")
 ;;127
 ;;21,"T40.1X1S ")
 ;;128
 ;;21,"T40.2X1A ")
 ;;129
 ;;21,"T40.2X1D ")
 ;;130
 ;;21,"T40.2X1S ")
 ;;131
 ;;21,"T40.3X1A ")
 ;;132
 ;;21,"T40.3X1D ")
 ;;133
 ;;21,"T40.3X1S ")
 ;;134
 ;;21,"T40.4X1A ")
 ;;135
 ;;21,"T40.4X1D ")
 ;;136
 ;;21,"T40.4X1S ")
 ;;137
 ;;21,"T40.5X1A ")
 ;;138
 ;;21,"T40.5X1D ")
 ;;139
 ;;21,"T40.5X1S ")
 ;;140
 ;;21,"T40.601A ")
 ;;141
 ;;21,"T40.601D ")
 ;;142
 ;;21,"T40.601S ")
 ;;143
 ;;21,"T40.691A ")
 ;;144
 ;;21,"T40.691D ")
 ;;145
 ;;21,"T40.691S ")
 ;;146
 ;;21,"T40.7X1A ")
 ;;147
 ;;21,"T40.7X1D ")
 ;;148
 ;;21,"T40.7X1S ")
 ;;149
 ;;21,"T40.8X1A ")
 ;;150
 ;;21,"T40.8X1D ")
 ;;151
 ;;21,"T40.8X1S ")
 ;;152
 ;;21,"T40.901A ")
 ;;153
 ;;21,"T40.901D ")
 ;;154
 ;;21,"T40.901S ")
 ;;155
 ;;21,"T40.991A ")
 ;;156
 ;;21,"T40.991D ")
 ;;157
 ;;21,"T40.991S ")
 ;;158
 ;;21,"T41.0X1A ")
 ;;159
 ;;21,"T41.0X1D ")
 ;;160
 ;;21,"T41.0X1S ")
 ;;161
 ;;21,"T41.1X1A ")
 ;;162
 ;;21,"T41.1X1D ")
 ;;163
 ;;21,"T41.1X1S ")
 ;;164
 ;;21,"T41.201A ")
 ;;165
 ;;21,"T41.201D ")
 ;;166
 ;;21,"T41.201S ")
 ;;167
 ;;21,"T41.291A ")
 ;;168
 ;;21,"T41.291D ")
 ;;169
 ;;21,"T41.291S ")
 ;;170
 ;;21,"T41.3X1A ")
 ;;171
 ;;21,"T41.3X1D ")
 ;;172
 ;;21,"T41.3X1S ")
 ;;173
 ;;21,"T41.41XA ")
 ;;174
 ;;21,"T41.41XD ")
 ;;175
 ;;21,"T41.41XS ")
 ;;176
 ;;21,"T41.5X1A ")
 ;;177
 ;;21,"T41.5X1D ")
 ;;178
 ;;21,"T41.5X1S ")
 ;;179
 ;;21,"T42.0X1A ")
 ;;180
 ;;21,"T42.0X1D ")
 ;;181
 ;;21,"T42.0X1S ")
 ;;182
 ;;21,"T42.1X1A ")
 ;;183
 ;;21,"T42.1X1D ")
 ;;184
 ;;21,"T42.1X1S ")
 ;;185
 ;;21,"T42.2X1A ")
 ;;186
 ;;21,"T42.2X1D ")
 ;;187
 ;;21,"T42.2X1S ")
 ;;188
 ;;21,"T42.3X1A ")
 ;;189
 ;;21,"T42.3X1D ")
 ;;190
 ;;21,"T42.3X1S ")
 ;;191
 ;;21,"T42.4X1A ")
 ;;192
 ;;21,"T42.4X1D ")
 ;;193
 ;;21,"T42.4X1S ")
 ;;194
 ;;21,"T42.5X1A ")
 ;;195
 ;;21,"T42.5X1D ")
 ;;196
 ;;21,"T42.5X1S ")
 ;;197
 ;;21,"T42.6X1A ")
 ;;198
 ;;21,"T42.6X1D ")
 ;;199
 ;;21,"T42.6X1S ")
 ;;200
 ;;21,"T42.71XA ")
 ;;201
 ;;21,"T42.71XD ")
 ;;202
 ;;21,"T42.71XS ")
 ;;203
 ;;21,"T42.8X1A ")
 ;;204
 ;;21,"T42.8X1D ")
 ;;205
 ;;21,"T42.8X1S ")
 ;;206
 ;;21,"T43.011A ")
 ;;207
 ;;21,"T43.011D ")
 ;;208
 ;;21,"T43.011S ")
 ;;209
 ;;21,"T43.021A ")
 ;;210
 ;;21,"T43.021D ")
 ;;211
 ;;21,"T43.021S ")
 ;;212
 ;;21,"T43.1X1A ")
 ;;213
 ;;21,"T43.1X1D ")
 ;;214
 ;;21,"T43.1X1S ")
 ;;215
 ;;21,"T43.201A ")
 ;;216
 ;;21,"T43.201D ")
 ;;217
 ;;21,"T43.201S ")
 ;;218
 ;;21,"T43.211A ")
 ;;219
 ;;21,"T43.211D ")
 ;;220
 ;;21,"T43.211S ")
 ;;221
 ;;21,"T43.221A ")
 ;;222
 ;;21,"T43.221D ")
 ;;223
 ;;21,"T43.221S ")
 ;;224
 ;;21,"T43.291A ")
 ;;225
 ;;21,"T43.291D ")
 ;;226
 ;;21,"T43.291S ")
 ;;227
 ;;21,"T43.3X1A ")
 ;;228
 ;;21,"T43.3X1D ")
 ;;229
 ;;21,"T43.3X1S ")
 ;;230
 ;;21,"T43.4X1A ")
 ;;231
 ;;21,"T43.4X1D ")
 ;;232
 ;;21,"T43.4X1S ")
 ;;233
 ;;21,"T43.501A ")
 ;;234
 ;;21,"T43.501D ")
 ;;235
 ;;21,"T43.501S ")
 ;;236
 ;;21,"T43.591A ")
 ;;237
 ;;21,"T43.591D ")
 ;;238
 ;;21,"T43.591S ")
 ;;239
 ;;21,"T43.601A ")
 ;;240
 ;;21,"T43.601D ")
 ;;241
 ;;21,"T43.601S ")
 ;;242
 ;;21,"T43.611A ")
 ;;243
 ;;21,"T43.611D ")
 ;;244
 ;;21,"T43.611S ")
 ;;245
 ;;21,"T43.621A ")
 ;;246
 ;;21,"T43.621D ")
 ;;247
 ;;21,"T43.621S ")
 ;;248
 ;;21,"T43.631A ")
 ;;249
 ;;21,"T43.631D ")
 ;;250
 ;;21,"T43.631S ")
 ;;251
 ;;21,"T43.691A ")
 ;;252
 ;;21,"T43.691D ")
 ;;253
 ;;21,"T43.691S ")
 ;;254
 ;;21,"T43.8X1A ")
 ;;255
 ;;21,"T43.8X1D ")
 ;;256
 ;;21,"T43.8X1S ")
 ;;257
 ;;21,"T43.91XA ")
 ;;258
 ;;21,"T43.91XD ")
 ;;259
 ;;21,"T43.91XS ")
 ;;260
 ;;21,"T44.0X1A ")
 ;;261
 ;;21,"T44.0X1D ")
 ;;262
 ;;21,"T44.0X1S ")
 ;;263
 ;;21,"T44.1X1A ")
 ;;264
 ;;21,"T44.1X1D ")
 ;;265
 ;;21,"T44.1X1S ")
 ;;266
 ;;21,"T44.2X1A ")
 ;;267
 ;;21,"T44.2X1D ")
 ;;268
 ;;21,"T44.2X1S ")
 ;;269
 ;;21,"T44.3X1A ")
 ;;270
 ;;21,"T44.3X1D ")
 ;;271
 ;;21,"T44.3X1S ")
 ;;272
 ;;21,"T44.4X1A ")
 ;;273
 ;;21,"T44.4X1D ")
 ;;274
 ;;21,"T44.4X1S ")
 ;;275
 ;;21,"T44.5X1A ")
 ;;276
 ;;21,"T44.5X1D ")
 ;;277
 ;;21,"T44.5X1S ")
 ;;278
 ;;21,"T44.6X1A ")
 ;;279
 ;;21,"T44.6X1D ")
 ;;280
 ;;21,"T44.6X1S ")
 ;;281
 ;;21,"T44.7X1A ")
 ;;282
 ;;21,"T44.7X1D ")
 ;;283
 ;;21,"T44.7X1S ")
 ;;284
 ;;21,"T44.8X1A ")
 ;;285
 ;;21,"T44.8X1D ")
 ;;286
 ;;21,"T44.8X1S ")
 ;;287
 ;;21,"T44.901A ")
 ;;288
 ;;21,"T44.901D ")
 ;;289
 ;;21,"T44.901S ")
 ;;290
 ;;21,"T44.991A ")
 ;;291
 ;;21,"T44.991D ")
 ;;292
 ;;21,"T44.991S ")
 ;;293
 ;;21,"T45.0X1A ")
 ;;294
 ;;21,"T45.0X1D ")
 ;;295
 ;;21,"T45.0X1S ")
 ;;296
 ;;21,"T45.1X1A ")
 ;;297
 ;;21,"T45.1X1D ")
 ;;298
 ;;21,"T45.1X1S ")
 ;;299
 ;;21,"T45.2X1A ")
 ;;300
 ;;21,"T45.2X1D ")
 ;;301
 ;;21,"T45.2X1S ")
 ;;302
 ;;21,"T45.3X1A ")
 ;;303
 ;;21,"T45.3X1D ")
 ;;304
 ;;21,"T45.3X1S ")
 ;;305
 ;;21,"T45.4X1A ")
 ;;306
 ;;21,"T45.4X1D ")
 ;;307
 ;;21,"T45.4X1S ")
 ;;308
 ;;21,"T45.511A ")
 ;;309
 ;;21,"T45.511D ")
 ;;310
 ;;21,"T45.511S ")
 ;;311
 ;;21,"T45.521A ")
 ;;312
 ;;21,"T45.521D ")
 ;;313
 ;;21,"T45.521S ")
 ;;314
 ;;21,"T45.601A ")
 ;;315
 ;;21,"T45.601D ")
 ;;316
 ;;21,"T45.601S ")
 ;;317
 ;;21,"T45.611A ")
 ;;318
 ;;21,"T45.611D ")
 ;;319
 ;;21,"T45.611S ")
 ;;320
 ;;21,"T45.621A ")
 ;;321
 ;;21,"T45.621D ")
 ;;322
 ;;21,"T45.621S ")
 ;;323
 ;;21,"T45.691A ")
 ;;324
 ;;21,"T45.691D ")
 ;;325
 ;;21,"T45.691S ")
 ;;326
 ;;21,"T45.7X1A ")
 ;;327
 ;;21,"T45.7X1D ")
 ;;328
 ;;21,"T45.7X1S ")
 ;;329
 ;;21,"T45.8X1A ")
 ;;330
 ;;21,"T45.8X1D ")
 ;;331
 ;;21,"T45.8X1S ")
 ;;332
 ;;21,"T45.91XA ")
 ;;333
 ;;21,"T45.91XD ")
 ;;334
 ;;21,"T45.91XS ")
 ;;335
 ;;21,"T46.0X1A ")
 ;;336
 ;;21,"T46.0X1D ")
 ;;337
 ;;21,"T46.0X1S ")
 ;;338
 ;;21,"T46.1X1A ")
 ;;339
 ;;21,"T46.1X1D ")
 ;;340
 ;;21,"T46.1X1S ")
 ;;341
 ;;21,"T46.2X1A ")
 ;;342
 ;;21,"T46.2X1D ")
 ;;343
 ;;21,"T46.2X1S ")
 ;;344
 ;;21,"T46.3X1A ")
 ;;345
 ;;21,"T46.3X1D ")
 ;;346
 ;;21,"T46.3X1S ")
 ;;347
 ;;21,"T46.4X1A ")
 ;;348
 ;;21,"T46.4X1D ")
 ;;349
 ;;21,"T46.4X1S ")
 ;;350
 ;;21,"T46.5X1A ")
 ;;351
 ;;21,"T46.5X1D ")
 ;;352
 ;;21,"T46.5X1S ")
 ;;353
 ;;21,"T46.6X1A ")
 ;;354
 ;;21,"T46.6X1D ")
 ;;355
 ;;21,"T46.6X1S ")
 ;;356
 ;;21,"T46.7X1A ")
 ;;357
 ;;21,"T46.7X1D ")
 ;;358
 ;;21,"T46.7X1S ")
 ;;359
 ;;21,"T46.8X1A ")
 ;;360
 ;;21,"T46.8X1D ")
 ;;361
 ;;21,"T46.8X1S ")
 ;;362
 ;;21,"T46.901A ")
 ;;363
 ;;21,"T46.901D ")
 ;;364
 ;;21,"T46.901S ")
 ;;365
 ;;21,"T46.991A ")
 ;;366
 ;;21,"T46.991D ")
 ;;367
 ;;21,"T46.991S ")
 ;;368
 ;;21,"T47.0X1A ")
 ;;369
 ;;21,"T47.0X1D ")
 ;;370
 ;;21,"T47.0X1S ")
 ;;371
 ;;21,"T47.1X1A ")
 ;;372
 ;;21,"T47.1X1D ")
 ;;373
 ;;21,"T47.1X1S ")
 ;;374
 ;;21,"T47.2X1A ")
 ;;375
 ;;21,"T47.2X1D ")
 ;;376
 ;;21,"T47.2X1S ")
 ;;377
 ;;21,"T47.3X1A ")
 ;;378
 ;;21,"T47.3X1D ")
 ;;379
 ;;21,"T47.3X1S ")
 ;;380
 ;;21,"T47.4X1A ")
 ;;381
 ;;21,"T47.4X1D ")
 ;;382
 ;;21,"T47.4X1S ")
 ;;383
 ;;21,"T47.5X1A ")
 ;;384
 ;;21,"T47.5X1D ")
 ;;385
 ;;21,"T47.5X1S ")
 ;;386
 ;;21,"T47.6X1A ")
 ;;387
 ;;21,"T47.6X1D ")
 ;;388
 ;;21,"T47.6X1S ")
 ;;389
 ;;21,"T47.7X1A ")
 ;;390
 ;;21,"T47.7X1D ")
 ;;391
 ;;21,"T47.7X1S ")
 ;;392
 ;;21,"T47.8X1A ")
 ;;393
 ;;21,"T47.8X1D ")
 ;;394
 ;;21,"T47.8X1S ")
 ;;395
 ;;21,"T47.91XA ")
 ;;396
 ;;21,"T47.91XD ")
 ;;397
 ;;21,"T47.91XS ")
 ;;398
 ;;21,"T48.0X1A ")
 ;;399
 ;;21,"T48.0X1D ")
 ;;400
 ;;21,"T48.0X1S ")
 ;;401
 ;;21,"T48.1X1A ")
 ;;402
 ;;21,"T48.1X1D ")
 ;;403
 ;;21,"T48.1X1S ")
 ;;404
 ;;21,"T48.201A ")
 ;;405
 ;;21,"T48.201D ")
 ;;406
 ;;21,"T48.201S ")
 ;;407
 ;;21,"T48.291A ")
 ;;408
 ;;21,"T48.291D ")
 ;;409
 ;;21,"T48.291S ")
 ;;410
 ;;21,"T48.3X1A ")
 ;;411
 ;;21,"T48.3X1D ")
 ;;412
 ;;21,"T48.3X1S ")
 ;;413
 ;;21,"T48.4X1A ")
 ;;414
 ;;21,"T48.4X1D ")
 ;;415
 ;;21,"T48.4X1S ")
 ;;416
 ;;21,"T48.5X1A ")
 ;;417
 ;;21,"T48.5X1D ")
 ;;418
 ;;21,"T48.5X1S ")
 ;;419
 ;;21,"T48.6X1A ")
 ;;420
 ;;21,"T48.6X1D ")
 ;;421
 ;;21,"T48.6X1S ")
 ;;422
 ;;21,"T48.901A ")
 ;;423
 ;;21,"T48.901D ")
 ;;424
 ;;21,"T48.901S ")
 ;;425
 ;;21,"T48.991A ")
 ;;426
 ;;21,"T48.991D ")
 ;;427
 ;;21,"T48.991S ")
 ;;428
 ;;21,"T49.0X1A ")
 ;;429
 ;;21,"T49.0X1D ")
 ;;430
 ;;21,"T49.0X1S ")
 ;;431
 ;;21,"T49.1X1A ")
 ;;432
 ;;21,"T49.1X1D ")
 ;;433
 ;;21,"T49.1X1S ")
 ;;434
 ;;21,"T49.2X1A ")
 ;;435
 ;;21,"T49.2X1D ")
 ;;436
 ;;21,"T49.2X1S ")
 ;;437
 ;;21,"T49.3X1A ")
 ;;438
 ;;21,"T49.3X1D ")
 ;;439
 ;;21,"T49.3X1S ")
 ;;440
 ;;21,"T49.4X1A ")
 ;;441
 ;;21,"T49.4X1D ")
 ;;442
 ;;21,"T49.4X1S ")
 ;;443
 ;;21,"T49.5X1A ")
 ;;444
 ;;21,"T49.5X1D ")
 ;;445
 ;;21,"T49.5X1S ")
 ;;446
 ;;21,"T49.6X1A ")
 ;;447
 ;;21,"T49.6X1D ")
 ;;448
 ;;21,"T49.6X1S ")
 ;;449
 ;;21,"T49.7X1A ")
 ;;450
 ;;21,"T49.7X1D ")
 ;;451
 ;;21,"T49.7X1S ")
 ;;452
 ;;21,"T49.8X1A ")
 ;;453
 ;;21,"T49.8X1D ")
 ;;454
 ;;21,"T49.8X1S ")
 ;;455
 ;
OTHER ; OTHER ROUTINES
 D ^ATXD5Q10
 D ^ATXD5Q11
 D ^ATXD5Q12
 D ^ATXD5Q13
 D ^ATXD5Q2
 D ^ATXD5Q3
 D ^ATXD5Q4
 D ^ATXD5Q5
 D ^ATXD5Q6
 D ^ATXD5Q7
 D ^ATXD5Q8
 D ^ATXD5Q9
 Q