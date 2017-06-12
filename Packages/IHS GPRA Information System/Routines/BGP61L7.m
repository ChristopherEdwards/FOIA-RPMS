BGP61L7 ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON AUG 18, 2015 ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"65162-0175-10 ")
 ;;2179
 ;;21,"65162-0175-11 ")
 ;;2180
 ;;21,"65162-0175-50 ")
 ;;2181
 ;;21,"65162-0177-10 ")
 ;;2182
 ;;21,"65162-0177-11 ")
 ;;2183
 ;;21,"65162-0177-50 ")
 ;;2184
 ;;21,"65162-0218-10 ")
 ;;2185
 ;;21,"65162-0218-11 ")
 ;;2186
 ;;21,"65162-0218-50 ")
 ;;2187
 ;;21,"65162-0219-10 ")
 ;;2188
 ;;21,"65162-0219-11 ")
 ;;2189
 ;;21,"65162-0219-50 ")
 ;;2190
 ;;21,"65162-0220-10 ")
 ;;2191
 ;;21,"65162-0220-11 ")
 ;;2192
 ;;21,"65162-0220-50 ")
 ;;2193
 ;;21,"65243-0176-09 ")
 ;;2194
 ;;21,"65243-0176-12 ")
 ;;2195
 ;;21,"65243-0176-18 ")
 ;;2196
 ;;21,"65243-0176-27 ")
 ;;2197
 ;;21,"65243-0176-36 ")
 ;;2198
 ;;21,"65243-0183-18 ")
 ;;2199
 ;;21,"65243-0185-36 ")
 ;;2200
 ;;21,"65243-0195-09 ")
 ;;2201
 ;;21,"65243-0195-12 ")
 ;;2202
 ;;21,"65243-0196-09 ")
 ;;2203
 ;;21,"65243-0239-09 ")
 ;;2204
 ;;21,"65243-0239-18 ")
 ;;2205
 ;;21,"65243-0239-27 ")
 ;;2206
 ;;21,"65243-0288-06 ")
 ;;2207
 ;;21,"65243-0288-09 ")
 ;;2208
 ;;21,"65243-0288-12 ")
 ;;2209
 ;;21,"65243-0288-18 ")
 ;;2210
 ;;21,"65243-0289-06 ")
 ;;2211
 ;;21,"65243-0289-09 ")
 ;;2212
 ;;21,"65243-0289-12 ")
 ;;2213
 ;;21,"65243-0289-18 ")
 ;;2214
 ;;21,"65243-0325-09 ")
 ;;2215
 ;;21,"65243-0325-18 ")
 ;;2216
 ;;21,"65243-0343-09 ")
 ;;2217
 ;;21,"65243-0343-36 ")
 ;;2218
 ;;21,"65243-0346-09 ")
 ;;2219
 ;;21,"65243-0371-06 ")
 ;;2220
 ;;21,"65243-0371-09 ")
 ;;2221
 ;;21,"65243-0372-06 ")
 ;;2222
 ;;21,"65243-0372-09 ")
 ;;2223
 ;;21,"65243-0372-18 ")
 ;;2224
 ;;21,"65243-0373-09 ")
 ;;2225
 ;;21,"65243-0375-09 ")
 ;;2226
 ;;21,"65243-0378-09 ")
 ;;2227
 ;;21,"65862-0008-01 ")
 ;;2228
 ;;21,"65862-0008-05 ")
 ;;2229
 ;;21,"65862-0008-90 ")
 ;;2230
 ;;21,"65862-0008-99 ")
 ;;2231
 ;;21,"65862-0009-01 ")
 ;;2232
 ;;21,"65862-0009-05 ")
 ;;2233
 ;;21,"65862-0009-90 ")
 ;;2234
 ;;21,"65862-0010-01 ")
 ;;2235
 ;;21,"65862-0010-05 ")
 ;;2236
 ;;21,"65862-0010-46 ")
 ;;2237
 ;;21,"65862-0010-90 ")
 ;;2238
 ;;21,"65862-0010-99 ")
 ;;2239
 ;;21,"65862-0028-01 ")
 ;;2240
 ;;21,"65862-0029-01 ")
 ;;2241
 ;;21,"65862-0029-05 ")
 ;;2242
 ;;21,"65862-0030-01 ")
 ;;2243
 ;;21,"65862-0030-99 ")
 ;;2244
 ;;21,"65862-0080-01 ")
 ;;2245
 ;;21,"65862-0080-05 ")
 ;;2246
 ;;21,"65862-0081-01 ")
 ;;2247
 ;;21,"65862-0081-05 ")
 ;;2248
 ;;21,"65862-0082-01 ")
 ;;2249
 ;;21,"65862-0082-05 ")
 ;;2250
 ;;21,"65862-0291-01 ")
 ;;2251
 ;;21,"65862-0291-05 ")
 ;;2252
 ;;21,"65862-0292-01 ")
 ;;2253
 ;;21,"65862-0512-30 ")
 ;;2254
 ;;21,"65862-0513-30 ")
 ;;2255
 ;;21,"65862-0514-30 ")
 ;;2256
 ;;21,"65862-0525-18 ")
 ;;2257
 ;;21,"65862-0525-60 ")
 ;;2258
 ;;21,"65862-0526-18 ")
 ;;2259
 ;;21,"65862-0526-60 ")
 ;;2260
 ;;21,"65862-0670-01 ")
 ;;2261
 ;;21,"65862-0671-01 ")
 ;;2262
 ;;21,"65862-0672-01 ")
 ;;2263
 ;;21,"66105-0145-01 ")
 ;;2264
 ;;21,"66105-0145-03 ")
 ;;2265
 ;;21,"66105-0145-06 ")
 ;;2266
 ;;21,"66105-0145-09 ")
 ;;2267
 ;;21,"66105-0145-15 ")
 ;;2268
 ;;21,"66105-0154-01 ")
 ;;2269
 ;;21,"66105-0154-03 ")
 ;;2270
 ;;21,"66105-0154-06 ")
 ;;2271
 ;;21,"66105-0154-09 ")
 ;;2272
 ;;21,"66105-0154-15 ")
 ;;2273
 ;;21,"66105-0156-01 ")
 ;;2274
 ;;21,"66105-0156-03 ")
 ;;2275
 ;;21,"66105-0156-06 ")
 ;;2276
 ;;21,"66105-0156-09 ")
 ;;2277
 ;;21,"66105-0156-15 ")
 ;;2278
 ;;21,"66105-0159-01 ")
 ;;2279
 ;;21,"66105-0159-03 ")
 ;;2280
 ;;21,"66105-0159-06 ")
 ;;2281
 ;;21,"66105-0159-09 ")
 ;;2282
 ;;21,"66105-0159-15 ")
 ;;2283
 ;;21,"66105-0652-03 ")
 ;;2284
 ;;21,"66105-0984-03 ")
 ;;2285
 ;;21,"66105-0984-06 ")
 ;;2286
 ;;21,"66105-0984-10 ")
 ;;2287
 ;;21,"66105-0984-11 ")
 ;;2288
 ;;21,"66105-0984-50 ")
 ;;2289
 ;;21,"66105-0985-03 ")
 ;;2290
 ;;21,"66105-0985-06 ")
 ;;2291
 ;;21,"66105-0985-10 ")
 ;;2292
 ;;21,"66105-0985-11 ")
 ;;2293
 ;;21,"66105-0985-50 ")
 ;;2294
 ;;21,"66105-0986-03 ")
 ;;2295
 ;;21,"66105-0986-06 ")
 ;;2296
 ;;21,"66105-0986-10 ")
 ;;2297
 ;;21,"66105-0986-11 ")
 ;;2298
 ;;21,"66105-0986-50 ")
 ;;2299
 ;;21,"66116-0233-30 ")
 ;;2300
 ;;21,"66116-0282-60 ")
 ;;2301
 ;;21,"66116-0293-30 ")
 ;;2302
 ;;21,"66116-0454-30 ")
 ;;2303
 ;;21,"66116-0695-60 ")
 ;;2304
 ;;21,"66267-0099-30 ")
 ;;2305
 ;;21,"66267-0100-30 ")
 ;;2306
 ;;21,"66267-0100-60 ")
 ;;2307
 ;;21,"66267-0100-90 ")
 ;;2308
 ;;21,"66267-0100-91 ")
 ;;2309
 ;;21,"66267-0100-92 ")
 ;;2310
 ;;21,"66267-0103-30 ")
 ;;2311
 ;;21,"66267-0493-14 ")
 ;;2312
 ;;21,"66267-0493-30 ")
 ;;2313
 ;;21,"66267-0493-60 ")
 ;;2314
 ;;21,"66267-0493-90 ")
 ;;2315
 ;;21,"66267-0493-91 ")
 ;;2316
 ;;21,"66267-0493-92 ")
 ;;2317
 ;;21,"66267-0493-93 ")
 ;;2318
 ;;21,"66267-0497-30 ")
 ;;2319
 ;;21,"66267-0553-30 ")
 ;;2320
 ;;21,"66336-0028-30 ")
 ;;2321
 ;;21,"66336-0028-90 ")
 ;;2322
 ;;21,"66336-0269-30 ")
 ;;2323
 ;;21,"66336-0269-90 ")
 ;;2324
 ;;21,"66336-0270-30 ")
 ;;2325
 ;;21,"66336-0270-60 ")
 ;;2326
 ;;21,"66336-0270-90 ")
 ;;2327
 ;;21,"66336-0270-94 ")
 ;;2328
 ;;21,"66336-0292-60 ")
 ;;2329
 ;;21,"66336-0319-30 ")
 ;;2330
 ;;21,"66336-0358-30 ")
 ;;2331
 ;;21,"66336-0358-60 ")
 ;;2332
 ;;21,"66336-0358-62 ")
 ;;2333
 ;;21,"66336-0358-90 ")
 ;;2334
 ;;21,"66336-0360-30 ")
 ;;2335
 ;;21,"66336-0361-30 ")
 ;;2336
 ;;21,"66336-0500-30 ")
 ;;2337
 ;;21,"66336-0500-90 ")
 ;;2338
 ;;21,"66336-0534-30 ")
 ;;2339
 ;;21,"66336-0534-90 ")
 ;;2340
 ;;21,"66336-0535-30 ")
 ;;2341
 ;;21,"66336-0535-60 ")
 ;;2342
 ;;21,"66336-0535-90 ")
 ;;2343
 ;;21,"66336-0573-30 ")
 ;;2344
 ;;21,"66336-0573-60 ")
 ;;2345
 ;;21,"66336-0573-90 ")
 ;;2346
 ;;21,"66336-0662-30 ")
 ;;2347
 ;;21,"66336-0662-60 ")
 ;;2348
 ;;21,"66336-0662-90 ")
 ;;2349
 ;;21,"66336-0662-94 ")
 ;;2350
 ;;21,"66336-0712-90 ")
 ;;2351
 ;;21,"66336-0730-14 ")
 ;;2352
 ;;21,"66336-0730-30 ")
 ;;2353
 ;;21,"66336-0730-60 ")
 ;;2354
 ;;21,"66336-0730-90 ")
 ;;2355
 ;;21,"66336-0784-30 ")
 ;;2356
 ;;21,"66336-0784-60 ")
 ;;2357
 ;;21,"66336-0784-90 ")
 ;;2358
 ;;21,"66336-0850-30 ")
 ;;2359
 ;;21,"66336-0850-60 ")
 ;;2360
 ;;21,"66336-0850-90 ")
 ;;2361
 ;;21,"66336-0857-30 ")
 ;;2362
 ;;21,"66336-0857-90 ")
 ;;2363
 ;;21,"66336-0858-30 ")
 ;;2364
 ;;21,"66336-0858-90 ")
 ;;2365
 ;;21,"66336-0859-30 ")
 ;;2366
 ;;21,"66336-0859-90 ")
 ;;2367
 ;;21,"66336-0883-30 ")
 ;;2368
 ;;21,"66336-0883-60 ")
 ;;2369
 ;;21,"66336-0883-90 ")
 ;;2370
 ;;21,"66336-0884-14 ")
 ;;2371
 ;;21,"66336-0884-28 ")
 ;;2372
 ;;21,"66336-0884-30 ")
 ;;2373
 ;;21,"66336-0884-60 ")
 ;;2374
 ;;21,"66336-0884-62 ")
 ;;2375
 ;;21,"66336-0884-90 ")
 ;;2376
 ;;21,"66336-0938-30 ")
 ;;2377
 ;;21,"66336-0938-60 ")
 ;;2378
 ;;21,"66336-0938-90 ")
 ;;2379
 ;;21,"66780-0210-07 ")
 ;;2380
 ;;21,"66780-0212-01 ")
 ;;2381
 ;;21,"66780-0219-04 ")
 ;;2382
 ;;21,"66780-0226-01 ")
 ;;2383
 ;;21,"66993-0162-02 ")
 ;;2384
 ;;21,"66993-0163-02 ")
 ;;2385
 ;;21,"66993-0164-02 ")
 ;;2386
 ;;21,"67253-0460-10 ")
 ;;2387
 ;;21,"67253-0461-10 ")
 ;;2388
 ;;21,"67253-0461-11 ")
 ;;2389
 ;;21,"67253-0461-50 ")
 ;;2390
 ;;21,"67253-0462-10 ")
 ;;2391
 ;;21,"67253-0462-11 ")
 ;;2392
 ;;21,"67253-0462-50 ")
 ;;2393
 ;;21,"67544-0047-30 ")
 ;;2394
 ;;21,"67544-0047-53 ")
 ;;2395
 ;;21,"67544-0047-60 ")
 ;;2396
 ;;21,"67544-0047-70 ")
 ;;2397
 ;;21,"67544-0047-75 ")
 ;;2398
 ;;21,"67544-0047-80 ")
 ;;2399
 ;;21,"67544-0047-90 ")
 ;;2400
 ;;21,"67544-0047-92 ")
 ;;2401
 ;;21,"67544-0047-94 ")
 ;;2402
 ;;21,"67544-0047-96 ")
 ;;2403
 ;;21,"67544-0065-30 ")
 ;;2404
 ;;21,"67544-0065-53 ")
 ;;2405
 ;;21,"67544-0065-60 ")
 ;;2406
 ;;21,"67544-0066-30 ")
 ;;2407
 ;;21,"67544-0066-45 ")
 ;;2408
 ;;21,"67544-0066-60 ")
 ;;2409
 ;;21,"67544-0097-53 ")
 ;;2410
 ;;21,"67544-0097-60 ")
 ;;2411
 ;;21,"67544-0097-70 ")
 ;;2412
 ;;21,"67544-0097-80 ")
 ;;2413
 ;;21,"67544-0097-92 ")
 ;;2414
 ;;21,"67544-0097-94 ")
 ;;2415
 ;;21,"67544-0107-53 ")
 ;;2416
 ;;21,"67544-0107-60 ")
 ;;2417
 ;;21,"67544-0107-80 ")
 ;;2418
 ;;21,"67544-0107-92 ")
 ;;2419
 ;;21,"67544-0113-60 ")
 ;;2420
 ;;21,"67544-0113-70 ")
 ;;2421
 ;;21,"67544-0113-80 ")
 ;;2422
 ;;21,"67544-0129-53 ")
 ;;2423
 ;;21,"67544-0129-70 ")
 ;;2424
 ;;21,"67544-0129-80 ")
 ;;2425
 ;;21,"67544-0129-94 ")
 ;;2426
 ;;21,"67544-0163-30 ")
 ;;2427
 ;;21,"67544-0163-45 ")
 ;;2428
 ;;21,"67544-0163-53 ")
 ;;2429
 ;;21,"67544-0163-60 ")
 ;;2430
 ;;21,"67544-0163-80 ")
 ;;2431
 ;;21,"67544-0199-80 ")
 ;;2432
 ;;21,"67544-0254-53 ")
 ;;2433
 ;;21,"67544-0296-70 ")
 ;;2434
 ;;21,"67544-0302-32 ")
 ;;2435
 ;;21,"67544-0302-45 ")
 ;;2436
 ;;21,"67544-0302-60 ")
 ;;2437
 ;;21,"67544-0302-73 ")
 ;;2438
 ;;21,"67544-0302-80 ")
 ;;2439
 ;;21,"67544-0302-92 ")
 ;;2440
 ;;21,"67544-0302-98 ")
 ;;2441
 ;;21,"67544-0421-60 ")
 ;;2442
 ;;21,"67544-0421-80 ")
 ;;2443
 ;;21,"67544-0421-92 ")
 ;;2444
 ;;21,"67544-0486-53 ")
 ;;2445
 ;;21,"67544-0511-70 ")
 ;;2446
 ;;21,"67544-0511-94 ")
 ;;2447
 ;;21,"67544-0566-53 ")
 ;;2448
 ;;21,"67544-0566-60 ")
 ;;2449
 ;;21,"67544-0566-70 ")
 ;;2450
 ;;21,"67544-0566-80 ")
 ;;2451
 ;;21,"67544-0566-92 ")
 ;;2452
 ;;21,"67544-0566-94 ")
 ;;2453
 ;;21,"67544-0613-53 ")
 ;;2454
 ;;21,"67544-0653-53 ")
 ;;2455
 ;;21,"67544-0653-60 ")
 ;;2456
 ;;21,"67544-0653-70 ")
 ;;2457
 ;;21,"67544-0653-80 ")
 ;;2458
 ;;21,"67544-0653-90 ")
 ;;2459
 ;;21,"67544-0653-92 ")
 ;;2460
 ;;21,"67544-0653-94 ")
 ;;2461
 ;;21,"67544-0653-98 ")
 ;;2462
 ;;21,"67544-0661-41 ")
 ;;2463
 ;;21,"67544-0661-81 ")
 ;;2464
 ;;21,"67544-0875-60 ")
 ;;2465
 ;;21,"67544-0875-80 ")
 ;;2466
 ;;21,"67877-0159-01 ")
 ;;2467
 ;;21,"67877-0159-05 ")
 ;;2468
 ;;21,"67877-0159-10 ")
 ;;2469
 ;;21,"67877-0217-01 ")
 ;;2470
 ;;21,"67877-0217-05 ")
 ;;2471
 ;;21,"67877-0217-10 ")
 ;;2472
 ;;21,"67877-0218-01 ")
 ;;2473
 ;;21,"67877-0218-05 ")
 ;;2474
 ;;21,"67877-0218-10 ")
 ;;2475
 ;;21,"67877-0221-01 ")
 ;;2476
 ;;21,"67877-0221-05 ")
 ;;2477
 ;;21,"67877-0221-10 ")
 ;;2478
 ;;21,"68001-0177-00 ")
 ;;2479
 ;;21,"68001-0177-03 ")
 ;;2480
 ;;21,"68001-0178-00 ")
 ;;2481
 ;;21,"68001-0178-03 ")
 ;;2482
 ;;21,"68001-0179-00 ")
 ;;2483
 ;;21,"68001-0179-03 ")
 ;;2484
 ;;21,"68012-0002-13 ")
 ;;2485
 ;;21,"68012-0003-16 ")
 ;;2486
 ;;21,"68071-0008-30 ")
 ;;2487
 ;;21,"68071-0028-30 ")
 ;;2488
 ;;21,"68071-0028-60 ")
 ;;2489
 ;;21,"68071-0388-30 ")
 ;;2490
 ;;21,"68071-0405-15 ")
 ;;2491
 ;;21,"68071-0406-15 ")
 ;;2492
 ;;21,"68071-0407-15 ")
 ;;2493
 ;;21,"68071-0823-30 ")
 ;;2494
 ;;21,"68084-0072-01 ")
 ;;2495
 ;;21,"68084-0072-11 ")
 ;;2496
 ;;21,"68084-0111-01 ")
 ;;2497
 ;;21,"68084-0111-11 ")
 ;;2498
 ;;21,"68084-0112-01 ")
 ;;2499
 ;;21,"68084-0112-11 ")
 ;;2500
 ;;21,"68084-0136-01 ")
 ;;2501
 ;;21,"68084-0136-11 ")
 ;;2502
 ;;21,"68084-0137-01 ")
 ;;2503
 ;;21,"68084-0137-11 ")
 ;;2504
 ;;21,"68084-0138-01 ")
 ;;2505
 ;;21,"68084-0138-11 ")
 ;;2506
 ;;21,"68084-0295-11 ")
 ;;2507
 ;;21,"68084-0295-21 ")
 ;;2508
 ;;21,"68084-0326-01 ")
 ;;2509
 ;;21,"68084-0326-11 ")
 ;;2510
 ;;21,"68084-0327-01 ")
 ;;2511
 ;;21,"68084-0327-11 ")
 ;;2512
 ;;21,"68084-0458-11 ")
 ;;2513
 ;;21,"68084-0458-21 ")
 ;;2514
 ;;21,"68084-0459-11 ")
 ;;2515
 ;;21,"68084-0459-21 ")
 ;;2516
 ;;21,"68084-0556-11 ")
 ;;2517
 ;;21,"68084-0556-21 ")
 ;;2518
 ;;21,"68084-0629-01 ")
 ;;2519
 ;;21,"68084-0629-11 ")
 ;;2520
 ;;21,"68084-0630-01 ")
 ;;2521
 ;;21,"68084-0630-11 ")
 ;;2522
 ;;21,"68084-0631-01 ")
 ;;2523
 ;;21,"68084-0631-11 ")
 ;;2524
 ;;21,"68084-0649-01 ")
 ;;2525
 ;;21,"68084-0649-11 ")
 ;;2526
 ;;21,"68084-0652-01 ")
 ;;2527
 ;;21,"68084-0652-11 ")
 ;;2528
 ;;21,"68084-0660-01 ")
 ;;2529
 ;;21,"68084-0660-11 ")
 ;;2530
 ;;21,"68084-0745-25 ")
 ;;2531
 ;;21,"68084-0745-95 ")
 ;;2532
 ;;21,"68084-0788-11 ")
 ;;2533
 ;;21,"68084-0788-21 ")
 ;;2534
 ;;21,"68084-0807-01 ")
 ;;2535
 ;;21,"68084-0807-11 ")
 ;;2536
 ;;21,"68084-0819-32 ")
 ;;2537