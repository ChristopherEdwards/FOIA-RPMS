INHSGZ ; cmi/flag/maw - JSH 15 Oct 1999 14:52 Interface - Generate a script ; [ 05/22/2002  2:53 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1991, 1992 SAIC
 ;
 K DIC S DIC="^INTHL7M(",DIC(0)="QAEM" D ^DIC
 K INGALL
 ;
EN ;Enter here with Y= internal entry # of message
 Q:Y<0
 N INDUZ M INDUZ=DUZ N DUZ S DUZ=.5,DUZ(0)="@",DUZ("AG")=$G(INDUZ("AG"))
 L +^INTHL7M(+Y):0 E  W !,*7,"Another user is working with this entry." Q
 N DMAX,MESS,TRT,MODE,INSS,ERR,INHSZ,INSTD S INHSZ=1
 S MESS=+Y Q:'$D(^INTHL7M(MESS,0))  S MESS(0)=^INTHL7M(MESS,0)
 W !!,"Generation for message: "_$P(MESS(0),U)
 I $P(MESS(0),U,8) W ".. Inactive (aborting)" Q
 ;Set flag for interface standard (stored in field .12)
 S INSTD=$P(MESS(0),U,12),INSTD=$S(INSTD="NCPDP":"NC",INSTD="HL7":"HL",INSTD="X12":"X12",1:"HL")
 D SETDT^UTDT S TRT=0,INSS=$G(^INTHL7M(MESS,"S")) K ^("S")
 F  S TRT=$O(^INTHL7M(MESS,2,TRT)) Q:'TRT  D ONE(+^(TRT,0))
 L -^INTHL7M(MESS)
 S INSS=$G(^INTHL7M(MESS,"S")) I INSS=""!(INSS="^") W !,*7,"No scripts were generated!" G QT
 W !!,"The following scripts were generated:"
 F I=1,2 I $P(INSS,U,I) W !?5,$P(^INRHS($P(INSS,U,I),0),U)
 W !
 I '$G(INGALL) S X=$$YN^UTSRD("Do you wish to compile the script(s) now? ;1","") G:'X QT
 F INI=1,2 I $P(INSS,U,INI) S SCR=$P(INSS,U,INI) D EN^INHSZ
QT K ^UTILITY("INS",$J),^UTILITY("INDIA",$J),SNAME Q
 ;
ONE(%T) ;Compile one transaction type
 ;%T = entry number of the transaction type
 W "."
 Q:'$G(%T)  Q:'$D(^INRHT(%T))!'$D(^INTHL7M(+MESS,0))
 S MODE=$P(^INRHT(%T,0),U,8) Q:MODE=""!("IO"'[MODE)
 Q:$D(ERR(MODE))
 S X=$P($G(^INTHL7M(MESS,"S")),U,MODE="O"+1) I X S $P(^INRHT(%T,0),U,3)=X Q
 S SNAME="Generated: "_$E($P(MESS(0),U),1,40)_"-"_MODE
 S X=$P(INSS,U,MODE="O"+1) I X S SCR=X G:$P($G(^INRHS(SCR,0)),U)=SNAME COMP S $P(INSS,U,MODE="O"+1)=""
 S SCR=$$MAKENEW^INHSC Q:'SCR
COMP ;At this point, the entry # of the script is known in SCR
 N DA,DIK,I,%,FILE,INISTD K ^UTILITY("INS",$J)
 K ^INRHS(SCR,1)
 K DIC,Y S DIC="^INRHS(",DIC(0)="Y",X=SNAME D ^DIC D:Y'<0
 . S:Y Y(+Y)="" K Y(+SCR)
 . S DA=0,DIK="^INRHS(" F  S DA=$O(Y(DA)) Q:'DA  X "N Y D ^DIK"
 S FILE=$P(MESS(0),U,5),INISTD=$P(MESS(0),U,12)
 I '$D(^DIC(FILE,0)) W *7,!,"WARNING.  There is no file ",FILE," in the system.  Aborting script compilation",! S ERR=1 Q
 S ERR=0 D OUT^INHSGZ1:MODE="O",IN^INHSGZ2:MODE="I"
 I ERR S ERR(MODE)="" W !?5,"... generation of all ",$P("IN^OUT",U,MODE="O"+1),"PUT scripts is aborted." K:^INRHS(SCR,0)="" ^INRHS(SCR) Q
 ;Adding interface standard 6/8 dgh
 I $G(^INRHS(SCR,0))]"" S DIE="^INRHS(",DA=SCR,DR=".03////"_FILE_";.07///"_INISTD D ^DIE
 I $G(^INRHS(SCR,0))="" S ^INRHS(SCR,0)=SNAME_U_MODE_U_FILE_U_U_1_U_U_INISTD,DA=SCR,DIK="^INRHS(" D IX1^DIK
 S (%,I)=0 F  S I=$O(^UTILITY("INS",$J,I)) Q:'I  S %=%+1,^INRHS(SCR,1,%,0)=^UTILITY("INS",$J,I)
 S ^INRHS(SCR,1,0)=U_U_%_U_%
 S $P(^INRHT(%T,0),U,3)=SCR
 S $P(^INTHL7M(MESS,"S"),U,MODE="O"+1)=SCR
 Q
 ;
ALL ;Regerate all
 W !!,*7,"WARNING:  This option will regenerate all active messages." S X=$$YN^UTSRD("Proceed? ;0","") Q:'X
ALLAUTO ;Automatically regenerate
 N INGALL,INHSGZ
 S INGALL=1,INHSGZ=0 F  S INHSGZ=$O(^INTHL7M(INHSGZ)) Q:'INHSGZ  S Y=INHSGZ D EN
 Q
