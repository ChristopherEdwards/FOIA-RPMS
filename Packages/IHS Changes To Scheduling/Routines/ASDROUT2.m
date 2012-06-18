ASDROUT2 ; IHS/ADC/PDW/ENM - RS HEADING (SHORT FORM) ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
HED ;EP -- rerouted from SDROUT2 if printing short form
 I $G(SDCNT)>0 W @IOF
 W !,"FACILITY: "
 W $S($D(^DG(40.8,+DIV,0)):$P(^(0),U),1:^DD("SITE")) S P=P+1
 W !,"PAGE ",P,?10,"OUTPATIENT ROUTING SLIP"
 W !?7,"***",$$CONF1^ASDUT,"***"
 S Y=^DPT(J,0),NAME=$E($P(Y,U,1),1,20),DOB=$P(Y,U,3)
 W !,"NAME:",?7,NAME,?30,"HRCN: ",$$HRN^ASDUT(J)
 S Y=DOB X ^DD("DD") W !,"DOB:",?7,Y,?27,"APPT DT: ",$$APDT
 I $D(^DPT(J,.1)) D  G OVR
 . W !!,"*** INPATIENT ***"
 . W ?20,"LOCATED ON WARD: ",$P(^DPT(J,.1),U,1),!
 S ADDR=$S($D(^DPT(J,.11)):^DPT(J,.11),1:"")
OVR W !
 Q
 ;
APDT() ;EP; returns printable appt date
 Q $S(APDATE]"":APDATE,1:$$FMTE^XLFDT(DT,2))
 ;
SHORT() ;EP -- returns 1 is short rs form wanted
 Q $S($G(ASDLONG):0,$P($G(^DG(40.8,$$DIV,"IHS")),U,2)="S":1,1:0)
 ;
DIV() ; -- returns division ien
 Q +$O(^DG(40.8,"C",DUZ(2),0))
 ;
HD ;EP
 W !,?11,"**CURRENT APPOINTMENTS**",!!,?3,"TIME",?11,"CLINIC"
 Q
 ;
STATUS(DFN) ;EP; -- called to check if patient's chart is incomplete
 ;        or pulled for day surgery
 NEW X
 Q:DFN=""
 I $O(^ADGIC(DFN,"D",0)) D
 . W !?5,"**Active Incomplete Chart**"
 . S X=$O(^ADGIC(DFN,"D",0))
 . I X]"",$P($G(^ADGIC(DFN,"D",X,0)),U,12)]"" D
 .. W !?8,$P(^ADGIC(DFN,"D",X,0),U,12) ;comments
 ;
 I $O(^ADGDSI(DFN,"DT",0)) D
 . W !?5,"**Active DS Incomplete Chart**"
 . S X=$O(^ADGDSI(DFN,"DT",0))
 . I X]"",$P($G(^ADGDSI(DFN,"DT",X,0)),U,4)]"" D
 .. W !?8,$P(^ADGDSI(DFN,"DT",X,0),U,4) ;comments
 ;
 NEW X S X=$O(^ADGDS(DFN,"DS",DT))
 I X]"",X\1=DT W !?5,"**Active Day Surgery Patient**"
 ;
 NEW DATE,X S DATE=9999999-DT,X=DATE-.0001
 S X=$O(^SRF("AIHS3",DFN,X)) Q:'X
 I X\1=DATE W !?5,"**Day Surgery/SDA Patient**"
 Q
