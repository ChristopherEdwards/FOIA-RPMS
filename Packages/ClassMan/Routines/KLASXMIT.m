KLASXMIT ;RTM;MSM CPU<->CPU TRANSMIT; [ 08/12/92  3:25 PM ]
 ; COPYRIGHT MICRONETICS DESIGN CORP. @1985
 ; If you need to send $C(1) or $C(2) through as data,
 ; pick another character and change the line INIT+1.
 ; %HT = wait time for READs (0 or 1)
 ; %DT = # of READs from IO device since last terminal read
 ; %DC = # iterations thru fast loop with no data received
 ; %RS = 1 if recording, 0 if not
 S %INT=0 K %MSM ; $D(%MSM) flag for calling from %TRANS
 S $ZT="ERROR^%XMIT"
GO S %HT=0,%DT=0,%DC=0,%RS=0 G:%INT INIT
 W !?10,$P($P($ZV,","),"-")," - Transmission Utility"
ASK R !!,"I/O PORT? > ",%IO G:%IO="" EXIT G:%IO?1"^".E EXIT I %IO?1"?".E D QUE G ASK
 I $I=%IO!'%IO W !!,"Cannot select your own device.",*7 G ASK
 S $ZT="NOPEN^%XMIT"
 B 1 O %IO::0 E  W *7,"..line in use..waiting.." O %IO W "ready"
 S $ZT="ERROR^%XMIT"
 U %IO I $ZB($ZA,2,1) U 0 W !,"Device ",%IO," is an output only device.",*7 G ASK
INIT U 0 S %ESC=$ZB($ZA,64,1) ; save escape processing status
 S %EXIT=$C(1),%RECORD=$C(2)
 ; Turn off pass-all, esc processing, & tab control. Set terminators
OPEN U %IO:(0::::#001001:#800040:::$C(3,8,13,21,24,27,127))
 U 0:(0::::#000001:#800040:::$C(3,8,13,15,18,21,24,27,127)) W !
TERM ;
 U 0 R %X:%HT
 S %CR=$ZB ; get READ terminator
 G:$E(%X)=%EXIT EXIT D:$E(%X)=%RECORD
 .D @$S(%RS:"HALT",1:"RECORD") S %X=$E(%X,2,$L(%X)) Q
 U %IO W:$L(%X) %X W:$T $C(%CR) S:$L(%X)!$T %DC=0,%HT=0 S %DT=0
PORT ;
 U %IO R %Y:%HT G:%INT&(%Y=$C(1)) EXIT S %CR=$ZB U 0 W:$L(%Y) %Y W:$T $C(%CR) S:$L(%Y)!$T %DC=0,%HT=0,%DT=%DT+1
 S:$L(%Y)&%RS %XS=%XS_%Y I $T,%RS S ^XMIT(%XN,%XE)=%XS,%XE=%XE+1,%XS=""
PORT1 I %DT>20 G TERM ; heavy incoming data, force check of CRT
 G TERM:$L(%X),PORT:$L(%Y)
 S %DC=%DC+1 G:%DC<500 TERM S %HT=1 ; READ timeout 1, goto slow mode
TERMWAIT ; TERMWAIT and PORTWAIT handle periods in which no data has been
 ; received from either side for %DC iterations through the
 ; TERM & PORT loop.
 U 0 R %X#1:%HT E  G PORTWAIT
 G:%X=%EXIT EXIT
 I %X=%RECORD D @$S(%RS:"HALT",1:"RECORD") S (%DC,%DT,%HT)=0 G TERM
 S %CR=$ZB
 U %IO W %X W:'$L(%X) $C(%CR) S (%DC,%DT,%HT)=0 G TERM
PORTWAIT ;
 U %IO R %Y#1:%HT E  G TERMWAIT
 G:%INT&(%Y=%EXIT) EXIT ; %TRANS rtn or gbl selection finished
 S %CR=$ZB
 U 0 W %Y W:'$L(%Y) $C(%CR) S (%DC,%DT,%HT)=0
 ; If recording...
 S:$L(%Y)&%RS %XS=%XS_%Y ; add to captured string
 ; or terminate & file captured string
 I '$L(%Y),%RS S ^XMIT(%XN,%XE)=%XS,%XE=%XE+1,%XS=""
 G PORT
EXIT ;
 D:%RS HALT I $D(%ESC),%ESC U 0:(::::64)
 K %ESC,%X,%Y,%RS,%XN,%XE,%XS,%DC,%DT,%HT,%CR,%EXIT,%RECORD
 U:(%IO?.N)&(%IO'="") %IO:(:::::#001001:::$C(13,27))
 U 0:(:::::#000001:::$C(13,27))
 I %INT!$D(%MSM) B 1 K %INT Q  ; return to %TRANS
 I %IO?.N&(%IO'="") C %IO U 0 K %IO,%INT
 W:'$F($ZE,"<DSCON>") !,"Transmission Complete",!!
 Q
RECORD ;
 S:'$D(^XMIT) ^XMIT(0)=1
 S %XN=^XMIT(0),^XMIT(0)=%XN+1,%RS=1,%XS="",%XE=1,%X=$E(%X,2,999),^XMIT(%XN)=$H
 U 0 W !!,"Recording Started in ^XMIT(",%XN,",1)",!
 Q
HALT ;
 S:$L(%XS) ^XMIT(%XN,%XE)=%XS S %RS=0
 U 0 W !!,"Recording halted, last node is ^XMIT(",%XN,",",%XE,")",!!
 Q
NOPEN S %IO="" ; avoid <NOPEN> on <INRPT>
ERROR ;
 I $F($ZE,"<MXSTR>") F %XE=%XE:1 G:%XS="" ERROR1 S ^XMIT(%XN,%XE)=$E(%XS,1,255),%XS=$E(%XS,256,9999)
 I $F($ZE,"<INRPT>") U 0 W !!,"...Aborted." D EXIT V 0:$J:$ZB($V(0,$J,2),#0400,7):2
 I $F($ZE,"<DSCON>") DO:$I'=$P  D EXIT V 0:$J:$ZB($V(0,$J,2),#0400,7):2
 .U 0 W !!,"...Disconnected."
 ZQ
ERROR1 S $ZT="ERROR^%XMIT" G PORT1 ; resume after <MXSTR>
INT ;FROM TRANSFER UTILS
 S %INT=1 B 0 G GO
 ;
QUE W !! F %IO=1:1 S %X=$T(TEXT+%IO) Q:%X=""  W $P(%X,";",2),!
 Q
TEXT ;
 ;Enter the port number to be used for the transmission.
 ;While the transmission is in progress, all characters except CTRL/A
 ;and CTRL/B will be passed through to the port.
 ;Use CTRL/B to start or stop recording of the information in the XMIT
 ;global, and CTRL/A to exit the program.
