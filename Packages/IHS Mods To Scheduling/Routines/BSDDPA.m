BSDDPA ; IHS/ITSC/LJF, WAR - DISPLAY PAT APPTS ;  [ 04/16/2004  4:40 PM ]
 ;;5.3;PIMS;**1003,1004**;MAY 28, 2004
 ;IHS/ITSC/LJF 05/13/2005 PATCH 1003 added EP; to EN subroutine
 ;IHS/OIT/LJF 07/20/2005 PATCH 1004 check if patient active on a wait list
 ;                                  expanded default end date to 6 months from today
 ;
PAT ; -- ask user for patient
 NEW DFN,BSDBD,BSDED
 D KILL^AUPNPAT
 S DFN=+$$READ^BDGF("PO^9000001:EQM","Select Patient") Q:DFN<1
 ;
 S BSDBD=$$READ^BDGF("D^::EX","Select Beginning Date","TODAY") Q:'BSDBD
 ;
 ;;IHS/OIT/LJF 7/20/2005 PATCH 1004
 ;I '$O(^DPT(DFN,"S",BSDBD)) D  Q
 ;. W !!,"NO APPOINTMENTS FOUND!",!
 I '$O(^DPT(DFN,"S",BSDBD)),'$$ONWL^BSDWLV(DFN,"C") D  D PAT Q
 . W !!,"NO APPOINTMENTS OR WAITING LIST ENTRIES FOUND!",!
 ;end of PATCH 1004 changes
 ;
 ;S BSDED=$$READ^BDGF("D^::EX","Select Ending Date","T+90") Q:'BSDED
 S BSDED=$$READ^BDGF("D^::EX","Select Ending Date","T+180") Q:'BSDED  ;IHS/OIT/LJF 7/20/2005 PATCH 1004
 ;
 D EN,PAT Q
 ;
EN ;EP; -- main entry point for SD IHS APPT MADE BY;IHS/ITSC/LJF PATCH 1003
 NEW VALMCNT
 S VALMCC=1 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM DISPLAY APPTS")
 D CLEAR^VALM1,EXIT
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$G(IORVON)_$$GET1^DIQ(2,DFN,.01)_$G(IORVOFF)
 S X=$$PAD(X,40)_"#"_$$HRCN^BDGF2(DFN,+$G(DUZ(2)))
 S X=$$PAD(X,52)_"DOB: "_$$GET1^DIQ(2,DFN,.03)
 S VALMHDR(2)=$$PAD(X,69)_"Sex: "_$E($$GET1^DIQ(2,DFN,.02),1)
 I $$DEAD^BDGF2(DFN) S VALMHDR(3)=$$SP(25)_$G(IORVON)_"** Patient Died on "_$$DOD^BDGF2(DFN)_" **"_$G(IORVOFF)
 E  S VALMHDR(3)=$$PCLINE^SDPPTEM(DFN,DT)
 Q
 ;
INIT ; -- init variables and list array
 ; variables set are DFN, BSDBD, BSDED
 ; BSDLN keeps track of line #s to update VALMCNT which is returned
 ; BSDNUM used to link display line with entry
 NEW APDT,NODE,LINE,END,BSDNUM,BSDLN,X,BSDM,BSDU
 K ^TMP("BSDDPA",$J)
 ;
 ; loop thru pat's appts in date range
 S APDT=BSDBD,END=BSDED+.2400
 F  S APDT=$O(^DPT(DFN,"S",APDT)) Q:'APDT!(APDT>END)  D
 . S NODE=^DPT(DFN,"S",APDT,0)
 . S LINE=$$PAD($$FMTE^XLFDT(APDT),20)                   ;appt dt
 . S LINE=LINE_$$PAD($$GET1^DIQ(44,+NODE,.01),24)_" "    ;clinic
 . S LINE=LINE_$$STATUS(DFN,APDT,NODE)                   ;type/status
 . S BSDNUM=$G(BSDNUM)+1,LINE=$J(BSDNUM,2)_". "_LINE     ;add number
 . S X=DFN_U_+NODE_U_APDT D SET(LINE,X,BSDNUM,.BSDLN)    ;set line
 . D SET($$OI(DFN,+NODE,APDT),"",BSDNUM,.BSDLN)          ;other info
 . I $P(NODE,U,2)["C",$G(^DPT(DFN,"S",APDT,"R"))]"" D
 .. D SET($$SP(15)_"Cancel Remark: "_^DPT(DFN,"S",APDT,"R"),"",BSDNUM,.BSDLN)  ;cncl rmark
 . D SET(" ","",BSDNUM,.BSDLN)                           ;blank line
 ;
 ;IHS/OIT/LJF 07/20/2005 PATCH 1004 added display of active waiting list entries for patient
 K BSDWLR D WLDATA^BSDWLV(DFN,"C",.BSDWLR)
 S:'$D(BSDNUM) BSDNUM=0 D SET(" ","",BSDNUM,.BSDLN)
 ;
 I '$O(BSDWLR(0)) D SET($$SP(10)_BSDWLR(0),"",BSDNUM,.BSDLN) I 1
 E  D
 . D SET($$SP(17)_"**** ACTIVE WAIT LIST ENTRIES FOR PATIENT ****","",BSDNUM,.BSDLN)
 . D SET(BSDWLR(0),"",BSDNUM,.BSDLN)                   ;caption line
 . D SET($$REPEAT^XLFSTR("-",77),"",BSDNUM,.BSDLN)     ;dividing line
 . NEW DATE,LINE
 . S DATE=0 F  S DATE=$O(BSDWLR(DATE)) Q:'DATE  D
 . . S LINE=0 F  S LINE=$O(BSDWLR(DATE,LINE)) Q:'LINE  D
 . . . D SET($S(LINE=1:"",1:$$SP(3))_$P(BSDWLR(DATE,LINE),U,2),"",BSDNUM,.BSDLN)
 . D SET(" ","",BSDNUM,.BSDLN)    ;extra line for spacing
 ;end of PATCH 1004 additions
 ;
 S VALMCNT=+$G(BSDLN)
 Q
 ;
SET(LINE,DATA,NUM,BSDLN) ; -- set ^tmp with display line
 S BSDLN=$G(BSDLN)+1
 S ^TMP("BSDDPA",$J,BSDLN,0)=LINE
 S ^TMP("BSDDPA",$J,"IDX",BSDLN,NUM)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K BSDBD,BSDED,BSDLN,BSDNUM
 K SDC,SDIFN,SDP,SDPP,SDS,SDSTAT,VALMY,ORX
 K VALMBCK,VALMCNT,VALMHDR
 D KILL^AUPNPAT
 Q
 ;
 ;
RETURN ; -- reset variables for return to lt
 D TERM^VALM0 S VALMBCK="R" Q
 ;
GETAPPT(BSDSUB) ; -- select appt from listing
 ; BSDSUB=subscript of display global
 NEW X,Y,Z,BSDA
 D FULL^VALM1
 S BSDA=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) S BSDSOME=0 Q
 S BSDSOME=1
 S (SDW,X)=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP(BSDSUB,$J,"IDX",Y)) Q:Y=""  Q:BSDA]""  D
 . S Z=$O(^TMP(BSDSUB,$J,"IDX",Y,0))
 . Q:^TMP(BSDSUB,$J,"IDX",Y,Z)=""
 . I Z=X S BSDA=^TMP(BSDSUB,$J,"IDX",Y,Z)
 Q:BSDA=""
 S DFN=$P(BSDA,U),SDCL=$P(BSDA,U,2),SDT=$P(BSDA,U,3)
 Q
 ;
VA ;EP; called by View Appt action
 NEW DFN,SDCL,SDT,SDW
 NEW BSDSOME
 S SUB=$P(VALMAR,"""",2)
 S (DFN,SDCL,SDT)="" D GETAPPT(SUB)
 I (DFN="")!(SDCL="")!(SDT="") D  D RETURN Q
 . Q:'BSDSOME
 . W !,"Sorry data missing on this appointment!"
 D EN^BSDAMEP
 D RETURN
 Q
 ;
VV ;EP; called by View Visit action
 NEW DFN,SDCL,SDT,SDW
 S SUB=$P(VALMAR,"""",2)
 S (DFN,SDCL,SDT)="" D GETAPPT(SUB)
 ;
 I (DFN="")!(SDCL="")!(SDT="") D  D RETURN Q
 . W !,"Sorry data missing on this appointment!"
 . D PAUSE^BDGF
 ;
 S APCDPAT=DFN,APCDVSIT=$$GETVST(DFN,SDT)
 I $P($G(^AUPNVSIT(+APCDVSIT,0)),U,5)'=DFN D  D RETURN Q
 . W !,"Sorry, this appointment does not have a visit attached yet."
 . D PAUSE^BDGF
 ;
 D ^APCDVD
 K APCDCLN,APCDCAT,APCDDATE,APCDLOC,APCDPAT,APCDVSIT,APCDLOOK,APCDTYPE
 D RETURN
 Q
 ;
FINDUSR(PAT,CLINIC,DATE,BSDU,BSDM) ; -- gets user and date made from file 44
 NEW X,Y
 ; look in patient file first
 S Y=$P(^DPT(PAT,"S",DATE,0),U,18,19)
 I +Y S BSDU=$P(Y,U),BSDM=$P(Y,U,2) D FORMAT Q
 ;
 ; if not there, check file 44
 K Y S X=0 F  S X=$O(^SC(CLINIC,"S",DATE,1,X)) Q:(X="")!($D(Y))  D
 . I +^SC(CLINIC,"S",DATE,1,X,0)'=DFN Q
 . S Y=$P(^SC(CLINIC,"S",DATE,1,X,0),U,6,7)
 S BSDU=$P($G(Y),U)
 S BSDM=$P($G(Y),U,2)
FORMAT ; -- convert data to external format
 S BSDU=$S(BSDU="":"??",1:$$GET1^DIQ(200,BSDU,1))
 I $$RESVIEW,'$D(^XUSEC("SDZSUP",DUZ)) S BSDU=""  ;who made appt rstrctd
 S BSDM=$S(BSDM="":"??",1:$$FMTE^XLFDT(BSDM,"D"))
 Q
 ;
STATUS(PAT,DATE,NODE) ; returns appt status
 NEW TYP
 S TYP=$$APPTYP^BSDU2(PAT,DATE)    ;sched vs. walkin
 I $P(NODE,U,2)["C" Q TYP_" - CANCELLED"
 I $P(NODE,U,2)'="NT",$P(NODE,U,2)["N" Q TYP_" - NO SHOW"
 I $$CO^BSDU2(PAT,+NODE,DATE) Q TYP_" - CHECKED OUT"
 I $$CI^BSDU2(PAT,+NODE,DATE) Q TYP_" - CHECKED IN"
 Q TYP
 ;
OI(PAT,CLINIC,DATE) ; -- returns other info display line
 Q $$SP(15)_$E($$OI^BSDU2(PAT,CLINIC,DATE),1,65)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
RESVIEW() ; -- returns 1 if restrict viewing of who made appt turned on
 Q +$$GET1^DIQ(9009020.2,$$DIV^BSDU,.12,"I")
 ;
GETVST(PAT,DATE) ; returns visit ien for appt date and patient
 NEW X
 I ('PAT)!('DATE) Q 0
 S X=$G(^DPT(PAT,"S",DATE,0)) I 'X Q 0   ;appt node
 S X=$P(X,U,20) I 'X Q 0                 ;outpt encounter ptr
 S X=$G(^SCE(X,0)) I 'X Q 0              ;outpt encounter node
 I $P(X,U,2)'=PAT Q 0                    ;patient ptr
 Q $P(X,U,5)                             ;visit ptr
