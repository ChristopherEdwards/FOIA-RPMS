APCLAL2 ; IHS/CMI/LAB - list refusals ; 
 ;;2.0;IHS PCC SUITE;**2,4**;MAY 14, 2009
 ;
 ;
INFORM ;
 W !,$$CTR($$USR)
 W !,$$LOC()
 W !!,$$CTR("TALLY AND LISTING OF ALL VISITS W/ALCOHOL SCREENING",80)
 W !!,"This report will tally and optionally list all visits on which ALCOHOL"
 W !,"screening or a refusal was documented in the time frame specified by the"
 W !,"user.  Alcohol Screening is defined as any of the following documented:"
 W !?5,"- Alcohol Screening Exam (Exam code 35)"
 W !?5,"- Measurements: AUDC, AUDT, CRFT"
 W !?5,"- Health Factor with Alcohol/Drug Category (CAGE)"
 W !?5,"- Diagnoses V79.1, 29.1 (Behavioral Health Problem Code)"
 W !?5,"- Education Topics: AOD-SCR, CD-SCR"
 W !?5,"- CPT Codes: 99408, 99409, G0396, G0397, H0049"
 W !?5,"- refusal of exam code 35"
 W !,"This report will tally the visits by age, gender, screening result,"
 W !,"provider (either exam provider, if available, or primary provider on the "
 W !,"visit), clinic, date of screening, designated PCP, MH Provider, SS Provider"
 W !,"and A/SA Provider."
 W !,"  Notes:  "
 W !?10,"- this report will optionally, look at both PCC and the Behavioral"
 W !?10,"   Health clinics for evidence of screening/refusal"
 W !?10,"- this is a tally of visits with a screening done, if a patient had"
 W !?10,"   multiple screenings during the time period, all will be counted"
 W !
 D PAUSE^APCLVL01
 D XIT
 S APCREXC=$O(^AUTTEXAM("C",35,0))
 I 'APCREXC W !!,"Exam code 35 is missing from the EXAM table.  Cannot run report.",! H 3 D XIT Q
 ;
DATES K APCRED,APCRBD
 W !,"Please enter the date range during which the screening was done.",!,"To get all screenings ever put in a long date range like 01/01/1980",!,"to the present date.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date for Screening"
 D ^DIR Q:Y<1  S APCRBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Date for Screening"
 D ^DIR Q:Y<1  S APCRED=Y
 ;
 I APCRED<APCRBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
TALLY ;which items to tally
 K APCRTALL
 W !!,"Please select which items you wish to tally on this report:",!
 W !?3,"0)  Do not include any Tallies",?40,"6)  Date of Screening"
 W !?3,"1)  Type/Result of Screening",?40,"7)  Primary Provider on Visit"
 W !?3,"2)  Gender",?40,"8)  Designated MH Provider"
 W !?3,"3)  Age of Patient",?40,"9)  Designated SS Provider"
 W !?3,"4)  Provider who Screened",?40,"10) Designated ASA/CD Provider"
 W !?3,"5)  Clinic",?40,"11) Designated Primary Care Provider"
 K DIR S DIR(0)="L^0:11",DIR("A")="Which items should be tallied",DIR("B")="" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 I Y="" G DATES
 S APCRTALL=Y
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S APCRTALL(C)=""
EXCL ;
 S APCLEXBH=""
 W !!,"Would you like to include screenings recorded in the Behavioral Clinics"
 W !,"Mental Health (14); DEPRESSION and Substance Abuse (43), Medical Social"
 S DIR(0)="Y",DIR("A")="Services, Behavioral Health (C4) and Telebehavioral Health (C9): ",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCLEXBH=Y
 S APCREXPC=1
LIST ;
 S APCRLIST=""
 W !
 S DIR(0)="Y",DIR("A")="Would you like to include a list of visits w/screening done",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCRLIST=Y
 I 'APCRLIST G ZIS
LIST1 ;
 S APCRSORT=""
 W !
 S DIR(0)="S^H:Health Record Number;N:Patient Name;P:Provider who screened;C:Clinic;R:Result of Exam;D:Date Screened;A:Age of Patient at Screening;G:Gender of Patient;T:Terminal Digit HRN"
 S DIR("A")="How would you like the list to be sorted",DIR("B")="H"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G LIST
 S APCRSORT=Y
ZIS ;
 S XBRP="PRINT^APCLAL2P",XBRC="PROC^APCLAL2",XBRX="XIT^APCLAL2",XBNS="APC"
 D ^XBDBQUE
 D XIT
 Q
XIT ;
 D EN^XBVK("APC")
 D ^XBFMK
 Q
PROC ;
 S APCRCNT=0
 S APCRH=$H,APCRJ=$J
 K ^XTMP("APCLAL2",APCRJ,APCRH)
 D XTMP^AMHUTIL("APCLAL2","ALCOHOL SCREENING REPORT")
 ;now go through BH
 S APCRSD=$$FMADD^XLFDT(APCRBD,-1),APCRSD=APCRSD_".9999"
 I 'APCLEXBH G PCC
 F  S APCRSD=$O(^AMHREC("B",APCRSD)) Q:APCRSD'=+APCRSD!($P(APCRSD,".")>APCRED)  D
 .S APCRBIEN=0 F  S APCRBIEN=$O(^AMHREC("B",APCRSD,APCRBIEN)) Q:APCRBIEN'=+APCRBIEN  D
 ..S APCRDATE=$P(APCRSD,".")
 ..Q:'$D(^AMHREC(APCRBIEN,0))
 ..;Q:'$$ALLOWVI^AMHUTIL(DUZ,APCRBIEN)
 ..Q:APCRDATE>APCRED
 ..Q:APCRDATE<APCRBD
 ..S DFN=$P(^AMHREC(APCRBIEN,0),U,8)
 ..Q:DFN=""
 ..;Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 ..S APCSCR=$$BHSCR(APCRBIEN)
 ..Q:APCSCR=""
 ..S APCRCNT=APCRCNT+1
 ..S ^XTMP("APCLAL2",APCRJ,APCRH,"PTS",DFN,APCRDATE)=""
 ..S ^XTMP("APCLAL2",APCRJ,APCRH,"VSTS",APCRCNT)=APCSCR
PCC ;
 ;Q:'APCREXPC
 S APCRSD=$$FMADD^XLFDT(APCRBD,-1),APCRSD=APCRSD_".9999"
 F  S APCRSD=$O(^AUPNVSIT("B",APCRSD)) Q:APCRSD'=+APCRSD!($P(APCRSD,".")>APCRED)  D
 .S APCRBIEN=0 F  S APCRBIEN=$O(^AUPNVSIT("B",APCRSD,APCRBIEN)) Q:APCRBIEN'=+APCRBIEN  D
 ..S APCRDATE=$P(APCRSD,".")
 ..Q:'$D(^AUPNVSIT(APCRBIEN,0))
 ..I APCLEXBH Q:$D(^AMHREC("AVISIT",APCRBIEN))  ;visit is in BH
 ..;Q:'$$ALLOWPCC^AMHUTIL(DUZ,APCRBIEN)
 ..Q:APCRDATE>APCRED
 ..Q:APCRDATE<APCRBD
 ..S DFN=$P(^AUPNVSIT(APCRBIEN,0),U,5)
 ..Q:DFN=""
 ..I 'APCLEXBH S C=$$CLINIC^APCLV(APCRBIEN,"C") I C=14!(C=43)!(C=48)!(C="C4")!(C="C9") Q
 ..;Q:'$$ALLOWP^AMHUTIL(DUZ,DFN)
 ..S APCSCR=$$PCCSCR(APCRBIEN)
 ..Q:APCSCR=""
 ..S APCRCNT=APCRCNT+1
 ..S ^XTMP("APCLAL2",APCRJ,APCRH,"PTS",DFN,APCRDATE)=""
 ..S ^XTMP("APCLAL2",APCRJ,APCRH,"VSTS",APCRCNT)=APCSCR
 ;now go through refusals in pcc
 S APCRRIEN=0 F  S APCRRIEN=$O(^AUPNPREF(APCRRIEN)) Q:APCRRIEN'=+APCRRIEN  D
 .Q:'$D(^AUPNPREF(APCRRIEN,0))
 .Q:$P(^AUPNPREF(APCRRIEN,0),U,5)'=9999999.15
 .Q:$P(^AUPNPREF(APCRRIEN,0),U,6)'=APCREXC
 .S APCRDATE=$P(^AUPNPREF(APCRRIEN,0),U,3)
 .Q:APCRDATE=""
 .Q:APCRDATE>APCRED
 .Q:APCRDATE<APCRBD
 .S DFN=$P(^AUPNPREF(APCRRIEN,0),U,2)
 .I $D(^XTMP("APCLAL2",APCRJ,APCRH,"PTS",DFN,APCRDATE)) Q
 .S APCRCNT=APCRCNT+1
 .S ^XTMP("APCLAL2",APCRJ,APCRH,"PTS",DFN,APCRDATE)=""
 .S T=APCRDATE
 .S $P(T,U,2)="REFUSED;"_$$VAL^XBDIQ1(9000022,APCRRIEN,.07)
 .S $P(T,U,3)=$P(^DPT(DFN,0),U,2)
 .S $P(T,U,4)=$$AGE^AUPNPAT(DFN,APCRDATE)
 .S $P(T,U,5)=$$VAL^XBDIQ1(9000022,APCRRIEN,1204) I $P(T,U,5)="" S $P(T,U,5)="UNKNOWN"
 .S $P(T,U,6)="UNKNOWN"
 .S $P(T,U,7)="UNKNOWN"
 .S $P(T,U,8)=$$VAL^XBDIQ1(9002011.55,DFN,.02)
 .S $P(T,U,9)=$$VAL^XBDIQ1(9002011.55,DFN,.03)
 .S $P(T,U,10)=$$VAL^XBDIQ1(9002011.55,DFN,.04)
 .S $P(T,U,11)=$$VAL^XBDIQ1(9000001,DFN,.14)
 .S $P(T,U,15)=DFN
 .S $P(T,U,20)="PCC"
 .S ^XTMP("APCLAL2",APCRJ,APCRH,"VSTS",APCRCNT)=T
 Q
 ;
BHSCR(V) ;EP - is there a screening?  return in R
 ;get measurements AUDC, AUDT, CRFTT
 NEW R,X,M,P,E
 S R=""
 S P=$P(^AMHREC(V,0),U,8)
 S X=0 F  S X=$O(^AMHRMSR("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9002011.12,X,.01)
 .I M="AUDC"!(M="AUDT")!(M="CRFT") S R=$$BHRT^APCLAL1(V,M,$P(^AMHRMSR(X,0),U,4),P,$$VALI^XBDIQ1(9002011.12,X,1204))
 I R]"" Q R
 ;get exam
 S E=$P($G(^AMHREC(V,14)),U,3)
 I E]"" S R=$$BHRT^APCLAL1(V,"ALCOHOL SCREENING EXAM",$$VAL^XBDIQ1(9002011,V,1403),P,$P($G(^AMHREC(V,14)),U,4),$P($G(^AMHREC(V,16)),U,1))
 I R]"" Q R
 ;get health factor
 S X=0 F  S X=$O(^AMHRHF("AD",V,X)) Q:X'=+X  D
 .S M=$$VALI^XBDIQ1(9002011.08,X,.01)
 .I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U)="ALCOHOL/DRUG" S R=$$BHRT^APCLAL1(V,$$VAL^XBDIQ1(9002011.08,X,.01),"",P,$$VALI^XBDIQ1(9002011.08,X,.05),$P($G(^AMHRHF(V,811)),U,1))
 I R]"" Q R
 ;get pov
 S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9002011.01,X,.01)
 .I M="29.1"!(M="V79.1") S R=$$BHRT^APCLAL1(V,M,"",P,$$VALI^XBDIQ1(9002011.01,X,1204))
 I R]"" Q R
 ;get education
 S X=0 F  S X=$O(^AMHREDU("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9002011.05,X,.01)
 .I M="CD-SCR"!(M="AOD-SCR") S R=$$BHRT^APCLAL1(V,M,"",P,$$VALI^XBDIQ1(9002011.05,X,.04),$P($G(^AMHREDU(V,11)),U,1))
 I R]"" Q R
 ;get CPTs
 S X=0 F  S X=$O(^AMHRPROC("AD",V,X)) Q:X'=+X  D
 .S M=$$VALI^XBDIQ1(9002011.04,X,.01)
 .Q:'$$ICD^ATXCHK(M,$O(^ATXAX("B","BGP ALCOHOL SCREENING CPTS",0)),1)
 .S R=$$BHRT^APCLAL1(V,"CPT: "_$$VAL^XBDIQ1(9002011.04,X,.01),"",P,"")
 I R]"" Q R
 Q R
 ;
PCCSCR(V) ;EP - is there a screening?  return in R
 ;get measurements AUDC, AUDT, CRFTT
 NEW R,X,M,P,E
 S R=""
 S P=$P(^AUPNVSIT(V,0),U,5)
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVMSR(X,2)),U,1)  ;entered in error
 .S M=$$VAL^XBDIQ1(9000010.01,X,.01)
 .I M="AUDC"!(M="AUDT")!(M="CRFT") D
 ..S T=D_U_M_U_$$VAL^XBDIQ1(9000010.01,X,.04)_U_V_U_9000010.01_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get exam
 S X=0 F  S X=$O(^AUPNVXAM("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.13,X,.01)
 .I M="ALCOHOL SCREENING" D
 ..S T=D_U_M_U_$$VAL^XBDIQ1(9000010.13,X,.04)_U_V_U_9000010.13_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get health factor
 S X=0 F  S X=$O(^AUPNVHF("AD",V,X)) Q:X'=+X  D
 .S M=$$VALI^XBDIQ1(9000010.23,X,.01)
 .I $P(^AUTTHF($P(^AUTTHF(M,0),U,3),0),U)="ALCOHOL/DRUG" D
 ..S T=D_U_$$VAL^XBDIQ1(9000010.23,X,.01)_U_U_V_U_9000010.23_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get pov
 S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.07,X,.01)
 .I M="V79.1" D
 ..S T=D_U_M_U_U_V_U_9000010.07_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get education
 S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X  D
 .S M=$$VAL^XBDIQ1(9000010.16,X,.01)
 .I M="CD-SCR"!(M="AOD-SCR") D
 ..S T=D_U_M_U_U_V_U_9000010.16_U_X
 ..S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 ;get CPTs
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 .S M=$$VALI^XBDIQ1(9000010.18,X,.01)
 .Q:'$$ICD^ATXCHK(M,$O(^ATXAX("B","BGP ALCOHOL SCREENING CPTS",0)),1)
 .S T=D_U_"CPT: "_$$VAL^XBDIQ1(9000010.18,X,.01)_U_U_V_U_9000010.18_U_X
 .S R=$$PCCV^APCLAL1(T,P)
 I R]"" Q R
 Q R
 ;
BHPPNAME(R) ;EP primary provider internal # from 200
 NEW %,%1
 S %=0,%1="" F  S %=$O(^AMHRPROV("AD",R,%)) Q:%'=+%  I $P(^AMHRPROV(%,0),U,4)="P" S %1=$P(^AMHRPROV(%,0),U),%1=$P($G(^VA(200,%1,0)),U)
 I %1]"" Q %1
 Q "UNKNOWN"
SPRV(E) ;
 I $P($G(^AUPNVXAM(E,12)),U,4) Q $$VAL^XBDIQ1(9000010.13,E,1204)
 Q "UNKNOWN"
PRVREF(R) ;
 I $P($G(^AUPNPREF(R,12)),U,4)]"" Q $$VAL^XBDIQ1(9000022,R,1204)
 Q "UNKNOWN"
PPV(V) ;
 NEW %
 S %=$$PRIMPROV^APCLV(V)
 I %]"" Q %
 Q "UNKNOWN"
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
