BARBL ; IHS/SD/LSL - AGE DAY LETTER AND LIST ; 07/30/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**3,4,6**;OCT 26, 2005
 ;;
 W !!,"Enter the minimum age (in days) of bills to be itemized."
 K DIR
 S DIR(0)="N0^0:9000"
 D ^DIR
 K DIR
 Q:Y'>0
 S BARAGE=Y
 D SELACC
 Q:$G(BARQUIT)
 S DIR("A")="Summary Only"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 S BARSUM=Y
 S BARSBY=1
 I '$G(BARSUM) D
 .S DIR(0)="S^1:POLICY HOLDER;2:POLICY NUMBER;3:PATIENT;4:DATE OF SERVICE"
 .S DIR("A")="Within Account Sort By"
 .S DIR("B")=1
 .D ^DIR
 .K DIR
 .S BARSBY=Y
 S %ZIS="NQ"
 S %ZIS("A")="Print to Device: "
 D ^%ZIS
 Q:POP
 I IO'=IO(0) D QUE,EXIT,HOME^%ZIS Q
 I $D(IO("S")) D
 . S IOP=ION
 . D ^%ZIS
 ;
AGE ; *
 ; * dequeing compute point
 K ^TMP("BAR",$J,"BLAGE")
 S BARSVC=$$GET1^DIQ(200,DUZ,29)
 I '$D(BARSAC) D
 .S BARACDA=0
 .F  S BARACDA=$O(^BARBL(DUZ(2),"ABAL",BARACDA)) Q:'BARACDA  D ONEAC
 I $D(BARSAC) D
 .S BARACDA=0
 .F  S BARACDA=$O(BARSAC(BARACDA)) Q:'BARACDA  D ONEAC
 D PRINT
 I $D(IO("S")) D ^%ZISC
 D EXIT
 Q
 ; *********************************************************************
 ;
ONEAC ;ONE A/R ACCOUNT
 S DA=0
 F  S DA=$O(^BARBL(DUZ(2),"ABAL",BARACDA,DA)) Q:'DA  D
 .K BART
 .D ENP^XBDIQ1(90050.01,DA,"3;7.2;10;15","BART(","I")
 .I BART(7.2)<BARAGE Q  ;age
 .I BART(10)'=BARSVC Q  ;SVC
 .S BARSVAL=$G(^BARBL(DUZ(2),DA,7))
 .Q:BARSVAL=""                          ;MRS:BAR*1.8*6 IM29966
 .S $P(BARSVAL,"^",3)=$P(^BARBL(DUZ(2),DA,1),"^",16)
 .S $P(BARSVAL,"^",4)=$P(^BARBL(DUZ(2),DA,1),"^",2)
 .S BARSVAL=$P(BARSVAL,"^",BARSBY)
 .S:BARSVAL="" BARSVAL="UNKNOWN"
 .S ^TMP("BAR",$J,"BLAGE",BARACDA,BARSVAL,DA)=BART(15)
 .S ^TMP("BAR",$J,"BLAGE",BARACDA)=$G(^TMP("BAR",$J,"BLAGE",BARACDA))+BART(15)
 Q
 ; *********************************************************************
 ;
PRINT ;
 ;** deque for print
 D SUMMARY
 Q:$G(BARQUIT)
 Q:$G(BARSUM)
 S BARACDA=0
 F  S BARACDA=$O(^TMP("BAR",$J,"BLAGE",BARACDA)) Q:BARACDA'>0  S BARTOT=^(BARACDA) Q:$G(BARQUIT)  D
 .K BARA
 .D ENP^XBDIQ1(90050.02,BARACDA,".01;1:1.99","BARA(","N")
 .D LETTER
 .Q:$G(BARQUIT)
 .D LIST
 Q
 ; *********************************************************************
 ;
LETTER ;
 ; ** print letter
 W $$EN^BARVDF("IOF")
 D ENP^XBDIQ1(90052.03,2,".01;100","BARLT(")
 S BARL=0
 ;** header
 F BARL=BARL+1:1 Q:'$D(BARLT(100,BARL))  Q:$E(BARLT(100,BARL))="~"  W !,BARLT(100,BARL)
 ;** address
 W !,"DATE:",?10,$$MDT2^BARDUTL(DT)
 ;W !!,"TO:",?10,BARA(.01)
 W !!,"TO:",?10,$G(BARA(.01))  ;BAR*1.8*4 IM????? OCCURRED DURING BETA TESTING
 S DR=1.01
 ;W !,?10,BARA(1.01)
 W !,?10,$G(BARA(1.01))  ;IHS/SD/TPF BAR*1.8*3 IM25704
 F  S DR=$O(BARA(DR)) Q:DR'>0  W !,?10,BARA(DR)
 ;** from
 S BARFDA=$$GET1^DIQ(9002274.5,1,.23,"I")
 G:BARFDA'>0 CNT
 K BARF
 D ENP^XBDIQ1(9999999.06,BARFDA,".14:.17","BARF(")
 W !!,"FROM: ",$G(BARUSR(29)),"  address for payments"
 W !,?5,BARF(.14)
 W !,?5,BARF(.15)
 W !,?5,BARF(.16)
 W !,?5,BARF(.17)
 K BARF
CNT F BARL=BARL+1:1 Q:'$D(BARLT(100,BARL))  Q:$E(BARLT(100,BARL))="~"  W !,BARLT(100,BARL)
 ;** regarding
 W !,"Regarding Past due bills over  ",BARAGE," days totaling  $ ",$FN(BARTOT,",",2)
 ;** body
 F BARL=BARL+1:1 Q:'$D(BARLT(100,BARL))  Q:$E(BARLT(100,BARL))="~"  W !,BARLT(100,BARL)
 F BARL=BARL+1:1 Q:'$D(BARLT(100,BARL))  Q:$E(BARLT(100,BARL))="~"  W !,BARLT(100,BARL)
 D EOP
 Q
 ; *********************************************************************
 ;
LIST ;** list bills
 S BARBLDA=0,BARSVAL=0
 S BARPG("HDR")=BARA(.01)_"   over  "_BARAGE_"  days"
 D BARHDR
 F  S BARSVAL=$O(^TMP("BAR",$J,"BLAGE",BARACDA,BARSVAL)) Q:BARSVAL=""  D
 .F  S BARBLDA=$O(^TMP("BAR",$J,"BLAGE",BARACDA,BARSVAL,BARBLDA)) Q:BARBLDA'>0  Q:$G(BARQUIT)  D  Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ..K BARB
 ..D ENP^XBDIQ1(90050.01,BARBLDA,".01;101;102;13;15;7.2;701;702","BARB(","I")
 ..W !,$E(BARB(701),1,22)
 ..W ?25,$E(BARB(702),1,12)
 ..W ?39,$E(BARB(.01),1,8)
 ..W ?49,$$FMDT(BARB(102,"I"))
 ..W ?58,$J(BARB(13),10,2)
 ..W ?69,$J(BARB(15),10,2)
 ..W !,"Pat:",?5,BARB(101),"   Comment:"
 ..F  W "_" Q:$X+3>IOM
 ..W !
 ..I $Y+4>IOSL D
 ...D EOP
 ...D PG
 W !!,"TOTAL: ",?67,$J("$"_$FN(BARTOT,",",2),12)
 D EOP
 Q
 ; *********************************************************************
 ;
SUMMARY ;
 S BARPG("HDR")="Summary of bills/accounts over "_BARAGE_" days"
 D BARHDR
 S (BARAC,BARTOT,BARCNT)=0
 F  S BARAC=$O(^TMP("BAR",$J,"BLAGE",BARAC)) Q:BARAC'>0  Q:$G(BARQUIT)  S X=^(BARAC) S BARTOT=BARTOT+X D  Q:$G(BARQUIT)
 .W !,$$GET1^DIQ(90050.02,BARAC,.01),?50,$J($FN(X,",",2),12)
 .Q:$Y+6'>IOSL
 .D EOP
 .D PG
 Q:$G(BARQUIT)
 W !!,"TOTAL ALL ACCOUNTS:",?50,$J($FN(BARTOT,",",2),12),!!
 W !!,?15,"E N D   O F   R E P O R T",!!
 D EOP
 Q
 ; *********************************************************************
 ;
SELACC ;
 ; ** select accounts to print
 K BARSAC
 W !,"Select individual A/R accounts or hit RETURN for ALL accounts."
 S DIC=$$DIC^XBDIQ1(90050.02)
 S DIC(0)="AEQMZ"
 S DIC("S")="I $P(^(0),U,10)=$$VALI^XBDIQ1(200,DUZ,29)"
 F  D ^DIC Q:Y'>0  S BARSAC(+Y)=Y(0,0)
 Q:'$D(BARSAC)
 S DA=0
 W !
 F  S DA=$O(BARSAC(DA)) Q:'DA  W !,BARSAC(DA)
 W !
 K DIR
 S DIR(0)="Y"
 S DIR("B")="YES"
 S DIR("A")="Selected Account(s) Correct"
 D ^DIR
 I Y Q
 K BARSAC
 G SELACC
 ; *********************************************************************
 ;
FMDT(X) ;
 ; cvt fmdt to mm/dd/yyyy
 S X=$$SDT^BARDUTL(X)
 Q X
 ; *********************************************************************
 ;
PG ;
BARPG ;EP PAGE CONTROLLER
 ; this utility uses variables BARPG("HDR"),BARPG("DT"),BARPG("LINE"),BARPG("PG")
 ; kill variables by D EBARPG
 ;
 S BARPG("PG")=+$G(BARPG("PG"))+1
 ;
BARHDR ;EP
 ; write page header
 W $$EN^BARVDF("IOF")
 W !
 Q:'$D(BARPG("HDR"))
 S:'$D(BARPG("LINE")) $P(BARPG("LINE"),"=",IOM)=""
 S:'$D(BARDASH) $P(BARDASH,"-",IOM)=""
 S:'$D(BARPG("PG")) BARPG("PG")=1
 W ?(IOM-40-$L(BARPG("HDR"))/2),BARPG("HDR")
 W ?(IOM-24),$$SDT^BARDUTL(DT)
 W ?(IOM-10),"PAGE: ",BARPG("PG")
 W !,BARPG("LINE")
 ;
BARHD ;EP
 ; Write column header / message
 W !
 I BARPG("HDR")'["mmary" W "Policy Holder",?25,"Policy #",?39,"Claim #",?49,"DOS",?58,$J("Amt Bld",10),?69,$J("Balance",10)
 W !,BARDASH,!
 Q
 ; *********************************************************************
 ;
EBARPG ;
 K BARPG("LINE"),BARPG("PG"),BARPG("HDR"),BARPG("DT")
 Q
 ; *********************************************************************
 ;
QUE ;QUE
 N I
 F I="BARSAC*","BARSBY","BARAGE","BARSUM" S ZTSAVE(I)=""
 S ZTRTN="AGE^BARBL"
 S ZTDESC="AGED DAY LETTER"
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
 ; *********************************************************************
 ;
EXIT ;clean up and quit
 K DIC,BARSAC,BARSBY,BARA,BARB,BARPG,BARAC,BARACDA,BARAGE,BARBLDS
 K BARCNT,BARFDA,BARJOB,BARL,BARLT,BARQUIT,BARSVAL,BARSVC,BART,BARTOT
 W $$EN^BARVDF("IOF")
 Q
 ; *********************************************************************
 ;
EOP ;end of page
 I IO=IO(0),'$D(IO("S")),'$G(ZTQUEUED) D
 .F  W ! Q:$Y+4>IOSL
 .D EOP^BARUTL(0)
 .S:'Y BARQUIT=1
 Q
