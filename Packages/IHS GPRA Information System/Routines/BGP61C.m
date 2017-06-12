BGP61C ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;;BGP HEDIS ENDOCRINE NDC
 ;
 ; This routine loads Taxonomy BGP HEDIS ENDOCRINE NDC
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
 ;;21,"00008-1123-12 ")
 ;;1
 ;;21,"00009-0341-01 ")
 ;;2
 ;;21,"00009-0352-01 ")
 ;;3
 ;;21,"00009-0352-04 ")
 ;;4
 ;;21,"00009-3449-01 ")
 ;;5
 ;;21,"00009-3449-03 ")
 ;;6
 ;;21,"00009-3774-17 ")
 ;;7
 ;;21,"00015-0508-42 ")
 ;;8
 ;;21,"00037-4801-35 ")
 ;;9
 ;;21,"00037-4802-35 ")
 ;;10
 ;;21,"00039-0051-10 ")
 ;;11
 ;;21,"00039-0052-10 ")
 ;;12
 ;;21,"00039-0052-70 ")
 ;;13
 ;;21,"00039-0053-05 ")
 ;;14
 ;;21,"00046-1100-81 ")
 ;;15
 ;;21,"00046-1100-91 ")
 ;;16
 ;;21,"00046-1101-81 ")
 ;;17
 ;;21,"00046-1102-81 ")
 ;;18
 ;;21,"00046-1102-91 ")
 ;;19
 ;;21,"00046-1103-81 ")
 ;;20
 ;;21,"00046-1104-81 ")
 ;;21
 ;;21,"00046-1104-91 ")
 ;;22
 ;;21,"00046-1105-11 ")
 ;;23
 ;;21,"00046-1106-11 ")
 ;;24
 ;;21,"00046-1107-11 ")
 ;;25
 ;;21,"00046-1108-11 ")
 ;;26
 ;;21,"00046-2575-12 ")
 ;;27
 ;;21,"00046-2579-11 ")
 ;;28
 ;;21,"00054-3542-58 ")
 ;;29
 ;;21,"00054-4603-25 ")
 ;;30
 ;;21,"00054-4604-25 ")
 ;;31
 ;;21,"00054-8603-25 ")
 ;;32
 ;;21,"00054-8604-25 ")
 ;;33
 ;;21,"00078-0343-42 ")
 ;;34
 ;;21,"00078-0343-45 ")
 ;;35
 ;;21,"00078-0343-62 ")
 ;;36
 ;;21,"00078-0344-42 ")
 ;;37
 ;;21,"00078-0344-45 ")
 ;;38
 ;;21,"00078-0344-62 ")
 ;;39
 ;;21,"00078-0345-42 ")
 ;;40
 ;;21,"00078-0345-45 ")
 ;;41
 ;;21,"00078-0345-62 ")
 ;;42
 ;;21,"00078-0346-42 ")
 ;;43
 ;;21,"00078-0346-45 ")
 ;;44
 ;;21,"00078-0346-62 ")
 ;;45
 ;;21,"00078-0365-42 ")
 ;;46
 ;;21,"00078-0365-45 ")
 ;;47
 ;;21,"00078-0377-42 ")
 ;;48
 ;;21,"00078-0377-62 ")
 ;;49
 ;;21,"00078-0378-42 ")
 ;;50
 ;;21,"00078-0378-62 ")
 ;;51
 ;;21,"00087-6072-11 ")
 ;;52
 ;;21,"00087-6073-11 ")
 ;;53
 ;;21,"00087-6074-11 ")
 ;;54
 ;;21,"00093-3122-42 ")
 ;;55
 ;;21,"00093-3122-98 ")
 ;;56
 ;;21,"00093-5454-28 ")
 ;;57
 ;;21,"00093-5454-62 ")
 ;;58
 ;;21,"00093-5455-28 ")
 ;;59
 ;;21,"00093-5455-42 ")
 ;;60
 ;;21,"00093-5710-01 ")
 ;;61
 ;;21,"00093-5710-05 ")
 ;;62
 ;;21,"00093-5710-19 ")
 ;;63
 ;;21,"00093-5711-01 ")
 ;;64
 ;;21,"00093-5711-05 ")
 ;;65
 ;;21,"00093-5711-19 ")
 ;;66
 ;;21,"00093-5711-93 ")
 ;;67
 ;;21,"00093-5712-01 ")
 ;;68
 ;;21,"00093-5712-05 ")
 ;;69
 ;;21,"00093-5712-19 ")
 ;;70
 ;;21,"00093-5712-93 ")
 ;;71
 ;;21,"00093-7261-05 ")
 ;;72
 ;;21,"00093-7262-05 ")
 ;;73
 ;;21,"00093-8034-01 ")
 ;;74
 ;;21,"00093-8035-01 ")
 ;;75
 ;;21,"00093-8035-05 ")
 ;;76
 ;;21,"00093-8036-01 ")
 ;;77
 ;;21,"00093-8342-01 ")
 ;;78
 ;;21,"00093-8343-01 ")
 ;;79
 ;;21,"00093-8343-05 ")
 ;;80
 ;;21,"00093-8343-10 ")
 ;;81
 ;;21,"00093-8343-98 ")
 ;;82
 ;;21,"00093-8344-01 ")
 ;;83
 ;;21,"00093-8344-05 ")
 ;;84
 ;;21,"00093-8344-10 ")
 ;;85
 ;;21,"00093-8344-19 ")
 ;;86
 ;;21,"00093-8344-93 ")
 ;;87
 ;;21,"00093-8344-98 ")
 ;;88
 ;;21,"00093-9364-01 ")
 ;;89
 ;;21,"00093-9364-05 ")
 ;;90
 ;;21,"00093-9364-10 ")
 ;;91
 ;;21,"00093-9433-01 ")
 ;;92
 ;;21,"00093-9433-05 ")
 ;;93
 ;;21,"00093-9477-53 ")
 ;;94
 ;;21,"00121-4776-10 ")
 ;;95
 ;;21,"00121-4776-20 ")
 ;;96
 ;;21,"00121-4776-35 ")
 ;;97
 ;;21,"00143-9918-01 ")
 ;;98
 ;;21,"00143-9919-01 ")
 ;;99
 ;;21,"00143-9919-05 ")
 ;;100
 ;;21,"00143-9920-01 ")
 ;;101
 ;;21,"00143-9920-05 ")
 ;;102
 ;;21,"00143-9920-10 ")
 ;;103
 ;;21,"00169-5174-01 ")
 ;;104
 ;;21,"00169-5174-02 ")
 ;;105
 ;;21,"00169-5175-10 ")
 ;;106
 ;;21,"00169-5175-11 ")
 ;;107
 ;;21,"00182-2646-89 ")
 ;;108
 ;;21,"00228-2751-11 ")
 ;;109
 ;;21,"00228-2751-50 ")
 ;;110
 ;;21,"00228-2752-11 ")
 ;;111
 ;;21,"00228-2752-50 ")
 ;;112
 ;;21,"00228-2753-11 ")
 ;;113
 ;;21,"00228-2753-50 ")
 ;;114
 ;;21,"00245-0880-30 ")
 ;;115
 ;;21,"00245-0881-30 ")
 ;;116
 ;;21,"00245-0882-30 ")
 ;;117
 ;;21,"00378-0197-01 ")
 ;;118
 ;;21,"00378-0197-05 ")
 ;;119
 ;;21,"00378-0210-01 ")
 ;;120
 ;;21,"00378-1113-01 ")
 ;;121
 ;;21,"00378-1125-01 ")
 ;;122
 ;;21,"00378-1125-10 ")
 ;;123
 ;;21,"00378-1142-01 ")
 ;;124
 ;;21,"00378-1452-01 ")
 ;;125
 ;;21,"00378-1452-05 ")
 ;;126
 ;;21,"00378-1454-01 ")
 ;;127
 ;;21,"00378-1454-05 ")
 ;;128
 ;;21,"00378-1458-01 ")
 ;;129
 ;;21,"00378-1458-05 ")
 ;;130
 ;;21,"00378-1458-77 ")
 ;;131
 ;;21,"00378-3349-16 ")
 ;;132
 ;;21,"00378-3349-99 ")
 ;;133
 ;;21,"00378-3350-16 ")
 ;;134
 ;;21,"00378-3350-99 ")
 ;;135
 ;;21,"00378-3351-16 ")
 ;;136
 ;;21,"00378-3351-99 ")
 ;;137
 ;;21,"00378-3352-16 ")
 ;;138
 ;;21,"00378-3352-99 ")
 ;;139
 ;;21,"00378-3360-99 ")
 ;;140
 ;;21,"00378-3361-16 ")
 ;;141
 ;;21,"00378-3361-99 ")
 ;;142
 ;;21,"00378-4551-01 ")
 ;;143
 ;;21,"00378-4553-01 ")
 ;;144
 ;;21,"00378-4640-16 ")
 ;;145
 ;;21,"00378-4640-26 ")
 ;;146
 ;;21,"00378-4641-26 ")
 ;;147
 ;;21,"00378-4642-26 ")
 ;;148
 ;;21,"00378-4643-26 ")
 ;;149
 ;;21,"00378-4644-26 ")
 ;;150
 ;;21,"00430-0145-14 ")
 ;;151
 ;;21,"00430-0720-24 ")
 ;;152
 ;;21,"00430-0721-24 ")
 ;;153
 ;;21,"00430-0722-24 ")
 ;;154
 ;;21,"00440-7570-20 ")
 ;;155
 ;;21,"00440-7571-14 ")
 ;;156
 ;;21,"00440-7571-30 ")
 ;;157
 ;;21,"00440-7571-60 ")
 ;;158
 ;;21,"00440-7571-90 ")
 ;;159
 ;;21,"00440-7571-91 ")
 ;;160
 ;;21,"00440-7571-92 ")
 ;;161
 ;;21,"00440-7571-94 ")
 ;;162
 ;;21,"00440-7571-95 ")
 ;;163
 ;;21,"00440-7585-90 ")
 ;;164
 ;;21,"00440-7587-90 ")
 ;;165
 ;;21,"00440-7589-90 ")
 ;;166
 ;;21,"00440-7589-95 ")
 ;;167
 ;;21,"00440-7749-10 ")
 ;;168
 ;;21,"00440-7749-20 ")
 ;;169
 ;;21,"00440-7749-30 ")
 ;;170
 ;;21,"00440-7749-60 ")
 ;;171
 ;;21,"00440-8170-30 ")
 ;;172
 ;;21,"00440-8170-60 ")
 ;;173
 ;;21,"00440-8170-90 ")
 ;;174
 ;;21,"00440-8171-30 ")
 ;;175
 ;;21,"00440-8171-60 ")
 ;;176
 ;;21,"00440-8171-90 ")
 ;;177
 ;;21,"00440-8172-30 ")
 ;;178
 ;;21,"00440-8172-60 ")
 ;;179
 ;;21,"00440-8172-90 ")
 ;;180
 ;;21,"00456-0457-01 ")
 ;;181
 ;;21,"00456-0458-01 ")
 ;;182
 ;;21,"00456-0458-11 ")
 ;;183
 ;;21,"00456-0458-63 ")
 ;;184
 ;;21,"00456-0459-01 ")
 ;;185
 ;;21,"00456-0459-11 ")
 ;;186
 ;;21,"00456-0459-63 ")
 ;;187
 ;;21,"00456-0460-01 ")
 ;;188
 ;;21,"00456-0461-01 ")
 ;;189
 ;;21,"00456-0461-63 ")
 ;;190
 ;;21,"00456-0462-01 ")
 ;;191
 ;;21,"00456-0463-01 ")
 ;;192
 ;;21,"00456-0464-01 ")
 ;;193
 ;;21,"00555-0606-02 ")
 ;;194
 ;;21,"00555-0607-02 ")
 ;;195
 ;;21,"00555-0607-04 ")
 ;;196
 ;;21,"00555-0886-02 ")
 ;;197
 ;;21,"00555-0886-04 ")
 ;;198
 ;;21,"00555-0887-02 ")
 ;;199
 ;;21,"00555-0887-04 ")
 ;;200
 ;;21,"00555-0899-02 ")
 ;;201
 ;;21,"00591-0414-01 ")
 ;;202
 ;;21,"00591-0415-01 ")
 ;;203
 ;;21,"00591-0416-01 ")
 ;;204
 ;;21,"00591-0487-01 ")
 ;;205
 ;;21,"00591-0487-05 ")
 ;;206
 ;;21,"00591-0488-01 ")
 ;;207
 ;;21,"00591-0488-05 ")
 ;;208
 ;;21,"00591-0528-01 ")
 ;;209
 ;;21,"00781-7129-40 ")
 ;;210
 ;;21,"00781-7129-83 ")
 ;;211
 ;;21,"00781-7138-40 ")
 ;;212
 ;;21,"00781-7138-83 ")
 ;;213
 ;;21,"00781-7144-40 ")
 ;;214
 ;;21,"00781-7144-83 ")
 ;;215
 ;;21,"00781-7156-40 ")
 ;;216
 ;;21,"00781-7156-83 ")
 ;;217
 ;;21,"00781-7167-40 ")
 ;;218
 ;;21,"00781-7167-83 ")
 ;;219
 ;;21,"00904-3571-61 ")
 ;;220
 ;;21,"00904-6137-60 ")
 ;;221
 ;;21,"00904-6138-40 ")
 ;;222
 ;;21,"00904-6138-60 ")
 ;;223
 ;;21,"00904-6139-60 ")
 ;;224
 ;;21,"00904-6139-80 ")
 ;;225
 ;;21,"10135-0469-01 ")
 ;;226
 ;;21,"10135-0470-01 ")
 ;;227
 ;;21,"10544-0579-30 ")
 ;;228
 ;;21,"10544-0579-90 ")
 ;;229
 ;;21,"11528-0010-01 ")
 ;;230
 ;;21,"11528-0020-01 ")
 ;;231
 ;;21,"13925-0171-01 ")
 ;;232
 ;;21,"13925-0172-01 ")
 ;;233
 ;;21,"15310-0010-01 ")
 ;;234
 ;;21,"15310-0020-01 ")
 ;;235
 ;;21,"16590-0052-73 ")
 ;;236
 ;;21,"16590-0254-33 ")
 ;;237
 ;;21,"16590-0898-08 ")
 ;;238
 ;;21,"16590-0898-16 ")
 ;;239
 ;;21,"16590-0940-60 ")
 ;;240
 ;;21,"16590-0972-30 ")
 ;;241
 ;;21,"17139-0617-40 ")
 ;;242
 ;;21,"17856-0907-02 ")
 ;;243
 ;;21,"17856-0907-03 ")
 ;;244
 ;;21,"18860-0480-01 ")
 ;;245
 ;;21,"18860-0480-60 ")
 ;;246
 ;;21,"18860-0490-02 ")
 ;;247
 ;;21,"21695-0467-30 ")
 ;;248
 ;;21,"21695-0467-60 ")
 ;;249
 ;;21,"21695-0468-30 ")
 ;;250
 ;;21,"21695-0468-60 ")
 ;;251
 ;;21,"21695-0468-72 ")
 ;;252
 ;;21,"21695-0468-78 ")
 ;;253
 ;;21,"21695-0568-30 ")
 ;;254
 ;;21,"21695-0568-60 ")
 ;;255
 ;;21,"21695-0613-00 ")
 ;;256
 ;;21,"21695-0613-30 ")
 ;;257
 ;;21,"21695-0613-90 ")
 ;;258
 ;;21,"21695-0623-00 ")
 ;;259
 ;;21,"21695-0623-15 ")
 ;;260
 ;;21,"21695-0623-30 ")
 ;;261
 ;;21,"21695-0696-45 ")
 ;;262
 ;;21,"21695-0981-30 ")
 ;;263
 ;;21,"23155-0056-01 ")
 ;;264
 ;;21,"23155-0057-01 ")
 ;;265
 ;;21,"23155-0058-01 ")
 ;;266
 ;;21,"23155-0058-10 ")
 ;;267
 ;;21,"23155-0233-01 ")
 ;;268
 ;;21,"23155-0233-05 ")
 ;;269
 ;;21,"23155-0234-01 ")
 ;;270
 ;;21,"23155-0234-05 ")
 ;;271
 ;;21,"23155-0235-01 ")
 ;;272
 ;;21,"23155-0235-05 ")
 ;;273
 ;;21,"29336-0325-56 ")
 ;;274
 ;;21,"33261-0209-30 ")
 ;;275
 ;;21,"33261-0209-60 ")
 ;;276
 ;;21,"33261-0209-90 ")
 ;;277
 ;;21,"33261-0411-00 ")
 ;;278
 ;;21,"33261-0411-30 ")
 ;;279
 ;;21,"33261-0411-60 ")
 ;;280
 ;;21,"33261-0411-90 ")
 ;;281
 ;;21,"33261-0667-30 ")
 ;;282
 ;;21,"33261-0667-60 ")
 ;;283
 ;;21,"33261-0667-90 ")
 ;;284
 ;;21,"33261-0714-15 ")
 ;;285
 ;;21,"33261-0714-30 ")
 ;;286
 ;;21,"33261-0714-60 ")
 ;;287
 ;;21,"33261-0751-30 ")
 ;;288
 ;;21,"33261-0751-60 ")
 ;;289
 ;;21,"33261-0751-90 ")
 ;;290
 ;;21,"33261-0763-01 ")
 ;;291
 ;;21,"33261-0813-30 ")
 ;;292
 ;;21,"33261-0813-60 ")
 ;;293
 ;;21,"33261-0813-90 ")
 ;;294
 ;;21,"33261-0821-30 ")
 ;;295
 ;;21,"33261-0821-60 ")
 ;;296
 ;;21,"33261-0821-90 ")
 ;;297
 ;;21,"33261-0911-01 ")
 ;;298
 ;;21,"33358-0160-30 ")
 ;;299
 ;;21,"33358-0160-60 ")
 ;;300
 ;;21,"33358-0161-01 ")
 ;;301
 ;;21,"33358-0161-30 ")
 ;;302
 ;;21,"33358-0161-60 ")
 ;;303
 ;;21,"33358-0161-90 ")
 ;;304
 ;;21,"33358-0295-30 ")
 ;;305
 ;;21,"33358-0336-30 ")
 ;;306
 ;;21,"33358-0336-60 ")
 ;;307
 ;;21,"33358-0337-60 ")
 ;;308
 ;;21,"35356-0249-00 ")
 ;;309
 ;;21,"35356-0250-00 ")
 ;;310
 ;;21,"35356-0251-00 ")
 ;;311
 ;;21,"35356-0276-28 ")
 ;;312
 ;;21,"35356-0277-28 ")
 ;;313
 ;;21,"35356-0278-28 ")
 ;;314
 ;;21,"35356-0279-28 ")
 ;;315
 ;;21,"35356-0360-30 ")
 ;;316
 ;;21,"35356-0360-60 ")
 ;;317
 ;;21,"35356-0360-90 ")
 ;;318
 ;;21,"35356-0426-30 ")
 ;;319
 ;;21,"35356-0897-30 ")
 ;;320
 ;;21,"35356-0897-60 ")
 ;;321
 ;;21,"35356-0932-30 ")
 ;;322
 ;;21,"35356-0932-60 ")
 ;;323
 ;;21,"35356-0932-90 ")
 ;;324
 ;;21,"35356-0995-30 ")
 ;;325
 ;;21,"35356-0995-60 ")
 ;;326
 ;;21,"35356-0995-90 ")
 ;;327
 ;;21,"42192-0329-01 ")
 ;;328
 ;;21,"42192-0330-01 ")
 ;;329
 ;;21,"42192-0331-01 ")
 ;;330
 ;;21,"42254-0071-30 ")
 ;;331
 ;;21,"42254-0090-30 ")
 ;;332
 ;;21,"42254-0090-60 ")
 ;;333
 ;;21,"42254-0090-90 ")
 ;;334
 ;;21,"42254-0104-30 ")
 ;;335
 ;;21,"42254-0105-30 ")
 ;;336
 ;;21,"42254-0281-30 ")
 ;;337
 ;;21,"42254-0281-90 ")
 ;;338
 ;;21,"42291-0316-50 ")
 ;;339
 ;
OTHER ; OTHER ROUTINES
 D ^BGP61C10
 D ^BGP61C11
 D ^BGP61C12
 D ^BGP61C13
 D ^BGP61C14
 D ^BGP61C15
 D ^BGP61C16
 D ^BGP61C2
 D ^BGP61C3
 D ^BGP61C4
 D ^BGP61C5
 D ^BGP61C6
 D ^BGP61C7
 D ^BGP61C8
 D ^BGP61C9
 Q