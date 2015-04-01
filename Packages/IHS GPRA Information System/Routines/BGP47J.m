BGP47J ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 16, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;;BGP HEDIS ANTICHOLINERGIC NDC
 ;
 ; This routine loads Taxonomy BGP HEDIS ANTICHOLINERGIC NDC
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
 ;;21,"00006-0021-68 ")
 ;;1
 ;;21,"00006-0062-68 ")
 ;;2
 ;;21,"00008-0019-01 ")
 ;;3
 ;;21,"00008-0027-02 ")
 ;;4
 ;;21,"00008-0027-07 ")
 ;;5
 ;;21,"00008-0063-01 ")
 ;;6
 ;;21,"00008-0212-01 ")
 ;;7
 ;;21,"00008-0227-01 ")
 ;;8
 ;;21,"00008-0229-01 ")
 ;;9
 ;;21,"00008-0498-01 ")
 ;;10
 ;;21,"00008-0550-01 ")
 ;;11
 ;;21,"00008-0550-02 ")
 ;;12
 ;;21,"00008-0746-01 ")
 ;;13
 ;;21,"00049-5460-74 ")
 ;;14
 ;;21,"00049-5590-93 ")
 ;;15
 ;;21,"00049-5600-66 ")
 ;;16
 ;;21,"00049-5610-66 ")
 ;;17
 ;;21,"00049-5610-73 ")
 ;;18
 ;;21,"00049-5620-66 ")
 ;;19
 ;;21,"00049-5630-66 ")
 ;;20
 ;;21,"00069-5410-66 ")
 ;;21
 ;;21,"00069-5420-66 ")
 ;;22
 ;;21,"00069-5430-66 ")
 ;;23
 ;;21,"00069-5440-93 ")
 ;;24
 ;;21,"00069-5440-97 ")
 ;;25
 ;;21,"00074-2312-01 ")
 ;;26
 ;;21,"00074-2312-11 ")
 ;;27
 ;;21,"00074-2312-31 ")
 ;;28
 ;;21,"00074-2335-01 ")
 ;;29
 ;;21,"00074-2335-31 ")
 ;;30
 ;;21,"00085-0016-05 ")
 ;;31
 ;;21,"00085-0095-03 ")
 ;;32
 ;;21,"00085-0148-03 ")
 ;;33
 ;;21,"00085-0820-03 ")
 ;;34
 ;;21,"00093-0308-01 ")
 ;;35
 ;;21,"00093-0309-12 ")
 ;;36
 ;;21,"00093-2929-01 ")
 ;;37
 ;;21,"00093-2929-10 ")
 ;;38
 ;;21,"00093-2929-93 ")
 ;;39
 ;;21,"00093-5060-01 ")
 ;;40
 ;;21,"00093-5060-05 ")
 ;;41
 ;;21,"00093-5060-10 ")
 ;;42
 ;;21,"00093-5061-01 ")
 ;;43
 ;;21,"00093-5061-05 ")
 ;;44
 ;;21,"00093-5061-10 ")
 ;;45
 ;;21,"00093-5062-01 ")
 ;;46
 ;;21,"00093-5062-05 ")
 ;;47
 ;;21,"00093-5062-10 ")
 ;;48
 ;;21,"00093-9268-12 ")
 ;;49
 ;;21,"00093-9268-16 ")
 ;;50
 ;;21,"00095-0006-01 ")
 ;;51
 ;;21,"00095-0008-16 ")
 ;;52
 ;;21,"00095-0645-01 ")
 ;;53
 ;;21,"00095-1200-06 ")
 ;;54
 ;;21,"00095-1290-06 ")
 ;;55
 ;;21,"00095-6004-16 ")
 ;;56
 ;;21,"00095-6006-01 ")
 ;;57
 ;;21,"00095-9008-16 ")
 ;;58
 ;;21,"00113-0462-62 ")
 ;;59
 ;;21,"00113-0479-62 ")
 ;;60
 ;;21,"00113-0479-78 ")
 ;;61
 ;;21,"00115-1040-01 ")
 ;;62
 ;;21,"00115-1041-01 ")
 ;;63
 ;;21,"00115-1041-03 ")
 ;;64
 ;;21,"00115-1042-01 ")
 ;;65
 ;;21,"00121-0489-05 ")
 ;;66
 ;;21,"00121-0489-10 ")
 ;;67
 ;;21,"00121-0489-20 ")
 ;;68
 ;;21,"00121-0547-05 ")
 ;;69
 ;;21,"00121-0658-05 ")
 ;;70
 ;;21,"00121-0658-10 ")
 ;;71
 ;;21,"00121-0658-12 ")
 ;;72
 ;;21,"00121-0658-16 ")
 ;;73
 ;;21,"00121-4788-10 ")
 ;;74
 ;;21,"00143-1763-01 ")
 ;;75
 ;;21,"00143-1763-10 ")
 ;;76
 ;;21,"00143-1764-01 ")
 ;;77
 ;;21,"00143-1764-10 ")
 ;;78
 ;;21,"00143-9729-01 ")
 ;;79
 ;;21,"00143-9729-05 ")
 ;;80
 ;;21,"00143-9868-22 ")
 ;;81
 ;;21,"00143-9869-22 ")
 ;;82
 ;;21,"00172-2909-60 ")
 ;;83
 ;;21,"00172-2911-60 ")
 ;;84
 ;;21,"00172-2911-70 ")
 ;;85
 ;;21,"00172-2929-60 ")
 ;;86
 ;;21,"00172-2929-80 ")
 ;;87
 ;;21,"00182-0492-10 ")
 ;;88
 ;;21,"00182-1015-01 ")
 ;;89
 ;;21,"00182-1098-89 ")
 ;;90
 ;;21,"00182-1099-89 ")
 ;;91
 ;;21,"00182-1132-00 ")
 ;;92
 ;;21,"00182-1132-89 ")
 ;;93
 ;;21,"00182-1151-01 ")
 ;;94
 ;;21,"00182-1299-00 ")
 ;;95
 ;;21,"00182-1299-89 ")
 ;;96
 ;;21,"00182-1376-40 ")
 ;;97
 ;;21,"00182-1700-00 ")
 ;;98
 ;;21,"00182-1700-89 ")
 ;;99
 ;;21,"00182-1701-00 ")
 ;;100
 ;;21,"00182-1701-89 ")
 ;;101
 ;;21,"00182-6171-66 ")
 ;;102
 ;;21,"00182-7099-11 ")
 ;;103
 ;;21,"00182-7100-11 ")
 ;;104
 ;;21,"00182-7101-11 ")
 ;;105
 ;;21,"00182-8222-00 ")
 ;;106
 ;;21,"00182-8222-89 ")
 ;;107
 ;;21,"00185-0613-01 ")
 ;;108
 ;;21,"00185-0613-05 ")
 ;;109
 ;;21,"00185-0615-01 ")
 ;;110
 ;;21,"00185-0615-05 ")
 ;;111
 ;;21,"00185-1304-01 ")
 ;;112
 ;;21,"00185-1304-10 ")
 ;;113
 ;;21,"00217-0409-01 ")
 ;;114
 ;;21,"00247-0073-00 ")
 ;;115
 ;;21,"00247-0073-02 ")
 ;;116
 ;;21,"00247-0073-04 ")
 ;;117
 ;;21,"00247-0073-05 ")
 ;;118
 ;;21,"00247-0073-06 ")
 ;;119
 ;;21,"00247-0073-08 ")
 ;;120
 ;;21,"00247-0073-10 ")
 ;;121
 ;;21,"00247-0073-12 ")
 ;;122
 ;;21,"00247-0073-14 ")
 ;;123
 ;;21,"00247-0073-15 ")
 ;;124
 ;;21,"00247-0073-16 ")
 ;;125
 ;;21,"00247-0073-20 ")
 ;;126
 ;;21,"00247-0073-21 ")
 ;;127
 ;;21,"00247-0073-24 ")
 ;;128
 ;;21,"00247-0073-25 ")
 ;;129
 ;;21,"00247-0073-30 ")
 ;;130
 ;;21,"00247-0073-99 ")
 ;;131
 ;;21,"00247-0105-00 ")
 ;;132
 ;;21,"00247-0105-02 ")
 ;;133
 ;;21,"00247-0105-04 ")
 ;;134
 ;;21,"00247-0105-05 ")
 ;;135
 ;;21,"00247-0105-06 ")
 ;;136
 ;;21,"00247-0105-10 ")
 ;;137
 ;;21,"00247-0105-12 ")
 ;;138
 ;;21,"00247-0105-14 ")
 ;;139
 ;;21,"00247-0105-15 ")
 ;;140
 ;;21,"00247-0105-20 ")
 ;;141
 ;;21,"00247-0105-21 ")
 ;;142
 ;;21,"00247-0105-24 ")
 ;;143
 ;;21,"00247-0105-30 ")
 ;;144
 ;;21,"00247-0105-35 ")
 ;;145
 ;;21,"00247-0120-00 ")
 ;;146
 ;;21,"00247-0120-02 ")
 ;;147
 ;;21,"00247-0120-03 ")
 ;;148
 ;;21,"00247-0120-04 ")
 ;;149
 ;;21,"00247-0120-06 ")
 ;;150
 ;;21,"00247-0120-07 ")
 ;;151
 ;;21,"00247-0120-08 ")
 ;;152
 ;;21,"00247-0120-10 ")
 ;;153
 ;;21,"00247-0120-12 ")
 ;;154
 ;;21,"00247-0120-14 ")
 ;;155
 ;;21,"00247-0120-15 ")
 ;;156
 ;;21,"00247-0120-20 ")
 ;;157
 ;;21,"00247-0120-24 ")
 ;;158
 ;;21,"00247-0120-30 ")
 ;;159
 ;;21,"00247-0127-10 ")
 ;;160
 ;;21,"00247-0127-12 ")
 ;;161
 ;;21,"00247-0127-15 ")
 ;;162
 ;;21,"00247-0127-20 ")
 ;;163
 ;;21,"00247-0127-30 ")
 ;;164
 ;;21,"00247-0204-01 ")
 ;;165
 ;;21,"00247-0204-02 ")
 ;;166
 ;;21,"00247-0204-04 ")
 ;;167
 ;;21,"00247-0204-06 ")
 ;;168
 ;;21,"00247-0204-12 ")
 ;;169
 ;;21,"00247-0205-01 ")
 ;;170
 ;;21,"00247-0205-02 ")
 ;;171
 ;;21,"00247-0205-03 ")
 ;;172
 ;;21,"00247-0205-04 ")
 ;;173
 ;;21,"00247-0205-06 ")
 ;;174
 ;;21,"00247-0205-12 ")
 ;;175
 ;;21,"00247-0651-01 ")
 ;;176
 ;;21,"00247-0651-04 ")
 ;;177
 ;;21,"00247-0651-06 ")
 ;;178
 ;;21,"00247-0723-08 ")
 ;;179
 ;;21,"00247-0723-10 ")
 ;;180
 ;;21,"00247-0723-12 ")
 ;;181
 ;;21,"00247-0723-20 ")
 ;;182
 ;;21,"00247-0829-14 ")
 ;;183
 ;;21,"00247-0868-77 ")
 ;;184
 ;;21,"00247-1074-03 ")
 ;;185
 ;;21,"00247-1074-06 ")
 ;;186
 ;;21,"00247-1074-20 ")
 ;;187
 ;;21,"00247-1322-12 ")
 ;;188
 ;;21,"00254-4206-28 ")
 ;;189
 ;;21,"00254-5971-28 ")
 ;;190
 ;;21,"00254-5971-38 ")
 ;;191
 ;;21,"00254-5972-28 ")
 ;;192
 ;;21,"00254-5972-38 ")
 ;;193
 ;;21,"00256-0127-01 ")
 ;;194
 ;;21,"00256-0133-01 ")
 ;;195
 ;;21,"00277-0176-01 ")
 ;;196
 ;;21,"00277-0183-01 ")
 ;;197
 ;;21,"00277-0186-41 ")
 ;;198
 ;;21,"00314-1400-70 ")
 ;;199
 ;;21,"00314-2236-70 ")
 ;;200
 ;;21,"00314-2237-70 ")
 ;;201
 ;;21,"00364-0484-01 ")
 ;;202
 ;;21,"00364-0495-01 ")
 ;;203
 ;;21,"00372-0048-04 ")
 ;;204
 ;;21,"00372-0048-08 ")
 ;;205
 ;;21,"00372-0048-16 ")
 ;;206
 ;;21,"00372-0048-28 ")
 ;;207
 ;;21,"00378-2586-01 ")
 ;;208
 ;;21,"00378-2586-10 ")
 ;;209
 ;;21,"00378-2587-01 ")
 ;;210
 ;;21,"00378-2587-10 ")
 ;;211
 ;;21,"00378-2588-01 ")
 ;;212
 ;;21,"00378-2588-10 ")
 ;;213
 ;;21,"00378-7028-01 ")
 ;;214
 ;;21,"00378-7028-10 ")
 ;;215
 ;;21,"00378-7029-01 ")
 ;;216
 ;;21,"00378-7029-10 ")
 ;;217
 ;;21,"00378-7030-01 ")
 ;;218
 ;;21,"00378-7030-10 ")
 ;;219
 ;;21,"00406-2040-01 ")
 ;;220
 ;;21,"00406-2041-01 ")
 ;;221
 ;;21,"00406-2041-10 ")
 ;;222
 ;;21,"00406-2042-01 ")
 ;;223
 ;;21,"00409-2312-02 ")
 ;;224
 ;;21,"00409-2312-31 ")
 ;;225
 ;;21,"00440-1617-12 ")
 ;;226
 ;;21,"00440-2365-20 ")
 ;;227
 ;;21,"00440-7195-30 ")
 ;;228
 ;;21,"00440-7195-60 ")
 ;;229
 ;;21,"00440-7195-90 ")
 ;;230
 ;;21,"00440-7195-92 ")
 ;;231
 ;;21,"00440-7196-30 ")
 ;;232
 ;;21,"00440-7196-60 ")
 ;;233
 ;;21,"00440-7196-90 ")
 ;;234
 ;;21,"00440-7196-92 ")
 ;;235
 ;;21,"00440-7277-30 ")
 ;;236
 ;;21,"00440-7280-30 ")
 ;;237
 ;;21,"00440-7360-30 ")
 ;;238
 ;;21,"00440-7365-10 ")
 ;;239
 ;;21,"00440-7365-12 ")
 ;;240
 ;;21,"00440-7365-20 ")
 ;;241
 ;;21,"00440-7365-30 ")
 ;;242
 ;;21,"00440-7365-60 ")
 ;;243
 ;;21,"00440-7425-04 ")
 ;;244
 ;;21,"00440-7425-05 ")
 ;;245
 ;;21,"00440-7425-06 ")
 ;;246
 ;;21,"00440-7425-10 ")
 ;;247
 ;;21,"00440-7425-12 ")
 ;;248
 ;;21,"00440-7425-16 ")
 ;;249
 ;;21,"00440-7425-20 ")
 ;;250
 ;;21,"00440-7425-24 ")
 ;;251
 ;;21,"00440-7425-30 ")
 ;;252
 ;;21,"00440-7425-60 ")
 ;;253
 ;;21,"00440-7426-04 ")
 ;;254
 ;;21,"00440-7426-06 ")
 ;;255
 ;;21,"00440-7426-09 ")
 ;;256
 ;;21,"00440-7426-12 ")
 ;;257
 ;;21,"00440-7426-20 ")
 ;;258
 ;;21,"00440-7426-30 ")
 ;;259
 ;;21,"00440-7426-60 ")
 ;;260
 ;;21,"00440-7616-30 ")
 ;;261
 ;;21,"00440-7617-04 ")
 ;;262
 ;;21,"00440-7617-06 ")
 ;;263
 ;;21,"00440-7617-12 ")
 ;;264
 ;;21,"00440-7617-15 ")
 ;;265
 ;;21,"00440-7617-16 ")
 ;;266
 ;;21,"00440-7617-21 ")
 ;;267
 ;;21,"00440-7617-30 ")
 ;;268
 ;;21,"00440-7617-99 ")
 ;;269
 ;;21,"00440-7620-04 ")
 ;;270
 ;;21,"00440-8195-04 ")
 ;;271
 ;;21,"00440-8195-06 ")
 ;;272
 ;;21,"00440-8195-10 ")
 ;;273
 ;;21,"00440-8195-12 ")
 ;;274
 ;;21,"00440-8195-20 ")
 ;;275
 ;;21,"00440-8195-99 ")
 ;;276
 ;;21,"00440-8255-10 ")
 ;;277
 ;;21,"00440-8255-12 ")
 ;;278
 ;;21,"00440-8255-14 ")
 ;;279
 ;;21,"00440-8255-20 ")
 ;;280
 ;;21,"00440-8255-30 ")
 ;;281
 ;;21,"00440-8255-60 ")
 ;;282
 ;;21,"00450-0108-25 ")
 ;;283
 ;;21,"00450-0108-49 ")
 ;;284
 ;;21,"00450-0226-14 ")
 ;;285
 ;;21,"00451-4000-50 ")
 ;;286
 ;;21,"00451-4000-60 ")
 ;;287
 ;;21,"00451-4001-50 ")
 ;;288
 ;;21,"00451-4001-60 ")
 ;;289
 ;;21,"00451-4060-50 ")
 ;;290
 ;;21,"00472-0096-12 ")
 ;;291
 ;;21,"00472-0727-16 ")
 ;;292
 ;;21,"00472-0731-04 ")
 ;;293
 ;;21,"00472-0731-16 ")
 ;;294
 ;;21,"00472-0731-28 ")
 ;;295
 ;;21,"00472-0733-31 ")
 ;;296
 ;;21,"00472-0755-16 ")
 ;;297
 ;;21,"00472-0771-16 ")
 ;;298
 ;;21,"00472-1400-16 ")
 ;;299
 ;;21,"00472-1504-04 ")
 ;;300
 ;;21,"00472-1504-08 ")
 ;;301
 ;;21,"00472-1504-16 ")
 ;;302
 ;;21,"00472-1504-28 ")
 ;;303
 ;;21,"00472-1627-04 ")
 ;;304
 ;;21,"00472-1627-08 ")
 ;;305
 ;;21,"00472-1627-16 ")
 ;;306
 ;;21,"00472-1627-28 ")
 ;;307
 ;;21,"00472-1628-04 ")
 ;;308
 ;;21,"00472-1628-08 ")
 ;;309
 ;;21,"00472-1628-16 ")
 ;;310
 ;;21,"00472-1628-28 ")
 ;;311
 ;;21,"00472-1629-04 ")
 ;;312
 ;;21,"00472-1629-08 ")
 ;;313
 ;;21,"00472-1629-16 ")
 ;;314
 ;;21,"00472-1629-28 ")
 ;;315
 ;;21,"00472-1630-04 ")
 ;;316
 ;;21,"00472-1630-16 ")
 ;;317
 ;;21,"00472-1630-28 ")
 ;;318
 ;;21,"00472-1633-04 ")
 ;;319
 ;;21,"00472-1633-16 ")
 ;;320
 ;;21,"00482-0181-10 ")
 ;;321
 ;;21,"00482-0181-50 ")
 ;;322
 ;;21,"00482-0184-10 ")
 ;;323
 ;;21,"00482-0185-16 ")
 ;;324
 ;;21,"00485-0054-01 ")
 ;;325
 ;;21,"00485-0055-16 ")
 ;;326
 ;;21,"00485-0072-01 ")
 ;;327
 ;;21,"00485-0074-02 ")
 ;;328
 ;;21,"00485-0076-02 ")
 ;;329
 ;;21,"00485-0094-02 ")
 ;;330
 ;;21,"00485-0098-04 ")
 ;;331
 ;;21,"00485-0098-16 ")
 ;;332
 ;;21,"00496-0382-02 ")
 ;;333
 ;;21,"00496-0434-02 ")
 ;;334
 ;;21,"00516-0430-01 ")
 ;;335
 ;;21,"00516-0430-24 ")
 ;;336
 ;;21,"00516-0510-01 ")
 ;;337
 ;;21,"00516-0510-50 ")
 ;;338
 ;;21,"00516-0512-01 ")
 ;;339
 ;;21,"00517-0785-05 ")
 ;;340
 ;;21,"00517-4201-25 ")
 ;;341
 ;;21,"00517-5601-25 ")
 ;;342
 ;;21,"00517-5602-25 ")
 ;;343
 ;;21,"00517-5610-25 ")
 ;;344
 ;;21,"00525-0781-16 ")
 ;;345
 ;;21,"00525-0880-01 ")
 ;;346
 ;;21,"00525-6121-01 ")
 ;;347
 ;;21,"00525-6131-01 ")
 ;;348
 ;;21,"00525-6425-16 ")
 ;;349
 ;;21,"00525-6435-16 ")
 ;;350
 ;;21,"00525-6748-01 ")
 ;;351
 ;;21,"00525-6748-05 ")
 ;;352
 ;;21,"00525-6752-04 ")
 ;;353
 ;;21,"00525-6752-16 ")
 ;;354
 ;;21,"00551-0059-10 ")
 ;;355
 ;;21,"00551-0147-01 ")
 ;;356
 ;;21,"00551-0222-01 ")
 ;;357
 ;;21,"00551-0223-01 ")
 ;;358
 ;;21,"00551-0224-01 ")
 ;;359
 ;;21,"00555-0059-02 ")
 ;;360
 ;;21,"00555-0059-05 ")
 ;;361
 ;;21,"00555-0302-02 ")
 ;;362
 ;;21,"00555-0302-04 ")
 ;;363
 ;;21,"00555-0323-02 ")
 ;;364
 ;;21,"00555-0323-04 ")
 ;;365
 ;;21,"00555-0324-02 ")
 ;;366
 ;;21,"00574-0836-25 ")
 ;;367
 ;;21,"00574-7234-12 ")
 ;;368
 ;;21,"00574-7236-12 ")
 ;;369
 ;;21,"00591-0800-01 ")
 ;;370
 ;;21,"00591-0800-05 ")
 ;;371
 ;;21,"00591-0801-01 ")
 ;;372
 ;;21,"00591-0801-05 ")
 ;;373
 ;;21,"00591-2160-39 ")
 ;;374
 ;;21,"00591-2161-39 ")
 ;;375
 ;;21,"00591-3157-54 ")
 ;;376
 ;;21,"00591-3157-83 ")
 ;;377
 ;;21,"00591-3158-54 ")
 ;;378
 ;;21,"00591-3158-83 ")
 ;;379
 ;;21,"00591-3423-01 ")
 ;;380
 ;;21,"00591-3423-05 ")
 ;;381
 ;;21,"00591-3423-10 ")
 ;;382
 ;;21,"00591-4008-01 ")
 ;;383
 ;;21,"00591-4009-01 ")
 ;;384
 ;;21,"00591-5307-01 ")
 ;;385
 ;;21,"00591-5307-10 ")
 ;;386
 ;;21,"00591-5319-01 ")
 ;;387
 ;;21,"00591-5335-01 ")
 ;;388
 ;;21,"00591-5335-10 ")
 ;;389
 ;;21,"00591-5337-01 ")
 ;;390
 ;;21,"00591-5337-10 ")
 ;;391
 ;;21,"00591-5522-01 ")
 ;;392
 ;;21,"00591-5522-05 ")
 ;;393
 ;
OTHER ; OTHER ROUTINES
 D ^BGP47J10
 D ^BGP47J11
 D ^BGP47J12
 D ^BGP47J13
 D ^BGP47J14
 D ^BGP47J15
 D ^BGP47J16
 D ^BGP47J17
 D ^BGP47J18
 D ^BGP47J19
 D ^BGP47J2
 D ^BGP47J20
 D ^BGP47J21
 D ^BGP47J22
 D ^BGP47J23
 D ^BGP47J24
 D ^BGP47J25
 D ^BGP47J26
 D ^BGP47J27
 D ^BGP47J28
 D ^BGP47J29
 D ^BGP47J3
 D ^BGP47J30
 D ^BGP47J31
 D ^BGP47J32
 D ^BGP47J33
 D ^BGP47J34
 D ^BGP47J35
 D ^BGP47J36
 D ^BGP47J37
 D ^BGP47J4
 D ^BGP47J5
 D ^BGP47J6
 D ^BGP47J7
 D ^BGP47J8
 D ^BGP47J9
 Q