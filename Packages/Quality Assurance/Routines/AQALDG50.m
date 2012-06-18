AQALDG50 ; IHS/ORDC/LJF - AUTOLINK ADT OCC CONT. ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This rtn contains a series of entry points called by ^AQALDG5 to
 ;find event specific information prior to creating occurrences.
 ;
TI ;EP >> get extra data for transfer in
 S Y=$P(DGPMA,U,5),C=$P(^DD(405,.05,0),U,2) D Y^DIQ
 S AQALXTR(1)="Facility transferred from:  "_Y
 Q
 ;
READM ;EP >> get extra data for readmissions
 S AQALX=$O(^DGPM("ATID3",DFN,AQALST,0)),AQALX=$G(^DGPM(AQALX,0))
 S AQALDC=+AQALX,AQALCA=$P(AQALX,U,14)
 S AQALXTR(1)=" Last discharge date:  "_$$FMTE^XLFDT(+AQALDC)
 S AQALXTR(2)=" Last discharge service:  "_$$SRVP($P(AQALX,U,14))
 S AQALXTR(3)=" Last admission dx:  "_$P(^DGPM(AQALCA,0),U,10)
 S AQALXTR(4)=" This admission dx:  "_$P(DGPMA,U,10)
 Q
 ;
DSADM ;EP >> get extra data for admit after day surgery
 S AQALX=$O(^ADGDS("APID",DFN,AQALST,0))
 S AQALX=$G(^ADGDS(DFN,"DS",AQALX,0))
 S AQALXTR(1)=" Last Day Surgery Date:  "_$$FMTE^XLFDT(+AQALX)
 S AQALXTR(2)=" Last Day Surgery service:  "_$$DSSRV(AQALX)
 S AQALXTR(3)=" Last Day Surgery Procedure:  "_$P(AQALX,U,2)
 S AQALXTR(4)=" This admission dx:  "_$P(DGPMA,U,10)
 Q
 ;
ICU ;EP >> get extra data for icu transfers
 S X=$O(^DGPM("APMV",DFN,DGPMCA,AQALST,0)),AQALX=$G(^DGPM(X,0))
 S AQALXTR(1)=" Last ward:  "_$$WDP(AQALX)
 S AQALXTR(2)=" Admission dx:  "_$P($G(^DGPM(DGPMCA,0)),U,10)
 Q
 ;
RICU ;EP >> get extra data for return to icu
 S AQALXTR(1)=" Last discharge from ICU:  "_$$FMTE^XLFDT(AQALST)
 S AQALXTR(2)=" Admission dx:  "_$P($G(^DGPM(DGPMCA,0)),U,10)
 Q
 ;
DSCH ;EP >> get extra data for discharges
 S AQALXTR(1)=" Admission dx:  "_$P($G(^DGPM(DGPMCA,0)),U,10)
 I AQALEV=1051 D
 .S Y=$P(DGPMA,U,5),C=$P(^DD(405,.05,0),U,2) D Y^DIQ
 .S AQALXTR(2)=" Transferred to:  "_Y
 Q
 ;
SRV(X) ; >> hospital service ifn for movement
 N Y S Y=$O(^DGPM("APHY",X,0))
 I Y]"" S Y=$P(^DGPM(Y,0),U,9)
 I Y]"" S Y=$P($G(^DIC(45.7,Y,0)),U,4)
 Q Y
 ;
SRVP(X) ; >> hospital service name
 Q $P($G(^DIC(49,+$$SRV(X),0)),U)
 ;
WDP(X) ; >> ward name
 Q $P($G(^DIC(42,$P(X,U,6),0)),U)
 ;
IVDTP(X) ; >> convert inverse date to readable date
 Q $$FMTE^XLFDT($$IDATE(X))
 ;
IDATE(X) ; >> inverse date
 Q (9999999.9999999-X)
 ;
DSSRV(X) ; >> find day surgery service
 Q $P($G(^DIC(49,$P($G(^DIC(45.7,$P(AQALX,U,5),0)),U,4),0)),U)
