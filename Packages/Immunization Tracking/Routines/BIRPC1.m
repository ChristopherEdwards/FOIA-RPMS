BIRPC1 ;IHS/CMI/MWR - REMOTE PROCEDURE CALLS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETURNS PATIENT DATA, DATA FOR AN IMMUNIZATION OR SKIN TEST VISIT.
 ;
 ;
 ;----------
PDATA(BIDATA,BIDFN) ;EP
 ;---> Return Patient Data in 5 ^-delimited pieces:
 ;--->   1 - DOB in format: OCT 01,1994.
 ;--->   2 - Age in format: 35 Months.
 ;--->   3 - Text of Patient's sex.
 ;--->   4 - HRCN in the format XX-XX-XX.
 ;--->   5 - Text of ACTIVE/INACTIVE Status.
 ;---> Parameters:
 ;     1 - BIDATA  (ret) String of patient data||error.
 ;     2 - BIDFN   (req) DFN of patient.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BI31,BIERR S BI31=$C(31)_$C(31)
 S BIDATA="",BIERR=""
 ;
 ;---> If DFN not supplied, set Error Code and quit.
 I '$G(BIDFN) D  Q
 .D ERRCD^BIUTL2(201,.BIERR) S BIDATA=BI31_BIERR
 ;
 ;---> DOB.
 S BIDATA=$$TXDT1^BIUTL5($$DOB^BIUTL1(BIDFN))
 ;
 ;---> Age.
 S BIDATA=BIDATA_U_$$AGEF^BIUTL1(BIDFN)
 ;
 ;---> Text of sex.
 S BIDATA=BIDATA_U_$$SEXW^BIUTL1(BIDFN)
 ;
 ;---> HRCN, format XX-XX-XX.
 S BIDATA=BIDATA_U_$$HRCN^BIUTL1(BIDFN)
 ;
 ;---> Active/Inactive Status.
 S BIDATA=BIDATA_U_$$ACTIVE^BIUTL1(BIDFN)
 ;
 S BIDATA=BIDATA_BI31
 ;
 Q
 ;
 ;
 ;----------
GET(BIDATA,BIDA,BIVTYPE,BIDE) ;PEP - Return data for one Immunization or Skin Test.
 ;---> Return data for one Immunization or Skin Test.
 ;---> Called by RPC: BI VISIT GET.
 ;---> Parameters:
 ;     1 - BIDATA  (ret) Visit Data or Text of Error Code if any.
 ;     2 - BIDA    (req) IEN of V IMM or V SKIN entry for data retrieval.
 ;     3 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     4 - BIDE    (opt) Local array for Data Elements to be returned.
 ;
 ;---> Delimiter to pass error with result to GUI.
 N BI31,BIERR S BI31=$C(31)_$C(31)
 S BIDATA="",BIERR=""
 ;
 ;---> If BIVTYPE does not="I" (Immunization Visit) and it does
 ;---> not="S" (Skin Test Visit), then set Error Code and quit.
 I ($G(BIVTYPE)'="I")&($G(BIVTYPE)'="S") D  Q
 .D ERRCD^BIUTL2(410,.BIERR) S BIDATA=BI31_BIERR
 ;
 ;---> If BIDA not supplied, set Error Code and quit.
 I '$G(BIDA) D  Q
 .D ERRCD^BIUTL2(409,.BIERR) S BIDATA=BI31_BIERR
 ;
 ;---> Set required variables, kill ^BITMP($J).
 D SETVARS^BIUTL5 K ^BITMP($J)
 ;
 ;---> Set BIDE local array for Data Elements to be returned.
 ;---> IENs are in ^BIEXPDD(, the BI TABLE DATA ELEMENT File.
 ;---> The Pieces (PC) indicate position in the returned data string,
 ;---> BIDATA, below.
 ;---> Branching logic for Immunization versus Skin Test Visits.
 ;
 ;---> IMMUNIZATION:
 ;---> If this is an Immunization Visit, collect these Data Elements.
 N I
 ;---> Next line: 6 (Dose#) defunct, but serves as a place holder. v8.0
 I '$D(BIDE),BIVTYPE="I" F I=4,6,24,27,29:1:37,43,49,51,61,65,67,68,76,77,78,80  S BIDE(I)=""
 ;
 ;---> IEN PC  DATA
 ;---> --- --  ----
 ;--->     1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;---> 4   2 = Vaccine Name, Short.
 ;---> 6   3 = Dose#.  v8.0 No longer used.
 ;---> 24  4 = V IMMUNIZATION IEN.
 ;---> 27  5 = Vaccine Group ("Series Type").
 ;---> 29  6 = Date of Immunization (DD-Mmm-YYYY @HH:MM).
 ;---> 30  7 = Vaccine Name, IEN.
 ;---> 31  8 = Vaccine maximum Dose#.
 ;---> 32  9 = Vaccine Lot Number, IEN.
 ;---> 33 10 = Vaccine Lot Number.
 ;---> 34 11 = Location IEN.
 ;---> 35 12 = Category of Visit (A,E, or I)
 ;---> 36 13 = Location Other (text).
 ;---> 37 14 = Location IHS (text).
 ;---> 43 15 = Vaccine Reaction.
 ;---> 49 16 = VIS Statement Info (Yes/No).
 ;---> 51 17 = Release/Revision Date of VIS (DD-Mmm-YYYY).
 ;---> 61 18 = Immunization Provider IEN.
 ;---> 65 19 = Dose Override.
 ;---> 67 20 = Injection Site.
 ;---> 68 21 = Volume.
 ;---> 76 22 = Visit IEN.
 ;---> 77 23 = VFC Eligibility.
 ;---> 78 24 - Imported from Outside Registry (1=imported, 2=imported & edited).
 ;---> 80 25 = NDC Code pointer IEN.
 ;
 ;
 ;---> SKIN TEST:
 ;---> If this is a Skin Test Visit, collect these Data Elements.
 I '$D(BIDE),BIVTYPE="S" F I=24,26,29,34:1:42,61,67,68,70,76 S BIDE(I)=""
 ;
 ;---> IEN PC  DATA
 ;---> --- --  ----
 ;--->     1 = Visit Type: "I"=Immunization, "S"=Skin Test.
 ;---> 24  2 = V File IEN.
 ;---> 26  3 = Location (or Outside Location) of Visit.
 ;---> 29  4 = Date of Skin Test (DD-Mmm-YYYY @HH:MM).
 ;---> 34  5 = Location IEN.
 ;---> 35  6 = Category of Visit (A,E, or I)
 ;---> 36  7 = Location Other (text).
 ;---> 37  8 = Location IHS (text).
 ;---> 38  9 = Skin Test Result.
 ;---> 39 10 = Skin Test Reading.
 ;---> 40 11 = Skin Test Date Read.
 ;---> 41 12 = Skin Test Name.
 ;---> 42 13 = Skin Test Name IEN.
 ;---> 61 14 = Immunization Provider IEN.
 ;---> 67 15 = Injection Site.
 ;---> 68 16 = Volume.
 ;---> 70 17 = Skin Test Reader (Provider) IEN.
 ;---> 76 18 = Visit IEN.
 ;
 ;
 ;---> Now, gather data from one V File Visit.
 ;     1 - BIDA    (req) IEN of V File Visit.
 ;     2 - BIDE    (req) Data Elements array (null if HL7)
 ;     3 - BIFMT   (req) Format: 0=ASCII Split, 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     4 - BIVTYPE (req) Visit Type: "I"=Immunization, "S"=Skin Test.
 ;     5 - BIDATA  (opt) Data returned in this param if desired.
 ;
 D HISTORY1^BIEXPRT3(BIDA,.BIDE,1,BIVTYPE,,.BIERR)
 I BIERR]"" S BIDATA=BI31_BIERR Q
 ;
 ;
 ;---> Set parameters for writing data as a string in BIDATA.
 ;---> Parameters:
 ;     1 - BIEXP    (req) Export: 0=screen, 1=host file, 2=string
 ;     2 - BIFMT    (req) Format: 1=ASCII, 2=HL7, 3=IMM/SERVE
 ;     3 - BIFLNM   (opt) File name
 ;     4 - BIPATH   (opt) BI Path name for host files
 ;     5 - BIDATA   (ret) Immunization History in "|"-delimited string
 ;                        NOTE: Since this is necessarily only one
 ;                              record, strip "^"-delimiter at end.
 ;
 D WRITE^BIEXPRT4(2,1,,,.BIDATA)
 ;
 ;---> Returned data string, with error delimiter concatenated.
 S BIDATA=$P(BIDATA,U)_BI31
 Q
