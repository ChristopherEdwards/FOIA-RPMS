APSPNE4 ; IHS/DSD/ENM - OUTPATIENT LABEL ASK OPTION 11/10/93 ;23-Sep-2011 15:54;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1005,1008,1013**;Sep 23, 2004;Build 33
 ; Modified - IHS/CIA/PLS - 01/21/04
 ;            IHS/MSC/PLS - 04/30/09
 ;                        - 09/16/2011 - Added PWH prompt
OUT ;
 S:'$D(PPL) PPL=$G(PSORX("PSOL",1))
 I $G(PSORX("PSOL",1))]"" S PPL=PSORX("PSOL",1)
OPT ;EP - ASK PRINT OPTION
 D CHKFDT^APSPFUNC(.PPL) S PSORX("PSOL",1)=PPL
 I 'PPL,'$D(RXRS) D  Q
 .W !!,"No other labels to print. Exiting..."
 N PMI ;IHS/DSD/ENM 05/22/01
 S PMI("IN")="" ;IHS/DSD/ENM 05/22/01
 S X="APSEPPIM" X ^%ZOSF("TEST") I $T S PMI("IN")=1 ;IHS/DSD/EM 05/22/01
 S APSPZ1=$P($G(^APSPCTRL(PSOSITE,0)),"^",12),APSPZ2=$S(APSPZ1=1:"Summary",1:""),APSPZ3=$S(APSPZ1=1:"B=Sum+Cpro",1:"") ;IHS/DSD/ENM 08/01/96
 S DIR(0)="SA^P:Print Label;Q:Queue Labels;C:Labels & Chronic Med Profile;R:Refill Rx;M:Med Sheet;MS:Med Sheet+Summary;W:PWH;CA:Cancel Rx" ;_";"_APSPZ2_";"_APSPZ3
 I APSPZ2]""!APSPZ3]"" S DIR(0)=DIR(0)_";S:"_APSPZ2_";B:"_APSPZ3
 S DIR(0)=DIR(0)_$S($P(PSOPAR,"^",23):";H:Hold",1:"")_$S($P(PSOPAR,"^",24):";SU:Suspense",1:"")
 S DIR("A")="Print/Queue/Cpro/Med sheet/pWh/"_$S($P(PSOPAR,U,23):"Hold/",1:"")_$S($P(PSOPAR,U,24):"SUspend/",1:"")_"Refill/CAncel"_"/"_APSPZ2_"/"_APSPZ3_"/'^'=Exit: ",DIR("B")="P" ;IHS/OKCAO/POC 6/9/98
 S DIR("?",1)="Enter 'P' to Immediately Print Label(s) only",DIR("?",2)="Enter 'Q' to Queue Label(s) to a Printer",DIR("?",3)="Enter 'C' to Print Label(s) and Chronic Med Profile"
 S DIR("?",4)="Enter 'R' to Refill Prescription",DIR("?",5)="Enter 'CA' to Cancel Prescription",DIR("?",6)="*Enter 'S' to Print Labels + Summary Labels"
 S DIR("?",7)="*Enter 'B' to Print Label(s) + Chronic Med Profiles + Summary Labels"
 S DIR("?",8)="*Note: Summary labels depend on parameter setting in APSP CONTROL FILE"
 S DIR("?",9)="ENTER 'M' to print label(s) and patient med sheet" ;IHS/OKCAO/POC 6/9/98
 S DIR("?",10)="ENTER 'MS' to print label(s), patient med sheet, and summary label" ;IHS/OKCAO/POC 6/9/98
 S DIR("?",11)="Enter 'W' to print a Patient Wellness Handout"
 S:$P(PSOPAR,U,23) DIR("?",11)="Enter 'H' to hold label until Rx can be filled"
 S:$P(PSOPAR,U,24) DIR("?",12)="Enter 'SU' to suspend labels to print later"
 S DIR("?")="ENTER '^' TO EXIT"
 W !!
COME D ^DIR S PX=Y,APSPX1=""
 I $D(DUOUT) D  G CQ:PX=U
 .D EXCK
 .D:PX=U AL^PSOLBL("UT")
 K DIR
OUT1 ;
 I $E(PX,1)="R" D  G OUT
 .W !,*7,"<The Refill Function is currently unavailable!>" Q
 .S PSORX("DO REFILL")=1,PX="",APSPZIT=1 D
 ..I $G(PSORX("DO REFILL")),'PSORX("REFILL") W !,*7,"No prescriptions with refills allowed ",! G OUT ;IHS/DSD/ENM 02/14/97
 ..I $G(PSORX("DO REFILL")),$D(PSOSD)>1,PSORX("REFILL") W !,"Now entering Refill Option",! N PSOOPT S PSOOPT=4 D ^PSOREF
 ..K APSPFLG,PSORX("DO REFILL") ;IHS/DSD/ENM 02/14/97
 ..W !,*7,"<--- RETURNING TO 'NEW RX' OPTION",! Q
 I $E(PX,1,2)="CA" D  G OUT
 .W !,*7,"<The Cancel Function is currently unavailable!>" Q
 .D ^APSPCAN W !!
 I "P"[PX S APSQSTOP=0 D P^PSORXL K APSQSTOP G CQ ;IHS/OKCAO/POC 01/09/2001 VARIABLE SET FOR SIGNATURE LABEL USED IN APSPLBL AND PSORXL
 ;IHS/ASD/ENM 05/22/01 NEXT TWO LINES CHECK IF PMI'S EXIST
 I "M"[PX,PMI("IN")=1 S APSQSTOP=0 D EN^APSEPPIM,P^PSORXL K APSQSTOP G CQ ;IHS/ASDS/ENM 03/26/01 IHS/OKCAO/POC 01/09/2001 APSQSTOP USED TO DECIDE IF PRINT SIGNATURE LABEL IN RTN APSPLBL AND PSORXL ;IHS/ASDS/ENM 03/26/01
 I "M"[PX,PMI("IN")="" S APSQSTOP=0 D P^PSORXL K APSQSTOP G CQ ;IHS/ASDS/ENM 03/26/01 IHS/OKCAO/POC 01/09/2001 APSQSTOP USED TO DECIDE IF PRINT SIGNATURE LABEL IN RTN APSPLBL AND PSORXL ;IHS/ASDS/ENM 03/26/01
 I "W"[PX D EN2^APCHPWHG(2,PSODFN),P^PSORXL G CQ  ;IHS/MSC/PLS - 09/16/2011
 I "C"[PX S APSQSTOP=0 D PCOPY,P^PSORXL,CPCK K APSQSTOP G CQ ;IHS/OKCAO/POC 01/09/2001 APSQSTOP SET FOR PRINTING SIGNATURE LABEL IN RTNS PSORXL AND APSPLBL
 I "S"[PX K ARRAY S APSQSTOP=0 D P^PSORXL,EP2^APSPSLBL:$D(ARRAY(1)) K APSQSTOP G CQ ;IHS/DSD/ENM 08/02/96 IHS/OKCAO/POC 01/09/2001 APSQSTOP USED TO PRINT SIGNATURE LABEL IN RTNS APSPLBL AND PSORXL
 ;IHS/ASD/ENM 05/22/01 NEXT TWO LINES CHECK IF PMI EXIST
 I "MS"[PX,PMI("IN")=1 K ARRAY S APSQSTOP=0 D EN^APSEPPIM,P^PSORXL,EP2^APSPSLBL:$D(ARRAY(1)) K APSQSTOP G CQ ;IHS/ASDS/ENM/POC 03/26/2001 APSQSTOP USED TO DECIDE TO PRINT SIGNATURE LABEL IN RTNS APSPLBL AND PSORXL
 I "MS"[PX,PMI("IN")="" K ARRAY S APSQSTOP=0 D P^PSORXL,EP2^APSPSLBL:$D(ARRAY(1)) K APSQSTOP G CQ ;IHS/ASDS/ENM 03/26/01 IHS/OKCAO/POC 01/09/2001 APSQSTOP USED TO DECIDE TO PRINT SIGNATURE LABEL IN RTNS APSPLBL AND PSORXL ;IHS/ASDS/ENM 03/26/01
 I "B"[PX K ARRAY S APSQSTOP=0 D PCOPY,P^PSORXL,EP2^APSPSLBL:$D(ARRAY(1)),CPCK K APSQSTOP G CQ ;IHS/DSD/ENM 08/02/96 IHS/OKCAO/POC 01/09/2001 APSQSTOP USED TO DECIDE IF PRINT SIGNATURE LABEL IN RTNS APSPLBL AND PSORXL
 I "Q"[PX S APSPXQ="1" D Q^PSORXL G CQ ;IHS/DSD/ENM 10/16/97
 I PX="H" D H1^PSORXL G CQ  ;IHS/CIA/PLS - 01/29/04
 I PX="SU" D S^PSORXL G CQ  ;IHS/CIA/PLS - 01/29/04
 S PX=PX_"^PSORXL" F PI=1:1 Q:$P(PPL,",",PI)=""  S DA=$P(PPL,",",PI),ZD=$P(^PSRX(DA,2),"^",2),RXF=0 D @PX
CQ K NEW1,NEW11 D ^%ZISC
 U IO(0) K APSEFDT,APSZFDT,ARRAY,SPFL1,AL,PSD,PS(53),PC,PL,PY,PI,PNM,DFN,NOW,PR,IOP,RX,SIG,SIGD,RXM,RX0,RX2,PPL ;S PPL=""
 K APFLAG,APSP,APSP1,APSP2,APSPCTR,APSPD,APSPDR,APSPDZ,APSPM0,APSPPDY,APSPPLOT,APSPPMF,APSPRFD,APSPRXX,APSPZDT,APSPZRN,APSPDY,APSPLOT,APSPMF,APSPZ,APSPZ1,APSPZ2,APSPZ3,APSPZZ,APSHRN
 K APSPZZN ;IHS/DSD/ENM 07/31/96
 Q
PCOPY ;ASK CM COPIES
 D COPIES^APSPCP2
 Q
CPCK ;CHECK CHRONIC MED PRINT STATUS
 I $G(APSPCP)=2 D INIT^APSPCP2 G CQ ;IHS/DSD/ENM 09/05/96
 I $G(APSPCPP)]"" S ZTIO=APSPCPP D EMPRT^APSPCP2 G CQ
 I APSPCP=1,$G(APSPCPP)']"" D INIT^APSPCP2 G CQ
 Q
EXCK ;IHS/DSD/ENM 02/23/96 QUESTION USER EXIT ACTION
 ;If a user exits before label prints release and label print info
 ;will not be set.
 W !,*7,?30,"Warning!!",!
 W ?10,"Exiting at this point will result in an incomplete",!
 W ?10,"prescription entry. To avoid future problems with",!
 W ?10,"this Rx, PRINT the label and then destroy the label",!
 W ?10,"after it prints.",!
 S DIR(0)="Y",DIR("B")="NO",DIR("A")="Do you still want to Exit" D ^DIR K DIR
 I Y=0 S PX="P" Q
 S PX="^"
 Q
