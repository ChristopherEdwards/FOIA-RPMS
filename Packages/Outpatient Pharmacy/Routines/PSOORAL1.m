PSOORAL1 ;BHAM ISC/SAB - build listman activity logs ; 11/16/92 13:11
 ;;7.0;OUTPATIENT PHARMACY;**71**;DEC 1997
 N RX0,VALMCNT K DIR,DTOUT,DUOUT,DIRUT,^TMP("PSOAL",$J) S DA=$P(PSOLST(ORN),"^",2),RX0=^PSRX(DA,0),J=DA,RX2=$G(^(2)),R3=$G(^(3)),CMOP=$O(^PSRX(DA,4,0))
 S IEN=0,DIR(0)="LO^1:"_$S(CMOP:7,1:6),DIR("A",1)=" ",DIR("A",2)="Select Activity Log by  number",DIR("A",3)="1.  Refill      2.  Partial      3.  Activity"
 S DIR("A")=$S(CMOP:"4.  Label       5.  Copay        6.  CMOP Events  7.  All Logs",1:"4.  Labels      5.  Copay        6.  All Logs")
 S DIR("B")=$S(CMOP:7,1:6) D ^DIR S PSOELSE=+Y I +Y S Y=$S(CMOP&(Y[7):"1,2,3,4,5,6",'CMOP&(Y[6):"1,2,3,4,5",1:Y) S ACT=Y D FULL^VALM1 D
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Rx #: "_$P(RX0,"^")_"   Original Fill Released: " I $P(RX2,"^",13) S DTT=$P(RX2,"^",13) D DAT S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_DAT K DAT,DTT
 .I $P(RX2,"^",15) S DTT=$P(RX2,"^",15) D DAT S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"(Returned to Stock "_DAT_")" K DAT,DTT
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Routing: "_$S($P(RX0,"^",11)="W":"Window",1:"Mail")_$S($P($G(^PSRX(DA,"OR1")),"^",5):"      Finished by: "_$P(^VA(200,$P(^PSRX(DA,"OR1"),"^",5),0),"^"),1:"")
 .D:$G(^PSRX(DA,"H"))]""&($P(PSOLST(ORN),"^",3)="HOLD") HLD^PSOORAL2
 .F LOG=1:1:$L(ACT,",") Q:$P(ACT,",",LOG)']""  S LBL=$P(ACT,",",LOG) D @$S(LBL=1:"RF^PSOORAL2",LBL=2:"PAR^PSOORAL2",LBL=3:"ACT",LBL=5:"COPAY",LBL=6:"^PSORXVW2",1:"LBL")
 ;.D:$O(^PSRX(DA,4,0)) ^PSORXVW2
 I 'PSOELSE S VALMBCK="" K PSOELSE Q 
 K ST0,RFL,RFLL,RFL1,II,J,N,PHYS,L1,DIRUT,PSDIV,PSEXDT,MED,M1,FFX,DTT,DAT,R3,RTN,SIG,STA,P1,PL,P0,Z0,Z1,EXDT,IFN,DIR,DUOUT,DTOUT,PSOELSE
 K LBL,I,RFDATE,%H,%I,RN,RFT
 S PSOAL=IEN K IEN,ACT,LBL,LOG D EN^PSOORAL S VALMBCK="R"
 Q
ACT ;activity log
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" ",IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Activity Log:"
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="#   Date        Reason         Rx Ref         Initiator Of Activity",IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0),"=",79)="="
 I '$O(^PSRX(DA,"A",0)) S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="There's NO Activity to report" Q
 F N=0:0 S N=$O(^PSRX(DA,"A",N)) Q:'N  S P1=^(N,0),DTT=P1\1 D DAT D
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=N_"   "_DAT_"    ",$P(RN," ",15)=" ",REA=$P(P1,"^",2),REA=$F("HUCELPRWSIVDABX",REA)-1
 .I REA D
 ..S STA=$P("HOLD^UNHOLD^DISCONTINUED^EDIT^RENEWED^PARTIAL^REINSTATE^REPRINT^SUSPENSE^RETURNED^INTERVENTION^DELETED^DRUG INTERACTION^PROCESSED^X-INTERFACE^","^",REA)
 ..S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_STA_$E(RN,$L(STA)+1,15)
 .E  S $P(STA," ",15)=" ",^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_STA
 .K STA,RN S $P(RN," ",15)=" ",RF=+$P(P1,"^",4)
 .S RFT=$S(RF>0&(RF<6):"REFILL "_RF,RF=6:"PARTIAL",RF>6:"REFILL "_(RF-1),1:"ORIGINAL")
 .S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_RFT_$E(RN,$L(RFT)+1,15)_$S($D(^VA(200,+$P(P1,"^",3),0)):$P(^(0),"^"),1:$P(P1,"^",3))
 .;S:$P(P1,"^",5)]"" IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Comments: "_$P(P1,"^",5)
 .I $P(P1,"^",5)]"" N PSOACBRK,PSOACBRV D
 ..S PSOACBRV=$P(P1,"^",5)
 ..I $L(PSOACBRV)<71 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Comments: "_PSOACBRV Q
 ..I $E(PSOACBRV,1,70)'[" " S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Comments: "_$E(PSOACBRV,1,70),IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=$E(PSOACBRV,71,245) Q
 ..F PSOACBRK=245:-1 Q:PSOACBRK=0  I $E(PSOACBRV,PSOACBRK)=" ",PSOACBRK<71 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Comments: "_$E(PSOACBRV,1,PSOACBRK),IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=$E(PSOACBRV,PSOACBRK,245) Q
 .I $P($G(^PSRX(DA,"A",N,1)),"^")]"" S IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0)," ",5)=$P($G(^PSRX(DA,"A",N,1)),"^") I $P($G(^PSRX(DA,"A",N,1)),"^",2)]"" S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_":"_$P($G(^PSRX(DA,"A",N,1)),"^",2) Q
 Q
LBL ;label log
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" ",IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Label Log:"
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="#   Date        Rx Ref                    Printed By",IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0),"=",79)="="
 I '$O(^PSRX(DA,"L",0)) S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="There are NO Labels printed." Q
 F L1=0:0 S L1=$O(^PSRX(DA,"L",L1)) Q:'L1  S LBL=^PSRX(DA,"L",L1,0),DTT=$P(^(0),"^") D DAT D
 .S $P(RN," ",26)=" ",IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=L1_"   "_DAT_"    ",RFT=$S($P(LBL,"^",2):"REFILL "_$P(LBL,"^",2),1:"ORIGINAL"),RFT=RFT_$E(RN,$L(RFT)+1,26)
 .S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_RFT_$P($G(^VA(200,$P(LBL,"^",4),0)),"^"),IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Comments: "_$P(LBL,"^",3)
 Q
DAT S DAT="",DTT=DTT\1 Q:DTT'?7N  S DAT=$E(DTT,4,5)_"/"_$E(DTT,6,7)_"/"_$E(DTT,2,3)
 Q
COPAY ;Copay activity log
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=" ",IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Copay Activity Log:"
 S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="#   Date        Reason               Rx Ref         Initiator Of Activity",IEN=IEN+1,$P(^TMP("PSOAL",$J,IEN,0),"=",79)="="
 I '$O(^PSRX(DA,"COPAY",0)) S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="There's NO Copay activity to report" Q
 F N=0:0 S N=$O(^PSRX(DA,"COPAY",N)) Q:'N  S P1=^(N,0),DTT=P1\1 D DAT D
 .S IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)=N_"   "_DAT_"    ",$P(RN," ",21)=" ",REA=$P(P1,"^",2),REA=$F("ARICE",REA)-1
 .I REA D
 ..S STA=$P("ANNUAL CAP REACHED^COPAY RESET^IB-INITIATED COPAY^REMOVE COPAY CHARGE^RX EDITED^","^",REA)
 ..S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_STA_$E(RN,$L(STA)+1,21)
 .E  S $P(STA," ",21)=" ",^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_STA
 .K STA,RN S $P(RN," ",15)=" ",RF=+$P(P1,"^",4)
 .S RFT=$S(RF>0:"REFILL "_RF,1:"ORIGINAL")
 .S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_RFT_$E(RN,$L(RFT)+1,15)_$S($D(^VA(200,+$P(P1,"^",3),0)):$P(^(0),"^"),1:$P(P1,"^",3))
 .S:$P(P1,"^",5)]""!($P(P1,"^",6)]"")!($P(P1,"^",7)]"") IEN=IEN+1,^TMP("PSOAL",$J,IEN,0)="Comment: "_$P(P1,"^",5)
 .I $P(P1,"^",6)]"" S ^TMP("PSOAL",$J,IEN,0)=^TMP("PSOAL",$J,IEN,0)_"  Old value="_$P(P1,"^",6)_"   New value="_$P(P1,"^",7)
 Q
