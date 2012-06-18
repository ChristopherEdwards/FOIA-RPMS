ZISHMSMU ; IHS/DSM/MFD - HOST COMMANDS FOR UNIX ; [ 06/03/96  10:58 AM ]
 ;;8.0;KERNEL;**1001,1002,1003,1004,1005,1006,1007,1011,1016,1017**;APR 1, 2003;Build 3
 ;;8.0;KERNEL;;JUL 10, 1995
 ;THIS ROUTINE CONTAINS IHS MODIFICATIONS BY IHS/HQW/JLS 12/24/97; IHS/ANMC/LJF 12/11/96; IHS/ADC/GTH 06/03/96; IHS/AAO/RPL 4/9/99; TASSC/MFD
 ;
 ; Excepted from IHS SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 ;
 ; Rename to %ZISH in the managers account
 ;
 ;IHS/HQW/JLS 12/24/97  This routine called by %ZISH on UNIX Systems 
 ;
 ;IHS/ANMC/LJF 12/11/96
 ; -- changed exit value for PWD call to make it work for VA calls
 ;
OPEN(ZISH1,ZISH2,ZISH3) ; -----  Open unix file.
 ;  S Y=$$OPEN^%ZISH("/directory/","filename","R")
 ;error    1=no dev
 ;         2=open new fl with 'R'
 ;         3=passed fls by ref
 ;         4=invalid fi len
 ;
 ; ---------------------------------------------------------------
 ; PROGRAMMERS NOTE:  IHS/ADC/GTH - 06-03-96
 ; The VA's K8 version of %ZISH added another parameter to $$OPEN,
 ; the "handle name" of the file, but put the parameter at the
 ; beginning of the formal parameter list, instead of at the end,
 ; causing backwards incompatibility problems.
 ; This version is the IHS's version, with three parameters.
 ; ---------------------------------------------------------------
 ;
 NEW ZISHDF,ZISHIOP,%ZIS,POP,ZISHQ,IOUPAR
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 ;
 ; -- Pass by value, or quit.
 I $O(ZISH2(0)) S ZISHX=3 Q ZISHX
 ;
 ; -- Check filename length.
 D FL(.ZISH2)
 I ZISH2=4 Q ZISH2
 ;
 S ZISHDF=$S(ZISH1'="":ZISH1_ZISH2,1:ZISH2)
 ;
 ; -- Open MSM host.
 F ZISHIOP=51:1:54 I '$D(IO(1,ZISHIOP)) S IOP=ZISHIOP,%ZIS("IOPAR")="("""_ZISHDF_""":"""_ZISH3_""")" D ^%ZIS Q:'POP
 I POP Q 1
 ;
 ; -- Check new filename with "R" privileges.
 I ZISH3="R" D
 .U IO I $ZA=-1 S ZISHQ=2 D ^%ZISC
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 ;
 I '$D(ZISHQ),'$D(ZTQUEUED) U IO(0)
 Q $S($D(ZISHQ):ZISHQ,1:0)
 ;
DEL(ZISH1,ZISH2) ; -----  Delete file(s).
 ;  S Y=$$DEL^%ZISH("/directory/","filename")
 ;                               ,.array)
 NEW ZISHDA,ZISHF,ZISHX,ZISHQ,ZISHDF,ZISHC
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 ;
 ; -- Set array if filename(s) passed by value.
 I '$O(ZISH2(0)) S ZISH2(1)=ZISH2
 ;
 ; -- Get filename(s) to act on.
 ; -- No '*' allowed.
 F ZISHDA=0:0 S ZISHDA=$O(ZISH2(ZISHDA)) Q:'ZISHDA  S ZISHF=ZISH2(ZISHDA) I ZISHF["*" S ZISHX=1,ZISHQ=1 Q
 I $D(ZISHQ) Q ZISHX
 F ZISHDA=0:0 S ZISHDA=$O(ZISH2(ZISHDA)) Q:'ZISHDA  S ZISHF=ZISH2(ZISHDA) D
 . I ZISH1'="" S ZISHDF=ZISH1_ZISHF
 . S ZISHC="rm "_$S(ZISH1'="":ZISHDF,1:ZISHF)
 . D JW
 .Q
 Q ZISHX
 ;
FROM(ZISH1,ZISH2,ZISH3,ZISH4,ZISH5) ; -----  Get unix file(s) from.
 ;  S Y=$$FROM^%ZISH("/dir/","fl","mach","qlfr","/dir/")
 ;                           "fl*"
 ;                           .array
 Q 20
 ;
SEND(ZISH1,ZISH2,ZISH3) ;Send unix fl
 ;  S Y=$$SEND^%ZISH("/dir/","fl","mach")
 ;                           "fl*"
 ;                           .array
 NEW ZISH,ZISHPARM
 S ZISH1=$G(ZISH1) ; If directory not passed, use system.
 I '$L($G(ZISH2)) Q "-1^<file not specified>"
 I '$L($G(ZISH3)) Q "-1^<destination not specified>"
 S Y=$$LIST(.ZISH1,ZISH2,.ZISH2) ; Put array of files in ZISH2()
 ;I OS=AIX S ZISHPARM="-nc"
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1016
 ;S ZISHPARM="-nc"
 ; -n = suppress sending results in UNIX mail message to the user
 ; -c = pack file(s) with 'compress' before sending
 S ZISHPARM="-a"  ;IHS/AAO/RPL -a for ascii mode with ftpsend
 ;----- END IHS MODIFICATION - XU*8.0*1016
 ;I OS=SCO S ZISHPARM="-p"
 ; -p = pack the file before the send request
 ; - BEGIN IHS MODIFIACTION - XU*8.0*1016
 ;F ZISH=1:1 Q:'$D(ZISH2(ZISH))  S ZISHC="sendto "_ZISHPARM_" "_ZISH3_" "_ZISH1_ZISH2(ZISH) D JW
 F ZISH=1:1 Q:'$D(ZISH2(ZISH))  S ZISHC="cd /usr/spool/uucppublic; ftpsend "_ZISHPARM_" "_ZISH3_" "_ZISH2(ZISH) D JW  ;IHS/AAO/RPL 4/9/99 ftpsend after cd to public or nothing gets sent.
 Q ZISHX
 ;----- END IHS MODIFICATION XU*8.0-*1016
 ;
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1007
 ;Subroutine SENDTO1 is added to use sendto1 script to send file
SENDTO1(X,Y)       ;EP - use sendto1 script to send unix file
 ;X=Entry in ZISH SEND PARAMETERS FILE (name or ien)
 ;Y=file (path and filename)
 ;
 ;    S Y=$$SENDTO1^%ZISH("param","/path/file")
 ;
 N ZISH
 I '$L($G(Y)) Q "-1^<file not specified>"
 S ZISHFL=Y
 D GETDA
 I '$G(ZISHDA1) Q Y
 S ZISHDA=ZISHDA1
 D ONE
 I Y=0 D
 .S Y="0^processed"
 .I $G(ZISHRNUM) S Y=Y_"^"_ZISHRNUM
 Q Y
 ;----- END IHS MODIFICATION
LIST(ZISH1,ZISH2,ZISH3) ; -----  Set local array holding filename(s).
 ;  S Y=$$LIST^%ZISH("/dir/","fl",".return array")
 ;                           "fl*",
 ;                           .array,
 ;
 NEW ZISHC,ZISHDA,ZISHDF,ZISHX,ZISHLN,ZISHF,X,Y,POP,ZISHIOP1
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 ;
 ; -- Init ZISHAUTO.$J.
 S ZISHC="rm /tmp/ZISHAUTO."_$J
 D JW
 ;
 ; -- Set array if filename(s) are passed by value.
 I '$O(ZISH2(0)) S ZISH2(1)=ZISH2
 ;
 ; -- Get filename(s) to act on.
 ; -- Append listing to ZISHAUTO.$J.
 F ZISHDA=0:0 S ZISHDA=$O(ZISH2(ZISHDA)) Q:'ZISHDA  S ZISHF=ZISH2(ZISHDA) D
 . S ZISHDF=$S(ZISH1'="":ZISH1_ZISHF,1:ZISHF)
 . S ZISHC="ls "_ZISHDF_" >> /tmp/ZISHAUTO."_$J
 . D JW
 .Q
 ;
 ; -- Open ZISHAUTO.$J to read.
 ; -- Create the 'Return Array' to pass back to user.
 S ZISHIOP1=ION_";"_IOST_";"_IOM_";"_IOSL
 S ZISHX=$$OPEN("/tmp/","ZISHAUTO."_$J,"R")
 I ZISHX Q ZISHX
 F ZISHLN=1:1 U IO R X Q:$$STATUS=-1  S ZISH3(ZISHLN)=$P(X,"/",$L(X,"/"))
 D ^%ZISC
 S IOP=ZISHIOP1
 D ^%ZIS
 ;
 ; -- Remove ZISHAUTO.$J.
 S ZISHC="rm /tmp/ZISHAUTO."_$J
 D JW
 ;
 Q ZISHX
 ;
MV(ZISH1,ZISH2,ZISH3,ZISH4) ; -----  Rename a file.
 ;  S Y=$$MV^%ZISH("/from_dir/","from_fl","/to_dir/","to_fl")
 ;
 NEW ZISHC,ZISHX
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 D DF(.ZISH3)
 ;
 ; -- Check for pass by value, or quit.
 I $O(ZISH2(0))!($O(ZISH4(0))) S ZISHX=3 Q ZISHX
 ;
 ; -- Check for 'from' and 'to' directory.
 S ZISH2=$S(ZISH1="":ZISH2,1:ZISH1_ZISH2)
 S ZISH4=$S(ZISH3="":ZISH4,1:ZISH3_ZISH4)
 ;
 S ZISHC="mv "_ZISH2_" "_ZISH4
 D JW
 Q ZISHX
 ;
PWD(ZISH1) ; -----  Print working directory.
 ;  S Y=$$PWD^%ZISH(.return array)
 ;
 ; ---------------------------------------------------------------
 ; PROGRAMMERS NOTE:  IHS/ADC/GTH - 06-03-96
 ; The VA's K 8 version makes $$PWD a parameter-less extrinsic, which
 ; makes it backwards incompatible with IHS.  This is the IHS's
 ; version of $$PWD.
 ; ---------------------------------------------------------------
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1007
 ;IHS/OIRM/DSD/AEF/1/22/03 -THE LINE BELOW IS COMMENTED OUT AND REPLACED
 ;BY NEW LINES TO GET DEF DIR FROM KERNEL SYSTEM PARAMETERS FILE
 ;S ZISH1(1)="/tmp"
 S ZISH1(1)=$G(^XTV(8989.3,1,"DEV"))
 I ZISH1(1)="" S ZISH1(1)="/tmp/"
 S ZISH1(1)=$TR(ZISH1(1),"\","/")
 I $E(ZISH1(1),$L(ZISH1(1)))'="/" S ZISH1(1)=ZISH1(1)_"/"
 Q ZISH1(1)   ;IHS/ANMC/LJF 12/11/96
 ;Q 1         ;IHS/ANMC/LJF 12/11/96
 ;----- END IHS MODIFICATION
 ;
 ;
 ; --------------------------------------------------------------------------
 ; PROGRAMMERS NOTE: IHS/OIT/BWF-FBD
 ; Commented out followin VA code and re-introduced IHS modifications for XU*8.0*1016
 ; -------------------------------------------------------------------------
 ;
 ; ------ BEGIN IHS MODIFIACTION - XU*8.0*1016
 ;NEW %ZIS,POP,X,Y,ZISHC,ZISHDA,ZISHDF,ZISHF,ZISHIOP,ZISHLN,ZISHQ,ZISHX,ZISHSYFI,ZISHIOP1
 ;;
 ;; -- Init ZISHAUTO.$J.
 ;;S ZISHC="rm ZISHAUTO."_$J
 ;D JW
 ;;
 ;S ZISHC="pwd > ZISHAUTO."_$J
 ;D JW
 ;;
 ;; -- Open ZISHAUTO.$J to read.
 ;; -- Create the 'Return Array' to pass back to user.
 ;S ZISHIOP1=ION_";"_IOST_";"_IOM_";"_IOSL
 ;S ZISHX=$$OPEN("/usr/mumps/","ZISHAUTO."_$J,"R")
 ;I ZISHX Q ZISHX
 ;F ZISHLN=1:1 U IO R X Q:$$STATUS=-1  S ZISH1(ZISHLN)=X
 ;D ^%ZISC
 ;S IOP=ZISHIOP1
 ;D ^%ZIS
 ;;
 ;; -- Remove ZISHAUTO.$J.
 ;S ZISHC="rm ZISHAUTO."_$J
 ;D JW
 ;;
 ;Q ZISHX
 ; ------ END IHS MODIFIACTION - XU*8.0*1016
 ;
JW ; -- MSM extrinsic.
 S ZISHX=$$JOBWAIT^%HOSTCMD(ZISHC)
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 Q
 ;
DF(X) ; ----- Directory format.
 Q:X=""
 S X=$TR(X,"\","/")
 I $E(X,$L(X))'="/" S X=X_"/"
 Q
 ;
STATUS() ; ----- EndOfFile flag.
 Q $ZC
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 ;
QL(X) ;Qlfrs
 Q:X=""
 S:$E(X)'="-" X="-"_X
 Q
 ;
FL(X) ; ----- Filename length.
 NEW ZISHP1,ZISHP2
 S ZISHP1=$P(X,"."),ZISHP2=$P(X,".",2)
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1007
 ;THESE TWO LINES ARE COMMENTED OUT, FILE LENGTH IS NO LONGER AN ISSUE.
 ;ORIGINAL MODIFIATION BY TASSC/MFD
 ;I $L(ZISHP1)>14 S X=4 Q
 ;I $L(ZISHP2)>8 S X=4 Q
 ;----- END IHS MODIFICATION
 Q
 ;
IHS() ;EP - Determine if the call was from an IHS application.
 I '$L($G(XQY0)) Q 1
 I "AB"[$E($G(XQY0)_" ") Q 1
 ; If required, add more checks, below.
 ; I "xxx"[$E($G(XQY0)_" ") Q
 Q 0
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1007
 ;New subroutines added to support new $$SENDTO1 function
 ;Original modification by MJD
DIST(ZISH1,ZISH2)  ;send distribution list
 N ZISH
 I '$L($G(Y)) Q "-1^<file not specified>"
 S ZISHFL=Y
 D GETDA
 I '$D(ZISHDA1) Q Y
 I '$O(^%ZIB(9888888.93,ZISHDA1,1,0)) Q "-1^no entries in distribution list"
 S ZISHDA=0
 F  S ZISHDA=$O(^%ZIB(9888888.93,ZISHDA1,1,ZISHDA)) Q:'ZISHDA  D
 .D ONE
 S Y="0^list processed"
 Q Y         
ONE ;run one     
 F I=1:1:10 S ZISH(I)=$P(^%ZIB(9888888.93,ZISHDA,0),"^",I)
 S:ZISH(8)="" ZISH(8)="sendto1"
 S ZISHC=ZISH(8)
 I ZISH(3)'="",ZISH(4)'="" D
 .S:ZISH(6)'="" ZISH(6)=ZISH(6)_" "
 .S ZISH(6)=ZISH(6)_"-l "_ZISH(3)_":"_ZISH(4)
 I ZISH(5)'="" D
 .S:ZISH(6)'="" ZISH(6)=ZISH(6)_" "
 .S ZISH(6)=ZISH(6)_"-r "_ZISH(5)
 I ZISH(10)'="" D
 .S:ZISH(6)'="" ZISH(6)=ZISH(6)_" "
 .S ZISH(6)=ZISH(6)_"-w "_ZISH(6)
 S:ZISH(6)'="" ZISHC=ZISHC_" "_ZISH(6)
 S ZISHC=ZISHC_" "_ZISH(2)_" "_ZISHFL
 I ZISH(8)="sendto1",ZISH(7)="B" D
 .S ZISHRNUM=$$NXNM()
 .S ZISHC=ZISHC_" "_ZISHRNUM
 .S DIE="^%ZIB(9888888.93,",DA=ZISHDA,DR=".09///"_ZISHRNUM
 .D ^DIE
 D @(ZISH(7))
 K ZISH,ZISHDA,ZISHFL
 Q
 ;
F ;call hostcmd foreground
 S Y=$$TERMINAL^%HOSTCMD(ZISHC)
 Q
B ;call hostcmd background
 S Y=$$JOBWAIT^%HOSTCMD(ZISHC)
 Q
SCRIPT(X)          ;run a script
 ;x=entry in ZISH SEND PARAMETERS file (name or ien)
 D GETDA
 I '$G(ZISHDA) Q Y
 S ZISH(7)=$P(^%ZIB(9888888.93,ZISHDA,0),"^",7)
 I ZISH(7)="" Q Y
 S I=0
 F  S I=$O(^%ZIB(9888888.93,ZISHDA,2,I)) Q:'I  D
 .S ZISHC=^%ZIB(9888888.93,ZISHDA,2,I,0)
 .D @(ZISH(7))
 Q Y
GETDA ;internal entry number
 K ZISHDA1
 S Y="-1^<ZISH SEND PARAMETER FILE entry not valid>"
 I $G(X)="" Q
 I X,$D(^%ZIB(9888888.93,X,0)) D  Q
 .S ZISHDA1=X
 .K Y
 S ZISHDA1=$O(^%ZIB(9888888.93,"B",X,0))
 I '$D(^%ZIB(9888888.93,+ZISHDA1,0)) D
 .K ZISHDA1
 Q
NXNM() ;get next reference number
 I '$D(^%ZIB(9888888.93,"ARNUM")) D
 .S ^%ZIB(9888888.93,"ARNUM")=0
 L +^%ZIB(9888888.93,"ARNUM"):1 I '$T Q 0
 S Y=^%ZIB(9888888.93,"ARNUM")+1
 S ^%ZIB(9888888.93,"ARNUM")=Y
 L -^%ZIB(9888888.93,"ARNUM")
 Q Y
 ;----- END IHS MODIFICATION
