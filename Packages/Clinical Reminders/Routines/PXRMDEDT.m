PXRMDEDT ; SLC/PJH - Edit PXRM reminder dialog. ;12/21/2001
 ;;1.5;CLINICAL REMINDERS;**2,5,7**;Jun 19, 2000
 ;
 ;Used by protocol PXRM SELECTION ADD/PXRM GENERAL ADD
 ;
 ;Add Dialog
 ;----------
ADD N DA,DIC,Y,DTOUT,DUOUT,DTYP,DLAYGO,HED
 S HED="ADD DIALOG"
 W IORESET
 F  D  Q:$D(DTOUT)
 .S DIC="^PXRMD(801.41,"
 .;Set the starting place for additions.
 .D SETSTART^PXRMCOPY(DIC)
 .S DIC(0)="AELMQ",DLAYGO=801.41
 .S DIC("A")="Select DIALOG to add: "
 .S DIC("DR")="4///"_$G(PXRMDTYP)
 .D ^DIC
 .I $D(DUOUT) S DTOUT=1
 .I ($D(DTOUT))!($D(DUOUT)) Q
 .I Y=-1 K DIC S DTOUT=1 Q
 .I $P(Y,U,3)'=1 W !,"This dialog name already exists" Q
 .S DA=$P(Y,U,1)
 .;Determine dialog type
 .S DTYP=$P($G(^PXRMD(801.41,DA,0)),U,4)
 .;Enter dialog type if a new entry
 .I DTYP="" D  Q:$D(Y)
 ..N DIE,DR
 ..S DIE=801.41,DR=4
 ..D ^DIE
 .;
 .;Edit Dialog
 .D EDIT(DTYP,DA)
 Q
 ;
 ;Delete a line from the reminder dialog
 ;--------------------------------------
DEL(DIEN,PXRMDIEN) ;
 N DA,DIK
 S DA(1)=PXRMDIEN,DA=$O(^PXRMD(801.41,PXRMDIEN,10,"D",DIEN,"")) Q:'DA
 S DIK="^PXRMD(801.41,"_DA(1)_",10,"
 D ^DIK
 Q
 ;
 ;called by protocol PXRM DIALOG EDIT
 ;-----------------------------------
EDIT(TYP,DA) ;
 Q:'$$LOCK(DA)
 W IORESET
 N CS1,CS2,DIC,DIDEL,DIE,DR,DTOUT,DUOUT,DINUSE,TYP,ODA,Y
 ;Save checksum
 S CS1=$$FILE^PXRMEXCS(801.41,DA)
 ;Check dialog type
 S TYP=$P($G(^PXRMD(801.41,DA,0)),U,4)
 S DIE="^PXRMD(801.41,",DIDEL=801.41,DINUSE=0,ODA=DA
 ;Reminder Dialog
 I TYP="R" S DR="[PXRM EDIT REMINDER DIALOG]"
 ;Dialog Element
 I TYP="E" S DR="[PXRM EDIT ELEMENT]"
 ;Additional Prompt
 I TYP="P" S DR="[PXRM EDIT PROMPT]"
 ;Forced Value
 I TYP="F" S DR="[PXRM EDIT FORCED VALUE]"
 ;Dialog Group (Finding item dialog)
 I TYP="G" S DR="[PXRM EDIT GROUP]"
 ;Result Group
 I TYP="S" S DR="[PXRM RESULT GROUP]"
 ;Result Element
 I TYP="T" S DR="[PXRM RESULT ELEMENT]"
 ;Allows limited edit of national dialogs
 I $P($G(^PXRMD(801.41,DA,100)),U)="N" D
 .I $G(PXRMINST)=1,DUZ(0)="@" Q
 .S DR="[PXRM EDIT NATIONAL DIALOG]",DINUSE=1
 ;
 I "GEPF"[TYP D
 .I '$D(^PXRMD(801.41,"AD",DA)) W !,"Not used by any other dialog",! Q
 .I PXRMGTYP'="DLG" S DINUSE=1 Q
 .I PXRMGTYP="DLG" D  Q
 ..N SUB
 ..S SUB=0
 ..F  S SUB=$O(^PXRMD(801.41,"AD",DA,SUB)) Q:'SUB  Q:DINUSE  D
 ...I SUB'=PXRMDIEN S DINUSE=1
 I DINUSE D
 .W !,"CURRENT DIALOG ELEMENT/GROUP NAME: "_$P($G(^PXRMD(801.41,DA,0)),U)
 .I TYP="S" Q
 .I PXRMGTYP="DLGE" W !,"Used by:" D USE^PXRMDLST(DA,10,"")
 .I PXRMGTYP'="DLGE" W !,"Used by:" D USE^PXRMDLST(DA,10,PXRMDIEN)
 ;
 ;Save list of components
 N COMP D COMP^PXRMDEDX(DA,.COMP)
 ;
 ;Edit dialog then unlock
 D ^DIE,UNLOCK(ODA)
 ;Deleted ???
 I '$D(DA) D  Q
 .;Clear any pointers from #811.9
 .I $D(PXRMDIEN) D PURGE(PXRMDIEN)
 .;Option to delete components
 .I $D(COMP) D DELETE^PXRMDEDX(.COMP)
 .S VALMBCK="Q"
 ;
 ;Update edit history
 I (TYP'="R") D
 .S CS2=$$FILE^PXRMEXCS(801.41,DA) Q:CS2=CS1  Q:+CS2=0
 .D SEHIST^PXRMUTIL(801.41,DIC,DA)
 ;
 ;Redisplay changes (reminder dialog option only)
 I PXRMGTYP="DLG",TYP="R" D
 .;Get name of reminder dialog again
 .S Y=$P($G(^PXRMD(801.41,DA,0)),U)
 .;Format headings to include dialog name
 .S PXRMHD="REMINDER DIALOG NAME: "_$P(Y,U)
 .;Check if the set is disable and add to header if disabled
 .I $P(^PXRMD(801.41,DA,0),U,3)]"" S PXRMHD=PXRMHD_" (DISABLED)"
 .;Reset header in case name has changed
 .S HEADER=PXRMHD,VALMHDR(1)=HEADER
 Q
 ;
 ;Add SINGLE dialog element (protocol PXRM DIALOG SELECTION ITEM)
 ;-------------------------
ESEL(PXRMDIEN,SEL) ;
 N DA,DIC,DLAYGO,DNEW,DTOUT,DUOUT,DTYP,Y
 ;
 S DIC="^PXRMD(801.41,"
 S DLAYGO="801.41"
 ;Set the starting place for additions.
 D SETSTART^PXRMCOPY(DIC)
 S DIC(0)="AEMQL"
 S DIC("A")="Select new DIALOG ELEMENT: "
 S DIC("S")="I ""EG""[$P(^PXRMD(801.41,Y,0),U,4)&(Y'=PXRMDIEN)"
 S DIC("DR")="4///E"
 W !
 D ^DIC
 I $D(DUOUT) S DTOUT=1
 I ($D(DTOUT))!($D(DUOUT)) Q
 I Y=-1 K DIC S DTOUT=1 Q
 S DA=$P(Y,U,1) Q:'DA
 S DNEW=$P(Y,U,3)
 ;Add to dialog
 D EADD(SEL,DA,PXRMDIEN)
 ;Determine dialog type
 S DTYP=$P($G(^PXRMD(801.41,DA,0)),U,4)
 ;
 ;Edit Dialog
 I DNEW D EDIT(DTYP,DA)
 Q
 ;
 ;Update dialog component multiple
 ;--------------------------------
EADD(SEL,NSUB,PXRMDIEN) ;
 N DA,DATA,NEXT
 S DATA=$G(^PXRMD(801.41,PXRMDIEN,10,0)),NEXT=$P(DATA,U,3)+1
 I DATA="" S DATA="^801.412IA"
 S DA=NSUB,DA(1)=PXRMDIEN
 S ^PXRMD(801.41,PXRMDIEN,10,NEXT,0)=SEL_U_DA_"^^^^^^^"
 ;Update next slot
 S $P(DATA,U,4)=$P(DATA,U,4)+1,$P(DATA,U,3)=NEXT
 S ^PXRMD(801.41,PXRMDIEN,10,0)=DATA
 ;Re-index
 N DIK,DA S DIK="^PXRMD(801.41,",DA=PXRMDIEN
 D IX^DIK
 Q
 ;
 ;Edit individual element (protocol PXRM DIALOG SELECTION ITEM)
 ;-----------------------
IND(DIEN) ;
 W IORESET
 N DIC,DIDEL,DR,DTOUT,DUOUT,DINUSE,HED,NATIONAL,Y
 ;
 S NATIONAL=0
 ;Limited edit of National dialogs
 I $P($G(^PXRMD(801.41,PXRMDIEN,100)),U)="N" D
 .I $G(PXRMINST)=1,DUZ(0)="@" Q
 .S NATIONAL=1
 ;
 W !,"CURRENT DIALOG ELEMENT NAME: "_$P($G(^PXRMD(801.41,DIEN,0)),U)
 ;Ask what to do with it
 N ANS
 I 'NATIONAL D PROMPT(.ANS) Q:$D(DTOUT)!$D(DUOUT)
 ;National can only be edited
 I NATIONAL S ANS="E"
 ;Delete line
 I ANS="D" D DEL(DIEN,PXRMDIEN) Q
 ;Copy and Replace option
 I ANS="C" D SEL^PXRMDCPY(.DIEN,PXRMDIEN) Q:$D(DTOUT)!$D(DUOUT)
 ;Determine if a taxonomy dialog
 N FIND
 S FIND=$P($G(^PXRMD(801.41,IEN,1)),U,5),VALMBCK="R"
 ;Edit taxomomy dialog
 I $P(FIND,";",2)="PXD(811.2," D EDIT^PXRMGEDT("DTAX",$P(FIND,";"),0) Q
 ;Determine dialog type
 S DTYP=$P($G(^PXRMD(801.41,DIEN,0)),U,4) Q:DTYP=""
 ;Option to change an element to a group
 I DTYP="E",'NATIONAL D NTYP(.DTYP) Q:$D(DUOUT)!$D(DTOUT)  D:DTYP="G"
 .S $P(^PXRMD(801.41,DIEN,0),U,4)=DTYP
 .W !,"Dialog element changed to a dialog group"
 ;Edit Element
 D EDIT(DTYP,DIEN)
 Q
 ;
 ;Change Dialog Element Type
 ;--------------------------
NTYP(TYP) ;
 N X,Y,DIR K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="SA"_U_"E:Element;"
 S DIR(0)=DIR(0)_"G:Group;"
 S DIR("A")="Dialog Element Type: "
 S DIR("B")="E"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMDEDT(3)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S TYP=Y
 Q
 ;
 ;Select Dialog Element Action
 ;----------------------------
PROMPT(ANS) ;
 N X,Y,DIR K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="S"_U_"E:Edit;"
 S DIR(0)=DIR(0)_"C:Copy and Replace current element;"
 S DIR(0)=DIR(0)_"D:Delete element from this dialog;"
 S DIR("A")="Select Dialog Element Action"
 S DIR("B")="E"
 S DIR("?")="Select from the codes displayed. For detailed help type ??"
 S DIR("??")=U_"D HELP^PXRMDEDT(1)"
 D ^DIR K DIR
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!($D(DUOUT)) Q
 S ANS=Y
 Q
 ;
 ;Clear pointers from the reminder file and process ID file
 ;---------------------------------------------------------
PURGE(DIEN) ;
 ;Purge pointers to this dialog from reminder file
 N RIEN
 S RIEN=0
 F  S RIEN=$O(^PXD(811.9,"AG",DIEN,RIEN)) Q:'RIEN  D
 .K ^PXD(811.9,RIEN,51),^PXD(811.9,"AG",DIEN,RIEN)
 ;
 Q
 ;
 ;General help text routine. Write out the text in the HTEXT array.
HELP(CALL) ;
 N HTEXT
 N DIWF,DIWL,DIWR,IC
 S DIWF="C70",DIWL=0,DIWR=70
 ;
 I CALL=1 D
 .S HTEXT(1)="Select E to edit dialog element. If you wish to create"
 .S HTEXT(2)="a new dialog element just for this reminder dialog select"
 .S HTEXT(3)="C to copy and replace the current element. Select D to"
 .S HTEXT(4)="delete the sequence number/element from the dialog."
 I CALL=2 D
 .S HTEXT(1)="Enter Y to copy the current dialog element to a new name"
 .S HTEXT(2)="and then use this new element in the reminder dialog."
 I CALL=3 D
 .S HTEXT(1)="Enter G to change the current dialog element into a dialog"
 .S HTEXT(2)="group so that additional elements can be added. Enter E to"
 .S HTEXT(3)="leave the type of the dialog element unchanged."
 I CALL=4 D
 .S HTEXT(1)="Enter Y to change the dialog prompt created into a forced"
 .S HTEXT(2)="value. To edit the new forced value switch to the forced"
 .S HTEXT(3)="value screen using CV. This option only applies to prompts"
 .S HTEXT(4)="which update PCE or vitals."
 .S HTEXT(5)="Enter N to leave the dialog prompt unchanged."
 K ^UTILITY($J,"W")
 S IC=""
 F  S IC=$O(HTEXT(IC)) Q:IC=""  D
 . S X=HTEXT(IC)
 . D ^DIWP
 W !
 S IC=0
 F  S IC=$O(^UTILITY($J,"W",0,IC)) Q:IC=""  D
 . W !,^UTILITY($J,"W",0,IC,0)
 K ^UTILITY($J,"W")
 W !
 Q
 ;
LOCK(DA) ;Lock the record
 N OK
 S OK=1
 I '$$VEDIT^PXRMUTIL("^PXRMD(801.41,",DA) D
 .N DTYP
 .S DTYP=$P($G(^PXRMD(801.41,DA,0)),U,4)
 .;Allow edit of findings but not component multiple on groups 
 .I DTYP="G",$G(PXRMDIEN),DA'=PXRMDIEN Q
 .;Allow edit of element findings
 .I DTYP="E" Q
 .S OK=0
 .W !!,?5,"VA- and national class reminder dialogs may not be edited" H 2
 I 'OK Q 0
 ;
 L +^PXRMD(801.41,DA):0 I  Q 1
 E  W !!,?5,"Another user is editing this file, try later" H 2 Q 0
 ;
 ;
UNLOCK(DA) ;Unlock the record
 L -^PXRMD(801.41,DA)
 Q
