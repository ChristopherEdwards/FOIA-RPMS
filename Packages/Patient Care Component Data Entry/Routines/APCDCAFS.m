APCDCAFS ; IHS/CMI/LAB - MENTAL HLTH ROUTINE 16-AUG-1994 ;
 ;;2.0;IHS PCC SUITE;**2,5**;MAY 14, 2009
 ;; ;
 ;
PROCESS ;EP
 S APCDJ=$J,APCDH=$H
 S ^XTMP("APCDCAFR",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC UNREVIEWED REPORT"
 S APCDODAT=$P(APCDBD,".")-1,APCDODAT=APCDODAT_".9999"
 S (APCDRCNT,APCDVIEN)=0 F  S APCDODAT=$O(^AUPNVSIT("B",APCDODAT)) Q:APCDODAT=""!($P(APCDODAT,".")>$P(APCDED,"."))  D
 .S APCDVIEN=0 F  S APCDVIEN=$O(^AUPNVSIT("B",APCDODAT,APCDVIEN)) Q:APCDVIEN'=+APCDVIEN  D
 ..S APCDV0=$G(^AUPNVSIT(APCDVIEN,0))
 ..Q:APCDV0=""
 ..;Q:"AOSTCR"'[$P(APCDV0,U,7)  ;SERV CAT - NO I's per Dorene
 ..I $P(APCDV0,U,7)="I",'$D(^APCDSITE(DUZ(2),13,"B","I")) G N
 ..;Q:"AOSTCR"'[$P(APCDV0,U,7)
 ..Q:'$$SCW^APCDCAF($P(APCDV0,U,7))
N ..;
 ..Q:'$P(APCDV0,U,9)        ;NO DEP ENTRIES
 ..Q:$P(APCDV0,U,11)        ;DELETED
 ..Q:$P(APCDV0,U,3)="C"     ;CONTRACT
 ..;Q:'$D(^AUPNVPOV("AD",APCDVIEN))  ;no pov  PER CAROLYN JOHNSON, INCLUDE THEM
 ..;Q:'$D(^AUPNVPRV("AD",APCDVIEN))  ;no provider
 ..S APCDVPP=$$PRIMPROV^APCLV(APCDVIEN,"I")
 ..;Q:'APCDVPP  ;no primary provider
 ..S APCDVLOC=$P(APCDV0,U,6)
 ..Q:APCDVLOC=""  ;no location of encounter
 ..I $D(APCDLOCS),'$D(APCDLOCS(APCDVLOC)) Q  ;not a location we want
 ..S X=$P(APCDV0,U,7)
 ..Q:X=""  ;no sc
 ..I $D(APCDSCS),'$D(APCDSCS(X)) Q  ;not a sc we want
 ..S APCDVCLN=$P(APCDV0,U,8)
 ..I APCDVCLN="",$D(APCDCLNS) Q  ;clinic blank and want certain clinics
 ..I $D(APCDCLNS),'$D(APCDCLNS(APCDVCLN)) Q  ;not a CLINIC we want
 ..S APCDVHL=$P(APCDV0,U,22)
 ..I APCDVHL="",$D(APCDHLS) Q  ;HOSP LOC blank and want certain HOSP LOCS
 ..I $D(APCDHLS),'$D(APCDHLS(APCDVHL)) Q  ;not a HOSP LOC we want
 ..I APCDVPP="",$D(APCDPRVS) Q  ;PRIM PROV blank and want certain PRIM PROVS
 ..I $D(APCDPRVS),'$D(APCDPRVS(APCDVPP)) Q  ;not a PRIM PROV we want
 ..S APCDVCAS=$P($G(^AUPNVSIT(APCDVIEN,11)),U,11)
 ..I APCDVCAS="R" Q  ;DON'T DISPLAY REVIEWED VISITS
 ..;I $D(APCDCASS),'$D(APCDCASS(APCDVCAS)) Q
 ..S APCDVCDR=$$LASTCDR(APCDVIEN)  ;last chart deficiency reason
 ..I APCDVCDR="",$D(APCDCDRS) Q  ;
 ..I $D(APCDCDRS),'$D(APCDCDRS(APCDVCDR)) Q
 ..S ^XTMP("APCDCAFR",APCDJ,APCDH,"VISITS",$$SORT(APCDVIEN,APCDSORT),APCDVIEN)=""
 ..Q
 .Q
 Q
 ;
DATE(D) ;
 NEW X,Y
 S X=$P(D,".")
 S X=$E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 S Y=$$FMTE^XLFDT(D,"2S"),Y=$P(Y,"@",2),Y=$P(Y,":",1,2)
 Q X_"@"_Y
 ;
ERRORCHK ;
 ;check for no pov, .9999 or multiple primary providers
 S APCDERR=""
 I '$D(^AUPNVPOV("AD",APCDV)) S APCDERR="NO POV"
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCDV,X)) Q:X'=+X  D
 .I $$VAL^XBDIQ1(9000010.07,X,.01)=".9999" S APCDERR=".9999 POV "
 S X=0,C=0 F  S X=$O(^AUPNVPRV("AD",APCDV,X)) Q:X'=+X  D
 .I $P(^AUPNVPRV(X,0),U,4)="P" S C=C+1
 I C>1 S APCDERR=APCDERR_"MULT PRIM PROV"
 Q
RBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
 ;
LASTCDR(V,F) ;EP - get last chart deficiency reason
 I $G(F)="" S F="I"  ;default to ien
 ;I '$D(^AUPNVCA(V)) Q ""
 NEW X,A,D,L
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .Q:$P(^AUPNVCA(X,0),U,6)=""
 .S D=$P(^AUPNVCA(X,0),U)
 .S A((9999999-$P(D,".")))=X
 S L=$O(A(0)) I L="" Q ""
 S X=A(L)
 Q $S(F="I":$P(^AUPNVCA(X,0),U,6),1:$$VAL^XBDIQ1(9000010.45,X,.06))
 ;
SORT(V,S) ;
 NEW R
 S R=""
 D @(S_"SORT")
 I R="" S R="--"
 Q R
 ;
DSORT ;
 I 'V Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S R=$P(^AUPNVSIT(V,0),U)
 Q
 ;
SSORT ;
 I 'V Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S R=$$VAL^XBDIQ1(9000010,V,.07)
 Q
 ;
LSORT ;
 I 'V Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S R=$$VAL^XBDIQ1(9000010,V,.06)
 Q
 ;
CSORT ;
 I 'V Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S R=$$VAL^XBDIQ1(9000010,V,.08)
 Q
 ;
OSORT ;
 I 'V Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S R=$$VAL^XBDIQ1(9000010,V,.22)
 Q
 ;
PSORT ;
 S R=$$PRIMPROV^APCLV(V,"N")
 Q
 ;
ASORT ;
 I 'V Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 S R=$$VAL^XBDIQ1(9000010,V,1111)
 I R="" S R="INCOMPLETE"
 Q
 ;
RSORT ;
 S R=$$LASTCDR(V,"E")
 Q
 ;
NSORT ;
 S R=$$VAL^XBDIQ1(9000010,V,.05)
 Q
 ;
HSORT ;
 S R=$$HRN^AUPNPAT($P(^AUPNVSIT(V,0),U,5),DUZ(2))
 Q
 ;
TSORT ;
 I V="" Q
 I '$D(^AUPNVSIT(V,0)) Q ""
 NEW D
 S D=$P(^AUPNVSIT(V,0),U,5)
 I D="" Q
 S R=$$HRN^AUPNPAT(D,DUZ(2))
 S R=R+10000000,R=$E(R,7,8)_$E(R,1,6)
 Q
 ;
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 ;Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press Enter to Continue",DIR(0)="E" D ^DIR
 Q
 ;----------
PRINT ;EP - called from xbdbque
 S APCD80S="-------------------------------------------------------------------------------"
 S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
 S APCDPG=0
 K APCDQUIT
 D COVPAGE
 D PRINT1
DONE ;
 I $D(APCDQUIT) G XIT
 I $D(APCDET) S APCDDVTS=(86400*($P(APCDET,",")-$P(APCDBT,",")))+($P(APCDET,",",2)-$P(APCDBT,",",2)),APCDDVH=$P(APCDDVTS/3600,".") S:APCDDVH="" APCDDVH=0
 S APCDDVTS=APCDDVTS-(APCDDVH*3600),APCDDVM=$P(APCDDVTS/60,".") S:APCDDVM="" APCDDVM=0 S APCDDVTS=APCDDVTS-(APCDDVM*60),APCDDVS=APCDDVTS W !!,"RUN TIME (H.M.S): ",APCDDVH,".",APCDDVM,".",APCDDVS
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
XIT ; Clean up and exit
 K ^XTMP("APCDCAFR",APCDJ,APCDH,"VISITS")
 D EN^XBVK("APCD")
 Q
PRINT1 ; Print report 2
 K APCDQUIT
 D HEAD
 I '$D(^XTMP("APCDCAFR",APCDJ,APCDH,"VISITS")) W !!,"There are no visits that are not already reviewed." Q
 S APCDS="" F  S APCDS=$O(^XTMP("APCDCAFR",APCDJ,APCDH,"VISITS",APCDS)) Q:APCDS=""!($D(APCDQUIT))  D
 .S APCDV="" F  S APCDV=$O(^XTMP("APCDCAFR",APCDJ,APCDH,"VISITS",APCDS,APCDV)) Q:APCDV=""!($D(APCDQUIT))  D
 ..I $Y>(IOSL-5) D HEAD Q:$D(APCDQUIT)
 ..D PRN1
 ..D DE
 ..D ER
 Q
ER ; CHECK FOR VARIOUS ERRORS
 ;no pov, no prov, .9999, multi prim prov, 
 Q
DE ;EP;FIND DEP ENTRIES
 W !?10,"This visit has:  "
 S APCDVFLE=9000010 F  S APCDVFLE=$O(^DIC(APCDVFLE)) Q:APCDVFLE>9000010.99!(APCDVFLE'=+APCDVFLE)  D DE2
 Q
 ;
DE2 ;
 Q:APCDVFLE=9000010.45  ;DON'T DISPLAY CHART AUDIT V FILE
 S APCDVDG=^DIC(APCDVFLE,0,"GL"),APCDVIGR=APCDVDG_"""AD"",APCDV,APCDVDFN)"
 S APCDVDFN="" I $O(@APCDVIGR)]"" W ?27,$P($P(^DIC(APCDVFLE,0),U),"V ",2),"'s",!
 K APCDAPOV,APCDAPRV
 F APCDVI=1:1 S APCDVDFN=$O(@APCDVIGR) Q:APCDVDFN=""  D
 .S APCDK12N=APCDVDG_APCDVDFN_",12)",APCDK12D=""
 .I $D(@(APCDK12N)) S APCDK12D=@(APCDK12N)
 .S APCDK16N="",APCDK16D="" I APCDVFLE=9000010.09 S APCDK16N=APCDVDG_APCDVDFN_",16)" I $D(@(APCDK16N)) S APCDK16D=@(APCDK16N)
 .I $P(APCDK16D,U)]"" S APCDAPOV($P(APCDK16D,U))=""
 .I $P(APCDK12D,U,13)]"" S APCDAPOV($P(APCDK12D,U,13))=""
 .I $P(APCDK12D,U,2)]"" S APCDAPRV($P(^DIC(APCDVFLE,0),U)_" - "_$P($G(^VA(200,$P(APCDK12D,U,2),0)),U))=""
 .I $P(APCDK12D,U,4)]"" S APCDAPRV($P(^DIC(APCDVFLE,0),U)_" - "_$P($G(^VA(200,$P(APCDK12D,U,4),0)),U))=""
 Q
 ;
PRN1 ;EP
 S APCDVR=^AUPNVSIT(APCDV,0) S:'$P(APCDVR,U,6) $P(APCDVR,U,6)=0
 S DFN=$P(APCDVR,U,5)
 S APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(DFN,$P(APCDVR,U,6),2)
 I APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(DFN,DUZ(2))
 W !,$$FMTE^XLFDT($P(APCDVR,U)),?19,APCDHRN,?31,$E($P(^DPT(DFN,0),U),1,17),?50,$E($P(^DIC(4,$P(APCDVR,U,6),0),U),1,10),?61,$P(APCDVR,U,7)
 W ?64,$$CLINIC^APCLV(APCDV,"C"),?67,$E($$VAL^XBDIQ1(9000010,APCDV,.22),1,11),?78,$P(APCDVR,U,9)
 W:$$PRIMPROV^APCLV(APCDV,"N")]"" !," PRIMARY PROVIDER: ",$$PRIMPROV^APCLV(APCDV,"N")
 I $P($G(^AUPNVSIT(APCDV,12)),U,11)]"" W !," Ext Acct #: ",$P($G(^AUPNVSIT(APCDV,12)),U,11) ;IHS/CMI/LAB - added acct # display
 ;
 Q
PAGEHEAD ;
HEAD ;EP;HEADER
 G:$D(APCDDEM)!($D(APCDDEMM)) HEAD2
 I 'APCDPG G HEAD1
HEAD2 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",APCDPG
 W !?29,"PCC Data Entry Module"
 W !,$$CTR("******************************************************************",80)
 W !,$$CTR("*   LIST OF VISITS WITH CHART AUDIT STATUS OF INCOMPLETE/BLANK   *",80)
 W !,$$CTR("******************************************************************",80)
 S X="VISIT Date Range: "_APCDBDD_" through "_APCDEDD W !,$$CTR(X,80)
 ;S X=$S(APCDLOCT="A":"ALL Locations Included",APCDLOCT="O":"Location of Encounter: "_$P(^DIC(4,APCDLOCT("ONE"),0),U),APCDLOCT="S":"LOCATIONs Included: ALL Within the "_$P(^AUTTSU(APCDLOCT("SU"),0),U)_" Service Unit",1:"")
 ;W !?(80-$L(X)/2),X
 W !!,"VISIT DATE",?19,"HRN",?31,"PATIENT NAME",?50,"LOCATION",?61,"SC",?64,"CL",?67,"HOSP LOC",?77,"DEC"
 W !,APCD80S
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
COVPAGE ;
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",APCDPG
 W !?29,"PCC Data Entry Module"
 W !,$$CTR("******************************************************************",80)
 W !,$$CTR("*   LIST OF VISITS WITH CHART AUDIT STATUS OF INCOMPLETE/BLANK   *",80)
 W !,$$CTR("******************************************************************",80)
 W !!,$$CTR("VISIT LIST CRITERIA",80)
 W !!,"VISIT DATES: ",$$FMTE^XLFDT(APCDBD)," to ",$$FMTE^XLFDT(APCDED)
 W !,"VISIT TYPE:  NOT Contract"
 W !!,"LOCATION OF ENCOUNTER: " D
 .I '$D(APCDLOCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDLOCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(4,Y,0),U),1,15)
 W !!,"CLINICS: " D
 .I '$D(APCDCLNS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDCLNS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(40.7,Y,0),U),1,15)
 W !!,"SERVICE CATEGORIES: " D
 .I '$D(APCDSCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDSCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010,.07,Y)
 W !!,"HOSPITAL LOCATIONS: " D
 .I '$D(APCDHLS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDHLS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^SC(Y,0),U),1,15)
 W !!,"PRIMARY PROVIDER ON VISIT: " D
 .I '$D(APCDPRV) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDPRVS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^VA(200,Y,0),U),1,15)
 ;W !!,"CHART AUDIT STATUS: " D
 ;.I '$D(APCDCASS) W "All" Q
 ;.S Y=0,C=0 F  S Y=$O(APCDCASS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010.45,Y,.04)
 W !!,"CHART DEFICIENCY REASONS: " D
 .I '$D(APCDCDRS) W "All (includes visits with no chart deficiency reason entered" Q
 .S Y=0,C=0 F  S Y=$O(APCDCDRS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^AUTTCDR(Y,0),U),1,15)
 Q
