BARPMUP1 ; IHS/SD/LSL - MANUAL UPLOAD PROCESS JAN 15,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 12/12/02 - V1.7 - NHA-0601-180049
 ;      Find the right bill in 3PB.
 ;
 ; *********************************************************************
 ;** Manual upload process for a single 3p bill
 ; *********************************************************************
 ;
ONE ;EP
 N DIC,BARDA,BARSTAT
 ; -------------------------------
 ;
SELSAT ; checking for satellite selection
 K BARQUIT
 W !,"Please pick the satellite you wish to load",!
 S DIC=$$DIC^XBDIQ1(90052.05)
 S DA(1)=DUZ(2)
 S DIC(0)="AEQMZ"
 D ^DIC
 I Y'>0 W !,"NONE PICKED",! Q
 S BARDUZ2=DUZ(2)
 F  D SELSATE Q:$D(DIRUT)
 S DUZ(2)=BARDUZ2
 K BARDUZ2
 Q
 ; *********************************************************************
 ;
SELSATE ;
 N BARBILLS,BAR3PBIL,BARCNT,BAR3PAT,BASR3DOS,Y
 W !!
 K DIR
 S DIR("A")="Select 3P Bill: "
 S DIR(0)="FA^2:8"
 D ^DIR
 Q:$D(DIRUT)
 S BAR3PBIL=Y
 D FINDBILL
 I '$D(BARBILLS) W "     Bill not found in 3PB." Q
 I +$G(BARCNT)>1 D CHOOSE
 Q:'+$G(BARCNT)
 S Y=$P(BARBILLS(BARCNT),U,2)
 S DUZ(2)=$P(BARBILLS(BARCNT),U)
 D L2 Q:+Y<0
 Q
 ; *********************************************************************
 ;
FINDBILL ;
 K BARCNT,BARBILLS
 N BAR3PAT,BAR3DOS
 S DUZ(2)=0
 F  S DUZ(2)=$O(^ABMDBILL(DUZ(2)))  Q:'+DUZ(2)  D LOOP3P
 Q
 ; *********************************************************************
 ;
LOOP3P ;
 S DIC="^ABMDBILL(DUZ(2),"
 S DIC(0)="XZ"
 S X=BAR3PBIL
 K DD,DO
 D ^DIC
 Q:Y<0
 S BAR3PAT=$$GET1^DIQ(9002274.4,+Y,.05)
 S BAR3DOS=$$SDT^BARDUTL($P($G(^ABMDBILL(DUZ(2),+Y,7)),U))
 S BARCNT=$G(BARCNT)+1
 S BARBILLS(BARCNT)=DUZ(2)_U_+Y_U_Y(0,0)_U_BAR3PAT_U_BAR3DOS
 Q
 ; *********************************************************************
 ;
CHOOSE ;
 K BARCNT
 W !!,"The system has found more than one matching bill in 3PB.",!
 S BAR1=0
 F  S BAR1=$O(BARBILLS(BAR1))  Q:'+BAR1  D
 . S BARD=BARBILLS(BAR1)
 . S BARCNT2=BAR1
 . W !,BAR1,?5,$P(BARD,U,3),?30,$E($P(BARD,U,4),1,30),?62,$P(BARD,U,5)
 K DIR
 S DIR("A")="Please select one (enter the line #): "
 S DIR(0)="NA^1:BARCNT2"
 D ^DIR
 Q:$D(DIRUT)
 S BARCNT=Y
 Q
 ; *********************************************************************
 ;
L2 ;
 W !
 S Y(0)=$G(^ABMDBILL(DUZ(2),Y,0))
 S DA=+Y
 S ABMA("BLNM")=$P(Y(0),U)
 S ABMA("PTNM")=$P(Y(0),U,5)
 S ABMA("VSLC")=$P(Y(0),U,3)
 D BLNM^ABMAPASS
 S BARBLNM=ABMA("BLNM")
 W !,BARBLNM,!
 K DIR
 S DIR("A")="  Correct"
 S DIR("B")="YES"
 S DIR(0)="Y"
 D ^DIR
 K DIR
 Q:Y'=1
 ; -------------------------------
 ;
 ; always reload A/R Bill items from 3P
 I $D(^BARBL(BARDUZ2,"B",BARBLNM))  D  Q:Y'=1
 .W !!,*7,"This bill has already been uploaded to A/R!"
 .W !,*7,"Do you really want to Reload it from 3P? "
 .W !!
 .S DIR("B")="YES"
 .S DIR(0)="Y"
 .D ^DIR
 .K DIR
 S BARSTAT=$$GET1^DIQ(9002274.4,DA,.04)
 W !!,"Uploading "_BARBLNM_" ..."
 D EXT^ABMAPASS
 W "Done."
 Q
