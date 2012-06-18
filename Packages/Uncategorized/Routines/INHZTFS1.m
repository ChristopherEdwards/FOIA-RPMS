%ZTFS1 ; cmi/flag/maw - Ed de Moel 11:53 ; [ 05/22/2002  2:54 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUL 01, 2001
 ;CHCS TLS_4602; GEN 2; 12-NOV-1998
 ;COPYRIGHT 1991 SAIC
 ;--space for CMS stamp---
 ;
OPENSEQ(FILE,ACC,XFILEDEF) ;
 ; SET DEVICE=$$OPENSEQ^%ZTFS1(FILE,ACCESS)
 ;     Opens the sequential file identified by FILE and
 ;     returns the identifier to be used for the file as
 ;     the function value.
 ;     Default file access is 'read from beginning'.
 ;
 ;   FILE      = name of file, needs to conform to operating
 ;               system requirements
 ;   ACCESS    = type of access
 ;              IF ACCESS["R"  file must be readable
 ;              IF ACCESS["W"  file must be writeable
 ;              IF ACCESS["A"  initial position will be at end-of-file
 ;                             so that data can be appended
 ;              IF ACCESS["B"  initial position will be at start-of-file
 ;                             so that data can be overwritten
 ;              IF ACCESS["S"  the file will be opened for shared access
 ;
 ;   XFILEDEF  = name of FDL file to use when creating file
 ;               needs to conform to operating system requirements
 ;
 N XRD,XWR,XBG,XAP,XT,XTR
 S $ZT="ERR",ACC=$G(ACC) S:ACC="" ACC="RB" S ACC=$$UPCASE^%ZTF(ACC)
 S XBG=ACC["B",XAP=ACC["A",XRD=ACC["R",XWR=ACC["W"
 I $TR(ACC,"BRAW")'="" Q ""
 I 'XRD,'XWR Q ""
 I XBG,XAP Q ""
 I XAP,XRD Q ""
 ;I XRD,$ZSEARCH(FILE)="" Q ""
 ; Force check the existence of the file if reading from the file
 I XRD,'$$PARSE(FILE,1) Q ""
 ; Don't force check the existence of the file if writing to the file
 I XWR,'$$PARSE(FILE) Q ""
 ;I 'XRD,XWR,XBG,$L($G(XFILEDEF)) S %=$ZC(%FDLCREATE,XFILEDEF,FILE) O % U % Q $ZI
 I XBG,'XRD O FILE:NEWVERSION U FILE Q $ZI
 I XBG,'XWR O FILE:READONLY U FILE Q $ZI
 I XBG O FILE:NOSEQUENTIAL U FILE:RFA="1,0" Q $ZI
 I XAP O FILE U FILE Q $ZI
 I XWR O FILE:NEWVERSION U FILE Q $ZI
 O FILE:READONLY:30 Q:'$T "" U FILE Q $ZI
ERR Q ""
 ;
OPENRAN(FILE,ACC,WHERE) ;
 ; SET DEVICE=$$OPENRAN^%ZTFS1(FILE,ACCESS,WHERE)
 ;     Opens the sequential file identified by FILE and
 ;     returns the identifier to be used for the file as
 ;     the function value.
 ;     Default file access is 'read from beginning'.
 ;
 ;   FILE      = name of file, needs to conform to operating
 ;               system requirements
 ;   ACCESS    = type of access
 ;              IF ACCESS["R"  file must be readable
 ;              IF ACCESS["W"  file must be writeable
 ;              IF ACCESS["S"  the file will be opened for shared access
 ;   WHERE     = initial file position
 ;
 N XRD,XWR,XT,XTR
 S $ZT="ERR",ACC=$G(ACC) S:ACC="" ACC="R" S ACC=$$UPCASE^%ZTF(ACC)
 S XRD=ACC["R",XWR=ACC["W"
 I $TR(ACC,"RW")'="" Q ""
 I 'XRD,'XWR Q ""
 I XRD,'$$PARSE(FILE,1) Q ""
 I XWR,'$$PARSE(FILE) Q ""
 I 'XRD O FILE:NEWVERSION U FILE Q $I
 I 'XWR O FILE:(NOSEQUENTIAL:READONLY) U FILE:RFA=WHERE Q $I
 O FILE:NOSEQUENTIAL:30 Q:'$T "" U FILE:RFA=WHERE Q $I
 ;
READSEQ(FILE) ;
 ; SET LINE=$$READSEQ(FILE)
 ;       reads a line from the specified sequential file and
 ;       returns the text of this line as the function value.
 ;       The device identifier is preferably obtained through
 ;       SET FILE=$$OPENSEQ(...) in this module.
 ;  ***  As a side effect, local variable EOF is     **********
 ;  ***  set to 0 when a line could be successfully  **********
 ;  ***  read, or to 1 when end of file is reached.  **********
 ;
 N X
 S EOF=0,$ZT="END" U FILE R X Q X
END U 0 I $ZE'["ENDOFILE" ZQ
 S EOF=1 Q ""
CLOSESEQ(FILE,DISPOSE) ;
 ; SET STATUS=$$CLOSESEQ^%ZTFS1(FILE[,DISPOSE])
 ;     Closes the sequential file identified by FILE and
 ;     optionally performs a special close-disposition.
 ;       The device identifier is preferably obtained through
 ;       SET FILE=$$OPENSEQ(...) in this module.
 ;     Possible close-dispositions are:
 ;          "DELETE"
 ;          "PRINT/QUEUE=queuename"
 ;          "SUBMIT/QUEUE=queuename"
 ;
 I $G(DISPOSE)="DELETE" C FILE:DELETE Q 1
 C FILE Q 1
GETPOS(FILE) ;
 ; SET WHERE=$$GETPOS^%ZTFS1(FILE)
 ;     Makes the named file the current device and returns the
 ;     current file position as the function value.
 ;
 U FILE Q $ZB
POSSEQ(FILE,WHERE) ;
 ; DO POSSEQ(FILE,WHERE)
 ;     Changes the file position of the named file to the spefified
 ;     location.
 ;
 U FILE:RFA=WHERE Q
 ;
PARSE(FILE,EXIST,SHOWMSG) ; Parse a file spec.
 ;
 ; Input: FILE ==> File Spec in DEVICE:[DIRECTORY]NAME format
 ;                 if DEVICE is null, current device is assumed
 ;                 if DIRECTORY is null, current directory is assumed
 ;
 ;       EXIST ==> 1 to force check the existence of the file
 ;                 0 Do not check the existence of the file (Default)
 ;
 ;       SHOWMSG ==> 1 If display of error message is desired
 ;                   0 If display of error message is not desired (Def)
 ; Note: Device and directory must exist for both read and write
 ;       operations no matter how EXIST is passed.
 ;
 ;Output: E1   ==> Null input file spec
 ;        E2   ==> Device does not exist
 ;        E3   ==> Directory does not exist
 ;        E4   ==> File not found
 ;        1    ==> File spec was parsed
 ;
 ; Usage: I '$$PARSE^%ZTFS1(FILENAME,1) Q
 ;
 N XDEV,XDIR,XEXIST,XF,XLDEV,XMSG,XNAME,XSHOW,XTRN
 S XEXIST=$G(EXIST) S:'$L(XEXIST) XEXIST=0
 S XSHOW=$G(SHOWMSG),XF=$G(FILE) I '$L(XF) D  Q "E1^"_XMSG
 .S XMSG="NULL INPUT FILE SPEC" W:XSHOW !,*7,XMSG
 ;S XTRN=$&ZLIB.%TRNLNM(XF) S:$L(XTRN) XF=XTRN
 ;S XDEV=$&ZLIB.%PARSE(XF,,,"DEV",1)
 ;S XLDEV=$&ZLIB.%TRNLNM($E(XDEV,1,$L(XDEV)-1)) S:$L(XLDEV) XDEV=XLDEV
 ;I $&ZLIB.%GETDVI(XDEV,"EXISTS")=0 D  Q "E2^"_XMSG
 .S XMSG="DEVICE "_XDEV_" DOES NOT EXIST" W:XSHOW !,*7,XMSG
 ; If device is not a directory structured device (e.g. NL:) quit 1
 ;I $L(XDEV),'($&ZLIB.%GETDVI(XDEV,"DIR")) Q 1
 ;S XDIR=$&ZLIB.%PARSE(XF,,,"DIR") I '$L(XDIR) D  Q "E3^"_XMSG
 .S XMSG="DIRECTORY DOES NOT EXIST" W:XSHOW !,*7,XMSG
 ;S XNAME=$&ZLIB.%PARSE(XF,,,"NAME",XEXIST)
 I XNAME="" D  Q "E4^"_XMSG
 .S XMSG="FILE "_FILE_" NOT FOUND" W:XSHOW !,*7,XMSG
 I 'XEXIST Q 1
 I $L($ZSEARCH(FILE)) Q 1
 S XMSG="FILE "_FILE_" NOT FOUND" W:XSHOW !,*7,XMSG
 Q "E4^"_XMSG
