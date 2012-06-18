BARRFCR ; IHS/SD/LSL - REPORT--FAC COLLECTIONS REGISTER JAN 16,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
START ; EP
 ; Collections report using FM print
 ;
 D DIPVAR
 G:$D(BAREFLG) END
 D PRINT
 D EOP^BARUTL(1)
 ;
END ;
 Q
 ; *********************************************************************
 ;
LOOKUP ;
 ; Collection Register name lookup--Batch Name
 K DUOUT,DTOUT,BAREFLG
 S DIC="90051.01"
 S DIC(0)="AEMQZ"
 D ^DIC
 K DIC
 S:Y<0 BAREFLG=1
 S:$D(DUOUT) BAREFLG=1
 S:$D(DTOUT) BAREFLG=1
 I $D(BAREFLG) Q
 I Y>0 S BARBATCH=+Y,BARBEX=$P(Y(0),U)
 Q
 ; *********************************************************************
 ;
PRINT ;
 ; Print
 S DIC="90051.01"
 S L=0
 I $D(BARBEX) S FR=BARBEX,TO=BARBEX
 D EN1^DIP
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
DIPVAR ;
 ; Set up Print Variables
 D LOOKUP
 Q:$D(BAREFLG)
 S DHD="[BAR CRH FAC]"
 S BY="[BAR CRS DET]"
 S FLDS="[BAR CR DET]"
 Q
