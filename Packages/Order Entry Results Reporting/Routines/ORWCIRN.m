ORWCIRN ; slc/dcm,REV - Functions for GUI CIRN ACTIONS ;22-NOV-1999 07:27:24
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,101,109,132,141,160,208**;October 28, 1997
 ;
FACLIST(ORY,ORDFN) ; Return list of remote facilities for patient
 ;Check to see if CIRN PD/MPI installed
 N X,ORSITES,I,IFN,LOCAL
 S X="MPIF001" X ^%ZOSF("TEST")
 I '$T S ORY(0)="-1^CIRN MPI not installed." Q
 S X="VAFCTFU1" X ^%ZOSF("TEST")
 I '$T S ORY(0)="-1^Remote data view not installed." Q
 S X=$$GET^XPAR("ALL","ORWRP CIRN REMOTE DATA ALLOW",1,"I")
 I 'X S ORY(0)="-1^Remote access not allowed" Q
 D TFL^VAFCTFU1(.ORY,ORDFN)
 I $$GET^XPAR("ALL","ORWRP CIRN SITES ALL",1,"I") D
 . S I=0
 . F  S I=$O(ORY(I)) Q:'I  S $P(ORY(I),"^",5)=1 I $P(ORY(I),"^")=776!($P(ORY(I),"^")=200) S $P(ORY(I),"^",2)="DEPT. OF DEFENSE"
 D GETLST^XPAR(.ORSITES,"ALL","ORWRP CIRN SITES","I")
 S I=0,LOCAL=$P($$SITE^VASITE,"^",3)
 F  S I=$O(ORY(I)) Q:'I  D
 . I +ORY(I)=+LOCAL K ORY(I) Q
 . S IFN=$$IEN^XUAF4(ORY(I))
 . I IFN,$G(ORSITES(IFN)) S $P(ORY(I),"^",5)=1 I $P(ORY(I),"^")=776!($P(ORY(I),"^")=200) S $P(ORY(I),"^",2)="DEPT. OF DEFENSE"
 I '$L($O(ORY(""))) S ORY(0)="-1^Only local data exists for this patient"
 Q
RESTRICT(ORY,PATID) ;Check for sensitive patient
 N DFN,ICN,SITE
 I '$G(PATID) S ORY(1)="-1",ORY(2)="Invalid Patient ID" Q
 S ICN=$P(PATID,";",2)
 I 'ICN S ORY(1)="-1",ORY(2)="Invalid ICN" Q
 S SITE=$$SITE^VASITE,SITE=$P(SITE,"^",2)_";"_$P(SITE,"^",3)
 S DFN=+$$GETDFN^MPIF001(ICN)
 I DFN<0 S ORY(1)="-1",ORY(2)="Patient not found on remote system ("_SITE_")" Q
 D PTSEC^DGSEC4(.ORY,DFN)
 Q
CHKLNK(ORY) ;Check for active HL7 TCP link on local system
 S ORY=$$STAT^HLCSLM
 Q
