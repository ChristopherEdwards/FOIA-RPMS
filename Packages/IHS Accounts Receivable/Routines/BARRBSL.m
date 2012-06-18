BARRBSL ; IHS/SD/LSL - BATCH STATISTICAL LISTING RPT JAN 16,1997 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
START ; EP
 ; Collections report using FM print
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
DATE ;
 ; Select Date Range
 D DATE^BARRADAL
 Q
 ; *********************************************************************
 ;
PRINT ;**Print
 ;
 S BAR("SITE")=$P(^DIC(4,DUZ(2),0),U)
 S DIC="90051.01"
 S L=0
 S FR=BAR("BDOS")_","
 S TO=BAR("EDOS")_","
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
 S BY="'4,+2;S2;L16"
 ; Changes required by new Collection Batch DD (Triggers)
 S FLDS="[BAR BSL DET]"
 S DHD="[BAR BSL HDR]"
 Q
