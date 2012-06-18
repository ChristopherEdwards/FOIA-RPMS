AZAXSND ; IHS/PHXAO/AEF - Re-send several AZ Medicaid batches to AHCCCS  
 ;;1.0;ANNE'S SPECIAL ROUTINES;;MAR 19, 2004
 ;;
DESC ;
 ;;
 ;;This routine contains code from routines ABMERSND and ABMEF10 and
 ;;is used to gather up bills from more than one batch and re-create an
 ;;EMC file for submission to AHCCCS.
 ;;
 ;;Only batches with an export of UB-92-E V4 and Insurer of Arizona
 ;;Medicaid can be selected.
 ;
EN ;----- MAIN ENTRY POINT
 ;
 ;
 S ABMP("INS")=$$INS("ARIZONA MEDICAID")
 I ABMP("INS")'>0  D
 . S ABMP("INS")=0
 . W !?5,"CAN'T FIND 'ARIZONA MEDICAID' IN INSURER FILE"
 . W !?5,"CANNOT CONTINUE!!!"
 Q:'ABMP("INS")
 ;
 Q
INS(X) ;
 ;----- CHECK FOR INSURER IN INSURER FILE
 ;   
 ;      INPUT:
 ;      X  =  INSURANCE COMPANY NAME
 ;      
 ;      OUTPUT:
 ;      Y  =  INSURANCE COMPANY IEN
 ;      
 N DIC,Y
 S DIC="^AUTNINS("
 S DIC(0)="I"
 D ^DIC
 Q +Y
 ;
 ;
 ;----- OLD CODE BELOW THIS LINE -----
START ;  *** THIS IS OLD CODE ***
 ;START HERE
 I '$D(ABMP("INS")) D
 .S ABMP("INS")=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),"^",4)
 .I 'ABMP("INS") D
 ..S DIC="^AUTNINS("
 ..S DIC(0)="AEMQ"
 ..D ^DIC
 ..Q:Y<0
 ..S ABMP("INS")=+Y
 .S ABMP("ITYPE")=$P($G(^AUTNINS(ABMP("INS"),2)),"^",1)
 I 'ABMP("INS") D  Q
 .W !,"Insurer NOT identified.",!
 .S DIR="E"
 .D ^DIR
 .K DIR
 .Q
 S ABMP("FTYPE")=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",4)
 S:ABMP("FTYPE")="" ABMP("FTYPE")="H"
 D OPEN
 I $G(POP) W !,"File could not be created/opened.",! Q
 S DIE="^ABMDTXST(DUZ(2),"
 S DA=ABMP("XMIT")
 S DR=".14///"_ABMFN
 D ^DIE
 ;
LOOP ;
 ; LOOP THROUGH BILLS
 S ABMP("L#")=0
 S ABMEF("BATCH#")=0
 S ABMP("MP")=1
 K ABMR,ABMRT
 D ^ABMER01
 I $$RCID^ABMERUTL(ABMP("INS"))="00400" U 0 W !,"BATCH #",ABMR(1,170),!
 U 0 W !,"Writing bills to file.",!
 S ABMEF("LINE")=ABMREC(1)
 D WRITE
 S ABMP("OLDFN")=0
 S ABMP("OBTYP")=0
 S ABMP("ORD")=0
 F  S ABMP("ORD")=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),2,ABMP("ORD"))) Q:'ABMP("ORD")  D
 .S ABMP("BDFN")=+^ABMDTXST(DUZ(2),ABMP("XMIT"),2,ABMP("ORD"),0)
 .Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))
 .Q:$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),"^",4)="X"
 .S ABMBIL0=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))
 .S ABMP("BTYP")=$P(ABMBIL0,U,2)
 .S ABMP("LDFN")=$P(ABMBIL0,U,3)
 .S ABMP("VTYP")=$P(ABMBIL0,U,7)
 .I ABMP("BTYP")'=ABMP("OBTYP")!(ABMP("LDFN")'=ABMP("OLDFN")) D
 ..;new code patch #1
 ..I $$RCID^ABMERUTL(ABMP("INS"))=61044,$G(ABMEF("BATCH#")) Q
 ..;end new code
 ..S ABMEF("BATCH#")=ABMEF("BATCH#")+1
 ..I ABMP("OBTYP") D
 ...D ^ABMER95
 ...S ABMEF("LINE")=ABMREC(95)
 ...D WRITE
 ..D ^ABMER10
 ..S ABMEF("LINE")=ABMREC(10)
 ..D WRITE
 ..S ABMP("OBTYP")=ABMP("BTYP")
 ..S ABMP("OLDFN")=ABMP("LDFN")
 .W "."
 .K ABMR
 .D ^ABMER20
 .S ABMEF("LINE")=ABMREC(20)
 .D WRITE
 .K ABMR
 .D ^ABMER30
 .F I=1:1:3 D
 ..I $D(ABMREC(30,I)) D
 ...S ABMEF("LINE")=ABMREC(30,I)
 ...D WRITE
 ..I $D(ABMREC(31,I)) D
 ...S ABMEF("LINE")=ABMREC(31,I)
 ...D WRITE
 .K ABMR
 .D ^ABMER40
 .F I=1:1:3 D
 ..I $D(ABMREC(40,I)) D
 ...S ABMEF("LINE")=ABMREC(40,I)
 ...D WRITE
 .I $D(^ABMDBILL(DUZ(2),ABMP("BDFN"),53))!($D(^ABMDBILL(DUZ(2),ABMP("BDFN"),55))) D
 ..D ^ABMER41
 ..F I=1:1:3 D
 ...I $D(ABMREC(41,I)) D
 ....S ABMEF("LINE")=ABMREC(41,I)
 ....D WRITE
 .; If inpatient
 .I $E(ABMP("BTYP"),1,2)=11 D
 ..K ABMR
 ..D ^ABMER50
 ..S I=0
 ..F  S I=$O(ABMREC(50,I)) Q:'I  D
 ...S ABMEF("LINE")=ABMREC(50,I)
 ...D WRITE
 ..Q:+$G(ABMR(50,40))=100
 ..K ABMR
 ..D ^ABMER60
 ..S I=0
 ..F  S I=$O(ABMREC(60,I)) Q:'I  D
 ...S ABMEF("LINE")=ABMREC(60,I)
 ...D WRITE
 .; If outpatient
 .I $E(ABMP("BTYP"),1,2)'=11 D
 ..K ABMR
 ..D ^ABMER61
 ..S I=0
 ..F  S I=$O(ABMREC(61,I)) Q:'I  D
 ...S ABMEF("LINE")=ABMREC(61,I)
 ...D WRITE
 .K ABMR
 .D ^ABMER70
 .S ABMEF("LINE")=ABMREC(70)
 .D WRITE
 .K ABMR
 .D ^ABMER80
 .F I=1:1:3 D
 ..I $D(ABMREC(80,I)) D
 ...S ABMEF("LINE")=ABMREC(80,I)
 ...D WRITE
 .K ABMR
 .D ^ABMER90
 .S ABMEF("LINE")=ABMREC(90)
 .D WRITE
 .S DIE="^ABMDBILL(DUZ(2),"
 .S DA=ABMP("BDFN")
 .S DR=".04////B;.16////A;.17////"_ABMP("XMIT")
 .D ^DIE
 K ABMR
 D ^ABMER95
 S ABMEF("LINE")=ABMREC(95)
 D WRITE
 K ABMR
 D ^ABMER99
 S ABMEF("LINE")=ABMREC(99)
 D WRITE
 D CLOSE
 W !!,"Finished.",!!
 K ABME,ABM,ABMEF,ABMREC,ABMR,ABMRV,ABMFN,ABMLF,ABMLNUM,ABMPATH
 Q
 ;
OPEN ;
 ; OPEN FILE
 I ABMP("FTYPE")="K" D
 .S POP=0
 .S DIC="^DIZ(8980,"
 .S DIC(0)="AEMQL"
 .S DIC("S")="I $P(^(0),""^"",5)=DUZ"
 .D ^DIC
 .K DIC
 .I Y<0 S POP=1 Q
 .S ABMP("FILE#")=+Y
 .S ABMFN=$P(Y,"^",2)
 .I $O(^DIZ(8980,ABMP("FILE#"),2,0)) D
 ..W !,*7,"Data already exists in this file!",!
 ..S DIR("A")="Delete"
 ..S DIR(0)="Y"
 ..S DIR("B")="NO"
 ..D ^DIR
 ..K DIR
 ..I Y=1 K ^DIZ(8980,ABMP("FILE#"),2)
 ..I Y=0 S POP=1
 I ABMP("FTYPE")="H" D
 .S DIR(0)="9002274.5,.47"
 .S DIR("A")="Enter Path"
 .S DIR("B")=$P($G(^ABMDPARM(DUZ(2),1,4)),"^",7)
 .D ^DIR K DIR
 .I Y["^" S POP=1 Q
 .S ABMPATH=Y
 .S ABMRCID=$P(^AUTNINS(ABMP("INS"),0),"^",8)
 .I $L(ABMRCID)<5 D
 ..S ABMRCID=$E("00000",1,5-$L(ABMRCID))_ABMRCID
 .S ABMJDT=$$JDT^XBFUNC(DT)
 .S ABMLF=$G(^ABMNINS("ALF",ABMP("INS")))
 .S:$P(ABMLF,".",2)'=ABMJDT ABMLF=""
 .S ABMLNUM=+$E($P(ABMLF,".",1),7,8)
 .S ABMLNUM=ABMLNUM+1
 .I ABMLNUM<10 S ABMLNUM="0"_ABMLNUM
 .S ABMFN="E"_ABMRCID_ABMLNUM_"."_ABMJDT
 . S DIR(0)="F^1:15"
 . S DIR("A")="Enter File Name: "
 . S DIR("B")=ABMFN
 .D ^DIR K DIR
 .I Y["^" S POP=1 Q
 .S ABMFN=Y
 .D OPEN^%ZISH("EMCFILE",ABMPATH,ABMFN,"W")
 .S:'POP ^ABMNINS("ALF",ABMP("INS"))=ABMFN
 I ABMP("FTYPE")="M" D
 .S ABMP("DOMAIN")=$P($G(^ABMDPARM(DUZ(2),1,3)),"^",9)
 .I 'ABMP("DOMAIN") W !,"MM SEND TO DOMAIN NOT DEFINED.",! S POP=1 Q
 .S ABMP("DOMAIN")=$P(^DIC(4.2,ABMP("DOMAIN"),0),"^",1)
 .S XMSUB="EMC FILE FROM "_$P($G(^AUTTLOC(DUZ(2),0)),"^",2)
 .S XMDUZ=DUZ
 .D XMZ^XMA2
 .I XMZ<1 S POP=1 Q
 .S ABMFN="MAIL MSG# "_XMZ
 .W !!,"MAIL MSG# ",XMZ," CREATED.",!
 Q
 ;
WRITE ;
 ;WRITE RECORD TO FILE
 I ABMP("FTYPE")="K" D
 .S ABMP("L#")=ABMP("L#")+1
 .S ^DIZ(8980,ABMP("FILE#"),2,ABMP("L#"),0)=ABMEF("LINE")
 I ABMP("FTYPE")="H" D
 .U IO
 .W ABMEF("LINE"),$C(13,10)
 .U IO(0)
 I ABMP("FTYPE")="M" D
 .S ABMP("L#")=ABMP("L#")+1
 .S ^XMB(3.9,XMZ,2,ABMP("L#"),0)=ABMEF("LINE")
 Q
 ;
CLOSE ;
 ;CLOSE FILE
 I ABMP("FTYPE")="H" D ^%ZISC
 I ABMP("FTYPE")="K" S ^DIZ(8980,ABMP("FILE#"),2,0)="^^"_I_"^"_I_"^"_DT
 I ABMP("FTYPE")="M" D
 .S ^XMB(3.9,XMZ,2,0)="^3.92A^"_ABMP("L#")_"^"_ABMP("L#")_"^"_DT
 .S XMY(".5@"_ABMP("DOMAIN"))=""
 .D ENT1^XMD
 Q
