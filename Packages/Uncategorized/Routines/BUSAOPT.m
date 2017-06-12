BUSAOPT ;GDIT/HS/ALA-Security Audit Menu ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
EN ;EP - Entry point
 NEW BUS,CT,TYP,VALUE,DATA,DIR,X,Y,SWIT,COMM,IEN,CURR,PREV,DIRUT,DUOUT,DTOUT
 S BUS(1)="Current Security Audit Settings:",CT=1
 ;
 F TYP="M","B","C","W" D
 . S VALUE=$$STATUS(TYP),DATA(TYP)=VALUE
 . S CT=CT+1,BUS(CT,"F")="!?5",BUS(CT)=$P(VALUE,U,2)
 . S CT=CT+1,BUS(CT,"F")="?20",BUS(CT)="Status:"
 . S CT=CT+1,BUS(CT,"F")="?35",BUS(CT)=$P(VALUE,U,3)
 . S CT=CT+1,BUS(CT,"F")="!?20",BUS(CT)="Date Logged:"
 . S CT=CT+1,BUS(CT,"F")="?35",BUS(CT)=$P(VALUE,U,4)
 . S CT=CT+1,BUS(CT,"F")="!?20",BUS(CT)="User Logged:"
 . S CT=CT+1,BUS(CT,"F")="?35",BUS(CT)=$P(VALUE,U,5)
 . I $P(VALUE,U,6)'="" D
 .. S CT=CT+1,BUS(CT,"F")="!?11",BUS(CT)="Disabled Comment:"
 .. S CT=CT+1,BUS(CT,"F")="?25",BUS(CT)=$P(VALUE,U,6)
 D EN^DDIOL(.BUS)
 K BUS
 ;
 K DIR
 S DIR(0)="S^M:Master;B:BMXNet;C:CIA Broker;W:XWB Broker",DIR("A")="Select Switch"
 D ^DIR I $G(DIRUT)!($G(DUOUT))!($G(DTOUT)) Q
 S SWIT=Y
 ;
 K DIR
 S DIR(0)="S^1:On;0:Disabled",DIR("A")="Change Status"
 S IEN=$P(DATA(SWIT),U,7),DIR("B")=$$GET1^DIQ(9002319.04,IEN_",",.02,"E"),PREV=$$GET1^DIQ(9002319.04,IEN_",",.02,"I")
 D ^DIR I $G(DIRUT)!($G(DUOUT))!($G(DTOUT)) Q
 S CURR=Y
 I CURR'=PREV D
 . I CURR=0 D
 .. K DIR
 .. S DIR(0)="F^3:120",DIR("A")="Disable Comment"
 .. D ^DIR I $G(DIRUT)!($G(DUOUT)) Q
 .. S COMM=Y
 . D NREC(SWIT,CURR,$G(COMM))
 Q
 ;
STATUS(BTYP) ;EP
 NEW DTM,IEN,RESULT
 S DTM=$O(^BUSA(9002319.04,"C",BTYP,""),-1)
 S IEN=""
 I DTM'="" S IEN=$O(^BUSA(9002319.04,"C",BTYP,DTM,""))
 S RESULT=$$GET1^DIQ(9002319.04,IEN_",",.02,"I")_U_$$GET1^DIQ(9002319.04,IEN_",",.01,"E")_U_$$GET1^DIQ(9002319.04,IEN_",",.02,"E")_U_$$GET1^DIQ(9002319.04,IEN_",",.03,"E")_U
 S RESULT=RESULT_$$GET1^DIQ(9002319.04,IEN_",",.04,"E")_U_$$GET1^DIQ(9002319.04,IEN_",",.05,"E")_U_IEN
 Q RESULT
 ;
NREC(SWIT,CURR,COMM) ;EP - New record
 ;
 ;Mark the link as ON/OFF
 NEW DIC,X,DLAYGO,DA,BUSAUP,DESC,STS,ESWIT
 S DIC="^BUSA(9002319.04,",DIC(0)="L",DLAYGO=9002319.04,X=SWIT
 K DO,DD D FILE^DICN
 S DA=+Y
 S BUSAUP(9002319.04,DA_",",.02)=CURR
 S BUSAUP(9002319.04,DA_",",.05)=$G(COMM)
 D FILE^DIE("","BUSAUP","ERROR")
 ;
 ;Now log the event in the audit log
 S ESWIT=$S(SWIT="M":"Master",SWIT="B":"BMXNet",SWIT="C":"CIA Broker",SWIT="W":"XWB Broker",1:"")
 S DESC=ESWIT_" Switch "_$S(CURR=1:"turned on",1:"disabled")
 S STS=$$BYPSLOG^BUSAAPI("A","S","","BUSA SECURITY EDIT Option",DESC,"")
 Q
 ;
USER ;EP - Set up users for BUSA Reporting Tool access
 ;
 I $G(DUZ)="" W !,"DUZ MUST BE DEFINED BEFORE CALLING THIS OPTION" Q
 ;
 NEW DIR,DIROUT,DTOUT,DUOUT,DZ,GL,I,IDZ,UGL,UID,USERCL,STATUS,%,EXEC
 ;
PROMPT ;Display current users
 S EXEC="S GL=$NA(^BUSA.UsersI(""StatusUserIdx"",""A""))" X EXEC
 S EXEC="S UGL=$NA(^BUSA.UsersI(""UserIdx""))" X EXEC
 S DZ="" F I=1:1 S DZ=$O(@GL@(DZ)) Q:DZ=""  D
 . I I=1 W !!,"Current approved BUSA Reporting Users",!
 . W !,$$GET1^DIQ(200,$TR(DZ," ")_",",.01,"E")
 ;
 W !!,"Enter the user to add/delete BUSA Reporting Access for",!
 ;
 S DIR(0)="POr^200:EM"
 S DIR("A")="User"
 D ^DIR
 I $D(DIROUT)!($D(DTOUT))!($D(DUOUT))!(Y=-1) Q
 ;
 S IDZ=" "_+Y
 ;
 ;Add user
 I '$D(@UGL@(IDZ)) D  G PROMPT
 . NEW USERCL,%,STS
 . S EXEC="S USERCL=##CLASS(BUSA.Users).%New()" X EXEC
 . S EXEC="S USERCL.User=+Y" X EXEC
 . S EXEC="S USERCL.LastModifiedBy=DUZ" X EXEC
 . D NOW^%DTC
 . S EXEC="S USERCL.LastModifiedDt=%" X EXEC
 . S EXEC="S USERCL.Status=""A""" X EXEC
 . S EXEC="S STS=USERCL.%Save()" X EXEC
 . I STS=1 W !!,"User set up for BUSA Reporting Access",! H 2
 ;
 ;Process existing user
 ;
 S UID=$O(@UGL@(IDZ,"")) Q:UID=""
 ;
 ;Get user's status
 S EXEC="S USERCL=##class(BUSA.Users).%OpenId(UID,1)" X EXEC
 S EXEC="S STATUS=USERCL.Status" X EXEC
 ;
 ;If Active, make Inactive
 I STATUS="A" D  G PROMPT
 . NEW DIR,DIROUT,DTOUT,DUOUT,Y,X,STS,%
 . S DIR(0)="Y"
 . S DIR("A")="User is currently an Active BUSA Auditing User. Make them Inactive"
 . D ^DIR
 . I $D(DIROUT)!($D(DTOUT))!($D(DUOUT))!(Y=-1) Q
 . I +Y<1 Q
 . S EXEC="S USERCL.LastModifiedBy=DUZ" X EXEC
 . D NOW^%DTC
 . S EXEC="S USERCL.LastModifiedDt=%" X EXEC
 . S EXEC="S USERCL.Status=""I""" X EXEC
 . S EXEC="S STS=USERCL.%Save()" X EXEC
 . W !!,"User's BUSA Auditing status has been set to Inactive" H 2
 ;
 I STATUS="I" D  G PROMPT
 . NEW DIR,DIROUT,DTOUT,DUOUT,Y,X,STS,%
 . S DIR(0)="Y"
 . S DIR("A")="User is currently an Inactive BUSA Auditing User. Make them Active again"
 . D ^DIR
 . I $D(DIROUT)!($D(DTOUT))!($D(DUOUT))!(Y=-1) Q
 . I +Y<1 Q
 . S EXEC="S USERCL.LastModifiedBy=DUZ" X EXEC
 . D NOW^%DTC
 . S EXEC="S USERCL.LastModifiedDt=%" X EXEC
 . S EXEC="S USERCL.Status=""A""" X EXEC
 . S EXEC="S STS=USERCL.%Save()" X EXEC
 . W !!,"User's BUSA Auditing status has been set to Active" H 2
 Q
