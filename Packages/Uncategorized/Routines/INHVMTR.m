INHVMTR ; DGH,FRW ; 06 Aug 1999 14:44:52; MHCMIS background processor
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;Modified 5/13/98 to suport multiple MHCMIS/CEIS systems.
 ;This is a background process to write interface messages to
 ;VMS files. It combines elements of the generic background
 ;processor ^INHVTAPT with the Ver 3.0 MHCMIS transmitter, ^INHVMTR
 ;INPUT:
 ; INBPN = Background processor
 ;KEY VARIABLES:
 ; INENDTM = $H time a VMS file should close, or 0 if no file is open
 ;
EN ;Main starting point
 N DT,INENDTM,ER,I,INDSTR,INIP,INQP,INQT,INUIF,LCT,LINE,INOK,SYSTEM,X,XXDFN,XXDTRDA,INFILOPN,INRUN,WAIT,INPNAME,INCEIS,XXNO
 ;Start GIS Background process audit if flag is set in Site Parms File
 S INPNAME=$P(^INTHPC(INBPN,0),U) D AUDCHK^XUSAUD D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME)
 S X="ERR^INHVMTR",@^%ZOSF("TRAP")
 S SYSTEM="SC",INDSTR=+$P(^INTHPC(INBPN,0),U,7) I 'INDSTR D ENR^INHE("MHCMIS - No destination designated for background process "_INBPN) G EXIT
 G:'$D(^INRHB("RUN",INBPN)) EXIT S ^INRHB("RUN",INBPN)=$H_U_"Starting"
 ; intialize variables from background process file
 D INIT^INHUVUT(INBPN,.INIP)
 ;Get variables from MHCMIS SITE PARAMETER FILE based on match between
 ;the numbers embedded in the .01 fields of ^INRHD and ^XXDBE
 S XXNO=$$MHC^INHUT2($P(^INRHD(INDSTR,0),U)) D
 .;Default to ien=1
 .I +XXNO<2 S INCEIS=1 Q
 .;Otherwise find the entry that contains the same numeric value
 .N OUT,IEN,X S OUT=0,IEN=1 F  S IEN=$O(^XXDBE(30203,IEN)) Q:'IEN!OUT  D
 ..S X=$$MHC^INHUT2($P(^XXDBE(30203,IEN,0),U))
 ..I X=XXNO S (OUT,INCEIS)=IEN
 S:'$G(INCEIS) INCEIS=1
 ;Get length of time to keep VMS file open. Minimum of 20
 S INFILOPN=+$G(^XXDBE(30203,INCEIS,3)) S:INFILOPN<20 INFILOPN=20
 S INENDTM=0
 ;
RUN ;This is main loop of routine.
 S INRUN=$$INRHB^INHUVUT1(INBPN,"Idle") G:'INRUN EXIT
 ;Update background process audit
 D:$D(XUAUDIT) ITIME^XUSAUD(INPNAME)
 ;If a VMS file has been open the allocated time, close it
 I INENDTM D
 .S INOK=$$CHKTM(INENDTM)
 .Q:INOK
 .D:$D(XXDFN) CLOSE(XXDFN) S INENDTM=0
 ;Loop until a transaction exists on the destination queue
 ;If re-trying a message, it will still be at top of queue
 S INUIF=$$NEXT^INHUVUT3(INDSTR,.INQP,.INQT)
 I 'INUIF D WAIT^INHUVUT(INBPN,INIP("THNG")) G RUN
 ;
 ;If there is a message to write, be sure a file is open
 I 'INENDTM D
 .S XXDTRDA=$$GETFIL(.XXDFN)
 .I XXDTRDA S INENDTM=$$SETTM(INFILOPN) Q
 .;If file not opened, update run global
 .I 'XXDTRDA S INRUN=$$INRHB^INHUVUT1(INBPN,"File error",2)
 G:'INRUN EXIT
 ;
 ;If file is not opened, hang 1200 sec and try again,
 ;based on send hang parameter (which is in seconds)
 I 'XXDTRDA D QULOCK S WAIT=$S(INIP("SHNG")>0:INIP("SHNG"),1:1200) D WAIT^INHUVUT(INBPN,WAIT) G RUN
 ;
 ;else file is open, proceed
 S INRUN=$$INRHB^INHUVUT1(INBPN,"Transmitting")
 G:'INRUN EXIT
 ;GIS audit call
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",INPNAME,"","TRANSMIT")
 ;;
 ;Append message to file
 S LCT=0 F  D GETLINE^INHOU(INUIF,.LCT,.LINE) Q:'$D(LINE)  D
 .  ;copy main line
 .  U XXDFN W LINE
 .  ;copy any overflow nodes
 .  F I=1:1 Q:'$D(LINE(I))  U XXDFN W LINE(I)
 .  U XXDFN W !
 ;
 ;Write EOM character
 U XXDFN W $C(28),!
 ;Stop GIS Transaction Type audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 ;
 ;Kill from queue and loop
 D QKILL,LOG
 S INRUN=$$INRHB^INHUVUT1(INBPN,"Transmission complete",1)
 G RUN
 ;
LOG ;Log status of original message
 ;INHOS needs UIF and ER=0,1,or 2
 N UIF S UIF=INUIF,ER=0
 D DONE^INHOS
 Q
 ;
QKILL K ^INLHDEST(INDSTR,INQP,INQT,INUIF)
 D QULOCK
 Q
 ;
GETFIL(XXDFN) ;Get VMS file name to open
 ;XXDFN is file to open, pass by reference. To work with MSM on PC
 ;this will be the value returned from OPENSEQ^%ZTFS1, which includes
 ;the device number,full file and path.
 N DA,EXT,FIL,XXDIR,X,DIC,Y,DLAYGO,DIK,DATE,FIL1,OK,FILNAM
 K XXDFN
 ;Directory to write files to
 D SETDT^UTDT S XXDIR=$G(^XXDBE(30203,INCEIS,1))_"MH",DATE=$E(DT,2,7)
 ;Last file name stored in ^XXDFIL("AC",INCEIS)
 ;Until file is open or EXT=999
 S XXDTRDA=0 F  D  Q:XXDTRDA!(EXT>999)
 .;First get file and extension
 .D  Q:EXT>999
 ..S FIL=$G(^XXDFIL("AC",INCEIS))
 ..I '$L(FIL)!($P(FIL,".")'=DATE) S EXT="001" Q
 ..;else increment last extension
 ..S EXT=$P(FIL,".",2)+1 Q:EXT>999
 ..I $L(EXT)<3 F  S EXT="0"_EXT Q:$L(EXT)=3
 .S FIL=DATE_"."_EXT,^XXDFIL("AC",INCEIS)=FIL,FILNAM=XXDIR_FIL
 .;try to add entry to transaction file
 .S XXDTRDA=$$TRANA(FILNAM) Q:'XXDTRDA
 .;try to open file
 .S XXDFN=$$OPEN(FILNAM)
 .I '$L(XXDFN) D ENR^INHE(INBPN,"MHCMIS - Unable to open file "_$G(FILNAM)) D
 ..;If file is new, but can't be opened, kill entry from tracking file
 ..;Third piece of XXDTRDA corrosponds to $P(Y,U,3) in DIC call
 ..Q:'$P(XXDTRDA,U,3)
 ..S DIK="^XXDFIL(",DA=+XXDTRDA D ^DIK
 .S:'$L(XXDFN) XXDTRDA=0
 I 'XXDTRDA D ENR^INHE("MHCMIS - Failure to create file for period "_XXDIR_FIL) K XXDFN
 Q +XXDTRDA
 ;
TRANA(X) ;Add/find entry in transmission tracking file (30205)
 Q:'$L(X) 0
 S DIC(0)="MNLZ",DIC="^XXDFIL(",DLAYGO=30205 D ^DIC S:Y<0 Y=0
 I 'Y D ENR^INHE(INBPN,"Unable to open file "_X) Q 0
 ;See if file has already been transmitted
 I $P(^XXDFIL(+Y,0),U,2) D ENR^INHE(INBPN,"MHCHMIS - file "_X_" has already been transmitted") Q 0
 Q Y
 ;
OPEN(FILNAM) ;Open VMS file XXDFN
 N %
 ;make sure file doesn't already exist and quit if it does
 Q:$L($$OPENSEQ^%ZTFS1(FILNAM,"R")) 0
 ;Then try to open new file
 Q $$OPENSEQ^%ZTFS1(FILNAM,"WA")
 ;
SETTM(INFILOPN) ;Set closing time (no later than midnight of current day)
 ;INPUT: INFILOPN=length of time to be open in minutes
 N NOW,OPEN,CLOSE
 ;Closing time is current time + INFILOPN
 ;less 120 seconds to avoid possible conflict with FTP process
 S NOW=$$NOW^UTDT,OPEN=INFILOPN-2
 S CLOSE=$$ADDT^UTDT(NOW,0,0,OPEN)
 I $P(CLOSE,".")'=$P(NOW,".") S CLOSE=$P(NOW,".")_".24"
 ;Convert closing time to $H format
 S X=$$CDATF2H^UTDT(CLOSE)
 ;Update transmission tracking file with time to close (used for FTP)
 D TRANU(XXDTRDA,CLOSE,INCEIS)
 Q X
 ;
CHKTM(INENDTM) ;Compare current time with time to close VMS file
 ;INENDTM = $H format of time to end.
 ;Return 1 if okay to keep writing to this file, 0 if time to close
 ;If file has been open past midnight, it's time to close
 Q:+INENDTM'=+$H 0
 ;If current time is later than time to close
 Q:$P(INENDTM,",",2)<$P($H,",",2) 0
 Q 1
 ;
ERR ;Error module
 N INREERR S INREERR=$$GETERR^%ZTOS
 ;If unanticipated error is encounterd close transmitter
 I $D(XXDFN) D CLOSE(XXDFN)
 D ENR^INHE(INBPN,"MHCMIS - Fatal error encountered by TRANSCEIVER  - "_INREERR_" in background process "_INBPN)
 X $G(^INTHOS(1,3))
 ;
EXIT ;Main exit module
 D QULOCK
 D:$D(XXDFN) CLOSE(XXDFN)
 K ^INRHB("RUN",INBPN)
 ;Stop background process audit
 D:$D(XUAUDIT) AUDSTP^XUSAUD
 Q
 ;
QULOCK L:$G(INUIF) -^INLHDEST(INDSTR,INQP,INQT,INUIF)
 Q
 ;
CLOSE(XXDFN) ;Close file
 S OK=$$CLOSESEQ^%ZTFS1(XXDFN)
 I 'OK D ENR^INHE(INBPN,"MHCMIS - Error in closing ASCII file "_XXDFN)
 K XXDFN
 Q
 ;
TRANU(DA,CLOSE,INCEIS) ;Update entry in MHCMIS Data Exchange file (#30205)
 Q:'$G(DA)
 ;S $P(^XXDFIL(DA,0),U,3,5)="^"_CLOSE_"^"
 ;S $P(^XXDFIL(DA,0),U,3,5)="^"_$$NOW^%ZTFDT_"^"
 S $P(^XXDFIL(DA,0),U,4)=CLOSE,$P(^(0),U,6)=INCEIS
 Q
 ;
