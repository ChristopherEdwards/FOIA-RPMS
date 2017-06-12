BUDCRP6N ; IHS/CMI/LAB - UDS REPORT  ;
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
K ;EP ;CRC
 S BUDDOB=$P(^DPT(DFN,0),U,3)
 S BUD50RB=($E(BUDBD,1,3)-51)_"1231"
 S BUD75RB=($E(BUDBD,1,3)-74)_"0101"
 Q:BUDDOB<BUD75RB
 Q:BUDDOB>BUD50RB
 Q:BUDMEDV<1
 Q:$$CRC(DFN,BUDED)
 S BUDCRCT=$$SCREEN(DFN,,$$VD^APCLV(BUDLASTV))
 I BUDCRCT]"" S BUDSECTK("CRC")=$G(BUDSECTK("CRC"))+1
 S BUDCRCL=""
 S BUDSECTK("PTS")=$G(BUDSECTK("PTS"))+1 D
 .I $G(BUDCRC2L) D
 ..I BUDCRCT="" D LAST S ^XTMP("BUDCRP6B",BUDJ,BUDH,"CRC2",BUDAGE,$P(^DPT(DFN,0),U),BUDCOM,DFN)=$P(BUDCRCL,U)
 .I $G(BUDCRC1L) D
 ..I BUDCRCT]"" S ^XTMP("BUDCRP6B",BUDJ,BUDH,"CRC1",BUDAGE,$P(^DPT(DFN,0),U),BUDCOM,DFN)=$P(BUDCRCT,U)
 Q
LAST ;
 NEW LAST,COLO,SIG,FOBT
 S BUDCRCL=""
 S COLO=$$COLO(DFN,$$DOB^AUPNPAT(DFN),BUDED)
 S BUDCRCL=COLO
 S SIG=$$SIG(DFN,$$DOB^AUPNPAT(DFN),BUDED)
 I $P(SIG,U,2)>$P(BUDCRCL,U,2) S BUDCRCL=SIG
 S FOBT=$$FOB(DFN,$$DOB^AUPNPAT(DFN),BUDED)
 I $P(FOBT,U,2)>$P(BUDCRCL,U,2) S BUDCRCL=FOBT
 Q
SCREEN(P,BDATE,EDATE) ;
 NEW BUDCOLO,BUDSIG,BUDFOB
 S BUDCOLO=$$COLO(DFN,,EDATE)
 I BUDCOLO]"" Q BUDCOLO
 S BUDSIG=$$SIG(DFN,,EDATE)
 I BUDSIG]"" Q BUDSIG
 S BUDFOB=$$FOB(P,,EDATE)
 I BUDFOB]"" Q BUDFOB
 Q ""
CRC(P,EDATE) ;EP
 NEW BUDG,X,E,Y,T
 K BUDG
 S Y="BUDG("
 S X=P_"^LAST DX [BGP COLORECTAL CANCER DXS;DURING "_$$FMTE^XLFDT($$DOB^AUPNPAT(P))_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I $D(BUDG(1)) Q 1
 S T=$O(^ATXAX("B","BUD COLORECTAL CANCER CPTS",0))
 I T D  I X]"" Q 1
 .S X=$$CPT^BUDCDU(P,$$DOB^AUPNPAT(P),EDATE,T,5) I X]"" Q
 .S X=$$TRAN^BUDCDU(P,$$DOB^AUPNPAT(P),EDATE,T,5)
 S BUDG=$$LASTPRC^BUDCUTL1(P,"BGP TOTAL COLECTOMY PROCS",$$DOB^AUPNPAT(P),EDATE)
 I BUDG Q 1
 S X=$$PLTAX^BUDCDU(P,"BGP COLORECTAL CANCER DXS")
 I X Q 1
 Q 0
SIG(P,BDATE,EDATE) ;EP
 NEW BUDLSIG
 S BUDLSIG=""
 I $G(BDATE)="" S BDATE=$E(EDATE,1,3)-6_$E(EDATE,4,7)
 S BUDG=$$LASTPRC^BUDCUTL1(P,"BGP SIG PROCS",BDATE,EDATE)
 I $P(BUDG,U)=1 S BUDLSIG="SIG: Proc "_$P(BUDG,U,2)_":"_$$DATE^BUDCDU($P(BUDG,U,3))_U_$P(BUDG,U,3)
 ;
 S T=$O(^ATXAX("B","BUD SIG CPTS",0))
 I T D  I X]"",$P(BUDLSIG,U,3)<$P(X,U,1) S BUDLSIG="SIG: CPT "_$P(X,U,2)_":"_$$DATE^BUDCDU($P(X,U,1))_U_$P(X,U,1)
 .S X=$$CPT^BUDCDU(P,BDATE,EDATE,T,5) I X]"" Q
 .S X=$$TRAN^BUDCDU(P,BDATE,EDATE,T,5)
 Q BUDLSIG
COLO(P,BDATE,EDATE) ;EP
 K BUDG
 S BUDLCOLO=""
 I $G(BDATE)="" S BDATE=$E(EDATE,1,3)-10_$E(EDATE,4,7)
 S BUDG=$$LASTPRC^BUDCUTL1(P,"BGP COLO PROCS",BDATE,EDATE)
 I $P(BUDG,U)=1 S BUDLCOLO="COLO: Proc "_$P(BUDG,U,2)_":"_$$DATE^BUDCDU($P(BUDG,U,3))_U_$P(BUDG,U,3)
 K BUDG
 S %=P_"^LAST DIAGNOSIS [BGP COLO DXS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(%,"BUDG(")
 I $D(BUDG(1)),$P(BUDLCOLO,U,3)<$P(BUDG(1),U,1) S BUDLCOLO="COLO: DX "_$P(BUDG(1),U,2)_":"_$$DATE^BUDCDU($P(BUDG(1),U))
 S T=$O(^ATXAX("B","BUD COLO CPTS",0))
 I T D  I X]"",$P(BUDLCOLO,U,3)<$P(X,U,1) S BUDLCOLO="COLO: CPT "_$P(X,U,2)_":"_$$DATE^BUDCDU($P(X,U,1))_U_$P(X,U,1)
 .S X=$$CPT^BUDCDU(P,BDATE,EDATE,T,5) I X]"" Q
 .S X=$$TRAN^BUDCDU(P,BDATE,EDATE,T,5)
 Q BUDLCOLO
FOB(P,BDATE,EDATE) ;EP
 I $G(BDATE)="" S BDATE=$E(EDATE,1,3)-2_$E(EDATE,4,7)
 S BUDC="",BUDLFOB=""
 S T=$O(^ATXAX("B","BGP FOBT LOINC CODES",0))
 S BUDLT=$O(^ATXLAB("B","BGP GPRA FOB TESTS",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)!(BUDC]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(BUDC]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(BUDC]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I BUDLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BUDLT,21,"B",$P(^AUPNVLAB(X,0),U))) S BUDC="FOB: Lab "_$$VAL^XBDIQ1(9000010.09,X,.01)_":"_$$DATE^BUDCDU(9999999-D)_U_(9999999-D) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S BUDC="FOB: LAB LOINC "_$$VAL^XBDIQ1(9000010.09,X,.01)_":"_$$DATE^BUDCDU(9999999-D)_U_(9999999-D) Q
 ...Q
 S BUDLFOB=BUDC
 S T=$O(^ATXAX("B","BUD FOBT CPTS",0))
 I T D  I X]"",$P(BUDLFOB,U,2)<$P(X,U,1) S BUDLFOB="FOB: CPT "_$P(X,"^",2)_":"_$$DATE^BUDCDU($P(X,U,1))_"^"_$P(X,U,1)
 .S X=$$CPT^BUDCDU(P,BDATE,EDATE,T,5) I X]"" Q
 Q BUDLFOB
 ;
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
DEPLIST1 ;EP
 D EOJ
 S BUDDEP1L=1
 D DEP1
 G EN1^BUDCRP6B
DEPLIST2 ;EP
 D EOJ
 S BUDDEP2L=1
 D DEP2
 G EN1^BUDCRP6B
DEP1 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC^BUDCRP6S,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 12+ w/Depression Scrn & if Positive a Follow-up Plan (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 12 years and older who were "
 W !,"screened for depression with a standardized tool during the report year"
 W !,"and had a follow-up plan documented if screened positive, and had at"
 W !,"least one medical visit during the report year."
 W !
 Q
DEP1L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DEP1H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP1")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D DEP1L1
 I BUDROT="P",$Y>(IOSL-3) D DEP1H Q:BUDQUIT
 I BUDROT="P" W !,"TOTAL PATIENTS WITH DEP SCRN & IF POSITIVE, FOLLOW-UP:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS WITH DEP SCRN & IF POSITIVE, FOLLOW-UP:  "_BUDTOT)
 Q
DEP1L1 ;
 I BUDROT="P",$Y>(IOSL-7) D DEP1H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP1",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D DEP1H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP1",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....S BUD1=$P(BUDALL,"|",1),BUD2=$P(BUDALL,"|",2)
 ....I BUD1]"",BUDROT="P" W ?5,$P(BUD1,U,2),": ",$P(BUD1,U,3),": ",$$FMTE^XLFDT($P(BUD1,U,1),5)
 ....I BUDROT="P" W ?35,"Follow-up: " I BUD2]"" W $P(BUD2,U,2),": ",$$FMTE^XLFDT($P(BUD2,U,1),5)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....I BUD1]"" S X=X_U_$P(BUD1,U,2)_": "_$P(BUD1,U,3)_": "_$$FMTE^XLFDT($P(BUD1,U,1),5)
 .....S X=X_U_"Follow-up: "
 .....I BUD2]"" S X=X_$P(BUD2,U,2)_": "_$$FMTE^XLFDT($P(BUD2,U,1),5)
 .....D S(X)
 Q
DEP1HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section M")
 D S("Patients Screened for Depression and Followed Up if Appropriate")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 12 years and older who were ")
 D S("screened for depression with a standardized tool during the report year and")
 D S("had a follow-up plan documented if screened positive, and had at least one")
 D S("medical visit during the report year. ")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^Depression Scrn: Date/Result^Follow-up Plan: Date")
 Q
DEP1H ;
 I BUDROT="D" D DEP1HD Q
 G:'BUDGPG DEP1H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DEP1H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section M,",80),!,$$CTR("Patients Screened for Depression and Followed Up if Appropriate",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 12 years and older who were "
 .W !,"screened for depression with a standardized tool during the report year and"
 .W !,"had a follow-up plan documented if screened positive, and had at least one"
 .W !,"medical visit during the report year. "
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Depression Scrn: Date/Result",?35,"Follow-up Plan: Date"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
DEP2 ;EP
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC^BUDCRP6S,80)
 W !,$$CTR("UDS 2015",80)
 W !!,"All Patients 12+ w/o Depression Scrn or w/o Follow-up (Table 6B)",!
 D GENI
 D PAUSE
 W !!,"This report provides a list of all patients 12 years and older not"
 W !,"screened for depression or who were screened for depression with a"
 W !,"standardized tool during the report year and does not have a follow-up"
 W !,"plan documented if screened positive, and had at least one medical visit"
 W !,"during the report year."
 W !
 Q
DEP2L ;EP
 S BUDP=0,BUDQUIT=0,BUDTOT=0
 D DEP2H Q:BUDQUIT
 I '$D(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP2")) W:BUDROT="P" !!,"No patients to report." D:BUDROT="D" S() D:BUDROT="D" S("No patients to report.") Q
 D DEP2L1
 I BUDROT="P",$Y>(IOSL-3) D DEP2H Q:BUDQUIT
 I BUDROT="P" W !,"TOTAL PATIENTS W/O DEP SCRN OR W/O FOLLOW-UP IF POSITIVE:  ",BUDTOT,!
 I BUDROT="D" D S(),S("TOTAL PATIENTS W/O DEP SCRN OR W/O FOLLOW-UP IF POSITIVE:  "_BUDTOT)
 Q
DEP2L1 ;
 I BUDROT="P",$Y>(IOSL-7) D DEP2H Q:BUDQUIT
 S BUDAGE="" F  S BUDAGE=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP2",BUDAGE)) Q:BUDAGE=""!(BUDQUIT)  D
 .S BUDNAME="" F  S BUDNAME=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME)) Q:BUDNAME=""!(BUDQUIT)  D
 ..S BUDCOM="" F  S BUDCOM=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME,BUDCOM)) Q:BUDCOM=""!(BUDQUIT)  D
 ...S DFN=0 F  S DFN=$O(^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME,BUDCOM,DFN)) Q:DFN'=+DFN!(BUDQUIT)  D
 ....I BUDROT="P",$Y>(IOSL-3) D DEP2H Q:BUDQUIT
 ....I BUDROT="P" W !,$E($P(^DPT(DFN,0),U,1),1,25),?29,$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2)),?41,$E(BUDCOM,1,25),?70,$P(^DPT(DFN,0),U,2),?75,BUDAGE,!
 ....S BUDTOT=BUDTOT+1
 ....S BUDALL=^XTMP("BUDCRP6B",BUDJ,BUDH,"DEP2",BUDAGE,BUDNAME,BUDCOM,DFN)
 ....S BUD1=$P(BUDALL,"|",1),BUD2=$P(BUDALL,"|",2)
 ....I BUD1]"" I BUDROT="P" W ?5,$P(BUD1,U,2),": ",$P(BUD1,U,3),": ",$$FMTE^XLFDT($P(BUD1,U,1),5)
 ....I BUDROT="P" W ?35,"Follow-up: " I BUD2]"" W $P(BUD2,U,2),": ",$$FMTE^XLFDT($P(BUD2,U,1),5)
 ....I BUDROT="D" S X=$P(^DPT(DFN,0),U,1)_U_$S($$HRN^AUPNPAT(DFN,BUDSITE)]"":$$HRN^AUPNPAT(DFN,BUDSITE,2),1:$$HRN^AUPNPAT(DFN,DUZ(2),2))_U_BUDCOM_U_$P(^DPT(DFN,0),U,2)_U_$$AGE^AUPNPAT(DFN,BUDCAD) D
 .....I BUD1]"" S X=X_U_$P(BUD1,U,2)_": "_$P(BUD1,U,3)_": "_$$FMTE^XLFDT($P(BUD1,U,1),5)
 .....I BUD1="" S X=X_U
 .....S X=X_U_"Follow-up: "
 .....I BUD2]"" S X=X_$P(BUD2,U,2)_": "_$$FMTE^XLFDT($P(BUD2,U,1),5)
 .....D S(X)
 Q
DEP2HD ;
 D S(),S(),S()
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6B, Section M")
 D S("Patients not Screened for Depression or w/o follow up")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S()
 D S("This report provides a list of all patients 12 years and older not")
 D S("screened for depression or who were screened for depression with a")
 D S("standardized tool during the report year and does not have a follow-up")
 D S("plan documented if screened positive, and had at least one medical visit")
 D S("during the report year.")
 D S("Age is calculated as of December 31.")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^Depression Scrn: Date/Result^Follow-up Plan: Date")
 Q
DEP2H ;
 I BUDROT="D" D DEP2HD Q
 G:'BUDGPG DEP2H1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
DEP2H1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List for Table 6B, Section M,",80),!,$$CTR("Patients not Screened for Depression or w/o Follow-up",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 D
 .W !!,"This report provides a list of all patients 12 years and older not"
 .W !,"screened for depression or who were screened for depression with a"
 .W !,"standardized tool during the report year and does not have a follow-up"
 .W !,"plan documented if screened positive, and had at least one medical visit"
 .W !,"during the report year."
 .W !,"Age is calculated as of December 31."
 W !!,"PATIENT NAME",?34,"HRN",?41,"COMMUNITY",?70,"SEX",?75,"AGE"
 W !?5,"Depression Scrn: Date/Result",?35,"Follow-up Plan: Date"
 W !,$TR($J("",80)," ","-"),!
 S BUDP=1
 Q
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
PAUSE ;
 K DIR S DIR(0)="E",DIR("A")="PRESS ENTER" KILL DA D ^DIR KILL DIR
 Q
GENI ;EP
 D GENI^BUDCRP6I
 Q
 ;
CTR(X,Y) ;
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
EOJ ;
 D EN^XBVK("BUD")
 Q
