CIAVCXUS ;MSC/IND/DKM - User Context Support ;18-Sep-2007 13:44;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;**1**;Sep 18, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Returns true if user has key
 ; KEY = Security key (or parameter if begins with "@")
 ; USR = IEN of user to check (defaults to current user)
HASKEY(KEY,USR) ;EP
 Q:'$L(KEY) 1
 S USR=$G(USR,DUZ)
 I $E(KEY)="@" D GETPAR^CIAVMRPC(.KEY,$E(KEY,2,999),,,,USR) Q ''KEY
 Q ''$D(^XUSEC(KEY,+USR))
 ; RPC: Check for multiple keys
HASKEYS(DATA,KEYS) ;EP
 N PC
 S DATA=""
 F PC=1:1:$L(KEYS,U) S $P(DATA,U,PC)=$$HASKEY($P(KEYS,U,PC))
 Q
 ; RPC: Retrieve user information for specified USER
 ;  1    2            3              4           5
 ; DUZ^NAME^PTMOUT;STMOUT;CNTDN^COMPOSE MODE^DESIGN MODE
VIMINFO(DATA,USER) ;
 N X
 I $G(USER) N DUZ S DUZ=USER
 S DATA=$P($G(^VA(200,DUZ,0)),U)
 Q:'$L(DATA)
 S DATA=DUZ_U_DATA_U_$$GET^XPAR("ALL","CIAVM PRIMARY TIMEOUT")
 S X=$$GET^XPAR("ALL","CIAVM SECONDARY TIMEOUT")
 S:'X X=$G(DTIME,300)
 S DATA=DATA_";"_X_";"_$$GET^XPAR("ALL","CIAVM COUNTDOWN INTERVAL")
 S DATA=DATA_U_$$HASKEY("CIAV COMPOSE")_U_$$HASKEY("CIAV DESIGN")
 Q
 ; RPC: Returns true if password is valid
VALIDPSW(DATA,PSW) ;EP
 S PSW=$$DECRYP^XUSRB1(PSW)
 S:'$$GET^XPAR("SYS","XU VC CASE SENSITIVE") PSW=$$UP^XLFSTR(PSW)
 S DATA=$$EN^XUSHSH(PSW)=$P($G(^VA(200,+DUZ,.1)),U,2)
 Q
