APCPFIXD ; IHS/TUCSON/LAB - OHPRD-TUCSON/EDE FIX "APCIS" XREF AUGUST 14, 1992 ; [ 09/16/02 12:08 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**6**;APR 03, 1998
 ;
 ; This should not be necessary, but alas, things never seem to
 ; be the way they should be.  If this routine finds any xrefs
 ; to delete, it is symptomatic of a problem elsewhere.
 ;
START ;
 Q
 W:'$D(ZTQUEUED) !!,"Checking ""APCIS"" xref <WAIT>"
 S U="^"
 S D="" F  S D=$O(^AUPNVSIT("APCIS",D)) Q:D'=+D  D CHECK
 K D,X,E
 Q
 ;
CHECK ;
 S X="" F  S X=$O(^AUPNVSIT("APCIS",D,X)) Q:X'=+X  I $P(^AUPNVSIT(X,0),U,11) D KILL
 Q
 ;
KILL ;
 S E=1
 W:'$D(ZTQUEUED) !,X,"  ",$D(^AUPNVSIT("APCIS",$P(^AUPNVSIT(X,0),U,2),X)) K ^(X)
 K ^AUPNVSIT("APCIS",D,X)
 Q
