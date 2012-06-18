BHLIQUI ; cmi/sitka/maw - BHL HL7 Immunization Query User Interface ;
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;
 ;this routine will generate a standard query message based upon
 ;the selected criteria.  The message type being generated will depend
 ;upon the type of query.  We will try to use defined query messages
 ;for each query. (ie. VXQ/V01, etc)
 ;
MAIN ;-- this is the main routine driver
 K INA
 D REG
 D PT Q:$D(DUOUT)!($D(DTOUT))  Q:Y<0
 D DTR Q:$D(DIRUT)
 D REC Q:$D(DIRUT)
 K DIC,DIR,Y
 S X=$S(BHLREG:"BHL SEND IMMUNIZATION QUERY REGISTRY",1:"BHL SEND IMMUNIZATION QUERY"),DIC=101 D EN^XQOR
 D EOJ
 Q
 ;
REG ;-- ask if this is going to a registry or not
 S DIR(0)="Y"
 S DIR("A")="Query a State Registry: "
 D ^DIR
 Q:Y<1
 S BHLREG=1
 Q
 ;
 ;
PT ;-- get the patient      
 S DIC=9000001,DIC(0)="AEMQZ",DIC("A")="Select Patient for Query: "
 D ^DIC
 Q:$D(DUOUT)!($D(DTOUT))
 Q:Y<0
 S INA("QNM",+Y)=$$VAL^XBDIQ1(2,+Y,.01)
 S BHLQDA=+Y
 K DIC
 Q
 ;support for multiples maybe later
 W !
 S DIR(0)="Y"
 S DIR("A")="Would you like to select an additional patient: "
 D ^DIR
 Q:Y<1
 S BHLQMPT=1
 G PT
 Q
 ;
DTR ;-- get the date ranges
 W !
 S DIR(0)="Y",DIR("A")="Would like to specify a date range "
 D ^DIR
 Q:$D(DIRUT)
 Q:Y<1
 K DIR,Y
 W !
 S %DT="AE",%DT("A")="Select beginning date: "
 D ^%DT
 Q:Y<0
 S INA("QBDT")=+Y
 W !
 K %DT,Y
 S %DT="AE",%DT("A")="Select ending date: "
 D ^%DT
 Q:Y<0
 S INA("QEDT")=+Y
 K %DT,Y
 Q
 ;
REC ;-- limit the query to number of records
 K DIR,Y
 W !
 S DIR(0)="N",DIR("A")="Please enter the number of responses "
 D ^DIR
 Q:$D(DIRUT)
 Q:Y<1
 S INA("QTY")=+Y
 K DIR,Y
 Q
 ;
EOJ ;-- kill variables
 K BHLREG,BHLQDT,BHLQDA
 Q
 ;
