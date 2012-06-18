BARRDET ; IHS/SD/LSL - AGE DETAIL REPORT JAN 16,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
START ; EP
 ; SUMMARY DETAIL report
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),"^",1)
 D DATE
 G:$G(BAREFLG) END
 S DIR(0)="S^I:INSURER;C:CLINIC;B:BEN/NONBEN"
 D ^DIR
 G:Y<0!($D(DTOUT))!($D(DUOUT)) END
 S BAR("SELECTION")=Y(0)
 D @$S(Y="I":"INS",Y="C":"CLIN",1:"BEN")
 D TEMP
 D PRINT
 ;
END ;
 K BAR,FR,TO,BY,DHD,FLDS,L,Y,DIC
 Q
 ; *********************************************************************
 ;
DATE ;
 ; Select Date Range
 D DATE^BARRADAL
 Q
 ; *********************************************************************
 ;
PRINT ;
 ; Print
 S DIC="90050.01"
 S L=0
 D EN1^DIP
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
TEMP ;
 ; Multiple insurers (all) option
 S DHD="[BAR MGMTDET HDR]"
 I $G(FR)="" S FR="@,@,"_BAR("BDOS"),BAR("CNAME")="ALL"
 I $G(TO)="" S TO=",,"_BAR("EDOS")
 S FLDS="[BAR MGMTDET PRNT]"
 Q
 ; *********************************************************************
 ;
INS ;
 ;Single Insurer print
 S BY="+3;S2,@101,@7;S2"
 K DIC
 S DIC("A")="Select Insurer or press <RETURN> for all Insurers: "
 S DIC="90050.02"
 S DIC(0)="AEMQZ"
 S DIC("S")="I $P(^(0),U)[""AUT"",$P(^(0),U,10)=$$VALI^XBDIQ1(200,DUZ,29)"
 D ^DIC
 Q:Y<0
 S BAR("CNAME")=Y(0,0)
 S FR=BAR("CNAME")_",,"_BAR("BDOS")
 S TO=BAR("CNAME")_",,"_BAR("EDOS")
 Q
 ; *********************************************************************
 ;
CLIN ;
 ; Single Clinic print
 S BY="+112;S2,@101,@7;S2"
 K DIC
 S DIC("A")="Select Clinic or press <RETURN> for all Clinics: "
 S DIC="40.7"
 S DIC(0)="AEMQZ"
 D ^DIC
 Q:Y<0
 S BAR("CNAME")=Y(0,0)
 S FR=BAR("CNAME"),TO=BAR("CNAME")
 Q
 ; *********************************************************************
 ;
BEN ;
 ; Single Benificiary print
 S BY="+115,@101,@7;S2"
 S FR="0"
 S TO="1"
 Q
