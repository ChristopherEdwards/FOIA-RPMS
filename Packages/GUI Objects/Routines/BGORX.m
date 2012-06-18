BGORX ; IHS/BAO/TMD - Pharmacy Utilities ;
 ;;1.1;BGO;**1**;JUN 02, 2005
 ;
 ;
ALLOPRX(BGORET,BGOP)  ;BGORET is array value, all op meds
 ;     input data - dfn|rx age
 N S,DT1,DT2,DFN,C,%DT,Y,X,Z,T,RX,CHR,DUP,DRUG,CNT,UNDUP
 K ^TMP("BGOALLRX",$J)
 S C=0
 I $G(BGOP)="" S BGORET="-1^Missing Input Data" Q
 S S="OR_RXOP:ALL OUTPATIENT~RXOP;ORDV06;28;10"
 S DFN=+BGOP Q:'DFN
 S DT1=$P(BGOP,"|",2)
 S DUP=$P(BGOP,"|",3)
 S DRUG=$P(BGOP,"|",4)
 I DT1="" S DT1="T-30"
 S %DT="T",X=DT1 D ^%DT Q:'Y  S DT1=Y
 S %DT="T",X="T" D ^%DT Q:'Y  S DT2=Y
 D RPT^ORWRP(.BGORET,DFN,S,"","","",DT1,DT2)
 Q:$E(BGORET,1,4)'="^TMP"
 S N=$P($P(BGORET,",",2),")",1) Q:'N
 S X=0 F  S X=$O(^TMP("ORDATA",N,X)) Q:'X  D
 .I DRUG Q:$P(^TMP("ORDATA",N,X,"WP",3),U,2)'=DRUG
 .I 'DUP,$P($G(UNDUP($P(^TMP("ORDATA",N,X,"WP",3),U,2))),U)>$P(^TMP("ORDATA",N,X,"WP",8),U,2) Q
 .S Y=0 F  S Y=$O(^TMP("ORDATA",N,X,"WP",Y)) Q:'Y  D
 ..I Y=1 S S=$P($P(^TMP("ORDATA",N,X,"WP",Y),U,2),";",1)
 ..I Y'=14 S $P(S,U,Y)=$P(^TMP("ORDATA",N,X,"WP",Y),U,2)
 ..I Y=14 S T="" D  S $P(S,U,Y)=T
 ...S Z=0 F  S Z=$O(^TMP("ORDATA",N,X,"WP",Y,Z)) Q:'Z  D
 ....S T=T_$P(^TMP("ORDATA",N,X,"WP",Y,Z),U,2)
 .S RX=$P(S,U,4) Q:RX=""
 .S RX=$O(^PSRX("B",RX,0)),CHR=$P($G(^PSRX(+RX,9999999)),U,2)
 .S $P(S,U,15)=CHR
 .I DUP S CNT=C,C=C+1
 .I 'DUP D
 ..I $D(UNDUP($P(^TMP("ORDATA",N,X,"WP",3),U,2))) S CNT=$P(^(3),U,2)
 ..E  S CNT=C,C=C+1
 ..S UNDUP($P(^TMP("ORDATA",N,X,"WP",3),U,2))=$P(^TMP("ORDATA",N,X,"WP",8),U,2)_U_CNT
 .S ^TMP("BGOALLRX",$J,CNT)=S_$C(13)_$C(10)
 S BGORET="^TMP("_"""BGOALLRX"""_","_$J_")"
 Q
 ;
RXCHR(BGORET,BGOP) ;
 ;     input data - RX|Y/N
 N DA,DIE,DR,CHR
 S DA=+BGOP,CHR=$P(BGOP,"|",2)
 S DA=$O(^PSRX("B",DA,0)) Q:'DA
 S DIE="^PSRX(",DR="9999999.02///"_CHR D ^DIE
 S BGORET=$S('$D(Y):0,1:-1)
 Q
 ;
RXRPT(DATA,BGOI)  ;DATA is return value,
 ;    BGOI input data = rpc/parameters
 ;
 S PSOVDA=+BGOI Q:'PSOVDA
 S PS="VIEW"
 S DATA="^TMP("_"""PSOAL"""_","_$J_")"
 K ^TMP("PSOAL",$J),PCOMX,PDA,PHI,PRC,ACOM,ANS
 S (DA,RXN)=PSOVDA K PSOVDA S RX0=^PSRX(RXN,0),PSODFN=+$P(^(0),U,2),RX2=$G(^(2)),RX3=$G(^(3)),ST=+$G(^("STA")),RXOR=$G(^("OR1"))
 I 'RXOR,$P(^PSDRUG($P(RX0,"^",6),2),"^") S $P(^PSRX(RXN,"OR1"),"^")=$P(^PSDRUG($P(RX0,"^",6),2),"^"),RXOR=$P(^PSDRUG($P(RX0,"^",6),2),"^")
 S IEN=0,$P(RN," ",12)=" "
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=$S($P($G(^PSRX(RXN,"TPB")),"^"):"            TPB Rx #: ",1:"                Rx #: ")_$P(RX0,"^")_$S($G(^PSRX(RXN,"IB")):"$",1:"")_$E(RN,$L($P(RX0,"^")_$S($G(^PSRX(RXN,"IB")):"$",1:""))+1,12)
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="      Orderable Item: "_$S($D(^PS(50.7,$P(+RXOR,"^"),0)):$P(^PS(50.7,$P(+RXOR,"^"),0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^"),1:"No Pharmacy Orderable Item")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=$S($D(^PSDRUG("AQ",$P(RX0,"^",6))):"           CMOP ",1:"                ")_"Drug: "_$P(^PSDRUG($P(RX0,"^",6),0),"^")
 S:$G(^PSRX(RXN,"TN"))]"" IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="          Trade Name: "_$G(^PSRX(RXN,"TN"))
 D IHSFLDS   ; IHS/CIA/PLS - 01/08/04 - Build IHS output
 D DOSE^PSORXVW1
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Patient Instructions:" I $O(^PSRX(RXN,"INS1",0)) D
 .F I=0:0 S I=$O(^PSRX(RXN,"INS1",I)) Q:'I  S MIG=$P(^PSRX(RXN,"INS1",I,0),"^") D
 ..F SG=1:1:$L(MIG) S:$L(^TMP("PSOAL",$J,IEN,0)_" "_$P(MIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0)," ",21)=" " S:$P(MIG," ",SG)'="" ^TMP("PSOAL",$J,IEN,0)=$G(^TMP("PSOAL",$J,IEN,0))_" "_$P(MIG," ",SG)
 K MIG,SG
 I $P($G(^PS(55,PSODFN,"LAN")),"^") S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="  Other Pat. Instruc: "_$S($G(^PSRX(RXN,"INSS"))]"":^PSRX(RXN,"INSS"),1:"")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="                 SIG:"
 I '$P($G(^PSRX(RXN,"SIG")),"^",2) D  G PTST
 .S X=$P($G(^PSRX(RXN,"SIG")),"^") D SIGONE^PSOHELP S SIG=$E($G(INS1),2,250)
 .F SG=1:1:$L(SIG) S:$L(^TMP("PSOAL",$J,IEN,0)_" "_$P(SIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0)," ",21)=" " S:$P(SIG," ",SG)'="" ^TMP("PSOAL",$J,IEN,0)=$G(^TMP("PSOAL",$J,IEN,0))_" "_$P(SIG," ",SG)
 S SIGOK=1
 F I=0:0 S I=$O(^PSRX(RXN,"SIG1",I)) Q:'I  S MIG=$P(^PSRX(RXN,"SIG1",I,0),"^") D
 .F SG=1:1:$L(MIG) S:$L(^TMP("PSOAL",$J,IEN,0)_" "_$P(MIG," ",SG))>80 IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0)," ",21)=" " S:$P(MIG," ",SG)'="" ^TMP("PSOAL",$J,IEN,0)=$G(^TMP("PSOAL",$J,IEN,0))_" "_$P(MIG," ",SG)
 S SIGOK=1 K MIG,SG
PTST S $P(RN," ",25)=" ",PTST=$S($G(^PS(53,+$P(RX0,"^",3),0))]"":$P($G(^PS(53,+$P(RX0,"^",3),0)),"^"),1:""),IEN=IEN+1
 S ^TMP("PSOAL",$J,IEN,0)="      Patient Status: "_PTST_$E(RN,$L(PTST)+1,25)
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="          Issue Date: "_$E($P(RX0,"^",13),4,5)_"/"_$E($P(RX0,"^",13),6,7)_"/"_$E($P(RX0,"^",13),2,3)
 S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"                 Fill Date: "_$E($P(RX2,"^",2),4,5)_"/"_$E($P(RX2,"^",2),6,7)_"/"_$E($P(RX2,"^",2),2,3)
 S ROU=$S($P(RX0,"^",11)="W":"Window",1:"Mail")
 S REFL=$P(RX0,"^",9),I=0 F  S I=$O(^PSRX(RXN,1,I)) Q:'I  S REFL=REFL-1,ROU=$S($P(^PSRX(RXN,1,I,0),"^",2)="W":"Window",1:"Mail")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="      Last Fill Date: "_$E($P(RX3,"^"),4,5)_"/"_$E($P(RX3,"^"),6,7)_"/"_$E($P(RX3,"^"),2,3)
 ;D CMOP^PSOORNE3 S DA=RXN
 S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_" ("_ROU_$S($G(PSOCMOP)]"":", "_PSOCMOP,1:"")_")" K ROU,PSOCMOP
 S IEN=IEN+1 I $P(RX2,"^",15) S ^TMP("PSOAL",$J,IEN,0)="   Returned to Stock: "_$E($P(RX2,"^",15),4,5)_"/"_$E($P(RX2,"^",15),6,7)_"/"_$E($P(RX2,"^",15),2,3)
 E  S ^TMP("PSOAL",$J,IEN,0)="   Last Release Date: " D
 .S RLD=$S($P(RX2,"^",13):$E($P(RX2,"^",13),4,5)_"/"_$E($P(RX2,"^",13),6,7)_"/"_$E($P(RX2,"^",13),2,3),1:"")
 .I $O(^PSRX(RXN,1,0)) F I=0:0 S I=$O(^PSRX(RXN,1,I)) Q:'I  D
 ..I $P(^PSRX(RXN,1,I,0),"^",18) S RLD=$E($P(^(0),"^",18),4,5)_"/"_$E($P(^(0),"^",18),6,7)_"/"_$E($P(^(0),"^",18),2,3)
 .S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_RLD
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="             Expires: "_$E($P(RX2,"^",6),4,5)_"/"_$E($P(RX2,"^",6),6,7)_"/"_$E($P(RX2,"^",6),2,3)
 S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"                     Lot #: "_$S($P(RX2,"^",4):$P(RX2,"^",4),1:"")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="         Days Supply: "_$P(RX0,"^",8)_$S($L($P(RX0,"^",8))=1:" ",1:"")
 S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"                           QTY"_$S($P($G(^PSDRUG($P(RX0,"^",6),660)),"^",8)]"":" ("_$P($G(^PSDRUG($P(RX0,"^",6),660)),"^",8)_")",1:" (  )")_": "_$P(RX0,"^",7)
 I $P($G(^PSDRUG($P(RX0,"^",6),5)),"^")]"" D
 .S $P(RN," ",79)=" ",IEN=IEN+1
 .S ^TMP("PSOAL",$J,IEN,0)=$E(RN,$L("QTY DSP MSG: "_$P(^PSDRUG($P(RX0,"^",6),5),"^"))+1,79)_"QTY DSP MSG: "_$P(^PSDRUG($P(RX0,"^",6),5),"^") K RN
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="        # of Refills: "_$P(RX0,"^",9)_$S($L($P(RX0,"^",9))=1:" ",1:"")_"                       Remaining: "_REFL
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="            Provider: "_$S($D(^VA(200,$P(RX0,"^",4),0)):$P(^VA(200,$P(RX0,"^",4),0),"^"),1:"UNKNOWN")
 I $P(RX3,"^",3) S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="        Cos-Provider: "_$P(^VA(200,$P(RX3,"^",3),0),"^")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="             Routing: "_$S($P(RX0,"^",11)="W":"Window",1:"Mail")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="              Copies: "_$S($P(RX0,"^",18):$P(RX0,"^",18),1:1)
 S:$P(RX0,"^",11)="W" IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="    Method of Pickup: "_$G(^PSRX(RXN,"MP"))
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="              Clinic: "_$S($D(^SC(+$P(RX0,"^",5),0)):$P(^SC($P(RX0,"^",5),0),"^"),1:"Not on File")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="            Division: "_$P(^PS(59,$P(RX2,"^",9),0),"^")_" ("_$P(^(0),"^",6)_")"
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="          Pharmacist: "_$S($P(RX2,"^",3):$P(^VA(200,$P(RX2,"^",3),0),"^"),1:"")
 S:$P(RX2,"^",10)&('$G(PSOCOPY)) IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="         Verified By: "_$P(^VA(200,$P(RX2,"^",10),0),"^")
 ; IHS/CIA/PLS - 01/25/04 - Removed from display
 ;S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="  Patient Counseling: "_$S($P($G(^PSRX(RXN,"PC")),"^"):"YES",1:"NO")_"                      "_$S($P($G(^PSRX(RXN,"PC")),"^"):"Was Counseling Understood: "_$S($P($G(^PSRX(RXN,"PC")),"^",2):"YES",1:"NO"),1:"")
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="             Remarks: "_$P(RX3,"^",7)
 D PC^PSORXVW1
 I $P($G(^PSRX(DA,"OR1")),"^",5) S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="         Finished By: "_$P(^VA(200,$P(^PSRX(DA,"OR1"),"^",5),0),"^")
 S $P(RN," ",35)=" ",IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="   Entry By: "_$P($G(^VA(200,+$P(RX0,"^",16),0)),"^")_$E(RN,$L($P($G(^VA(200,+$P(RX0,"^",16),0)),"^"))+1,35)
 S Y=$P(RX2,"^") X ^DD("DD")
 S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"Entry Date: "_$E($P(RX2,"^"),4,5)_"/"_$E($P(RX2,"^"),6,7)_"/"_$E($P(RX2,"^"),2,3)_" "_$P(Y,"@",2) K RN
 D ^PSORXVW1 S PSOAL=IEN K IEN,ACT,LBL,LOG
 I ST<12,$P(RX2,"^",6)<DT S ST=11
 S ^TMP("PSOAL",$J,1,0)=^TMP("PSOAL",$J,1,0)_" ("_$P("Error^Active^Non-Verified^Refill^Hold^Non-Verified^Suspended^^^^^Done^Expired^Discontinued^Deleted^Discontinued^Discontinued (Edit)^Provider Hold^","^",ST+2)_")"
 S:$P($G(^PSRX(DA,"PKI")),"^") ^TMP("PSOAL",$J,1,0)=^TMP("PSOAL",$J,1,0)_" Digitally Signed Order"
 ;D EN^PSOORAL,KILL G:PS="VIEW" PSORXVW
 D KILL
 Q
KILL K PS,DA
 K ^TMP("PSOHDR",$J)
 K ST,RFL,RFLL,RFL1,ST,II,J,N,PHYS,L1,DIRUT,PSDIV,PSEXDT,MED,M1,FFX,DTT,DAT,RX0,RX2,R3,RTN,SIG,STA,P1,PL,P0,Z0,Z1,EXDT,IFN,DIR,DUOUT,DTOUT,PSOELSE
 K LBL,I,RFDATE,%H,%I,RN,RFT,%,%I,DFN,GMRAL,HDR,POERR,PTST,REFL,RF,RLD,RX3
 K RXN,RXOR,SG,VA,VADM,VAERR,VALMBCK,VAPA,X,DIC,REA,ZD,PSOHD,PSOBCK,PSODFN,INS1,PSOAL,PSOCOPY,SIGOK
 Q
 ; IHS/CIA/PLS - 01/08/04 - Build IHS data
IHSFLDS ; EP
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="                 NDC: "_$P(RX2,U,7)
 S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"     AWP: "_$$GET1^DIQ(52,RXN,9999999.06)_"    UP: "_$$GET1^DIQ(52,RXN,17)
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="        TRIPLICATE #: "_$$GET1^DIQ(52,RXN,9999999.14)
 Q
