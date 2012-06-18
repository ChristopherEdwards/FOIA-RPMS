PSONEW2 ;IHS/DSD/JCM - displays new rx information for edit ;19-Oct-2010 13:05;SM
 ;;7.0;OUTPATIENT PHARMACY;**32,37,46,71,94,124,139,157,1005,1006,1009**;DEC 1997
 ;External reference to ^PSDRUG supported by DBIA 221
 ;External reference to ^DPT supported by DBIA 10035
 ;External reference to PSOUL^PSSLOCK supported by DBIA 2789
 ; This routine displays the entered new rx information and
 ; asks if correct, if not allows editing of the data.
 ;------------------------------------------------------------
 ; Modified - IHS/CIA/PLS - 01/02/04 - EP, EN1+2 and DISPLAY+3
 ;          - IHS/MSC/PLS - 10/05/07 - Line RX52 - added call to APSPFNC3
 ;                          09/27/10 - Line RX52+1 Added call to KILLOCM^PSORN52
 ;                          10/19/10 - Added RX52E line tag
EP ; IHS/CIA/PLS - 01/02/04 - Check for DUE Questionnarie
 ;N APFLAG S APFLAG="N" D ^APSPQ  ; PLS 06/21/04 COMMENTED OUT
START ;
 S (PSONEW("DFLG"),PSONEW2("QFLG"))=0
 D STOP
 D DISPLAY ; Displays information
 ;Copay exemption checks
 S PSONEWFF=1 K PSOANSQ,PSOANSQD S PSOCPZ("DFLG")=0,PSONEW("NEWCOPAY")=0 I $P($G(^PS(53,+$G(PSONEW("PATIENT STATUS")),0)),"^",7)'=1,$G(DUZ("AG"))="V" S PSOFLAG=1 D COPAY^PSOCPB W !
 I $G(PSOCPZ("DFLG")) K PSONEWFF,PSOANSQD,PSOCPZ("DFLG"),PSONEW("NEWCOPAY") S DIRUT="",PSONEW("DFLG")=1 D ASKX G END
 ;iF MILL BILL, AND COPAY (*******TEST THE COPAY CHECK)
 I $G(PSONEW("NEWCOPAY")),$$DT^PSOMLLDT D  I $G(PSOCPZ("DFLG")) K PSONEWFF,PSOANSQD,PSOANSQ,PSOCPZ("DFLG"),PSONEW("NEWCOPAY") S DIRUT="",PSONEW("DFLG")=1 D ASKX G END
 .;New prompts Quit after first '^'
 .I $D(PSOIBQS(PSODFN,"CV")) D CV^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("CV"))) K PSONEW("NEWCOPAY") Q
 .I $D(PSOIBQS(PSODFN,"VEH")) D VEH^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("VEH"))) K PSONEW("NEWCOPAY") Q
 .I $D(PSOIBQS(PSODFN,"RAD")) D RAD^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("RAD"))) K PSONEW("NEWCOPAY") Q
 .I $D(PSOIBQS(PSODFN,"PGW")) D PGW^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("PGW"))) K PSONEW("NEWCOPAY") Q
 .I $D(PSOIBQS(PSODFN,"MST")) D MST^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("MST"))) K PSONEW("NEWCOPAY") Q
 .I $D(PSOIBQS(PSODFN,"HNC")) D HNC^PSOMLLDT I $G(PSOCPZ("DFLG"))!($G(PSOANSQ("HNC"))) K PSONEW("NEWCOPAY")
 K PSOCPZ("DFLG"),PSONEWFF
 D ASK K:$G(PSONEW("DFLG")) PSOANSQ G:PSONEW2("QFLG")!PSONEW("DFLG") END
 S PSORX("EDIT")=1 D EN^PSOORNE1(.PSONEW),FULL^VALM1 G:$G(PSORX("FN")) END  I '$G(PSORX("FN")) S PSONEW("DFLG")=1 K PSOANSQ G END ;D EDIT
 G:'$G(PSONEW("DFLG")) START
 S PSONEW("QFLG")=1,PSONEW("DFLG")=0
END D EOJ
 Q
 ;------------------------------------------------------------
STOP K PSEXDT,X,%DT S PSON52("QFLG")=0
 S X1=PSOID,X2=PSONEW("DAYS SUPPLY")*(PSONEW("# OF REFILLS")+1)\1
 S X2=$S(PSONEW("DAYS SUPPLY")=X2:X2,+$G(PSONEW("CS")):184,1:366)
 I X2<30 D
 . N % S %=$P($G(PSORX("PATIENT STATUS")),"^"),X2=30
 . S:%?.N %=$P($G(^PS(53,+%,0)),"^") I %["AUTH ABS" S X2=5
 D C^%DTC I PSONEW("FILL DATE")>$P(X,".") S PSEXDT=1_"^"_$P(X,".")
 K X1,X2,X,%DT
 Q
DISPLAY ;
 W !!,"Rx # ",PSONEW("RX #")
 W ?23,$E(PSONEW("FILL DATE"),4,5),"/",$E(PSONEW("FILL DATE"),6,7),"/",$E(PSONEW("FILL DATE"),2,3),!,$G(PSORX("NAME")),?30,"#",PSONEW("QTY")
 ; IHS/CIA/PLS - 01/02/04 - Output NDC, AWP,Cost and Triplicate
 W ?36,"NDC ",$S($G(PSONEW("NDC"))]"":PSONEW("NDC"),1:$G(PSODRUG("NDC")))
 I ('$D(IOBON))!('$D(IOBOFF)) S X="IOBON;IOBOFF" D ENDR^%ZISS
 W " ("_$S($G(PSONEW("AWP"))]"":PSONEW("AWP"),$G(PSODRUG("AWP"))]"":PSODRUG("AWP"),1:IOBON_"NO AWP"_IOBOFF)_")"
 W " ("_$S($G(PSONEW("COST"))]"":PSONEW("COST"),$G(PSODRUG("COST"))]"":PSODRUG("COST"),1:IOBON_"NO COST"_IOBOFF)_")"
 W:$G(PSONEW("TRIP"))]"" " TRIPLICATE SERIAL # "_PSONEW("TRIP")
 I $G(SIGOK),$O(SIG(0)) D  K D G TRN
 .F D=0:0 S D=$O(SIG(D)) W !,SIG(D) Q:'$O(SIG(D))
 E  S X=PSONEW("SIG") D SIGONE^PSOHELP W !,$G(INS1)
TRN ;I $G(PSOPRC) F I=0:0 S I=$O(PRC(I)) Q:'I  W !,PRC(I)
 W !!,$S($G(PSODRUG("TRADE NAME"))]"":PSODRUG("TRADE NAME"),1:PSODRUG("NAME"))
 W !,PSONEW("PROVIDER NAME"),?25,PSORX("CLERK CODE"),!,"# of Refills: ",PSONEW("# OF REFILLS"),!
 ; IHS/CIA/PLS - 01/02/04 - Output Manufacturer, Lot # and Expiration Date
 N EXPDT S EXPDT=$$FMTE^XLFDT($G(PSONEW("EXPIRATION DATE")),"5DZ") S:'$P(EXPDT,"/",2) EXPDT=$P(EXPDT,"/")_"/"_$P(EXPDT,"/",3)
 I APSPMAN=1 D
 .W !,"Drug Mfg: ",$G(PSONEW("MANUFACTURER")),?35,"Exp Date: ",$G(EXPDT)
 .W ?58,"Lot #: ",$G(PSONEW("LOT #"))
 E  I APSPMAN=2 D
 .W !,?35,"Exp Date: ",$G(EXPDT)
 Q
 ;
ASK ;
 K DIR,X,Y S DIR("A")="Is this correct"
 S DIR(0)="Y",DIR("B")="YES" D ^DIR K DIR I $D(DIRUT) S PSONEW("DFLG")=1 G ASKX
ASK1 I Y D  S PSONEW2("QFLG")=1
 .S:$G(PSONEW("MAIL/WINDOW"))["W" BINGCRT=Y,BINGRTE="W"
 .D:+$G(PSEXDT)
 ..S Y=PSONEW("FILL DATE") X ^DD("DD") W !!,$C(7),Y_" fill date is greater than possible expiration date of " S Y=$P(PSEXDT,"^",2) X ^DD("DD") W Y_"."
 .D DCORD K RORD,^TMP("PSORXDC",$J)
ASKX I $D(DIRUT) D
 .I +$G(PSEXDT) K DIRUT S (PSONEW2("QFLG"),PSONEW2("DFLG"),PSONEW("DFLG"),Y)=1
 K X,Y,DIRUT,DTOUT,DUOUT
 D:+$G(PSEXDT) PAUSE^VALM1
 Q
DCORD ;dc rxs and pending orders after new order is entered
 F RORD=0:0 S RORD=$O(^TMP("PSORXDC",$J,RORD)) Q:'RORD  D @$S($P(^TMP("PSORXDC",$J,RORD,0),"^")="P":"PEN",1:"RX52")
 K RORD
 Q
PEN ;pending ^tmp("psorxdc",$j,rord,0)="p^"_rord_"^"_msg
 S $P(^PS(52.41,RORD,0),"^",3)="DC",^PS(52.41,RORD,4)=$P(^TMP("PSORXDC",$J,RORD,0),"^",3)
 K ^PS(52.41,"AOR",PSODFN,+$P($G(^PS(52.41,RORD,"INI")),"^"),RORD)
 D EN^PSOHLSN($P(^PS(52.41,RORD,0),"^"),"OC",$P(^TMP("PSORXDC",$J,RORD,0),"^",3),"D") W $C(7),!," -Pending Order was discontinued..."
 D PSOUL^PSSLOCK(RORD_"S") K ^TMP("PSORXDC",$J,RORD,0)
 Q
 ; IHS/MSC/PLS - 10/05/07 - Restructured RX52 to process auto RTS/Delete
RX52 ;rxs in file 52 ^tmp("psorxdc",$j,rord,0)=52^rord^msg^rea^act^sta^dnm^apsprts
 I $P(^TMP("PSORXDC",$J,RORD,0),U,9) D KILLOCM^PSORN52(+RORD) G RX52E  ;IHS/MSC/PLS - 09/27/10 - Removed chronic med flag
 I $P(^TMP("PSORXDC",$J,RORD,0),U,8) D
 .D EN^APSPFNC3(RORD)
 .W !," -Rx "_$P(^PSRX(RORD,0),"^")_" has been auto RTS/Deleted...",!
 E  D
 .S PSCAN($P(^PSRX(RORD,0),"^"))=RORD_"^"_$P(^TMP("PSORXDC",$J,RORD,0),"^",4)
 .S MSG=$P(^TMP("PSORXDC",$J,RORD,0),"^",3),REA=$P(^(0),"^",4),ACT=$P(^(0),"^",5)
 .N PSONOOR S PSONOOR="D",DUP=1,DA=RORD D CAN^PSOCAN K PSONOOR
 .W !," -Rx "_$P(^PSRX(RORD,0),"^")_" has been discontinued...",!
RX52E K PSOSD($P(^TMP("PSORXDC",$J,RORD,0),"^",6),$P(^TMP("PSORXDC",$J,RORD,0),"^",7))
 D PSOUL^PSSLOCK(RORD) K ^TMP("PSORXDC",$J,RORD,0)
 Q
 ;
EDIT ;
 S PSORX("EDIT")=1
 D ^PSONEW3
 S PSONEW("DFLG")=$S($G(PSORX("DFLG")):1,1:0)
 Q
 ;
EOJ ;
 K PSONEW2,PSORX("EDIT"),PSORX("DFLG"),PSOEDIT
 Q
 ;
EN1(PSONEW2) ; Entry point to just display and ask if okay
 S PSONEW("DFLG")=0
 ; IHS/CIA/PLS - 01/06/04 - Set NDC, AWP, and COST array variables
 S:$G(PSONEW2("NDC"))]"" PSONEW("NDC")=PSONEW2("NDC")
 S:$G(PSONEW2("AWP"))]"" PSONEW("AWP")=PSONEW2("AWP")
 S:$G(PSONEW2("COST"))]"" PSONEW("COST")=PSONEW2("COST")
 I $G(^PSRX(PSONEW2("IRXN"),0))']"" S PSONEW("DFLG")=1 G EN1X
 S PSOX=^PSRX(PSONEW2("IRXN"),0),PSONEW("TRADE NAME")=$G(^("TN")),PSONEW("FILL DATE")=$P($G(^(2)),"^",2)
 S PSONEW("RX #")=$P(PSOX,"^"),PSORX("NAME")=$P(^DPT($P(PSOX,"^",2),0),"^")
 S PSONEW("QTY")=$P(PSOX,"^",7),PSODRUG("NAME")=$P(^PSDRUG($P(PSOX,"^",6),0),"^"),PSONEW("# OF REFILLS")=$P(PSOX,"^",9)
 S PSORX("CLERK CODE")=$P(^VA(200,$P(PSOX,"^",16),0),"^")
 S:$G(PSONEW("PROVIDER NAME"))="" PSONEW("PROVIDER NAME")=$P(^VA(200,$P(PSOX,"^",4),0),"^")
 S PSONEW("SIG")=$P($G(^PSRX(PSONEW2("IRXN"),"SIG")),"^")
 D DISPLAY
 D ASK
 I PSONEW("DFLG")=1 S PSONEW2("DFLG")=1
EN1X ;
 Q
