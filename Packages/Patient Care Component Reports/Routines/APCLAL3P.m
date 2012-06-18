APCLAL3P ; IHS/CMI/LAB - list refusals ; 10 Dec 2009  3:10 PM
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ;
PRINT ;EP - called from xbdbque
 D PRINT1
 D DONE
 Q
PRINT1 ;
 S APCRPG=0 K APCRQUIT
 K APCRLSTP
 I '$D(^XTMP("APCLAL3",APCRJ,APCRH)) D HEADER W !!,"No data to report.",! G DONE
 D COVPAGE
 Q:$$END
 D HEADER
 S APCRTOT=APCRCNT
 S APCRPTOT=$$PTOT
 W !," Total Number of Visits with Screening",?40,$J($$COM(APCRTOT,0),8)
 W !,"     Total Number of Patients Screened",?40,$J($$COM(APCRPTOT,0),8)
 D LIST
 Q
COM(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
END() ;
 I $Y<(IOSL-3) Q 0
 D HEADER
 I $D(APCRQUIT) Q 1
 Q 0
ENDL() ;
 I $Y<(IOSL-8) Q 0
 D HEADER
 I $D(APCRQUIT) Q 1
 Q 0
PTOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("APCLAL3",APCRJ,APCRH,"PTS",X)) Q:X'=+X  S C=C+1
 Q C
TOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("APCLAL3",APCRJ,APCRH,"VSTS",X)) Q:X'=+X  S C=C+1
 Q C
HEADER ;EP
 G:'APCRPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCRQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCRPG=APCRPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCRPG,!
 W !,$$CTR("***  ALCOHOL SCREENING VISIT LISTING FOR SELECTED PATIENTS  ***",80),!
 S X="Screening Dates: "_$$FMTE^XLFDT(APCRBD)_" to "_$$FMTE^XLFDT(APCRED) W $$CTR(X,80),!
 W !?35,"DATE",!,"PATIENT NAME",?22,"HRN",?29,"AGE",?35,"SCREENED",?55,"CLINIC"
 W !,$TR($J("",80)," ","-")
 Q
DONE ;
 K ^TMP($J)
 K ^XTMP("APCLAL3",APCRJ,APCRH)
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
 S APCRPG=0 K APCRQUIT
 S APCRLSTP=1
 D HEADER
 K ^TMP($J)
 ;resort by sort item
 S APCRX=0 F  S APCRX=$O(^XTMP("APCLAL3",APCRJ,APCRH,"PTS",APCRX)) Q:APCRX'=+APCRX  S APCRY=^XTMP("APCLAL3",APCRJ,APCRH,"PTS",APCRX) D
 .S DFN=APCRX
 .D @APCRSORT
 .I APCRSORV="" S APCRSORV="--"
 .S ^TMP($J,"PTS",APCRSORV,APCRX)=APCRY
 .Q
 S APCRSORV="" F  S APCRSORV=$O(^TMP($J,"PTS",APCRSORV)) Q:APCRSORV=""!($D(APCRQUIT))  D
 .S DFN=0 F  S DFN=$O(^TMP($J,"PTS",APCRSORV,DFN)) Q:DFN'=+DFN!($D(APCRQUIT))  D
 ..Q:$$ENDL
 ..S APCRY=^TMP($J,"PTS",APCRSORV,DFN)
 ..W !!,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?29,$P(APCRY,U,4),?33,$P(^DPT(DFN,0),U,2),?35,$$DT($P(APCRY,U,1)),?55,$E($P(APCRY,U,6),1,20)
 ..W !?3,"Type/Result: ",$P($P(APCRY,U,2),";")_"  "_$P($P(APCRY,U,2),";",2)
 ..I $P(APCRY,U,12)]"" W !?3,"Comment: ",$P(APCRY,U,12)
 ..I $P(APCRY,U,20)="PCC" S APCRV=$P(APCRY,U,14) I APCRV,$D(^AUPNVPOV("AD",APCRV)) D
 ...S APCRC=0 W !?3,"DXs: "
 ...S APCRX=0 F  S APCRX=$O(^AUPNVPOV("AD",APCRV,APCRX)) Q:APCRX'=+APCRX!($D(APCRQUIT))  D
 ....S APCRC=APCRC+1
 ....W:APCRC'=1 ! W ?8,$$VAL^XBDIQ1(9000010.07,APCRX,.01),?17,$E($$VAL^XBDIQ1(9000010.07,APCRX,.04),1,60)
 ..I $P(APCRY,U,20)="BH" S APCRV=$P(APCRY,U,15) I APCRV,$D(^AMHRPRO("AD",APCRV)) D
 ...S APCRC=0 W !?3,"DXs: "
 ...S APCRX=0 F  S APCRX=$O(^AMHRPRO("AD",APCRV,APCRX)) Q:APCRX'=+APCRX!($D(APCRQUIT))  D
 ....S APCRC=APCRC+1
 ....W:APCRC'=1 ! W ?8,$$VAL^XBDIQ1(9002011.01,APCRX,.01),?17,$E($$VAL^XBDIQ1(9002011.01,APCRX,.04),1,60)
 ..W !?3,"Primary Provider on Visit: ",?31,$P(APCRY,U,7)
 ..W !?3,"    Provider who screened: ",?31,$P(APCRY,U,5)
 Q
H ;
 S APCRSORV=$$HRN^AUPNPAT(DFN,DUZ(2))
 Q
N ;
 S APCRSORV=$P(^DPT(DFN,0),U)
 Q
P ;
 S APCRSORV=$P(APCLY,U,5)
 Q
R ;
 S APCRSORV=$P($P(APCLY,U,2),";")_"  "_$P($P(APCLY,U,2),";",2)
 Q
D ;
 S APCRSORV=$P(APCLY,U,1)
 Q
A S APCRSORV=$P(APCLY,U,4)
 Q
G ;
 S APCRSORV=$P(APCLY,U,3)
 Q
C ;
 S APCRSORV=$P(APCLY,U,6)
 Q
T ;
 S %=$$HRN^AUPNPAT(DFN,DUZ(2))
 S %=%+10000000,%=$E(%,7,8)_"-"_+$E(%,2,8)
 S APCRSORV=%
 Q
DT(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !,$$CTR("********** ALCOHOL SCREENING FOR SELECTED PATIENTS **********",80)
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains an ALCOHOL screening report based on the",!,"following criteria:"
SHOW ;
 W !!?6,"Patient must have had a screening between ",$$FMTE^XLFDT(APCRBD)," and ",$$FMTE^XLFDT(APCRED),!
 ;W:APCRTYPE="S" !!?6,"Search Template: ",$P(^DIBT(APCRSEAT,0),U),!
 W !?6,"Gender:  ",$S(APCRSEX="F":"FEMALES ONLY",APCRSEX="M":"MALES ONLY",APCRSEX="MF":"Both MALES and FEMALES",1:"")
 I $D(APCRAGET) W !?6,"Age of Patients included: ",$P(APCRAGET,"-")," to ",$P(APCRAGET,"-",2)
 I '$D(APCRAGET) W !?6,"All Ages included"
 W !?6,"Patients must have had a screening during the time period with one of ",!?6,"the following screening results:"
 W ! S X="" F  S X=$O(APCRREST(X)) Q:X'=+X  D
 .I X=1 W ?8,"NEGATIVE"
 .I X=2 W "  ","POSITIVE"
 .I X=3 W "  ","REFUSED"
 .I X=4 W "  ","UNABLE TO SCREEN"
 .I X=5 W !?8,"SCREENINGS WITH NO RECORDED RESULT"
 I $D(APCRCLNT) W !,"Screenings done in the following clinics are included:" D
 .S X=0 F  S X=$O(APCRCLNT(X)) Q:X'=+X  W !?10,$P(^DIC(40.7,X,0),U)," ("_$P(^DIC(40.7,X,0),U,2)_")"
 I '$D(APCRCLNT),APCLEXBH W !,"Screenings done in ALL clinics included"
 I 'APCLEXBH W !,"Behavioral Health Clinics excluded."
 I APCRDESP]"" W !,"Only patients whose Designated Mental Health Provider",!?6,$P(^VA(200,APCRDESP,0),U)," are included"
 I APCRSSP]"" W !,"Only patients whose Designated Social Services Provider",!?6,$P(^VA(200,APCRSSP,0),U)," are included"
 I APCRCDP]"" W !,"Only patients whose Designated ASA/CD Provider",!?6,$P(^VA(200,APCRCDP,0),U)," are included"
 I APCRPPUN W !,"Only patients who had a visit on which a screeening was done",!?6,"but the primary provider on the visit was UNKNOWN are included."
 I APCRSPUN W !,"Only patients who had a visit on which a screeening was done",!?6,"but the screening provider on the visit was UNKNOWN are included."
 I '$D(APCRPROV) W !,"Visits to any Primary Provider are included"
 I '$D(APCRSPRV) W !,"Visits on which any provider did the screening are included"
 I $D(APCRPROV) W !,"Only screenings on which ",$P(^VA(200,APCRPROV,0),U)," was the primary provider",!?6,"on the visit are included"
 I $D(APCRSPRV) W !,"Only screenings on which ",$P(^VA(200,APCRSPRV,0),U)," was the primary provider",!?6,"on the visit are included"
 D PAUSE
 Q
PAUSE ; 
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) APCRQUIT=1
 W:$D(IOF) @IOF
 Q
