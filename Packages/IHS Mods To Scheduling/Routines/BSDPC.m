BSDPC ; IHS/ITSC/LJF,WAR - 1ST AVAIL APPT FOR PRIN CLINIC ; [ 08/20/2004  11:54 AM ]
 ;;5.3;PIMS;**1001,1004,1005,1013**;MAY 28, 2004
 ;IHS/ITSC/WAR 07/30/2004 PATCH 1001 check for undef of VALMCNT
 ;IHS/OIT/LJF  07/15/2005 PATCH 1004 fixed heading & spacing
 ;IHS/OIT/LJF  12/30/2005 PATCH 1005 removed 3 day restriction; fix to heading
 ;ihs/cmi/maw  04/06/2011 PATCH 1013 added code to sort print clinic alphabetically
 ;
EN ;EP; called by SDM with SDPC set
 NEW SDAY,SDX,SDN,SDD,Y,Z,SDSLOT
 S %DT="AE",%DT("A")="Enter EARLIEST POSSIBLE APPT DATE: "
 S %DT("B")="TODAY",X="" D ^%DT Q:Y<1  S SDAY=Y
 ;
 S %DT="AE",%DT("A")="Enter LATEST POSSIBLE APPT DATE: "
 S %DT("B")="T+15",X="" D ^%DT Q:Y<1  S SDEND=Y+.2400 W !!
 ;
 NEW VALMCNT
 S VALMCC=1 ;1=screen mode, 0=scrolling mode
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM PRIN CLN AVAIL")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$GET1^DIQ(44,SDPC,.01)  ;prin cln name
 Q
 ;
INIT ;EP; -- init variables and list array
 K ^TMP("BSDPC",$J),^TMP("BSDPC1",$J)
 D GUIR^XBLM("SC^BSDPC","^TMP(""BSDPC1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDPC1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDPC",$J,X,0)=^TMP("BSDPC1",$J,X)
 ;
 ; add legend to display to explain 1s, 0s, As, Bs, *s, etc.
 ;IHS/ITSC/WAR 7/30/04 PATCH #1001 found/corrected by AEF
 ;S VALMCNT=VALMCNT+1,^TMP("BSDPC",$J,VALMCNT,0)=""  ;extra line
 S VALMCNT=$G(VALMCNT)+1,^TMP("BSDPC",$J,VALMCNT,0)=""  ;extra line
 NEW BSDX D LEGEND^BSDU(.BSDX)
 S X=0 F  S X=$O(BSDX(X)) Q:'X  D
 . ;IHS/ITSC/WAR 7/30/04 PATCH #1001 found/corrected by AEF
 . ;S VALMCNT=VALMCNT+1,^TMP("BSDPC",$J,VALMCNT,0)=BSDX(X)
 . S VALMCNT=$G(VALMCNT)+1,^TMP("BSDPC",$J,VALMCNT,0)=BSDX(X)
 ;
 K ^TMP("BSDPC1",$J)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BSDPC",$J) D CLEAN^VALM10
 S VALMNOFF=1  ;suppress form feed 
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
PAUSE ; -- end of action pause
 D PAUSE^BDGF Q
 ;
RESET ; -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
RESET2 ; -- update partition without recreating display array
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 ;
 ;
SC ;EP; entry point to gather available appts from each clinic
 NEW SDN,SDCNT,SDD,SDSLOT,SDX,Z,NDA
 N CLNORD
 NEW BSDIOM,BSDTOT S BSDIOM=150,BSDTOT=BSDIOM-15  ;used in place of 80 & 65;IHS/OIT/LJF 7/15/2005 PATCH 1004
 ;ihs/cmi/maw 04/06/2011 PATCH 1013 RQMT153 added next 6 lines to sort alpha
 ;S SDN=0 F  S SDN=$O(^SC("AIHSPC",SDPC,SDN)) Q:'SDN  D DAY
 S NDA=0 F  S NDA=$O(^SC("AIHSPC",SDPC,NDA)) Q:'NDA  D
 . S (CLNORD($P(^SC(NDA,0),U),NDA))=""
 N CDA,SDN
 S CDA=0 F  S CDA=$O(CLNORD(CDA)) Q:CDA=""  D
 . S SDN=0 F  S SDN=$O(CLNORD(CDA,SDN)) Q:'SDN  D
 .. D DAY
 ;ihs/cmi/maw 04/06/2011 end of mods
 W ! Q
 ;
HD ;Write month heading lines
 ;IHS/OIT/LJF 7/15/2005 PATCH 1004 rewrote so each clinic has correct heading & spacing
 NEW SI,SL,STARTDAY,SC,Y,J   ;IHS/OIT/LJF 12/30/2005 PATCH 1005 needed one more tweak
 S SI=$P($G(^SC(SDN,"SL")),U,6),SI=$S(SI<3:4,1:SI)
 I $G(STARTDAY)="" D
 .S SL=$G(^SC(+SDN,"SL")),X=$P(SL,U,3),STARTDAY=$S(X:X,1:8),SC=+SDN
 W !!,?16,"TIME",?SI+SI-1 F Y=STARTDAY:1:BSDTOT\(SI+SI)+STARTDAY W $E("|"_$S('Y:0,1:(Y-1#12+1))_"                 ",1,SI+SI)
 W !,?16,"DATE",?SI+SI-1,"|" K J F Y=0:1:6 I $D(^SC(+SDN,"T"_Y)) S J(Y)=""
 F Y=1:1:BSDTOT\(SI+SI) W $J("|",SI+SI)
 Q
 ;
 ;IHS/OIT/LJF 12/30/2005 PATCH 1005 rewrote so display goes to End date, not just 1st 3 dates
DAY S SDD=SDAY-.001,Z="",SDSLOT=0,SDCNT=0
 ;F  S SDD=$O(^SC(SDN,"ST",SDD)) Q:'SDD  Q:SDD>SDEND  Q:SDCNT=3  D
 F  S SDD=$O(^SC(SDN,"ST",SDD)) Q:'SDD  Q:SDD>SDEND  D
 . S SDX=0
 . ;F  S SDX=$O(^SC(SDN,"ST",SDD,SDX)) Q:'SDX  Q:SDCNT=3  D
 . F  S SDX=$O(^SC(SDN,"ST",SDD,SDX)) Q:'SDX  D
 .. S Z=$E(^SC(SDN,"ST",SDD,SDX),6,$L(^SC(SDN,"ST",SDD,SDX)))
 .. Q:Z["CANCELLED"
 .. I (Z'["|"),(Z'["[") Q
 .. S SDSLOT=$TR(Z,"|[@#]!$* ABCDEFXjklmno",0)
 .. Q:+SDSLOT<1                                   ;no appt slots found
 .. I SDCNT=0 D HD W !,$P(^SC(SDN,0),U,1)         ;display times & clinic name
 .. S Y=$$FMTE^XLFDT(SDD)                         ;printable date
 .. W !,Y,?15
 .. I $E(^SC(SDN,"ST",SDD,SDX),6,7)'="  " D
 ... W ^SC(SDN,"ST",SDD,SDX)
 .. E  D
 ... W $E(^SC(SDN,"ST",SDD,SDX),1,5),$E(^SC(SDN,"ST",SDD,SDX),8,120)
 .. S SDCNT=SDCNT+1                              ;keep count so know when to print heading
 Q
