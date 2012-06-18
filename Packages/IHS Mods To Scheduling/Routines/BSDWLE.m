BSDWLE ; IHS/OIT/LJF - WAITING LIST DATA ENTRY
 ;;5.3;PIMS;**1004,1007,1010,1013**;MAY 28, 2004
 ;IHS/OIT/LJF 07/21/2005 PATCH 1004 routine added
 ;
 ;cmi/anch/maw 2/21/2007 added ability to sort report in SRT, INIT PATCH 1007 item 1007.33
 ;cmi/anch/maw 10/20/2008 PATCH 1010 RQMT91 added INACT to inactivate a wait list
 ;cmi/anch/maw 10/20/2008 PATCH 1010 RQMT91 added a check to see if wait list is inactive
 ;
ASK ; ask user questions
 NEW DIC,DLAYGO,Y,BSDWLN,X,BSDSRT
 S DIC=9009017.1,DIC(0)="AEMQZ"
 I $D(^XUSEC("SDZAC",DUZ)) S DLAYGO=9009017.1,DIC(0)=DIC(0)_"L"
 D ^DIC Q:Y<1  S BSDWLN=+Y K DLAYGO,DIC
 ;cmi/maw 10/20/2008 PATCH 1010 RQMT91 added a check to see if wait list is inactive
 I $P($G(^BSDWL(BSDWLN,0)),U,2) D  Q
 . W !,"Wait List is Inactive"
 . H 2
 ;cmi/maw 10/20/2008 end of mods
 D SRT  ;cmi/anch/maw 2/21/2007 ask to sort by
 ;
EN ; -- main entry point for BSDRM WAITING LIST
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM WAITING LIST")
 D CLEAR^VALM1
 Q
 ;
SRT ;-- how do they want to sort
 S BSDSRT=$$READ^BDGF("S^P:Patient Name;D:Date Added to List;O:Priority;R:Recall Date","Sort By","Patient Name")
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$$GET1^DIQ(9009017.1,BSDWLN,.01)
 S VALMHDR(2)=$$SP(80-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW FILE,IEN,IENS,BSDATA,NAME,BSDCNT,LINE,DFN
 S VALMCNT=0 K ^TMP("BSDWLE",$J),^TMP("BSDWLE1",$J)
 ;
 S FILE=9009017.11
 S IEN=0 F  S IEN=$O(^BSDWL(BSDWLN,1,IEN)) Q:'IEN  D
 . S IENS=IEN_","_BSDWLN_","
 . ;K BSDATA D GETS^DIQ(FILE,IENS,".01;.07","R","BSDATA")  ;cmi/anch/maw 2/21/2007 orig line
 . K BSDATA D GETS^DIQ(FILE,IENS,".01:.07","R","BSDATA")  ;cmi/anch/maw 2/21/2007 mod line PATCH 1007 item 1007.33
 . K BSDATAI D GETS^DIQ(FILE,IENS,".01:.07","RI","BSDATAI")  ;ihs/cmi/maw 04/15/2011 PATCH 1013
 . I BSDATA(FILE,IENS,"DATE REMOVED FROM LIST")]"" Q        ;skip if already closed out
 . ;cmi/anch/maw 2/21/2007 maw mod/added following 5 lines PATCH 1007 item 1007.33
 . ;S ^TMP("BSDWLE1",$J,BSDATA(FILE,IENS,"PATIENT"),IEN)=""  ;sort by patient name cmi/anch/maw 2/21/2007 maw orig line PATCH 1007 item 1007.33
 . I BSDSRT="P" S ^TMP("BSDWLE1",$J,BSDATA(FILE,IENS,"PATIENT"),IEN)=""  ;sort by patient name
 . I BSDSRT="D" S ^TMP("BSDWLE1",$J,BSDATA(FILE,IENS,"DATE ADDED TO LIST"),IEN)=""  ;sort by date added to list
 . I BSDSRT="O" S ^TMP("BSDWLE1",$J,$S(BSDATA(FILE,IENS,"PRIORITY")]"":BSDATA(FILE,IENS,"PRIORITY"),1:"MIDDLE"),IEN)=""  ;sort by priority
 . I BSDSRT="R" S ^TMP("BSDWLE1",$J,$S(BSDATAI(FILE,IENS,"RECALL DATE","I")]"":BSDATAI(FILE,IENS,"RECALL DATE","I"),1:"0000000"),IEN)=""  ;sort by recall date
 ;
 ; now take sorted list and build display array
 S NAME=0 F  S NAME=$O(^TMP("BSDWLE1",$J,NAME)) Q:NAME=""  D
 . S IEN=0 F  S IEN=$O(^TMP("BSDWLE1",$J,NAME,IEN)) Q:'IEN  D
 . . S IENS=IEN_","_BSDWLN_"," K BSDATA
 . . ;D GETS^DIQ(FILE,IENS,".013;.02:.05;.06;1","R","BSDATA")  ;cmi/anch/maw 2/21/2007 orig line PATCH 1007 item 1007.33
 . . D GETS^DIQ(FILE,IENS,".01;.013;.02:.05;.06;1","R","BSDATA")  ;cmi/anch/maw 2/21/2007 added .01 PATCH 1007 item 1007.33
 . . S BSDCNT=$G(BSDCNT)+1 S LINE=$J(BSDCNT,3)_". "
 . . ;S LINE=LINE_$$PAD($E(NAME,1,25),28)_BSDATA(FILE,IENS,"HRCN")  ;cmi/anch/maw 2/21/2007 orig line PATCH 1007 item 1007.33
 . . S LINE=LINE_$$PAD($E(BSDATA(FILE,IENS,"PATIENT"),1,25),28)_BSDATA(FILE,IENS,"HRCN")  ;cmi/anch/maw 2/21/2007 changed patient variable PATCH 1007 item 1007.33
 . . S LINE=$$PAD(LINE,41)_BSDATA(FILE,IENS,"DATE ADDED TO LIST")
 . . S LINE=$$PAD(LINE,56)_BSDATA(FILE,IENS,"RECALL DATE")
 . . S LINE=$$PAD(LINE,71)_BSDATA(FILE,IENS,"PRIORITY")
 . . S LINE=$$PAD(LINE,81)_$E(BSDATA(FILE,IENS,"PROVIDER"),1,12)
 . . S LINE=$$PAD(LINE,96)_$G(BSDATA(FILE,IENS,"COMMENTS",1))
 . . S DFN=$$GET1^DIQ(FILE,IENS,".01","I")
 . . D SET(LINE,IEN_U_DFN,BSDCNT,.VALMCNT)
 ;
 I VALMCNT=0 S ^TMP("BSDWLE",$J,1,0)="No Active Patients on this Waiting List",VALMCNT=1
 K ^TMP("BSDWLE1",$J)
 Q
 ;
SET(DATA,SAVE,COUNT,LINENUM) ; puts data line into display array
 S LINENUM=LINENUM+1 S:COUNT=0 COUNT=1
 S ^TMP("BSDWLE",$J,LINENUM,0)=DATA
 S ^TMP("BSDWLE",$J,"IDX",LINENUM,COUNT)=SAVE   ;=IEN^DFN
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWLE",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ;-- print wait list letters
 K ^UTILITY($J,"BSDLET")
 D MAIN^BSDLTP("W")
 Q:'$G(SDLET)
 D GETSOME(SDLET)
 Q:'$D(^UTILITY($J,"BSDLET",SDLET))
 D ZIS^DGUTQ Q:POP
 N CNT,REC
 S CNT=0
 S A=0 F  S A=$O(^UTILITY($J,"BSDLET",SDLET,A)) Q:'A  D
 . U IO
 . I CNT>0 W @IOF
 . D ^BSDLT
 . D RECALL^BSDLT(BSDWLN,A)
 . D REST^BSDLT
 . S CNT=CNT+1
 D ^%ZISC
 D RETURN(1)
 K ^UTILITY($J,"BSDLET")
 Q
 ;
GETONE ; -- select entry from listing
 NEW X,Y,Z
 D FULL^VALM1
 S BSDN=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("BSDWLE",$J,"IDX",Y)) Q:Y=""  Q:BSDN]""  D
 . S Z=$O(^TMP("BSDWLE",$J,"IDX",Y,0))
 . Q:^TMP("BSDWLE",$J,"IDX",Y,Z)=""
 . I Z=X S BSDN=+^TMP("BSDWLE",$J,"IDX",Y,Z)
 Q
 ;
GETSOME(LET) ;-- select multiple entries from the list
 NEW X,Y,Z,BSDP,BSDX
 D FULL^VALM1
 S BSDN=""
 D EN^VALM2(XQORNOD(0),"")
 I '$D(VALMY) Q
 S BSDX=0 F  S BSDX=$O(VALMY(BSDX)) Q:'BSDX  D
 . S Y=0 F  S Y=$O(^TMP("BSDWLE",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BSDWLE",$J,"IDX",Y,0))
 .. Q:^TMP("BSDWLE",$J,"IDX",Y,Z)=""
 .. I Z=BSDX D
 ... S BSDN=+^TMP("BSDWLE",$J,"IDX",Y,Z)
 ... S BSDP=$P(^TMP("BSDWLE",$J,"IDX",Y,Z),U,2)
 ... S ^UTILITY($J,"BSDLET",LET,BSDP,DT)=""
 Q
 ;
VIEW ;EP; called by BSDWL VIEW protocol
 NEW BSDN,DFN
 D GETONE I BSDN="" D RETURN(0) Q
 S DFN=+$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.01,"I")  ;line added
 D EN^BSDWLV,RETURN(0)
 Q
 ;
RETURN(MODE) ; -- reset variables for return to lt
 ; MODE=1 to rebuild list
 D TERM^VALM0 S VALMBCK="R"
 I MODE=1,$G(BSDCLOSE) D HDR^BSDWLE1,INIT^BSDWLE1 Q
 I MODE=1 D HDR,INIT
 Q
 ;
ADD ;EP - called by BSDWL ADD protocol
 NEW DIC,DD,DO,DA,X,DINUM,Y,DIE,DR,DFN
 K DD,DO  ;cmi/maw 6/13/2007
 D FULL^VALM1
 S DFN=+$$READ^BDGF("PO^2:EMQZ","Select Patient") I DFN<1 D RETURN(0) Q
 I $$ONNOW(DFN) I '$$READ^BDGF("Y","Patient already on list; Want to add again","NO") D RETURN(0) Q
 S DIC="^BSDWL("_BSDWLN_",1,",DIC(0)="AEMQZL"
 S DIC("P")=$P(^DD(9009017.1,1,0),U,2)
 S DIC("DR")=".03//TODAY;.09;.04///`"_DUZ
 S DA(1)=BSDWLN
 S X=DFN
 D FILE^DICN I Y<1 D PAUSE^BDGF,RETURN(0) Q
 S DA=+Y
 ;
 S DIE="^BSDWL("_BSDWLN_",1,",DA(1)=BSDWLN
 S DR=".02;.06;.05;1"
 D ^DIE,ADDRESS,RETURN(1)
 Q
 ;
EDIT ;EP - called by BSDWL EDIT protocol
 NEW BSDN,DIE,DA,DR,Y
 D GETONE I BSDN="" D RETURN(0) Q
 W !!,$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.01)   ;display patient name
 S DIE="^BSDWL("_BSDWLN_",1,",DA(1)=BSDWLN,DA=BSDN
 S DR=".03;.09;.02;.06;.05;1"
 D ^DIE,ADDRESS
 D RETURN(1)
 Q
 ;
EDITALL ;EP - called by BSDWL EDIT ALL protocol (for closed cases)
 NEW BSDN,DIE,DA,DR,Y
 D GETONE I BSDN="" D RETURN(0) Q
 W !!,$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.01)   ;display patient name
 S DIE="^BSDWL("_BSDWLN_",1,",DA(1)=BSDWLN,DA=BSDN
 S DR=".03;.09;.02;.06;.05;1;.07;.08"
 D ^DIE
 D RETURN(1)
 Q
 ;
REMOVE ;EP - called by BSDWL REMOVE protocol
 NEW BSDN,DIE,DA,DR,Y
 D GETONE I BSDN="" D RETURN(0) Q
 W !!,$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.01)   ;display patient name
 S DIE="^BSDWL("_BSDWLN_",1,",DA(1)=BSDWLN,DA=BSDN
 S DR=".07;.08;I $P(^(0),U,11)]"""" S Y=""@1"";.11///`"_DUZ_";@1;1"
 D ^DIE,RETURN(1)
 Q
 ;
ADDRESS ; ask to update address & phone number
 NEW BSDREG,DFN
 S DFN=$$GET1^DIQ(9009017.11,DA_","_DA(1),.01,"I")  ;patient IEN
 S BSDREG=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.19,"I")  ;registration access level
 I (BSDREG=1)!(BSDREG=2)!(BSDREG=3&$D(^XUSEC("SDZREGEDIT",DUZ))) D ADDRESS^BSDREG
 Q
 ;
ONNOW(PAT) ; return 1 if patient currently active on list
 NEW Y,X,FOUND
 S FOUND=0
 S Y=0 F  S Y=$O(^TMP("BSDWLE",$J,"IDX",Y)) Q:'Y  Q:FOUND  D
 . S Z=0 F  S Z=$O(^TMP("BSDWLE",$J,"IDX",Y,Z)) Q:'Z  Q:FOUND  D
 . . I $P(^TMP("BSDWLE",$J,"IDX",Y,Z),U,2)=PAT S FOUND=1
 Q FOUND
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
INACT ;-- PATCH 1010 RQMT91 set the wait list to inactive
 NEW DIC,DLAYGO,Y,BSDWLN,X,BSDSRT
 S DIC=9009017.1,DIC(0)="AEMQZ"
 D ^DIC Q:Y<1  S BSDWLN=+Y
 S DIE=DIC,DR=.02,DA=BSDWLN
 D ^DIE
 K DLAYGO,DIC,DA,DR
 Q
 ;
