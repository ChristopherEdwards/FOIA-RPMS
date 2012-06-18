BEHOCMAL ;IHS/MSC/IND/PLS - Community Alert;21-Apr-2010 21:22;PLS
 ;;1.1;BEH COMPONENTS;**050001;Mar 20, 2007
 ;=================================================================
LINK ;EP - Link protocol to VueCentric Subscription Event Protocol
 D REGPROT^CIAURPC("CIAV SUBSCRIBE EVENT","BEH COMMUNITY ALERT")
 I $$REGRPC^CIAURPC("BQI GET COMM ALERTS SPLASH","CIAV VUECENTRIC")
 Q
 ; Fire community event if needed
COMALRT ; EP
 I $G(TYPE)="SUBSCRIBE.COMMUNITY" D
 .D:$$CHK() QUEUE^CIANBEVT("COMMUNITY","")
 Q
 ; Check the number of LOGIN events for the user for the current day
 ; Returns 0 or 1
 ;   0 = no fire of community event
 ;   1 = fire community event
CHK() ;EP
 N LP,NODE,RES
 S RES=0
 S LP=0 F  S LP=$O(^CIANB(19941.23,"D",DUZ,LP)) Q:'LP  D
 .S NODE=^CIANB(19941.23,LP,0)
 .Q:NODE'["LOGIN"
 .S RES=RES+($P($P(NODE,U),".")=$$DT^XLFDT())
 Q RES<2
