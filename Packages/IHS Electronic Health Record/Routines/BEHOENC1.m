BEHOENC1 ;MSC/IND/DKM - Visit Creation Support ;02-Sep-2011 08:57;PLS
 ;;1.1;BEH COMPONENTS;**005004;Sep 18, 2007
 ;=================================================================
 ; Visit creation API
GETVISIT(IN,OUT) ;
 ;
 ; >> All date/time variables must be in FileMan internal format
 ;
 ; Special Incoming Variables:
 ;  IN("FORCE ADD")   = 1    ; no matter what, create new visit (Optional)
 ;  IN ("NEVER ADD")  = 1    ; never add visit, just try to find one or more (Optional)
 ;  IN("ANCILLARY")   = 1    ; for ancillary packages to create noon visit if no match found (Optional)
 ;
 ; Incoming Variables used in Matching: REQUIRED
 ;  IN("PAT")         = patient IEN (file 2 or 9000001)
 ;  IN("VISIT DATE")  = visit date & time (same as check-in date & time)
 ;  IN ("SITE")       = location of encounter IEN (file 4 or 9999999.06)
 ;  IN("VISIT TYPE")  = internal value for field .03 in Visit file
 ;  IN("SRV CAT")     = internal value for service category
 ;  IN("TIME RANGE")  = #   ; range in minutes for matching on visit time; REQUIRED unless FORCE ADD set
 ;                             ;   zero=exact matches only; -1=don't match on time
 ;
 ;   These are used to match if sent (Optional)
 ;  IN("PROVIDER")    = IEN for provider to match from file 200
 ;  IN("CLINIC CODE") = IEN of clinic stop code (file 40.7)
 ;  IN("HOS LOC")     = IEN of hospital location (file 44)
 ;
 ; Incoming Variables used in creating appt and visit
 ;  IN("USR")         = user IEN in file 200; REQUIRED
 ;
 ; Incoming PCC variables for adding additional info to visit (Optional)
 ;  IN("APCDOLOC") = Outside Location (#2101)
 ;
 ; Outgoing Array:
 ;  OUT(0) always set
 ;    if = 0 none found and may have error message in 2nd piece
 ;    if = 1 and OUT(visit ien)="ADD" new visit just created
 ;    if = 1 and OUT(visit ien)=#; # is time difference in minutes
 ;    if >1, multiple OUT(visit ien) entries exist
 ;
 N TMP
 K OUT
 M TMP=IN    ;don't mess with incoming array
 Q:'$$HAVEREQ(.TMP,.OUT)    ;check required fields
 ; if forced add, skip visit match attempt
 I $G(TMP("FORCE ADD")) D ADDVIST(.TMP,.OUT) Q
 ; attempt to find matching visits; return OUT array
 D MATCH(.TMP,.OUT)
 ; if appt date set, go to check-in
 I $G(TMP("APPT DATE")),'$G(TMP("NEVER ADD")) D ADDVIST(.TMP,.OUT) Q
 ; if only 1 visit found, return ien and quit
 ; if >1 visits found, return full array and quit
 Q:OUT(0)
 ; if called by ancillary package, just create noon visit and quit
 I $G(TMP("ANCILLARY")) D  Q
 .K TMP("ANCILLARY"),TMP("PROVIDER")             ; set up to find other ancillaries
 .D MATCH(.TMP,.OUT)
 .Q:OUT(0)=1                                     ; try to match on hos loc or clinic
 .Q:$G(TMP("NEVER ADD"))=1                       ; if in never add mode, quit after 2nd match
 .S TMP("VISIT DATE")=TMP("VISIT DATE")\1        ; take off time; PCC will add noon
 .D ADDVIST(.TMP,.OUT)                           ; create noon visit; no PIMS link
 ; if no visits found but in never add mode, just quit
 Q:$G(TMP("NEVER ADD"))=1
 ; otherwise, logic falls through to create visit choices
 D ADDVIST(.TMP,.OUT)
 Q
 ; Check required fields
HAVEREQ(IN,OUT) ;
 I ('$G(IN("FORCE ADD"))),('$D(IN("TIME RANGE"))) S OUT(0)="0^Missing Time Range" Q 0
 I '$D(IN("PAT")) S OUT(0)="0^Missing Patient IEN" Q 0
 I '$D(IN("VISIT DATE")) S OUT(0)="0^Missing Visit Date" Q 0
 I IN("VISIT DATE")\1>DT S OUT(0)="0^Future Dates Not Allowed" Q 0
 I '$D(IN("SITE")) S OUT(0)="0^Missing Facility/Site" Q 0
 I '$D(IN("VISIT TYPE")) S OUT(0)="0^Missing Visit Type" Q 0
 I '$D(IN("SRV CAT")) S OUT(0)="0^Missing Service Category" Q 0
 I '$D(IN("USR")) S OUT(0)="0^Missing User IEN" Q 0
 I $G(IN("HOS LOC")),'$G(IN("CLINIC CODE")) S IN("CLINIC CODE")=$$GET1^DIQ(44,IN("HOS LOC"),8,"I")
 Q 1
 ; Set DATE and END based on TIME RANGE setting in minutes
TIME(RANGE,VISIT,DATE,END) ;
 N TMDIF,SW
 S TMDIF=$S(RANGE<1:0,1:RANGE)
 S DATE=$$FMADD^XLFDT(VISIT,,,-TMDIF)
 S END=$$FMADD^XLFDT(VISIT,,,TMDIF)
 I (DATE\1)<(END\1) S SW=(END\1),END=(DATE\1)_".9999",DATE=SW
 S DATE=(9999999-(DATE\1)_"."_$P(DATE,".",2))-.0001
 S END=9999999-(END\1)_"."_$P(END,".",2)
 I RANGE=-1 S END=END\1_".9999",DATE=DATE\1     ;no time range used; go from begin one day to end
 Q
 ; Find matching visits based on IN array
 ; OUT(0)=# of visits found^optional error message
MATCH(IN,OUT) ;
 N END,DATE,VIEN,STOP,DIFF
 S OUT(0)=0
 D TIME(IN("TIME RANGE"),IN("VISIT DATE"),.DATE,.END)
 F  S DATE=$O(^AUPNVSIT("AA",IN("PAT"),DATE)) Q:'DATE  Q:(DATE>END)  D
 .S VIEN=0
 .F  S VIEN=$O(^AUPNVSIT("AA",IN("PAT"),DATE,VIEN)) Q:'VIEN  D
 ..I $P($G(^AUPNVSIT(VIEN,0)),U,11) Q                        ;check for delete flag just in case xref not killed
 ..I IN("SITE")'=$$GET1^DIQ(9000010,VIEN,.06,"I") Q          ;no match on loc of enc
 ..I IN("VISIT TYPE")'=$$GET1^DIQ(9000010,VIEN,.03,"I") Q    ;no match on vist type
 ..I IN("SRV CAT")'=$$GET1^DIQ(9000010,VIEN,.07,"I") Q       ;no match on service category
 ..I IN("TIME RANGE")>-1 S STOP=0 D  Q:STOP                  ;check time range
 ...S DIFF=$$TIMEDIF(IN("VISIT DATE"),VIEN)                 ;find difference in minutes
 ...S:$$ABS^XLFMTH(DIFF)>IN("TIME RANGE") STOP=1
 ..Q:'$$PRVMTCH    ; if provider sent and didn't match, skip
 ..;
 ..; if called by ancillary, falls through and sets visit into array
 ..; otherwise, check if app wants to match on clinic code or hosp location
 ..I '$G(IN("ANCILLARY")) S STOP=0 D  Q:STOP
 ...I $G(IN("HOS LOC")),'$G(IN("CLINIC CODE")) S IN("CLINIC CODE")=$$GET1^DIQ(44,IN("HOS LOC"),8,"I")
 ...I $G(IN("CLINIC CODE")),IN("CLINIC CODE")'=$$GET1^DIQ(9000010,VIEN,.08,"I") S STOP=1 Q  ;no match on clinic code
 ...I $G(IN("HOS LOC")),(IN("HOS LOC")'=$$GET1^DIQ(9000010,VIEN,.22,"I")) S STOP=1 Q  ;no match on hospital location
 ..S OUT(0)=OUT(0)+1
 ..S OUT(VIEN)=$$TIMEDIF(IN("VISIT DATE"),VIEN)
 Q
 ; Do visits match on provider?
PRVMTCH() ;
 N PRVS,IEN
 I '$G(IN("PROVIDER")) Q 1     ; if no provider sent, assume okay
 ; find all v provider entries for visit
 S IEN=0
 F  S IEN=$O(^AUPNVPRV("AD",VIEN,IEN)) Q:'IEN  D
 .S PRVS(+$G(^AUPNVPRV(IEN,0)))=""
 Q ''$D(PRVS(IN("PROVIDER")))
 ;
TIMEDIF(VDTTM,VIEN) ; return time difference between incoming time and current visit
 Q $$FMDIFF^XLFDT(VDTTM,+$G(^AUPNVSIT(VIEN,0)),2)\60
 ; Create visit
ADDVIST(IN,OUT) ;
 N VSIT,VSITPKG,DFN
 S VSIT("VDT")=IN("VISIT DATE")
 S VSIT("TYP")=IN("VISIT TYPE")
 S VSIT("PAT")=IN("PAT")
 S VSIT("INS")=IN("SITE")
 S VSIT("SVC")=IN("SRV CAT")
 S VSIT("DSS")=$G(IN("CLINIC CODE"))
 S VSIT("LOC")=$G(IN("HOS LOC"))
 S VSIT("USR")=IN("USR")
 S VSIT("OPT")=$G(XQY)
 S VSIT("VID")=$$GETVID^VSITVID
 S:$D(IN("APCDOLOC")) VSIT("OUT")=IN("APCDOLOC")
 S VSIT(0)="F"
 S VSITPKG="CIAV"
 S DFN=IN("PAT")
 D ^VSIT
 I $G(VSIT("IEN"))'>0 S OUT(0)="0^Could not create visit."
 E  S OUT(+VSIT("IEN"))="ADD",OUT(0)=1
 Q
