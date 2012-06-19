BSDAPI ; IHS/ANMC/LJF - SCHEDULING APIs ;  [ 03/08/2004  10:36 AM ]
 ;;5.3;PIMS;**1002,1003,1006,1010,1012**;MAY 28, 2004
 ;IHS/ITSC/LJF 12/23/2004 PATCH 1002 removed PEP from CHECKIN entry point
 ;             04/22/2005 PATCH 1003 added code to handle call from BSDAPI4
 ;IHS/OIT/LJF  10/18/2006 PATCH 1006 now allow 240 minute appts as DD does
 ;cmi/anch/maw 10/20/2008 PATCH 1010 RQMT69 added FUTURE PEP function to return whether patient has a future appointment
 ;cmi/flag/maw 02/18/2010 PATCH 1012 added check of data in DPT node when cancelling an appointment
 ;
MAKE(BSDR) ;PEP; call to store appt made
 ;
 ; Make call using: S ERR=$$MAKE^BSDAPI(.ARRAY)
 ;
 ; Input Array -
 ; BSDR("PAT") = ien of patient in file 2
 ; BSDR("CLN") = ien of clinic in file 44
 ; BSDR("TYP") = 3 for scheduled appts, 4 for walkins
 ; BSDR("ADT") = appointment date and time
 ; BSDR("LEN") = appointment length in minutes (5-120)
 ; BSDR("OI")  = reason for appt - up to 150 characters
 ; BSDR("USR") = user who made appt
 ;
 ;Output: error status and message
 ;   = 0 or null:  everything okay
 ;   = 1^message:  error and reason
 ;
 I '$D(^DPT(+$G(BSDR("PAT")),0)) Q 1_U_"Patient not on file: "_$G(BSDR("PAT"))
 I '$D(^SC(+$G(BSDR("CLN")),0)) Q 1_U_"Clinic not on file: "_$G(BSDR("CLN"))
 I ($G(BSDR("TYP"))<3)!($G(BSDR("TYP"))>4) Q 1_U_"Appt Type error: "_$G(BSDR("TYP"))
 I $G(BSDR("ADT")) S BSDR("ADT")=+$E(BSDR("ADT"),1,12)  ;remove seconds
 I $G(BSDR("ADT"))'?7N1".".4N Q 1_U_"Appt Date/Time error: "_$G(BSDR("ADT"))
 ;
 ;IHS/OIT/LJF 10/18/2006 PATCH 1006 DD now allows 240 minutes
 ;I ($G(BSDR("LEN"))<5)!($G(BSDR("LEN"))>120) Q 1_U_"Appt Length error: "_$G(BSDR("LEN"))
 I ($G(BSDR("LEN"))<5)!($G(BSDR("LEN"))>240) Q 1_U_"Appt Length error: "_$G(BSDR("LEN"))
 I '$D(^VA(200,+$G(BSDR("USR")),0)) Q 1_U_"User Who Made Appt Error: "_$G(BSDR("USR"))
 I $D(^DPT(BSDR("PAT"),"S",BSDR("ADT"),0)),$P(^(0),U,2)'="C" Q 1_U_"Patient "_BSDR("PAT")_" already has appt at "_BSDR("ADT")
 ;
 NEW DIC,DA,Y,X,DD,DO,DLAYGO
 ;
 I $D(^DPT(BSDR("PAT"),"S",BSDR("ADT"),0)),$P(^(0),U,2)="C" D
 . ; "un-cancel" existing appt in file 2
 . N BSDXFDA,BSDXIENS,BSDXMSG
 . S BSDXIENS=BSDR("ADT")_","_BSDR("PAT")_","
 . S BSDXFDA(2.98,BSDXIENS,".01")=BSDR("CLN")
 . S BSDXFDA(2.98,BSDXIENS,"3")=""
 . S BSDXFDA(2.98,BSDXIENS,"9")=BSDR("TYP")
 . S BSDXFDA(2.98,BSDXIENS,"9.5")=9
 . S BSDXFDA(2.98,BSDXIENS,"14")=""
 . S BSDXFDA(2.98,BSDXIENS,"15")=""
 . S BSDXFDA(2.98,BSDXIENS,"16")=""
 . S BSDXFDA(2.98,BSDXIENS,"19")=""
 . S BSDXFDA(2.98,BSDXIENS,"20")=$$NOW^XLFDT
 . D FILE^DIE("","BSDXFDA","BSDXMSG")
 . N BSDXTEMP S BSDXTEMP=$G(BSDXMSG)
 ;E  D  I Y<1 Q 1_U_"FileMan add to DPT error: Patient="_BSDR("PAT")_" Appt="_BSDR("ADT")  ;cmi/maw 9/9/2008 orig line PATCH 1010
 E  D  I $G(BSDXERR(1)) Q 1_U_"FileMan add to DPT error: Patient="_BSDR("PAT")_" Appt="_BSDR("ADT")  ;cmi/maw 9/9/2008 new line patch 1010
 . ; add appt to file 2
 . ;cmi/maw 9/9/2008 changed call to silent server call PATCH 1010
 . N BSDXFDA,BSDXIENS,BSDXMSG
 . S BSDXIENS="?+2,"_BSDR("PAT")_","
 . S BSDXIENS(2)=BSDR("ADT")
 . S BSDXFDA(2.98,BSDXIENS,.01)=BSDR("CLN")
 . S BSDXFDA(2.98,BSDXIENS,"9")=BSDR("TYP")
 . S BSDXFDA(2.98,BSDXIENS,"9.5")=9
 . S BSDXFDA(2.98,BSDXIENS,"20")=$$NOW^XLFDT
 . D UPDATE^DIE("","BSDXFDA","BSDXIENS","BSDXERR(1)")
 . ;S DIC="^DPT("_BSDR("PAT")_",""S"",",DA(1)=BSDR("PAT"),X=BSDR("CLN")  ;cmi/maw 9/9/2008 orig line
 . ;S DIC("DR")="9///"_BSDR("TYP")_";9.5///9;20///"_$$NOW^XLFDT  ;cmi/maw 9/9/2008 orig line
 . ;S DIC("P")="2.98P",DIC(0)="L",DLAYGO=2.98,DINUM=BSDR("ADT")  ;cmi/maw 9/9/2008 orig line
 . ;K DD,DO  ;cmi/maw 9/9/2008 orig line
 . ;D FILE^DICN  ;cmi/maw 9/9/2008 orig line
 ;
 ;
 ; add appt to file 44
 K DIC,DA,X,Y,DLAYGO,DD,DO
 I '$D(^SC(BSDR("CLN"),"S",0)) S ^SC(BSDR("CLN"),"S",0)="^44.001DA^^"
 I '$D(^SC(BSDR("CLN"),"S",BSDR("ADT"),0)) D  I Y<1 Q 1_U_"Error adding date to file 44: Clinic="_BSDR("CLN")_" Date="_BSDR("ADT")
 . S DIC="^SC("_BSDR("CLN")_",""S"",",DA(1)=BSDR("CLN"),(X,DINUM)=BSDR("ADT")
 . S DIC("P")="44.001DA",DIC(0)="L",DLAYGO=44.001
 . S Y=1 I '$D(@(DIC_X_")")) D FILE^DICN
 ;
 K DIC,DA,X,Y,DLAYGO,DD,DO,DINUM
 S DIC="^SC("_BSDR("CLN")_",""S"","_BSDR("ADT")_",1,"
 S DA(2)=BSDR("CLN"),DA(1)=BSDR("ADT"),X=BSDR("PAT")
 ;S DIC("DR")="1///"_BSDR("LEN")_";3///"_$E($G(BSDR("OI")),1,150)_";7///`"_BSDR("USR")_";8///"_$$NOW^XLFDT  ;cmi/maw 9/19/2008 orig line
 S DIC("DR")="1///"_BSDR("LEN")_";3///"_$E($G(BSDR("OI")),1,150)_";7////"_BSDR("USR")_";8////"_$$NOW^XLFDT  ;cmi/maw 9/19/2008 mod line PATCH 1010
 S DIC("P")="44.003PA",DIC(0)="L",DLAYGO=44.003
 D FILE^DICN
 ;
 ; call event driver
 NEW DFN,SDT,SDCL,SDDA,SDMODE
 S DFN=BSDR("PAT"),SDT=BSDR("ADT"),SDCL=BSDR("CLN"),SDMODE=2
 S SDDA=$$SCIEN^BSDU2(BSDR("PAT"),BSDR("CLN"),BSDR("ADT"))
 D MAKE^SDAMEVT(DFN,SDT,SDCL,SDDA,SDMODE)
 Q 0
 ;
CHECKIN(BSDR) ;EP; call to add checkin info to appt; IHS/ITSC/LJF 12/23/2004 PATCH 1002
 ; PATCH 1002 - entry point no longer public; other apps must call GETVISIT^BSDAPI4
 ;
 ; Make call by using:  S ERR=$$CHECKIN^BSDAPI(.ARRAY)
 ;
 ; Input array -
 ;  BSDR("PAT") = ien of patient in file 2
 ;  BSDR("CLN") = ien of clinic in file 44
 ;  BSDR("ADT") = appt date/time
 ;  BSDR("CDT") = checkin date/time
 ;  BSDR("USR") = checkin user
 ;  BSDR("OPT") = option used to create visit (optional)
 ;
 ;IHS/ITSC/LJF 4/22/2005 PATCH 1003 new variable sent from BSDAPI4
 ;  BSDR("VIEN") = visit IEN (sent if new visit is NOT to be created)
 ;
 ; variables to create visit under event driver
 ;  BSDR("CC")  = clinic code for creating visit - optional
 ;  BSDR("PRV") = visit provider - pointer to file 200
 ;
 ; Output value -
 ;              = 0 means everything worked
 ;              = 1^message means error with reason message
 ;
 I '$D(^DPT(+$G(BSDR("PAT")),0)) Q 1_U_"Patient not on file: "_$G(BSDR("PAT"))
 I '$D(^SC(+$G(BSDR("CLN")),0)) Q 1_U_"Clinic not on file: "_$G(BSDR("CLN"))
 I $G(BSDR("ADT")) S BSDR("ADT")=+$E(BSDR("ADT"),1,12)  ;remove seconds
 I $G(BSDR("ADT"))'?7N1".".4N Q 1_U_"Appt Date/Time error: "_$G(BSDR("ADT"))
 I $G(BSDR("CDT")) S BSDR("CDT")=+$E(BSDR("CDT"),1,12)  ;remove seconds
 I $G(BSDR("CDT"))'?7N1".".4N Q 1_U_"Checkin Date/Time error: "_$G(BSDR("CDT"))
 I '$D(^VA(200,+$G(BSDR("USR")),0)) Q 1_U_"User Who Made Appt Error: "_$G(BSDR("USR"))
 ;
 ; find ien for appt in file 44
 NEW IEN,DIE,DA,DR
 S IEN=$$SCIEN^BSDU2(BSDR("PAT"),BSDR("CLN"),BSDR("ADT"))
 I 'IEN Q 1_U_"Error trying to find appointment for checkin: Patient="_BSDR("PAT")_" Clinic="_BSDR("CLN")_" Appt="_BSDR("ADT")
 ;
 ; remember before status
 NEW SDATA,DFN,SDT,SDCL,SDDA,SDCIHDL
 S DFN=BSDR("PAT"),SDT=BSDR("ADT"),SDCL=BSDR("CLN"),SDMODE=2,SDDA=IEN
 S SDCIHDL=$$HANDLE^SDAMEVT(1),SDATA=SDDA_U_DFN_U_SDT_U_SDCL
 D BEFORE^SDAMEVT(.SDATA,DFN,SDT,SDCL,SDDA,SDCIHDL)
 ;
 ; set checkin
 S DIE="^SC("_BSDR("CLN")_",""S"","_BSDR("ADT")_",1,"
 S DA(2)=BSDR("CLN"),DA(1)=BSDR("ADT"),DA=IEN
 S DR="309///"_BSDR("CDT")_";302///`"_BSDR("USR")_";305///"_$$NOW^XLFDT
 D ^DIE
 ;
 ; set after status
 S SDDA=$$SCIEN^BSDU2(BSDR("PAT"),BSDR("CLN"),BSDR("ADT"))
 S SDCIHDL=$$HANDLE^SDAMEVT(1),SDATA=SDDA_U_DFN_U_SDT_U_SDCL
 D AFTER^SDAMEVT(.SDATA,DFN,SDT,SDCL,SDDA,SDCIHDL)
 ;
 ;IHS/ITSC/LJF 4/22/2005 PATCH 1003 set visit variable if not creating new visit
 ;                                  event driver kills variable after all protocols run
 I $G(BSDR("VIEN")) S BSDVSTN=BSDR("VIEN")
 ;
 ; call event driver
 D EVT^SDAMEVT(.SDATA,4,SDMODE,SDCIHDL)
 Q 0
 ;
CANCEL(BSDR) ;PEP; called to cancel appt
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
 I $D(^DPT(DFN,"S",SDT)) D  ;cmi/maw 02/18/2010 allows cancellation to continue if DPT node missing
 . NEW DIE,DA,DR
 . S DIE="^DPT("_DFN_",""S"",",DA(1)=DFN,DA=SDT
 . S DR="3///"_BSDR("TYP")_";14///`"_BSDR("USR")_";15///"_BSDR("CDT")_";16///`"_BSDR("CR")_";19///`"_USER_";20///"_DATE
 . S:$G(BSDR("NOT"))]"" DR=DR_";17///"_$E(BSDR("NOT"),1,160)
 . D ^DIE
 ;
 ; delete data in ^SC
 NEW DIK,DA
 S DIK="^SC("_BSDR("CLN")_",""S"","_BSDR("ADT")_",1,"
 S DA(2)=BSDR("CLN"),DA(1)=BSDR("ADT"),DA=IEN
 D ^DIK
 ;
 ; call event driver
 D CANCEL^SDAMEVT(.SDATA,DFN,SDT,SDCL,SDDA,SDMODE,SDCPHDL)
 Q 0
 ;
FUTURE(BSDPAT) ;PEP - PATCH 1010 RQMT69 API that returns 1 if patient has a future appointment or 0 if not DFN is passed in
 N BSDDA,BSDFUT
 S BSDFUT=0
 S BSDDA=0 F  S BSDDA=$O(^DPT(BSDPAT,"S",BSDDA)) Q:'BSDDA  D
 . I BSDDA>DT S BSDFUT=1
 Q $G(BSDFUT)
 ;
