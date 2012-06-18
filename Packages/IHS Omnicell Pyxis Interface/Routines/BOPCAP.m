BOPCAP ;IHS/ILC/ALG/CIA/PLS - ILC ADT Event & Segments ;20-Nov-2006 09:22;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1,2**;Jul 26, 2005
 ;Called from BOP DG ADT protocol
 ;Modified - IHS/MSC/PLS - 11/20/06 - Line MSH1+8 - Corrected issue with Allergies
ADT ; PEP - Capture ADT Events
 ; Check for ADT active
 Q:'$P($G(^BOP(90355,1,2)),U)
 ; Check for send inpatient ADT active
 Q:'$P($G(^BOP(90355,1,2)),U,7)
 ;
 G:'$G(DFN) END S BOPDFN=DFN
 D INIT G:$G(BOPQ) END
 W !,"...updating "_$S(BOPWHO="O":"Omnicell",1:"Pyxis")_" data base..."
 D PID^BOPCP,PV1^BOPCP,AL1^BOPCP
 D OBXH^BOPCP,OBXW^BOPCP,DG1^BOPCP
 N VAIP,VAROOT S VAIP("D")="LAST",VAROOT="BOPVA"
 D IN5^VADPT K VAROOT,VAIP("D")
 N X S X=$P($G(BOPVA(2)),U) G:45[X!(X>6) END  ;Exclude lodger or specialty transfer
 I +$G(BOPVA(1))'=+$G(DGPMVI(1))&(+$G(BOPVA(1))>+$G(DGPMVI(1))) G:X=6 END D
 .S BOP(.02)=$S(X=1:"A01",X=2:"A02",1:"A03")
 .I BOP(.02)="A02"&($P($G(BOP10),U,1)="O") S BOP(.02)="A07"
 .S BOP(.03)=$P($G(BOPVA(3)),U)
 E  S BOP(.02)="A02" S BOP(.03)=$$DT()
 S BOP(.04)="ADT" ;Message Type
 S BOPDIV=$$DIV()
 G:'BOPDIV END
 ;
 I $P(BOP10,U,1)="O"&($P(BOP10,U,2)="")&($P($G(^BOP(90355,1,"SITE")),U,5)) D  ;->
 .  N A,B,C S A=$P($G(^BOP(90355,1,"SITE")),U,6)
 .  I 'A S $P(BOP10,U,2)="AEC" Q  ;->
 .  I A S B=$P($G(^SC(+A,0)),U,1),$P(C,U,2)=B,$P(C,U,3)=$P($G(^BOP(90355,1,"SITE")),U,4)
 .  I $L($P(C,U,2)) S $P(BOP10,U,2)=$P(C,U,2)
 .  I $P(C,U,3)'="" S $P(BOP10,U,2)=$P(C,U,3)
 .  Q  ;->
 ;
 K BOPQ D MSH G:$G(BOPQ) END D FLAG
 W !,"done."
 G END
STAT ;Called from Xref on STATUS field of UNIT DOSE field of File 55
 Q:'$P($G(^BOP(90355,1,2)),U,4)
 S BOPDC=$G(DC)
 G:'$G(DA(1)) END G:'$G(DA) END
 S BOPDFN=DA(1),BOPORDN=DA
 ;
STAT1 ;
 I $G(BOPDC)="" S BOPDC=$P($G(^PS(55,BOPDFN,5,BOPORDN,0)),U,9)
 S BOPDIV=$$DIV() G:'BOPDIV END
 N DFN S DFN=BOPDFN
 F BOPI=0:0 S BOPI=$O(^PS(55,BOPDFN,5,BOPORDN,1,BOPI)) Q:BOPI<1  D
 .D INIT Q:$G(BOPQ)
 .S BOP(2.1)=$G(BOPDC)
 .I BOP(2.1)]"" S BOP(2.1)=$S(BOPDC="R":"DC",BOPDC["D":"DC",BOPDC="H":"HD",BOPDC="A":"RL",BOPDC="RE":"NW",BOPDC="E":"DC",BOPDC="X":($S(BOPWHO="O":"XX",1:"XO")),1:"")
 .Q:BOP(2.1)=""
 .S BOP(8.2)="" ;Initial Dose
 .D ORDER Q:$G(BOPQ)
 .N X S X=$P(BOPX0,U,3)
 .S BOP(8.1)=$G(^PS(51.2,+X,0)) ;Med Route
 .S BOP(8.1)=$S($L($P(BOP(8.1),U))'>10:$P(BOP(8.1),U),1:$P(BOP(8.1),U,3))   ;DUG 1/30/03
 .S BOP(8.3)=$P($G(^PS(55,BOPDFN,5,BOPORDN,0)),U,16)
 .S BOP8=BOP(8.1)_U_BOP(8.2)_U_BOP(8.3)
 .S ^BOP(90355.1,BOPDA,8)=BOP8
 .D FLAG
 G END
 ;
 ;Called from ^PSGOETO
NEW ;PEP - New Order
 Q:'$P($G(^BOP(90355,1,2)),U,2)
 G:'$G(PSGP) END S BOPDFN=PSGP
 G:'$G(PSGORD) END S BOPORDN=+PSGORD
 G:'$P($G(^PS(55,BOPDFN,5,BOPORDN,4)),U,3) END
 S BOPDIV=$$DIV() G:'BOPDIV END
 F BOPI=0:0 S BOPI=$O(^PS(55,BOPDFN,5,BOPORDN,1,BOPI)) Q:BOPI<1  D
 .D INIT Q:$G(BOPQ)
 .S BOP(2.1)="NW" ;New Order
 .S BOP(8.2)="" ;Batch Fill
 .D ORDER Q:$G(BOPQ)
 .N X S X=$P(BOPX0,U,3)
 .S BOP(8.1)=$G(^PS(51.2,+X,0)) ;Med Route
 .S BOP(8.1)=$S($L($P(BOP(8.1),U))'>10:$P(BOP(8.1),U),1:$P(BOP(8.1),U,3))   ;DUG 1/30/03
 .S BOP(8.3)="" ;Fill Cycle Start Date/Time
 .S BOP8=BOP(8.1)_U_BOP(8.2)_U_BOP(8.3)
 .S ^BOP(90355.1,BOPDA,8)=BOP8
 .D FLAG
 G END
 ;
ORDDT ;entry for change in stop dt
 N PSGP,PSGOORD S PSGP=+DA(1),PSGOORD=+DA
 ;
RENEW ;PEP - Renewal
 ; use PSGP instead of DA(1) and PSGOORD instead of DA for DA issue
 Q:'$G(PSGP)  Q:'$G(PSGOORD)
 ;  Q:'$G(DA)  Q:'$G(DA(1))
 ;  Q:'$D(^PS(55,DA(1),5,DA,0))
 Q:'$D(^PS(55,PSGP,5,+PSGOORD,0))
 Q:'$P($G(^BOP(90355,1,2)),U,3)
 S BOPDC=$P(^PS(55,PSGP,5,+PSGOORD,0),U,9)
 S BOPDFN=PSGP,BOPORDN=+PSGOORD
 G:BOPDC="E" END
 ; S BOPDC="X"
 ; S BOPDC="D"
 ; Change above to set eq "d" if not "r" or "re"
 I $E(BOPDC,1)'="R"&($E(BOPDC,1)'="A") S BOPDC="D"
 ;
 G STAT1
 Q
ORDER ; EP - SET UP ORDER INFO
 D ORC
 D RXE^BOPCP,PID^BOPCP,PV1^BOPCP
 ;D OBXH^BOPCP,OBXW^BOPCP  ;UNCOMMENT TO INCLUDE HEIGHT AND WEIGHT
 S BOP(.02)="O01" ;Event Type
 S BOP(.03)=""
 S BOP(.04)="RDE" ;Message Type
 K BOPQ D MSH Q:$G(BOPQ)
 S:$D(BOP2) ^BOP(90355.1,BOPDA,2)=BOP2
 S:$D(BOP3) ^BOP(90355.1,BOPDA,3)=BOP3
 S:$D(BOP4) ^BOP(90355.1,BOPDA,4)=BOP4
 S:$D(BOP5) ^BOP(90355.1,BOPDA,5)=BOP5
 S:$D(BOP6) ^BOP(90355.1,BOPDA,6)=BOP6 Q
 ;
MSH ;EP - Get MSH and EVN Segment Data
 ;.02=Event Type Code, .03=Date/Time of Event, .04=Message Type
 S BOP0=U_BOP(.02)_U_BOP(.03)_U_BOP(.04)
 S BOP0=BOP0_U_U_BOPRAP_U_U_BOPPID_U_BOPVER
 ;
 ;If being processed from "DATA" do not create new entry
 S BOPY=$$DT()
 I $G(BOPNONU) D  G MSH1
 .S Y=BOPDA_U_$P(^BOP(90355.1,BOPDA,0),U)
 ;Create new entry if necessary
 N I
 F I=1:1:3 D  Q:$P(Y,U,3)  H 1
 .N DIC K DO,DD S DIC="^BOP(90355.1,",DIC(0)="L",X=BOPY D FILE^DICN
 I '$P(Y,U,3) S BOPQ=1 Q
 S BOPDA=+Y
 ;
MSH1 S $P(BOP0,U,5)=BOPY,$P(BOP0,U,7)=$P(Y,U,2)
 S $P(^BOP(90355.1,BOPDA,0),U,2,9)=$P(BOP0,U,2,9)
 S $P(^BOP(90355.1,BOPDA,0),U,12)=$G(BOPDIV)
 S $P(^BOP(90355.1,BOPDA,0),U,21)=$G(BOP(.21))
 S:BOP1]"" ^BOP(90355.1,BOPDA,1)=BOP1
 S:BOP(.02)="A03" $P(BOP10,U,7)=$P($G(BOPVA(3)),U)
 S:BOP10]"" ^BOP(90355.1,BOPDA,10)=BOP10
 I $D(BOP9) I BOP9'="^"&(BOP9'="") S ^BOP(90355.1,BOPDA,9)=BOP9
 I $D(BOP11(0)) D
 .K ^BOP(90355.1,BOPDA,11)
 .M ^BOP(90355.1,BOPDA,11)=BOP11
 I $D(BOP12) S ^BOP(90355.1,BOPDA,12)=BOP12
 I $D(BOP14) S ^BOP(90355.1,BOPDA,14)=BOP14
 Q
ORC ;Get ORC Segment Data
 G ORC^BOPCP ; put in BOPOCP for program space
 ;
INIT ;EP - Init variables
 N X K BOPQ I '$D(^BOP(90355,1,0)) S BOPQ=1 Q
 S U="^",X=^BOP(90355,1,0),BOPIT=$P(X,U,2),BOPRAP=$P(X,U,3)
 S BOPPID=$P(X,U,12),BOPVER=$P(X,U,13),BOPBAT=$P(X,U,14)
 S BOPWHO=$G(^BOP(90355,1,2)),BOPWHO=$P(BOPWHO,U,5)
 S:BOPWHO="" BOPWHO="P"
 Q
 ;
VER(PREFIX) ; EP - Return current version of Prefix
 Q +$$VERSION^XPDUTL(PREFIX)
 ;
FLAG ;EP - SET READY FLAG
 S $P(^BOP(90355.1,BOPDA,0),U,10)=0
 S ^BOP(90355.1,"AS",0,BOPDA)=""
 I $G(BOP(.04))="ADT" S ^BOP(90355.1,"AD",BOP(.03),BOPDA)=""
 N DA,DIK S DA=BOPDA,DIK="^BOP(90355.1," D IX1^DIK K DA,DIK
 Q
 ;
DT() ; EP - SET DATE
 Q $$NOW^XLFDT()
 ;
END ; EP - KILL VARIABLES
 K BOP,BOP0,BOP1,BOP10,BOP2,BOP3,BOP4,BOP5,BOP6,BOP8,BOPBAT
 K BOPDA,BOPDFN,BOPMPRX,BOPPID,BOPPREX,BOPQ,BOPRAP,BOPRST,BOPT
 K BOPVA,BOPDIV,BOPDC,BOPORDN,BOPX0,BOPVER,BOPI,BOPY,BOPX2
 K BOPDDN,BOPWID,BOPIT,BOPWHO,BOP9,BOP11,BOP12
 Q
 ;
DIV() ; EP - get Medical Center Division
 N VAIP
 S VAIP("D")="LAST"
 D IN5^VADPT
 ;Q:'$G(VAIP(5)) 0
 S BOPDIV=+$$GET1^DIQ(42,+$G(VAIP(5)),.015,"I")
 Q $S('$P($G(^BOP(90355,1,3,BOPDIV,0)),U,6):0,1:BOPDIV)  ;Check Accept Transactions
