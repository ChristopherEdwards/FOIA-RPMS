AKMOMNUS ;IHS/AAO/RPL;Set Synonyms for Kernel Options ;[ 12/20/90  8:50 AM ] ; 10/3/91  10:05 AM
 ;;2.0;IHS KERNEL UTILITIES;;JUN 28, 1993
 ;IHS/MFD renamed to AKMO namespace
 W !,"Not an entry point.",! Q
SET ;Set Synonym data into OPTION file
 D ^XBKVAR
 I '$D(^AKMOMNUS(1,0)) W !,"MENU SYNONYM DATA File not built!",! Q
 W !,"Setting Synonyms and Display Order according to the MENU SYNONYM FILE.",!!
 S AKMO("SQ")=0
 F I=0:0 S AKMO("SQ")=$O(^AKMOMNUS(AKMO("SQ"))) Q:AKMO("SQ")'=+AKMO("SQ")  D S1
 K AKMO Q
S1 S AKMO("NM")=$P(^AKMOMNUS(AKMO("SQ"),0),"^")
 S AKMO("OPT")=$O(^DIC(19,"B",AKMO("NM"),"")) Q:AKMO("OPT")']""  D S2
 Q
S2 S AKMO("ITM")=0
 K AKMO("GOT1") F J=0:0 S AKMO("ITM")=$O(^AKMOMNUS(AKMO("SQ"),1,AKMO("ITM")))  Q:AKMO("ITM")'=+AKMO("ITM")  D S3
 Q
S3 S AKMO("ITNM")=$P(^AKMOMNUS(AKMO("SQ"),1,AKMO("ITM"),0),"^"),AKMO("ISYN")=$P(^(0),"^",2),AKMO("ITORD")=$P(^(0),"^",3)
 S AKMO("ITNO")=$O(^DIC(19,"B",AKMO("ITNM"),"")) Q:AKMO("ITNO")']""
 S AKMO("ITDFN")=$O(^DIC(19,AKMO("OPT"),10,"B",AKMO("ITNO"),"")) Q:AKMO("ITDFN")']""
 ;
 W ! G:$D(AKMO("GOT1")) S3A W !,"Option",?25,$J("Item",7),?33,$J("Item",10),?62,"Item",?71,"Order"
 W !,$J("DFN",6),?8,"Option Name",?25,$J("Sub DFN",7),?33,$J("Option DFN",10),?45,"Item Option Name",?62,"Synonym",?71,"Number"
 W !,"------",?8,"---------------",?25,"-------",?33,"----------",?45,"----------------",?62,"--------",?71,"------"
 W !,$J(AKMO("OPT"),6),?8,$E(AKMO("NM"),1,15) S AKMO("GOT1")=""
S3A W ?25,$J(AKMO("ITDFN"),7),?33,$J(AKMO("ITNO"),10),?45,$E(AKMO("ITNM"),1,15),?62,AKMO("ISYN"),?71,$J(AKMO("ITORD"),6)
 S DIE="^DIC(19,"_AKMO("OPT")_",10,",DA(1)=AKMO("OPT"),DA=AKMO("ITDFN"),DR="2///"_AKMO("ISYN")_";3///"_AKMO("ITORD") D ^DIE K DIE,DA,DR
 Q
BUILD ;Build File to hold data
 D ^XBKVAR
 I $D(^AKMOMNUS(1)) W !,"MENU SYNONYM DATA File already built!",!,"Delete All entries with FileMan if you want to rebuild it.",! Q
 S AKMO("NM")="AKMOEVE" D B1
 S AKMO("NM")="X"
 F I=0:0 S AKMO("NM")=$O(^DIC(19,"B",AKMO("NM"))) Q:AKMO("NM")=""  D B1
 K AKMO
 Q
B1 S AKMO("OPT")=$O(^DIC(19,"B",AKMO("NM"),"")) Q:AKMO("OPT")=""
 S AKMO("ITM")=0
 K AKMO("GOT1"),AKMO("DFN")
 F J=0:0 S AKMO("ITM")=$O(^DIC(19,AKMO("OPT"),10,AKMO("ITM"))) Q:AKMO("ITM")'=+AKMO("ITM")  D B2
 Q
B2 ;
 S AKMO("ITNM")=$P(^(AKMO("ITM"),0),"^"),AKMO("ITSY")=$P(^(0),"^",2),AKMO("ITORD")=$P(^(0),"^",3)
 I AKMO("ITSY")']"" Q
 S AKMO("ITNM")=$P(^DIC(19,AKMO("ITNM"),0),"^")
 I '$D(AKMO("GOT1")) D B3
 W ?30,AKMO("ITNM"),?60,AKMO("ITSY"),?70,AKMO("ITORD"),!
TMP S DA=AKMO("DFN"),DIE="^AKMOMNUS(",DR="1///"""_AKMO("ITNM")_"""",DR(2,8007699.01)="1///"_AKMO("ITSY")_";2///"_AKMO("ITORD") D ^DIE K DR,DIE
 Q
B3 S AKMO("GOT1")="" W !,AKMO("NM")
 S DIC(0)="L",DIC="^AKMOMNUS(",X=AKMO("NM") D FILE^DICN K DIC
 S AKMO("DFN")=+Y
 Q
