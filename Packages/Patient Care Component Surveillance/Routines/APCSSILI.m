APCSSILI ; IHS/CMI/LAB - ILI surveillance export ; 
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
 ;
START ;
 ;This option will create an HL7 output file of all visits for the past 90 days.
 ;
 ;
 D EXIT
 ;
INFORM ;inform user
 W:$D(IOF) @IOF
 W !!,$$CJ^XLFSTR("SURVEILLANCE ILI HL7 EXPORT",80)
 W !!,"This option is used to create a file of HL7 messages.  The messages will"
 W !,"be sent to the IHS EPI program.  Visits in the past 90 days that meet"
 W !,"the criteria defined by the EPI program for the ILI export will be sent."
 W !,"The data elements contained in the HL7 messages have been defined by the"
 W !,"EPI program.  Documentation of the message definitions can be"
 W !,"obtained from the EPI program.",!!
 W !,"This HL7 export file will be automatically ftp'ed to the EPI program.",!!
DATES ;set date range to T-91 to T-1
 ;
 S APCSBD=$$FMADD^XLFDT(DT,-91),APCSED=$$FMADD^XLFDT(DT,-1)
 W !!,"The date range for this export is: ",$$FMTE^XLFDT(APCSBD)," to ",$$FMTE^XLFDT(APCSED),".",!
CONTINUE ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue and generate this export file",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D EXIT Q
ZIS ;called xbdbque to see if they want to queue or not
 S XBRC="PROC^APCSSILI",XBRP="",XBNS="APCS",XBRX="EXIT^APCSSILI"
 D ^XBDBQUE
 D EXIT
 Q
PROC ;EP - called from xbdbque
 K APCSLOCT
 K ^APCSDATA($J)  ;export global
 S APCSCTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))  ;clinic taxonomy
 S APCSDTAX=$O(^ATXAX("B","SURVEILLANCE ILI",0))  ;dx taxonomy
 I 'APCSCTAX D EXIT Q
 I 'APCSDTAX D EXIT Q
 ;
 S APCSSD=$$FMADD^XLFDT(DT,-91)_".9999"  ;start with 3/21/09 visits CHANGED TO 90 DAYS IN PATCH 26, AFTER THE FIRST PATCH 26 EXPORT
 S APCSED=$$FMADD^XLFDT(DT,-1)
 S APCSVTOT=0  ;visit counter
 F  S APCSSD=$O(^AUPNVSIT("B",APCSSD)) Q:APCSSD'=+APCSSD!($P(APCSSD,".")>APCSED)  D
 .S APCSV=0 F  S APCSV=$O(^AUPNVSIT("B",APCSSD,APCSV)) Q:APCSV'=+APCSV  D
 ..Q:'$D(^AUPNVSIT(APCSV,0))  ;no zero node
 ..Q:$P(^AUPNVSIT(APCSV,0),U,11)  ;deleted visit
 ..S DFN=$P(^AUPNVSIT(APCSV,0),U,5)
 ..Q:DFN=""
 ..Q:'$D(^DPT(DFN,0))
 ..Q:$P(^DPT(DFN,0),U)["DEMO,PATIENT"
 ..Q:$$DEMO^APCLUTL(DFN)
 ..S G=0,X=0 F  S X=$O(^BGPSITE(X)) Q:X'=+X  I $P($G(^BGPSITE(X,0)),U,12) I $D(^DIBT($P(^BGPSITE(X,0),U,12),1,DFN)) S G=1
 ..Q:G
 ..S APCSKV=0,APCSH1N1=0,(APCSILI,APCSHVAC,APCSIVAC,APCSADVE,APCSSRD,APCSAVM,APCSAV9)=""
 ..S APCSLOC=$P(^AUPNVSIT(APCSV,0),U,6)  Q:APCSLOC=""  ;no location ???
 ..S APCSDATE=$P($P(^AUPNVSIT(APCSV,0),U),".")
 ..S APCSASUF=$P($G(^AUTTLOC(APCSLOC,0)),U,10)
 ..I APCSASUF="" Q  ;no ASUFAC????
 ..;keep visit?
 ..S G=0 D ILIDX I G S APCSKV=1,APCSILI=G
 ..S G=0 D H1N1DX I G S APCSKV=1,APCSH1N1=G
 ..;S APCSHVAC=$$HASVAC(APCSV) I APCSHVAC S APCSKV=1
 ..S APCSIVAC=$$HASIVAC^APCLSILI(APCSV) I APCSIVAC S APCSKV=1
 ..S APCSADVE=$$HASADVN6^APCLSIL1(APCSV) I APCSADVE S APCSKV=1
 ..S APCSOVAC="" I APCSADVE S APCSOVAC=$$OTHVAC^APCLSIL1(DFN,APCSDATE)
 ..S APCSSRD=$$HASSRD7(APCSV) I APCSSRD S APCSKV=1
 ..S APCSAVM=$$HASAVM(APCSV) I APCSAVM S APCSKV=1
 ..;S APCSAV9=$$HASAV9(APCSV) I APCSAV9 S APCSKV=1
 ..I 'APCSKV Q  ;not a visit to export
 ..W:'$D(ZTQUEUED) "."
 ..D SETREC^APCSSIL2  ;set record
 ;NOW SET TOTAL IN PIECE 13
 S X=0 F  S X=$O(^APCSDATA($J,X)) Q:X'=+X  D
 .I $P(^APCSDATA($J,X),",",8)="" Q  ;not an ILI visit
 .Q:$P(^APCSDATA($J,X),",",15)="H"  ;not ambulatory
 .S L=$P(^APCSDATA($J,X),",",6),D=$P(^APCSDATA($J,X),",",7)
 .S $P(^APCSDATA($J,X),",",13)=$G(APCSLOCT(L,D))
 .Q
 ;NOW SET TOTAL IN PIECE 20
 S X=0 F  S X=$O(^APCSDATA($J,X)) Q:X'=+X  D
 .Q:$P(^APCSDATA($J,X),",",15)'="H"
 .I $P(^APCSDATA($J,X),",",8)="",$P(^APCSDATA($J,X),U,43)=""  ;not an ILI or H1N1 visit
 .S L=$P(^APCSDATA($J,X),",",6),D=$P(^APCSDATA($J,X),",",7)
 .S $P(^APCSDATA($J,X),",",20)=$G(APCSHTOT(L,D))
 .Q
 ;NOW SET TOTAL IN PIECE 42
 S X=0 F  S X=$O(^APCSDATA($J,X)) Q:X'=+X  D
 .Q:$P(^APCSDATA($J,X),",",15)="H"
 .I $P(^APCSDATA($J,X),",",43)="" Q    ;not an H1N1/ili visit
 .S L=$P(^APCSDATA($J,X),",",6),D=$P(^APCSDATA($J,X),",",7)
 .S $P(^APCSDATA($J,X),",",42)=$G(APCSALLT(L,D))
 .Q
 ;MARK - at this point you can loop through ^APCSDATA and generate HL7 messages
 I '$O(^APCSDATA($J,0)) D  Q
 .I '$D(ZTQUEUED) W !!,"There are no visits to export.",! D PAUSE^APCLVL01
 D ILI^APCSHLO("ILI")  ;parse out the APCSDATA global and create a message from it
 I '$D(ZTQUEUED) D PAUSE^APCLVL01
 ;D WRITE  ;MARK - if you stored all the HL7 messages somewhere this is where you will write them out see WRITE subroutine, I write out global APCSDATA
 Q
ILIDX ;
 Q:"AORSH"'[$P(^AUPNVSIT(APCSV,0),U,7)
 I $P(^AUPNVSIT(APCSV,0),U,7)="H" S APCSHTOT(APCSASUF,$$JDATE(APCSDATE))=$G(APCSHTOT(APCSASUF,$$JDATE(APCSDATE)))+1
 S APCSCLIN=$$CLINIC^APCLV(APCSV,"I")  ;get clinic code
 ;is there a PHN
 S X=0,P=0 F  S X=$O(^AUPNVPRV("AD",APCSV,X)) Q:X'=+X!(P)  D
 .Q:'$D(^AUPNVPRV(X,0))
 .S Y=$P(^AUPNVPRV(X,0),U)
 .S Z=$$VALI^XBDIQ1(200,Y,53.5)
 .Q:'Z
 .I $P($G(^DIC(7,Z,9999999)),U,1)=13 S P=1
 I P G ILIDX1
 I $P(^AUPNVSIT(APCSV,0),U,7)'="H" Q:APCSCLIN=""
 I $P(^AUPNVSIT(APCSV,0),U,7)'="H" Q:'$D(^ATXAX(APCSCTAX,21,"B",APCSCLIN))  ;not in clinic taxonomy
ILIDX1 ;
 I $P(^AUPNVSIT(APCSV,0),U,7)'="H" S APCSLOCT(APCSASUF,$$JDATE(APCSDATE))=$G(APCSLOCT(APCSASUF,$$JDATE(APCSDATE)))+1   ;total number of visits
 S C=0
 K G,Y S G=""
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCSV,X)) Q:X'=+X  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,APCSDTAX,9) S C=C+1,Y(C)=$$VAL^XBDIQ1(9000010.07,X,.01)
 Q:'$D(Y)  ;no diagnosis
 S X=0 F  S X=$O(Y(X)) Q:X'=+X  S G=G_U_Y(X)
 S $P(G,U,1)=1
 Q
H1N1DX ;
 Q:"AORSH"'[$P(^AUPNVSIT(APCSV,0),U,7)  ;just want outpatient with dx
 S APCSCLIN=$$CLINIC^APCLV(APCSV,"I")  ;get clinic code
 ;I $P(^AUPNVSIT(APCSV,0),U,7)'="H" Q:'$D(^ATXAX(APCSCTAX,21,"B",APCSCLIN))  ;not in clinic taxonomy
 I $P(^AUPNVSIT(APCSV,0),U,7)'="H" S APCSALLT(APCSASUF,$$JDATE(APCSDATE))=$G(APCSALLT(APCSASUF,$$JDATE(APCSDATE)))+1   ;total number of visits
 S G=0
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCSV,X)) Q:X'=+X!(G)  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE H1N1 DX",0)),9) S G=1,D=$$VAL^XBDIQ1(9000010.07,X,.01)
 Q:'G  ;no diagnosis
 S G=1_U_D
 Q
HASSRD7(APCLV) ;EP
 NEW X,P,D,Y,Z,APCLCLIN,T,G,C
 I $P(^AUPNVSIT(APCLV,0),U,7)'="H" Q ""  ;just want hOSP
 S C=0
 K G,Y S G=""
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,$O(^ATXAX("B","SURVEILLANCE SEV RESP DIS DXS",0)),9) S C=C+1,Y(C)=$$VAL^XBDIQ1(9000010.07,X,.01)
 I '$D(Y) Q ""  ;no diagnosis
 S X=0 F  S X=$O(Y(X)) Q:X'=+X  S G=G_U_Y(X)
 S $P(G,U,1)=1
 Q G
HASAVM(V) ;EP
 NEW C,X,Y,Z,T,L,M,N
 S T=$O(^ATXAX("B","FLU ANTIVIRAL MEDS",0))
 S C="",X=0 F  S X=$O(^AUPNVMED("AD",V,X)) Q:X'=+X!(C)  S Y=$P($G(^AUPNVMED(X,0)),U) D
 .Q:'Y
 .Q:'$D(^PSDRUG(Y,0))
 .S Z=0
 .S N=$P(^PSDRUG(Y,0),U)
 .I $D(^ATXAX(T,21,"B",Y)) S Z=1
 .I N["OSELTAMIVIR" S Z=1
 .I N["ZANAMIVIR" S Z=1
 .I Z=1 S C=1_U_N_U_$P(^AUPNVMED(X,0),U,7)
 .Q
 Q C
 ;send file
WRITE ; use XBGSAVE to save the temp global (APCSDATA) to a delimited
 ; file that is exported to the IE system
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBGL="APCSDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="ILI SURVEILLANCE EXPORT HL7"
 S APCSASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="FLUHL7_"_APCSASU_"_"_$$DATE(DT)_".txt"
 S XBS1="SURVEILLANCE ILI SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT ILI file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT ILI file NOT successfully created",!!
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
 K ^APCSDATA($J)
 Q
 ;
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
 S APCSFLST=$$LIST^%ZISH(APCSDIR,"FLUHL7_"_APCSASU_"*",.APCSFILE)
 Q:'$O(APCSFILE(""))
 S APCSX=0 F  S APCSX=$O(APCSFILE(APCSX)) Q:APCSX'=+APCSX  D
 .S D=$P($P(APCSFILE(APCSX),"."),"_",3)
 .I D<APCSDT S N=APCSFILE(APCSX) S APCSM=$$DEL^%ZISH(APCSDIR,N)
 Q
