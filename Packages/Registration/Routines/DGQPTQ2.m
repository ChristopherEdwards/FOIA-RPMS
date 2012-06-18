DGQPTQ2 ; slc/CLA - Functions which return patient lists and list sources pt 2 ;12/15/97
 ;;5.3;Registration;**447**;Aug 13, 1993
CLIN(Y) ; RETURN LIST OF CLINICS
 N DGLST,IEN,I
 D GETLST^XPAR(.DGLST,"ALL","DGWD COMMON CLINIC")
 S I=0 F  S I=$O(DGLST(I)) Q:'I  D
 . S IEN=$P(DGLST(I),U,2) I $$ACTLOC^SDWU(IEN)=1 D
 .. S Y(I)=IEN_U_$P(^SC(IEN,0),U,1)
 Q
CLINPTS(Y,CLIN,DGBDATE,OREDATE) ; RETURN LIST OF PTS W/CLINIC APPT W/IN BEGINNING AND END DATES
 I +$G(CLIN)<1 S Y(1)="^No clinic identified" Q 
 I $$ACTLOC^SDWU(CLIN)'=1 S Y(1)="^Clinic is inactive or Occasion Of Service" Q
 N DFN,NAME,I,J,X,DGJ,DGSRV,DGNOWDT,CHKX,CHKIN,MAXAPPTS,DGC,CLNAM
 S MAXAPPTS=200
 S DGNOWDT=$$NOW^XLFDT
 S DGSRV=$G(^VA(200,DUZ,5)) I +DGSRV>0 S DGSRV=$P(DGSRV,U)
 S DFN=0,I=1
 I DGBDATE="" S DGBDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT CLINIC START DATE",1,"E"))
 I DGEDATE="" S DGEDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT CLINIC STOP DATE",1,"E"))
 ;CONVERT DGBDATE AND DGEDATE INTO FILEMAN DATE/TIME
 D DT^DILF("T",DGBDATE,.DGBDATE,"","")
 D DT^DILF("T",DGEDATE,.DGEDATE,"","")
 I (DGBDATE=-1)!(DGEDATE=-1) S Y(1)="^Error in date range." Q 
 S DGEDATE=$P(DGEDATE,".")_.5  ;ADD 1/2 DAY TO END DATE
 ;access to SC global granted under DBIA #518:
 S DGJ=DGBDATE F  S DGJ=$O(^SC(+CLIN,"S",DGJ)) Q:DGJ<1!(DGJ>DGEDATE)  D
 .I $L($G(^SC(+CLIN,"S",DGJ,1,0))) D
 ..S J=0 F  S J=$O(^SC(+CLIN,"S",DGJ,1,J)) Q:+J<1!(I>MAXAPPTS)  D
 ...S DGC=$P(^SC(+CLIN,"S",DGJ,1,J,0),U,9)
 ...Q:DGC="C"  ; cancelled clinic availability
 ...;
 ...S DFN=+$G(^SC(+CLIN,"S",DGJ,1,J,0))
 ...S X=$G(^DPT(DFN,"S",DGJ,0)) I +X'=CLIN Q  ; appt cancelled/resched
 ...;
 ...; quit if appt cancelled or no show:
 ...I $P(X,U,2)'="NT",($P(X,U,2)["C")!($P(X,U,2)["N") Q
 ...;
 ...S Y(I)=DFN_"^"_$P(^DPT(DFN,0),"^")_"^"_+CLIN_"^"_DGJ,I=I+1
 I I>MAXAPPTS D  ;maximum allowable appointments exceeded
 .S CLNAM=$P($G(^SC(CLIN,0)),U)
 .K Y S Y(1)="^CLINIC: "_CLNAM_" - Too many appointments found; please narrow search range."
 S:'$D(Y) Y(1)="^No appointments."
 Q
CDATRANG(DGY) ; return default start and stop dates for clinics in form start^stop
 N DGBDATE,DGEDATE,DGSRV
 S DGSRV=$G(^VA(200,DUZ,5)) I +DGSRV>0 S DGSRV=$P(DGSRV,U)
 S DGBDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT CLINIC START DATE",1,"E"))
 S DGEDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(DGSRV)_"^DIV^SYS^PKG","DGLP DEFAULT CLINIC STOP DATE",1,"E"))
 S DGBDATE=$S($L($G(DGBDATE)):DGBDATE,1:""),DGEDATE=$S($L($G(DGEDATE)):DGEDATE,1:"")
 S DGY=$$UP^XLFSTR(DGBDATE)_"^"_$$UP^XLFSTR(DGEDATE)
 Q
PTAPPTS(Y,DFN,DGBDATE,DGEDATE,CLIN) ; return appts for a patient between beginning and end dates for a clinic, if no clinic return all appointments
 ;I +$G(CLIN)<1 S Y(1)="^No clinic identified" Q 
 I +$G(CLIN)>0,$$ACTLOC^SDWU(CLIN)'=1 S Y(1)="^Clinic is inactive or Occasion Of Service" Q
 N VASD,NUM,CNT,INVDT,INT,EXT,DGSRV S NUM=0,CNT=1
 I (DGBDATE="")!(DGEDATE="") D  ;get user's service and set up entities:
 .S DGSRV=$G(^VA(200,DUZ,5)) I +DGSRV>0 S DGSRV=$P(DGSRV,U)
 I DGBDATE="" D
 .I '$L(CLIN) S DGBDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(DGSRV)_"^DIV^SYS^PKG","DGQQAP SEARCH RANGE START",1,"E"))
 .S:DGBDATE="" DGBDATE="T" ;default start date across all clinics is today
 I DGEDATE="" D
 .I '$L(CLIN) S DGEDATE=$$UP^XLFSTR($$GET^XPAR("USR^SRV.`"_+$G(DGSRV)_"^DIV^SYS^PKG","DGQQAP SEARCH RANGE STOP",1,"E"))
 .S:DGEDATE="" DGEDATE="T" ;default end date across all clinics is today
 ;CONVERT DGBDATE AND DGEDATE INTO FILEMAN DATE/TIME
 D DT^DILF("T",DGBDATE,.DGBDATE,"","")
 D DT^DILF("T",DGEDATE,.DGEDATE,"","")
 I (DGBDATE=-1)!(DGEDATE=-1) S Y(1)="^Error in date range." Q 
 S VASD("F")=DGBDATE
 S VASD("T")=$P(DGEDATE,".")_.5  ;ADD 1/2 DAY TO END DATE
 I $L($G(CLIN)) S VASD("C",CLIN)=""
 D SDA^VADPT
 Q:VAERR=1
 F  S NUM=$O(^UTILITY("VASD",$J,NUM)) Q:'NUM  D
 .S INT=^UTILITY("VASD",$J,NUM,"I"),INVDT=9999999-$P(INT,U)
 .S EXT=^UTILITY("VASD",$J,NUM,"E")
 .S Y(CNT)=$P(INT,U)_U_$P(EXT,U,2)_U_$P(EXT,U,3)_U_$P(EXT,U,4)_U_INVDT
 .S CNT=CNT+1
 S:+$G(Y(1))<1 Y(1)="^No appointments."
 K VAERR
 Q
PROV(Y) ; RETURN LIST OF PROVIDERS
 N I,IEN,NAME,TDATE
 S I=1,NAME=""
 F  S NAME=$O(^VA(200,"B",NAME)) Q:NAME=""  S IEN=0,IEN=$O(^(NAME,IEN))  D
 .Q:$E(NAME)="*"
 .I $D(^XUSEC("PROVIDER",IEN)),$$ACTIVE^XUSER(IEN) S Y(I)=IEN_"^"_NAME,I=I+1
 Q
PROVPTS(Y,PROV) ; RETURN LIST OF PATIENTS LINKED TO A PRIMARY PROVIDER
 I +$G(PROV)<1 S Y(1)="^No provider identified" Q
 N DGI,DFN
 S DGI=1,DFN=0
 F  S DFN=$O(^DPT("APR",PROV,DFN)) Q:DFN'>0  S Y(DGI)=+DFN_"^"_$P(^DPT(+DFN,0),"^"),DGI=DGI+1
 S:+$G(Y(1))<1 Y(1)="^No patients found."
 Q
SPEC(Y) ; RETURN LIST OF TREATING SPECIALTIES
 N I,NAME,IEN
 S I=1,NAME=""
 ;access to DIC(45.7 global granted under DBIA #519:
 F  S NAME=$O(^DIC(45.7,"B",NAME)) Q:NAME=""  S IEN=0,IEN=$O(^(NAME,IEN)) I $$ACTIVE^DGACT(45.7,IEN) S Y(I)=IEN_"^"_NAME,I=I+1
 Q
SPECPTS(Y,SPEC) ; RETURN LIST OF PATIENTS LINKED TO A TREATING SPECIALTY
 I +$G(SPEC)<1 S Y(1)="^No specialty identified" Q
 N DGI,DFN
 S DGI=1,DFN=0
 F  S DFN=$O(^DPT("ATR",SPEC,DFN)) Q:DFN'>0  S Y(DGI)=+DFN_"^"_$P(^DPT(+DFN,0),"^"),DGI=DGI+1
 S:+$G(Y(1))<1 Y(1)="^No patients found."
 Q
WARD(Y) ; RETURN LIST OF ACTIVE WARDS
 N I,IEN,NAME,D0
 S I=1,NAME=""
 ;access to DIC(42 global granted under DBIA #36:
 F  S NAME=$O(^DIC(42,"B",NAME)) Q:NAME=""  S IEN=$O(^(NAME,0)) D
 . S D0=IEN D WIN^DGPMDDCF
 . I X=0 S Y(I)=IEN_"^"_NAME,I=I+1
 Q
WARDPTS(Y,WARD) ; RETURN LIST OF PATIENTS IN A WARD
 ; SLC/PKS - Modifications for Room/Bed data on  1/19/2001.
 I +$G(WARD)<1 S Y(1)="^No ward identified" Q 
 N DGI,DFN,RBDAT
 S DGI=1,DFN=0
 ;access to DIC(42 global granted under DBIA #36:
 S WARD=$P(^DIC(42,WARD,0),"^")   ;GET WARD NAME FOR "CN"  LOOKUP
 ; Next section modified 1/19/2001 by PKS:
 F  D  Q:DFN'>0
 .S DFN=$O(^DPT("CN",WARD,DFN)) Q:DFN'>0
 .S Y(DGI)=+DFN_"^"_$P(^DPT(+DFN,0),"^")
 .S RBDAT=""
 .; Add patient room/bed information where data exists:
 .S RBDAT=$P($G(^DPT(+DFN,.101)),U)
 .; Assure at least 4 letters for any existing room/bed data:
 .I RBDAT'="" D                                   ; Any R/B data?
 ..I $L(RBDAT)<4 D                                ; Less than 4 now?
 ...S RBDAT=RBDAT_"   "                           ; Add 3 for safety.
 ...S RBDAT=$E(RBDAT,1,4)                         ; Get first 4 only.
 ...S Y(DGI)=Y(DGI)_U_RBDAT                       ; Add R/B to string
 .S DGI=DGI+1                                     ; Increment counter.
 ;
 S:+$G(Y(1))<1 Y(1)="^No patients found."
 Q
NLIST(DGQY) ; return a null list
 S DGQY(1)=""
 Q
