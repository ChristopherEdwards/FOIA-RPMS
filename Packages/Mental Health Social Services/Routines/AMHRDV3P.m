AMHRDV3P ; IHS/CMI/LAB - list refusals ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
PRINT ;EP - called from xbdbque
 D PRINT1
 D DONE
 Q
PRINT1 ;
 S AMHRPG=0 K AMHRQUIT
 K AMHRLSTP
 I '$D(^XTMP("AMHRDV3",AMHRJ,AMHRH)) D HEADER W !!,"No data to report.",! G DONE
 D COVPAGE
 Q:$$END
 D HEADER
 S AMHRTOT=AMHRCNT
 S AMHRPTOT=$$PTOT
 W !," Total Number of Visits with Screening",?40,$J($$COM(AMHRTOT,0),8)
 W !,"     Total Number of Patients Screened",?40,$J($$COM(AMHRPTOT,0),8)
 D LIST
 Q
COM(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
END() ;
 I $Y<(IOSL-3) Q 0
 D HEADER
 I $D(AMHRQUIT) Q 1
 Q 0
ENDL() ;
 I $Y<(IOSL-8) Q 0
 D HEADER
 I $D(AMHRQUIT) Q 1
 Q 0
PTOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("AMHRDV3",AMHRJ,AMHRH,"PTS",X)) Q:X'=+X  S C=C+1
 Q C
TOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("AMHRDV3",AMHRJ,AMHRH,"VSTS",X)) Q:X'=+X  S C=C+1
 Q C
HEADER ;EP
 G:'AMHRPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHRQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S AMHRPG=AMHRPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",AMHRPG,!
 W !,$$CTR("***  IPV SCREENING VISIT LISTING FOR SELECTED PATIENTS  ***",80),!
 S X="Screening Dates: "_$$FMTE^XLFDT(AMHRBD)_" to "_$$FMTE^XLFDT(AMHRED) W $$CTR(X,80),!
 W !?35,"DATE",!,"PATIENT NAME",?22,"HRN",?29,"AGE",?35,"SCREENED",?44,"RESULT",?61,"CLINIC"
 W !,$TR($J("",80)," ","-")
 Q
DONE ;
 K ^TMP($J)
 K ^XTMP("AMHRDV3",AMHRJ,AMHRH)
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
 S AMHRPG=0 K AMHRQUIT
 S AMHRLSTP=1
 D HEADER
 K ^TMP($J)
 ;resort by sort item
 S AMHRX=0 F  S AMHRX=$O(^XTMP("AMHRDV3",AMHRJ,AMHRH,"VSTS",AMHRX)) Q:AMHRX'=+AMHRX  S AMHRY=^XTMP("AMHRDV3",AMHRJ,AMHRH,"VSTS",AMHRX) D
 .S DFN=$P(AMHRY,U,9)
 .D @AMHRSORT
 .I AMHRSORV="" S AMHRSORV="--"
 .S ^TMP($J,"VSTS",AMHRSORV,AMHRX)=AMHRY
 .Q
 S AMHRSORV="" F  S AMHRSORV=$O(^TMP($J,"VSTS",AMHRSORV)) Q:AMHRSORV=""!($D(AMHRQUIT))  D
 .S AMHRX=0 F  S AMHRX=$O(^TMP($J,"VSTS",AMHRSORV,AMHRX)) Q:AMHRX'=+AMHRX!($D(AMHRQUIT))  D
 ..Q:$$ENDL
 ..S AMHRY=^TMP($J,"VSTS",AMHRSORV,AMHRX),DFN=$P(AMHRY,U,9)
 ..W !!,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?29,$P(AMHRY,U,5),?33,$P(^DPT(DFN,0),U,2),?35,$$DT($P(AMHRY,U,7)),?44,$E($P(AMHRY,U,3),1,16),?61,$E($P(AMHRY,U,10),1,17)
 ..I $P(AMHRY,U,4)]"" W !?3,"Comment: ",$P(AMHRY,U,4)
 ..I $P(AMHRY,U,1)="EX" S AMHRV=$P(AMHRY,U,15) I $D(^AUPNVPOV("AD",AMHRV)) D
 ...S AMHRC=0 W !?3,"DXs: "
 ...S AMHRS=0 F  S AMHRS=$O(^AUPNVPOV("AD",AMHRV,AMHRS)) Q:AMHRS'=+AMHRS!($D(AMHRQUIT))  D
 ....S AMHRC=AMHRC+1
 ....W:AMHRC'=1 ! W ?8,$$VAL^XBDIQ1(9000010.07,AMHRS,.01),?17,$E($$VAL^XBDIQ1(9000010.07,AMHRS,.04),1,60)
 ..I $P(AMHRY,U,1)="BH" S AMHRV=$P(AMHRY,U,15) I $D(^AMHRPRO("AD",AMHRV)) D
 ...S AMHRC=0 W !?3,"DXs: "
 ...S AMHRS=0 F  S AMHRS=$O(^AMHRPRO("AD",AMHRV,AMHRS)) Q:AMHRS'=+AMHRS!($D(AMHRQUIT))  D
 ....S AMHRC=AMHRC+1
 ....W:AMHRC'=1 ! W ?8,$$VAL^XBDIQ1(9002011.01,AMHRS,.01),?17,$E($$VAL^XBDIQ1(9002011.01,AMHRS,.04),1,60)
 ..W !?3,"Primary Provider on Visit: ",?31,$P(AMHRY,U,2)
 ..W !?3,"     Provider who screened: ",?31,$P(AMHRY,U,16)
 Q
H ;
 S AMHRSORV=$$HRN^AUPNPAT(DFN,DUZ(2))
 Q
N ;
 S AMHRSORV=$P(^DPT(DFN,0),U)
 Q
P ;
 S AMHRSORV=$P(AMHRY,U,2)
 Q
R ;
 S AMHRSORV=$P(AMHRY,U,3)
 Q
D ;
 S AMHRSORV=$P(AMHRY,U,7)
 Q
A S AMHRSORV=$P(AMHRY,U,5)
 Q
G ;
 S AMHRSORV=$P(AMHRY,U,6)
 Q
C ;
 S AMHRSORV=$P(AMHRY,U,10)
 Q
T ;
 S %=$$HRN^AUPNPAT(DFN,DUZ(2))
 S %=%+10000000,%=$E(%,7,8)_"-"_+$E(%,2,8)
 S AMHRSORV=%
 Q
DT(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
COVPAGE ;EP
 W:$D(IOF) @IOF
 W !?20,"********** IPV/DV SCREENING FOR SELECTED PATIENTS **********"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains an IPV/DV screening report based on the",!,"following criteria:"
SHOW ;
 W !!?6,"Patient must have had a screening between ",$$FMTE^XLFDT(AMHRBD)," and ",$$FMTE^XLFDT(AMHRED),!
 ;W:AMHRTYPE="S" !!?6,"Search Template: ",$P(^DIBT(AMHRSEAT,0),U),!
 W !?6,"Gender:  ",$S(AMHRSEX="F":"FEMALES ONLY",AMHRSEX="M":"MALES ONLY",AMHRSEX="MF":"Both MALES and FEMALES",1:"")
 I $D(AMHRAGET) W !?6,"Age of Patients included: ",$P(AMHRAGET,"-")," to ",$P(AMHRAGET,"-",2)
 I '$D(AMHRAGET) W !?6,"All Ages included"
 W !?6,"Patients must have had a screening during the time period with one of ",!?6,"the following screening results:"
 W ! S X="" F  S X=$O(AMHRREST(X)) Q:X'=+X  D
 .I X=1 W ?8,"NEGATIVE"
 .I X=2 W "  ","PRESENT"
 .I X=3 W "  ","PAST"
 .I X=4 W "  ","PRESENT AND PAST"
 .I X=5 W "  ","REFUSED"
 .I X=6 W "  ","UNABLE TO SCREEN"
 .I X=7 W !?8,"SCREENINGS WITH NO RECORDED RESULT"
 I $D(AMHRCLNT) W !,"Screenings done in the following clinics are included:" D
 .S X=0 F  S X=$O(AMHRCLNT(X)) Q:X'=+X  W !?10,$P(^DIC(40.7,X,0),U)," ("_$P(^DIC(40.7,X,0),U,2)_")"
 I '$D(AMHRCLNT),AMHREXPC W !,"Screenings done in ALL clinics included"
 I 'AMHREXPC W !,"PCC Clinics excluded."
 I AMHRDESP]"" W !,"Only patients whose Designated Mental Health Provider",!?6,$P(^VA(200,AMHRDESP,0),U)," are included"
 I AMHRSSP]"" W !,"Only patients whose Designated Social Services Provider",!?6,$P(^VA(200,AMHRSSP,0),U)," are included"
 I AMHRCDP]"" W !,"Only patients whose Designated ASA/CD Provider",!?6,$P(^VA(200,AMHRCDP,0),U)," are included"
 I AMHRPPUN W !,"Only patients who had a visit on which a screeening was done",!?6,"but the primary provider on the visit was UNKNOWN are included."
 I AMHRSPUN W !,"Only patients who had a visit on which a screeening was done",!?6,"but the screening provider on the visit was UNKNOWN are included."
 I '$D(AMHRPROV) W !,"Visits to any Primary Provider are included"
 I '$D(AMHRSPRV) W !,"Visits on which any provider did the screening are included"
 I $D(AMHRPROV) W !,"Only screenings on which ",$P(^VA(200,AMHRPROV,0),U)," was the primary provider",!?6,"on the visit are included"
 I $D(AMHRSPRV) W !,"Only screenings on which ",$P(^VA(200,AMHRSPRV,0),U)," was the primary provider",!?6,"on the visit are included"
 D PAUSE
 Q
PAUSE ; 
 Q:$E(IOST)'="C"
 Q:IO'=IO(0)
 S DIR(0)="E",DIR("A")="Press return to continue or '^' to quit" D ^DIR K DIR,DA
 S:$D(DIRUT) AMHRQUIT=1
 W:$D(IOF) @IOF
 Q
