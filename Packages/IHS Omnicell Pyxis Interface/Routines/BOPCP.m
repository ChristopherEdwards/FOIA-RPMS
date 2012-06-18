BOPCP ;IHS/ILC/ALG/CIA/PLS - Capture and File Data;27-Nov-2006 11:10;SM;
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1,2**;Jul 26, 2005
 ;Called from ^BOPCAP
 ;Modified - IHS/MSC/PLS - 11/20/06 - Line AL1+10 - Added set of zero node for allergies
 ;                                    Line AL1S+1 - Added logic to set "B" xref on BOP11
PID ;EP - Get PID Segment data
 D DEM^VADPT,ADD^VADPT
 S BOP(1.13)=$P($G(^DPT(BOPDFN,.13)),U,2)
 ;If PIMS 5.3 is installed use VA("PID" for Chart Number - IHS/CIA/PLS - 01/20/05
 I $$VERSION^XPDUTL("DG")<5.3 D
 .S BOP1=BOPDFN_U_BOPDFN_U_VADM(1)_U_$P(VADM(3),U)_U_$P(VADM(5),U)_U_$P(VADM(8),U)_U_VAPA(1)_U_VAPA(4)_U_$P(VAPA(5),U,2)_U_VAPA(6)_U_BOPIT_U_VAPA(8)_U_BOP(1.13)_U_$P(VADM(11),U)_U_$P(VADM(2),U) Q
 E  D
 .S BOP1=BOPDFN_U_BOPDFN_U_VADM(1)_U_$P(VADM(3),U)_U_$P(VADM(5),U)_U_$P(VADM(8),U)_U_VAPA(1)_U_VAPA(4)_U_$P(VAPA(5),U,2)_U_VAPA(6)_U_BOPIT_U_VAPA(8)_U_BOP(1.13)_U_$G(VA("PID"))_U_$P(VADM(2),U) Q
 ;
PV1 ;EP - Get PV1 Segment data
 K VAIP("D") S VAROOT="BOPVA" D IN5^VADPT K VAROOT
 S BOP(10.2)=$P($G(BOPVA(5)),U,2) ;Nursing Unit
 S BOPWID=$P($G(BOPVA(5)),U) ;Ward IEN
 S BOP(10.3)=$P($G(BOPVA(6)),U,2) ;Room-Bed
 S BOP(10.4)=$P($G(BOPVA(18)),U,2) ;Attending Doctor
 S BOP(10.41)=$P($G(BOPVA(7)),U,2) ; consulting doc added
 S BOP(10.5)="" ;Hospital Service
 S BOP(10.6)=$P($G(BOPVA(13,1)),U) ;Admit Date/Time
 S BOP(10.1)=$S($G(BOPVA(1)):"I",1:"O") ;Patient Status
 ; S BOP10=BOP(10.1)_U_BOP(10.2)_U_BOP(10.3)_U_BOP(10.4)_U_U_BOP(10.6)_U_U Q
 S BOP10=BOP(10.1)_U_BOP(10.2)_U_BOP(10.3)_U_BOP(10.4)_U_U_BOP(10.6)_U_U
 S $P(BOP10,U,20)=BOP(10.41)
 Q
 ;
RXE ;EP - Get RXE, RXR, ZRX Segment Data
 S BOPX0=^PS(55,BOPDFN,5,BOPORDN,0),BOPX2=^(2)
 S BOP(3.1)=$P(BOPX2,U) ;Schedule (Q/T Frequency-HL7)
 S BOP(3.2)=""
 S BOP(3.3)=$P(BOPX2,U,2) ;Start Date/Time
 I $P(BOP(3.3),".",2)=24 S $P(BOP(3.3),".",2)=2359
 S BOP(3.4)=$P(BOPX2,U,4) ;Stop Date/Time
 I $P(BOP(3.4),".",2)=24 S $P(BOP(3.4),".",2)=2359
 N X S X=$P($G(^PS(55,BOPDFN,5,BOPORDN,0)),U,7)
 S BOP(3.5)=X ;QT Order Type
 S BOP(3.6)=""
 S BOP(3.7)=$P(BOPX2,U,5) ;Admin Times
 N I S BOP3="" F I=3.1:.1:3.7 S BOP3=BOP3_BOP(I)_U
 S X=$G(^PS(55,BOPDFN,5,BOPORDN,1,BOPI,0))
 S BOP(4.1)=$P(X,U) ;Dispense Drug (IEN)
 S BOPDDN=BOP(4.1)
 S BOP(4.2)=$P($G(^PSDRUG(+BOP(4.1),0)),U)
 S A="",A=$$VER^BOPCAP("PSJ")
 S BOP(4.3)=$P($G(^PS(55,BOPDFN,5,BOPORDN,($S($E(A,1)=5:".2",1:".1")))),U,2)
 ;S BOP(4.3)=""
 S BOP4=BOP(4.1)_U_BOP(4.2)_U_BOP(4.3)
 S BOP5=U_$P(X,U,2) ;Dispense Amount-HL7
 S BOP6=U_$P($G(^PS(55,BOPDFN,5,BOPORDN,6)),U) ;Special instruction
 Q
OBXH ;EP - Get OBX height and weight Data
 S BOP(9.1)=$$VITCHT^BOPTU(+$P($$VITAL^BOPTU(DFN,"HT"),U,2))
 S $P(BOP9,U,1)=BOP(9.1)
 Q
OBXW ;EP -  get the patient weight
 S BOP(9.2)=$$VITCWT^BOPTU(+$P($$VITAL^BOPTU(DFN,"WT"),U,2))
 S $P(BOP9,U,2)=BOP(9.2)
 Q
DG1 ;EP - get free text diag (Dx)
 S BOP12=$G(BOPVA(9))
 Q
AL1 ;EP - get allergy info
 N GMRA,GMRAL,BOPN K GMRAL,BOP11,BOPN
 S GMRAL=""
 S BOPMAL1=$P($G(^BOP(90355,1,4)),U,4)
 S BOPN=0
 S GMRA="1^0^111" D EN1^GMRADPT
 I GMRAL="" D  ; Check for patient not asked
 .S B="UNKNOWN^" D AL1S
 E  I 'GMRAL D  ; Check for nka
 .S B="NKA^" D AL1S
 E  D  ;loop thru allergies
 .S A=0 F  S A=$O(GMRAL(A)) Q:'A  S B=$P(GMRAL(A),U,9),OK=0 D  D:OK AL1S
 ..I +B=BOPMAL1!(B="") D  Q
 ...S B=$P(GMRAL(A),U,2)_U,OK=1
 ..I $P(B,";",1)'=""&($P(B,";",2)'="") D  Q
 ...S C=U_$P(B,";",2)_+B_",0)"
 ...S D=$G(@C),B=$P(D,U,1)_U_+B,OK=1
 I $D(BOP11) D
 .S BOP11(0)="^90355.111A^"_BOP11(0)_U_BOP11(0)
 Q
AL1N ; check for nka
 S A="",A=$G(^GMR(120.86,DFN,0)) I A'=""&($P(A,U,2)=0) S BOPN=0,B="NKA^" D AL1S
 K GMRAL,GMRA,BOPN
 Q
AL1S S BOPN=BOPN+1,BOP11(0)=BOPN,BOP11(BOPN,0)=B
 S BOP11("B",$P(B,U),BOPN)=""
 Q
ORC ;EP -  Get ORC Segment Data
 S BOP(2.2)=+$G(BOPORDN) ;Order Number
 N X S X=$G(^PS(55,BOPDFN,5,BOP(2.2),0))
 S BOP(2.3)=$P(X,U,9) ;Order Status
 N A S A=BOP(2.3),BOP(2.3)=$S(A="A":"IP",(A="D"!(A="DE")!(A="DR")):"DC",A="H":"HD",1:"")
 S (BOP(2.4))=$P(X,U,16) ;Login Date/Time
 S BOP(2.7)=+$P(X,U,2),BOP(2.93)=BOP(2.7)  ;Provider IEN
 S BOP(2.7)=$P($G(^VA(200,BOP(2.7),0)),U) ;Provider
 S X=$G(^PS(55,BOPDFN,5,BOP(2.2),4))
 S BOP(2.5)=+$P(X,U,7),BOP(2.91)=BOP(2.5),BOP(2.5)=$P($G(^VA(200,BOP(2.5),0)),U) ;Clerk
 S BOP(2.6)=+$P(X,U,3),BOP(2.92)=BOP(2.6),BOP(2.6)=$P($G(^VA(200,BOP(2.6),0)),U) ;Pharmacist
 S X=$G(^PS(55,BOPDFN,5,BOPORDN,1,BOPI,0))
 S BOP(2.8)=BOP(2.2)_"-"_$P(X,U)
 N I S BOP2="" F I=2.1:.1:2.8 S A=$G(BOP(I)),BOP2=BOP2_A_U
 F I=2.91:.01:2.99 S A=$G(BOP(I)),BOP2=BOP2_A_"-" I I=2.99 S BOP2=BOP2_U
 K I,A
 Q
