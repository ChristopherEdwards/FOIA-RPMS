BSDWLV ; IHS/ITSC/LJF, WAR - VIEW WAITING LIST ENTRY ; [ 01/09/2003  1:44 PM ]
 ;;5.3;PIMS;**1004,1007,1012**;MAY 28, 2004
 ;IHS/OIT/LJF 07/20/2005 PATCH 1004 added subroutine to return 1 if patient active on a wait list
 ;                                  added subroutine to return array of active waiting list entries for patient
 ;                                  added display of user who added patient & user who removed patient
 ;
EN ;EP; -- main entry point for BSDRM WAIT LIST VIEW
 ; variables already set coming into this routine:
 ;   BSDN   = ien of patient multiple in Waiting List File
 ;   BSDWLN = clinic ien in file
 ;
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM WAIT LIST VIEW")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 ;
 S X=$G(IORVON)_$$GET1^DIQ(2,DFN,.01)_$G(IORVOFF)
 S X=$$PAD(X,32)_"#"_$$HRCN^BDGF2(DFN,+$G(DUZ(2)))
 S X=$$PAD(X,48)_"DOB: "_$$GET1^DIQ(2,DFN,.03)
 S VALMHDR(2)=$$PAD(X,68)_"Sex: "_$$GET1^DIQ(2,DFN,.02)
 ;
 I $$DEAD^BDGF2(DFN) S VALMHDR(3)=$$SP(25)_$G(IORVON)_"** Patient Died on "_$$DOD^BDGF2(DFN)_" **"_$G(IORVOFF)
 E  S VALMHDR(3)=$$PCLINE^SDPPTEM(DFN,DT)
 Q
 ;
INIT ; -- init variables and list array
 NEW LINE,BSDI,X
 S VALMCNT=0 K ^TMP("BSDWLV",$J)
 ;
 S X=$$GET1^DIQ(9009017.1,BSDWLN,.01) D SET($$SP(23)_"CLINIC:"_$$SP(5)_X,.VALMCNT)    ;clinic name
 ;
 ; first section (date added, reason, recall date, provider, etc.)
 F BSDI=.03,.09,.02,.06,.05 D
 . S LINE=$J($P($G(^DD(9009017.11,BSDI,0)),U)_":",30)
 . S LINE=$$PAD(LINE,35)_$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,BSDI)
 . I BSDI=".03" S LINE=LINE_" by "_$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.04)   ;IHS/OIT/LJF 7/22/2005 PATCH 1004
 . D SET(LINE,.VALMCNT)
 ;
 ; patient's home and office phones for recall
 F BSDI=.131,.132 D
 . S LINE=$J($P($G(^DD(2,BSDI,0)),U)_":",30)
 . ;
 . ;IHS/OIT/LJF 01/25/2007 PATCH 1007 fix code so phone #s print
 . ;S LINE=$$PAD(LINE,35)_$$GET1^DIQ(2,BSDN_","_BSDWLN,BSDI)
 . ;S LINE=$$PAD(LINE,35)_$$GET1^DIQ(2,BSDWLN_","_BSDN,BSDI)
 . NEW DFN S DFN=$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.01,"I")
 . S LINE=$$PAD(LINE,35)_$$GET1^DIQ(2,+DFN,BSDI)
 . S LINE=$$PAD(LINE,35)_$$GET1^DIQ(2,+DFN,BSDI)
 . ;
 . D SET(LINE,.VALMCNT)
 ;
 ; comments word-processing field
 D SET("",.VALMCNT),SET("Comments:",.VALMCNT)
 S BSDI=0 F  S BSDI=$O(^BSDWL(BSDWLN,1,BSDN,1,BSDI)) Q:'BSDI  D
 . D SET($G(^BSDWL(BSDWLN,1,BSDN,1,BSDI,0)),.VALMCNT)
 ;
 ; last section (date removed and resolution)
 D SET("",.VALMCNT)
 F BSDI=.07,.08 D
 . S LINE=$J($P($G(^DD(9009017.11,BSDI,0)),U)_":",30)
 . S LINE=$$PAD(LINE,35)_$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,BSDI)
 . I BSDI=".07" S LINE=LINE_" by "_$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.11)   ;IHS/OIT/LJF 7/22/2005 PATCH 1004
 . D SET(LINE,.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; put data line into display array
 S NUM=NUM+1
 S ^TMP("BSDWLV",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWLV",$J) D KILL^AUPNPAT K BSDN
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;
ONWL(PAT,TYPE) ; EP - returns 1 if patient active on at least one waiting list
 ;IHS/OIT/LJF 7/20/2005 PATCH 1004 subroutine added
 ;TYPE (optional) can be set to C for clinics only or W for wards only
 I '$D(^BSDWL("AB",PAT)) Q 0
 NEW WL,IEN,FOUND
 S (WL,FOUND)=0 F  S WL=$O(^BSDWL("AB",PAT,WL)) Q:'WL  Q:FOUND  D
 . I $G(TYPE)]"",$P($G(^SC(+^BSDWL(WL,0),0)),U,3)'=TYPE Q   ;skip if not correct type
 . ;
 . S IEN=0 F  S IEN=$O(^BSDWL("AB",PAT,WL,IEN)) Q:'IEN  Q:FOUND  D
 . . I $P(^BSDWL(WL,1,IEN,0),U,7)]"" Q                        ;skip if already removed as active
 . . S FOUND=1
 Q FOUND
 ;
WLDATA(PAT,TYPE,BSDOUT) ; EP - return wait list info in BSDOUT array
 ;IHS/OIT/LJF 7/20/2005 PATCH 1004 subroutine added
 ; BSDOUT array is sorted by date added to the list
 I '$O(^BSDWL(0)) S BSDOUT(0)="" Q
 I '$$ONWL(PAT,$G(TYPE)) S BSDOUT(0)="Not currently on a Waiting List." Q
 ;
 NEW WL,IEN,FOUND,LINE,BSDATA,IENS,FILE,CNTA  ;cmi/maw 6/1/2010 PATCH 1012 adding counter for multiple wait list items
 S CNTA=0  ;cmi/maw 6/1/2010 PATCH 1012 adding counter
 ;
 S (WL,FOUND)=0 F  S WL=$O(^BSDWL("AB",PAT,WL)) Q:'WL  D
 . S IEN=0 F  S IEN=$O(^BSDWL("AB",PAT,WL,IEN)) Q:'IEN  D
 . . I $P(^BSDWL(WL,1,IEN,0),U,7)]"" Q    ;skip if closed out
 . . ;
 . . S CNTA=CNTA+1  ;PATCH 1012
 . . ; build display line
 . . K BSDATA S IENS=IEN_","_WL_",",FILE=9009017.11
 . . S ADDDT=$$GET1^DIQ(FILE,IENS,.03,"I")    ;date added for sorting
 . . I ADDDT="" S BSDOUT(0)="Patient on Waiting List but critical data missing!" Q
 . . D GETS^DIQ(FILE,IENS,".02;.03;.05;.06;1","R","BSDATA")
 . . S LINE=BSDATA(FILE,IENS,"DATE ADDED TO LIST")_"/"
 . . S LINE=$$PAD(LINE_BSDATA(FILE,IENS,"RECALL DATE"),27)
 . . S LINE=$$PAD(LINE_$$GET1^DIQ(9009017.1,WL,.01),47)      ;clinic name
 . . S LINE=$$PAD(LINE_$$SP(2)_BSDATA(FILE,IENS,"PROVIDER"),67)
 . . S LINE=LINE_$$SP(3)_BSDATA(FILE,IENS,"PRIORITY")
 . . ;S BSDOUT(ADDDT,1)=IENS_U_LINE  ;cmi/maw 6/1/2010 orig line
 . . S BSDOUT(ADDDT,CNTA)=IENS_U_LINE  ;cmi/maw6/1/2010 PATCH 1012 RQMT149
 . . ;
 . . ; build comments array
 . . S CNT=0 F  S CNT=$O(BSDATA(FILE,IENS,"COMMENTS",CNT)) Q:'CNT  D
 . . . S BSDOUT(ADDDT,CNTA,CNT+1)=IENS_U_BSDATA(FILE,IENS,"COMMENTS",CNT)  ;cmi/maw 6/1/2010 PATCH 1012 RQMT149
 ;
 I $G(BSDOUT(0))]"" Q
 ; if data found, add caption node in array
 S BSDOUT(0)="  Date Added/Recall Date   Wait List Name        Provider            Priority"
 Q
