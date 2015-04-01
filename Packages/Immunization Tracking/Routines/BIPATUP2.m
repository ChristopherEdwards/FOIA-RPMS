BIPATUP2 ;IHS/CMI/MWR - UPDATE PATIENT DATA 2; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  IHS FORECAST. UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  NOTE!: An earlier version of this routine is saved in BIZPATUP2.
 ;;  PATCH 8: Changes for Problem Doses retrieval from TCH Forecaster.  DPROBS+10
 ;;  PATCH 9: Mods to flag only problem components of combo vaccines.  DPROBS+23
 ;
 ;
 ;----------
DPROBS(BIFORC,BIPDSS,BIID) ;EP
 ;---> Check for any Input Doses that have Dose Problems.
 ;---> If any exist, build the string BIPDSS, concatenating the
 ;---> Visit IEN's with U.
 ;---> Parameters:
 ;     1 - BIFORC (req) Forecast string coming back from TCH.
 ;     2 - BIPDSS (ret) Returned string of V IMM IEN's that are Problem Doses.
 ;                      according to ImmServe.
 ;     3 - BIID   (ret) NO LONGER USED. Immserve "Number of Input Doses" (Field 109 in 2010).
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Changes to accommodate new TCH Forecaster.
 ;
 S BIPDSS=""
 ;
 ;---> NOTE: Pulling History from the TCH Output String (NOT RPMS Input string).
 N BIFORC1,BIDOSE,N
 S BIFORC1=$P(BIFORC,"~~~",2)
 ;
 F N=1:1 S BIDOSE=$P(BIFORC1,"|||",N) Q:(BIDOSE="")  D
 .;---> If this Input Dose was TCH-invalid (pc6), set V Imm IEN_%_CVX in
 .;---> Problem Doses string (BIPDSS).
 .;
 .;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 .;---> Mods to flag only problem components of combo vaccines.
 .;
 .;---> Quit if this is not a problem dose.
 .Q:('$P(BIDOSE,U,6))
 .;
 .N BICVXS S BICVXS=$P(BIDOSE,U,7)
 .;---> If piece 7 is null then not a combo, set BIPDSS and quit.
 .I 'BICVXS S BIPDSS=BIPDSS_$P(BIDOSE,U)_"%"_$P(BIDOSE,U,2)_U Q
 .;
 .;--> Piece 7 equals one or more problem CVX's in this combo, delimited by comma.
 .N J F J=1:1 S BICVX=$P(BICVXS,",",J) Q:'BICVX  D
 ..S BIPDSS=BIPDSS_$P(BIDOSE,U)_"%"_BICVX_U
 .;**********
 ;
 ;W !,BIPDSS R ZZZ
 Q
 ;
 ;
 ;----------
KILLDUE(BIDFN) ;EP
 ;---> Clear out any previously set Immunizations Due and
 ;---> any Forecasting Errors for this patient.
 ;---> Hardcoded to improve performance during massive reports.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient IEN.
 ;
 Q:'BIDFN
 ;
 ;---> Clear previous Immunizations Due.
 D:$D(^BIPDUE("B",BIDFN))
 .N N S N=0
 .F  S N=$O(^BIPDUE("B",BIDFN,N)) Q:'N  D
 ..N Y,Z S Y=$G(^BIPDUE(N,0))
 ..K ^BIPDUE(N),^BIPDUE("B",BIDFN,N)
 ..Q:Y=""
 ..S Z=$P(Y,U,4) K:Z ^BIPDUE("D",Z,N)
 ..S Z=$P(Y,U,5) K:Z ^BIPDUE("D",Z,N)
 ..S $P(^BIPDUE(0),U,4)=$P(^BIPDUE(0),U,4)-1
 .K ^BIPDUE("B",BIDFN),^BIPDUE("E",BIDFN)
 ;
 ;---> Clear previous Forecasting Errors.
 D:$D(^BIPERR("B",BIDFN))
 .N N S N=0
 .F  S N=$O(^BIPERR("B",BIDFN,N)) Q:'N  D
 ..K ^BIPERR("B",BIDFN,N),^BIPERR(N)
 ..S $P(^BIPERR(0),U,4)=$P(^BIPERR(0),U,4)-1
 .K ^BIPERR("B",BIDFN)
 Q
 ;
 ;
 ;----------
IMMSDT(DATE) ;EP
 ;---> Convert Immserve Date (format MMDDYYYY) TO FILEMAN
 ;---> Internal format.
 ;---> NOTE: This code is copied from routine ^BIUTL5 for speed.
 ;---> Any changes here should also be made to ^BIUTL5 too.
 Q:'$G(DATE) "NO DATE"
 Q ($E(DATE,5,9)-1700)_$E(DATE,1,2)_$E(DATE,3,4)
 ;
 ;
 ;----------
PNMAGE(BISITE) ;EP - Return Age Appropriate in years for Pneumo at this site.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) "65"
 N Y
 S Y=$P($G(^BISITE(BISITE,0)),U,10) S:'Y Y=65
 Q Y
 ;---> q6-years no longer used.
 ;Q:'$G(BISITE) "65^0"
 ;N Y,Z
 ;S Y=$P($G(^BISITE(BISITE,0)),U,10) S:'Y Y=65
 ;S Z=$P($G(^BISITE(BISITE,0)),U,22) S:'Z Z=0
 ;Q Y_U_Z
 Q
 ;
 ;
 ;----------
FLUALL(BISITE) ;EP - Return 1 to forecast Flu for ALL ages.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) 1
 N Y S Y=$P($G(^BISITE(BISITE,0)),U,27)
 Q:(Y=0) 0
 Q 1
 ;
 ;
 ;----------
ZOSTER(BISITE) ;EP - Return 1 if Zostervax should be forecast.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) 1
 N Y S Y=$P($G(^BISITE(BISITE,0)),U,29)
 Q:(Y=0) 0
 Q 1
 ;
 ;
 ;----------
SETDUE(BIDATA) ;EP
 ;---> Code to add this Immunization Due to BI PATIENT IMM DUE File #9002084.1.
 ;---> Hardcoded to improve performance during massive reports.
 ;---> Parameters:
 ;     1 - BIDATA (req) Data string (5 fields) for 0-node.
 ;                      BIDFN^Vaccine IEN^Dose#^Recommended Date^Date Past Due
 ;
 Q:$G(BIDATA)=""
 N A,B,BIDFN,M,N
 S M=^BIPDUE(0),N=$P(M,U,3),M=$P(M,U,4) S:'N N=1
 F  Q:'$D(^BIPDUE(N))  S N=N+1
 S BIDFN=$P(BIDATA,U) Q:'BIDFN
 S ^BIPDUE(N,0)=BIDATA
 ;
 ;********** PATCH 1, v8.3.1, Dec 30,2008, IHS/CMI/MWR
 ;---> Add 6th pc, Date Forecast Calculated.
 S:$G(DT) $P(^BIPDUE(N,0),U,6)=DT
 ;**********
 ;
 S ^BIPDUE("B",BIDFN,N)=""
 S A=$P(BIDATA,U,4),B=$P(BIDATA,U,5)
 I A S ^BIPDUE("D",A,N)=""
 I B S ^BIPDUE("D",B,N)="",^BIPDUE("E",BIDFN,B,N)=""
 S $P(^BIPDUE(0),U,3,4)=N_U_(M+1)
 Q
