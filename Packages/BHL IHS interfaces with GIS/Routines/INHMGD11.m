INHMGD11 ;CAR; 10 April 97 11:03;HL7 MESSAGING - PRINT PAGE1(&2)
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME:
 ; HL7 Messaging - Display Header Page (Page: 1 and 2)
 ;
 ; Inputs:
 ; INDA    = D0 in ^INTHL7M(D0,
 ; INMSG0 = is ^INTHL7M(D0,0)
 ; INHDR   = the Header text (ARRAY, call by reference)
 ;
 ; Outputs: NONE
PAGE1(INMSG,INMSG0,INHDR) ;callable routine to print Page 1 & 2.
 ;Provides a brief synopsis of the data contained in ^INTHL7M for
 ;this message.
 ; Inputs:
 ;   INMSG   = the main index (ien) for this message, into ^INTHL7M(INMSG
 ;   INMSG0  = the ^INTHL7M(INDA,0) array.  I assume you already have it
 ;             in local memory.
 ;   INHDR   = the page header array, from HSET^YourRtn.
 ;
 N INDEX,INJ,INK,INL,INMSGT,INX,INY
 ;
 S ING=$G(ING,0)
 I IOM=132 S ING=IOM-12 N IOM S IOM=ING,ING=8
 ;setup for field column (see INHMGD4 for remainder of columns)
 S INS2=$S(IOM>90:58,1:47)+ING ;start of column2
 ;
 ;Write 3 line header, and "***** Message **..."
 D HEADER^INHMGD1
 S DATA="""***** Message ""_$$DASH^INHMGD1(80-16,""*"")"
 D WRITE^INHMGD1
 ;
 S X=INMSG0
 ;Write Message Name and Inactive: YES or NO
 S DATA="$E($P(X,U),1,45),?(80-15+ING),""Inactive: ""_$$YN^INHMGD1($P(X,U,8),1)"
 D WRITE^INHMGD1
 ;
 ;Add message notes from ^INTHL7M(INMSG,3,INDEX,0) word processing field.
 D WRAPWP("^INTHL7M("_INMSG_",3,",.INMSGT,73)
 F INJ=1:1:INMSGT S Y=INMSGT(INJ),DATA="""    ""_Y" D WRITE^INHMGD1
 ;
 ;Event Type and Message Type:
 S DATA="!,?ING+3,""Event Type:"",?ING+15,$E($P(X,U,2),1,20),?ING+41,"
 S DATA=DATA_"""Message Type:"",?ING+56,$E($P(X,U,6),1,3)" D WRITE^INHMGD1
 ;
 ;Sending Application and Receiving Application:
 S X=$G(^INTHL7M(INMSG,7))
 S DATA="?ING+1,""Send Applic.:"",?ING+15,$E($P(X,U),1,25)"
 S DATA=DATA_",?ING+41,""Rec. Applic.:"",?ING+55,$E($P(X,U,3),1,25)"
 D WRITE^INHMGD1
 ;
 ;Sending Facility and Receiving Facility:
 S DATA="?ING+5,""Facility:"",?ING+15,$E($P(X,U,2),1,25),?ING+45,"
 S DATA=DATA_"""Facility:"",?ING+55,$E($P(X,U,4),1,25)" D WRITE^INHMGD1
 ;
 ;Processing ID, HL7 Version and Lookup Parameter:
 S X=INMSG0,Y=$P(X,U,3)
 S INX=$S(Y="P":"PRODUCTION",Y="D":"DEBUG",Y="T":"TRAINING",1:Y)
 S INY=$$LKPRM^INHMGD1($P(X,U,7))
 S DATA="""Processing ID:"",?ING+15,INX"
 S DATA=DATA_",?ING+28,""HL7 Version:"",?ING+41,$E($P(X,U,4),1,5)"
 S DATA=DATA_",?ING+48,""Lookup Parameter:"",?ING+66,INY"
 D WRITE^INHMGD1
 ;
 ;Accept Ack. and Application Ack:
 S Y=$P(X,U,10) ;Accept Ack.
 S INX=$S(Y="AL":"ALWAYS",Y="ER":"ERROR/REJECT",Y="NE":"NEVER",Y="SU":"SUCCESS ONLY",1:Y)
 S Y=$P(X,U,11) ;Application Ack:
 S INY=$S(Y="AL":"ALWAYS",Y="ER":"ERROR/REJECT",Y="NE":"NEVER",Y="SU":"SUCCESS ONLY",1:Y)
 S DATA="?ING+3,""Accept Ack:"",?ING+15,INX,?ING+49,""Application Ack:"",?ING+66,INY"
 D WRITE^INHMGD1
 ;
 ;Root File and Audited?
 S Y=$P(X,U,5)
 S INX=$E($S(Y="":Y,$D(^DIC(Y,0))#2:$P(^DIC(Y,0),U),1:" "_Y),1,40)
 S INY=$$YN^INHMGD1($P(X,U,9),1)
 S DATA="?ING+4,""Root File:"",?ING+15,INX,?ING+57,""Audited:"",?ING+66,INY"
 D WRITE^INHMGD1
 ;
 ;Routine for Lookup/Store:"
 S INY=$G(^INTHL7M(INDA,5)),INX=1,INX(1)=""
 D WRAPS(INY,.INX,IOM-29)
 S DATA="""Routine for Lookup/Store:"",?ING+26,INX(1)" D WRITE^INHMGD1
 I INX>1 F INJ=2:1:INX S DATA="?ING+26,INX(INJ)" D WRITE^INHMGD1
 K INX
 ;
 ;Sort Transaction Types by Name:
 S DATA="""Transaction Types:""" D WRITE^INHMGD1
 S INJ=0  F  S INJ=$O(^INTHL7M(INDA,2,INJ)) Q:'INJ  D
 .;get the pointer to ^INRHT from each node descendendent from 2
 .S INK=+$P($G(^INTHL7M(INDA,2,INJ,0)),U) Q:'INK
 .S INL=$P($G(^INRHT(INK,0)),U) Q:INL=""
 .;save the 1st piece (Transaction Type) in ^INRHT
 .S INX(INL)=""
 S INJ=0 F  S INJ=$O(INX(INJ)) D  Q:INJ=""
 .S DATA="?ING+4,INJ" D WRITE^INHMGD1
 ;
 ;Let's not try to put it all on the first page:
 I IOSL-$Y<10 D HEADER^INHMGD1
 ;
 ;MUMPS Code for Lookup:
 D WRAPWP("^INTHL7M("_INDA_",4,",.INX,IOM-24-3)
 S DATA="""MUMPS Code for Lookup:"",?ING+24,INX(1)" D WRITE^INHMGD1
 I $D(INX(2)) D
 .S INJ=1 F  S INJ=$O(INX(INJ)) Q:'INJ  D
 ..S DATA="?ING+24,INX(INJ)" D WRITE^INHMGD1
 K INX
 ;
 ;Outgoing Initial MUMPS Code:"
 D WRAPWP("^INTHL7M("_INDA_",6,",.INX,IOM-30-3)
 S DATA="""Outgoing Initial MUMPS Code:"",?ING+30,INX(1)" D WRITE^INHMGD1
 I $D(INX(2)) D
 .S INJ=1 F  S INJ=$O(INX(INJ)) Q:'INJ  D
 ..S DATA="?ING+30,INX(INJ)" D WRITE^INHMGD1
 K INX
 ;
 ;Generated Scripts -"
 S DATA="""Generated Scripts -""" D WRITE^INHMGD1
 S INJ=$G(^INTHL7M(INDA,"S"))
 S INK=$P(INJ,U),INL=$P(INJ,U,2),(INX,INY)=""
 I INK S INX=$E($P($G(^INRHS(INK,0)),U),1,60) ;input
 I INL S INY=$E($P($G(^INRHS(INL,0)),U),1,60) ;output
 S DATA="?ING+3,""Input: "",INX"  D WRITE^INHMGD1
 S DATA="?ING+2,""Output: "",INY" D WRITE^INHMGD1
 ;
 Q
WRAPWP(INGN,INO,INW) ;WP wrapping routine, doesn't force wrap if text
 ; will fit on current line.
 ; Inputs:
 ;   INGN  = global name and nodes e.g. "^INTHL7M(12181,3,"
 ;   INO   = name of the output array (call by Reference)
 ;   INW   = width of the output field
 ; Outputs:
 ;   INO   = output array
 ;
 N INA,INDEX
 S INO=1,INO(1)="",INW=$G(INW,35)
 S INDEX=0 F  S INDEX=$O(@(INGN_INDEX_")")) Q:'INDEX  D
 .S INA=$G(@(INGN_INDEX_",0)")),INO(INO)=$G(INO(INO))
 .;add a space if continuing on from a previous line
 .S INA=$S($E(INA)=" "!(INO(INO)=""):INA,1:" "_INA)
 .I $L(INO(INO)_INA)'>INW S INO(INO)=INO(INO)_INA,INO=INO+1 Q
 .D WRAPS(INA,.INO,INW)
 I '$D(INO(INO)) S INO=INO-1
 Q
WRAPS(INA,INO,INW) ;Array Wrapping routine - Completes WRAP.
 ; Inputs:
 ;   INA  = input, a long string.
 ;   INO  = output array (call by reference)
 ;   INW  = desired width of output array
 ; Output:
 ;   INO  = output array
 ;
 N INS
 S INO=$G(INO,1),INO(INO)=$G(INO(INO))_INA
 F  Q:$L(INO(INO))'>INW  D
 .;find a space to break the line
 .F INS=INW:-1:1 Q:$E(INO(INO),INS)=" "
 .S:INS'>1 INS=INW ;if space not found
 .S INO(INO+1)=$E(INO(INO),INS+1,999) ;keep remainder of line
 .S INO(INO)=$E(INO(INO),1,INS),INO=INO+1 ;copy 1st part to output array
 Q
