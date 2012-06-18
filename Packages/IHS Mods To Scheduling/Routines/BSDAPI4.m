BSDAPI4 ; IHS/ITSC/LJF & HMW - PCC API FOR RPMS [ 03/24/2005  1:44 PM ]
 ;;5.3;PIMS;**1002,1003,1004,1005,1009,1010**;MAY 28, 2004
 ;IHS/ITSC/LJF PATCH 1002 routine created
 ;             PATCH 1003 check-in logic improved
 ;IHS/OIT/LJF 09/15/2005 PATCH 1004 added APCDOPT to help text
 ;            10/05/2005 PATCH 1004 kill APCDALVR variable after visit created
 ;            10/06/2005 PATCH 1004 made changes for ancillary visits
 ;            12/21/2005 PATCH 1005 added APCDOLOC to optional variables
 ;            03/03/2006 PATCH 1005 fixed hole in triage logic
 ;cmi/anch/maw05/14/2008 PATCH 1009 change logic for triage so it creates 2 visits
 ;cmi/anch/maw06/01/2008 PATCH 1009 requirement 58 added logic for matching on ordering location and returning that visit
 ;cmi/anch/maw06/10/2008 PATCH 1009 requirement 58 added logic to display visits for user to select if more than one
 ;cmi/anch/maw09/02/2009 PATCH 1010 added optional set of Option Used to Create
 ;
GETVISIT(BSDIN,BSDOUT) ;Private Entry Point with PCC - API for PCC visit Creation by RPMS applications
 ; >> All date/time variables must be in FileMan internal format
 ; Special Incoming Variables:
 ;  BSDIN("FORCE ADD")   = 1    ; no matter what, create new visit (Optional)
 ;  BSDIN ("NEVER ADD")  = 1    ; never add visit, just try to find one or more (Optional)
 ;  BSDIN("ANCILLARY")   = 1    ; for ancillary packages to create noon visit if no match found (Optional)
 ;  BSDIN("SHOW VISITS") = 1    ; this will display visits if more than one match
 ; Incoming Variables used in Matching: REQUIRED
 ;  BSDIN("PAT")         = patient IEN (file 2 or 9000001)
 ;  BSDIN("VISIT DATE")  = visit date & time (same as check-in date & time)
 ;  BSDIN ("SITE")       = location of encounter IEN (file 4 or 9999999.06)
 ;  BSDIN("VISIT TYPE")  = internal value for field .03 in Visit file
 ;  BSDIN("SRV CAT")     = internal value for service category
 ;  BSDIN("TIME RANGE")  = #   ; range in minutes for matching on visit time; REQUIRED unless FORCE ADD set
 ;                             ;   zero=exact matches only; -1=don't match on time
 ;   These are used to match if sent (Optional)
 ;  BSDIN("PROVIDER")    = IEN for provider to match from file 200
 ;  BSDIN("CLINIC CODE") = IEN of clinic stop code (file 40.7)
 ;  BSDIN("HOS LOC")     = IEN of hospital location (file 44, field .22 in VISIT file)
 ;  BSDIN("DEF CC")      = IEN of default clinic code for package making call PATCH 1009
 ;  BSDIN("DEF HL")      = IEN of default hospital location for package making call PATCH 1009
 ; Incoming Variables used in creating appt and visit
 ;  BSDIN("APPT DATE")   = appt date & time (Required for scheduled appts and walk-ins; check-in will be performed) 
 ;  BSDIN("USR")         = user IEN in file 200; REQUIRED
 ;  BSDIN("OPT")         = name for Option Used To Create field, for check-in only (Optional)
 ;  BSDIN("OI")          = reason for appointment; for walk-ins (Optional)
 ; Incoming PCC variables for adding additional info to visit (Optional)
 ;  BSDIN("APCDTPB")  = Third Party Billed (#.04)
 ;  BSDIN("APCDPVL")  = Parent Visit Link (#.12)
 ;  BSDIN("APCDAPPT") = WalkIn/Appt (#.16)
 ;  BSDIN("APCDEVM")  = Evaluation and Management Code (#.17)
 ;  BSDIN("APCDCODT") = Check Out Date & Time (#.18)
 ;  BSDIN("APCDLS")   = Level of Service -PCC Form  (#.19).
 ;  BSDIN("APCDVELG") = Eligibility (#.21)
 ;  BSDIN("APCDPROT") = Protocol (#.25).
 ;  BSDIN("APCDOPT")  = Option Used To Create (#.24)  ;IHS/OIT/LJF 09/15/2005 PATCH 1004
 ;  BSDIN("APCDOLOC") = Outside Location (#2101)      ;IHS/OIT/LJF 12/21/2005 PATCH 1005
 ; Outgoing Array:
 ;  BSDOUT(0) always set; if = 0 none found and may have error message in 2nd piece
 ;                        if = 1 and BSDOUT(visit ien)="ADD" new visit just created
 ;                        if = 1 and BSDOUT(visit ien)=#; # is time difference in minutes
 ;                        if >1, multiple BSDOUT(visit ien) entries exist
 NEW BSDTMP K BSDOUT
 M BSDTMP=BSDIN    ;don't mess with incoming array
 IF '$$HAVEREQ(.BSDTMP,.BSDOUT) Q    ;check required fields
 ;IHS/ITSC/LJF 4/28/2005 PATCH 1003 if FORCE ADD set, bypass check-in & create visit
 ; if forced add, skip visit match attempt
 ;IF $G(BSDTMP("FORCE ADD")) D APPTDT Q
 ;cmi/flag/maw 9/2/2009 PATCH 1010
 I '$G(BSDTMP("APCDOPT")) D
 .I $G(BSDTMP("OPT"))]"",BSDTMP("OPT")?.N,$D(^DIC(19,BSDTMP("OPT"))) S BSDTMP("APCDOPT")=BSDTMP("OPT") Q
 .I $G(BSDTMP("OPT"))]"",$E(BSDTMP("OPT"),1,1)="`" S BSDTMP("APCDOPT")=$TR(BSDTMP("OPT"),"`") Q
 .I $G(BSDTMP("OPT"))]"",BSDTMP("OPT")'?.N S BSDTMP("APCDOPT")=$O(^DIC(19,"B",BSDTMP("OPT"),0)) Q
 .I $G(BSDTMP("APCDOPT"))]"",$E(BSDTMP("APCDOPT"),1,1)="`" S BSDTMP("APCDOPT")=$TR(BSDTMP("APCDOPT"),"`") Q
 .I $G(BSDTMP("APCDOPT"))]"",BSDTMP("APCDOPT")'?.N S BSDTMP("APCDOPT")=$O(^DIC(19,"B",BSDTMP("APCDOPT"),0)) Q
 IF $G(BSDTMP("FORCE ADD")) D ADDVIST(.BSDTMP,.BSDOUT) Q
 ; attempt to find matching visits; return BSDOUT array
 D MATCH(.BSDTMP,.BSDOUT)
 ;IHS/ITSC/LJF 4/22/2005 PATCH 1003 if appt date set, go to check-in
 ;IF $G(BSDTMP("APPT DATE")),'$G(BSDTMP("NEVER ADD")) D APPTDT Q
 ;if only 1 visit found, return ien and quit
 IF BSDOUT(0)=1 Q
 ;if >1 visits found, return full array and quit, unless they pass it the variable to show visits then we will display
 ;(calling app decides next step)
 IF BSDOUT(0)>1 Q
 ;IHS/OIT/LJF 10/06/2005 PATCH 1004 added 2nd match, move never add checks & not kill variables
 ;if called by ancillary package, just create noon visit and quit
 IF $G(BSDTMP("ANCILLARY")) D  Q
 . K BSDTMP("ANCILLARY"),BSDTMP("PROVIDER")            ; set up to find other ancillaries
 . D MATCH(.BSDTMP,.BSDOUT) I BSDOUT(0)=1 Q            ; try to match on hos loc or clinic
 . I $G(BSDTMP("NEVER ADD"))=1 Q                       ; if in never add mode, quit after 2nd match
 . S BSDTMP("VISIT DATE")=BSDTMP("VISIT DATE")\1       ; take off time; PCC will add noon
 . D ADDVIST(.BSDTMP,.BSDOUT)                          ; create noon visit; no PIMS link
 ;if no visits found but in never add mode, just quit
 IF $G(BSDTMP("NEVER ADD"))=1 Q
 ;IHS/OIT/LJF 10/06/2005 PATCH 1004  end of changes for this section
 ;otherwise, logic falls through to create visit choices
APPTDT ;
 I $G(BSDTMP("CALLER"))]"",$G(BSDTMP("CALLER"))="BSD CHECKIN" Q  ;cmi/maw 6/10/2008 PATCH 1009 for interactive visit creation
 ;if no appointment date/time sent, just create visit and quit
 IF '$G(BSDTMP("APPT DATE")) D ADDVIST(.BSDTMP,.BSDOUT) Q
 ;IHS/ITSC/LJF 4/22/2005 PATCH 1003 if one matching visit found, check-in but don't create visit
 I BSDOUT(0)=1 S BSDTMP("VIEN")=$O(BSDOUT(0))
 ;if patient already has appt at this time, call Check-in (which creates visit) then quit
 NEW IEN,ERR,V
 S IEN=$$SCIEN^BSDU2(BSDTMP("PAT"),BSDTMP("HOS LOC"),BSDTMP("APPT DATE"))  ;find appt
 I IEN D  Q
 . ; set variables used by checkin call
 . S BSDTMP("CDT")=BSDTMP("VISIT DATE")
 . S BSDTMP("CC")=$G(BSDTMP("CLINIC CODE"))
 . S BSDTMP("PRV")=$G(BSDTMP("PROVIDER"))
 . ;IHS/ITSC/LJF 5/4/2005 PATCH 1003 set more variables to use in BSDAPI
 . S BSDTMP("CLN")=$G(BSDTMP("HOS LOC"))
 . S BSDTMP("ADT")=$G(BSDTMP("APPT DATE"))
 . S ERR=$$CHECKIN^BSDAPI(.BSDTMP)      ;check in and create visit
 . ;IHS/ITSC/LJF 5/5/2005 PATCH 1003 reset BSDOUT only if truly added one.
 . ;I 'ERR S V=$$GETVST^BSDU2(BSDTMP("PAT"),BSDTMP("APPT DATE")) I V S BSDOUT(0)=1,BSDOUT(V)="ADD" Q
 . I 'ERR S V=$$GETVST^BSDU2(BSDTMP("PAT"),BSDTMP("APPT DATE")) I V,'$G(BSDTMP("VIEN")) S:BSDOUT(0)=0 BSDOUT(0)=1 S BSDOUT(V)="ADD" Q
 . I ERR S BSDOUT(0)=0_U_$P(ERR,U,2)
 ; else call walk-in (which calls make appt, checkin and create visit)
 D WALKIN(.BSDTMP,.BSDOUT)
 Q
MATCH(IN,OUT) ; find matching visits based on IN array
 S OUT(0)=0
 NEW END,DATE,VIEN,STOP,DIFF,MATCH
 S MATCH=0
 D TIME(IN("TIME RANGE"),IN("VISIT DATE"),.DATE,.END)
 F  S DATE=$O(^AUPNVSIT("AA",IN("PAT"),DATE)) Q:'DATE  Q:(DATE>END)  D
 . S VIEN=0
 . F  S VIEN=$O(^AUPNVSIT("AA",IN("PAT"),DATE,VIEN)) Q:'VIEN  D
 . . I $$GET1^DIQ(9000010,VIEN,.11)="DELETED" Q                ;check for delete flag just in case xref not killed
 . . I IN("SITE")'=$$GET1^DIQ(9000010,VIEN,.06,"I") Q          ;no match on loc of enc
 . . I IN("VISIT TYPE")'=$$GET1^DIQ(9000010,VIEN,.03,"I") Q    ;no match on vist type
 . . ;cmi/maw 06/01/2008 PATCH 1009 get observation and day surgery visits
 . . ;I IN("SRV CAT")'=$$GET1^DIQ(9000010,VIEN,.07,"I") Q       ;no match on service category
 . . I IN("SRV CAT")["CENRT" Q  ;don't look at HIM excluded visits
 . . I $$GET1^DIQ(90000010,VIEN,.07,"I")["CENRT" Q  ;don't look at HIM excluded visits
 . . I IN("SRV CAT")=$$GET1^DIQ(9000010,VIEN,.07,"I") S MATCH=1       ;no match on service category
 . . I IN("SRV CAT")="A",$G(IN("ANCILLARY")),$$GET1^DIQ(9000010,VIEN,.07,"I")="O" S MATCH=1  ;match if observation
 . . I IN("SRV CAT")="A",$G(IN("ANCILLARY")),$$GET1^DIQ(9000010,VIEN,.07,"I")="D" S MATCH=1
 . . I '$G(MATCH) Q
 . . ;cmi/maw 06/01/2008 PATCH 1009 end of mods
 . . I IN("TIME RANGE")>-1 S STOP=0 D  Q:STOP                  ;check time range
 . . . S DIFF=$$TIMEDIF(IN("VISIT DATE"),VIEN)                 ;find difference in minutes
 . . . I $$ABS^XLFMTH(DIFF)>IN("TIME RANGE") S STOP=1
 . . I '$$PRVMTCH Q   ; if provider sent and didn't match, skip
 . . ; if called by ancillary, falls through and sets visit into array
 . . ; otherwise, check if app wants to match on clinic code or hosp location
 . . I '$G(IN("ANCILLARY")) S STOP=0 D  Q:STOP
 . . . I $G(IN("HOS LOC")),'$G(IN("CLINIC CODE")) S IN("CLINIC CODE")=$$GET1^DIQ(44,IN("HOS LOC"),8,"I")
 . . . I $G(IN("CLINIC CODE")),IN("CLINIC CODE")'=$$GET1^DIQ(9000010,VIEN,.08,"I") S STOP=1 Q  ;no match on clinic code
 . . . ;IHS/ITSC/LJF 4/22/2005 PATCH 1003 if both have appt date and visit was triage clinic, is a match
 . . . ;cmi/anch/maw 5/14/2008 PATCH 1009 requirement 59 create visit on same day no matter what
 . . . ;I $G(IN("APPT DATE")),$$GET1^DIQ(9000010,VIEN,.26,"I"),$$TRIAGE(VIEN) Q  ;cmi/maw 5/14/2008 comment out PATCH 1009 requirement 59
 . . . I $G(IN("HOS LOC")),(IN("HOS LOC")'=$$GET1^DIQ(9000010,VIEN,.22,"I")) S STOP=1 Q  ;no match on hospital location
 . . . ;IHS/OIT/LJF 02/03/2006 PATCH 1005 if same clinic & same provider but not triage, make new visit
 . . . I $G(IN("APPT DATE")),$$GET1^DIQ(9000010,VIEN,.26,"I"),'$$TRIAGE(VIEN) S STOP=1 Q
 . . ; must be good match, increment counter and set array node
 . . S OUT(0)=OUT(0)+1
 . . S OUT(VIEN)=$$TIMEDIF(IN("VISIT DATE"),VIEN)
 Q
 ;
PRVMTCH() ; do visits match on provider?
 NEW PRVS,IEN
 I '$G(IN("PROVIDER")) Q 1     ; if no provider sent, assume okay
 ;IHS/ITSC/LJF 5/4/2005 PATCH 1003
 ;if visit is triage clinic & new encounter is not ancillary, skip provider match
 I $$TRIAGE(VIEN),'$G(IN("ANCILLARY")) Q 1
 ; find all v provider entries for visit
 S IEN=0 F  S IEN=$O(^AUPNVPRV("AD",VIEN,IEN)) Q:'IEN  D
 . S PRVS(+$G(^AUPNVPRV(IEN,0)))=""
 ;if incoming provider in list, this is match
 I $D(PRVS(IN("PROVIDER"))) Q 1
 ;otherwise, no match
 Q 0
 ;
TIMEDIF(VDTTM,VIEN) ; return time diff between incoming time and current visit
 Q $$FMDIFF^XLFDT(VDTTM,+$G(^AUPNVSIT(VIEN,0)),2)\60
 ;
ADDVIST(BSDTMP,BSDOUT)  ;
 K APCDALVR NEW %DT,SUB
 S SUB="APCD" F  S SUB=$O(BSDTMP(SUB)) Q:SUB]"APCDZZZZ"  S APCDALVR(SUB)=BSDTMP(SUB)
 S APCDALVR("AUPNTALK")="",APCDALVR("APCDANE")=""        ;keep it silent
 S APCDALVR("APCDLOC")=BSDTMP("SITE")                     ;facility
 S APCDALVR("APCDPAT")=BSDTMP("PAT")                      ;patient
 S APCDALVR("APCDTYPE")=BSDTMP("VISIT TYPE")              ;visit type
 S APCDALVR("APCDCAT")=BSDTMP("SRV CAT")                  ;srv cat
 S APCDALVR("APCDDATE")=BSDTMP("VISIT DATE")              ;chkin dt
 I $G(BSDTMP("CLINIC CODE")) S APCDALVR("APCDCLN")="`"_BSDTMP("CLINIC CODE")      ;clinic code ien w/`
 S APCDALVR("APCDHL")=$G(BSDTMP("HOS LOC"))               ;clinic name
 S APCDALVR("APCDAPDT")=$G(BSDTMP("APPT DATE"))           ;appt date
 ;I '$G(APCDALVR("APCDOPT")) S APCDALVR("APCDOPT")=$G(BSDTMP("OPT"))                  ;option name PATCH 1010
 S APCDALVR("APCDADD")=1                                  ;force add
 ;create visit
 D ^APCDALV
 ;if no visit created,error quit
 I '$G(APCDALVR("APCDVSIT")) D  Q
 . S BSDOUT(0)="0^Error Creating Visit"
 ; set new visit info in out array
 S BSDOUT(APCDALVR("APCDVSIT"))="ADD",BSDOUT(0)=1
 K APCDALVR    ;IHS/OIT/LJF 10/05/2005 PATCH 1004
 Q
 ;
WALKIN(BSDATA,OUT) ;EP; create walkin appt which is checked in and visit created
 ; also called by BSDAPI3 to create ancillary walkin appt
 NEW ERR,V
 S OUT(0)=0    ;initialize outgoing count
 S BSDATA("CLN")=$G(BSDATA("HOS LOC"))
 S BSDATA("TYP")=4   ;4=walkin
 S BSDATA("ADT")=$G(BSDATA("APPT DATE"))
 I '$D(BSDATA("LEN")) S BSDATA("LEN")=$$GET1^DIQ(44,BSDATA("CLN"),1912)
 ; make walkin appt
 S ERR=$$MAKE^BSDAPI(.BSDATA) I ERR S $P(OUT(0),U,2)=$P(ERR,U,2) Q
 ; set variables used by checkin call
 S BSDATA("CDT")=BSDATA("VISIT DATE")
 S BSDATA("CC")=$G(BSDATA("CLINIC CODE"))
 S BSDATA("PRV")=$G(BSDATA("PROVIDER"))
 ; check in appt and create visit
 S ERR=$$CHECKIN^BSDAPI(.BSDATA)
 ; update out array based on result
 ;IHS/ITSC/LJF 5/5/2005 PATCH 1003 reset BSDOUT(0) only if added new visit
 ;I 'ERR S V=$$GETVST^BSDU2(BSDATA("PAT"),BSDATA("APPT DATE")) I V S OUT(0)=1,OUT(V)="ADD"   ;visit added
 I 'ERR S V=$$GETVST^BSDU2(BSDATA("PAT"),BSDATA("APPT DATE")) I V,'$G(BSDTMP("VIEN")) S:OUT(0)=0 OUT(0)=1 S OUT(V)="ADD"   ;visit added
 I ERR S $P(OUT(0),U,2)=$P(ERR,U,2)          ;error
 Q
 ;
HAVEREQ(IN,OUT) ; check required fields
 I ('$G(IN("FORCE ADD"))),('$D(IN("TIME RANGE"))) S OUT(0)="0^Missing Time Range" Q 0
 I '$D(IN("PAT")) S OUT(0)="0^Missing Patient IEN" Q 0
 I '$D(IN("VISIT DATE")) S OUT(0)="0^Missing Visit Date" Q 0
 I '$D(IN("SITE")) S OUT(0)="0^Missing Facility/Site" Q 0
 I '$D(IN("VISIT TYPE")) S OUT(0)="0^Missing Visit Type" Q 0
 I '$D(IN("SRV CAT")) S OUT(0)="0^Missing Service Category" Q 0
 I '$D(IN("USR")) S OUT(0)="0^Missing User IEN" Q 0
 ;IHS/ITSC/LJF 5/5/2005 PATCH 1003 moved line to set clinic code earlier
 I $G(IN("HOS LOC")),'$G(IN("CLINIC CODE")) S IN("CLINIC CODE")=$$GET1^DIQ(44,IN("HOS LOC"),8,"I")
 ;IHS/ITSC/LJF 5/5/2005 PATCH 1003 convert service category
 I $G(IN("APPT DATE")),$G(IN("HOS LOC")) S IN("SRV CAT")=$$SERCAT^BSDV(IN("HOS LOC"),IN("PAT"))
 Q 1
 ;
TIME(RANGE,VISIT,DATE,END) ; set DATE and END based on TIME RANGE setting in minutes
 NEW TMDIF,SW
 S TMDIF=$S(RANGE<1:0,1:RANGE)
 S DATE=$$FMADD^XLFDT(VISIT,,,-TMDIF)
 S END=$$FMADD^XLFDT(VISIT,,,TMDIF)
 I (DATE\1)<(END\1) S SW=(END\1),END=(DATE\1)_".9999",DATE=SW
 S DATE=(9999999-(DATE\1)_"."_$P(DATE,".",2))-.0001
 S END=9999999-(END\1)_"."_$P(END,".",2)
 I RANGE=-1 S END=(END\1)_".9999",DATE=(DATE\1)     ;no time range used; go from begin one day to end
 Q
 ;
TRIAGE(VST) ; returns 1 if visit's hosp loc is triage type ;IHS/ITSC/LJF 4/22/2005 PATCH 1003
 NEW HL
 S HL=$$GET1^DIQ(9000010,VST,.22,"I") I 'HL Q 0
 Q +$$GET1^DIQ(9009017.2,HL,.16,"I")
 ;
