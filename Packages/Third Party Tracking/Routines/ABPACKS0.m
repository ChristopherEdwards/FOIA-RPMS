ABPACKS0 ;AO PVT-INS CHECK SUMMARY DISPLAY; [ 06/26/91  7:56 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"<<< NOT AN ENTRY POINT - ACCESS DENIED >>>",!! Q
 ;---------------------------------------------------------------------
CLEAR ;PROCEDURE TO KILL ALL TEMPORARY VARIABLES
 K I,GOTCHECK,RESTRICT,ABPACHK
 Q
 ;---------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 K ABPA("HD") S ABPA("HD",1)=ABPATLE,ABPA("HD",2)=$P(XQO,"^",2)
 D ^ABPAHD
 Q
 ;---------------------------------------------------------------------
GETCHK ;PROCEDURE PROCESS INPUT OF A CHECK NUMBER
 F I=0:0 D  Q:(GOTCHECK)!(('GOTCHECK)&((Y="")!(Y["^")))  W *7,"  ??"
 .S RESTRICT=0 W !! D MAIN^ABPACKLK
 .I $D(ABPACHK)=1 I ABPACHK]""&('GOTCHECK) S Y=" "
 I GOTCHECK D
 .S ABPA("DTIN")=ABPACHK("XMIT") D DTCVT^ABPAMAIN
 .S ABPACHK("RCVD")=ABPA("DTOUT")
 Q
 ;---------------------------------------------------------------------
DEVICE ;PROCEDURE TO PROCESS OUTPUT DEVICE SELECTION
 K %IS S %IS="H",%IS("A")="Use which device: " W ! D ^%ZIS U IO
 Q
 ;---------------------------------------------------------------------
HEAD2 ;PROCEDURE TO DRAW CHECK SUMMARY HEADER
 S ABPAPG=ABPAPG+1 W @IOF,!
 S ABPA("DTIN")=DT D DTCVT^ABPAMAIN W ABPA("DTOUT")
 S X=ABPATLE_" - Check Summary" W ?40-($L(X)/2),X
 S X="Page ("_ABPAPG_")" W ?79-$L(X),X,!
 F I=1:1:79 W "=" I I=79 W !
 W " Check #: ",ABPACHK("NUM")," for ",$E(ABPACHK("APNAM"),1,27)
 W ?56,"Amount: ",$J(ABPACHK("AMT"),8,2)
 W !,"   Payor: ",ABPACHK("PAYOR"),?55,"Balance: "
 W $J(ABPACHK("RAMT"),8,2),!,"Received: ",ABPACHK("RCVD"),?53
 W "Last User: ",ABPACHK("LUSR"),! F I=1:1:79 W "=" I I=79 W !
 W "Facility",?13,"Patient Name",?38,"DOS Beg/End",?54
 W "Amount Insurer Name",!
 Q
 ;---------------------------------------------------------------------
DETAIL ;PROCEDURE TO EXTRACT AND WRITE OUT THE DETAIL RECORDS
 S DA(2)=0,ABPA("TAMT")=0,ABPAX=""
 F ABPAI=0:0 D  Q:+DA(2)=0!(ABPAX="^")
 .S DA(2)=$O(^ABPVAO("CK",ABPACHK("NUM"),DA(2))) Q:+DA(2)=0  S DA(1)=0
 .F ABPAJ=0:0 D  Q:+DA(1)=0!(ABPAX="^")
 ..S DA(1)=$O(^ABPVAO("CK",ABPACHK("NUM"),DA(2),DA(1))) Q:+DA(1)=0
 ..S ABPA("PAT")="",ABPA("FAC")="" I $D(^ABPVAO(DA(2),0))=1 D
 ...S DATA=^ABPVAO(DA(2),0),ABPA("PAT")=$P(DATA,"^")
 ...S ABPAPTR=$P(DATA,"^",2) Q:$D(^AUTTLOC(ABPAPTR,0))'=1
 ...I $P(^AUTTLOC(ABPAPTR,0),"^",4)'=ABPACHK("AP") S ABPAX="^" Q
 ...S DATA=^AUTTLOC(ABPAPTR,0),ABPA("FAC")=$P(DATA,"^",2)
 ..I ABPAX="^" S ABPAX="" Q
 ..S ABPA("BDOS")=9999999,ABPA("EDOS")=0,ABPA("INS")=""
 ..I $D(^ABPVAO(DA(2),"P",DA(1),"D",0))=1 D
 ...S DA=0 F ABPAK=0:0 D  Q:+DA=0
 ....S DA=$O(^ABPVAO(DA(2),"P",DA(1),"D",DA)) Q:+DA=0
 ....Q:$D(^ABPVAO(DA(2),"P",DA(1),"D",DA,0))'=1
 ....S ABPA("DOS")=+^ABPVAO(DA(2),"P",DA(1),"D",DA,0)
 ....I ABPA("DOS")<ABPA("BDOS") S ABPA("BDOS")=ABPA("DOS")
 ....I ABPA("DOS")>ABPA("EDOS") S ABPA("EDOS")=ABPA("DOS")
 ....S ABPAPTR=$P(^ABPVAO(DA(2),"P",DA(1),"D",DA,0),"^",2)
 ....Q:$D(^ABPVAO(DA(2),1,ABPAPTR,0))'=1
 ....S ABPAPTR=$P(^ABPVAO(DA(2),1,ABPAPTR,0),"^",6)
 ....Q:$D(^AUTNINS(ABPAPTR,0))'=1
 ....S ABPA("INS")=$E($P(^AUTNINS(ABPAPTR,0),"^"),1,18)
 ..S ABPA("DTIN")=ABPA("BDOS") D DTCVT^ABPAMAIN
 ..S ABPA("BDOS")=ABPA("DTOUT")
 ..S ABPA("DTIN")=ABPA("EDOS") D DTCVT^ABPAMAIN
 ..S ABPA("EDOS")=ABPA("DTOUT"),ABPA("AMT")=0
 ..I $D(^ABPVAO(DA(2),"P",DA(1),"A",0))=1 D
 ...S DA=0 F ABPAK=0:0 D  Q:+DA=0
 ....S DA=$O(^ABPVAO(DA(2),"P",DA(1),"A",DA)) Q:+DA=0
 ....Q:$D(^ABPVAO(DA(2),"P",DA(1),"A",DA,0))'=1
 ....Q:$P(^ABPVAO(DA(2),"P",DA(1),"A",DA,0),"^",2)'="S"
 ....S ABPA("AMT")=ABPA("AMT")+(+^ABPVAO(DA(2),"P",DA(1),"A",DA,0))
 ..S ABPA("TAMT")=ABPA("TAMT")+ABPA("AMT")
 ..W !,ABPA("FAC"),?13,$E(ABPA("PAT"),1,20),?34,$J(ABPA("BDOS"),8)
 ..W " ",$J(ABPA("EDOS"),8),?52,$J(ABPA("AMT"),8,2),?61,ABPA("INS")
 ..I $Y>(IOSL-3) D  Q:ABPAX="^"  D HEAD2
 ...I $E(IOST,1)'="P" D
 ....S ABPAMESS="...Press any key to continue or ""^"" to exit..."
 ....U IO(0) D PAUSE^ABPAMAIN U IO
 Q:ABPAX="^"  I ABPA("TAMT")=0 D  Q
 .W !!,"No payments found using this check for this accounting point."
 W !?52,"--------",!?52,$J(ABPA("TAMT"),8,2)
 Q
 ;---------------------------------------------------------------------
CLOSE ;PROCEDURE TO PROCESS OUTPUT DEVICE CLOSING
 U IO W ! X ^%ZIS("C") S IOP=$I D ^%ZIS K IOP
 Q
 ;---------------------------------------------------------------------
MAIN ;THE OVERALL ROUTINE DRIVER - ENTRY POINT TO THIS PROGRAM
 D CLEAR,HEAD,GETCHK I 'GOTCHECK D CLEAR Q
 D DEVICE I $E(IOST,1)="P" U IO(0) W ! D WAIT^DICD U IO
 S ABPAPG=0 D HEAD2,DETAIL,CLOSE G:ABPAX="^" MAIN
 D PAUSE^ABPAMAIN
 G MAIN
