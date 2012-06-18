ASUL20IT ; IHS/ITSC/LMH -IN TRANSFORM REQUSITIONER TABLE 20 ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is the File Man Input transform for SAMS table 20 -
 ;Requsitioner table
 I '$D(DUZ(2)) K X W !?10,"DUZ(2) must be set so Area Accounting Point can be determined" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 I $D(DIC(0)) D
 .S DIC(0)=$TR(DIC(0),"Q")
 .S:DIC(0)'["N" DIC(0)="N"_DIC(0)
 .S:DIC(0)'["A" DIC(0)="A"_DIC(0)
 E  D
 .S DIC(0)="NAE"
 N DIK,DIR,DR,DIC,DIE
 S (DIC,DIE)=9002039.2
EN1 ;X ALREADY SET BY EN2
 S X=$G(X),ASUL("REQ")=1
 I X']"" D ASUL19RC^ASUL19IT G:$D(DIRUT) ERR I Y>0 G SST
 I $D(DA) D  G:ASUL("REQ")=2 REQ G:$D(ASUL(19,"USR","E#")) SST
 .I DA?9N,$D(^ASUL(20,+DA,0)) D  I ASUL("REQ")=2 Q
 ..I $E(DA,1,2)=ASUL(1,"AR","AP") S ASUL("REQ")=2
 .I $D(^ASUL(19,+DA,0)),DA?6N  D  I Y>0 K DA
 ..I $E(DA,1,2)=ASUL(1,"AR","AP") D USR^ASULDIRR(.DA)
 E  D
 .S DA=X
 I DA]"" K Y D  G:$G(Y)>0 SST
 .I DA?6N,$D(^ASUL(19,+DA,0)) D  Q:$G(Y)>0
 ..I $E(DA,1,2)'=ASUL(1,"AR","AP") Q
 ..I $G(ASUL(19,"USR","E#"))'=DA D USR^ASULDIRR(.DA) Q:Y<-1  Q:Y>0
 ..I Y=-1 D USR^ASULDIRA(.DA) Q:Y<0
 .E  D
 ..I DA?1AN.ANP S Y=$O(^ASUL(19,"B",DA,"")) I Y]"" S DA=Y D USR^ASULDIRR(.DA) Q
 E  D
 .D DIC^ASUL19IT
 G:$D(DIRUT) ERR
 I $D(ASUL(19)) G SST
 W !?5,"No valid Requsitioner, User, or Sub Station entered"
 G ERR
SST ;
 I $D(ASUL(18)) G REQ
 D ASUL18RC^ASUL18IT
 G:$D(DIRUT) ERR
 I $D(ASUL(18)) G REQ
 I Y>0 S DA=Y D SST^ASULDIRR(.DA)
 I $D(ASUL(18)) G REQ
 D DIC^ASUL18IT
 I '$D(ASUL(18,"SST","E#")) W !?5,"Valid Sub Station not entered" G ERR
REQ ;
 I '$D(DA),$D(ASUL(18,"SST","E#")),$D(ASUL(19,"USR","E#")) S DA=ASUL(18,"SST","E#")_$E(ASUL(19,"USR","E#"),3,6)
 I DA?9N D  G:Y>0 EXIT
 .I '$D(ASUL(18,"SST","E#")) S ASUL(18,"SST","E#")=$E(DA,1,5) D SST^ASULDIRR(ASUL(18,"SST","E#"))
 .I '$D(ASUL(19,"USR","E#")) S ASUL(19,"USR","E#")=$E(DA,1,2)_$E(DA,6,9) D USR^ASULDIRR(ASUL(19,"USR","E#"))
 .D REQ^ASULDIRR(.DA)
 I $D(ASUL(18,"SST","E#")) D
 .I $D(ASUL(19,"USR","E#")) D
 ..S (DA,ASUL(20,"REQ","E#"))=ASUL(18,"SST","E#")_$E(ASUL(19,"USR","E#"),3,6)
 ..D REQ^ASULDIRR(.DA)
 ..D:Y<0 FILE
 .E  D
 ..W !?5,"Valid User not entered" D ERR
 E  D
 .W !?5,"Valid Sub Station not entered" D ERR
 G:'$D(X) ERR
EXIT ;
 S (DA,D0)=ASUL(20,"REQ","E#"),X=ASUL(20,"REQ","NM")
 K ASUL(18),ASUL(19),ASUL(20),ASUL(22),ASUL("REQ")
 Q
ARIT ;EP;;AREA POINTER INPUT TRANSFORM FOR FILEMAN
 N Z S Z=$E(DA,1,2) K:X'=Z X Q
FILE ;ADD ENTRY TO REQUSITIONER TABLE FILE
 S ASUL(20,"REQ","ULV")=$S($E(DA,1,2)=59:2.0,1:1.5)
 W !?10,"Adding entry in Requsitioner Table (20)"
 W !?10," NAME: ",ASUL(20,"REQ","NM")
 W !?10," AREA: ",ASUL(1,"AR","AP")
 W !?10," USER LEVEL: ",ASUL(20,"REQ","ULV")
 S ^ASUL(20,ASUL(20,"REQ","E#"),0)=ASUL(20,"REQ","NM")_U_ASUL(19,"USR","E#")_U_ASUL(18,"SST","E#")_U_ASUL(1,"AR","AP")
 S ^ASUL(20,ASUL(20,"REQ","E#"),1)=ASUL(20,"REQ","ULV")
 S $P(^ASUL(20,0),U,4)=$P(^ASUL(20,0),U,4)+1
 S $P(^ASUL(20,0),U,3)=ASUL(19,"USR","E#")
 S DIK="^ASUL(20,",DA=ASUL(20,"REQ","E#") D IX^DIK K X
ERR ;ERROR OR NEW ENTRY MADE
 K X,DUOUT,DTOUT,ASUL(18),ASUL(19),ASUL(20),ASUL(22),ASUL("REQ")
 Q
HELP ;
 W !?5,"You may only access Requsitioner table entries for the Area you are signed"
 W !?5,"in to SAMS with. This is determined using the setting of DUZ(2)"
 W !?5,"which is set when you sign in to SAMS. If you wish to change Areas,"
 W !?5,"you must sign out of SAMS and then sign back in to SAMS selecting the"
 W !?5,"appropriate DIVISION (area). If when you sign in to SAMS you are not"
 W !?5,"prompted for a DIVISION, then you are automatically signed on as a"
 W !?5,"specific Area and are restricted to that Area."
 W !!?5,"You will be asked for the Requsitioner (User) Code for the entry you wish"
 W !?5,"to Access. If an entry for that User does not exist, you will be asked"
 W !?5,"for all necessary data to enter a new User in the ASUTBL USER table file."
 W !?5,"For the user you select, you will be asked for the Sub Station where the"
 W !?5,"user is located. If an entry for that Sub Station does not exist, you will"
 W !?5,"be asked for all data to enter a new Sub Station in the ASUTBL SUB STATION"
 W !?5,"table file. Once an entry has been made to the Requsitioner table, only"
 W !?5,"the USER LEVEL field may be changed. To change any other field, you must"
 W !?5,"delete the entry and re-enter it with the changes. Deletions however,"
 W !?5,"may only be done by those with specific access keys."
 Q
EN2 ;EP;;FOR ASUL20EN
 I $D(ASUL(19)) G SST
 I $D(ASUL(18)) K X
 G EN1
