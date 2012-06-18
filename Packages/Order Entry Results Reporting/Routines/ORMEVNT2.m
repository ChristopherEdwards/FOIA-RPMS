ORMEVNT2 ;SLC/DAN Additional event delayed order utilities ;7/22/03  11:14
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**177,186**;Dec 17, 1997
 ;
 ;DBIA SECTION
 ;10063 - %ZTLOAD
 ;17    - DGPM("ATID3"
 ;
DCGEN ;Auto-dc admission generic order for observation episode of
 ;care, if it exists and other orders are being carried over
 ;
 N ORLIST,ORADM,OREASON,ORNATR,X,ORCREATE,ORPRNT,ORSIG,ORI,ORPKG,ORDC,ORDT,ORN
 S ORLIST=$H
 S ORADM=$G(VAIP(13,1)) ;Admission date/time for this episode of care
 D ADMORD^ORMEVNT1 ;See if admission order exists
 Q:'$D(^TMP("ORR",$J,ORLIST))  ;no order found
 S OREASON=$P($G(^ORD(100.6,TORY,0)),U,4) I OREASON<1 S OREASON=+$O(^ORD(100.3,"C","ORDIS",0)) ;If no reason assigned to rule, use discharge
 S ORNATR=+$P($G(^ORD(100.03,+$G(OREASON),0)),U,7) I ORNATR<1 S ORNATR=+$O(^ORD(100.02,"C","A",0)) ;Get nature from reason, if none then use auto-dc
 S X=$G(^ORD(100.02,ORNATR,1)),ORCREATE=+$P(X,U),ORPRNT=+$P(X,U,2) ;create order action, print?
 S ORSIG=$S('ORCREATE:"",1:$P(X,U,4)) ;Signature required?
 S ORI=0 F  S ORI=$O(^ORD(100.6,TORY,7,"B",ORI)) Q:ORI<1  S ORPKG(ORI)=1 ;Identify packages to be auto-dcd for the rule
 S ORDT=$P($G(DGPMA),U),ORDC=TORY,ORN=""
 D DC1^ORMEVNT1 ;Code to auto-dc order
 Q
 ;
TIMER ;Start background job to make sure that patient was readmitted
 ;following the discharge from observation.  Readmission must
 ;occur within 1 hour
 N ZTSK,ZTRTN,ZTDESC,ZTDTH,ZTIO,ZTSAVE
 S ZTRTN="TIMERDQ^ORMEVNT2",ZTIO="",ZTDESC="Observation readmit"
 S ZTDTH=$P($G(^XTMP("ORDCOBS-"_+$G(ORVP),0)),U) ;If inpatient med orders will be reinstated, match timing
 I ZTDTH="" S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT,,1) ;One hour from now
 S ZTSAVE("*")="" ;Save everything for possible use in auto-dcing
 D ^%ZTLOAD
 Q
 ;
TIMERDQ ;Check if patient readmitted, if not, auto-dc orders that should have auto-dcd on discharge
 N CVAIP
 K VAIP("E") S VAIP("V")="CVAIP" D IN5^VADPT ;Is patient an inpatient?
 I $G(^XTMP("ORDCOBS-"_$G(DFN),"READMIT")) G DEL ;186 If readmit from ASIH OBS hasn't happened then auto-dc orders
 I CVAIP(13)'="",CVAIP(13)'=VAIP(13) Q  ;Check to see that patient is currently an inpatient and that they are in a different episode of care than the observation episode
 I +$P($Q(^DGPM("ATID3",DFN)),",",4)'=VAIP(1) Q  ;Stop if there's been another discharge since the discharge from observation.
DEL K ^XTMP("ORDCOBS-"_$G(DFN)) ;Inpatient meds waiting for reinstatement are no longer needed so XTMP can be deleted
 D AUTODC^ORMEVNT1(TORY,$P($G(DGPMA),U)) ;Auto-dc orders from observation
 I '$D(^ORE(100.2,$G(OREVENT),10)),$G(OREVENT) D ACTLOG^OREVNTX(OREVENT,"NW","D",1),DONE^OREVNTX(OREVENT,,DGPMDA) ;186 Log event in 100.2 if not previously done
 Q
