GMRCSRVS ;SLC/DCM,JFR - Add/Edit services in File 123.5. ;6/14/00 12:00
 ;;3.0;CONSULT/REQUEST TRACKING;**1,16**;DEC 27, 1997
 ;
EN ;set up services entry point
 ;GMRCOLDU=Service Usage field. If changed, GMRCOLDU shows the change (See ^DD(123.5,2,0) for field description).
 N GMRCSAFE,GMRCOLDU,GMRCOLDS,GMRCOSNM,GMRCSRVC,GMRCACT,GMRCSSNM
 N DIC,DLAYGO,DUOUT,DTOUT
 S DIC="^GMR(123.5,",DLAYGO=123.5,DIC(0)="AELMQZ",DIC("A")="Select Service/Specialty:"
 D ^DIC I $S(Y<0:1,$D(DTOUT):1,$D(DUOUT):1,1:0) D END K GMRCMSG,DTOUT,DUOUT Q
 D
 .S GMRCSAFE=+$G(^GMR(123.5,+Y,"INT"))
 .S (DA,GMRCSRVC)=+Y,GMRCOSNM=$P(Y,"^",2),(GMRCOLDU,GMRCOLDS)=""
 .S GMRCACT=$S('$O(^GMR(123.5,+Y,0)):"MAD",1:"MUP"),GMRCOLDU=$P(^(0),"^",2),GMRCOLDN=$P(^(0),"^",1) S ND=0,GMRCOLDS="" F  S ND=$O(^GMR(123.5,+Y,2,ND)) Q:ND?1A.E!(ND="")  S GMRCOLDS=GMRCOLDS_^GMR(123.5,+Y,2,ND,0)_"^"
 .S DIE=DIC,DR="[GMRC SETUP REQUEST SERVICE]",DIE("NO^")="OUTOK"
 .D ^DIE
 .Q
 S GMRCACT=$S($P(^GMR(123.5,GMRCSRVC,0),"^",2)=9:"MDC",$P(^(0),"^",2)=1:"MDC",1:GMRCACT) D
 .S GMRCSSNM=$P(^GMR(123.5,GMRCSRVC,0),"^",1)
 .I GMRCACT'="MAD",GMRCSSNM'=GMRCOSNM S GMRCACT="MUP"
 .I $S(GMRCACT'="MAD":1,GMRCACT'="MUP":1,1:0),$L(GMRCOLDU),GMRCOLDU=$P(^GMR(123.5,GMRCSRVC,0),"^",2) S GMRCACT="NOACT"
 .I $S(GMRCACT="MUP":1,GMRCACT="NOACT":1,1:0),GMRCOLDN'=$P(^GMR(123.5,GMRCSRVC,0),"^",1) S GMRCACT="MUP"
 .S ND=0 F  S ND=$O(^GMR(123.5,GMRCSRVC,2,ND)) Q:ND?1A.E!(ND="")  I GMRCOLDS'=""&(^GMR(123.5,GMRCSRVC,2,ND,0)'=""),GMRCOLDS'[^GMR(123.5,GMRCSRVC,2,ND,0) S GMRCACT="MUP" Q
 .I $S(GMRCACT="MAD":1,GMRCACT="MUP":1,GMRCACT="MDC":1,1:0) D SVC^GMRC101H(GMRCSRVC,GMRCSSNM,GMRCACT),MSG^XQOR("GMRC ORDERABLE ITEM UPDATE",.GMRCMSG)
 .D PTRCLN^GMRCU
 .Q
 K GMRCMSG,GMRCSSNM,GMRCSRVS,GMRCOLDN,GMRCOLDS,GMRCOLDU,ND
 ;Ask to continue...
 ;
 N GMRC0,GMRCA,GMRCB,GMRCH,GMRCL
 S GMRC0="YA",GMRCA="Add/Edit Another Service? ",GMRCB="NO"
 S GMRCH="Enter 'YES' to add/edit another service, or 'NO' to exit."
 S GMRCL=2
 I '+$$READ(GMRC0,GMRCA,GMRCB,GMRCH,GMRCL) D END Q
 G EN
 ;
END K DIC,DIE,DTOUT,DUOUT,DA,DR,FL,GMRCACT,GMRCANS,GMRCMSG,GMRCREA,GMRCSRVC,GMRCSSNM,REVCODE,RLEVCODE,Y
 Q
 ;
READ(GMRC0,GMRCA,GMRCB,GMRCH,GMRCL,GMRCS) ;
 ;
 ;  GMRC0 -> DIR(0) --- Type of read
 ;  GMRCA -> DIR("A") - Prompt
 ;  GMRCB -> DIR("B") - Default Answer
 ;  GMRCH -> DIR("?") - Help text or ^Execute code
 ;  GMRCS -> DIR("S") - Screen
 ;  GMRCL -> Number of blank lines to put before Prompt
 ;
 ;  Returns "^" or answer
 ;
 N GMRCLINE,DIR,DTOUT,DUOUT,DIRUT,DIROUT,X,Y
 Q:'$L($G(GMRC0)) U
 S DIR(0)=GMRC0
 S:$L($G(GMRCA)) DIR("A")=GMRCA
 I $D(GMRCA("A")) M DIR("A")=GMRCA("A")
 S:$L($G(GMRCB)) DIR("B")=GMRCB
 I $D(GMRCH("?")) M DIR("?")=GMRCH("?")
 S:$L($G(GMRCH)) DIR("?")=GMRCH
 S:$L($G(GMRCS)) DIR("S")=GMRCS
 F GMRCLINE=1:1:($G(GMRCL)-1) W !
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) Q U
 Q Y
 ;
NOED(SERV) ;
 I '$D(^GMR(123.5,+SERV,0)) Q 0
 N NAME
 S NAME=$P(^GMR(123.5,+SERV,0),U)
 I NAME="PROSTHETICS REQUEST" Q 1
 I NAME="EYEGLASS REQUEST" Q 1
 I NAME="CONTACT LENS REQUEST" Q 1
 I NAME="HOME OXYGEN REQUEST" Q 1
 Q 0
 ;
CLONPSAS ; clone a PROSTHETICS service
 ; choose service and text to append
 N GMRCSIEN,GMRCROOT,GMRCNWNM
 N GMRCCPY,GMRCNEW,FDA,GMRCERR,GMRC
 S GMRC(0)="PAO^GMR(123.5,:AEMQ"
 S GMRC("A")="Select the Prosthetics Service to clone: "
 S GMRC("S")="I $$NOED^GMRCSRVS(+Y)"
 S GMRCCPY=+$$READ(GMRC(0),GMRC("A"),,,2,GMRC("S"))
 I 'GMRCCPY Q
 K GMRC
 S GMRCNWNM=$$GETAPP(GMRCCPY)
 I '$L(GMRCNWNM) Q
 S FDA(1,123.5,"+1,",.01)=GMRCNWNM
 S FDA(1,123.5,"+1,",2)="DISABLED"
 S FDA(1,123.5,"+1,",1.01)="REQUIRE"
 S FDA(1,123.5,"+1,",1.02)="LEXICON"
 S FDA(1,123.5,"+1,",123.01)="CONSULTS"
 S FDA(1,123.5,"+1,",123.03)="GMRCACTM SERVICE ACTION MENU"
 S FDA(1,123.5,"+1,",131)="YES"
 D UPDATE^DIE("E","FDA(1)","GMRCNEW","GMRCERR")
 I '$D(GMRCNEW) W !,"Failed to create new entry. Please try again" Q
 W !!,GMRCNWNM," created",!
 S GMRCSIEN=GMRCNEW(1)_","
 S GMRCROOT="^GMR(123.5,"_GMRCCPY_",124)"
 D WP^DIE(123.5,GMRCSIEN,124,,GMRCROOT,"GMRCERR")
 W !!,"The new Service is currently DISABLED. To activate this service for use in"
 W !,"the Prosthetics interface, you MUST use the Setup Consult Services option"
 W !,"and delete the DISABLED flag from the SERVICE USAGE field.",!
 Q
GETAPP(GMRIEN) ;get text to append
 N GMRCNWNM,QTFLG,I,GMRC,GMRCHL,OK
 S GMRCNWNM=""
 F I=0:0 D  Q:$G(QTFLG)
 . W !!
 . S GMRC(0)="FA^3:40"
 . S GMRC("A")="Enter text to append to national service name: "
 . S GMRCHL("?",1)="The text entered will be appended to the name of the exported service"
 . S GMRCHL("?")="(e.g. If HINES was entered it may appear as PROSTHETICS REQUEST - HINES"
 . S GMRCNWNM=$$READ(GMRC(0),GMRC("A"),,.GMRCHL,2)
 . I '$L(GMRCNWNM)!(GMRCNWNM["^") S GMRCNWNM="",QTFLG=1 Q
 . K GMRC,GMRCHL
 . S GMRCNWNM=$P(^GMR(123.5,GMRIEN,0),U)_" - "_GMRCNWNM
 . I $$FIND1^DIC(123.5,,"X",GMRCNWNM) D  Q
 .. W !!,$C(7),"This service already exists, you'll have to try again!",!
 .. S GMRCNWNM=""
 . W !,"The new service name will be:"
 . W !,?5,GMRCNWNM,!
 . S OK=+$$READ("Y","Is this OK",,,1)
 . I OK=U S QTFLG=1 Q
 . I 'OK S GMRCNWNM="" Q
 . S QTFLG=1
 Q GMRCNWNM
