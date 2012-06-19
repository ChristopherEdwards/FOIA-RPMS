PSOORNE4 ;BIR/SAB-display renew RXs from backdoor ;09-Dec-2010 09:13;SM
 ;;7.0;OUTPATIENT PHARMACY;**11,27,32,36,46,75,96,103,99,117,131,1008,1009**;DEC 1997
 ;^SC DBIA-10040;^PS(50.7-2223;^PS(50.606-2174;^PS(50.607-2221;^PS(51.2-2226;^PSDRUG-221;^PS(55-2228
 ; Modified - IHS/CIA/PLS - 01/27/04 - Added display of IHS Fields
 ;            IHS/MSC/PLS - 03/13/08 - Added line RMK+10
 ;                          01/23/09 - Added line RMK+11
 ;                          12/09/10 - Added line VER+17
EN(PSONEW) N FLD,LST,VALMCNT
EN1 K PSOQUIT D:$G(PSONEW("ENT"))'>0  I $G(PSORENW("POE"))=1 S PSOREEDT=1 D SV
 .S PSOREEDT=1 D SV
 .K PSONEW("DOSE"),PSONEW("UNITS"),PSONEW("DOSE ORDERED"),PSONEW("ROUTE")
 .K PSONEW("SCHEDULE"),PSONEW("DURATION"),PSONEW("CONJUNCTION"),PSONEW("NOUN"),PSONEW("VERB"),PSOPRC,PSONEW("ODOSE")
RDD D DSPL,^PSOLMRN D:$G(PKI1)=2 DCP^PSOPKIV1 I $G(PSORX("FN")) S VALMBCK="Q" K PSOREEDT Q
 G:'$G(PSOQUIT) RDD
 Q
 ; IHS/CIA/PLS - 01/27/04 - Commented out next to extend range to include zero
EDT ;D KV^PSOVER1 S DIR("A")="Select Field to Edit by number",DIR(0)="LO^1:"_$S($G(PSOREEDT):10,1:8)
 D KV^PSOVER1 S DIR("A")="Select Field to Edit by number",DIR(0)="LO^0:"_$S($G(PSOREEDT):10,1:8)
 D ^DIR I $D(DTOUT)!($D(DUOUT)) D KV^PSOVER1 S VALMBCK="" Q
EDTSEL S PSOLM=1,(PSONEW("DFLG"),PSONEW("FIELD"),PSONEW3)=0
 ; IHS/CIA/PLS - 01/27/04 - Changed to $L to include zero value
 ;I +Y S LST=Y D HLDHDR^PSOLMUTL S PSOEDT=1 D  Q:$G(PSODIR("DFLG"))!($G(PSODIR("QFLG")))
 I $L(Y) S LST=Y D HLDHDR^PSOLMUTL S PSOEDT=1 D  Q:$G(PSODIR("DFLG"))!($G(PSODIR("QFLG")))
 .F FLD=1:1:$L(LST,",") Q:$P(LST,",",FLD)']""  D @(+$P(LST,",",FLD)) Q:$G(PSODIR("DFLG"))!($G(PSODIR("QFLG")))
 E  S VALMBCK="" D FULL^VALM1
 Q
ACP I $G(PKI1)=1 D REA^PSOPKIV1 G:$G(PSONEW("QFLG"))=1 PKI
 D INST2^PSORENW S PSOFROM1=1 D:$D(^XUSEC("PSORPH",DUZ))!('$P(PSOPAR,"^",2)) VER
 K PSOFROM1
PKI I $G(PSONEW("QFLG")) S POERR("DFLG")=1,VALMBCK="R" K PSONEW2 Q
 I PSONEW("ENT")>0,$G(NEWDOSE) K NEWDOSE G EN1 Q
 S PSORX("FN")=1 D EN^PSORN52(.PSONEW)
 D RNPSOSD^PSOUTIL,ACP1^PSOORNE6,^PSOBUILD S VALMBCK="Q"
 Q
VER1(PSONEW) ;
VER S (PSONEW("DFLG"),PSONEW("QFLG"))=0 I PSONEW("ENT")=0 D  K PSOORRNW,PSOFROM1 I PSONEW("DFLG")=1 S (PSONEW("QFLG"),POERR("DFLG"))=1 Q
 .S (PSOREEDT,PSOORRNW)=1 W !!,"Dosing Instruction Missing!!",!
 .S PSONEW("IRXN")=PSONEW("OIRXN") K VALMSG D FULL^VALM1 W !,"Drug: "_PSODRUG("NAME") D
 ..I $O(SIG(0)) D  Q
 ...F I=1:1 Q:$G(SIG(I))']""  W !,SIG(I)
 ..I $P($G(^PSRX(PSONEW("OIRXN"),"SIG")),"^")]"" S X=$P(^PSRX(PSONEW("OIRXN"),"SIG"),"^") D SIGONE^PSOHELP W !,$E($G(INS1),2,250)
 .K DIRUT W ! D DOSE^PSODIR(.PSONEW) Q:$G(PSONEW("DFLG"))  D EN^PSOFSIG(.PSONEW)
 .I PSONEW("ENT")>0,$O(SIG(0)) S (SIGOK,NEWDOSE)=1
 .I '$G(SPEED),PSONEW("DFLG")=1 S VALMSG="Renewal Request Cancelled!" W:$G(SPEED) !,"Renewal Request Cancelled!" Q:$G(PSONEW("DFLG"))
 .I +$G(PSONEW("ENT"))'>0 K DIRUT Q
 .D INS^PSODIR(.PSONEW),EN^PSOFSIG(.PSONEW),SINS^PSODIR(.PSONEW):$G(^PS(55,PSODFN,"LAN"))
 .S:'$G(SPEED)&(PSONEW("DFLG")=1) VALMSG="Renewal Request Cancelled!" W:$G(SPEED)&(PSONEW("DFLG")=1) !,"Renewal Request Cancelled!"
 .I $G(SPEED),'$G(PSONEW("DFLG")) D KV^PSOVER1 S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR,KV^PSOVER1 K X,Y
 I +$G(PSONEW("ENT"))'>0 G VER
 D STOP^PSORENW1 I +$G(PSEXDT) D  S PSORENW("QFLG")=1
 .S Y=PSORENW("FILL DATE") X ^DD("DD") S VALMSG=Y_" fill date is past expiration date "
 .S Y=$P(PSEXDT,"^",2) X ^DD("DD") S VALMSG=VALMSG_Y_"."
 I '$$SCREEN^APSPMULT(+$G(PSORENW("DRUG IEN")),,1) S PSORENW("QFLG")=1,VALMSG="^Sorry, this drug is not currently available in this facility" Q  ;IHS/MSC/JDS - 12/09/10 - MDF
 Q
DSPL G:$G(PSONEW("ENT"))>0 DSP
 S PSONEW("ENT")=0 F I=0:0 S I=$O(^PSRX(PSONEW("OIRXN"),6,I)) Q:'I  S DOSE=^PSRX(PSONEW("OIRXN"),6,I,0) D
 .S PSONEW("ENT")=PSONEW("ENT")+1,PSONEW("DOSE",PSONEW("ENT"))=$P(DOSE,"^")
 .S PSONEW("UNITS",PSONEW("ENT"))=$P(DOSE,"^",3),PSONEW("DOSE ORDERED",PSONEW("ENT"))=$P(DOSE,"^",2),PSONEW("ROUTE",PSONEW("ENT"))=$P(DOSE,"^",7)
 .S PSONEW("SCHEDULE",PSONEW("ENT"))=$P(DOSE,"^",8),PSONEW("DURATION",PSONEW("ENT"))=$P(DOSE,"^",5),PSONEW("CONJUNCTION",PSONEW("ENT"))=$P(DOSE,"^",6)
 .S PSONEW("NOUN",PSONEW("ENT"))=$P(DOSE,"^",4),PSONEW("VERB",PSONEW("ENT"))=$P(DOSE,"^",9)
 .I $G(^PSRX(PSONEW("OIRXN"),6,I,1))]"" S PSONEW("ODOSE",PSONEW("ENT"))=^PSRX(PSONEW("OIRXN"),6,I,1)
 .K DOSE
DSP D ^PSOORUT2 K ^TMP("PSOPO",$J) S IEN=0 D:$G(PKI1) L1^PSOPKIV1
 D DIN^PSONFI(PSODRUG("OI"),$S($G(PSODRUG("IEN")):PSODRUG("IEN"),1:""))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                 Rx#: "_PSONEW("NRX #")
 I +$G(PSODRUG("OI")) D
 .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="      Orderable Item: "_$P(^PS(50.7,+$G(PSODRUG("OI")),0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^")_NFIO
 .S:NFIO["<DIN>" NFIO=IEN_","_($L(^TMP("PSOPO",$J,IEN,0))-4)
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="     "_$S($D(^PSDRUG("AQ",PSODRUG("IEN"))):"      CMOP ",1:"           ")_"Drug: "_PSODRUG("NAME")_NFID
 S:NFID["<DIN>" NFID=IEN_","_($L(^TMP("PSOPO",$J,IEN,0))-4)
 S:$G(PSONEW("TN"))]"" IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          Trade Name: "_$G(PSONEW("TN"))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="      Patient Status: "_$P(PSONEW("PTST NODE"),"^"),PSONEW("PATIENT STATUS")=$P(PSONEW("PTST NODE"),"^")
 S (PSOID,Y)=PSONEW("ISSUE DATE") X ^DD("DD") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (1)     Issue Date: "_Y
 S Y=PSONEW("FILL DATE") X ^DD("DD") S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (2)      Fill Date: "_Y
 I PSONEW("ENT")=0 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=$S($G(PSOREEDT):"  (9)",1:"     ")_"         Dosage:" G PAT
 F I=1:1:PSONEW("ENT") D
 .I '$G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("VERB",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                Verb: "_$G(PSONEW("VERB",I))
 .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=$S($G(PSOREEDT)&(I'>1):"  (9)",1:"     ")_"         Dosage: "_$S($E(PSONEW("DOSE",I),1)="."&($G(PSONEW("DOSE ORDERED",I))):"0",1:"")_PSONEW("DOSE",I)
 .S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_$S($G(PSONEW("UNITS",I))]"":" ("_$P(^PS(50.607,PSONEW("UNITS",I),0),"^")_")",1:"")
 .I $P($G(^PS(55,PSODFN,"LAN")),"^"),'$G(PSONEW("DOSE ORDERED",I)) D
 ..S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="   Oth. Lang. Dosage: "_$G(PSONEW("ODOSE",I))
 .I $G(PSONEW("DOSE ORDERED",I)),$G(PSONEW("VERB",I))]"" D
 ..S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                Verb: "_$G(PSONEW("VERB",I))
 ..S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="      Dispense Units: "_$S($E($G(PSONEW("DOSE ORDERED",I)),1)=".":"0",1:"")_$G(PSONEW("DOSE ORDERED",I))
 ..S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                Noun: "_$G(PSONEW("NOUN",I))
 .I $G(PSONEW("ROUTE",I)) S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="               Route: "_$P(^PS(51.2,PSONEW("ROUTE",I),0),"^")
 .S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="            Schedule: "_PSONEW("SCHEDULE",I)
 .I $G(PSONEW("DURATION",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="           *Duration: "_$G(PSONEW("DURATION",I))
 .I $G(PSONEW("CONJUNCTION",I))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="         Conjunction: "_$S($G(PSONEW("CONJUNCTION",I))="A":"AND",$G(PSONEW("CONJUNCTION",I))="T":"THEN",$G(PSONEW("CONJUNCTION",I))="X":"EXCEPT",1:"")
PAT S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)=$S($G(PSOREEDT):" (10)",1:"     ")_"Pat Instruction:" D INS2^PSOBKDED
 S RXN=PSONEW("OIRXN") D INST1^PSORENW
 I $O(PRC(0)) D PC1^PSOORNE5
 K RXN S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                 SIG:"
 I $G(SIGOK),$O(SIG(0)) D  K SG,MIG
 .F I=0:0 S I=$O(SIG(I)) Q:'I  F SG=1:1:$L(SIG(I)) D
 ..S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P(SIG(I)," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",21)=" "
 ..S:$P(SIG(I)," ",SG)'="" ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P(SIG(I)," ",SG)
 E  D
 .S X=$S($G(PSONEW("SIG"))]"":PSONEW("SIG"),1:$P($G(^PSRX(PSONEW("OIRXN"),"SIG")),"^")) D SIGONE^PSOHELP S SIG=$E($G(INS1),2,250)
 .F SG=1:1:$L(SIG) S:$L(^TMP("PSOPO",$J,IEN,0)_" "_$P(SIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOPO",$J,IEN,0)," ",21)=" " S:$P(SIG," ",SG)'="" ^TMP("PSOPO",$J,IEN,0)=$G(^TMP("PSOPO",$J,IEN,0))_" "_$P(SIG," ",SG)
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="         Days Supply: "_PSONEW("DAYS SUPPLY")_$S($L(PSONEW("DAYS SUPPLY"))=1:" ",1:"")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                 QTY"_$S($G(PSODRUG("UNIT"))]"":" ("_PSODRUG("UNIT")_")",1:" (  )")_": "_PSONEW("QTY")
 I $D(^PSDRUG("AQ",PSODRUG("IEN"))),$P($G(^PSDRUG(PSODRUG("IEN"),5)),"^")]"" D
 .S $P(RN," ",79)=" ",IEN=IEN+1
 .S ^TMP("PSOPO",$J,IEN,0)="            QTY DSP MSG: "_$P(^PSDRUG(PSODRUG("IEN"),5),"^")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (3)   # of Refills: "_PSONEW("# OF REFILLS")_$S($L(PSONEW("# OF REFILLS"))=1:" ",1:"")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (4)        Routing: "_$S($G(PSORENW("MAIL/WINDOW"))["W":"WINDOW",1:"MAIL")
 S:$G(PSONEW("METHOD OF PICK-UP"))]""&($P(PSOPAR,"^",12)) IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="    Method of Pickup: "_PSONEW("METHOD OF PICK-UP")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (5)         Clinic: "_$S($G(PSONEW("CLINIC")):$P(^SC(PSONEW("CLINIC"),0),"^"),1:"")
 S $P(RN," ",31)=" ",IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (6)       Provider: "_PSONEW("PROVIDER NAME")_$E(RN,$L(PSONEW("PROVIDER NAME"))+1,31) K RN
 I $G(PSONEW("COSIGNING PROVIDER"))]"" S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="        Cos-Provider: "_$P(^VA(200,PSONEW("COSIGNING PROVIDER"),0),"^")
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (7)         Copies: "_$S($G(PSONEW("COPIES")):PSONEW("COPIES"),1:1)
RMK S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  (8)        Remarks: "_$S($G(PSONEW("REMARKS"))]"":PSONEW("REMARKS"),1:"")
 S $P(RN," ",35)=" ",IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="   Entry By: "_$P(^VA(200,DUZ,0),"^")_$E(RN,$L($P(^VA(200,DUZ,0),"^"))+1,35)
 ; IHS/CIA/PLS - 01/26/04 - Add IHS Fields to display
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="Enter a zero (0) to edit IHS specific fields."
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                  NDC: "_$$GET1^DIQ(52,PSONEW("OIRXN"),27)
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="                  AWP: "_$$GET1^DIQ(52,PSONEW("OIRXN"),9999999.06)_"       Unit Cost: "_$$GET1^DIQ(52,PSONEW("OIRXN"),17)   ; IHS/CIA/PLS - 01/15/04
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="         Triplicate #: "_$$GET1^DIQ(52,PSONEW("OIRXN"),9999999.14)   ; IHS/CIA/PLS - 01/15/04
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          Bill Status: "_$$EXTERNAL^DILFD(52,9999999.07,,$G(PSONEW("BST")))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="         Manufacturer: "_$G(PSONEW("MANUFACTURER"))_"   Lot #: "_$G(PSONEW("LOT #"))_"  ExpDate: "_$$FMTE^XLFDT($G(PSONEW("EXPIRATION DATE")))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="          Chronic Med: "_$$EXTERNAL^DILFD(52,9999999.02,,$G(PSONEW("CM")))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="       Substitution: "_$$EXTERNAL^DILFD(52,9999999.25,,$G(PSONEW("DAW")))  ;IHS/MSC/PLS - 03/13/08
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="           Cash Due: "_$$EXTERNAL^DILFD(52,9999999.26,,$G(PSONEW("CASH DUE")))   ; IHS/MSC/PLS - 01/23/09
 ;S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="              Insurer: "_$G(PSONEW("INSURER"))
 S IEN=IEN+1,^TMP("PSOPO",$J,IEN,0)="  "
 ; End IHS Fields
 I $G(PSOFDR) S ^TMP("PSOPO",$J,IEN,0)="   Entry By: "_$P(^VA(200,$P(OR0,"^",4),0),"^")_$E(RN,$L($P(^VA(200,$P(OR0,"^",4),0),"^"))+1,35)
 D NOW^%DTC S PSONEW("LOGIN DATE")=$S($P($G(OR0),"^",6):$P($G(OR0),"^",6),1:%) K %,X S Y=PSONEW("LOGIN DATE") X ^DD("DD")
 S ^TMP("PSOPO",$J,IEN,0)=^TMP("PSOPO",$J,IEN,0)_"Entry Date: "_$P(Y,"@")_" "_$P(Y,"@",2) K RN
 S (VALMCNT,PSOPF)=IEN
 Q
0 ; EP - IHS/CIA/PLS - 01/26/04 - Prompt IHS Fields
 D IHSFLDS^APSPDIR(.PSONEW) Q
 ;
1 D 1^PSOBKDED Q
2 D 2^PSOBKDED Q
3 D 9^PSOBKDED Q
4 D 12^PSOBKDED Q
5 D 5^PSOBKDED Q
6 D 4^PSOBKDED Q
7 D 11^PSOBKDED Q
8 D 13^PSOBKDED Q
9 W !!,"Drug: "_PSODRUG("NAME") S PSOORRNW=1 D DOSE1^PSOORED5(.PSONEW)
 I $G(PSONEW("DFLG")) S PSODIR("DFLG")=1,VALMBCK="Q" Q
 D SV Q
10 D INS^PSODIR(.PSONEW),SINS^PSODIR(.PSONEW) D SV Q
SV D SV^PSOORNE5 Q
