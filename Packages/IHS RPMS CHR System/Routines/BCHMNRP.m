BCHMNRP ; IHS/CMI/LAB - MERGE NON-REGISTERED PATIENTS ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
 ;
 W !!,"This option is used to merge two Non-Registered Patients who are"
 W !,"in the file as duplicates.  You will be asked to select the two"
 W !,"patients who are duplicates.  If one patient has a data value"
 W !,"such as Tribe and the other doesn't the system will use the Tribe"
 W !,"value from the patient with Tribe recorded.  If both patients"
 W !,"have a data value and they are different you will be asked to"
 W !,"choose which value to use.  Values looked at are:  DOB, Sex,"
 W !,"SSN, Name, Tribe, Community of Residence.",!!
GETPAT1 ;
 K DIC
 S (BCHPAT1,BCHPAT2)=""
 W !!,"Please select the first patient of the set of duplicates.",!
 S DIC="^BCHRPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !,"BYE" D XIT Q
 S BCHPAT1=+Y
 ;
GETPAT2 ;
 K DIC
 W !!,"Please select the second patient of the set of duplicates.",!
 S DIC="^BCHRPAT(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !,"BYE" D XIT Q
 I +Y=BCHPAT1 W !!,"YOU CAN'T SELECT THE SAME PATIENT AS THE FIRST PATIENT!" G GETPAT2
 S BCHPAT2=+Y
 W !!,"You have selected the following 2 patients to merge together:"
 W ! S DIC="^BCHRPAT(",DA=BCHPAT1 D EN^DIQ
 W ! S DIC="^BCHRPAT(",DA=BCHPAT2 D EN^DIQ
CMM ;
 K BCHDATA,BCHMAST
 S BCHQUIT=0
 F BCHF=".01",".02",".03",".04",".05",".06" Q:BCHQUIT  D CHK
 I BCHQUIT D XIT Q
 W !!,"I am going to merge the following two patients together using the"
 W !,"following values for the demographic data:"
 W !!?5,"Patient 1: ",$$VAL^XBDIQ1(90002.11,BCHPAT1,.01)
 W !?5,"Patient 2: ",$$VAL^XBDIQ1(90002.11,BCHPAT2,.01)
 W !
 S BCHX="" F  S BCHX=$O(BCHMAST(BCHX)) Q:BCHX=""  W !?8,$P(^DD(90002.11,BCHX,0),U,1),":  ",BCHMAST(BCHX)
 W !
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 D MERGE
 Q
XIT ;
 D EN^XBVK("BCH")
 Q
CHK ;
 S BCHDATA(BCHPAT1,BCHF)=$$VAL^XBDIQ1(90002.11,BCHPAT1,BCHF)
 S BCHDATA(BCHPAT2,BCHF)=$$VAL^XBDIQ1(90002.11,BCHPAT2,BCHF)
 I BCHDATA(BCHPAT1,BCHF)]"",BCHDATA(BCHPAT2,BCHF)="" S BCHMAST(BCHF)=BCHDATA(BCHPAT1,BCHF) Q
 I BCHDATA(BCHPAT1,BCHF)="",BCHDATA(BCHPAT2,BCHF)="" S BCHMAST(BCHF)=BCHDATA(BCHPAT1,BCHF) Q  ;don't bother, both blank
 I BCHDATA(BCHPAT1,BCHF)=BCHDATA(BCHPAT2,BCHF) S BCHMAST(BCHF)=BCHDATA(BCHPAT1,BCHF) Q
 I BCHDATA(BCHPAT1,BCHF)="",BCHDATA(BCHPAT2,BCHF)]"" S BCHMAST(BCHF)=BCHDATA(BCHPAT2,BCHF) Q
 ;CHOOSE WHICH VALUE
 W !
 K DIR
 S DIR(0)="S^1:"_BCHDATA(BCHPAT1,BCHF)_";2:"_BCHDATA(BCHPAT2,BCHF),DIR("A")="Which Value for "_$P(^DD(90002.11,BCHF,0),U,1)_" should be used" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BCHQUIT=1 Q
 I Y="" S BCHQUIT=1 Q
 I Y=1 S BCHMAST(BCHF)=BCHDATA(BCHPAT1,BCHF)
 I Y=2 S BCHMAST(BCHF)=BCHDATA(BCHPAT2,BCHF)
 Q
MERGE ;
 ;EDIT BCHPAT1 WITH MASTER VALUES
 ;GET TRIBE AND COMMUNITY IENS
 W !,"Hold on...this may take a few minutes.."
 S BCHT=""
 S BCHVC=0,BCHGC=0
 I BCHMAST(".05")]"" S BCHT=$O(^AUTTTRI("B",BCHMAST(".05"),0))
 S BCHTC=""
 I BCHMAST(".06")]"" S BCHC=$O(^AUTTCOM("B",BCHMAST(".06"),0))
 S DA=BCHPAT1,DIE="^BCHRPAT(",DR=".01///"_BCHMAST(".01")_";.02///"_BCHMAST(".02")_";.03///"_BCHMAST(".03")_";.04///"_BCHMAST(".04")_";.05////"_BCHT_";.06////"_BCHC
 D ^DIE
 K DA,DR,DIE
 ;repoint 1112 of CHR Record file
 S BCHV=0 F  S BCHV=$O(^BCHR("ANRP",BCHPAT1,BCHV)) Q:BCHV'=+BCHV  D
 .S DA=BCHV,DR="1112////"_BCHPAT1,DIE="^BCHR(" D ^DIE
 .K DIE,DR,DA
 .S BCHVC=BCHVC+1 W "."
 ;NOW DELETE BCHPAT2
 S DA=BCHPAT2,DIK="^BCHRPAT(" D ^DIK
 W !!,"Patients have been merged.  ",BCHVC," records were re-pointed.",!
 Q
