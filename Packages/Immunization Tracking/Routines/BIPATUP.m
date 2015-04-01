BIPATUP ;IHS/CMI/MWR - UPDATE PATIENT FORECAST; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE PATIENT FORECAST DATA, IMM PROFILE IN ^BIP(DFN,
 ;;  AND IMM FORECAST IN ^BIPDUE(.
 ;;  PATCH 8: Changes to accommodate new TCH Forecaster  UPDATE+81,+99, LDPROF+18, BIDE+6
 ;;  PATCH 9: Insert patient name and DOB at top of Report Text (for EHR).  LDPROF+28
 ;;           Add DUZ2 so that BIXTCH can retrieve IP address for TCH.
 ;
 ;
 ;----------
UPDATE(BIDFN,BIFDT,BIERR,BINOP,BIDUZ2,BIPDSS) ;EP
 ;---> Update Patient Imms Due (in ^BIPDUE) using Immserve Utility.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     3 - BIERR  (ret) String returning text of error code.
 ;     4 - BINOP  (opt) If BINOP=1 do not retrieve Imm Profile.
 ;     5 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;     6 - BIPDSS (ret) Returned string of Visit IEN's that are
 ;                      Problem Doses, according to TCH.
 ;
 S BIERR=""
 ;
 ;---> If Vaccine global (^AUTTIMM) is not standard, set Error Text
 ;---> in patient's Profile global, return Error Text and quit.
 I $D(^BISITE(-1)) D  Q
 .K ^BIP(BIDFN,1)
 .D ERRCD^BIUTL2(503,.BIERR)
 .S ^BIP(BIDFN,1,1,0)=BIERR
 .S ^BIP(BIDFN,1,0)=U_U_1_U_1_U_DT
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 ;
 ;---> Return 1 if Forecasting is enabled.
 I '$$FORECAS^BIUTL2(DUZ(2)) D ERRCD^BIUTL2(314,.BIERR) Q
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> If no BIDUZ2, try DUZ(2); otherwise, defaults will be used.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 ;
 ;---> If BINOP not specified, retrieve and store Imm Profile.
 S:'$G(BINOP) BINOP=0
 ;
 ;---> Quit if this patient is Locked (being edited by another user).
 L +^BIP(BIDFN):0 I '$T D ERRCD^BIUTL2(212,.BIERR) Q
 ;
 ;---> Set required variables, kill ^BITMP($J).
 D SETVARS^BIUTL5 K ^BITMP($J)
 ;
 ;---> Set the patient temp global.
 S ^BITMP($J,1,BIDFN)=""
 ;
 ;---> Gather Immunization History for this patient (into ^BITMP) .
 ;---> Parameters:
 ;     1 - BIFMT  (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     2 - BIDE   (req) Data Elements array (null if HL7)
 ;     3 - BIMM   (req) Array of Imms to be passed to forecasting.
 ;     4 - BIFDT  (opt) Forecast Date (date used to calc Imms due).
 ;     5 - BISKIN (opt) ""=Do not retrieve Skin Tests.
 ;     6 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;     7 - BINF   (opt) Array of Vaccines that should not be forecast.
 ;
 ;
 ;---> Build local array of Vaccines (by HL7 Code) that should not
 ;---> be forecast, according to this machine's Immunization File.
 N BINF D NOFORC(.BINF)
 ;
 N BIDE S BIDE="" D BIDE(.BIDE)
 N BIMM S BIMM("ALL")=""
 ;
 ;---> Gather Patient Imm History in ^BITMP.
 D HISTORY^BIEXPRT3(3,.BIDE,.BIMM,BIFDT,,BIDUZ2,.BINF)
 ;
 ;---> Retrieve data for this patient from ^BITMP, return in BIHX.
 ;---> Parameters:
 ;     1 - BIEXP    (req) Export: 0=screen, 1=host file, 2=string
 ;     2 - BIFMT    (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     3 - BIFLNM   (opt) File name
 ;     4 - BIPATH   (opt) BI Path name for host files
 ;     5 - BIHX     (ret) Immunization History in "^"-delimited string
 ;
 N BIHX S BIHX=""
 D WRITE^BIEXPRT4(2,3,,,.BIHX)
 ;
 ;---> Check for precise Date of Birth.
 N X S X=$P(BIHX,U,8)
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Change error check to accommodate new TCH date format.
 ;I ('$E(X,1,2))!('$E(X,3,4))!('$E(X,5,8)) D ERRCD^BIUTL2(215,.BIERR) Q
 I ('$E(X,1,4))!('$E(X,5,6))!('$E(X,7,8)) D ERRCD^BIUTL2(215,.BIERR) Q
 ;**********
 ;
 ;
 ;---> Use Immunization History (in BIHX) to obtain Immserve Forecast.
 ;---> Parameters:
 ;     1 - BIHX   (req) String contain Patient's Immunization History.
 ;     2 - BIPROF (ret) String returning text version of profile.
 ;     3 - BIFORC (ret) String returning data version of forecast.
 ;     4 - BIERR  (ret) String returning text of error code.
 ;
 N BIPROF,BIFORC S (BIPROF,BIFORC)=""
 ;
 ;---> Call ImmServe and get Forecast and Profile.
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Call new TCH Forecaster.
 ;D RUN^BIXCALL(BIHX,.BIPROF,.BIFORC,.BIERR)
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add DUZ2 so that BIXTCH can retrieve IP address for TCH.
 ;D RUN^BIXTCH(BIHX,.BIPROF,.BIFORC,.BIERR)
 D RUN^BIXTCH(BIHX,BIDUZ2,.BIPROF,.BIFORC,.BIERR)
 ;**********
 ;
 ;---> For diagnostic purposes.
 ;D DISPLAY
 ;
 I BIERR]"" D UNLOCK(BIDFN) Q
 ;
 ;---> Load Forecast into BI PATIENT IMMUNIZATIONS DUE File (^BIPDUE).
 ;---> Pass BIHX (history) and BIFDT to check for >65yrs need for Pneumo.
 ;---> need for Influenza and Pneumo.
 D LDFORC^BIPATUP1(BIDFN,BIFORC,BIHX,BIFDT,BIDUZ2,.BINF,.BIPDSS)
 ;
 ;---> Load Report Text into patient WP global (^BIP(DFN,1,).
 D:'BINOP LDPROF(BIDFN,BIPROF)
 ;
 ;---> Unlock patient.
 D UNLOCK(BIDFN)
 Q
 ;
 ;
 ;----------
LDPROF(BIDFN,BIPROF,BIERR) ;EP
 ;---> Entry point to load Immserve Profile into Patient's global.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIPROF (req) String containing text of Patient's Imm Profile.
 ;     3 - BIERR  (ret) String returning text of error code.
 ;
 S BIERR=""
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 ;
 ;---> Quit if Patient does not exist in Immunization Register.
 I '$D(^BIP(BIDFN,0)) D ERRCD^BIUTL2(204,.BIERR) Q
 ;
 ;---> Load Report Text into Patient's WP Node.
 D SETVARS^BIUTL5
 K ^BIP(BIDFN,1)
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Switch to $C(13,10)) to accommodate new TCH Report.
 ;S X=$L(BIPROF,$C(13))
 ;F I=1:1:X S ^BIP(BIDFN,1,I,0)=$P(BIPROF,$C(13),I)
 ;N X S X=$L(BIPROF,$C(13,10))
 ;F I=1:1:X S ^BIP(BIDFN,1,I,0)=$P(BIPROF,$C(13,10),I)
 N X S X=$L(BIPROF,"|||")
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Insert patient name and DOB at top of Report Text (for EHR).
 ;F I=1:1:X S ^BIP(BIDFN,1,I,0)=$P(BIPROF,"|||",I)
 S ^BIP(BIDFN,1,1,0)=" "
 S ^BIP(BIDFN,1,2,0)="Patient: "_$$NAME^BIUTL1(BIDFN)_"    DOB: "_$$DOBF^BIUTL1(BIDFN,$G(BIFDT))
 S ^BIP(BIDFN,1,3,0)=" "
 F I=1:1:X S ^BIP(BIDFN,1,(I+3),0)=$P(BIPROF,"|||",I)
 ;**********
 ;
 S ^BIP(BIDFN,1,0)=U_U_X_U_X_U_DT
 Q
 ;
 ;
 ;----------
BIDE(BIDE) ;EP
 ;---> Set Data Elements for TCH Format.
 ;---> (Old v7.x: 6=Dose#, 23=Date of Visit, 25=HL7 Code.)
 ;---> 25=CVX Code, 65=Dose Override, 88=TCH Date of Visit.
 K BIDE
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Pull TCH date format instead of Immserve.
 ;N I F I=23,25,65 S BIDE(I)=""
 N I F I=25,65,88 S BIDE(I)=""
 ;**********
 Q
 ;
 ;
 ;----------
UNLOCK(BIDFN) ;EP
 ;---> Unlock BI PATIENT global for this patient.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient DFN to unlock.
 ;
 Q:'$G(BIDFN)
 L -^BIP(BIDFN)
 Q
 ;
 ;
 ;----------
NOFORC(BINF) ;EP
 ;---> Build local array of Vaccines Group IEN's that Site has
 ;---> specified should not be forecast.
 ;---> Parameters:
 ;     1 - BINF (ret) Array of Vaccine Group IEN's that should not be forecast.
 ;
 N N S N=0
 F  S N=$O(^BISERT(N)) Q:'N  D
 .I '$P(^BISERT(N,0),U,5) S BINF(N)=""
 Q
 ;
 ;
DISPLAY ;EP
 ;---> Display Input and Output Data Strings.
 ;---> Uncomment any of the next lines to see History or ImmServe data:
 ;W !!,"BIHX Out: ",BIHX R ZZZ
 ;W !!,"BIFORC Full: ",BIFORC R ZZZ
 ;
 D  R ZZZ:600
 .W #!," RPMS INPUT String, Patient Data: "
 .W !,"   ",$P(BIHX,"~~~",1)
 .;
 .W !!," RPMS INPUT String, Dose History Input doses: "
 .N BIDOSE,BIDOSES,I S BIDOSES=$P(BIHX,"~~~",2)
 .F I=1:1 S BIDOSE=$P(BIDOSES,"|||",I) Q:(BIDOSE="")  W !,"   ",BIDOSE
 ;
 D  R ZZZ:600
 .W !!!," TCH OUTPUT String, Input doses: "
 .N BIDOSE,BIDOSES,I S BIDOSES=$P(BIFORC,"~~~",2)
 .F I=1:1 S BIDOSE=$P(BIDOSES,"|||",I) Q:(BIDOSE="")  W !,"   ",BIDOSE
 ;
 D  R ZZZ:600
 .W !!!," TCH OUTPUT String, Doses Due: "
 .N BIDOSE,BIDOSES,I S BIDOSES=$P(BIFORC,"~~~",3)
 .F I=1:1 S BIDOSE=$P(BIDOSES,"|||",I) Q:(BIDOSE="")  W !,"   ",BIDOSE
 ;
 Q
