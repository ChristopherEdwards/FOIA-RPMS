AKMOSKEY ;OHPD-TUCSON/BRJ ASSIGN NAMESPACE SECURITY KEYS TO USERS [ 04/22/93  10:41 AM ]
 ;;2.0;IHS KERNEL UTILITIES;;JUN 28, 1993
EN ; ENTRY TO PROGRAM
 X "ZL @""XUS"" S AKMO(""KERNEL VERSION"")=$P($T(+2),"";"",3)"
 I AKMO("KERNEL VERSION")<7 W !!,*7,"You are running Kernel ",AKMO("KERNEL VERSION"),".  This program requires Kernel 7.0 or later version!",!!,"No action taken!!",! K AKMO Q
 D ^XBKSET
 W !,"I'm ready to assign security keys but. . .",!,"Please note - the POSTMASTER will be the assignee.",!
 S DUZ(0)="@"
 S X="T",%DT="" D ^%DT S AKMO("DATE")=Y
GETNSP ; Get security key namespaces
 F  D  Q:AKMO("NO MORE KEYS")
 . S AKMO("NO MORE KEYS")=1
 . F  R !,?10,"Enter Security Key namespace : // ",AKMO("KEYNSP") Q:"^"[AKMO("KEYNSP")  D  Q:$D(AKMO("KEY TBL","*"))
 .. I AKMO("KEYNSP")?1"?".E W !!,?5,"Enter the leading characters of the package namespace.",!,?15,"Ex: APCD for PCC Data Entry ",!,?5,"OR - to select all keys, enter an asterisk (*).",! Q
 .. I AKMO("KEYNSP")?1"*".E D  Q
 ... W !!,"Selecting ALL security keys supercedes previously selected namespace, if any, for this iteration."
 ... W !!,*7,"Do you really want to assign all security keys at this time"
 ... S %=1 D YN^DICN
 ... Q:%'=1
 ... W !!,"O.K.",!
 ... K AKMO("KEY TBL")
 ... S AKMO("KEY TBL","*")=""
 ... S AKMO("NO MORE KEYS")=0
 .. S AKMO("KEY")=$O(^DIC(19.1,"B",AKMO("KEYNSP")))
 .. I AKMO("KEYNSP")'=$E(AKMO("KEY"),1,$L(AKMO("KEYNSP"))) W !,*7,?10,"The ",AKMO("KEYNSP")," namespace does not have any security keys!",! Q
 .. S AKMO("KEY TBL",AKMO("KEYNSP"))=""
 .. S AKMO("NO MORE KEYS")=0
GETUSER . ;
 . Q:AKMO("NO MORE KEYS")
 . S DIC="^VA(200,"
 . S DIC("A")="Enter User Name to be assigned keys: // "
 . S DIC(0)="AEMQ"
 . F  W ! D ^DIC Q:"^"[X  D
 .. S AKMO("KEYNSP")=""
 .. F  S AKMO("KEYNSP")=$O(AKMO("KEY TBL",AKMO("KEYNSP"))) Q:AKMO("KEYNSP")=""  S AKMO("KEY TBL",AKMO("KEYNSP"),X,$P(Y,U))=""
 . S AKMO("NO MORE KEYS")=1
ASSGNLP ; LOOP DOWN AKMO("KEY TBL","KEYNSP",holder) and assign the security keys
 ;Q
 W !!,"Assigning security keys. . . ",!
 S AKMO("KEYNSP")=""
 F  S AKMO("KEYNSP")=$O(AKMO("KEY TBL",AKMO("KEYNSP"))) Q:AKMO("KEYNSP")=""  D
 . S AKMO("HOLDER")=""
 . F  S AKMO("HOLDER")=$O(AKMO("KEY TBL",AKMO("KEYNSP"),AKMO("HOLDER"))) Q:AKMO("HOLDER")=""  D
 .. S AKMO("HOLDER DFN")=$O(AKMO("KEY TBL",AKMO("KEYNSP"),AKMO("HOLDER"),""))
 .. S AKMO("KEY")=AKMO("KEYNSP")
 .. F  S AKMO("KEY")=$O(^DIC(19.1,"B",AKMO("KEY"))) D  Q:AKMO("KEY")=""
 ... Q:AKMO("KEY")=""
 ... I AKMO("KEYNSP")'="*",$E(AKMO("KEY"),1,$L(AKMO("KEYNSP")))'=AKMO("KEYNSP") S AKMO("KEY")="" Q
 ... S AKMO("KEY DFN")=$O(^DIC(19.1,"B",AKMO("KEY"),""))
 ... I $D(^VA(200,AKMO("HOLDER DFN"),51,AKMO("KEY DFN"))) W !,AKMO("KEY"),?34,"already assigned to <",AKMO("HOLDER"),">." Q
 ... ; I '$D(^DIC(19.1,"D",DUZ,AKMO("KEY DFN"))) W !,AKMO("KEY"),?30,"Denied!  You are not allowed to assign this key." Q
ASSGNKEY ... ; ASSIGN KEY USING DIC AND DIE CALLS
 ... S DIE="^VA(200,",DA=AKMO("HOLDER DFN"),DR="51///`"_AKMO("KEY DFN")
 ... S DR(2,200.051)="1////.5;2////"_AKMO("DATE")_";3////"_AKMO("DATE")
 ... D ^DIE
 ... K DIE,DR,DA
 ... I $D(Y) W !!,*7,"FileManager error condition returned from ^DIE call while updating",!,?3,AKMO("KEY")," security key for ",AKMO("HOLDER"),!,?3,"Security key was not assigned." Q
 ... W !,AKMO("KEY"),?42,"assigned to <",AKMO("HOLDER"),">."
XIT ;
 I '$D(AKMO("KEY TBL")) W !!,*7,"No selection of security keys made.  B y e . . . .",!
 W !!,*7,?12,"<DONE>"
KILL ; KILL VARIABLES
 K AKMO,Y,%DT,DIC,DIE,DUZ,DA,DR,DT,X
 Q
