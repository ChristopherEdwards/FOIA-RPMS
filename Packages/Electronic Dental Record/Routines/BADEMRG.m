BADEMRG ;IHS/MSC/MGH - Dentrix HL7 interface  ;31-Aug-2010 13:46;EDR
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 Q
TLOADPT ;EP Taskman call to start patient load
 N STOP,ZTDTH,ZTIO,ZTDESC,ZTRTN,ZTSAVE,ZTPRI,ZTSK
 ;Make sure its not already running
 S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE MRG LOAD",1,"E")
 ;Its already running and shouldn't be restarted
 I STOP="NO" D  H 3 Q
 .W !,"Merge Upload is already running",!
 I $$GET^XPAR("ALL","BADE EDR MRG DFN") D  H 3 Q
 .W !,"Upload process has already begun. Please use Restart option.",!
 S ZTIO=""
 S ZTPRI=1
 S ZTDESC="Load Patient Merge Data to EDR"
 S ZTRTN="LOADPT^BADEMRG"
 S ZTSAVE("DUZ")=""
 D ^%ZTLOAD
 I $G(ZTSK) D
 .D EN^XPAR("SYS","BADE EDR MRG LOAD TSK",1,ZTSK)
 .W !,"Task number "_ZTSK H 2
 Q
LOADPT ;EP Load all patient's data
 N FDFN,CNT,CNTCHK,DATA,TOTAL,STOP,THROTTLE,RESULT
 ;Make sure the stop parameter is NO
 D EN^XPAR("SYS","BADE EDR PAUSE MRG LOAD",1,"NO")
 ;Set the dfn to null
 S FDFN=$$GET^XPAR("ALL","BADE EDR MRG DFN")
 ;Loop through the patients and send data
LOOP S FDFN=$S(FDFN>0:FDFN,1:0),CNT=0,STOP="NO",TOTAL=0
 F  S FDFN=$O(^DPT(FDFN)) Q:+FDFN'>0!(STOP="YES")  D
 .Q:'$D(^DPT(FDFN,-9))   ;Patient has not been merged
 .;If patient was merged, find the merged to patient and send A40 message
 .;and an A31 message on the merged to patient
 .S RESULT=""
 .S RESULT=$$MRGTODFN^BADEUTIL(FDFN)
 .D A40(FDFN,RESULT)
 .D A31(RESULT)
 .;Set IEN into the DFN parameter
 .D EN^XPAR("SYS","BADE EDR MRG DFN",1,FDFN)
 .;Add to total count
 .S TOTAL=TOTAL+1
 .D EN^XPAR("SYS","BADE EDR MRG TOTAL",1,TOTAL)
 .;Check to see if we should stop
 .S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE MRG LOAD",1,"E")
 .Q:STOP="YES"
 ;Finish up by resetting the pt parameter to null and the stop paramater to YES
 I STOP="NO" D
 .D EN^XPAR("SYS","BADE EDR PAUSE MRG LOAD",1,"YES")
 .D EN^XPAR("SYS","BADE EDR MRG LOAD TSK",1,"Upload complete")
 .D COMPLETE("DONE")
 Q
TRESTRT ;EP Taskman call to restart patient load
 N STOP,ZTDTH,ZTIO,ZTDESC,ZTRTN,ZTSAVE,ZTPRI,ZTSK
 ;Make sure its not already running
 S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE MRG LOAD",1,"E")
 ;Its already running and shouldn't be restarted
 I STOP="NO" W !,"Process is already running",!!! H 3 Q
 S ZTIO=""
 S ZTPRI=1
 S ZTDESC="Load Merge Data to EDR"
 S ZTRTN="RESTPT^BADEMRG"
 S ZTSAVE("DUZ")=""
 D ^%ZTLOAD
 I $G(ZTSK) D
 .D EN^XPAR("SYS","BADE EDR MRG LOAD TSK",,ZTSK)
 .W !,"Task number "_ZTSK H 2
 Q
RESTPT ;EP Restart the patient load
 N FDFN,CNT,CNTCHK,TOTAL,DATA,STOP,RESULT
 ;Get the last used DFN from the parameter
 S FDFN=$$GET^XPAR("ALL","BADE EDR MRG DFN")
 ;Set the stop parameter to NO
 D EN^XPAR("SYS","BADE EDR PAUSE MRG LOAD",,0)
 ;Get the total count
 S TOTAL=$$GET^XPAR("ALL","BADE EDR MRG TOTAL")
 ;Task off the job of restarting
LOOP2 S CNT=0,STOP="NO"
 S FDFN=$S(FDFN>0:FDFN,1:0)
 F  S FDFN=$O(^DPT(FDFN)) Q:+FDFN'>0!(STOP="YES")  D
 .Q:'$D(^DPT(FDFN,-9))   ;Patient has not been merged
 .;If patient was merged, find the merged to patient and send A40 messag
 .;and an A31 message on the merged to patient
 .S RESULT=""
 .S RESULT=$$MRGTODFN^BADEUTIL(FDFN)
 .D A40(FDFN,RESULT)
 .D A31(RESULT)
 .;Send message if patient was merged
 .;Set IEN into the DFN parameter
 .D EN^XPAR("SYS","BADE EDR MRG DFN",1,FDFN)
 .;Add to total count
 .S TOTAL=TOTAL+1
 .D EN^XPAR("SYS","BADE EDR MRG TOTAL",1,TOTAL)
 .;See if we should stop
 .S STOP=$$GET^XPAR("ALL","BADE EDR PAUSE MRG LOAD",1,"E")
 .Q:STOP="YES"
 ;Finish up by resetting the pt parameter to null and the stop parameter to YES
 I STOP="NO" D
 .D EN^XPAR("SYS","BADE EDR PAUSE MRG LOAD",1,1)
 .D EN^XPAR("SYS","BADE EDR MRG LOAD TSK",1,"Upload complete")
 .D COMPLETE("DONE")
 Q
COMPLETE(WHICH) ;Mark options out of order
 N MSG,MENU,I
 S MENU(1)="BADE EDR UPLOAD ALL MERGED PTS"
 S MENU(2)="BADE EDR RESTART MRG UPLOAD"
 S MENU(3)="BADE EDR PAUSE MRG LOAD"
 S MENU(4)="BADE EDR SEND A40"
 F I=1:1:4 D
 .N DA,DIE,DR
 .I (WHICH="DONE"),(I=4) Q
 .S MSG=$S(WHICH="DONE":"Upload completed",1:"Patient merge not installed")
 .S DA=$O(^DIC(19,"B",MENU(I),""))
 .I DA'=""  D
 ..S DIE="^DIC(19,",DR="2///^S X=MSG"
 ..D ^DIE
 ; Enable event protocols
 D EDPROT^BADEUTIL("BADE PATIENT A40")
 Q
SENDA40 ;Send one A40 message
 N ERR,DIC,DIR,DT,DFN,DFN2,BADERR,X,Y,RESULT,ARRAY,CNT,NAME,QUIT
 S CNT=0
 S DIC=2,DIC("A")=" Select Patient:  ",DIC(0)="AEQMZ",DT=$$DT^XLFDT
 D ^DIC I Y=-1 G SENDX
 I +Y>0 D
 .S DFN=+Y
 .Q:'DFN
 .S NAME=$P($G(^DPT(DFN,0)),U,1)
 .S DFN2=0 F  S DFN2=$O(^DPT(DFN2)) Q:'+DFN2  D
 ..Q:'$D(^DPT(DFN2,-9))
 ..S RESULT=$$MRGTODFN^BADEUTIL(DFN2)
 ..I RESULT=DFN D
 ...S CNT=CNT+1
 ...S ARRAY(CNT)=DFN2_U_$P($G(^DPT(DFN2,0)),U,1)
 I CNT=0 W !,"There were no patients merged to "_NAME G SENDA40
 S QUIT=0
 I CNT>0 D
 .N I
 .S I=0 F  S I=$O(ARRAY(I)) Q:I=""  D
 ..W !,CNT,?10,$P(ARRAY(I),U,2)
 ..S DIR(0)="N",DIR("A")="Select the MERGED FROM PT" D ^DIR
 ..I '$D(ARRAY(X)) W !,"Invalid Selection, Try again" S QUIT=1
 ..E  S FROM=$P(ARRAY(X),U,1),TO=DFN D MSG(FROM,TO)
 I QUIT G SENDA40
 Q
SENDX Q
MSG(FROM,TO) ;EP to send A40 and A31 messages
 D A40(FROM,TO)
 I $D(ERR) W !,"Unable to send HL7 message" H 2 Q
 D A31(TO)
 I '$D(ERR) W !,"Message was sent" H 2
 I $D(ERR) W !,"Unable to send HL7 message" H 2
 Q
A40(FROM,TO) ;EP Create and send one A40 message
 N EVNTTYPE
 S EVNTTYPE="A40"
 D NEWMSG^BADEMRG1(FROM,TO,EVNTTYPE)
 Q
A31(DFN) ;EP Create and send one A31 message
 N EVNTTYPE,DOD
 S EVNTTYPE="A31"
 I '$D(^DPT(DFN,0)) D NOTIF^BADEHL1(DFN,"Missing zero node.  Cannot create A31.") Q
 D NEWMSG^BADEHL1(DFN,EVNTTYPE)
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
