BGOVPED2 ; IHS/BAO/TMD - Patient Education ;10-Feb-2011 11:24;DU
 ;;1.1;BGO COMPONENTS;**8**;Mar 20, 2007
 ;---------------------------------------------
 ;  Return IEN of code given the name
 ;  INP = Name of code
 ;RET=IEN of code in patient education file
FIND(RET,INP) ;EP
 N MAJOR,TYPE,CODE,IEN,ABB,LOOKUP
 S MAJOR=$P(INP,"-",1),TYPE=$P(INP,"-",2)
 S CODE=0
 I +MAJOR!($E(MAJOR,1,1)="V") D
 .S CODE=$$LOOK(INP)
 .;Try a second time with upper case
 .I CODE=0 D
 ..S INP=$$UPPER(INP)
 ..S CODE=$$LOOK(INP)
 .I CODE=0 S CODE=$$CREATE(MAJOR,TYPE)
 E  D
 .S MAJOR=$$UPPER(MAJOR)
 .S IEN=$O(^AUTTEDMT("B",MAJOR,"")) Q:IEN=""  D
 ..S ABB=$P($G(^AUTTEDMT(IEN,0)),U,2)
 ..S LOOKUP=ABB_"-"_$$UPPER(TYPE)
 ..S CODE=$$LOOK(LOOKUP)
 ..I CODE=0 D
 ...S LOOKUP=ABB_"-"_TYPE
 ...S CODE=$$LOOK(LOOKUP)
 I CODE=0 D CREATE(MAJOR,$$UPPER(TYPE))
 S RET=CODE
 Q
LOOK(NAME) ;Check for the code
 N EDU,GOOD,IEN
 S GOOD=0,IEN=0
 S EDU="" F  S EDU=$O(^AUTTEDT("B",NAME,EDU)) Q:EDU=""!(+GOOD)  D
 .I $P($G(^AUTTEDT(EDU,0)),U,3)="" S GOOD=1,IEN=EDU
 Q IEN
CREATE(ICD,TOPIC) ;Add this ICD9 related code to the database
 N ED,INP,RET,IEN,DATA,TIEN
 S ED=0,IEN="",TIEN=""
 S INP=ICD_U_"1^^^0"
 D ICDLKUP^BGOICDLK(.RET,INP)
 I '$D(@RET@(1)) Q 0
 S DATA=@RET@(1)
 S IEN=$P(DATA,U,2)
 S TOPIC=$$UPPER(TOPIC)
 S TIEN=$O(^APCDEDCV("B",TOPIC,TIEN))
 I +IEN&(+TIEN) D
 .S INP=IEN_U_TIEN D SETDXTOP^BGOVPED(.RET,INP)
 .S ED=$P(RET,U,1)
 Q ED
UPPER(X) ; Convert lower case X to UPPER CASE
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
