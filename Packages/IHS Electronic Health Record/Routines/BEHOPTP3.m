BEHOPTP3 ;MSC/IND/MGH - Patient List Management ;11-Feb-2010 12:45;PLS
 ;;1.1;BEH COMPONENTS;**004004**;Mar 20, 2007
 ;=================================================================
 ; Call logic to manage team lists
MANAGE(DATA,LIST,ACTION,NAME,VAL) ;
 D EXEC(12)
 Q
 ; Execute logic at specified node
EXEC(NODE) ;
 N $ET
 S $ET="",@$$TRAP^CIAUOS("EXECERR^BEHOPTPL")
 X $G(^BEHOPT(90460.03,+LIST,NODE))
 Q
 ; List management API
MAN2(DATA,LIST,ACTION,NAME,VAL) ;EP
 S DATA=""
 I ACTION="S"!(ACTION="P")!(ACTION="D") S DATA=$$VALIDATE(NAME)
 I ACTION="C" S DATA=$$VALIDATE(NAME,1)
 Q:DATA
 I ACTION="T" D GETTEAM(.DATA) Q
 I ACTION="P" D GETLST(.DATA,NAME) Q
 I ACTION="C" D CRLST(.DATA,NAME) Q
 I ACTION="S" D SETLST(.DATA,NAME,.VAL) Q
 I ACTION="D" D DELETE(.DATA,NAME) Q
 S DATA="-1^Unknown action"
 Q
 ;Return the list of providers for this list
GETLST(DATA,NAME) ;EP
 N CNT,IEN,PRV,QUALS,DATE,PAT
 K DATA
 S DATA(1)="^No Users found.",(CNT,IEN)=0
 S DATE="TODAY",DATE=$$DT^CIAU(DATE)
 S TEAM=$$GETIEN(NAME)
 I '$D(^OR(100.21,TEAM,0)) S DATA(1)="^Not a valid team." Q
 F  S IEN=$O(^OR(100.21,TEAM,1,IEN)) Q:'IEN  S PRV=+$G(^(IEN,0)) D
 .S X=$$ACTIVE^BEHOUSCX(PRV,DATE)
 .I X=1 S CNT=CNT+1,DATA(CNT)=PRV_U_$P(^VA(200,PRV,0),U)_U_"U"
 .I X=0 S CNT=CNT+1,DATA(CNT)=PRV_"*"_U_$P(^VA(200,PRV,0),U)_U_"U"
 S IEN=0 F  S IEN=$O(^OR(100.21,TEAM,10,IEN)) Q:'IEN  S PAT=+$G(^(IEN,0)) D
 .S CNT=CNT+1,DATA(CNT)=PAT_U_$P(^DPT(PAT,0),U)_U_"M"
 Q
 ; Validate list name
VALIDATE(NAME,DUP) ;
 N L
 S NAME=$$TRIM^CIAU(NAME),L=$L(NAME),DUP=+$G(DUP)
 Q:L<3!(L>30) "-1^List name must be 3-30 characters in length."
 Q:NAME'?.(1A,1N,1"_",1" ") "-1^List name contains invalid characters."
 I DUP,$$GETIEN(NAME) Q "-1^List name already exists."
 I 'DUP,'$$GETIEN(NAME) Q "-1^List name not found."
 Q ""
CRLST(DATA,NAME) ;EP Create a new team list
 N DATE,FNUM,FDA
 K DATA
 S DATE="TODAY",DATE=$$DT^CIAU(DATE)
 S FNUM=100.21
 S FDA=$NA(FDA(FNUM,"+1,"))
 S @FDA@(.01)=NAME
 S @FDA@(.1)=$$UPPER(NAME)
 S @FDA@(1)="TM"
 S @FDA@(1.6)=DUZ
 S @FDA@(1.65)=DATE
 S @FDA@(1.7)="Y"
 S DATA=$$UPDATE^BGOUTL(.FDA,"",.IEN)
 S:'DATA DATA=IEN(1)
 I $D(IEN(1)) D
 .S FDA=$NA(FDA(100.212,"+1,"_IEN(1)_","))
 .S @FDA@(.01)=DUZ
 .D UPDATE^DIE("","FDA","IEN","ERR")
 Q
 ; Set List
SETLST(DATA,NAME,VAL) ;EP
 N TEAM,FDA,FNUM,ERR,IEN,CNTU,CNTM,NUM
 K DATA
 Q:'$L(NAME)
 S TEAM=$$GETIEN(NAME)
 S CNTU=0,CNTM=0
 I '$D(^OR(100.21,TEAM,0)) S DATA(1)="^Not a valid team." Q
 D DELLST(.DATA,NAME)
 S NUM="" F  S NUM=$O(VAL(NUM)) Q:NUM=""  D
 .I $P(VAL(NUM),U,3)="U"  D
 ..K FDA,IEN,ERR
 ..S FDA=$NA(FDA(100.212,"+1,"_TEAM_","))
 ..S @FDA@(.01)=$P(VAL(NUM),U,1)
 ..D UPDATE^DIE("","FDA","IEN","ERR")
 .I $P(VAL(NUM),U,3)="M"  D
 ..K FDA,IEN,ERR
 ..S FDA=$NA(FDA(100.2101,"+1,"_TEAM_","))
 ..S @FDA@(.01)=$P(VAL(NUM),U,1)_";DPT("
 ..D UPDATE^DIE("","FDA","IEN","ERR")
 Q
GETIEN(NAME) ;Get the IEN of the list
 N IEN
 S IEN="" S IEN=$O(^OR(100.21,"B",NAME,IEN))
 Q IEN
DELLST(DATA,NAME) ;EP
 N TEAM,FDA,FNUM,PRV,DA,DIK,MEM
 Q:'$L(NAME)
 S TEAM=$$GETIEN(NAME)
 S DATA=0
 I '$D(^OR(100.21,TEAM,0)) S DATA(1)="^Not a valid team." Q
 S PRV=0 F  S PRV=$O(^OR(100.21,TEAM,1,PRV)) Q:PRV=""  D
 .S DA(1)=TEAM,DA=PRV
 .S DIK="^OR(100.21,DA(1),1,"
 .S:DA DATA=$$DELETE^BGOUTL(DIK,.DA)
 S MEM=0 F  S MEM=$O(^OR(100.21,TEAM,10,MEM)) Q:MEM=""  D
 .S DA(1)=TEAM,DA=MEM
 .S DIK="^OR(100.21,DA(1),10,"
 .S:DA DATA=$$DELETE^BGOUTL(DIK,.DA)
 I DATA="" S DATA=0
 Q DATA
DELETE(DATA,NAME) ;Delete entire team
 N FNUM,IEN
 K DATA
 Q:'$L(NAME)
 S TEAM=$$GETIEN(NAME)
 S FNUM=100.21,IEN=TEAM
 S DATA=$$DELETE^BGOUTL(FNUM,IEN)
 Q
GETTEAM(DATA) ;Get the teams with this user
 N CNT,IEN,X
 S (CNT,IEN)=0
 F  S IEN=$O(^OR(100.21,"C",DUZ,IEN)) Q:'IEN  D
 .S X=$G(^OR(100.21,IEN,0))
 .S:$P(X,U,2)="TM" CNT=CNT+1,DATA(CNT)=IEN_U_X
 Q
UPPER(X) ; Convert lower case X to UPPER CASE
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
