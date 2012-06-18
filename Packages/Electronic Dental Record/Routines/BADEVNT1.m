BADEVNT1 ;IHS/MSC/MGH - Dentrix HL7 interface (cont) ;08-Jul-2009 16:38;PLS
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified - IHS/MSC/AMF - 11/23/10 - Updated Out of Order, alerts, removed H 2
 Q
TPROV ;EP Taskman call to start provider load
 N STOP,ZTDTH,ZTIO,ZTDESC,ZTRTN,ZTSAVE,ZTPRI,ZTSK
 ;Make sure its not already running
 S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE PROV UPLOAD",1,"E")
 ;Its already running and shouldn't be restarted
 I STOP="NO" D  H 3 Q
 .W !,"Process is already running",!
 I $$GET^XPAR("ALL","BADE LAST NEW PERSON") D  H 3 Q
 .W !,"Upload process has already begun. Please use Restart option.",!
 S ZTIO=""
 S ZTDESC="Load Provider Data to EDR"
 S ZTRTN="LOADPRV^BADEVNT1"
 S ZTPRI=1
 S ZTSAVE("DUZ")=""
 D ^%ZTLOAD
 I $G(ZTSK) D
 .D EN^XPAR("SYS","BADE EDR PRV TSK",1,ZTSK)
 .W !,"Task number "_ZTSK H 2
 Q
LOADPRV ;EP Load the dental providers
 N IEN,CNT,DATA,TOTAL,STOP,MFNTYP
 ;Set the stop parameter to NO
 D EN^XPAR("SYS","BADE EDR PAUSE PROV UPLOAD",1,"NO")
 ;Make sure the last used IEN is set to null
 S IEN=$$GET^XPAR("ALL","BADE EDR LAST NEW PERSON")
 ;Loop through providers
 S IEN=$S(IEN>0:IEN,1:0),CNT=0,STOP="NO",TOTAL=0
 S MFNTYP="MAD"
 F  S IEN=$O(^VA(200,IEN)) Q:+IEN'>0!(STOP="YES")  D
 .Q:$$INACTPRV(IEN)  ; Do not send Inactive/Terminated providers
 .D MFN^BADEVNT1(IEN)
 .;Set the IEN into the PROVIDER parameter
 .D EN^XPAR("SYS","BADE EDR LAST NEW PERSON",1,"`"_IEN)
 .;Set the total count
 .S TOTAL=TOTAL+1
 .D EN^XPAR("SYS","BADE EDR TOTAL PROVIDERS",1,TOTAL)
 .;Check to see if we should stop
 .S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE PROV UPLOAD",1,"E")
 .Q:STOP="YES"
 ;Finish up by resetting the provider parameter and the stop parameter to YES
 I STOP="NO" D
 .D EN^XPAR("SYS","BADE EDR PAUSE PROV UPLOAD",1,"YES")
 .D EN^XPAR("SYS","BADE EDR PRV TSK",1,"Upload Complete")
 .N DA,DIE,DR
 .D COMPLETE
 Q
TRELPRV ;EP Taskman call to restart provider load
 N STOP,ZTDTH,ZTIO,ZTPRI,ZTDESC,ZTRTN,ZTSAVE,ZTSK
 ;First, check to see if its already running
 S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE PATIENT LOAD",1,"E")
 ;Its already running and shouldn't be restarted
 I STOP="NO" W !,"Process is already running",!!! H 3 Q
 ;S ZTDTH=$H
 S ZTIO=""
 S ZTPRI=1
 S ZTDESC="Load Provider Data to EDR"
 S ZTRTN="RESTPRV^BADEVNT1"
 S ZTSAVE("DUZ")=""
 D ^%ZTLOAD
 I $G(ZTSK) D
 .D EN^XPAR("SYS","BADE EDR PRV TSK",,ZTSK)
 .W !,"Task number "_ZTSK H 2
 Q
RESTPRV ;EP Restart the provider load
 N IEN,TOTAL,DATA,STOP,MFNTYP
 ;Get the last used IEN from the parameter
 S IEN=$$GET^XPAR("ALL","BADE LAST NEW PERSON")
 ;Get the total count
 S TOTAL=$$GET^XPAR("ALL","BADE EDR TOTAL PROVIDERS")
 ;Set the stop parameter to NO
 ;S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE PROV UPLOAD",1,"E")
 ;Q:STOP="NO"
 D EN^XPAR("SYS","BADE EDR PAUSE PROV UPLOAD",1,"NO")
 ;Loop through providers
 S STOP="NO"
 S IEN=$S(IEN>0:IEN,1:0)
 F  S IEN=$O(^VA(200,IEN)) Q:+IEN'>0!(STOP="YES")  D
 .Q:$$INACTPRV(IEN)  ; Do not send Inactive/Terminated providers
 .S MFNTYP="MAD"
 .D MFN^BADEVNT1(IEN)
 .;Set the IEN into the PROVIDER parameter
 .D EN^XPAR("SYS","BADE EDR LAST NEW PERSON",1,"`"_IEN)
 .;Add to the total count
 .S TOTAL=TOTAL+1
 .D EN^XPAR("SYS","BADE EDR TOTAL PROVIDERS",1,TOTAL)
 .;Check to see if we should stop
 .S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE PROV UPLOAD",1,"E")
 .Q:STOP="YES"
 .;Finish up by resetting the provider parameter and the stop parameter to YES
 I STOP="NO" D
 .D EN^XPAR("SYS","BADE EDR PAUSE PROV UPLOAD",1,"YES")
 .D EN^XPAR("SYS","BADE EDR PRV TSK",1,"")
 .D COMPLETE
 Q
 ; ----- IHS/MSC/AMF 10/9/10 modified to mark all provider upload options complete
COMPLETE ;Mark options out of order
 N MSG,MENU,I
 S MENU(1)="BADE EDR UPLOAD ALL PROVIDERS"
 S MENU(2)="BADE EDR RESTART PROV UPLOAD"
 S MENU(3)="BADE EDR PAUSE PROV UPLOAD"
 F I=1:1:3 D
 .N DA,DIE,DR
 .S MSG="Upload completed"
 .S DA=$O(^DIC(19,"B",MENU(I),""))
 .I DA'=""  D
 ..S DIE="^DIC(19,",DR="2///^S X=MSG"
 ..D ^DIE
 ; ----- end IHS/MSC/AMF 10/9/10 
 ; Enable event protocol
 D EDPROT^BADEUTIL("BADE PROVIDER UPDATE MFN-M02")
 Q
STATUS ;EP Display the status
 N THROTTLE,CNT,DATA,TOTAL,TASK,PDATA,PTOTAL,PSTOP,PTASK,DFN,USR
 ;Get the patient processed and total number processed
 S DFN=$$GET^XPAR("ALL","BADE EDR LAST DFN")
 S DATA=$$GET1^DIQ(2,DFN,.01)_$S(DFN>0:"  ("_DFN_")",1:"")
 S TOTAL=$$GET^XPAR("ALL","BADE EDR TOTAL PROCESSED")
 ;Display throttle and processing status
 S THROTTLE=$$GET^XPAR("ALL","BADE EDR PT THROTTLE")
 S CNT=$$GET^XPAR("ALL","BADE EDR THROTTLE CT")
 S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE PATIENT LOAD",1,"E")
 S TASK=$$GET^XPAR("ALL","BADE EDR LOAD TSK")
 ;Get the providers processed and total number processed
 S USR=$$GET^XPAR("ALL","BADE EDR LAST NEW PERSON")
 S PDATA=$$GET1^DIQ(200,USR,.01)_$S(USR>0:"  ("_USR_")",1:"")
 S PTOTAL=$$GET^XPAR("ALL","BADE EDR TOTAL PROVIDERS")
 ;Display the processing status
 S PSTOP=$$GET^XPAR("ALL","BADE EDR PAUSE PROV UPLOAD",1,"E")
 S PTASK=$$GET^XPAR("ALL","BADE EDR PRV TSK")
 ; ----- IHS/SAIC/FJE 3/9/11 added to complete display for merge
 ;Get MERGED PATIENTS processed and total number processed
 S MRGDFN=$$GET^XPAR("ALL","BADE EDR MRG DFN")
 S MRGDATA=$$GET1^DIQ(2,MRGDFN,.01)_$S(MRGDFN>0:"  ("_MRGDFN_")",1:"")
 S MRGTOTAL=$$GET^XPAR("ALL","BADE EDR MRG TOTAL")
 ;Display the processing status
 S MRGSTOP=$$GET^XPAR("ALL","BADE EDR PAUSE MRG LOAD",1,"E")
 S MRGTASK=$$GET^XPAR("ALL","BADE EDR MRG LOAD TSK")
 ; ----- end IHS/SAIC/FJE 3/9/11
 ; Display statistics
 Q:$E($G(IOST),1,2)'="C-"
 N X,%ZIS,IORVON,IORVOFF,MNU
 S VER="Version "_$G(VER,1.0),PKG=$G(PKG,"RPMS-Dentrix Upload")
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF
 W !!!!,"Patient Upload Data"
 W !,?5,"Last Patient Processed: "_DATA
 W !,?5,"Total Pts processed: "_TOTAL
 W !,?5,"Throttle seconds: "_THROTTLE,?40,"Throttle Pt. Ct.: "_CNT
 W !,?5,"Currently stopped: "_STOP,?40,"Task: "_TASK
 W !,"Provider Upload Data"
 W !,?5,"Last Provider Processed: "_PDATA
 W !,?5,"Total Prov processed: "_PTOTAL
 W !,?5,"Currently stopped: "_PSTOP,?40,"Task: "_PTASK
 W !,"Merge Upload Data"
 W !,?5,"Last Merged Patient Processed: "_MRGDATA
 W !,?5,"Total Merged Patients processed: "_MRGTOTAL
 W !,?5,"Currently stopped: "_MRGSTOP,?40,"Task: "_MRGTASK
 W !!
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
SENDMFN ;Send one MFN message
 N ERR,INDA,DIC,D,MFNTYP
 S DIC=200,DIC(0)="AEQ",DIC("A")="Select DENTIST: "
 S D="AK.PROVIDER",DIC("S")="I $$ISDENTST^BADEVNT1(+Y)"
 D IX^DIC I +Y>0 D
 .S INDA=+Y
 .I $$NPI^XUSNPI("Individual_ID",INDA)<0 D  Q
 ..W !,"Selected provider lacks NPI number"
 .D MFN^BADEVNT1(INDA)
 .W !,$S($D(ERR):"Unable to send HL7 message...",$G(MSG):MSG,1:"Message was sent...")
 ; IHS/MSC/AMF 10/9/10 modified - removed H, replaced with Enter to continue.
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
MFN(INDA) ;EP Create and send one MFN message
 ;Make sure its a dentist
 N PC,DENT
 Q:'$D(^VA(200,INDA,0))
 Q:$P($G(^VA(200,INDA,0)),U,1)=""
 S PC=$P($G(^VA(200,INDA,"PS")),U,5)
 S DENT="" S DENT=$O(^DIC(7,"D",52,DENT))
 I $D(MFNTYP)=0 S MFNTYP=$$FINDTYP^BADEHL2(INDA)
 I PC=DENT D NEWMSG^BADEHL2(INDA,MFNTYP) Q
 E  S MSG="Not a dentist, message not sent..."
 Q
MSA ;EP
 N MSA,HLST
 D SET(.ARY,"MSA",0)
 D SET(.ARY,"AA",1)
 D SET(.ARY,"TODO-MSGID",2)
 D SET(.ARY,"Transaction Successful",3)
 D SET(.ARY,"todo-010",4)
 S MSA=$$ADDSEG^HLOAPI(.HLST,.ARY)
 Q
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
 ; Edit a parameter from a menu option
EDITPAR(PARAM) ;EP
 S PARAM=$G(PARAM,$P(XQY0,U))
 D TITLE(),EDITPAR^XPAREDIT(PARAM):$$CHECK(8989.51,PARAM,"Parameter")
 Q
 ; Display required header for menus
TITLE(PKG,VER) ;EP
 Q:$E($G(IOST),1,2)'="C-"
 N X,%ZIS,IORVON,IORVOFF,MNU
 S MNU=$P(XQY0,U,2),VER="Version "_$G(VER,1.0),PKG=$G(PKG,"RPMS-Dentrix Upload")
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 U IO
 W @IOF,IORVON,$$GET1^DIQ(4,DUZ(2),.01),?(IOM-$L(PKG)\2),PKG,?(IOM-$L(VER)),VER,!,IORVOFF,?(IOM-$L(MNU)\2-$X),MNU
 Q
CHECK(FIL,VAL,ENT) ;
 Q:$$FIND1^DIC(FIL,"","X",VAL) 1
 W !,ENT," ",VAL," was not found.",!
 D PAUSE
 Q 0
 ; Pause for user response
PAUSE ;EP
 N X
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
 ; Returns true if user is a dentist (52)
ISDENTST(USR) ;EP
 N PCLS,CODE
 S PCLS=+$P($G(^VA(200,USR,"PS")),U,5)  ; Provider Class
 S CODE=+$P($G(^DIC(7,PCLS,9999999)),U)     ; IHS Code
 Q CODE=52
 ; Returns Inactive status of provider
 ; Input: USR = IEN to File 200
INACTPRV(USR) ;EP
 Q:'$G(USR) 1
 Q:$P($G(^VA(200,USR,0)),U,11) 1  ; Provider has been terminated
 Q:$P($G(^VA(200,USR,"PS")),U,4) 1  ; Provider is inactive
 Q 0  ; Provider is active
