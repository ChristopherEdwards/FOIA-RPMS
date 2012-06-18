DGPMRBA1 ;ALB/MIR - PRINT FROM BED AVAILABILITY ; [ 11/08/2001  3:04 PM ]
 ;;5.3;Registration;;Aug 13, 1993
 ;IHS/ANMC/LJF  6/28/2001 added code to screen out inactive wards
 ;                        added IHS code for scheduled admissions
 ;
PR D NOW^%DTC S DGDT=%,(DGPG,DGFL,DGI)=0,Y=DGDT X ^DD("DD") S DGNOW=Y G:DGOPT="S" SV I 'VAUTW F I1=0:0 S DGI=$O(VAUTW(DGI)) Q:DGI=""  S W=VAUTW(DGI) D PRINT Q:DGFL
 I VAUTW F I1=0:0 S DGI=$O(^DIC(42,"B",DGI)) Q:DGI=""  S J=$O(^(DGI,0)) S W=J D PRINT Q:DGFL
 Q
SV I 'DGSV F I1=0:0 S DGI=$O(DGSV(DGI)) Q:DGI=""!DGFL  D HEAD F DGJ=0:0 S DGJ=$O(^DIC(42,"D",DGI,DGJ)) Q:'DGJ  S W=DGJ D PRINT Q:DGFL
 I DGSV F I1=0:0 S DGI=$O(^DIC(42,"D",DGI)) Q:DGI=""!DGFL  D HEAD F DGJ=0:0 S DGJ=$O(^DIC(42,"D",DGI,DGJ)) Q:'DGJ  S W=DGJ D PRINT Q:DGFL
 Q
 ;
 ;
 ;IHS/ANMC/LJF 6/28/2001 screen for inactive wards
PRINT ;I $S('$D(^DIC(42,+W,0)):1,VAUTD:0,'$P(^(0),"^",11)&$D(VAUTD(+$O(^DG(40.8,0)))):0,$D(VAUTD(+$P(^DIC(42,+W,0),"^",11))):0,1:1) Q
 I $S('$D(^BDGWD(+W,0)):1,$P($G(^BDGWD(+W,0)),U,3)="I":1,VAUTD:0,'$P(^(0),"^",11)&$D(VAUTD(+$O(^DG(40.8,0)))):0,$D(VAUTD(+$P(^DIC(42,+W,0),"^",11))):0,1:1) Q
 ;IHS/ANMC/LJF 6/28/2001 end of mods
 ;
 ;
 S D0=W D WIN^DGPMDDCF I X Q
 S (DGA,DGL)=0,DGNM=$P(^DIC(42,+W,0),"^",1) I 'DGPG!($Y>(IOSL-8)) D HEAD Q:DGFL
ABB ;call in here for abbreviated (single ward) bed availability
ABBREV ;abbreviated bed availability
 W !!,DGNM,":  "
EN F I=0:0 S I=$O(^DG(405.4,"W",W,I)) Q:I'>0!(DGFL)  I $D(^DG(405.4,+I,0)) S J=^(0),J=$P($P(J,"^",1,3)_"^^^","^",1,3),DGR=$P(J,"^",1) D ACT I 'DGU D DIS
 I 'DGA W ?21,"There are no available beds on this ward."
 ;
 ;
 ;IHS/ANMC/LJF 6/28/2001 use IHS file for scheduled admissions
 ;G LD:'$O(^DGS(41.1,"ARSV",W,0))!'DGSA S DGONE=0
 ;F I=0:0 S I=$O(^DGS(41.1,"ARSV",W,I)) Q:'I  I $D(^DGS(41.1,I,0)) S J=^(0) I '$P(J,"^",13),($P(J,"^",2)'<DT),'$P(J,"^",17) W:'DGONE !?3,"Future Scheduled Admissions:" S DGONE=1 D SA
 ;
 G LD:'$O(^BDGSV("AC","A",W,0))!'DGSA S DGONE=0
 NEW BDGDT S BDGDT=$$FMADD^XLFDT(DT,14)   ;limit to 2 weeks in future
 S I=DT-1 F  S I=$O(^BDGSV("AC","A",W,I)) Q:'I  Q:(I>BDGDT)  D
 . S J=0 F  S J=$O(^BDGSV("AC","A",W,I,J)) Q:'J  D
 .. W:'DGONE !?3,"Scheduled Admissions for next 2 weeks:" S DGONE=1
 .. W !?5,$$GET1^DIQ(9009016.7,J,.01)," -- ",$$GET1^DIQ(9009016.7,J,.011)
 .. W " on ",$$GET1^DIQ(9009016.7,J,.02)
 ;IHS/ANMC/LJF 6/28/2001 end of mods
 ;
 ;
LD I '$D(^UTILITY("DGPMLD",$J))!'DGLD Q
 W !?3,"Lodgers occupy the following beds:"
 S DGL=1,DGR=0 F J1=0:0 S DGR=$O(^UTILITY("DGPMLD",$J,DGR)) Q:DGR=""  S J=^(DGR) D LOD
 K ^UTILITY("DGPMLD",$J) Q
 ;
ACT S M=$O(^DGPM("ARM",I,0)) I M S DGU=1 Q:'^(M)  D LDGER Q
 S DGU=0,X=$O(^DG(405.4,I,"I","AINV",0)),X=$O(^(+X,0)) I $D(^DG(405.4,I,"I",+X,0)) S DGND=^(0) D AVAIL
 I DGU Q
 S DGA=DGA+1 Q
 ;
AVAIL I +DGND'>DGDT,$S('$P(DGND,"^",4):1,$P(DGND,"^",4)>DGDT:1,1:0) S DGU=1
 Q
 ;
DIS ;display available room-beds with/without descriptions
 ;
 ;IHS/ANMC/LJF 6/28/2001 if room used by >1 ward, mark with *
 I $O(^DG(405.4,I,"W",+$O(^DG(405.4,I,"W",0)))) D
 . S $P(J,U,1)="*"_$P(J,U,1)
 ;IHS/ANMC/LJF 6/28/2001 end of new code
 ;
 I 'DGDESC W:DGA=1 !?3 S $P(J,"^",1)=$E($P(J,"^",1)_"                    ",1,18) W:$X+$L($P(J,"^",1))>79 !?3 W $P(J,"^",1) Q
 W:DGA#2 !?3 I '(DGA#2) W ?40
 W $E($P(J,"^",1),1,18) I $D(^DG(405.6,+$P(J,"^",2),0)) W "   (",$E($P(^(0),"^",1),1,15),")"
 Q
LOD W !?5,DGR," is occupied by ",$P(J,"^",4)," - PT ID: ",$S($P(J,"^",5)]"":$P(J,"^",5),1:"UNKNOWN")
 Q
LDGER ;create UTILITY for lodgers
 ;J=ROOM-BED NAME^DESCRIPTION^T.S
 S J=$S($D(^DGPM(+M,0)):$P(^(0),"^",3),1:"")
 Q:'$D(^DPT("LD",DGNM,+J))!'$D(^DPT(+J,0))  ;if lodger not on this ward
 S ^UTILITY("DGPMLD",$J,DGR)=J_"^^^"_$P(^DPT(+J,0),"^",1)
 N DFN S DFN=J D PID^VADPT6 S ^(DGR)=^UTILITY("DGPMLD",$J,DGR)_"^"_VA("PID")
 Q
HEAD I DGPG,($E(IOST)="C") K DIR S DIR(0)="E" D ^DIR S DGFL='Y Q:DGFL
 S DGPG=DGPG+1 W @IOF,!,"BED AVAILABILITY FOR ",DGNOW,?70,"PAGE:",$J(DGPG,5),! K X S $P(X,"-",81)="" W X,!
 I DGOPT="S" W !?25,"SERVICE:  ",$P($P(DGSTR,";"_DGI_":",2),";",1)
 Q
SA W !?5 W:$D(^DPT(+J,0)) $P(^(0),"^",1)," -- " S DFN=+J D PID^VADPT6 W VA("PID") S Y=$P(J,"^",2) I J W " on " D DT^DIQ
 Q
