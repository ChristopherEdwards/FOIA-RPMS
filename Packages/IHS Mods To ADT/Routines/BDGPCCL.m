BDGPCCL ; IHS/ANMC/LJF,WAR - PCC LINK CODE ;  [ 09/14/2004  2:11 PM ]
 ;;5.3;PIMS;**1001,1003,1004,1005,1006,1010,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 09/01/2004 PATCH 1001 change visit pointer if "A" visit
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 HASVISIT changed to find only H visit at date/time stamp
 ;             06/24/2005 PATCH 1003 fix typo so update to Discharge UB-92 works
 ;             08/25/2005 PATCH 1004 fixed Discharge UB-92 to pointer with "`"
 ;IHS/OIT/LJF  05/03/2006 PATCH 1005 if default visit type not set in one file, check another
 ;             09/08/2006 PATCH 1006 prevent PCC visit deletion if already coded
 ;cmi/anch/maw 10/20/2008 PATCH 1010 added set of APCDALVR("APCDOPT") to BDG VISIT CREATOR
 ;ihs/cmi/maw  09/26/2011 PATCH 1013 added service cat and clinic for DAY SURGERY
 ;
 ; Called by ADT Event Driver as first protocol
 ;
 ; Input Variables:
 ;    DGPMT   = type of event (1-admit, 3-discharge, etc.)
 ;    DGPMDA  = event ien
 ;    DGPMCA  = admission ien
 ;    DGPMP   = zero node of 405 entry Prior to event
 ;    DGPMA   = zero node of 405 entry After event
 ;    DFN     = patient ien
 ;    DGQUIET = if $G(DGQUIET), no user interaction
 ;
EVENT ; process event
 Q:$$CHECK^BDGVAR(0)'=2     ;PCC link not turned on
 K APCDALVR
 D @DGPMT                   ;use code based on type of event
 Q
 ;
1 ; Admissions       
 I DGPMP="",DGPMA="" Q             ;incomplete admission
 I DGPMA]"",'$G(DGQUIET) D NBCHK   ;check admit date & dob for newborns
 I DGPMP="" D ADDVST Q             ;new admission-create visit
 I DGPMA="" D DELVST Q             ;if deleted, delete visit
 I +DGPMP'=+DGPMA D CHGVDT         ;change visit date if diff adm date
 ;
 D CHKCAT                          ;chk serv category (H vs. O)
 I +$P(DGPMA,U,17) D CHKVH         ;if discharged, check VHosp data
 Q
 ;
2 ; Ward Transfers
 Q                                 ;no visit mods associated with wards
 ;
3 ; Discharges
 ;  if patient died, make sure Reg export notified
 I +$G(^DPT(DFN,.35)) S ^AGPATCH($$NOW^XLFDT,DUZ(2),DFN)=""
 ;
 I DGPMP="" D ADDVH Q         ;if new discharge, add VHosp entry
 ;
 I DGPMA="" D  Q                   ;delete vhosp if disch deleted
 . NEW DIK,DA,E
 . S DIK=9000010.02,DA=$$VH(+$$GET1^DIQ(405,+DGPMCA,.27)) Q:'DA
 . S E=$$DEL^APCDALVR(DIK,DA)      ;call PCC to delete v file
 . I E,'$G(DGQUIET) D
 .. W !,"ERROR DELETING V HOSP ENTRY - ERROR CODE ",E
 .. W !,"Please relay this message to your supervisor"
 .. D PAUSE^BDGF
 ;
 ; check for changes against previous discharge info
 ;  if discharge date/time changed
 I +DGPMA'=+DGPMP S APCDALVR("APCDDSCH")=+DGPMA
 ;
 ;  if discharge type changed
 I $P(DGPMA,U,4)'=$P(DGPMP,U,4) S APCDALVR("APCDTDT")="`"_$P(DGPMA,U,4)
 ;
 ;  check for changes in UB92 field
 NEW VH,X S VH=$O(^AUPNVINP("AD",+$$GET1^DIQ(405,DGPMCA,.27,"I"),0))
 ;I VH S X=$$GET1^DIQ(405,DGPMDA,9999999.07,"I") I X]"",X'=$$GET1^DIQ(9000010.02,VH,6103,"I") S APCDALVR("APCDTDSU")=X
 ;I VH S X=$$GET1^DIQ(405,DGPMDA,9999999.07,"I") I X]"",X'=$$GET1^DIQ(9000010.02,VH,6103,"I") S APCDALVR("APCDTDTU")=X  ;IHS/ITSC/LJF 06/24/2005 PATCH 1003
 I VH S X=$$GET1^DIQ(405,DGPMDA,9999999.07,"I") I X]"",X'=$$GET1^DIQ(9000010.02,VH,6103,"I") S APCDALVR("APCDTDTU")="`"_X  ;IHS/OIT/LJF 08/25/2005 PATCH 1004
 ;
 ;  if transfer facility changed
 I $P(DGPMA,U,5)'=$P(DGPMP,U,5) D
 . I $P(DGPMA,U,5)="" S APCDALVR("APCDTTT")="@" Q
 . S APCDALVR("APCDTTT")="`"_$P(DGPMA,U,5)
 ;
 ; if found something changed, update v hosp file
 I $D(APCDALVR) D EDITVH Q
 ;
 D CHKCAT   ;check service category
 Q
 ;
4 ; check-in lodger
5 ; check-out lodger       
 Q                           ;no visit mods for lodgers
 ;
6 ; Service transfers
 D CHKCAT                           ;service category might be changed BEFORE discharge
 Q:$$GET1^DIQ(405,DGPMCA,.17)=""    ;not discharged yet
 I DGPMA]"",'$G(DGQUIET) D NBCHK    ;chk newborn admit vs. dob
 ;
 ; check if service transfer changed discharge service
 NEW VST,DSRV
 S VST=$$GET1^DIQ(405,DGPMCA,.27,"I") Q:'VST
 S DSRV=$P($$LASTTXN^BDGF1(DGPMCA,DFN),U,2)        ;current disch serv
 I $$GET1^DIQ(9000010.02,$$VH(VST),.05,"I")'=DSRV D
 . S APCDALVR("APCDTDCS")="`"_DSRV D EDITVH
 ;
 Q
 ;
ADDVST ; create visit
 Q:$$HASVPTR          ;405 points to good visit
 Q:$$HASVISIT         ;PCC has good visit-will add pointer
 ;
 S APCDALVR("APCDADD")=1              ;force add
 S APCDALVR("APCDPAT")=DFN            ;patient
 S APCDALVR("APCDLOC")=DUZ(2)         ;location
 S APCDALVR("APCDTYPE")=$$GET1^DIQ(9001001.2,DUZ(2),.11,"I")  ;vst type
 I APCDALVR("APCDTYPE")="" S APCDALVR("APCDTYPE")=$$GET1^DIQ(9001000,DUZ(2),.04,"I")  ;IHS/OIT/LJF 05/03/2006 PATCH 1005
 S APCDALVR("APCDDATE")=$E(+DGPMA,1,12)    ;visit date/time, no seconds
 S APCDALVR("APCDHL")=$$GET1^DIQ(42,$$GET1^DIQ(405,DGPMCA,.06,"I"),44,"I")
 ;cmi/maw 9/2/2009 PATCH 1010
 N BDGOPT
 S BDGOPT="BDG VISIT CREATOR"
 S APCDALVR("APCDOPT")=$O(^DIC(19,"B",BDGOPT,0))  ;cmi/maw 10/20/2008 PATCH 1010 added set of option used to create visit
 I $G(DGQUIET) D
 . S APCDALVR("AUPNTALK")=""   ;no user interaction w/PCC
 . S APCDALVR("APCDANE")=""    ;no user interactive w/FM
 ;
 NEW ASRV S ASRV=$$LASTSRVN^BDGF1(DGPMCA,DFN)    ;admit service name
 S APCDALVR("APCDCAT")=$S(ASRV["OBSERVATION":"O",ASRV="DAY SURGERY":"S",1:"H")   ;srv category maw 09/26/2011
 I ASRV["OBSERVATION" S APCDALVR("APCDCLN")=$O(^DIC(40.7,"C",87,0))
 I ASRV="DAY SURGERY" S APCDALVR("APCDCLN")=$O(^DIC(40.7,"C",44,0))  ;ihs/cmi/maw 09/26/2011 PATCH 1013
 ;
 D ^APCDALV
 ;
 I $D(APCDALVR("APCDAFLG")) D  Q
 . D ERR("Error creating admit visit; code=",APCDALVR("APCDAFLG"))
 . D KILLVAR
 I '$G(DGQUIET) W !!,"Visit created for date of admission"
 ;
 L +^DGPM(DGPMCA):3 I '$T D  Q
 . I '$G(DGQUIET) W !,*7,"CANNOT UPDATE VISIT LINK; ENTRY LOCKED"
 . D KILLVAR
 ;
 ; used 4 slashes as visit at this point has no dep entry counts
 S DIE="^DGPM(",DA=DGPMCA,DR=".27////"_APCDALVR("APCDVSIT")
 D ^DIE L -^DGPM(DGPMCA)
 ;
 D KILLVAR
 Q
 ;
EDITVST(VST,DFN)   ; edit visit data
 S APCDALVR("APCDVSIT")=VST
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDATMP")="[APCDALVR 9000010 (MOD)]"
 ;
 D ^APCDALVR
 ;
 I $D(APCDALVR("APCDAFLG")) D ERR("Error editing Visit entry; code=",APCDALVR("APCDAFLG"))
 D KILLVAR
 Q
 ;
CHGVDT ; edit visit date
 K APCDCVDT
 I $$GET1^DIQ(405,DGPMCA,.27)="" D ADDVST   ;if none, add visit to 405
 S APCDCVDT("VISIT DFN")=$$GET1^DIQ(405,DGPMCA,.27,"I")
 S APCDCVDT("VISIT DATE/TIME")=+DGPMA
 ;
 D START^APCDCVDT
 ;
 I $D(APCDCVDT("ERROR FLAG")) D
 . D ERR("ERROR updating visit date/time; Code=",APCDCVDT("ERROR FLAG"))
 D KILLVAR
 Q
 ;
DELVST ; delete visit
 S APCDVDLT=$P(DGPMP,U,27) Q:'APCDVDLT
 I $D(^SRF("AV",APCDVDLT)) Q   ;do not delete if used by surgery
 ;
 ;IHS/OIT/LJF 09/08/2006 PATCH 1006
 I $D(^AUPNVINP("AD",APCDVDLT)),$$GET1^DIQ(9000010.02,+$O(^AUPNVINP("AD",APCDVDLT,0)),.15)="" D  Q   ;don't delete coded visit
 . D ERR("Cannot DELETE coded PCC visit.  Use PCC to delete it.","")
 ;
 D EN^APCDVDLT,KILLVAR
 Q
 ;
CHKVH ; check v hosp entry to see if admission mod changed v hosp data
 ;   if admission service changed...
 I $$ADMSRVN^BDGF1(DGPMCA,DFN)'=$P(DGPMA,U,9) D
 . S APCDALVR("APCDTADS")="`"_$$ADMSRVN^BDGF1(DGPMCA,DFN)
 . S APCDALVR("APCDTDCS")="`"_$P($$LASTTXN^BDGF1(DGPMCA,DFN),U,2)
 . S APCDALVR("APCDTDCS")=$P($$LASTTXN^BDGF1(DGPMCA,DFN),U,2)
 ;
 ;   if admission type changed...
 I $P(DGPMA,U,4)'=$P(DGPMP,U,4) S APCDALVR("APCDTAT")="`"_$P(DGPMA,U,4)
 ;
 NEW VH,X S VH=$O(^AUPNVINP("AD",+$$GET1^DIQ(405,DGPMCA,.27,"I"),0))
 I VH S X=$$GET1^DIQ(405,DGPMCA,9999999.05,"I") I X]"",X'=$$GET1^DIQ(9000010.02,VH,6101,"I") S APCDALVR("APCDTATU")=X
 I VH S X=$$GET1^DIQ(405,DGPMCA,9999999.06,"I") I X]"",X'=$$GET1^DIQ(9000010.02,VH,6102,"I") S APCDALVR("APCDTASU")="`"_X
 ;
 I $D(APCDALVR) D EDITVH
 Q
 ;
CHKCAT ; called by ADDVH to check visit service category
 ; if last service and service category don't match, fix category
 NEW VST,DSRV,CAT
 S VST=$$GET1^DIQ(405,DGPMCA,.27,"I") Q:'VST
 S DSRV=$$LASTSRVN^BDGF1(DGPMCA,DFN)             ;disch service name
 S CAT=$$GET1^DIQ(9000010,VST,.07,"I")           ;service category
 ;
 ;if visit changed from H to O, delete V Hosp entry
 I DSRV["OBSERVATION",CAT="H" D  Q
 . S APCDALVR("APCDCAT")="O" D EDITVST(VST,DFN)
 . NEW DA,DIK S DA=$O(^AUPNVINP("AD",VST,0)) I DA S DIK="^AUPNVINP(" D ^DIK
 ;
 ; if visit changed from O to H, make sure has V Hosp entry if discharged
 I DSRV'["OBSERVATION",CAT="O" D  Q
 . S APCDALVR("APCDCAT")="H" D EDITVST(VST,DFN)
 . I '$O(^AUPNVINP("AD",VST,0)),$$GET1^DIQ(405,DGPMCA,.17)]"" D ADDVH
 I DSRV'="DAY SURGERY",CAT="S" D  Q  ;ihs/cmi/maw 09/26/2011 PATCH 1013 for day surgery
 . S APCDALVR("APCDCAT")="H" D EDITVST(VST,DFN)
 . I '$O(^AUPNVINP("AD",VST,0)),$$GET1^DIQ(405,DGPMCA,.17)]"" D ADDVH
 ;
 Q
 ;
EDITVH ; edit v hospitalization
 ; -- create visit if none already for admission
 NEW VST S VST=$$GET1^DIQ(405,DGPMCA,.27,"I")
 I 'VST D  I 'VST D KILLVAR Q
 . NEW DGPMA S DGPMA=^DGPM(DGPMCA,0) D ADDVST
 . S VST=$$GET1^DIQ(405,DGPMCA,.27,"I")
 ;
 ; -- create v hosp if none
 I '$O(^AUPNVINP("AD",+VST,0)) D ADDVH Q
 ;
 ; -- modify v hosp
 S APCDALVR("APCDVSIT")=VST
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.02 (MOD)]"
 S APCDALVR("APCDLOOK")="`"_$O(^AUPNVINP("AD",+VST,0))
 I '$D(APCDALVR("APCDDSCH")) S APCDALVR("APCDDSCH")=+$$GET1^DIQ(405,+$$GET1^DIQ(405,DGPMCA,.17,"I"),.01,"I")
 ;
 D ^APCDALVR
 ;
 I $D(APCDALVR("APCDAFLG")) D ERR("Error editing V Hosp entry; code=",APCDALVR("APCDAFLG"))
 D KILLVAR
 Q
 ;
ADDVH ;EP; -- create v hosp
 ; Also called by V Hosp fix (^BDGVHF)
 NEW V
 S V=$$GET1^DIQ(405,DGPMCA,.27,"I")
 ;
 I $$GET1^DIQ(9000010,+V,.11)="DELETED" S V=""
 I "OHS"'[$$GET1^DIQ(9000010,+V,.07,"I") S V=""   ;IHS/ITSC/LJF 9/1/2004 PATCH #1001 change if linked to "A" visit
 I 'V D
 . S DGSAV=DGPMA,DGPMA=$G(^DGPM(DGPMCA,0))  ;reset DGPMA to admit node
 . D ADDVST
 . S DGPMA=DGSAV K DGSAV  ;reset DGPMA back to discharge node
 . S V=$$GET1^DIQ(405,DGPMCA,.27,"I")
 I 'V Q
 ;
 S APCDALVR("APCDVSIT")=V
 ;
 I $D(^AUPNVINP("AD",V)) Q                ;vhosp already in file
 I $$GET1^DIQ(9000010,V,.07,"I")'="H" Q   ;only add for H visits
 ;
 NEW DSC S DSC=$$GET1^DIQ(405,DGPMCA,.17,"I") Q:'DSC
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDTDT")="`"_$$GET1^DIQ(405,DSC,.04,"I")
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.02 (ADD)]"
 S:$P(DGPMA,U,18)=10 APCDALVR("APCDTTT")="`"_$P(DGPMA,U,5)
 ;
 S APCDALVR("APCDLOOK")=$E($$GET1^DIQ(405,DSC,.01,"I"),1,12)
 ;
 S APCDALVR("APCDTDCS")="`"_$P($$LASTTXN^BDGF1(DGPMCA,DFN),U,2)
 S APCDALVR("APCDTADS")="`"_$$ADMSRVN^BDGF1(DGPMCA,DFN)
 S APCDALVR("APCDTAT")="`"_$$GET1^DIQ(405,DGPMCA,.04,"I")
 S APCDALVR("APCDTATU")=$$GET1^DIQ(405,DGPMCA,9999999.05,"I")
 S X=$$GET1^DIQ(405,DGPMCA,9999999.06,"I")
 S APCDALVR("APCDTASU")=$S(X="":"",1:"`"_X)
 ;S APCDALVR("APCDTDTU")=$$GET1^DIQ(405,DSC,9999999.07,"I")
 S APCDALVR("APCDTDTU")="`"_$$GET1^DIQ(405,DSC,9999999.07,"I")  ;IHS/OIT/LJF 8/25/2005 PATCH 1004
 ;
 D ^APCDALVR
 ;
 I $D(APCDALVR("APCDAFLG")) D ERR("Error creating V Hosp entry; code=",APCDALVR("APCDAFLG")) I 1
 E  D ERR("V Hospitalization Entry Created","")
 ;
 D KILLVAR
 Q
 ;
KILLVAR ; cleanup variables
 D EN1^APCDEKL K DIE,DA,DR,APCDALVR,APCDCVDT,APCDVDLT,APCDVLDT  Q
 ;
ERR(MSG,ERROR) ; display error message
 Q:$G(DGQUIET)
 D MSG^BDGF(MSG_ERROR)
 Q
 ;
 ;
HASVPTR() ; -- returns 1 if admission already has good visit pointer
 NEW X
 S X=$$GET1^DIQ(405,DGPMCA,.27,"I") I 'X Q 0    ;visit pointer in 405
 I '$D(^AUPNVSIT(X,0)) D DELPTR Q 0             ;bad pointer
 ;
 ; if 405 points to deleted visit, remove pointer
 I $$GET1^DIQ(9000010,X,.11)="DELETED" D DELPTR Q 0
 ;
 ; if 405 points to a visit not an hosp or observation, remove pointer
 S Y=$$GET1^DIQ(9000010,X,.07,"I") I (Y'="H"),(Y'="O") D DELPTR Q 0
 ;
 Q 1
 ;
HASVISIT() ; returns 1 if visit found in PCC and link added
 ; assumes called with DGPMA=admit node
 NEW X,VST,CAT,DIE,DA,DR
 NEW NODE S NODE=$G(^DGPM(DGPMCA,0)) I 'NODE Q 0
 S X=9999999-($P(+NODE,"."))_"."_$E($P(+NODE,".",2),1,4)  ;inverse admit date without seconds
 ;
 ;IHS/ITSC/LJF 5/13/2005 PATCH 1003 find H visit at date/time
 ;S VST=$O(^AUPNVSIT("AA",DFN,X,0)) I 'VST Q 0       ;no vst for dt/time
 NEW V S (V,VST)=0 F  S V=$O(^AUPNVSIT("AA",DFN,X,V)) Q:'V  Q:VST  D
 . I $P(^AUPNVSIT(V,0),U,7)="H" S VST=V
 I 'VST Q 0
 ;PATCH 1003 end of code changes
 ;
 S CAT=$P($G(^AUPNVSIT(VST,0)),U,7) I CAT="" Q 0    ;service category
 I "SOH"'[CAT Q 0                                   ;must be one of these 3 to link
 ;
 ; update service category based on last service
 S X=$$LASTSRVN^BDGF1(DGPMCA,DFN) Q:X=""
 K DIE,DR,DA S DIE="^AUPNVSIT(",DA=VST
 S DR=".07///"_$S(X["OBSERVATION":"O",1:"H") D ^DIE
 ;
 ; link visit to file 405 entry
 ;   used 4 slashes to override visit file screen
 K DIE,DA,DR S DIE="^DGPM(",DA=DGPMCA,DR=".27////"_VST D ^DIE
 Q 1
 ;
VH(V) ; return V Hosp entry for visit V
 Q +$O(^AUPNVINP("AD",+$$GET1^DIQ(405,DGPMCA,.27,"I"),0))
 ;
DELPTR ; deletes visit pointer in admission ien
 NEW DIE,DA,DR S DIE="^DGPM(",DA=DGPMCA,DR=".27///@" D ^DIE
 Q
 ;
NBCHK ; -- checks newborn admit date against date of birth 
 NEW X,DOB,Y
 S X=$O(^DIC(45.7,"CIHS","07",0)) I X="" Q  ;no nb code
 S Y=$S(DGPMT=1:$$ADMTXN^BDGF1(DGPMCA,DFN),1:DGPMDA) Q:Y=""
 Q:$P($G(^DGPM(+Y,0)),U,9)'=X  ;not newborn
 S DOB=$P($G(^DPT(+$P(DGPMA,U,3),0)),U,3) Q:DOB=""
 I DOB'=(+DGPMA\1) D
 . W !!,*7,"NEWBORN ADMIT DATE DOES NOT MATCH DATE OF BIRTH"
 . W !,"PLEASE FIX INCORRECT DATE!"
 Q
