BSDPRV ; IHS/ANMC/LJF - 1ST AVAIL APPT BY PROVIDER/TEAM ;  [ 04/01/2004  4:29 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
ASK ; -- ask provider/PCP/PCT
 ; BSDPRV set here or under PCP or PCT
 ; BSDCL array of clinics used by GATHER subroutine
 ; BSDQUIT used by calling routine to exit
 ;NEW Y,BSDPRV,BSDCL,X K BSDQUIT
 NEW Y,BSDPRV,BSDCL,X,BSDPCP K BSDQUIT  ;IHS/ITSC/LJF 3/31/2004 added kill of BSDPCP
 S Y=$$READ^BDGF("FO^3:30","Select Provider/PCPR/PCTM","","^D HELP1^BSDPRV")
 I (Y="")!(Y=U) S BSDQUIT=1 Q
 S Y=$$UP^XLFSTR(Y)    ;convert to uppercase
 I (Y="PCPR")!(Y="PCTM")!(Y="WHPR")!(Y="WHTM") D GETALL(Y) D EN Q
 S X=Y,DIC=200,DIC(0)="EMQZ" D ^DIC I Y<1 D ASK Q
 S BSDPRV=$P(Y,U,2),BSDPCP(+Y)="" D FINDCL(.BSDPCP) D EN Q    ;provider ien
 ;
 ;
EN ;EP; called by SDM with SDPC set
 NEW BSDAY,BSDEND
 S BSDAY=$$READ^BDGF("DO^::E","Enter EARLIEST POSSIBLE APPT DATE","TODAY")
 Q:BSDAY<1
 ;
 S BSDEND=$$READ^BDGF("DO^::E","Enter LATEST POSSIBLE APPT DATE","T+15")
 Q:BSDEND<1  S BSDEND=BSDEND_".2400"
 ;
 NEW VALMCNT
 S VALMCC=1 ;1=screen mode, 0=scrolling mode
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM PROVIDER AVAIL")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 NEW X,Y
 S VALMHDR(1)=$$SP(20)_"First 3 days with Appointments"
 S VALMHDR(2)=$$SP(15)_BSDPRV  ;provider or team name
 S X=$$FMTE^XLFDT(BSDAY),Y=$$FMTE^XLFDT(BSDEND,"D")
 S VALMHDR(2)=VALMHDR(2)_" from "_X_" to "_Y
 Q
 ;
INIT ;EP; -- init variables and list array
 K ^TMP("BSDPRV",$J),^TMP("BSDPRV1",$J)
 D GUIR^XBLM("GATHER^BSDPRV","^TMP(""BSDPRV1"",$J,")
 S X=$O(^TMP("BSDPRV1",$J,999999),-1) I X,^TMP("BSDPRV1",$J,X)="" K ^TMP("BSDPRV1",$J,X)
 S X=0 F  S X=$O(^TMP("BSDPRV1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDPRV",$J,X,0)=^TMP("BSDPRV1",$J,X)
 ;
 I '$D(^TMP("BSDPRV",$J)) S VALMCNT=1,^TMP("BSDPRV",$J,1,0)="NO APPOINTMENTS FOUND FOR DATE RANGE"
 K ^TMP("BSDPRV1",$J)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
HELP1 ;EP; -- help called by DIR call for Provider/PCPR/PCTM
 D MSG^BDGF("Enter a provider's name",2,0)
 D MSG^BDGF("  or PCPR for patient's primary care provider",1,0)
 D MSG^BDGF("  or PCTM for patient's primary care team.",1,0)
 D MSG^BDGF("  or WHPR for patient's women's health provider",1,0)
 D MSG^BDGF("  or WHTM for women's health provider team.",1,1)
 D MSG^BDGF("Display will be similar to that for principal clinic in",1,0)
 D MSG^BDGF("that the first 3 days with appointments will display.",1,0)
 D MSG^BDGF("Once a clinic has been found, exit the display and enter",1,0)
 D MSG^BDGF("that clinic name at the ""Select CLINIC"" prompt.",1,1)
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BSDPRV",$J) D CLEAN^VALM10
 S VALMNOFF=1  ;suppress form feed 
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
 ;
GATHER ;EP; loop thru clinics selected
 ; assumes BSDCL array of clinics and BSDAY, BSDEND are set
 NEW BSDNM,BSDN
 I '$D(BSDCL) W !!?20,"NO PROVIDER/TEAM FOUND" Q
 S BSDNM=0 F  S BSDNM=$O(BSDCL(BSDNM)) Q:BSDNM=""  D
 . S BSDN=BSDCL(BSDNM) D DAY
 Q
 ;
HD ;Write month heading lines  ;IHS/ITSC/LJF 4/1/2004 added subroutine
 I $G(SI)="" D
 .S SI=$P($G(^SC(BSDN,"SL")),U,6),SI=$S(SI<3:4,1:SI)
 I $G(STARTDAY)="" D
 .S SL=$G(^SC(+Y,"SL")),X=$P(SL,U,3),STARTDAY=$S(X:X,1:8),SC=+Y
 W !!,?18,"TIME",?SI+SI-1 F Y=STARTDAY:1:65\(SI+SI)+STARTDAY W $E("|"_$S('Y:0,1:(Y-1#12+1))_"                 ",1,SI+SI)
 W !,?18,"DATE",?SI+SI-1,"|" K J F Y=0:1:6 I $D(^SC(+BSDN,"T"_Y)) S J(Y)=""
 F Y=1:1:65\(SI+SI) W $J("|",SI+SI)
 Q
 ;
DAY ; for clinic & date range, find first 3 days with appts
 NEW DATE,DAYCNT,IEN,Z,I,SLOT
 S DATE=BSDAY-.001,Z="",SLOT=0,DAYCNT=0
 F  S DATE=$O(^SC(BSDN,"ST",DATE)) Q:'DATE  Q:DATE>BSDEND  Q:DAYCNT=3  D
 . S IEN=0
 . F  S IEN=$O(^SC(BSDN,"ST",DATE,IEN)) Q:'IEN  Q:DAYCNT=3  D
 .. S Z=$E(^SC(BSDN,"ST",DATE,IEN),6,$L(^SC(BSDN,"ST",DATE,IEN)))
 .. Q:Z["CANCELLED"
 .. I (Z'["|"),(Z'["[") Q
 .. I Z["|" S SLOT=$P(Z,"|",2,999)
 .. I Z'["|" S SLOT=$E(Z,6,999)
 .. F I="|","[","]","*"," ","0" S SLOT=$$STRIP^XLFSTR(SLOT,I)
 .. F I="A","B","C","D","E","F" S SLOT=$$STRIP^XLFSTR(SLOT,I)
 .. F I="j","k","l","m","n","o" S SLOT=$$STRIP^XLFSTR(SLOT,I)
 .. S SLOT=$TR(Z,"|[@#]!$* ABCDEFXjklmno",0)   ;IHS/ITSC/LJF 4/1/2004
 .. Q:+SLOT<1                            ;no appt slots found
 .. ;I DAYCNT=0 W !!,$P(^SC(BSDN,0),U,1)  ;display clinic name
 .. I DAYCNT=0 D HD W !,$P(^SC(BSDN,0),U,1)  ;display times & clinic name  ;IHS/ITSC/LJF 4/1/2004
 .. S Y=$$FMTE^XLFDT(DATE)               ;printable date
 .. W !,Y,?15,^SC(BSDN,"ST",DATE,IEN)    ;display day's appts
 .. S DAYCNT=DAYCNT+1                  ;display up to 3 days per clinic
 Q
 ;
GETALL(BSDP) ; -- get primary care provider or team
 ; BSDP="PCPR for primary care provider or "PCTM" for primary care team
 ; BSDP="WHPR" for women's health provider or "WHTM" for wh team
 ; returns BSDPCP array of all providers selected
 ; returns BSDPRV=pcp provider or team name
 ;
 NEW X,I,TEAM
 ; find patient's PCP or WH PCP
 S BSDPRV=$S(BSDP["PC":"Primary Care ",1:"Women's Health ")_$S(BSDP["PR":"Provider",1:"Team")
 ;IHS/ITSC/WAR 1/5/04 mods per Linda.
 ;I BSDP["PC" S X=$$GET1^DIQ(9000001,DFN,.14,"I") I 'X S BSDQUIT=1 Q
 ;I BSDP["WH" S X=$$GET1^DIQ(9002086,DFN,.25,"I") I 'X S BSDQUIT=1 Q
 I BSDP["PC" S X=$$GET1^DIQ(9000001,DFN,.14,"I") I 'X Q
 I BSDP["WH" S X=$$GET1^DIQ(9002086,DFN,.25,"I") I 'X Q
 S BSDPCP(X)=""
 I BSDP["PR" D FINDCL(.BSDPCP) Q
 ;END OF 12/31/03 Changes (now removed) & 1/5/04 changes
 ;
 ; if using team, find all teams to which this PCP belongs
 S X=0 F  S X=$O(^BSDPCT("AB",+$O(BSDPCP(X)),X)) Q:'X  S TEAM(X)=""
 I '$D(TEAM) S BSDQUIT=1 Q
 ;
 ; now find all providers on those teams
 S X=0 F  S X=$O(TEAM(X)) Q:'X  D
 . S Y=0 F  S Y=$O(^BSDPCT(X,1,Y)) Q:'Y  D
 .. S BSDPCP(+$G(^BSDPCT(X,1,Y,0)))=""     ;add providers from team
 ;
 ; then find all clinics linked to those providers
 D FINDCL(.BSDPCP)
 Q
 ;
 ;
FINDCL(BSDX) ;EP; -- sets array of clinics for provider or team
 ; returns BSDCL array with clinic name and then ien
 ; BSDX=array of providers
 K BSDCL NEW PRV,X
 S PRV=0 F  S PRV=$O(BSDX(PRV)) Q:'PRV  D
 . S X=0 F  S X=$O(^SC("AIHSDPR",PRV,X)) Q:'X  D
 .. S BSDCL($$GET1^DIQ(44,X,.01))=X
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
