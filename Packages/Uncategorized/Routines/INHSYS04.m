INHSYS04 ;slt,JPD; 31 Jan 96 15:58;System Configuration data utility
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
 ;
RTNBFR(%TT,INROU) ;routine buffer/builder machine
 ;input:
 ;  %TT   --> (required) Transaction Type ien used to uniquely id TT
 ;output:
 ;  INROU --> array of compiled routines in the IB* name-space.
 ;            format: INROU(routine name)=""
 ;local:
 ;  %RTN  --> routine root name to build
 ;  %NODE --> global node result of $Q
 ;  %DATA --> string of data
 ;  INMAX --> maximum allowable routine source size
 ;  INOS  --> operating system ien
 ;  INZI  --> code to insert line into the routine directory
 ;  %ODD  --> odd numbered offset
 ;  %EVEN --> even numbered offset
 ;
 N %CC,%LC,INMAX,INOS,INZI,%RTN,%NODE,%DATA,%T,%RTNBFR,%ODD,%EVEN,%RC
 K ^UTILITY($J,0)
 S INMAX=^DD("ROU"),INOS=^("OS"),INZI=^("OS",INOS,"ZS")
 S %CC=INMAX*2,%LC=0,%RC="00",%RTN="IB"_$$ID(%TT),%NODE="^UTILITY($J)"
 I %RTN="IB" W !,"The UNIQUE IDENTIFIER for this INTERFACE TRANSACTION TYPE does not exist!","Aborting!" K ^UTILITY($J) S INPOP=1 Q
 S %RTNBFR="^UTILITY(""""INHSYS"""","
 F  S %NODE=$Q(@%NODE) Q:$$QS^INHUTIL(%NODE,1)'=$J  D
 .S %DATA=@%NODE
 .I %CC+$L(%DATA)+$L(%NODE)'<INMAX D NEWR
 .D LN(" ;;"_%NODE,.%CC,.%LC)
 .D LN(" ;;"_%DATA,.%CC,.%LC)
 I $O(^UTILITY($J,0,0)) D
 .D LN(" Q",.%CC,.%LC) S X=%RTN_$S($L(%RC)=1:"0"_%RC,1:%RC) X INZI W !,X_" filed." S INROU(X)=""
 .K ^UTILITY($J,0)
 K ^UTILITY($J)
 Q
NEWR ; Current routine will be too big so finish
 ; current routine and start new one
 I $O(^UTILITY($J,0,0)) D
 .S X=%RTN_$S($L(%RC)=1:"0"_%RC,1:%RC)
 .D LN(" Q",.%CC,.%LC)
 .X INZI W X_" filed.",! S INROU(X)=""
 .K ^UTILITY($J,0)
 S %CC=0,%RC=$$HEXUP(%RC),%LC=0
 S %T=%RTN_$S($L(%RC)=1:"0"_%RC,1:%RC)_" ;"_$$INITIALS^INHUT5($P($G(^DIC(3,DUZ,0)),U))_";"_$$DATIM^INHUT5()_";compiled gis system data"
 D LN(%T,.%CC,.%LC),LN(" ;;V1; "_$$DATIM^INHUT5(),.%CC,.%LC)
 D LN(" ;COPYRIGHT "_(1700+$E(DT,1,3))_" SAIC",.%CC,.%LC)
 D LN(" ;"_$P($G(^INRHT(%TT,0)),U),.%CC,.%LC)
 D LN(" ;Compiled by: "_$P($G(^DIC(3,DUZ,0)),U),.%CC,.%LC),LN(" Q",.%CC,.%LC)
 D LN(" ;",.%CC,.%LC)
 D LN("EN F I=1:2 S %ODD=$E($T(EN+I),4,999) Q:%ODD=""""  S %EVEN=$E($T(EN+(I+1)),4,999) S X="""_%RTNBFR_"""_$J_"",""_$P(%ODD,"","",2,99),@X=%EVEN",.%CC,.%LC)
 Q
 ;
HEXUP(%H) ;hexidecimal increment
 ;input:
 ;  %H --> hexidecimal number
 ;output:
 ;  %Y --> %H+1
 ;local:
 ;  SUM  --> result of addition
 ;  %HEX --> 1. string of valid hexidecimal characters
 ;           2. array of parsed hexidecimal characters converted into
 ;              equivalent decimal values i.e HEX(1)=15
 ;  
 N I,SUM,%HEX,DIVIDEND,DIVISOR,REMAIN,QUOTIENT,%Y,J,%LEN
 S %HEX="0123456789ABCDEF",%LEN=$L(%H)
 F I=%LEN-1:-1:0 S %HEX(I)=$F(%HEX,$E(%H))-2,%H=$E(%H,2,%LEN)
 ;convert hexidecimal to decimal
 S J="",SUM=0
 F  S J=$O(%HEX(J),-1) Q:J=""  S SUM=SUM+(%HEX(J)*$$POW(16,J))
 ;increment number
 S SUM=SUM+1
 ;convert decimal to hexidecimal
 S DIVIDEND=SUM,DIVISOR=16,REMAIN=0
 F I=1:1 D  Q:'QUOTIENT
 .S QUOTIENT=DIVIDEND\DIVISOR
 .S REMAIN(I)=$E(%HEX,DIVIDEND#DIVISOR+1)
 .S DIVIDEND=QUOTIENT
 ;rebuild number
 S (J,%Y)=""
 F  S J=$O(REMAIN(J),-1) Q:'J  S %Y=%Y_REMAIN(J)
 Q %Y
 ;
POW(X,N) ;power function where X is raised to the Nth power
 ;input:
 ;  X --> base
 ;  N --> exponent
 ;output:
 ;  POW --> the result of the Nth power of X
 ;
 N POW
 I 'N S POW=1
 E  S POW=X*$$POW(X,N-1)
 Q POW
 ;
ID(X) ;fetch unique identifier for transaction type in X
 ; Input: X - Transaction Type
 ; Returns: UNIQUE IDENTIFIER
 ;          If the UNIQUE IDENTIFIER is NULL, this should
 ;          denote an error condition
 Q $P(^INRHT(X,0),U,4)
 ;
NTRNL(INROU,X) ;procedure to compile internal installation driver
 ;input:
 ;  INROU --> array of compiled data routines
 ;  X     --> driver name
 ;local:
 ;  %CC   --> character counter
 ;  %LC   --> routine line counter
 ;  INOS  --> ien of current operating system
 ;  INZI  --> routine insert execute logic
 ;
 N %CC,%LC,INRTN,INOS,INZI
 S INOS=^DD("OS"),INZI=^("OS",INOS,"ZS")
 D LN(X_" ;"_$$INITIALS^INHUT5($P($G(^DIC(3,DUZ,0)),U))_";"_$$DATIM^INHUT5()_";gis system configuration installation",.%CC,.%LC)
 D LN(" ;;V1; "_$$DATIM^INHUT5(),.%CC,.%LC)
 D LN(" ;COPYRIGHT "_(1700+$E(DT,1,3))_" SAIC",.%CC,.%LC)
 D LN(" ;"_$P($G(^INRHT(+$O(^INRHT("ID",$E(X,3,6),"")),0)),U),.%CC,.%LC)
 D LN(" ;Compiled by: "_$P($G(^DIC(3,DUZ,0)),U),.%CC,.%LC)
 D LN(" Q",.%CC,.%LC),LN(" ;",.%CC,.%LC)
 D LN("EN ;entry point",.%CC,.%LC)
 S INRTN=""
 F  S INRTN=$O(INROU(INRTN)) Q:INRTN=""  D LN(" D EN^"_INRTN,.%CC,.%LC)
 D LN(" Q",.%CC,.%LC) X INZI W !,X," internal driver filed.",!
 K ^UTILITY($J,0)
 Q
 ;
LN(%X,%CC,%LC) ;insert a line into routine buffer ^UTILITY($J,0,n)
 ;input:
 ;  %X   --> line of text to store
 ;  %CC  --> character counter
 ;  %LC  --> line counter
 ;
 S %CC=$G(%CC)+$L($G(%X)),%LC=$G(%LC)+1
 S ^UTILITY($J,0,%LC)=$G(%X)
 Q
 ;
RTNINB(X) ;WOM 8/8/95
 ;Return the "IBvxxx" based on transaction name
 ;Return NULL if not found
 ;Note: If the UNIQUE IDENTIFIER of the INTERFACE TRANSACTION
 ;      TYPE is invalid, $$ID will return NULL which will
 ;      cause this function to return "IB" which should denote
 ;      an error condition
 ;INPUT: X = TRANSACTION NAME, i.e., the 01 field
 N DIC,Y S DIC="^INRHT(",DIC(0)="X" D ^DIC
 Q $S(Y=""!(Y<0):"",1:"IB"_$$ID(+Y))
