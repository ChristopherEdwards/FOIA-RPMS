AMEREDTT ; IHS/OIT/SCR - SUB-ROUTINE FOR ER VISIT EDIT of Triage Information
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ; 
 ;VARIABLES: The following variables are passed to multiple editing routines
 ;  AMERDA  : the IEN of the ER VISIT that is selected for editing
 ;  AMERAIEN: The IEN of the ER AUDIT that is created when user begins editing a record
 ;  AMEREDNO: An integer representing the number of multiple fields that have been edited
 ;            for uniqueness in multiple field number in audit file
 ;            
 ; Edit Auditing VARIABLES newed and used throughout edit routines:
 ;      AMEROLD : original value of edited field
 ;      AMERNEW : new value of edited field
 ;      AMERSTRG : A ";" deliminated string of edit information for a field   
 ;       
ADMTRIAG(AMERDA,AMERAIEN)  ; EP from AMEREDIT
 N AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,DIR,DIC,AMERSKIP
 S (AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR)=""
 Q:'$D(^XUSEC("AMERZ9999",DUZ)) $$ERSEDTT(AMERDA,AMERAIEN)  ; PROGRAMATICALLY locking fields that pass to PCC
 S AMERSKIP=0
 ; ADMITTING PROVIDER
 N DIC,DIR
 S DIC("A")="*Admitting provider: "
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,0)),U,6)
 ;screening so that only valid PCC providers identified
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 I AMEROLD'="" S DIC("B")=$P(^VA(200,AMEROLD,0),U)
 S DIC="^VA(200,",DIC(0)="AEQ"   ;
 D ^DIC
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 I Y>0 S AMERNEW=+Y
 E  S AMERNEW=""
 I AMEROLD=AMERNEW D
 .I AMERNEW="" S AMERSKIP=1 Q
 .; If discharge provider is same as admitting provider, don't let 'em delete it
 .I AMERNEW=$P($G(^AMERVSIT(AMERDA,6)),U,3) D  Q
 ..D EN^DDIOL("ADMITTING provider is same as DISCHARGE provider","","!!")
 ..D EN^DDIOL("cannot remove ADMITTING provider until DISCHARGE provider is updated","","!")
 ..D EN^DDIOL("","","!!")
 .S DIR("A")="Do you want to REMOVE this provider from the ER VISIT"
 .S DIR(0)="Y",DIR("B")="NO"
 .D ^DIR
 .I Y=1 D
 ..S DR=$S(DR'="":DR_";",1:""),DR=DR_".06////@;12.1////@"  ;delete any time as well
 ..S AMERNEW="",AMERSKIP=1
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU(".06",AMEROLD,AMERNEW,"ADMITTING PROVIDER")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .Q
 I AMEROLD'=AMERNEW D
 .S DR=$S(DR'="":DR_";",1:""),DR=DR_".06////"_AMERNEW
 .S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"N") ;translates from new person ien to name
 .S AMERNEW=$$EDDISPL^AMEREDAU(AMERNEW,"N")
 .S AMERSTRG=$$EDAUDIT^AMEREDAU(".06",AMEROLD,AMERNEW,"ADMITTING PROVIDER")
 .I AMERSTRG="^" S AMERQUIT=1,DR="" Q
 .S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .Q
 K DIC,DIR
 ; DOC TIME
 N DIR
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,12)),U,1)
 I AMEROLD'="" S Y=AMEROLD  X ^DD("DD") S DIR("B")=Y
 S DIR(0)="DO^::ER",DIR("A")="*What time did the patient see the admitting provider"
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)"
 F  Q:Y="^"!(Y="")  D
 .D ^DIR
 .I $D(DUOUT)!$D(DTOUT) Q
 .S AMERNEW=Y
 .I AMERNEW,$$TVAL^AMER2A($P($G(^AMERVSIT(AMERDA,0)),U,1),AMERNEW,6) Q
 .I AMERNEW="" D
 ..I AMEROLD=AMERNEW  S Y="^" Q
 ..S DR=$S(DR'="":DR_";",1:""),DR=DR_"12.1////@"
 ..S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"D")  ;tranforms fileman date into user friendly date
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("12.1",AMEROLD,AMERNEW,"ADMITTING PROVIDER TIME")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..S Y="^"
 ..Q
 .Q:AMERNEW=""
 .D:'$$TCK^AMER2A($P($G(^AMERVSIT(AMERDA,0)),U,1),AMERNEW,1,"admission")
 ..I AMEROLD=AMERNEW  S Y="^" Q
 ..I AMEROLD'=AMERNEW D
 ...S DR=$S(DR'="":DR_";",1:""),DR=DR_"12.1////"_AMERNEW
 ...S AMERNEW=$$EDDISPL^AMEREDAU(AMERNEW,"D")  ;tranforms fileman date into user friendly date
 ...S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"D")
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("12.1",AMEROLD,AMERNEW,"ADMITTING PROVIDER TIME")
 ...I AMERSTRG="^" Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S Y="^"
 ...Q
 ..Q
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT  Q 0
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 I DR'="" D DIE^AMEREDIT(AMERDA,DR)
 S (DR,AMEREDTS)=""
 K DIR
 ; TRIAGE NURSE
 N DIC,DIR
 S DR="",AMERSKIP=0
 S DIC("A")="*Triage nurse: " K DIC("B")
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,0)),U,7)
 I AMEROLD'="" S DIC("B")=$P($G(^VA(200,AMEROLD,0)),U)
 S DIC="^VA(200,",DIC(0)="AEQM"
 ;screening so that only valid PCC providers identified
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC K DIC
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN) Q 0
 I Y>0 S AMERNEW=+Y
 E  S AMERNEW=""
 I AMEROLD=AMERNEW D
 .I AMERNEW="" S AMERSKIP=1 Q
 .; If discharge nurse is same as admitting nurse, don't let 'em delete it
 .I AMERNEW=$P($G(^AMERVSIT(AMERDA,6)),U,4) D  Q
 ..D EN^DDIOL("TRIAGE nurse is same as DISCHARGE nurse","","!!")
 ..D EN^DDIOL("cannot remove TRIAGE nurse until DISCHARGE nurse is updated","","!")
 ..D EN^DDIOL("","","!!")
 ..Q
 .S DIR("A")="Do you want to REMOVE this Triage nurse from this visit"
 .S DIR(0)="Y",DIR("B")="NO"
 .D ^DIR K DIR
 .I Y=1 D
 ..S AMERNEW="",AMERSKIP=1
 ..S DR=$S(DR'="":DR_";",1:""),DR=DR_".07////@;12.2////@"
 ..S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"N") ;translates from new person ien to name
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU(".07",AMEROLD,AMERNEW,"TRIAGE NURSE")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .Q
 I AMEROLD'=AMERNEW D
 .S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"N") ;translates from new person ien to name
 .S AMERNEW=$$EDDISPL^AMEREDAU(AMERNEW,"N")
 .S AMERSTRG=$$EDAUDIT^AMEREDAU(".07",AMEROLD,AMERNEW,"TRIAGE NURSE")
 .I AMERSTRG="^" Q
 .S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .S DR=$S(DR'="":DR_";",1:""),DR=DR_".07////"_+Y
 .Q
 K DIR,DIC
 ; TRIAGE TIME
 N DIR
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,12)),U,2)
 I AMEROLD'="" S Y=AMEROLD X ^DD("DD") S DIR("B")=Y
 S DIR(0)="D^::ER",DIR("A")="*What time did the patient see the triage nurse"
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)"
 F  Q:Y="^"!(Y="")  D
 .D ^DIR K DIR
 .I $D(DUOUT)!$D(DTOUT) Q
 .S AMERNEW=Y
 .I AMERNEW,$$TVAL^AMER2A($P($G(^AMERVSIT(AMERDA,0)),U,1),AMERNEW,6) Q
 .I AMERNEW="" D
 ..I AMEROLD=AMERNEW  S Y="^" Q
 ..S DR=$S(DR'="":DR_";",1:""),DR=DR_"12.2////@"
 ..S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"D") ;tranforms fileman date into user friendly date
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("12.2",AMEROLD,AMERNEW)
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..S Y="^"
 ..Q
 .Q:AMERNEW=""
 .D:'$$TCK^AMER2A($P($G(^AMERVSIT(AMERDA,0)),U,1),Y,1,"admission")
 ..I AMEROLD=AMERNEW  S Y="^" Q
 ..I AMEROLD'=AMERNEW D
 ...S DR=$S(DR'="":DR_";",1:""),DR=DR_"12.2////"_AMERNEW
 ...S AMERNEW=$$EDDISPL^AMEREDAU(AMERNEW,"D")  ;tranforms fileman date into user friendly date
 ...S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"D")
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("12.2",AMEROLD,AMERNEW,"TRIAGE TIME")
 ...I AMERSTRG="^" Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S Y="^"
 ...Q
 ..Q
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT  Q 0
 I DR'="" D DIE^AMEREDIT(AMERDA,DR)
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 S (DR,AMEREDTS)=""
 K DIR
 K AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,DIR,AMERSKIP
 D EN^DDIOL("ERS PCC Data Entry is complete for this option","","!!")
 S DIR("A")="Edit more TRIAGE data"
 S DIR(0)="Y",DIR("B")="NO"
 D ^DIR K DIR
 I Y=1 Q $$ERSEDTT(AMERDA,AMERAIEN)
 Q 1
ERSEDTT(AMERDA,AMERAIEN)  ;SUBROUTINE FOR EDIT OF ERS FIELDS THAT DO NOT PASS TO PCC
 S (AMERDR,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,AMERQUIT)=""
 ; INITIAL TRIAGE
 N DIR
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,0)),U,24)
 I AMEROLD'="" S DIR("B")=AMEROLD
 S DIR(0)="N^1:5:0",DIR("A")="Enter initial triage assessment from RN"
 S DIR("?")="Enter a number from 1 to 5"
 S DIR("?",1)="This is a site-specified value that indicates severity of visit"
 D ^DIR K DIR
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN) Q 0
 S AMERNEW=+Y
 I (AMERNEW'=AMEROLD) D
 .S DR=".24////"_AMERNEW
 .S AMERSTRG=$$EDAUDIT^AMEREDAU(".24",AMEROLD,AMERNEW,"INITIAL ACUITY")
 .I AMERSTRG="^" Q
 .D DIE^AMEREDIT(AMERDA,DR)
 .D DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 .Q
 ;Work related
 N DIR
 S AMEROLD=$G(^AMERVSIT(AMERDA,2.1))
 S DIR("B")=$S(AMEROLD=0:"NO",AMEROLD=1:"YES",1:"NO")
 I DIR("B")="NO" S AMEROLD=0  ;NULL VALUE WILL BE UPDATED WITH 0
 S DIR(0)="YO",DIR("A")="Was this ER visit WORK-RELATED"
 D ^DIR
 I $D(DUOUT)!$D(DTOUT)!(Y<0) K DUOUT,DTOUT,Y Q 0
 S AMERNEW=Y
 Q:Y<0
 I AMEROLD'=AMERNEW D
 .S DR="2.1///"_Y
 .S AMERNEW=$$EDDISPL^AMEREDAU(AMERNEW,"B") ;TRANSLATE FROM 0 TO "NO"
 .S AMEROLD=$$EDDISPL^AMEREDAU(AMEROLD,"B")
 .S AMERSTRG=$$EDAUDIT^AMEREDAU("2.1",AMEROLD,AMERNEW,"WORK RELATED")
 .D DIE^AMEREDIT(AMERDA,DR)
 .S DR=""
 .D:AMERSTRG'="" DIEREC^AMEREDAU(AMERAIEN,AMERSTRG)
 .S AMERSTRG=""
 .Q
 K DIR
 Q 1
