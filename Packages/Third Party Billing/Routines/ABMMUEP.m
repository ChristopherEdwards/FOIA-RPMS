ABMMUEP ;IHS/SD/SDR - MU EP List of EPs Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;**7**;NOV 12, 2009
 ;
 I $P($G(^ABMMUPRM(1,0)),U,2)="" D  Q
 .W !!,"Setup has not been done.  Please do MUP option prior to running any reports",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;
EN ;
 D ^XBFMK
 W !!
 S DIR(0)="Y"
 S DIR("A",1)="The output for this report will contain a list of eligible provider classes"
 S DIR("A",2)=""
 S DIR("A",3)="You can also print providers that have an eligible provider class"
 S DIR("A",4)="This could be a lengthy list!"
 S DIR("A",5)=""
 S DIR("A")="Print the list of providers with eligible provider classes as well"
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMBOTH=Y
 S ABMQ("RC")="COMPUTE^ABMMUEP"
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 S ABMQ("RP")="PRINT^ABMMUEP"
 D ^ABMDRDBQ
 Q
COMPUTE ;
 Q
PRINT ;
 S ABM("PG")=1
 D HDR
 S ABMLAST=$O(^ABMMUPRM(1,2,9999),-1)
 S ABMCUTOF=$S(ABMLAST#2=1:(ABMLAST+1)\2,1:ABMLAST\2)
 S ABMCNT=0
 S ABMCNT2=ABMCUTOF
 F  S ABMCNT=$O(^ABMMUPRM(1,2,ABMCNT)) Q:'ABMCNT  D  Q:ABMCNT=ABMCUTOF
 .I $Y+5>IOSL D HD Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMCD=$$GET1^DIQ(7,$P($G(^ABMMUPRM(1,2,ABMCNT,0)),U),9999999.01,"E")
 .S ABMPC=$$GET1^DIQ(7,$P($G(^ABMMUPRM(1,2,ABMCNT,0)),U),.01,"E")
 .S ABMCD2=$$GET1^DIQ(7,$P($G(^ABMMUPRM(1,2,ABMCNT2,0)),U),9999999.01,"E")
 .S ABMPC2=$$GET1^DIQ(7,$P($G(^ABMMUPRM(1,2,ABMCNT2,0)),U),.01,"E")
 .S ABMCNT2=ABMCNT2+1
 .W !?3,ABMCD,?8,ABMPC,?40,ABMCD2,?45,ABMPC2
 ;
 I +$G(ABMBOTH)'=1 Q  ;don't write providers
 S ABM("PG")=ABM("PG")+1
 D HDR2
 K ^XTMP("ABM-EP",$J)
 S ABMNM=""
 S ABMCNT=0
 F  S ABMNM=$O(^VA(200,"B",ABMNM)) Q:$G(ABMNM)=""  D
 .S ABMIEN=0
 .F  S ABMIEN=$O(^VA(200,"B",ABMNM,ABMIEN)) Q:'ABMIEN  D
 ..Q:$$GET1^DIQ(200,ABMIEN,53.5,"I")=""
 ..Q:'$D(^ABMMUPRM(1,2,"B",$$GET1^DIQ(200,ABMIEN,53.5,"I")))  ;not on the provider class list
 ..S ABMCNT=ABMCNT+1
 ..S ^XTMP("ABM-EP",$J,ABMCNT)=$$GET1^DIQ(200,ABMIEN,.01,"E")_U_$$GET1^DIQ(7,$$GET1^DIQ(200,ABMIEN,53.5,"I"),9999999.01,"E")
 S ABMCUTOF=$S(ABMCNT#2=1:(ABMCNT+1)\2,1:ABMCNT\2)
 S ABMCNT=0,ABMCNT2=ABMCUTOF
 F  S ABMCNT=$O(^XTMP("ABM-EP",$J,ABMCNT)) Q:'ABMCNT!(ABMCNT=ABMCUTOF)  D  Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .I $Y+5>IOSL D HD2 Q:(IOST["C")&((+$G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 .S ABMP=$P($G(^XTMP("ABM-EP",$J,ABMCNT)),U)
 .S ABMPC=$P($G(^XTMP("ABM-EP",$J,ABMCNT)),U,2)
 .S ABMP2=$P($G(^XTMP("ABM-EP",$J,ABMCNT2)),U)
 .S ABMPC2=$P($G(^XTMP("ABM-EP",$J,ABMCNT2)),U,2)
 .S ABMCNT2=ABMCNT2+1
 .W !,$E(ABMP,1,33),?35,ABMPC,?40,$E(ABMP2,1,33),?75,ABMPC2
 K ^XTMP("ABM-EP",$J)
 Q
 ;
HD ;
 D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("PG")=+$G(ABM("PG"))+1
HDR ;EP
 D EN^ABMVDF("IOF")
 W $C(13)
 D CENTER^ABMUCUTL("               EP Class - List of Eligible Professionals               Page "_ABM("PG"))
 W ! D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report")
 W !
 D NOW^%DTC
 D CENTER^ABMUCUTL("Report Run Date:  "_$$CDT^ABMDUTL(%))
 I ABM("PG")=1 W !!,"PROVIDER CLASSES THAT WILL BE INCLUDED:"
 I ABM("PG")'=1 W !!,"(Cont)"
 W !?3,$$EN^ABMVDF("ULN"),"Code",$$EN^ABMVDF("ULF")
 W ?8,$$EN^ABMVDF("ULN"),"Provider Class",$$EN^ABMVDF("ULF")
 W ?40,$$EN^ABMVDF("ULN"),"Code",$$EN^ABMVDF("ULF")
 W ?45,$$EN^ABMVDF("ULN"),"Provider Class",$$EN^ABMVDF("ULF")
 Q
HD2 ;
 D PAZ^ABMDRUTL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("PG")=+$G(ABM("PG"))+1
HDR2 ;EP
 D EN^ABMVDF("IOF")
 W $C(13)
 D CENTER^ABMUCUTL("               EP Class - List of Eligible Professionals               Page "_ABM("PG"))
 W ! D CENTER^ABMUCUTL("IHS Meaningful Use Patient Volume Report")
 W !
 D NOW^%DTC
 D CENTER^ABMUCUTL("Report Run Date:  "_$$CDT^ABMDUTL(%))
 I ABM("PG")=1 W !!,"ELIGIBLE PROFESSIONALS"
 I ABM("PG")'=1 W !!,"(Cont)"
 W !,$$EN^ABMVDF("ULN"),"Provider",$$EN^ABMVDF("ULF")
 W ?34,$$EN^ABMVDF("ULN"),"Class",$$EN^ABMVDF("ULF")
 W ?40,$$EN^ABMVDF("ULN"),"Provider",$$EN^ABMVDF("ULF")
 W ?75,$$EN^ABMVDF("ULN"),"Class",$$EN^ABMVDF("ULF")
 Q
