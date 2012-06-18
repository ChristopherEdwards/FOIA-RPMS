AMEREDTD ; IHS/OIT/SCR - Sub-routine for ER VISIT edit of discharge data
 ;;3.0;ER VISIT SYSTEM;**2**;FEB 23, 2009
 ;
 ;DISCHARGE
 ;PROCEDURES
 ;EXIT ASSESSMENT
 ;FOLLOW UP INSTRUCTIONS 
 ;
 ; VARIABLES: The following variables are passed to multiple editing routines
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
EDDISCHG(AMERDA,AMERAIEN) ; EP from AMEREDIT for discharge information
 ;QD17 - DISCHARGE PHYSICIAN
 I '$D(^XUSEC("AMERZ9999",DUZ)) D EN^DDIOL("You are not authorized to use this option","","!!") Q 1  ;PROGRAMATICALLY LOCKING this option to holders of the coding key
 N AMERNO,Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,DIC,DIR
 N AMERDR ;IHS/OIT/SCR 08/28/09 patch 2
 S (AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,AMERDR)=""
 S DIC("A")="*(PRIMARY)Provider who signed PCC form: " K DIC("B"),DIC("S")
 S DIC("?")="Only active providers can be selected"
 I $P($G(^AMERVSIT(AMERDA,6)),U,4)'="" D
 .S (AMEROLD,AMERNO)=$P($G(^AMERVSIT(AMERDA,6)),U,3)
 .S DIC("B")=$P($G(^VA(200,AMERNO,0)),U)
 .Q
 S DIC="^VA(200,",DIC(0)="AEQ"
 ;screening so that only valid PRIMARY providers are sent to PCC for Visit Creation
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC
 K DIC
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 I Y>0 D
 .S AMERNEW=+Y
 .I AMERNEW'=AMEROLD D
 ..I AMERNEW="" S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.3////@"
 ..I AMERNEW>0 S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.3////"_AMERNEW
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("6.3",$$EDDISPL^AMEREDAU(AMEROLD,"N"),$$EDDISPL^AMEREDAU(AMERNEW,"N"),"DISCHARGE PROVIDER")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..Q
 .Q
 ;QD18 - DISCHARGE NURSE
 S DIC("A")="Discharge nurse: ",AMERNO=""
 K DIC("B")
 S DIC("?")="Only active providers can be selected"
 S (AMEROLD,AMERNO)=$P($G(^AMERVSIT(AMERDA,6)),U,4)
 I AMEROLD'="" S DIC("B")=$P(^VA(200,AMERNO,0),U)
 ;screening so that only valid PCC providers identified
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 S DIC="^VA(200,",DIC(0)="AEQM"
 D ^DIC K DIC
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 S AMERNEW=+Y
 I AMERNEW'=AMEROLD D
 .I AMERNEW>0 S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.4////"_AMERNEW
 .S AMERSTRG=$$EDAUDIT^AMEREDAU("6.4",$$EDDISPL^AMEREDAU(AMEROLD,"N"),$$EDDISPL^AMEREDAU(AMERNEW,"N"),"DISCHARGE NURSE")
 .I AMERSTRG="^" Q
 .S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .Q
 ;QD19 - TIME OF DEPARTURE
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,6)),U,2)
 I AMEROLD'="" S Y=$P($G(^AMERVSIT(AMERDA,6)),U,2) X ^DD("DD") S DIR("B")=Y
 S DIR(0)="DO^::ER",DIR("A")="*What time did the patient depart from the ER"
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. 1/3/90@1PM)"
 F  Q:Y="^"  D
 .D ^DIR
 .I $D(DUOUT)!$D(DTOUT) S Y="^" Q
 .S AMERNEW=Y
 .;TVAL returns 0 if user says "yes they are sure they want this time..."
 .I $$TVAL^AMER2A($P($G(^AMERVSIT(AMERDA,0)),U,1),AMERNEW,6) Q
 .I AMERNEW="" S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.2////@"
 .I $$TCK^AMER2A($P($G(^AMERVSIT(AMERDA,0)),U,1),AMERNEW,1,"admission")=0  D
 ..I AMERNEW=AMEROLD S Y="^" Q
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("6.2",$$EDDISPL^AMEREDAU(AMEROLD,"D"),$$EDDISPL^AMEREDAU(AMERNEW,"D"),"DEPARTURE TIME")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.2///"_AMERNEW
 ..S Y="^"
 ..Q
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 IF AMERDR'="" D
 .D DIE^AMEREDIT(AMERDA,AMERDR)
 .Q
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 K AMERNO,Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DIC,DIR,AMERDR
 Q 1
 ;
EDPROCS(AMERDA,AMEREDNO,AMERAIEN) ;  EP from AMEREDIT - ER PROCEDURES  
 N AMERNO,Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG
 S (AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,Y)=""
 S AMERNO=0
 K DIC("B"),DIC("S")
 I $P($G(^AMERVSIT(AMERDA,4,0)),U,3)="" D EN^DDIOL("No procedure(s) have been entered:","","!")
 E  D
 .D EN^DDIOL("The following procedure(s) have been entered: ","","!")
 .D EN^DDIOL("","","!")
 .S AMERNO=0
 .F  S AMERNO=$O(^AMERVSIT(AMERDA,4,AMERNO)) Q:AMERNO="B"  D
 ..S Y=$G(^AMERVSIT(AMERDA,4,AMERNO,0)),Y1=$G(^AMER(3,Y,0))
 ..D EN^DDIOL($P(Y1,U,1),"","!")
 ..Q
 .Q
 D EN^DDIOL("","","!")
 F  Q:Y="^"  D
 .S SKIP=0
 .S DIC="^AMER(3,",DIC(0)="AEQM",DIC("S")="I $P(^(0),U,2)=20",Y=""  ;only show type 20 -ER PROCEDURES
 .S DIC("A")="Enter "_$S($P($G(^AMERVSIT(AMERDA,4,0)),U,3)>0:"another ",1:"a ")_"procedure: "
 .D ^DIC
 .I $G(Y)<=0 S Y="^" Q
 .;First look to see if that procedure has already been entered
 .;if it has, we give the user a chance to delete it
 .S AMERNO=0
 .F  S AMERNO=$O(^AMERVSIT(AMERDA,4,AMERNO)) Q:'AMERNO  I ^AMERVSIT(AMERDA,4,AMERNO,0)=$P(Y,U,1) D
 ..S SKIP=1
 ..S AMEROLD=$G(^AMERVSIT(AMERDA,4,AMERNO,0))
 ..S DIR(0)="Y",DIR("A")="Delete this procedure? ",DIR("B")="NO"
 ..D ^DIR
 ..I Y=1  D
 ...S AMEREDNO=AMEREDNO+1
 ...S AMERNEW=""
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("4-01"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMEROLD,"R"),$$EDDISPL^AMEREDAU(AMERNEW,"R"),"PROCEDURE")
 ...I AMERSTRG="^" Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...S DA(1)=AMERDA,DA=AMERNO,DIK="^AMERVSIT(DA(1),4,"
 ...D ^DIK,EN^DIK K DIK  ;Kill the record and Re-index 
 ...Q
 ..S (AMERNO,Y)=""
 ..Q
 .I 'SKIP D
 ..S DA(1)=AMERDA,DIC="^AMERVSIT(DA(1),4,",DIC(0)="L",DIC("P")=$P(^DD(9009080,4,0),U,2) ; PROCEDURES
 ..S AMEROLD="",AMERNEW=+Y
 ..S X="`"_+Y
 ..D ^DIC K DIC  ;add a new entry
 ..S AMERNO=+Y,AMEREDNO=AMEREDNO+1
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("4-1"_"."_AMEREDNO,$$EDDISPL^AMEREDAU(AMEROLD,"R"),$$EDDISPL^AMEREDAU(AMERNEW,"R"),"PROCEDURE")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..Q
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT  Q 0
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 K AMERNO,Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG
 Q 1
 ;
EDEXTAS(AMERDA,AMERAIEN)   ;EP from AMEREDIT - ER EXIT ASSESSMENT 
 ;QD12 - FINAL TRIAGE CATEGORY
 N Y,AMEROLD,AMERNEW,AMEREDTS,AMERDR,AMERSTRG,AMEROPTN,AMERFAC,AMERM,DIR,DIC,AMEROPNO
 S (AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,AMERDR,Y)=""
 S AMEROLD=$P($G(^AMERVSIT(AMERDA,5.1)),U,4)
 I AMEROLD'="" S DIR("B")=AMEROLD
 S DIR(0)="NO^1:5:0",DIR("A")="Enter final acuity assessment from provider"
 S DIR("?")="Enter a number from 1 to 5 - This is a required field"
 F  Q:Y="^"  D
 .D ^DIR
 .I $D(DUOUT)!$D(DTOUT) S Y="^" Q
 .S AMERNEW=Y
 .I AMERNEW=AMEROLD S Y="^" Q
 .I AMERNEW>0 D
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("4.1",AMEROLD,AMERNEW,"FINAL ACUITY")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"5.4///"_Y
 ..S Y="^"
 ..Q
 .Q
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 I AMERDR'="" D
 .D DIE^AMEREDIT(AMERDA,AMERDR)
 .Q
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 S (DR,AMEREDTS)=""
 ;QD14 - DISPOSITION and transfer
 S AMEROPNO=""
 I $P($G(^AMERVSIT(AMERDA,6)),U,1)'="" S (AMEROLD,AMEROPNO)=$P($G(^AMERVSIT(AMERDA,6)),U,1)
 S DIC("A")="Disposition: " K DIC("B"),DIC("S")
 S DIC="^AMER(3,",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("DISPOSITION")
 I AMEROPNO'="" S DIC("B")=$P($G(^AMER(3,AMEROPNO,0)),U,1)
 D ^DIC K DIC
 I AMEROLD=$$OPT^AMER0("REGISTERED IN ERROR","DISPOSITION") D
 .D EN^DDIOL("This disposition can not be changed!!","","!")
 .S AMERNEW=AMEROLD
 E  S AMERNEW=+Y
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 ;IHS/OIT/SCR - 10/08/08 - START if the new value is Registered in error delete PCC VISIT
 I (AMERNEW>0) D
 .I AMERNEW=$$OPT^AMER0("REGISTERED IN ERROR","DISPOSITION") D
 ..D EN^DDIOL("This DISPOSITION will cause this entire VISIT to be deleted!!","","!")
 ..S DIR(0)="Y",DIR("A")="Do you still wish to keep this DISPOSITION"
 ..S DIR("B")="YES"
 ..D ^DIR
 ..I Y=0 S AMERNEW=AMEROLD
 ..I Y=1 D
 ...D DELETVST^AMERVSIT(AMERDA)
 ...S AMERDA=0
 ...Q
 ..Q  ;IHS/OIT/SCR - 10/08/08 - END if the new value is Registered in error delete PCC VISIT
 .S AMEROPTN=$$OPT^AMER0("TRANSFER","DISPOSITION")
 .I (AMERNEW'=AMEROLD) D
 ..S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.1///"_AMERNEW
 ..S AMERSTRG=$$EDAUDIT^AMEREDAU("6.1",$$EDDISPL^AMEREDAU(AMEROLD,"I"),$$EDDISPL^AMEREDAU(AMERNEW,"I"),"DISPOSITION")
 ..I AMERSTRG="^" Q
 ..S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ..;If the old value was "transfer to another facility, delete facility associated
 ..I AMEROLD=AMEROPTN D  S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.6////@"
 ..Q
 .I AMERNEW=AMEROPTN D
 ..;IF the new value is "transfer to another facility", collect facility information
 ..D EN^DDIOL("","","!")
 ..S AMEROLD=""
 ..I $P($G(^AMER(2.1,0)),U,3)="" D EN^DDIOL("No local ER Facilities found","","!") Q
 ..S DIC="^AMER(2.1,",DIC(0)="AEQM"
 ..S DIC("A")="Where is patient being transferred? "
 ..S AMERFAC=$P($G(^AMERVSIT(AMERDA,6)),U,6)
 ..I AMERFAC'="" S (DIC("B"),AMEROLD)=$P($G(^AMER(2.1,AMERFAC,0)),U,1)
 ..E  S AMERM=$O(^AMER(2.1,0))
 ..D ^DIC K DIC
 ..I +Y>0 S AMERNEW=$P($G(^AMER(2.1,+Y,0)),U,1)
 ..E  S AMERNEW=""
 ..I +Y>0&(AMERNEW'=AMEROLD) D
 ...S AMERDR=$S(AMERDR'="":AMERDR_";",1:""),AMERDR=AMERDR_"6.6////"_+Y
 ...S AMERSTRG=$$EDAUDIT^AMEREDAU("6.6",AMEROLD,AMERNEW,"TRANSFER TO")
 ...I AMERSTRG="^" Q
 ...S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 ...Q
 ..Q
 ..E  I AMEROPTN<0 D
 ...D EN^DDIOL("Option 'TRANSFER TO ANOTHER FACILITY' is missing ","","!")
 ...D EN^DDIOL("This DISPOSITION type is required for collection of transfer location ","","!")
 ...Q
 ..Q
 .I AMEROLD=AMEROPTN
 .Q  ;IF NEW>0
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 IF AMERDR'="" D
 .D DIE^AMEREDIT(AMERDA,AMERDR)
 .Q
 D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 K Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,AMERDR,AMEROPTN,AMERFAC,AMERM,DIR,DIC
 Q 1
 ;
EDFUINST(AMERDA,AMERAIEN) ;EP - From AMEREDIT
 ;QD16 - DISCHARGE INSTRUCTIONS
 N Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,DIE
 S (AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,Y)=""
 S DIC("A")="*Follow up instructions: " K DIC("B"),DIC("S")
 S AMEROLD=$G(^AMERVSIT(AMERDA,7))
 I AMEROLD'="" S DIC("B")=$P($G(^AMER(3,AMEROLD,0)),U)
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("FOLLOW UP INSTRUCTIONS"),DIC(0)="AEQ"
 D ^DIC K DIC
 I $D(DUOUT)!$D(DTOUT) K DUOUT,DTOUT Q 0
 S AMERNEW=+Y
 I AMERNEW>0&(AMERNEW'=AMEROLD) D
 .S DR="7///"_AMERNEW
 .S AMERSTRG=$$EDAUDIT^AMEREDAU("7",$$EDDISPL^AMEREDAU(AMEROLD,"F"),$$EDDISPL^AMEREDAU(AMERNEW,"F"),"DISCHARGE INSTRUCTIONS")
 .I AMERSTRG="^" Q
 .S AMEREDTS=$S(AMEREDTS="":AMERSTRG,1:AMEREDTS_"^"_AMERSTRG)
 .D:AMEREDTS'="" MULTAUDT^AMEREDAU(AMEREDTS,AMERAIEN)
 .D DIE^AMEREDIT(AMERDA,DR)
 .Q
 K Y,AMEROLD,AMERNEW,AMEREDTS,AMERSTRG,DR,DIE
 Q 1
