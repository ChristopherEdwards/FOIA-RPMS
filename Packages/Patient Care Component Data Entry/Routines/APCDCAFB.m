APCDCAFB ; IHS/CMI/LAB - ; 
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 D TERM^VALM0
 W @(IOF),!!
 D INFORM
 I $P(^APCCCTRL(DUZ(2),0),U,12)="" W !!,"The EHR/PCC Coding Audit Start Date has not been set",!,"in the PCC Master Control file." D  D XIT Q
 .W !!,"Please see your Clinical Coordinator or PCC Manager."
 .S DIR(0)="E",DIR("A")="Press Enter" KILL DA D ^DIR KILL DIR
 .Q
DATES K APCDED,APCDBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning REVIEW Date"
 D ^DIR G:Y<1 XIT S APCDBD=Y
 I APCDBD<$P($G(^APCCCTRL(DUZ(2),0)),U,12) D  G DATES
 .W !!,"That date is before the EHR/PCC Coding Start Date."
 .W !,"Please enter a date on or after "_$$FMTE^XLFDT($P(^APCCCTRL(DUZ(2),0),U,12))
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending REVIEW Date"
 D ^DIR G:Y<1 XIT  S APCDED=Y
 ;
 I APCDED<APCDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
USER ;
 S APCDDEO=""
 S DIR(0)="YO",DIR("A")="Report on ALL Operators",DIR("?")="If you wish to include visits reviewd by ALL Operators answer Yes.  If you wish to tabulate for only one operator enter NO." D ^DIR K DIR
 G:$D(DIRUT) DATES
 I Y=1 S APCDDEO="" G SUB
DEC1 ;enter location
 S DIC("A")="Which Operator: ",DIC="^VA(200,",DIC(0)="AEMQ" D ^DIC K DIC,DA G:Y<0 USER
 S APCDDEO=+Y
SUB ;
 S APCDVSTD=""
 K DIR W ! S DIR(0)="Y",DIR("A")="Do you wish to see a subtotal by REVIEW Date",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G USER
 S APCDVSTD=Y
ZIS ;call xbdbque
 S XBRC="DRIVER^APCDCAFB",XBRP="PRINT^APCDCAFB",XBRX="XIT^APCDCAFB",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
DRIVER ;EP entry point for taskman
 S APCDBT=$H,APCDJOB=$J
 K ^XTMP("APCDCAFB",APCDJOB,APCDBT)
 S ^XTMP("APCDCAFB",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"CODING QUEUE TALLY"
 ;loop through all visits in date range and exclude any not reviewed in the date range
 D V
 S APCDET=$H
 Q
V ;
 S APCDODAT=$P(APCDBD,".")-1,APCDODAT=APCDODAT_".9999"
 S (APCDRCNT,APCDVCAI)=0 F  S APCDODAT=$O(^AUPNVCA("B",APCDODAT)) Q:APCDODAT=""!($P(APCDODAT,".")>$P(APCDED,"."))  D
 .S APCDVCAI=0 F  S APCDVCAI=$O(^AUPNVCA("B",APCDODAT,APCDVCAI)) Q:APCDVCAI'=+APCDVCAI  D
 ..S APCDVIEN=$P(^AUPNVCA(APCDVCAI,0),U,3)
 ..Q:'APCDVIEN
 ..Q:'$D(^AUPNVSIT(APCDVIEN,0))
 ..S APCDV0=$G(^AUPNVSIT(APCDVIEN,0))
 ..Q:APCDV0=""
 ..Q:$P($G(^AUPNVSIT(APCDVIEN,11)),U,11)=""  ;not reviewed yet
 ..S APCDU=$P($G(^AUPNVCA(APCDVCAI,0)),U,5)
 ..Q:APCDU=""
 ..I $G(APCDDEO),APCDU'=APCDDEO Q  ;want 1 operator and this isn't it
 ..D SET(APCDU,$P($P(^AUPNVCA(APCDVCAI,0),U),"."),1)
 ..I $P(^AUPNVCA(APCDVCAI,0),U,4)="R" D SET(APCDU,$P($P(^AUPNVCA(APCDVCAI,0),U),"."),2)
 S APCDET=$H
 Q
SET(R,D,P) ;
 S $P(^XTMP("APCDCAFB",APCDJOB,APCDBT,R,D),U,P)=$P($G(^XTMP("APCDCAFB",APCDJOB,APCDBT,R,D)),U,P)+1
 S $P(^XTMP("APCDCAFB",APCDJOB,APCDBT,R),U,P)=$P($G(^XTMP("APCDCAFB",APCDJOB,APCDBT,R)),U,P)+1
 Q
PRINT ;EP
 S APCDQUIT="",APCDPG=0,APCDTOTV=0,APCDTOTR=0 D HDR
 I '$D(^XTMP("APCDCAFB",APCDJOB,APCDBT)) D HDR W !!,"NO DATA TO REPORT",! G DONE
 S APCDU="" F  S APCDU=$O(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU)) Q:APCDU=""!(APCDQUIT)  D
 . I $Y>(IOSL-3) D HDR Q:APCDQUIT
 . W !!,$P(^VA(200,APCDU,0),U),?40,$$C($P(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU),U),0),?55,$$C($P(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU),U,2),0)
 . S APCDTOTV=APCDTOTV+$P(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU),U,1),APCDTOTR=APCDTOTR+$P(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU),U,2)
 . Q:'APCDVSTD
 . S APCDD=0 F  S APCDD=$O(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU,APCDD)) Q:APCDD'=+APCDD!(APCDQUIT)  D
 .. I $Y>(IOSL-3) D HDR Q:APCDQUIT
 .. W !?10,$$FMTE^XLFDT(APCDD),?40,$$C($P(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU,APCDD),U),0),?55,$$C($P(^XTMP("APCDCAFB",APCDJOB,APCDBT,APCDU,APCDD),U,2),0)
 .Q
 I APCDQUIT G DONE
 I $Y>(IOSL-3) D HDR G:APCDQUIT DONE
 W !!,"Total Number of Visits:  ",?40,$$C(APCDTOTV,0),?55,$$C(APCDTOTR,0),!
DONE ;
 K ^XTMP("APCDCAFB",APCDJOB,APCDBT),APCDJ,APCDBT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
HDR ;EP;HEADER
 I 'APCDPG G HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT=1 Q
HDR1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",APCDPG
 W !?29,"PCC Data Entry Module"
 W !,$$CTR("******************************************************",80)
 W !,$$CTR("*   COUNT OF VISITS REVIEWED/COMPLETED BY OPERATOR   *",80)
 W !,$$CTR("******************************************************",80)
 S X="REVIEW Date Range: "_$$FMTE^XLFDT(APCDBD)_" through "_$$FMTE^XLFDT(APCDED) W !,$$CTR(X,80)
 ;I APCDLOCT="A" S X="Location of Encounter: All" W !,$$CTR(X,80)
 ;I APCDLOCT'="A" D
 ;.S X=0,Y="" F  S X=$O(APCDLOCS(X)) Q:X'=+X  S Y=Y_$S(Y="":"",1:";")_$P(^AUTTLOC(X,0),U,2)
 ;.;S X="Locations: "_Y W !,$$CTR(Y,80)
 W !!,"Operator",?40,"# of visits",?55,"# of visits marked"
 W !?40,"reviewed",?55,"as complete"
 W !,$$REPEAT^XLFSTR("-",80)
 Q
OPER(V) ;
 I '$D(^AUPNVSIT(V,0)) Q ""
 I '$D(^AUPNVCA("AD",V)) Q ""
 NEW X,G
 S G=""
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X!(G)  D
 .Q:'$D(^AUPNVCA(X,0))
 .I $P(^AUPNVCA(X,0),U,4)="R" S G=$P(^AUPNVCA(X,0),U,5)_U_$P($P(^AUPNVCA(X,0),U),".") Q
 .Q
 Q G
 ;
XIT ;
 K DIR
 D EN^XBVK("APCD")  ;clean up APCD variables
 D ^XBFMK  ;clean up fileman variables
 D KILL^AUPNPAT  ;clean up AUPN
 D EN^XBVK("AMQQ")  ;clean up after qman
 Q
 ;
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;inform user what this report is all about
 W !,$$CTR($$LOC)
 W !!,$$CTR("PCC/EHR CODING AUDIT")
 W !!,"This report will produce a tally of visits REVIEWED/COMPLETED"
 W !,"by the user who reviewed/completed the visit.  PLEASE NOTE:  this"
 W !,"report will only look at visits that have been reviewed and"
 W !,"marked as either REVIEWED/COMPLETE or INCOMPLETE.  If a visit has"
 W !,"never been reviewed it is not counted in this report.  You must"
 W !,"enter the REVIEW date range.  This is the date range for which visits"
 W !,"were reviewed.",!!
 W !,"Please keep in mind that more than one operator may have reviewed"
 W !,"a visit so the total number of visits in this report may be more"
 W !,"than the total number of visits to the facility as one visit"
 W !,"may be counted more than once."
 W !
 Q
OLOC ;one location
 S DIC="^AUTTLOC(",DIC(0)="AEMQ",DIC("A")="Which LOCATION: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDLOCS(+Y)=""
 Q
SLOC ;taxonomy of locations
 S X="LOCATION OF ENCOUNTER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDLOCS(")
 I '$D(APCDLOCS) S APCDQ="" Q
 I $D(APCDLOCS("*")) S APCDLOCT="A" K APCDLOCS W !!,"**** all locations will be included ****",! Q
 Q
INSTALLD(APCDSTAL) ;EP - Determine if patch APCDSTAL was installed, where
 ; APCDSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCDY,DIC,X,Y
 S X=$P(APCDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(APCDSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(APCDSTAL,"*",3)
 D ^DIC
 S APCDY=Y
 D IMES
 Q $S(APCDY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_APCDSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
INSTDATE(APCDSTAL) ;EP - Determine if patch APCDSTAL was installed, where
 ; APCDSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW APCDY,DIC,X,Y,APCDX,APCDZ
 S X=$P(APCDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 S APCDX=+Y
 S DIC=DIC_APCDX_",22,",X=$P(APCDSTAL,"*",2)
 D ^DIC
 S APCDZ=+Y
 S DIC=DIC_APCDZ_",""PAH"",",X=$P(APCDSTAL,"*",3)
 D ^DIC
 S APCDY=+Y
 Q $$FMTE^XLFDT($P(^DIC(9.4,APCDX,22,APCDZ,"PAH",APCDY,0),U,2))
