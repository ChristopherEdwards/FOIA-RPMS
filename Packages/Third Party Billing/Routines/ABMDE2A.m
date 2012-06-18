ABMDE2A ; IHS/ASDST/DMJ - PAGE 2 - INSURER VIEW OPTION ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - V2.5 P2 - 4/17/02 - NOIS NEA-0401-180046
 ;     Modified to include coverage type in claim editor for
 ;     the insurer view portion
 ;
 ; IHS/SD/SDR - v2.5 p8 task 8
 ;    Added code to look for replacement insurer
 ;
 ; IHS/SD/SDR - v2.5 p9 - IM18938
 ;    Added RATE CODE to display
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   Added display of TIN
 ;
 ; *********************************************************************
 ;
V1 ; view
 I $E(Y,2)>0&($E(Y,2)<(ABMZ("NUM")+1)) D  G V2
 .S Y=$E(Y,2)
 I ABMZ("NUM")=1 D  G V2
 .S Y=1
 K DIR
 S DIR(0)="NO^1:"_ABMZ("NUM")_":0"
 S DIR("?")="Enter the Sequence Number of "_ABMZ("ITEM")_" to View"
 S DIR("A")="Sequence Number to VIEW"
 D ^DIR
 K DIR
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)!(+Y'>0)
 ;
V2 ;
 S Y=$P(ABMZ(+Y),U,3)
 S ABM("XIEN")=+Y
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 S Y=$S($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,+Y,0),U,11)'="":$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,+Y,0),U,11),1:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,+Y,0),U))
 D SEL^ABMDE2X
 S ABMZ("TITL")="INSURER - VIEW OPTION"
 D SUM^ABMDE1
 S ABMV="",$P(ABMV,"-",80)=""
 W !,"Insurer..: ",$E($P($P(ABMV("X1"),U),";",2),1,30)
 W ?45,"Phone....: ",$P(ABMV("X1"),U,2)
 W !,"Prov. No.: ",$P(ABMV("X1"),U,7)
 W ?45,"Contact..: ",$E($P(ABMV("X1"),U,3),1,24)
 W !,"TIN......: ",$P($G(^AUTNINS($P(ABMV("X1"),";"),0)),U,11)
 S ABMPRI=0,ABMPFLG=0
 F  S ABMPRI=$O(ABML(ABMPRI)) Q:+ABMPRI=0!($G(ABMPFLG)=1)!($G(ABMPFLG)=2)  D  Q:($G(ABMPFLG)=1)!($G(ABMPFLG)=2)
 .I $G(ABML(ABMPRI,Y))'="",(ABMPRI>97) S ABMPFLG=1
 .I $G(ABML(ABMPRI,Y))'="" S ABMPFLG=2
 I $G(ABMPFLG)=1 W !,"*UNBILLABLE* for reason ",$P($G(^ABMDCS($P($G(ABML(ABMPRI,Y)),U,6),0)),U)
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0)),U,11)'="" D
 .W !?5,"**This insurer replaces "
 .W $P($G(^AUTNINS($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,ABM("XIEN"),0)),U),0)),U)
 .W " for this claim only!"
 W !,ABMV
 W !,$S($P($P(ABMV("X1"),U),";",2)="MEDICARE":"HIC Number.......: ",1:"Policy Number....: "),$P(ABMV("X1"),U,4)
 I $P($G(ABMV("X1")),U,13)'="" W ?45,"Rate Code.......:",$P($G(ABMV("X1")),U,13)
 I ABMV("X2")="" G ERR
 W !,"Group Name.......: ",$P(ABMV("X3"),U,6)
 W ?45,"Group Number....: ",$P(ABMV("X3"),U,7)
 S ABMCOV=""
 F  S ABMCOV=$O(ABMP("COV",ABMCOV)) Q:ABMCOV=""  D
 .S ABMEDT=$P(ABMP("COV",ABMCOV),U)
 .S ABMEEDT=$P(ABMP("COV",ABMCOV),U,2)
 .W !,?3,"Elig dt: ",$$SDT^ABMDUTL(ABMEDT),?30,"Elig end dt: ",$$SDT^ABMDUTL(ABMEEDT)
 .W ?55,"Coverage: ",$E(ABMCOV,1,24)
 W !,ABMV
 W !,"Policy Holder.: ",$P($P(ABMV("X2"),U),";",2)
 W ?48,"Relationship..: ",$P($P(ABMV("X2"),U,2),";",2)
 W !?16,$P(ABMV("X2"),U,3)
 W ?48,"Home Phone....: ",$P(ABMV("X2"),U,5)
 W !?16,$P(ABMV("X2"),U,4)
 W !!?3,"Employer...: ",$P(ABMV("X3"),U)
 W ?48,"Empl. Status..: ",$P($P(ABMV("X3"),U,5),";",2)
 W !?16,$P(ABMV("X3"),U,2)
 W ?48,"Work Phone....: ",$P(ABMV("X3"),U,4)
 W !?16,$P(ABMV("X3"),U,3)
 ;
ERR ;
 D ^ABMDERR
 W !
 S ABM("Y")=+Y
 ;
XIT ;
 K ABM
 Q
