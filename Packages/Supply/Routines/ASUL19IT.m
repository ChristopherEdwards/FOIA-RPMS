ASUL19IT ; IHS/ITSC/LMH -INPUT TRANSFORM USER TABLE 19 ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is the File Man Input transform for SAMS table 19 -
 ;User Code table
 I $G(DA)?6N D USR^ASULDIRR(DA) Q:$D(ASUL(19))
 I '$D(DUZ(2)) K X W !?10,"DUZ(2) must be set so Area Accounting Point can be determined" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 I $D(DIC(0)) S DIC(0)=$TR(DIC(0),"Q") S:DIC(0)'["A" DIC(0)="A"_DIC(0)
 S X=$G(DIX)
 N DIC,DIE
EN2 ;EP; DIC ALREADY SET
 N DIK,DIR,DR
 S X=$G(X)
 I X']"" D ASUL19RC G:$D(DIRUT) X G:'$D(X) X I Y>0 S DA=+Y,X=ASUL(19,"USR","NM") G X
 I $D(DA) I $D(^ASUL(19,+DA,0)) I DA?6N,$E(DA,1,2)=ASUL(1,"AR","AP") D NMIT Q
 I $D(ASUL(19,"USR","E#")) I ASUL(19,"USR","E#")?6N S X=ASUL(19,"USR","E#")
 I X?2N.1AN D
 .S DA=X,ASUL(19,"USR")=X D USR^ASULALGO(.DA) Q:DA'?4N
 .S (ASUL(19,"USR","E#"),X,DA)=ASUL(1,"AR","AP")_DA Q
 I X?4N D
 .S DA=X,(ASUL(19,"USR","E#"),X,DA)=ASUL(1,"AR","AP")_DA Q
 I X?6N D  Q:$D(X)  G:$D(DTOUT) ERR G:$D(DUOUT) ERR G X
 .S DA=X
 .I '$G(^ASUL(22,+($E(X,3,4)),0)) D  Q
 ..W !?10,$E(DA,3,4)," Is not a valid Program - first 2 characters of USER CODE must be valid Program"
 ..D HELP D ERR
 .I $E(DA,1,2)'=ASUL(1,"AR","AP") D  Q
 ..W !?10,$E(DA,1,2)," Is not Accounting Point you are signed on as, which is: ",ASUL(1,"AR","AP")
 ..D HELP D ERR
 .I $D(^ASUL(19,DA,0)) D  Q  ;Record found for DA
 ..S ASUL(19,"USR","E#")=DA,ASUL(19,"USR","NM")=$P(^ASUL(19,DA,0),U),ASUL(19,"USR")=$P(^ASUL(19,DA,1),U)
 .S ASUL(19,"USR","E#")=DA
 .I '$G(ASUL(19,"USR")) D  Q:'$D(X)
 ..S ASUL19=$E(DA,3,5) D IEN^ASULALGO(.ASUL19)
 ..I Y<0 W !?10,"Can't compute USER code for IEN:",DA D ERR Q
 ..S ASUL(19,"USR")=ASUL19 K ASUL19 ;Convert IEN back to USER code
 .D NAME ;Read a name for USER code
 .Q:'$D(X)  Q:$D(DTOUT)  Q:$D(DUOUT)
 .D FILE
 E  D
 .I X'?1A.ANP D ERR Q
 .S ASUL(19,"USR","NM")=X,ASUL(19,"USR","E#")=""
 .F  S ASUL(19,"USR","E#")=$O(^ASUL(19,"B",ASUL(19,"USR","NM"),ASUL(19,"USR","E#"))) Q:$E(ASUL(19,"USR","E#"),1,2)=ASUL(1,"AR","AP")  Q:ASUL(19,"USR","E#")']""
 .Q:ASUL(19,"USR","E#")]""  ;USER name found
 .S DIR(0)="Y",DIR("A")="Do you want to add a new User "_ASUL(19,"USR","NM") D ^DIR
 .D:$D(DIRUT) ERR D:('Y) ERR D:$D(DUOUT) ERR D:$D(DTOUT) ERR Q:'$D(X)
 .D ASUL19RC D:'$D(ASUL(19,"USR","E#")) ERR D:ASUL(19,"USR","E#")']"" ERR Q:'$D(X)
 G:$D(DIRUT) ERR G:'$D(X) ERR G:X']"" ERR G:$D(DTOUT) ERR G:$D(DUOUT) ERR G:$D(DIRUT) ERR
X ;
 S DA=ASUL(19,"USR","E#"),X=ASUL(19,"USR","NM")
 I '$D(ASUL("REQ")) K ASUL(19),ASUL(22)
 Q
NAME ;
 S DIR(0)="Y",DIR("A")="Do you want to add a new User "_ASUL(19,"USR") D ^DIR
 I $D(DIRUT)!('Y) K X Q
READNAME ;EP ;READ USER NAME
 S DIR(0)="F^3:30",DIR("A")="ENTER "_ASUL(19,"USR")_" USER NAME",DIR("?")="Name may be 3 to 30 characters long"
 S:$G(ASUL(19,"USR","NM"))]"" DIR("B")=$G(ASUL(19,"USR","NM"))
 D ^DIR
 G:$D(DTOUT) ERR G:$D(DUOUT) ERR G:X']"" ERR
 S ASUL(19,"USR","NM")=X
 Q
NMIT ;EP ; INPUT TRANSFORM FOR NAME (.01) FIELD
 K:$L(X)<3!($L(X)>40)!(X'?3AN.APN) X
 Q
CDIT ;EP;;USER CODE INPUT TRANSFORM FOR FILEMAN
 N Z S Z=DA D IEN^ASULALGO(.Z) K:X'=Z X Q
ARIT ;EP;;AREA POINTER INPUT TRANSFORM FOR FILEMAN
 N Z S Z=$E(DA,1,2) K:X'=Z X Q
PGIT ;EP;;PROGRAM POINTER INPUT TRANSFORM FOR FILEMAN
 N Z S X=+X,Z=+($E(DA,3,4)) K:X'=Z X Q
FILE ;
 S DIE=9002039.19
 W !?10,"Adding entry in User Table (19)"
 W !?15," CODE: ",ASUL(19,"USR")
 W !?15," NAME: ",ASUL(19,"USR","NM")
 W !?15," PROGRAM: ",ASUL(22,"PGM","NM")
 W !?15," AREA: ",ASUL(1,"AR","NM")
 S DR=".01///"_ASUL(19,"USR","NM")_";.02///"_ASUL(1,"AR","AP")_";.03///"_ASUL(22,"PGM","E#")_";1///"_ASUL(19,"USR")
 S $P(^ASUL(19,0),U,4)=$P(^ASUL(19,0),U,4)+1
 S $P(^ASUL(19,0),U,3)=ASUL(19,"USR","E#")
 S (DA,D0)=ASUL(19,"USR","E#") K DD D ^DIE K X
 Q
ERR ;
 K X,DUOUT,DTOUT,ASUL(19),ASUL(22)
 Q
DIC ;EP; SET DIC
 N DIC,DIE
 S (DIE,DIC)="^ASUL(19,",DIC(0)="EALM",DIC("W")="W ""   "" W:$D(^(1)) ""   "",,$P(^(1),U)" D EN2
 Q
HELP ;HELP INPUT USER TABLE 19
 W !?5,"You may only access User table entries for the Area you are signed"
 W !?5,"in to SAMS with. This is determined using the setting of DUZ(2)"
 W !?5,"which is set when you sign in to SAMS. If you wish to change Areas,"
 W !?5,"you must sign out of SAMS and then sign back in to SAMS selecting the"
 W !?5,"appropriate DIVISION (area). If when you sign in to SAMS you are not"
 W !?5,"prompted for a DIVISION, then you are automatically signed on as a"
 W !?5,"specific Area and are restricted to that Area."
 W !!?5,"You will be asked for the User Code or User Name for the entry you wish"
 W !?5,"to Access. If an entry for that User does not exist, you will also be asked"
 W !?5,"for the User Name or User Code (whichever has not already been enterd)"
 W !?5,"so that a new entry may be added. Once an entry has been added to the"
 W !?5,"table, only the NAME field may be changed. To change any other field,"
 W !?5,"you must delete the entry and re-enter it with the changes. Deletions"
 W !?5,"however, may only be done by those with specific access keys."
 Q
ASUL19RC ;EP;WITH LOCAL ARRAY KILL
 K ASUL(19)
READUSR ;Get User to be processed
 N DIR
 S DIR(0)="FAO^2:6^K:X'?2N.1AN X"
 S DIR("A")="    ENTER USER CODE"
 I $D(ASUL(19,"USR","NM")) S DIR("A")=DIR("A")_" FOR "_ASUL(19,"USR","NM")
 S DIR("A")=DIR("A")_" : "
 S DIR("?")="^D HLPUSADD^ASUL19RC"
 S DIR("??")="^D HLPUSLST^ASUL19RC"
 D ^DIR S:$D(DUOUT) ASUL(19,"USR")="" Q:$D(DIROUT)  Q:$D(DUOUT)  Q:$D(DTOUT)
 S ASUL(19,"USR")=X
 D USR^ASULDIRR(.X)
 I Y<0 D
 .W !?5,"No entry in User Table (19) for Usr Code ",ASUL(19,"USR")
 .W " ",$G(ASUL(19,"USR","NM")),!?10," for area ",ASUL(1,"AR","NM")," - ",ASUL(1,"AR","AP")
 .I Y=-1 D
 ..K DIR S DIR(0)="Y",DIR("A")="Do you want to add one" D ^DIR
 ..I Y D READNAME^ASUL19IT Q:Y<0  S X=ASUL(19,"USR","E#"),X(1)=ASUL(19,"USR","NM") D USR^ASULDIRA(.X)
 E  D
 .W " ",$G(ASUL(19,"USR","NM"))
 Q
HLPUSLST ;
 N DIC,DIR,DO
 S DIC="^ASUL(19,",DIC("S")="I $P(^(0),U,2)=ASUL(1,""AR"",""E#"")"
 S DIC(0)="MEI",D="B",DZ="??" D DQ^DICQ
 S (DIR("B"),DIR(0))="Y",DIR("A")="Want to see valid Program Codes?" D ^DIR
 I Y D HLPPGLST
 Q
HLPPGLST ;
 N DIC,DO
 S DIC="^ASUL(22,"
 S DIC(0)="MEI",D="B",DZ="??" D DQ^DICQ
 Q
HLPUSADD ;
 W !,"For the User to be added, Enter either:"
 W !?10,"3 digit User code (first 2 must equal valid Program code)"
 W !?10,"?? to see a list of current entries in the User Table"
 W !?10,"Enter '^' or <enter> to end session of User entry update"
 Q
