AMHLETP3 ; IHS/CMI/LAB - print goals on tp ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
SIG ;signature line
 Q:AMHQUIT
 I $Y>(AMHIOSL-17) D HEAD^AMHLETPP Q:AMHQUIT
 I '$G(AMHBROW) S X=AMHIOSL-$Y-17 F I=1:1:X W !
 I $G(AMHBROW) W !!
 W !!!!?2,"__________________________________     ___________________________________"
 W !?2,"Client's Signature                     Designated Provider's Signature"
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Supervisor's Signature                 Physician's Signature",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
REV ;EP - review with client
 I $G(AMHPREV)="T" Q
 I '$D(^AMHPTXP(AMHTP,41)) Q
 S AMHD=0 F  S AMHD=$O(^AMHPTXP(AMHTP,41,AMHD)) Q:AMHD'=+AMHD!(AMHQUIT)  D
 .I $D(AMHREVP) Q:'$D(AMHREVP(AMHD))
 .D HEAD Q:AMHQUIT
 .W !!?2,"Date of Review:  ",?27,$$FMTE^XLFDT(AMHD)
 .I $Y>(AMHIOSL-3) D HEAD Q:AMHQUIT
 .W !!?2,"Reviewing Provider:  ",?27,$S($P(^AMHPTXP(AMHTP,41,AMHD,0),U,3):$P(^VA(200,$P(^AMHPTXP(AMHTP,41,AMHD,0),U,3),0),U),1:"<<not recorded>>")
 .I $Y>(AMHIOSL-3) D HEAD Q:AMHQUIT
 .W !!?2,"Reviewing Supervisor:  ",?27,$S($P(^AMHPTXP(AMHTP,41,AMHD,0),U,4):$P(^VA(200,$P(^AMHPTXP(AMHTP,41,AMHD,0),U,4),0),U),1:"<<not recorded>>")
 .I $Y>(AMHIOSL-3) D HEAD Q:AMHQUIT
 .W !!?2,"Next Review Date:  ",?27,$$FMTE^XLFDT($P(^AMHPTXP(AMHTP,41,AMHD,0),U,2))
 .W !!?2,"Progress Summary: ",!
 .K AMHPCNT,AMHPRNM S AMHPCNT=0,AMHNODE=1,AMHDA=AMHD,AMHFILE=9002011.564101,AMHG="^AMHPTXP("_AMHTP_",41," D NWP^AMHLETP4
 .;K AMHPCNT,AMHPRNM S AMHPCNT=0,X=0 F  S X=$O(^AMHPTXP(AMHTP,41,AMHD,1,X)) Q:X'=+X  S AMHPCNT=AMHPCNT+1,AMHPRNM(AMHPCNT)=^AMHPTXP(AMHTP,41,AMHD,1,X,0)
 .I $D(AMHPRNM) S X=0 F  S X=$O(AMHPRNM(X)) Q:X'=+X!(AMHQUIT)  D:$Y>(AMHIOSL-2) HEAD^AMHLETPP Q:AMHQUIT  W ?6,$TR(AMHPRNM(X),$C(10)),!
 .Q:AMHQUIT
 .;participants
 .I $Y>(AMHIOSL-5) D HEAD Q:AMHQUIT
PART .W !!?2,"Participants in Review:"
 .W !!?2,"PARTICIPANT NAME",?35,"RELATIONSHIP TO CLIENT"
 .I '$D(^AMHPTXP(AMHTP,41,AMHD,12)) D SIGREV Q
 .S X=0 F  S X=$O(^AMHPTXP(AMHTP,41,AMHD,12,X)) Q:X'=+X!(AMHQUIT)  D
 ..D:$Y>(AMHIOSL-3) HEAD Q:AMHQUIT  W !!?2,$P(^AMHPTXP(AMHTP,41,AMHD,12,X,0),U),?35,$P(^AMHPTXP(AMHTP,41,AMHD,12,X,0),U,2)
 ..Q
 .Q:AMHQUIT
 .D SIGREV
 .Q
 Q
SIGREV ;
 I $Y>(AMHIOSL-17) D HEAD^AMHLETPP Q:AMHQUIT
 I '$G(AMHBROW) S X=AMHIOSL-$Y-17 F I=1:1:X W !
 I $G(AMHBROW) W !!
 W !!!!?2,"__________________________________     ___________________________________"
 W !?2,"Client's Signature                     Designated Provider's Signature"
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Supervisor's Signature                 Physician's Signature",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
 Q
HEAD ;ENTRY POINT
 I 'AMHPG G HEAD1
 NEW X
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
HEAD1 ;EP
 I AMHPG W:$D(IOF) @IOF
 S AMHPG=AMHPG+1
 W:$G(AMHGUI) "ZZZZZZZ",!
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$TR($J("",80)," ","*")
 W !,"*",?79,"*"
 W !,"*  TREATMENT PLAN REVIEW",?45,"Printed: ",$$FMTE^XLFDT($$NOW^XLFDT),?79,"*"
 W !,"*  Name:  ",$P(^DPT(DFN,0),U),?68,"Page ",AMHPG,?79,"*"
 W !,"*  ",$E($P(^DIC(4,DUZ(2),0),U),1,25),?30,"DOB:  ",$$FMTE^XLFDT($P(^DPT(DFN,0),U,3),"2D"),?46,"Sex:  ",$P(^DPT(DFN,0),U,2),?54,"  Chart #:  ",$P(^AUTTLOC(DUZ(2),0),U,7),$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2),?79,"*"
 W !,"*",?79,"*"
 W !,$TR($J("",80)," ","*"),!
 Q
 ;
