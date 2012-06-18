BATTXCH ; IHS/CMI/LAB - ASTHMA TAXONOMY CHECK ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
TAXCHK ;EP
 K BATQUIT
 W !,"Checking for Taxonomies to support the ASTHMA REGISTER System...",!
 NEW A,BATX,I,Y,Z,J
 K A
 S T="TAXS" F J=1:1 S Z=$T(@T+J),BATX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BATX=""  D
 .I '$D(^ATXAX("B",BATX)) S A(BATX)=Y_"^is Missing" Q
 .S I=$O(^ATXAX("B",BATX,0))
 .I '$D(^ATXAX(I,21,"B")) S A(BATX)=Y_"^has no entries "
 S T="LAB" F J=1:1 S Z=$T(@T+J),BATX=$P(Z,";;",2),Y=$P(Z,";;",3) Q:BATX=""  D
 .I '$D(^ATXLAB("B",BATX)) S A(BATX)=Y_"^is Missing " Q
 .S I=$O(^ATXLAB("B",BATX,0))
 .I '$D(^ATXLAB(I,21,"B")) S A(BATX)=Y_"^has no entries "
 I '$D(A) W !,"All taxonomies are present.",! K A,BATX,Y,I,Z D DONE Q
 W !!,"In order for this application to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BATX="" F  S BATX=$O(A(BATX)) Q:BATX=""!($D(BATQUIT))  D
 .I $Y>(IOSL-2) D PAGE Q:$D(BATQUIT)
 .W !,$P(A(BATX),U)," [",BATX,"] ",$P(A(BATX),U,2)
 .Q
DONE ;
 K BATQUIT
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
XIT ;EP
 K BAT,BATX,BATQUIT,BATLINE,BATJ,BATX,BATTEXT,BAT
 K X,Y,J
 Q
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT="" Q
 Q
TAXS ;
 ;;BAT ASTHMA DIAGNOSES;;Asthma ICD 9 diagnoses codes
 ;;BAT ASTHMA RELIEVER MEDS;;Taxonomy of Asthma Reliever Meds
 ;;BAT ASTHMA INHALED STEROIDS;;Taxonomy of Asthma Inhaled Steroids
 ;;BAT ASTHMA CONTROLLER MEDS;;Taxonomy of Asthma Controller Meds
 ;;
 ;;
HS ;EP - called from option
 W:$D(IOF) @IOF
 S BATOPT=$O(^DIC(19,"B","BAT HS SETUP",0))
 I 'BATOPT W !!,"oops something is wrong, option doesn't exist." D EOJ Q
W ;write out array
 W:$D(IOF) @IOF
 K BATQUIT
 S BATX=0 F  S BATX=$O(^DIC(19,BATOPT,1,BATX)) Q:BATX'=+BATX!($D(BATQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BATQUIT)
 .W !,^DIC(19,BATOPT,1,BATX,0)
 .Q
 D EOJ
 Q
 ;
EOJ ;
 D HEADER
 K BATOPT,BATQUIT,BATX
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BATQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 Q
