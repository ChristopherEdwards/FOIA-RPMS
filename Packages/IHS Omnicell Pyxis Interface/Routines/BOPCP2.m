BOPCP2 ;IHS/ILC/ALG/CIA/PLS - ILC Queue Processor;20-Oct-2006 09:50;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;
EDIT ;PEP
 Q:'$P($G(^BOP(90355,1,2)),U,4)
 Q:'$G(PSGORD)  Q:'$G(PSGP)
 S BOPDFN=PSGP,BOPORDN=+PSGORD
 S BOPDIV=$$DIV^BOPCAP() G:'BOPDIV END^BOPCAP
 F BOPI=0:0 S BOPI=$O(^PS(55,BOPDFN,5,BOPORDN,1,BOPI)) Q:BOPI<1  D
 .D INIT^BOPCAP Q:$G(BOPQ)
 .S X=$P($G(^PS(55,BOPDFN,5,BOPORDN,1,BOPI,0)),U,3)
 .S BOP(2.1)=$S(X:"DC",1:"NW")
 .S BOP(8.2)="" ;Initial Dose
 .D ORDER^BOPCAP Q:$G(BOPQ)
 .N X S X=$P(BOPX0,U,3)
 .S BOP(8.1)=$G(^PS(51.2,+X,0)) ;Med Route
 .S BOP(8.1)=$S($L($P(BOP(8.1),U))'>10:$P(BOP(8.1),U),1:$P(BOP(8.1),U,3))   ;DUG 1/30/03
 .S BOP(8.3)=$P($G(^PS(55,BOPDFN,5,BOPORDN,0)),U,16)
 .S BOP8=BOP(8.1)_U_BOP(8.2)_U_BOP(8.3)
 .S ^BOP(90355.1,BOPDA,8)=BOP8
 .D FLAG^BOPCAP
 G END^BOPCAP
 ;
DIAGTXT ; patient free text diag change
 Q:'$P($G(^BOP(90355,1,2)),U)
 Q:'$P($G(^BOP(90355,1,1)),U,2)  ; send free text diag
 D GET(3)
 G END
 ;
ICD9 ; get primary icd9 for patient
 N A
 Q:'$P($G(^BOP(90355,1,1)),U,3)  ; send discharge icd9 primary
 S A=$S($D(PTF):PTF,1:DGPTF),B=$G(DFN)
 Q:'$P($G(^BOP(90355,1,2)),U)
 S A=$G(^DGPT(BOPDPTF,"M",BOPDPTI,0)),A=$P(A,U,5) Q:'A
 I $$VERSION^XPDUTL("BCSV") D
 .S A=$$ICDDX^ICDCODE(A)
 .S BOP14=$P(A,U,2)_U_$P(A,U,4)
 E  D
 .S A=$G(^ICD9(A,0)) Q:'A
 .S BOP14=$P(A,U,1)_U_$P(A,U,3)
 S BOP14=BOP14_U_$$DT^BOPCAP
 D GET(5)
 G END
ALLERGY ; patient allergy info change
 Q:'$P($G(^BOP(90355,1,2)),U)
 D GET(4)
 G END
 ;
HTWT(BOPHTWT) ;  patient height and weight from GMRBOP2
 Q:'$P($G(^BOP(90355,1,2)),U)
 D GET((BOPHTWT-7))
 G END
 ;
GET(BOPDO) ; build the various A08 strings
 I '$G(DFN) G GETQ
 S BOPDFN=DFN D INIT^BOPCAP I $G(BOPQ) G GETQ
 S BOPWHO=$$INTFACE^BOPTU(1)
 W !,"...updating "_$S(BOPWHO="O":"Omnicell",1:"Pyxis")_" data base..."
 D PID^BOPCP,PV1^BOPCP
 I BOPDO=1 D OBXH^BOPCP
 I BOPDO=2 D OBXW^BOPCP
 I BOPDO=3 D DG1^BOPCP I BOP12="" G GETQ
 I BOPDO=4 D AL1^BOPCP
 N VAIP,VAROOT S VAIP("D")="LAST",VAROOT="BOPVA"
 D IN5^VADPT K VAROOT,VAIP("D")
 S BOP(.02)="A08" S BOP(.03)=$$DT^BOPCAP
 S BOP(.04)="ADT" ;Message Type
 S BOP(.21)=BOPDO
 S X=$P($G(BOPVA(5)),U) I 'X G GETQ
 S BOPDIV=$$DIV^BOPCAP G:'BOPDIV GETQ
 ;  puts xaction in 90355.1 for xmission
 K BOPQ D MSH^BOPCAP G:$G(BOPQ) GETQ D FLAG^BOPCAP
 W "done"
GETQ Q
 ;
END G END^BOPCAP
 ;
TEST W !,"  XXXX ",!
 Q
 ;
