INHUVUT2 ; CHEM ; 20 May 99 17:11; Generic TCP/IP socket utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
WAIT(INBPN,HNG,STAT,STOP)       ;Hang function which periodically checks ^INRHB
 ;INPUT:
 ; INBPN=backgound process
 ; HNG=requested hang time
 ; STAT (OPT) = Status message display in second piece of ^INHRB("RUN")
 ;              Default status is "Idle"
 ; STOP = PBR variable will return 0 if time expires
 ;                                 1 if signalled to quit
 ;This function will quit after the requested hang time, or if
 ;the background process is signalled to quit, whichever comes first.
 N BEGIN,DAY,TIME,END,OUT,INHNGCNT
 S BEGIN=$H,DAY=$P(BEGIN,","),TIME=$P(BEGIN,",",2),END=TIME+HNG,OUT=0,INHNGCNT=HNG
 ;If end time falls into tomorrow
 I END'<86400 S DAY=DAY+(END\86400),END=END#86400
 F  D  Q:OUT
 .;Check background process status - lock to flush local bfr
 .L +^INRHB("RUN",INBPN):0
 .I '$D(^INRHB("RUN",INBPN)) L -^INRHB("RUN",INBPN) S OUT=2 Q
 .S $P(^INRHB("RUN",INBPN),U,1,2)=$H_U_$S($D(STAT):STAT,1:"Idle")
 .L -^INRHB("RUN",INBPN)
 .H $S(INHNGCNT<5:INHNGCNT,1:5)  ; 5 sec interval before cking process status
 .;Quit at day's end
 .I $H>DAY S OUT=1 Q
 .;Otherwise quit when time is later than end
 .I $P($H,",",2)'<END S OUT=1 Q
 .; Check if hang counter has expired - avoid 0/negative hang time
 .S INHNGCNT=INHNGCNT-5 I INHNGCNT<1 S OUT=1 Q
 S STOP=OUT=2
 Q
ADDR(INBPN,INIPADIE,INERR) ;Get next IP address from Background Proc file
 ;INPUT:
 ;  INBPN=background procese ien
 ;  INIPADIE - last ien in IP Address multiple checked (pass by ref.)
 ;OUTPUT
 ;  INIPADIE - last ien checked in IP ADDRESS multiple
 ;  function value - IP address or 0 if not found
 ;
 N %
 D:$G(INDEBUG) LOG^INHVCRA1("Getting next IP address",5)
 I '$O(^INTHPC(INBPN,6,0)) S INERR="No ports designated" Q ""
 S INIPADIE=$O(^INTHPC(INBPN,6,INIPADIE)) Q:'INIPADIE ""
 S %=$P($G(^INTHPC(INBPN,6,INIPADIE,0)),U,1) Q:$L(%) %
 Q 0
 ;
CPORT(INBPN,INIPADIE,INIPPOIE) ;Get next client port from Background Proc. file
 ;INPUT:
 ;  INBPN - background process
 ;  INIPADIE - last ien in IP Address multiple checked
 ;  INIPPOIE - last port tried at address (pass by ref.)
 ;OUTPUT:
 ;  INIPPOIE - last ient checked in IP PORT multiple
 ;  function value = Port Number or null if not found
 ;
 N %
 ;Check for next port
 D:$G(INDEBUG) LOG^INHVCRA1("Checking for next port",5)
 S INIPPOIE=$O(^INTHPC(INBPN,6,INIPADIE,1,INIPPOIE)) Q:'INIPPOIE ""
 S %=$P($G(^INTHPC(INBPN,6,INIPADIE,1,INIPPOIE,0)),U,1) Q:$L(%) %
 Q ""
 ;
SPORT(INBPN,INIPADIE,INERR) ;Get next server port from Background Prc. file
 ;INPUT:
 ;  INBPN - background process
 ;  INIPADIE - last ien in port multiple checked (Pass by ref)
 ;  INERR - error variable (PBR)
 ;OUTPUT:
 ;  function value - Port Number
 ;
 N INIPORT
 ;Check for next port
 D:$G(INDEBUG) LOG^INHVCRA1("Checking for next server port",5)
 I '$O(^INTHPC(INBPN,5,0)) S INERR="No ports designated" Q ""
 S INIPADIE=$O(^INTHPC(INBPN,5,INIPADIE)) Q:'INIPADIE ""
 S INIPORT=$P(^INTHPC(INBPN,5,INIPADIE,0),U) Q:'INIPORT ""
 Q INIPORT
 ;
OPEN(INBPN,INCHNL,INERR,INMEM) ;Open socket for destination
 ;INPUT:
 ; INBPN = background process file
 ; INCHNL=channel opened (1st param)
 ; INMEM=memory location (2nd)
 ; INERR=error array
 ;
 ;OUTPUT:
 ; 1 if successful, 0 if not
 ;Initialize variables
 N INIPADIE,INIPAD,INIPPOIE,CLISRV,DOMN,INIPORT,INDONE
 S (INIPADIE,INIPAD,INDONE,INCHNL)=0
 ;Determine if socket is to be opened as client (0=default) or as server
 S CLISRV=+$P(^INTHPC(INBPN,0),U,8)
 ;If server
 I CLISRV D  Q $S(INCHNL:1,1:0)
 .;Get port
 .F  D  Q:INDONE!'$D(^INRHB("RUN",INBPN))
 ..S INIPORT=$$SPORT(INBPN,.INIPADIE,.INERR) I 'INIPORT S INDONE=1 Q
 ..;Attempt to create an internet socket
 ..D:$G(INDEBUG) LOG^INHVCRA1("Attempt to create an internet socket for "_INBPN,3)
 ..D OPEN^%INET(.INCHNL,.INMEM,"",INIPORT,1)
 ..;Check for success
 ..S:INCHNL INDONE=1 Q
 .I 'INCHNL,$L(INCHNL),'$L($G(INERR)) S INERR=INCHNL
 .D:$G(INDEBUG) LOG^INHVCRA1($S(INCHNL:"Socket created on port "_INIPORT,1:INERR),3)
 ;If client
 F  D  Q:INDONE!'$D(^INRHB("RUN",INBPN))
 .  ;Get domain name/internet address until no more entries in multiple
 .  S DOMN=$$ADDR(INBPN,.INIPADIE,.INERR) I 'INIPADIE S INDONE=1 Q
 .  ;look through port multiple until port is opened or no more ports
 .  S INIPPOIE=0 F  D  Q:INDONE!'$D(^INRHB("RUN",INBPN))
 ..   ;Get next port for address - quit if none left
 ..   S INIPORT=$$CPORT(INBPN,INIPADIE,.INIPPOIE) I 'INIPORT S INDONE=1 Q
 ..   ;Attempt to create an internet socket
 ..   D:$G(INDEBUG) LOG^INHVCRA1("Attempting to create a socket for "_DOMN_" on "_INIPORT,4)
 ..   D OPEN^%INET(.INCHNL,.INMEM,.DOMN,INIPORT,1)
 ..   ;Check for success
 ..   S:INCHNL INDONE=1
 I 'INCHNL,$L(INCHNL),'$L($G(INERR)) S INERR=INCHNL
 D:$G(INDEBUG) LOG^INHVCRA1($S(INCHNL:"Socket created for "_DOMN_" on "_INIPORT,1:INERR),3)
 Q $S(INCHNL:1,1:0)
