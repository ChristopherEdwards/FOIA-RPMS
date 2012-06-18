ABMDPINQ ; IHS/SD/SDR - Inquire UTILITY ;  
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - Split Provider inquire
 ;   into separate routine and added fields
 ;
PRV ;EP for displaying Provider Record
 S ABM("SUB")="PROVIDER"
 D HD
 S DIC="^VA(200,"
 S DIC("S")="I $D(^(""PS""))"
 ;
DIC W !!
 S DIC("A")="Select "_ABM("SUB")_": "
 S DIC(0)="QEAM"
 D ^DIC
 G XIT:X=""!(X["^")!$D(DUOUT)!$D(DTOUT)
 I +Y<1 G DIC
 S DA=+Y
 W $$EN^ABMVDF("IOF")
 W !?80-$L(ABM("SUB"))-21\2,"*** ",ABM("SUB")," FILE INQUIRY ***"
 S ABM="",$P(ABM,"=",80)=""
 S $P(ABMDASH,"-",80)=""
 W !!,ABM
 K S
 D GETS^DIQ(200,DA,".01;8;20.2;29;53.5;9999999.01;9999999.06;9999999.07;9999999.08","E","ABMZ")
 S ABMPRV=DA_","
 D WRITE
 W ABM
 G DIC
 ;
XIT K ABM,DIR,DIC,DIE
 Q
 ;
HD K DIC,DR
 Q
WRITE ;
 W !,"NAME: ",$G(ABMZ(200,ABMPRV,.01,"E"))
 W ?50,"TITLE: ",$G(ABMZ(200,ABMPRV,8,"E"))
 W !,"PROVIDER CLASS: ",$G(ABMZ(200,ABMPRV,53.5,"E"))
 W ?50,"AFFILIATION: ",$G(ABMZ(200,ABMPRV,9999999.01,"E"))
 W !!,"SERVICE/SECTION.............: ",$G(ABMZ(200,ABMPRV,29,"E"))
 W !,"SIGNATURE BLOCK PRINTED NAME: ",$G(ABMZ(200,ABMPRV,20.2,"E"))
 ;
 W !,$E(ABMDASH,1,26),"National Provider Identifier",$E(ABMDASH,1,26)
 W !?3,"NPI",?20,"Effective Date",?40,"Status"
 S ABMI=0
 F  S ABMI=$O(^VA(200,+ABMPRV,"NPISTATUS",ABMI)) Q:+ABMI=0  D
 .W !?3,$P($G(^VA(200,+ABMPRV,"NPISTATUS",ABMI,0)),U,3)  ;NPI
 .W ?20,$$CDT^ABMDUTL($P($G(^VA(200,+ABMPRV,"NPISTATUS",ABMI,0)),U))  ;effective date
 .W ?40,$S($P($G(^VA(200,+ABMPRV,"NPISTATUS",ABMI,0)),U,2)=1:"ACTIVE",$P($G(^VA(200,+ABMPRV,"NPISTATUS",ABMI,0)),U,2)=0:"INSACTIVE",1:"")  ;status
 K ABMI
 ;
 W !!,$E(ABMDASH,1,32),"Provider Numbers",$E(ABMDASH,1,32)
 W !,"MEDICARE PROVIDER NUMBER.....: ",$G(ABMZ(200,ABMPRV,9999999.06,"E"))
 W !,"MEDICAID PROVIDER NUMBER.....: ",$G(ABMZ(200,ABMPRV,9999999.07,"E"))
 W !,"UPIN NUMBER..................: ",$G(ABMZ(200,ABMPRV,9999999.08,"E"))
 W !,"TAXONOMY CODE................: ",$$PTAX^ABMEEPRV(+ABMPRV)
 ;
 W !,$E(ABMDASH,1,32),"Licensing States",$E(ABMDASH,1,32)
 W !?3,"State",?10,"License Number"
 S ABMI=0
 F  S ABMI=$O(^VA(200,+ABMPRV,"PS1",ABMI)) Q:+ABMI=0  D
 .W !?3,$P($G(^DIC(5,$P($G(^VA(200,+ABMPRV,"PS1",ABMI,0)),U),0)),U,2)
 .W ?10,$P($G(^VA(200,+ABMPRV,"PS1",ABMI,0)),U,2)
 K ABMI
 ;
 W !,$E(ABMDASH,1,25),"Payer Assigned Provider Number",$E(ABMDASH,1,25)
 W !?3,"Insurer",?35,"Payer Assigned Provider Number"
 S ABMI=""
 D GETS^DIQ("200",ABMPRV,"9999999.18*","E","ABMINS")
 F  S ABMI=$O(ABMINS(200.9999918,ABMI)) Q:$G(ABMI)=""  D
 .W !?3,ABMINS(200.9999918,ABMI,.01,"E")
 .W ?35,$G(ABMINS(200.9999918,ABMI,.02,"E"))
 K ABMINS
 ;
 W !!,$E(ABMDASH,1,34),"Person Class",$E(ABMDASH,1,34)
 W !,"Effective Date  Ending Date  Person Class"
 S ABMI=0
 F  S ABMI=$O(^VA(200,+ABMPRV,"USC1",ABMI)) Q:+ABMI=0  D
 .W !,$$SDT^ABMDUTL($P($G(^VA(200,+ABMPRV,"USC1",ABMI,0)),U,2))
 .W ?16,$$SDT^ABMDUTL($P($G(^VA(200,+ABMPRV,"USC1",ABMI,0)),U,3))
 .W ?29,$P($G(^USC(8932.1,$P($G(^VA(200,+ABMPRV,"USC1",ABMI,0)),U),0)),U)
 K ABMI
 W !
 Q
