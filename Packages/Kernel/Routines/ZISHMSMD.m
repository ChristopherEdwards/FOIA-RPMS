ZISHMSMD ; IHS/DSM/MFD - HOST COMMANDS FOR DOS (MSMD); [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1001,1002,1003,1004,1005,1007,1017**;APR 1, 2003;Build 3
 ;;8.0;KERNEL;;JUL 10, 1995
 ;THIS ROUTINE CONTAINS IHS MODIFICATIONS BY IHS/ADC/GTH 06/03/96; IHS/AAO/RPL; IHS/HQW/JLB 3/1/99
 ;
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 ;
OPEN(ZISH1,ZISH2,ZISH3) ; -----  Open DOS file.
 ;  S Y=$$OPEN^%ZISH("\directory\","filename","R")
 ;error    1=no dev
 ;         2=open new fl with 'R'
 ;         3=passes fls by ref
 ;         4=invalid fl len
 ;
 ; ---------------------------------------------------------------
 ; PROGRAMMERS NOTE:  IHS/ADC/GTH - 06-03-96
 ; The VA's K8 version of %ZISH added another parameter to $$OPEN,
 ; the "handle name" of the file, but put the parameter at the
 ; beginning of the formal parameter list, instead of at the end,
 ; causing backwards incompatibility problems.
 ; This version is the IHS's version, with three parameters.
 ; ZISHMSMD resides in the production UCI and is called by %ZISH
 ; on DOS-based machines.  
 ; ---------------------------------------------------------------
 ;
 NEW ZISHDF,ZISHIOP,%ZIS,POP,ZISHQ
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 ;
 ; -- Pass by value or quit.
 I $O(ZISH2(0)) S ZISHX=3 Q ZISHX
 ;
 ; -- Check filename length.
 D FL(.ZISH2) I ZISH2=4 Q ZISH2
 ;
 S ZISHDF=$S(ZISH1'="":ZISH1_ZISH2,1:ZISH2)
 ;
 ; -- Open MSM host.
 F ZISHIOP=51:1:54 I '$D(IO(1,ZISHIOP)) S IOP=ZISHIOP,%ZIS("IOPAR")="("""_ZISHDF_""":"""_ZISH3_""")" D ^%ZIS Q:'POP
 I POP Q 1
 ;
 ; -- Check new file with "R" privileges.
 I ZISH3="R" D
 .U IO I $ZA=-1 S ZISHQ=2 D ^%ZISC
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 ;
 I '$D(ZISHQ),'$D(ZTQUEUED) U IO(0)
 Q $S($D(ZISHQ):ZISHQ,1:0)
 ;
DEL(ZISH1,ZISH2) ; ----- Delete file(s).
 ;  S Y=$$DEL^%ZISH("\directory\","filename")
 ;                               ,.array)
 ;error      1=attempted wild card * del
 ;
 NEW ZISHDA,ZISHF,ZISHX,ZISHQ,ZISHDF,ZISHC,ZISHNUM
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 ;
 ; -- Set array if filename(s) are passed by value.
 I '$O(ZISH2(0)) S ZISH2(1)=ZISH2
 ;
 ; -- Get file(s) to act on.
 ; -- No '*' allowed.
 F ZISHDA=0:0 S ZISHDA=$O(ZISH2(ZISHDA)) Q:'ZISHDA  S ZISHF=ZISH2(ZISHDA) I ZISHF["*" S ZISHX=1,ZISHQ=1 Q
 I $D(ZISHQ) Q ZISHX
 F ZISHDA=0:0 S ZISHDA=$O(ZISH2(ZISHDA)) Q:'ZISHDA  S ZISHF=ZISH2(ZISHDA) D
 . I ZISH1'="" S ZISHDF=ZISH1_ZISHF
 . S ZISHC=$S(ZISH1'="":ZISHDF,1:ZISHF)
 . S ZISHNUM=2
 . D JW
 .Q
 Q ZISHX
 ;
FROM(ZISH1,ZISH2,ZISH3,ZISH4,ZISH5) ; ----- Get DOS file(s) from.
 ;  S Y=$$FROM^%ZISH("\dir\","fl","mach","qlfr","\dir\")
 ;                           "fl*"
 ;                           .array
 Q 20
 ;
SEND(ZISH1,ZISH2,ZISH3) ; ----- Send DOS file(s). (MV to export directory.)
 ;  S Y=$$SEND^%ZISH("\dir\","fl","mach")
 ;                           "fl*"
 ;                           .array
 NEW Y,ZISH,ZISHPARM
 I '$L($G(ZISH2)) Q "1^<file not specified>"
 ; Put array of files in ZISH2()
 S Y=$$LIST(.ZISH1,ZISH2,.ZISH2)
 F ZISH=1:1 Q:'$D(ZISH2(ZISH))  S Y=$$MV(ZISH1,ZISH2(ZISH),"\EXPORT\",ZISH2(ZISH))
 Q Y
 ;
 ;
LIST(ZISH1,ZISH2,ZISH3) ; -----  Create local array holding filename(s).
 ;  S Y=$$LIST^%ZISH("\dir\","fl",".return array")
 ;                           "fl*",
 ;                           .array,
 ;
 NEW ZISHC,ZISHDA,ZISHDF,ZISHX,ZISHF,X,Y,ZISHCNT
 ;
 ; -- Set array counter for pass back array.
 S ZISHCNT=0
 ;
 ; -- Directory format.
 D DF(.ZISH1)
 ;
 ;
 ; -- Set array if filename(s) are passed by value.
 I '$O(ZISH2(0)) S ZISH2(1)=ZISH2
 ;
 ; -- Get filename(s) to act on.
 F ZISHDA=0:0 S ZISHDA=$O(ZISH2(ZISHDA)) Q:'ZISHDA  S ZISHF=ZISH2(ZISHDA) D
 . I $P(ZISHF,".",2)="" S ZISHF=ZISHF_".*"
 . S ZISHDF=$S(ZISH1'="":ZISH1_ZISHF,1:ZISHF)
 .; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 . S ZISHCNT=ZISHCNT+1 S ZISHX=$ZOS(12,ZISHDF,32+16+4+1) I $P(ZISHX,U)'="",$P(ZISHX,U)'<0 S ZISH3(ZISHCNT)=$P(ZISHX,U)
 .;Above line fixed 12/17 'I $P...'<0'
 . F  S ZISHCNT=ZISHCNT+1 S ZISHX=$ZOS(13,ZISHX) Q:$P(ZISHX,U)=""!(ZISHX<0)  S ZISH3(ZISHCNT)=$P(ZISHX,U)
 .; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 .Q
 Q ZISHX
 ;
 ;
MV(ZISH1,ZISH2,ZISH3,ZISH4) ; -----  Rename a file(s).
 ;  S Y=$$MV^%ZISH("\dir\","fl","\dir\","fl")
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
 S ZISHX=$ZOS(3,ZISH2,ZISH4)
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
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
 NEW X,Y
 S ZISH1(1)=$ZOS(11,"C")
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 Q ZISH1(1) ; WAS Q ZISH(1) AND GAVE UNDEF ON ZISH(1) ;IHS/AAO/RPL 
 ;
JW ; -----  Call DOS $ZOS.
 S ZISHX=$ZOS(ZISHNUM,ZISHC)
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 Q
 ;
DF(X) ; -----  Directory format.
 Q:X=""
 S X=$TR(X,"/","\")
 I $E(X,$L(X))'="\" S X=X_"\"
 Q
 ;
STATUS() ; -----EndOfFile flag.
 Q $ZC
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 ;
FL(X) ; -----  Check for filename length.
 N ZISHP1,ZISHP2
 S ZISHP1=$P(X,"."),ZISHP2=$P(X,".",2)
 ; Don't really care about filename length for NT systems  IHS/HQW/JLB 3/1/99
 ;I $L(ZISHP1)>8 S X=4 Q IHS/HQW/JLB 3/1/99
 ;I $L(ZISHP2)>3 S X=4 Q IHS/HQW/JLB 3/1/99
 Q
 ;
