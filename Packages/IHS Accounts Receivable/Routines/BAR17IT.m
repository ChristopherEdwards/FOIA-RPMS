BAR17IT ; IHS/SD/LSL - INPUT TRANFORM FILE 90052.06, FIELD 17 3/12/02 2:40:05 PM ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**5**;JUN 22, 2008
 ;
 ; IHS/SD/SDR - 03/12/02 - V1.6 Patch 2 - NOIS XXX-0202-200181
 ;     Routine created.
 ;     Input transform for field 17 of file 90052.06
 ;
 ; *********************************************************************
 ;I $L(X)>25 K X Q
 I $L(X)>40 K X Q  ;BAR*1.8*5 IHS/SD/TPF 4/17/2008 FOUND TOO SHORT DURING TESTING
 I $L(X)<1 K X Q
 S X=$$LWC^BARUTL(X)
 ;
 I ^%ZOSF("OS")["MSM-UNIX" D
 .S X=$TR(X,"\","/")
 .S:$E(X)'="/" X="/"_X
 .S:$E(X,$L(X))'="/" X=X_"/"
 ;
 I ^%ZOSF("OS")["Windows NT" D
 .S X=$TR(X,"/","\")
 Q
