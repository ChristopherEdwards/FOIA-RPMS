BATVSUM ; IHS/CMI/LAB - ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
EN ;
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("*** List Asthma Patient's Asthma Visit History ***"),!!
 W "This report will print the Asthma Visit History and Asthma Medication History",!,"for a patient on the Asthma Register.",!
 S DIC="^BATREG(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D EXIT Q
 S DFN=+Y
 W !
ZIS ;
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D EXIT Q
 S BATOPT=Y
 I Y="B" D BROWSE,EXIT Q
 S XBRP="PRINT^BATVSUM",XBRC="",XBRX="EXIT^BATVSUM",XBNS="BAT;DFN"
 D ^XBDBQUE
 D EXIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^BATVSUM"")"
 S XBRC="",XBRX="EXIT^BATVSUM",XBIOP=0 D ^XBDBQUE
 Q
EXIT ;
 D EN^XBVK("BAT")
 D ^XBFMK
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("BATAST",$J,"DCS",0),U)+1,$P(^TMP("BATAST",$J,"DCS",0),U)=%
 S ^TMP("BATAST",$J,"DCS",%)=X
 Q
PRINT ;
 D EP(DFN) ;gather up data
 K ^TMP("BATAST",$J)
 Q
EP(DFN) ;asthma register summary
 D EP2(DFN)
W ;write out array
 W:$D(IOF) @IOF
 K BATQUIT
 S BATX=0 F  S BATX=$O(^TMP("BATAST",$J,"DCS",BATX)) Q:BATX'=+BATX!($D(BATQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BATQUIT)
 .W !,^TMP("BATAST",$J,"DCS",BATX)
 .Q
 I $D(BATQUIT) S BATSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K BATX,BATQUIT,BATY,BATSDFN,BATSBEG,BATSTOB,BATSUPI,BATSED,BATTOBN,BATTOB
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 Q
EP2(BATSDFN) ;EP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("BATAST",$J,"DCS"
 K ^TMP("BATAST",$J,"DCS")
 S ^TMP("BATAST",$J,"DCS",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 S X="****** CONFIDENTIAL PATIENT INFORMATION -- "_$$HTE^XLFDT($H)_" ["_$P(^VA(200,DUZ,0),U,2)_" ] ******" D S(X)
 S X="ASTHMA PATIENT CARE SUMMARY                   Report Date:  "_$$FMTE^XLFDT(DT) D S(X,1)
 S X=$P(^DPT(DFN,0),U),$E(X,35)="HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2)) D S(X,1)
 S X="DOB: "_$$DOB^AUPNPAT(DFN,"E")_"  Age: "_$$AGE^AUPNPAT(DFN)_"  "_$$SEX^AUPNPAT(DFN) S Y=$$VAL^XBDIQ1(90181.01,DFN,.02) S $E(X,35)="Asthma Register Status: "_$S(Y]"":Y,1:"NOT ON REGISTER") D S(X)
 S X="Problem List: "
 S Y=$$PLAST^BATU(DFN,2) ;get problem list # and narrative
 I Y="" S Y="ASTHMA IS NOT ON THIS PATIENT'S PROBLEM LIST"
 S X=X_Y D S(X)
 S X="Primary Care Provider: "_$$VAL^XBDIQ1(9000001,DFN,.14) D S(X)
 S X="Last Asthma Visit: "_$$LASTAV^BATU(DFN,3),$E(X,35)="Calculated Next Due: "_$$FMTE^XLFDT($$NEXT^BATU(DFN)) D S(X)
 S BATPBF=$$LASTPBF^BATU(DFN)
 I BATPBF]"" S X="Personal Best Peak Flow   "_BATPBF_" liters/minute on "_$$LASTPBF^BATU(DFN,2) D S(X,1)
 I BATPBF="" S X="Personal Best Peak Flow NOT documented.  NEEDS TO BE REVIEWED" D S(X,1)
 S X="Peak Flow Zones",$E(X,20)="Green (80-100%)",$E(X,39)=$$GREEN(BATPBF) D S(X,1)
 S X="",$E(X,20)="Yellow (50-79%)",$E(X,39)=$$YELLOW(BATPBF) D S(X)
 S X="",$E(X,20)="Red (< 50%)",$E(X,39)=$$RED(BATPBF) D S(X)
 S Y=$$LASTSEV^BATU(DFN,5)
 I Y="" S X="Severity NOT DOCUMENTED, NEEDS TO BE REVIEWED" D S(X,1)
 I Y]"" S X="Severity  "_Y_"  documented on "_$$LASTSEV^BATU(DFN,3) D S(X,1)
 S Y=$$LASTAM^BATU(DFN,2) I Y]"" S X="Date of Last Asthma Management Plan:  "_Y D S(X,1)
 I Y="" S X="Date of Last Asthma Managment Plan:  NEEDS TO BE REVIEWED" D S(X,1)
 S X="Triggers (Last Documented Value)" D S(X,1)
 S X="",Y=$$LASTETS^BATU(DFN,1),$E(X,8)="ETS",$E(X,28)=$S(Y]"":Y,1:"NOT DOCUMENTED, NEEDS TO BE REVIEWED"),$E(X,35)=$S(Y]"":$$LASTETS^BATU(DFN,2),1:"") D S(X)
 S X="",Y=$$LASTPARM^BATU(DFN,1),$E(X,8)="PARTICULATE MATTER",$E(X,28)=$S(Y]"":Y,1:"NOT DOCUMENTED, NEEDS TO BE REVIEWED"),$E(X,35)=$S(Y]"":$$LASTPARM^BATU(DFN,2),1:"") D S(X)
 S X="",Y=$$LASTDM^BATU(DFN,1),$E(X,8)="DUST MITE",$E(X,28)=$S(Y]"":Y,1:"NOT DOCUMENTED, NEEDS TO BE REVIEWED"),$E(X,35)=$S(Y]"":$$LASTDM^BATU(DFN,2),1:"") D S(X)
 S Y=$$LASTHF^BATSUM(DFN,"TOBACCO"),X="Last Recorded TOBACCO Health Factor: "_$P(Y,U,2)_"   "_$$FMTE^XLFDT($P(Y,U))  D S(X,1)
 D LAST5
 S X="Last 5 Asthma Visits - LUNG FUNCTION" D S(X,1)
 S X="",$E(X,3)="DATE",$E(X,20)="FEV 1",$E(X,38)="FEF 25-75",$E(X,56)="PEF/Best PF" D S(X)
 S X="",$P(X,"-",75)="" D S(X)
 I '$D(BATL) S X="NO ASTHMA VISITS ON FILE" D S(X) G N
 S Y=0 F  S Y=$O(BATL(Y)) Q:Y'=+Y  S E=BATL(Y) D
 .S X="",$E(X,3)=$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVAST(E,0),U,3),0),U),"."),"1D"),$E(X,20)=$P(^AUPNVAST(E,0),U,5)_" % predicted"
 .S $E(X,38)=$P(^AUPNVAST(E,0),U,6)_" % predicted",$E(X,56)=$P(^AUPNVAST(E,0),U,7)_" liters/minute" D S(X)
N ;more stuff
 S Y=$$NREL^BATU(DFN,$$FMTE^XLFDT($$FMADD^XLFDT(DT,-365)),$$FMTE^XLFDT(DT))
 S X="Number of Reliever Fills in past 12 months:  "_Y D S(X,1)
 ;last 5 medication prescriptions filled
 S T=$O(^ATXAX("B","BAT ASTHMA RELIEVER MEDS",0))
 I 'T S X="BAT ASTHMA RELIEVER MEDS taxonomy missing - cannot display meds" D S(X,1) G COMN
 S T=$O(^ATXAX("B","BAT ASTHMA CONTROLLER MEDS",0))
 I 'T S X="BAT ASTHMA CONTROLLER MEDS taxonomy missing - cannot display meds" D S(X,1) G COMN
 S T=$O(^ATXAX("B","BAT ASTHMA INHALED STEROIDS",0))
 I 'T S X="BAT ASTHMA INHALED STEROIDS MEDS taxonomy missing - cannot display meds" D S(X,1) G COMN
 D LAST1YRM
 I '$D(BATL) S X="<< No Asthma Medications found. >>" D S(X,1) G COMN
 S X="",$E(X,3)="-----------ASTHMA MEDICATIONS (PRESCRIPTIONS FILLED IN PAST YEAR)----------" D S(X,1)
 S D=0 F  S D=$O(BATL(D)) Q:D'=+D  D
 .S E=0 F  S E=$O(BATL(D,E)) Q:E'=+E  S N=^AUPNVMED(E,0) D
 ..S BATD=$$FMTE^XLFDT($P(^AUPNVSIT($P(N,U,3),0),U),"2D")
 ..S BATDC=$P(N,U,8),BATDYS=$P(N,U,7),BATMFX=$S($P(N,U,4)="":+N,1:$P(N,U,4)) S:BATDYS="" BATDYS=30 S BATRX=$S($D(^PSRX("APCC",E)):$O(^(E,0)),1:0)
 ..S BATCRN=$S(+BATRX:$D(^PS(55,DFN,"P","CP",BATRX)),1:0)
 ..S BATQTY=$P(N,U,6),BATSIG=$P(N,U,5)
 ..S BATDTM=$P($P(^AUPNVSIT($P(N,U,3),0),U),"."),BATEXP=""
 ..S X=$$FMDIFF^XLFDT(DT,BATDTM)
 ..I X>BATDYS S Y=$$FMADD^XLFDT(BATDTM,BATDYS) S BATEXP="-- Ran out "_$$FMTE^XLFDT(Y,"2D")
 ..S BATMED=$S($P(N,U,4)="":$P(^PSDRUG(BATMFX,0),U),1:$P(N,U,4))
 ..I BATDC S Y=$$FMTE^XLFDT(BATDC,"2D") S BATEXP="-- D/C "_Y
 ..S BATORTS=$G(^AUPNVMED(E,11))
 ..I BATORTS["RETURNED TO STOCK",BATDC S BATEXP="--RTS "_Y
 ..D SIG S BATSIG=BATSSGY
 ..D REF I BATREF S BATSIG=BATSIG_" "_BATREF_$S(BATREF=1:" refill",1:" refills")_" left."
 ..S X=BATD,$E(X,9)=$S(BATCRN:"(C)",1:""),$E(X,13)=BATMED_" #"_BATQTY_" ("_BATDYS_" days) "_BATEXP D S(X)
 ..S X="",$E(X,14)=$E(BATSIG,1,65) D S(X)
 ..I $L(BATSIG)>65 S X="",$E(X,14)=$E(BATSIG,66,999) D S(X)
 ..Q
 .Q
E ;
 K BATEDUC D EDUC^BATSUM(DFN,.BATEDUC)
 I $D(BATEDUC) D
 .S X="Last of each ASTHMA Patient Education done:" D S(X,1)
 .S N="" F  S N=$O(BATEDUC(N)) Q:N=""  S X="     "_N,$E(X,50)=$$FMTE^XLFDT(BATEDUC(N)) D S(X)
COMN ;if comments/notes in register print them
 I $O(^BATREG(DFN,11,0)) D
 .S X="",$E(X,3)="Comments/Notes from Register:" D S(X,1)
 .K BATAR D ENP^XBDIQ1(90181.01,DFN,1100,"BATAR(","E")
 .S F=0 F  S F=$O(BATAR(1100,F)) Q:F'=+F  S X="",$E(X,5)=BATAR(1100,F) D S(X)
N1 ;
 S X="" D S(X,1)
 Q
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S BATSSGY="" F BATSP=1:1:$L(BATSIG," ") S X=$P(BATSIG," ",BATSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(BATSIG," ",BATSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S BATSSGY=BATSSGY_X_" "
 Q
 ;
REF ;DETERMINE THE NUMBER OF REFILLS REMAINING
 I 'BATRX S BATREF=0 Q
 S BATRFL=$P(^PSRX(BATRX,0),U,9) S BATREF=0 F  S BATREF=$O(^PSRX(BATRX,1,BATREF)) Q:'BATREF  S BATRFL=BATRFL-1
 S BATREF=BATRFL
 Q
GREEN(V) ;
 NEW P,P1
 S P=$J((V*.80),3,0),P1=V
 Q P_"-"_V_" liters/minute"
YELLOW(V)  ;
 NEW P,P1
 S P=$J((V*.50),3,0),P1=$J((V*.79),3,0)
 Q P_"-"_P1_" liters/minute"
RED(V) ;
 NEW P,P1
 S P=$J((V*.50),3,0)
 Q "< "_P_"   liters/minute"
 ;
LAST1YRM ;
 NEW T,T1,T2,E,D,Y,M
 S T=$O(^ATXAX("B","BAT ASTHMA RELIEVER MEDS",0))
 S T1=$O(^ATXAX("B","BAT ASTHMA INHALED STEROIDS",0))
 S T2=$O(^ATXAX("B","BAT ASTHMA CONTROLLER MEDS",0))
 K BATL
 S E=9999999-$$FMADD^XLFDT(DT,-365)
 S D=0 F  S D=$O(^AUPNVMED("AA",DFN,D)) Q:D'=+D!(D>E)  D
 .S M=0 F  S M=$O(^AUPNVMED("AA",DFN,D,M)) Q:M'=+M  S Y=$P(^AUPNVMED(M,0),U) I $D(^ATXAX(T,21,"B",Y))!($D(^ATXAX(T1,21,"B",Y)))!($D(^ATXAX(T2,21,"B",Y))) S BATL(D,M)=""
 .Q
 Q
LAST5 ;
 ;get last 2 years worth
 NEW EDATE
 S EDATE=$$FMADD^XLFDT(DT,-(365*2))
 S EDATE=9999999-EDATE
 K BATL
 NEW D,E,C S (D,C)=0 F  S D=$O(^AUPNVAST("AA",DFN,D)) Q:D'=+D!(D>EDATE)  D
 .K BATL1 S E=0 F  S E=$O(^AUPNVAST("AA",DFN,D,E)) Q:E'=+E  D
 ..S BATL1(9999999-E)=E
 .S E=0 F  S E=$O(BATL1(E)) Q:E'=+E  S BATL(E)=BATL1(E),C=C+1
 .Q
 Q
