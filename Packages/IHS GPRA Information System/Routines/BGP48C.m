BGP48C ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 17, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;;BGP PQA THIAZOLIDINEDIONE NDC
 ;
 ; This routine loads Taxonomy BGP PQA THIAZOLIDINEDIONE NDC
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
 ;;21,"00007-3166-18 ")
 ;;1
 ;;21,"00007-3166-20 ")
 ;;2
 ;;21,"00007-3167-20 ")
 ;;3
 ;;21,"00007-3168-20 ")
 ;;4
 ;;21,"00029-3151-13 ")
 ;;5
 ;;21,"00029-3152-13 ")
 ;;6
 ;;21,"00029-3153-13 ")
 ;;7
 ;;21,"00029-3159-18 ")
 ;;8
 ;;21,"00029-3159-20 ")
 ;;9
 ;;21,"00029-3160-20 ")
 ;;10
 ;;21,"00093-2046-05 ")
 ;;11
 ;;21,"00093-2046-56 ")
 ;;12
 ;;21,"00093-2046-98 ")
 ;;13
 ;;21,"00093-2047-05 ")
 ;;14
 ;;21,"00093-2047-56 ")
 ;;15
 ;;21,"00093-2047-98 ")
 ;;16
 ;;21,"00093-2048-05 ")
 ;;17
 ;;21,"00093-2048-56 ")
 ;;18
 ;;21,"00093-2048-98 ")
 ;;19
 ;;21,"00093-5049-06 ")
 ;;20
 ;;21,"00093-5049-86 ")
 ;;21
 ;;21,"00093-5050-06 ")
 ;;22
 ;;21,"00093-5050-86 ")
 ;;23
 ;;21,"00173-0834-18 ")
 ;;24
 ;;21,"00173-0835-13 ")
 ;;25
 ;;21,"00173-0836-13 ")
 ;;26
 ;;21,"00173-0837-18 ")
 ;;27
 ;;21,"00173-0838-18 ")
 ;;28
 ;;21,"00173-0839-18 ")
 ;;29
 ;;21,"00173-0840-18 ")
 ;;30
 ;;21,"00173-0841-13 ")
 ;;31
 ;;21,"00173-0842-13 ")
 ;;32
 ;;21,"00173-0843-13 ")
 ;;33
 ;;21,"00173-0844-13 ")
 ;;34
 ;;21,"00173-0845-13 ")
 ;;35
 ;;21,"00378-0048-05 ")
 ;;36
 ;;21,"00378-0048-77 ")
 ;;37
 ;;21,"00378-0048-93 ")
 ;;38
 ;;21,"00378-0228-05 ")
 ;;39
 ;;21,"00378-0228-77 ")
 ;;40
 ;;21,"00378-0228-93 ")
 ;;41
 ;;21,"00378-0318-05 ")
 ;;42
 ;;21,"00378-0318-77 ")
 ;;43
 ;;21,"00378-0318-93 ")
 ;;44
 ;;21,"00378-1550-91 ")
 ;;45
 ;;21,"00378-1575-91 ")
 ;;46
 ;;21,"00591-3205-05 ")
 ;;47
 ;;21,"00591-3205-19 ")
 ;;48
 ;;21,"00591-3205-30 ")
 ;;49
 ;;21,"00591-3206-05 ")
 ;;50
 ;;21,"00591-3206-19 ")
 ;;51
 ;;21,"00591-3206-30 ")
 ;;52
 ;;21,"00591-3207-05 ")
 ;;53
 ;;21,"00591-3207-19 ")
 ;;54
 ;;21,"00591-3207-30 ")
 ;;55
 ;;21,"00781-5420-10 ")
 ;;56
 ;;21,"00781-5420-31 ")
 ;;57
 ;;21,"00781-5420-92 ")
 ;;58
 ;;21,"00781-5421-10 ")
 ;;59
 ;;21,"00781-5421-31 ")
 ;;60
 ;;21,"00781-5421-92 ")
 ;;61
 ;;21,"00781-5422-10 ")
 ;;62
 ;;21,"00781-5422-31 ")
 ;;63
 ;;21,"00781-5422-92 ")
 ;;64
 ;;21,"00781-5626-60 ")
 ;;65
 ;;21,"00781-5627-60 ")
 ;;66
 ;;21,"00781-5634-31 ")
 ;;67
 ;;21,"00781-5635-31 ")
 ;;68
 ;;21,"12280-0003-60 ")
 ;;69
 ;;21,"12280-0004-60 ")
 ;;70
 ;;21,"12280-0060-15 ")
 ;;71
 ;;21,"12280-0060-30 ")
 ;;72
 ;;21,"12280-0062-00 ")
 ;;73
 ;;21,"12280-0062-30 ")
 ;;74
 ;;21,"12280-0062-90 ")
 ;;75
 ;;21,"12280-0078-30 ")
 ;;76
 ;;21,"13411-0101-01 ")
 ;;77
 ;;21,"13411-0101-03 ")
 ;;78
 ;;21,"13411-0101-06 ")
 ;;79
 ;;21,"13411-0101-09 ")
 ;;80
 ;;21,"13411-0101-15 ")
 ;;81
 ;;21,"13411-0102-01 ")
 ;;82
 ;;21,"13411-0102-03 ")
 ;;83
 ;;21,"13411-0102-06 ")
 ;;84
 ;;21,"13411-0102-09 ")
 ;;85
 ;;21,"13411-0102-15 ")
 ;;86
 ;;21,"13411-0103-01 ")
 ;;87
 ;;21,"13411-0103-03 ")
 ;;88
 ;;21,"13411-0103-06 ")
 ;;89
 ;;21,"13411-0103-09 ")
 ;;90
 ;;21,"13411-0103-15 ")
 ;;91
 ;;21,"13668-0119-05 ")
 ;;92
 ;;21,"13668-0119-30 ")
 ;;93
 ;;21,"13668-0119-90 ")
 ;;94
 ;;21,"13668-0120-05 ")
 ;;95
 ;;21,"13668-0120-30 ")
 ;;96
 ;;21,"13668-0120-90 ")
 ;;97
 ;;21,"13668-0140-05 ")
 ;;98
 ;;21,"13668-0140-30 ")
 ;;99
 ;;21,"13668-0140-90 ")
 ;;100
 ;;21,"13668-0280-33 ")
 ;;101
 ;;21,"13668-0280-60 ")
 ;;102
 ;;21,"13668-0281-33 ")
 ;;103
 ;;21,"13668-0281-60 ")
 ;;104
 ;;21,"16729-0020-10 ")
 ;;105
 ;;21,"16729-0020-15 ")
 ;;106
 ;;21,"16729-0020-16 ")
 ;;107
 ;;21,"16729-0021-10 ")
 ;;108
 ;;21,"16729-0021-15 ")
 ;;109
 ;;21,"16729-0021-16 ")
 ;;110
 ;;21,"16729-0022-10 ")
 ;;111
 ;;21,"16729-0022-15 ")
 ;;112
 ;;21,"16729-0022-16 ")
 ;;113
 ;;21,"21695-0147-15 ")
 ;;114
 ;;21,"21695-0148-15 ")
 ;;115
 ;;21,"23490-0104-03 ")
 ;;116
 ;;21,"23490-0105-03 ")
 ;;117
 ;;21,"23490-0106-03 ")
 ;;118
 ;;21,"35356-0130-60 ")
 ;;119
 ;;21,"35356-0271-60 ")
 ;;120
 ;;21,"47463-0583-30 ")
 ;;121
 ;;21,"47463-0584-30 ")
 ;;122
 ;;21,"47463-0585-30 ")
 ;;123
 ;;21,"47463-0764-60 ")
 ;;124
 ;;21,"47463-0765-30 ")
 ;;125
 ;;21,"47463-0766-30 ")
 ;;126
 ;;21,"49999-0304-30 ")
 ;;127
 ;;21,"49999-0449-15 ")
 ;;128
 ;;21,"49999-0449-30 ")
 ;;129
 ;;21,"49999-0450-30 ")
 ;;130
 ;;21,"49999-0451-30 ")
 ;;131
 ;;21,"49999-0451-90 ")
 ;;132
 ;;21,"49999-0935-30 ")
 ;;133
 ;;21,"51079-0513-01 ")
 ;;134
 ;;21,"51079-0513-20 ")
 ;;135
 ;;21,"51079-0514-01 ")
 ;;136
 ;;21,"51079-0514-20 ")
 ;;137
 ;;21,"51079-0515-01 ")
 ;;138
 ;;21,"51079-0515-20 ")
 ;;139
 ;;21,"51138-0214-15 ")
 ;;140
 ;;21,"51138-0214-30 ")
 ;;141
 ;;21,"51138-0215-15 ")
 ;;142
 ;;21,"51138-0215-30 ")
 ;;143
 ;;21,"51138-0216-15 ")
 ;;144
 ;;21,"51138-0216-30 ")
 ;;145
 ;;21,"51138-0495-20 ")
 ;;146
 ;;21,"51138-0495-30 ")
 ;;147
 ;;21,"51138-0496-30 ")
 ;;148
 ;;21,"51138-0497-30 ")
 ;;149
 ;;21,"51138-0498-30 ")
 ;;150
 ;;21,"51138-0499-30 ")
 ;;151
 ;;21,"51138-0500-30 ")
 ;;152
 ;;21,"51138-0501-30 ")
 ;;153
 ;;21,"51991-0708-10 ")
 ;;154
 ;;21,"51991-0708-33 ")
 ;;155
 ;;21,"51991-0708-90 ")
 ;;156
 ;;21,"51991-0709-10 ")
 ;;157
 ;;21,"51991-0709-33 ")
 ;;158
 ;;21,"51991-0709-90 ")
 ;;159
 ;;21,"51991-0710-10 ")
 ;;160
 ;;21,"51991-0710-33 ")
 ;;161
 ;;21,"51991-0710-90 ")
 ;;162
 ;;21,"54569-4801-00 ")
 ;;163
 ;;21,"54569-4802-00 ")
 ;;164
 ;;21,"54569-4803-00 ")
 ;;165
 ;;21,"54569-4880-00 ")
 ;;166
 ;;21,"54569-4881-00 ")
 ;;167
 ;;21,"54569-4882-00 ")
 ;;168
 ;;21,"54569-5603-00 ")
 ;;169
 ;;21,"54569-6354-00 ")
 ;;170
 ;;21,"54569-6354-01 ")
 ;;171
 ;;21,"54569-6355-00 ")
 ;;172
 ;;21,"54569-6355-01 ")
 ;;173
 ;;21,"54569-6356-00 ")
 ;;174
 ;;21,"54569-6356-01 ")
 ;;175
 ;;21,"54868-4198-00 ")
 ;;176
 ;;21,"54868-4198-01 ")
 ;;177
 ;;21,"54868-4221-00 ")
 ;;178
 ;;21,"54868-4343-00 ")
 ;;179
 ;;21,"54868-4343-01 ")
 ;;180
 ;;21,"54868-4354-00 ")
 ;;181
 ;;21,"54868-4354-01 ")
 ;;182
 ;;21,"54868-4391-00 ")
 ;;183
 ;;21,"54868-4391-01 ")
 ;;184
 ;;21,"54868-4965-00 ")
 ;;185
 ;;21,"54868-4965-01 ")
 ;;186
 ;;21,"54868-4965-02 ")
 ;;187
 ;;21,"54868-5157-00 ")
 ;;188
 ;;21,"54868-5157-01 ")
 ;;189
 ;;21,"54868-5249-00 ")
 ;;190
 ;;21,"54868-5249-01 ")
 ;;191
 ;;21,"54868-5262-00 ")
 ;;192
 ;;21,"54868-5262-01 ")
 ;;193
 ;;21,"54868-5376-00 ")
 ;;194
 ;;21,"54868-5379-00 ")
 ;;195
 ;;21,"54868-5500-00 ")
 ;;196
 ;;21,"54868-5500-01 ")
 ;;197
 ;;21,"54868-5500-02 ")
 ;;198
 ;;21,"54868-5553-00 ")
 ;;199
 ;;21,"54868-5553-01 ")
 ;;200
 ;;21,"54868-5553-02 ")
 ;;201
 ;;21,"54868-5739-00 ")
 ;;202
 ;;21,"55048-0583-30 ")
 ;;203
 ;;21,"55048-0584-30 ")
 ;;204
 ;;21,"55048-0585-30 ")
 ;;205
 ;;21,"55048-0764-60 ")
 ;;206
 ;;21,"55048-0765-30 ")
 ;;207
 ;;21,"55048-0766-30 ")
 ;;208
 ;;21,"55289-0540-30 ")
 ;;209
 ;;21,"55289-0862-15 ")
 ;;210
 ;;21,"55289-0862-30 ")
 ;;211
 ;;21,"55289-0938-30 ")
 ;;212
 ;;21,"57866-0069-08 ")
 ;;213
 ;;21,"57866-0069-09 ")
 ;;214
 ;;21,"57866-1264-02 ")
 ;;215
 ;;21,"57866-1364-03 ")
 ;;216
 ;;21,"58016-0081-00 ")
 ;;217
 ;;21,"58016-0081-30 ")
 ;;218
 ;;21,"58016-0081-60 ")
 ;;219
 ;;21,"58016-0081-90 ")
 ;;220
 ;;21,"58016-0082-00 ")
 ;;221
 ;;21,"58016-0082-30 ")
 ;;222
 ;;21,"58016-0082-60 ")
 ;;223
 ;;21,"58016-0082-90 ")
 ;;224
 ;;21,"58118-5420-01 ")
 ;;225
 ;;21,"58118-5420-03 ")
 ;;226
 ;;21,"58118-5420-06 ")
 ;;227
 ;;21,"58118-5420-09 ")
 ;;228
 ;;21,"58864-0670-14 ")
 ;;229
 ;;21,"58864-0670-30 ")
 ;;230
 ;;21,"58864-0687-30 ")
 ;;231
 ;;21,"58864-0687-60 ")
 ;;232
 ;;21,"58864-0745-15 ")
 ;;233
 ;;21,"58864-0745-30 ")
 ;;234
 ;;21,"58864-0827-60 ")
 ;;235
 ;;21,"60429-0330-10 ")
 ;;236
 ;;21,"60429-0330-30 ")
 ;;237
 ;;21,"60429-0330-90 ")
 ;;238
 ;;21,"60429-0331-10 ")
 ;;239
 ;;21,"60429-0331-30 ")
 ;;240
 ;;21,"60429-0331-90 ")
 ;;241
 ;;21,"60429-0332-10 ")
 ;;242
 ;;21,"60429-0332-30 ")
 ;;243
 ;;21,"60429-0332-90 ")
 ;;244
 ;;21,"63304-0254-05 ")
 ;;245
 ;;21,"63304-0254-30 ")
 ;;246
 ;;21,"63304-0254-90 ")
 ;;247
 ;;21,"63304-0255-05 ")
 ;;248
 ;;21,"63304-0255-30 ")
 ;;249
 ;;21,"63304-0255-90 ")
 ;;250
 ;;21,"63304-0261-05 ")
 ;;251
 ;;21,"63304-0261-30 ")
 ;;252
 ;;21,"63304-0261-90 ")
 ;;253
 ;;21,"63304-0311-05 ")
 ;;254
 ;;21,"63304-0311-30 ")
 ;;255
 ;;21,"63304-0311-90 ")
 ;;256
 ;;21,"63304-0312-05 ")
 ;;257
 ;;21,"63304-0312-30 ")
 ;;258
 ;;21,"63304-0312-90 ")
 ;;259
 ;;21,"63304-0313-05 ")
 ;;260
 ;;21,"63304-0313-30 ")
 ;;261
 ;;21,"63304-0313-90 ")
 ;;262
 ;;21,"63629-1269-01 ")
 ;;263
 ;;21,"64764-0121-03 ")
 ;;264
 ;;21,"64764-0123-03 ")
 ;;265
 ;;21,"64764-0124-03 ")
 ;;266
 ;;21,"64764-0151-04 ")
 ;;267
 ;;21,"64764-0151-05 ")
 ;;268
 ;;21,"64764-0151-06 ")
 ;;269
 ;;21,"64764-0155-18 ")
 ;;270
 ;;21,"64764-0155-60 ")
 ;;271
 ;;21,"64764-0158-18 ")
 ;;272
 ;;21,"64764-0158-60 ")
 ;;273
 ;;21,"64764-0251-03 ")
 ;;274
 ;;21,"64764-0253-03 ")
 ;;275
 ;;21,"64764-0254-03 ")
 ;;276
 ;;21,"64764-0301-14 ")
 ;;277
 ;;21,"64764-0301-15 ")
 ;;278
 ;;21,"64764-0301-16 ")
 ;;279
 ;;21,"64764-0302-30 ")
 ;;280
 ;;21,"64764-0304-30 ")
 ;;281
 ;;21,"64764-0310-30 ")
 ;;282
 ;;21,"64764-0451-24 ")
 ;;283
 ;;21,"64764-0451-25 ")
 ;;284
 ;;21,"64764-0451-26 ")
 ;;285
 ;;21,"64764-0510-30 ")
 ;;286
 ;;21,"65243-0195-09 ")
 ;;287
 ;;21,"65243-0195-12 ")
 ;;288
 ;;21,"65243-0196-09 ")
 ;;289
 ;;21,"65862-0512-30 ")
 ;;290
 ;;21,"65862-0513-30 ")
 ;;291
 ;;21,"65862-0514-30 ")
 ;;292
 ;;21,"65862-0525-18 ")
 ;;293
 ;;21,"65862-0525-60 ")
 ;;294
 ;;21,"65862-0526-18 ")
 ;;295
 ;;21,"65862-0526-60 ")
 ;;296
 ;;21,"66105-0145-01 ")
 ;;297
 ;;21,"66105-0145-03 ")
 ;;298
 ;;21,"66105-0145-06 ")
 ;;299
 ;;21,"66105-0145-09 ")
 ;;300
 ;;21,"66105-0145-15 ")
 ;;301
 ;;21,"66105-0154-01 ")
 ;;302
 ;;21,"66105-0154-03 ")
 ;;303
 ;;21,"66105-0154-06 ")
 ;;304
 ;;21,"66105-0154-09 ")
 ;;305
 ;;21,"66105-0154-15 ")
 ;;306
 ;;21,"66105-0156-01 ")
 ;;307
 ;;21,"66105-0156-03 ")
 ;;308
 ;;21,"66105-0156-06 ")
 ;;309
 ;;21,"66105-0156-09 ")
 ;;310
 ;;21,"66105-0156-15 ")
 ;;311
 ;;21,"66105-0159-01 ")
 ;;312
 ;;21,"66105-0159-03 ")
 ;;313
 ;;21,"66105-0159-06 ")
 ;;314
 ;;21,"66105-0159-09 ")
 ;;315
 ;;21,"66105-0159-15 ")
 ;;316
 ;;21,"66336-0360-30 ")
 ;;317
 ;;21,"66336-0361-30 ")
 ;;318
 ;;21,"66336-0857-30 ")
 ;;319
 ;;21,"66336-0857-90 ")
 ;;320
 ;;21,"66336-0858-30 ")
 ;;321
 ;;21,"66336-0858-90 ")
 ;;322
 ;;21,"66336-0859-30 ")
 ;;323
 ;;21,"66336-0859-90 ")
 ;;324
 ;;21,"67263-0025-90 ")
 ;;325
 ;;21,"67263-0026-90 ")
 ;;326
 ;;21,"67263-0027-90 ")
 ;;327
 ;;21,"67263-0087-90 ")
 ;;328
 ;;21,"67263-0222-30 ")
 ;;329
 ;;21,"67544-0065-30 ")
 ;;330
 ;;21,"67544-0065-53 ")
 ;;331
 ;;21,"67544-0065-60 ")
 ;;332
 ;;21,"67544-0066-30 ")
 ;;333
 ;;21,"67544-0066-45 ")
 ;;334
 ;;21,"67544-0066-60 ")
 ;;335
 ;;21,"67544-0113-60 ")
 ;;336
 ;;21,"67544-0113-70 ")
 ;;337
 ;;21,"67544-0113-80 ")
 ;;338
 ;;21,"67544-0114-15 ")
 ;;339
 ;;21,"67544-0114-45 ")
 ;;340
 ;;21,"67544-0114-60 ")
 ;;341
 ;;21,"67544-0114-82 ")
 ;;342
 ;;21,"67544-0254-53 ")
 ;;343
 ;;21,"68071-0405-15 ")
 ;;344
 ;;21,"68071-0406-15 ")
 ;;345
 ;;21,"68071-0407-15 ")
 ;;346
 ;;21,"68084-0629-01 ")
 ;;347
 ;;21,"68084-0629-11 ")
 ;;348
 ;;21,"68084-0630-01 ")
 ;;349
 ;;21,"68084-0630-11 ")
 ;;350
 ;;21,"68084-0631-01 ")
 ;;351
 ;;21,"68084-0631-11 ")
 ;;352
 ;;21,"68115-0671-15 ")
 ;;353
 ;;21,"68115-0671-20 ")
 ;;354
 ;;21,"68115-0671-30 ")
 ;;355
 ;;21,"68115-0671-90 ")
 ;;356
 ;;21,"68115-0684-30 ")
 ;;357
 ;;21,"68115-0712-60 ")
 ;;358
 ;;21,"68115-0841-30 ")
 ;;359
 ;;21,"68115-0891-60 ")
 ;;360
 ;;21,"68258-3034-03 ")
 ;;361
 ;;21,"68258-5230-03 ")
 ;;362
 ;;21,"68258-5991-03 ")
 ;;363
 ;;21,"68258-6007-03 ")
 ;;364
 ;;21,"68258-9051-01 ")
 ;;365
 ;;21,"68258-9116-01 ")
 ;;366
 ;;21,"68258-9151-01 ")
 ;;367
 ;;21,"68258-9152-01 ")
 ;;368
 ;;9002226,1200,.01)
 ;;BGP PQA THIAZOLIDINEDIONE NDC
 ;;9002226,1200,.02)
 ;;@
 ;;9002226,1200,.04)
 ;;n
 ;;9002226,1200,.06)
 ;;@
 ;;9002226,1200,.08)
 ;;@
 ;;9002226,1200,.09)
 ;;3140317
 ;;9002226,1200,.11)
 ;;@
 ;;9002226,1200,.12)
 ;;@
 ;;9002226,1200,.13)
 ;;1
 ;;9002226,1200,.14)
 ;;@
 ;;9002226,1200,.15)
 ;;@
 ;;9002226,1200,.16)
 ;;@
 ;;9002226,1200,.17)
 ;;@
 ;;9002226,1200,3101)
 ;;@
 ;;9002226.02101,"1200,00007-3166-18 ",.01)
 ;;00007-3166-18
 ;;9002226.02101,"1200,00007-3166-18 ",.02)
 ;;00007-3166-18
 ;;9002226.02101,"1200,00007-3166-20 ",.01)
 ;;00007-3166-20
 ;;9002226.02101,"1200,00007-3166-20 ",.02)
 ;;00007-3166-20
 ;;9002226.02101,"1200,00007-3167-20 ",.01)
 ;;00007-3167-20
 ;;9002226.02101,"1200,00007-3167-20 ",.02)
 ;;00007-3167-20
 ;;9002226.02101,"1200,00007-3168-20 ",.01)
 ;;00007-3168-20
 ;
OTHER ; OTHER ROUTINES
 D ^BGP48C2
 D ^BGP48C3
 D ^BGP48C4
 D ^BGP48C5
 Q