BGP9DNE ; IHS/CMI/LAB - NATL COMP EXPORT 05 Dec 2006 7:09 PM 07 Mar 2008 2:29 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
 ;
 W:$D(IOF) @IOF
INTRO ;
 D XIT
 S BGPXPFYC=$O(^BGPCTRL("B","2009",0))
 S X=0 F  S X=$O(^BGPCTRL(BGPXPFYC,54,X)) Q:X'=+X  D
 .I $Y>(IOSL-3) D EOP W @IOF
 .W !,^BGPCTRL(BGPXPFYC,54,X,0)
 D TAXCHK^BGP9XTCN
TP ;
 S BGPRTYPE=1,BGPXPRP=1,BGPXPFYY=2009,BGPXPFYI=308
 S BGPXPBD=2990701,BGPXPNDT=3090630
 W !!,"The date ranges for this report are: ",$$FMTE^XLFDT(BGPXPBD)," to ",?31,$$FMTE^XLFDT(BGPXPNDT)
COMM ;
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K BGPTAX
 S BGPTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC K DIC
 I Y=-1 Q
 S BGPTAXI=+Y
COM1 ;
 S X=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S BGPTAX($P(^ATXAX(BGPTAXI,21,X,0),U))=""
 .Q
 I '$D(BGPTAX) W !!,"There are no communities in that taxonomy." G COMM
 S X=0,G=0
 F  S X=$O(^ATXAX(BGPTAXI,21,X)) Q:'X  D
 .S C=$P(^ATXAX(BGPTAXI,21,X,0),U)
 .I '$D(^AUTTCOM("B",C)) W !!,"***  Warning: Community ",C," is in the taxonomy but was not",!,"found in the standard community table." S G=1
 .Q
 I G D  I BGPQUIT D XIT Q
 .W !!,"These communities may have been renamed or there may be patients"
 .W !,"who have been reassigned from this community to a new community and this"
 .W !,"could reduce your patient population."
 .S BGPQUIT=0
 .S DIR(0)="Y",DIR("A")="Do you want to cancel the report and review the communities" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S BGPQUIT=1
 .I Y S BGPQUIT=1
 .Q
MFIC K BGPQUIT
 S BGPMFITI=""
 I $P($G(^BGPSITE(DUZ(2),0)),U,8)=1 D  I BGPMFITI="" G COMM
 .S BGPMFITI=""
 .W !!,"Specify the LOCATION taxonomy to determine which patient visits will be"
 .W !,"used to determine whether a patient is in the denominators for the report."
 .W !,"You should have created this taxonomy using QMAN.",!
 .K BGPMFIT
 .S BGPMFITI=""
 .D ^XBFMK
 .S DIC("S")="I $P(^(0),U,15)=9999999.06",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Location/Facility Taxonomy: "
 .S B=$P($G(^BGPSITE(DUZ(2),0)),U,9) I B S DIC("B")=$P(^ATXAX(B,0),U)
 .D ^DIC
 .I Y=-1 Q
 .S BGPMFITI=+Y
BEN ;
 S BGPBEN=1
HOME ;
 S BGPHOME=$P($G(^BGPSITE(DUZ(2),0)),U,2)
 ;I BGPHOME="" W !!,"Home Location not found in Site File!!",!,"PHN Visits counts to Home will be calculated using clinic 11 only!!" H 2 G EXPORT
 ;W !,"Your HOME location is defined as: ",$P(^DIC(4,BGPHOME,0),U)," asufac:  ",$P(^AUTTLOC(BGPHOME,0),U,10)
EXPORT ;export to area or not?
 S BGPEXPT=""
 S DIR(0)="Y",DIR("A")="Do you wish to export this data to Area" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S BGPEXPT=Y
 S BGPXPDR=DT
 S BGPNOW=$$NOW^XLFDT
 S BGPUF=$$GETDIR^BGP9UTL2()
 ;I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["NT")!($P($G(^AUTTSITE(1,0)),U,21)=2) S BGPUF=$S($P($G(^AUTTSITE(1,1)),U,2)]"":$P(^AUTTSITE(1,1),U,2),1:"C:\EXPORT")
 ;I $P(^AUTTSITE(1,0),U,21)=1 S BGPUF="/usr/spool/uucppublic/"
 I BGPEXPT,BGPUF="" W:'$D(ZTQUEUED) !!,"Cannot continue.....can't find export directory name. EXCEL file",!,"not written." D PAUSE^BGP9CL,XIT Q
 S BGPFN="CRSCNT"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP9UTL(BGPXPBD)_$$D^BGP9UTL(BGPXPNDT)_$$D^BGP9UTL(BGPNOW)_"_001_of_001.TXT"
LOCALF ;
 S BGPLOCAL=""
 S DIR(0)="Y",DIR("A")="Do you want to create local delimited files for use in Excel",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G EXPORT
 S BGPLOCAL=Y
 I 'BGPLOCAL,'BGPEXPT W !!,"You have chosen not to create any files.....exiting" H 3 D XIT Q
SUM ;
 W:$D(IOF) @IOF
 W !,$$CTR("SUMMARY OF NATIONAL GPRA EXPORT FILE TO BE GENERATED")
 W !!,"The date ranges for this report are: ",$$FMTE^XLFDT(BGPXPBD)," to ",?31,$$FMTE^XLFDT(BGPXPNDT)
 W !!,"The COMMUNITY Taxonomy to be used is: ",$P(^ATXAX(BGPTAXI,0),U)
 I $G(BGPMFITI) W !!,"The MFI Location Taxonomy to be used is: ",$P(^ATXAX(BGPMFITI,0),U)
 ;I BGPHOME W !,"The HOME location is: ",$P(^DIC(4,BGPHOME,0),U)," ",$P(^AUTTLOC(BGPHOME,0),U,10)
 ;I 'BGPHOME W !,"No HOME Location selected."
 I BGPEXPT D
 .W !,"The Area Export file will be named: ",!,BGPFN
 .W !,"and will reside in the ",BGPUF," directory.  This is the file you should"
 .W !,"export to your Area Office.  Depending on your site configuration, the"
 .W !,"file may need to be manually sent to your Area Office.",!
 I BGPLOCAL D
 .W !,"The local files will all begin with ""","CRSLCNT","""and will have the"
 .W !,"same name except for the last 10 characters, which represent the number"
 .W !,"of files (e.g. 001_of_003).",!
 .W !,"NOTE: If the data will fit into one file, only one file beginning"
 .W !,"with ""","CRSCNT","""will be created, which should be used for"
 .W !,"both Area Exporting and local use.",!
ZIS ;call to XBDBQUE
 ;CREATE REPORT ENTRY
 K DIC S X=$P(^VA(200,DUZ,0),U)_"-"_$$D^BGP9UTL(BGPNOW),DIC(0)="L",DIC="^BGPXPN(",DLAYGO=90536.11,DIADD=1
 S DIC("DR")=".02////"_BGPXPBD_";.03////"_BGPXPNDT_";.04////"_$P(^ATXAX(BGPTAXI,0),U)_";.05////"_$S(BGPMFITI:$P(^ATXAX(BGPMFITI,0),U),1:"")
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY!" H 4 D XIT Q
 S BGPXPRPT=+Y
 K ^BGPXPN(BGPXPRPT,13)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPXPN(BGPXPRPT,13,C,0)=X,^BGPXPN(BGPXPRPT,13,"B",X,C)=""
 S ^BGPXPN(BGPXPRPT,13,0)="^90536.111301A^"_C_"^"_C
 K ^BGPXPN(BGPXPRPT,14)
 I $G(BGPMFITI) S C=0,X="" F  S X=$O(^ATXAX(BGPMFITI,21,"B",X)) Q:X=""  S C=C+1,Y=$P($G(^DIC(4,X,0)),U) S ^BGPXPN(BGPXPRPT,14,C,0)=Y,^BGPXPN(BGPXPRPT,14,"B",Y,C)=""
 S ^BGPXPN(BGPXPRPT,14,0)="^90536.111401A^"_C_"^"_C
ONEF ;
 S BGPONEF=""
 K IOP,%ZIS W !! S %ZIS="PQM" D ^%ZIS
 I POP W !,"Report Aborted" S DA=BGPXPRPT,DIK="^BGPXPN(" D ^DIK K DIK D XIT Q
 I $D(IO("Q")) G TSKMN
DRIVER ;
 D PROC^BGP9DNE
 U IO
 D PRINT^BGP9DNE
 D ^%ZISC
 Q
 ;
TSKMN ;EP ENTRY POINT FROM TASKMAN
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE S ZTSAVE("BGP*")=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^BGP9DNE",ZTDTH="",ZTDESC="NATIONAL GPRA REPORT 09" D ^%ZTLOAD D XIT Q
 Q
 ;
XIT ;
 D ^%ZISC
 D EN^XBVK("BGP") I $D(ZTQUEUED) S ZTREQ="@"
 K DIRUT,DUOUT,DIR,DOD
 K DIADD,DLAYGO
 D KILL^AUPNPAT
 K X,X1,X2,X3,X4,X5,X6
 K A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 K N,N1,N2,N3,N4,N5,N6
 K BD,ED
 D KILL^AUPNPAT
 D ^XBFMK
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!$D(IO("S"))
 W !
 NEW DIR,X
 K DIR,DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR KILL DIR
 Q
 ;----------
USR() ;EP - 
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - .
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
 ;
CNTSF ;EP
 I '$D(ZTQUEUED) W !!,"Writing out National GPRA Export file...."
 I BGPEXPT D CNTSF1
 I 'BGPLOCAL G STOP
 ;count up total # of records and divide by 65,536
 S BGPX=0,BGPTOT=0 F  S BGPX=$O(^BGPXPN(BGPXPRPT,11,BGPX)) Q:BGPX'=+BGPX  S BGPTOT=BGPTOT+1
 S BGPNF1=BGPTOT/65536
 I BGPNF1'>1,BGPEXPT G STOP ; - only 1 and it is created already
 S BGPNF=$S($P(BGPNF1,".",2)]"":BGPNF1+1,1:BGPNF1)
 S BGPNF=$P(BGPNF,".")
 S BGPX=0,BGPLX=0
 S ^BGPXPN(BGPXPRPT,12,0)="^90536.111201A^"_BGPNF_"^"_BGPNF
 F BGPZ=1:1:BGPNF D
 .S BGPFN="CRSLCNT"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP9UTL(BGPXPBD)_$$D^BGP9UTL(BGPXPNDT)_$$D^BGP9UTL(BGPNOW)_"_"_$$LZERO^BGP9UTL(BGPZ,3)_"_of_"_$$LZERO^BGP9UTL(BGPNF,3)_".TXT"
 .S ^BGPXPN(BGPXPRPT,12,BGPZ+1,0)=BGPFN_" --- "_BGPUF
 .I '$D(ZTQUEUED) U IO W !?10,BGPFN
 .S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 .I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 .U IO
 .S Y="SITE NAME^ASUFAC^DATE FILE RUN^FILE BEGIN DATE^FILE END DATE^PATIENT UNIQUE REGISTRATION ID^DOB^GENDER^STATE^COUNTY^MEASURE ID^MEASURE"
 .S P=13 F X=2000:1:BGPXPFYY S $P(Y,U,P)="GPRA YR "_X,P=P+1
 .W Y,!
 .S BGPC=1,BGPX=$S(BGPLX:BGPLX,1:0)
 .F  S BGPX=$O(^BGPXPN(BGPXPRPT,11,BGPX)) Q:BGPX'=+BGPX!(BGPC>65535)  D
 ..W $G(^BGPXPN(BGPXPRPT,11,BGPX,0)),!
 ..S BGPC=BGPC+1
 ..S BGPLX=BGPX
 .D ^%ZISC
STOP ;
 K ^BGPXPN(BGPXPRPT,11)
 Q
CNTSF1 ;EP
 ;write out one flie only
 S BGPZ=1,BGPFN="CRSCNT"_$P(^AUTTLOC(DUZ(2),0),U,10)_$$D^BGP9UTL(BGPXPBD)_$$D^BGP9UTL(BGPXPNDT)_$$D^BGP9UTL(BGPNOW)_"_001_of_001.TXT"
 S ^BGPXPN(BGPXPRPT,12,BGPZ,0)=BGPFN_" --- "_BGPUF
 I '$D(ZTQUEUED) U IO W !?10,BGPFN
 L +^BGPDATA:10 Q:'$T
 K ^BGPDATA  ;EXPORT GLOBAL FOR AREA EXPORT
 S BGPC=0
 S Y="SITE NAME^ASUFAC^DATE FILE RUN^FILE BEGIN DATE^FILE END DATE^PATIENT UNIQUE REGISTRATION ID^DOB^GENDER^STATE^COUNTY^MEASURE ID^MEASURE"
 S P=13 F X=2000:1:BGPXPFYY S $P(Y,U,P)="GPRA YR "_X,P=P+1
 S BGPC=BGPC+1
 S ^BGPDATA(BGPC)=Y
 S BGPX=0
 F  S BGPX=$O(^BGPXPN(BGPXPRPT,11,BGPX)) Q:BGPX'=+BGPX  D
 .S BGPC=BGPC+1
 .S ^BGPDATA(BGPC)=$G(^BGPXPN(BGPXPRPT,11,BGPX,0))
 ;D ^%ZISC
 S XBGL="BGPDATA"
 S XBMED="F",XBFN=BGPFN,XBTLE="SAVE OF NATIONAL GPRA EXPORT DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
PROC ;EP
 S BGPBT=$H
 D JRNL^BGP9UTL
 S BGPXPXPX=1  ;in xp report
 S BGPJ=$J,BGPH=$H
 S BGPCHSO=$P($G(^BGPSITE(DUZ(2),0)),U,6)
 S BGPXPTOT=0
PROC1 ;process each patient
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:DFN'=+DFN  D
 .;S DFN=4812 D
 .Q:'$D(^DPT(DFN,0))
 .Q:$P($G(^DPT(DFN,0)),U)["DEMO,PATIENT"
 .I $P($G(^BGPSITE(DUZ(2),0)),U,12) Q:$D(^DIBT($P(^BGPSITE(DUZ(2),0),U,12),1,DFN))
 .S BGPXPUP=""
 .F BGPXPCY=300:1:BGPXPFYI  D
 ..;set beginning date and ending date
 ..S BGPXXX=BGPXPCY_"0630"
 ..Q:'$$ACTUP^BGP9D1(DFN,$$FMADD^XLFDT(BGPXXX,-(3*365)),BGPXXX,BGPTAXI,1)
 ..S BGPXPUP=1
 .Q:'BGPXPUP  ;NOT IN ANY USER POP
 .D PROCYRS
 .S X=0 F  S X=$O(BGPXPDAT(X)) Q:X'=+X  D
 ..S BGPXPTOT=BGPXPTOT+1
 ..S ^BGPXPN(BGPXPRPT,11,BGPXPTOT,0)=BGPXPDAT(X)
 .Q
 S ^BGPXPN(BGPXPRPT,11,0)="^90536.111101A^"_BGPXPTOT_"^"_BGPXPTOT
 S BGPET=$H
 D CNTSF
 Q
PROCYRS ;
 ;process each year from 2000, starting at "^" piece 13, loop through all measures
 S BGPXPPIE=12
 K BGPXPDAT
 F BGPXPCY=300:1:BGPXPFYI  D
 .;set beginning date and ending date
 .S BGPBD=(BGPXPCY-1)_"0701",BGPED=BGPXPCY_"0630",BGPXPPIE=BGPXPPIE+1
 .S BGP3YE=$$FMADD^XLFDT(BGPED,-1096)
 .D PROCCY^BGP9D1
 .D PROCIND
 .Q
 Q
PROCIND ;
 S BGPXPPD=$P(^DIC(4,DUZ(2),0),U)
 S $P(BGPXPPD,U,2)=$P(^AUTTLOC(DUZ(2),0),U,10)
 S $P(BGPXPPD,U,3)=$$EDT^BGP9UTL(DT)
 S $P(BGPXPPD,U,4)=$$EDT^BGP9UTL(BGPXPBD)
 S $P(BGPXPPD,U,5)=$$EDT^BGP9UTL(BGPXPNDT)
 S $P(BGPXPPD,U,6)=$$UID^BGP9DCHW(DFN)
 S $P(BGPXPPD,U,7)=$$EDT^BGP9UTL($P(^DPT(DFN,0),U,3))
 S $P(BGPXPPD,U,8)=$P(^DPT(DFN,0),U,2)
 S $P(BGPXPPD,U,9)=$$STATE^BGP9DCHW(DFN)
 S $P(BGPXPPD,U,10)=$$COUNTY(DFN)
 ;process each measure and set record BGPXPDAT per measure
 S BGPXPMI=0 F  S BGPXPMI=$O(^BGPCTRL(BGPXPFYC,55,BGPXPMI)) Q:'BGPXPMI  D
 .S BGPXPX=$P(^BGPCTRL(BGPXPFYC,55,BGPXPMI,0),U,1)
 .K BGPSTOP,BGPVAL,BGPVALUE,BGPG,BGPC,BGPALLED,BGPV,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .K BGPN1,BGPN2,BGPN3,BGPN4,BGPN5,BGPN6,BGPN7,BGPN8,BGPN9,BGPN10,BGPN11,BGPN12,BGPN13,BGPN14,BGPN15,BGPN16,BGPN17,BGPN18,BGPN19,BGPN20,BGPN21,BGPN22,BGPN23,BGPN24,BGPN25,BGPN26,BGPN27,BGPN28,BGPN29,BGPN30
 .K BGPD1,BGPD2,BGPD3,BGPD4,BGPD5,BGPD6,BGPD7,BGPD8,BGPD9,BGPD10,BGPD11,BGPD12,BGPD13
 .K BGPNUMV
 .S BGPXPNV=""
 .K ^TMP($J)
 .I $D(^BGPINDN(BGPXPX,1)) X ^BGPINDN(BGPXPX,1)
 .;now get each individual measure and set value
 .S BGPXPN=0 F  S BGPXPN=$O(^BGPCTRL(BGPXPFYC,55,BGPXPMI,11,BGPXPN)) Q:BGPXPN'=+BGPXPN  D
 ..S BGPXPMID=$P(^BGPCTRL(BGPXPFYC,55,BGPXPMI,11,BGPXPN,0),U,1)
 ..I '$D(BGPXPDAT(BGPXPMID)) S BGPXPDAT(BGPXPMID)=BGPXPPD
 ..S $P(BGPXPDAT(BGPXPMID),U,11)=BGPXPMID
 ..S $P(BGPXPDAT(BGPXPMID),U,12)=$P(^BGPCTRL(BGPXPFYC,55,BGPXPMI,11,BGPXPN,0),U,3)
 ..S X=""
 ..X ^BGPCTRL(BGPXPFYC,55,BGPXPMI,11,BGPXPN,1)
 ..S $P(BGPXPDAT(BGPXPMID),U,BGPXPPIE)=X
 ..Q
 .K BGPVAL,BGPG,BGPC,BGPALLED,BGPV,A,B,C,D,E,F,G,H,I,J,K,M,N,O,P,Q,R,S,T,V,W,X,Y,Z
 .K ^TMP($J)
 Q
COUNTY(P) ;EP
 S C=$$COMMRES^AUPNPAT(P,"C")
 I C="" Q ""
 S S=$E(C,1,4)
 S S=$O(^AUTTCTY("C",S,0))
 I S="" Q S
 Q $P($G(^AUTTCTY(S,0)),U,1)
 ;
PRINT ;EP - CALLED FROM XBDBQUE
 S BGPGPG=0,BGPQUIT=""
 S BGPIOSL=$S($G(BGPGUI):55,1:$G(IOSL))
 D HEADER
 W !!,"Community Taxonomy: ",$P(^ATXAX(BGPTAXI,0),U)
 I '$G(BGPALLPT),'$G(BGPSEAT) W !?10,"The following communities are included in this report:",! D
 .S BGPZZ="",BGPN=0,BGPY="" F  S BGPZZ=$O(BGPTAX(BGPZZ)) Q:BGPZZ=""!(BGPQUIT)  S BGPN=BGPN+1,BGPY=BGPY_$S(BGPN=1:"",1:";")_BGPZZ
 .S BGPZZ=0,C=0 F BGPZZ=1:3:BGPN D  Q:$G(BGPQUIT)
 ..I $Y>(BGPIOSL-2) D HEADER Q:$G(BGPQUIT)
 ..W !?10,$E($P(BGPY,";",BGPZZ),1,20),?30,$E($P(BGPY,";",(BGPZZ+1)),1,20),?60,$E($P(BGPY,";",(BGPZZ+2)),1,20)
 ..Q
 Q:BGPQUIT
 I $G(BGPMFITI) W !!?10,"MFI Visit Location Taxonomy Name: ",$P(^ATXAX(BGPMFITI,0),U)
 I $G(BGPMFITI) W !?10,"The following Locations are used for patient visits in this report:",! D
 .S BGPZZ="",BGPN=0,BGPY="" F  S BGPZZ=$O(^ATXAX(BGPMFITI,21,"B",BGPZZ)) Q:BGPZZ=""  S BGPN=BGPN+1,BGPY=BGPY_$S(BGPN=1:"",1:";")_$P($G(^DIC(4,BGPZZ,0)),U)
 .S BGPZZ=0,C=0 F BGPZZ=1:3:BGPN D  Q:$G(BGPQUIT)
 ..I $Y>(BGPIOSL-2) D HEADER Q:$G(BGPQUIT)
 ..W !?10,$E($P(BGPY,";",BGPZZ),1,20),?30,$E($P(BGPY,";",(BGPZZ+1)),1,20),?60,$E($P(BGPY,";",(BGPZZ+2)),1,20)
 ..Q
 Q:BGPQUIT
 I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 W !!,"The following files were created: "
 S BGPX=0 F  S BGPX=$O(^BGPXPN(BGPXPRPT,12,BGPX)) Q:BGPX'=+BGPX!(BGPQUIT)  D
 .I $Y>(IOSL-3) D HEADER Q:BGPQUIT
 .W !?5,$P(^BGPXPN(BGPXPRPT,12,BGPX,0),U)
 K BGPX,BGPQUIT
 Q
HEADER ;EP
 G:'BGPGPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0),'$D(ZTQUEUED) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BGPQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S BGPGPG=BGPGPG+1
 I $G(BGPGUI) W "ZZZZZZZ",!  ;maw
 W $P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",BGPGPG,!
 W $$CTR("*** IHS 2009 Comprehensive National GPRA Export ***",80),!
 W !,$$CTR($$RPTVER^BGP9BAN,80)
 W !,$$CTR("Date Export Run: "_$$FMTE^XLFDT(DT),80)
 W !,$$CTR("Site where Run: "_$P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("Report Generated by: "_$$USR,80)
 S X="Time Period: "_$$FMTE^XLFDT(BGPXPBD)_" to "_$$FMTE^XLFDT(BGPXPNDT) W !,$$CTR(X,80),!
 W $TR($J("",80)," ","-")
 Q
