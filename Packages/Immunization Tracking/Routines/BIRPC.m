BIRPC ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETURNS IMMUNIZATION HISTORY, FORECAST, IMM/SERV PROFILE.
 ;;  PATCH 1: Add API: FORCALL, to allow queued update of all BI Patients.
 ;
 ;
 ;----------
IMMHX(BIHX,BIDFN,BIDE,BISKIN,BIFMT) ;PEP - Return Immunization History.
 ;---> Return Patient's Immunization History.
 ;---> Immunizations returned in one string, delimited by "^".
 ;---> Parameters:
 ;     1 - BIHX   (ret) String of patient's immunizations_||_Error.
 ;     2 - BIDFN  (req) DFN of patient.
 ;     3 - BIDE   (opt) Array of Data Elements to be returned:
 ;                      BIDE(IEN of Data Element).
 ;     4 - BISKIN (opt) =1 if Skin Tests should be included (DEFAULT);
 ;                      =0 if Skin Tests should NOT be included.
 ;     5 - BIFMT  (opt) Format: 0=ASCII Split, 1=ASCII, 3=IMM/SERVE
 ;                      "Split" means the components of a combination vaccine
 ;                      will be split out as if they were given individually.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BI31,BIERR S BI31=$C(31)_$C(31)
 S BIHX="",BIERR=""
 ;
 ;---> If DFN not provided, set Error Code and quit.
 ;I $G(BIDFN) D  Q  ;---> Use this line to test error handling.
 I '$G(BIDFN) D  Q
 .D ERRCD^BIUTL2(306,.BIERR) S BIHX=BI31_BIERR
 ;
 ;---> Set required variables, kill ^BITMP($J).
 D SETVARS^BIUTL5 K ^BITMP($J)
 ;
 ;---> Set the Patient TEMP global.
 S ^BITMP($J,1,BIDFN)=""
 ;
 ;---> If BIDE local array (Data Elements to be returned) is not
 ;---> passed, then set the following default Data Elements.
 ;---> The following are IEN's in ^BIEXPDD(.
 ;---> IEN PC  DATA
 ;---> --- --  ----
 ;--->     1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;--->  4  2 = Vaccine Name, Short.
 ;--->  8  3 = Vaccine Components.  ;v8.0
 ;---> 24  4 = IEN, V File Visit.
 ;---> 26  5 = Location (or Outside Location) where Imm was given.
 ;---> 27  6 = Vaccine Group (Series Type) for grouping of vaccines.
 ;---> 29  7 = Date of Visit (DD-Mmm-YYYY @HH:MM).
 ;---> 38  8 = Skin Test Result.
 ;---> 39  9 = Skin Test Reading.
 ;---> 40 10 = Skin Test date read.
 ;---> 41 11 = Skin Test Name.
 ;---> 42 12 = Skin Test Name IEN.
 ;---> 44 13 = Reaction to Immunization, text.
 ;---> 51 14 = Release/Revision Date of VIS (DD-Mmm-YYYY).
 ;---> 61 15 = Encounter Provider.
 ;---> 65 16 = Dose Override.
 ;---> 66 17 = Date of Visit (MM/DD/YY).
 ;---> 69 18 = Vaccine Component CVX Code.
 ;---> 74 19 = CPT-Coded Visit.
 ;---> 78 20 - Imported from Outside Registry (if = 1).
 ;
 D:'$D(BIDE)
 .N I F I=4,8,24,26,27,29,38,39,40,41,42,44,51,61,65,66,69,74,78 S BIDE(I)=""
 N BIMM S BIMM("ALL")=""
 ;
 ;---> Next, gather Immunization History for this patient.
 ;     1 - BIFMT  (req) Format: 0=ASCII Split, 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     2 - BIDE   (req) Data Elements array (null if HL7)
 ;     3 - BIMM   (req) Array of Vaccine Types
 ;     4 - BIFDT  (opt) Forecast Date (not needed for history only).
 ;     5 - BISKIN (opt) =1 if Skin Tests should be included.
 ;
 S:'$D(BISKIN) BISKIN=1
 S:'$D(BIFMT) BIFMT=0
 D HISTORY^BIEXPRT3(BIFMT,.BIDE,.BIMM,,BISKIN)
 ;
 ;
 ;---> Next, set parameters for writing data as a string in BIHX.
 ;---> Parameters:
 ;     1 - BIEXP    (req) Export: 0=screen, 1=host file, 2=string
 ;     2 - BIFMT    (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     3 - BIFLNM   (opt) File name
 ;     4 - BIPATH   (opt) BI Path name for host files
 ;     5 - BIHX     (ret) Immunization History in "^"-delimited string
 ;
 D WRITE^BIEXPRT4(2,1,,,.BIHX)
 S BIHX=BIHX_BI31
 Q
 ;
 ;
 ;----------
IMMFORC(BIFORC,BIDFN,BIFDT,BIUPD,BIDUZ2,BIPDSS) ;PEP - Return Immunization Forecast.
 ;---> Return Immserve Patient Forecast in one string.
 ;---> Lines delimited by "^".
 ;---> Called by RPC: BI IMMSERVE PT PROFILE
 ;---> Parameters:
 ;     1 - BIFORC (ret) String of patient's forecast_||_Error.
 ;     2 - BIDFN  (req) DFN of patient.
 ;     3 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     4 - BIUPD  (opt) If BIUPD=1, do NOT update Immserve Forecast.
 ;                      Default $G(BIUPD)="", forecast gets updated.
 ;     5 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;     6 - BIPDSS (ret) Returned string of Visit IEN's that are
 ;                      Problem Doses, according to ImmServe.
 ;
 ;---> Define delimiter to pass error and error variable.
 N BI31,BIERR S BI31=$C(31)_$C(31),BIERR=""
 ;
 ;---> If the Vaccine Table is not standard, set Error Code and quit.
 I $D(^BISITE(-1)) D  Q
 .D ERRCD^BIUTL2(503,.BIERR) S BIFORC=BI31_BIERR
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(301,.BIERR) S BIFORC=BI31_BIERR Q
 ;
 ;---> If patient is deceased, report it as error (in msgbox).
 I $$DECEASED^BIUTL1(BIDFN) D  Q
 .D ERRCD^BIUTL2(205,.BIERR) S BIFORC=BI31_BIERR Q
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> If Forecast Date is before Patient's DOB, set Error Code and quit.
 I BIFDT<$$DOB^BIUTL1(BIDFN) D  Q
 .D ERRCD^BIUTL2(315,.BIERR) S BIFORC=BI31_BIERR
 ;
 ;---> Update patient's forecast with Immserve Utility (in ^BIPDUE).
 D:'$G(BIUPD) UPDATE^BIPATUP(BIDFN,BIFDT,.BIERR,1,$G(BIDUZ2),.BIPDSS)
 I BIERR]"" S BIFORC=BI31_BIERR Q
 ;
 ;---> If no Immunizations are due for this patient, return message.
 I '$D(^BIPDUE("B",BIDFN))&('$D(^BIPERR("B",BIDFN))) D  Q
 .S BIFORC="No immunizations due."_BI31
 .;---> NOTE! The above text is specifically checked for in ^BIPATVW1.
 ;
 ;---> Copy Immserve Patient Forecast (stored in ^BIPDUE) to string.
 N A,B,C,N,U,V,X,Z
 S:'$D(BIFORC) BIFORC="" S U="^",V="|"
 S N=0
 F  S N=$O(^BIPDUE("B",BIDFN,N)) Q:'N  D
 .S Z=$G(^BIPDUE(N,0))
 .I $P(Z,U)'=BIDFN K ^BIPDUE(N),^BIPDUE("B",BIDFN,N) Q
 .;
 .;---> A=Date Due, B=Date Past Due.
 .S A=$P(Z,U,4),B=$P(Z,U,5)
 .S X="  "_$$VNAME^BIUTL2($P(Z,U,2))  ;v8.0
 .;
 .;---> Concatenate due by/past due appropriate text and date.
 .S X=X_V_$S(B:" past due",1:" due")
 .S BIFORC=BIFORC_X_U
 ;
 ;
 ;---> Copy any Forecasting Errors (stored in ^BIPERR) to string.
 S N=0
 F  S N=$O(^BIPERR("B",BIDFN,N)) Q:'N  D
 .S Z=$G(^BIPERR(N,0))
 .I $P(Z,U)'=BIDFN K ^BIPERR(N),^BIPERR("B",BIDFN,N) Q
 .S X=$P(Z,U,2) S:'X X=999
 .;
 .S X=$P(Z,U,3)_" ERROR: "_$P((^BIERR(X,0)),"^",2)
 .S BIFORC=BIFORC_X_U
 ;
 S BIFORC=BIFORC_BI31
 Q
 ;
 ;
 ;
 ;----------
IMMPROF(BIGBL,BIDFN,BIFDT,BIDUZ2) ;PEP - Return ImmServe Profile in global array.
 ;---> Return ImmServe Profile in global array, ^BITEMP($J,"PROF".
 ;---> Lines delimited by "^".
 ;---> Called by RPC: BI PATIENT PROFILE GET
 ;---> Parameters:
 ;     1 - BIGBL  (ret) Name of result global containing patient's
 ;                      ImmServe Profile, passed to Broker.
 ;     2 - BIDFN  (req) DFN of patient.
 ;     3 - BIFDT  (opt) Forecast Date (date used to calc Imms due).
 ;     4 - BIDUZ2 (opt) User's DUZ(2) to indicate Immserve Forecasting
 ;                      Rules in Patient History data string.
 ;
 ;---> Delimiters to pass error with result to GUI.
 N BI30,BI31,BIERR,X
 S BI30=$C(30),BI31=$C(31)_$C(31)
 S BIGBL="^BITEMP("_$J_",""PROF"")",BIERR=""
 K ^BITEMP($J,"PROF")
 ;
 I '$G(BIDFN) D  Q
 .D ERRCD^BIUTL2(305,.BIERR) S ^BITEMP($J,"PROF",1)=BI31_BIERR
 ;
 ;---> If patient is deceased, report it as error (in msgbox).
 I $$DECEASED^BIUTL1(BIDFN) D  Q
 .D ERRCD^BIUTL2(205,.BIERR) S ^BITEMP($J,"PROF",1)=BI31_BIERR
 ;
 ;---> If the Patient is not in the Immunization Register,
 ;---> report the fact in the Profile (instead of as an error).
 I '$D(^BIP(BIDFN)) D  Q
 .N X
 .S X="This patient is not in the Immunization Register."
 .S ^BITEMP($J,"PROF",1)=X_BI30
 .S X="The Immserve Profile cannot be stored and displayed"
 .S ^BITEMP($J,"PROF",2)=X_BI30
 .S X="if the patient is not in the Register."
 .S ^BITEMP($J,"PROF",3)=X_BI30
 .S ^BITEMP($J,"PROF",4)=BI31
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> Update patient's profile with Immserve Utility.
 D UPDATE^BIPATUP(BIDFN,BIFDT,.BIERR,,$G(BIDUZ2))
 ;
 ;---> Copy Immserve Patient Profile to string.
 N I,N,U,X S U="^"
 S N=0
 F I=1:1 S N=$O(^BIP(BIDFN,1,N)) Q:'N  D
 .;---> Set null lines (line breaks) equal to one space, so that
 .;---> Windows reader will quit only at the final "null" line.
 .S X=^BIP(BIDFN,1,N,0) S:X="" X=" "
 .S ^BITEMP($J,"PROF",I)=X_BI30
 ;
 ;---> If no ImmServe Profile produced, report it as an error.
 I '$O(^BITEMP($J,"PROF",0)) D ERRCD^BIUTL2(307,.BIERR)
 ;
 ;---> Tack on Error Delimiter and any error.
 S ^BITEMP($J,"PROF",I)=BI31_BIERR
 Q
 ;
 ;
 ;----------
FORCALL ;PEP - Update Forecast for all Immunization Patients.
 ;---> Can be called by RPC: BI FORECAST ALL
 ;---> Can be called by OPTION: BI FORECAST ALL (may be queued in Taskman)
 ;---> This subroutine updates the immunization forecast for all patients in
 ;---> the File BI PATIENT IMMUNIZATIONS DUE File #9002084.1 for today.
 D ^XBKVAR
 N ZTIO S ZTIO=""
 N BIN S BIN=0
 F  S BIN=$O(^BIP(BIN)) Q:'BIN  D IMMFORC^BIRPC(,BIN)
 Q
