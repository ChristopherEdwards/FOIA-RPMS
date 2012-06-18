BEHOPTP2 ;MSC/IND/DKM - Patient List Management ;20-Mar-2007 13:48;DKM
 ;;1.1;BEH COMPONENTS;**004002**;Mar 20, 2007
 ;=================================================================
 ; Retrieve a given list for a given user
PLSTPTS(DATA,NAME) ;EP
 N TMP,ERR,CNT,LP,DFN,PTNM
 S DATA(1)="^No patients found.",(CNT,LP)=0
 D GETWP^XPAR(.TMP,"ALL",$$PARAM,$$GETNAME(NAME),.ERR)
 F  S LP=$O(TMP(LP)) Q:'LP  D
 .S DFN=+TMP(LP,0)
 .I DFN D
 ..S PTNM=$$GET1^DIQ(2,DFN_",",".01")
 ..S:$L(PTNM) CNT=CNT+1,DATA(CNT)=DFN_U_PTNM
 Q
 ; Retrieve a list of personal lists for a user
PLSTLST(DATA) ;EP
 N ERR,LP
 S LP=0
 D GETLST^XPAR(.DATA,"ALL",$$PARAM,"Q",.ERR)
 F  S LP=$O(DATA(LP)) Q:'LP  S $P(DATA(LP),U)=$$GETIEN($P(DATA(LP),U,2))
 Q
 ; List management API
MANAGE(DATA,ACTION,NAME,VAL) ;EP
 S DATA=$$VALIDATE(.NAME,ACTION="C")
 Q:DATA
 I ACTION="C" D SETLST(.DATA,NAME) Q
 I ACTION="R" D RENLST(.DATA,NAME,.VAL) Q
 I ACTION="S" D SETLST(.DATA,NAME,.VAL) Q
 I ACTION="D" D DELLST(.DATA,NAME) Q
 S DATA="-1^Unknown action"
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
 ; Rename existing list
 ;  OLD  - Existing Instance name (aka list name)
 ;  NEW  - New list name
RENLST(DATA,OLD,NEW) ;EP
 S DATA=$$VALIDATE(NEW,1)
 D:'DATA REP^XPAR("USR",$$PARAM,$$GETNAME(OLD),NEW,.DATA)
 D:'DATA CHG^XPAR("USR",$$PARAM,NEW,NEW,.DATA)
 Q
 ; Set List
SETLST(DATA,NAME,VAL) ;EP
 Q:'$L(NAME)
 S:NAME=+NAME NAME=$$GETNAME(NAME)
 S VAL=NAME
 S:$D(VAL)'=11 VAL(1,0)=""
 D EN^XPAR("USR",$$PARAM,NAME,.VAL,.DATA)
 Q
 ; Delete list
 ;   NAME - List Name
DELLST(DATA,NAME) ;EP
 D DEL^XPAR("USR",$$PARAM,$$GETNAME(NAME),.DATA)
 Q
 ; Return parameter name/ien
PARAM(X) Q $S($G(X):$$FIND1^DIC(8989.51,,,$$PARAM),1:"BEHOPTPL PERSONAL LIST")
 ; Return IEN to file 8989.5
GETIEN(NAME) ;
 Q $S(NAME=+NAME:NAME,1:$O(^XTV(8989.5,"AC",$$PARAM(1),+DUZ_";VA(200,",NAME,0)))
 ; Returns instance name for 8989.5 IEN
GETNAME(IEN) ;
 Q $S(IEN=+IEN:$$GET1^DIQ(8989.5,IEN_",",.03),1:IEN)
