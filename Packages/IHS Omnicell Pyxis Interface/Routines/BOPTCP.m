BOPTCP ;IHS/ILC/ALG/CIA/PLS - TCP/IP Send/Receive Utility;03-Feb-2006 10:58;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1**;Jul 26, 2005
 ;;
 ;
 ; NOTE!  This routine may be saved under a different name.  If this is
 ;        done, be sure to edit the first line of the routine and the
 ;        name of the routine in the EOR line
 ;
 ; NOTE!  Normally, transmissions are ended with a sequence of control
 ;        characters such as ASCII 13,11,13 or 27,27,27.  No such
 ;        end-of-transmit characters are used during the sending of
 ;        data.  If any such characters are
 ;        returned, they are not checked for.  PLEASE be sure
 ;        to add them.  (Data sent to in SDATA and data
 ;        received in DATA subroutines.)
 ;
 ; Replaceable parameters that will need to be replaced are
 ; the following:
 ;
 ; Subroutine:  IP (To IP address
 ; Subroutine:  SOCKET (To Socket#)
 ;
 ; Or
 ;
 ; Change these subroutines to call a file or table (which is probably
 ; better than hardsetting the values.)
 ;
 ;
 ; EXPLANATION:
 ;
 ; Then EN call point will transmit to IP/Socket the data contained in
 ; the INPUT array.  Data returned will be returned
 ; in the OUTPUT array.
 ;
 ;
 ; EXAMPLE:
 ;
 ; TRANS(1)="MSH|^~\&|..."       <- message carries over into TRANS(2)
 ; TRANS(2)="...MSA|... etc, etc"
 ;
 ; S A7RERR=$$EN^BOPTCP("TRANS","RESULTS")
 ;
 ; W A7RERR   -> will be = zero if ALL goes well, or -1^... if not
 ;
 ; If the above call works, the response will be in
 ; the RESULTS array.  Something line this...
 ;
 ; RESULTS(1)="MSH|^~\&|..."   <- the response message
 ; RESULTS(2)="... etc, etc"
 ;
EN(INPUT,OUTPUT) ;Call to do direct connect to MPI
 N I,LOOP,LP,POP,X,XCS,XCSDAT,XCSER,XCSEXIT,XCSMD,XCSNT,XCSTIME
 N XCSTRACE,Y
 ;
 D SETUP
 ;
 ;IHS exemption approved on March 16, 2005
 I XCSNT N $ESTACK,$ETRAP S $ETRAP="D ERROR^BOPTCP"
 E  S X="ERROR^BOPTCP",@^%ZOSF("TRAP")
 ;
 D OPEN I POP QUIT $$ERR("POP=1 ON OPEN") ;->
 D DATA
 D GET
 D QUIT
 ;
 Q 0 ;#errors = 0
 ;
ERR(REA) ;Report back an error
 D TRACE("ERROR "_XCS("STAT"))
 D:'POP QUIT
 Q "-1^"_REA
 ;
ERROR ;Trap an error
 D ^%ZTER G UNWIND^%ZTER
 ;
OPEN ;Open connection
 D TRACE("Make Connection")
 D CALL^%ZISTCP(BOPIP,BOPOCK) Q:POP
 D TRACE("Got Connection")
 U IO
 Q
DATA ;Send data
 D TRACE("Send Data")
 D SDATA(INPUT,$G(TYPE,"MPI")) ;LJA
 Q
 ;
GET ;Get responce
 D GDATA(OUTPUT)
 Q
QUIT ;Shut down
 D CLOSE^%ZISTCP
 Q
TRACE(S1) ;
 Q:0  N %,H
 I S1=-1 K ^TMP($J,"ZZXCSA") Q
 S H=$P($H,",",2),H=(H\3600)_":"_(H#3600\60)_":"_(H#60)_" "
 L +^TMP($J,"ZZXCSA"):1
 S %=$G(^TMP($J,"ZZXCSA",0))+1,^(0)=%,^(%)=H_XCSTRACE_S1
 L -^TMP($J,"ZZXCSA")
 Q
SETUP ;EP - SET UP INFO
 S XCS("IP")=BOPIP,XCS("SOCK")=BOPOCK
 S (XCS("STAT"),XCSEXIT)=0,XCSTIME=30,XCSTRACE="C: "
 S XCSNT=$$NEWERR^%ZTER()
 D TRACE(-1),TRACE("Client Setup")
 Q
GDATA(ROOT,STAT) ;EP - get Data
 N E,I,M
 ;
 ;  changed read timeout to 2 from 5 dtg
 S BOPCHKA="" F  U IO R RESTRNG#200:3 Q:RESTRNG=""&'$T  D  Q:BOPCHKA  ;
 .; set quit flag if ascii 28 contained
 .I RESTRNG[$C(28) S BOPCHKA=1
 .;
 .;Strip Control Characters from END of received string
 .F  Q:RESTRNG'?.E1C  S RESTRNG=$E(RESTRNG,1,$L(RESTRNG)-1)
 .;
 .S BOPK=2
MORE .S BOPTRNG=$P(RESTRNG,$C(11),BOPK)
 .Q:BOPTRNG']""
 .F BOPI=1:1 S BOPLINE=$P(BOPTRNG,$C(13),BOPI) Q:BOPLINE']""!(BOPLINE=$C(28))  D
 ..S I=$O(@ROOT@(":"),-1)+1,@ROOT@(I)=BOPLINE
 .S BOPK=BOPK+1
 .G MORE
 ;
 Q
 ;
SDATA(ROOT,TYPE) ;EP - Send data from a source
 N X,Y,L,D
 S X=ROOT
 F  S X=$Q(@X) Q:X']""!(X'[ROOT)  D
 .U IO W @X,!
 ;
 D ENDCHARS
 Q
 ;
ENDCHARS ; Add EOT ctrl characters, etc, below... LJA
 Q
 ;
 ; If end of transmission characters needed, add here...
 ;
IP() ; Substitute IP ADDRESS...
 Q $P(^BOP(90355,1,0),U,17)
 ;
SOCKET() ; Substitute SOCKET...
 Q $P(^BOP(90355,1,0),U,18)
