SDROUT2 ;BSN/GRR - PRINT ROUTING SLIPS HEADING ; [ 09/13/2001  2:41 PM ]
 ;;5.3;Scheduling;**28**;Aug 13, 1993
 ;IHS/ANMC/LJF 11/30/2000 contains $N but not called by IHS
 ;
HED W !,@IOF,"*** FACILITY: ",$S($D(^DG(40.8,+DIV,0)):$P(^(0),"^"),1:$P($$SITE^VASITE,U,2)) S P=P+1
 I ORDER=2 W !,"*** CLINIC: ",$P(^SC(+SC,0),"^")
 I $D(^DPT(J,.321)) F SDX1=1,2,3 I $P(^(.321),"^",SDX1)["Y" Q
 ;I  W ?45,"*** EXPOSURE SURVEY ***",!
 ;I $D(^DPT(J,.321)) F SDX1=1,2,3 I $P(^(.321),"^",SDX1)=""!($P(^(.321),"^",SDX1)["U") W ?45,"*** UPDATE SURVEY DATA ***" Q
 ;I '$D(^DPT(J,.321)) W ?45,"*** UPDATE SURVEY DATA ***"
 I P'>1 S SDZ="",$P(SDZ,"* ",13)="" D WCAT K SDZ
 W !,"PAGE ",P,?10,"OUTPATIENT ROUTING SLIP"
 I $D(^DPT(J,.36)),$P(^DPT(J,.36),"^",1)]""
 W ?45,"*** ",$S($T:$P(^DIC(8,+^DPT(J,.36),0),"^",1),1:"ELIG NOT SPECIFIED")," ***"
 S Y=^DPT(J,0),NAME=$P(Y,"^",1),SSN=$P(Y,"^",9)
 W !!,NAME,?54,"APPOINTMENT DATE"
 W !,$E(SSN,1,3),"-",$E(SSN,4,5),"-",$E(SSN,6,10),?58,APDATE
 I $D(^DPT(J,.1)) W !!,"*** INPATIENT ***",!,"LOCATED ON WARD: ",$P(^DPT(J,.1),"^",1),! G OVR
 S ADDR=$S($D(^DPT(J,.11)):^DPT(J,.11),1:"")
 F LL=1:1:3 W:$P(ADDR,"^",LL)]"" !,$P(ADDR,"^",LL)
 W !,$S($P(ADDR,"^",4)]"":$P(ADDR,"^",4),1:"")," ",$S($P(ADDR,"^",5)]"":$P(^DIC(5,+$P(ADDR,"^",5),0),"^",1),1:"")," ",$S($P(ADDR,"^",6)]"":$P(ADDR,"^",6),1:"")
 W !!,"PSA: UNKNOWN"
OVR W !
 N I S DFN=J D DIS
 N DGINSDT S DGINSDT=SDATE
 D INS^DGRPDB,KVAR^VADPT S J=DFN
 W ! Q
WCAT S DGMT=$$LST^DGMTCOU1(J,"",3) Q:DGMT']""  S SDVA=$P(DGMT,U,3) I SDVA']"" Q  ;Q:$S('$D(^DG(41.3,+J,0)):1,$P(^(0),"^",2)']"":1,1:0)
 S SDVA=$S($P(DGMT,U,4)="R":"REQUIRES MEANS TEST",$P(DGMT,U,4)="N":"MEANS TEST NOT REQUIRED",1:SDVA)
 D KVAR^VADATE I $P(DGMT,U,2)]"",$P(DGMT,U,4)'="R",$P(DGMT,U,4)'="N" S VADAT("W")=$P(DGMT,U,2) D ^VADATE ;$N(^DG(41.3,+J,2,0))>0 S VADAT("W")=9999999-$N(^DG(41.3,J,2,0)) D ^VADATE
 W !?27,SDZ,!?27,$S($P(DGMT,U,5)=1:SDVA,1:"PHARMACY CO-PAY: "_SDVA) I $D(VADATE("E")) W !?27,"LAST TEST: ",VADATE("E")
 W !?27,SDZ K VADAT,VADATE,SDVA Q
HD W !,?11,"**CURRENT APPOINTMENTS**",!!,?3,"TIME",?11,"CLINIC",?45,"LOCATION",!
 Q
SCCOND ;  - text on routing sheet for determining if care for sc condition.
 S SDSCCOND=""
 W !!?11,"List diagnosis ________________________________________________"
 W !!?11,"List any procedures performed during this clinic visit ________",!!?11,"_______________________________________________________________"
 D CL(J)
 W ! Q
 ;
CL(DFN) ;Classification
 N SDCLY,SDCTI,SDCTIS,SDCTS
 D CL^SDCO21(DFN,DT,"",.SDCLY) G CLQ:'$D(SDCLY)
 S SDCTIS=$$SEQ^SDCO21
 W !
 F SDCTS=1:1 S SDCTI=+$P(SDCTIS,",",SDCTS) Q:'SDCTI  I $D(SDCLY(SDCTI)) D
 .W !,$P($G(^SD(409.41,SDCTI,0)),"^",2),"? "
 .W "__Yes __No"
CLQ Q
 ;
DIS ;rated disabilities
 ; -- Pharmacy is allowed to call this tag via a special agreement
 ;    with MAS.  MAS should notify pharmacy developers of any
 ;    changes that may impact PS* code.  (5/91 - MJK/BOK)
 ;
 I '$D(VAEL) D ELIG^VADPT S DGKVAR=1
 W:'+VAEL(3) !!,"Service Connected: NO" W:+VAEL(3) !!,"       SC Percent: ",$P(VAEL(3),"^",2)_"%"
 W !,"     Disabilities: " I 'VAEL(4),$S('$D(^DG(391,+VAEL(6),0)):1,$P(^(0),"^",2):0,1:1) W "NOT A VETERAN" G DISQ
 S I3=0 F I=0:0 S I=$O(^DPT(DFN,.372,I)) Q:'I  D DIS1
 I 'I3 W $S('$O(^DPT(DFN,.372,0)):"NONE STATED",1:"NO SC DISABILITIES LISTED")
DISQ I $D(DGKVAR) D KVAR^VADPT K DGKVAR,I1,I2,I3
 Q
DIS1 S I1=^DPT(DFN,.372,I,0) I $P(I1,"^",3) S I2=$S($D(^DIC(31,+I1,0)):^(0),1:""),I2=$S($P(I2,"^",4)]"":$P(I2,"^",4),1:$P(I2,"^")) W !,I2,?48,$J($P(I1,"^",2),4),"% - ",$S($P(I1,"^",3):"SERVICE CONNECTED",1:"") S I3=I3+1
 Q
