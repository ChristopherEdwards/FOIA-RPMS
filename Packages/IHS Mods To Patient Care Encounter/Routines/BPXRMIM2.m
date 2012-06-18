BPXRMIM2 ; IHS/CIA/MGH - Handle Computed findings for immunizations. ;09-Sep-2008 15:46;MGH
 ;;1.5;CLINICAL REMINDERS;**1002,1004,1005,1006**;Jun 19, 2000
 ;=================================================================
 ;This routine is designed to search  the immunication forcast
 ;data to determine if an immunization is due for a child requiring a
 ;series immunization
 ;Fixed call to standard call for forecaster
 ;1005 Changed and added call to forecaster to display last date done
 ;if the reminder is due
 ;=====================================================================
GETVAR(BPXTRM) ;EP
 ;Get the needed data from the reminder term. This includes the date range
 ;the test name(s) and the value to search for
 N X,Y,BPXFIND,BPXTYPE,BPXFILE,BPXCOND,BPXOFF,BPXVAL,BPXRESLT,BPXLAST
 N BPXCNT,BPXHI,TARGET,BPXTEST,TSTRING
 S TSTRING=""
 K ^TMP("BPXIMM",$J)
 S BPXCNT=0,BPXHI=0,BPXRESLT=0
 S X="TODAY" D ^%DT S TODAY=Y,LATE=Y
 S TARGET="^TMP(""BPXIMM"",$J)"
 S BPXFIND=0 F  S BPXFIND=$O(^PXRMD(811.5,BPXTRM,20,BPXFIND)) Q:BPXFIND=""!(BPXFIND?1A.A)!(BPXRESLT=1)  D
 .S BPXTYPE=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,1)
 .S BPXTEST=$P(BPXTYPE,";",1),BPXFILE=$P(BPXTYPE,";",2)
 .Q:BPXFILE'="AUTTIMM("
 .S BPXOFF=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,8)
 .S BPXOFF="-"_BPXOFF
 .;Call next routine with patient,start and stop dates,test name
 .S BPXRESLT=$$RESULT^BPXRMIM2(DFN,BPXTEST)
 I BPXRESLT=1 S TEST=0,VALUE=TEST
 I BPXRESLT=0 S TEST=1,VALUE=TEST,DATE=TODAY
 Q
RESULT(DFN,TEST) ;Find what is due
 ;Search the imunization forecast file to find the chosen  immunizations
 N BPXFOR,BPXIMM,BPXDONE,BPXSTR,TNAME,BIHX,BIDE,TCODE
 S BPXDONE=0
 ;Changed called Patch 1004 to standard call for forecaster
 S TNAME=$P(^AUTTIMM(TEST,0),U,2),TCODE=$P(^AUTTIMM(TEST,0),U,3)
 I TSTRING="" S TSTRING=TCODE
 I TSTRING'="" S TSTRING=TSTRING_","_TCODE
 ;Call the forecaster code to return the data
 D IMMFORC^BIRPC(.BPXSTR,DFN)
 F I=1:1 S BPXFOR=$P(BPXSTR,"^",I) Q:BPXFOR=""  D
 .S BPXIMM=$P(BPXFOR,"|",1)
 .;See if the immunization is due
 .I BPXIMM[TNAME S BPXDONE=1
 .;Find the date last done
 .S DATE=$$LASTIMM^BIUTL11(DFN,TSTRING)
 Q BPXDONE
