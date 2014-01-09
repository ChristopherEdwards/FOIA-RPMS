BLRAG02 ; IHS/MSC/SAT - LABORATORY ACCESSION GUI RPCS ; MAY 23, 2013  1500; SAT
 ;;5.2;IHS LABORATORY;**1031,1032**;NOV 01, 1997;Build 185
 ;
 ;return all accessioned lab records - RPC
ABD(BLRY,BLRBDT,BLREDT,BLRDFN,BLRDEV) ;return all accessioned records for given date range - RPC
 ; RPC Name is BLR ALL-ACCESSIONED
 ;INPUT
 ;   BLRBDT  = (optional) Begin Date in external date form
 ;                        defaults to 'today'
 ;   BLREDT  = (optional) End Date in external date form
 ;                        defaults to BLRBDT
 ;   BLRDFN  = (optional) return all accessioned lab records for this
 ;                        given patient only
 ;               return for all patients of this parameters is not defined
 ;   BLRDEV  = Printer for Manifest reprinting - IEN pointer to the DEVICE file
 ;             No printing will occur if null or undefined in the DEVICE file
 ;
 ;return all accessioned records for given date range - RPC
 ;  DFN               = patient IEN, pointer to VA PATIENT file 2
 ;  PNAME             = patient name as defined in the NAME field .01
 ;                      of the Va PATIENT file 2
 ;  ACCESSION_#       = as defined in the ACCESSION file 68
 ;  UID               = as defined in the LAB ORDER ENTRY file 69
 ;  TEST_NAME         = as defined in the NAME field .01 of the
 ;                      LABORATORY TEST file 60
 ;  COLLECTION_STATUS = as defined under the SPECIMEN Multiple in the
 ;                      LAB ORDER ENTRY file 69
 ;  REF_LAB_NAME      = as defined in the REF LAB NAME FOR SHIP MANIFEST
 ;                      field in the BLR MASTER CONTROL file
 ;  Client_#          = all Client account numbers as defined in the
 ;                      BLR MASTER CONTROL file 9009029 separated by pipe |
 ;  CHART_#           = patient HCRN for area
 ;  COLLECTION_DATE_TIME = date/time of specimen collection external format
 ;  PROVIDER_NAM         = name of person signing for the order
 ;  LRO69_POINTERS    = list of TEST POINTERS to LAB ORDER ENTRY file 69
 ;               BLRDT:BLRSP:BLRTEST
 ;                 BLRDT = Date pointer to the LAB ORDER ENTRY file 69
 ;                 BLRSP = Specimen pointer to the LAB ORDER ENTRY FILE 69
 ;                 BLRTEST = Test pointer to the LAB ORDER ENTRY FILE 69
 ;  ACCESSION_AREA_IEN = Accession Area pointer to file 68
 ;  ACCESSION_AREA_NAM = Accession Area name from file 68
 ;  ORDER_NUMBER = Unique order number to identify the specimen
 ;
 N BLR60NAM,BLR62NAM,BLRSPNS,BLRTOP
 N BLRCS
 N BLRACCNO,BLRDT,BLRHCRN,BLRI,BLRIFNL,BLRJ,BLRK,BLRLCNT,BLRLI,BLRLRDFN,BLRLST,BLRLSTI,BLROI
 N BLRLTMP,BLRNODS,BLRNODT,BLROERR,BLROLOC,BLRPADD
 N BLRPHRN,BLRPNAM,BLRSEX,BLRSP,BLRT,BLRTI,BLRTMP
 K ^TMP("BLRAG02",$J)  ;used to keep records for same patient together
 S (BLRPAD1,BLRPAD2,BLRPAD3,BLRPADC,BLRPADS,BLRPADZ,BLRTMP)=""
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 K BLRIFNL,BLRLTMP
 S (BLRI,BLRLCNT,BLROI,BLRTI)=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="ERROR_ID"
 S BLRTMP=""
 ;
 ;if begin date is null, default to today
 I $G(BLRBDT)="" S BLRBDT=$$HTFM^XLFDT($H,1)
 E  D
 .;convert external date to FM format
 .S X=BLRBDT,%DT="XT" D ^%DT S BLRBDT=$P(Y,".")
 .;default to 'today' if invalid date passed in
 .S:$$FR^XLFDT($G(BLRBDT)) BLRBDT=$$HTFM^XLFDT($H,1)
 ;
 ;if end date is null, default to begin date
 I $G(BLREDT)="" S BLREDT=BLRBDT
 E  D
 .;convert external date to FM format
 .S X=BLREDT,%DT="XT" D ^%DT S BLREDT=$P(Y,".")
 .;default to begin date if invalid date passed in
 .S:$$FR^XLFDT($G(BLREDT)) BLREDT=BLRBDT
 S BLRDFN=$G(BLRDFN)
 ;
 K BLRDTCK S BLRDTCK=""
 ;
 ;Only need to look at beginning based on BLRBDT for Yearly, Monthly, and Quarterly transforms.
 ; If the date range crosses years, months,or quarters, the Daily will catch them.
 ;look for accessions with yearly ACCESSION TRANSFORMS
 S BLRDATE=$E(BLRBDT,1,3)_"0000" S BLRDTCK(BLRDATE)=""
 S BLRAFMSC="" F  S BLRAFMSC=$O(^LRO(69,"AFMSC",BLRDATE,BLRAFMSC)) Q:BLRAFMSC=""  D ABDA
 ;
 ;look for accessions with monthly ACCESSION TRANSFORMS
 S BLRDATE=$E(BLRBDT,1,5)_"00"
 I '$D(BLRDTCK(BLRDATE)) D
 .S BLRDTCK(BLRDATE)=""
 .S BLRAFMSC="" F  S BLRAFMSC=$O(^LRO(69,"AFMSC",BLRDATE,BLRAFMSC)) Q:BLRAFMSC=""  D ABDA
 ;
 ;look for accessions with quarterly ACCESSION TRANSFORMS
 S BLRTN=+($E(BLRBDT,4,5)\3) S BLRTN=(BLRTN*3)+1 S BLRDATE=$E(BLRBDT,1,3)_$S(BLRTN<10:"0",1:"")_BLRTN_"00"
 I '$D(BLRDTCK(BLRDATE)) D
 .S BLRDTCK(BLRDATE)=""
 .S BLRAFMSC="" F  S BLRAFMSC=$O(^LRO(69,"AFMSC",BLRDATE,BLRAFMSC)) Q:BLRAFMSC=""  D ABDA
 ;
 ;look for accessions in given date range (daily ACCESSION TRANSFORMS)
 S BLRDATE=BLRBDT-1 F  S BLRDATE=$O(^LRO(69,"AFMSC",BLRDATE)) Q:BLRDATE'>0  Q:BLRDATE>BLREDT  D
 .I '$D(BLRDTCK(BLRDATE)) D
 ..S BLRAFMSC="" F  S BLRAFMSC=$O(^LRO(69,"AFMSC",BLRDATE,BLRAFMSC)) Q:BLRAFMSC=""  D ABDA
 ;
 D ABDHD
 S BLRJ="" F  S BLRJ=$O(^TMP("BLRAG02",$J,BLRJ)) Q:BLRJ=""  D
 .S BLRK="" F  S BLRK=$O(^TMP("BLRAG02",$J,BLRJ,BLRK)) Q:BLRK=""  D
 ..S BLRI=BLRI+1
 ..S ^TMP("BLRAG",$J,BLRI)=^TMP("BLRAG02",$J,BLRJ,BLRK)
 ;
 ;S BLRI=BLRI+1
 ;S ^TMP("BLRAG",$J,BLRI)=$C(31)
 Q
 ;
ABDA ;
 S BLRDT=$P(BLRAFMSC,"|",1)                      ; Order Date
 S BLRSP=$P(BLRAFMSC,"|",2)                      ; Order Specimen
 S BLRT=$P(BLRAFMSC,"|",3)                       ; Order Test
 ;
 S BLRORD=$P($G(^LRO(69,BLRDT,1,BLRSP,.1)),U,1)  ; Order #
 Q:$G(BLRORD)=""                                 ; Quit if no Order #
 ;
 S BLRNODS1=$G(^LRO(69,BLRDT,1,BLRSP,1))         ; specimen mult collection node
 S BLRCTIM=$P(BLRNODS1,U,1)                      ; Collection Time
 Q:+BLRCTIM<1                                    ; Quit if Collection time is null
 ;
 Q:$P(BLRCTIM,".")<$P(BLRBDT,".")!($P(BLRCTIM,".")>$P(BLREDT,"."))   ; IHS/MSC/MKK - BLR*5.2*1032 -- Quit if collection date not today, no matter the Accession Area.
 ;
 S BLRNODS=$G(^LRO(69,BLRDT,1,BLRSP,0))          ; specimen mult node
 S BLR62NAM=$P($G(^LAB(62,+$P(BLRNODS,U,3),0)),U,1)   ; Collection Sample
 ;
 S LRDOC=""
 S (BLRDOC,X)=$P(BLRNODS,U,6) D DOC^LRX
 S BLRDOCN=$E(LRDOC,1,25)                        ; Provider
 S BLRCS=$P($G(^LRO(69,BLRDT,1,BLRSP,1)),U,4)    ; Collection status
 S BLROLOC=$P(BLRNODS,U,9)                       ; Ordering Location
 ;
 S BLRNODT=$G(^LRO(69,BLRDT,1,BLRSP,2,BLRT,0))   ; test mult node
 I $P(BLRNODT,U,3)'="" D                         ; Accession Date
 .I $P(BLRNODT,U,9)'="CA" D                      ; Status
 ..I ($E($P(BLRNODT,U,3),6,7)="00")!(($P(BLRNODT,U,3)>=BLRBDT)&($P(BLRNODT,U,3)<=BLREDT)) D  ;accession date is in range
 ...S BLRLRDFN=$P(BLRNODS,U,1)                   ; lab data IEN
 ...S BLRLRNOD=$G(^LR(BLRLRDFN,0))               ; Lab Data file Patient node
 ...I $P(BLRLRNOD,U,2)=2 D
 ....S BLRPDFN=$P(BLRLRNOD,U,3)                  ; patient IEN
 ....I BLRDFN'="" Q:BLRDFN'=BLRPDFN              ; IFF passed in DFN, then only collect data for that patient
 ....;
 ....S BLRPNAM=$P(^DPT(BLRPDFN,0),U,1)           ; patient name
 ....S BLRACCNI=$P(BLRNODT,U,5)                  ; accession number (internal pointer to file 68)
 ....S BLRAREA=$P(BLRNODT,U,4)                   ; accession area
 ....S BLRAREAN=$P($G(^LRO(68,BLRAREA,0)),U,1)   ; accession area name
 ....S BLRDATE=$P(BLRNODT,U,3)                   ; accession date
 ....S BLRACCNO=$P($G(^LRO(68,BLRAREA,1,BLRDATE,1,BLRACCNI,.2)),U,1) ; Accession Number string
 ....S BLRUID=$P($G(^LRO(69,BLRDT,1,BLRSP,2,BLRT,.3)),U,1) ; UID
 ....; S BLR60NAM=$$GET1^DIQ(60,$P(BLRNODT,U,1)_",",.01)     ; test name
 ....S BLR60NAM=$$TESTNAME^BLRAGUT(+$P(BLRNODT,U,1))  ;get test name
 ....S BLRHCRN=$$HRCN^BDGF2(BLRPDFN,DUZ(2))      ; chart number - HCRN
 ....S BLR68TST=$O(^LRO(68,BLRAREA,1,BLRDATE,1,BLRACCNI,4,"B",$P(BLRNODT,U,1),0))
 ....S BLRRLNAM=$P($G(^BLRSITE(DUZ(2),"RL")),U,20)         ; lab name
 ....S BLRCLN=$P($G(^LRO(69,BLRDT,1,BLRSP,2,BLRT,"MSC")),U,1)   ; client number
 ....;
 ....;S BLRMAN=$P($G(^LRO(68,BLRAREA,1,BLRDATE,1,BLRACCNI,4,BLR68TST,0)),U,10)
 ....;S BLRINV=$$GET1^DIQ(62.8,BLRMAN_",",.01)              ; invoice number
 ....;S BLRCONF=$$GET1^DIQ(62.8,BLRMAN_",",.02)             ; shipping configuration
 ....;S BLRSTAT=$$GET1^DIQ(62.8,BLRMAN_",",.03)             ; shipping status
 ....;
 ....S BLRTI=BLRTI+1
 ....;
 ....;                                  0         1         2          3        4          5       6          7        8         9                            10        11                         12        13         14
 ....S ^TMP("BLRAG02",$J,BLRPDFN,BLRTI)=BLRPDFN_U_BLRPNAM_U_BLRACCNO_U_BLRUID_U_BLR60NAM_U_BLRCS_U_BLRRLNAM_U_BLRCLN_U_BLRHCRN_U_$$FMTE^XLFDT(BLRCTIM,"5M")_U_BLRDOCN_U_BLRDT_":"_BLRSP_":"_BLRT_U_BLRAREA_U_BLRAREAN_U_BLRORD
 ;
 Q
 ;
ABDHD ;
 S BLRTMP="T00020DFN^T00020PNAME^T00020ACCESSION_#^T00020UID^T00020TEST_NAME^T00020COLLECTION_STATUS^"
 S BLRTMP=BLRTMP_"T00020REF_LAB_NAME^T00020Client_#^T00020CHART_#^T00020COLLECTION_DATE_TIME^"
 S BLRTMP=BLRTMP_"T00020PROVIDER_NAM^T00020LRO69_POINTERS^T00020ACCESSION_AREA_IEN^T00020ACCESSION_AREA_NAM^"
 S BLRTMP=BLRTMP_"T00020ORDER_NUMBER"
 S ^TMP("BLRAG",$J,0)=BLRTMP
 Q
 ;
CLIENT() ;
 N BLRCN,BLRRET
 S BLRRET=""
 S BLRCN=$O(^BLRSITE(DUZ(2),"RLCA",0))
 S:BLRCN'="" BLRRET=$G(^BLRSITE(DUZ(2),"RLCA",BLRCN,0))
 I BLRCN'="" F  S BLRCN=$O(^BLRSITE(DUZ(2),"RLCA",BLRCN)) Q:BLRCN'>0  D
 .S BLRRET=BLRRET_"|"_$G(^BLRSITE(DUZ(2),"RLCA",BLRCN,0))
 Q BLRRET
 ;
ABR(BLRY,BLRUID,BLRLMF,BLRDEV) ;reprint accession label or manifest - RPC
 ; RPC Name is BLR ACCESSION PRINT
 ;  .BLRY   = returned pointer to appointment data
 ;INPUT:
 ;   BLRUID = UIDs of accession to reprint delimited by ^
 ;   BLRLMF = label or manifest flag 0=label (default); 1=manifest
 ;   BLRDEV  = Printer for Manifest printing - IEN pointer to the DEVICE file
 ;RETURNS:
 ;   ERROR_ID = 0=clean
 ;
 N BLRC1,BLRC2,BLRC3,BLRERR,BLRI,BLRJ,BLRUID1
 N LRAA,LRAD,LRAN,LRODT,LRSN
 S BLRERR=0
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 K BLRIFNL,BLRLTMP
 S BLRI=0
 K ^TMP("BLRAG",$J)
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="ERRORID"
 I $G(BLRLMF)="" S BLRLMF=0   ;default to label
 I '+$G(BLRUID) D ERR^BLRAGUT("BLRAG02: Invalid UID") Q
 ;
 I BLRLMF S IOP="`"_+$G(BLRDEV) D ^%ZIS
 F BLRJ=1:1:$L(BLRUID,"^") D
 .S BLRUID1=$P(BLRUID,"^",BLRJ)
 .S:'$D(^LRO(68,"C",BLRUID1)) BLRUID1=$P($G(^LRO(69,+$P(BLRUID1,":",1),1,+$P(BLRUID1,":",2),2,+$P(BLRUID1,":",3),.3)),"^",1)
 .Q:BLRUID1=""
 .S LRAA=$O(^LRO(68,"C",BLRUID1,0)) Q:LRAA=""
 .S LRAD=$O(^LRO(68,"C",BLRUID1,LRAA,0)) Q:LRAD=""
 .S LRAN=$O(^LRO(68,"C",BLRUID1,LRAA,LRAD,0)) Q:LRAN=""
 .I 'BLRLMF D            ;print labels
 ..S BLRDEVN=$P($G(^LAB(69.9,1,3.5,+DUZ(2),0)),U,3)  ;do not use passed in printer for labels; only manifest printer is passed in
 ..S BLRDEV=$O(^%ZIS(1,"B",BLRDEVN,0))
 ..I BLRDEV>0 D
 ...D LBLTYP^BLRAG02A  ;D LBLTYP^LRLABLD
 ...S IOP=$P($G(^%ZIS(1,BLRDEV,0)),U,1)
 ...D ^%ZIS
 ...Q:POP
 ...S LRLABLIO=ION_";"_IOST_";"_IOM_";"_IOSL
 ...U IO
 ...D PRINT^LRLABXT
 ...D ^%ZISC
 .I BLRLMF D             ;print manifests
 .. D RPRT(+$O(^BLRSHPM("B",BLRUID1,0)),$G(BLRDEV))
 I BLRDEV>0 S ^TMP("BLRAG",$J,0)="CLEAN" S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=0
 I BLRDEV<1 S BLRI=BLRI+1 S ^TMP("BLRAG",$J,BLRI)=1
 Q
 ;
RPRT(RIEN,BLRDEV) ;-- reprint
 U $$DEV($G(BLRDEV))
 N BLRDA
 S BLRDA=0 F  S BLRDA=$O(^BLRSHPM(RIEN,11,BLRDA)) Q:'BLRDA  D
 . W !,$G(^BLRSHPM(RIEN,11,BLRDA,0))
 D ^%ZISC
 Q
 ;
DEV(BLRDEV) ;-- device handler
 ; Return updated IO
 ; Return -1 error if device not defined at ^BLRSITE(<site>,"RL")
 S DEV=""
 I $G(BLRDEV)'="" S DEV=BLRDEV
 ;I DEV'="" S DEV=$$GET1^DIQ(3.5,BLRDEV_",",.01)
 S:DEV="" DEV=$S($P($G(^BLRSITE(DUZ(2),"RL")),U,2)]"":$P($G(^BLRSITE(DUZ(2),"RL")),U,2),1:"")  ;blr master control file
 I DEV="" Q -1
 S IOP="`"_DEV
 D ^%ZIS
 Q IO
 ;
UL(BLRY) ; rpc to return the value of the 'REF LAB USING LEDI?' field in the BLR MASTER CONTROL file
 ; RPC: BLR REF LAB USING LEDI
 ;Returns:
 ;  (0) REF LAB USING LEDI?   = 0='no'=CACHE (default); 1='yes'=ENSEMBLE
 ;  (1) REF LAB BILLING TYPE  = C=client
 ;                          P=patient
 ;                          T=third party
 ;  (2) CURRENT USER IEN      = pointer to VA PATIENT file 2
 ;  (3) CURRENT USER NAME     = value of NAME field in VA PATIENT
 ;  (4) PT CONFIRM            = Patient Confirmation enabled
 ;                          0='no' (default); 1='yes'
 ;  (5) USE INS SEQ           = value of REF LAB USE INSURANCE SEQ
 ;                          0='no' (default); 1='yes'
 ;  (6) CLIENT ACC LIST       = list of values from the
 ;                          REF LAB CLIENT ACCOUNT NUMBER multiple
 ;                          in BLR MASTER CONTROL separated by pipe |
 ;  (7) DEF DEV MANIFEST      = REF LAB DEV FOR SHIP MANIFEST
 ;                           default printer for Shipping Manifest
 ;                           ien pointer to the DEVICE file
 ;
 ;N BLRDOM,BLRENT,BLRPAR
 K ^TMP("BLRAG",$J)
 D ^XBKVAR S X="ERROR^BLRAGUT",@^%ZOSF("TRAP")
 S BLRY="^TMP(""BLRAG"","_$J_")"
 S ^TMP("BLRAG",$J,0)="ERROR_ID"
 N BLRBILL,BLRCANI,BLRCANL,BLRISEQ,BLRLEDI,BLRPTCF,BLRRET,BLRSITE,BLRUSERN
 S BLRCANL=""
 I '+$G(DUZ) D ERR^BLRAGUT("BLRAG02: Invalid user defined.") Q
 S BLRSITE=$G(^BLRSITE(DUZ(2),"RL"))
 S BLRLEDI=+$P(BLRSITE,U,22)             ; REF LAB USING LEDI?
 S BLRBILL=$P(BLRSITE,U,15)              ; REF LAB BILLING TYPE
 S BLRRET=$P($G(^BLRSITE(DUZ(2),"RL")),U,22)
 S BLRDEVM=$P(BLRSITE,U,2)               ;get default printer for Shipping Manifest
 S BLRUSERN=$$GET1^DIQ(200,DUZ_",",.01)  ;get user name
 S BLRPTCF=$$PTC^BLRAGUT()               ;get patient confirmation flag
 S BLRISEQ=+$P(BLRSITE,U,21)             ;get REF LAB USE INSURANCE SEQ
 S BLRCANI=$O(^BLRSITE(DUZ(2),"RLCA",0)) S:BLRCANI>0 BLRCANL=$P($G(^BLRSITE(DUZ(2),"RLCA",BLRCANI,0)),U,1)
 I BLRCANI>0 F  S BLRCANI=$O(^BLRSITE(DUZ(2),"RLCA",BLRCANI)) Q:BLRCANI'>0  S BLRCANL=BLRCANL_"|"_$P($G(^BLRSITE(DUZ(2),"RLCA",BLRCANI,0)),U,1)
 S ^TMP("BLRAG",$J,0)="T00020USING_LEDI?^T00020BILLING_TYPE^T00020CURRENT_USER_IEN^T00020CURRENT_USER_NAME^T00020PT_CONFIRM^T00020USE_INS_SEQ^T00100CLIENT_ACC_LIST^T00020DEF_DEV_MANIFEST"
 S ^TMP("BLRAG",$J,1)=+BLRLEDI_U_$G(BLRBILL)_U_DUZ_U_BLRUSERN_U_BLRPTCF_U_BLRISEQ_U_BLRCANL_U_BLRDEVM
 Q
