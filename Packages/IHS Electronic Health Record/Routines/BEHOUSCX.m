BEHOUSCX ;MSC/IND/DKM - User Context Support ;02-Nov-2009 10:27;PLS
 ;;1.1;BEH COMPONENTS;**006002**;Sep 18, 2007
 ;=================================================================
 ; Retrieve user information for specified USER
 ;  1   2      3      4         5         6        7             8             9     10
 ; DUZ^NAME^USRCLS^CANSIGN^ISPROVIDER^ORDERROLE^NOORDER^PTMOUT;STMOUT;CNTDN^SRVIEN^SRVNAME
USERINFO(DATA,USER) ;
 N X
 I +$G(USER) N DUZ D DUZ^XUP(USER)
 S DATA=$P($G(^VA(200,DUZ,0)),U)
 Q:'$L(DATA)
 S DATA=DUZ_U_DATA
 S $P(DATA,U,3)=$S($$HASKEY("ORES"):3,$$HASKEY("ORELSE"):2,$$HASKEY("OREMAS"):1,1:0)
 S $P(DATA,U,4)=$$HASKEY("ORES")&$$ISPROV
 S $P(DATA,U,5)=$$ISPROV
 S $P(DATA,U,6)=$$ORDROLE
 S $P(DATA,U,7)=$$GET^XPAR("ALL","ORWOR DISABLE ORDERING")
 S $P(DATA,U,8)=$$GET^XPAR("ALL","CIAVM PRIMARY TIMEOUT")
 S X=$$GET^XPAR("ALL","CIAVM SECONDARY TIMEOUT")
 S:'X X=$G(DTIME,300)
 S DATA=DATA_";"_X_";"_$$GET^XPAR("ALL","CIAVM COUNTDOWN INTERVAL")
 S $P(DATA,U,9)=+$G(^VA(200,DUZ,5))
 S $P(DATA,U,10)=$$GET1^DIQ(49,+$P(DATA,U,10),.01)
 Q
 ; Returns the role a person takes in ordering
 ;   0=nokey, 1=clerk, 2=nurse, 3=physician, 4=student, 5=bad keys
ORDROLE() ;EP
 Q:$$HASKEY("OREMAS")+$$HASKEY("ORELSE")+$$HASKEY("ORES")>1 5
 Q:$$HASKEY("OREMAS") 1
 Q:$$HASKEY("ORELSE") 2
 Q:$$HASKEY("ORES")&$$ISPROV 3
 Q:$$ISPROV 4
 Q 0
 ; Returns true if user is a provider
ISPROV() ;EP
 Q $$HASKEY("PROVIDER")
 ; Returns true if user has key
 ; KEY = Security key (or parameter if begins with "@")
 ; USR = IEN of user to check (defaults to current user)
HASKEY(KEY,USR) ;PEP - Does user have key?
 Q:'$L(KEY) 1
 S USR=$G(USR,DUZ)
 I $E(KEY)="@" D GETPAR^CIAVMRPC(.KEY,$E(KEY,2,999),,,,USR) Q ''KEY
 Q ''$D(^XUSEC(KEY,+USR))
 ; Check for multiple keys
HASKEYS(DATA,KEYS,USR) ;
 N PC
 S DATA=""
 F PC=1:1:$L(KEYS,U) S $P(DATA,U,PC)=$$HASKEY($P(KEYS,U,PC),.USR)
 Q
 ; Return a set of names from the NEW PERSON file
NEWPERS(DATA,FROM,DIR,KEY,DATE,FLT,CNT) ;
 ; .DATA=returned list
 ;  FROM=text to $O from
 ;  DIR=$O direction,
 ;  KEY=screen users by security key (optional)
 ;  DATE=checks for an active person class on this date (optional)
 ;  FLT=any of: A=Active only, D=Current division only
 ;  CNT=maximum # to return (defaults to 44)
 N I,IEN
 S I=0,CNT=$S($G(CNT)>0:+CNT,1:44),KEY=$G(KEY),DATE=$G(DATE),FLT=$G(FLT,"AD")
 S:FLT FLT="A"                                                         ; Backward compatibility
 I DATE,DATE'=+DATE S DATE=$$DT^CIAU(DATE) Q:DATE<0
 F  S FROM=$O(^VA(200,"B",FROM),DIR),IEN=0 Q:FROM=""  D  Q:I'<CNT
 .F  S IEN=$O(^VA(200,"B",FROM,IEN)) Q:'IEN  D
 ..Q:IEN<1
 ..Q:'$$HASKEY(KEY,IEN)
 ..I FLT["A",'$$ACTIVE(IEN,DATE) Q                                     ; terminated user
 ..I FLT["D",'$$INDIV(IEN) Q
 ..S I=I+1,DATA(I)=IEN_U_FROM
 Q
 ; Return true if user was active on/before given date
 ;   IEN = User IEN
 ;   DAT = Date constraint
ACTIVE(IEN,DAT) ;PEP - User active?
 N X
 I $G(DAT) N DT S DT=DAT\1
 S X=$$ACTIVE^XUSER(IEN)
 Q $S(X:+X,1:X=0)
 ; Returns true if user in specified division
 ; For users not assigned to any divisions, always returns true
 ;   IEN = User IEN (defaults to DUZ)
 ;   DIV = Division constraint (defaults to current division)
INDIV(IEN,DIV) ;
 N RTN
 S:'$G(IEN) IEN=DUZ
 S:'$D(DIV) DIV=DUZ(2)
 Q $S('$$DIV4^XUSER(.RTN,IEN):1,1:$D(RTN(DIV)))
 ; Returns true if valid electronic signature
VALIDSIG(DATA,ESIG) ;
 N X
 S X=$$DECRYP^XUSRB1(ESIG)
 D HASH^XUSHSHP
 S DATA=X=$P($G(^VA(200,+DUZ,20)),U,4)
 Q
 ; Returns true if electronic signature code passes input transform
VALINSIG(DATA,ESIG) ;
 N X
 S DATA=1
 S X=$$DECRYP^XUSRB1(ESIG)
 I $L(X)>20!($L(X)<6) S DATA="-1^Length must be between 6 and 20 characters." Q
 I X'?.UNP S DATA="-2^Signature code can only contain uppercase letters, punctuation or numbers." Q
 Q
STORESIG(DATA,ESIG) ;
 N X,LP,DA
 S DA=DUZ
 S DATA=0
 S X=$$DECRYP^XUSRB1(ESIG)
 D HASH^XUSHSHP  ;returns hashed value in X
 L +^VA(200,DUZ):5
 E  S DATA="-1^Unable to obtain lock on New Person File." Q
 S $P(^VA(200,DUZ,20),U,4)=X
 S LP=0 F  S LP=$O(^DD(200,20.4,1,LP)) Q:'LP  X ^(LP,1)  ; Fire DD Triggers
 L -^VA(200,DUZ)
 Q
 ; Returns true if user has electronic signature code
HASESIG(DATA) ;EP
 S DATA=$L($P($G(^VA(200,DUZ,20)),U,4))>0
 Q
 ; Returns true if password is valid
VALIDPSW(DATA,PSW) ;
 S DATA=$$EN^XUSHSH($$UP^XLFSTR($$DECRYP^XUSRB1(PSW)))=$P($G(^VA(200,+DUZ,.1)),U,2)
 Q
 ; Returns true if File Manager Access Code field contains code
 ; If user has the '@' code, returns true regardless
HASFMCD(DATA,CODE) ;
 S DATA=$G(DUZ(0))["@"!($G(DUZ(0))[CODE)
 Q
