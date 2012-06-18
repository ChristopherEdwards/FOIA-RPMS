SD53227P ;ALB/RBS - Find Encounter/Visit Date/Time 421 error ; 10/11/00 4:59pm
 ;;5.3;Scheduling;**227**;AUG 13, 1993
 ;
 ;DBIA Integration Reference # 3211 to update #9000010 VISIT file.
 ; *** Calling routine is SD53P227 ***
 ;
 ;This routine will search for Encounters that have a invalid date
 ;and time setup causing a 421 error code to be setup.
 ;
 ;The ^XTMP global will be used as an audit file for 30 days from
 ;date of running the Clean Up & Report option.
 ; ^XTMP("SD53P227",0)=STRING of 10 fields
 ;  STRING = purge date^run date^start dt/time^stop dt/time...
 ;           ^tot errors^tot fixed^tot searched
 ; ^XTMP("SD53P227",1)=error node of encounters that can't be fixed
 ; ^XTMP("SD53P227",2)=encounters that can be fixed and re-sent
 ; ^XTMP("SD53P227",3)=e-mail report sent to user
 ; ^XTMP("SD53P227,"SENT")=audit trial of all encounters fixed
 ;
 ; @SDTEMP@ = ^XTMP("SD53P227")
 ;
 Q
 ;*;
FIND ; Search file for error pointer (ie...30 = 421)
 N CODE421,ENCPTR,ERRPTR,ERRNODE,NEWENDT,OK,OK1,OK2,SCENODE,SCEDATE,SCEDFN,SDDT,SDPNAM
 N SDSSN,SDCLN,STRING,TOTALS,VSITDATE,VSITPTR,XMITPTR,XMITNODE,X,Y,Z
 S (ERRPTR,EXIT,TOTALS)=0
 S CODE421=+$O(^SD(409.76,"B",421,0))      ;get pointer to error codes
 I 'CODE421 D  Q                           ;no error's - QUIT process
 .D NOFIND^SD53227
 .S EXIT=1
 S:$D(@SDTEMP@(0)) TOTALS=$P(@SDTEMP@(0),U,8,10)
 F  S ERRPTR=+$O(^SD(409.75,ERRPTR)) Q:('ERRPTR)  D  Q:EXIT
 .I ($$S^%ZTLOAD) S EXIT=1 Q
 .S ERRNODE=$G(^SD(409.75,ERRPTR,0))
 .S X=+$P(ERRNODE,U,2)
 .Q:(X'=CODE421)
 .; Get pointer to Transmitted Outpatient Encounter file (#409.73)
 .S XMITPTR=+$G(^SD(409.75,ERRPTR,0))
 .Q:('$D(^SD(409.73,XMITPTR,0)))
 .S XMITNODE=$G(^SD(409.73,XMITPTR,0))
 .; Get pointer to Outpatient Encounter file (#409.68)
 .S ENCPTR=+$P(XMITNODE,U,2)
 .;
 .Q:$D(@SDTEMP@("SENT",ERRPTR,XMITPTR,ENCPTR))        ;already fixed
 .;
 .; Get pointer to Visit file (#9000010) - ^AUPNVSIT
 .S SCENODE=$G(^SCE(ENCPTR,0))
 .Q:SCENODE=""
 .; date.time - patient DPT( pointer -  visit pointer
 .S SCEDATE=$P(SCENODE,U),SCEDFN=$P(SCENODE,U,2),VSITPTR=+$P(SCENODE,U,5)
 .; get patient name - SSN
 .S SDPNAM=$G(^DPT(SCEDFN,0)),SDSSN=$P(SDPNAM,U,9),SDPNAM=$P(SDPNAM,U)
 .S SDCLN=$P($G(^SC(+$P(SCENODE,U,4),0)),U)       ;hospital location
 .S STRING=VSITPTR_U_SDPNAM_U_SCEDFN_U_SDSSN_U_SDCLN_U_SCEDATE
 .S $P(TOTALS,U,3)=$P(TOTALS,U,3)+1               ;total records
 .;
 .; Check Encounter date/time
 .S (NEWENDT,OK,OK1,OK2)=0
 .D CKDATE(SCEDATE,.OK)                           ;check date
 .I OK D  Q                                       ;bad Date
 ..D ADD(STRING,"* INVALID DATE *",1)
 .;
 .D CKTIME(SCEDATE,.NEWENDT,.OK)                  ;check time
 .I OK D  Q                                       ;can't fix Date/Time
 ..D ADD(STRING,"* INVALID TIME *",1)
 .;
 .I NEWENDT=SCEDATE D  Q               ;date & time OK, nothings wrong
 ..D ADD(STRING,"* Date/Time OK *",1)
 .;
 .S OK1=1     ;new encounter date and time reset was OK
 .;
 .; API - Get #9000010 file - .01 VISIT/ADMIT DATE&TIME field
 .;S VSITDATE=$$VISADDAT^PXAAVSIT(VSITPTR)
 .S VSITDATE=$P($G(^AUPNVSIT(VSITPTR,0)),"^",1)
 .; Check if Visit d/t equals original Encounter d/t...then OK2
 .S:VSITDATE=SCEDATE OK2=1
 .;
 .; Visit d/t different
 .I OK1,'OK2 D  Q
 ..D ADD(STRING_U_VSITDATE,"*VISIT D/T Diff.*",1)
 .;
 .; Everything is OK
 .I OK1,OK2 D
 ..D:FIX FIX(ENCPTR,XMITPTR,VSITPTR,NEWENDT,.OK)     ;update files
 ..Q:OK                                              ;can't fix
 ..D ADD(STRING,NEWENDT,2)                           ;OK to update
 ;
 S $P(@SDTEMP@(0),U,8,10)=TOTALS         ;add totals string to ^XTMP
 Q
 ;
ADD(STR,X,Z) ; Setup file entry
 ; Setup either error node(1) or fix node(2) or sent node("SENT")
 ; STR = string of ien pointers, patient info, original date/time
 ; X   = the new date/time or error message.
 ; Z   = node subscript to setup data
 ; ERRPTR  - IEN for Transmitted Outpatient Encounter error file
 ;                   (#409.75)
 ; XMITPTR - Pointer to Transmitted Outpatient Encounter file
 ;                   (#409.73)
 ; ENCPTR  - Pointer to entry in Outpatient Encounter file
 ;                   (#409.68)
 S @SDTEMP@(Z,ERRPTR,XMITPTR,ENCPTR)=STR_U_X
 S @SDTEMP@(Z)=$G(@SDTEMP@(Z))+1
 S:+Z $P(TOTALS,U,Z)=$P(TOTALS,U,Z)+1
 Q
 ;
FIX(ENCPTR,XMITPTR,VSITPTR,NEWENDT,ERR) ; Fix #409.68  &  #9000010 files
 ;Input  : ENCPTR  - Pointer to entry in Outpatient Encounter file
 ;                   (#409.68)
 ;         XMITPTR - Pointer to Transmitted Outpatient Encounter file
 ;                   (#409.73)
 ;         VSITPTR - Pointer to Visit file
 ;                   (#9000010)
 ;         NEWENDT - New date/time (FileMan format)
 ;             ERR - Check for OK or not(0=OK, 1=error)
 ;
 ;Output :     ERR - 0=OK, 1=error
 ;
 Q:'FIX                                ;Not time to update records
 ;
 N SCFDA,IENS,SCERR
 S IENS=ENCPTR_","
 S SCFDA(409.68,IENS,".01")=NEWENDT    ;#409.68 - Encounter file
 ;
 L +^SCE(ENCPTR):2
 I '$T D  Q                            ;can't lock record
 .D ADD(STRING,"* #409.68 Error *",1)
 .S OK=1
 ;
 ; if nothing is wrong, "SCERR" will be un-defined...
 D FILE^DIE("","SCFDA","SCERR")
 I $D(SCERR) D  Q                      ;somethings wrong
 .D ADD(STRING,"* #409.68 Error* ",1)
 .L -^SCE(ENCPTR)
 ;
 ; #9000010 API call to PCE for Filing update to .01 Visit/Admit field
 S SCERR=0
 D FILE(VSITPTR,NEWENDT,.SCERR)
 I SCERR D  Q                          ;somethings wrong
 .D ADD(STRING,"* #9000010 Error *",1)
 .L -^SCE(ENCPTR)
 ;
 ; Re-flag encounters for transmission
 D STREEVNT^SCDXFU01(XMITPTR)          ;Log the event
 D XMITFLAG^SCDXFU01(XMITPTR)          ;Flag record for transmission
 ;
 L -^SCE(ENCPTR)
 ;
 D ADD(STRING,NEWENDT,"SENT")           ;Audit trail - ^XTMP(,"SENT"
 Q
 ;
CKDATE(SDDT,ERR) ; Check Encounter and Visit Date
 N CKDATE
 S CKDATE=$P(SDDT,"."),ERR=0
 S ERR=+$$DATE(CKDATE)  ;validate date
 Q
 ;
DATE(DAT) ; Validate FileMan date only
 N DATE,X,Y,%DT
 S DATE=$P(DAT,"."),X=DATE,%DT="X" D ^%DT
 I Y<0 Q 1
 Q 0
 ;
CKTIME(SDDT,NEWENDT,ERR) ; check and validate new date/time
 ; we are dropping all seconds before trying to validate hour/min
 N CKTIME,NEWTIME,X,Y,%DT
 S (NEWENDT,NEWTIME,ERR)=0,CKTIME=$P(SDDT,".",2)
 I $L(CKTIME)>6 S CKTIME=$E(CKTIME,1,6)
 ;convert to external d/t first, then validate back to internal d/t
 S Y=$P(SDDT,".")_"."_CKTIME
 D DD^%DT S X=Y,%DT="ST" D ^%DT
 I Y<0 D                                  ;reset time
 .S CKTIME=$E(CKTIME_"0000",1,4)          ;drop all seconds
 .S NEWTIME=+$$TIME(CKTIME)               ;try to setup new time
 .S NEWENDT=$P(SDDT,".")_NEWTIME          ;concatenate date w/new time
 .S Y=NEWENDT D DD^%DT S X=Y,%DT="ST" D ^%DT    ;re-validate date/time
 I Y<0 S ERR=1 Q
 S NEWENDT=Y
 Q
 ;
TIME(TIM) ; Break out hours and minutes
 N TIME,HR,MIN,SEC
 S HR=$E(TIM,1,2),MIN=$E(TIM,3,4),SEC=$E(TIM,5,6)
 S:(HR>23) HR=23,MIN=59,SEC=""
 S:(MIN>59) MIN=59
 S:(SEC>59) SEC=59
 S TIME=HR_MIN_SEC
 Q:'TIME 0
 ;Done - return time (trailing zeros removed)
 Q +("."_TIME)
 ;
FILE(IEN,VDT,ERR) ; Update #9000010 VISIT File - .01 Visit/Admit d/t field
 ; input    - IEN   = visit internal entry number to ^AUPNVSIT(#)
 ;          - VDT   = new date and time (FM internal d/t format)
 ;          - ERR   = check for Filing OK
 ; output   - ERR   = 0 = Filing complete
 ;                    1 = Filing error
 N SDFDA,IENS,SDERR,X,Y
 S ERR=0
 I '($D(^AUPNVSIT(IEN,0))#2) S ERR=1 Q    ;not a valid visit ien
 I VDT']"" S ERR=1 Q
 L +^AUPNVSIT(IEN):2 I '$T S ERR=1 Q      ;can't lock
 S IENS=IEN_","
 S SDFDA(9000010,IENS,".01")=VDT          ;#9000010 - Visit file
 D FILE^DIE("","SDFDA","SDERR")           ;file new .01 date/time
 L -^AUPNVSIT(IEN)
 S:$D(SDERR) ERR=1
 Q
