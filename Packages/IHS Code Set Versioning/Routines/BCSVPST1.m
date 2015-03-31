BCSVPST1 ;IHS/MSC/BWF - CSV Patch 1 ;27-Jun-2010 17:18;BF
 ;;1.0;BCSV;**1**;JUL 9,2010
 ;=================================================================
 Q
POST ;
 N X,X2
 S X=0 F  S X=$O(^ICD0(X)) Q:'X  D
 .S $P(^ICD0(X,"MDC",0),U,2)="80.12PA"
 .S X2=0 F  S X2=$O(^ICD0(X,"MDC",X2)) Q:'X2  D
 ..S ^ICD0(X,"MDC",X2,0)=X2
 ..I $D(^ICD0(X,"MDC",X2,1)) K ^ICD0(X,"MDC",X2,1)
 Q
