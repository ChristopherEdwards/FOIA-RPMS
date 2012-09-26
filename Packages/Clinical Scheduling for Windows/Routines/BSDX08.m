BSDX08 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;
APPDELD(BSDXY,BSDXAPTID,BSDXTYP,BSDXCR,BSDXNOT) ;EP
 ;Entry point for debugging
 ;
 ;D DEBUG^%Serenji("APPDEL^BSDX08(.BSDXY,BSDXAPTID,BSDXTYP,BSDXCR,BSDXNOT)")
 Q
 ;
APPDEL(BSDXY,BSDXAPTID,BSDXTYP,BSDXCR,BSDXNOT)        ;EP
 ;Called by BSDX CANCEL APPOINTMENT
 ;Cancels appointment
 ;BSDXAPTID is entry number in BSDX APPOINTMENT file
 ;BSDXTYP is C for clinic-cancelled and PC for patient cancelled
 ;BSDXCR is pointer to CANCELLATION REASON File (409.2)
 ;BSDXNOT is user note
 ;Returns error code in recordset field ERRORID
 ;
 N BSDXNOD,BSDXPATID,BSDXSTART,DIK,DA,BSDXID,BSDXI,BSDXZ,BSDXERR
 N BSDXLOC,BSDXLEN,BSDXSCIEN
 N BSDXNOEV
 S BSDXNOEV=1 ;Don't execute BSDX CANCEL APPOINTMENT protocol
 ;
 D ^XBKVAR S X="ETRAP^BSDX08",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,BSDXI)="T00020ERRORID"_$C(30)
 S BSDXI=BSDXI+1
 TSTART
 I '+BSDXAPTID D ERR(BSDXI,"BSDX08: Invalid Appointment ID") Q
 I '$D(^BSDXAPPT(BSDXAPTID,0)) D ERR(BSDXI,"BSDX08: Invalid Appointment ID") Q
 ;
 ;Delete APPOINTMENT entries
 S BSDXNOD=^BSDXAPPT(BSDXAPTID,0)
 S BSDXPATID=$P(BSDXNOD,U,5)
 S BSDXSTART=$P(BSDXNOD,U)
 ;
 ;Lock BSDX node
 L +^BSDXAPPT(BSDXPATID):5 I '$T D ERR(BSDXI+1,"Another user is working with this patient's record.  Please try again later") TROLLBACK  Q
 ;cancel BSDX APPOINTMENT record
 D BSDXCAN(BSDXAPTID)
 ;
 S BSDXSC1=$P(BSDXNOD,U,7) ;RESOURCEID
 I BSDXSC1]"",$D(^BSDXRES(BSDXSC1,0)) D  I +$G(BSDXZ) S BSDXERR=BSDXERR_$P(BSDXZ,U,2) D ERR(BSDXI,BSDXERR) Q
 . S BSDXNOD=^BSDXRES(BSDXSC1,0)
 . S BSDXLOC=$P(BSDXNOD,U,4) ;HOSPITAL LOCATION
 . Q:'+BSDXLOC
 . S BSDXSCIEN=$$SCIEN^BSDU2(BSDXPATID,BSDXLOC,BSDXSTART) I BSDXSCIEN="" D  I 'BSDXZ Q  ;Q:BSDXZ
 . . S BSDXERR="BSDX08: Unable to find associated RPMS appointment for this patient. "
 . . S BSDXZ=1
 . . I '$D(^BSDXRES(BSDXSC1,20)) S BSDXZ=0 Q
 . . N BSDX1
 . . S BSDX1=0
 . . F  S BSDX1=$O(^BSDXRES(BSDXSC1,20,BSDX1)) Q:'+BSDX1  Q:BSDXZ=0  D
 . . . Q:'$D(^BSDXRES(BSDXSC1,20,BSDX1,0))
 . . . S BSDXLOC=$P(^BSDXRES(BSDXSC1,20,BSDX1,0),U)
 . . . S BSDXSCIEN=$$SCIEN^BSDU2(BSDXPATID,BSDXLOC,BSDXSTART) I +BSDXSCIEN S BSDXZ=0 Q
 . S BSDXERR="BSDX08: CANCEL^BSDAPI Returned "
 . I BSDXLOC']"" S BSDXZ="0^Unable to find associated RPMS appointment for this patient." Q
 . I '$D(^SC(BSDXLOC,0)) S BSDXZ="0^Unable to find associated RPMS appointment for this patient." Q
 . S BSDXNOD=$G(^SC(BSDXLOC,"S",BSDXSTART,1,BSDXSCIEN,0))
 . I BSDXNOD="" S BSDXZ="0^Unable to find associated RPMS appointment for this patient." Q
 . S BSDXLEN=$P(BSDXNOD,U,2)
 . D APCAN(.BSDXZ,BSDXLOC,BSDXPATID,BSDXSTART,BSDXAPTID,BSDXLEN)
 . Q:+$G(BSDXZ)
 . D AVUPDT(BSDXLOC,BSDXSTART,BSDXLEN)
 . ;L
 ;
 TCOMMIT
 L -^BSDXAPPT(BSDXPATID)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=""_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
AVUPDT(BSDXSCD,BSDXSTART,BSDXLEN) ;Update RPMS Clinic availability
 ;See SDCNP0
 S (SD,S)=BSDXSTART
 S I=BSDXSCD
 Q:'$D(^SC(I,"ST",SD\1,1))
 S SL=^SC(I,"SL"),X=$P(SL,U,3),STARTDAY=$S($L(X):X,1:8),SB=STARTDAY-1/100,X=$P(SL,U,6),HSI=$S(X:X,1:4),SI=$S(X="":4,X<3:4,X:X,1:4),STR="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz",SDDIF=$S(HSI<3:8/HSI,1:2) K Y
 S SL=BSDXLEN
 S S=^SC(I,"ST",SD\1,1),Y=SD#1-SB*100,ST=Y#1*SI\.6+(Y\1*SI),SS=SL*HSI/60
 I Y'<1 F I=ST+ST:SDDIF S Y=$E(STR,$F(STR,$E(S,I+1))) Q:Y=""  S S=$E(S,1,I)_Y_$E(S,I+2,999),SS=SS-1 Q:SS'>0
 S ^SC(BSDXSCD,"ST",SD\1,1)=S
 Q
 ;
APCAN(BSDXZ,BSDXLOC,BSDXDFN,BSDXSD,BSDXAPTID,BSDXLEN)         ;
 ;Cancel appointment for patient BSDXDFN in clinic BSDXSC1
 ;at time BSDXSD
 N BSDXPNOD,BSDXC,DA,DIE,DPTST,DR,%H
 ;save data in case of uncancel (status & appt length)
 S BSDXPNOD=^DPT(BSDXPATID,"S",BSDXSD,0)
 S DPTST=$P(BSDXPNOD,U,2)
 S DIE=9002018.4
 S DA=BSDXAPTID
 S DR=".17///"_DPTST_";"_".18///"_BSDXLEN
 D ^DIE
 S BSDXC("PAT")=BSDXDFN
 S BSDXC("CLN")=BSDXLOC
 S BSDXC("TYP")=BSDXTYP
 S BSDXC("ADT")=BSDXSD
 S %H=$H D YMD^%DTC
 S BSDXC("CDT")=X+%
 S BSDXC("NOT")=BSDXNOT
 S:'+$G(BSDXCR) BSDXCR=14 ;UNKNOWN REASON
 S BSDXC("CR")=BSDXCR
 S BSDXC("USR")=DUZ
 ;
 S BSDXZ=$$CANCEL(.BSDXC)
 Q
 ;
BSDXCAN(BSDXAPTID) ;
 ;Cancel BSDX APPOINTMENT entry
 N %DT,X,BSDXDATE,Y,BSDXIENS,BSDXFDA,BSDXMSG
 S %DT="XT",X="NOW" D ^%DT ; X ^DD("DD")
 S BSDXDATE=Y
 S BSDXIENS=BSDXAPTID_","
 S BSDXFDA(9002018.4,BSDXIENS,.12)=BSDXDATE
 K BSDXMSG
 D FILE^DIE("","BSDXFDA","BSDXMSG")
 Q
 ;
CANEVT(BSDXPAT,BSDXSTART,BSDXSC) ;EP Called by BSDX CANCEL APPOINTMENT event
 ;when appointments cancelled via PIMS interface.
 ;Propagates cancellation to BSDXAPPT and raises refresh event to running GUI clients
 N BSDXFOUND,BSDXRES
 Q:+$G(BSDXNOEV)
 Q:'+$G(BSDXSC)
 S BSDXFOUND=0
 I $D(^BSDXRES("ALOC",BSDXSC)) S BSDXRES=$O(^BSDXRES("ALOC",BSDXSC,0)) S BSDXFOUND=$$CANEVT1(BSDXRES,BSDXSTART,BSDXPAT)
 I BSDXFOUND D CANEVT3(BSDXRES) Q
 I $D(^BXDXRES("ASSOC",BSDXSC)) S BSDXRES=$O(^BSDXRES("ASSOC",BSDXSC,0)) S BSDXFOUND=$$CANEVT1(BSDXRES,BSDXSTART,BSDXPAT)
 I BSDXFOUND D CANEVT3(BSDXRES)
 Q
 ;
CANEVT1(BSDXRES,BSDXSTART,BSDXPAT) ;
 ;Get appointment id in BSDXAPT
 ;If found, call BSDXCAN(BSDXAPPT) and return 1
 ;else return 0
 N BSDXFOUND,BSDXAPPT
 S BSDXFOUND=0
 Q:'+BSDXRES BSDXFOUND
 Q:'$D(^BSDXAPPT("ARSRC",BSDXRES,BSDXSTART)) BSDXFOUND
 S BSDXAPPT=0 F  S BSDXAPPT=$O(^BSDXAPPT("ARSRC",BSDXRES,BSDXSTART,BSDXAPPT)) Q:'+BSDXAPPT  D  Q:BSDXFOUND
 . S BSDXNOD=$G(^BSDXAPPT(BSDXAPPT,0)) Q:BSDXNOD=""
 . I $P(BSDXNOD,U,5)=BSDXPAT,$P(BSDXNOD,U,12)="" S BSDXFOUND=1 Q
 I BSDXFOUND,+$G(BSDXAPPT) D BSDXCAN(BSDXAPPT)
 Q BSDXFOUND
 ;
CANEVT3(BSDXRES) ;
 ;Call RaiseEvent to notify GUI clients
 ;
 N BSDXRESN
 S BSDXRESN=$G(^BSDXRES(BSDXRES,0))
 Q:BSDXRESN=""
 S BSDXRESN=$P(BSDXRESN,"^")
 ;D EVENT^BSDX23("SCHEDULE-"_BSDXRESN,"","","")
 D EVENT^BMXMEVN("BSDX SCHEDULE",BSDXRESN)
 Q
 ;
CANCEL(BSDR) ;EP; called to cancel appt
 ;
 ; Make call using: S ERR=$$CANCEL^BSDAPI(.ARRAY)
 ;
 ; Input Array -
 ; BSDR("PAT") = ien of patient in file 2
 ; BSDR("CLN") = ien of clinic in file 44
 ; BSDR("TYP") = C for canceled by clinic; PC for patient canceled
 ; BSDR("ADT") = appointment date and time
 ; BSDR("CDT") = cancel date and time
 ; BSDR("USR") = user who canceled appt
 ; BSDR("CR")  = cancel reason - pointer to file 409.2
 ; BSDR("NOT") = cancel remarks - optional notes to 160 characters
 ;
 ;Output: error status and message
 ;   = 0 or null:  everything okay
 ;   = 1^message:  error and reason
 ;
 I '$D(^DPT(+$G(BSDR("PAT")),0)) Q 1_U_"Patient not on file: "_$G(BSDR("PAT"))
 I '$D(^SC(+$G(BSDR("CLN")),0)) Q 1_U_"Clinic not on file: "_$G(BSDR("CLN"))
 I ($G(BSDR("TYP"))'="C"),($G(BSDR("TYP"))'="PC") Q 1_U_"Cancel Status error: "_$G(BSDR("TYP"))
 I $G(BSDR("ADT")) S BSDR("ADT")=+$E(BSDR("ADT"),1,12)  ;remove seconds
 I $G(BSDR("ADT"))'?7N1".".4N Q 1_U_"Appt Date/Time error: "_$G(BSDR("ADT"))
 I $G(BSDR("CDT")) S BSDR("CDT")=+$E(BSDR("CDT"),1,12)  ;remove seconds
 I $G(BSDR("CDT"))'?7N1".".4N Q 1_U_"Cancel Date/Time error: "_$G(BSDR("CDT"))
 I '$D(^VA(200,+$G(BSDR("USR")),0)) Q 1_U_"User Who Canceled Appt Error: "_$G(BSDR("USR"))
 I '$D(^SD(409.2,+$G(BSDR("CR")))) Q 1_U_"Cancel Reason error: "_$G(BSDR("CR"))
 ;
 NEW IEN,DIE,DA,DR
 S IEN=$$SCIEN^BSDU2(BSDR("PAT"),BSDR("CLN"),BSDR("ADT"))
 I 'IEN Q 1_U_"Error trying to find appointment for cancel: Patient="_BSDR("PAT")_" Clinic="_BSDR("CLN")_" Appt="_BSDR("ADT")
 ;
 I $$CI^BSDU2(BSDR("PAT"),BSDR("CLN"),BSDR("ADT"),IEN) Q 1_U_"Patient already checked in; cannot cancel until checkin deleted: Patient="_BSDR("PAT")_" Clinic="_BSDR("CLN")_" Appt="_BSDR("ADT")
 ;
 ; remember before status
 NEW SDATA,DFN,SDT,SDCL,SDDA,SDCPHDL
 S DFN=BSDR("PAT"),SDT=BSDR("ADT"),SDCL=BSDR("CLN"),SDMODE=2,SDDA=IEN
 S SDCPHDL=$$HANDLE^SDAMEVT(1),SDATA=SDDA_U_DFN_U_SDT_U_SDCL
 D BEFORE^SDAMEVT(.SDATA,DFN,SDT,SDCL,SDDA,SDCPHDL)
 ;
 ; get user who made appt and date appt made from ^SC
 ;    because data in ^SC will be deleted
 NEW USER,DATE
 S USER=$P($G(^SC(SDCL,"S",SDT,1,IEN,0)),U,6)
 S DATE=$P($G(^SC(SDCL,"S",SDT,1,IEN,0)),U,7)
 ;
 ; update file 2 info
 NEW DIE,DA,DR
 S DIE="^DPT("_DFN_",""S"",",DA(1)=DFN,DA=SDT
 S DR="3///"_BSDR("TYP")_";14///`"_BSDR("USR")_";15///"_BSDR("CDT")_";16///`"_BSDR("CR")_";19///`"_USER_";20///"_DATE
 S:$G(BSDR("NOT"))]"" DR=DR_";17///"_$E(BSDR("NOT"),1,160)
 D ^DIE
 ;
 ; delete data in ^SC
 NEW DIK,DA
 S DIK="^SC("_BSDR("CLN")_",""S"","_BSDR("ADT")_",1,"
 S DA(2)=BSDR("CLN"),DA(1)=BSDR("ADT"),DA=IEN
 D ^DIK
 Q 0
 ;
APPUDEL(BSDXY,BSDXAPTID) ;EP  Undo Cancel
 ;called by BSDX UNCANCEL APPT
 ; BSDXAPTID = ien of appointment in BSDX APPOINTMENT (^BSDXAPPT) file 9002018.4
 N BSDXDAM,BSDXDEC,BSDXI,BSDXNOD,BSDXPATID,BSDXSTART
 S BSDXNOEV=1 ;Don't execute BSDX CANCEL APPOINTMENT protocol
 ;
 D ^XBKVAR S X="ETRAP^BSDX08",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,BSDXI)="T00020ERRORID"_$C(30)
 TSTART
 I '+BSDXAPTID TROLLBACK  D ERR(BSDXI+1,"Invalid Appointment ID.") Q
 I '$D(^BSDXAPPT(BSDXAPTID,0)) TROLLBACK  D ERR(BSDXI+1,"Invalid Appointment ID") Q
 ;Make sure appointment is cancelled
 I $$GET1^DIQ(9002018.4,BSDXAPTID_",",.12)="" TROLLBACK  D ERR(BSDXI+1,"Appointment is not Cancelled.") Q
 ;appts cancelled by patient cannot be uncancelled.
 S BSDXNOD=^BSDXAPPT(BSDXAPTID,0)
 I $P(^DPT($P(BSDXNOD,U,5),"S",$P(BSDXNOD,U,1),0),U,2)="PC" TROLLBACK  D ERR(BSDXI+1,"Cancelled by patient appointment can not be uncancelled.") Q
 ;get appointment data
 S BSDXNOD=^BSDXAPPT(BSDXAPTID,0)
 S BSDXDAM=$P(BSDXNOD,U,9)                  ;date appt made
 S BSDXDEC=$P(BSDXNOD,U,8)                  ;data entry clerk
 S BSDXLEN=$P(BSDXNOD,U,18)                 ;length of appt in minutes
 S BSDXNOTE=$G(^BSDXAPPT(BSDXAPTID,1,1,0))  ;note from BSDX APPOINTMENT
 S BSDXPATID=$P(BSDXNOD,U,5)                ;pointer to VA PATIENT file 2
 S BSDXSC1=$P($G(BSDXNOD),U,7)              ;resource
 S BSDXSTART=$P(BSDXNOD,U)                  ;appt start time
 S BSDXWKIN=$P($G(BSDXNOD),U,13)            ;walkin
 ;lock BSDX node
 L +^BSDXAPPT(BSDXPATID):5 I '$T D ERR(BSDXI+1,"Another user is working with this patient's record.  Please try again later") TROLLBACK  Q
 ;uncancel BSDX APPOINTMENT
 D BSDXUCAN(BSDXAPTID)
 I BSDXSC1]"",$D(^BSDXRES(BSDXSC1,0)) D  I +$G(BSDXZ) S BSDXERR=BSDXERR_$P(BSDXZ,U,2) D ERR(BSDXI,BSDXERR) Q
 . S BSDXNOD=^BSDXRES(BSDXSC1,0)
 . S BSDXLOC=$P(BSDXNOD,U,4) ;HOSPITAL LOCATION
 . Q:'+BSDXLOC
 . ;uncancel patient appointment and re-instate clinic appointment
 . S BSDXZ=""
 . D APUCAN(.BSDXZ,BSDXLOC,BSDXPATID,BSDXSTART,BSDXDAM,BSDXDEC,BSDXLEN,BSDXNOTE,BSDXSC1,BSDXWKIN)
 TCOMMIT
 L -^BSDXAPPT(BSDXPATID)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=""_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
BSDXUCAN(BSDXAPTID) ;called internally to update BSDX APPOINTMENT by clearing cancel date/time
 S BSDXIENS=BSDXAPTID_","
 S BSDXFDA(9002018.4,BSDXIENS,.12)=""
 K BSDXMSG
 D FILE^DIE("","BSDXFDA","BSDXMSG")
 Q
 ;
APUCAN(BSDXZ,BSDXLOC,BSDXPATID,BSDXSTART,BSDXDAM,BSDXDEC,BSDXLEN,BSDXNOTE,BSDXRES,BSDXWKIN)         ;
 ;unCancel appointment for patient BSDXDFN in clinic BSDXSC1
 ;  BSDXLOC   = pointer to hospital location ^SC file 44
 ;  BSDXPATID = pointer to VA Patient ^DPT file 2
 ;  BSDXSTART = Appointment time
 ;  BSDXDAM   = Date appointment made in FM format
 ;  BSDXDEC   = Data entry clerk - pointer to NEW PERSON file 200
 N BSDXC,%H
 S BSDXC("PAT")=BSDXPATID
 S BSDXC("CLN")=BSDXLOC
 S BSDXC("ADT")=BSDXSTART
 S BSDXC("NOTE")=BSDXNOTE  ;user note
 S BSDXC("RES")=BSDXRES
 S BSDXC("USR")=DUZ
 S BSDXC("LEN")=BSDXLEN
 S BSDXC("WKIN")=BSDXWKIN
 ;
 S BSDXZ=$$UNCANCEL(.BSDXC)
 Q
 ;
UNCANCEL(BSDR) ;PEP; called to ucancel appt
 ;
 ; Make call using: S ERR=$$UNCANCEL(.ARRAY)
 ;
 ; Input Array -
 ; BSDR("PAT") = ien of patient in file 2
 ; BSDR("CLN") = ien of clinic in file 44
 ; BSDR("ADT") = appointment date and time
 ; BSDR("USR") = user who uncanceled appt
 ; BSDR("NOTE") = appointment note from BSDX APPOINTMENT
 ; BSDR("LEN") = appt length in minutes (numeric)
 ; BSDR("RES") = resource
 ; BSDR("WKIN")= walkin
 ;
 ;Output: error status and message
 ;   = 0 or null:  everything okay
 ;   = 1^message:  error and reason
 ;
 N DPTNOD,DPTNODR
 I '$D(^DPT(+$G(BSDR("PAT")),0)) Q 1_U_"Patient not on file: "_$G(BSDR("PAT"))
 I '$D(^SC(+$G(BSDR("CLN")),0)) Q 1_U_"Clinic not on file: "_$G(BSDR("CLN"))
 I $G(BSDR("ADT")) S BSDR("ADT")=+$E(BSDR("ADT"),1,12)  ;remove seconds
 I $G(BSDR("ADT"))'?7N1".".4N Q 1_U_"Appt Date/Time error: "_$G(BSDR("ADT"))
 I '$D(^VA(200,+$G(BSDR("USR")),0)) Q 1_U_"User Who Canceled Appt Error: "_$G(BSDR("USR"))
 ;
 S BSDXERR=$$APPRPMS^BSDX07(BSDR("LEN"),BSDR("NOTE"),BSDR("PAT"),BSDR("RES"),BSDR("ADT"),BSDR("WKIN"))
 Q BSDXERR
 ;
ERR(BSDXI,BSDXERR) ;Error processing
 S BSDXI=BSDXI+1
 S BSDXERR=$TR(BSDXERR,"^","~")
 TROLLBACK
 S ^BSDXTMP($J,BSDXI)=BSDXERR_$C(30)
 S BSDXI=BSDXI+1
 S ^BSDXTMP($J,BSDXI)=$C(31)
 L
 Q
 ;
ETRAP ;EP Error trap entry
 D ^%ZTER
 I '$D(BSDXI) N BSDXI S BSDXI=999999
 S BSDXI=BSDXI+1
 D ERR(BSDXI,"BSDX08 Error: "_$G(%ZTERROR))
 Q
