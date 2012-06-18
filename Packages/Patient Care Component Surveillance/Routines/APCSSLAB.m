APCSSLAB ; IHS/CMI/LAB - ILI surveillance export ; 
 ;;3.0;IHS PCC REPORTS;**22,23,24,25,26,27,28**;FEB 05, 1997
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
 W !,"be sent to the IHS EPI program.  A message will be sent for every visit"
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
 S XBRC="PROC^APCSSLAB",XBRP="",XBNS="APCS",XBRX="EXIT^APCSSLAB"
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
 ..I APCSGOT D HL7(DFN,APCSV) Q  ;don't bother with cpts if found lab
 ..S APCSGOT=0 K APCSLAB
 ..D CPT
 ..I APCSGOT D HL7(DFN,APCSV) Q
 ..Q
 .Q
 I APCSVTOT D ILI^APCSHLO("ILILAB") Q
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
CPT ;
 S X=0 F  S X=$O(^AUPNVCPT("AD",APCSV,X)) Q:X'=+X!(APCSGOT)  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S Y=$P(^AUPNVCPT(X,0),U,1)
 .I APCSLTYP="A"!(APCSLTYP="C"),$$ICD^ATXCHK(Y,APCSACTT,1) S APCSGOT=1 Q
 .I APCSLTYP="B"!(APCSLTYP="C"),$$ICD^ATXCHK(Y,APCSBCTT,1) S APCSGOT=1 Q
 .Q
 Q
HL7(FN,AV) ;export this visit - MARK - this is where you will generate the HL7 message
 ;APCSV is visit ien
 ;array APCSLAB is array of lab test entries to send from V LAB
 ;if array APCSLAB is undefined that means a found a visit with a cpt code and no lab so there will be no OBXs for lab but send the visit
 S APCSVTOT=APCSVTOT+1
 D BLDPID(FN,AV)
 D BLDZID(FN,AV)
 D BLDPV1(AV)
 D BLDDG1(AV)
 D BLDPR1(AV)
 S APCSOBXC=0
 D BLDOBXTP(AV)
 D BLDOBXLB(AV)
 W:'$D(ZTQUEUED) ".",AV
 Q
BLDPID(F,V) ;
 N LOC,HRN,SEX,DOB
 S LOC=$P($G(^AUPNVSIT(V,0)),U,6)
 S HRN=$S($$HRN^AUPNPAT(F,LOC)]"":$$HRN^AUPNPAT(F,LOC),1:$$HRN^AUPNPAT(F,DUZ(2)))
 S SEX=$P($G(^DPT(F,0)),U,2)
 S DOB=$$FMTHL7^XLFDT($P($G(^DPT(F,0)),U,3))
 S ^APCSDATA($J,V,"PID")=HRN_U_SEX_U_DOB
 Q
 ;
BLDZID(F,V) ;
 N AGE
 S AGE=$$AGE^AUPNPAT(F)
 S ^APCSDATA($J,V,"ZID")=AGE
 Q
 ;
BLDPV1(V) ;
 N ASUFAC,UVIEN,VDT,DDT,LOC,CC,CLN
 S LOC=$P($G(^AUPNVSIT(V,0)),U,6)
 S CLN=$P($G(^AUPNVSIT(V,0)),U,8)
 S CC=$S(CLN:$$GET1^DIQ(40.7,CLN,1),1:"")
 S ASUFAC=$P(^AUTTLOC(LOC,0),U,10)
 S UVIEN=$S($P($G(^AUPNVSIT(V,11)),U,14)]"":$P($G(^AUPNVSIT(V,11)),U,14),1:$$UIDV^AUPNVSIT(V))
 S VDT=$$FMTHL7^XLFDT($P($P(^AUPNVSIT(V,0),U),"."))
 S DDT=$$FMTHL7^XLFDT($$DSCHDATE^APCLSIL2(V))
 S ^APCSDATA($J,V,"PV1")=ASUFAC_U_CC_U_UVIEN_U_VDT_U_DDT
 Q
 ;
BLDDG1(V) ;
 N BDA,DX,CNT
 S CNT=0
 S BDA=0 F  S BDA=$O(^AUPNVPOV("AD",V,BDA)) Q:'BDA  D
 . S DX=$$GET1^DIQ(9000010.07,BDA,.01)
 . S CNT=CNT+1
 . S ^APCSDATA($J,V,"DG1",CNT)=DX
 Q
 ;
BLDPR1(V) ;
 N BDA,CPT,CNT
 S CNT=0
 S BDA=0 F  S BDA=$O(^AUPNVCPT("AD",V,BDA)) Q:'BDA  D
 . S CPT=$$GET1^DIQ(9000010.18,BDA,.01)
 . S CNT=CNT+1
 . S ^APCSDATA($J,V,"PR1",CNT)=CPT
 Q
 ;
BLDOBXTP(V) ;
 N BDA,TMP,TEMP
 S TEMP=""
 S BDA=0 F  S BDA=$O(^AUPNVMSR("AD",V,BDA)) Q:'BDA  D
 .Q:$P($G(^AUPNVMSR(BDA,2)),U,1)
 .Q:$$VAL^XBDIQ1(9000010.01,BDA,.01)'="TMP"  ;not a temperature
 .S TMP=$P(^AUPNVMSR(BDA,0),U,4)
 .S TEMP=$S(TMP>TEMP:TMP,1:TEMP)
 .S APCSOBXC=APCSOBXC+1
 .S ^APCSDATA($J,V,"OBX",APCSOBXC)=APCSOBXC_U_"ST"_U_"TMP"_U_TEMP
 Q
 ;
BLDOBXLB(V) ;
 N BDA,LABI,LAB,LOINC,RES
 S BDA=0 F  S BDA=$O(APCSLAB(BDA)) Q:'BDA  D
 . S LABI=$P($G(^AUPNVLAB(BDA,0)),U)
 . S RES=$P($G(^AUPNVLAB(BDA,0)),U,4)
 . S LAB=$$GET1^DIQ(9000010.09,BDA,.01)
 . S LOINC=$$GET1^DIQ(9000010.09,BDA,1113)
 . S APCSOBXC=APCSOBXC+1
 . S ^APCSDATA($J,V,"OBX",APCSOBXC)=APCSOBXC_U_"ST"_U_LOINC_"~"_LAB_U_RES
 Q
 ;
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
 S XBNAR="EPI LAB HL7 EXPORT"
 S APCSASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="EPILABHL7_"_APCSASU_"_"_$$DATE(DT)_".txt"
 S XBS1="SURVEILLANCE ILI SEND"
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
