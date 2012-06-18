ZIBTCP ; IHS/ADC/GTH - TCP PRINT TEST ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ;
 ; This routine must be DONE from the CLOSE EXECUTE when
 ; printing to a TCP printer.  See below for further
 ; documentation.
 ;
 ; H = Host IP address
 ; P = Port number
 ; I = Counter
 ;
EN ;
 D EN1
EXIT ;
 S ZIBX="rm XM"_ZIBH_".DAT",ZIBX=$$JOBWAIT^%HOSTCMD(ZIBX)
 KILL ^TMP($J,"XM"_ZIBH),ZIBH,ZIBIO,ZIBI,ZIBX
 Q
 ;
EN1 ;
 NEW H,P,I
 S ZIBIO=ION,ZIBIO=$O(^%ZIS(1,"B",ZIBIO,0)),ZIBH=DUZ_$G(ZIBH)
 Q:'ZIBIO
 Q:'$D(^%ZIS(1,ZIBIO,90))
 S H=$P(^%ZIS(1,ZIBIO,90),U,2),P=$P(^(90),U,3)
 D OPEN
 Q:'$D(IO)
 U IO:(::0)
 F I=1:1 R X:300 S %X=$ZC Q:%X<0  S ^TMP($J,"XM"_ZIBH,I)=X
 D ^%ZISC
 O 56::99
 U 56::"TCP"
 W /SOCKET(H,P)
 S X=0
 F  S X=$O(^TMP($J,"XM"_ZIBH,X)) Q:X=""  W ^TMP($J,"XM"_ZIBH,X)_$C(10)_$C(13)
 W !,#,!
 C 56
 Q
 ;
OPEN ;OPEN HOST FILE
 F ZIBI=1:1:4 S (IOP,ION)="HOST FILE SERVER #"_ZIBI,%ZIS("IOPAR")="(""XM"_ZIBH_".DAT"":""R"")" D ^%ZIS Q:'POP
 I POP H 2 G OPEN
 KILL IOP
 Q
 ;
 ; Technical Notes:
 ; MSM TCP uses the "!" to clear the TCP buffer.  FileMan (RPMS)
 ; uses "!" for a carriage return, line feed.  Further, TCP does not
 ; recognize "?30" as 30 spaces from left margin.  To circumvent these
 ; problems, I write to a temporary host file, which formats the
 ; document, and then I read it back into the TMP global.  Once it's
 ; in the TMP global, I $O through the global and write each line
 ; with a $C(10) and $C(13) concatenated to the string.  This process
 ; handles the CR/LF problem at the remote end.
 ;
 ; Port 2501 is the assigned port from the vendor for the Net Que.
 ;
 ; As of 3Jan95, this has only been tested on the Unix platform using
 ; MSM.  It should work in a DOS environment using FTP Software's TCP,
 ; but needs to be tested.
 ;
 ; Below is an inquiry of the Device file and Terminal Type file.
 ;
 ; OUTPUT FROM WHAT FILE: DEVICE//
 ;   NAME: P-TCP TEST PRINTER                $I: 51
 ;   ASK DEVICE: YES                       ASK PARAMETERS: NO
 ;   VOLUME SET(CPU): TUC                  SIGN-ON/SYSTEM DEVICE: NO
 ;   FORCED QUEUING: N0
 ;   LOCATION OF TERMINAL: MAT PARKENSON PRINTER
 ;   ASK HOST FILE: NO                     MARGIN WIDTH: 255
 ;   FORM FEED: #                          PAGE LENGTH: 256
 ;   BACK SPACE: $C(8)   OPEN PARAMETERS: ("XM"_DUZ_$G(ZIBH)_".DAT":"M")
 ;   SUBTYPE: P-TCP PRINTER                TYPE: HOST FILE SERVER
 ;
 ; Select TERMINAL TYPE NAME: P-TCP PRINTER
 ;   NAME: P-TCP PRINTER                     SELECTABLE AT SIGN-ON: NO
 ;   RIGHT MARGIN: 255                     FORM FEED: #
 ;   PAGE LENGTH: 256                      BACK SPACE: $C(8)
 ;   OPEN EXECUTE: S XMREC="R X#255:1"     CLOSE EXECUTE: D ^ZIBTCP Q
 ;   DESCRIPTION: Special Terminal Type used only for P-TCP Printer
 ;                Device..
