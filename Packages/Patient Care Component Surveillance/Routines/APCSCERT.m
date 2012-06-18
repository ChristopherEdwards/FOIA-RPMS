APCSCERT ; IHS/CMI/LAB - APCS Certification Export ; 
 ;;2.0;IHS PCC SUITE;**6**;MAY 14, 2009;Build 11
 ;
 ;
START ;
 ;This option will create an HL7 o output file of all visits in a date range that have a certain lab test.
 ;
 ;
 D EXIT
 ;
INFORM ;inform user
 W:$D(IOF) @IOF
 W !!,$$CJ^XLFSTR("EPI PROGRAM HL7 LAB EXPORT",80)
 W !!,"This option is used to create a file of HL7 messages.  These messages will"
 W !,"be sent to the IHS Certification program.  A message will be sent for every visit"
 W !,"on which a certain lab test was done.  The user will define the date range"
 W !,"of visits to export."
 W !,"This HL7 export file will be automatically ftp'ed to the EPI program.",!!
DATES ;set date range to T-91 to T-1
 S (APCSSD,APCSED)=""
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning Visit Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G EXIT
 S APCSBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCSBD_":DT:EP",DIR("A")="Enter Ending Visit Date: " S Y=APCSBD D DD^%DT S Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCSED=Y
 S X1=APCSBD,X2=-1 D C^%DTC S APCSSD=X_".9999"
 ;
 W !!,"The date range for this export is: ",$$FMTE^XLFDT(APCSBD)," to ",$$FMTE^XLFDT(APCSED),".",!
LABTYPE ;
 S APCSLTYP=""
 S DIR(0)="S^A:Rapid Test for Influenza A & B;B:Chlamydia Tests;C:Both A & B;D:Any Lab Test or Set of (Taxonomy) Lab Tests",DIR("A")="Which Lab Tests should Trigger an HL7 message to be generated"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DATES
 S APCSLTYP=Y
 S APCLQ=""
 I APCSLTYP="A"!(APCSLTYP="C") D A G:APCLQ LABTYPE
 I APCSLTYP="B"!(APCSLTYP="C") D B G:APCLQ LABTYPE
 I APCSLTYP="D" D D G:APCLQ LABTYPE
CONTINUE ;
 W !!
 S DIR(0)="Y",DIR("A")="Do you wish to continue and generate this export file",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
ZIS ;called xbdbque to see if they want to queue or not
DEMO ;
 D DEMO^APCLUTL(.APCLDEMO)
 I $G(APCLDEMO) G LABTYPE
 S XBRC="PROC^APCSCERT",XBRP="",XBNS="APCS",XBRX="EXIT^APCSCERT"
 D ^XBDBQUE
 D EXIT
 Q
A ;
 S APCSALBT=$O(^ATXLAB("B","SURVEILLANCE RAPID FLU TESTS",0))
 I 'APCSALBT W !!,"The SURVEILLANCE RAPID FLU TESTS lab taxonomy is missing.  Cannot continue." S APCLQ=1 Q
 S APCSACTT=$O(^ATXAX("B","SURVEILLANCE RAPID FLU CPT",0)) I 'APCSACTT W !!,"The SURVEILLANCE RAPID FLU CPT taxonomy is missing.  Cannot continue." S APCLQ=1 Q
 S APCSALOT=$O(^ATXAX("B","SURVEILLANCE RAPID FLU LOINC",0))
 I 'APCSALOT W !!,"The SURVEILLANCE RAPID FLU LOINC taxonomy is missing.  Cannot continue." S APCLQ=1 Q
 I '$O(^ATXLAB(APCSALBT,21,0)) W !!,"The SURVEILLANCE RAPID FLU TESTS site populated LAB taxonomy has no entries." S APCLQ=1 Q
 Q
B ;
 S APCSBLBT=$O(^ATXLAB("B","BGP CHLAMYDIA TESTS TAX",0))
 I 'APCSBLBT W !!,"The BGP CHLAMYDIA TESTS TAX lab taxonomy is missing.  Cannot continue." S APCLQ=1 Q
 S APCSBCTT=$O(^ATXAX("B","BGP CHLAMYDIA CPTS",0)) I 'APCSBCTT W !!,"The CHLAMYDIA CPT taxonomy is missing.  Cannot continue." S APCLQ=1 Q
 S APCSBLOT=$O(^ATXAX("B","BGP CHLAMYDIA LOINC CODES",0))
 I 'APCSBLOT W !!,"The BGP CHLAMYDIA LOINC CODES taxonomy is missing.  Cannot continue." S APCLQ=1 Q
 I '$O(^ATXLAB(APCSBLBT,21,0)) W !!,"The BGP CHLAMYDIA TESTS TAX site populated LAB taxonomy has no entries." S APCLQ=1 Q
 Q
LABTAX ;
 S DIC="^ATXLAB(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 Q
 S X=0 F  S X=$O(^ATXLAB(+Y,21,X)) Q:X'=+X  S L=$P(^ATXLAB(+Y,21,X,0),U,1) I $D(^LAB(60,L,0)) S APCSLABS(L)=""
 Q
INDLAB ;
 S DIC=60,DIC(0)="AEMQ" D ^DIC
 I Y=-1 Q
 S APCSLABS(+Y)=""
 G INDLAB
D ;taxonomy or selected
 K APCSLABS
 S APCSLABS=""
 S DIR(0)="S^I:Select Lab Tests Individually by Name;T:Use a Lab Taxonomy",DIR("A")="How do you want to select Lab Tests for Export",DIR("B")="I" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S APCLQ=1 Q
 S APCSLABS=Y
 I APCSLABS="T" D LABTAX
 I APCSLABS="I" D INDLAB
 I '$O(APCSLABS(0)) S APCLQ=1 K APCSLABS W !!,"no lab tests selected." Q
 W !!,"The following labs and values will be exported:"
 S X=0 F  S X=$O(APCSLABS(X)) Q:X'=+X  W !?5,$P(^LAB(60,X,0),U,1)
 W !
 Q
PROC ;EP - called from xbdbque
 W:'$D(ZTQUEUED) !,"Processing..."
 K ^APCSDATA($J)
 S APCSVTOT=0
 F  S APCSSD=$O(^AUPNVSIT("B",APCSSD)) Q:APCSSD'=+APCSSD!($P(APCSSD,".")>APCSED)  D
 .S APCSV=0 F  S APCSV=$O(^AUPNVSIT("B",APCSSD,APCSV)) Q:APCSV'=+APCSV  D
 ..Q:'$D(^AUPNVSIT(APCSV,0))  ;no zero node
 ..Q:$P(^AUPNVSIT(APCSV,0),U,11)  ;deleted visit
 ..S DFN=$P(^AUPNVSIT(APCSV,0),U,5)
 ..Q:DFN=""
 ..Q:'$D(^DPT(DFN,0))
 ..Q:$P(^DPT(DFN,0),U)["DEMO,PATIENT"
 ..Q:$$DEMO^APCLUTL(DFN)
 ..;check for tests
 ..S APCSGOT="" K APCSLABT
 ..D LAB
 ..I APCSGOT D CERT^APCSHLOC(.APCSLAB,"CERT")
 ..S APCSVTOT=1
 ..Q
 .Q
 I 'APCSVTOT D
 .Q:$D(ZTQUEUED)
 .W !!,"There are no lab test results to export."
 .D PAUSE^APCLVL01
 Q
LAB ;does this visit have A or B or either?
 S X=0 F  S X=$O(^AUPNVLAB("AD",APCSV,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVLAB(X,0))
 .I '$P(^AUPNVLAB(X,0),U,1) Q
 .I APCSLTYP="A"!(APCSLTYP="C") D
 ..I $D(^ATXLAB(APCSALBT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCSGOT=1,APCSLAB(X)="" Q
 ..Q:'APCSALOT
 ..S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ..Q:'$$LOINC(J,APCSALOT)
 ..S APCSGOT=1,APCSLAB(X)=""
 .I APCSLTYP="B"!(APCSLTYP="C") D
 ..I $D(^ATXLAB(APCSBLBT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCSGOT=1,APCSLAB(X)="" Q
 ..Q:'APCSBLOT
 ..S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ..Q:'$$LOINC(J,APCSBLOT)
 ..S APCSGOT=1,APCSLAB(X)=""
 .I APCSLTYP="D"  D
 ..I '$D(APCSLABS($P(^AUPNVLAB(X,0),U))) Q
 ..S APCSGOT=1,APCSLAB(X)=""
 Q
LOINC(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;send file
WRITE ; use XBGSAVE to save the temp global (APCSDATA) to a delimited
 ; file that is exported to the IE system
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBGL="APCSDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="CERTIFICATION EXPORT"
 S APCSASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="CERTLABHL7_"_APCSASU_"_"_$$DATE(DT)_".txt"
 S XBS1="CERTIFICATION EXPORT"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"LAB HL7 file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"LAB HL7 file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to IHS/CDC",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 K ^APCSDATA($J)
 Q
 ;
DATE(D) ;EP
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
JDATE(D) ;EP - get date
 I $G(D)="" Q ""
 NEW A
 S A=$$FMTE^XLFDT(D)
 Q $E(D,6,7)_$$UP^XLFSTR($P(A," ",1))_(1700+$E(D,1,3))
 ;
UID(APCSA) ;Given DFN return unique patient record id.
 I '$G(APCSA) Q ""
 I '$D(^AUPNPAT(APCSA)) Q ""
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(APCSA))_APCSA
 ;
EXIT ;clean up and exit
 D EN^XBVK("APCS")
 D ^XBFMK
 Q
 ;
EP ;EP - called from option to create search template using ILI logic
 G ^APCLSIL3
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
PURGE ;
 W:'$D(ZTQUEUED) !!,"Now cleaning up host files older than 7 DAYS"
 K APCSFILE,APCSDIR
 S APCSDIR=$P($G(^AUTTSITE(1,1)),"^",2)
 I APCSDIR="" S APCSDIR=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I APCSDIR="" Q
 S APCSASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)
 S APCSDT=$$FMADD^XLFDT(DT,-7)
 S APCSDT=$$DATE(APCSDT)
 S APCSFLST=$$LIST^%ZISH(APCSDIR,"EPILABHL7"_APCSASU_"*",.APCSFILE)
 Q:'$O(APCSFILE(""))
 S APCSX=0 F  S APCSX=$O(APCSFILE(APCSX)) Q:APCSX'=+APCSX  D
 .S D=$P($P(APCSFILE(APCSX),"."),"_",3)
 .I D<APCSDT S N=APCSFILE(APCSX) S APCSM=$$DEL^%ZISH(APCSDIR,N)
 Q
