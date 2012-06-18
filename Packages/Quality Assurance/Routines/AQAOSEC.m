AQAOSEC ; IHS/ORDC/LJF - SECURITY CHECK UTILITY ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;One of the most important routines in the package. Handles extra
 ;security levels needed for such sensitive data.  Contains various
 ;entry points called by entry actions & screens on DIC calls.
 ;
 Q
ENTRY ;EP; used by options to check AQAOPT variable
 ;called by entry actions; sets xquit if access not correct
 ;
 K AQAOCHK("VAR")
 I '$D(AQAOUA("USER")) D  D CHECK Q
 .S AQAOCHK("VAR")="***USER QI ACCESS INFO MISSING***"
 I $P(AQAOUA("USER"),U,6)="",'$D(AQAOUA("USER","ACCESS")) D  D CHECK Q
 .S AQAOCHK("VAR")="***USER QI ACCESS INFO MISSING***"
 D ACCESS
 ;
 ; >> quit option if check variable set
CHECK I $D(AQAOCHK("VAR")) W *7,!!,AQAOCHK("VAR") K AQAOCHK("VAR") S XQUIT=""
 Q
 ;
ACCESS ; >>> SUBRTN to check user's access level
 I '$D(AQAOCHK("ACTION")) S AQAOCHK("VAR")="***NO ACTION LEVEL SET***" Q
 I AQAOCHK("ACTION")="INQUIRY" Q
 I $P(AQAOUA("USER"),U,6)="QA" Q  ;pkg admin access
 I (AQAOCHK("ACTION")="ADMIN") D  Q
 .S AQAOCHK("VAR")="** YOU ARE NOT A DESIGNATED PACKAGE ADMINISTRATOR!"
 I $P(AQAOUA("USER"),U,6)="QI" Q  ;qi staff
 I AQAOCHK("ACTION")="EDIT" Q  ;PATCH 4
 ;I AQAOCHK("ACTION")="EDIT" D  Q  ;PATCH 4
 ;.S:(AQAOUA("USER","ACCESS")="1") AQAOCHK("VAR")="***YOU DO NOT HAVE ACCESS TO EDIT QI DATA, SEE YOUR SUPERVISOR***" ;PATCH 4
 S AQAOCHK("VAR")="***ACTION LEVEL NOT SET CORRECTLY***"
 Q
 ;
 ;
INDCHK ;EP; called by DIC("S") to screen indicators
 N AQAOI K AQAOCHK("OK") Q:'$D(AQAOUA("USER"))
 I $P(AQAOUA("USER"),U,6)["Q" S AQAOCHK("OK")="" D RESETI Q  ;qi staff
 I $O(^AQAO(2,Y,"QTM",0))="" S AQAOCHK("OK")="" D RESETI Q  ;open indtr
 ;
 S AQAOI=0 ;loop thru qi teams for indicator
 F  S AQAOI=$O(^AQAO(2,Y,"QTM",AQAOI)) Q:AQAOI'=+AQAOI  D
 .Q:'$D(^AQAO(2,Y,"QTM",AQAOI,0))  S AQAOIII=$P(^(0),U) ;team ifn
 .I $D(AQAOUA("USER",AQAOIII)) D TEAMCHK ;check user's access level
 ;
RESETI K AQAOI,AQAOIII I ^AQAO(2,Y,0) ;reset naked ref
 Q
 ;
 ;
OCCCHK ;EP; called by DIC("S") to screen occurrence
 K AQAOCHK("OK") Q:'$D(AQAOUA("USER"))
 I $P(^AQAOC(Y,0),U,9)'=DUZ(2) D RESETO Q  ;another facility
 I $P(AQAOUA("USER"),U,6)["Q" S AQAOCHK("OK")="" D RESETO Q  ;qi staff
 ;
 S AQAOI=$P(^AQAOC(Y,0),U,8) ;indicator
 I '$O(^AQAO(2,AQAOI,"QTM",0)) S AQAOCHK("OK")="" D RESETO Q  ;open ind
 ;
 S AQAOII=0 ;check access via qi team
 F  S AQAOII=$O(^AQAO(2,AQAOI,"QTM",AQAOII)) Q:AQAOII'=+AQAOII  D
 .Q:'$D(^AQAO(2,AQAOI,"QTM",AQAOII,0))  S AQAOIII=$P(^(0),U)
 .I $D(AQAOUA("USER",AQAOIII)) D
 ..I +$O(^AQAO1(1,AQAOIII,1,0)),$P(^(0),U,7)]"" Q:'$D(^AQAO1(1,"AB",$P(^AQAOC(Y,0),U,7),AQAOIII))  ;service specific occ
 ..D TEAMCHK ;check user access level
 I $D(AQAOCHK("OK"))!('$D(AQAORVW)) D RESETO Q
 ;
 ;check for referrals
 I $$INITIAL S AQAOCHK("OK")="" D RESETO Q  ;on initial review
 I $$REVW S AQAOCHK("OK")="" ;on other reviews
 ;
RESETO K AQAOI,AQAOII,AQAOIII I ^AQAOC(Y,0) ;reset naked ref
 Q
 ;
INITIAL() ;EXTRN VAR to see if occ was referred on initial review
 N AQAOI,X S X=0,AQAOI=$P($G(^AQAOC(Y,1)),U,9)
 I AQAOI]"" D
 .I AQAOI["AQAO(9" S:(+AQAOI=DUZ) X=1
 .I AQAOI["AQAO1(1" S:$D(AQAOUA("USER",+AQAOI)) X=1
 .I X=0 S X=$$IADDRV ;check additional ref
 Q X
 ;
IADDRV() ;EXTRN VAR to see if any additional referrals made on initial review
 N AQAOI,AQAOII,X S X=0
 S AQAOI=0
 F  S AQAOI=$O(^AQAOC(Y,"IADDRV",AQAOI)) Q:AQAOI'=+AQAOI  Q:X=1  D
 .Q:'$D(^AQAOC(Y,"IADDRV",AQAOI,0))  S AQAOII=$P(^(0),U)
 .Q:AQAOII=""  I AQAOII["AQAO(9" S:+AQAOII=DUZ X=1
 .I AQAOII["AQAO1(1" S:$D(AQAOUA("USER",+AQAOII)) X=1
 Q X
 ;
REVW() ;EXTRN VAR to see if occ referred during other reviews
 N AQAOI,AQAOII,X S X=0
 S AQAOI=0
 F  S AQAOI=$O(^AQAOC(Y,"REV",AQAOI)) Q:AQAOI'=+AQAOI  Q:X=1  D
 .Q:'$D(^AQAOC(Y,"REV",AQAOI,0))  S AQAOII=$P(^(0),U,9) ;PATCH 4
 .Q:AQAOII=""  I AQAOII["AQAO(9" S:+AQAOII=DUZ X=1
 .I AQAOII["AQAO1(1" S:$D(AQAOUA("USER",+AQAOII)) X=1
 .I X=0 S X=$$ADDRV(AQAOI) ;additional referrals
 Q X
 ;
ADDRV(AQAOI) ;EXTRN VAR to see if additional ref made on other reviews
 N AQAOIII,AQAOII,X S X=0
 S AQAOII=0
 F  S AQAOII=$O(^AQAOC(Y,"REV",AQAOI,"ADDRV",AQAOII)) Q:AQAOII'=+AQAOII  Q:X=1  D
 .Q:'$D(^AQAOC(Y,"REV",AQAOI,"ADDRV",AQAOII,0))  S AQAOIII=$P(^(0),U)
 .Q:AQAOIII=""  I AQAOIII["AQAO(9" S:+AQAOIII=DUZ X=1
 .I AQAOIII["AQAO1(1" S:$D(AQAOUA("USER",+AQAOIII)) X=1
 Q X
 ;
 ;
ACTCHK ;EP; called by DIC("S") to screen actions
 K AQAOCHK("OK") Q:'$D(AQAOUA("USER"))
 I $P(^AQAO(5,Y,0),U,12)'=DUZ(2) D RESETA Q  ;another facility
 I $P(AQAOUA("USER"),U,6)["Q" S AQAOCHK("OK")="" D RESETA Q  ;qi staff
 ;
 S AQAOI=$P(^AQAO(5,Y,0),U,14) ;indicator
 I '$O(^AQAO(2,AQAOI,"QTM",0)) S AQAOCHK("OK")="" D RESETA Q  ;open ind
 ;
 S AQAOII=0 ;check access via qi team
 F  S AQAOII=$O(^AQAO(2,AQAOI,"QTM",AQAOII)) Q:AQAOII'=+AQAOII  D
 .Q:'$D(^AQAO(2,AQAOI,"QTM",AQAOII,0))  S AQAOIII=$P(^(0),U)
 .I $D(AQAOUA("USER",AQAOIII)) D TEAMCHK ;check user access level
 ;
RESETA K AQAOI,AQAOII,AQAOIII I ^AQAO(5,Y,0) ;reset naked ref
 Q
 ;
TEAMCHK ; >> SUBRTN called by INDCHK and OCCCHK
 ;checks access level by team
 I AQAOUA("USER",AQAOIII)="1",(AQAOCHK("ACTION")="INQUIRY") S AQAOCHK("OK")="" Q
 I AQAOUA("USER",AQAOIII)="2" S AQAOCHK("OK")="" Q
 Q
