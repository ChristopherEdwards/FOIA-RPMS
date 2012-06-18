DG53249P ;ALB/JAP - Patch 249 postinstall ; 1/11/00 12:56pm
 ;;5.3;Registration;**249**;Aug 13, 1993
 ;
EN ;entry point from install
 ;update identifier code in patient file
 S ^DD(2,0,"ID",.03)="D EN^DDIOL($TR($$DOB^DPTLK1(Y,1),""/"",""-""),,""?$X+2"")"
 S ^DD(2,0,"ID",.09)="D EN^DDIOL($$SSN^DPTLK1(Y),,""?$X+2"")"
 Q
