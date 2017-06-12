BEXSITE ;IHS/CMI/DAY - BEX - Division and Site Selection ; 05 Oct 2015  11:42 AM
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;*6*;APR 20, 2015;Build 7
 ;
 Q
 ;
 ;Site Notes
 ;
 ;PSOSITE is set to the IEN in the OUTPATIENT SITE file
 ;
 ;PSOPINST is set to the Related Institution in the
 ;OUTPATIENT SITE file
 ;
 ;PSOINST is needed for BEXRX7 and is set in ^PSOLSET however, the
 ;value is set to the Station Number, which is set by users or by
 ;assigned Station Numbers in the 8000 range.  Therefore, we must set
 ;PSOINST ourselves.
 ;
 ;
CHANGE ;EP - Display current site and ask user if they want to change
 ;
 ;Do not ask if only one Outpatient Site
 I $P($G(^PS(59,0)),U,3)=1 Q
 ;
 ;If we do not have these variables, we have to ask them first
 I '$D(PSOSITE) K PSOPAR
 I '$D(PSOPAR) D ^PSOLSET
 I '$D(PSOPAR) G CHANGE
 ;
 ;We assume from here that we have multiple Outpatient Site entries
 ;
 W !!
 F I=1:1:70 W "*"
 W !
 W "***  O/P Site (Division) is: "
 W ?30,$$GET1^DIQ(59,PSOSITE,.01),?67,"***",!
 W "***  Related Institution is: "
 W ?30,$$GET1^DIQ(4,PSOPINST,.01),?67,"***",!
 F I=1:1:70 W "*"
 W !
 ;
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Do you want to change these"
 S DIR("B")="N"
 D ^DIR
 I Y'=1 Q
 ;
 K PSOSITE,PSOPAR,PSOPINST
 D ^PSOLSET
 I '$D(PSOPAR) G CHANGE
 ;
 W !!
 W "The RELATED INSTITUTION is ",$$GET1^DIQ(4,PSOPINST,.01),!
 W "and will be used to lookup and display health record numbers.",!
 ;
 ;This is borrowed from ASKSITE^XUS1
 K DIC
 S DIC(0)="AEQM"
 S DIC="^VA(200,DUZ,2,"
 S DIC("P")="200.02P"
 S DIC("A")="Select RELATED INSTITUTION: "
 S DIC("B")=PSOPINST
 D ^DIC
 K DIC
 I Y>0 S PSOPINST=+Y,DUZ(2)=+Y
 W !!
 ;
 Q
 ;
 ;
HOLD ;EP - Store original settings when a user enters BEX processing
 ;
 ;We store PSOSITE (the Outpatient Site)
 ;and PSOPINST (the related institution)
 ;and DUZ(2)
 ;
 S BEXHOLD("PSOSITE")=$G(PSOSITE)
 S BEXHOLD("PSOPINST")=$G(PSOPINST)
 S BEXHOLD("DUZ(2)")=$G(DUZ(2))
 ;
 Q
 ;
 ;
CHECK() ;EP - Check if user changed their site settings
 ;
 ;This is called from the END section of BEXRX7 and
 ;from the EOJ section of BEXRQUE to see if the user changed
 ;their Outpatient Site settings
 ;
 ;Quit if not a multi-division site
 I $P($G(^PS(59,0)),U,3)=1 Q 0
 ;
 I $G(PSOSITE)="" Q 0
 I $G(PSOPINST)="" Q 0
 I $G(DUZ(2))="" Q 0
 ;
 I $G(PSOSITE)'=$G(BEXHOLD("PSOSITE")) Q 1
 I $G(PSOPINST)'=$G(BEXHOLD("PSOPINST")) Q 1
 I $G(DUZ(2))'=$G(BEXHOLD("DUZ(2)")) Q 1
 ;
 Q 0
 ;
 ;
