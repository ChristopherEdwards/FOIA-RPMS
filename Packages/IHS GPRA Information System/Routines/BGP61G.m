BGP61G ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;;BGP PQA CCB NDC
 ;
 ; This routine loads Taxonomy BGP PQA CCB NDC
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
 ;;21,"00025-1851-31 ")
 ;;1
 ;;21,"00025-1861-31 ")
 ;;2
 ;;21,"00025-1891-31 ")
 ;;3
 ;;21,"00025-1891-34 ")
 ;;4
 ;;21,"00025-1891-51 ")
 ;;5
 ;;21,"00025-1901-31 ")
 ;;6
 ;;21,"00025-1911-31 ")
 ;;7
 ;;21,"00025-2011-31 ")
 ;;8
 ;;21,"00025-2011-34 ")
 ;;9
 ;;21,"00025-2021-31 ")
 ;;10
 ;;21,"00025-2021-34 ")
 ;;11
 ;;21,"00054-0100-22 ")
 ;;12
 ;;21,"00054-0100-31 ")
 ;;13
 ;;21,"00054-0101-20 ")
 ;;14
 ;;21,"00054-0101-22 ")
 ;;15
 ;;21,"00054-0101-28 ")
 ;;16
 ;;21,"00054-0101-31 ")
 ;;17
 ;;21,"00054-0102-20 ")
 ;;18
 ;;21,"00054-0102-22 ")
 ;;19
 ;;21,"00054-0102-28 ")
 ;;20
 ;;21,"00054-0102-31 ")
 ;;21
 ;;21,"00069-1520-68 ")
 ;;22
 ;;21,"00069-1530-41 ")
 ;;23
 ;;21,"00069-1530-68 ")
 ;;24
 ;;21,"00069-1530-72 ")
 ;;25
 ;;21,"00069-1540-41 ")
 ;;26
 ;;21,"00069-1540-68 ")
 ;;27
 ;;21,"00069-2150-30 ")
 ;;28
 ;;21,"00069-2160-30 ")
 ;;29
 ;;21,"00069-2170-30 ")
 ;;30
 ;;21,"00069-2180-30 ")
 ;;31
 ;;21,"00069-2190-30 ")
 ;;32
 ;;21,"00069-2250-30 ")
 ;;33
 ;;21,"00069-2260-30 ")
 ;;34
 ;;21,"00069-2270-30 ")
 ;;35
 ;;21,"00069-2650-41 ")
 ;;36
 ;;21,"00069-2650-66 ")
 ;;37
 ;;21,"00069-2650-72 ")
 ;;38
 ;;21,"00069-2660-41 ")
 ;;39
 ;;21,"00069-2660-66 ")
 ;;40
 ;;21,"00069-2660-72 ")
 ;;41
 ;;21,"00069-2670-66 ")
 ;;42
 ;;21,"00069-2960-30 ")
 ;;43
 ;;21,"00069-2970-30 ")
 ;;44
 ;;21,"00069-2980-30 ")
 ;;45
 ;;21,"00074-3045-30 ")
 ;;46
 ;;21,"00074-3045-90 ")
 ;;47
 ;;21,"00074-3061-30 ")
 ;;48
 ;;21,"00074-3061-90 ")
 ;;49
 ;;21,"00074-3062-30 ")
 ;;50
 ;;21,"00074-3062-90 ")
 ;;51
 ;;21,"00074-3063-30 ")
 ;;52
 ;;21,"00074-3063-90 ")
 ;;53
 ;;21,"00074-3064-30 ")
 ;;54
 ;;21,"00074-3064-90 ")
 ;;55
 ;;21,"00074-3069-30 ")
 ;;56
 ;;21,"00074-3069-90 ")
 ;;57
 ;;21,"00074-3287-13 ")
 ;;58
 ;;21,"00074-3288-13 ")
 ;;59
 ;;21,"00074-3289-13 ")
 ;;60
 ;;21,"00074-3290-13 ")
 ;;61
 ;;21,"00078-0364-05 ")
 ;;62
 ;;21,"00078-0379-05 ")
 ;;63
 ;;21,"00078-0384-05 ")
 ;;64
 ;;21,"00078-0404-05 ")
 ;;65
 ;;21,"00078-0405-05 ")
 ;;66
 ;;21,"00078-0406-05 ")
 ;;67
 ;;21,"00078-0488-15 ")
 ;;68
 ;;21,"00078-0489-15 ")
 ;;69
 ;;21,"00078-0490-15 ")
 ;;70
 ;;21,"00078-0491-15 ")
 ;;71
 ;;21,"00078-0559-15 ")
 ;;72
 ;;21,"00078-0559-30 ")
 ;;73
 ;;21,"00078-0560-15 ")
 ;;74
 ;;21,"00078-0560-30 ")
 ;;75
 ;;21,"00078-0561-15 ")
 ;;76
 ;;21,"00078-0561-30 ")
 ;;77
 ;;21,"00078-0562-15 ")
 ;;78
 ;;21,"00078-0562-30 ")
 ;;79
 ;;21,"00078-0563-15 ")
 ;;80
 ;;21,"00078-0563-30 ")
 ;;81
 ;;21,"00078-0603-15 ")
 ;;82
 ;;21,"00078-0604-15 ")
 ;;83
 ;;21,"00078-0605-15 ")
 ;;84
 ;;21,"00078-0606-15 ")
 ;;85
 ;;21,"00078-0610-15 ")
 ;;86
 ;;21,"00078-0611-15 ")
 ;;87
 ;;21,"00078-0612-15 ")
 ;;88
 ;;21,"00078-0613-15 ")
 ;;89
 ;;21,"00078-0614-15 ")
 ;;90
 ;;21,"00085-1701-01 ")
 ;;91
 ;;21,"00085-1701-02 ")
 ;;92
 ;;21,"00085-1701-03 ")
 ;;93
 ;;21,"00085-1716-01 ")
 ;;94
 ;;21,"00085-1716-02 ")
 ;;95
 ;;21,"00085-1716-03 ")
 ;;96
 ;;21,"00085-1722-01 ")
 ;;97
 ;;21,"00085-1722-02 ")
 ;;98
 ;;21,"00091-2489-23 ")
 ;;99
 ;;21,"00091-2490-23 ")
 ;;100
 ;;21,"00091-2491-23 ")
 ;;101
 ;;21,"00091-2495-23 ")
 ;;102
 ;;21,"00091-4085-01 ")
 ;;103
 ;;21,"00091-4086-01 ")
 ;;104
 ;;21,"00091-4087-01 ")
 ;;105
 ;;21,"00093-0083-98 ")
 ;;106
 ;;21,"00093-0318-01 ")
 ;;107
 ;;21,"00093-0318-05 ")
 ;;108
 ;;21,"00093-0319-01 ")
 ;;109
 ;;21,"00093-0319-05 ")
 ;;110
 ;;21,"00093-0320-01 ")
 ;;111
 ;;21,"00093-0321-01 ")
 ;;112
 ;;21,"00093-0819-01 ")
 ;;113
 ;;21,"00093-0819-55 ")
 ;;114
 ;;21,"00093-1022-01 ")
 ;;115
 ;;21,"00093-1022-19 ")
 ;;116
 ;;21,"00093-1022-55 ")
 ;;117
 ;;21,"00093-1022-93 ")
 ;;118
 ;;21,"00093-1023-01 ")
 ;;119
 ;;21,"00093-2057-01 ")
 ;;120
 ;;21,"00093-2057-55 ")
 ;;121
 ;;21,"00093-2058-01 ")
 ;;122
 ;;21,"00093-2058-55 ")
 ;;123
 ;;21,"00093-2059-01 ")
 ;;124
 ;;21,"00093-3043-01 ")
 ;;125
 ;;21,"00093-3044-01 ")
 ;;126
 ;;21,"00093-3044-05 ")
 ;;127
 ;;21,"00093-3045-01 ")
 ;;128
 ;;21,"00093-3045-05 ")
 ;;129
 ;;21,"00093-5112-98 ")
 ;;130
 ;;21,"00093-5117-98 ")
 ;;131
 ;;21,"00093-5118-98 ")
 ;;132
 ;;21,"00093-5119-98 ")
 ;;133
 ;;21,"00093-5173-01 ")
 ;;134
 ;;21,"00093-5173-55 ")
 ;;135
 ;;21,"00093-5272-01 ")
 ;;136
 ;;21,"00093-5272-19 ")
 ;;137
 ;;21,"00093-5272-55 ")
 ;;138
 ;;21,"00093-5272-93 ")
 ;;139
 ;;21,"00093-7037-56 ")
 ;;140
 ;;21,"00093-7037-98 ")
 ;;141
 ;;21,"00093-7038-56 ")
 ;;142
 ;;21,"00093-7038-98 ")
 ;;143
 ;;21,"00093-7167-55 ")
 ;;144
 ;;21,"00093-7167-98 ")
 ;;145
 ;;21,"00093-7168-98 ")
 ;;146
 ;;21,"00093-7370-01 ")
 ;;147
 ;;21,"00093-7371-01 ")
 ;;148
 ;;21,"00093-7371-10 ")
 ;;149
 ;;21,"00093-7372-01 ")
 ;;150
 ;;21,"00093-7372-10 ")
 ;;151
 ;;21,"00093-7373-01 ")
 ;;152
 ;;21,"00093-7373-10 ")
 ;;153
 ;;21,"00093-7670-01 ")
 ;;154
 ;;21,"00093-7671-01 ")
 ;;155
 ;;21,"00093-7690-56 ")
 ;;156
 ;;21,"00093-7690-98 ")
 ;;157
 ;;21,"00093-7691-56 ")
 ;;158
 ;;21,"00093-7691-98 ")
 ;;159
 ;;21,"00093-7692-56 ")
 ;;160
 ;;21,"00093-7692-98 ")
 ;;161
 ;;21,"00093-7693-56 ")
 ;;162
 ;;21,"00093-7693-98 ")
 ;;163
 ;;21,"00093-7807-56 ")
 ;;164
 ;;21,"00093-7807-98 ")
 ;;165
 ;;21,"00093-7809-56 ")
 ;;166
 ;;21,"00093-7809-98 ")
 ;;167
 ;;21,"00093-7810-56 ")
 ;;168
 ;;21,"00093-7810-98 ")
 ;;169
 ;;21,"00143-9959-09 ")
 ;;170
 ;;21,"00143-9960-09 ")
 ;;171
 ;;21,"00143-9961-09 ")
 ;;172
 ;;21,"00172-4280-00 ")
 ;;173
 ;;21,"00172-4280-10 ")
 ;;174
 ;;21,"00172-4280-60 ")
 ;;175
 ;;21,"00172-4280-70 ")
 ;;176
 ;;21,"00172-4285-00 ")
 ;;177
 ;;21,"00172-4285-10 ")
 ;;178
 ;;21,"00172-4285-60 ")
 ;;179
 ;;21,"00172-4286-00 ")
 ;;180
 ;;21,"00172-4286-10 ")
 ;;181
 ;;21,"00172-4286-60 ")
 ;;182
 ;;21,"00172-4286-70 ")
 ;;183
 ;;21,"00173-0784-01 ")
 ;;184
 ;;21,"00173-0785-01 ")
 ;;185
 ;;21,"00187-0771-47 ")
 ;;186
 ;;21,"00187-0772-47 ")
 ;;187
 ;;21,"00187-0792-47 ")
 ;;188
 ;;21,"00187-0795-30 ")
 ;;189
 ;;21,"00187-0795-42 ")
 ;;190
 ;;21,"00187-0796-30 ")
 ;;191
 ;;21,"00187-0796-42 ")
 ;;192
 ;;21,"00187-0797-30 ")
 ;;193
 ;;21,"00187-0797-42 ")
 ;;194
 ;;21,"00187-0798-30 ")
 ;;195
 ;;21,"00187-0798-42 ")
 ;;196
 ;;21,"00187-0799-42 ")
 ;;197
 ;;21,"00187-2045-30 ")
 ;;198
 ;;21,"00187-2045-90 ")
 ;;199
 ;;21,"00187-2046-30 ")
 ;;200
 ;;21,"00187-2046-90 ")
 ;;201
 ;;21,"00187-2047-30 ")
 ;;202
 ;;21,"00187-2047-90 ")
 ;;203
 ;;21,"00187-2048-30 ")
 ;;204
 ;;21,"00187-2048-90 ")
 ;;205
 ;;21,"00187-2049-30 ")
 ;;206
 ;;21,"00187-2050-30 ")
 ;;207
 ;;21,"00187-2612-30 ")
 ;;208
 ;;21,"00187-2612-90 ")
 ;;209
 ;;21,"00187-2613-30 ")
 ;;210
 ;;21,"00187-2613-90 ")
 ;;211
 ;;21,"00187-2614-30 ")
 ;;212
 ;;21,"00187-2614-90 ")
 ;;213
 ;;21,"00187-2615-30 ")
 ;;214
 ;;21,"00187-2615-90 ")
 ;;215
 ;;21,"00187-2616-30 ")
 ;;216
 ;;21,"00187-2616-90 ")
 ;;217
 ;;21,"00187-2617-30 ")
 ;;218
 ;;21,"00187-2617-90 ")
 ;;219
 ;;21,"00228-1112-03 ")
 ;;220
 ;;21,"00228-1112-09 ")
 ;;221
 ;;21,"00228-1113-03 ")
 ;;222
 ;;21,"00228-1113-09 ")
 ;;223
 ;;21,"00228-1114-03 ")
 ;;224
 ;;21,"00228-1114-09 ")
 ;;225
 ;;21,"00228-1115-03 ")
 ;;226
 ;;21,"00228-1115-09 ")
 ;;227
 ;;21,"00228-1116-03 ")
 ;;228
 ;;21,"00228-1116-09 ")
 ;;229
 ;;21,"00228-1117-03 ")
 ;;230
 ;;21,"00228-1117-09 ")
 ;;231
 ;;21,"00228-2577-03 ")
 ;;232
 ;;21,"00228-2577-09 ")
 ;;233
 ;;21,"00228-2577-50 ")
 ;;234
 ;;21,"00228-2578-03 ")
 ;;235
 ;;21,"00228-2578-09 ")
 ;;236
 ;;21,"00228-2578-50 ")
 ;;237
 ;;21,"00228-2579-03 ")
 ;;238
 ;;21,"00228-2579-09 ")
 ;;239
 ;;21,"00228-2579-50 ")
 ;;240
 ;;21,"00228-2588-03 ")
 ;;241
 ;;21,"00228-2588-09 ")
 ;;242
 ;;21,"00228-2588-50 ")
 ;;243
 ;;21,"00228-2918-03 ")
 ;;244
 ;;21,"00228-2918-09 ")
 ;;245
 ;;21,"00258-3687-90 ")
 ;;246
 ;;21,"00258-3688-90 ")
 ;;247
 ;;21,"00258-3689-90 ")
 ;;248
 ;;21,"00258-3690-90 ")
 ;;249
 ;;21,"00258-3691-90 ")
 ;;250
 ;;21,"00258-3692-90 ")
 ;;251
 ;;21,"00378-0023-01 ")
 ;;252
 ;;21,"00378-0023-05 ")
 ;;253
 ;;21,"00378-0045-01 ")
 ;;254
 ;;21,"00378-0045-05 ")
 ;;255
 ;;21,"00378-0135-01 ")
 ;;256
 ;;21,"00378-0135-05 ")
 ;;257
 ;;21,"00378-0353-01 ")
 ;;258
 ;;21,"00378-0353-10 ")
 ;;259
 ;;21,"00378-0360-01 ")
 ;;260
 ;;21,"00378-0360-10 ")
 ;;261
 ;;21,"00378-0390-01 ")
 ;;262
 ;;21,"00378-0480-01 ")
 ;;263
 ;;21,"00378-0480-30 ")
 ;;264
 ;;21,"00378-0481-01 ")
 ;;265
 ;;21,"00378-0481-30 ")
 ;;266
 ;;21,"00378-0494-01 ")
 ;;267
 ;;21,"00378-0512-01 ")
 ;;268
 ;;21,"00378-0512-10 ")
 ;;269
 ;;21,"00378-0525-01 ")
 ;;270
 ;;21,"00378-0772-01 ")
 ;;271
 ;;21,"00378-0772-05 ")
 ;;272
 ;;21,"00378-1020-05 ")
 ;;273
 ;;21,"00378-1020-77 ")
 ;;274
 ;;21,"00378-1075-93 ")
 ;;275
 ;;21,"00378-1076-93 ")
 ;;276
 ;;21,"00378-1077-93 ")
 ;;277
 ;;21,"00378-1078-93 ")
 ;;278
 ;;21,"00378-1411-01 ")
 ;;279
 ;;21,"00378-1411-05 ")
 ;;280
 ;;21,"00378-1411-77 ")
 ;;281
 ;;21,"00378-1430-05 ")
 ;;282
 ;;21,"00378-1430-77 ")
 ;;283
 ;;21,"00378-1721-93 ")
 ;;284
 ;;21,"00378-1722-93 ")
 ;;285
 ;;21,"00378-1723-93 ")
 ;;286
 ;;21,"00378-1724-93 ")
 ;;287
 ;;21,"00378-2096-01 ")
 ;;288
 ;;21,"00378-2097-01 ")
 ;;289
 ;;21,"00378-2098-01 ")
 ;;290
 ;;21,"00378-2099-01 ")
 ;;291
 ;;21,"00378-2120-01 ")
 ;;292
 ;;21,"00378-2120-93 ")
 ;;293
 ;;21,"00378-2180-01 ")
 ;;294
 ;;21,"00378-2180-05 ")
 ;;295
 ;;21,"00378-2222-01 ")
 ;;296
 ;;21,"00378-2223-01 ")
 ;;297
 ;;21,"00378-2224-01 ")
 ;;298
 ;;21,"00378-3475-01 ")
 ;;299
 ;;21,"00378-3475-30 ")
 ;;300
 ;;21,"00378-3482-01 ")
 ;;301
 ;;21,"00378-3482-30 ")
 ;;302
 ;;21,"00378-3495-01 ")
 ;;303
 ;;21,"00378-4510-93 ")
 ;;304
 ;;21,"00378-4511-93 ")
 ;;305
 ;;21,"00378-4512-93 ")
 ;;306
 ;;21,"00378-4513-05 ")
 ;;307
 ;;21,"00378-4513-93 ")
 ;;308
 ;;21,"00378-4514-05 ")
 ;;309
 ;;21,"00378-4514-93 ")
 ;;310
 ;;21,"00378-4515-05 ")
 ;;311
 ;;21,"00378-4515-93 ")
 ;;312
 ;;21,"00378-4516-93 ")
 ;;313
 ;;21,"00378-4517-05 ")
 ;;314
 ;;21,"00378-4517-93 ")
 ;;315
 ;;21,"00378-4518-05 ")
 ;;316
 ;;21,"00378-4518-93 ")
 ;;317
 ;;21,"00378-4519-05 ")
 ;;318
 ;;21,"00378-4519-93 ")
 ;;319
 ;;21,"00378-4520-93 ")
 ;;320
 ;;21,"00378-5011-01 ")
 ;;321
 ;;21,"00378-5011-05 ")
 ;;322
 ;;21,"00378-5012-01 ")
 ;;323
 ;;21,"00378-5012-05 ")
 ;;324
 ;;21,"00378-5013-01 ")
 ;;325
 ;;21,"00378-5013-05 ")
 ;;326
 ;;21,"00378-5208-05 ")
 ;;327
 ;;21,"00378-5208-77 ")
 ;;328
 ;;21,"00378-5209-05 ")
 ;;329
 ;;21,"00378-5209-77 ")
 ;;330
 ;;21,"00378-5210-05 ")
 ;;331
 ;;21,"00378-5210-77 ")
 ;;332
 ;;21,"00378-5220-01 ")
 ;;333
 ;;21,"00378-5220-05 ")
 ;;334
 ;;21,"00378-5280-01 ")
 ;;335
 ;;21,"00378-5280-05 ")
 ;;336
 ;;21,"00378-5340-01 ")
 ;;337
 ;;21,"00378-5340-05 ")
 ;;338
 ;;21,"00378-6060-01 ")
 ;;339
 ;;21,"00378-6090-01 ")
 ;;340
 ;;21,"00378-6120-01 ")
 ;;341
 ;;21,"00378-6161-77 ")
 ;;342
 ;;21,"00378-6161-93 ")
 ;;343
 ;;21,"00378-6162-77 ")
 ;;344
 ;;21,"00378-6162-93 ")
 ;;345
 ;;21,"00378-6163-77 ")
 ;;346
 ;;21,"00378-6163-93 ")
 ;;347
 ;;21,"00378-6164-05 ")
 ;;348
 ;;21,"00378-6164-77 ")
 ;;349
 ;;21,"00378-6164-93 ")
 ;;350
 ;;21,"00378-6165-05 ")
 ;;351
 ;;21,"00378-6165-77 ")
 ;;352
 ;;21,"00378-6165-93 ")
 ;;353
 ;;21,"00378-6166-05 ")
 ;;354
 ;;21,"00378-6166-77 ")
 ;;355
 ;;21,"00378-6166-93 ")
 ;;356
 ;;21,"00378-6167-77 ")
 ;;357
 ;;21,"00378-6167-93 ")
 ;;358
 ;;21,"00378-6168-05 ")
 ;;359
 ;;21,"00378-6168-77 ")
 ;;360
 ;;21,"00378-6168-93 ")
 ;;361
 ;;21,"00378-6169-05 ")
 ;;362
 ;;21,"00378-6169-77 ")
 ;;363
 ;;21,"00378-6169-93 ")
 ;;364
 ;;21,"00378-6170-05 ")
 ;;365
 ;;21,"00378-6170-77 ")
 ;;366
 ;;21,"00378-6170-93 ")
 ;;367
 ;
OTHER ; OTHER ROUTINES
 D ^BGP61G10
 D ^BGP61G11
 D ^BGP61G12
 D ^BGP61G13
 D ^BGP61G14
 D ^BGP61G15
 D ^BGP61G16
 D ^BGP61G17
 D ^BGP61G18
 D ^BGP61G19
 D ^BGP61G2
 D ^BGP61G20
 D ^BGP61G21
 D ^BGP61G22
 D ^BGP61G23
 D ^BGP61G24
 D ^BGP61G25
 D ^BGP61G26
 D ^BGP61G27
 D ^BGP61G28
 D ^BGP61G29
 D ^BGP61G3
 D ^BGP61G4
 D ^BGP61G5
 D ^BGP61G6
 D ^BGP61G7
 D ^BGP61G8
 D ^BGP61G9
 Q