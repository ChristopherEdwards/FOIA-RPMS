ABMDE2 ; IHS/ASDST/DMJ - Edit Page 2 - PAYERS ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**6,8**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - 10/29/02 - V2.5 P2 - NHA-0402-180088
 ;     Modified so it would allow the deletion of insurer from page 2
 ;     if accident or work related claim.
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM15307/IM14092
 ;    Modified to display MSP error on page if applicable
 ;
 ; IHS/SD/SDR - v2.5 p8 - task 8
 ;   Added code to display replacment insurer
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM19040
 ;   Added ability to delete insurers all the time
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM20593
 ;   Changed default for MSP reason to NO MSP ON FILE
 ;
OPT ;
 K ABM,ABME,ABMV,ABMG
 S ABMZ("NUM")=""
 ;S ABMP("OPT")="DPVNJBQ"  ;abm*2.6*6 NOHEAT
 S ABMP("OPT")="ADPVNJBQ"  ;abm*2.6*6 NOHEAT
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),8)),U,3)!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U)="Y") S ABMP("OPT")="A"_ABMP("OPT")
 I $D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",1))=10 D
 .I $O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",1))="" D
 ..S ABMP("OPT")=$P(ABMP("OPT"),"P")_$P(ABMP("OPT"),"P",2)
 S ABMZ("PG")="1,2,7"
 D DISP
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8)="" ABMP("DFLT")="P"
 I ABMZ("NUM")=0 D
 .S ABMP("DFLT")="Q"
 .S ABMP("OPT")="BQ"
 D:$D(ABMW)=10 ^ABMDWARN
 W !
 D SEL^ABMDEOPT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!("VPAD"'[$E(Y))
 S ABM("DO")=$S($E(Y)="C":"^ABMDECK",$E(Y)="V":"V1^ABMDE2A",$E(Y)="A":"A1^ABMDEML",$E(Y)="D":"D1",1:"^ABMDE2P")
 D @ABM("DO")
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!$D(ABMP("OVER"))
 G OPT
 ;
 ; *********************************************************************
DISP ;
 S ABMZ("TITL")="INSURERS"
 S ABMZ("PG")=2
 I $D(ABMP("DDL")),$Y>(IOSL-9) D  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  I 1
 . D PAUSE^ABMDE1
 E  D SUM^ABMDE1
 I $P(ABMP("C0"),U,8)="" G INSR
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 D ^ABMDE2X
 D ^ABMDE2X1
 ;start old code abm*2.6*8 HEAT34042
 ;W:$D(ABMP("VTYP",999)) ?68,"Prof-Comp"
 ;W !,"To: ",$P(ABMV("X5"),U)
 ;W ?40,"Bill Type...: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",12)
 ;W:$D(ABMP("VTYP",999)) ?68,"========="
 ;W !?4,$P(ABMV("X5"),U,2)
 ;W ?40,"Proc. Code..: ",$S($P(ABMV("X6"),U,2)="C":"CPT4",$P(ABMV("X6"),U,2)="A":"ADA",1:"ICD9")
 ;I $D(ABMP("VTYP",999)) D
 ;.I '$D(ABMP("FLAT")) D  Q
 ;..W ?68,$S($P(ABMV("X6"),U,2)="C":"CPT4",$P(ABMV("X6"),U,2)="A":"ADA",1:"ICD9")
 ;.W ?68,$S($P(ABMP("FLAT"),U,5)="C":"CPT4",$P(ABMP("FLAT"),U,5)="A":"ADA",1:"ICD9")
 ;W !?4,$P(ABMV("X5"),U,3)
 ;W ?40,"Export Mode.: "
 ;I +ABMV("X6") W $P($G(^ABMDEXP(+ABMV("X6"),0)),U)
 ;W:$G(ABMP("VTYP",999)) ?68,$P(^ABMDEXP(ABMP("VTYP",999),0),U)
 ;W !?4,$P(ABMV("X5"),U,4)
 ;W ?40,"Flat Rate...: ",$S(+$P(ABMV("X6"),U,5):$J($P(ABMV("X6"),U,5),4,2),1:"N/A")
 ;W:$D(ABMP("VTYP",999)) ?68,$S('$D(ABMP("FLAT")):"N/A",$P(ABMP("FLAT"),U,4)]"":$J($P(ABMP("FLAT"),U,4),4,2),1:"N/A")
 ;end old code start new code HEAT34042
 I $P(ABMV("X6"),U,6)="Y" D
 .W:$D(ABMP("VTYP",999)) ?68,"Prof-Comp"
 .W !,"To: ",$P(ABMV("X5"),U)
 .W ?40,"Bill Type...: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",12)
 .W:$D(ABMP("VTYP",999)) ?68,"========="
 .W !?4,$P(ABMV("X5"),U,2)
 .W ?40,"Proc. Code..: ",$S($P(ABMV("X6"),U,2)="C":"CPT4",$P(ABMV("X6"),U,2)="A":"ADA",1:"ICD9")
 .I $D(ABMP("VTYP",999)) D
 ..I '$D(ABMP("FLAT")) D  Q
 ...W ?68,$S($P(ABMV("X6"),U,2)="C":"CPT4",$P(ABMV("X6"),U,2)="A":"ADA",1:"ICD9")
 ..W ?68,$S($P(ABMP("FLAT"),U,5)="C":"CPT4",$P(ABMP("FLAT"),U,5)="A":"ADA",1:"ICD9")
 .W !?4,$P(ABMV("X5"),U,3)
 .W ?40,"Export Mode.: "
 .I +ABMV("X6") W $P($G(^ABMDEXP(+ABMV("X6"),0)),U)
 .W:$G(ABMP("VTYP",999)) ?68,$P(^ABMDEXP(ABMP("VTYP",999),0),U)
 .W !?4,$P(ABMV("X5"),U,4)
 .W ?40,"Flat Rate...: ",$S(+$P(ABMV("X6"),U,5):$J($P(ABMV("X6"),U,5),4,2),1:"N/A")
 .W:$D(ABMP("VTYP",999)) ?68,$S('$D(ABMP("FLAT")):"N/A",$P(ABMP("FLAT"),U,4)]"":$J($P(ABMP("FLAT"),U,4),4,2),1:"N/A")
 I ($P(ABMV("X6"),U,6)="")!($P(ABMV("X6"),U,6)="N") D  ;if null or NO
 .W:$D(ABMP("VTYP",999)) ?54,"Prof-Comp"
 .W !,"To: ",$P(ABMV("X5"),U)
 .W:'$D(ABMP("VTYP",999)) ?40,"Bill Type...: ",$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),"^",12)
 .W:$D(ABMP("VTYP",999)) ?54,"========="
 .W !?4,$P(ABMV("X5"),U,2)
 .W:'$D(ABMP("VTYP",999)) ?40,"Proc. Code..: ",$S($P(ABMV("X6"),U,2)="C":"CPT4",$P(ABMV("X6"),U,2)="A":"ADA",1:"ICD9")
 .I $D(ABMP("VTYP",999)) D
 ..I '$D(ABMP("FLAT")) D  Q
 ...W ?40,"Proc. Code..: ",$S($P(ABMV("X6"),U,2)="C":"CPT4",$P(ABMV("X6"),U,2)="A":"ADA",1:"ICD9")
 ..W ?40,"Proc. Code..: ",$S($P(ABMP("FLAT"),U,5)="C":"CPT4",$P(ABMP("FLAT"),U,5)="A":"ADA",1:"ICD9")
 .W !?4,$P(ABMV("X5"),U,3)
 .I '$D(ABMP("VTYP",999)) W ?40,"Export Mode.: " I +ABMV("X6") W $P($G(^ABMDEXP(+ABMV("X6"),0)),U)
 .I $G(ABMP("VTYP",999)) W ?40,"Export Mode.: ",$P(^ABMDEXP(ABMP("VTYP",999),0),U)
 .W !?4,$P(ABMV("X5"),U,4)
 .W:'$D(ABMP("VTYP",999)) ?40,"Flat Rate...: ",$S(+$P(ABMV("X6"),U,5):$J($P(ABMV("X6"),U,5),4,2),1:"N/A")
 .W:$D(ABMP("VTYP",999)) ?40,"Flat Rate...: ",$S('$D(ABMP("FLAT")):"N/A",$P(ABMP("FLAT"),U,4)]"":$J($P(ABMP("FLAT"),U,4),4,2),1:"N/A")
 ;end new code HEAT34042
 S ABMX=""
 S $P(ABMX,".",80)=""
 W !,ABMX,!
 I $D(^AUPNMSP("C",ABMP("PDFN"))) D
 .K ABMMSP,ABMFLAG,ABMMSPSV
 .; get correct entry based on visit date
 .S ABMMSP=9999999,ABMFLAG="",ABMMSPSV=9999999
 .F  S ABMMSP=$O(^AUPNMSP("C",ABMP("PDFN"),ABMMSP),-1) Q:ABMMSP=""  D  Q:ABMFLAG=1
 ..I $G(ABMMSPSV)="" S ABMMSPSV=ABMMSP
 ..I (ABMP("VDT")<ABMMSPSV&(ABMP("VDT")>ABMMSP))!(ABMMSP=ABMP("VDT")) S ABMMSPSV=$O(^AUPNMSP("C",ABMP("PDFN"),ABMMSP,0)),ABMFLAG=1 Q
 ..I ABMP("VDT")=ABMMSP S ABMFLAG=1 Q
 ..S ABMMSPSV=ABMMSP
 .; write the entry with date
 .I ABMFLAG=1 D
 ..K %DT  ;abm*2.6*8
 ..S Y=ABMMSP
 ..D DD^%DT
 ..S ABMMSPDT=Y
 ..K %DT  ;abm*2.6*8
 ..S ABMMSPRS=$S($G(ABMMSPSV)="":"NO REASON ENTERED",$P($G(^AUPNMSP(ABMMSPSV,0)),U,4)'="":$P($G(^AUPNMSP(ABMMSPSV,0)),U,4),1:"NO REASON ENTERED")
 ..W "MSP STATUS AS OF "_ABMMSPDT_": "
 ..I $G(ABMMSPSV)'="",$P($G(^AUPNMSP(ABMMSPSV,0)),U,3)["Y" W "["_ABMMSPRS_"]-"_$$GET1^DIQ(9000037,ABMMSPSV,.04)
 ..E  W "NOT MSP ELIGIBLE"
 ..W !,ABMX,!
 .K ABMFLAG,ABMMSPSV
 K ABMX
 K ABMMSPDT
 ;
INSR ; Insurer Info
 S ABMZ("SUB")=13
 S ABMZ("DR")=";.03////P"
 S ABMZ("ITEM")="Payer"
 S ABMZ("DIC")="^AUTNINS("
 S ABMZ("X")="X"
 I $Y>(IOSL-8) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)
 D HD
 G LOOP
 ;
 ;**********************************************************************
HD ;
 W !?13,"BILLING ENTITY",?39,"STATUS",?52,"POLICY HOLDER"
 W !,?5,"==============================",?37,"==========",?49,"=============================="
 Q
 ;
 ; *********************************************************************
LOOP ;LOOP HERE
 S (ABMZ("LNUM"),ABMZ("NUM"),ABMZ(1),ABMZ("UNBILL"))=0
 S ABM=""
 F ABM("I")=1:1 S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM)) Q:'ABM  D
 .S ABM("XIEN")=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,"C",ABM,""))
 .S ABM("X")=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0),U)
 .D INS
 S ABMZ("DR2")=";.02////"_(ABMZ("LNUM")+1)
 I ABMZ("NUM")=0 W *7,!?5,"*** ERROR: No "_ABMZ("ITEM")_" Exists, at Least One is Required! ***",!
 K ABME
 S ABME("CONT")=""
 S ABM("E")=0
 F  S ABM("E")=$O(ABMG(ABM("E"))) Q:'ABM("E")  D
 . S ABME(ABM("E"))=ABMG(ABM("E"))
 D ^ABMDERR
 K ABME("CONT")
 Q
 ;
 ; *********************************************************************
INS ;
 Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0))
 Q:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0),U,3)=""
 S ABMZ("NUM")=ABM("I")
 S ABM("X0")=^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0)
 S:ABMZ("LNUM")<$P(ABM("X0"),U,2) ABMZ("LNUM")=$P(ABM("X0"),U,2)
 I $Y>(IOSL-5) D PAUSE^ABMDE1 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)  D HD
 I $P(ABM("X0"),U,3)="C" D
 .S ABMZ("UNBILL")=ABMZ("UNBILL")+1
 .S ABMZ("UNBILL",ABM("I"))=""
 S ABMZ(ABM("I"))=$P(^AUTNINS(ABM("X"),0),U)_U_ABM("X")_U_ABM("XIEN")_U_$P(ABM("X0"),U,3,9)
 S Y=ABM("X")
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 D SEL^ABMDE2X
 S ABM("Y0")=""
 S ABM("Y")=$P(ABM("X0"),U,3)
 I ABM("Y")]"" D
 .S ABM("Y0")=$P(^DD(9002274.3013,.03,0),U,3)
 .S ABM("Y0")=$P($P(ABM("Y0"),ABM("Y")_":",2),";",1)
 W !,"[",ABM("I"),"]"
 I +$P(ABMV("X1"),U)=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,$P(ABMZ(ABM("I")),U,3),0)),U),($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,$P(ABMZ(ABM("I")),U,3),0)),U,11)'="") D
 .W ?4,"*"
 .W $P($G(^AUTNINS($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,$P(ABMZ(ABM("I")),U,3),0)),U,11),0)),U)
 E  W ?5,$P(ABMZ(ABM("I")),U)
 W ?37,ABM("Y0")
 W ?49,$P($P(ABMV("X2"),U),";",2)
 I ABM("Y")="I" S ABM("E")=0 F  S ABM("E")=$O(ABME(ABM("E"))) Q:'ABM("E")  S ABMG(ABM("E"))=ABME(ABM("E"))
 S ABM("PRI")=$S($P($G(^AUTNINS(ABM("X"),2)),U)="D":4,"MR"[$P($G(^(2)),U):3,$P($G(^(2)),U)="H":2,1:1)
 S ABM(ABM("PRI"))=""
 Q
 ;
D1 ;EP - Delete Insurer Multiple on claim
 I +$E(Y,2,3)>0&(+$E(Y,2,3)<(ABMZ("NUM")+1)) S Y=+$E(Y,2,3) G D2
 I ABMZ("NUM")=1 S Y=1 G D2
 I ABMZ("NUM")<1 D  G DXIT
 .W !,"There is no ",ABMZ("ITEM")," to delete."
 .H 3
 K DIR S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to Delete"
 S DIR("A")="Sequence Number to DELETE"
 D ^DIR
 K DIR
 G DXIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(Y'>0)
D2 I ABMZ("NUM")=1 W !,"Cannot delete only insurer on claim!" H 1 Q
 W ! S ABMX("ANS")=+Y K DIR S DIR(0)="YO"
 I $P(ABMZ(ABMX("ANS")),U,4)="I" W !,"Cannot delete active insurer!" H 1 Q
 S DIR("A")="Do you wish "_$P(ABMZ(ABMX("ANS")),U,1)_" DELETED"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
D3 I Y=1 D
 .S DA(1)=ABMP("CDFN")
 .S DA=$P(ABMZ(ABMX("ANS")),U,3)
 .S DIK="^ABMDCLM(DUZ(2),"_DA(1)_","_ABMZ("SUB")_","
 .D ^DIK
DXIT K ABMX
 Q
XIT K ABM,ABMG
 Q
