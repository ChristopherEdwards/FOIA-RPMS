PXRMPTL ; SLC/DLT,PKR,PJH - Print Clinical Reminders logic ; 01/18/2002
 ;;1.5;CLINICAL REMINDERS;**2,8**;Jun 19, 2000
 ;
 ;=======================================================================
ARRFMT(START,END,NE,INARRAY,OUTARRAY) ;Format array INARRAY so that
 ;it fits between START and END. Put each "formatted" piece into
 ;OUTARRAY and return the number of lines.
 N IC,LINNUM,MAXLEN,SLEN
 K OUTARRAY
 S MAXLEN=END-START+1
 S OUTARRAY(1)=""
 S LINNUM=1
 F IC=1:1:NE D
 . S SLEN=$L(OUTARRAY(LINNUM))+$L(INARRAY(IC))
 . I SLEN>MAXLEN D
 .. S LINNUM=LINNUM+1
 .. S OUTARRAY(LINNUM)=INARRAY(IC)
 . E  S OUTARRAY(LINNUM)=OUTARRAY(LINNUM)_INARRAY(IC)
 Q LINNUM
 ;
 ;=======================================================================
BLDFLST(FL) ;Build the list of findings defined for this reminder.
 N IC,TEMP,GLOB,SUB,NAME
 ;Build a list of findings.
 S IC=0
 F  S IC=$O(^PXD(811.9,RITEM,20,IC)) Q:+IC=0  D
 . S TEMP=$P(^PXD(811.9,RITEM,20,IC,0),U)
 . S GLOB=$P(TEMP,";",2),SUB=$P(TEMP,";")
 . S NAME=$P($G(@(U_GLOB_SUB_",0)")),U)
 . S FL(IC)=NAME
 Q
 ;
 ;=======================================================================
DISLOG ;Display the APPLY LOGIG.
 ;Determine if this is a default adhoc logic or user modified logic
 N PXF
 S PXF=$L($G(^PXD(811.9,D0,30)))
 I 'PXF W "Default PATIENT COHORT LOGIC to see if the Reminder applies to a patient:"
 E  W "Customized PATIENT COHORT LOGIC to see if the Reminder applies to a patient:"
 ;
 N BOOLOP,RITEM
 S RITEM=D0
 ;
 ;Establish the list of boolean operators that can be used in the logic
 ;string.
 S BOOLOP="'!&"
 ;
 ;Build the lists of findings for this reminder.
 N FL
 D BLDFLST(.FL)
 ;
 N ELOGSTR,IND,NEE,LOGSTR,NLOGLIN,PARRAY,SEP,TEND,TSTART
 S TSTART=1
 S TEND=75
 ;
 ;Get the user cohort logic string.
 S LOGSTR=$G(^PXD(811.9,RITEM,30))
 ;Otherwise use internal cohort logic
 I LOGSTR="" S LOGSTR=$G(^PXD(811.9,RITEM,31))
 ;
 ;Remove any (0)! and (1)& entries
 S LOGSTR=$$REMOVE(LOGSTR)
 ;
 S NLOGLIN=$$STRFMT(TSTART,TEND,LOGSTR,BOOLOP,.PARRAY)
 F IND=1:1:NLOGLIN D
 . W !,?5,PARRAY(IND)
 ;
 ;The finding separators are the Boolean operators plus ","
 ;in functions.
 S SEP=BOOLOP_",<>="
 S NEE=$$ELOGSTR(LOGSTR,.ELOGSTR,.FL,SEP)
 ;Format the expanded logic string.
 S NLOGLIN=$$ARRFMT(TSTART,TEND,NEE,.ELOGSTR,.PARRAY)
 ;
 W !!,"Expanded Patient Cohort Logic:"
 F IND=1:1:NLOGLIN D
 . W !,?5,PARRAY(IND)
 ;
 W !!
 S PXF=$L($G(^PXD(811.9,RITEM,34)))
 I 'PXF W "Default RESOLUTION LOGIC defines findings that resolve the Reminder:"
 E  W "Customized RESOLUTION LOGIC defines findings that resolve the Reminder:"
 ;
 ;Get user resolution logic string
 S LOGSTR=$G(^PXD(811.9,RITEM,34))
 ;Otherwise use internal resolution logic
 I LOGSTR="" S LOGSTR=$G(^PXD(811.9,RITEM,35))
 ;
 ;Remove any (0)! and (1)& entries
 S LOGSTR=$$REMOVE(LOGSTR)
 ;
 S NLOGLIN=$$STRFMT(TSTART,TEND,LOGSTR,BOOLOP,.PARRAY)
 F IND=1:1:NLOGLIN D
 . W !,?5,PARRAY(IND)
 ;
 S NEE=$$ELOGSTR(LOGSTR,.ELOGSTR,.FL,BOOLOP)
 ;Format the expanded logic string.
 S NLOGLIN=$$ARRFMT(TSTART,TEND,NEE,.ELOGSTR,.PARRAY)
 ;
 W !!,"Expanded Resolution Logic:"
 F IND=1:1:NLOGLIN D
 . W !,?5,PARRAY(IND)
 Q
 ;
 ;=======================================================================
ELOGSTR(LOGSTR,ELOGSTR,FL,SEP) ;Expand the logic string use SEP as a
 ;separator. Return the number of elements.
 N END,IC,IND,NEE,START,TEMP
 S NEE=1
 S ELOGSTR(NEE)=""
 ;Break the logic string into pieces using SEP.
 F IC=1:1:$L(LOGSTR) D
 . S TEMP=$E(LOGSTR,IC)
 . I SEP[TEMP D
 .. S NEE=NEE+1
 .. S ELOGSTR(NEE)=TEMP
 .. S NEE=NEE+1
 .. S ELOGSTR(NEE)=""
 . E  S ELOGSTR(NEE)=ELOGSTR(NEE)_TEMP
 ;Substitute the names for the finding indices.
 F IC=1:1:NEE D
 . I ELOGSTR(IC)["FI" D
 .. S TEMP=ELOGSTR(IC)
 .. S START=$F(TEMP,"FI(")
 .. S END=$F(TEMP,")",START)-2
 .. S IND=$E(TEMP,START,END)
 .. S TEMP=$G(FL(IND)) I TEMP="" Q
 .. S ELOGSTR(IC)=$$STRREP^PXRMUTIL(ELOGSTR(IC),IND,TEMP)
 Q NEE
 ;
 ;======================================================================
STRFMT(START,END,STRING,SEP,OUTARRAY) ;Format string STRING so that
 ;it fits between START and END. Put each "formatted" piece into
 ;OUTARRAY and return the number of lines.
 N MAXLEN,SLEN
 K OUTARRAY
 S MAXLEN=END-START+1
 S SLEN=$L(STRING)
 I SLEN'>MAXLEN D  Q 1
 . S OUTARRAY(1)=STRING
 ;
 N CHAR,IC,LINNUM,NE,TARRAY,TEMP
 ;Break string into pieces using SEP.
 S LINNUM=0
 S TEMP=""
 F IC=1:1:SLEN D
 . S CHAR=$E(STRING,IC,IC)
 . S TEMP=TEMP_CHAR
 . I SEP[CHAR D
 .. S LINNUM=LINNUM+1
 .. S TARRAY(LINNUM)=TEMP
 .. S TEMP=""
 S LINNUM=LINNUM+1
 S TARRAY(LINNUM)=TEMP
 S NE=LINNUM
 ;
 ;Load the output array.
 S OUTARRAY(1)=""
 S LINNUM=1
 F IC=1:1:NE D
 . S SLEN=$L(OUTARRAY(LINNUM))+$L(TARRAY(IC))
 . I SLEN>MAXLEN D
 .. S LINNUM=LINNUM+1
 .. S OUTARRAY(LINNUM)=TARRAY(IC)
 . E  S OUTARRAY(LINNUM)=OUTARRAY(LINNUM)_TARRAY(IC)
 Q LINNUM
 ;
 ;======================================================================
REMOVE(STRING) ;Remove leading (n) entries
 I ($E(STRING,1,4)="(0)!")!($E(STRING,1,4)="(1)&") S $E(STRING,1,4)=""
 Q STRING
