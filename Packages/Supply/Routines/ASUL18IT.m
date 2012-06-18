ASUL18IT ; IHS/ITSC/LMH -LOOKUP RTN TABLE 18 SUB STA ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is the File Man Input transform for SAMS table 18 -
 ;Sub Station table
 I '$D(DUZ(2)) K X W !,"DUZ(2) must be set so Area Accounting Point can be determined" Q
 I '$D(ASUL(1,"AR","AP")) S ASUV("SAVEX")=X D SETAREA^ASULARST S X=ASUV("SAVEX") K ASUV("SAVEX")
 D ARE^ASUUSCRN
 I $D(DIC(0)) S DIC(0)=$TR(DIC(0),"Q") S:DIC(0)'["A" DIC(0)="A"_DIC(0)
 N DIC,DIE
EN2 ;EP; DIC ALREADY SET
 N DIK,DIR,DR
 S X=$G(X)
 I X']"" D ASUL18RC G:$D(DIRUT) ERR  I Y>0 S DA=+Y,X=ASUL(18,"SST","NM") G X
 I X?1N.N D
 .S DA=X
 .I $L(DA)=3 S (ASUL(18,"SST","E#"),X,DA)=ASUL(1,"AR","AP")_DA Q
 .I $L(DA)=2 S (ASUL(18,"SST","E#"),X,DA)=ASUL(1,"AR","AP")_"0"_DA
 I X?5N D  Q:'$D(DA)
 .S DA=X D SST^ASUUSCRN(.DA)
 .I '$D(DA) D  Q
 ..W !?10,$E(DA,1,2)," Is not Accounting Point you are signed on as, which is: ",ASUL(1,"AR","AP"),! D HELP D ERR
 .I $D(^ASUL(18,DA,0)) D  Q  ;SST entry found
 ..S ASUL(18,"SST","E#")=DA,ASUL(18,"SST")=$E(DA,4,5),ASUL(18,"SST","NM")=$P(^ASUL(18,DA,0),U)
 .S ASUL(18,"SST","E#")=DA,ASUL(18,"SST")=$E(DA,4,5)
 .D NAME^ASUL18IT Q:$D(DTOUT)  Q:$D(DUOUT)  Q:'$D(X)
 .D FILE^ASUL18IT S X=ASUL(18,"SST","NM"),DA=ASUL(18,"SST","E#")
 E  D
 .D NMIT^ASUL18IT Q:'$D(X)
 .S ASUL(18,"SST","NM")=X,ASUL(18,"SST","E#")=""
 .F  S ASUL(18,"SST","E#")=$O(^ASUL(18,"C",ASUL(18,"SST","NM"),ASUL(18,"SST","E#"))) Q:$E(ASUL(18,"SST","E#"),1,2)=ASUL(1,"AR","AP")  Q:ASUL(18,"SST","E#")']""
 .I ASUL(18,"SST","E#")]"" S ASUL(18,"SST")=$P(^ASUL(18,ASUL(18,"SST","E#"),1),U) Q
 .D READSST I '$D(ASUL(18,"SST","E#")) D ERR Q
 .I ASUL(18,"SST","E#")'["" D ERR Q
 .D FILE
 G:$D(DIRUT) ERR G:'$D(X) ERR G:X'["" ERR G:$D(DUOUT) ERR G:$D(DTOUT) ERR
X ;
 S DA=ASUL(18,"SST","E#"),X=ASUL(18,"SST","NM")
 I '$D(ASUL("REQ")) K ASUL(18)
 Q
NAME ;EP ;
 S DIR(0)="FA^3:30"
 S DIR("?")="Name may be 3 to 30 characters long"
 S DIR("A")="Enter Sub Station Name for code "_ASUL(18,"SST")_": "
 D ^DIR Q:$D(DTOUT)  Q:$D(DUOUT)  Q:X']""
 S ASUL(18,"SST","NM")=X
 Q
NMIT ;EP ; INPUT TRANSFORM FOR NAME (.01) FIELD
 K:$L(X)<3!($L(X)>30)!(X'?3AN.APN) X
 Q
ARSST ;EP ;
 I '$D(DUZ(2)) K X W !,"DUZ(2) must be set so Area Accounting Point can be determined" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 K:$E(X,1,2)'=ASUL(1,"AR","AP")!(X'?5N) X
 Q
FILE ;EP ;
 N DIC,DIX
 S:'$D(ASUL(1,"AP")) ASUL(1,"AP")=ASUL(1,"AR","AP")
 W !?10,"Adding entry in Sub Station table (18) CODE:",ASUL(18,"SST")
 W !!?48," NAME:",ASUL(18,"SST","NM")
 W !!?48," AREA:",ASUL(1,"AR","AP")
 S DIC="^ASUL(18,",DIC(0)="LISN",X=ASUL(18,"SST","NM"),(DINUM,DA)=ASUL(18,"SST","E#"),DLAYGO=9002039.18 K DD,DO D FILE^DICN
FILE2 ;
 S DR=".02///"_ASUL(1,"AR","AP")_";1///"_ASUL(18,"SST")
 S (DA,D0)=ASUL(18,"SST","E#"),DIE="^ASUL(18," K DD D ^DIE K X
 Q
ERR ;
 K X
 Q
DIC ;EP ;TO SET DIC
 N DIC,DIE
 S (DIC,DIE)="^ASUL(18,",DIC(0)="EALM"
 S (DIE,DIC)="^ASUL(19,",DIC(0)="EALM",DIC("W")="W ""   "" W:$D(^(1)) ""   "",,$P(^(1),U)" D EN2
 Q
HELP ;
 W !?5,"You may only access Sub Station table entries for the Area you are signed"
 W !?5,"in to SAMS with. This is determined using the setting of DUZ(2)"
 W !?5,"which is set when you sign in to SAMS. If you wish to change Areas,"
 W !?5,"you must sign out of SAMS and then sign back in to SAMS selecting the"
 W !?5,"appropriate DIVISION (area). If when you sign in to SAMS you are not"
 W !?5,"prompted for a DIVISION, then you are automatically signed on as a"
 W !?5,"specific Area and are restricted to that Area."
 W !!?5,"You will be asked for the Sub Station Code or Sub Station Name for the"
 W !?5,"entry you wish to Access. If an entry for that Sub Station does not exist,"
 W !?5,"you will also be asked for the Sub Station Name or Sub Station Code"
 W !?5,"(whichever has not already been enterd) so that a new entry may be added."
 Q
ASUL18RC ;EP; READ AFTER CLEAR LOCAL VARIABLES
 K ASUL(18)
READSST ;EP ;Get Sub Station to be processed
 N DIR
 S DIR(0)="FAO^2:5^K:X'?2AN.N X",DIR("A")="ENTER SUB STATION CODE "
 S DIR("?")="^D HLPSSAD^ASUL18IT"
 S DIR("??")="^D HLPSSLS^ASUL18IT"
 D ^DIR Q:$D(DIROUT)  Q:$D(DUOUT)  Q:$D(DTOUT)
 I X["PL" S DA=ASUL(1,"AR","AP")_999,ASUL(18,"SST")=X
 I X?2N S ASUL(18,"SST")=X
 I X?3N S ASUL(18,"SST")=$E(X,2,3)
 S DA=X
 D SST^ASULDIRR(.DA)
 I Y<0 D
 .W !,"No entry in Sub Station Table (18) for ",X
 .S ASUF("HALT")=1
 I $G(ASUL(18,"SST"))']"" S ASUF("HALT")=1
 W " ",$G(ASUL(18,"SST","NM"))
 Q
HLPSSLST ;EP ;
 N DIC,DO
 S DIC="^ASUL(18,",DIC("S")="I $P(^(0),U,2)=ASUL(1,""AR"",""AP"")"
 S DIC(0)="MEI",D="B",DZ="??" D DQ^DICQ
 Q
HLPSSADD ;
 W !,"For the Sub Station to be found, Enter either:"
 W !?10,"2 digit Sub Station code or"
 W !?10,"?? to see a list of current entries in the Sub Station Table"
 W !?10,"Enter '^' or <enter> to end session"
 Q
