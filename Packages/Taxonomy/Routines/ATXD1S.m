ATXD1S ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON OCT 28, 2013;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;;BGP CAUSE OF INJURY ECODES
 ;
 ; This routine loads Taxonomy BGP CAUSE OF INJURY ECODES
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
 ;;21,"E800.0 ")
 ;;1
 ;;21,"V00.01XA ")
 ;;2
 ;;21,"V00.02XA ")
 ;;3
 ;;21,"V00.09XA ")
 ;;4
 ;;21,"V00.111A ")
 ;;5
 ;;21,"V00.112A ")
 ;;6
 ;;21,"V00.118A ")
 ;;7
 ;;21,"V00.121A ")
 ;;8
 ;;21,"V00.122A ")
 ;;9
 ;;21,"V00.128A ")
 ;;10
 ;;21,"V00.131A ")
 ;;11
 ;;21,"V00.132A ")
 ;;12
 ;;21,"V00.138A ")
 ;;13
 ;;21,"V00.141A ")
 ;;14
 ;;21,"V00.142A ")
 ;;15
 ;;21,"V00.148A ")
 ;;16
 ;;21,"V00.151A ")
 ;;17
 ;;21,"V00.152A ")
 ;;18
 ;;21,"V00.158A ")
 ;;19
 ;;21,"V00.181A ")
 ;;20
 ;;21,"V00.182A ")
 ;;21
 ;;21,"V00.188A ")
 ;;22
 ;;21,"V00.211A ")
 ;;23
 ;;21,"V00.212A ")
 ;;24
 ;;21,"V00.218A ")
 ;;25
 ;;21,"V00.221A ")
 ;;26
 ;;21,"V00.222A ")
 ;;27
 ;;21,"V00.228A ")
 ;;28
 ;;21,"V00.281A ")
 ;;29
 ;;21,"V00.282A ")
 ;;30
 ;;21,"V00.288A ")
 ;;31
 ;;21,"V00.311A ")
 ;;32
 ;;21,"V00.312A ")
 ;;33
 ;;21,"V00.318A ")
 ;;34
 ;;21,"V00.321A ")
 ;;35
 ;;21,"V00.322A ")
 ;;36
 ;;21,"V00.328A ")
 ;;37
 ;;21,"V00.381A ")
 ;;38
 ;;21,"V00.382A ")
 ;;39
 ;;21,"V00.388A ")
 ;;40
 ;;21,"V00.811A ")
 ;;41
 ;;21,"V00.812A ")
 ;;42
 ;;21,"V00.818A ")
 ;;43
 ;;21,"V00.821A ")
 ;;44
 ;;21,"V00.822A ")
 ;;45
 ;;21,"V00.828A ")
 ;;46
 ;;21,"V00.831A ")
 ;;47
 ;;21,"V00.832A ")
 ;;48
 ;;21,"V00.838A ")
 ;;49
 ;;21,"V00.891A ")
 ;;50
 ;;21,"V00.892A ")
 ;;51
 ;;21,"V00.898A ")
 ;;52
 ;;21,"V01.00XA ")
 ;;53
 ;;21,"V01.01XA ")
 ;;54
 ;;21,"V01.02XA ")
 ;;55
 ;;21,"V01.09XA ")
 ;;56
 ;;21,"V01.10XA ")
 ;;57
 ;;21,"V01.11XA ")
 ;;58
 ;;21,"V01.12XA ")
 ;;59
 ;;21,"V01.19XA ")
 ;;60
 ;;21,"V01.90XA ")
 ;;61
 ;;21,"V01.91XA ")
 ;;62
 ;;21,"V01.92XA ")
 ;;63
 ;;21,"V01.99XA ")
 ;;64
 ;;21,"V02.00XA ")
 ;;65
 ;;21,"V02.01XA ")
 ;;66
 ;;21,"V02.02XA ")
 ;;67
 ;;21,"V02.09XA ")
 ;;68
 ;;21,"V02.10XA ")
 ;;69
 ;;21,"V02.11XA ")
 ;;70
 ;;21,"V02.12XA ")
 ;;71
 ;;21,"V02.19XA ")
 ;;72
 ;;21,"V02.90XA ")
 ;;73
 ;;21,"V02.91XA ")
 ;;74
 ;;21,"V02.92XA ")
 ;;75
 ;;21,"V02.99XA ")
 ;;76
 ;;21,"V03.00XA ")
 ;;77
 ;;21,"V03.01XA ")
 ;;78
 ;;21,"V03.02XA ")
 ;;79
 ;;21,"V03.09XA ")
 ;;80
 ;;21,"V03.10XA ")
 ;;81
 ;;21,"V03.11XA ")
 ;;82
 ;;21,"V03.12XA ")
 ;;83
 ;;21,"V03.19XA ")
 ;;84
 ;;21,"V03.90XA ")
 ;;85
 ;;21,"V03.91XA ")
 ;;86
 ;;21,"V03.92XA ")
 ;;87
 ;;21,"V03.99XA ")
 ;;88
 ;;21,"V04.00XA ")
 ;;89
 ;;21,"V04.01XA ")
 ;;90
 ;;21,"V04.02XA ")
 ;;91
 ;;21,"V04.09XA ")
 ;;92
 ;;21,"V04.10XA ")
 ;;93
 ;;21,"V04.11XA ")
 ;;94
 ;;21,"V04.12XA ")
 ;;95
 ;;21,"V04.19XA ")
 ;;96
 ;;21,"V04.90XA ")
 ;;97
 ;;21,"V04.91XA ")
 ;;98
 ;;21,"V04.92XA ")
 ;;99
 ;;21,"V04.99XA ")
 ;;100
 ;;21,"V05.00XA ")
 ;;101
 ;;21,"V05.01XA ")
 ;;102
 ;;21,"V05.02XA ")
 ;;103
 ;;21,"V05.09XA ")
 ;;104
 ;;21,"V05.10XA ")
 ;;105
 ;;21,"V05.11XA ")
 ;;106
 ;;21,"V05.12XA ")
 ;;107
 ;;21,"V05.19XA ")
 ;;108
 ;;21,"V05.90XA ")
 ;;109
 ;;21,"V05.91XA ")
 ;;110
 ;;21,"V05.92XA ")
 ;;111
 ;;21,"V05.99XA ")
 ;;112
 ;;21,"V06.00XA ")
 ;;113
 ;;21,"V06.01XA ")
 ;;114
 ;;21,"V06.02XA ")
 ;;115
 ;;21,"V06.09XA ")
 ;;116
 ;;21,"V06.10XA ")
 ;;117
 ;;21,"V06.11XA ")
 ;;118
 ;;21,"V06.12XA ")
 ;;119
 ;;21,"V06.19XA ")
 ;;120
 ;;21,"V06.90XA ")
 ;;121
 ;;21,"V06.91XA ")
 ;;122
 ;;21,"V06.92XA ")
 ;;123
 ;;21,"V06.99XA ")
 ;;124
 ;;21,"V09.00XA ")
 ;;125
 ;;21,"V09.01XA ")
 ;;126
 ;;21,"V09.09XA ")
 ;;127
 ;;21,"V09.1XXA ")
 ;;128
 ;;21,"V09.20XA ")
 ;;129
 ;;21,"V09.21XA ")
 ;;130
 ;;21,"V09.29XA ")
 ;;131
 ;;21,"V09.3XXA ")
 ;;132
 ;;21,"V09.9XXA ")
 ;;133
 ;;21,"V10.0XXA ")
 ;;134
 ;;21,"V10.1XXA ")
 ;;135
 ;;21,"V10.2XXA ")
 ;;136
 ;;21,"V10.3XXA ")
 ;;137
 ;;21,"V10.4XXA ")
 ;;138
 ;;21,"V10.5XXA ")
 ;;139
 ;;21,"V10.9XXA ")
 ;;140
 ;;21,"V11.0XXA ")
 ;;141
 ;;21,"V11.1XXA ")
 ;;142
 ;;21,"V11.2XXA ")
 ;;143
 ;;21,"V11.3XXA ")
 ;;144
 ;;21,"V11.4XXA ")
 ;;145
 ;;21,"V11.5XXA ")
 ;;146
 ;;21,"V11.9XXA ")
 ;;147
 ;;21,"V12.0XXA ")
 ;;148
 ;;21,"V12.1XXA ")
 ;;149
 ;;21,"V12.2XXA ")
 ;;150
 ;;21,"V12.3XXA ")
 ;;151
 ;;21,"V12.4XXA ")
 ;;152
 ;;21,"V12.5XXA ")
 ;;153
 ;;21,"V12.9XXA ")
 ;;154
 ;;21,"V13.0XXA ")
 ;;155
 ;;21,"V13.1XXA ")
 ;;156
 ;;21,"V13.2XXA ")
 ;;157
 ;;21,"V13.3XXA ")
 ;;158
 ;;21,"V13.4XXA ")
 ;;159
 ;;21,"V13.5XXA ")
 ;;160
 ;;21,"V13.9XXA ")
 ;;161
 ;;21,"V14.0XXA ")
 ;;162
 ;;21,"V14.1XXA ")
 ;;163
 ;;21,"V14.2XXA ")
 ;;164
 ;;21,"V14.3XXA ")
 ;;165
 ;;21,"V14.4XXA ")
 ;;166
 ;;21,"V14.5XXA ")
 ;;167
 ;;21,"V14.9XXA ")
 ;;168
 ;;21,"V15.0XXA ")
 ;;169
 ;;21,"V15.1XXA ")
 ;;170
 ;;21,"V15.2XXA ")
 ;;171
 ;;21,"V15.3XXA ")
 ;;172
 ;;21,"V15.4XXA ")
 ;;173
 ;;21,"V15.5XXA ")
 ;;174
 ;;21,"V15.9XXA ")
 ;;175
 ;;21,"V16.0XXA ")
 ;;176
 ;;21,"V16.1XXA ")
 ;;177
 ;;21,"V16.2XXA ")
 ;;178
 ;;21,"V16.3XXA ")
 ;;179
 ;;21,"V16.4XXA ")
 ;;180
 ;;21,"V16.5XXA ")
 ;;181
 ;;21,"V16.9XXA ")
 ;;182
 ;;21,"V17.0XXA ")
 ;;183
 ;;21,"V17.1XXA ")
 ;;184
 ;;21,"V17.2XXA ")
 ;;185
 ;;21,"V17.3XXA ")
 ;;186
 ;;21,"V17.4XXA ")
 ;;187
 ;;21,"V17.5XXA ")
 ;;188
 ;;21,"V17.9XXA ")
 ;;189
 ;;21,"V18.0XXA ")
 ;;190
 ;;21,"V18.1XXA ")
 ;;191
 ;;21,"V18.2XXA ")
 ;;192
 ;;21,"V18.3XXA ")
 ;;193
 ;;21,"V18.4XXA ")
 ;;194
 ;;21,"V18.5XXA ")
 ;;195
 ;;21,"V18.9XXA ")
 ;;196
 ;;21,"V19.00XA ")
 ;;197
 ;;21,"V19.09XA ")
 ;;198
 ;;21,"V19.10XA ")
 ;;199
 ;;21,"V19.19XA ")
 ;;200
 ;;21,"V19.20XA ")
 ;;201
 ;;21,"V19.29XA ")
 ;;202
 ;;21,"V19.3XXA ")
 ;;203
 ;;21,"V19.40XA ")
 ;;204
 ;;21,"V19.49XA ")
 ;;205
 ;;21,"V19.50XA ")
 ;;206
 ;;21,"V19.59XA ")
 ;;207
 ;;21,"V19.60XA ")
 ;;208
 ;;21,"V19.69XA ")
 ;;209
 ;;21,"V19.81XA ")
 ;;210
 ;;21,"V19.88XA ")
 ;;211
 ;;21,"V19.9XXA ")
 ;;212
 ;;21,"V20.0XXA ")
 ;;213
 ;;21,"V20.1XXA ")
 ;;214
 ;;21,"V20.2XXA ")
 ;;215
 ;;21,"V20.3XXA ")
 ;;216
 ;;21,"V20.4XXA ")
 ;;217
 ;;21,"V20.5XXA ")
 ;;218
 ;;21,"V20.9XXA ")
 ;;219
 ;;21,"V21.0XXA ")
 ;;220
 ;;21,"V21.1XXA ")
 ;;221
 ;;21,"V21.2XXA ")
 ;;222
 ;;21,"V21.3XXA ")
 ;;223
 ;;21,"V21.4XXA ")
 ;;224
 ;;21,"V21.5XXA ")
 ;;225
 ;;21,"V21.9XXA ")
 ;;226
 ;;21,"V22.0XXA ")
 ;;227
 ;;21,"V22.1XXA ")
 ;;228
 ;;21,"V22.2XXA ")
 ;;229
 ;;21,"V22.3XXA ")
 ;;230
 ;;21,"V22.4XXA ")
 ;;231
 ;;21,"V22.5XXA ")
 ;;232
 ;;21,"V22.9XXA ")
 ;;233
 ;;21,"V23.0XXA ")
 ;;234
 ;;21,"V23.1XXA ")
 ;;235
 ;;21,"V23.2XXA ")
 ;;236
 ;;21,"V23.3XXA ")
 ;;237
 ;;21,"V23.4XXA ")
 ;;238
 ;;21,"V23.5XXA ")
 ;;239
 ;;21,"V23.9XXA ")
 ;;240
 ;;21,"V24.0XXA ")
 ;;241
 ;;21,"V24.1XXA ")
 ;;242
 ;;21,"V24.2XXA ")
 ;;243
 ;;21,"V24.3XXA ")
 ;;244
 ;;21,"V24.4XXA ")
 ;;245
 ;;21,"V24.5XXA ")
 ;;246
 ;;21,"V24.9XXA ")
 ;;247
 ;;21,"V25.0XXA ")
 ;;248
 ;;21,"V25.1XXA ")
 ;;249
 ;;21,"V25.2XXA ")
 ;;250
 ;;21,"V25.3XXA ")
 ;;251
 ;;21,"V25.4XXA ")
 ;;252
 ;;21,"V25.5XXA ")
 ;;253
 ;;21,"V25.9XXA ")
 ;;254
 ;;21,"V26.0XXA ")
 ;;255
 ;;21,"V26.1XXA ")
 ;;256
 ;;21,"V26.2XXA ")
 ;;257
 ;;21,"V26.3XXA ")
 ;;258
 ;;21,"V26.4XXA ")
 ;;259
 ;;21,"V26.5XXA ")
 ;;260
 ;;21,"V26.9XXA ")
 ;;261
 ;;21,"V27.0XXA ")
 ;;262
 ;;21,"V27.1XXA ")
 ;;263
 ;;21,"V27.2XXA ")
 ;;264
 ;;21,"V27.3XXA ")
 ;;265
 ;;21,"V27.4XXA ")
 ;;266
 ;;21,"V27.5XXA ")
 ;;267
 ;;21,"V27.9XXA ")
 ;;268
 ;;21,"V28.0XXA ")
 ;;269
 ;;21,"V28.1XXA ")
 ;;270
 ;;21,"V28.2XXA ")
 ;;271
 ;;21,"V28.3XXA ")
 ;;272
 ;;21,"V28.4XXA ")
 ;;273
 ;;21,"V28.5XXA ")
 ;;274
 ;;21,"V28.9XXA ")
 ;;275
 ;;21,"V29.00XA ")
 ;;276
 ;;21,"V29.09XA ")
 ;;277
 ;;21,"V29.10XA ")
 ;;278
 ;;21,"V29.19XA ")
 ;;279
 ;;21,"V29.20XA ")
 ;;280
 ;;21,"V29.29XA ")
 ;;281
 ;;21,"V29.3XXA ")
 ;;282
 ;;21,"V29.40XA ")
 ;;283
 ;;21,"V29.49XA ")
 ;;284
 ;;21,"V29.50XA ")
 ;;285
 ;;21,"V29.59XA ")
 ;;286
 ;;21,"V29.60XA ")
 ;;287
 ;;21,"V29.69XA ")
 ;;288
 ;;21,"V29.81XA ")
 ;;289
 ;;21,"V29.88XA ")
 ;;290
 ;;21,"V29.9XXA ")
 ;;291
 ;;21,"V30.0XXA ")
 ;;292
 ;;21,"V30.1XXA ")
 ;;293
 ;;21,"V30.2XXA ")
 ;;294
 ;;21,"V30.4XXA ")
 ;;295
 ;;21,"V30.5XXA ")
 ;;296
 ;;21,"V30.6XXA ")
 ;;297
 ;;21,"V30.7XXA ")
 ;;298
 ;;21,"V30.9XXA ")
 ;;299
 ;;21,"V31.0XXA ")
 ;;300
 ;;21,"V31.1XXA ")
 ;;301
 ;;21,"V31.2XXA ")
 ;;302
 ;;21,"V31.4XXA ")
 ;;303
 ;;21,"V31.5XXA ")
 ;;304
 ;;21,"V31.6XXA ")
 ;;305
 ;;21,"V31.7XXA ")
 ;;306
 ;;21,"V31.9XXA ")
 ;;307
 ;;21,"V32.0XXA ")
 ;;308
 ;;21,"V32.1XXA ")
 ;;309
 ;;21,"V32.2XXA ")
 ;;310
 ;;21,"V32.4XXA ")
 ;;311
 ;;21,"V32.5XXA ")
 ;;312
 ;;21,"V32.6XXA ")
 ;;313
 ;;21,"V32.7XXA ")
 ;;314
 ;;21,"V32.9XXA ")
 ;;315
 ;;21,"V33.0XXA ")
 ;;316
 ;;21,"V33.1XXA ")
 ;;317
 ;;21,"V33.2XXA ")
 ;;318
 ;;21,"V33.4XXA ")
 ;;319
 ;;21,"V33.5XXA ")
 ;;320
 ;;21,"V33.6XXA ")
 ;;321
 ;;21,"V33.7XXA ")
 ;;322
 ;;21,"V33.9XXA ")
 ;;323
 ;;21,"V34.0XXA ")
 ;;324
 ;;21,"V34.1XXA ")
 ;;325
 ;;21,"V34.2XXA ")
 ;;326
 ;;21,"V34.4XXA ")
 ;;327
 ;;21,"V34.5XXA ")
 ;;328
 ;;21,"V34.6XXA ")
 ;;329
 ;;21,"V34.7XXA ")
 ;;330
 ;;21,"V34.9XXA ")
 ;;331
 ;;21,"V35.0XXA ")
 ;;332
 ;;21,"V35.1XXA ")
 ;;333
 ;;21,"V35.2XXA ")
 ;;334
 ;;21,"V35.4XXA ")
 ;;335
 ;;21,"V35.5XXA ")
 ;;336
 ;;21,"V35.6XXA ")
 ;;337
 ;;21,"V35.7XXA ")
 ;;338
 ;;21,"V35.9XXA ")
 ;;339
 ;;21,"V36.0XXA ")
 ;;340
 ;;21,"V36.1XXA ")
 ;;341
 ;;21,"V36.2XXA ")
 ;;342
 ;;21,"V36.4XXA ")
 ;;343
 ;;21,"V36.5XXA ")
 ;;344
 ;;21,"V36.6XXA ")
 ;;345
 ;;21,"V36.7XXA ")
 ;;346
 ;;21,"V36.9XXA ")
 ;;347
 ;;21,"V37.0XXA ")
 ;;348
 ;;21,"V37.1XXA ")
 ;;349
 ;;21,"V37.2XXA ")
 ;;350
 ;;21,"V37.3XXA ")
 ;;351
 ;;21,"V37.4XXA ")
 ;;352
 ;;21,"V37.5XXA ")
 ;;353
 ;;21,"V37.6XXA ")
 ;;354
 ;;21,"V37.7XXA ")
 ;;355
 ;;21,"V37.9XXA ")
 ;;356
 ;;21,"V38.0XXA ")
 ;;357
 ;;21,"V38.1XXA ")
 ;;358
 ;;21,"V38.2XXA ")
 ;;359
 ;;21,"V38.3XXA ")
 ;;360
 ;;21,"V38.4XXA ")
 ;;361
 ;;21,"V38.5XXA ")
 ;;362
 ;;21,"V38.6XXA ")
 ;;363
 ;;21,"V38.7XXA ")
 ;;364
 ;;21,"V38.9XXA ")
 ;;365
 ;;21,"V39.00XA ")
 ;;366
 ;;21,"V39.09XA ")
 ;;367
 ;;21,"V39.10XA ")
 ;;368
 ;;21,"V39.19XA ")
 ;;369
 ;;21,"V39.20XA ")
 ;;370
 ;;21,"V39.29XA ")
 ;;371
 ;;21,"V39.3XXA ")
 ;;372
 ;;21,"V39.40XA ")
 ;;373
 ;;21,"V39.49XA ")
 ;;374
 ;;21,"V39.50XA ")
 ;;375
 ;;21,"V39.59XA ")
 ;;376
 ;;21,"V39.60XA ")
 ;;377
 ;;21,"V39.69XA ")
 ;;378
 ;;21,"V39.81XA ")
 ;;379
 ;;21,"V39.89XA ")
 ;;380
 ;;21,"V39.9XXA ")
 ;;381
 ;;21,"V40.0XXA ")
 ;;382
 ;;21,"V40.1XXA ")
 ;;383
 ;;21,"V40.2XXA ")
 ;;384
 ;;21,"V40.3XXA ")
 ;;385
 ;;21,"V40.4XXA ")
 ;;386
 ;;21,"V40.5XXA ")
 ;;387
 ;;21,"V40.6XXA ")
 ;;388
 ;;21,"V40.7XXA ")
 ;;389
 ;;21,"V40.9XXA ")
 ;;390
 ;;21,"V41.0XXA ")
 ;;391
 ;;21,"V41.1XXA ")
 ;;392
 ;;21,"V41.2XXA ")
 ;;393
 ;;21,"V41.3XXA ")
 ;;394
 ;;21,"V41.4XXA ")
 ;;395
 ;;21,"V41.5XXA ")
 ;;396
 ;;21,"V41.6XXA ")
 ;;397
 ;;21,"V41.7XXA ")
 ;;398
 ;;21,"V41.9XXA ")
 ;;399
 ;;21,"V42.0XXA ")
 ;;400
 ;;21,"V42.1XXA ")
 ;;401
 ;;21,"V42.2XXA ")
 ;;402
 ;;21,"V42.3XXA ")
 ;;403
 ;;21,"V42.4XXA ")
 ;;404
 ;;21,"V42.5XXA ")
 ;;405
 ;;21,"V42.6XXA ")
 ;;406
 ;;21,"V42.7XXA ")
 ;;407
 ;;21,"V42.9XXA ")
 ;;408
 ;;21,"V43.01XA ")
 ;;409
 ;;21,"V43.02XA ")
 ;;410
 ;;21,"V43.03XA ")
 ;;411
 ;;21,"V43.04XA ")
 ;;412
 ;;21,"V43.11XA ")
 ;;413
 ;;21,"V43.12XA ")
 ;;414
 ;;21,"V43.13XA ")
 ;;415
 ;;21,"V43.14XA ")
 ;;416
 ;;21,"V43.21XA ")
 ;;417
 ;;21,"V43.22XA ")
 ;;418
 ;;21,"V43.23XA ")
 ;;419
 ;;21,"V43.24XA ")
 ;;420
 ;;21,"V43.31XA ")
 ;;421
 ;;21,"V43.32XA ")
 ;;422
 ;;21,"V43.33XA ")
 ;;423
 ;;21,"V43.34XA ")
 ;;424
 ;;21,"V43.41XA ")
 ;;425
 ;;21,"V43.42XA ")
 ;;426
 ;;21,"V43.43XA ")
 ;;427
 ;;21,"V43.44XA ")
 ;;428
 ;;21,"V43.51XA ")
 ;;429
 ;;21,"V43.52XA ")
 ;;430
 ;;21,"V43.53XA ")
 ;;431
 ;;21,"V43.54XA ")
 ;;432
 ;;21,"V43.61XA ")
 ;;433
 ;;21,"V43.62XA ")
 ;;434
 ;;21,"V43.63XA ")
 ;;435
 ;;21,"V43.64XA ")
 ;;436
 ;;21,"V43.71XA ")
 ;;437
 ;;21,"V43.72XA ")
 ;;438
 ;;21,"V43.73XA ")
 ;;439
 ;;21,"V43.74XA ")
 ;;440
 ;;21,"V43.91XA ")
 ;;441
 ;;21,"V43.92XA ")
 ;;442
 ;;21,"V43.93XA ")
 ;;443
 ;;21,"V43.94XA ")
 ;;444
 ;;21,"V44.0XXA ")
 ;;445
 ;;21,"V44.1XXA ")
 ;;446
 ;;21,"V44.2XXA ")
 ;;447
 ;;21,"V44.3XXA ")
 ;;448
 ;;21,"V44.4XXA ")
 ;;449
 ;;21,"V44.5XXA ")
 ;;450
 ;;21,"V44.6XXA ")
 ;;451
 ;;21,"V44.7XXA ")
 ;;452
 ;;21,"V44.9XXA ")
 ;;453
 ;;21,"V45.0XXA ")
 ;;454
 ;
OTHER ; OTHER ROUTINES
 D ^ATXD1S10
 D ^ATXD1S11
 D ^ATXD1S12
 D ^ATXD1S13
 D ^ATXD1S14
 D ^ATXD1S15
 D ^ATXD1S16
 D ^ATXD1S17
 D ^ATXD1S18
 D ^ATXD1S19
 D ^ATXD1S2
 D ^ATXD1S20
 D ^ATXD1S21
 D ^ATXD1S22
 D ^ATXD1S23
 D ^ATXD1S24
 D ^ATXD1S25
 D ^ATXD1S26
 D ^ATXD1S3
 D ^ATXD1S4
 D ^ATXD1S5
 D ^ATXD1S6
 D ^ATXD1S7
 D ^ATXD1S8
 D ^ATXD1S9
 Q