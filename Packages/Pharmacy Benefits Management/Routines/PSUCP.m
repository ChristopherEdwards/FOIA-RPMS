PSUCP ;BIR/TJH,PDW - PBM CONTROL POINT ;25 AUG 1998
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**4,5,8,19**;Oct 15, 1998
 ;
 ; DBIAs
 ; Reference to File #4    supported by DBIA 10090
 ; Reference to File #4.3  supported by DBIA 10091
 ; Reference to File #40.8 supported by DBIA 2438
 ; Reference to File #59.7 supported by DBIA 2854
MANUAL ; entry point for manual option
 S PSUFQ=1 ; set here for being available in PSUCP1
 ;
 I $D(^XTMP("PSUJFLG")) D  Q:Y=0  Q:Y="^"
 .W !!,"PLEASE NOTE: AN EXTRACT IS CURRENTLY RUNNING, OR"
 .W !!,"             A PREVIOUS JOB HAS NOT COMPLETED DUE TO"
 .W !,"             AN ERROR OR SYSTEM PROBLEM."
 .W !!,"             PLEASE CHECK TASKMAN TO SEE IF AN EXTRACT"
 .W !,"             IS IN PROGRESS BEFORE CONTINUING."
 .W !!,"             IF IN PROGRESS, THE JOB MAY ABORT IF YOU"
 .W !,"             RESPOND 'YES' TO CONTINUE."
 .W !
 .S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="Do you wish to continue"
 .D ^DIR
 D ^PSUCP3
 S PSUJOB=$J_"_"_$P($H,",",2)
 D EN^PSUCP1 ; prompt for report choices
 ;
 D XMY^PSUTL1 ; Setup for mail groups according to choices
 I PSUERR G EXIT
 S ^XTMP("PSUJFLG")=""    ;FLAG to avoid concurrent jobs running
 ;                         This can't be set to include $J because
 ;                         it is a flag to see if ANY job is running
 ;                         rather than a specific job. 
 S PSUAUTO=0
 S ^XTMP("PSU_"_PSUJOB,"PSUJOB")=PSUJOB
 D PUT
 S PSUTITLE="PSU PBM MANUAL"
 S PSURC="RUN^PSUCP"
 S PSURP=$S('$L(PSUIOP):"",1:"PRINT^PSUCP")
 S PSURX="EXIT^PSUCP"
 S PSUNS="PS"
 ;
 ;
 D ^PSUDBQUE
MANUALQ Q
 ;
AUTO ; set variables for Auto-report option and task to background
 D ^PSUCP3         ;Clear trash globals
 S PSUJOB=$J_"_"_$P($H,",",2)
 S ^XTMP("PSU_"_PSUJOB,"PSUFLAG1")=""   ;flag for mail patient summary reports
 S ^XTMP("PSU_"_PSUJOB,"PSUPSUMFLAG")=1         ;Set 'auto' flag
 S ^XTMP("PSUJFLG")=""    ;FLAG to avoid concurrent jobs running
 D  ; schedule job completion check
 .S PSURC="AUTO^PSUCP2"
 .S (PSURP,PSURX,PSUIOP)=""
 .S PSUTITLE="PSU PBM JOB CHECK"
 .S PSUFQ=1
 .D NOW^%DTC S X1=%,X2=6 D C^%DTC S PSUDTH=X ; LIVE MODE, wait 6 days (72 hours)
 .D ^PSUDBQUE
 ;
 D NOW^%DTC S PSUMON=$S('$D(DT):X,1:DT),PSUMON=$E(PSUMON,1,5)-1 ; get previous month
 I $E(PSUMON,4,5)="00" S PSUMON=($E(PSUMON,1,3)-1)_"12" ; set to Dec. of previous year if this month is Jan.
 S ^XTMP("PSU_"_PSUJOB,"PSUMONTH")=PSUMON
 S PSUSDT=PSUMON_"01"
 S PSULY=$$LEAPYR(PSUMON)
 S X=U_$E(PSUMON,4,5)_U
 S PSUEDT=PSUMON_$S(X["02":$S(PSULY:"29",1:"28"),"^04^06^09^11^"[X:"30",1:"31")
 S PSUDUZ=$S(DUZ=0:.5,1:DUZ),PSUMASF=1,PSUSMRY=0,PSUPBMG=1
 S ^XTMP("PSU_"_PSUJOB,"PSUPDFLAG")=1   ;Flag-detailed PD won't go to user auto extract
 S X=$$VALI^PSUTL(4.3,1,217),PSUSNDR=+$$VAL^PSUTL(4,X,99)
 S PSUOPTS="1,2,3,4,5,6,7,8,9,10,11",PSUAUTO=1,PSUIOP=""
 S ^XTMP("PSU_"_PSUJOB,"PSUJOB")=PSUJOB
 D PUT
 S PSUTITLE="PSU PBM AUTO"
 S PSURC="RUN^PSUCP"
 S PSURP=""
 S PSURX="EXIT^PSUCP"
 S PSUNS="PS"
 S PSUFQ=1
 D NOW^%DTC S PSUDTH=%
 D ^PSUDBQUE
AUTOQ D EXIT Q  ; exit from AUTO
 ;
RUN ; run each selected module
 D PULL,OPTS
 K PSUMOD,PSUFDA
 I PSUAUTO S PSUFDA(59.7,"1,",90)="@" D FILE^DIE("","PSUFDA","")
 F I=1:1:$L(PSUOPTS,",") S PSUMOD($P(PSUOPTS,",",I))=""
 ;
 S PSUOPTN=""
 F  S PSUOPTN=$O(PSUMOD(PSUOPTN)) Q:PSUOPTN=""  D
 .K PSUMSGT
 .D PULL
 .I PSUAUTO S PSUPBMG=1
 .D XMY^PSUTL1
 .S PSURTN=PSUA(PSUOPTN,"R")
 .D NOW^%DTC
 .S ^XTMP("PSU_"_PSUJOB,"STATUS",PSUOPTN,"START")=%
 .D @PSURTN
 .D PULL
 .D NOW^%DTC
 .S ^XTMP("PSU_"_PSUJOB,"STATUS",PSUOPTN,"STOP")=%
 D DT^DILF("E",PSUSDT,.EXTD)
 S PSURP("START")=EXTD(0)
 D DT^DILF("E",PSUEDT,.EXTD)
 S PSURP("END")=EXTD(0)
 S PSUSUB="PSU_"_PSUJOB
 D TIMING ; send a report of how long each module took to complete
 I PSUMASF!PSUPBMG D CONFIRM  ;Confirmation message went only if data went to Master File
 I PSUAUTO D
 .D NOW^%DTC
 .S PSUFDA(59.7,"1,",90)=% K %,%H,%I,X
 .D FILE^DIE("","PSUFDA","") ; file the completion date in 59.7,90;1
 ;
 Q
 ;
PRINT ; print hard copy if requested
 Q:'$L(PSUIOP)  ; no printer selected, stop right here.
 D PULL,OPTS
 K PSUMOD
 F I=1:1:$L(PSUOPTS,",") S PSUMOD($P(PSUOPTS,",",I))=""
 S PSUOPTN=""
 F  S PSUOPTN=$O(PSUMOD(PSUOPTN)) Q:PSUOPTN=""  D
 .D PULL
 .S PSURTN=PSUA(PSUOPTN,"P")
 .D @PSURTN
PRINTQ Q
 ; ********  THE END  *********
EXIT ; exit point
 K ^XTMP("PSUJFLG")   ;Remove flag to prevent concurrent jobs
 ;D VARKILL^PSUTL
 ;D PURGE^PSUTL1
 Q
 ;
PUT ; put variables in ^XTMP so modules can retrieve them
 S PSUVARS="PSUSDT,PSUEDT,PSUMON,PSUDUZ,PSUMASF,PSUPBMG,PSUSMRY,PSUIOP,PSUSNDR,PSUOPTS,PSUAUTO"
 S PSUVSTR=""
 F I=1:1:$L(PSUVARS,",") S $P(PSUVSTR,U,I)=@$P(PSUVARS,",",I)
 ;K ^XTMP("PSU_"_PSUJOB)
 S X1=DT,X2=6 D C^%DTC
 S ^XTMP("PSU_"_PSUJOB,0)=X_U_DT_U_"Control data for PSU PBM individual modules"
 S ^XTMP("PSU_"_PSUJOB,1)=PSUVSTR
 K PSUVARS,PSUVSTR,X,X1
PUTQ Q
 ;
PULL ; pull variables from ^XTMP
 ; PSUJOB must exist and must be the job number used to store the data desired for this session.
 N I
 S PSUVARS="PSUSDT,PSUEDT,PSUMON,PSUDUZ,PSUMASF,PSUPBMG,PSUSMRY,PSUIOP,PSUSNDR,PSUOPTS,PSUAUTO"
 F I=1:1:$L(PSUVARS,",") S @$P(PSUVARS,",",I)=$P($G(^XTMP("PSU_"_PSUJOB,1)),U,I)
PULLQ Q
 ;
OPTS ; set option array
 S PSUA(1,"M")="IVs",PSUA(1,"R")="EN^PSUIV0",PSUA(1,"P")="PRINT^PSUIV0",PSUA(1,"C")="IV"
 S PSUA(2,"M")="Unit Dose",PSUA(2,"R")="EN^PSUUD0",PSUA(2,"P")="PRINT^PSUUD0",PSUA(2,"C")="UD"
 S PSUA(3,"M")="AR/WS",PSUA(3,"R")="EN^PSUAR0",PSUA(3,"P")="PRINT^PSUAR0",PSUA(3,"C")="AR"
 S PSUA(4,"M")="Prescription",PSUA(4,"R")="EN^PSUOP0",PSUA(4,"P")="PRINT^PSUOP0",PSUA(4,"C")="OP"
 S PSUA(5,"M")="Procurement",PSUA(5,"R")="EN^PSUPR0",PSUA(5,"P")="PRINT^PSUPR0",PSUA(5,"C")="PR"
 S PSUA(6,"M")="Controlled Substances",PSUA(6,"R")="EN^PSUCS0",PSUA(6,"P")="PRINT^PSUCS0",PSUA(6,"C")="CS"
 S PSUA(7,"M")="Patient Demographics",PSUA(7,"R")="EN^PSUDEM1",PSUA(7,"P")="PRINT^PSUDEM0",PSUA(7,"C")="PD"
 S PSUA(8,"M")="Outpatient Visits",PSUA(8,"R")="EN^PSUDEM2",PSUA(8,"P")="OPV^PSUDEM0",PSUA(8,"C")="OV"
 S PSUA(9,"M")="Inpatient PTF Records",PSUA(9,"R")="EN^PSUDEM7",PSUA(9,"P")="PTF^PSUDEM0",PSUA(9,"C")="PTF"
 S PSUA(10,"M")="Provider Information",PSUA(10,"R")="EN^PSUDEM4",PSUA(10,"P")="PRO^PSUDEM0",PSUA(10,"C")="PRO"
 S PSUA(11,"M")="Laboratory Results",PSUA(11,"R")="EN^PSULR0",PSUA(11,"P")="PRINT^PSULR0",PSUA(11,"C")="LR"
 S PSUA("A")=""
OPTSQ Q
 ;
CONFIRM ;Send confirmation by Division(s)
 K PSUCONF
 S PSUDIV=0,$P(PSUDASH,"-",81)=""
 D OPTS
 S PSUCONF(1)="The chart below shows the package(s) whose dispensing statistics were extracted"
 S PSUCONF(2)="by the PBM "_$S(PSUAUTO:"Automatic",1:"Manual")_" Pharmacy Statistics option."
 S PSUCONF(3)=" "
 S PSUCONF(4)="PACKAGE"_$J("# Line items",35)_$J("# MailMan msgs",19)
 S PSUCONF(5)=$E(PSUDASH,1,79)
 F  S PSUDIV=$O(^XTMP(PSUSUB,"CONFIRM",PSUDIV)) Q:PSUDIV'?1N.E  D
 .K ^XTMP(PSUSUB,"XMD")
 .M ^XTMP(PSUSUB,"XMD")=PSUCONF
 .S PSUOPT=0,PSULCT=5
 .F  S PSUOPT=$O(^XTMP(PSUSUB,"CONFIRM",PSUDIV,PSUOPT)) Q:PSUOPT'?1.N  D
 ..S PSULCT=PSULCT+1
 ..S PSUPKG=PSUA(PSUOPT,"M")
 ..S PSULIN=^XTMP(PSUSUB,"CONFIRM",PSUDIV,PSUOPT,"L")
 ..S PSUMSG=^XTMP(PSUSUB,"CONFIRM",PSUDIV,PSUOPT,"M")
 ..S ^XTMP(PSUSUB,"XMD",PSULCT)=PSUPKG_$J(PSULIN,37-$L(PSUPKG))_$J(PSUMSG,12)
 .S PSUSUBJ="PBM Stats for "
 .I PSUMASF=1 D XMD
CONFIRMQ Q
 ;
XMD ;Email
 ;
 S XMDUZ=DUZ
 ;S ^XTMP("PSU_"_PSUJOB,"PSUPBMG")=PSUPBMG
 D XMY^PSUTL1
 M XMY=PSUXMYS1
 I $G(PSUMASF)!$G(PSUPBMG) M XMY=PSUXMYH
 S X=PSUDIV,DIC=40.8,DIC(0)="XM" D ^DIC
 S X=+Y S PSUDIVNM=$$VAL^PSUTL(40.8,X,.01)
 S XMSUB=PSUSUBJ_PSURP("START")_" to "_PSURP("END")_" from "_PSUDIV_" "_PSUDIVNM
 S XMTEXT="^XTMP(PSUSUB,""XMD"","
 S XMCHAN=1
 D ^XMD
XMDQ Q
 ;
TIMING ; Timing report
 K ^XTMP(PSUSUB,"XMD")
 S $P(PSUSPACE," ",41)=""
 S PSUX=0,PSULCT=0
 F  S PSUX=$O(^XTMP(PSUSUB,"STATUS",PSUX)) Q:PSUX=""  D
 .S (X,Y)=^XTMP(PSUSUB,"STATUS",PSUX,"START") X ^DD("DD") D
 ..I $E(Y,17)=":" S PSUT1=$E(Y,1,16)
 ..I $E(Y,17)'=":" S PSUT1=$E(Y,1,17)
 .S (X1,Y)=^XTMP(PSUSUB,"STATUS",PSUX,"STOP") X ^DD("DD") D
 ..I $E(Y,17)=":" S PSUT2=$E(Y,1,16)
 ..I $E(Y,17)'=":" S PSUT2=$E(Y,1,17)
 .S Y=$E(X1_"000",9,10)-$E(X_"000",9,10)*60+$E(X1_"00000",11,12)-$E(X_"00000",11,12),X2=X,X=$P(X,".",1)'=$P(X1,".",1)
 .D ^%DTC:X S X=X*1440+Y
 .S PSULCT=PSULCT+1
 .S PSUREC=$E(PSUA(PSUX,"M")_PSUSPACE,1,20)_$J(PSUT1,20)_$J(PSUT2,20)_$J(X\60,4)_" hrs,"_$J(X#60,3)_" min"
 .S ^XTMP(PSUSUB,"XMD",PSULCT)=PSUREC
 S PSULCT=PSULCT+1
 S $P(^XTMP(PSUSUB,"XMD",PSULCT),"-",80)="" S PSULCT=PSULCT+1
 S ^XTMP(PSUSUB,"XMD",PSULCT)="" S PSULCT=PSULCT+1
 S ^XTMP(PSUSUB,"XMD",PSULCT)="**NOTE:  Timing for the Provider Information extract is not recorded when the" S PSULCT=PSULCT+1
 S ^XTMP(PSUSUB,"XMD",PSULCT)="         the IV, Unit Dose, Prescription, and Patient Demographics extracts" S PSULCT=PSULCT+1
 S ^XTMP(PSUSUB,"XMD",PSULCT)="         are run concurrently."
 S PSUDIV=PSUSNDR
 S PSUSUBJ="PBM TIMING for report "
 D XMD
TIMINGQ Q
 ;
LEAPYR(FMYR) ; Check to see if year is a leap year: 1=leap year, 0=not leap year
 N YYYY
 S YYYY=1700+$E(FMYR,1,3)
 Q (((YYYY#4=0)&(YYYY#100'=0))!((YYYY#100=0)&(YYYY#400=0)))
