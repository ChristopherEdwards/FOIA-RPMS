AGMPHLU ; IHS/SD/TPF - MPI HLO MSG UTILITIES ; 12/15/2007
 ;;7.2;IHS PATIENT REGISTRATION;**1,3**;MAY 20, 2010;Build 4
 Q
 ;
DIRCON ;EP - SEND A DIRECT CONNECT VQQ-Q02
 W !!,"ENTER PATIENT YOU WISH TO QUERY THE MPI FOR:"
 W !
 D PTLK^AG
 Q:'$D(DFN)
 D CREATMSG^AGMPIHLO(DFN,"VTQ",,.SUCCESS)
 I SUCCESS D  Q
 .W !!,"Query message "_$G(SUCCESS)_" has been sent to the MPI"
 W !,"Unable to query patient "_$P(^DPT(DFN,0),U)_" on MPI"
 Q
 ;
A28 ;EP - SEND A A28 ADD A PATIENT
 W !!,"ENTER PATIENT YOU WISH TO ADD TO THE MPI:"
 D PTLK^AG
 Q:'$D(DFN)
 D CREATMSG^AGMPIHLO(DFN,"A28",,.SUCCESS)
 I SUCCESS D  Q
 .W !!,"A28 Message "_SUCCESS_" has been sent to add patient "_$P(^DPT(DFN,0),U)_" to the MPI." H 2
 .;05/29/2013 - KJH - TFS8109 - This was causing an extra message to be sent to EDR.
 .;S X="AG REGISTER A PATIENT",DIC=101,INDA=DFN
 .;D EN^XQOR
 W !,"Unable to create A28 to add patient "_$P(^DPT(DFN,0),U)_" to MPI"
 Q
 ;
A08 ;EP - SEND AN A08 UPDATE
 W !!,"EXAMPLE OF AN A08 UPDATE"
 D PTLK^AG
 Q:'$D(DFN)
 D CREATMSG^AGMPIHLO(DFN,"A08","",.SUCCESS)
 I SUCCESS D  Q
 .W !!,"A08 Message "_SUCCESS_" has been sent to update patient "_$P(^DPT(DFN,0),U)_" on the MPI." H 2
 .;05/29/2013 - KJH - TFS8109 - This was causing an extra message to be sent to EDR.
 .;S X="AG UPDATE A PATIENT",DIC=101,INDA=DFN
 .;D EN^XQOR
 W !,"Unable to create A08 to update patient "_$P(^DPT(DFN,0),U)_" on MPI"
 Q
 ;
VISITMSG ;EP - CREATE A NEW A01 OR A03
 W !!,"CREATE A VISIT HL7 MESSAGE"
 D PTLK^AG
 Q:'$D(DFN)
 K DIR
 S DIR(0)="SO^A:ADMISSION;D:DISCHARGE;CIN:CHECK-IN;COUT:CHECK-OUT"
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 ;CHECK IN - CHECK OUT
 I Y="CIN"!(Y="COUT") D  Q  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 .S EVENT=$S(Y="CIN":4,1:5)
 .K DIR
 .S DIR(0)="D^::RE"
 .S DIR("A")="ENTER CHECK-"_$S(Y="CIN":"IN",1:"OUT")_" DATE"
 .D ^DIR
 .D NOW^%DTC S NOW=%
 .Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 .S DATE=Y
 .D CREATE^AGMPHL01(EVENT,DFN,DATE,.SUCCESS)
 .I SUCCESS D  Q
 ..W !!,$S(EVENT=1:"A01",1:"A03")_" Message IEN "_SUCCESS_" has been sent to update patient"
 ..W !,$P(^DPT(DFN,0),U)_" last treated date on the MPI." H 2
 .W !,"Unable to create "_$S(EVENT=1:"A01",1:"A03")_" to update patient "_$P(^DPT(DFN,0),U)_" on MPI"
 ;
 ;ADMISSION - DISCHARGE
 S TYPE=$S(Y="A":1,1:3)
 K DIR
 S DIR(0)="D^::RE"
 S DIR("A")="ENTER MOVEMENT DATE"
 D ^DIR
 D NOW^%DTC S NOW=%
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 S DATETIME="T"_Y
 D CREATE^AGMPHL03(DFN,TYPE,DATETIME,.SUCCESS)
 I SUCCESS D  Q
 .W !!,$S(TYPE=1:"A01",1:"A03")_" Message IEN "_SUCCESS_" has been sent to update patient"
 .W !,$P(^DPT(DFN,0),U)_" last treated date on the MPI." H 2
 W !,"Unable to create "_$S(TYPE=1:"A01",1:"A03")_" to update patient "_$P(^DPT(DFN,0),U)_" on MPI"
 Q
 ;
A40 ;EP - SEND A40 MERGE FROM/TO
PT1 ;ASK FOR FROM PATIENT
 W !,"ENTER PATIENT TO KEEP:"
 D PTLK^AG
 Q:'$D(DFN)
 S DFN2=DFN
 W !!,"ENTER PATIENT TO MERGE TO PATIENT ABOVE:"
 D PTLK^AG
 Q:'$D(DFN)
 S DFN1=DFN
 I $G(^DPT(DFN1,-9))'=DFN1 D  G A40
 .W !,"THIS PATIENT HAS NOT BEEN MERGED TO FIRST PATIENT SUCCESSFULLY!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 D CREATMSG^AGMPIHLO(DFN2,"A40",DFN1,.SUCCESS)
 I SUCCESS D  Q
 .W !!,"A40 Message "_SUCCESS_" has been sent to merge patient"
 .W !,$P(^DPT(DFN1,0),U)_" to patient "_$P(^DPT(DFN2,0),U) H 2
 W !,"Unable to merge "_$P(^DPT(DFN1,0),U)_" to patient "_$P(^DPT(DFN2,0),U)_" on MPI" H 2
 Q
 ;
MFNMFK ;EP - PROCESS MFN MESSAGE AND CREATE A MFK RESPONSE
 K DIR,DIC,DA,DIE,DIR
 W !!
 S DIC(0)="AQEM"
 S DIC("S")="I $G(^HLB(Y,2))[""MFN"""
 S DIC="^HLB("
 D ^DIC
 Q:Y<0
 D PROC^AGMPHMFN(+Y,.SUCCESS)
 K DIR,DIC,DA,DIE,DIR
 I SUCCESS D  Q
 .W !!,"MFK Message "_SUCCESS_" has been sent to the MPI" H 2
 W !,"Unable to create MFK message." H 2
 Q
 ;
RESEND ;EP - RESEND MESSAGE(S)
RSAGAIN ;EP
 N FRMSGIEN,TOMSGIEN,DIC,DT,NEWIEN,ERROR,Y
 N MPIDIREC,TOTEVENT,GRDTOTAL,ERRORS
FROM ;EP - ASK FROM
 S (MPIDIREC,TOTEVENT,GRDTOTAL,ERRORS)=0
 W !!
 S DIC=778
 S DIC(0)="AEQM"
 S DIC("A")="SELECT FROM MESSAGE: "
 ;S DIC("W")="W $P(^(0),U,20)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("W")="W $P($G(^(0)),U,5)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("S")="I $P($G(^(0)),U,4)=""O"",($P($G(^(0)),U,20)'=""SU""),($P($G(^(0)),U,5)=""MPI"")"
 D ^DIC
 Q:Y<0
 S FRMSGIEN=+Y
TO ;EP - ASK TO
 S DIC=778
 S DIC(0)="AEQM"
 S DIC("A")="SELECT TO MESSAGE: "
 S DIC("B")=FRMSGIEN
 ;S DIC("W")="W $P(^(0),U,20)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("W")="W $P($G(^(0)),U,5)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("S")="I $P($G(^(0)),U,4)=""O"",($P($G(^(0)),U,20)'=""SU""),$P($G(^(0)),U,5)=""MPI"""
 D ^DIC
 Q:Y<0
 S TOMSGIEN=+Y
 I FRMSGIEN>TOMSGIEN D  G FROM
 .W !,"FROM MSG ID CAN NOT BE GREATER THAN THE TO MSG ID" H 2
 S MSGIEN=FRMSGIEN-.01
 F  S MSGIEN=$O(^HLB(MSGIEN)) Q:MSGIEN>TOMSGIEN  D
 .S LINK=$P($G(^HLB(MSGIEN,0)),U,5)
 .Q:LINK'="MPI"
 .S DIREC=$P($G(^HLB(MSGIEN,0)),U,4)
 .Q:DIREC'="O"
 .S COMSTAT=$P($G(^HLB(MSGIEN,0)),U,20)
 .Q:COMSTAT="SU"
 .;B "S+"
 .S EVENT=$P($P($G(^HLB(MSGIEN,2)),U,4),"~",2)
 .; 05/24/2013 - KJH - TFS8008 - Remove extraneous locks on the HLO globals.
 .S NEWIEN=$$RESEND^HLOAPI3(MSGIEN,.ERROR)
 .;B "S+"
 .D PARSE^AGMPIACK(.DATA,NEWIEN,.HLMSTATE)
 .S DFN=$G(DATA(2,4,3,1,1))
 .S GRDTOTAL=GRDTOTAL+1
 .I '$D(ERROR) D
 ..W !,"MESSAGE RESENT, NEW NUMBER: "_NEWIEN
 ..W !?17,"OLD NUMBER: ",MSGIEN
 ..D NOW^%DTC S Y=% X ^DD("DD") W !,"SENT AT ",Y
 ..S TOTEVENT(EVENT)=$G(TOTEVENT(EVENT))+1
 .E  D  Q
 ..S ERRORS(ERROR)=$G(ERRORS(ERROR))+1
 ;.05/29/2013 - KJH - TFS8109 - Since this is a 'resend', we do not need to kick off these protocols again.
 ;.IF NO ERROR KICK PROTOCOL OFF
 ;.I EVENT="A28" D  Q
 ;..S X="AG REGISTER A PATIENT",DIC=101,INDA=DFN
 ;..D EN^XQOR
 ;.I EVENT="A08" D
 ;..S X="AG UPDATE A PATIENT",DIC=101,INDA=DFN
 ;..D EN^XQOR
 W !!,"TOTAL MESSAGES PROCESSED: ",GRDTOTAL
 S ERROR=""
 F  S ERROR=$O(ERRORS(ERROR)) Q:ERROR=""  D
 .W !,ERRORS(ERROR)," ",ERROR
 S EVENT=""
 F  S EVENT=$O(TOTEVENT(EVENT)) Q:EVENT=""  D
 .W !,TOTEVENT(EVENT)," ",EVENT
 G RSAGAIN
 Q
 ;
CONDT(DATE) ;EP - CONVERT FM DATE INTO 2009-04-14 00:00:00
 N NEWDATE,TIME
 S TIME=$P(DATE,".",2)
 S DATE=$P(DATE,".")
 S TIME="."_$$FILLSTR^AGMPIHL1(TIME,6,"L",0)
 S DATE=DATE_TIME
 S NEWDATE=(1700+$E(DATE,1,3))
 S DATE=$TR(DATE,"."," ") S DATE=$E(DATE,4,14),NEWDATE=NEWDATE_DATE
 S NEWDATE=$E(NEWDATE,1,4)_"-"_$E(NEWDATE,5,6)_"-"_$E(NEWDATE,7,8)_" "_$E(NEWDATE,10,11)_":"_$E(NEWDATE,12,13)_":"_$E(NEWDATE,14,15)
 Q NEWDATE
