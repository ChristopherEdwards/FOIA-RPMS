INHT ;JSH; 25 Mar 93 12:20;Transaction Type routines 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
EDT ;Edit a Transaction Type
 K DIC
 W !! S DIC="^INRHT(",DIC(0)="QAELM",DIC("A")="Select Transaction Type: " D ^DIC K DIC Q:Y<0
 I $P(Y,U,3) S $P(^INRHT(+Y,0),U,5)=1
 S DA=+Y,DIE="^INRHT(" D EDIT("INH TRANSACTION TYPE")
 G EDT Q
 ;
POST ;Post-action for In/Out field
 N I I $$VAL^DWRA(4000,.08)="O" D  Q
 . F I=.09,.1,.11 S DWSFLD(I)="",DWSFLD(I,0)=2
 . S DWSFLD(.02,0)=0
 . F I=.06,.07,.12 S DWSFLD(I,0)=0
 I $$VAL^DWRA(4000,.08)="I" D  Q
 . F I=.09,.1,.11 S DWSFLD(I,0)=0
 . F I=.02,.06,.07,.12 S DWSFLD(I,0)=2,DWSFLD(I)=""
 Q
 ;
EDB ;Edit a background process
 K DIC
 W !! S DIC="^INTHPC(",DIC(0)="QAELM",DIC("A")="Select BACKGROUND PROCESS: ",DIC("S")="I Y>2" D ^DIC Q:Y<0
 S DA=+Y,DIE=DIC D EDIT("INH BACKGROUND PROCESS") G EDB
 ;
EDD ;Edit a destination
 K DIC
 W !! S DIC="^INRHD(",DIC(0)="QAELM",DIC("A")="Select INTERFACE DESTINATION: " D ^DIC Q:Y<0
 S DA=+Y,DIE=DIC D EDIT("INH DESTINATION ENTRY AND EDIT") G EDD
 ;
EDSITE ;Edit site parameters
 N DIC,DIE,DA,DLAYGO,DO
 G:$D(^INRHSITE(1,0)) EDSITE1
 I '$D(^XMB(1,1,0)) W !!,*7,"KERNEL SITE PARAMETERS must be initialized first." Q
 S (DIC,DLAYGO)=4002,DIC(0)="L",X=1 D ^DICN
EDSITE1 S DA=1,DIE=4002 D EDIT("INH SITE PARAMETERS") Q
 ;
EMR ;Edit Interface Message Replication entries
 N DIC,DIE,DA,DLAYGO,DO
 W !! S DIC="^INRHR(",DIC(0)="QAELM",DIC("A")="Select transaction type: " D ^DIC Q:Y<0
 S DA=+Y,DIE=DIC D EDIT("INH MESSAGE REP ENTER EDIT") G EMR
 ;
EDIT(%T) ;Perform an edit either using a gallery or input template
 ;%T = gallery/template name
 ;Enter with DIE=global reference of file to edit
 ;DA = entry #
 Q:$G(%T)=""  Q:'$D(DIE)!('$D(DA))
 ;Check to determine if this is an IHS system and the form exists
 I '$$SC^INHUTIL1,$D(^DIST(.403,"B",%T)) D  Q
 .N DDSFILE,DDSPAGE
 .S DDSFILE=DIE,DR="["_$TR(%T,"[]")_"]",DDSPAGE=1
 .D ^DDS
 K DWFILE I $$SC^INHUTIL1,'$P($G(^INRHSITE(1,2)),U,5) S DWN=%T D ^DWC Q
 S DR="["_$TR(%T,"[]")_"]" D ^DIE S DWFILE="" Q
 ;
EDOS ;Edit Interface OS file
 N DIC,DA,DO
 I '$O(^INTHOS(0)) D  Q:DA<1
 . S ^INTHOS(0)=$P(^INTHOS(0),U,1,2)
 . S DIC=.7,DIC(0)="QAEM" D ^DIC K DIC S DA=+Y Q:DA<1
 . S (DLAYGO,DIC)=4002.1,DIC(0)="L",X=+Y D ^DICN K DIC
 S DA=1,DIE="^INTHOS(" D EDIT("INH OPERATING SYSTEM")
 Q
