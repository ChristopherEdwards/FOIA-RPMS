APCDCAFA ; IHS/CMI/LAB - report on T/C VISITS WITH ANCILLARY ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
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
 S XBRP="PRINT^APCDCAFA",XBRC="PROCESS^APCDCAFA",XBRX="EOJ^APCDCAFA",XBNS="APCD"
 D ^XBDBQUE
 D EOJ
 Q
 ;
EOJ ;
 D EN^XBVK("APCD")
 Q
PROCESS ;EP - called from XBDBQUE
 S ^XTMP("APCDCAFA",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"APCD - C OR T WITH ANCILLARY"
 S APCDJ=$J,APCDBT=$H
 S APCDT=APCDBD-.0001,APCDEND=APCDED+.2400
 F  S APCDT=$O(^AUPNVSIT("B",APCDT)) Q:'APCDT!(APCDT>APCDEND)  D
 . S APCDV=0
 . F  S APCDV=$O(^AUPNVSIT("B",APCDT,APCDV)) Q:'APCDV  D
 .. Q:$P($G(^AUPNVSIT(APCDV,11)),U,11)="R"
 .. S C=$$CLINIC^APCLV(APCDV,"C")
 .. I C'=39 Q  ;not pharmacy
 .. Q:$D(^AUPNVMED("AD",APCDV))  ;has a med
 .. Q:'$D(^AUPNVPRV("AD",APCDV))  ;NO PROVIDER
 .. ;v = has V65.49 or V65.19   O = has other POV
 .. S V=0,O=0,X=0 F  S X=$O(^AUPNVPOV("AD",APCDV,X)) Q:X'=+X  D
 ... S I=$P(^AUPNVPOV(X,0),U)
 ... Q:'I
 ... Q:'$D(^ICD9(I,0))
 ... S I=$P($$ICDDX^ICDCODE(I),U,2)
 ... I I="V65.49"!(I="V65.19") S V=1
 ... I I'="V65.49",I'="V65.19" S O=1
 .. I O Q
 .. I 'V Q
 .. D ^XBFMK
 .. D UPDATE
 .. S APCDSORT="" D GETSORT I APCDSORT="" S APCDSORT="??"
 .. S ^XTMP("APCDCAFA",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)=""
 .. Q
 . Q
 Q
UPDATE ;
 K DIC,DD,D0,DO
 S X=$$NOW^XLFDT,DIC="^AUPNVCA(",DIC(0)="L",DIADD=1,DLAYGO=9000010.45,DIC("DR")=".02////"_$P(^AUPNVSIT(APCDV,0),U,5)_";.03////"_APCDV_";.04////R;.05////"_DUZ D FILE^DICN
 K DIC,DD,D0,DIADD,DLAYGO
UPD1 ;
 D ^XBFMK
 S DIE="^AUPNVSIT(",DA=APCDV,DR=".13////"_DT_";1111////R" D ^DIE K DIE,DA,DR
 ;
UPDATEX ;
 K DIADD,DLAYGO
 D ^XBFMK
 Q
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
 I '$D(^XTMP("APCDCAFA",APCDJ,APCDBT)) W !!,"NO DATA TO REPORT",! G DONE
 S APCDSORT="" F  S APCDSORT=$O(^XTMP("APCDCAFA",APCDJ,APCDBT,"VISITS",APCDSORT)) Q:APCDSORT=""!(APCDQUIT)  D
 . S APCDV=0 F  S APCDV=$O(^XTMP("APCDCAFA",APCDJ,APCDBT,"VISITS",APCDSORT,APCDV)) Q:APCDV'=+APCDV!(APCDQUIT)  D
 .. I $Y>(IOSL-4) D HDR Q:APCDQUIT
 .. S APCDVR=^AUPNVSIT(APCDV,0)
 .. W !,$E($P(^DPT($P(APCDVR,U,5),0),U),1,15),?16,$$HRN^AUPNPAT($P(APCDVR,U,5),DUZ(2)),?24,$$DATE($P($P(APCDVR,U),".")),?36,$P(APCDVR,U,7),?39,$$CLINIC^APCLV(APCDV,"C") ;Y2000
 .. S APCDC=0,APCDY=0 F  S APCDY=$O(^AUPNVPOV("AD",APCDV,APCDY)) Q:APCDY'=+APCDY!(APCDQUIT)  D
 ... S APCDC=APCDC+1
 ... I $Y>(IOSL-3) D HDR Q:APCDQUIT
 ... W:APCDC>1 !
 ... W ?45,$$VAL^XBDIQ1(9000010.07,APCDY,.01)
 .Q
DONE ;
 K ^XTMP("APCDCAFA",APCDJ,APCDBT),APCDJ,APCDBT
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
 W $$CTR("Visits Automatically Completed/Reviewed"),!
 W !?3,"PATIENT NAME",?17,"HRN",?24,"VISIT DATE",?36,"SC",?39,"CL",?45,"Purpose of Visits",!
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
 ;;This option is used to automatically COMPLETE/REVIEW all"
 ;;visits in a date range that meet the following criteria:
 ;;    - POV is V65.49 or V65.19
 ;;    - there is no Medication dispensed
 ;;    - Clinic is 39 - Pharmacy
 ;;    - there is no other Purpose of visit/diagnosis
 ;;    - there is a primary provider
 ;;
 ;;A list of visits will be provided.
 ;;
 ;;END
