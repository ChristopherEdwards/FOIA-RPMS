BADEPROV ;IHS/SAIC/FJE /MSC/AMF - Dentrix HL7 interface  ;31-Mar-2010 16:38;PLS
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 Q
DISPPROV ; EP for BADE EDR DISP PROV
 ; consolidates FINDPRV and UPLDPROV
 ;
 N WHICH,IEN,NAME,CODE,PCLS,TP,TPX,IP,IPX,NPI,COUNT,TITLE
 N X,%ZIS,IORVON,IORVOFF,VER,PKG,DASH
 S DASH="---------------------------------------------------------------------------------"
 W !!,"This option will display dentists in your RPMS system.",!,"You may include dentists who are inactive, or only active dentists.",!
 S DIR(0)="S^A:All;O:Only Active",DIR("A")="Do you want to display (A)ll dentists or (O)nly active dentists?",DIR("B")="A"
 S DIR("?")="Enter 'A' to include the dentists who have been terminated or inactivated.  Otherwise enter 'O' for only the active dentists" D ^DIR K DIR
 Q:Y=U  S WHICH=Y
 I $E($G(IOST),1,2)'="C-" W !,"Your terminal Type is not defined correctly for this report.",! S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR Q
 S TITLE=$S(WHICH="O":"RPMS-Dentrix Active Provider Upload Display",1:"RPMS-Dentrix All Provider Display")
 S VER="Version "_$G(VER,1.0),PKG=$G(PKG,TITLE)
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF
 I WHICH="A" W !!,"Provider",?32,"Terminated Inactivated",?56,"NPI",?70,"IEN",!,$E(DASH,1,80)
 I WHICH="O" W !!,"Provider",?32,"NPI",?46,"IEN",!,$E(DASH,1,55)
 ;
 S IEN=0,NAME="",COUNT=0
 F  S NAME=$O(^VA(200,"B",NAME)) Q:NAME=""  D
 .S IEN=0 F  S IEN=$O(^VA(200,"B",NAME,IEN)) Q:+IEN'>0  D
 ..Q:'$D(^VA(200,IEN,0))
 ..S PCLS=+$P($G(^VA(200,IEN,"PS")),U,5)  ; Provider Class
 ..S CODE=+$P($G(^DIC(7,PCLS,9999999)),U)     ; IHS Code
 ..Q:CODE'=52  ;Not a Dentist
 ..S NAME=$P($G(^VA(200,IEN,0)),U,1)  ;Provider Name
 ..S TP=$P($G(^VA(200,IEN,0)),U,11) ; Provider has been terminated
 ..S TPX=$S(+TP:"Yes",1:"No")
 ..S IP=$P($G(^VA(200,IEN,"PS")),U,4) ; Provider is inactive
 ..S IPX=$S(+IP:"Yes",1:"No")
 ..S NPI=$P($G(^VA(200,IEN,"NPI")),U,1) ; Provider NPI
 ..I WHICH="O" Q:+TP!+IP!'+NPI
 ..S COUNT=COUNT+1
 ..I WHICH="A" W !,NAME,?32,TPX,?43,IPX,?56,NPI,?70,IEN
 ..I WHICH="O" W !,NAME,?32,NPI,?46,IEN
 W !!,"A total of ",COUNT," providers.",!!
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
 ;
PURGEMAN ;EP - Entry point for manual PURGE from menu
 N PURDT,MSGIEN,PURNOW,QNM,DIR,HMDAYS,TYPE,COUNT,STR
 W !!,"This option will purge all Dentrix messages which are older than a certain date."
 ;
 S HMDAYS=$$GET^XPAR("ALL","BADE EDR DEFAULT PURGE DAYS")
 S:HMDAYS="" HMDAYS=7
PM1 ;
 S DIR(0)="NO^0:100:0",DIR("A")="For how many days would you like to keep messages",DIR("B")=HMDAYS
 S DIR("?")="Enter a number indicating the number of days for message retention.  All older messages will be purged." D ^DIR K DIR
 Q:Y=U  S HMDAYS=Y
PM2 ;
 S DIR(0)="Y",DIR("A")="Do you want to continue with the purge",DIR("B")="No"
 D ^DIR K DIR
 G:Y=U PM1 Q:(X="N")!'Y
PM3 ; 
 S QNM="DENTRIX",COUNT=0
 S PURNOW=$$NOW^XLFDT
 S PURDT=PURNOW-HMDAYS
 S MSGIEN=0 F  S MSGIEN=$O(^HLB(MSGIEN)) Q:+MSGIEN=0  D
 .S STR=$G(^HLB(MSGIEN,0))
 .Q:$P(STR,U,16)>PURDT
 .Q:'$$PM4(MSGIEN)
 .S COUNT=COUNT+1
 .D DELETE^HLOPURGE(MSGIEN)
 W !!,COUNT," messages have been purged. ",!
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
 ; Verifies that message is for DENTRIX
PM4(MSGIEN) ;EP-
 N MSG,RES
 S RES=$$STARTMSG^HLOPRS(.MSG,MSGIEN)
 S RES=RES&($G(MSG("HDR","RECEIVING APPLICATION"))=QNM)
 Q RES
 ;
AC ;DELETE "AC" XREF FOR IEN
 ;EXAMPLE:  ^HLB("AC","Dental^198.45.6.101:5027^DNSDENTRIXDental 1",1)=""
 S (BADE1,BADE2,BADE3)=""
 S BADE1="AC"
 F  S BADE2=$O(^HLB(BADE1,BADE2)) Q:BADE2=""  D
 .S BADE3=0 F  S BADE3=$O(^HLB(BADE1,BADE2,BADE3)) Q:+BADE3<1  D
 ..K:BADE3=BADEIEN ^HLB(BADE1,BADE2,BADE3)
 Q
ADI ;DELETE "AD" XREF FOR "IN" IEN
 ;EXAMPLE:  ^HLB("AD","IN",3)=""
 S (BADE1,BADE2,BADE3)=""
 S BADE1="AD",BADE2="IN"
 S BADE3=0 F  S BADE3=$O(^HLB(BADE1,BADE2,BADE3)) Q:+BADE3<1  D
 .K:BADE3=BADEIEN ^HLB(BADE1,BADE2,BADE3)
 Q
ADO ;DELETE "AD" XREF FOR "OUT" IEN
 ;EXAMPLE:  ^HLB("AD","OUT",3090819.1143,3)=""
 S (BADE1,BADE2,BADE3,BADE4)=""
 S BADE1="AD",BADE2="OUT"
  F  S BADE3=$O(^HLB(BADE1,BADE2,BADE3)) Q:BADE3=""  D
 .S BADE4=0 F  S BADE4=$O(^HLB(BADE1,BADE2,BADE3,BADE4)) Q:+BADE4<1  D
 ..K:BADE4=BADEIEN ^HLB(BADE1,BADE2,BADE3,BADE4)
 Q
QUEUEI ;DELETE "QUEUE" XREF FOR IEN
 ;EXAMPLE:  ^HLB("QUEUE","IN",3100218.220529,"RPMS-DEN","DFT","P03",1)=""
 S (BADE1,BADE2,BADE3,BADE4,BADE5,BADE6,BADE7)=""
 S BADE1="QUEUE"
 F  S BADE2=$O(^HLB(BADE1,BADE2)) Q:BADE2=""  D
 .S BADE3="" F  S BADE3=$O(^HLB(BADE1,BADE2,BADE3)) Q:BADE3=""  D
 ..S BADE4="" F  S BADE4=$O(^HLB(BADE1,BADE2,BADE3,BADE4)) Q:BADE4=""  D
 ...S BADE5="" F  S BADE5=$O(^HLB(BADE1,BADE2,BADE3,BADE4,BADE5)) Q:BADE5=""  D
 ....S BADE6="" F  S BADE6=$O(^HLB(BADE1,BADE2,BADE3,BADE4,BADE5,BADE6)) Q:BADE6=""  D
 .....S BADE7="" F  S BADE7=$O(^HLB(BADE1,BADE2,BADE3,BADE4,BADE5,BADE6,BADE7)) Q:BADE7=""  D
 ......K:BADE7=BADEIEN ^HLB(BADE1,BADE2,BADE3,BADE4,BADE5,BADE6,BADE7)
 Q
QUEUEO ;DELETE "QUEUE" XREF FOR IEN
 ;EXAMPLE:  ^HLB("QUEUE","IN",3100218.220529,"RPMS-DEN","DFT","P03",1)=""
 S (BADE1,BADE2,BADE3,BADE4,BADE5,BADE6,BADE7)=""
 S BADE1="QUEUE",BADE2="OUT"
 F  S BADE3=$O(^HLB(BADE1,BADE2,BADE3)) Q:BADE3=""  D
 .S BADE4="" F  S BADE4=$O(^HLB(BADE1,BADE2,BADE3,BADE4)) Q:BADE4=""  D
 ..S BADE5="" F  S BADE5=$O(^HLB(BADE1,BADE2,BADE3,BADE4,BADE5)) Q:BADE5=""  D
 ...K:BADE5=BADEIEN ^HLB(BADE1,BADE2,BADE3,BADE4,BADE5)
 Q
TOTCNT  ;Displays Patient Count Info
 ;Loop through the patients and send data
 N BADEDFN,BADECNTD,BADECNTA,BADEAPAT,BADEDPAT,BADEA41,BADEBPAT
 S (BADEDFN,BADECNTD,BADECNTA,BADEAPAT,BADEDPAT,BADEA41,BADEBPAT)=0
 F  S BADEDFN=$O(^DPT(BADEDFN)) Q:+BADEDFN'>0  D
 .S BADECNTD=BADECNTD+1
 .I '$D(^AUPNPAT(BADEDFN,0)) S BADEAPAT=BADEAPAT+1 Q
 .I '$D(^AUPNPAT(BADEDFN,41)) S BADEA41=BADEA41+1 Q
 .S BADENAME=$P($G(^DPT(BADEDFN,0)),"^",1)
 .Q:BADENAME=""
 .I '$D(^DPT("B",BADENAME,BADEDFN)) S BADEBPAT=BADEBPAT+1 Q
 S BADEDFN=0 F  S BADEDFN=$O(^AUPNPAT(BADEDFN)) Q:+BADEDFN'>0  D
 .S BADECNTA=BADECNTA+1
 .I '$D(^DPT(BADEDFN,0)) S BADEDPAT=BADEDPAT+1 Q
 ; Display statistics
 Q:$E($G(IOST),1,2)'="C-"
 S VER="Version "_$G(VER,1.0),PKG=$G(PKG,"RPMS-Dentrix Patient Count Display")
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF
 W !!,"Patient Counts"
 W !,"----------------------------------------------------------------------"
 W !,"VA PATIENT (DPT) COUNT:  ",BADECNTD
 W !,"PATIENT (AUPNPAT) COUNT:  ",BADECNTA
 W !,"AUPNPAT ENTRY MISSING DPT COUNT:  ",BADEDPAT
 W !,"DPT ENTRY MISSING AUPNPAT COUNT:  ",BADEAPAT
 W !,"AUPNPAT ENTRY MISSING A DIVISION/HRCN (A41) COUNT:  ",BADEA41
 W !,"DPT MISSING ""B"" XREF COUNT:  ",BADEBPAT
 W !!
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
