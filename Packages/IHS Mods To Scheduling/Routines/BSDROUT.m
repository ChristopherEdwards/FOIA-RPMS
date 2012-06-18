BSDROUT ; IHS/ANMC/LJF,WAR - IHS CALLS FROM SDROUT ;  
 ;;5.3;PIMS;**1001,1003,1005,1006,1007,1009,1010,1011**;DEC 01, 2006
 ;IHS/ITSC/WAR 8/19/2004 PATCH #1001 set date range for appt letter from tomorrow to a year from now
 ;IHS/ITSC/WAR 10/21/2004 PATCH 1001 Check for DFN if user enters by Clinic, but does not select a Pt
 ;IHS/ITSC/LJF 10/25/2004 PATCH 1001 Changed default for Want to print Appt Letter to YES
 ;IHS/ITSC/LJF 06/17/2005 PATCH 1003 added ability to call for single RS without a health summary
 ;IHS/OIT/LJF  02/16/2006 PATCH 1005 added RSCI subroutine to pull charts at checkin
 ;             07/07/2006 PATCH 1006 WISD now a PEP (public entry point); used by ERS
 ;cmi/anch/maw 11/22/2006 PATCH 1007 added modifications for items 1007.05 and 1007.16
 ;cmi/anch/maw 01/20/2007 PATCH 1007 added mods in APPT to check for mult appt book flab BSDMK item 1007.13
 ;cmi/anch/maw 04/07/2008 PATCH 1009 added code in RSCI and APPT for default prompt for chart request requirement 61
 ;cmi/anch/maw 05/01/2009 PATCH 1010 added code in RSCI and APPT to default BSDPAR to first entry if DIV is not defined
 ;cmi/flag/maw 10/15/2009 PATCH 1011 added code PWH to get patient wellness handout RQMT121
 ;
ASK ;EP; called by SDROUT to ask rest of the questions
 NEW BSDI,BSDQ
 S BSDQ=0
 F BSDI="SORT","DATE","CLINIC","REPRINT" D @BSDI I BSDQ D END^SDROUT Q
 I 'BSDQ D DEVICE
 Q
 ;
SORT ; ask user for sort choice    
 S ORDER=$$READ^BDGF("S^1:TERMINAL DIGIT;2:CLINIC NAME;3:PRINCIPAL CLINIC;4:PATIENT NAME","Choose Sort Order","","^D R3HELP^BSDROUT")
 I (ORDER="")!(ORDER=U) S BSDQ=1
 Q
 ;
DATE ; ask appt date to process
 S SDATE=$$READ^BDGF("DO^::EXF","PRINT ROUTING SLIPS FOR WHAT DATE")
 I SDATE<1 S BSDQ=1
 Q
 ;
CLINIC ; ask clinic selection if sort 2 or 3
 ;
 I (ORDER=1)!(ORDER=4) S VAUTC=1 D  Q
 . I $G(DIV)="" S VAUTD=1 Q                  ;set to all divisions
 . S VAUTD=0,VAUTD(DIV)=$$DIVNM^BSDU(DIV)    ;division already set
 D CLINIC^BSDU(2,"",1) S BSDQ=$S($D(BSDQ):1,1:0) Q
 ;
REPRINT ; ask if this is a reprint
 Q:$G(SDX)'["ADD"  ;cmi/anch/maw added line for item 1007.16 patch 1007
 S SDREP=$$READ^BDGF("Y","IS THIS A REPRINT OF A PREVIOUS RUN","NO")
 I SDREP=U S BSDQ=1 Q
 I SDREP=0 D  Q
 . I (ORDER=2)!(ORDER=3) Q
 . D RANGE("PRINT")
 ;
 I SDX["ADD" S SDSTART=$$READ^BDGF("DO^::EX","REPRINT ADD-ONS THAT WERE RUN ON WHAT DATE") S:SDSTART<1 BSDQ=1 Q
 I (ORDER=1)!(ORDER=4) D RANGE("REPRINT")
 Q
 ;
RANGE(TYPE) ; ask to print a small batch
 NEW BSDX,HELP
 S BSDX=$S(ORDER=1:"TERMINAL DIGIT",1:"PATIENT NAME")
 S HELP="THE "_TYPE_" WILL BEGIN PRINTING AT THE "_BSDX_"YOU SPECIFY"
 S SDSTART=$$READ^BDGF("F^1:30","ENTER "_BSDX_" TO BEGIN "_TYPE_" FROM","FIRST",HELP)
 I SDSTART=U S BSDQ=1 Q
 I SDSTART="FIRST" S SDSTART="" Q
 I ORDER=1,SDSTART'?2N D MSG^BDGF("Must enter 2 digits",2,1) D RANGE(TYPE) Q
 ;
RANGE2 ;
 S SDSTOP=$$READ^BDGF("F^1:30","ENTER "_BSDX_" ON WHICH TO STOP PRINT","LAST")
 I SDSTOP=U S BSDQ=1 Q
 I SDSTOP="LAST" S SDSTOP="" Q
 I ORDER=1,SDSTOP'?2N D MSG^BDGF("Must enter 2 digits",2,1) D RANGE2 Q
 Q
 ;
DEVICE ; ask print device
 S VAR="DIV^VAUTC^VAUTC(^SDX^ORDER^SDATE^SDIQ^SDREP^SDSTART^SDSTOP^VAUTD^VAUTD("
 S DGPGM="START^BSDROUT"
 S BDGDEV=$$GET1^DIQ(40.8,$$DIV^BSDU,9) K:BDGDEV="" BDGDEV
 D ZIS^DGUTQ I POP D END^SDROUT1 Q
 D START^BSDROUT
 Q
 ;
START ;EP; entry point when printing routing slip batch
 ; IHS modified version of START^SDROUT
 K ^TMP("SDRS",$J) U IO
 K ^TMP("SDRS1",$J)
 S Y=SDATE D DTS^SDUTL S APDATE=Y,Y=DT D DTS^SDUTL S PRDATE=Y
 ;
 NEW BSDSC,BSDGD,BSDL,SC
 I $G(VAUTC)=1 D
 .S BSDSCIND="S BSDSC=$O(^SC(BSDSC))"
 E  D
 .S BSDSCIND="S BSDSC=$O(VAUTC(BSDSC))"
 S BSDSC=0 F  X BSDSCIND Q:'BSDSC  S SC=BSDSC D CHECK^SDROUT I $T D
 . S BSDGD=SDATE
 . F  S BSDGD=$O(^SC(BSDSC,"S",BSDGD)) Q:('BSDGD)!(BSDGD>(SDATE+1))  D
 .. I $D(^SC(BSDSC,"S",BSDGD,1)) S BSDL=0 F  S BSDL=$O(^SC(BSDSC,"S",BSDGD,1,BSDL)) Q:'BSDL  I $D(^(BSDL,0)),$P(^(0),U,9)'="C" D FIND^BSDROUT0(BSDSC,BSDGD,BSDL,ORDER,"")
 D CRLOOP^BSDROUT2
 D PRINT^BSDROUT1(ORDER,SDATE)
 Q
 ;
R3HELP ;EP; user help for Sort question
 D MSG^BDGF("Select the order in which you want the routing slips printed.",2,1)
 D MSG^BDGF("  Choose 1 to print by terminal digit order",1,0)
 D MSG^BDGF("   (Or by chart # order if site parameter set that way.)",1,0)
 D MSG^BDGF("  Choose 2 to print by name for selected clinics.",1,0)
 D MSG^BDGF("  Choose 3 to print by principal clinic names.",1,0)
 D MSG^BDGF("   (Subtotaled by terminal digit within these categories.)",1,0)
 D MSG^BDGF("  Choose 4 to print alphabetically by patient name.",1,1)
 Q
 ;
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003 added BSDNHS parameter
 ;IHS/OIT/LJF 07/07/2006 PATCH 1006 now a public entry point
WISD(DFN,SDATE,BSDMODE,BSDDEV,BSDNHS) ;PEP; print routing slip for walkin/same day appt
 ; called by SDAMWI1 for walkins; BSDMODE="WI"
 ; called by ONE^BSDROUT for single patient rs; BSDMODE=""
 ; called by APPT for same day appt; BSDMODE="SD"
 ; called by BSDAPP for chart requests for today
 ; called by RS protocol with BSDNHS=1 so no health summary will print;PATCH 1003
 ;
 ;IHS/ITSC/WAR 10/21/04; PATCH #1001
 ; Check for DFN if user enters by Clinic, but does not select a Pt
 I +DFN=0 D
 .S DIR(0)="N^"_VALMBG_":"_VALMLST
 .D ^DIR
 .I +Y>0 S DFN=+$P($G(^TMP("SDAMIDX",$J,+Y)),U,2)
 I +DFN=0 Q
 ;***** END 10/21/04
 ;
 NEW DGPGM,VAR,VAR1,DEV,POP
 S SDX="ALL",ORDER="",SDREP=0,SDSTART="",DIV=$$DIV^BSDU
 ;
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003 adde BSDNHS to variable list
 ;S VAR="DIV^ORDER^SDX^SDATE^DFN^SDREP^SDSTART^BSDMODE"
 ;S VAR1="DIV;ORDER;SDX;SDATE;DFN;SDREP;SDSTART;BSDMODE"
 S VAR="DIV^ORDER^SDX^SDATE^DFN^SDREP^SDSTART^BSDMODE^BSDNHS"
 S VAR1="DIV;ORDER;SDX;SDATE;DFN;SDREP;SDSTART;BSDMODE;BSDNHS"
 ;end of these PATCH 1003 changes
 ;
 S DGPGM="SINGLE^BSDROUT"
 I $G(BSDDEV)]"",$G(DGQUIET) D ZIS^BDGF("F","SINGLE^BSDROUT","ROUTING SLIP",VAR1,BSDDEV) Q
 S DEV=$S(BSDMODE="CR":".05",1:".11")   ;default printer fields
 S BDGDEV=$$GET1^DIQ(9009020.2,$$DIV^BSDU,DEV)
 I BDGDEV="" K BDGDEV I $G(DGQUIET) Q
 S %ZIS("A")="FILE ROOM PRINTER: " D ZIS^DGUTQ I POP D END^SDROUT1 Q
 D SINGLE
 Q
 ;
ONE ;EP; called by SDROUT to print one patient's routing slip
 S DFN=+$$READ^BDGF("PO^2:EQM","Select PATIENT") I DFN<1 D END^SDROUT Q
 D WISD(DFN,DT,"")
 Q
 ;
SINGLE ;EP; queued entry point for single routing slips
 ; called by WISD subroutine
 U IO K ^TMP("SDRS",$J)
 NEW BSDT,CLN,IEN,BSDMOD2
 ;
 ; find all appts for patient
 I BSDMODE="CR" S BSDMOD2="CR",BSDMODE=""
 S BSDT=SDATE\1
 F  S BSDT=$O(^DPT(DFN,"S",BSDT)) Q:'BSDT  Q:(BSDT\1>SDATE)  D
 . S CLN=+$G(^DPT(DFN,"S",BSDT,0)) Q:'CLN   ;clinic ien
 . S IEN=0 F  S IEN=$O(^SC(CLN,"S",BSDT,1,IEN)) Q:'IEN  Q:$P($G(^SC(CLN,"S",BSDT,1,IEN,0)),U)=DFN
 . Q:'IEN                                   ;appt ien in ^sc
 . D FIND^BSDROUT0(CLN,BSDT,IEN,ORDER,BSDMODE)
 I $D(BSDMOD2) S BSDMODE=BSDMOD2
 ;
 ; find all chart requests for patient
 S CLN=0 F  S CLN=$O(^SC("AIHSCR",DFN,CLN)) Q:'CLN  D
 . S BSDT=(SDATE\1)-.0001
 . F  S BSDT=$O(^SC("AIHSCR",DFN,CLN,BSDT)) Q:'BSDT  D
 .. D CRSET^BSDROUT2(CLN,BSDT,DFN,ORDER)
 ;
 ; if no future appts, set something so RS will print
 I '$D(^TMP("SDRS",$J)) S ^TMP("SDRS",$J,$$GET1^DIQ(2,DFN,.01),$$TERM(DFN),DFN)=""
 ;
 D PRINT^BSDROUT1(ORDER,SDATE)
 Q
 ;
APPT(EVENT,DFN,DATE) ;EP; called by BSDAM APPT SLIP protocol
 ; which is called by BSDAM APPOINTMENT EVENTS protocol
 ;  which is called by EVT^SDAMEVT via MAKE^SDAMEVT via ^SDM1A
 ;   from making appointment
 ;
 ;cmi/maw 1/20/2007 check for mult appt book flag BSDMK, if there quit until it is not patch 1007 item 1007.13'
 Q:$G(BSDMK)
 ;cmi/maw 1/20/2007 end of mods
 ;
 Q:$G(SDMODE)=2   ;quiet mode
 ; save variables not used that event driver needs back
 NEW SDT,SDCL,SDDA,SDATA,SDAMEVT,SDMODE
 NEW SDC
 Q:IOST'["C-"                              ;quit if printer is device
 Q:$G(BSDNO)                               ;quit if rebook
 Q:EVENT'=1                                ;not make appt
 Q:$P($G(^DPT(DFN,"S",DATE,0)),U,7)'=3     ;not sched appt
 ;
 ; print routing slip for same day appt
 N BSDPAR  ;cmi/maw 5/2/2009 patch 1010
 S BSDPAR=$O(^BSDPAR("B",0))  ;cmi/maw 5/2/2009 patch 1010
 I (DATE\1)=($P(^DPT(DFN,"S",DATE,0),U,19)\1) D  Q
 . I '$G(DIV) Q:$$READ^BDGF("Y","Want Chart Requested",$S($P($G(^BSDPAR(BSDPAR,0)),U,25):"YES",1:"NO"),"^D HELPA^BSDROUT")'=1  ;cmi/maw 04/07/2008 orig line
 . I $G(DIV) Q:$$READ^BDGF("Y","Want Chart Requested",$S($P($G(^BSDPAR(DIV,0)),U,25):"YES",1:"NO"),"^D HELPA^BSDROUT")'=1  ;cmi/maw 04/07/2008 PATCH 1009 mod line for default
 . D WISD(DFN,DATE,"SD",$$GET1^DIQ(9009020.2,$$DIV^BSDU,.05))
 ;
 ; ask to print appt letter for patient
 Q:$$GET1^DIQ(9009020.2,$$DIV^BSDU,.02)'="YES"  ;site parameter
 ;Q:$$READ^BDGF("Y","Want to Print Appointment Letter for Patient","NO","^D HELPB^BSDROUT")'=1
 Q:$$READ^BDGF("Y","Want to Print Appointment Letter for Patient","YES","^D HELPB^BSDROUT")'=1  ;IHS/ITSC/LJF 10/25/2004 PATCH 1001
 ;
 ; set up variables for call
 NEW X,L2,SDCONC,SDLT,DIV,SDV1,SDFORM,SDLET,SDLT1,SDBD,SDED,SDTIME
 NEW S1,VAUTD,VAUTN,L0
 NEW SDDAT       ;saved for multibook rtn
 S L2="^SDL1",SDCONC="B",SDLT=1,L0="P"
 S DIV=$$DIV^BSDU,SDV1=DIV,SDFORM=+$$GET1^DIQ(40.8,DIV,30.01,"I")
 S VAUTD=0,VAUTD(DIV)=$$GET1^DIQ(40.8,DIV,.01)
 ;cmi/anch/maw 11/22/06 split below line to get letter format
 ;cmi/anch/maw 11/22/2006 adding code to select letter format if field .23 of IHS SCHEDULING PARAMETER file is set to yes item 1007.04 and 1007.05 patch 1007
 S X=+$G(^DPT(DFN,"S",DATE,0))  ;cmi/anch/maw 11/22/06 added item 1007.04 patch 1007
 S SDLET=""  ;cmi/anch/maw 11/22/06 added line for item 1007.04 patch 1007
 I $$GET1^DIQ(9009020.2,DIV,.23,"I") D  ;cmi/anch/maw 11/22/06 added for item 1007.04 patch 1007
 . S SDLET=+$$READ^BDGF("P^407.5:EMQZ","Select Letter",$$GET1^DIQ(44,X,2509))  ;cmi/anch/maw 11/22/06 added for item 1007.04 patch 1007
 I $G(SDLET) D MSG^BDGF($$GET1^DIQ(407.5,SDLET,.01)_" letter selected",2,1)  ;cmi/anch/maw 12/5/2006 added to display letter selected
 ;
 ;S X=+$G(^DPT(DFN,"S",DATE,0)),SDLET=$$GET1^DIQ(44,X,2509,"I")  ;cmi/anch/maw 11/22/06 orig line item 1007.04 patch 1007
 I SDLET="" S SDLET=$$GET1^DIQ(44,X,2509,"I")  ;cmi/anch/maw 11/22/06 item 1007.04 patch 1007
 I SDLET="" S SDLET=$O(^VA(407.5,"B","APPOINTMENT SLIP",0))
 I SDLET="" D MSG^BDGF("Sorry, no letter set up to print.  See Application Coordinator.",2,1) Q
 ;
 ;IHS/ITSC/WAR 8/19/2004 PATCH #1001 set date range starting with tomorrow
 ;S SDLT1=SDLET,SDBD=DT,SDED=$$FMADD^XLFDT(DT,365),SDTIME="*"
 S SDLT1=SDLET,SDBD=$$FMADD^XLFDT(DT,1),SDED=$$FMADD^XLFDT(DT,365),SDTIME="*"
 S VAUTN=0,VAUTN(DFN)=$$GET1^DIQ(2,DFN,.01),S1="P"
 ;
 D QUE^SDLTP
 Q
 ;
PWH(EVENT,DFN,DATE) ;EP; called by BSDAM PWH AT CHECKIN protocol;cmi/flag/maw 10/19/2009 PATCH 1011
 Q:$T(EN2^APCHPWHG)=""  ;pcc v2.0 not loaded
 I '$G(DATE) S DATE=DT
 ; which is called by BSDAM APPOINTMENT EVENTS protocol
 ; Used at sites with so many no-shows that charts are not pulled until patients arrive
 ;
 Q:$G(SDMODE)=2   ;quiet mode
 ; save variables not used that event driver needs back
 NEW SDDA,SDATA,SDAMEVT,SDMODE,SDC,VALMY,SDI,SDAT,BSDPWH
 Q:IOST'["C-"                                                ;quit if printer is device
 I $G(EVENT)'="OR" Q:EVENT'=4                                                  ;not checkin
 ;Q:$$GET1^DIQ(9009020.2,$$DIV^BSDU,.22)'="YES"               ;parameter not turned on
 I $G(EVENT)'="OR" Q:$P($G(^DPT(DFN,"S",DATE,0)),U,7)'=3                       ;not sched appt
 I $G(EVENT)'="OR" Q:'$$CI^BSDU2(DFN,SDCL,DATE,$$SCIEN^BSDU2(DFN,SDCL,DATE))   ;quit if check in deleted
 ;
 S DIV=$$DIV^BSDU
 Q:$$READ^BDGF("Y","Want Patient Wellness Handout","NO","^D HELPA^BSDROUT")'=1
 S BSDPWH=$$SELTYP
 Q:'$G(BSDPWH)
 D EN2^APCHPWHG(BSDPWH,DFN)
 I $D(VALMBCK),VALMBCK="R" D REFRESH^VALM S VALMBCK=$P(VALMBCK,"R")_$P(VALMBCK,"R",2)
 Q
 ;
SELTYP() ;
 K DIADD,DLAYGO
 N BSDPWHT
 D ^XBFMK
 K DIC S DIC="^APCHPWHT(",DIC("A")="Select Patient Wellness Handout type: ",DIC(0)="AEQM"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,16)
 I $D(^DISV(DUZ,"^APCHPWHT(")) S Y=^("^APCHPWHT(") I $D(^APCHPWHT(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR"
 S DIC("B")=X
 D ^DIC K DIC
 I Y=-1 Q 0
 S BSDPWHT=+Y
 Q BSDPWHT
 ;
RSCI(EVENT,DFN,DATE) ;EP; called by BSDAM RS AT CHECKIN protocol;IHS/OIT/LJF 02/16/2006 PATCH 1005
 ; which is called by BSDAM APPOINTMENT EVENTS protocol
 ; Used at sites with so many no-shows that charts are not pulled until patients arrive
 ;
 Q:$G(SDMODE)=2   ;quiet mode
 ; save variables not used that event driver needs back
 NEW SDDA,SDATA,SDAMEVT,SDMODE,SDC,VALMY,SDI,SDAT
 Q:IOST'["C-"                                                ;quit if printer is device
 Q:EVENT'=4                                                  ;not checkin
 Q:$$GET1^DIQ(9009020.2,$$DIV^BSDU,.22)'="YES"               ;parameter not turned on
 Q:$P($G(^DPT(DFN,"S",DATE,0)),U,7)'=3                       ;not sched appt
 Q:'$$CI^BSDU2(DFN,SDCL,DATE,$$SCIEN^BSDU2(DFN,SDCL,DATE))   ;quit if check in deleted
 ;
 ;Q:$$READ^BDGF("Y","Want Chart Requested","YES","^D HELPA^BSDROUT")'=1  ;cmi/maw 04/07/2008 orig line
 ;cmi/maw 7/17/2008 PATCH 1009 the following 2 lines are now part of patch 1009 due to DIV being undefined as various times 
 S DIV=$$DIV^BSDU
 N BSDPAR  ;cmi/maw 5/2/2009 patch 1010
 S BSDPAR=$O(^BSDPAR("B",0))  ;cmi/maw 5/2/2009 patch 1010
 I $G(DIV) Q:$$READ^BDGF("Y","Want Chart Requested",$S($P($G(^BSDPAR(DIV,0)),U,25):"YES",1:"YES"),"^D HELPA^BSDROUT")'=1  ;cmi/maw 04/07/2008 PATCH 1009 mod line for default
 I '$G(DIV) Q:$$READ^BDGF("Y","Want Chart Requested",$S($P($G(^BSDPAR(BSDPAR,0)),U,25):"YES",1:"YES"),"^D HELPA^BSDROUT")'=1
 ;cmi/maw 7/17/2008 PATCH 1009 end of mods
 D WISD(DFN,DATE,"RS",$$GET1^DIQ(9009020.2,$$DIV^BSDU,.05))
 Q
 ;
TERM(PAT) ; returns chart # in terminal digit format
 NEW N,T
 S N=$$HRCN^BDGF2(PAT,$G(DUZ(2)))         ;chart #
 S T=$$HRCNT^BDGF2(N)                     ;terminal digit format
 I $$GET1^DIQ(9009020.2,+$$DIV^BSDU,.18)="NO" D
 . S T=$$HRCND^BDGF2(N)                   ;use chart # per site param
 Q T
 ;
HELPA ;EP; called as help for "Want Chart Requested?" question
 W !,"Since this is a same day appointment, do you need the paper"
 W !,"chart pulled?  Answer YES to have the routing slip print in"
 W !,"medical records."
 Q
 ;
HELPB ;EP; called as help for "Print Appt Letter?" question
 W !,"Answer YES to print a reminder letter for this appointment." Q
