APSPMED2 ; IHS/DSD/ENM - PATIENT DEMOGRAPHICS ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
GET S DFN=DA D 6^VADPT,PID^VADPT
 U IO W @IOF
HDR ;EP
 S APSPAGE=APSPAGE+1 D NOW^%DTC S Y=X X ^DD("DD") W "Medication Profile",?35,Y,?65,"(Page "_APSPAGE_")"
 S APSPCN=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2) W !,"Chart #: ",APSPCN
 W !,VADM(1),?40,"ID#:   "_VA("PID")
 I +VAPA(9),+VAPA(10) W !?5,"(TEMP ADDRESS from "_$P(VAPA(9),"^",2)_" till "_$P(VAPA(10),"^",2)_")"
 W !,VAPA(1),?40,"DOB:   ",$S(+VADM(3):$P(VADM(3),"^",2),1:"UNKNOWN") W:VAPA(2)]"" !,VAPA(2) W:VAPA(3)]"" !,VAPA(3)
 W !,VAPA(4),?40,"PHONE: "_VAPA(8),!,$P(VAPA(5),"^",2)_"  "_VAPA(6),?40,"ELIG:  "_$P(VAEL(1),"^",2)
 I $D(^PS(55,DFN,0)) W:$P(^(0),"^",2) !,"CANNOT USE SAFETY CAPS." I +$P(^(0),"^",4) W ?40,"DIALYSIS PATIENT."
 I $G(^PS(55,DFN,1))]"" S X=^(1) W !!?5,"Pharmacy narrative: " F I=1:1 Q:$P(X," ",I,99)=""  W $P(X," ",I)," " W:$X>75 !
RE S PSLC=0 G MA:'$D(^DPT(DFN,.17)) G MA:$P(^(.17),"^",2)'="I"
 I '$D(VAEL(1)) D ELIG^VADPT W !!,"ELIGIBILITY: ",$P(VAEL(1),"^",2) S PSLC=PSLC+2
MA K SC W !,"DISABILITIES: ",! S PSLC=PSLC+2
 F I=0:0 S I=$O(^DPT(DFN,.372,I)) Q:'I  S I1=$S($D(^(I,0)):^(0),1:""),PSDIS=$S($D(^DIC(31,+I1,0)):$P(^(0),"^"),1:""),PSCNT=$P(I1,"^",2) X:($X+$L(PSDIS)+7)>72 "W !?10 S PSLC=PSLC+1" W PSDIS,"-",PSCNT,"% (",$S($P(I1,"^",3):"SC",1:"NSC"),"), "
 X "N X S X=""GMRADPT"" X ^%ZOSF(""TEST"") Q" I $T D:'$D(PSOPTPST) GMRA
Q K SC,I1,VAROOT,Y,AL,I,X,Y,PSCNT,PSLC,PSDIS Q
GMRA W !!,"REACTIONS: " D ^GMRADPT S I1=0 F I=0:0 S I=$O(GMRAL(I)) Q:I'>0  W:I1 ", " S AL=$P(GMRAL(I),"^",2) W:$X+$L(AL)>75 !?5 W AL S I1=1
 K GMRA,GMRAL Q
