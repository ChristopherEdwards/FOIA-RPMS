BEHOOUS ; IHS/MSC/MGH - RPC functions which return user alert ;12-Mar-2013 13:45;DU
 ;;1.1;BEH COMPONENTS;;****;Build 1
 ;
 ;
KILUNSNO(Y,ORVP) ; Delete unsigned order alerts if no unsigned orders remaining
 S ORVP=ORVP_";DPT("
 D UNOTIF
 Q
 ;
UNOTIF ; -- Undo unsigned SS notification
 ;Check for the type of unsigned order, We only want surescripts ones
 N INVDT,ORD,CNT,RR
 S CNT=0
 S INVDT="" F  S INVDT=$O(^OR(100,"AS",ORVP,INVDT)) Q:'+INVDT  D
 .S ORD="" F  S ORD=$O(^OR(100,"AS",ORVP,INVDT,ORD)) Q:'+ORD  D
 ..S RR=$$VALUE^ORCSAVE2(+ORD,"SSRREQIEN")
 ..I +RR S CNT=CNT+1
 I CNT=0 D DELETE
 Q
DELETE ;Delete alert
 N XQAKILL,ORNIFN
 S ORNIFN=$O(^ORD(100.9,"B","SS REFILL REQUEST SIGNATURE",0))
 S XQAKILL=$$XQAKILL^ORB3F1(ORNIFN) ; unsigned orders notif
 I $D(XQAID),$P($P(XQAID,";"),",",3)=ORNIFN D DELETE^XQALERT
 I '$D(XQAID) S XQAID=$P($G(^ORD(100.9,ORNIFN,0)),U,2)_","_+ORVP_","_ORNIFN D DELETEA^XQALERT K XQAID
 Q
