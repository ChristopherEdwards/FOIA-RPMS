BAR50LM1 ; IHS/SD/LSL - Main program to call ListMan AR File output ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**21**;OCT 26, 2005
 ;
 ;
 Q
 ; *********************************************************************
 ;
EN ; Entry point
 ;
 W #
 S Y=$$SELTRAN^BAR50I01
 Q:Y'>0
 S DLFL=Y
 D EN^BAREDLA1(DLFL)
 Q
