BGP9SXKC ; IHS/CMI/LAB -CREATED BY ^ATXSTX ON MAR 25, 2009 ;
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
START ;
 K:'$G(ATXPGMC) ^TMP("ATX",$J)
 S ATXPGMC=$G(ATXPGMC)+1
 F ATXI=1:1 S X=$P($T(TMP+ATXI),";;",2,99) Q:X=""  S X="^TMP(""ATX"",$J,"_X,ATXI=ATXI+1,Y=$P($T(TMP+ATXI),";;",2,99) S @X=Y
 Q
 ;
TMP ;;TAXONOMY (WITH BULLETIN)
 ;;21,"00839-7279-12 ")
 ;;304
 ;;21,"00839-7280-06 ")
 ;;305
 ;;21,"00839-7280-12 ")
 ;;306
 ;;21,"00904-0090-40 ")
 ;;307
 ;;21,"00904-0090-60 ")
 ;;308
 ;;21,"00904-0090-80 ")
 ;;309
 ;;21,"00904-0091-40 ")
 ;;310
 ;;21,"00904-0091-60 ")
 ;;311
 ;;21,"00904-0091-80 ")
 ;;312
 ;;21,"00904-0092-40 ")
 ;;313
 ;;21,"00904-0092-60 ")
 ;;314
 ;;21,"00904-1700-40 ")
 ;;315
 ;;21,"00904-1700-60 ")
 ;;316
 ;;21,"00904-1701-40 ")
 ;;317
 ;;21,"00904-2800-40 ")
 ;;318
 ;;21,"00904-2800-60 ")
 ;;319
 ;;21,"00904-2800-61 ")
 ;;320
 ;;21,"00904-2801-40 ")
 ;;321
 ;;21,"00904-2801-60 ")
 ;;322
 ;;21,"00904-2801-61 ")
 ;;323
 ;;21,"00904-3901-40 ")
 ;;324
 ;;21,"00904-3901-60 ")
 ;;325
 ;;21,"00904-3901-61 ")
 ;;326
 ;;21,"00904-3901-80 ")
 ;;327
 ;;21,"00904-3902-40 ")
 ;;328
 ;;21,"00904-3902-60 ")
 ;;329
 ;;21,"00904-3902-61 ")
 ;;330
 ;;21,"00904-3902-80 ")
 ;;331
 ;;21,"00904-3903-40 ")
 ;;332
 ;;21,"00904-3903-60 ")
 ;;333
 ;;21,"00904-3903-80 ")
 ;;334
 ;;21,"10019-0004-44 ")
 ;;335
 ;;21,"10019-0005-42 ")
 ;;336
 ;;21,"10019-0005-67 ")
 ;;337
 ;;21,"12280-0006-00 ")
 ;;338
 ;;21,"12280-0219-00 ")
 ;;339
 ;;21,"49884-0958-01 ")
 ;;340
 ;;21,"49884-0959-01 ")
 ;;341
 ;;21,"49884-0960-01 ")
 ;;342
 ;;21,"49884-0961-01 ")
 ;;343
 ;;21,"49884-0962-01 ")
 ;;344
 ;;21,"51079-0141-20 ")
 ;;345
 ;;21,"51079-0284-20 ")
 ;;346
 ;;21,"51079-0284-21 ")
 ;;347
 ;;21,"51079-0285-20 ")
 ;;348
 ;;21,"51079-0285-21 ")
 ;;349
 ;;21,"51079-0286-20 ")
 ;;350
 ;;21,"51079-0286-21 ")
 ;;351
 ;;21,"51079-0302-20 ")
 ;;352
 ;;21,"51079-0302-21 ")
 ;;353
 ;;21,"51079-0303-20 ")
 ;;354
 ;;21,"51079-0303-21 ")
 ;;355
 ;;21,"51079-0374-20 ")
 ;;356
 ;;21,"51079-0374-21 ")
 ;;357
 ;;21,"51079-0375-20 ")
 ;;358
 ;;21,"51079-0375-21 ")
 ;;359
 ;;21,"51655-0801-24 ")
 ;;360
 ;;21,"51655-0801-25 ")
 ;;361
 ;;21,"51655-0801-26 ")
 ;;362
 ;;21,"51655-0801-82 ")
 ;;363
 ;;21,"51655-0833-24 ")
 ;;364
 ;;21,"51655-0833-25 ")
 ;;365
 ;;21,"51655-0833-26 ")
 ;;366
 ;;21,"51655-0833-82 ")
 ;;367
 ;;21,"52544-0785-01 ")
 ;;368
 ;;21,"52544-0785-05 ")
 ;;369
 ;;21,"52544-0786-01 ")
 ;;370
 ;;21,"52544-0786-05 ")
 ;;371
 ;;21,"52544-0786-10 ")
 ;;372
 ;;21,"52544-0787-01 ")
 ;;373
 ;;21,"52544-0787-05 ")
 ;;374
 ;;21,"52959-0047-03 ")
 ;;375
 ;;21,"52959-0047-05 ")
 ;;376
 ;;21,"52959-0047-06 ")
 ;;377
 ;;21,"52959-0047-10 ")
 ;;378
 ;;21,"52959-0047-12 ")
 ;;379
 ;;21,"52959-0047-15 ")
 ;;380
 ;;21,"52959-0047-20 ")
 ;;381
 ;;21,"52959-0047-21 ")
 ;;382
 ;;21,"52959-0047-25 ")
 ;;383
 ;;21,"52959-0047-30 ")
 ;;384
 ;;21,"52959-0047-45 ")
 ;;385
 ;;21,"52959-0047-50 ")
 ;;386
 ;;21,"52959-0047-60 ")
 ;;387
 ;;21,"52959-0236-60 ")
 ;;388
 ;;21,"52959-0295-30 ")
 ;;389
 ;;21,"52959-0295-50 ")
 ;;390
 ;;21,"52959-0306-06 ")
 ;;391
 ;;21,"52959-0306-20 ")
 ;;392
 ;;21,"52959-0306-30 ")
 ;;393
 ;;21,"52959-0369-00 ")
 ;;394
 ;;21,"52959-0369-06 ")
 ;;395
 ;;21,"52959-0369-30 ")
 ;;396
 ;;21,"52959-0369-40 ")
 ;;397
 ;;21,"54569-0173-00 ")
 ;;398
 ;;21,"54569-0936-00 ")
 ;;399
 ;;21,"54569-0936-02 ")
 ;;400
 ;;21,"54569-0936-03 ")
 ;;401
 ;;21,"54569-0936-04 ")
 ;;402
 ;;21,"54569-0936-05 ")
 ;;403
 ;;21,"54569-0936-06 ")
 ;;404
 ;;21,"54569-0936-07 ")
 ;;405
 ;;21,"54569-0936-08 ")
 ;;406
 ;;21,"54569-0936-09 ")
 ;;407
 ;;21,"54569-0947-00 ")
 ;;408
 ;;21,"54569-0947-03 ")
 ;;409
 ;;21,"54569-0948-00 ")
 ;;410
 ;;21,"54569-0949-00 ")
 ;;411
 ;;21,"54569-0949-01 ")
 ;;412
 ;;21,"54569-0949-02 ")
 ;;413
 ;;21,"54569-0949-03 ")
 ;;414
 ;;21,"54569-0949-04 ")
 ;;415
 ;;21,"54569-0949-05 ")
 ;;416
 ;;21,"54569-0949-06 ")
 ;;417
 ;;21,"54569-0949-07 ")
 ;;418
 ;;21,"54569-1413-00 ")
 ;;419
 ;;21,"54569-2376-02 ")
 ;;420
 ;;21,"54569-2775-00 ")
 ;;421
 ;;21,"54569-4167-00 ")
 ;;422
 ;;21,"54569-4764-00 ")
 ;;423
 ;;21,"54868-0059-00 ")
 ;;424
 ;;21,"54868-0059-01 ")
 ;;425
 ;;21,"54868-0059-02 ")
 ;;426
 ;;21,"54868-0059-03 ")
 ;;427
 ;;21,"54868-0059-04 ")
 ;;428
 ;;21,"54868-0059-05 ")
 ;;429
 ;;21,"54868-0059-06 ")
 ;;430
 ;;21,"54868-0059-08 ")
 ;;431
 ;;21,"54868-0059-09 ")
 ;;432
 ;;21,"54868-0501-00 ")
 ;;433
 ;;21,"54868-0617-00 ")
 ;;434
 ;;21,"54868-0988-00 ")
 ;;435
 ;;21,"54868-0988-01 ")
 ;;436
 ;;21,"54868-0988-02 ")
 ;;437
 ;;21,"54868-0988-05 ")
 ;;438
 ;;21,"54868-2126-01 ")
 ;;439
 ;;21,"54868-2126-02 ")
 ;;440
 ;;21,"54868-2126-03 ")
 ;;441
 ;;21,"54868-2126-04 ")
 ;;442
 ;;21,"54868-2206-01 ")
 ;;443
 ;;21,"54868-2320-01 ")
 ;;444
 ;;21,"54868-2320-02 ")
 ;;445
 ;;21,"54868-4061-00 ")
 ;;446
 ;;21,"54868-4586-00 ")
 ;;447
 ;;21,"55045-1171-00 ")
 ;;448
 ;;21,"55045-1171-07 ")
 ;;449
 ;;21,"55045-1171-08 ")
 ;;450
 ;;21,"55045-1171-09 ")
 ;;451
 ;;21,"55045-1477-07 ")
 ;;452
 ;;21,"55045-1624-08 ")
 ;;453
 ;;21,"55045-1624-09 ")
 ;;454
 ;;21,"55045-1922-06 ")
 ;;455
 ;;21,"55045-2799-01 ")
 ;;456