BSDPCP ; IHS/ANMC/LJF,WAR - UPDATE PCP FOR GROUP OF PTS ;  
 ;;5.3;PIMS;**1003,1004,1007**;DEC 01, 2006
 ;IHS/ITSC/LJF 06/17/2005 PATCH 1003 screened out deceased patients
 ;IHS/OIT/LJF  09/28/2005 PATCH 1004 allow inactive providers in listing
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added line in ASKPN and code in GATHER for item 1007.11
 ;
PROV ; -- ask user to select a provider
 NEW BSDPRV,SCREEN,BSDFL,BSDAAPN
 S BSDFL=$S($P(^DD(9000001,.14,0),U,2)["200":200,1:6),SCREEN=""
 ;I BSDFL=200 S SCREEN="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 I BSDFL=200 S SCREEN="I $D(^XUSEC(""PROVIDER"",+Y))"    ;IHS/OIT/LJF 09/28/2005 PATCH 1004
 S BSDPRV=+$$READ^BDGF("PO^"_BSDFL_":EMQZ","Select a PRIMARY CARE PROVIDER","","",SCREEN) Q:BSDPRV<1
 D ASKPN  ;cmi/anch/maw 11/9/2006 added item 1007.11 patch 1007
 ;
EN ; -- main entry point for SD IHS PCP LIST
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSD PCP LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S VALMHDR(2)=$$SP(18)_"Patient List for "_$$GET1^DIQ(BSDFL,BSDPRV,.01)
 S VALMSG="- Previous Screen  Q Quit  ?? for More Actions"
 Q
 ;
INIT ; -- init variables and list array
 NEW BSDLN
 D GATHER
 S VALMCNT=BSDLN
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K VALMCNT,VALMQUIT,BSDPRV
 K ^TMP("BSDPCP",$J),^TMP("BSDPCP2",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
RESET ; -- code executed upon return
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
RESET2 ; -- code executed upon return
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 Q
 ;
GATHER ; -- build display array
 NEW DFN,NAME,COMM,LINE,COUNT
 D MSG^BDGF("Building Patient List. . .Please wait.",1,0)
 K ^TMP("BSDPCP",$J),^TMP("BSDPCP1",$J),^TMP("BSDPCP2",$J)
 S BSDLN=0
 S DFN=0 F  S DFN=$O(^AUPNPAT("AK",+BSDPRV,DFN)) Q:'DFN  D
 . ;
 . ;IHS/ITSC/LJF 6/17/2005 PATCH 1003 screen out deceased patients
 . Q:$$DOD^AUPNPAT(DFN)      ;skip if patient has date of death recorded
 . ;
 . S NAME=$$GET1^DIQ(2,DFN,.01)
 . S COMM=$$GET1^DIQ(9000001,DFN,1118) S:COMM="" COMM="??"
 . ;S ^TMP("BSDPCP1",$J,COMM,NAME,DFN)=""  cmi/anch/maw 11/9/2006 orig line item 1007.11 patch 1007
 . I $G(BSDAPN)="C" S ^TMP("BSDPCP1",$J,COMM,NAME,DFN)=""  ;cmi/anch/maw 11/9/2006 new line item 1007.11 patch 1007
 . I $G(BSDAPN)="P" S ^TMP("BSDPCP1",$J,NAME,COMM,DFN)=""  ;cmi/anch/maw 11/9/2006 new line added item 1007.11 patch 1007 
 ;
 ;cmi/anch/maw added below line for item 1007.11 patch 1007
 I $G(BSDAPN)="C" D  ;cmi/anch/maw 11/9/2006 added for item 1007.11 patch 1007
 . S COMM=0 F  S COMM=$O(^TMP("BSDPCP1",$J,COMM)) Q:COMM=""  D
 .. S NAME=0 F  S NAME=$O(^TMP("BSDPCP1",$J,COMM,NAME)) Q:NAME=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BSDPCP1",$J,COMM,NAME,DFN)) Q:'DFN  D
 .... S COUNT=$G(COUNT)+1,LINE=$$PAD($J(COUNT,4)_" "_NAME,25)
 .... S LINE=LINE_$J($$HRN^AUPNPAT(DFN,DUZ(2)),8)_"  "_COMM
 .... S LINE=$$PAD(LINE,50)_$$LASTVST(DFN)
 .... D SET(LINE,+$G(COUNT),DFN)
 .... S ^TMP("BSDPCP2",$J,COMM,DFN)=""
 ;
 ;cmi/anch/maw added below lines for item 1007.11 patch 1007
 I $G(BSDAPN)="P" D  ;cmi/anch/maw 11/9/2006 added for item 1007.11 patch 1007
 . S NAME=0 F  S NAME=$O(^TMP("BSDPCP1",$J,NAME)) Q:NAME=""  D
 .. S COMM=0 F  S COMM=$O(^TMP("BSDPCP1",$J,NAME,COMM)) Q:COMM=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BSDPCP1",$J,NAME,COMM,DFN)) Q:'DFN  D
 .... S COUNT=$G(COUNT)+1,LINE=$$PAD($J(COUNT,4)_" "_NAME,25)
 .... S LINE=LINE_$J($$HRN^AUPNPAT(DFN,DUZ(2)),8)_"  "_COMM
 .... S LINE=$$PAD(LINE,50)_$$LASTVST(DFN)
 .... D SET(LINE,+$G(COUNT),DFN)
 .... S ^TMP("BSDPCP2",$J,NAME,DFN)=""
 ;
 I '$G(COUNT) D SET($$SP(10)_"NONE FOUND",0,0)
 K ^TMP("BSDPCP1",$J)
 Q
 ;
SET(L,C,N) ; -- set display line into array
 S BSDLN=BSDLN+1 S:N=0 N=1
 S ^TMP("BSDPCP",$J,BSDLN,0)=L
 S ^TMP("BSDPCP",$J,"IDX",BSDLN,C)=N
 Q
 ;
LASTVST(DFN) ; -- returns date, serv cat, and clinic/srv of last visit
 NEW X,V,CAT,VDT,CLIN,LINE
 S X=0 F  S X=$O(^AUPNVSIT("AA",DFN,X)) Q:('X)!($D(LINE))  D
 . S V=0 F  S V=$O(^AUPNVSIT("AA",DFN,X,V)) Q:'V  D
 .. S CAT=$$SC^APCLV(V,"I") Q:"OHATS"'[CAT
 .. S VDT=$$VD^APCLV(V,"S"),CLIN=$$CLINIC^APCLV(V,"E")
 .. I CAT="H" S CLIN=$$DSCHSERV^APCLV(V,"E")
 .. S CAT=$$SC^APCLV(V,"E")
 .. S LINE=$$PAD($J(VDT,8),10)_$E(CAT,1,3)_"  "_CLIN
 Q $G(LINE)
 ;
 ;
GETITEM ; -- select item from list
 K BSDRR
 D EN^VALM2(XQORNOD(0),"O")
 I '$D(VALMY) Q
 NEW X,Y,Z,F
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BSDPCP",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BSDPCP",$J,"IDX",Y,0))
 .. Q:^TMP("BSDPCP",$J,"IDX",Y,Z)=""  Q:(Z'=X)
 .. S BSDRR(X)=^TMP("BSDPCP",$J,"IDX",Y,Z)
 .. S Y=99999999
 D CLEAR^VALM1,FULL^VALM1
 Q
 ;
PATLOOP ;EP; -- called to edit by patient from PCP List
 NEW BSDRR,BSDCNT,DFN
 D GETITEM I '$D(BSDRR) D RESET2 Q
 D FULL^VALM1
 S BSDCNT=0 F  S BSDCNT=$O(BSDRR(BSDCNT)) Q:'BSDCNT  D
 . S DFN=BSDRR(BSDCNT) Q:'DFN
 . D MSG^BDGF($J(BSDCNT,4)_"  "_$$GET1^DIQ(2,DFN,.01)_":",2,0)
 . D ONEPAT(DFN)
 D RESET
 Q
 ;
COMLOOP ;EP; -- called to edit by community from PCP List
 NEW BSDCOMN,Y,SCREEN,BSDNEW,BSDREAS,DIE,DA,DR
 D FULL^VALM1
 S Y=$$READ^BDGF("PO^9999999.05:EQMZ") I 'Y D RESET2 Q
 S BSDCOMN=$P(Y,U,2)
 ;
 S SCREEN=""
 I BSDFL=200 S SCREEN="I $D(^XUSEC(""PROVIDER"",BSDPRV)),$P($G(^VA(200,BSDPRV,""PS"")),U,4)="""""
 S Y=+$$READ^BDGF("PO^"_BSDFL_":EMQZ","Enter new PRIMARY CARE PROVIDER","","",SCREEN)
 I Y<1 D RESET2 Q
 S BSDNEW=+Y
 ;
 S BSDREAS=+$$READ^BDGF("PO^9999999.93:EMQZ","Select REASON for CHANGE")
 I BSDREAS<1 D RESET2 Q
 ;
 D MSG^BDGF("I will now convert the Primary Care Provider for patients of ",2,0)
 D MSG^BDGF($$SP(15)_$$GET1^DIQ(BSDFL,BSDPRV,.01)_" in "_BSDCOMN,1,0)
 D MSG^BDGF("to"_$$SP(13)_$$GET1^DIQ(BSDFL,BSDNEW,.01),1,0)
 I '$$READ^BDGF("YO","Ready to continue","NO") D RESET2 Q
 ;
 S DIE="^AUPNPAT(",DR=".14///`"_BSDNEW_";.37///`"_BSDREAS
 S DFN=0 F  S DFN=$O(^TMP("BSDPCP2",$J,BSDCOMN,DFN)) Q:'DFN  D
 . S DA=DFN D ^DIE W "."
 D RESET
 Q
 ;
UPD ;EP; -- called by update all patients from PCP List
 D CLEAR^VALM1,MSG^BDGF($$SP(20)_"CONVERT PRIMARY CARE PROVIDER",2,2)
 NEW Y,BSDNEW,SCREEN,BSDREAS
 S SCREEN=""
 I BSDFL=200 S SCREEN="I $D(^XUSEC(""PROVIDER"",+Y)),$P($G(^VA(200,+Y,""PS"")),U,4)="""""
 S Y=+$$READ^BDGF("PO^"_BSDFL_":EMQZ","Enter new PRIMARY CARE PROVIDER","","",SCREEN)
 Q:Y<1  S BSDNEW=+Y
 ;
 S BSDREAS=""
 F  Q:+BSDREAS>0!(BSDREAS="^")  D
 .S BSDREAS=$$READ^BDGF("PO^9999999.93:EMQZ","Select REASON for CHANGE")
 .I BSDREAS=-1 D
 ..W !!,$C(7),"You must enter a REASON or '^' to Quit"
 ..D PAUSE^BDGF
 I BSDREAS<1 D RESET2 Q
 S BSDREAS=+BSDREAS
 ;
 D MSG^BDGF("I will now convert the Primary Care Provider for patients of ",2,0)
 D MSG^BDGF($$SP(15)_$$GET1^DIQ(BSDFL,BSDPRV,.01),1,0)
 D MSG^BDGF("to"_$$SP(13)_$$GET1^DIQ(BSDFL,BSDNEW,.01),1,0)
 I '$$READ^BDGF("YO","Ready to continue","NO") D RESET2 Q
 ;
 S DIE="^AUPNPAT(",DR=".14///`"_BSDNEW_";.37///`"_BSDREAS
 S DFN=0 F  S DFN=$O(^AUPNPAT("AK",BSDPRV,DFN)) Q:'DFN  D
 . S DA=DFN D ^DIE W "."
 ;
 S BSDPRV=BSDNEW D RESET
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;
GETPAT ;EP;-- edit PCP for 1 patient when patient not known
 NEW DIC,Y,DFN
 S Y=1 F  D  Q:Y<1
 . S DIC=9000001,DIC(0)="AEMQ" D ^DIC Q:Y<1
 . S DFN=+Y
 . NEW Y,I W ! D PCPDISP^BSDU1(DFN,.Y) F I=1:1 Q:'$D(Y(I))  W !,Y(I)
 . Q:'$$READ^BDGF("Y","Want to CHANGE this patient's Providers","NO")
 . D ONEPAT(DFN) S Y=DFN
 Q
 ;
ONEPAT(DFN) ; once patient is selected, edit PCP fields
 NEW BEFORE,DIE,DA,DR,DITC
 S BEFORE=$$GET1^DIQ(9000001,DFN,.14,"I")  ;current PCP
 S DIE="^AUPNPAT(",DA=DFN,DR=".14" D ^DIE  ;edit PCP
 ;
 ; if PCP changed, ask reason (date and user updated via triggers)
 I BEFORE]"",BEFORE'=$$GET1^DIQ(9000001,DFN,.14,"I") D  Q:$D(Y)
 . S DITC="",DIE="^AUPNPAT(",DA=DFN,DR=".37///@" D ^DIE
 . S DIE="^AUPNPAT(",DA=DFN,DR=".37" D ^DIE
 ;
 I $$GET1^DIQ(2,DFN,.02)="FEMALE",$D(^BWP(DFN)) D WHREF(DFN)
 Q
 ;
WHREF(PAT) ; edit WH Referral Provider
 NEW DIE,BEFORE,DA,DR
 S BEFORE=$$GET1^DIQ(9002086,PAT,.25,"I")
 S DIE="^BWP(",DA=DFN,DR=".25" D ^DIE
 I BEFORE]"",BEFORE'=$$GET1^DIQ(9002086,DFN,.25,"I") D
 . S DIE="^BWP(",DA=DFN,DR=".28///@" D ^DIE
 . S DIE="^BWP(",DA=DFN,DR=".28" D ^DIE
 Q
 ;
AMPCP ;EP; update PCP from Appt Mgt
 D FULL^VALM1
 I $G(DFN) D  S VALMBCK="R" Q
 . NEW Y,I W ! D PCPDISP^BSDU1(DFN,.Y) F I=1:1 Q:'$D(Y(I))  W !,Y(I)
 . Q:'$$READ^BDGF("Y","Want to CHANGE this patient's Providers","NO")
 . D ONEPAT(DFN)
 ;
 D GETPAT S VALMBCK="R"
 Q
 ;cmi/anch/maw added ASKPN 11/9/2006 item 1007.11 patch 1007
ASKPN ;EP - ask if they want to sort by patient name
 S BSDAPN=$$READ^BDGF("S^C:Community of Residence;P:Patient Name","Sort By","Community of Residence")
 Q
 ;
