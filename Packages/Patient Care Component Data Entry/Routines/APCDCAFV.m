APCDCAFV ; IHS/CMI/LAB - CODING QUEUE ROUTINE 16-AUG-1994 ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;; ;
 ;
PROCESS ;EP
 S APCDJ=$J,APCDH=$H,APCDGRTA=0,APCDGRTP=0
 S ^XTMP("APCDCAFT",0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_"PCC UNREVIEWED REPORT"
 S APCDODAT=$P(APCDBD,".")-1,APCDODAT=APCDODAT_".9999"
 S (APCDRCNT,APCDVIEN)=0 F  S APCDODAT=$O(^AUPNVSIT("B",APCDODAT)) Q:APCDODAT=""!($P(APCDODAT,".")>$P(APCDED,"."))  D
 .S APCDVIEN=0 F  S APCDVIEN=$O(^AUPNVSIT("B",APCDODAT,APCDVIEN)) Q:APCDVIEN'=+APCDVIEN  D
 ..S APCDV0=$G(^AUPNVSIT(APCDVIEN,0))
 ..Q:APCDV0=""
 ..I $P(APCDV0,U,7)="I",'$D(^APCDSITE(DUZ(2),13,"B","I")) G N
 ..;Q:"AOSTCRN"'[$P(APCDV0,U,7)  ;SERV CAT -LORI CHANGE THIS
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
 ..S $P(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",$P($P(^AUPNVSIT(APCDVIEN,0),U),"."),$P(^AUPNVSIT(APCDVIEN,0),U,7)),U,1)=$P($G(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",$P($P(^AUPNVSIT(APCDVIEN,0),U),"."),$P(^AUPNVSIT(APCDVIEN,0),U,7))),U,1)+1
 ..S APCDGRTA=APCDGRTA+1
 ..I 'APCDVPP D
 ...S $P(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",$P($P(^AUPNVSIT(APCDVIEN,0),U),"."),$P(^AUPNVSIT(APCDVIEN,0),U,7)),U,2)=$P($G(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",$P($P(^AUPNVSIT(APCDVIEN,0),U),"."),$P(^AUPNVSIT(APCDVIEN,0),U,7))),U,2)+1
 ...S APCDGRTP=APCDGRTP+1
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
 I '$D(^AUPNVCA(V)) Q ""
 NEW X,A,D,L
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .S D=$P(^AUPNVCA(X,0),U)
 .S A((9999999-$P(D,".")))=X
 S L=$O(A(0)) I L="" Q ""
 S L=A(0)
 Q $S(F="I":$P(^AUPNVCA(X,0),U,5),1:$$VAL^XBDIQ1(9000010.45,X,.05))
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
DONE I $D(APCDET) S APCDDVTS=(86400*($P(APCDET,",")-$P(APCDBT,",")))+($P(APCDET,",",2)-$P(APCDBT,",",2)),APCDDVH=$P(APCDDVTS/3600,".") S:APCDDVH="" APCDDVH=0
 S APCDDVTS=APCDDVTS-(APCDDVH*3600),APCDDVM=$P(APCDDVTS/60,".") S:APCDDVM="" APCDDVM=0 S APCDDVTS=APCDDVTS-(APCDDVM*60),APCDDVS=APCDDVTS W !!,"RUN TIME (H.M.S): ",APCDDVH,".",APCDDVM,".",APCDDVS
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
XIT ; Clean up and exit
 K ^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS")
 D EN^XBVK("APCD")
 Q
PRINT1 ; Print report 2
 I $Y>(IOSL-3) D HEAD I 1
 E  D H1
 I '$D(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS")) W !!,"There are no visits that are not already reviewed." Q
 S APCDS="" F  S APCDS=$O(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",APCDS)) Q:APCDS=""!($D(APCDQUIT))  D
 .S APCDFRO=1 S APCDV="" F  S APCDV=$O(^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",APCDS,APCDV)) Q:APCDV=""!($D(APCDQUIT))  D
 ..I $Y>(IOSL-5) D HEAD Q:$D(APCDQUIT)
 ..D PRN1 S APCDFRO=""
 .S APCDFRO=""
TOTALS ;
 Q:$D(APCDQUIT)
 I $Y>(IOSL-3) D HEAD Q:$D(APCDQUIT)
 W !!,"Totals:",?35,APCDGRTA,?60,APCDGRTP
 Q
PRN1 ;EP
 S APCDX=^XTMP("APCDCAFT",APCDJ,APCDH,"VISITS",APCDS,APCDV)
 W ! W:APCDFRO $$FMTE^XLFDT(APCDS) W ?19,$E($$EXTSET^XBFUNC(9000010,.07,APCDV),1,12),?35,$P(APCDX,U,1),?60,$P(APCDX,U,2)
 ;
 Q
PAGEHEAD ;
HEAD ;EP;HEADER
 I 'APCDPG G HEAD1
HEAD2 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",APCDPG
 W !?29,"PCC Data Entry Module"
 W !,$$CTR("******************************************************************",80)
 W !,$$CTR("*   COUNT OF VISITS WITH CHART AUDIT STATUS OF INCOMPLETE/BLANK  *",80)
 W !,$$CTR("******************************************************************",80)
H1 S X="VISIT Date Range: "_APCDBDD_" through "_APCDEDD W !,$$CTR(X,80)
 W !!,"VISIT DATE",?19,"SERV CAT",?35,"# UNREVIEWED VISITS",?60,"# W/NO PROV",!,?60,"(ANCILLARY)"
 W !,APCD80S
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
COVPAGE ;
 W !,$$FMTE^XLFDT(DT),?70,"Page: ",APCDPG
 W !?29,"PCC Data Entry Module"
 W !,$$CTR("******************************************************************",80)
 W !,$$CTR("*   COUNT OF VISITS WITH CHART AUDIT STATUS OF INCOMPLETE/BLANK   *",80)
 W !,$$CTR("******************************************************************",80)
 W !!,$$CTR("VISIT LIST CRITERIA",80)
 W !!,"VISIT DATES: ",$$FMTE^XLFDT(APCDBD)," to ",$$FMTE^XLFDT(APCDED)
 W !,"SERVICE CATEGORY: A, O, S, C, T"
 W !,"VISIT TYPE:  NOT Contract"
 W !!,"LOCATION OF ENCOUNTER: " D
 .I '$D(APCLLOCS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDLOCS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(4,Y,0),U),1,15)
 W !!,"CLINICS: " D
 .I '$D(APCLCLNS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDCLNS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^DIC(40.7,Y,0),U),1,15)
 W !!,"HOSPITAL LOCATIONS: " D
 .I '$D(APCLHLS) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDHLS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^SC(Y,0),U),1,15)
 W !!,"PRIMARY PROVIDER ON VISIT: " D
 .I '$D(APCLPRV) W "All" Q
 .S Y=0,C=0 F  S Y=$O(APCDPRVS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^VA(200,Y,0),U),1,15)
 ;W !!,"CHART AUDIT STATUS: " D
 ;.I '$D(APCDCASS) W "All" Q
 ;.S Y=0,C=0 F  S Y=$O(APCDCASS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$$EXTSET^XBFUNC(9000010.45,Y,.04)
 W !!,"CHART DEFICIENCY REASONS: " D
 .I '$D(APCLCDRS) W "All (includes visits with no chart deficiency reason entered" Q
 .S Y=0,C=0 F  S Y=$O(APCDCDRS(Y)) Q:Y'=+Y  S C=C+1 W:C>1 ";" W ?24,$E($P(^AUTTCDR(Y,0),U),1,15)
 Q
