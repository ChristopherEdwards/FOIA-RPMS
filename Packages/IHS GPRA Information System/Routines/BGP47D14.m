BGP47D14 ;IHS/CMI/LAB-CREATED BY ^ATXSTX ON MAR 16, 2014;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"58016-0126-15 ")
 ;;5041
 ;;21,"58016-0126-18 ")
 ;;5042
 ;;21,"58016-0126-20 ")
 ;;5043
 ;;21,"58016-0126-21 ")
 ;;5044
 ;;21,"58016-0126-28 ")
 ;;5045
 ;;21,"58016-0126-30 ")
 ;;5046
 ;;21,"58016-0126-42 ")
 ;;5047
 ;;21,"58016-0126-60 ")
 ;;5048
 ;;21,"58016-0126-99 ")
 ;;5049
 ;;21,"58016-0127-06 ")
 ;;5050
 ;;21,"58016-0127-08 ")
 ;;5051
 ;;21,"58016-0127-10 ")
 ;;5052
 ;;21,"58016-0127-14 ")
 ;;5053
 ;;21,"58016-0127-20 ")
 ;;5054
 ;;21,"58016-0127-21 ")
 ;;5055
 ;;21,"58016-0127-24 ")
 ;;5056
 ;;21,"58016-0127-28 ")
 ;;5057
 ;;21,"58016-0127-30 ")
 ;;5058
 ;;21,"58016-0127-40 ")
 ;;5059
 ;;21,"58016-0127-42 ")
 ;;5060
 ;;21,"58016-0127-50 ")
 ;;5061
 ;;21,"58016-0127-60 ")
 ;;5062
 ;;21,"58016-0137-00 ")
 ;;5063
 ;;21,"58016-0137-02 ")
 ;;5064
 ;;21,"58016-0137-10 ")
 ;;5065
 ;;21,"58016-0137-12 ")
 ;;5066
 ;;21,"58016-0137-15 ")
 ;;5067
 ;;21,"58016-0137-20 ")
 ;;5068
 ;;21,"58016-0137-30 ")
 ;;5069
 ;;21,"58016-0137-60 ")
 ;;5070
 ;;21,"58016-0137-90 ")
 ;;5071
 ;;21,"58016-0138-00 ")
 ;;5072
 ;;21,"58016-0138-02 ")
 ;;5073
 ;;21,"58016-0138-03 ")
 ;;5074
 ;;21,"58016-0138-12 ")
 ;;5075
 ;;21,"58016-0138-14 ")
 ;;5076
 ;;21,"58016-0138-15 ")
 ;;5077
 ;;21,"58016-0138-20 ")
 ;;5078
 ;;21,"58016-0138-21 ")
 ;;5079
 ;;21,"58016-0138-24 ")
 ;;5080
 ;;21,"58016-0138-28 ")
 ;;5081
 ;;21,"58016-0138-30 ")
 ;;5082
 ;;21,"58016-0138-40 ")
 ;;5083
 ;;21,"58016-0138-56 ")
 ;;5084
 ;;21,"58016-0138-60 ")
 ;;5085
 ;;21,"58016-0138-73 ")
 ;;5086
 ;;21,"58016-0138-89 ")
 ;;5087
 ;;21,"58016-0139-00 ")
 ;;5088
 ;;21,"58016-0139-02 ")
 ;;5089
 ;;21,"58016-0139-03 ")
 ;;5090
 ;;21,"58016-0139-04 ")
 ;;5091
 ;;21,"58016-0139-05 ")
 ;;5092
 ;;21,"58016-0139-06 ")
 ;;5093
 ;;21,"58016-0139-08 ")
 ;;5094
 ;;21,"58016-0139-10 ")
 ;;5095
 ;;21,"58016-0139-12 ")
 ;;5096
 ;;21,"58016-0139-14 ")
 ;;5097
 ;;21,"58016-0139-15 ")
 ;;5098
 ;;21,"58016-0139-18 ")
 ;;5099
 ;;21,"58016-0139-20 ")
 ;;5100
 ;;21,"58016-0139-21 ")
 ;;5101
 ;;21,"58016-0139-24 ")
 ;;5102
 ;;21,"58016-0139-28 ")
 ;;5103
 ;;21,"58016-0139-30 ")
 ;;5104
 ;;21,"58016-0139-40 ")
 ;;5105
 ;;21,"58016-0139-50 ")
 ;;5106
 ;;21,"58016-0139-56 ")
 ;;5107
 ;;21,"58016-0139-60 ")
 ;;5108
 ;;21,"58016-0139-73 ")
 ;;5109
 ;;21,"58016-0139-89 ")
 ;;5110
 ;;21,"58016-0145-18 ")
 ;;5111
 ;;21,"58016-0146-00 ")
 ;;5112
 ;;21,"58016-0146-02 ")
 ;;5113
 ;;21,"58016-0146-03 ")
 ;;5114
 ;;21,"58016-0146-10 ")
 ;;5115
 ;;21,"58016-0146-12 ")
 ;;5116
 ;;21,"58016-0146-16 ")
 ;;5117
 ;;21,"58016-0146-20 ")
 ;;5118
 ;;21,"58016-0146-21 ")
 ;;5119
 ;;21,"58016-0146-24 ")
 ;;5120
 ;;21,"58016-0146-28 ")
 ;;5121
 ;;21,"58016-0146-30 ")
 ;;5122
 ;;21,"58016-0146-40 ")
 ;;5123
 ;;21,"58016-0146-60 ")
 ;;5124
 ;;21,"58016-0146-73 ")
 ;;5125
 ;;21,"58016-0146-89 ")
 ;;5126
 ;;21,"58016-0146-90 ")
 ;;5127
 ;;21,"58016-0147-00 ")
 ;;5128
 ;;21,"58016-0147-02 ")
 ;;5129
 ;;21,"58016-0147-03 ")
 ;;5130
 ;;21,"58016-0147-06 ")
 ;;5131
 ;;21,"58016-0147-10 ")
 ;;5132
 ;;21,"58016-0147-12 ")
 ;;5133
 ;;21,"58016-0147-15 ")
 ;;5134
 ;;21,"58016-0147-16 ")
 ;;5135
 ;;21,"58016-0147-20 ")
 ;;5136
 ;;21,"58016-0147-21 ")
 ;;5137
 ;;21,"58016-0147-24 ")
 ;;5138
 ;;21,"58016-0147-28 ")
 ;;5139
 ;;21,"58016-0147-30 ")
 ;;5140
 ;;21,"58016-0147-40 ")
 ;;5141
 ;;21,"58016-0147-50 ")
 ;;5142
 ;;21,"58016-0147-60 ")
 ;;5143
 ;;21,"58016-0147-73 ")
 ;;5144
 ;;21,"58016-0147-89 ")
 ;;5145
 ;;21,"58016-0147-90 ")
 ;;5146
 ;;21,"58016-0148-00 ")
 ;;5147
 ;;21,"58016-0148-08 ")
 ;;5148
 ;;21,"58016-0148-09 ")
 ;;5149
 ;;21,"58016-0148-10 ")
 ;;5150
 ;;21,"58016-0148-12 ")
 ;;5151
 ;;21,"58016-0148-14 ")
 ;;5152
 ;;21,"58016-0148-15 ")
 ;;5153
 ;;21,"58016-0148-20 ")
 ;;5154
 ;;21,"58016-0148-24 ")
 ;;5155
 ;;21,"58016-0148-28 ")
 ;;5156
 ;;21,"58016-0148-30 ")
 ;;5157
 ;;21,"58016-0148-40 ")
 ;;5158
 ;;21,"58016-0148-50 ")
 ;;5159
 ;;21,"58016-0149-00 ")
 ;;5160
 ;;21,"58016-0149-07 ")
 ;;5161
 ;;21,"58016-0149-10 ")
 ;;5162
 ;;21,"58016-0149-20 ")
 ;;5163
 ;;21,"58016-0149-21 ")
 ;;5164
 ;;21,"58016-0149-24 ")
 ;;5165
 ;;21,"58016-0149-25 ")
 ;;5166
 ;;21,"58016-0149-28 ")
 ;;5167
 ;;21,"58016-0149-30 ")
 ;;5168
 ;;21,"58016-0149-40 ")
 ;;5169
 ;;21,"58016-0156-00 ")
 ;;5170
 ;;21,"58016-0156-02 ")
 ;;5171
 ;;21,"58016-0156-03 ")
 ;;5172
 ;;21,"58016-0156-06 ")
 ;;5173
 ;;21,"58016-0156-07 ")
 ;;5174
 ;;21,"58016-0156-10 ")
 ;;5175
 ;;21,"58016-0156-12 ")
 ;;5176
 ;;21,"58016-0156-14 ")
 ;;5177
 ;;21,"58016-0156-15 ")
 ;;5178
 ;;21,"58016-0156-16 ")
 ;;5179
 ;;21,"58016-0156-20 ")
 ;;5180
 ;;21,"58016-0156-21 ")
 ;;5181
 ;;21,"58016-0156-24 ")
 ;;5182
 ;;21,"58016-0156-28 ")
 ;;5183
 ;;21,"58016-0156-30 ")
 ;;5184
 ;;21,"58016-0156-40 ")
 ;;5185
 ;;21,"58016-0156-60 ")
 ;;5186
 ;;21,"58016-0156-73 ")
 ;;5187
 ;;21,"58016-0156-89 ")
 ;;5188
 ;;21,"58016-0161-10 ")
 ;;5189
 ;;21,"58016-0161-12 ")
 ;;5190
 ;;21,"58016-0161-14 ")
 ;;5191
 ;;21,"58016-0161-15 ")
 ;;5192
 ;;21,"58016-0161-16 ")
 ;;5193
 ;;21,"58016-0161-18 ")
 ;;5194
 ;;21,"58016-0161-20 ")
 ;;5195
 ;;21,"58016-0161-21 ")
 ;;5196
 ;;21,"58016-0161-24 ")
 ;;5197
 ;;21,"58016-0161-28 ")
 ;;5198
 ;;21,"58016-0161-30 ")
 ;;5199
 ;;21,"58016-0161-40 ")
 ;;5200
 ;;21,"58016-0161-50 ")
 ;;5201
 ;;21,"58016-0161-60 ")
 ;;5202
 ;;21,"58016-0162-28 ")
 ;;5203
 ;;21,"58016-0162-30 ")
 ;;5204
 ;;21,"58016-0162-40 ")
 ;;5205
 ;;21,"58016-0167-00 ")
 ;;5206
 ;;21,"58016-0167-20 ")
 ;;5207
 ;;21,"58016-0167-40 ")
 ;;5208
 ;;21,"58016-0171-20 ")
 ;;5209
 ;;21,"58016-0171-30 ")
 ;;5210
 ;;21,"58016-0204-00 ")
 ;;5211
 ;;21,"58016-0204-30 ")
 ;;5212
 ;;21,"58016-0204-60 ")
 ;;5213
 ;;21,"58016-0204-90 ")
 ;;5214
 ;;21,"58016-0284-15 ")
 ;;5215
 ;;21,"58016-0284-20 ")
 ;;5216
 ;;21,"58016-0284-30 ")
 ;;5217
 ;;21,"58016-0284-50 ")
 ;;5218
 ;;21,"58016-0299-00 ")
 ;;5219
 ;;21,"58016-0299-30 ")
 ;;5220
 ;;21,"58016-0299-60 ")
 ;;5221
 ;;21,"58016-0299-90 ")
 ;;5222
 ;;21,"58016-0339-30 ")
 ;;5223
 ;;21,"58016-0391-00 ")
 ;;5224
 ;;21,"58016-0391-01 ")
 ;;5225
 ;;21,"58016-0391-06 ")
 ;;5226
 ;;21,"58016-0391-10 ")
 ;;5227
 ;;21,"58016-0391-15 ")
 ;;5228
 ;;21,"58016-0391-18 ")
 ;;5229
 ;;21,"58016-0391-20 ")
 ;;5230
 ;;21,"58016-0391-28 ")
 ;;5231
 ;;21,"58016-0391-30 ")
 ;;5232
 ;;21,"58016-0391-60 ")
 ;;5233
 ;;21,"58016-0391-90 ")
 ;;5234
 ;;21,"58016-0453-00 ")
 ;;5235
 ;;21,"58016-0453-12 ")
 ;;5236
 ;;21,"58016-0453-15 ")
 ;;5237
 ;;21,"58016-0453-20 ")
 ;;5238
 ;;21,"58016-0453-21 ")
 ;;5239
 ;;21,"58016-0453-30 ")
 ;;5240
 ;;21,"58016-0453-40 ")
 ;;5241
 ;;21,"58016-0512-20 ")
 ;;5242
 ;;21,"58016-0550-10 ")
 ;;5243
 ;;21,"58016-0550-12 ")
 ;;5244
 ;;21,"58016-0550-14 ")
 ;;5245
 ;;21,"58016-0550-15 ")
 ;;5246
 ;;21,"58016-0550-20 ")
 ;;5247
 ;;21,"58016-0550-30 ")
 ;;5248
 ;;21,"58016-0550-40 ")
 ;;5249
 ;;21,"58016-0573-00 ")
 ;;5250
 ;;21,"58016-0573-07 ")
 ;;5251
 ;;21,"58016-0573-10 ")
 ;;5252
 ;;21,"58016-0573-20 ")
 ;;5253
 ;;21,"58016-0573-30 ")
 ;;5254
 ;;21,"58016-0573-60 ")
 ;;5255
 ;;21,"58016-0573-90 ")
 ;;5256
 ;;21,"58016-0633-00 ")
 ;;5257
 ;;21,"58016-0633-30 ")
 ;;5258
 ;;21,"58016-0633-60 ")
 ;;5259
 ;;21,"58016-0633-90 ")
 ;;5260
 ;;21,"58016-0634-00 ")
 ;;5261
 ;;21,"58016-0634-30 ")
 ;;5262
 ;;21,"58016-0634-60 ")
 ;;5263
 ;;21,"58016-0634-90 ")
 ;;5264
 ;;21,"58016-0643-00 ")
 ;;5265
 ;;21,"58016-0643-02 ")
 ;;5266
 ;;21,"58016-0643-04 ")
 ;;5267
 ;;21,"58016-0643-09 ")
 ;;5268
 ;;21,"58016-0643-12 ")
 ;;5269
 ;;21,"58016-0643-15 ")
 ;;5270
 ;;21,"58016-0643-18 ")
 ;;5271
 ;;21,"58016-0643-20 ")
 ;;5272
 ;;21,"58016-0643-21 ")
 ;;5273
 ;;21,"58016-0643-24 ")
 ;;5274
 ;;21,"58016-0643-30 ")
 ;;5275
 ;;21,"58016-0643-40 ")
 ;;5276
 ;;21,"58016-0643-50 ")
 ;;5277
 ;;21,"58016-0643-60 ")
 ;;5278
 ;;21,"58016-0643-89 ")
 ;;5279
 ;;21,"58016-0643-90 ")
 ;;5280
 ;;21,"58016-0643-99 ")
 ;;5281
 ;;21,"58016-0810-00 ")
 ;;5282
 ;;21,"58016-0810-12 ")
 ;;5283
 ;;21,"58016-0810-15 ")
 ;;5284
 ;;21,"58016-0810-30 ")
 ;;5285
 ;;21,"58016-0872-12 ")
 ;;5286
 ;;21,"58016-0872-15 ")
 ;;5287
 ;;21,"58016-0872-18 ")
 ;;5288
 ;;21,"58016-0872-20 ")
 ;;5289
 ;;21,"58016-0872-24 ")
 ;;5290
 ;;21,"58016-0872-30 ")
 ;;5291
 ;;21,"58016-0873-00 ")
 ;;5292
 ;;21,"58016-0873-15 ")
 ;;5293
 ;;21,"58016-0873-20 ")
 ;;5294
 ;;21,"58016-0873-30 ")
 ;;5295
 ;;21,"58016-0924-00 ")
 ;;5296
 ;;21,"58016-0924-30 ")
 ;;5297
 ;;21,"58016-0924-60 ")
 ;;5298
 ;;21,"58016-0924-90 ")
 ;;5299
 ;;21,"58016-0953-00 ")
 ;;5300
 ;;21,"58016-0953-02 ")
 ;;5301
 ;;21,"58016-0953-10 ")
 ;;5302
 ;;21,"58016-0953-12 ")
 ;;5303
 ;;21,"58016-0953-15 ")
 ;;5304
 ;;21,"58016-0953-20 ")
 ;;5305
 ;;21,"58016-0953-30 ")
 ;;5306
 ;;21,"58016-0953-60 ")
 ;;5307
 ;;21,"58016-0953-90 ")
 ;;5308
 ;;21,"58016-0955-00 ")
 ;;5309
 ;;21,"58016-0955-30 ")
 ;;5310
 ;;21,"58016-0955-60 ")
 ;;5311
 ;;21,"58016-0955-90 ")
 ;;5312
 ;;21,"58016-0957-00 ")
 ;;5313
 ;;21,"58016-0957-02 ")
 ;;5314
 ;;21,"58016-0957-10 ")
 ;;5315
 ;;21,"58016-0957-12 ")
 ;;5316
 ;;21,"58016-0957-15 ")
 ;;5317
 ;;21,"58016-0957-20 ")
 ;;5318
 ;;21,"58016-0957-30 ")
 ;;5319
 ;;21,"58016-0957-60 ")
 ;;5320
 ;;21,"58016-0957-90 ")
 ;;5321
 ;;21,"58016-0964-00 ")
 ;;5322
 ;;21,"58016-0964-30 ")
 ;;5323
 ;;21,"58016-0964-60 ")
 ;;5324
 ;;21,"58016-0964-90 ")
 ;;5325
 ;;21,"58016-0975-00 ")
 ;;5326
 ;;21,"58016-0975-30 ")
 ;;5327
 ;;21,"58016-0975-60 ")
 ;;5328
 ;;21,"58016-0975-90 ")
 ;;5329
 ;;21,"58016-1004-01 ")
 ;;5330
 ;;21,"58016-1005-01 ")
 ;;5331
 ;;21,"58016-1006-01 ")
 ;;5332
 ;;21,"58016-1007-01 ")
 ;;5333
 ;;21,"58016-1011-01 ")
 ;;5334
 ;;21,"58016-1019-01 ")
 ;;5335
 ;;21,"58016-1021-01 ")
 ;;5336
 ;;21,"58016-1023-01 ")
 ;;5337
 ;;21,"58016-1024-01 ")
 ;;5338
 ;;21,"58016-1025-01 ")
 ;;5339
 ;;21,"58016-1026-01 ")
 ;;5340
 ;;21,"58016-1027-01 ")
 ;;5341
 ;;21,"58016-1028-01 ")
 ;;5342
 ;;21,"58016-1029-01 ")
 ;;5343
 ;;21,"58016-1033-01 ")
 ;;5344
 ;;21,"58016-1034-01 ")
 ;;5345
 ;;21,"58016-1035-01 ")
 ;;5346
 ;;21,"58016-1036-01 ")
 ;;5347
 ;;21,"58016-1037-01 ")
 ;;5348
 ;;21,"58016-1038-01 ")
 ;;5349
 ;;21,"58016-1039-01 ")
 ;;5350
 ;;21,"58016-1045-01 ")
 ;;5351
 ;;21,"58016-1046-01 ")
 ;;5352
 ;;21,"58016-4147-01 ")
 ;;5353
 ;;21,"58016-4148-01 ")
 ;;5354
 ;;21,"58016-4192-01 ")
 ;;5355
 ;;21,"58016-4193-01 ")
 ;;5356
 ;;21,"58016-4786-01 ")
 ;;5357
 ;;21,"58016-4790-01 ")
 ;;5358
 ;;21,"58016-4804-01 ")
 ;;5359
 ;;21,"58016-4807-01 ")
 ;;5360
 ;;21,"58016-4814-01 ")
 ;;5361
 ;;21,"58016-4834-01 ")
 ;;5362
 ;;21,"58016-4842-01 ")
 ;;5363
 ;;21,"58016-4847-01 ")
 ;;5364
 ;;21,"58016-4869-01 ")
 ;;5365
 ;;21,"58016-4873-01 ")
 ;;5366
 ;;21,"58016-4990-01 ")
 ;;5367
 ;;21,"58016-9438-01 ")
 ;;5368
 ;;21,"58016-9551-01 ")
 ;;5369
 ;;21,"58864-0029-30 ")
 ;;5370
 ;;21,"58864-0029-40 ")
 ;;5371
 ;;21,"58864-0034-10 ")
 ;;5372
 ;;21,"58864-0034-14 ")
 ;;5373
 ;;21,"58864-0067-20 ")
 ;;5374
 ;;21,"58864-0072-30 ")
 ;;5375
 ;;21,"58864-0072-40 ")
 ;;5376
 ;;21,"58864-0073-20 ")
 ;;5377
 ;;21,"58864-0073-28 ")
 ;;5378
 ;;21,"58864-0073-30 ")
 ;;5379
 ;;21,"58864-0073-40 ")
 ;;5380
 ;;21,"58864-0073-56 ")
 ;;5381
 ;;21,"58864-0149-40 ")
 ;;5382
 ;;21,"58864-0150-30 ")
 ;;5383
 ;;21,"58864-0189-10 ")
 ;;5384
 ;;21,"58864-0189-20 ")
 ;;5385
 ;;21,"58864-0189-28 ")
 ;;5386
 ;;21,"58864-0190-12 ")
 ;;5387
 ;;21,"58864-0190-20 ")
 ;;5388
 ;;21,"58864-0190-28 ")
 ;;5389
 ;;21,"58864-0190-30 ")
 ;;5390
 ;;21,"58864-0195-40 ")
 ;;5391
 ;;21,"58864-0379-40 ")
 ;;5392
 ;;21,"58864-0478-06 ")
 ;;5393
 ;;21,"58864-0478-10 ")
 ;;5394
 ;;21,"58864-0478-14 ")
 ;;5395
 ;;21,"58864-0478-20 ")
 ;;5396
 ;;21,"58864-0478-30 ")
 ;;5397
 ;;21,"58864-0607-40 ")
 ;;5398
 ;;21,"58864-0607-60 ")
 ;;5399
 ;;21,"58864-0612-28 ")
 ;;5400
 ;;21,"58864-0615-30 ")
 ;;5401
 ;;21,"58864-0621-05 ")
 ;;5402
 ;;21,"58864-0621-10 ")
 ;;5403
 ;;21,"58864-0621-30 ")
 ;;5404
 ;;21,"58864-0632-40 ")
 ;;5405
 ;;21,"58864-0637-14 ")
 ;;5406
 ;;21,"58864-0637-20 ")
 ;;5407
 ;;21,"58864-0637-30 ")
 ;;5408
 ;;21,"58864-0655-04 ")
 ;;5409
 ;;21,"58864-0655-06 ")
 ;;5410
 ;;21,"58864-0655-14 ")
 ;;5411
 ;;21,"58864-0655-30 ")
 ;;5412
 ;;21,"58864-0675-30 ")
 ;;5413
 ;;21,"58864-0675-40 ")
 ;;5414
 ;;21,"58864-0690-20 ")
 ;;5415
 ;;21,"58864-0697-20 ")
 ;;5416
 ;;21,"58864-0740-30 ")
 ;;5417
 ;;21,"58864-0767-20 ")
 ;;5418
 ;;21,"58864-0767-21 ")
 ;;5419
 ;;21,"58864-0767-30 ")
 ;;5420
 ;;21,"58864-0775-20 ")
 ;;5421
 ;;21,"58864-0777-30 ")
 ;;5422
 ;;21,"58864-0791-06 ")
 ;;5423
 ;;21,"58864-0806-06 ")
 ;;5424
 ;;21,"58864-0806-14 ")
 ;;5425
 ;;21,"58864-0806-20 ")
 ;;5426