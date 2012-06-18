BARRAGED ; IHS/SD/LSL - AGE OPEN ITEMS RPT JAN 16,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; ITSC/SD/LSL - 10/18/2002 - V1.7 - NOIS LWI-1002-160087
 ;        Include credit balances
 ;
 ; ********************************************************************
START ;EP-Aging reports
 ;
 S BARQUIT=0
 W !!
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),"^",1)
 S DIR(0)="S^1:0-30;2:31-60;3:61-90;4:91-120;5:120+"
 D ^DIR
 G:Y<0!($D(DUOUT))!($D(DTOUT)) END
 S BAR("SELECTION")=Y(0)
 S BARAGE=$S(Y=1:"7.3",Y=2:"7.4",Y=3:"7.5",Y=4:"7.6",Y=5:"7.7")
 D INS
 Q:BARQUIT
 D AGE
 D PRINT
 ;
END ;
 Q
 ; *********************************************************************
 ;
PRINT ;Print
 ;
 S DIS(0)="S BARX=$$GET1^DIQ(90050.01,D0,BARAGE) I $FN(BARX,""-"")>0"
 S DIC="90050.01"
 S L=0
 S DIOEND="I $E(IOST)=""C"" S DIR(0)=""E"" D ^DIR"
 D EN1^DIP
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
AGE ;Age
 S DHD="[BAR AGED HDR]"
 I $G(FR)="" S FR="@,@",BAR("CNAME")="ALL"
 I $G(TO)="" S TO="zzzz,zzzz"
 S FLDS="101;L25;N,.01;L19;105;L11,NUMDATE4(#102);L10,&"_BARAGE  ;Y2000
 Q
 ; *********************************************************************
 ;
INS ;**Single Insurer print
 S BY="+3;S1,@101"
 K DIC
 S DIC("A")="Select Insurer or press <RETURN> for all Insurers: "
 S DIC="90050.02"
 S DIC(0)="AEMQZ"
 S DIC("S")="I $P(^(0),U)[""AUT"",$P(^(0),U,10)=$$VALI^XBDIQ1(200,DUZ,29)"
 K DD,DO
 D ^DIC
 I X["^" S BARQUIT=1
 Q:Y<0
 S BAR("CNAME")=Y(0,0)
 S FR=BAR("CNAME")_","
 S TO=BAR("CNAME")_","
 Q
