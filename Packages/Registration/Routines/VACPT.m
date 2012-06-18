VACPT ;ALB/GRR - DISPLAY CPT COPYRIGHT INF ; 12 APR 1989@1400 [ 08/01/2001  2:50 PM ]
 ;;5.3;Registration;**123,124,138**;Aug 13, 1993
 ;IHS/ANMC/LJF  8/01/2001 prevent CPT message from displaying
 ;
 ;  This routine now calls the CPT api for displaying the
 ; CPT COPYRIGHT information
 ;
 Q  ;IHS/ANMC/LJF 8/1/2001
 D COPY^ICPTAPIU
 Q:$G(IOST)["P-"  ;if printer, quit
 ;
 N DIR,DIRUT,DIROUT,DTOUT,DUOUT,X,Y
 S DIR(0)="FAO",DIR("A")="Press any key to continue",DIR("?")=""
 D ^DIR
 Q
