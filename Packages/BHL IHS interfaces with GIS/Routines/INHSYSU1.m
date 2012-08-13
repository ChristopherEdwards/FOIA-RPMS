INHSYSU1 ;utilities for GIS 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
CMPFLD ;Compile all messages related to field chosen
 N INCMP
 S INCMP=1
 D FLD
 Q
FLD ;Lookup and display all Messages related to selected field
 N Y,DIC
 S DIC="^INTHL7F(",DIC(0)="AEQZ",DIC("A")="Enter Script Generator Field Name: "
 D ^DIC
 Q:Y<0
 D ZIS^INHUT3("PRFLD^INHSYSU1("_+Y_")","INCMP")
 Q
PRFLD(INFLD) ;Print field
 ; Input: INFLD - ien of Script Generator Field
 N INSCR,INMSG,INGALL
 S INSCR=""
 I '$D(INCMP) W !!,"Script Generator Segment"
 F  S INSCR=$O(^INTHL7S("FIELD",INFLD,INSCR)) Q:INSCR=""  D
 .I '$D(INCMP) W !,$P($G(^INTHL7S(INSCR,0)),U),!!,"Script Generator Messages"
 .S INMSG="" F  S INMSG=$O(^INTHL7M("SEG",INSCR,INMSG)) Q:INMSG=""  D
 ..I '$D(INCMP) W !,$P($G(^INTHL7M(INMSG,0)),U)
 ..E  S INMSG(INMSG)=""
 I $G(INCMP) S INMSG="",INGALL=1 F  S (INMSG,Y)=$O(INMSG(INMSG)) Q:'Y  D EN^INHSGZ
 Q
CMPSEG ;Compile all messages related to segment
 N INCMP
 S INCMP=1
 D SEG
 Q
SEG ;Display Script Generator Message pointing to Segment
 N Y,DIC
 S DIC="^INTHL7S(",DIC(0)="AEQZ",DIC("A")="Enter Script Generator Segment Name: "
 D ^DIC
 Q:Y<0
 D ZIS^INHUT3("PRSEG^INHSYSU1("_+Y_")","INCMP")
 Q
PRSEG(INSCR) ;print segment
 ; Input: INSCR - ien of Script generator Message
 N INMSG,INGALL
 S INSCR=+Y
 I '$D(INCMP) W !!,"Script Generator Messages"
 S INMSG="" F  S INMSG=$O(^INTHL7M("SEG",INSCR,INMSG)) Q:INMSG=""  D
 .I '$D(INCMP) W !,$P($G(^INTHL7M(INMSG,0)),U)
 .E  S INMSG(INMSG)=""
 I $G(INCMP) S INMSG="",INGALL=1 F  S (INMSG,Y)=$O(INMSG(INMSG)) Q:'Y  D EN^INHSGZ
 Q
GETMSGF(INFL,INMS,INMSG) ;Get messages related to field
 ; Input: INFL - ien of Script Generator Field
 ; Output INMS - Array of Script Generator Messages
 ; In/Out(opt) INMSG - Array of messages
 N INSCR,INM
 S INSCR=""
 F  S INSCR=$O(^INTHL7S("FIELD",INFL,INSCR)) Q:INSCR=""  D
 .K INMSG(4010,INSCR)
 .S INM="" F  S INM=$O(^INTHL7M("SEG",INSCR,INM)) Q:INM=""  D
 ..S INMS(INM)=$P($G(^INTHL7M(INM,0)),U)
 ..K INMSG(4011,INM)
 Q
GETMSGS(INSG,INMS,INMSG) ;Get messages related to segment
 ; Input: INSG - ien of Script Generator Segment
 ; Output INMS - Array of Script Generator Messages
 ; In/Out(opt) INMSG - Array of messages
 N INM
 S INM="" F  S INM=$O(^INTHL7M("SEG",INSG,INM)) Q:INM=""  D
 .S INMS(INM)=$P($G(^INTHL7M(INM,0)),U)
 .K INMSG(4011,INM)
 Q
GETMSGDT(INM,INMS) ;Get messages related to Data Type
 ; Input: INM - array of Data types
 ; Output INMS - Array of Script Generator Messages
 ;Loop through fields looking for pointers to data type in array
 N INF
 S INF=0 F  S INF=$O(^INTHL7F(INF)) Q:'INF  D
 .I $D(INM(4012.1,+$P($G(^INTHL7F(INF,0)),U,2))) D
 ..D GETMSGF(INF,.INMS)
 ..K INM(4012,INF)
 Q
