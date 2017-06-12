BXPARPPD ;IHS/OIT/FBD - PARAMETER AUDIT REPORTS - PARAMETER/PROVIDER/DATE RANGE ;
 ;;1.0;IHS EXTENSIONS TO KERNEL TOOLKIT;;Dec 19, 2013;Build 12
 ;
 ;
 ;REPORT OF PARAMETER VALUES FOR ONE OR MORE PROVIDERS OVER A USER-
 ;SPECIFIED DATE RANGE.
 ;
 ;PROVIDERS MAY BE SPECIFIED IN ONE OF TWO MANNERS:
 ; 1. MANUAL SELECTION BY USER OF ONE OR MORE PROVIDERS
 ; 2. SPECIFICATION OF AN EXISTING PROVIDER TAXONOMY
 ;
 ;REPORT WILL CONSIS OF THREE SECTIONS:
 ; 1. PARAMETER VALUES AT START OF DATE RANGE
 ; 2. PARAMETER VALUE CHANGES TRACKED THROUGH COURSE OF DATE RANGE
 ; 3. PARAMETER VALUES AT END OF DATE RANGE
 ;
EN ;EP
 NEW BXPAEXIT,BXPSEL,BXBASE,BXPYEAR,DIRUT,DUOUT,X,Y,BXPABDT,BXPAEDT,BXPASEL
 NEW BXPAPRV,ABORT,BXPABDT,BXPAEDT,BXPAITM,CT,DASH,L,NXDATE,P,PAR,PDATE,PIEN
 NEW POP,PRV,PRDSC,ZTRTN,FLAG,IEN,QFL,TYPE,BXPBASE,BXPADT
 S BXPAEXIT=0
 D  Q:BXPAEXIT
 .NEW DIR
 .W !!,"Select one of the following:",!
 .W !?10,"1  User Defined Date Range"
 .W !?10,"2  Quarter: January 1 - March 31"
 .W !?10,"3  Quarter: April 1 - June 30"
 .W !?10,"4  Quarter: July 1 - September 30"
 .W !?10,"5  Quarter: October 1 - December 31"
 .S DIR(0)="N^1:5:",DIR("A")="Select Report Period" K DA D ^DIR K DIR
 .I $D(DIRUT) S BXPAEXIT=1 Q
 .I $D(DUOUT) S BXPAEXIT=1 Q
 .S BXPSEL=Y
 I BXPSEL>1 D YR Q:BXPAEXIT
 ;
 I BXPSEL=2 S BXPABDT=$E(BXPYEAR,1,3)_"0101",BXPAEDT=$E(BXPYEAR,1,3)_"0331"
 I BXPSEL=3 S BXPABDT=$E(BXPYEAR,1,3)_"0401",BXPAEDT=$E(BXPYEAR,1,3)_"0630"
 I BXPSEL=4 S BXPABDT=$E(BXPYEAR,1,3)_"0701",BXPAEDT=$E(BXPYEAR,1,3)_"0930"
 I BXPSEL=5 S BXPABDT=$E(BXPYEAR,1,3)_"1001",BXPAEDT=$E(BXPYEAR,1,3)_"1231"
 I BXPSEL=1 D DATESEL^BXPARUTL
 ;
 D PROVSEL^BXPARUTL Q:BXPAEXIT  ;SELECT PROVIDER(S)
 D ITMSEL^BXPARUTL Q:BXPAEXIT  ;SELECT AUDIT ITEM(S)
 ;
 ;SELECT DEVICE
 S ZTRTN="TSK^BXPARPPD"
 S ZTDESC="Parameter Audit Report"
 S %ZIS="QM" D ^%ZIS Q:POP
 I '$D(IO("Q")) K ZTDESC G @ZTRTN
 S ZTIO=ION,ZTSAVE("*")=""
 D ^%ZTLOAD
 ;
TSK ;QUEUED TASK ENTRY POINT FOR REPORT
 S U="^"
 D COMPILE
 D PARS
 D CLEANUP
 Q
 ;
 ;
COMPILE ;COMPILE REPORT DATA
 NEW PTR,DATE,INST,VALUE
 K ^TMP("BXPADATA",$J)
 ; Get the priority levels of the parameter(s)
 S PAR="" F  S PAR=$O(BXPAITM(PAR)) Q:PAR=""  D PPRI(PAR)
 ;
 S PRV=""
 F  S PRV=$O(BXPAPRV(PRV)) Q:PRV=""  D
 .S BXPAUNM=BXPAPRV(PRV)
 .S PAR="" F  S PAR=$O(BXPAITM(PAR)) Q:PAR=""  D
 ..D PAR(PAR)
 Q
 ;
PAR(BXPAR) ;EP
 NEW PTR,DATE,BXUSER,PLEV,PRI,BXPSOC,INST,VALUE,BXI,BXSRC,BXOP
 S PTR=""
 F  S PTR=$O(^BXPA(9002026.01,"APAR",BXPAR,PTR)) Q:PTR=""  D
 .S BXOP=$P(^BXPA(9002026.01,PTR,0),U,4)
 .S DATE=$P(^BXPA(9002026.01,PTR,0),U,1)\1  ;AUDIT RECORD DATE/TIME
 .I DATE<BXPABDT,BXOP'="B" Q
 .I DATE<BXPABDT,BXOP="B" S DATE=BXPABDT
 .I DATE>BXPAEDT Q
 .S BXUSER=$P(^BXPA(9002026.01,PTR,0),U,6),PIEN=$P(BXUSER,";",1),PLEV=$P(BXUSER,";",2)
 .I PLEV="VA(200,",'$D(BXPAPRV(PIEN)) Q
 .I PLEV="VA(200,",PRV'=PIEN Q
 .S PRI=$P($G(BXPAITM(BXPAR,PLEV)),U,1) I PRI="" Q
 .S PRDSC=$P(BXPAITM(BXPAR,PLEV),U,2)
 .S BXPSOC=BXPAITM(BXPAR)
 .S INST=$P(^BXPA(9002026.01,PTR,0),U,7)  ;PARAMETER NAME
 .S VALUE=$P(^BXPA(9002026.01,PTR,0),U,9)  ;PARAMETER VALUE
 .I BXPAR="ORK EDITABLE BY USER" D
 ..S BXPSOC="0:NO;1:YES"
 .I BXPAR="ORQQPX COVER SHEET REMINDERS" S QFL=0 D  Q:QFL
 ..S FLAG=$E(VALUE,1,1),TYPE=$E(VALUE,2,2),IEN=$E(VALUE,3,$L(VALUE))
 ..S VALUE=FLAG,BXPSOC="L:Lock;R:Remove;N:Normal"
 ..I TYPE="C" S QFL=1 Q
 ..I TYPE="R" S INST=$P(^PXD(811.9,IEN,0),U,1)
 .I $L(VALUE)=1 D
 ..I BXPSOC="" Q
 ..F BXI=1:1:$L(BXPSOC,";") D
 ...S BXSRC=$P(BXPSOC,";",BXI)
 ...I $P(BXSRC,":",1)=VALUE S VALUE=$P(BXSRC,":",2) Q
 .S ^TMP("BXPADATA",$J,BXPAUNM,BXPAR,INST,DATE,PRI,PRDSC)=VALUE_U_PTR
 .S ^TMP("BXPADATA",$J,BXPAUNM)=PRV
 Q
 ;
PPRI(BXPAR) ;EP - Parameter Priority
 NEW BXPN,BXN,BXPRDS,BXPSOC,BXPRGL,BXPRGLRF,BXPRI
 S BXPN=$O(^XTV(8989.51,"B",BXPAR,"")) I BXPN="" Q
 S BXPSOC=$P($G(^XTV(8989.51,BXPN,1)),U,2),BXPAITM(BXPAR)=BXPSOC
 D HIST^BXPARUTL(BXPAR,.BXPADT)
 S BXN=0
 F  S BXN=$O(^XTV(8989.51,BXPN,30,BXN)) Q:'BXN  D
 .S BXPRI=$P(^XTV(8989.51,BXPN,30,BXN,0),U,1),BXPRGL=$P(^XTV(8989.51,BXPN,30,BXN,0),U,2)
 .S BXPRDS=$P($G(^XTV(8989.518,BXPRGL,0)),U,2)
 .S BXPRGLRF=$$STRIP^XLFSTR($$ROOT^DILFD(BXPRGL,""),"^")
 .S BXPAITM(BXPAR,BXPRGLRF)=BXPRI_U_BXPRDS
 Q
 ;
PARS ;
 NEW USER,PRV,RANGE,PAR,BGDT,ENDT,PRI,LEVEL,VALUE,INST,DATE,DRANGE,HPRV,HPAR
 S (P,L,ABORT,CT)=0
 S RANGE=$$FMTE^XLFDT(BXPABDT,"5Z")_" - "_$$FMTE^XLFDT(BXPAEDT,"5Z")
 U IO
 I '$D(^TMP("BXPADATA",$J)) D  Q
 .S PRV=""
 .F  S PRV=$O(BXPAPRV(PRV)) Q:PRV=""  D
 ..S HPRV=BXPAPRV(PRV),HPAR=""
 ..F  S HPAR=$O(BXPAITM(HPAR)) Q:HPAR=""  D
 ...S PAR=HPAR
 ...D HDRM
 ...W !,?10,"Not defined in audit log by this date",! S L=L+2
 S USER=""
 F  S USER=$O(^TMP("BXPADATA",$J,USER)) Q:USER=""  D  I $G(ABORT)=1 Q
 .S PRV=^TMP("BXPADATA",$J,USER)
 .S PAR=""
 .F  S PAR=$O(^TMP("BXPADATA",$J,USER,PAR)) Q:PAR=""  D  W ! S L=L+1 I $G(ABORT)=1 Q
 ..NEW HPAR,HPRV
 ..S HPAR=PAR_" Parameter Report",HPRV="For provider: "_USER
 ..D HDRM I $G(ABORT)=1 Q
 ..S INST=""
 ..F  S INST=$O(^TMP("BXPADATA",$J,USER,PAR,INST)) Q:INST=""  D  I $G(ABORT)=1 Q
 ...S DATE=""
 ...F  S DATE=$O(^TMP("BXPADATA",$J,USER,PAR,INST,DATE)) Q:(DATE="")!(DATE>BXPAEDT)!(DATE<BXPABDT)  D  I $G(ABORT)=1 Q
 ....S NXDATE=$O(^TMP("BXPADATA",$J,USER,PAR,INST,DATE))
 ....S BGDT=$S(DATE'<PBGDT:DATE,1:PBGDT)
 ....I $G(ENDT)="" S ENDT=NXDATE S:NXDATE="" ENDT=BXPAEDT
 ....; Check if provider is inactive or terminated
 ....I $P(^VA(200,PRV,0),U,7)=1 S ENDT=$P($G(^VA(200,PRV,1.1)),U,1)\1
 ....I $P(^VA(200,PRV,0),U,11)'="" S ENDT=$P(^VA(200,PRV,0),U,11)
 ....I ENDT>DT S ENDT=DT
 ....S DRANGE=$$FMTE^XLFDT(BGDT,"5Z")_" - "_$$FMTE^XLFDT(ENDT,"5Z")
 ....I ENDT<BXPABDT S DRANGE="User not active"
 ....I PAR="ORQQPX COVER SHEET REMINDERS" D  Q
 ..... S PRI=""
 ..... F  S PRI=$O(^TMP("BXPADATA",$J,USER,PAR,INST,DATE,PRI),-1) Q:PRI=""  D  I $G(ABORT)=1 Q
 ......S LEVEL=$O(^TMP("BXPADATA",$J,USER,PAR,INST,DATE,PRI,""))
 ......S VALUE=$P(^TMP("BXPADATA",$J,USER,PAR,INST,DATE,PRI,LEVEL),U,1)
 ......W !,$E(INST,1,35),?40,LEVEL,?45,DRANGE,?70,VALUE S L=L+1
 ......I L+4>IOSL D HDRM Q:$G(ABORT)=1
 ....S PRI=$O(^TMP("BXPADATA",$J,USER,PAR,INST,DATE,"")) I PRI="" Q
 ....S LEVEL=$O(^TMP("BXPADATA",$J,USER,PAR,INST,DATE,PRI,""))
 ....S VALUE=$P(^TMP("BXPADATA",$J,USER,PAR,INST,DATE,PRI,LEVEL),U,1)
 ....W !,$E(INST,1,35),?40,LEVEL,?45,DRANGE,?70,VALUE S L=L+1
 ....K BGDT,ENDT
 ....I L+4>IOSL D HDRM Q:$G(ABORT)=1
 Q
 ;
OUTPUT ;PRINT OUT REPORT
 ;N LINE,PAGE,PDATE,EFFDATE,INST,DASH,VALUE
 S PDATE=$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_(1700+$E(DT,1,3))  ;TODAY'S DATE IN A PRINTABLE FORMAT
 ;S EFFDATE=$E(BXPAEFDT,4,5)_"/"_$E(BXPAEFDT,6,7)_"/"_(1700+$E(BXPAEFDT,1,3))  ;EFFECTIVE DATE IN A PRINTABLE FORMAT
 S DASH="",$P(DASH,"-",IOM)=""  ;DASHED LINE FOR OUTPUT SEPARATOR
 S PAGE=0  ;INITIALIZE REPORT PAGE COUNTER
 S IOSL=$S(IOST["C-":IOSL-2,1:IOSL)  ;FOR TERMINAL OUTPUT, LEAVE ROOM FOR A 'PAUSE' MESSAGE AT BOTTOM OF SCREEN
 S LINE=IOSL  ;REPORT LINE COUNTER
 Q
 ;
HDRM ;EP - HEADER
 S DASH="",$P(DASH,"-",IOM)=""
 K DIR
 S DIR(0)="E"
 I $E(IOST,1,2)="C-",P D ^DIR I $G(DIRUT)=1!($G(DTOUT)=1) S ABORT=1 Q
 I $E(IOST,1,2)="C-"!P W @IOF
 S P=P+1,L=6,PDATE=$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_(1700+$E(DT,1,3))
 W !,?55,PDATE_" Page: "_P
 W !,?80-$L(HPAR)\2,HPAR
 W !,?80-$L(HPRV)\2,HPRV
 W !,?80-$L(RANGE)\2,RANGE
 D HIS(PAR)
 W !,DASH,!
 Q
 ;
YR ;EP
 NEW BXBASE,DIR,DIRUT,DUOUT,Y
 W !!,"Enter the Calendar Year for which report is to be run.  Use a 4 digit",!,"year, e.g. 2014."
 S BXBASE=$O(^BXPA(9002026.01,"B",""))\1,BXPBASE=$E(BXBASE,1,3)_"0000"
 S DIR(0)="D^::EP"
 S DIR("A")="Select Year"
 S DIR("?")="This report is compiled for a period.  Enter a valid year."
 D ^DIR K DIR
 I $D(DIRUT) S BXPAEXIT=1 Q
 I $D(DUOUT) S BXPAEXIT=1 Q
 I $E(Y,4,7)'="0000" W !!,"Please enter a year only!",! G YR
 S BXPYEAR=Y
 I $E(BXPYEAR,1,3)<$E(BXPBASE,1,3) W !,"Year cannot be before Baseline date year." G YR
 Q
 ;
LINEOUT ;OUTPUT A SINGLE LINE OF THE REPORT
 S LINE=LINE+1
 I LINE>IOSL D  ;
 .I (IOST["C-"),+PAGE D  ;EXECUTE PAUSE MESSAGE WHEN BOTTOM OF SCREEN IS REACHED
 ..K DIR
 ..S DIR(0)="E"  ;END-OF-PAGE
 ..D ^DIR
 .D HEADER
 W $E(INST,1,38),?41,VALUE,!
 Q
 ;
 ;
HEADER ;PRINT HEADER FOR USER REPORT
 I +PAGE!(IOST["C-") W @IOF  ;SKIP FORM FEED ON FIRST PAGE, IF OUTPUT DEVICE NOT A CRT
 S PAGE=PAGE+1
 W "PARAMETER SETTINGS FOR",?24,BXPAUNM,?69,PDATE,!
 W ?6,"IN EFFECT ON DATE",?24,EFFDATE,?71,"PAGE ",PAGE,!
 W !,?5,"PARAMETER",?41,"VALUE",!
 W DASH,!
 S LINE=6
 Q
 ;
 ;
CLEANUP ;CLEAN PARTITION BEFORE EXITING PROCESS
 K BXPAEFDT,BXPAUSER,BXPAUNM,BXPAENT,BXPADATA,DIR
 K ^TMP("BXPADATA",$J)
 D ^%ZISC
 Q
 ;
HIS(PAR) ;EP
 NEW PDATE,PSTAT,CT,BHDRM
 K BGDT,ENDT,PBGDT
 S (PDATE,PBGDT)=BXPABDT,CT=0
 F  S PDATE=$O(BXPADT(PAR,PDATE)) Q:PDATE=""!(PDATE>BXPAEDT)  D
 .I CT=0 S BHDRM="*Auditing for this parameter was "
 .S PSTAT=$O(BXPADT(PAR,PDATE,""),-1),CT=CT+1
 .S BHDRM=BHDRM_PSTAT_" on "_$$FMTE^XLFDT(PDATE,"5Z")
 .I $O(BXPADT(PAR,PDATE))'="" S BHDRM=BHDRM_" and "
 .I PSTAT="DISABLED" S ENDT=PDATE
 .I PSTAT="ENABLED" S PBGDT=PDATE
 I $G(BHDRM)'="" W "*",!,?80-$L(BHDRM)\2,BHDRM
 Q