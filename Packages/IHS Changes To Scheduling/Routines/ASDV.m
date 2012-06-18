ASDV ; IHS/ANMC/LJF - CREATE VISIT AT CHECK-IN ;  [ 12/01/2000  11:10 AM ]
 ;;5.0;IHS SCHEDULING;**5,7**;MAR 25, 1999
 ;PATCH #5: added this routine
 ;PATCH #7: requiring provider is based on clinic parameter
 ;
CHKIN(ASDCLN,ASDDT,APTN,DFN) ;EP; -- ask visit related check-in questions
 ; called by SDI during check-in process
 ; user interface for 2 questions (clinic code and provider)
 ; Input variables:
 ;      ASDCLN = clinic ien
 ;      ASDDT  = appt date/time
 ;      APTN   = ien for appt under date mutiple
 ;      DFN    = patient ien
 ;
 Q:'$G(DFN)  Q:'$G(ASDCLN)  Q:'$G(ASDDT)  Q:'$G(APTN)
 I $P($G(^SC(+ASDCLN,9999999)),U,9)'=1 Q   ;don't create visit
 Q:'$G(^SC(+ASDCLN,"S",ASDDT,1,APTN,"C"))  ;not checked-in
 ;
 NEW ASDCC,ASDVP,ASDMSG
 S ASDCC=$$CLNCODE(ASDCLN)        ;ask clinic code
 S ASDVP=$$PROV(ASDCLN)           ;ask visit provider
 D VISIT(ASDCLN,ASDDT,APTN,DFN,ASDCC,ASDVP,.ASDMSG)  ;create visit
 ;
 I $D(ASDMSG) D
 . NEW I F I=1:1 Q:'$D(ASDMSG(I))  D MSG($P(ASDMSG(I),U,2),1,0)
 Q
 ;
VISIT(ASDCLN,ASDDT,APTN,DFN,ASDCC,ASDPROV,ASDMSG) ;PEP; -- create visit
 ; called by CHKIN subroutine above and by applications where
 ; all data is already known
 ; assumes calling routine has checked that patient is checked in
 ; silent update to database; no user interface
 ; Input variables:
 ;      ASDCLN  = clinic ien
 ;      ASDDT   = appt date/time
 ;      APTN    = ien for appt under date mutiple
 ;      DFN     = patient ien
 ;      ASDCC   = clinic code ien
 ;      ASDPROV = visit provider ien 
 ;      ASDMSG  = called by reference, upon exit contains user msgs
 ;                first piece is error code; 2nd piece is message
 ;                Error = 0 (no problems)
 ;                        1 (problem setting visit variables)
 ;                        2 (problem creating visit)
 ;                        3 (problem changing visit date/time)
 ;
 Q:'$G(ASDCLN)  Q:'$G(ASDDT)  Q:'$G(APTN)  Q:'$G(DFN)
 Q:'$G(ASDCC)  ;Q:'$G(ASDPROV)   ;PATCH 7
 I $P($G(^SC(+ASDCLN,9999999)),U,9)'=1 Q   ;create visit turned off
 ;
 ; send data to pyxis
 NEW X S X="VEFSPOBS" X ^%ZOSF("TEST") I $T D
 . S X=$P($G(^SC(+ASDCLN,9999999)),U,13) I X]"" D AMB^VEFSPOBS(X)
 ;
 ; -- set up visit variables
 K APCDALVR
 S APCDALVR("APCDLOC")=$$FAC(ASDCLN)                          ;facility
 I 'APCDALVR("APCDLOC") D  Q
 . D MSGADD(1,"Cannot create visit; can't find correct PCC facility.")
 . D VSTEND
 S APCDALVR("APCDPAT")=DFN                                    ;patient
 S APCDALVR("APCDTYPE")=$$VALI^XBDIQ1(9001001.2,APCDALVR("APCDLOC"),.11)
 S APCDALVR("APCDCAT")=$$SERCAT(ASDCLN,DFN)                   ;srv cat
 S APCDALVR("APCDDATE")=$G(^SC(ASDCLN,"S",ASDDT,1,APTN,"C"))  ;chkin dt
 S APCDALVR("APCDCLN")="`"_ASDCC                      ;clinic code w/`
 S APCDALVR("APCDHL")=+ASDCLN                          ;clinic name
 S X=$O(^DIC(19,"B","SD IHS PCC LINK",0))
 I X S APCDALVR("APCDOPT")=X                           ;option used
 S APCDALVR("APCDAPDT")=ASDDT                          ;appt date
 S APCDALVR("APCDAPPT")=$S($P(^DPT(DFN,"S",ASDDT,0),U,7)=3:"A",$P(^DPT(DFN,"S",ASDDT,0),U,7)=4:"W",1:"U")                              ;walk-in vs appt
 S APCDALVR("APCDADD")=1                               ;force add
 ;
 ; -- create visit
 N %DT  ;per Lori - %DT(0) set somewhere in scheduling and prevents creation of visit for current or future dates
 D ^APCDALV
 I '$G(APCDALVR("APCDVSIT")) D  D VSTEND Q
 . D MSGADD(2,"VISIT ERROR, Please notify your supervisor!")
 D MSGADD(0,"Visit Created.")
 S ASDVST=APCDALVR("APCDVSIT")
 ;
 ; -- add provider to visit
 I ASDPROV D     ;add provider only if passed;PATCH 7
 . K APCDALVR
 . S APCDALVR("APCDTPRO")="`"_ASDPROV
 . S APCDALVR("APCDPAT")=DFN
 . S APCDALVR("APCDVSIT")=ASDVST
 . S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]"
 . S APCDALVR("APCDTPS")="P",APCDALVR("APCDTOA")=""
 . D ^APCDALVR
 . D MSGADD(0,"Provider added to visit.")
 ;
 ; -- create VCN and add to visit
 I $T(VCN^AUPNVSIT)]"" S ASDVCN=$$VCN^AUPNVSIT(ASDVST,1)
 ;
 ; -- call to print PCC Encounter Form
 ;ADD CODE HERE
 ;
VSTEND D EN1^APCDEKL,EN2^APCDEKL K APCDALVR,ASDVST,X
 Q
 ;
VDATE(ASDCLN,ASDDT,APTN,DFN,ASDCKO,ASDMSG) ;EP;if new time entered, update visit
 ; called by SDI if check-in time was changed
 ; silent update to database; no user interface
 ; Input variables:
 ;    ASDCLN    =  clinic ien
 ;    ASSDT     =  appt date & time
 ;    APTN      =  ien for appt under date multiple
 ;    DFN       =  Patient ien
 ;    ASDCKO    =  old check-in date/time
 ;    ASDMSG    =  called by reference, upon exit contains user msgs
 ;
 I $P($G(^SC(+ASDCLN,9999999)),U,9)'=1 Q   ;create visit turned off
 NEW APCDVSIT,ASDCK
 ;
 ; find visit based on old check-in time
 S APCDVSIT=$O(^AUPNVSIT("AA",DFN,$$RDT(ASDCKO),0)) Q:'APCDVSIT
 I $O(^AUPNVSIT("AA",DFN,$$RDT(ASDCKO),APCDVSIT)) D MSGADD(4,"More than 1 visit at same date/time; must be updated manually.") Q   ;PATCH 7
 ;
 ; get new check-in time
 ;S ASDCK=$G(^SC(ASDCLN,"S",ASDDT,1,APTN,"C")) Q:'ASDCK  ;PATCH 7
 S ASDCK=$G(^SC(ASDCLN,"S",ASDDT,1,APTN,"C"))            ;PATCH 7
 I 'ASDCK S APCDVDLT=APCDVSIT I $$GET1^DIQ(9000010,APCDVSIT,.09)<2 NEW I D EN^APCDVDLT D MSGADD(0,"Visit Deleted.") Q   ;PATCH 7 delete visit if check-in time deleted and visit has less than 2 dep entries
 ;
 ;if visit date/time does NOT match new check-in date/time, modify it 
 I $$VALI^XBDIQ1(9000010,APCDVSIT,.01)'=ASDCK D
 . S APCDCVDT("VISIT DFN")=APCDVSIT
 . S APCDCVDT("VISIT DATE/TIME")=ASDCK
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
 . S CODE=$$VAL^XBDIQ1(40.7,+$$VALI^XBDIQ1(44,CLINIC,8),1)  ;code #
 . ;do not set default if multiple clinic codes used in clinic
 . I CODE,$$VAL^XBDIQ1(44,CLINIC,9999999.14)'="YES" S DIR("B")=CODE
 . S DIR("?")="This is required.  Please try again"
 . D ^DIR
 Q +Y
 ;
PROV(CLINIC) ; - asks user for visit provider
 NEW DIC,X,Y
 F  Q:$G(Y)>0  D
 . S DIC=200,DIC(0)="AMEQZ",DIC("A")="VISIT PROVIDER:  "
 . S DIC("B")=$$VAL^XBDIQ1(200,+$$VALI^XBDIQ1(44,CLINIC,9999999.8),.01)
 . I DIC("B")="" K DIC("B")
 . S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 . D ^DIC K DIC
 . I Y<1,$$GET1^DIQ(44,CLINIC,9999999.15)'="YES" S Y="1^QUIT" Q  ;not required;PATCH 7
 . I Y<1 D MSG("This is required.  Please try again.",1,0)
 I $P(Y,U,2)="QUIT" Q 0    ;not required;PATCH 7
 Q $$PRVIEN(+Y)
 ;
PRVIEN(Y) ; -- determines correct provider file to use
 I $P(^DD(9000010.06,.01,0),U,2)["200" Q +Y
 Q $P(^VA(200,+Y,0),U,16)
 ;
 ;
MSGADD(ERROR,STRING) ; -- put message string into array
 NEW I
 S I=$O(ASDMSG(""),-1)+1   ;get next subscript
 S ASDMSG(I)=ERROR_U_STRING
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
 S FAC=$$VALI^XBDIQ1(44,CLINIC,3)
 I 'FAC S FAC=$$VALI^XBDIQ1(40.8,+$$VALI^XBDIQ1(44,ASDCLN,3.5),.07)
 I 'FAC S FAC=$G(DUZ(2))
 I '$D(^APCDSITE(+FAC)) S FAC=0
 Q FAC
 ;
SERCAT(CLINIC,PAT) ; -- returns service category for visit
 NEW CAT,CLNCAT
 S CLNCAT=$$VALI^XBDIQ1(44,CLINIC,9999999.12)         ;clinic's ser cat
 S CAT=$S($G(^DPT(PAT,.1))]"":"I",CLNCAT]"":CLNCAT,1:"A")  ;chk if inpt
 Q CAT
