BARRADAL ; IHS/SD/LSL - ADVISE OF ALLOWANCE RPT JAN 16,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
START ; EP
 ; Collections report using FM print
 ;
S ;
 N DIR
 S DIR(0)="S^D:DETAIL;S:SUMMARY"
 S DIR("A")="ADVICE OF ALLOWANCE Report type"
 D ^DIR
 K DIR
 I Y<0!($D(DTOUT))!($D(DUOUT)) Q
 S BAR("RPTYPE")=Y
 D DATE
 G:$D(BAREFLG) END
 D DIPVAR
 D PRINT
 D EOP^BARUTL(1)
 ;
END ;
 Q
 ; *********************************************************************
 ;
DATE ; EP
 ; Select Date Range
 K BAREFLG
 W !
 S BAR("BDOS")=$$DATE^BARDUTL(1)
 I Y<0 S BAREFLG=1 Q
 S BAR("XBDOS")=$$MDT^BARDUTL(BAR("BDOS"))
 S BAR("EDOS")=$$DATE^BARDUTL(2)
 I Y<0 S BAREFLG=1 Q
 S BAR("XEDOS")=$$MDT^BARDUTL(BAR("EDOS"))
 Q
 ; *********************************************************************
 ;
PRINT ;
 ; Print
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),U)
 S DIC="90050.03"
 S L=0
 S FR=BAR("BDOS")_",PAYMENT,"
 S TO=BAR("EDOS")_",PAYMENT,"
 D EN1^DIP
 ;
DSP ; EP for VALM
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
DIPVAR ;
 ; Set up DIP variables and Header routine
 Q:$D(BAREFLG)
 S BY="'@.01,@101,+4:108;S2;"" """
 D:BAR("RPTYPE")="D" DETAIL
 D:BAR("RPTYPE")="S" SUMMARY
 Q
 ; *********************************************************************
 ;
DETAIL ;
 S DHD="[BAR ADAL HDR]"
 S FLDS="NUMDATE4(#12),4;L20,6;L20,&3.5;R10;D2"  ;Y2000
 Q
 ;
SUMMARY ;
 S FLDS="&3.5;R10;D2;C56"
 S DHD="[BAR ADALS HDR]"
 Q
