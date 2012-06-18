PXRMRLST ; SLC/PKR - Clinical Reminder list option routine ;02/07/2001
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;===================================================================== 
 ;Build the criteria for which reminders to list.
LIST N ALL,CRITERIA,DIR,IND,LOCAL,LPREFIX,NCRIT,PREFIX,SORT,STATUS,X,Y
START S (ALL,LOCAL,NCRIT)=0
 S (PREFIX,STATUS)=""
 ;
ALLQ K DIR,DIRUT,DTOUT,DUOUT
 S DIR(0)="YAO"
 S DIR("A")="List all reminders? "
 S DIR("B")="Y"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) Q
 I $D(DUOUT) Q
 S ALL=Y
 S NCRIT=NCRIT+1
 S CRITERIA(NCRIT)=DIR("A")_" "_Y(0)
 I ALL G ACTIVEQ
 ;
LOCALQ K DIR,DIRUT,DTOUT,DUOUT
 S DIR(0)="YAO"
 S DIR("A")="List all local reminders? "
 S DIR("B")="Y"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) Q
 I $D(DUOUT) G ALLQ
 S LOCAL=Y
 S NCRIT=NCRIT+1
 S CRITERIA(NCRIT)=DIR("A")_" "_Y(0)
 I LOCAL G ACTIVEQ
 ;
PREFIXQ K DIR,DIRUT,DTOUT,DUOUT
 S PREFIX=""
 S DIR(0)="FAO"_U_"1:30"
 S DIR("A")="List only reminders starting with (prefix)? "
 S DIR("B")="VA-"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) Q
 I $D(DUOUT) G LOCALQ
 S PREFIX=Y
 S LPREFIX=$L(Y)
 S NCRIT=NCRIT+1
 S CRITERIA(NCRIT)=DIR("A")_" "_PREFIX
 ;
ACTIVEQ K DIR,DIRUT,DTOUT,DUOUT
 S DIR(0)="SAO"_U_"A:Active;I:Inactive;B:Both"
 S DIR("A")="List Active (A), Inactive (I), Both (B)? "
 S DIR("B")="B"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) Q
 I $D(DUOUT) G START
 S STATUS=Y
 S NCRIT=NCRIT+1
 S CRITERIA(NCRIT)=DIR("A")_" "_Y(0)
 ;
SORTQ K DIR,DIRUT,DTOUT,DUOUT
 S SORT="N"
 S DIR(0)="SAO"_U_"N:Name (.01);P:Print name"
 S DIR("A")="Sort list by Name (N), Print Name (P)? "
 S DIR("B")="N"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) Q
 I $D(DUOUT) G ACTIVEQ
 S SORT=Y_U_Y(0)
 S NCRIT=NCRIT+1
 S CRITERIA(NCRIT)=DIR("A")_" "_Y(0)
 ;
 ;Make sure the criteria are ok.
 W !!,"A reminder list will be created using the following criteria:"
 F IND=1:1:NCRIT D
 . W !,?2,CRITERIA(IND)
 ;
 K CRITERIA
 K DIR,DIRUT,DTOUT,DUOUT
 S DIR(0)="YAO"
 S DIR("A")="Is this correct? "
 S DIR("B")="Y"
 W !
 D ^DIR
 I $D(DTOUT)!($D(DIROUT)) Q
 I $D(DUOUT) G START
 I 'Y G START
 ;
 ;Build the list of reminders based on the input critera.
 N IEN,NAME,NODE0,SFUN
 ;Setup the screening function to use
 I ALL S SFUN="$$ALLS(NODE0,STATUS)"
 I LOCAL S SFUN="$$LOCALS(NODE0,STATUS)"
 I $L(PREFIX)>0 S SFUN="$$PREFIXS(NODE0,STATUS,PREFIX,LPREFIX)"
 K ^TMP($J,"DEFLIST")
 S IEN=0
 F  S IEN=$O(^PXD(811.9,IEN)) Q:+IEN=0  D
 . S NODE0=^PXD(811.9,IEN,0)
 . I @SFUN S ^TMP($J,"DEFLIST",IEN)=""
 ;Print the list
 N BY,DIC,FLDS,FR,L,PXRMFVPL,PXRMROOT,TO
 D BLDRLIST^PXRMVPTR(811.902,.01,.PXRMFVPL)
 S (DIC,PXRMROOT)="^PXD(811.9,"
 S FLDS="[PXRM DEFINITION LIST]"
 S L=0
 S L(0)=1
 I $P(SORT,U,1)="N" S BY=.01
 I $P(SORT,U,1)="P" S BY=1.2
 S BY(0)="^TMP($J,""DEFLIST"""
 S (FR,TO)=""
 D EN1^DIP
 K ^TMP($J,"DEFLIST")
 Q
 ;
 ;===================================================================== 
ALLS(NODE0,STATUS) ;Screen based on all reminders and status.
 I STATUS="B" Q 1
 N INFLAG
 S INFLAG=$P(NODE0,U,6)
 I (STATUS="A")&('INFLAG) Q 1
 I (STATUS="I")&(INFLAG) Q 1
 Q 0
 ;
 ;===================================================================== 
LOCALS(NODE0,STATUS) ;Screen based on all local reminders and status.
 N NAME
 S NAME=$P(NODE0,U,1)
 I NAME["VA-" Q 0
 I STATUS="B" Q 1
 N INFLAG
 S INFLAG=$P(NODE0,U,6)
 I (STATUS="A")&('INFLAG) Q 1
 I (STATUS="I")&(INFLAG) Q 1
 Q 0
 ;
 ;===================================================================== 
PREFIXS(NODE0,STATUS,PREFIX,LPREFIX) ;Screen based on .01 prefix and status.
 N NAME,PRE
 S NAME=$P(NODE0,U,1)
 S PRE=$E(NAME,1,LPREFIX)
 I PRE'=PREFIX Q 0
 I STATUS="B" Q 1
 N INFLAG
 S INFLAG=$P(NODE0,U,6)
 I (STATUS="A")&('INFLAG) Q 1
 I (STATUS="I")&(INFLAG) Q 1
 Q 0
 ;
