BSDAM ; IHS/ANMC/LJF,WAR - IHS CALLS FOR APPT MGT ;  [ 03/16/2004  10:01 AM ]
 ;;5.3;PIMS;**1004,1005,1006,1007,1011,1012**;MAY 28, 2004
 ;IHS/OIT/LJF 07/28/2005 PATCH 1004 added WLDIS subroutine
 ;            12/30/2005 PATCH 1005 added PTAPPT subroutine; added help text to OIASK
 ;            01/19/2006 PATCH 1005 added code for OTHER REPORTS function under AM
 ;            03/22/2006 PATCH 1005 added PAT subrtn to enter Appt Mgt list template
 ;            07/12/2006 PATCH 1006 changed line label for reprinting PCC+ form
 ;            08/16/2006 PATCH 1006 display warning if patient is ineligible
 ;cmi/anch/maw 2/21/2006 PATCH 1007 checked code in OTHER that calls VENPCC, no changes item 1007.35
 ;cmi/flag/maw 11/9/2009 PATCH 1011 added PWH to other reports
 ;cmi/flag/maw 5/14/2010 PATCH 1012 increased length of OTHER INFO RQMT 129
 ;cmi/flag/maw 06/02/2010 PATCH 1012 RQMT149 added check of appt in OIASK,ADTEST,DELTEST
 ;
PAT(DFN) ;PEP - drop into Appt Management list template with patient defined
 D HDLKILL^SDAMEVT
 NEW SDY,BSDSAV
 S SDY=DFN_";DPT(",BSDSAV=DFN
 D EN1^SDAM,HDLKILL^SDAMEVT
 S DFN=BSDSAV
 NEW X,DIC,Y S X="`"_DFN,DIC=2,DIC(0)="" D ^DIC
 Q
 ;
PTAPPT(DFN) ;EP - display pending appts, last reg update and register membership;IHS/OIT/LJF 12/30/2005 PATCH 1005
 ; called when making an appt (SDAM2 and SDM)
 W !?4,"Age:  "_$$AGE^AUPNPAT(DFN,DT,"R")_"  "_$$PCLINE^SDPPTEM(DFN,DT)
 W !,"Last Registration Update: ",$$LASTREG^BDGF2(DFN)    ;last reg update
 ;
 ;IHS/OIT/LJF 08/16/2006 PATCH 1006 if patient is ineligible, display so
 I $$GET1^DIQ(9000001,DFN,1112)="INELIGIBLE" W !!?8,$$REPEAT^XLFSTR("*",24),!?8,"** INELIGIBLE PATIENT **",!?8,$$REPEAT^XLFSTR("*",24),!
 ;
 D CMS^BSDU1(DFN)                                         ;CMS register membership
 D PEND^BSDU2(DFN,1)                                      ;pending appts
 Q
 ;
WLDIS(DFN) ;EP - display waiting list info on AM screen if by patient ;IHS/OIT/LJF 07/28/2005 PATCH 1004
 ; Called by BLD1^SDAM1
 ;cmi/maw 6/1/2010 PATCH 1012 RQMT149
 NEW BSDWLR D WLDATA^BSDWLV(DFN,"C",.BSDWLR)
 ;
 I '$O(BSDWLR(0)) D SET^SDAM1($$SP(10)_BSDWLR(0)) I 1
 E  D
 . D SET^SDAM1(" ")
 . D SET^SDAM1($$SP(17)_"**** ACTIVE WAIT LIST ENTRIES FOR PATIENT ****")
 . D SET^SDAM1(BSDWLR(0))                   ;caption line
 . D SET^SDAM1($$REPEAT^XLFSTR("-",77))     ;dividing line
 . NEW DATE,LINE,LINEC
 . S DATE=0 F  S DATE=$O(BSDWLR(DATE)) Q:'DATE  D
 . . S LINE=0 F  S LINE=$O(BSDWLR(DATE,LINE)) Q:'LINE  D
 . . . ;D SET^SDAM1($S(LINE=1:"",1:$$SP(3))_$P(BSDWLR(DATE,LINE),U,2))
 . . . S SDACNT=SDACNT+1  ;cmi/maw PATCH 1012
 . . . D SET^SDAM1(SDACNT_" "_$P(BSDWLR(DATE,LINE),U,2))
 . . . S ^TMP("SDAMIDX",$J,SDACNT)=VALMCNT_U_DFN_U_U_U_$S($D(SDDA):SDDA,1:""_U_$P(BSDWLR(DATE,LINE),U))  ;cmi/maw PATCH 1012
 . . . S LINEC=0 F  S LINEC=$O(BSDWLR(DATE,LINE,LINEC)) Q:'LINEC  D
 . . . . D SET^SDAM1($$SP(3)_$P(BSDWLR(DATE,LINE,LINEC),U,2))
 Q
 ;
OIASK ;EP; add/edit other info
 NEW SDW,X,BSDT,BSDC,BSDN,SDERR,BSDPT
 D FULL^VALM1
 ;
 ; select entry from list
 D SEL^SDAMEP Q:'$G(SDW)  Q:SDERR
 S X=^TMP("SDAMIDX",$J,SDW)
 I $P(X,U,6)]"" W !!,*7,">>> This is not a valid appointment." D PAUSE^VALM1 D END Q  ;cmi/maw 6/2/2010 PATCH 1012 for list view
 S BSDPT=$P(X,U,2)
 S BSDT=$P(X,U,3),BSDC=$P(X,U,4),BSDN=$$SCIEN^BSDU2(BSDPT,BSDC,BSDT)
 I 'BSDN D OIASK Q
 S X=$$OI(BSDC,BSDT,BSDN,BSDPT) I X=-1 D OIASK Q
 D END
 Q
 ;
FU ;EP; add follow up appointment
 NEW SDW,X,BSDT,BSDC,BSDN,SDERR,BSDPT
 D FULL^VALM1
 ;
 ; select entry from list
 D SEL^SDAMEP Q:'$G(SDW)  Q:SDERR
 S X=^TMP("SDAMIDX",$J,SDW)
 I $P(X,U,6)]"" W !!,*7,">>> This is not a valid appointment." D PAUSE^VALM1 D END Q  ;cmi/maw 6/2/2010 PATCH 1012 for list view
 S BSDPT=$P(X,U,2)
 ;S BSDT=$P(X,U,3),BSDC=$P(X,U,4),BSDN=$$SCIEN^BSDU2(BSDPT,BSDC,BSDT)
 S BSDT=$P(X,U,3),BSDC=$P(X,U,4),BSDN=$$GETAPT^SDVSIT2(BSDPT,BSDT,BSDC)
 I 'BSDN W !!,*7,">>>A followup appointment cannot be made until after the patient is checked in" D PAUSE^VALM1 D END Q  ;cmi/maw 8/20/2010 PATCH 1012
 N SDCOMKF
 D MC^SDCO5(BSDN,1,.SDCOMKF,.SDCOQUIT) Q:$D(SDCOQUIT)
 K BSDSRFU
 D END
 Q
 ;
OI(BSDC,BSDT,BSDN,DFN) ;EP; called by OI and by SDAMWI1
 ; ask user to update other info
 NEW BSDX,X,LEN,DIR,DA,DR,BSDNEW,BSDOLD
 S BSDX=$G(^SC(BSDC,"S",BSDT,1,BSDN,0)) I +BSDX'=DFN Q 0    ;appt node
 S BSDOLD=$P(BSDX,U,4)
 ;
 ; ask user to update other info
 ;cmi/flag/maw 05/13/2010 PATCH 1012 RQMT129, increased length to 155 characters, the max it can be in that subscript
 ;IHS/OIT/LJF 12/30/2005 PATCH 1005 added help to question
 S X="Enter Reason for Appointment; can be up to 155 characters long (no semi-colons or colons)"
 ;S BSDNEW=$$READ^BDGF("FO^1:150","OTHER INFO",$P(BSDX,U,4))
 S BSDNEW=$$READ^BDGF("FO^1:155","OTHER INFO",$P(BSDX,U,4),X)
 ;
 I BSDNEW[U Q 0
 I (BSDNEW[";")!(BSDNEW[":") D MSG^BDGF("Sorry no semi-colons or colons allowed",2,1) Q -1
 ;
 ; if changed, add to file
 S DIE="^SC("_BSDC_",""S"","_BSDT_",1,",DA=BSDN,DA(1)=BSDT,DA(2)=BSDC
 I BSDNEW="@",BSDOLD]"" S DR="3///@" D ^DIE Q 1
 I BSDOLD=BSDNEW Q 1
 S DR="3///"_BSDNEW D ^DIE
 Q 1
 ;
HS ;EP; print or browse health summary
 D FULL^VALM1,^BSDHSP D ^%ZISC D END Q
 ;
RXPROF ;EP; print med or action profile
 NEW DFN,CLN,TYPE,DIC,X,Y
 D FULL^VALM1
 ;
 ; select patient if not set
 S DFN=$G(SDFN)
 I '$D(SDFN) S DFN=+$$READ^BDGF("P^2:EMQZ","Select Patient")
 Q:DFN<1
 ;
 S TYPE=$$READ^BDGF("S^1:Medication Profile;2:Action Profile","Select Rx Profile to Print") Q:'TYPE
 ; select clinic if not set
 S CLN=$G(SDCLN)
 I '$D(SDCLN),TYPE=2 D  Q:CLN<1       ;only ask if APRO
 . S DIC="^SC(",DIC(0)="AEMZQ",DIC("A")="Select CLINIC: "
 . S DIC("S")="I $P(^(0),U,3)=""C"",'$G(^(""OOS""))"
 . D ^DIC K DIC S CLN=+Y
 ;
 I TYPE=1 D ZIS^BDGF("PQ","MP^BSDFORM("_DFN_")","MED PROFILE","") Q
 I TYPE=2 D ZIS^BDGF("PQ","APRO^BSDFORM("_CLN_","_DFN_","_DT_")","ACTION PROFILE","")
 Q
 ;
TESTS ;EP; append or delete ancillary tests
 D FULL^VALM1
 NEW X,Y
 S X=$$READ^BDGF("SO^A:ADD Ancillary Test;D:DELETE Ancillary Test","Select Action") Q:X=""  Q:X=U
 S Y=$S(X="A":"ADTEST",1:"DELTEST") D @Y
 Q
 ;
ADTEST ; append ancillary test to appt
 NEW SDW,SDERR,SD,SDCL,SDDA,SODT,SDWR,LAB,XRAY,EKG,X
 D SEL^SDAMEP Q:'$G(SDW)  Q:SDERR
 S X=^TMP("SDAMIDX",$J,SDW)
 I $P(X,U,6)]"" W !!,*7,">>> This is not a valid appointment." D PAUSE^VALM1 D END Q  ;cmi/maw 6/2/2010 PATCH 1012 for list view
 S DFN=$P(X,U,2)
 S SD=$P(X,U,3),SDCL=$P(X,U,4),SDDA=$$SCIEN^BSDU2(DFN,SDCL,SD)
 S Y=SD D DTS^SDUTL S SODT=Y,SDWR=0,(LAB,XRAY,EKG)=""
 I $$CO^BSDU2(DFN,SDCL,SD,SDDA) D  Q
 . W !?5,"** Appointment already checked out; cannot add test. **"
 . D PAUSE^BDGF,END
 D DISPTEST(DFN,SD)   ;displays any already scheduled
 D ORD^SDM3,END
 Q
 ;
DELTEST ; delete ancillary test from appt
 NEW SDW,SDERR,SD,SDCL,SDDA,X,BSDRR,DIR,DR,DA,DIE,Y,BSDX
 D SEL^SDAMEP Q:'$G(SDW)  Q:SDERR
 S X=^TMP("SDAMIDX",$J,SDW)
 I $P(X,U,6)]"" W !!,*7,">>> This is not a valid appointment." D PAUSE^VALM1 D END Q  ;cmi/maw 6/2/2010 PATCH 1012 for list view
 S SD=$P(X,U,3),SDCL=$P(X,U,4),DFN=$P(X,U,2),SDDA=$$SCIEN^BSDU2(DFN,SDCL,SD)
 ;
 I $$CO^BSDU2(DFN,SDCL,SD,SDDA) D  D END Q
 . W !?5,"** Appointment already checked out; cannot delete test. **"
 . D PAUSE^BDGF
 ;
 D DISPTEST(DFN,SD,1)   ;displays any already scheduled
 ;
 I '$D(BSDRR) D  D END  Q
 . W !,"** No tests scheduled; nothing to delete. **"
 . D PAUSE^BDGF
 ;
 S BSDX=$O(BSDRR(""),-1) I 'X D END Q
 K DIR S DIR(0)="NO^1",DIR("A")="Select Test to Delete" D ^DIR
 Q:Y<1  Q:Y>BSDX  K DIR
 S DR=(BSDRR(Y)+2)_"///@",DA=SD,DA(1)=DFN,DIE="^DPT("_DFN_",""S"","
 D ^DIE
 ;
 D END
 Q
 ;
END ; end of action; return to appt mgt menu      
 D BLD^SDAM
 S VALMBCK="R"
 Q
 ;
DISPTEST(PAT,DATE,SAVE) ; -- displays any ancillary tests already scheduled
 NEW DATA,LINE,I,CNT
 S DATA=$G(^DPT(DFN,"S",SD,0)) Q:'DATA
 F I=3,4,5 D           ;loop thru tests
 . Q:$P(DATA,U,I)=""   ;nothing scheduled for that test
 . S CNT=$G(CNT)+1,LINE(CNT,"F")="!?5"
 . S LINE(CNT)=$$TST(I)_" scheduled for "_$$FMTE^XLFDT($P(DATA,U,I))
 . ;
 . ; if need to select by line number, save test number
 . I $G(SAVE) S BSDRR(CNT)=I,LINE(CNT)=$J(CNT,2)_". "_LINE(CNT)
 D EN^DDIOL(.LINE)
 Q
 ;
TST(NUMBER) ; -- returns name of test by number
 Q $S(NUMBER=3:"LAB",NUMBER=4:"X-RAY",1:"EKG")
 ;
 ;IHS/OIT/LJF 01/19/2006 PATCH 1005 new code begins
 ;cmi/anch/maw 2/21/2006 PATCH 1007 checked code that calls VENPCC, no changes
OTHER ;EP; called by BSDAM OTHER REPORTS protocol
 ; if in Clinic Mode, ask for Patient
 D FULL^VALM1
 I SDAMTYP="C" NEW DFN,SDFN D  Q:$G(DFN)<1
 . D SEL^VALM2 I $O(VALMY(0)) S (DFN,SDFN)=$P(^TMP("SDAMIDX",$J,$O(VALMY(0))),U,2)
 . I $G(DFN) NEW VADM,VA D DEM^VADPT,MSG^BDGF($$SP(5)_VADM(1)_$$SP(6)_"#"_VA("BID"),1,1)
 ;
 ; ask user to select report(s) to print
 NEW BSDRPT,BSDA,X,Y,BSDXXX
 ;F X=1:1:7 S BSDA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)  cmi/maw 11/09/2009 PATCH 1011 orig line
 ;F X=1:1:8 S BSDA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)  ;cmi/maw 11/09/2009 PATCH 1011 added PWH
 F X=1:1:9 S BSDA(X)=$J(X,3)_". "_$P($T(RPT+X),";;",2)  ;cmi/maw 05/14/2010 PATCH 1012 added AIU
 ;S Y=$$READ^BDGF("LO^1:7","Choose Report(s) To Print","","","",.BSDA) Q:'Y  ;cmi/maw 11/09/2009 PATCH 1011 orig line
 ;S Y=$$READ^BDGF("LO^1:8","Choose Report(s) To Print","","","",.BSDA) Q:'Y  ;cmi/maw 11/09/2009 PATCH 1011 added PWH
 S Y=$$READ^BDGF("LO^1:9","Choose Report(s) To Print","","","",.BSDA) Q:'Y  ;cmi/maw 05/14/2010 PATCH 1012 added AIU
 ;
 S BSDXXX=Y F  S BSDRPT=$P($T(RPT+BSDXXX),";;",3) Q:BSDRPT=""  D
 . ;
 . I '$$AVAIL(+BSDXXX) D  Q        ;report not available to this user or this facility
 . . D MSG^BDGF("Sorry, you do not have access to print "_$P($T(RPT+BSDXXX),";;",2),1,1)
 . . D PAUSE^BDGF
 . . S BSDXXX=$P(BSDXXX,",",2,99)  ;reset list to reports not yet printed
 . ;
 . D MSG^BDGF($P($T(RPT+BSDXXX),";;",2),2,1)
 . S BSDXXX=$P(BSDXXX,",",2,99)  ;reset list to reports not yet printed
 . D @BSDRPT D ^%ZISC            ;print report
 ;
 I SDAMTYP="P",$G(DFN) D SETPT(DFN)   ;make sure all current patient variables set correctly
 I SDAMTYP="C" D KILL^AUPNPAT         ;make sure all patient variables are gone if in clinic mode
 Q
 ;
AVAIL(N) ; returns 1 if user has access to print report N
 NEW CODE
 S CODE=$P($T(RPT+N),";;",4) I CODE="" Q 1
 X CODE     ;returns Y set to 1 or 0
 Q Y
 ;
VST ; view pcc visits
 NEW BSDSAV
 S (BSDSAV,APCDPAT)=DFN D GETVISIT^APCDDISP
 I APCDVSIT="" W !!,"No VISIT selected!" D PAUSE^BDGF Q
 D ^APCDVD,EOJ^APCDDISP
 S (DFN,AUPNPAT)=BSDSAV D SETPT(DFN)
 S VALMBCK="R"
 Q
 ;
SETPT(DFN) ;sets AUPN variables when DFN is set
 NEW X,DIC,Y S X="`"_DFN,DIC=2,DIC(0)="" D ^DIC Q
 ;IHS/OIT/LJF 01/19/2006 PATCH 1005 new code ends
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;IHS/OIT/LJF 07/12/2006 PATCH 1006 changed line label for PCC+ form
RPT ;;IHS/OIT/LJF 01/19/2006 PATCH 1005 added lines below
 ;;Routing Slip;;WISD^BSDROUT(+$G(DFN),DT,"RS","",1);;
 ;;Face Sheet;;DFN^AGFACE;;
 ;;Rx Profiles;;RXPROF^BSDAM;;S Y=$S('$D(^XUSEC("DGZNOCLN",DUZ)):1,1:0);;
 ;;PCC+ Form;;PIMS^VENPCC(+$G(DFN));;S Y=$S($L($T(PIMS^VENPCC))=0:0,'$D(^XUSEC("VENZPRINT",DUZ)):0,1:1);;
 ;;Visit Display;;VST^BSDAM;;
 ;;Chart Locator;;PAT^BSDCF;;
 ;;CWAD Notes;;CWAD^TIULX;;S Y=$S($L($T(CWAD^TIULX))=0:0,'$D(^XUSEC("TIUZCWAD",DUZ)):0,1:1);;
 ;;Patient Wellness Handout;;PWH^BSDROUT("OR",DFN,DT);;
 ;;Address/Insurance Update;;OR^BSDAIU;;
