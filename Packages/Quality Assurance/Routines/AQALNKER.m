AQALNKER ; IHS/ORDC/LJF - SEND ERROR MESSAGE IN BULLETIN ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This routine processes the error messages by sending a bulletin
 ;to all package administrators.  It lists the patient's name, chart
 ;number and all errors found that prevented adding or modifiying an
 ;occurrence.  Called by ^AQALNK and ^AQALNK1.
 ;
ERRORMSG ; >>> send bulletin if any error messages exist
 S XMB=AQALNK("BUL"),XMDUZ="QI LINKAGES MESSENGER"
 S X=0 F  S X=$O(^AQAO(9,"AC","QA",X)) Q:X=""
 .S XMY(X)="",XMY(X,1)="I" ;set pkg admin as recipients-info only
 S AQALAR(1)="PATIENT IS "_$P($G(^DPT(AQALNK("PAT"),0)),U)
 S AQALAR(2)="CHART #"_$P($G(^AUPNPAT(AQALNK("PAT"),41,DUZ(2),0)),U,2)
 S X=0,Y=2 F  S X=$O(AQALNKF(X)) Q:X=""  S Y=Y+1,AQALAR(Y)=AQALNKF(X)
 S XMTEXT="AQALAR(" D ^XMB K XMB,XMDUX,XMY,XMTEXT
 Q
