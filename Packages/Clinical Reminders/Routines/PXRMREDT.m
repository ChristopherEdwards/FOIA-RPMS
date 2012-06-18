PXRMREDT ; SLC/PKR,PJH - Edit PXRM reminder definition. ;06/06/2001
 ;;1.5;CLINICAL REMINDERS;**5**;Jun 19, 2000
 ;
 ;=======================================================================
 ;Build list of finding file definitions.
 N DEF,DEF1,DEF2
 D DEF^PXRMRUTL(.DEF,.DEF1,.DEF2)
 ;
 N DA,DIC,DLAYGO,DTOUT,DUOUT,Y
 S DIC="^PXD(811.9,"
 S DIC(0)="AEMQL"
 S DIC("A")="Select Reminder Definition: "
 S DIC("S")="I $$VEDIT^PXRMUTIL(DIC,Y)"
 S DLAYGO=811.9
GETNAME ;Get the name of the reminder definition to edit.
 ;Set the starting place for additions.
 D SETSTART^PXRMCOPY(DIC)
 W !
 D ^DIC
 I ($D(DTOUT))!($D(DUOUT)) Q
 I Y=-1 G END
 S DA=$P(Y,U,1)
 D ALL(DIC,DA)
 G GETNAME
END ;
 Q
 ;
 ;=======================================================================
 ;Select section of reminder to edit, also called at ALL by PXRMEDIT.
 ;----------------------------------
ALL(DIC,DA) ;
 ;Get list of findings/terms for reminder
 N CS1,CS2,BLDLOGIC,LIST,TYPE,FILE,LIST,OPTION
 S BLDLOGIC=0
 ;Save the original checksum.
 S CS1=$$FILE^PXRMEXCS(811.9,DA)
 D LIST(.LIST)
 ;If this is a new reminder enter all fields
 I $P(Y,U,3)=1 D EDIT(DIC,DA) Q
 ;Otherwise choose fields to edit
 F  D  Q:$D(DUOUT)!$D(DTOUT)
 .D OPTION Q:$D(DUOUT)!$D(DTOUT)
 .;All details
 .I OPTION="A" D
 .. S BLDLOGIC=1
 .. D EDIT(DIC,DA)
 .;Set up local variables
 .N DIE,DR S DIE=DIC N DIC
 .;Descriptions
 .I OPTION="G" D
 ..D GEN
 .;Baseline Frequency
 .I OPTION="B" D
 ..S BLDLOGIC=1
 ..D BASE
 .;Findings
 .I OPTION="F"  D
 ..S BLDLOGIC=1
 ..D FIND
 .;Logic
 .I OPTION="L" D
 ..S BLDLOGIC=1
 ..D LOGIC
 .;Dialog
 .I OPTION="D" D
 ..D DIALOG
 .;Web addresses
 .I OPTION="W" D
 ..D WEB
 .;If necessary build the internal logic strings.
 .I BLDLOGIC D
 ..D BLDALL^PXRMLOGX(DA,"")
 ;See if any changes have been made.
 S CS2=$$FILE^PXRMEXCS(811.9,DA)
 I CS2=0 Q
 ;If the file has been edited, do the edit history.
 I CS2'=CS1 D SEHIST^PXRMUTIL(811.9,DIC,DA)
 Q
 ;
 ;Reminder Edit
 ;-------------
EDIT(ROOT,DA) ;
 N DIC,DIDEL,DIE,DR,TAX
 S DIE=ROOT,DIDEL=811.9
 ;
 ;Edit the fields in the same order they are printed by a reminder
 ;inquiry.
 ;Reminder name
 W !!
 S DR=".01"
 D ^DIE
 ;If DA is undefined then the entry was deleted and we are done.
 I '$D(DA) S DTOUT=1 Q
 I $D(Y) S DTOUT=1 Q
 ;
 ;Other fields
 D GEN Q:$D(Y)
 D BASE Q:$D(Y)
 D FIND Q:$D(Y)
 D LOGIC Q:$D(Y)
 D DIALOG Q:$D(Y)
 D WEB Q:$D(Y)
 Q
 ;
GEN ;Print name
 W !!
 S DR="1.2"
 D ^DIE
 I $D(Y) Q
 ;
 ;Class, sponsor, review date, usage
 W !!
 S DR="100;101;102;103"
 D ^DIE
 I $D(Y) Q
 ;
 ;Related VA-* reminder
 W !!
 S DR="1.4"
 D ^DIE
 I $D(Y) Q
 ;
 ;Inactive flag
 W !!
 S DR="1.6"
 D ^DIE
 I $D(Y) Q
 ;
 ;Reminder description
 W !!
 S DR="2"
 D ^DIE
 I $D(Y) Q
 ;
 ;Technical description
 W !!
 S DR="3"
 D ^DIE
 ;
 ;Priority
 W !!
 S DR="1.91"
 D ^DIE
 Q
 ;
BASE W !!,"Baseline Frequency"
 ;Do in advance time frame
 S DR=1.3
 D ^DIE
 I $D(Y) Q
 ;
 ;Sex specific
 S DR=1.9
 D ^DIE
 I $D(Y) Q
 ;
 ;Ignore on N/A
 S DR=1.8
 D ^DIE
 I $D(Y) Q
 ;
 W !!,"Baseline frequency age range set"
 S DR="7"
 D ^DIE
 Q
 ;
FIND ;Edit findings (multiple)
 D FIND^PXRMREDF
 Q
 ;
LOGIC W !!,"Patient Cohort and Resolution Logic"
 S DR="30T;60T;61T;34T;65T;66T"
 D ^DIE
 ;Make sure the Patient Cohort Logic at least contains the default.
 I $G(^PXD(811.9,DA,31))="" S ^PXD(811.9,DA,31)="(SEX)&(AGE)"
 Q
 ;
DIALOG W !!,"Reminder Dialog"
 S DR="51"
 D ^DIE
 Q
 ;
WEB W !!,"Web Addresses for Reminder Information"
 S DR="50"
 D ^DIE
 Q
 ;
 ;
 ;Get full list of findings
 ;-------------------------
LIST(ARRAY) ;
 N TYPE,DATA,GLOB,IEN,NAME,NODE,SUB
 ;Clear passed arrays
 K ARRAY
 ;Build cross reference global to file number
 ;Get each finding
 S SUB=0 F  S SUB=$O(^PXD(811.9,DA,20,SUB)) Q:'SUB  D
 .S DATA=$G(^PXD(811.9,DA,20,SUB,0)) I DATA="" Q
 .;Determine global and global ien
 .S NODE=$P(DATA,U),GLOB=$P(NODE,";",2),IEN=$P(NODE,";")
 .;Ignore null entries
 .I (GLOB="")!(IEN="") Q
 .;Work out the file type
 .S TYPE=$G(DEF1(GLOB)) Q:TYPE=""
 .S NAME=$P($G(@(U_GLOB_IEN_",0)")),U)
 .S ARRAY(TYPE,NAME)=""
 Q
 ;
 ;Choose which part of Reminder to edit
 ;-------------------------------------
OPTION N X,Y,DIR,IC,IND
 ;Display warning message if un-mapped terms exist
 K DIROUT,DIRUT,DTOUT,DUOUT
 S DIR(0)="SO"_U
 S DIR(0)=DIR(0)_"A:All reminder details;"
 S DIR(0)=DIR(0)_"G:General;"
 S DIR(0)=DIR(0)_"B:Baseline Frequency;"
 S DIR(0)=DIR(0)_"F:Findings;"
 S DIR(0)=DIR(0)_"L:Logic;"
 S DIR(0)=DIR(0)_"D:Reminder Dialog;"
 S DIR(0)=DIR(0)_"W:Web Addresses;"
 S DIR("A")="Select section to edit"
 S DIR("?")="Select which section of the reminder you wish to edit."
 S DIR("??")="^D HELP^PXRMREDF(2)"
 D ^DIR K DIR
 I Y="" S DUOUT=1 Q
 I $D(DIROUT) S DTOUT=1
 I $D(DTOUT)!$D(DUOUT) Q
 S OPTION=Y
 Q
 ;
