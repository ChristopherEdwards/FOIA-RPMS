BTIUPG1 ; IHS/JM - PATIENT GOAL TIU OBJECT ROUTINE ;20-Mar-2013 15:09;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1011**;NOV 04,2004;Build 13
GETGOALS(DFN,TARGET,STATUS,NOSTEPS,NONOTES,TYPES) ;
 ;
 ; Patient Goals TIU Object API
 ;
 ;Required Parameters:
 ;
 ;  DFN       Patient identifier
 ;
 ;  TARGET    Where the medication data will be stored
 ;
 ;Optional Parameters:
 ;
 ;  STATUS    String containing one or more flags of goal types to display.
 ;              "A" - Show active goals
 ;              "I" - Show inactive goals
 ;              "D" - Show declined goals
 ;              Defaults is to show all goals
 ;
 ;  NOSTEPS   0 = Show Goal Steps (Default)
 ;            1 = Do Not Show Steps
 ;
 ;  NONOTES   0 = Show Goal Notes (Default)
 ;            1 = Do Not Show Notes
 ;
 ;  TYPES     String for limiting output to specific patient goal types,
 ;            as defined in File# 9001002.4 PATIENT GOAL TYPES.  Multiple
 ;            types must be delimited by a semicolon ";".  Example input
 ;            might be "PHYSICAL ACTIVITY;NUTRITION;DIABETES CURRICULUM",
 ;            which would return all goals with any of these goal types.
 ;            This parameter is case sensitive and must match the exact
 ;            text found in File# 9001002.4 PATIENT GOAL TYPES.
 ;            Default is to display all goal types.
 ;
 N GOALS,LINEINDX,ACTIVE,INACTIVE,DECLINE,SHOWSTEP,SHOWNOTE,FILTER
 N TEXT,MAXLEN,IDX,FLTRTXT,DASHES,GDATA,GFOUND,GSTATUS,GACTIVE
 N GINACTIV,GDECLINE,PROCESS,GTYPES,GTYPECNT,FIDX,TEMP,TEXT2
 N LISTIDX,ACTIVLST,INACTLST,DECLNLST,FIRST,SUBIDX,SUBDATA,SUBFIRST
 N GIEN,STEPDATA,MULTILST,SHOWN,GSHOWN
 K @TARGET
 S LINEINDX=0,MAXLEN=73
 D GETGOAL^BEHOPGAP(.GOALS,DFN)
 I $D(@GOALS)=0 G NOGOALS
 S $P(DASHES,"=",MAXLEN)="="
 S SHOWSTEP='(+$G(NOSTEPS))
 S SHOWNOTE='(+$G(NONOTES))
 S STATUS=$G(STATUS)
 S (ACTIVE,INACTIVE,DECLINE)=1
 I $TR(STATUS,"AID","")'=STATUS D
 . S ACTIVE=STATUS["A"
 . S INACTIVE=STATUS["I"
 . S DECLINE=STATUS["D"
 ;
 ; Display Report Criteria
 ;
 S TEXT=""
 I (ACTIVE&INACTIVE&DECLINE) S TEXT="All"
 E  D
 . I ACTIVE S TEXT="Active"
 . I INACTIVE D APPEND(.TEXT,"Inactive"," and")
 . I DECLINE D APPEND(.TEXT,"Declined"," and")
 D APPEND(.TEXT,"Patient Goals,")
 I SHOWSTEP D APPEND(.TEXT,"including")  I 1
 E  D APPEND(.TEXT,"excluding")
 D APPEND(.TEXT,"steps")
 I SHOWSTEP=SHOWNOTE D APPEND(.TEXT,"and")  I 1
 E  D
 . S TEXT=TEXT_","
 . I SHOWNOTE D APPEND(.TEXT,"including")  I 1
 . E  D APPEND(.TEXT,"excluding")
 D APPEND(.TEXT,"notes.")
 D ADD(TEXT)
 ;
 ; Display Filters
 ;
 S FILTER=$G(TYPES)
 I $L(FILTER)>0 D
 . S TEXT=""
 . F IDX=1:1 S FLTRTXT=$P(FILTER,";",IDX) Q:FLTRTXT=""  D APPEND(.TEXT,FLTRTXT,",")
 . S TEXT=": "_TEXT
 . I FILTER[";" S TEXT="s"_TEXT
 . S TEXT="Only showing goals of type"_TEXT_"."
 . D ADD(TEXT)
 ;
 ; GETGOAL^BEHOPGAP and GETSTEP^BEHOPGAP return data in the same ^TMP global.
 ; To avoid overwriting data when processing steps, the original goal data
 ; is moved to a temporary "GOALS" node of the TARGET ^TMP global
 ;
 I SHOWSTEP D
 . M @TARGET@("GOALS")=@GOALS
 . K @GOALS
 . S GOALS=$NA(@TARGET@("GOALS"))
 ;
 ; Display Data
 ;
 S MULTILST=((ACTIVE+INACTIVE+DECLINE)>1)
 I 'MULTILST D ADD(DASHES)
 S FILTER=";"_FILTER_";"
 S ACTIVLST=1,INACTLST=2,DECLNLST=3
 S (GFOUND,SHOWN)=0
 ;
 ; Call LSTGOALS up to 3 times in order to sort goals by status
 ;
 F LISTIDX=1:1:3 D
 . I (LISTIDX=ACTIVLST)&('ACTIVE) Q
 . I (LISTIDX=INACTLST)&('INACTIVE) Q
 . I (LISTIDX=DECLNLST)&('DECLINE) Q
 . D LSTGOALS
 G SUMMARY
 ;
LSTGOALS ;
 I MULTILST D  ; If more than one status, display a sub-header
 . D ADD("")
 . S TEXT=$S(LISTIDX=ACTIVLST:"Active",LISTIDX=INACTLST:"Inactive",LISTIDX=DECLNLST:"Declined",1:"")
 . D APPEND(.TEXT,"Patient Goals")
 . D ADD(TEXT) D ADD(DASHES)
 ;
 ; Loop through the goal data
 ;
 S IDX=0,FIRST=1,GSHOWN=0
 N CNT S CNT=0
 F  S IDX=$O(@GOALS@(IDX)) Q:IDX=""  D
 . S GDATA=$G(@GOALS@(IDX,0))
 . ;
 . ; Determine if goal should be displayed
 . ;
 . S GSTATUS=$P($P(GDATA,U,10),";")
 . I GSTATUS="D" Q  ; Ignore deleted goals
 . S GFOUND=1
 . S (GACTIVE,GINACTIV)=0
 . S GDECLINE=($P(GDATA,U,2)'="GOAL SET")
 . I 'GDECLINE D
 .. S GACTIVE=(GSTATUS="A")!(GSTATUS="MA")
 .. S GINACTIV=(GSTATUS="S")!(GSTATUS="ME")
 . S PROCESS=0
 . I (LISTIDX=ACTIVLST)&(ACTIVE&GACTIVE) S PROCESS=1
 . I (LISTIDX=INACTLST)&(INACTIVE&GINACTIV) S PROCESS=1
 . I (LISTIDX=DECLNLST)&(DECLINE&GDECLINE) S PROCESS=1
 . I 'PROCESS Q
 . S GTYPES=$G(@GOALS@(IDX,10))
 . I FILTER'=";;" D
 .. S PROCESS=0
 .. F FIDX=1:1 S TEMP=$P(GTYPES,U,FIDX) Q:(PROCESS!(TEMP=""))  D
 ... S TEMP=";"_TEMP_";"
 ... I FILTER[TEMP S PROCESS=1
 . I 'PROCESS Q
 . ;
 . ; Display Goal - column format not used because text fields
 . ; can be up to 120 characters long
 . ;
 . I FIRST S FIRST=0
 . E  D ADD("")
 . S (SHOWN,GSHOWN)=1
 . S CNT=CNT+1
 . S TEXT="Goal "_CNT_") "_$G(@GOALS@(IDX,11))
 . ;S TEXT="Goal "_$P(GDATA,U,11)_") "_$G(@GOALS@(IDX,11))
 . D ADD(TEXT)
 . ;
 . ; Display Goal Types
 . ;
 . S TEXT2="",TEXT="  Goal Type",GTYPECNT=0
 . F FIDX=1:1 S TEMP=$P(GTYPES,U,FIDX) Q:TEMP=""  S TEXT2=TEXT2_TEMP_", ",GTYPECNT=GTYPECNT+1
 . S TEXT2=$E(TEXT2,1,$L(TEXT2)-2) ; Strip last comma
 . I GTYPECNT>1 S TEXT=TEXT_"s"
 . S TEXT=TEXT_": "_TEXT2
 . D ADD(TEXT)
 . ;
 . ; Display Goal start/followup dates, status and reason
 . ;
 . S TEXT="  Start: "_$$DATESTR($P(GDATA,U,8))
 . I 'GDECLINE D APPEND(.TEXT,"  Follow Up: "_$$DATESTR($P(GDATA,U,9)))
 . D APPEND(.TEXT,"  Status: "_$S(GDECLINE:"Declined",1:$$STSTEXT(GSTATUS)))
 . D ADD(TEXT)
 . D ADD("  Reason: "_$G(@GOALS@(IDX,12)))
 . ;
 . ; Show Notes
 . ;
 . I SHOWNOTE,($D(@GOALS@(IDX,13))>9) D
 .. S SUBIDX=0,SUBFIRST=1
 .. F  S SUBIDX=$O(@GOALS@(IDX,13,SUBIDX)) Q:SUBIDX=""  D
 ... I SUBFIRST S SUBFIRST=0 S TEXT="  Notes: "
 ... E  S TEXT="         " ; Additional notes line up with start of first note
 ... S SUBDATA=$G(@GOALS@(IDX,13,SUBIDX))
 ... S TEXT=TEXT_$$DATESTR($P(SUBDATA,U,2))_" "_$P(SUBDATA,U,3)
 ... D ADD(TEXT)
 . ;
 . ; Show Steps, but only for active goals - same design as GUI Component
 . ;
 . N CNT
 . I SHOWSTEP&(LISTIDX=ACTIVLST) D
 .. S GIEN=$P(GDATA,U),SUBIDX=0,SUBFIRST=1
 .. D GETSTEP^BEHOPGAP(.STEPDATA,GIEN)
 .. S CNT=0
 .. F  S SUBIDX=$O(@STEPDATA@(SUBIDX)) Q:SUBIDX=""  D
 ... S SUBDATA=$G(@STEPDATA@(SUBIDX,0))
 ... S CNT=CNT+1
 ... I SUBFIRST S SUBFIRST=0 S TEXT="  Step "
 ... E  S TEXT="       "
 ... S TEXT=TEXT_CNT_") Start: "_$$DATESTR($P(SUBDATA,U,8))_"  "
 ... ;S TEXT=TEXT_$P(SUBDATA,U,4)_") Start: "_$$DATESTR($P(SUBDATA,U,8))_"  "
 ... D APPEND(.TEXT,"Follow Up: "_$$DATESTR($P(SUBDATA,U,9)))
 ... D APPEND(.TEXT,"  Status: "_$$STSTEXT($P($P(SUBDATA,U,12),";")))
 ... D ADD(TEXT)
 ... ; Line up step text with above line
 ... S TEXT="         "_$E("    ",1,$L($P(SUBDATA,U,4)))_$G(@STEPDATA@(SUBIDX,1))
 ... D ADD(TEXT)
 I 'GSHOWN D ADD("None Found.")
 Q
 ;
SUMMARY ;
 ;
 ; Display goal count
 ;
 I 'GFOUND G NOGOALS ; Happens when only deleted goals are found
 I 'SHOWN D ADD("No Patient Goals found that match the above criteria.")
 G DONE
 ;
NOGOALS ;
 K @TARGET
 D ADD("No patient goal information found.")
 G DONE
 ;
DONE ;
 D ADD("")
 K @TARGET@("GOALS")
 Q "~@"_$NA(@TARGET)
 ;
APPEND(VALUE,TXT,MIDDLE) ;
 I $L(VALUE)>0 D
 . I $L($G(MIDDLE))>0 S VALUE=VALUE_MIDDLE
 . S VALUE=VALUE_" "
 S VALUE=VALUE_TXT
 Q
 ;
ADD(TXT) ; Saves TXT in TARGET
 N TXT2,SUBCOUNT,SUBLINE
 I $L(TXT)>MAXLEN D  I 1
 . S TXT2=$$WRAP^TIULS(TXT,MAXLEN)
 . F SUBCOUNT=1:1 S SUBLINE=$P(TXT2,"|",SUBCOUNT) Q:SUBLINE=""  D ADD2(SUBLINE)
 E  D ADD2(TXT)
 Q
 ;
ADD2(TXT) ;
 S LINEINDX=LINEINDX+1
 S @TARGET@(LINEINDX,0)=TXT
 Q
 ;
DATESTR(DATE) ; returns Fileman date converted to MM/DD/YY format
 Q $S(+DATE>0:$E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_($E(DATE,1,3)+1700),1:"")
 ;
STSTEXT(CODE) ;
 Q $S(CODE="A":"Active",CODE="MA":"Maintained",CODE="S":"Stopped",CODE="ME":"Met",1:"")
