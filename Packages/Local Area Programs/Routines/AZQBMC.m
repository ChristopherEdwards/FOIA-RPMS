AZQBMC ; IHS/PHXAO/TMJ - Auto Print of Laguna Tribe Referrals [ 04/24/01  4:55 PM ]
 ;;1.0;REFERRED CARE INFO SYSTEM;;April 25, 2001
 ;
 ;
 ;
 ;
BD ;get beginning date
 ;
 S BMCSTRT=DT-7
 S BMCSTRT=$$FMTE^XLFDT(BMCSTRT,"2P")
 ;
 S BMCBD=BMCSTRT
ED ;get ending date
 ;
 S BMCEND=DT S BMCEND=$$FMTE^XLFDT(BMCEND,"2P")
 S BMCED=BMCEND
 ;
 ;
 ;
 ;
PRINT ;PRINT CHS REFERRALS FOR LAGUNA TRIBE - LAST 7 DAYS
 ;
 S FLDS="[AZQBMC PRINT]",BY="@#.01,INTERNAL(#.04)=""C"",PATIENT:TRIBE OF MEMBERSHIP:CODE=""081""",DIC="^BMCREF(",L=0
 S FR=BMCBD,TO=BMCED
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BMCBD,BMCED,X,DD0,B Q