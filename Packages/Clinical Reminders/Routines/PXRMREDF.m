PXRMREDF ; SLC/PJH - Edit PXRM reminder findings. ;06/07/2001
 ;;1.5;CLINICAL REMINDERS;**2,5**;Jun 19, 2000
 ;
 ; Called by PXRMREDT
 ;
SET S:'$D(^PXD(811.9,DA,20,0)) ^PXD(811.9,DA,20,0)="^811.902V" Q
 ;
 ;Edit Findings (excludes Terms)
 ;------------------------------
FIND D SET ; Check if node defined
 F  D  Q:$D(DUOUT)!$D(DTOUT)
 .;Display list of existing findings
 .W !!,"Findings"
 .D DSPALL
 .;Edit findings
 .D FEDIT(DA) Q:$D(DUOUT)!$D(DTOUT)
 .;Update list with term modifications
 .D LIST^PXRMREDT(.LIST)
 K DUOUT,DTOUT
 Q
 ;
 ;Display ALL findings
 ;--------------------
DSPALL N SUB,FIRST S FIRST=1,SUB="",SUB1=""
 F  S SUB=$O(LIST(SUB)) Q:SUB=""  D
 .S SUB1=0
 .F  S SUB1=$O(LIST(SUB,SUB1)) Q:SUB1=""  D
 ..I FIRST S FIRST=0 W !!,"Choose from:",!
 ..W SUB
 ..W ?8,SUB1,!
 I FIRST W !!,"Reminder has no findings",!
 ;Update list
 D LIST^PXRMREDT(.LIST)
 Q
 ;
 ;Display findings for file type selected
 ;---------------------------------------
DSP(TYPE) ;
 N SUB,FIRST S FIRST=1,SUB=""
 F  S SUB=$O(LIST(TYPE,SUB)) Q:SUB=""  D
 .I FIRST S FIRST=0 W !!,"Choose from:",!
 .W SUB
 .W !
 I FIRST W !!,"Reminder has no "_$G(DEF2(TYPE))_" findings",!
 Q
 ;
 ;Edit individual FINDING entry
 ;-----------------------------
FEDIT(IEN) ;
 N DA,DIC,DIE,DUOUT,DR,GLOB,Y
 S DA(1)=IEN
 S DIC="^PXD(811.9,"_IEN_",20,"
 S DIC(0)="QEAL"
 S DIC("A")="Select FINDING: "
 S DIC("P")="811.902V"
 D ^DIC I Y=-1 S DTOUT=1 Q
 S DIE=DIC K DIC
 S DA=+Y,GLOB=$P($P(Y,U,2),";",2) Q:GLOB=""
 S TYPE=$G(DEF1(GLOB))
 ;Finding record fields
 S DR=".01;1;2;3;6;7;8;9;12"
 ;Taxonomy - use inactive problems
 I TYPE="TX" S DR=DR_";10"
 ;Health Factor - within category rank
 I TYPE="HF" S DR=DR_";11"
 ;Mental Health - scale
 I TYPE="MH" S DR=DR_";13"
 ;Rx Type
 I (TYPE="DC")!(TYPE="DG")!(TYPE="DR") S DR=DR_";16"
 ;Condition
 S DR=DR_";14;15"
 ;Found/not found text
 S DR=DR_";4;5"
 ;
 ;Edit finding record
 D ^DIE
 Q
 ;
 ;General help text routine
 ;-------------------------
HELP(CALL) ;
 N HTEXT
 N DIWF,DIWL,DIWR,IC
 S DIWF="C70",DIWL=0,DIWR=70
 ;
 I CALL=1 D
 .S HTEXT(1)="Select the type of finding you wish to change or add."
 .S HTEXT(2)="Type '?' for a list of the available finding types."
 I CALL=2 D
 .S HTEXT(1)="Select section of the reminder you wish to edit or 'All'"
 .S HTEXT(2)="to step through all sections of the reminder definition."
 ;
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
