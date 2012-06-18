ASURO800 ; IHS/ITSC/LMH -RPT 80 ISS-ANAL SELECT ACCOUNTS ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine sorts report 80 extracts into proper sequence so that the
 ;report can be formatted and printed.
 D:'$D(IO) HOME^%ZIS
 I $D(^XTMP("ASUR","R80")) D
 .S DIR("A")="Use Last Report 80 Selections",DIR(0)="Y",DIR("?")="^D LASL^ASURO80" D ^DIR K DIR
 E  S Y=0
 I $D(DTOUT)!($D(DUOUT)) Q
 I Y Q
EN1 ;EP;SELECT NEW PARAMETERS
 S ASUT="R80"
 K ^XTMP("ASUR","R80")
 S ^XTMP("ASUR","R80",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 S ASUF("ALL","ACC")=0,DIR("A")="Report on all Accounts",DIR(0)="Y" D ^DIR Q:$D(DUOUT)  Q:$D(DTOUT)
 I Y D
 .S ASUF("ALL","ACC")=1 K DIR
 .F X=0:0 S X=$O(^ASUL(9,X)) Q:X'?1N.N  S ^XTMP("ASUR","R80",0,X)=X_U_$P(^ASUL(9,X,0),U)
 E  D
 .K DIR
 .F  D  Q:$D(DTOUT)!($D(DUOUT))!(Y<0)
 ..S DIR("A")="Report for what Account",DIR(0)="PO^9002039.09:MXEZ",DIR("?")="Enter valid Account Code " D ^DIR
 ..I $D(DTOUT)!($D(DUOUT)!(Y<0)) Q
 ..S ^XTMP("ASUR","R80",0,+Y)=Y
 I $D(DTOUT)!($D(DUOUT)) Q
 S ASUT(ASUT,"ACC")=""
 F  S ASUT(ASUT,"ACC")=$O(^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"))) Q:ASUT(ASUT,"ACC")']""  D ASURO801
 S ASUF("OK")=1
 S DIR(0)="Y",DIR("A")="Do you want to review your selections" D ^DIR
 I Y D
 .D SEL
 .W !!,"In answering the following, a response of 'Y' will process your Selections"
 .W !,"An answer of 'N' will erase your selections and allow you to enter new ones",!
 .S DIR("A")="Are selections OK"
 .D ^DIR
 .K DIR
 .I Y D
 ..S ASUF("OK")=1
 .E  D
 ..S ASUF("OK")=0
 I $D(DUOUT)!($D(DTOUT)) K ^XTMP("ASUR","R80") Q
 I 'ASUF("OK") G EN1
 W !!,"Gathering Data for your Selections",!
 S ASUMX("E#","IDX")=0
 F  S ASUMX("E#","IDX")=$O(^ASUMX(ASUMX("E#","IDX"))) Q:ASUMX("E#","IDX")'?1N.N  D
 .D READ^ASUMXDIO Q:ASUMX("CAT")']""
 .I $D(^XTMP("ASUR","R80",0,ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"))) D
 ..W "."
 ..S ^XTMP("ASUR","R80",1,ASUMX("IDX"))=ASUMX("E#","IDX")
 D:'$D(ASUK("DT","FM")) ^ASUUDATE
 S ^XTMP("ASUR","R80",2)=ASUK("DT","FM")
 D ASURO803
 K X,ASUF("ALL")
 Q
ASURO801 ;
 I ASUF("ALL","ACC") D
 .S Y=1
 E  D
 .S DIR("A")="Report on all Object Sub-Objects for Account "_ASUT(ASUT,"ACC"),DIR(0)="Y" D ^DIR
 I $D(DTOUT)!($D(DUOUT)) Q
 I Y D
 .S ASUF("ALL","OBJ")=1 K X,DIR
 .F Y=0:0 S Y=$O(^ASUL(3,Y)) Q:Y'?1N.N  D
 ..S (ASUT(ASUT,"SOBJ"),X)=^ASUL(3,Y,1) D SCROBJ Q:'$T
 ..S ^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"),ASUT(ASUT,"SOBJ"))=Y_U_^ASUL(3,Y,0)
 E  D
 .F  D  Q:$D(DTOUT)!($D(DUOUT))!(ASUT(ASUT,"SOBJ")="")
 ..S ASUF("ALL","OBJ")=0,DIR(0)="PO^9002039.03:MXZEA",DIR("A")="Select Object Sub-Object: ",ASUT("TRCD")=""
 ..D READOBJ I $D(DUOUT)!($D(DTOUT))!(ASUT(ASUT,"SOBJ")="") Q
 ..D SSO^ASULDIRF(ASUL(3,"SOBJ","E#"))
 ..S ^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"),ASUT(ASUT,"SOBJ"))=ASUL(3,"SOBJ","E#")_U_ASUL(3,"SOBJ","NM")
 .K DIR,X,Y
 S ASUT(ASUT,"SOBJ")=""
 F  S ASUT(ASUT,"SOBJ")=$O(^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"),ASUT(ASUT,"SOBJ"))) Q:ASUT(ASUT,"SOBJ")']""  D ASURO802
 Q
ASURO802 ;
 S ASUL(3,"SOBJ","E#")=$P(^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"),ASUT(ASUT,"SOBJ")),U)
 I ASUT(ASUT,"ACC")=$G(ASUV("ACC")) D
 .S ASUV("ACC")=ASUT(ASUT,"ACC") W !,"PROCESSING ACCOUNT: ",ASUT(ASUT,"ACC")
 I ASUF("ALL","OBJ") D
 .S Y=1
 E  D
 .S DIR("A")="Report on all Categorys for Ofject Sub-Object "_ASUT(ASUT,"SOBJ"),DIR(0)="Y" D ^DIR
 I $D(DTOUT)!($D(DUOUT)) Q
 I Y D
 .K X,Y,DIR
 .S ASUF("ALL","CAT")=1,Y=ASUL(3,"SOBJ","E#")_"00"
 .F  S Y=$O(^ASUL(7,Y)) Q:ASUL(3,"SOBJ","E#")'=$E(Y,1,3)  D
 ..S (ASUL(7,"CAT","CD"),X)=$P(^ASUL(7,Y,1),U)
 ..S ^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"),ASUT(ASUT,"SOBJ"),ASUL(7,"CAT","CD"))=Y_U_^ASUL(7,Y,0)
 E  D
 .S ASUF("ALL","CAT")=0
 .F  D  Q:$G(ASUT(ASUT,"CAT"))']""!($D(DTOUT))!($D(DUOUT))
 ..S DIR("A")="Select Category: ",ASUS("OPTN")="PO" D READCAT Q:ASUT(ASUT,"CAT")']""
 ..D CAT^ASULDIRF(ASUL(7,"CAT","E#"))
 ..I $D(DUOUT)!($D(DTOUT)) Q
 ..S ^XTMP("ASUR","R80",0,ASUT(ASUT,"ACC"),ASUT(ASUT,"SOBJ"),ASUL(7,"CAT","CD"))=ASUL(7,"CAT","E#")_U_ASUL(7,"CAT","NM")
 K DIR,X,Y
 Q
ASURO803 ;
 S ASUL(2,"STA","E#")=$G(ASUL(1,"AR","STA1"))
 I ASUL(2,"STA","E#")']"" W !,"SORRY, YOU AREA NOT AUTHORIZED TO RUN THIS REPORT" K DIR S DIR(0)="E" D ^DIR S DUOUT=1 Q
 D STA^ASULARST(ASUL(2,"STA","E#"))
 S ^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"))=ASUL(1,"AR","NM")
 S ^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUL(2,"STA","E#"))=ASUL(2,"STA","NM")_U_ASUL(2,"STA","CD")
 S ASUX("IDX")=""
 F  S ASUX("IDX")=$O(^XTMP("ASUR","R80",1,ASUX("IDX"))) Q:ASUX("IDX")']""  D
 .S ASUMK("E#","STA")="",ASUMK("E#","IDX")=^XTMP("ASUR","R80",1,ASUX("IDX"))
 .F  S ASUMK("E#","STA")=$O(^ASUMK("C",ASUMK("E#","IDX"),ASUMK("E#","STA"))) Q:ASUMK("E#","STA")']""  D
 ..W "."
 ..S ASUMK("E#","REQ")=""
 ..F  S ASUMK("E#","REQ")=$O(^ASUMK("C",ASUMK("E#","IDX"),ASUMK("E#","STA"),ASUMK("E#","REQ"))) Q:ASUMK("E#","REQ")']""  D IBMST
 Q
IBMST ;
 D READ^ASUMKBIO
 S ASUL(18,"E#","SST")=$E(ASUMK("E#","REQ"),1,5) D SST^ASULDIRR(ASUL(18,"E#","SST")),REQ^ASULDIRR(ASUMK("E#","REQ"))
 S ASUMX("E#","IDX")=^XTMP("ASUR","R80",1,ASUMK("IDX"))
 D READ^ASUMXDIO
 S $P(^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"),ASUMX("DESC",1),ASUL(18,"E#","SST")),U)=ASUL(18,"SST","NM")
 S ASUX(2)=^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"),ASUMX("DESC",1),ASUL(18,"E#","SST"))
 S $P(ASUX(2),U,2)=$P(ASUX(2),U,2)+ASUMK("CFY","VAL")
 S $P(ASUX(2),U,3)=$P(ASUX(2),U,3)+ASUMK("PFY","VAL")
 S $P(ASUX(2),U,4)=$P(ASUX(2),U,4)+ASUMK("PPY","VAL")
 S ^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"),ASUMX("DESC",1),+ASUL(18,"E#","SST"))=ASUX(2)
 S $P(^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"),ASUMX("DESC",1)),U,4)=ASUMX("E#","IDX")
 S ASUX=^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"),ASUMX("DESC",1))
 S $P(ASUX,U)=$P(ASUX,U)+ASUMK("CFY","VAL")
 S $P(ASUX,U,2)=$P(ASUX,U,2)+ASUMK("PFY","VAL")
 S $P(ASUX,U,3)=$P(ASUX,U,3)+ASUMK("PPY","VAL")
 S $P(ASUX,U,5)=ASUMX("IDX")
 S $P(ASUX,U,6)=ASUMX("DESC",2)
 S ^XTMP("ASUR","R80",2,ASUL(2,"STA","E#"),ASUMX("ACC"),ASUMX("SOBJ"),ASUMX("CAT"),ASUMX("DESC",1))=ASUX
 Q
ASURO805 ;
LASL ;LIST LAST REPORT 80'S SELECTIONS
 S ASUC=0
 W !,"Last Selection(s) were:" S ASUC=ASUC+1 D PAUSE Q:$D(DTOUT)!($D(DUOUT))
 G CONTU
SEL ;LIST REPORT 80 SELECTIONS
 S ASUC=0
 W !,"Your Selection(s) are:" S ASUC=ASUC+1 D PAUSE Q:$D(DTOUT)!($D(DUOUT))
CONTU ;
 F  S ASUL=$O(^XTMP("ASUR","R80",0,$G(ASUL))) Q:ASUL']""  D  Q:$D(DTOUT)!($D(DUOUT))
 .W !?2,"Account: ",ASUL," ",$P(^XTMP("ASUR","R80",0,ASUL),U,2) S ASUC=ASUC+1 D PAUSE Q:$D(DTOUT)!($D(DUOUT))
 .F  S ASUA(1)=$O(^XTMP("ASUR","R80",0,ASUL,$G(ASUA(1)))) Q:ASUA(1)']""  D  Q:$D(DTOUT)!($D(DUOUT))
 ..W !?4,"Object Sub Object: ",ASUA(1)," ",$P(^XTMP("ASUR","R80",0,ASUL,ASUA(1)),U,2) S ASUC=ASUC+1 D PAUSE Q:$D(DTOUT)!($D(DUOUT))
 ..F  S ASUA(2)=$O(^XTMP("ASUR","R80",0,ASUL,ASUA(1),$G(ASUA(2)))) Q:ASUA(2)']""  D  Q:$D(DTOUT)!($D(DUOUT))
 ...W !?6,"Category: ",ASUA(2)," ",$P(^XTMP("ASUR","R80",0,ASUL,ASUA(1),ASUA(2)),U,2) S ASUC=ASUC+1 D PAUSE Q:$D(DTOUT)!($D(DUOUT))
 K ASUC,ASUF,ASUMX,ASUMS,ASUT,ASUV,ASUX
 Q
PAUSE ;EP;PAUSE AT END OF SCREEN
 Q:ASUC<IOSL
 N DIR
 S DIR(0)="E" D ^DIR
 S ASUC=0
 Q
READOBJ ;READ OBJECT SUB OBJECT CODE
 I ASUT(ASUT,"ACC")="" S ASUT(ASUT,"SOBJ")="" W !,DIR("A"),":" Q
 S DIR("S")="D SCROBJ^ASURO800"
 S DIR("?")="Object-Sub-Object not valid for Account "_ASUT(ASUT,"ACC")
 D ASU0EDIR
 I $D(DUOUT)!($D(DIROUT))!($D(DTOUT)) Q
 I Y<0 D
 .S (ASUL(3,"SOBJ","E#"),ASUT(ASUT,"SOBJ"))=""
 E  D
 .S ASUL(3,"SOBJ","E#")=+Y
 .S ASUV("SOBJ","NM")=$P(Y,U,2)
 .S ASUT(ASUT,"SOBJ")=$P(^ASUL(3,ASUL(3,"SOBJ","E#"),1),U)
 .I ASUT("TRCD")="4C" S ASUS("CHG")=1
 K DIR,X,Y
 Q
SCROBJ ;EP ;SCREEN
 I $E(Y)=ASUT(ASUT,"ACC")
 Q
READCAT ;EP; READ CATEGORY
 N DIR,X,Y
 S DIR("S")="D SCRCAT^ASURO800"
 S DIC("W")="W ?70,"" "",$P(^(1),U)"
 S DIR("?")="Category not valid for Account "_ASUT(ASUT,"ACC")_" and Object-Sub-Object "_ASUT(ASUT,"SOBJ")
 I $G(ASUS("OPTN"))']"" D
 .S ASUS("OPTN")="PO"
 .I ASUT(ASUT,"ACC")]"",ASUT(ASUT,"SOBJ")]"" S ASUS("OPTN")="P"
 S DIR(0)=ASUS("OPTN")_"^9002039.07:MXZA" K ASUS("OPTN")
 D ASU0EDIR
 I $D(DUOUT)!($D(DIROUT))!($D(DTOUT)) Q
 I Y>0 D
 .S ASUL(7,"CAT","E#")=+Y,ASUT(ASUT,"CAT NM")=$P(Y,U,2)
 .S ASUT(ASUT,"CAT")=$P(^ASUL(7,ASUL(7,"CAT","E#"),1),U)
 .W " ",ASUT(ASUT,"CAT")," ",ASUT(ASUT,"CAT NM")
 E  D
 .S ASUT(ASUT,"CAT")=""
 I ASUT(ASUT,"CAT")]"" S:ASUT("TRCD")="4C" ASUS("CHG")=1
 Q
SCRCAT ;SCREENING LOGIC
 I $E(Y)=ASUL(9,"ACC","E#"),$E(Y,1,3)=ASUL(3,"SOBJ","E#")
 Q
ASU0EDIR ;
 N X
 S:$D(DIR("S")) DIC("S")=DIR("S")
 S DIC("A")=DIR("A")
 I $D(DIR("B")) W DIR("B"),"// " S DIC("B")=DIR("B")
 S DIC=$P($P(DIR(0),U,2),":")
 S:DIC'?1N.E DIC=U_DIC
 S DIC(0)=$P($P(DIR(0),U,2),":",2)
 I $P(DIR(0),U)'["O" D
 .F  D ^DIC Q:$D(DTOUT)!($D(DUOUT))  Q:+Y>0  W "   Field is Required",!
 E  D
 .D ^DIC
 K DIC
 Q
