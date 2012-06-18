APCDDVL5 ; IHS/CMI/LAB - report on T/C VISITS WITH ANCILLARY ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;IHS/CMI/LAB - patch 1 Y2K
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
 S DIR(0)="S^T:Terminal Digit Order;H:Health Record Number Order;D:Visit Date Order",DIR("A")="Sort the report by",DIR("B")="T" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ED
 S APCDCSRT=Y
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCDDVL5",XBRC="PROCESS^APCDDVL5",XBRX="EOJ^APCDDVL5",XBNS="APCD"
 D ^XBDBQUE
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCD")
 Q
PROCESS ;EP - called from XBDBQUE
 S ^XTMP("APCDDVL5",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"APCD - RETURN TO STOCK MEDS"
 S APCDJ=$J,APCDBT=$H
 S APCDT=APCDBD-.0001,APCDEND=APCDED+.2400
 F  S APCDT=$O(^AUPNVSIT("B",APCDT)) Q:'APCDT!(APCDT>APCDEND)  D
 . S APCDV=0
 . F  S APCDV=$O(^AUPNVSIT("B",APCDT,APCDV)) Q:'APCDV  D
 .. S G=0
 .. I '$$RTS(APCDV) Q
 .. Q:$P(^AUPNVSIT(APCDV,0),U,7)="C"
 .. Q:$P(^AUPNVSIT(APCDV,0),U,7)="T"
 .. Q:$$CLINIC^APCLV(APCDV,"C")=51
 .. Q:$$CLINIC^APCLV(APCDV,"C")=52
 .. S APCDSORT="" D GETSORT I APCDSORT="" S APCDSORT="??"
 .. S ^XTMP("APCDDVL5",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)=""
 .. Q
 . Q
 Q
RTS(V) ;
 NEW G,X,C
 ;if all have returned to stock
 S G=0,X=0,C=0
 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X  D
 .S C=C+1  ;# OF VMEDS
 .I $P($G(^AUPNVMED(X,11)),U)["RETURNED TO STOCK" S G=G+1
 .Q
 I 'G Q 0
 Q 1
GETSORT ;get sort value
 I APCDCSRT="D" S APCDSORT=$P(^AUPNVSIT(APCDV,0),U) Q
 ;I APCDCSRT="C" S APCDSORT=$$CLINIC^APCLV(APCDV,"C") Q  ;clinic code
 ;hrn sort values
 S APCDSORT=$$HRN^AUPNPAT($P(^AUPNVSIT(APCDV,0),U,5),DUZ(2))
 Q:APCDCSRT'="T"
 S APCDSORT=APCDSORT+10000000,APCDSORT=$E(APCDSORT,7,8)_"-"_+$E(APCDSORT,2,8)
 Q
PRINT ;EP - called from XBDBQUE
 S APCDQUIT="",APCDPG=0 D HDR
 I '$D(^XTMP("APCDDVL5",APCDJ,APCDBT)) D HDR W !!,"NO DATA TO REPORT",! G DONE
 S APCDSORT="" F  S APCDSORT=$O(^XTMP("APCDDVL5",APCDJ,APCDBT,"VISITS",APCDSORT)) Q:APCDSORT=""!(APCDQUIT)  D
 . S APCDV=0 F  S APCDV=$O(^XTMP("APCDDVL5",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)) Q:APCDV'=+APCDV!(APCDQUIT)  D
 .. I $Y>(IOSL-4) D HDR Q:APCDQUIT
 .. S APCDVR=^AUPNVSIT(APCDV,0)
 .. W !,$E($P(^DPT($P(APCDVR,U,5),0),U),1,15),?16,$$HRN^AUPNPAT($P(APCDVR,U,5),DUZ(2)),?24,$$DATE($P($P(APCDVR,U),".")),?36,$P(APCDVR,U,7),?39,$$CLINIC^APCLV(APCDV,"C") ;Y2000
 .. S APCDC=0,APCDM=0 F  S APCDM=$O(^AUPNVMED("AD",APCDV,APCDM)) Q:APCDM'=+APCDM!(APCDQUIT)  D
 ... S APCDC=APCDC+1
 ... I $Y>(IOSL-3) D HDR Q:APCDQUIT
 ... W:APCDC>1 !
 ... W ?45,$E($$VAL^XBDIQ1(9000010.14,APCDM,.01),1,28)
 ... I $P($G(^AUPNVMED(APCDM,11)),U)["RETURNED TO STOCK" W ?75,"Yes" I 1
 ... E  W ?75,"No"
 .Q
DONE ;
 K ^XTMP("APCDDVL5",APCDJ,APCDBT),APCDJ,APCDBT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
DATE(D) ;
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
HDR ;header for report
 I 'APCDPG G HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT=1 Q
HDR1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $P(^VA(200,DUZ,0),U,2),$$CTR($$FMTE^XLFDT(DT)),?71,"Page ",APCDPG,!
 W $$CTR($$LOC),!
 W $$CTR("Visits with a RETURNED TO STOCK Medication"),!
 W !?3,"PATIENT NAME",?17,"HRN",?24,"VISIT DATE",?36,"SC",?39,"CL",?45,"DRUG",?75,"RTS?",!
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
 ;;This report will list all non chart review/telephone call visits
 ;;with a V Medication that is flagged as RETURN TO STOCK.
 ;;
 ;; 
 ;;
 ;;END
ADDMENU ;EP
 S X=$$ADD^XPDMENU("APCDDVR","APCD C T VISITS W ANCILLARY","CTA")
 I 'X W "Attempt to add update option failed." H 3
 Q
