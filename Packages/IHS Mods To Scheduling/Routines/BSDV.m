BSDV ; IHS/ANMC/LJF - CREATE VISIT AT CHECK-IN ;  
 ;;5.3;PIMS;**1003,1007,1009,1012**;DEC 01, 2006
 ;IHS/ITSC/LJF 04/22/2005 PATCH 1003 code changed to use new Visit Creation API
 ;                                   updated code to adjust visit pointers in PE file
 ;             07/06/2005 PATCH 1003 fixed clinic code so alpha-numeric codes work as defaults
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added code in VISIT to screen on phone in check in
 ;cmi/anch/maw 05/09/2008 PATCH 1009 requirement 65 added code in CHKIN,VSTUPD to show other info if site parameter is setup, allow edit of clinic,provider
 ;cmi/anch/maw 06/10/2008 PATCH 1009 requirement 58 visit API enhancements, add check of existing visits at checkin
 ;
CHKIN(BSDEVT,BSDCLN,BSDDT,APTN,DFN) ;EP; -- ask visit related check-in questions
 ; called by Scheduling Event driver
 ; user interface for 2 questions (clinic code and provider)
 ; Input variables:
 ;      BSDEVT = type of event (4=checkin)
 ;      BSDCLN = clinic ien
 ;      BSDDT  = appt date/time
 ;      APTN   = ien for appt under date mutiple
 ;      DFN    = patient ien
 ;
 Q:$G(BSDEVT)'=4  ;quit if not a checkin
 Q:'$G(DFN)  Q:'$G(BSDCLN)  Q:'$G(BSDDT)  Q:'$G(APTN)
 I $$GET1^DIQ(9009017.2,+BSDCLN,.09)'="YES" Q  ;don't create visit
 ;
 ; if patient already checked in, use VDATE code
 I $P(SDATA("BEFORE","STATUS"),U,4)]"" D  Q
 . NEW BSDMSG
 . D VDATE(BSDEVT,BSDCLN,BSDDT,APTN,DFN,$P(SDATA("BEFORE","STATUS"),U,4),.BSDMSG)
 . D VSTUPD(BSDCLN,BSDDT,APTN,DFN,.BSDMSG)
 . ;
 . ; display any messages (error messages in reverse video)
 . I $D(BSDMSG) D
 .. NEW I F I=1:1 Q:'$D(BSDMSG(I))  D
 ... I $P(BSDMSG(I),U)>0,$G(IORVON) D MSG(IORVON_$P(BSDMSG(I),U,2)_IORVOFF,1,0),PAUSE^BDGF Q
 ... D MSG($P(BSDMSG(I),U,2),1,0)
 ;
 ;
 Q:'$G(^SC(+BSDCLN,"S",BSDDT,1,APTN,"C"))  ;not checked-in
 ;
 NEW BSDCC,BSDVP,BSDMSG
 ;cmi/anch/maw 5/9/2008 PATCH 1009 rqmt 65 show other info if site param set to yes
 I BSDCLN,$O(^BSDSC("B",BSDCLN,0)) D
 . N BSDOI,BSDOIA
 . S BSDOI=$O(^BSDSC("B",BSDCLN,0))
 . Q:'$P($G(^BSDSC(BSDOI,0)),U,13)  ;quit if not a multiple code clinic
 . Q:'$P($G(^BSDSC(BSDOI,0)),U,17)  ;quit if other info is set to no
 . S BSDOIA=$$OI^BSDAM(BSDCLN,BSDDT,APTN,DFN)  ;show/allow edit of other info
 ;cmi/anch/maw 5/9/2008 PATCH 1009 end of mods
 S BSDCC=$$CLNCODE(BSDCLN)        ;ask clinic code
 S BSDVP=$$PROV(BSDCLN)           ;ask visit provider
 ;
 ;IHS/ITSC/LJF 5/4/2005 PATCH 1003 add call to new API - GETVISIT^BSDAPI4
 NEW BSDVAR,BSDOUT
 S BSDVAR("NEVER ADD")=1              ;first time through just check for matches
 D SETVAR                             ;set basic variables for API call
 D GETVISIT^BSDAPI4(.BSDVAR,.BSDOUT)   ;call new API
 K BSDVAR
 I BSDOUT(0)=1 S BSDVSTN=$O(BSDOUT(0))         ;if match found, set visit IEN
 ;IHS/ITSC/LJF 5/4/2005 end of PATCH 1003 mods
 ;
 D VISIT(BSDCLN,BSDDT,APTN,DFN,BSDCC,BSDVP,.BSDMSG)   ;create visit call
 ;
 I $D(BSDMSG) D
 . NEW I F I=1:1 Q:'$D(BSDMSG(I))  D MSG($P(BSDMSG(I),U,2),1,0)
 . D PAUSE^BDGF
 Q
 ;
VISIT(BSDCLN,BSDDT,APTN,DFN,BSDCC,BSDPROV,BSDOPT,BSDMSG) ;EP; -- create visit
 ;IHS/ITSC/LJF 4/22/2005 PATCH 1003 code rewritten to call new Visit Creation API (BSDAPI4)
 ;
 ; called by CHKIN subroutine above and by applications where
 ; all data is already known
 ; silent update to database; no user interface
 ; Input variables:
 ;      BSDCLN  = clinic ien
 ;      BSDDT   = appt date/time
 ;      APTN    = ien for appt under date mutiple
 ;      DFN     = patient ien
 ;      BSDCC   = clinic code ien
 ;      BSDPROV = visit provider ien
 ;      BSDOPT  = option used to create visit (optional) ;IHS/ITSC/LJF 9/18/2003 new variable
 ;      BSDMSG  = called by reference, upon exit contains user msgs
 ;                first piece is error code; 2nd piece is message
 ;                Error = 0 (no problems)
 ;                        1 (problem setting visit variables)
 ;                        2 (problem creating visit)
 ;                        3 (problem changing visit date/time)
 ;
 Q:'$G(BSDCLN)  Q:'$G(BSDDT)  Q:'$G(APTN)  Q:'$G(DFN)
 Q:'$G(BSDCC)
 I $$GET1^DIQ(9009017.2,+BSDCLN,.09)'="YES" Q  ;don't create visit
 Q:'$G(^SC(+BSDCLN,"S",BSDDT,1,APTN,"C"))  ;not checked-in
 ;
 ;
 ;IHS/ITSC/LJF 4/28/2005 PATCH 1003
 I $G(BSDVSTN) D PROVUPD,HOSLUPD Q   ;if have visit already, update providers & clinic then quit
 ;
 ; else create visit, add provider and create VCN
 NEW BSDVAR,BSDRET
 ;S BSDVAR("FORCE ADD")=1  ;cmi/maw 6/10/2008 don't force add unless we don't find a matching visit
 D SETVAR
 S BSDVAR("APCDAPPT")=$S($P(^DPT(DFN,"S",BSDDT,0),U,7)=3:"A",$P(^DPT(DFN,"S",BSDDT,0),U,7)=4:"W",1:"U")    ;walk-in vs appt
 ;
 I "CT"[BSDVAR("SRV CAT") K BSDVAR("APCDAPPT")  ;IHS/OIT/LJF 11/17/2006 PATCH 1007 not needed for phone calls & chart reviews
 ;
 I $G(BSDOPT)]"" S BSDVAR("APCDOPT")=$O(^DIC(19,"B",BSDOPT,0))  ;option used
 E  S BSDVAR("APCDOPT")=$O(^DIC(19,"B","SD IHS PCC LINK",0))
 ;
 S BSDVAR("SHOW VISITS")=1  ;cmi/maw 6/10/2008 PATCH 1009 variable to show visits to link to
 S BSDVAR("CALLER")="BSD CHECKIN"  ;cmi/maw 6/10/2008 PATCH 1009 add variable that shows who the caller is for API to do something
 D GETVISIT^BSDAPI4(.BSDVAR,.BSDRET)
 ;
 ;cmi/maw 6/10/2008 PATCH 1009 requirement 58 added/modified next 4 lines
 I BSDRET(0)>1 D
 . D SELECT^BSDAPI5(.BSDVAR,.BSDRET)
 I '$G(BSDR("VIEN")) D
 . S BSDVAR("FORCE ADD")=1
 . D GETVISIT^BSDAPI4(.BSDVAR,.BSDRET)
 ;I BSDRET(0)'=1 D  D VSTEND Q
 ;. D MSGADD(2,"VISIT ERROR, Please notify your supervisor!")
 D MSGADD(0,"Visit Attached/Created.")
 ;S BSDVSTN=APCDALVR("APCDVSIT")
 S BSDVSTN=$O(BSDRET(0))
 I $G(BSDR("VIEN")) S BSDVSTN=BSDR("VIEN")  ;cmi/maw 6/10/2008 set to selected visit variable if there
 ;IHS/ITSC/LJF 4/28/2005 PATCH 1003 end of rewritten code
 ;
 ; -- add provider to visit
 I $G(BSDPROV) D
 . K APCDALVR
 . S APCDALVR("APCDTPRO")="`"_BSDPROV
 . S APCDALVR("APCDPAT")=DFN
 . S APCDALVR("APCDVSIT")=BSDVSTN
 . S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 . S APCDALVR("APCDTPS")="P",APCDALVR("APCDTOA")=""
 . D ^APCDALVR
 . D MSGADD(0,"Provider added to visit.")
 ;
 ; -- create VCN and add to visit
 S BSDVCN="" I $T(VCN^AUPNVSIT)]"" S BSDVCN=$$VCN^AUPNVSIT(BSDVSTN,1)
 ;
 ;DO NOT KILL BSDVSTN, BSDVCN OR BSDOPT; KILLED AT END OF EVENT DRIVER
VSTEND D EN1^APCDEKL,EN2^APCDEKL K APCDALVR,X
 Q
 ;
VDATE(BSDEVT,BSDCLN,BSDDT,APTN,DFN,BSDCKO,BSDMSG) ;EP
 ;if new time entered, update visit
 ; called by Scheduling Event Driver; use if check-in time was changed
 ; silent update to database; no user interface
 ; Input variables:
 ;    BSDEVT    =  type of event (4=checkin)
 ;    BSDCLN    =  clinic ien
 ;    BSDDT     =  appt date & time
 ;    APTN      =  ien for appt under date multiple
 ;    DFN       =  Patient ien
 ;    BSDCKO    =  old check-in date/time
 ;    BSDMSG    =  called by reference, upon exit contains user msgs
 ;
 Q:$G(BSDEVT)'=4   ;quit if not a checkin
 I $$GET1^DIQ(9009017.2,+BSDCLN,.09)'="YES" Q  ;don't create visit
 NEW APCDVSIT,BSDCK
 ;
 ; find visit based on old check-in time
 S APCDVSIT=$O(^AUPNVSIT("AA",DFN,$$RDT(BSDCKO),0)) Q:'APCDVSIT
 I $O(^AUPNVSIT("AA",DFN,$$RDT(BSDCKO),APCDVSIT)) D MSGADD(4,"More than 1 visit for date/time; visit must be updated manually.") Q
 ;
 ; get new check-in time
 S BSDCK=$G(^SC(BSDCLN,"S",BSDDT,1,APTN,"C")) Q:BSDCK=BSDCKO
 ;
 ;delete visit if check-in date deleted and visit not yet coded
 I 'BSDCK D  Q
 . ;
 . ;IHS/ITSC/LJF 5/4/2005 PATCH 1003 delete OE file visit pointer
 . NEW OEN,OENV
 . S OEN=$P(^DPT(DFN,"S",BSDDT,0),U,20) I OEN D
 . . S OENV=$$GET1^DIQ(409.68,+OEN,.05,"I")
 . . I OENV S DIE="^SCE(",DA=OEN,DR=".05///@" D ^DIE
 . ;
 . ; don't delete visit if another appt points to it in OE file
 . I $G(OENV) Q:$O(^SCE("AVSIT",OENV,0))
 . ; end of PATCH 1003 change
 . ;
 . NEW DEP S APCDVDLT=APCDVSIT,DEP=+$$GET1^DIQ(9000010,APCDVSIT,.09)
 . I (DEP=0)!((DEP=1)&($O(^AUPNVPRV("AD",APCDVSIT,0)))) D ^APCDVDLT Q
 . NEW DIE,DA,DR S DIE=9000010,DA=APCDVSIT
 . S DR="81101///SCHED COULD NOT DELETE VISIT WHEN CHECKIN DELETED"
 . D ^DIE
 ;
 ;if visit date/time does NOT match new check-in date/time, modify it 
 I $$GET1^DIQ(9000010,APCDVSIT,.01,"I")'=BSDCK D
 . S APCDCVDT("VISIT DFN")=APCDVSIT
 . S APCDCVDT("VISIT DATE/TIME")=BSDCK
 . D ^APCDCVDT
 . I $D(APCDCVDT("ERROR FLAG")) D MSGADD(3,"Changing visit date/time failed.  Please notify your supervisor.") Q
 . K APCDCVDT
 . D MSGADD(0,"Visit Date/Time Updated.")
 Q
 ;
 ;
 ; subroutines called by entry points above
 ;
RDT(X) ; -- reverse date
 Q 9999999-$P(X,".")_"."_$P(X,".",2)
 ;
CLNCODE(CLINIC) ; -- asks user for clinic code
 NEW Y,DIR,CODE
 F  Q:$G(Y)>0  D
 . S DIR(0)="P^40.7:EMZQ",DIR("A")="CLINIC CODE for VISIT"
 . S CODE=$$GET1^DIQ(40.7,+$$GET1^DIQ(44,CLINIC,8,"I"),1)  ;code #
 . ;do not set default if multiple clinic codes used in clinic
 . ;I CODE,$$GET1^DIQ(9009017.2,CLINIC,.13)'="YES" S DIR("B")=CODE
 . I CODE]"",$$GET1^DIQ(9009017.2,CLINIC,.13)'="YES" S DIR("B")=CODE  ;IHS/ITSC/LJF 7/6/2005 PATCH 1003
 . S DIR("?")="This is required.  Please try again"
 . D ^DIR
 Q +Y
 ;
PROV(CLINIC) ; - asks user for visit provider
 NEW DIC,X,Y
 F  Q:($G(Y)>0)  D
 . S DIC=200,DIC(0)="AMEQZ",DIC("A")="VISIT PROVIDER:  "
 . S DIC("B")=$$GET1^DIQ(200,+$$PRV^BSDU(CLINIC),.01)
 . I DIC("B")="" K DIC("B")
 . S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 . D ^DIC K DIC
 . I Y<1,$$GET1^DIQ(9009017.2,CLINIC,.14)'="YES" S Y="1^QUIT" Q
 . I Y<1 D MSG("This is required.  Please try again.",1,0)
 I $P(Y,U,2)="QUIT" Q 0
 Q $$PRVIEN(+Y)
 ;
PRVIEN(Y) ; -- determines correct provider file to use
 I $P(^DD(9000010.06,.01,0),U,2)["200" Q +Y
 Q $P(^VA(200,+Y,0),U,16)
 ;
 ;
MSGADD(ERROR,STRING) ; -- put message string into array
 NEW I
 S I=$O(BSDMSG(""),-1)+1   ;get next subscript
 S BSDMSG(I)=ERROR_U_STRING
 Q
 ;
MSG(DATA,PRE,POST) ; -- writes line to device
 NEW I,FORMAT
 S FORMAT="" I PRE>0 F I=1:1:PRE S FORMAT=FORMAT_"!"
 D EN^DDIOL(DATA,"",FORMAT)
 I POST>0 F I=1:1:POST D EN^DDIOL("","","!")
 Q
 ;
FAC(CLINIC) ; -- return facility location ien for clinic
 ; try institution field in file 44, then institution based on division
 ; then try user's division and make sure it is a PCC site
 NEW FAC
 S FAC=$$GET1^DIQ(44,CLINIC,3,"I")
 I 'FAC S FAC=$$GET1^DIQ(40.8,+$$GET1^DIQ(44,BSDCLN,3.5,"I"),.07,"I")
 I 'FAC S FAC=$G(DUZ(2))
 I '$D(^APCDSITE(+FAC)) S FAC=0
 Q FAC
 ;
SERCAT(CLINIC,PAT) ;EP; -- returns service category for visit
 NEW CLNCAT
 I $G(^DPT(PAT,.1))]"" Q "I"                       ;in hospital if inpt
 S CLNCAT=$$GET1^DIQ(9009017.2,CLINIC,.12,"I")     ;clinic's ser cat
 Q $S(CLNCAT]"":CLNCAT,1:"A")
 ;
VSTUPD(BSDCLN,BSDDT,APTN,DFN,BSDMSG) ; interactive updating of visit data during ckeck-in edit
 ; if check in time different, update visit if there is one
 NEW BSDCK,AUPNVSIT,DIE,DA,DR,VPROV
 ; get new check-in time
 S BSDCK=+$G(^SC(BSDCLN,"S",BSDDT,1,APTN,"C")) Q:'BSDCK
 ;
 ; find visit based on new check-in time
 S AUPNVSIT=$O(^AUPNVSIT("AA",DFN,$$RDT(BSDCK),0)) Q:'AUPNVSIT
 I $O(^AUPNVSIT("AA",DFN,$$RDT(BSDCK),AUPNVSIT)) D MSGADD(4,"More than 1 visit for date/time; visit must be updated manually.") Q
 ;
 ;cmi/anch/maw 5/9/2008 PATCH 1009 rqmt 65 show other info if site param set to yes
 I BSDCLN,$O(^BSDSC("B",BSDCLN,0)) D
 . N BSDOI,BSDOIA
 . S BSDOI=$O(^BSDSC("B",BSDCLN,0))
 . Q:'$P($G(^BSDSC(BSDOI,0)),U,13)  ;quit if not a multiple code clinic
 . Q:'$P($G(^BSDSC(BSDOI,0)),U,17)  ;quit if other info is set to no
 . S BSDOIA=$$OI^BSDAM(BSDCLN,BSDDT,APTN,DFN)  ;show/allow edit of other info
 ;cmi/anch/maw 5/9/2008 PATCH 1009 end of mods
 ; update visit clinic and option used to create
 S DIE=9000010,DA=AUPNVSIT,DR=".08;.24///SD IHS PCC LINK" D ^DIE,MOD^AUPNVSIT
 ;
 ; if visit already has provider, edit it
 NEW DA,DIE,DR
 S DA=$O(^AUPNVPRV("AD",AUPNVSIT,0)) I DA D  Q
 . S DIE=9000010.06,DR=".01" D ^DIE,MOD^AUPNVSIT
 ;
 ; else, add v provider entry
 NEW VPROV S VPROV=$$PROV(BSDCLN) I VPROV>0 D
 . NEW APCDALVR
 . S APCDALVR("APCDTPRO")="`"_VPROV
 . S APCDALVR("APCDPAT")=DFN
 . S APCDALVR("APCDVSIT")=AUPNVSIT
 . S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 . S APCDALVR("APCDTPS")="P",APCDALVR("APCDTOA")=""
 . D ^APCDALVR
 . D MSGADD(0,"Provider added to visit.")
 Q
 ;
PROVUPD ; will update provider on visit that was created earlier; IHS/ITSC/LJF 4/28/2005 PATCH 1003
 ;if provider sent is not already on visit, assume provider should be primary
 Q:'$D(BSDPROV)    ;no provider sent
 Q:'$G(BSDPROV)    ;quits if provider is set to zero PATCH 1012 8/19/2010
 ;
 ;look at providers on visit
 NEW FOUND,IEN,PRIM,PRV
 S (IEN,FOUND,PRIM)=0
 F  S IEN=$O(^AUPNVPRV("AD",BSDVSTN,IEN)) Q:'IEN  D
 . I $P($G(^AUPNVPRV(IEN,0)),U)=BSDPROV S FOUND=1   ;provider on visit
 . I $$GET1^DIQ(9000010.06,IEN,.04)="PRIMARY" S PRIM=IEN
 ;
 I FOUND Q           ;provider already on visit, leave alone
 ;
 ; if other provider is primary, switch him/her to secondary
 I PRIM S DIE=9000010.06,DA=PRIM,DR=".04///S" D ^DIE
 ;
 K APCDALVR
 S APCDALVR("APCDTPRO")="`"_BSDPROV
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDVSIT")=BSDVSTN
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 S APCDALVR("APCDTPS")="P",APCDALVR("APCDTOA")=""
 D ^APCDALVR
 D MSGADD(0,"Provider added to visit.")
 Q
 ;
HOSLUPD ; update hospital location on visit; IHS/ITSC/LJF 5/5/2004 PATCH 1003
 NEW DIE,DA,DR
 S DIE="^AUPNVSIT(",DA=BSDVSTN,DR=".22///`"_BSDCLN
 D ^DIE
 Q
 ;
SETVAR ; IHS/ITSC/LJF 5/4/2005 PATCH 1003 sets basic variables needed by API call
 S BSDVAR("PAT")=DFN,BSDVAR("VISIT DATE")=+$G(^SC(BSDCLN,"S",BSDDT,1,APTN,"C"))
 S BSDVAR("SITE")=$$FAC(BSDCLN)
 S BSDVAR("VISIT TYPE")=$$GET1^DIQ(9001001.2,BSDVAR("SITE"),.11,"I")
 I BSDVAR("VISIT TYPE")="" S BSDVAR("VISIT TYPE")=$$GET1^DIQ(9001000,BSDVAR("SITE"),.04,"I")
 I BSDVAR("VISIT TYPE")="" K BSDVAR("VISIT TYPE")
 S BSDVAR("SRV CAT")=$$SERCAT(BSDCLN,DFN)
 S BSDVAR("CLINIC CODE")=BSDCC
 S BSDVAR("HOS LOC")=+BSDCLN
 S BSDVAR("APPT DATE")=BSDDT
 S BSDVAR("USR")=DUZ
 S BSDVAR("TIME RANGE")=-1
 Q
