BSDROUTQ ; IHS/ANMC/LJF - IHS ROUTING SLIP QUESTIONS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
APPT(DFN,SDT,SDCL,SDDA) ;EP;  called by SDAMWI1 to ask during walk-in
 Q:$$GET1^DIQ(9009020.2,+$$DIVC^BSDU(SDCL),.02)="NO"   ;don't ask
 NEW DIR
 S DIR(0)="Y",DIR("A")="Want to print Appointment Slip now"
 S DIR("B")="YES" D ^DIR Q:$D(DIRUT)  Q:Y'=1
 ;set up rs code
 Q
