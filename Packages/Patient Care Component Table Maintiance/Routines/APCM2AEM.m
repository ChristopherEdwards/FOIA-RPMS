APCM2AEM ;IHS/CMI/LAB - IHS MU AVG CENSUS;
 ;;1.0;MU PERFORMANCE REPORTS;**7**;MAR 26, 2012;Build 15
 ;
 ;
AVC(APCMBD,APCMED,F) ;EP - GET # H VISITS IN PREVIOUS CALENDAR YEAR AND DIVIDE BY 365
 NEW BD,ED,X,Y,T,D
 S X=$E(APCMBD,1,3)-1
 S BD=X_"0101"
 S ED=X_"1231"
 S Y=1700+X
 S D=$S($$LEAP^%DTC(Y):366,1:365)
 S SD=$$FMADD^XLFDT(BD,-1)_".9999"
 S T=0
 F  S SD=$O(^AUPNVSIT("B",SD)) Q:SD'=+SD!($P(SD,".")>ED)  D
 .S X=0 F  S X=$O(^AUPNVSIT("B",SD,X)) Q:X'=+X  D
 ..Q:'$D(^AUPNVSIT(X,0))
 ..Q:$P(^AUPNVSIT(X,0),U,7)'="H"
 ..Q:$P(^AUPNVSIT(X,0),U,6)'=F
 ..Q:$P(^AUPNVSIT(X,0),U,11)  ;deleted
 ..S T=T+1
 Q T/D
AVCADT(APCMBD,APCMED) ; -- have user select report by ward or by service
 NEW APCMFRM,APCMIA
 S APCMFRM=1
 S APCMIA=1
 ;
 ;
INIT ; -- init variables and list array
 NEW APCMDAYS,APCMADC
 K APCMADC
 S APCMDAYS=$$FMDIFF^XLFDT(APCMED,APCMBD)+1   ;# of days in date range
 ;
 D 1         ;gather ward or service stats for date range
 ;
 I '$D(APCMADC) Q 0
 ;
 Q APCMADC
 ;
1 ; step thru ADT Census-Ward file for date range
 NEW WARD,WRDNM,DATE,APCMA,X,LINE,TOTAL
 S WARD=0
 F  S WARD=$O(^BDGCWD(WARD)) Q:'WARD  D
 . I APCMIA=0,'$D(^BDGWD(WARD)) Q          ;old ward, no longer used
 . I APCMIA=0,$$GET1^DIQ(9009016.5,WARD,.03)="INACTIVE" Q
 . S WRDNM=$$GET1^DIQ(42,WARD,.01)        ;ward name
 . ;
 . S DATE=APCMBD-.001
 . F  S DATE=$O(^BDGCWD(WARD,1,DATE)) Q:DATE>APCMED  Q:'DATE  D
 .. ; count patients remaining and one day patients
 .. S X=$P($G(^BDGCWD(WARD,1,DATE,0)),U,2)+$P($G(^(0)),U,8)
 .. ; increment array for total inpatient days
 .. S APCMA(WRDNM)=$G(APCMA(WRDNM))+X
 ;
 ; put sorted data into display array
 S WARD=0 F  S WARD=$O(APCMA(WARD)) Q:WARD=""  D
 . ; increment totals
 . S TOTAL=$G(TOTAL)+APCMA(WARD)
 ;
 ; put totals line into display array
 I $G(TOTAL) D
 . S APCMADC=TOTAL/APCMDAYS
 Q
