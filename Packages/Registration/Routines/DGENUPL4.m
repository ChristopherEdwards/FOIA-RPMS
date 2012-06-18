DGENUPL4 ;ALB/CJM,RTK,ISA/KWP,ISD/GSN,PHH - PROCESS INCOMING (Z11 EVENT TYPE) HL7 MESSAGES ; 4/25/2003
 ;;5.3;REGISTRATION;**147,177,232,253,327,367,377,514**;Aug 13,1993
 ;
UOBJECTS(DFN,DGPAT,DGELG,DGCDIS,MSGID,ERRCOUNT,MSGS,OLDPAT,OLDELG,OLDCDIS) ;
 ;Description: Used to update the PATIENT, ELIGIBILITY, and CATASTROPHIC
 ;DISABILITY objects 'in memory'.
 ;
 ;Input:
 ;  DFN - ien of record in the PATIENT file
 ;  DGPAT - PATIENT object array (pass by reference)
 ;  DGELG - ELIGIBILITY object array (pass by reference)
 ;  DGCDIS - CATASTROPHIC DISABILITY object array (pass by reference)
 ;  MSGID - message control id of the HL7 message being processed
 ;  ERRCOUNT - count of errors (pass by reference)
 ;  MSGS - array of messages for the site (pass by reference)
 ;
 ;Output:
 ;  Function Value: 1 if the update was successful 'in memory',
 ;           consistency checks pass and the objects can be stored in
 ;           the local database, 0 otherwise.
 ;  DGPAT - PATIENT object array (pass by reference)
 ;  DGELG - ELIGIBILITY object array (pass by reference)
 ;  DGCDIS - CATASTROPHIC DISABILITY object array (pass by reference)
 ;  ERRCOUNT - count of errors (pass by reference)
 ;  MSGS - array of messages for the site (pass by reference)
 ;  OLDPAT - patient object array as it currently exists in database before the update (pass by reference)
 ;  OLDELG - eligibility object array as it currently exists in database before the update (pass by reference)
 ;  OLDCDIS - catastrophically disability object array as it currently exists in database before the update (pass by reference)
 ;
 N DGPAT3,DGELG3,DGCDIS3,SUCCESS
 S SUCCESS=1
 D
 .;first get the local site's current data
 .I ('$$GET^DGENPTA(DFN,.OLDPAT))!('$$GET^DGENELA(DFN,.OLDELG))!('$$GET^DGENCDA(DFN,.OLDCDIS)) D  Q
 ..D ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),"UNABLE TO ACCESS PATIENT RECORD",.ERRCOUNT)
 ..S SUCCESS=0
 .;
 .;Phase II CD Consistency Checks (SRS 6.5.1.4) check VISTA against HEC
 .S SUCCESS=$$CDCHECK^DGENUPL9()
 .Q:'SUCCESS
 .;
 .;now merge with the update
 .D MERGE
 .;
 .;add the assumed values
 .D ADD
 .;
 .;now do the consistency checks
 .S SUCCESS=$$CHECK()
 .Q:'SUCCESS
 .;
 .;replace input arrays with fully updated versions
 .K DGPAT M DGPAT=DGPAT3
 .K DGELG M DGELG=DGELG3
 .K DGCDIS M DGCDIS=DGCDIS3
 ;
 I SUCCESS D
 .;
 .;list of required notifications
 .;
 .;change in date of death
 .I DGPAT("DEATH"),$P(OLDPAT("DEATH"),".")'=$P(DGPAT("DEATH"),".") D
 ..D ADDMSG^DGENUPL3(.MSGS,"HEC SHOWS DATE OF DEATH = "_$$FMTE^XLFDT(DGPAT("DEATH"),"1"),1)
 ..D ADDMSG^DGENUPL3(.MSGS,$S('OLDPAT("DEATH"):"SITE DOES NOT HAVE DATE OF DEATH",1:"SITE HAS DATE OF DEATH = "_$$FMTE^XLFDT(OLDPAT("DEATH"),"1")),1)
 .;
 .I OLDPAT("DEATH"),'DGPAT("DEATH") D
 ..D ADDMSG^DGENUPL3(.MSGS,"HEC SHOWS NO DATE OF DEATH",1)
 ..D ADDMSG^DGENUPL3(.MSGS,"SITE HAS DATE OF DEATH = "_$$FMTE^XLFDT(OLDPAT("DEATH"),"1"),1)
 .;
 .;change in POW
 .I OLDELG("POW")="N",DGELG("POW")="Y" D ADDMSG^DGENUPL3(.MSGS,"POW STATUS CHANGED TO YES")
 .I OLDELG("POW")="Y",DGELG("POW")="N" D ADDMSG^DGENUPL3(.MSGS,"POW STATUS CHANGED TO NO")
 .;
 .;SC to NSC
 .I OLDELG("SC")="Y",DGELG("SC")="N" D ADDMSG^DGENUPL3(.MSGS,"VETERAN CHANGED TO NON-SERVICE CONNECTED",1)
 .;
 .; Change from Eligible to Ineligible
 .I 'OLDPAT("INELDATE"),DGPAT("INELDATE") D ADDMSG^DGENUPL3(.MSGS,"VETERAN PREVIOUSLY ELIGIBLE FOR VA HEALTH CARE, NOW INELIGIBLE.",1)
 Q SUCCESS
 ;
ADD ;
 ;Description: adds computed and assumed values to the updated objects
 ;
 ;Input: DGELG3(),DGPAT3() created in the UOBJECTS procedure.
 ;
 N SUB,TYPE,DATA
 S DGELG3("ELIGENTBY")=.5
 S SUB=0 F  S SUB=$O(DGELG3("RATEDIS",SUB)) Q:'SUB  S DGELG3("RATEDIS",SUB,"RDSC")=1
 ;
 ; Default Patient Types
 I DGELG3("SC")="N" S DGPAT3("VETERAN")="Y",DGPAT3("PATYPE")=$O(^DG(391,"B","NSC VETERAN",0))
 I DGELG3("SC")="Y" S DGPAT3("VETERAN")="Y",DGPAT3("PATYPE")=$O(^DG(391,"B","SC VETERAN",0))
 ;
 ; If Ineldate apply the business rules
 I DGPAT3("INELDATE"),DGELG3("SC")'="Y" D
 .S DGPAT3("VETERAN")="N",DGPAT3("PATYPE")=$O(^DG(391,"B","NON-VETERAN (OTHER)",0))
 .S DGELG3("POS")=$O(^DIC(21,"B","OTHER NON-VETERANS",0))
 ;
 ;update/set ELIGIBILITY VERIF. SOURCE field (Ineligible Project):
 I DGELG3("ELIGVERIF")["VIVA" S DATA(.3613)="H"
 E  S DATA(.3613)="V"
 ;
 ; File the data fields modified by Ineligible Business Rules
 I $$UPD^DGENDBS(2,DFN,.DATA,.ERROR)
 Q
 ;
MERGE ;
 ;Description: merges arrays with current patient data with the updates
 ; Merges DGPAT() + OLDPAT() -> DGPAT3()
 ;        DGELG() + OLDELG() -> DGELG3()
 ;        DGCDIS() + OLDCDIS() -> DGCDIS3()
 ;
 ;Input:
 ;  DGPAT,DGELG,DGCDIS,OLDPAT,OLDELG,OLDCDIS arrays
 ;
 ;Output:
 ;  DGPAT3,DGELG3,DGCDIS3 arrays
 ;
 N SUB,SUB2,LOC,HEC,NATCODE
 M DGPAT3=OLDPAT,DGELG3=OLDELG,DGCDIS3=OLDCDIS
 ;
 ;discard MT status from local database - don't ever want to use it during upload
 S DGELG3("MTSTA")=DGELG("MTSTA")
 ;
 ;patient array
 S SUB=""
 F  S SUB=$O(DGPAT(SUB)) Q:(SUB="")  I (DGPAT(SUB)'="") S DGPAT3(SUB)=$S((DGPAT(SUB)="@"):"",1:DGPAT(SUB))
 ;
 ;Allow Ineligible info deletion (Ineligible Project):
 I $D(DGPAT("INELDEC")),DGPAT("INELDEC")="" S DGPAT("INELDEC")="@"
 I $D(DGPAT("INELREA")),DGPAT("INELREA")="" S DGPAT("INELREA")="@"
 I $D(DGPAT("INELDATE")),DGPAT("INELDATE")="" S DGPAT("INELDATE")="@"
 ;
 ;catastrophic disability array
 S SUB=""
 F  S SUB=$O(DGCDIS(SUB)) Q:(SUB="")  D
 .I $D(DGCDIS(SUB))=1 I ($G(DGCDIS(SUB))'="") S DGCDIS3(SUB)=$S((DGCDIS(SUB)="@"):"",1:DGCDIS(SUB))
 .I $D(DGCDIS(SUB))=10 D
 ..S SUB2=""
 ..F  S SUB2=$O(DGCDIS(SUB,SUB2)) Q:SUB2=""  D
 ...I ($G(DGCDIS(SUB,SUB2))'="") S DGCDIS3(SUB,SUB2)=$S((DGCDIS(SUB,SUB2)="@"):"",1:DGCDIS(SUB,SUB2))
 ...I SUB="PROC" D
 ....N CDPROC,CDEXT,LIEN
 ....S CDPROC=$G(DGCDIS3("PROC",SUB2))
 ....Q:CDPROC=""
 ....S CDEXT=DGCDIS3("EXT",SUB2)
 ....Q:CDEXT=""
 ....S LIEN=$O(^DGEN(27.17,CDPROC,1,"B",CDEXT,0))
 ....Q:LIEN=""
 ....K DGCDIS3("EXT",SUB2)
 ....S DGCDIS3("EXT",SUB2,LIEN)=CDEXT
 ;
 ;eligibility array
 F  S SUB=$O(DGELG(SUB)) Q:(SUB="")  I ($G(DGELG(SUB))'="") S DGELG3(SUB)=$S((DGELG(SUB)="@"):"",1:DGELG(SUB))
 ;
 ;rated disabilities from HEC should replace local sites
 D
 .K DGELG3("RATEDIS")
 .M DGELG3("RATEDIS")=DGELG("RATEDIS")
 ;
 ;primary eligibility
 I (DGELG("ELIG","CODE")'="") S DGELG3("ELIG","CODE")=$S((DGELG("ELIG","CODE")="@"):"",($$NATCODE^DGENELA(DGELG("ELIG","CODE"))=$$NATCODE^DGENELA(DGELG3("ELIG","CODE"))):DGELG3("ELIG","CODE"),1:DGELG("ELIG","CODE"))
 ;
 ;patient eligibilities multiple
 ;delete the veteran type codes not mapped to national codes sent by HEC, but leave the non-veteran types and the codes where there is a match
 ;first find all the local codes already in the patient file and the ones sent from HEC, keep in arrays LOC and HEC
 S NATCODE=$$NATCODE^DGENELA(DGELG("ELIG","CODE")) I NATCODE S HEC(NATCODE)=""
 S SUB=0 F  S SUB=$O(DGELG("ELIG","CODE",SUB)) Q:'SUB  S NATCODE=$$NATCODE^DGENELA(SUB) I NATCODE S HEC(NATCODE)=""
 S SUB=0 F  S SUB=$O(DGELG3("ELIG","CODE",SUB)) Q:'SUB  S NATCODE=$$NATCODE^DGENELA(SUB) I NATCODE S LOC(NATCODE)=""
 ;Now discard the codes in the local patient database that don't map to a national code sent by HEC, as well as HUMANIARIAN EMERGENCY code if not sent by HEC: 
 S SUB=0
 F  S SUB=$O(DGELG3("ELIG","CODE",SUB)) Q:'SUB  D
 .I $P($G(^DIC(8,SUB,0)),"^",5)="Y"!($P($G(^DIC(8,SUB,0)),"^")["HUMANITARIAN EMERGENCY"),'$D(HEC($$NATCODE^DGENELA(SUB))) K DGELG3("ELIG","CODE",SUB)
 ;now add the codes included in the update that the local database does not already contain
 S SUB=0
 F  S SUB=$O(DGELG("ELIG","CODE",SUB)) Q:'SUB  D
 .I '$D(LOC($$NATCODE^DGENELA(SUB))) S DGELG3("ELIG","CODE",SUB)=SUB
 Q
 ;
CHECK() ;
 ;Description: Does the consistency checks on the PATIENT, ELIGIBILITY, and CATASTROPHIC DISABILITY objects.
 ;
 ;Input:
 ;  OLDPAT,DGPAT3,DGELG3,DGCDIS3,ERRCOUNT,MSGID
 ;  DGENR -Enrollment Array
 ;  DGPAT -Patient Array
 ;  MSGS  -Warning and Error Message array   
 ;
 ;Output:
 ;  Function Value - 1 if consistency checks passed, 0 otherwise
 ;
 N SUCCESS,ALIVE,ERRMSG,DGENR
 S SUCCESS=1
 S ERRMSG=""
 ;
 ;if upload includes date of death, check for indications that the patient is alive
 I DGPAT3("DEATH"),'OLDPAT("DEATH") D  S:ALIVE SUCCESS=0
 .;
 .;determine if the patient is at the moment being registered
 .S ALIVE=$$IFREG^DGREG(DFN)
 .;
 .;check if an inpatient
 .I 'ALIVE,$$INPAT^DGENPTA(DFN,DT,DT) S ALIVE=1
 .;
 .;Phase II locally enrolled with enrollment date after death date and status of unverified and rejected-initial application by vamc (SRS 6.5.1.2 e)
 .N CURIEN,CURENR
 .S CURIEN=$$FINDCUR^DGENA(DFN)
 .I CURIEN,$$GET^DGENA(CURIEN,.CURENR),CURENR("DATE")>DGPAT3("DEATH"),CURENR("STATUS")=1!(CURENR("STATUS")=14) S ALIVE=1
 .;there is an indication that he patient may not be dead
 .D:ALIVE ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),"LOCAL SITE VERIFY PATIENT DEATH",.ERRCOUNT),ADDMSG^DGENUPL3(.MSGS,"ELIBILITY UPLOAD CONTAINED DATE OF DEATH AND WAS REJECTED, PLEASE VERIFY PATIENT DEATH",1),NOTIFY^DGENUPL3(.DGPAT,.MSGS)
 ;
 ;only do the consistency checks on this data if it is verified
 I SUCCESS,(DGELG3("ELIGSTA")="V") D
 .I $$CHECK^DGENPTA1(.DGPAT3,.ERRMSG),$$CHECK^DGENELA1(.DGELG3,.DGPAT3,.DGCDIS3,.ERRMSG),$$CHECK^DGENCDA1(.DGCDIS3,.ERRMSG)
 .E  D
 ..S SUCCESS=0
 ..D ADDERROR^DGENUPL(MSGID,DGPAT("SSN"),ERRMSG,.ERRCOUNT)
 Q SUCCESS
