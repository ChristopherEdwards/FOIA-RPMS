APSPCO1 ; IHS/MSC/PLS - List Manager Complete Orders, CON'T ;07-Nov-2011 16:20;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1013**;Sep 23, 2004;Build 33
 ;=================================================================
 Q
 ; Input: EFLG - Edit flag
PMTLLST(EFLG) ;EP- Prompt user for location restriction list
 N DIC,Y
 S DIC=9009033.6,DIC(0)="AEMQZ"_$S($G(EFLG):"L",1:"")
 I $G(EFLG) D
 .S DIC("A")="Select/Create location restriction list: "
 E  S DIC("A")="Select location restriction list('^' to ignore): "
 D ^DIC
 Q $S(Y>0:+Y,1:0)
 ;
EDTLLST ;EP- Create/Edit a location restriction list
 N DA,DIE,DR,DIDEL,DUOUT,DLAYGO
 S DLAYGO=9009033.6
 S DA=$$PMTLLST(1)
 Q:DA<1
 S DR=".01;1",DIE=9009033.6 D ^DIE
 Q
