BARVHF ; IHS/SD/LSL - View Host File 3/27/2002 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/SDR -04/03/02 - V1.6 Patch 2 - NOIS XXX-0202-200181
 ;     Routine created.
 ;     Called from VHF menu option allowing user to view a host file
 ;
 ; *********************************************************************
 Q
 ;
EN ; EP      
 K DIR,X,Y
 S BARPATH=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),"^",17)
 S DIR(0)="F^A"
 S DIR("A")="Directory"
 S DIR("B")=BARPATH
 D ^DIR
 Q:$D(DIRUT)!($D(DTOUT))!($D(DUOUT))!($D(DIROUT))
 S BARPATH=Y
 K DIR
 ;
 S DIR(0)="F^A"
 S DIR("A")="File name"
 D ^DIR
 Q:$D(DIRUT)!($D(DTOUT))!($D(DUOUT))!($D(DIROUT))
 S BARFILE=Y
 K DIR
 ;
 D FILE^XBLM(BARPATH,BARFILE)
 K BARPATH,BARFILE,X,Y
 Q
