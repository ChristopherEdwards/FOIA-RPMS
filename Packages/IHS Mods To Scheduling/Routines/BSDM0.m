BSDM0 ; IHS/ANMC/LJF - IHS MONTH-AT-A-GLANCE ;  [ 01/15/2004  11:39 AM ]
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 03/08/2006 PATCH 1005 if max days for future booking, Monday appt okay
 ;
EN(BSDANS) ;EP; -- main entry point for month-at-a-glance list templates
 NEW VALMCNT,DIR,DIC
 ;BSDANS = answer to date to start display
 S VALMCC=1    ;1=screen mode, 0=scrolling mode
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM MONTH DISPLAY")
 Q
 ;
HDR ;EP; -- header code
 F I=1:1:3 Q:'$D(^SC(+SC,"SI",I,0))  S VALMHDR(I)=^(0)
 S VALM("TM")=I+3                          ;set top margin based on # lines of special instruc
 S VALM("LINES")=VALM("BM")-VALM("TM")+1   ;reset # lines on screen
 Q
 ;
INIT ;EP; -- init variables and list array
 K ^TMP("BSDM0",$J),^TMP("BSDM",$J) S VALMCNT=0
 D GUIR^XBLM("DISP^BSDM0","^TMP(""BSDM0"",$J,")
 S X=0 F  S X=$O(^TMP("BSDM0",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDM",$J,X,0)=^TMP("BSDM0",$J,X)
 ;
 ; add legend to display to explain 1s, 0s, As, Bs, *s, etc.
 S VALMCNT=VALMCNT+1,^TMP("BSDM",$J,VALMCNT,0)=""  ;extra line
 NEW BSDX D LEGEND^BSDU(.BSDX)
 S X=0 F  S X=$O(BSDX(X)) Q:'X  D
 . S VALMCNT=VALMCNT+1,^TMP("BSDM",$J,VALMCNT,0)=BSDX(X)
 ;
 K ^TMP("BSDM0",$J)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BSDM",$J)
 S VALMNOFF=1  ;suppress form feed before next question
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
DISP ;EP; creates display lines
 ;lines below copied from D^SDM0 to DIFF^SDM0
 ;lines modified to handle longer days using BSD variables
 NEW BSDIOM,BSDTOT,BSDCNT
 S BSDIOM=150,BSDTOT=BSDIOM-15  ;used in place of 80 & 65 below
 S X=BSDANS                     ;answer passed from SDM0
 S BSDCNT=0                     ;counts lines per month
 W ?36,$P(SC,U,2) S:$O(^SC(+SC,"T",0))>X X=+$O(^(0)) D DOW S I=Y+32,D=Y S SDXF=0 D WM I SDXF D WMH
 ;
 ;IHS/OIT/LJF 03/08/2006 PATCH 1005 reset max days if max<3 and going over weekend
 ;I '$G(SDMAX) S X2=$S($D(^SC(+SC,"SDP")):$P(^("SDP"),"^",2),1:365),X1=DT,SDT=X D C^%DTC S SDMAX=X,X=SDT
 I '$G(SDMAX) D
 . S X2=$P($G(^SC(+SC,"SDP")),U,2) S:X2="" X2=365
 . I $$DOW^XLFDT(DT)="Friday",X2<3 S X2=3
 . S X1=DT,SDT=X D C^%DTC S SDMAX=X,X=SDT
 ;IHS/OIT/LJF 03/08/2006 end of changes
 ;
 S I=$$FMDIFF^XLFDT(SDMAX,X)  ;reset last day to max future booking
X1 S X1=X\100_$P("31^28^31^30^31^30^31^31^30^31^30^31",U,+$E(X,4,5))  ;28
W I '$D(^SC(+SC,"ST",X,1)) S Y=D#7 G L:'$D(J(Y)),H:$D(^HOLIDAY(X))&('SDSOH) S SS=+$O(^SC(+SC,"T"_Y,X)) G L:SS'>0,L:^(SS,1)="" S ^SC(+SC,"ST",$P(X,"."),1)=$E($P($T(DAY),U,Y+2),1,2)_" "_$E(X,6,7)_$J("",SI+SI-6)_^(1),^(0)=$P(X,".")
 ;S SDAV=1 D:X>SM WM I $D(^SC(+SC,"ST",X,1)),^(1)["["!(^(1)["CANCELLED")!($D(^HOLIDAY(X))) W !,$E(^SC(+SC,"ST",X,1),1,BSDIOM) S:'$D(^HOLIDAY(X))&('SDAV) SDAV=1
 ;S SDHX=X,SDAV=1 D:X>SM WM I SDXF<2 D WMH
 S SDHX=X,SDAV=1 I X>SM D WM,WMH        ;TEMP MOD
 I BSDCNT=15 D WMH                      ;add headings if lots of lines per month
 I $D(^SC(+SC,"ST",X,1)),^(1)["["!(^(1)["CANCELLED")!($D(^HOLIDAY(X))) W !,$E(^SC(+SC,"ST",X,1),1,BSDIOM) S:'$D(^HOLIDAY(X))&('SDAV) SDAV=1 S BSDCNT=BSDCNT+1
 ;I $Y>18 W ! Q  ;using list manager, no need for screen control
L S X=X+1,D=D+1
 I $D(SDINA),X>SDINA,SDRE>X!('SDRE) D:'SDAV NOAV S SDHY=Y,Y=SDINA D DTS^SDUTL W !,*7,?8,"Clinic is inactive ",$S(SDRE:"from ",1:"as of "),Y S Y=SDRE D:Y DTS^SDUTL W $S(SDRE:" to "_Y,1:"") S Y=SDHY K SDHY Q:'SDRE  D DIFF
 ;
 I ($$FMDIFF^XLFDT(SDMAX,X))<0 W ! D:'SDAV MNTH Q    ;IHS/OIT/LJF 03/08/2006 PATCH 1005
 ;
 G W:X'>X1 S X2=X-X1 D C^%DTC
 I $D(SDINA),X>SDINA,SDRE>X!('SDRE) D:'SDAV NOAV S SDHY=Y,Y=SDINA D DTS^SDUTL W !,*7,?8,"Clinic is inactive ",$S(SDRE:"from ",1:"as of "),Y S Y=SDRE D:Y DTS^SDUTL W $S(SDRE:" to "_Y,1:"") S Y=SDHY K SDHY Q:'SDRE
 ;
 ;IHS/OIT/LJF 03/08/2006 PATCH 1005
 ;G X1:D<I W ! D:'SDAV MNTH Q
 I (($$FMDIFF^XLFDT(SDMAX,X))'<0) G X1
 W ! D:'SDAV MNTH Q
 ;end of PATCH 1005 changes
 ;
NOAV W !,"No availability found between date chosen and inactivate date!" Q
H S ^SC(+SC,"ST",X,1)="   "_$E(X,6,7)_"    "_$P(^(X,0),U,2),^(0)=X G W
 ;
WM W !?36 S Y=$E(X,1,5)_"00",SM=$S($E(X,4,5)[12:$E(X,1,3)+1_"01",1:$E(X,1,3)_$E(X,4,5)+1)_"00"
 S SDXF=SDXF+1 I $E(X,6,7)>20 D
 . S SDXD=$O(^SC(+SC,"ST",X-1)) Q:SDXD=""
 . I $E(SDXD,4,5)'=$E(X,4,5) S SDXF=0
 D:SDXF DT
 Q
 ;
WMH ;Write month heading lines
 W !!," TIME",?SI+SI-1 F Y=STARTDAY:1:BSDTOT\(SI+SI)+STARTDAY W $E("|"_$S('Y:0,1:(Y-1#12+1))_"                 ",1,SI+SI)
 W !," DATE",?SI+SI-1,"|" K J F Y=0:1:6 I $D(^SC(+SC,"T"_Y)) S J(Y)=""
 F Y=1:1:BSDTOT\(SI+SI) W $J("|",SI+SI)
 S SDXF=2
 S BSDCNT=0   ;reset count after printing time headings
 Q
 ;
DT W $$FMTE^XLFDT(Y) Q
 ;
DOW S Y=$$DOW^XLFDT(X,1) Q
 ;
MNTH W !," *** No availability found for one full calendar month",!,"  Search stopped at " S Y=X D DTS^SDUTL W Y," ***",! Q
DIFF S X1=SDRE,X2=X D ^%DTC S D=D+X,X=SDRE,X1=X\100_28 Q
 ;
DAY ;;^SUN^MON^TUES^WEDNES^THURS^FRI^SATUR
