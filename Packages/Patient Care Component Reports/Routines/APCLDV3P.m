APCLDV3P ; IHS/CMI/LAB - list refusals ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
PRINT ;EP - called from xbdbque
 D PRINT1
 D DONE
 Q
PRINT1 ;
 S APCLPG=0 K APCLQUIT
 K APCLLSTP
 I '$D(^XTMP("APCLDV3",APCLJ,APCLH)) D HEADER W !!,"No data to report.",! G DONE
 D COVPAGE
 Q:$$END
 D HEADER
 S APCLTOT=APCLCNT
 S APCLPTOT=$$PTOT
 W !," Total Number of Visits with Screening",?40,$J($$COM(APCLTOT,0),8)
 W !,"     Total Number of Patients Screened",?40,$J($$COM(APCLPTOT,0),8)
 I APCLTMPL="L" D LIST Q
 ;store search template
 S X=0 F  S X=$O(^XTMP("APCLDV3",APCLJ,APCLH,"PTS",X)) Q:X'=+X  S ^DIBT(APCLSTMP,1,X)=""
 W !!,"Search template ",$P(^DIBT(APCLSTMP,0),U)," has been created.",!
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
 S X=0 F  S X=$O(^XTMP("APCLDV3",APCLJ,APCLH,"PTS",X)) Q:X'=+X  S C=C+1
 Q C
TOT() ;
 NEW C,X
 S C=0
 S X=0 F  S X=$O(^XTMP("APCLDV3",APCLJ,APCLH,"VSTS",X)) Q:X'=+X  S C=C+1
 Q C
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  IPV SCREENING VISIT LISTING FOR SELECTED PATIENTS  ***",80),!
 D LOCHDR^APCLDV1P,COMMHDR^APCLDV1P
 S X="Screening Dates: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 W !?35,"DATE",!,"PATIENT NAME",?22,"HRN",?29,"AGE",?35,"SCREENED",?44,"RESULT",?61,"CLINIC"
 W !,$TR($J("",80)," ","-")
 Q
DONE ;
 K ^TMP($J)
 K ^XTMP("APCLDV3",APCLJ,APCLH)
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
 S APCLX=0 F  S APCLX=$O(^XTMP("APCLDV3",APCLJ,APCLH,"VSTS",APCLX)) Q:APCLX'=+APCLX  S APCLY=^XTMP("APCLDV3",APCLJ,APCLH,"VSTS",APCLX) D
 .S DFN=$P(APCLY,U,9)
 .D @APCLSORT
 .I APCLSORV="" S APCLSORV="--"
 .S ^TMP($J,"VSTS",APCLSORV,APCLX)=APCLY
 .Q
 S APCLSORV="" F  S APCLSORV=$O(^TMP($J,"VSTS",APCLSORV)) Q:APCLSORV=""!($D(APCLQUIT))  D
 .S APCLX=0 F  S APCLX=$O(^TMP($J,"VSTS",APCLSORV,APCLX)) Q:APCLX'=+APCLX!($D(APCLQUIT))  D
 ..Q:$$ENDL
 ..S APCLY=^TMP($J,"VSTS",APCLSORV,APCLX),DFN=$P(APCLY,U,9)
 ..W !!,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^AUPNPAT(DFN,DUZ(2)),?29,$P(APCLY,U,5),?33,$P(^DPT(DFN,0),U,2),?35,$$DT($P(APCLY,U,7)),?44,$E($P(APCLY,U,3),1,16),?61,$E($P(APCLY,U,10),1,17)
 ..I $P(APCLY,U,4)]"" W !?3,"Comment: ",$P(APCLY,U,4)
 ..I $P(APCLY,U,1)="EX" S APCLV=$P(APCLY,U,15) I $D(^AUPNVPOV("AD",APCLV)) D
 ...S APCLC=0 W !?3,"DXs: "
 ...S APCLS=0 F  S APCLS=$O(^AUPNVPOV("AD",APCLV,APCLS)) Q:APCLS'=+APCLS!($D(APCLQUIT))  D
 ....S APCLC=APCLC+1
 ....W:APCLC'=1 ! W ?8,$$VAL^XBDIQ1(9000010.07,APCLS,.01),?17,$E($$VAL^XBDIQ1(9000010.07,APCLS,.04),1,60)
 ..I $P(APCLY,U,1)="BH" S APCLV=$P(APCLY,U,15) I $D(^AMHRPRO("AD",APCLV)) D
 ...S APCLC=0 W !?3,"DXs: "
 ...S APCLS=0 F  S APCLS=$O(^AMHRPRO("AD",APCLV,APCLS)) Q:APCLS'=+APCLS!($D(APCLQUIT))  D
 ....S APCLC=APCLC+1
 ....W:APCLC'=1 ! W ?8,$$VAL^XBDIQ1(9002011.01,APCLS,.01),?17,$E($$VAL^XBDIQ1(9002011.01,APCLS,.04),1,60)
 ..I $P(APCLY,U,1)="REF" S APCLD=$P(APCLY,U,7)  D
 ...K APCLV S A="APCLV(",B=DFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(APCLD)_"-"_$$FMTE^XLFDT(APCLD),E=$$START1^APCLDF(B,A)
 ...I $D(APCLV) S APCLV1=0 F  S APCLV1=$O(APCLV(APCLV1)) Q:APCLV1'=+APCLV1  S APCLV=$P(APCLV(APCLV1),U,5) D
 ....S APCLC=0 W !?3,"DXs: "
 ....S APCLS=0 F  S APCLS=$O(^AUPNVPOV("AD",APCLV,APCLS)) Q:APCLS'=+APCLS!($D(APCLQUIT))  D
 .....S APCLC=APCLC+1
 .....W:APCLC'=1 ! W ?8,$$VAL^XBDIQ1(9000010.07,APCLS,.01),?17,$E($$VAL^XBDIQ1(9000010.07,APCLS,.04),1,60)
 ..W !?3,"Primary Provider on Visit: ",?31,$P(APCLY,U,2)
 ..W !?3,"     Primary who screened: ",?31,$P(APCLY,U,16)
 ..I 'APCLDP W ! Q
 ..K APCLZ S X=$$VAL^XBDIQ1(9002011.55,DFN,.02) I X]"" S APCLZ("MENTAL HEALTH")=X
 ..S X=$$VAL^XBDIQ1(9002011.55,DFN,.03) I X]"" S APCLZ("SOCIAL SERVICES")=X
 ..S X=$$VAL^XBDIQ1(9002011.55,DFN,.04) I X]"" S APCLZ("CHEMICAL DEPENDENCY")=X
 ..S X=$$VAL^XBDIQ1(9000001,DFN,.14) I X]"" S APCLZ("DESIGNATED PRIMARY PROVIDER")=X
 ..S APCLXX=0 F  S APCLXX=$O(^BDPRECN("C",DFN,APCLXX)) Q:APCLXX'=+APCLXX  D
 ...S A=$$VAL^XBDIQ1(90360.1,APCLXX,.01) I '$D(APCLZ(A)) S APCLZ(A)=$$VAL^XBDIQ1(90360.1,APCLXX,.03)
 ..Q:'$D(APCLZ)
 ..W !?3,"     Designated Providers: "
 ..S APCLZ="",APCLC=0 F  S APCLZ=$O(APCLZ(APCLZ)) Q:APCLZ=""!($D(APCLQUIT))  D
 ...Q:$$END
 ...S APCLC=APCLC+1
 ...W:APCLC'=1 ! W ?31,$S(APCLZ="DESIGNATED PRIMARY PROVIDER":"PRIMARY CARE",1:APCLZ),": ",APCLZ(APCLZ)
 Q
H ;
 S APCLSORV=$$HRN^AUPNPAT(DFN,DUZ(2))
 Q
N ;
 S APCLSORV=$P(^DPT(DFN,0),U)
 Q
P ;
 S APCLSORV=$P(APCLY,U,2)
 Q
R ;
 S APCLSORV=$P(APCLY,U,3)
 Q
D ;
 S APCLSORV=$P(APCLY,U,7)
 Q
A S APCLSORV=$P(APCLY,U,5)
 Q
G ;
 S APCLSORV=$P(APCLY,U,6)
 Q
C ;
 S APCLSORV=$P(APCLY,U,10)
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
 W !?20,"********** IPV/DV SCREENING FOR SELECTED PATIENTS **********"
 W !!,"REPORT REQUESTED BY: ",$P(^VA(200,DUZ,0),U)
 W !!,"The following report contains an IPV/DV screening report based on the",!,"following criteria:"
SHOW ;
 W !!?6,"Patient must have had a screening between ",$$FMTE^XLFDT(APCLBD)," and ",$$FMTE^XLFDT(APCLED),!
 ;W:APCLTYPE="S" !!?6,"Search Template: ",$P(^DIBT(APCLSEAT,0),U),!
 W !?6,"Gender:  ",$S(APCLSEX="F":"FEMALES ONLY",APCLSEX="M":"MALES ONLY",APCLSEX="MF":"Both MALES and FEMALES",1:"")
 I $D(APCLAGET) W !?6,"Age of Patients included: ",$P(APCLAGET,"-")," to ",$P(APCLAGET,"-",2)
 I '$D(APCLAGET) W !?6,"All Ages included"
 W !?6,"Patients must have had a screening during the time period with one of ",!?6,"the following screening results:"
 W ! S X="" F  S X=$O(APCLREST(X)) Q:X'=+X  D
 .I X=1 W ?8,"NEGATIVE"
 .I X=2 W "  ","PRESENT"
 .I X=3 W "  ","PAST"
 .I X=4 W "  ","PRESENT AND PAST"
 .I X=5 W "  ","REFUSED"
 .I X=6 W "  ","UNABLE TO SCREEN"
 .I X=7 W !?8,"SCREENINGS WITH NO RECORDED RESULT"
 I $D(APCLCLNT) W !,"Screenings done in the following clinics are included:" D
 .S X=0 F  S X=$O(APCLCLNT(X)) Q:X'=+X  W !?10,$P(^DIC(40.7,X,0),U)," ("_$P(^DIC(40.7,X,0),U,2)_")"
 I '$D(APCLCLNT),APCLEXBH W !,"Screenings done in ALL clinics included"
 I 'APCLEXBH W !,"Behavioral Health Clinics excluded, all other clinics included."
 I APCLDESP]"" W !,"Only patients whose Designated Primary Care Provider is ",!?6,$P(^VA(200,APCLDESP,0),U)," are included"
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
