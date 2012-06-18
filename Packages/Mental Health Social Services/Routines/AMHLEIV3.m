AMHLEIV3 ; IHS/CMI/LAB - treatment plan update ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
PRINT ;EP
 NEW DFN,AMHPAT,AMHDPT,Y,X,AMHBROW,AMHAO,AMHINTR
 I '$G(AMHRINTI) W !!,"ERROR - IEN OF INTAKE not defined!" Q
 S (DFN,AMHPAT)=$P(^AMHRINTK(AMHRINTI,0),U,2)
 D FULL^VALM1
 S AMHDPT=""
 S DIR(0)="S^I:Intake Document Only;U:Update Document Only;B:Both the Intake and Update Documents;Q:Quit/Exit",DIR("A")="What would you like to print",DIR("B")="I" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="Q" Q
 S AMHDPT=Y
 I AMHDPT="I" G DEVICE
 S AMHAO=""
 K AMHREVS,AMHREVP
 I AMHDPT="U",'$O(^AMHRINTK("AI",AMHRINTI,0)) W !!,"There are no updates on file to print." D PAUSE G PRINT
 I AMHDPT="B",'$O(^AMHRINTK("AI",AMHRINTI,0)) W !!,"There are no updates to print...printing intake only." G DEVICE
 ;display all updates and have user choose
 W !?4,"0)  ",?10,"Quit/Exit (or type '^')"
 S (AMHX,AMHC)=0 F  S AMHX=$O(^AMHRINTK("AI",AMHRINTI,AMHX)) Q:AMHX'=+AMHX  D
 .S AMHC=AMHC+1,AMHREVS(AMHC)=AMHX
 .S AMHINTR=$P(^AMHRINTK(AMHX,0),U,3)
 .W !,?4,AMHC,")  ",?10,"Date: ",$$D^AMHLEIV($$VALI^XBDIQ1(9002011.13,AMHX,.01)),"  Provider: ",$E($$VAL^XBDIQ1(9002011.13,AMHX,.04),1,15),?51,$E($$VAL^XBDIQ1(9002011.13,AMHX,.05),1,13),?65,$$VAL^XBDIQ1(9002011.13,AMHX,.09)
 S AMHC=AMHC+1 W !?4,AMHC,")  ",?10,"ALL Updates"
 K DIR
 S DIR(0)="L^0:"_AMHC,DIR("A")="Which Updates would you like to Print",DIR("B")=AMHC KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PRINT
 I Y[0 G PRINT
 I Y[AMHC D   K AMHREVS G DEVICE
 .F I=1:1:(AMHC-1) S AMHREVP(AMHREVS(I))=""
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S J=AMHREVS(C) S AMHREVP(J)=""
 K AMHREVS
DEVICE ;print or browse
 W ! S DIR(0)="S^P:PRINT Output on Paper;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D PAUSE,EXIT^AMHLEIV Q
 I $G(Y)="B" D BROWSE D EXIT^AMHLEIV Q
 D EN1
 D EXIT^AMHLEIV
 Q
BROWSE ;
 S AMHBROW=1 D VIEWR^XBLM("PRINT1^AMHLEIV3","Display of Intake Document") K AMHBROW
 Q
EN1 ;EP - called from protocol
 ;DFN must be equal to patient
 ;get device
 S XBRP="PRINT1^AMHLEIV3",XBRC="",XBRX="XIT^AMHLEIV3",XBNS="AMH;DFN"
 D ^XBDBQUE
 D EXIT^AMHLEIV
 Q
XIT ;
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
GUI(AMHDPT,DFN,AMHRINTI,AMHREVP,AMHARRAY) ;EP - gui call
 I '$G(DFN) Q ""
 I '$G(AMHRINTI) Q ""
 NEW AMHGUI
 S AMHGUI=1
 D GUIR^XBLM("PRINT1^AMHLEIV3",AMHARRAY)
 Q
PRINT1 ;EP - called from xbdbque
 ;NOW REORDER THE UPDATES WITH THE INTAKE BY LATEST FIRST
 S AMHIOSL=$S($G(AMHGUI):55,1:IOSL)
 K AMHREVD
 S X=0 F  S X=$O(AMHREVP(X)) Q:X'=+X  S AMHREVD((9999999-$P(^AMHRINTK(X,0),U)),X)=""
 I AMHDPT'="U"  S AMHREVD((9999999-$P(^AMHRINTK(AMHRINTI,0),U)),AMHRINTI)=""
 ;I '$D(^AMHRINTK(AMHRINTI)) D HEAD W !!,"No INTAKE Document on file for ",$P(^DPT(DFN,0),U) Q
 NEW AMHQUIT,AMHPG,AMHX,AMHV,AMHPRNM,AMHPCNT,AMHFILE,AMHNOD,AMHRD,AMHRP
 S (AMHQUIT,AMHPG)=0
 S AMHRD=0 F  S AMHRD=$O(AMHREVD(AMHRD)) Q:AMHRD'=+AMHRD!(AMHQUIT)  D
 .S AMHRP=99999999999 F  S AMHRP=$O(AMHREVD(AMHRD,AMHRP),-1) Q:AMHRP'=+AMHRP!(AMHQUIT)  D PRINT2
 .Q
 Q
PRINT2 ;
 NEW X,Y,I,AMHINTT,AMHINTR
 ;S AMHIOSL=$S($G(AMHGUI):55,1:IOSL)
 S AMHINTT=$P(^AMHRINTK(AMHRP,0),U,9)
 D HEAD
 S AMHINTR=$P(^AMHRINTK(AMHRP,0),U,3)
 W !?2,"Date "_$S(AMHINTT="I":"Established",1:"Updated")_":  ",?22,$$VAL^XBDIQ1(9002011.13,AMHRP,.01)
 W !?2,"Provider:  ",?22,$$VAL^XBDIQ1(9002011.13,AMHRP,.04)
 W !?2,"Program:",?22,$$VAL^XBDIQ1(9002011.13,AMHRP,.05)
 W !?2,"Type of Document:",?22,$$VAL^XBDIQ1(9002011.13,AMHRP,.09)
 W !!?2,"Intake Documentation/Narrative:",!
 K AMHPCNT,AMHPRNM S AMHPCNT=0,AMHNODE=41,AMHDA=AMHRP  ;,AMHFILE=9002011.13 D WP^AMHLETP4
 S AMHX=0 F  S AMHX=$O(^AMHRINTK(AMHDA,AMHNODE,AMHX)) Q:AMHX'=+AMHX  S AMHPCNT=AMHPCNT+1,AMHPRNM(AMHPCNT)=^AMHRINTK(AMHDA,AMHNODE,AMHX,0)
 I $D(AMHPRNM) S X=0 F  S X=$O(AMHPRNM(X)) Q:X'=+X!(AMHQUIT)  D:$Y>(AMHIOSL-3) HEAD Q:AMHQUIT  W $TR(AMHPRNM(X),$C(10)),!  ;cmi/maw 1/13/10 pr593
 I $G(AMHBROW) G SIG
 I $Y>(AMHIOSL-8) D HEAD Q:AMHQUIT
 S X=AMHIOSL-$Y S X=X-8 F I=1:1:X W !
 I '$P(^AMHRINTK(AMHRP,0),U,11) D
 .W !,"________________________________________",?52,"__________________"
 .W !?60,"DATE"
SIG I $P(^AMHRINTK(AMHRP,0),U,11) D
 .W !?2,"PROVIDER SIGNATURE:  /es/  "_$P(^AMHRINTK(AMHRP,0),U,12)
 .I $P(^AMHRINTK(AMHRP,0),U,16)]"" W !?29,$P(^AMHRINTK(AMHRP,0),U,16)
 .W !?5,"Signed:  "_$P($$FMTE^XLFDT($P(^AMHRINTK(AMHRP,0),U,11)),"@",1)_" "_$P($$FMTE^XLFDT($P(^AMHRINTK(AMHRP,0),U,11)),"@",2)
 W !!!,"________________________________________",?52,"__________________"
 W !?60,"DATE"
 Q
HEAD ;ENTRY POINT
 I 'AMHPG G HEAD1
 NEW X
 I '$G(AMHBROW),$E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
HEAD1 ;EP
 I AMHPG W:$D(IOF) @IOF
 S AMHPG=AMHPG+1
 W:$G(AMHGUI) "ZZZZZZZ",!
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$TR($J("",80)," ","*")
 W !,"*",?79,"*"
 W !,"*  INTAKE DOCUMENT "_$S(AMHINTT="U":"UPDATE",1:""),?45,"Printed: ",$$FMTE^XLFDT($$NOW^XLFDT),?79,"*"
 W !,"*  Name:  ",$P(^DPT(DFN,0),U),?68,"Page ",AMHPG,?79,"*"
 W !,"*  ",$E($P(^DIC(4,DUZ(2),0),U),1,25),?30,"DOB:  ",$$FMTE^XLFDT($P(^DPT(DFN,0),U,3),"2D"),?46,"Sex:  ",$P(^DPT(DFN,0),U,2),?54,"  Chart #:  ",$P(^AUTTLOC(DUZ(2),0),U,7),$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2),?79,"*"
 W !,"*",?79,"*"
 W !,$TR($J("",80)," ","*"),!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
