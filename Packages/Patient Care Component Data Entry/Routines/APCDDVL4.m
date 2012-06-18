APCDDVL4 ; IHS/CMI/LAB - report on T/C VISITS WITH ANCILLARY ;
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
DEMO ;
 D DEMOCHK^APCLUTL(.APCDDEMO)
 I APCDDEMO=-1 G BD
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCDDVL4",XBRC="PROCESS^APCDDVL4",XBRX="EOJ^APCDDVL4",XBNS="APCD"
 D ^XBDBQUE
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCD")
 Q
PROCESS ;EP - called from XBDBQUE
 S ^XTMP("APCDDVL4",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"APCD - C OR T WITH ANCILLARY"
 S APCDJ=$J,APCDBT=$H
 S APCDT=APCDBD-.0001,APCDEND=APCDED+.2400
 F  S APCDT=$O(^AUPNVSIT("B",APCDT)) Q:'APCDT!(APCDT>APCDEND)  D
 . S APCDV=0
 . F  S APCDV=$O(^AUPNVSIT("B",APCDT,APCDV)) Q:'APCDV  D
 .. S G=0 D
 ... Q:$$DEMO^APCLUTL($P(^AUPNVSIT(APCDV,0),U,5),APCDDEMO)
 ... I $P(^AUPNVSIT(APCDV,0),U,7)="T" S G=1  ;telephone serv cat
 ... I $P(^AUPNVSIT(APCDV,0),U,7)="C" S G=1  ;chart review serv cat
 ... S C=$$CLINIC^APCLV(APCDV,"C")
 ... I C=52 S G=1  ;CHART REVIEW
 ... I C=51 S G=1  ;TELEPHONE CLINIC
 .. Q:'G
 .. Q:'$$ANCIL(APCDV)  ;no ancillary item
 .. S APCDSORT="" D GETSORT I APCDSORT="" S APCDSORT="??"
 .. S ^XTMP("APCDDVL4",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)=""
 .. Q
 . Q
 Q
ANCIL(V) ;
 I $D(^AUPNVMED("AD",V)),'$$RTS(V) Q 1
 I $D(^AUPNVLAB("AD",V)) Q 1
 I $D(^AUPNVMIC("AD",V)) Q 1
 I $D(^AUPNVBB("AD",V)) Q 1
 I $D(^AUPNVRAD("AD",V)) Q 1
 Q 0
RTS(V) ;
 NEW G,X,C
 ;if all have returned to stock
 S G=0,X=0,C=0
 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X  D
 .S C=C+1  ;# OF VMEDS
 .I $P($G(^AUPNVMED(X,11)),U)["RETURNED TO STOCK" S G=G+1
 .Q
 I G=C Q 1
 Q 0
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
 I '$D(^XTMP("APCDDVL4",APCDJ,APCDBT)) D HDR W !!,"NO DATA TO REPORT",! G DONE
 S APCDSORT="" F  S APCDSORT=$O(^XTMP("APCDDVL4",APCDJ,APCDBT,"VISITS",APCDSORT)) Q:APCDSORT=""!(APCDQUIT)  D
 . S APCDV=0 F  S APCDV=$O(^XTMP("APCDDVL4",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)) Q:APCDV'=+APCDV!(APCDQUIT)  D
 .. I $Y>(IOSL-4) D HDR Q:APCDQUIT
 .. S APCDVR=^AUPNVSIT(APCDV,0)
 .. W !,$E($P(^DPT($P(APCDVR,U,5),0),U),1,15),?16,$$HRN^AUPNPAT($P(APCDVR,U,5),DUZ(2)),?24,$$DATE($P($P(APCDVR,U),".")),?36,$P(APCDVR,U,7),?39,$$CLINIC^APCLV(APCDV,"C") ;Y2000
 .. K APCDX,APCDD D DE
 .. S APCDY=0 F  S APCDY=$O(APCDX(APCDY)) Q:APCDY'=+APCDY!(APCDQUIT)  D
 ... I $Y>(IOSL-3) D HDR Q:APCDQUIT
 ... W:APCDY>1 !
 ... ;beginning Y2K
 ... W ?45,$P(APCDX(APCDY),U),?54,$E($P(APCDX(APCDY),U,2),1,15),?70,$$DATE($P($P(APCDX(APCDY),U,3),".")) ;Y2000
 .Q
DONE ;
 K ^XTMP("APCDDVL4",APCDJ,APCDBT),APCDJ,APCDBT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 Q
DE ;EP;FIND DEP ENTRIES
 K APCDX,APCDD S APCDC=0
 S APCDVFLE=9000010 F  S APCDVFLE=$O(^DIC(APCDVFLE)) Q:APCDVFLE>9000010.99!(APCDVFLE'=+APCDVFLE)  D DE2
 Q
 ;
DE2 ;
 I '$$DF(APCDVFLE) Q
 S APCDVDG=^DIC(APCDVFLE,0,"GL"),APCDVIGR=APCDVDG_"""AD"",APCDV,APCDVDFN)"
 S APCDVDFN="" I $O(@APCDVIGR)]"" S APCDC=APCDC+1,APCDX(APCDC)=$E($P($P(^DIC(APCDVFLE,0),U),"V ",2),1,3)_"'s" S Y=$O(@APCDVIGR) S $P(APCDX(APCDC),U,3)=$$VALI^XBDIQ1(APCDVFLE,Y,1211),$P(APCDX(APCDC),U,2)=$$VAL^XBDIQ1(APCDVFLE,Y,1202)
 Q
 ;
DATE(D) ;
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
DF(F) ;
 I F=9000010.09 Q 1
 I F=9000010.14 Q 1
 I F=9000010.22 Q 1
 I F=9000010.25 Q 1
 I F=9000010.31 Q 1
 Q 0
HDR ;header for report
 I 'APCDPG G HDR1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT=1 Q
HDR1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $P(^VA(200,DUZ,0),U,2),$$CTR($$FMTE^XLFDT(DT)),?71,"Page ",APCDPG,!
 W $$CTR($$LOC),!
 W $$CTR("Chart Review and Telephone Call visits with ancillary data"),!
 W !?3,"PATIENT NAME",?17,"HRN",?24,"VISIT DATE",?36,"SC",?39,"CL",?45,"DATA",?54,"ORDER PROV",?70,"ORDER DATE"
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
 ;;This report will list all visits with a service category of
 ;;T (telecommunications) or C (Chart Review) or clinic code 51 (TELEPHONE),
 ;;or clinic code 52 (CHART REVIEW) that have an ancillary
 ;;data item attached to them.  The ancillary data items are defined as:
 ;;   MEDICATION
 ;;   RADIOLOGY
 ;;   MICROBIOLOGY
 ;;   LAB
 ;;   BLOOD BANK
 ;; 
 ;;
 ;;END
ADDMENU ;EP
 S X=$$ADD^XPDMENU("APCDDVR","APCD C T VISITS W ANCILLARY","CTA")
 I 'X W "Attempt to add update option failed." H 3
 Q
