AVA200 ; IHS/OIT/FBD - ADD/ EDIT PERSONS TO VA(200 ;30-Sep-2010 17:29;fbd
 ;;93.2;VA SUPPORT FILES;**1,4,7,8,13,19,21**;SEP 30, 2010
 ;PATCH #8 -- Added Service/Section field to Add New Person-IHS/ADC/CRG
 ;PATCH #19 Added Trigger to fire Protocol to generate MFN-M02 Hl7 message IHS/OIT/FJE
 ;PATCH #21 Added Fax, Email Addr, DEA Exp date, SPI field edits to Add Provider - IHS/OIT/FBD
 ;
 Q
PERADD ;EP; ENTRY POINT to add or edit persons in ^va(200
 W @IOF,!!?22,"ADD/EDIT NEW PERSONS",!!
 W !!?10,"Use this option to enter names of employees, contractors, "
 W !?5,"and volunteers who will be referenced by other software.  If"
 W !?5,"the person is also a provider, you do NOT need to use this "
 W !?5,"option as the ADD/EDIT PROVIDERS option includes the data"
 W !?5,"fields asked for here.",!!
 ;
PER1 S AVAX=$$PERSON G PER1:AVAX>0
 K AVAX Q
 ;
 ;
PRVADD ;EP;ENTRY POINT to add or edit providers in ^va(200
 W @IOF,!!?22,"ADD/EDIT PROVIDERS",!!
 W !!?10,"Use this option to add new providers to your system OR to"
 W !?5,"edit those already in the system.  You do NOT need to enter the"
 W !?5,"provider as a person first.  Just use this option.",!
 ;
PRV1 S AVAX=$$PROVIDER G PRV1:AVAX>0
 K AVAX Q
 ;
 ;
INACTIVE ;PEP;ENTRY POINT to inactivate a person and/or provider
 W @IOF,!!?20,"INACTIVATE/REACTIVATE A PERSON/PROVIDER",!!
 W !!?10,"Use this option to enter an INACTIVE DATE for a Person" ;PATCH #7
 W !?5,"or Provider.  To deactivate a user, please use the option on"
 W !?5,"the USER EDIT menu.  To REACTIVATE a person or provider, enter"
 W !?5,"an ""@"" at the Inactive Date prompt.  Then proceed to the" ;PATCH #7
 W !?5,"ADD/EDIT PROVIDERS option to insure all the data is current."
 W !!
 ;
ASK W !! K DIC S DIC=200,DIC(0)="AEMZQ" D ^DIC G INEXIT:Y=-1
 W ! S DIE=200,(DA,AVADA)=+Y,DR="53.4" D ^DIE ;PATCH #7
 ;Added for support of Dental project  fje 8/5/08
 I +AVADA>0,$P($G(^VA(200,+AVADA,"PS")),U,5)>0 D
 . S X="AVA PROVIDER UPDATE MFN_M02",DIC=101,INDA=+AVADA
 . D EN^XQOR
 G ASK
 ;
INEXIT K DIC,DIE,DR,DA,X,Y Q
 ;
 ;
 ;
PERSON(AVADR,AVADR1) ;PEP;EXTR FUNC called to perform add or edit on one person
 ;AVADR can be set to fields to add as identifiers
 ;AVADR1 can be set to additional fields for DIE call
 ;to call, set variable to $$PERSON(with optional parameters)
 ;Identifiers already included:  by VA: Initials, SSN, Sex
 ;DR string below includes: VA Identifiers plus those you sent
 ;   Plus those stated below: DOB, Address fields, Phone, Office Phone
 ;
 N DIE,DA,DR,AVADA S AVADR=$G(AVADR)
 W ! S AVADA=$$ADD^XUSERNEW(AVADR) G EXIT1:AVADA'>0
 I $P(AVADA,U,3)=1 W !,"Identifiers Completed. Now for other data fields"
 I $P($G(^VA(200,+AVADA,"PS")),U,4)]"" W !!,$P(AVADA,U,2)," has been INACTIVATED.  Please use the INACTIVATE/REACTIVATE option.",!! G EXIT1 ;PATCH #7
 W ! S DIE=200,DA=+AVADA
 ;S DR=".01;1;4;5;8;9;.111:.116;.131;.132" S:$D(AVADR1) DR=DR_";"_AVADR1 ;PATCH #7
 S DR=".01;1;4;5;8;9;29;.111:.116;.131;.132" S:$D(AVADR1) DR=DR_";"_AVADR1 ;PATCH #7,8 ;IHS/ADC/CRG 12/4/96
 D ^DIE
EXIT1 Q AVADA
 ;
 ;
PROVIDER(AVADR,AVADR1) ;PEP;EXTR FUNC called to add or edit one provider
 ;AVADR can be set to fields to add as identifiers
 ;AVADR1 can be set to additional fields for DR for ^DIE call
 ;to call, set variable to $$PROVIDER(with optional parameters)
 ;Identifiers already included:  by VA: Initials, SSN, Sex
 ;  By variable X set below: Affiliation, Provider Class, Code
 ;DR string includes: VA Identifiers plus those you sent to $$PROVIDER
 ;   Plus identifiers stated below in X
 ;   Plus those stated in $$PERSON: DOB, Address, Phone #
 ;   Plus those set into Y below: IHS Local Code, Medicare & Medicaid #,
 ;         UPIN #, and all VA provider fields except VA #
 ;
 N Y,X
 S X="53.5R;9999999.01;9999999.02" S:$D(AVADR) X=X_";"_AVADR ;IHS/ORDC/LJF 12/3/93 PATCH #4
 ;S Y=X_";9999999.05:9999999.08;53.1;53.2;53.6:53.9" ;PATCH #7  ;IHS/OIT/FBD - 9/30/2010 - COMMENTED OUT - SUPERCEDED BY AVA*93.2*21
 S Y=".136;.151;"_X_";9999999.05:9999999.08;53.1;53.2;747.44;43.99;53.6:53.9" ;IHS/OIT/FBD - 9/30/2010 - AVA*93.2*21
 S:$D(AVADR1) Y=Y_";"_AVADR1
 S AVADA=$$PERSON(X,Y)
 I $P($G(^VA(200,+AVADA,"PS")),U,5)]"" D  ;IHS/ORDC/LJF 9/13/93 PATCH #1
 .S DA=$P(^DIC(3,+AVADA,0),U,16) ;IHS/ORDC/LJF 9/13/93 PATCH #1
 .I DA S DIE=6,DR="9999999.21" D ^DIE ;IHS/ORDC/LJF 9/13/93 PATCH #1
 I +AVADA>0,$P($G(^VA(200,+AVADA,"PS")),U,5)="" W !!,*7,"MUST HAVE PROVIDER CLASS TO BE DESIGNATED AS A PROVIDER!!",!
 ;Added for support of Dental project  fje 8/5/08
 I +AVADA>0,$P($G(^VA(200,+AVADA,"PS")),U,5)>0 D
 . S X="AVA PROVIDER UPDATE MFN_M02",DIC=101,INDA=+AVADA
 . D EN^XQOR
 Q AVADA
 ;Begin New Code;IHS/SET/GTH AVA*93.2*13 09/12/2002
CERTS ;EP - Edit CERTIFICATIONS.
 NEW DA,DIC,DIE,DR
 S DIC="^VA(200,",DIC(0)="AE"
 D ^DIC
 Q:+Y<1
 S DIC(0)="AEL",DA(1)=+Y,DIC=DIC_+Y_",90002,",DIC("W")="D CERTSID^AVA200(^(0))",DIC("P")=$P(^DD(200,90002,0),U,2)
 D ^DIC
 Q:+Y<1
 S DDSFILE=200,DDSFILE(1)=200.90002,DA=+Y,DR="[AVA CERTS]"
 D ^DDS
 S DIE="^VA(200,"_DA(1)_",90002,",DR=".05////"_DT_";.06////"_DUZ
 D ^DIE
 Q
 ;
CERTSID(AVA) ;EP - From DIC("W")
 W "  ",$S($P(AVA,U,2):$E($P(^AUTTACF($P(AVA,U,2),0),U),1,30),1:$J("",30)),"   ",$S($P(AVA,U,3):$E($P(^AUTTACE($P(AVA,U,3),0),U,1),1,30),1:$J("",30)),"   ",$S($P(AVA,U,4):$$CERTDT($P(AVA,U,4)),1:"")
 Q
 ;
CERTDT(X) ;
 Q $E(X,4,5)_"-"_$E(X,6,7)_"-"_($E(X,1,3)+1700)
 ;End New Code;IHS/SET/GTH AVA*93.2*13 09/12/2002
