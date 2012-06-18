APCDDVL2 ; IHS/CMI/LAB - report on checked in visits with no pov ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - Y2K
 ;
 ;
START ;
 D EOJ
 D INFORM
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EOJ
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter ending Visit Date:  " S Y=APCDBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 ;
SORT ;
 S APCDCSRT=""
 S DIR(0)="S^T:Terminal Digit Order;H:Health Record Number Order;D:Visit Date Order;C:Clinic Code Order",DIR("A")="Sort the report by",DIR("B")="T" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ED
 S APCDCSRT=Y
DEMO ;
 D DEMOCHK^APCLUTL(.APCDDEMO)
 I APCDDEMO=-1 G BD
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCDDVL2",XBRC="PROCESS^APCDDVL2",XBRX="EOJ^APCDDVL2",XBNS="APCD"
 D ^XBDBQUE
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCD")
 Q
PROCESS ;EP - called from XBDBQUE
 S ^XTMP("APCDDVL2",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"APCD - DTC VISITS W NO BILL LINK"
 S APCDJ=$J,APCDBT=$H
 S APCDT=APCDBD-.0001,APCDEND=APCDED+.2400
 F  S APCDT=$O(^AUPNVSIT("B",APCDT)) Q:'APCDT!(APCDT>APCDEND)  D
 . S APCDV=0
 . F  S APCDV=$O(^AUPNVSIT("B",APCDT,APCDV)) Q:'APCDV  D
 .. I '$$DTC(APCDV) Q  ;no DTC's
 .. Q:$$DEMO^APCLUTL($P(^AUPNVSIT(APCDV,0),U,5),APCDDEMO)
 .. I $P(^AUPNVSIT(APCDV,0),U,28)]"" Q  ;has billing link
 .. I $P(^AUPNVSIT(APCDV,0),U,6)'=DUZ(2) Q  ;another facilities visit
 .. S APCDSORT="" D GETSORT I APCDSORT="" S APCDSORT="??"
 .. S ^XTMP("APCDDVL2",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)=""
 .. Q
 . Q
 Q
GETSORT ;get sort value
 I APCDCSRT="D" S APCDSORT=$P(^AUPNVSIT(APCDV,0),U) Q
 I APCDCSRT="C" S APCDSORT=$$CLINIC^APCLV(APCDV,"C") Q  ;clinic code
 ;hrn sort values
 S APCDSORT=$$HRN^AUPNPAT($P(^AUPNVSIT(APCDV,0),U,5),DUZ(2))
 Q:APCDCSRT'="T"
 S APCDSORT=APCDSORT+10000000,APCDSORT=$E(APCDSORT,7,8)_"-"_+$E(APCDSORT,2,8)
 Q
PRINT ;EP - called from XBDBQUE
 S APCDQUIT="",APCDPG=0 D HDR
 I '$D(^XTMP("APCDDVL2",APCDJ,APCDBT)) D HDR W !!,"NO DATA TO REPORT",! G DONE
 S APCDSORT="" F  S APCDSORT=$O(^XTMP("APCDDVL2",APCDJ,APCDBT,"VISITS",APCDSORT)) Q:APCDSORT=""!(APCDQUIT)  D
 . S APCDV=0 F  S APCDV=$O(^XTMP("APCDDVL2",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)) Q:APCDV'=+APCDV!(APCDQUIT)  D
 .. I $Y>(IOSL-4) D HDR Q:APCDQUIT
 .. S APCDVR=^AUPNVSIT(APCDV,0)
 .. ;beginning Y2K
 .. ;W !,$E($P(^DPT($P(APCDVR,U,5),0),U),1,15),?16,$$HRN^AUPNPAT($P(APCDVR,U,5),DUZ(2)),?23,$$FMTE^XLFDT($P(APCDVR,U),"2"),?38,$P(APCDVR,U,7),?40,$$CLINIC^APCLV(APCDV,"C") ;Y2000
 .. W !,$E($P(^DPT($P(APCDVR,U,5),0),U),1,15),?16,$$HRN^AUPNPAT($P(APCDVR,U,5),DUZ(2)),?23,$$FMTE^XLFDT($P(APCDVR,U),"5"),?40,$P(APCDVR,U,7),?42,$$CLINIC^APCLV(APCDV,"C") ;Y2000
 .. ;W ?43,$E($$PRIMPROV^APCLV(APCDV,"N"),1,20),?65,$$PRIMPOV^APCLV(APCDV,"C") ;Y2000
 .. W ?45,$E($$PRIMPROV^APCLV(APCDV,"N"),1,20),?67,$$PRIMPOV^APCLV(APCDV,"C") ;Y2000
 .. ;end Y2K
 .. S (C,APCDX)=0 F  S APCDX=$O(^AUPNVTC("AD",APCDV,APCDX)) Q:APCDX'=+APCDX!(APCDQUIT)  I $P($G(^AUPNVTC(APCDX,12)),U,2) D
 ... I $Y>(IOSL-4) D HDR Q:APCDQUIT
 ... W ! W:'C ?3,"DTC's: "
 ... ;beginning Y2K
 ... ;W ?10,$$VAL^XBDIQ1(9000010.33,APCDX,.01)," ",$E($$VAL^XBDIQ1(90092.02,$P(^AUPNVTC(APCDX,0),U),.019),1,30),?55,$$FMTE^XLFDT($P(^AUPNVTC(APCDX,12),U,11),"2"),?65,$E($$VAL^XBDIQ1(9000010.33,APCDX,1202),1,15) ;Y2000
 ... W ?10,$$VAL^XBDIQ1(9000010.33,APCDX,.01)," ",$E($$VAL^XBDIQ1(90092.02,$P(^AUPNVTC(APCDX,0),U),.019),1,30),?54,$$FMTE^XLFDT($P(^AUPNVTC(APCDX,12),U,11),"5"),?65,$E($$VAL^XBDIQ1(9000010.33,APCDX,1202),1,15) ;Y2000
 ... ;end Y2K
 .. S D=$$ORDT(APCDV),P=$P(^AUPNVSIT(APCDV,0),U,5)
 .. S DATE=(9999999-D)-.0001,END=(9999999-D)+.9999999
 .. F  S DATE=$O(^AUPNVSIT("AA",P,DATE)) Q:'DATE!(DATE>END)!(APCDQUIT)  D
 ... S APCDX=0 F  S APCDX=$O(^AUPNVSIT("AA",P,DATE,APCDX)) Q:APCDX'=+APCDX!(APCDQUIT)  I APCDX'=APCDV,'$P(^AUPNVSIT(APCDX,0),U,11) S C=C+1 D
 .... I $Y>(IOSL-3) D HDR Q:(APCDQUIT)
 .... W ! W:C=1 ?3,"Order date vsts: "
 .... ;beginning Y2K
 .... ;W ?21,$$FMTE^XLFDT($P(^AUPNVSIT(APCDX,0),U),"2"),?38,$P(^AUPNVSIT(APCDX,0),U,7),?39,$$CLINIC^APCLV(APCDX,"C"),?42,$E($$VAL^XBDIQ1(9000010,APCDX,.22),1,15),?59,$E($$PRIMPROV^APCLV(APCDX,"N"),1,15),?74,$$PRIMPOV^APCLV(APCDX,"C") ;Y2000
 .... W ?21,$$FMTE^XLFDT($P(^AUPNVSIT(APCDX,0),U),"5"),?40,$P(^AUPNVSIT(APCDX,0),U,7),?44,$$CLINIC^APCLV(APCDX,"C"),?42,$E($$VAL^XBDIQ1(9000010,APCDX,.22),1,15),?60,$E($$PRIMPROV^APCLV(APCDX,"N"),1,15),?76,$$PRIMPOV^APCLV(APCDX,"C") ;Y2000
 .... ;end Y2K
 .... Q
 ... Q
 .. Q
 .Q
DONE ;
 K ^XTMP("APCDDVL2",APCDJ,APCDBT),APCDJ,APCDBT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
DTC(V) ;any v tran code with an ordering provider? 1 or 0
 I '$G(V) Q 0
 I '$D(^AUPNVSIT(V,0)) Q 0
 I '$D(^AUPNVTC("AD",V)) Q 0
 NEW C
 S (X,C)=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  I $P($G(^AUPNVTC(X,12)),U,11) S C=C+1
 Q C
 ;
ORDT(V) ;
 I '$G(V) Q 0
 I '$D(^AUPNVSIT(V,0)) Q 0
 I '$D(^AUPNVTC("AD",V)) Q 0
 NEW C
 S (X,C)=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X!(C)  I $P($G(^AUPNVTC(X,12)),U,11) S C=$P(^AUPNVTC(X,12),U,11)
 Q C
 ;
VCNT(V) ;return number of other visits on this date
 I '$G(V) Q 0
 I '$D(^AUPNVSIT(V)) Q 0
 NEW D,X,Y,C,DATE,END,P
 S P=$P(^AUPNVSIT(V,0),U,5)
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S (C,C1)=0,DATE=(9999999-D)-.0001,END=(9999999-D)+.9999999
 F  S DATE=$O(^AUPNVSIT("AA",P,DATE)) Q:'DATE!(DATE>END)  D
 . S X=0 F  S X=$O(^AUPNVSIT("AA",P,DATE,X)) Q:X'=+X  I X'=V,'$P(^AUPNVSIT(X,0),U,11) S C=C+1 I $D(^AUPNVPOV("AD",X)),$D(^AUPNVPRV("AD",X)) S C1=C1+1
 Q C_U_C1
 ;
HDR ;header for report
 I 'APCDPG G HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT=1 Q
HDR1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $P(^VA(200,DUZ,0),U,2),$$CTR($$FMTE^XLFDT(DT)),?71,"Page ",APCDPG,!
 W $$CTR($$LOC),!
 W $$CTR("DTC Visits with No Billing Link"),!
 ;beginning Y2K
 ;W !?3,"PATIENT NAME",?17,"HRN",?22,"VISIT DATE",?37,"SC",?40,"CL",?43,"PRIM PROVIDER",?65,"PRIM POV",! ;Y2000
 W !?3,"PATIENT NAME",?17,"HRN",?22,"VISIT DATE",?39,"SC",?42,"CL",?45,"PRIM PROVIDER",?67,"PRIM POV",! ;Y2000
 ;end Y2K
 W $TR($J(" ",80)," ","-"),!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;let user know what is gong on
 W:$D(IOF) @IOF
 W !!,$$CTR($$LOC,80)
 W !,$$CTR($$USR,80),!!
 F I=1:1 S X=$P($T(INTRO+I),";;",2) Q:X="END"  W !,X
 K I,X
 Q
INTRO ;;
 ;;This report will list all visit in a time frame you indicate that have
 ;;a DTC tran code but NO Billing Link.
 ;;These visits could not be linked back to the original ordering visit.
 ;;END
