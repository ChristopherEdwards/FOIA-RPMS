AUTTVLK ; IHS/DIRM/JDM/DFM - VENDOR FILE INTERFACE ; [ 11/25/97  12:34 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);;NOV 25, 1997
 ;
 ; Screen for association between the Vendor and the PACKAGE when a
 ; non-LAYGOed Vendor lookup being performed and trigger to create
 ; Vendor/PACKAGE association when new Vendor added by package.
 ;
 ;
EN ;EP - Check relation between Vendor and Package.
 I $D(DIC(0)),DIC(0)'["L" D EN1
EXIT ;
 D KILL
 I $D(DICR(1,1)),DICR(1,1)'=DIC Q
 G IX^DIC
QUIT ;
 Q
 ;
KILL ;
 KILL AUT,AUTQUIT,AUTX,AUTY,AUTZ,AUTDIC
 Q
 ;
EN1 ;EP - Set DIC("S") to check relation between Vendor and Package.
 Q
 Q:'$D(XQY0)
 I $D(DIC(0)),DIC(0)["L" Q
 D PACKAGE
 I $D(AUTZ),AUTZ,$D(^DIC(9.4,AUTZ,0)) S AUTDIC("S")=" I $D(^AUTTVNDR(+Y,20,""B"","_AUTZ_"))" S:'$D(DIC("S")) DIC("S")=AUTDIC("S") S:DIC("S")'["AUTTVNDR(+Y,20" DIC("S")=DIC("S")_AUTDIC("S")
 D KILL
 Q
 ;
PACKAGE ;  -Determine Package.
 Q:'$D(XQY0)
 S AUTX=$P(XQY0,U)
 F AUT=4,3,2 S AUTY=$E(AUTX,1,AUT),AUTZ=$O(^DIC(9.4,"C",AUTY,0)) D:AUTZ  Q:'$D(X)!$D(AUTQUIT)
 .I $O(^DIC(9.4,"C",AUTY,AUTZ)) W !!,*7,*7,"There appears to be an error in the PACKAGE file.",!,"Please report this to your site manager." H 3 K X Q
 .I $D(^DIC(9.4,AUTZ,0)),$P(^(0),U,2)=AUTY S AUTQUIT=""
 KILL AUTQUIT
 Q
 ;
TRIGGER ;EP - Set relation between Vendor and Contractor.
 Q
 D PACKAGE
T ;
 I $D(AUTZ),AUTZ,'$D(^AUTTVNDR(DA,20,"B",AUTZ)) D T1
 D KILL
 Q
 ;
T1 ;
 Q:$D(^AUTTVNDR(DA,20,"B",AUTZ))
 S:'$D(^AUTTVNDR(DA,20,0)) ^AUTTVNDR(DA,20,0)="^9999999.112001P"
 ;EXCLUSIVE NEW BELOW REQUIRED FOR RECURSIVE FILEMAN CALL
 NEW (U,DA,DUZ,DT,IO,DTIME,AUTZ)
 S X=AUTZ,(AUTTDA,DA(1))=DA,DIC="^AUTTVNDR("_DA_",20,",DIC(0)="L",DIC("DR")=".02////"_DT_";.03////A"
 D FILE
 S DA=AUTTDA
 Q
 ;
UP ;EP - TEMP UTILITY TO UPDATE ALL VENDORS AS CHS VENDORS AND SELECTED
 ;VENDORS AS CIS VENDORS
 S AUTZ=$O(^DIC(9.4,"C","ACHS",0))
 I AUTZ,$D(^DIC(9.4,AUTZ,0)),'$O(^DIC(9.4,"C","ACHS",AUTZ)) S Y=0 F  S Y=$O(^AUTTVNDR(Y)) Q:'Y  S DA=Y D T
 S AUTZ=$O(^DIC(9.4,"C","ACG",0))
 I AUTZ,$D(^DIC(9.4,AUTZ,0)),'$O(^DIC(9.4,"C","ACG",AUTZ)) S Y=0 F  S Y=$O(^ACGS("H",Y)) Q:'Y  S DA=Y D T
 Q
 ;
ADD ;EP - Add or Edit Vendor data.
 D ^XBKVAR
 F  D ADD1 Q:$D(AUTQUIT)
ADDEXIT ;
 KILL AUTQUIT,AUTI,AUTVENAM,AUTDA
 Q
 ;
ADD1 ;
 W:$D(IOF) @IOF
 W !!?22,"ADD OR EDIT VENDOR DATA",!?21,"|==============================|"
 S (DIC,DIE)="^AUTTVNDR(",DIC(0)="AELMQZ",DIC("A")="VENDOR..............: "
 D DIC
 I U[$E(X)!(+Y<1) S AUTQUIT="" Q
 S AUTDA=+Y,AUTY=$P(Y,U,3),AUTVENAM=$P(^AUTTVNDR(+Y,0),U),AUTVEEIN=$P($G(^(11)),U,13)
 F  D EN2 Q:$D(AUTQUIT)
 KILL AUTQUIT
 Q
 ;
EN2 ;
 D:AUTY=1 EN3
 D VND
 S DIR(0)="YO",DIR("A")="Edit VENDOR DATA",DIR("B")="NO"
 W !
 D DIR
 I $G(Y)'=1 S AUTQUIT="" Q
 D EN3
 Q
 ;
ENX ;EP - TO UPDATE THE PACKAGE MULTIPLE FROM AN EXTERNAL PACKAGE
 ;MUST BE CALLED WITH THE VARIABLE 'AUTDA' SET TO THE INTERNAL ENTRY
 ;NUMBER OF THE VENDOR
MAKE ;
 Q:'$G(AUTDA)
 D PACKAGE
 I $G(AUTZ),'$D(^AUTTVNDR(AUTDA,20,"B",AUTZ)),$D(^DIC(9.4,AUTZ,0)) S AUTZ=$P(^(0),U),DIR(0)="YO",DIR("A")="Make this an "_AUTZ_" vendor",DIR("B")="YES" D DIR I Y=1 S DA=AUTDA D TRIGGER
 S AUTQUIT=""
 Q
 ;
EN3 ;
 S DIR(0)="SO^1:ALL Vendor Data;2:Mailing Address;3:Billing Address;4:Remit To Address;5:1099 Payment Data;6:ARMS/CIS;7:SMALL PURCHASE INFORMATION Data",DIR("A")="Edit which data"
 S DIR("?")="Enter the code from the list to indicate the type of data you want to edit."
 W !
 D DIR
 Q:'$G(Y)
 S AUTY="",DIE="^AUTTVNDR(",DA=AUTDA,DR="[AUT VENDOR EDIT"_$S(Y=1:"",Y=2:"-MAIL]",Y=3:"-BILL",Y=4:"-REMIT",Y=5:"-PAY",Y=6:"-CIS",Y=7:"-SPIS")_"]"
 W !!
 D DIE
 KILL AUTDDIE,AUTMESS
 Q
 ;
VND ;
 W:$D(IOF) @IOF
 W ?9,"VENDOR DATA FOR: ",AUTVENAM,!
 KILL DXS,DIP
 NEW D0
 S D0=AUTDA
 D ^AUTPVND
 KILL DXS,DIP
 Q
 ;
DIC ;EP
 D ^DIC
 KILL DIC,DA,DD,DR,DINUM,D
 Q
 ;
DIE ;EP
 KILL AUTQUIT
 LOCK +@(DIE_DA_")"):4
 E  S AUTQUIT="" I $D(IOST),$E(IOST,1,2)="C-" W !!,"Entry being edited by another user.  Please try Later." H 3
 Q:$D(AUTQUIT)
 S AUTDIEDA=DA
 D ^DIE
 LOCK -@(DIE_AUTDIEDA_")")
 I $D(DTOUT)!$D(DUOUT) S AUTQUIT=""
 KILL DIE,DA,DR,AUTDIEDA
 Q
 ;
FILE ;EP
 KILL DD,DO
 D FILE^DICN
 KILL DIC,DA,DD,DR,DINUM
 Q
 ;
DIR ;EP;
 KILL AUTOUT,AUTQUIT
 D ^DIR
 S AUTY=Y
 S:$D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT) AUTQUIT=""
 KILL DIR,DIRUT,DIROUT,DUOUT,DTOUT
 Q
 ;
1820 ;EP;TO TRANSFER DATA FROM THE 18 TO 20 NODES DUE TO CHANGE IN DB
 D ^XBKVAR
 S DA=0
 F  S DA=$O(^AUTTVNDR(DA)) Q:'DA  I $D(^AUTTVNDR(DA,18)) S %X="^AUTTVNDR("_DA_",18,",%Y="^AUTTVNDR("_DA_",20," D %XY^%RCR S $P(^AUTTVNDR(DA,20,0),U,2)="9999999.112001P" ;K ^AUTTVNDR(DA,18)
 Q
 ;
