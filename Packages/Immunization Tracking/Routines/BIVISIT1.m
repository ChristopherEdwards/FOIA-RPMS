BIVISIT1 ;IHS/CMI/MWR - CREATE/EDIT VISITS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO CREATE OR EDIT VISITS FOR IMMUNIZATIONS AND SKIN TESTS.
 ;;  PATCH 1: Allow for negative values of Y (time difference).  CREATE+91
 ;;           Correct "Other" Location not getting set during edits.  VISIT+14
 ;
 ;
 ;----------
VISIT(BIDFN,BIDATE,BICAT,BILOC,BIOLOC,BISITE,BIVSIT,BIERR) ;EP
 ;---> Create or edit a Visit for this patient's Immunization or
 ;---> Skin Test.  Called by BIVISIT.
 ;---> Parameters:
 ;     1 - BIDFN   (req) DFN of patient.
 ;     2 - BIDATE  (req) Date.Time of Visit.
 ;     3 - BILOC   (req) Location of encounter IEN.
 ;     4 - BIOLOC  (opt) Other Location of encounter.
 ;     5 - BICAT   (req) Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;     6 - BISITE  (req) DUZ(2) for Site Parameters.
 ;     7 - BIVSIT  (ret) IEN of Visit (may exist already or be new).
 ;     8 - BIERR   (ret) Text of Error Code if any, otherwise null.
 ;
 ;
 ;---> First, determine Location.
 ;---> If BILOC<1 or if Outside Location is not null set BILOC equal
 ;---> to "OTHER" entry in Location File by checking BI SITE Parameter.
 S:('$G(BILOC)!($G(BIOLOC)]"")) BILOC=$$OTHERLOC^BIUTL6(DUZ(2))
 ;
 ;---> Quit if "OTHER" Location has not been selected in Site Parameters.
 I 'BILOC S BIERR="1^"_$$OTHERLOC^BIUTL6(DUZ(2),1) Q
 ;
 ;---> Create Visit if necessary.
 ;
 ;---> If no Parent Visit EIN, create a new Visit.
 I '$G(BIVSIT) D CREATE(.BIVSIT,.BIERR) Q
 ;
 ;---> If Parent Visit doesn't really exist, create a new Visit.
 I '$G(^AUPNVSIT(+BIVSIT,0)) D CREATE(.BIVSIT,.BIERR) Q
 ;
 ;---> If edit of old VISIT changed Date.Time, create a new Visit.
 I $P(^AUPNVSIT(+BIVSIT,0),U)'=BIDATE D CREATE(.BIVSIT,.BIERR) Q
 ;
 ;---> If edit of old VISIT changed Category, create a new Visit.
 I $P(^AUPNVSIT(+BIVSIT,0),U,7)'=BICAT D CREATE(.BIVSIT,.BIERR) Q
 ;
 ;
 ;---> If Outside Location was deleted, set it ="@".
 S:$G(BIOLOC)="" BIOLOC="@"
 ;
 ;---> If edit of old VISIT changed Location, edit Visit.
 I $P(^AUPNVSIT(+BIVSIT,0),U,6)'=BILOC D  Q
 .N BIFLD S BIFLD(.06)=BILOC,BIFLD(2101)=BIOLOC
 .D FDIE^BIFMAN(9000010,BIVSIT,.BIFLD,.BIERR)
 .I $G(BIERR) D ERRCD^BIUTL2(433,.BIERR) S BIERR="1^"_BIERR
 ;
 ;---> If edit of old VISIT changed Outside Location, edit Visit.
 ;---> In old code, edit from default location to outside location failed. vvv83
 I $P($G(^AUPNVSIT(+BIVSIT,21)),U)'=BIOLOC D  Q
 .N BIFLD S BIFLD(.06)=BILOC,BIFLD(2101)=BIOLOC
 .D FDIE^BIFMAN(9000010,BIVSIT,.BIFLD,.BIERR)
 .I $G(BIERR) D ERRCD^BIUTL2(434,.BIERR) S BIERR="1^"_BIERR
 ;
 Q
 ;
 ;
 ;----------
CREATE(BIVSIT,BIERR) ;EP
 ;---> Create a new Visit OR match on an existing Visit in VISIT File.
 ;---> Parameters:
 ;     1 - BIVSIT (ret) IEN of newly created Parent Visit.
 ;     2 - BIERR  (ret) 1^Text of Error Code if any, otherwise null.
 ;
 ;---> Set permission override for this file.
 S DLAYGO=9000010
 ;
 ;---> Patient.
 S APCDALVR("APCDPAT")=BIDFN
 ;
 ;---> PCC Date/Time; If no time, 12 noon will be attached.
 S APCDALVR("APCDDATE")=BIDATE
 ;
 ;---> If Visit Selection Menu is Disabled, create/link automatically:
 ;---> Linking/Adding PCC Visits:
 ;--->    1) If no Visit exists on this date, create one silently.
 ;--->    2) If a Visit exists with exact time match, append to it.
 ;--->    3) If a Visit exists for this date but a different time,
 ;--->          add a new Visit.
 ;
 ;---> If site param says do NOT display Visit Selection Menu, then
 ;---> link or create automatically.
 D
 .I '$$VISMNU^BIUTL2(BISITE) S APCDALVR("APCDAUTO")="" Q
 .K APCDALVR("APCDAUTO")
 ;
 ;---> No interaction, no Fileman echoing.  Archaic?
 S APCDALVR("AUPNTALK")="",APCDALVR("APCDANE")=""
 ;
 S APCDALVR("APCDLOC")=BILOC
 ;
 ;---> Other Location (Text if Location="OTHER").
 S APCDALVR("APCDOLOC")=$G(BIOLOC)
 ;
 ;---> Set Type of Visit from PCC MASTER CONTROL File. (I,C,T,6,V)
 N BITYPE D
 .D:'$G(BISITE) SETVARS^BIUTL5 S BISITE=DUZ(2)
 .I $G(^APCCCTRL(BISITE,0))="" S BITYPE="I" Q
 .S BITYPE=$P(^APCCCTRL(BISITE,0),U,4)
 .S:BITYPE="" BITYPE="I"
 S APCDALVR("APCDTYPE")=BITYPE
 ;
 ;---> Category.  A=Ambulatory, I=Inpatient, E=Event/Historical.
 ;---> If User said this was an Ambulatory Visit, and if the Inpatient Visit
 ;---> Check Site Parameter is enabled, check to see if patient was an
 ;---> Inpatient on BIDATE; if so, change Category to "I",Inpatient.
 ;
 I BICAT="A",$$INPTCHK^BIUTL2(BISITE),$$INPT^BIUTL11(BIDFN,BIDATE) S BICAT="I"
 S APCDALVR("APCDCAT")=BICAT
 ;
 ;---> Call to add (create) Visit.
 ;---> NOTE: $G(BICAT)="E" (Historical) will override Active/Inactive
 ;---> selection screen on .01 Field of Immunization File #9999999.14.
 ;
 ;---> If PIMS is loaded, call new API.
 ;---> *** Use this below to test version of BSDAPI4?:
 ;---> I $P($T(BSDAPI4+1^BSDAPI4),"**",2)>1002
 D
 .;---> Check for PIMS (following lines from bottom of APCDAPI4).
 .;I $L($T(^APCDAPI4)),$L($T(VISIT^BSDV)),$L($T(GETVISIT^BSDAPI4)) D NEWCALL Q
 .D OLDCALL
 ;
 Q:$G(BIERR)
 ;
 ;S BITEST=1
 D:$G(BITEST) DISPLAY1^BIPCC
 ;
 ;---> Quit if Visit was not created.
 I '$G(APCDALVR("APCDVSIT"))!($D(APCDALVR("APCDAFLG"))) D  Q
 .D ERRCD^BIUTL2(401,.BIERR) S BIERR="1^"_BIERR
 ;
 ;Returns:  APCDVSIT - Pointer to Visit just selected or created.
 ;          APCDVSIT("NEW") - If ^APCDALVR created a new Visit.
 ;          APCDAFLG - =2 If FAILED to select or create a Visit.
 ;
 ;---> Save IEN of Visit just created.
 S BIVSIT=APCDALVR("APCDVSIT")
 Q
 ;
 ;
 ;----------
OLDCALL ;EP
 ;---> Create a Visit in VISIT File using APCDALV.
 ;---> Parameters per above.
 ;---> No new PIMS, call Lori's older API.
 I '$D(APCDALVR("APCDAUTO")) D FULL^VALM1 W:$D(IOF) @IOF
 D EN^APCDALV
 Q
 ;
 ;
 ;----------
NEWCALL ;EP
 ;---> Create a Visit in VISIT File using new PIMS 5.3+.
 ;---> Parameters per above.
 ;---> No new PIMS, call Lori's older API.
 ;
 ;W !,"IN NEWCALL." R ZZZ
 N APCDIN,APCDOUT
 ;S APCDIN("ANCILLARY")=1
 S APCDIN("SHOW VISITS")=1
 S APCDIN("PAT")=APCDALVR("APCDPAT")
 S APCDIN("VISIT DATE")=APCDALVR("APCDDATE")
 S APCDIN("SITE")=APCDALVR("APCDLOC")
 S APCDIN("VISIT TYPE")=APCDALVR("APCDTYPE")
 S APCDIN("SRV CAT")=APCDALVR("APCDCAT")
 S APCDIN("TIME RANGE")=60
 S APCDIN("USR")=$S($G(DUZ):DUZ,1:1)
 S APCDIN("APCDLOC")=APCDALVR("APCDLOC")
 S:($G(APCDALVR("APCDOLOC"))]"") APCDIN("APCDOLOC")=APCDALVR("APCDOLOC")
 ;
 ;---> Go get or create a Visit.
 D
 .;---> If Visit Selection Menu is disabled, make an automated call.
 .;---> Link to a Visit within 30 minutes.
 .I '$$VISMNU^BIUTL2(BISITE) D GETVISIT^APCDAPI4(.APCDIN,.APCDOUT) Q
 .;
 .;---> Okay, Visit Selection Menu is enabled.
 .;---> Don't match on time.
 .S APCDIN("TIME RANGE")=-1
 .S APCDIN("NEVER ADD")=1
 .D GETVISIT^APCDAPI4(.APCDIN,.APCDOUT)
 .N BIPAT S BIPAT("PAT")=BIDFN
 .D FULL^VALM1 W:$D(IOF) @IOF
 .D SELECT^BSDAPI5(.BIPAT,.APCDOUT) ;THIS IS NOT A PEP (CANNOT CALL IT).
 .;
 ;
 ;X ^O
 ;
 ;---> Variable containing parent IEN does not exist, so error out.
 I '$D(APCDOUT(0)) D ERRCD^BIUTL2(435,.BIERR) S BIERR="1^"_BIERR Q
 ;
 ;---> No Visits matching and none created, so error out.
 I $P(APCDOUT(0),U)=0 S BIERR="1^"_$P(APCDOUT(0),U,2) Q
 ;
 ;---> One Visit (matched or created), so set Visit IEN.
 S:APCDOUT(0)=1 APCDALVR("APCDVSIT")=$O(APCDOUT(0))
 ;
 ;---> If more than one Visit matches within 60 minutes, choose
 ;---> the closest in time.
 D:APCDOUT(0)>1
 .;---> Creat array based on time difference.
 .N A,X,Y S X=0
 .F  S X=$O(APCDOUT(X)) Q:'X  D
 ..;
 ..;---> Allow for negative values of Y (in time difference).
 ..S Y=APCDOUT(X) I Y]"" S:Y<0 Y=-Y S A(Y)=X
 .;
 .;X ^O
 .;---> Now grab the IEN of the closest Visit in time.
 .S Y="",X=""
 .F  S Y=$O(A(Y)) Q:Y=""  Q:$G(APCDALVR("APCDVSIT"))  D
 ..I ((Y=0)!(Y>0)),A(Y)>0 S APCDALVR("APCDVSIT")=A(Y) Q
 ;
 ;---> Got a valid Visit IEN, so quit.
 Q:$G(APCDALVR("APCDVSIT"))
 ;
 ;---> None of the above cases match, so error out.
 D ERRCD^BIUTL2(438,.BIERR) S BIERR="1^"_BIERR
 ;
 Q
