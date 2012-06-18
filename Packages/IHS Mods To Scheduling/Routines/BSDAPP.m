BSDAPP ; IHS/ANMC/LJF - IHS CALLS FROM SDAPP ;  [ 08/20/2004  11:51 AM ]
 ;;5.3;PIMS;**1001,1003,1004,1009**;MAY 28, 2004
 ;IHS/ITSC/LJF 06/15/2005 PATCH 1003 add ability to print future chart requests now
 ;IHS/OIT/LJF  07/28/2005 PATCH 1004 don't ask for printer if future date and printing in future
 ;cmi/anch/maw 02/21/2008 PATCH 1009 mods to print requirement 36
 ;cmi/anch/maw 02/21/2008 PATCH 1009 mods to print requirement 35
 ;
CR ;EP;Chart Request entry; called by SDAPP
 ; rewrote VA code to make it less confusing
 ;
 NEW DIC,DIE,DA,DR,BSDV,BSDC,BSDCNT,BSDQ,DFN,BSDDT,X,Y,DLAYGO
 S (DIC,DIE)="^SC(",DIC(0)="AQME",DIC("A")="SELECT CLINIC NAME: "
 S DIC("W")=$$INACTMSG^BSDU
 ; screen: must be clinic, not out-of-service and have division set
 S DIC("S")="I $P(^(0),U,3)=""C"",'$G(^(""OOS"")),$P(^(0),U,15)]"""""
 D ^DIC K DIC("A"),DIC("S") Q:+Y<0  S BSDC=+Y
 ;
 ; check out inactive status
 S SDIN=$S($D(^SC(BSDC,"I")):1,1:""),SDRE=""
 I SDIN S SDIN=+^SC(BSDC,"I"),SDRE=+$P(^("I"),"^",2)
 I SDIN,SDIN'>DT,'SDRE S D0=+Y D WRT1^SDAPP Q
 ;
 S BSDV=$$DELIVER Q:BSDV=""     ;ask delivery info
 ;
 ; ask for date and stuff into clinic if not there yet
 S BSDDT=$$READ^BDGF("DOA^"_DT_"::EX","Select Chart Delivery Date: ")
 Q:'BSDDT
 I '$D(^SC(BSDC,"C",BSDDT)) K DIC,DA D    ;add date for clinic
 . S DIC="^SC("_BSDC_",""C"",",DA(1)=BSDC,DIC(0)="L",DLAYGO=44.006
 . S DIC("P")=$P(^DD(44,1906,0),U,2)
 . S X=BSDDT D ^DIC
 I '$D(^SC(BSDC,"C",BSDDT)) W !!,"Problem with this date for this clinic. Notify computer department." Q
 ;
 ;IHS/ITSC/LJF 06/15/2005 PATCH 1003
 NEW BSDNOW K ^TMP("BSDNOW",$J)
 S BSDNOW=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.14) I BSDNOW="" S BSDNOW="FUTURE"
 ;end of PATCH 1003 changes
 ;
 ; ask for patients and check against previous appt and chart requests
 S (BSDQ,BSDCNT)=0 F  Q:BSDQ=1  D
 . S DFN=+$$READ^BDGF("PO^2:EMQZ","Select PATIENT") I DFN<1 S BSDQ=1 Q
 . Q:'$$OKAY(DFN,BSDDT)    ;show info to user and ask if okay
 . K DIC,DIE,DA,DR
 . S DIC="^SC("_BSDC_",""C"","_BSDDT_",1,",DIC(0)="L",DLAYGO=44.007
 . S DIC("P")=$P(^DD(44.006,2,0),U,2)
 . S DA(2)=BSDC,DA(1)=BSDDT,X=DFN
 . D FILE^DICN
 . I Y<1 W !!,"Problem recording chart request for patient.  Contact computer department." Q
 . ;
 . I BSDNOW="NOW" S ^TMP("BSDNOW",$J,+Y)=""   ;IHS/ITSC/LJF 06/15/2005 PATCH 1003
 . ;
 . S DIE=DIC,DA=+Y
 . S DR="9999999.01///^S X=$$NOW^XLFDT;9999999.02///^S X=""`""_DUZ;9999999.03///"_BSDV
 . D ^DIE
 . I '$G(Y) W !?5,"chart request recorded...",!!
 . S BSDCNT=BSDCNT+1    ;increment count
 ;
 I BSDNOW="FUTURE",BSDDT'=DT Q   ;quit if future date and want to print in the future ;IHS/OIT/LJF 7/28/2005 PATCH 1004
 ; if at least one CR recorded, ask for printer
 ;I BSDCNT>0 W ! D PRINT(BSDC)
 I BSDCNT>0 W ! D PRINT(BSDC,0,BSDDT,BSDNOW)   ;IHS/ITSC/LJF 06/15/2005 PATCH 1003
 Q
 ;
 ;
OKAY(PAT,DATE) ; find other appts and chart requests for date
 ; if any found, ask user if they still want to request chart
 NEW CLN,IEN,FIRST
 S FIRST=1
 ;
 ; show if current inpatient
 I $G(^DPT(PAT,.1))]"" D
 . W !!,"** Current "
 . NEW X S X=$$GET1^DIQ(2,PAT,.103)
 . W $S(X["OBSERVATION":"Observation Patient",1:"Inpatient")
 . W " on "_$G(^DPT(PAT,.1))_" ward **"
 . S FIRST=0
 ;
 ; check for any chart requests
 S CLN=0
 F  S CLN=$O(^SC("AIHSCR",PAT,CLN)) Q:'CLN  D
 . S IEN=0 F  S IEN=$O(^SC("AIHSCR",PAT,CLN,DATE,IEN)) Q:'IEN  D
 .. I FIRST W !!,"Patient's chart already requested for:" S FIRST=0
 .. W !?3,"Chart Request for ",$$GET1^DIQ(44,CLN,.01),?40,"made at "
 .. W $$GET1^DIQ(44.007,IEN_","_DATE_","_CLN,9999999.01)
 ;
 ; now check for any appointments
 S IEN=DATE
 F  S IEN=$O(^DPT(PAT,"S",IEN)) Q:'IEN  Q:(IEN>(DATE+.24))  D
 . I FIRST W !!,"Patient's chart already requested for:" S FIRST=0
 . W !?3,"APPT at ",$$TIME^BDGF(IEN),?25,"for "
 . W $$GET1^DIQ(44,+^DPT(PAT,"S",IEN,0),.01)
 ;
 I FIRST Q 1   ;if nothing found, okay to proceed
 ;
 Q +$$READ^BDGF("YO","Do you still want to request this chart","NO")
 ;
DELIVER() ; -- asks user for delivery info
 NEW X,Y,DIR,DIRUT
 ;IHS/ITSC/WAR 5/20/04 P #1001 Change in verbage
 ;S DIR(0)="F^3:60",DIR("A")="DELIVER CHARTS TO (PROVIDER/LOCATION/EXT.)"
 S DIR(0)="F^3:60",DIR("A")="REQUEST CHARTS FOR (PROVIDER/LOCATION/EXT.)"
 D ^DIR I $D(DIRUT) S Y=""
 I Y[";" S X(";")="-",Y=$$REPLACE^XLFSTR(Y,.X)
 Q Y
 ;
 ;IHS/ITSC/LJF 06/15/2005 PATCH 1003 added 2 new parameters
PRINT(CLN,ADMIT,BSDDT,BSDNOW) ; set up print job for routing slips
 ; called by this routine after recording chart requests
 ; called by admission chart request ADMIT^BSDAPP
 ; CLN=chart request clinic
 ; ADMIT (optional), if set to 1, don't use default printer
 ;
 ;IHS/ITSC/LJF 06/15/2005 PATCH 1003
 ; BSDDT (optional), if set contains chart request date
 ; BSDNOW = NOW or FUTURE
 ;Q:'$D(^SC(CLN,"C",DT))    ;none for today; wait for add-ons
 I $G(BSDNOW)'="NOW" Q:'$D(^SC(CLN,"C",DT))
 ;end of these PATCH 1003 changes
 ;
 NEW VAUTC,SDATE,ORDER,SDX,SDREP,IEN,SDPARMS,DEV,DFN
 S VAUTC=0,VAUTC(CLN)=$$GET1^DIQ(44,CLN,.01)
 S SDATE=DT,ORDER=4,SDX="ALL",SDREP=""
 ;
 S SDATE=$S($G(BSDDT):BSDDT,1:DT)  ;IHS/ITSC/LJF 061/5/2005 PATCH 1003
 ;
 S SDPARMS("DO NOT CLOSE")=1
 ;
 ; ask for print device, pull default from parameters
 ;IHS/ITSC/LJF 06/15/2005 PATCH 1003 use choice of default printers
 ;S DEV=$S($G(ADMIT)=1:"",1:$$GET1^DIQ(9009020.2,$$DIV^BSDU,.05))
 S DEV=$S($G(ADMIT)=1:"",1:$$GET1^DIQ(9009020.2,$$DIV^BSDU,$S($G(BSDDT)=DT:.05,1:.21)))
 ;
 I $D(DGQUIET),DEV="" Q
 S %ZIS="N",%ZIS("A")="Chart Request Printer: "
 ;S:DEV]"" %ZIS("B")=DEV D ^%ZIS Q:POP  ;cmi/maw 2/21/2008 PATCH 1009 requirement 35 orig line
DEVP S:DEV]"" %ZIS("B")=DEV D ^%ZIS
 I POP W !,"Exiting out prevents, the remaining chart requests from printing, please select a device" G DEVP  ;cmi/maw 2/21/2008 PATCH 1009 requirement 35
 ;cmi/maw 2/21/2008 PATCH 1009 requirement 36
 I $G(IOS),$P($G(^%ZIS(1,IOS,0)),U,12)=2 D  Q
 . Q:$D(DGQUIET)
 . W !,"You must select a device that allows queueing"
 . H 2
 ;cmi/maw 2/21/2008 PATCH 1009 end of mods requirement 36
 ;
 ; find each patient and make separate call
 NEW BDGQT I $D(DGQUIET) S BDGQT=1   ;was DGQUIET already set?
 S DGQUIET=1,BSDDEV=ION
 S IEN=0 F  S IEN=$O(^SC(CLN,"C",SDATE,1,IEN)) Q:'IEN  D
 . Q:$P($G(^SC(CLN,"C",SDATE,1,IEN,9999999)),U,4)]""  ;already printed
 . ;
 . ;IHS/ITSC/LJF 06/15/2005 PATCH 1003
 . ; if printing future CRs now, was this one of your patient's
 . I $G(BSDNOW)="NOW" Q:'$D(^TMP("BSDNOW",$J,IEN))
 . ;
 . S DFN=+$G(^SC(CLN,"C",SDATE,1,IEN,0)) Q:'DFN
 . D WISD^BSDROUT(DFN,SDATE,"CR",BSDDEV)
 D ^%ZISC
 K BSDDEV
 I '$D(BDGQT) K DGQUIET   ;only kill if not set in previous call
 K ^TMP("BSDNOW",$J)    ;IHS/ITSC/LJF 06/15/2005 PATCH 1003
 Q
 ;
ADMIT(DFN,DGQUIET,BSDCLN,BSDDELV,BSDADT) ;EP; request chart at admission
 ; Called by ADT Event Driver protocol
 ;  DGQUIET = if set to 1, no user interaction
 ;  BSDCLN  = if set, ien to clinic
 ;  BSDDELV = if set, delivery message (who, where, phone)
 ;  BSDADT  = ien of admission in file 405
 ;  ** I $G(DGQUIET) then Chart Request Printer must be set in
 ;      IHS Scheduling Parameter file
 ;
 ; quit if parameter not turned on
 NEW DIV
 S DIV=$$DIV^BDGPAR(DUZ(2)) Q:'DIV
 Q:$$GET1^DIQ(9009020.1,DIV,.09)'="YES"
 ;
 ; first get chart request clinic
 I '$G(BSDCLN) D  Q:$G(BSDCLN)<1
 . ; if not sent and in quiet mode, get clinic from parameter file
 . I $G(DGQUIET) S BSDCLN=$$GET1^DIQ(9009020.1,DIV,.11,"I") Q
 . ;
 . ; else, ask for clinic with parameter file entry as default
 . W !!,"Requesting Chart for new admission.  Type ^ to bypass."
 . K DIC S DIC="^SC(",DIC(0)="AEQM",DIC("W")=$$INACTMSG^BSDU
 . S DIC("B")=$$GET1^DIQ(9009020.1,DIV,.11)    ;default
 . S DIC("S")="I $P(^(0),U,3)=""C"""
 . S DIC("A")="Select Clinic Name: "
 . D ^DIC K DIC S BSDCLN=+Y
 ;
 ; next find out to whom it is to be delivered
 I $G(BSDDELV)="" D  Q:$G(BSDDELV)=""
 . ; if not sent and in quiet mode, use user name & office phone
 . I $G(DGQUIET) S BSDDELV="New Admission - Deliver Chart to "_$$GET1^DIQ(405,+$G(BSDADT),.06)_" Ward" Q
 . ;
 . ; else ask user
 . S BSDDELV=$$DELIVER^BSDAPP       ;see subrtn above for details
 ;
 ; next stuff chart request into file (code from ^SDAPP)
 NEW DIC,X,DLAYGO,DINUM,DD,DO,Y,DIE,DA,DR
 ;
 ;  add today's date if not there
 I '$D(^SC(BSDCLN,"C",DT,0)) D  Q:Y<1
 . S DIC="^SC("_BSDCLN_",""C"",",X=DT,DIC(0)="L",DLAYGO=44.006
 . S DIC("P")="44.006DA",DINUM=DT,DA(1)=BSDCLN
 . L +^SC(BSDCLN,"C"):3 I '$T S Y=0 Q
 . K DD,DO D FILE^DICN L -^SC(BSDCLN,"C")
 . I Y<1 W:'$D(DGQUIET) !,"Error filing chart request!!!"
 ;
 ;  now add patient to today's list
 S DIC="^SC("_BSDCLN_",""C"","_DT_",1,",DIC(0)="L",DLAYGO=44.007
 S DIC("P")="44.007PA",X=DFN,DA(2)=BSDCLN,DA(1)=DT
 L +^SC(BSDCLN,"C",DT):3 I '$T S Y=0 Q
 K DD,DO D FILE^DICN L -^SC(BSDCLN,"C",DT)
 I Y<1 W:'$D(DGQUIET) !,"Error filing chart request!!!" Q
 ;
 ;  add other data items
 S DIE="^SC("_BSDCLN_",""C"","_DT_",1,"
 S DA=+Y,DA(1)=DT,DA(2)=BSDCLN
 S DR="9999999.01///"_$$NOW^XLFDT_";9999999.02///"_DUZ
 S DR=DR_";9999999.03///"_BSDDELV
 D ^DIE
 ;
 ; now print request
 D PRINT^BSDAPP(BSDCLN,1)
 Q
 ;
