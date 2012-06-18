ADEKNT ; IHS/HQT/MJL - COMPILE DENTAL REPORTS ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;**23**;JUN 6, 2011
 ;
 ; TODO: Add facility capability to reports
 ;Entry points:
 ;  ADEKNT - prompt year,quarter & do all objectives.
 ;  EN(Objective)- prompt year.quarter, do objectives in parameter
 ;  ZTM - Tasked option ADEK-QUARTER
 ;  KNS - Called by ADEKNS installation routine
 ;
 N ADEYQ,ADESELOB
TOP ;
 S ADEYQ=$$ASKYQ^ADEKNT4()
 G:'ADEYQ END
 ;Objective(s) to be processed are stored in ;-delimited string ADESELOB
 ;which may also contain "ALL", "DATE", or "USER"
 S:'$D(ADESELOB) ADESELOB="ALL"
 S ZTRTN="START^ADEKNT",ZTDESC="DENTAL STATS "_ADEYQ,ZTIO="",ZTSAVE("ADEYQ")="",ZTSAVE("ADESELOB")="" D ^%ZTLOAD G END ;***TODO: Uncomment after test
 G START
 ;
ZTM ;EP - Entry point for tasked option ADEK-QUARTER
 N ADEYQ,ADESELOB
 S ADEYQ=$$QTR^ADEKNT5(DT)
 S ADESELOB="ALL"
 G START
 ;
KNS(ADEYQ,ADESELOB) ;EP - Called by ADEKNS installation routine
 G START
 ;
START ;EP
 N ADEBDI,ADEEDI,ADEDFN,ADEV,ADEVD,ADEVDFN,ADEUP,ADEDUP
 N ADECLIN,ADEFAC
 N ADEPER,ADE3BD,ADE1BD,ADEED,ADE3BDI,ADE1BDI,ADEQBDI,ADEEDI
 N ADECTR,ADEOBJ,ADEDOB,ADEHXC,ADEHXO,ADEIEN,ADEIND,ADELOE,ADEOGRP
 N ADEPAT,ADEQBD,ADEYR,ADE
 N DR,DIE,DIC
 K ^TMP($J,"CTR")
 ;
S2 ;
 ;Get Start time
 S ADE("STARTTIME")=$H
 ;Set error trap to send mailman message that count routine abended
 I $D(^%ZOSF("TRAP")) S X="ERR^ADEKNT3",@^%ZOSF("TRAP")
 ;I $D(^%ZOSF("MAXSIZ")) S X=255 X ^%ZOSF("MAXSIZ")
 ;
 ;INIT:
 S ADEPER=$$PERIOD^ADEKNT5($P(ADEYQ,"."),+$P(ADEYQ,".",2))
 S ADE3BD=$P(ADEPER,U,3)
 S ADE1BD=$P(ADEPER,U,4)
 S ADEQBD=$P(ADEPER,U,5)
 S ADEED=$P(ADEPER,U,2)
 ;
 ;Set inverse beginning and ending dates
 S ADE3BDI=9999999-ADE3BD
 S ADE1BDI=9999999-ADE1BD
 S ADEQBDI=9999999-ADEQBD
 S ADEEDI=9999999-ADEED
 ;
 ;Get ^-delimited dental facility IENs in ADEFAC
 S ADEFAC=$$LOADFAC^ADEKRP()
 ;
 ;Initialize counter array ^TMP($J,"CTR", for all objectives in ^ADEKOB
 D ARRAY^ADEKNT1(ADESELOB)
 ;
 ;B  ;Break here to examine initial ^TMP($J,"CTR",
 ;
PROC ;$O Thru ^AUPNPAT
 S ADEDFN=0
 ;This is the production line:
 I ADESELOB'="DATE" F  S ADEDFN=$O(^AUPNPAT(ADEDFN)) Q:+ADEDFN'=ADEDFN  D
 . ;I ADESELOB'="DATE" F ADEDFN=1,2 D  ;***COMMENT AFTER TEST
 . ;This is the test line:
 . ;Get DOB
 . Q:'$D(^AUPNPAT(ADEDFN,0))
 . Q:'$D(^DPT(ADEDFN,0))
 . S ADEDOB=$P(^DPT(ADEDFN,0),U,3)
 . Q:'+ADEDOB  ;Quit if no DOB
 . Q:ADEDOB>ADEED  ;Quit if born after enddate
 . I ($E(DT,1,3)-$E(ADEDOB,1,3))>123 Q  ;Age > 123 -- DOB Wrong
 . ;Set objective age group array ADEOBJ(
 . D ADEOBJ(ADEDOB)
 . ;Indian or Non-Indian (ADEIND)
 . S ADEIND=$$INDIAN(ADEDFN)
 . ;Increment User Counters
 . D:ADESELOB["ALL"!(ADESELOB["USER") USER
 . ;Increment Objective Counters
 . D OBJECT^ADEKNT2 ;***Uncomment after test of visit counters
 ;
 ;Increment daily & visit Counters
 D:ADESELOB["ALL"!(ADESELOB["DATE") DATE^ADEKNT1
 ;
 ;Q  ;Break here to examine finished ^TMP($J,"CTR",
 ;Update DENTAL OBJECTIVE COUNT file
 D FILE^ADEKNT3
 ;Send mail message
 D BULL^ADEKNT3(1)
 ;California stats
 D CFBULL^ADEKNT6(+ADEYQ)
 ;Processing time in minutes
 S ADE("PROC_TIME")=$$MIN^ADEKNT3(ADE("STARTTIME"),$H)
 S ^ADEUTL("ADEKNT_TIME")=(60*$P(ADE("PROC_TIME"),U))+($P(ADE("PROC_TIME"),U,2))+60
 ;
END ;EP
 ;All local variables are NEW; none have to be KILLed
 Q
 ;
USERDONE()         ;Return 1 if all facilities have a visit count
 N ADEDON,J
 S ADEDON=1
 Q:'ADEGOTV 0
 F J=1:1:$L(ADEFAC,U) D  Q:'ADEDON
 . I '+$G(ADEGOTV($P(ADEFAC,U,J))) S ADEDON=0
 Q ADEDON
 ;
USER ;$O Thru ^AUPNVSIT entries for patient ADEDFN
 N ADEGOTV
 S ADEGOTV=0
 S ADEV=ADEEDI-1
 F  S ADEV=$O(^AUPNVSIT("AA",ADEDFN,ADEV)) Q:ADEV'=+ADEV  S ADEVD=$P(ADEV,".") Q:ADEVD>ADE3BDI  D  Q:$$USERDONE()
 . S ADEVDFN=0
 . F  S ADEVDFN=$O(^AUPNVSIT("AA",ADEDFN,ADEV,ADEVDFN)) Q:ADEVDFN'=+ADEVDFN  D  Q:$$USERDONE()
 . . ;If pt had visit S ADEGOTV=1
 . . Q:'$D(^AUPNVSIT(ADEVDFN,0))
 . . N ADENOD
 . . S ADENOD=^AUPNVSIT(ADEVDFN,0)
 . . Q:$P(ADENOD,U,11)  ;Delete flag
 . . Q:'$P(ADENOD,U,9)  ;Dependent entries
 . . Q:"DXECT"[$P(ADENOD,U,7)  ;Service Category
 . . Q:'$D(^AUPNVPOV("AD",ADEVDFN))  ;No POV
 . . Q:'$D(^AUPNVPRV("AD",ADEVDFN))  ;No Provider
 . . S ADELOE=$P(ADENOD,U,6) ;Location
 . . ;It's a legit visit so if ADEGOTV hasn't already been set
 . . ;then set it to 1 and increment the med visit counters
 . . I 'ADEGOTV D  ;All Facilities
 . . . S ADEGOTV=1
 . . . ;F ADEIEN="MEDICAL USER (ALL)",$S(ADEIND=1:"MEDICAL USER (INDIAN)",1:"MEDICAL USER (NON-INDIAN)") D
 . . . F ADEIEN=3,$S(ADEIND=1:1,1:2) D
 . . . . Q:$G(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)))=""  D
 . . . . . F K=$S(ADEVD'>ADEQBDI:1,ADEVD'>ADE1BDI:2,1:3):1:3 S $P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,K)=$P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN)),U,K)+1
 . . . Q
 . . I '+$G(ADEGOTV(ADELOE)) D
 . . . S ADEGOTV(ADELOE)=1
 . . . F ADEIEN=3,$S(ADEIND=1:1,1:2) D
 . . . . Q:$G(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN),ADELOE))=""  D
 . . . . . F K=$S(ADEVD'>ADEQBDI:1,ADEVD'>ADE1BDI:2,1:3):1:3 S $P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN),ADELOE),U,K)=$P(^TMP($J,"CTR",ADEIEN,ADEOBJ(ADEIEN),ADELOE),U,K)+1
 . . Q
 . Q
 Q
 ;
INDIAN(ADEDFN) ;EP
 ;Return 1 if Indian or if NO TRIBE at all
 ;Else return 2 (NON-Indian)
 ;Conforms to logic in APCLACC2
 N ADEIND
 I '$D(^AUPNPAT(ADEDFN,11)) Q 1
 S ADEIND=$P(^AUPNPAT(ADEDFN,11),U,8)
 I ADEIND="" Q 1
 I '$D(^AUTTTRI(ADEIND,0)) Q 1
 S ADEIND=$P(^AUTTTRI(ADEIND,0),U,2)
 I +ADEIND,ADEIND<969 Q 1
 I ADEIND=997 Q 1
 Q 2
 ;
ADEOBJ(ADEDOB)     ;EP
 ;$O thru ^TMP($J,"CTR", and
 ;Set ADEOBJ( array based on ADEDOB
 N ADEIEN
 S ADEIEN=0 K ADEOBJ
 F  S ADEIEN=$O(^TMP($J,"CTR",ADEIEN)) Q:'+ADEIEN  D
 . S ADEOGRP=0
 . F  S ADEOGRP=$O(^TMP($J,"CTR",ADEIEN,ADEOGRP)) Q:ADEOGRP'?1N.E  D  Q:$D(ADEOBJ(ADEIEN))
 . . Q:ADEDOB<$P(^TMP($J,"CTR",ADEIEN,ADEOGRP),U,4)
 . . Q:ADEDOB>$P(^TMP($J,"CTR",ADEIEN,ADEOGRP),U,5)
 . . S ADEOBJ(ADEIEN)=ADEOGRP
 . . Q
 . Q
 Q
 ;
EN(ADESELOB)       ;EP
 ;Enter here with ADESELOB defined
 ;
 N ADEYQ
 G TOP
