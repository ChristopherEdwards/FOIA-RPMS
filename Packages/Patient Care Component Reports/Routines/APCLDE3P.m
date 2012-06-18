APCLDE3P ; IHS/CMI/LAB - list refusals ; 10 Dec 2009  3:03 PM
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
PRINT ;EP - called from xbdbque
 D PRINT1
 D DONE
 Q
PRINT1 ;
 S APCLPG=0 K APCLQUIT
 K APCLLSTP
 I '$D(^XTMP("APCLDE3",APCLJ,APCLH)) D HEADER W !!,"No data to report.",! G DONE
 D COVPAGE
 Q:$$END
 D HEADER
 S APCLTOT=APCLCNT
 S APCLPTOT=$$PTOT
 W !," Total Number of Visits with Screening",?40,$J($$COM(APCLTOT,0),8)
 W !,"     Total Number of Patients Screened",?40,$J($$COM(APCLPTOT,0),8)
 D LIST
 Q
COM(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
END() ;
 I $Y<(IOSL-3) Q 0
 D HEADER
 I $D(APCLQUIT) Q 1
 Q 0
ENDL() ;
 I $Y<(IOSL-8) Q 0
 D HEADER
 I $D(APCLQUIT) Q 1
 Q 0
PTOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("APCLDE3",APCLJ,APCLH,"PTS",X)) Q:X'=+X  S C=C+1
 Q C
TOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("APCLDE3",APCLJ,APCLH,"VSTS",X)) Q:X'=+X  S C=C+1
 Q C
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  DEPRESSION SCREENING VISIT LISTING FOR SELECTED PATIENTS  ***",80),!
 S X="Screening Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 W !?35,"DATE",!,"PATIENT NAME",?22,"HRN",?29,"AGE",?35,"SCREENED",?55,"CLINIC"
 W !,$TR($J("",80)," ","-")
 Q
DONE ;
 K ^TMP($J)
 K ^XTMP("APCLDE3",APCLJ,APCLH)
 D EOP
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 W !
 S DIR("A")="End of Report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
LIST ;EP - called from xbdbque
 S APCLPG=0 K APCLQUIT
 S APCLLSTP=1
 D HEADER
 K ^TMP($J)
 ;resort by sort item
 S APCLX=0 F  S APCLX=$O(^XTMP("APCLDE3",APCLJ,APCLH,"PTS",APCLX)) Q:APCLX'=+APCLX  S APCLY=^XTMP("APCLDE3",APCLJ,APCLH,"PTS",APCLX) D
 .S DFN=APCLX
 .D @APCLSORT
 .I APCLSORV="" S APCLSORV="--"
 .S ^TMP($J,"PTS",APCLSORV,APCLX)=APCLY
 .Q
 S APCLSORV="" F  S APCLSORV=$O(^TMP($J,"PTS",APCLSORV)) Q:APCLSORV=""!($D(APCLQUIT))  D
 .S DFN=0 F  S DFN=$O(^TMP($J,"PTS",APCLSORV,DFN)) Q:DFN'=+DFN!($D(APCLQUIT))  D
 ..Q:$$ENDL
 ..S APCLY=^TMP($J,"PTS",APCLSORV,DFN)
 ..W !!,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?29,$P(APCLY,U,4),?33,$P(^DPT(DFN,0),U,2),?35,$$DT($P(APCLY,U,1)),?55,$E($P(APCLY,U,6),1,20)
 ..W !?3,"Type/Result: ",$P($P(APCLY,U,2),";")_"  "_$P($P(APCLY,U,2),";",2)
 ..I $P(APCLY,U,12)]"" W !?3,"Comment: ",$P(APCLY,U,12)
 ..I $P(APCLY,U,20)="PCC" S APCLV=$P(APCLY,U,14) I APCLV,$D(^AUPNVPOV("AD",APCLV)) D
 ...S APCLC=0 W !?3,"DXs: "
 ...S APCLX=0 F  S APCLX=$O(^AUPNVPOV("AD",APCLV,APCLX)) Q:APCLX'=+APCLX!($D(APCLQUIT))  D
 ....S APCLC=APCLC+1
 ....W:APCLC'=1 ! W ?8,$$VAL^XBDIQ1(9000010.07,APCLX,.01),?17,$E($$VAL^XBDIQ1(9000010.07,APCLX,.04),1,60)
 ..I $P(APCLY,U,20)="BH" S APCLV=$P(APCLY,U,15) I APCLV,$D(^AMHRPRO("AD",APCLV)) D
 ...S APCLC=0 W !?3,"DXs: "
 ...S APCLX=0 F  S APCLX=$O(^AMHRPRO("AD",APCLV,APCLX)) Q:APCLX'=+APCLX!($D(APCLQUIT))  D
 ....S APCLC=APCLC+1
 ....W:APCLC'=1 ! W ?8,$$VAL^XBDIQ1(9002011.01,APCLX,.01),?17,$E($$VAL^XBDIQ1(9002011.01,APCLX,.04),1,60)
 ..W !?3,"Primary Provider on Visit: ",?31,$P(APCLY,U,7)
 ..W !?3,"    Provider who screened: ",?31,$P(APCLY,U,5)
 Q
H ;
 S APCLSORV=$$HRN^AUPNPAT(DFN,DUZ(2))
 Q
N ;
 S APCLSORV=$P(^DPT(DFN,0),U)
 Q
P ;
 S APCLSORV=$P(APCLY,U,5)
 Q
R ;
 S APCLSORV=$P($P(APCLY,U,2),";")_"  "_$P($P(APCLY,U,2),";",2)
 Q
D ;
 S APCLSORV=$P(APCLY,U,1)
 Q
A S APCLSORV=$P(APCLY,U,4)
 Q
G ;
 S APCLSORV=$P(APCLY,U,3)
 Q
C ;
 S APCLSORV=$P(APCLY,U,6)
 Q
T ;
 S %=$$HRN^AUPNPAT(DFN,DUZ(2))
 S %=%+10000000,%=$E(%,7,8)_"-"_+$E(%,2,8)
 S APCLSORV=%
 Q
DT(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !,$$CTR("********** DEPRESSION SCREENING FOR SELECTED PATIENTS **********",80)
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains an DEPRESSION screening report based on the",!,"following criteria:"
SHOW ;
 W !!?6,"Patient must have had a screening between ",$$FMTE^XLFDT(APCLBD)," and ",$$FMTE^XLFDT(APCLED),!
 ;W:APCLTYPE="S" !!?6,"Search Template: ",$P(^DIBT(APCLSEAT,0),U),!
 W !?6,"Gender:  ",$S(APCLSEX="F":"FEMALES ONLY",APCLSEX="M":"MALES ONLY",APCLSEX="MF":"Both MALES and FEMALES",1:"")
 I $D(APCLAGET) W !?6,"Age of Patients included: ",$P(APCLAGET,"-")," to ",$P(APCLAGET,"-",2)
 I '$D(APCLAGET) W !?6,"All Ages included"
 W !?6,"Patients must have had a screening during the time period with one of ",!?6,"the following screening results:"
 W ! S X="" F  S X=$O(APCLREST(X)) Q:X'=+X  D
 .I X=1 W ?8,"NEGATIVE"
 .I X=2 W "  ","POSITIVE"
 .I X=3 W "  ","REFUSED"
 .I X=4 W "  ","UNABLE TO SCREEN"
 .I X=5 W !?8,"SCREENINGS WITH NO RECORDED RESULT"
 I $D(APCLCLNT) W !,"Screenings done in the following clinics are included:" D
 .S X=0 F  S X=$O(APCLCLNT(X)) Q:X'=+X  W !?10,$P(^DIC(40.7,X,0),U)," ("_$P(^DIC(40.7,X,0),U,2)_")"
 I '$D(APCLCLNT),APCLEXPC W !,"Screenings done in ALL clinics included"
 I 'APCLEXPC W !,"BH Clinics excluded."
 I APCLDESP]"" W !,"Only patients whose Designated Mental Health Provider",!?6,$P(^VA(200,APCLDESP,0),U)," are included"
 I APCLSSP]"" W !,"Only patients whose Designated Social Services Provider",!?6,$P(^VA(200,APCLSSP,0),U)," are included"
 I APCLCDP]"" W !,"Only patients whose Designated ASA/CD Provider",!?6,$P(^VA(200,APCLCDP,0),U)," are included"
 I APCLPPUN W !,"Only patients who had a visit on which a screeening was done",!?6,"but the primary provider on the visit was UNKNOWN are included."
 I APCLSPUN W !,"Only patients who had a visit on which a screeening was done",!?6,"but the screening provider on the visit was UNKNOWN are included."
 I '$D(APCLPROV) W !,"Visits to any Primary Provider are included"
 I '$D(APCLSPRV) W !,"Visits on which any provider did the screening are included"
 I $D(APCLPROV) W !,"Only screenings on which ",$P(^VA(200,APCLPROV,0),U)," was the primary provider",!?6,"on the visit are included"
 I $D(APCLSPRV) W !,"Only screenings on which ",$P(^VA(200,APCLSPRV,0),U)," was the primary provider",!?6,"on the visit are included"
 D PAUSE
 Q
PAUSE ; 
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) APCLQUIT=1
 W:$D(IOF) @IOF
 Q
