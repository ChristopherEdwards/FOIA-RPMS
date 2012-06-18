SRONRPT0 ;TAMPA/CFB - NURSE'S REPORT ; 30 Jan 1989  8:38 AM
 ;;3.0; Surgery ;;24 Jun 93
 F X=0:.1:1.1 S SRTN(X)=$S($D(^SRF(SRTN,X))#2:^(X),1:"")
 D HDR^SRONRPT G:SRSOUT END^SRONRPT1
 D:SRT="UL" UL D:SRT="Q" Q W !,"Operating Room: ",$S($P(SRTN(0),U,2)="":"",'$D(^SRS($P(SRTN(0),U,2),0)):"",$D(^SC($P(^(0),U,1),0))#2:$P(^(0),U,1),1:""),?40,"Case Type: " S Q(3)=^DD(130,.035,0),Q(7)=$P(SRTN(0),U,10) D S W Q(7)
 D UL G:SRSOUT END^SRONRPT1 W !,"Pat in Holding: ",?16 S X=$P(SRTN(.2),U,15),%DT="ET" D:X'="" ^%DT W ?40,"Pat in OR: ",?56 S X=$P(SRTN(.2),U,10),%DT="ET" D:X'="" ^%DT
 D UL G:SRSOUT END^SRONRPT1 W !,"Operation Begin:",?16 S X=$P(SRTN(.2),U,2) D:X'="" ^%DT W ?40,"Operation End: ",?56 S X=$P(SRTN(.2),U,3) D:X'="" ^%DT
 D UL G:SRSOUT END^SRONRPT1 W !,"Surgeon in OR: ",?16 S X=$P(SRTN(.2),U,9),%DT="ET" D:X'="" ^%DT W ?40,"Pat Out OR: ",?56 S X=$P(SRTN(.2),U,12),%DT="ET" D:X'="" ^%DT
 D UL G:SRSOUT END^SRONRPT1 W !,"Surgeon: " S Z=$P(SRTN(.1),U,4) D N W $E(Z,1,30),?40,"First Assist: " S Z=$P(SRTN(.1),U,5) D N W $E(Z,1,30)
 D UL G:SRSOUT END^SRONRPT1 W !,"Attend Surg:: " S Z=$P(SRTN(.1),U,13) D N W $E(Z,1,30),?40,"Anesthetist: " S Z=$P(SRTN(.3),U,1) D N W $E(Z,1,30)
 D UL G:SRSOUT END^SRONRPT1 W !,"OR Support Personnel: ",!,?2,"Scrubbed",?40,"Circulating" K V
 D NURSE S CNT=0 F  S CNT=$O(NURSE(CNT)) Q:'CNT  W !,?2,$P(NURSE(CNT),"^"),?40,$P(NURSE(CNT),"^",2)
 D UL G:SRSOUT END^SRONRPT1 W !,"Other Scrubbed Assistants: " S NYUK=0 F  S NYUK=$O(^SRF(SRTN,28,NYUK)) Q:'NYUK  D SCRUB
 D UL G:SRSOUT END^SRONRPT1 I $D(^SRF(SRTN,.6)),$P(^(.6),"^",9)'="" S Z=$P(^(.6),"^",9) D N W !,"Valid Consent Confirmed By: "_Z
 S MOOD=$P(SRTN(.1),"^",9),CONS=$P(SRTN(.1),"^",15),CONV=$P(SRTN(.1),"^",14)
 W !,"Preop Mood: "_$S(MOOD'="":$P(^SRO(135.3,MOOD,0),"^"),1:""),?40,"Preop Cons: "_$S(CONS'="":$P(^SRO(135.4,CONS,0),"^"),1:"")
 S INTEG=$P(SRTN(0),"^",7) W !,"Preop Skin Integ: "_$S(INTEG'="":$P(^SRO(135.2,INTEG,0),"^"),1:"")
 I CONV'="" W ?40,"Preop Converse: " S Q(3)=^DD(130,.195,0),Q(7)=CONV D S W Q(7)
 I $P(^SRF(SRTN,0),"^",8) D UL G:SRSOUT END^SRONRPT1 W !,"Preop Skin Color: " S Q(3)=^DD(130,.08,0),Q(7)=$P(SRTN(0),U,8) D S W Q(7)
 D UL G:SRSOUT END^SRONRPT1 S Z=$P(SRTN(.1),"^",8) D N W !,"Skin Prepped By: ",Z S PREPAGNT=$P(SRTN(.1),"^",7) I PREPAGNT W ?40,"Skin Prep Agent: "_$P(^SRO(135.1,PREPAGNT,0),"^")
 D UL G:SRSOUT END^SRONRPT1 S Z=$P(SRTN(.1),"^",12) D N W !,"Skin Prep By (2): ",$E(Z,1,30) I $D(^SRF(SRTN,31)),$P(^(31),"^",2)'="" W ?40,"Second Prep Agent: "_$P(^SRO(135.1,$P(^(31),"^",2),0),"^"),!
 G ^SRONRPT2
UL Q:SRSOUT  I SRT="UL" D UL1
Q I $Y+11>IOSL D FOOT^SRONRPT Q:SRSOUT  D HDR^SRONRPT
 Q
END W ! D ^SRSKILL D ^%ZISC W @IOF I $D(SRSITE("KILL")) K SRSITE
 Q
NURSE ; nurse info
 S (CNT,CIRC)=0 F  S CIRC=$O(^SRF(SRTN,19,CIRC)) Q:'CIRC  S CNT=CNT+1,Z=^SRF(SRTN,19,CIRC,0),X=$P(Z,"^"),Y=$P(Z,"^",3),X=$P(^VA(200,X,0),"^"),CIRC(CNT)=$E(X,1,20)_$S(Y="":"",Y="F":"(FULLY TRAINED)",Y="O":"(ORIENTEE)",1:"")
 S (CNT,SCRU)=0 F  S SCRU=$O(^SRF(SRTN,23,SCRU)) Q:'SCRU  S CNT=CNT+1,Z=^SRF(SRTN,23,SCRU,0),X=$P(Z,"^"),Y=$P(Z,"^",3),X=$P(^VA(200,X,0),"^"),SCRU(CNT)=$E(X,1,20)_$S(Y="":"",Y="F":"(FULLY TRAINED)",Y="O":"(ORIENTEE)",1:"")
 F I=1:1:5 Q:('$D(SCRU(I))&'$D(CIRC(I)))  S NURSE(I)=$S($D(SCRU(I)):SCRU(I),1:"")_"^"_$S($D(CIRC(I)):CIRC(I),1:"")
 Q
SCRUB ; other scrubbed assistants
 S X=$P(^SRF(SRTN,28,NYUK,0),"^") I X S SHEMP=$P(^VA(200,NYUK,0),"^") W !,?2,SHEMP
 Q
UL1 I IO(0)=IO,'$D(ZTQUEUED) W !
 W $C(13) F X=1:1:79 W "_"
 Q
N S Z=$S(Z="":Z,$D(^VA(200,Z,0)):$P(^(0),U,1),1:Z) Q
S Q:Q(7)=""  S Z1=$P(Q(3),U,3) F X1=1:1 Q:Q(7)=$P($P(Z1,";",X1),":",1)  Q:X1=50
 Q:X1=50  S Q(7)=$P($P(Z1,";",X1),":",2) Q
