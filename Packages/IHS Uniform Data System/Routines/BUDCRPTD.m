BUDCRPTD ; IHS/CMI/LAB - UDS REPORT PROCESSOR 05 Oct 2015 5:03 PM ; 
 ;;10.0;IHS/RPMS UNIFORM DATA SYSTEM;;FEB 04, 2016;Build 50
 ;
 ;
GETV ;EP - get all visits for this patient and tally in BUDTV
 ;^TMP($J,"VISITS") has all visits
 ;^TMP($J,"VISITSLIST") is visit list 1 in the SRD
 ;^TMP($J,"VISITS35") is used for table 3 and 5
 ;^TMP($J,"VISITS6DX") is used for table 6 dxs and includes 2 visits on same day to same provider
 K ^TMP($J)
 S BUDTV=0,BUDT35V=0,BUDT6V=0,BUDMEDV=0,BUDMEDVI="",BUDLASTV=""
 S A="^TMP($J,""VISITS"",",B=DFN_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BUDBD)_"-"_$$FMTE^XLFDT(BUDED),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"VISITS",1)) Q
 S BUDX=0 F  S BUDX=$O(^TMP($J,"VISITS",BUDX)) Q:BUDX'=+BUDX  S BUDVSIT=$P(^TMP($J,"VISITS",BUDX),U,5) D
 .Q:'$D(^AUPNVSIT(BUDVSIT,0))
 .Q:'$P(^AUPNVSIT(BUDVSIT,0),U,9)
 .Q:$P(^AUPNVSIT(BUDVSIT,0),U,11)
 .S BUDVLOC=$P(^AUPNVSIT(BUDVSIT,0),U,6)
 .Q:BUDVLOC=""
 .Q:'$D(^BUDCSITE(BUDSITE,11,BUDVLOC))  ;not valid location
 .Q:"AHSORMEI"'[$P(^AUPNVSIT(BUDVSIT,0),U,7)
 .S BUDCLINC=$$CLINIC^APCLV(BUDVSIT,"C")
 .S BUDTIEN=$O(^BUDCCNTL("B","FIRST LEVEL CLINIC EXCLUSIONS",0))
 .I BUDCLINC]"",$D(^BUDCCNTL(BUDTIEN,11,"B",BUDCLINC)) Q  ;not a clinic code we want in any table
 .;now eliminate subsequent visits to same provider on same day  = item 4 in SRD visit definition
 .S BUDVDATE=$$VD^APCLV(BUDVSIT)
 .S BUDPP=$$PRIMPROV^APCLV(BUDVSIT,"I")
 .I $P(^AUPNVSIT(BUDVSIT,0),U,7)="I" G SET  ;don't count I visits
 .I '$D(^AUPNVPOV("AD",BUDVSIT)) G SET
 .S S=0
 .I BUDPP]"" D
 ..S D=$P($G(^TMP($J,"SAMEPROV",DFN,BUDVDATE,BUDPP)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already had a visit to this provider on this date
 ..S ^TMP($J,"SAMEPROV",DFN,BUDVDATE,BUDPP)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S  ;quit if already had a visit to this provider
 .S BUDPP=$$PRIMPROV^APCLV(BUDVSIT,"D")
 .I BUDPP="" G SET
MEDC .;NOW CHECK FOR MEDICAL CARE, CAN ONLY HAVE 1 PER LOCATION OF ENCOUNTER
 .S S=0
 .S BUDTIEN=$O(^BUDCCNTL("B","MEDICAL CARE LINE NUMBERS",0))
 .;S BUDPP=$$PRIMPROV^APCLV(BUDVSIT,"D")
 .I $E($$VAL^XBDIQ1(9000010,BUDVSIT,.06),1,3)="CHS",BUDPP=15 S BUDLINE=2 G MEDC1
 .S BUDY=$O(^BUDCTFIV("C",BUDPP,0)) I BUDY="" S BUDLINE=35 G MEDC1
 .S BUDLINE=$O(^BUDCTFIV("AA",BUDPP,""))
MEDC1 .S S=0
 .I $D(^BUDCCNTL(BUDTIEN,11,"B",BUDLINE)) D
 ..S D=$P($G(^TMP($J,"MEDCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already have a medical care visit on this date
 ..S ^TMP($J,"MEDCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 ..S BUDMEDV=BUDMEDV+1,BUDMEDVI=BUDVSIT
 .Q:S  ;don't count this one, already counted one medical
DENT .;NOW CHECK FOR DENTAL CARE
 .S S=0
 .S BUDTIEN=$O(^BUDCCNTL("B","DENTAL LINE NUMBERS",0))
 .S S=0
 .I $D(^BUDCCNTL(BUDTIEN,11,"B",BUDLINE)) D
 ..S D=$P($G(^TMP($J,"DENTCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already have a DENTAL care visit on this date
 ..S ^TMP($J,"DENTCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S  ;don't count this one, already counted one DENTAL
MH .;NOW CHECK FOR MH CARE
 .S S=0
 .S BUDTIEN=$O(^BUDCCNTL("B","MENTAL HEALTH LINE NUMBERS",0))
 .S P=$$PRIMPOV^APCLV(BUDVSIT,"C")
 .I $E(P,1,3)=303!($E(P,1,3)="304")!($E(P,1,3)="305") G SUB
 .S S=0
 .I $D(^BUDCCNTL(BUDTIEN,11,"B",BUDLINE)) D
 ..S D=$P($G(^TMP($J,"MHCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already have a MH care visit on this date
 ..S ^TMP($J,"MHCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S  ;don't count this one, already counted one MH
SUB .;
 .S S=0
 .S BUDTIEN=$O(^BUDCCNTL("B","SUBSTANCE LINE NUMBERS",0))
 .S S=0
 .I $D(^BUDCCNTL(BUDTIEN,11,"B",BUDLINE)) D
 ..S D=$P($G(^TMP($J,"SUBCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already have a SUB care visit on this date
 ..S ^TMP($J,"SUBCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S  ;don't count this one, already counted one SUBSTANCE
VISION .;
 .S S=0
 .S BUDTIEN=$O(^BUDCCNTL("B","VISION LINE NUMBERS",0))
 .S S=0
 .I $D(^BUDCCNTL(BUDTIEN,11,"B",BUDLINE)) D
 ..S D=$P($G(^TMP($J,"VISIONCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already have a VISION care visit on this date
 ..S ^TMP($J,"VISIONCARE",DFN,BUDVDATE,BUDVLOC,BUDTIEN)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S  ;don't count this one, already counted one VISION
OTH .;can have only 1 in each category
 .S BUDTIEN=$O(^BUDCTFIV("B",22,0))
 .S S=0
 .I $D(^BUDCTFIV(BUDTIEN,11,"B",BUDPP)) D
 ..S D=$P($G(^TMP($J,"OTHSERV",DFN,BUDVDATE,BUDVLOC,BUDPP)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q
 ..S ^TMP($J,"OTHSERV",DFN,BUDVDATE,BUDVLOC,BUDPP)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S
ENAB .;NOW CHECK FOR ENABLING
 .S S=0
 .S BUDTIEN=$O(^BUDCCNTL("B","ENABLING LINE NUMBERS",0))
 .S S=0
 .I $D(^BUDCCNTL(BUDTIEN,11,"B",BUDLINE)) D
 ..S D=$P($G(^TMP($J,"ENABCARE",DFN,BUDVDATE,BUDVLOC,BUDPP)),U,1)
 ..I D]"",D'>$P(^AUPNVSIT(BUDVSIT,0),U) S S=1 Q  ;already have a ENABLING care visit on this date
 ..S ^TMP($J,"ENABCARE",DFN,BUDVDATE,BUDVLOC,BUDPP)=$P(^AUPNVSIT(BUDVSIT,0),U)_U_BUDVSIT
 .Q:S   ;don't count this one, already counted onE ENABLING
SET .S BUDTV=BUDTV+1
 .S ^TMP($J,"VISITSLIST",BUDVSIT)=""  ;USED IN TABLE 6A SERVICES ONLY
 .;NOW get all for table 3A, 3B, 5 AND 6 dxs, same list but include duplicates
 .I '$D(^AUPNVPOV("AD",BUDVSIT)) Q
 .;must have a primary dx other than .9999
 .S Y=$$PRIMPOV^APCLV(BUDVSIT,"C") I Y=".9999" Q
 .;the above make it a "complete" visit
 .S BUDTIEN=$O(^BUDCCNTL("B","CLINIC EXCLUSIONS",0))
 .I BUDCLINC]"",$D(^BUDCCNTL(BUDTIEN,11,"B",BUDCLINC)) Q  ;exclude these clinics
 .Q:"EI"[$P(^AUPNVSIT(BUDVSIT,0),U,7)  ;new in 07 to exclude these from tables 3,5
 .Q:BUDPP=""  ;no primary provider
 .S BUDT35V=BUDT35V+1
 .S ^TMP($J,"VISITS356A",BUDVSIT)=""
 .I $$VD^APCLV(BUDLASTV)<$$VD^APCLV(BUDVSIT) S BUDLASTV=BUDVSIT
 ;now get all mamms and paps in date range and count as orphans if at this facility and no mam on that date in pcc
 Q:BUDT35V=0  ;not a patient of interest
 ;Q:'$D(^BWP(DFN))
 S T="MAMMOGRAM SCREENING",T=$O(^BWPN("B",T,0))
 S T1="MAMMOGRAM DX BILAT",T1=$O(^BWPN("B",T1,0))
 S T2="MAMMOGRAM DX UNILAT",T2=$O(^BWPN("B",T2,0))
 I $$VERSION^XPDUTL("BW")<3  D
 .S (G,V)=0 F  S V=$O(^BWPCD("C",DFN,V)) Q:V=""  D
 ..Q:'$D(^BWPCD(BUDVSIT,0))
 ..S D=$P(^BWPCD(BUDVSIT,0),U,12)
 ..S J=$P(^BWPCD(BUDVSIT,0),U,4) I J=T!(J=T1)!(J=T2) D  Q
 ...Q:D<BUDBD
 ...Q:D>BUDED
 ...Q:$P($G(^BWPCD(BUDVSIT,"PCC")),U,1)]""  ;already in pcc
 ...S L=$P(^BWPCD(BUDVSIT,0),U,10)
 ...Q:L=""
 ...Q:'$D(^BUDCSITE(BUDSITE,11,L))  ;not valid location
 ...S ^TMP($J,"MAMMS",V)="WH "_$$VAL^XBDIQ1(9002086.1,V,.04)_U_$$FMTE^XLFDT(D)
 .Q
 S T="PAP SMEAR",T=$O(^BWPN("B",T,0))
 I $$VERSION^XPDUTL("BW")<3  D
 .S (G,BUDVSIT)=0 F  S BUDVSIT=$O(^BWPCD("C",DFN,BUDVSIT)) Q:BUDVSIT=""  D
 ..Q:'$D(^BWPCD(BUDVSIT,0))
 ..S D=$P(^BWPCD(BUDVSIT,0),U,12)
 ..S J=$P(^BWPCD(BUDVSIT,0),U,4) I J=T D  Q
 ...Q:D<BUDBD
 ...Q:D>BUDED
 ...Q:$P($G(^BWPCD(BUDVSIT,"PCC")),U,1)]""  ;already in pcc
 ...S L=$P(^BWPCD(BUDVSIT,0),U,10)
 ...Q:L=""
 ...Q:'$D(^BUDCSITE(BUDSITE,11,L))  ;not valid location
 ...S ^TMP($J,"PAPS",BUDVSIT)="WH PAP SMEAR"_U_$$FMTE^XLFDT(D)
 .Q
 Q
TZH ;EP
 Q:BUDROT="D"
 G:'BUDGPG TZH1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BUDQUIT=1 Q
TZH1 ;
 W:$D(IOF) @IOF S BUDGPG=BUDGPG+1
 W !,"***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****"
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BUDGPG,!
 W !,$$CTR("***  RPMS Uniform Data System (UDS)  ***",80)
 W !,$$CTR("Patient List: Patient by Zip Code/Insurance",80),!
 W $$CTR($P(^DIC(4,BUDSITE,0),U),80),!
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) W $$CTR(X,80),!
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") W $$CTR(X,80),!
 W $TR($J("",80)," ","-")
 I BUDP=0 W !,"List of all patients with one or more visits during the calendar year."
 I BUDP=0 W !,"Zip code is from patient registration."
 I BUDP=0 W !!,"NOTE:  Patients with a zip code included in the Other Zip Codes category"
 I BUDP=0 W !,"have their zip code value followed by a ""","*",""" (e.g. 87015*)."
 W !!,"PATIENT NAME",?24,"HRN",?36,"COMMUNITY",?50,"SEX",?55,"ZIP CODE",?65,"INS"
 W !?5,"VISIT DATE",?25,"PROV TYPE",?41,"SRV",?45,"CLINIC",?62,"LOCATION"
 S BUDP=1
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;
WDEL ;EP - write out delimited file 9d
 ;call xbgsave to create output file
 S XBGL="BUDDATA"
 L +^BUDDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 K ^TMP($J,"SUMMARYDEL")
 K ^BUDDATA ;global for saving
 S X="DATE^BILL (A/R)^TRANSACTION TYPE^CREDIT^DEBIT^PRIME BILL AMOUNT^PAYMENT^ADJUSTMENT^ADJUSTMENT CATEGORY^ADJUSTMENT TYPE^A/R ACCOUNT^PATIENT (A/R)^VISIT LOCATION^CLINIC TYPE^DOS BEGIN^BILL TYPE^PRIMARY PROVIDER^"
 S X=X_"HRN^DOB^COMMUNITY"
 S ^BUDDATA(1)=X
 S D=0,C=1 F  S D=$O(^XTMP("BUDARP9DEL",BUDJ,BUDH,D)) Q:D'=+D  D
 .S X=0 F  S X=$O(^XTMP("BUDARP9DEL",BUDJ,BUDH,D,X)) Q:X'=+X  D
 ..S C=C+1 S ^BUDDATA(C)=^XTMP("BUDARP9DEL",BUDJ,BUDH,D,X)
 S XBFLT=1,XBFN=BUDFILE_".txt",XBMED="F",XBTLE="UDS TABLE 9D DELIMITED",XBQ="N",XBF=0
 D ^XBGSAVE
 K XBFLT,XBFN,XBMED,XBTLE,XBE,XBF
 L -^BUDDATA
 K ^BUDDATA ;export global
 Q
LOTE(P,V) ;
 ;if prim lang=other than english
 ;interpreter = yes AND
 ;preferred = other than english
 NEW X,%,Y,D,L,PL,IR,RL
 S D=$$VD^APCLV(V)
 S %=0,X=0 S (Y,L,PL,IR,RL)=""
 F  S X=$O(^AUPNPAT(P,86,"B",X)) Q:X'=+X!(X>D)  S Y=0 F  S Y=$O(^AUPNPAT(P,86,"B",X,Y)) Q:Y'=+Y  S L=Y  ;get last one
 I 'L Q 0  ;no data recorded
 I $P($G(^AUPNPAT(P,86,L,0)),U,3)'="Y" Q 0  ;INTERPRETER NOT REQUIRED SO DON'T COUNT
 S PL=$P($G(^AUPNPAT(P,86,L,0)),U,1)
 I 'PL Q 0  ;NO PRIM LANG
 I $$VAL^XBDIQ1(9999999.99,PL,.01)="ENGLISH" Q 0
 S PL=$P($G(^AUPNPAT(P,86,L,0)),U,4)
 I 'PL Q 0  ;NO PREF LANG
 I $$VAL^XBDIQ1(9999999.99,PL,.04)="ENGLISH" Q 0
 Q 1
TZHD ;EP
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"    "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List: Patient by Zip Code/Insurance")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S(" ")
 D S("List of all patients with one or more visits during the calendar year.")
 D S("Zip code is from patient registration.")
 D S("NOTE:  Patients with a zip code included in the Other Zip Codes category")
 S X="have their zip code value followed by a '*' (e.g. 87015*)." D S(X)
 D S(" "),S("PATIENT NAME^HRN^COMMUNITY^SEX^ZIP CODE^INSURANCE^VISIT DATE^PROV TYPE^SRV^CLINIC^LOCATION")
 Q
S(V) ;
 S BUDDECNT=BUDDECNT+1
 S ^TMP($J,"BUDDEL",BUDDECNT)=$G(V)
 Q
SAVEDEL ;EP
 I BUDDELT="S" D SCREEN Q
 ;call xbgsave to create output file
 S XBGL="BUDDATA"
 L +^BUDDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 K ^TMP($J,"SUMMARYDEL")
 K ^BUDDATA ;global for saving
 S X=0,C=0 F  S X=$O(^TMP($J,"BUDDEL",X)) Q:X'=+X  S C=C+1 S ^BUDDATA(C)=^TMP($J,"BUDDEL",X)
 D
 .S XBFLT=1,XBFN=BUDDELF_".txt",XBMED="F",XBTLE="UDS DELIMITED OUTPUT",XBQ="N",XBF=0
 .D ^XBGSAVE
 .K XBFLT,XBFN,XBMED,XBTLE,XBE,XBF
 L -^BUDDATA
 K ^BUDDATA ;export global
 K ^TMP($J,"BUDDEL")
 Q
 ;
SCREEN ;
 S X=0 F  S X=$O(^TMP($J,"BUDDEL",X)) Q:X'=+X  W !,^TMP($J,"BUDDEL",X)
 Q
T6DH ;EP
 D S(""),S(""),S("")
 D S("***** CONFIDENTIAL PATIENT INFORMATION, COVERED BY THE PRIVACY ACT *****")
 D S($P(^VA(200,DUZ,0),U,2)_"       "_$$FMTE^XLFDT(DT))
 D S("***  RPMS Uniform Data System (UDS)  ***")
 D S("Patient List for Table 6A, By Diagnosis Category")
 D S($P(^DIC(4,BUDSITE,0),U))
 S X="Reporting Period: "_$$FMTE^XLFDT(BUDBD)_" to "_$$FMTE^XLFDT(BUDED) D S(X)
 S X="Population:  "_$S($G(BUDCEN)=1:"Indian/Alaskan Native (Classification 01)",$G(BUDCEN)=2:"Not Indian Alaskan/Native (Not Classification 01)",$G(BUDCEN)=3:"All (both Indian/Alaskan Natives and Non 01)",1:"") D S(X)
 D S(" ")
 D S("List of all patients, sorted by diagnosis and tests/screening")
 D S("categories.  Displays community, gender, age and visit data, and codes.")
 D S("* (R) - denotes the value was obtained from the Race field")
 D S("  (C) - denotes the value was obtained from the Classification/Beneficiary field")
 ;D S("Age is calculated as of June 30.")
 D S("")
 D S("PATIENT NAME^HRN^COMMUNITY^SEX^AGE^RACE*^VISIT DATE^VALUE^SRV^CLINIC^LOCATION")
 Q
