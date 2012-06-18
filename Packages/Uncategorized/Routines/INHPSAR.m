INHPSAR ;WOM JPD; 29 Mar 96 11:31;Message Replication Application 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ; Associates all children of a parent INTERFACE TRANSACTION
 ; with an entry in the REPLICATION FILE
 ; 
 ; Pick a parent. Then Pick Base.
 ; Software finds children of parent makes them replicants
 ; then stuffs Base Transaction into .02 of 
 ; above message replicant file entries
 ; Then makes the children parents by removing parent field
 ;
 W !,"Not an entry point"
 Q
EN N Y,INPT,INBS,INPTY0,INBSY0
 K ^UTILITY("INHPSAR",$J)
 W @IOF,!,$$CENTER^INHUTIL("Message Replication Application",80),!!
 ; Get Parent TT
 F  Q:'$$PT(.Y)  D BS(+Y,Y(0))
 K ^UTILITY("INHPSAR",$J)
 Q  ;Exit here
PT(Y) ;Get parent TT
 N DIC
 S DIC="^INRHT(",DIC(0)="AEQZ",DIC("S")="I $P(^(0),U,6)="""""
 S DIC("A")="Enter Parent Transaction Type: "
 D ^DIC
 Q (Y'=-1)
BS(INPT,INPTY0) ;Get Base (REP) 
 ; Input:
 ;   INPT - Transaction Type 
 ;   INPTY0 - Zero node of Transacion Type
 N DIC,Y,INBS,INBS0
 S DIC="^INRHT(",DIC(0)="AEQZ",DIC("A")="Enter Base Transaction Type: "
 ;check so that no children pointing to it
 S DIC("S")="I '$D(^INRHT(""AC"",Y))"
 D ^DIC I Y=-1 Q
 D ASS(INPT,INPTY0,+Y,Y(0))
 Q
ASS(INPT,INPTY0,INBS,INBSY0) ;Associate children of TT w/replicants
 ; Input:
 ;   INPT - Transaction Type ien
 ;   INPTY0 - Zero node of Transacion Type
 ;   INBS - Base Transaction Type ien
 ;   INBSY0 - Zero Node of Base Transaction Type
 N INCH,INY
 W !!,"You are about to associate all children of",!,"Interface Transaction Type ",$P(INPTY0,U),!,"with ",$P(INBSY0,U)," as replicants",!,"These are:",!
 ; loop cross ref of parent INPT looking for children
 S INCH="" F  S INCH=$O(^INRHT("AC",INPT,INCH)) Q:INCH=""  D
 .W !,INCH,?20,$P(^INRHT(INCH,0),U)
 .;child same as base
 .I INCH=INBS W !,"Note - Child of Parent same as Base Transaction - will not be processed" Q
 .;save children of parent INPT in Utility global
 .S ^UTILITY("INHPSAR",$J,INCH)=""
 ;check if children exist
 I '$D(^UTILITY("INHPSAR",$J)) W !,"No children found. Exiting!"
 E  D
 .W !!,"Continue"
 .I '$$YN^%ZTF(0) W !,"Aborting!"
 .E  D
 ..D ACTVAT(INPT,INPTY0)
 ..D CREAT(INPT,INPTY0,INBS,INBSY0)
 ..D SBT(INBS,$P(INPTY0,U))
 Q
ACTVAT(INPT,INPTY0) ; Set parent to ACTIVE
 ; Input:
 ;   INPT - Transaction Type 
 ;   INPTY0 - Zero node of Transacion Type
 N INY,DIE,DR
 S DIE="^INRHT(",DA=INPT,DR="S INY=0;.05///ACTIVE;S INY=1"
 D ^DIE
 I 'INY W !,"Unable to Activate Parent Transaction ",$P(INPTY0,U)
 Q
CREAT(INPT,INPTY0,INBS,INBSY0) ; Create entry in REPLICATION FILE for each child of 
 ;the parent and delete Parent Pointer from all children
 ; Input:
 ;   INPT - Transaction Type ien
 ;   INPTY0 - Zero node of Transacion Type
 ;   INBS - Base Transaction Type ien
 ;   INBSY0 - Zero Node of Base Transaction Type
 N INCH
 ;get all children of parent
 S INCH="" F  S INCH=$O(^UTILITY("INHPSAR",$J,INCH)) Q:INCH=""  D
 .D CRE(INCH,INBS),DEL(INCH) S ^UTILITY("INHPSAR",$J,INCH)=""
 ;
 W !!!!,"The Parent INTERFACE TRANSACTION TYPE ",$P(INPTY0,U),!," no longer has the children listed above"
 W !!,"These former Children Transaction Types are Replicants with the",!,"ORIGINATING TRANSACTION TYPE of ",$P(INBSY0,U),!
 Q
DEL(DA) ; Makes child a parent
 ; Input:  DA - IEN of child entry in INTERFACE TRANSACTION FILE
 ;               to delete parent field
 N DIE,DR,INY
 S DIE="^INRHT(",DR="S INY=0;.06///@;S INY=1"
 D ^DIE
 I '$G(INY) W !,"Unable to delete child from parent ",DIE,DA
 Q
CRE(INCH,INBS) ; Create entry in REPLICATION FILE
 ; Input:  INCH - IEN of entry in INTERFACE TRANSACTION FILE
 ;               and .01 field
 ;         INBS - ORIGINATING TRANSACTION field
 ; Output: NONE
 N DA,DIC,DIE,DR,X,Y,INY
 S (DIC,DIE)="^INRHR(",DIC(0)="ZXL",X="`"_INCH
 ;look up child in INTERFACE REPLICATION FILE and laygo if not existing
 S DA=+$$DIC^INHSYS05(DIC,X,4020,DIC(0))
 I DA<1 W !,"Unable to replicate a child ",X Q
 ;Stuff Base TT into originating TT in INTERFACE MESSAGE REPLICATION FILE
 S DR="S INY=0;.02///`"_INBS_";S INY=1"
 D ^DIE
 I '$G(INY) W !,"NO DATA FILED for replicant ",DIE,INBS
 Q
SBT(DA,PTT) ;Stuff Base transaction into parent
 ; Input:
 ;  DA - ien of Base
 ;  PTT - Name of Parent Transaction Type to stuff into Base .06 field
 N DIE,DR,INY
 S DIE="^INRHT(",DR=".06///@"
 D ^DIE
 S DR="S INY=0;.06///^S X=PTT;S INY=1"
 D ^DIE
 I '$G(INY) W !,"Unable to stuff Parent into Base"
 Q
