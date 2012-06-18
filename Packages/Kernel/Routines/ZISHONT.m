%ZISH ;IHS/PR,SFISC/AC - Host File Control for Cache for VMS/NT/UNIX ;12/07/09  15:44
 ;;8.0;KERNEL;**34,65,84,104,191,306,385,440,518,524,1017**;JUL 10, 1995;Build 3
 ;THIS ROUTINE CONTAINS IHS MODIFICATIONS BY TASSC/MFD
 ;
 ;TASSC/MFD Many mods to enable functioning on Cache, Windows or Unix.
 ;          This routine no longer calls any other routines.
 ;
OPEN(X1,X2,X3,X4,X5,X6)    ;SR. Open Host File
 I '$D(X4) Q $$OPENI(X1,X2,X3)      ;TASSC/MFD added call
 ;X1=handle name
 ;X2=directory name \dir\
 ;X3=file name
 ;X4=file access mode e.g.: W for write, R for read, A for append.
 ;X5=Max record size for a new file, X6=Subtype
 N %,%1,%2,%I,%ZOS,%T,%ZA,%ZISHIO,$ET
 S $ET="D OPNERR^%ZISH"
 S U="^",%I=$I,%T=0,POP=0,X2=$$DEFDIR($G(X2)),%ZOS=$$OS^%ZOSV M %ZISHIO=IO
 I %ZOS'="VMS" S %1=$S(X4["A":"AW",X4["W":"WN",1:"R")_$S(X4["B":"U",1:"S") ;NT & Unix
 I %ZOS="VMS" S %1=$S(X4["A":"AW",X4["W":"WN",1:"RH")_$S(X4["B":"U",1:"S")
 ;The next line eliminates the <ENDOFFILE> error for sequential files for the current process.
 S %ZA=$ZUTIL(68,40,1) ;Work like DSM
 S %=X2_X3 O %:(%1):2 I '$T S POP=1 Q
 S IO=%,IO(1,IO)="",IOT="HFS",IOM=80,IOSL=60,POP=0 D SUBTYPE^%ZIS3($G(X6,"P-OTHER"))
 I $G(X1)]"" D SAVDEV^%ZISUTL(X1)
 ;I $L($G(%I)) U %I ;Would only needed if we had done a USE.
 Q
 ;
OPNERR ;Handle open error
 S POP=1,$ECODE=""
 ;I $L($G(%I)) U %I
 Q
 ;
CLOSE(X) ;SR. Close HFS device not opened by %ZIS.
 ;X=HANDLE NAME
 ;IO=Device
 N %
 I $L($G(IO)) C IO K IO(1,IO)
 I $L($G(X)) D RMDEV^%ZISUTL(X)
 ;Only reset home if one setup.
 I $D(IO("HOME"))!$D(^XUTL("XQ",$J,"IOS")) D HOME^%ZIS
 Q
 ;
OPENERR ;
 Q 0
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1017
DEL(%ZX1,%ZX2) ;ef,SR. Del fl(s)
 ;S Y=$$DEL^ZOSHMSM("\dir\",$NA(array))
 ;TASSC/MFD modified to accommodate IHS calls without $NA array in %ZX2
 ;in addition the VA quits 0 if failure whereas IHS quits 0 success
 N %,%ZISH,ZOSHDA,ZOSHF,ZOSHX,ZOSHQ,ZOSHDF,ZOSHC,%ZISHDC,%ZISHT,X
 S %ZX1=$$DEFDIR($G(%ZX1))
 ;Get fls to act on
 ;No '*' allowed
 I %ZX2["*" Q 1                           ;TASSC/MFD
 S %ZISHDC=$S($ZV["UNIX":"rm ",1:"del ")  ;TASSC/MFD
 S %ZISHT=$ZT,X="*DELI",@^%ZOSF("TRAP")   ;TASSC/MFD, 9/9/02 added * to not unwind stack
 I $D(@%ZX2)<10 G DELI                    ;TASSC/MFD
 S %ZISH="" F  S %ZISH=$O(@%ZX2@(%ZISH)) Q:'%ZISH  I %ZISH["*" S ZOSHQ=1 Q
 I $D(ZOSHQ) S X=%ZISHT,@^%ZOSF("TRAP") Q 0
 S %ZISH="" F  S %ZISH=$O(@%ZX2@(%ZISH)) Q:%ZISH=""  D
 . S %=$S(%ZISH[%ZX1:%ZISH,1:%ZX1_%ZISH)
 . S %=$ZF(-1,%ZISHDC_%)       ;TASSC/MFD changed del to a variable to allow Unix or Windows
 S X=%ZISHT,@^%ZOSF("TRAP") Q 1
 ;-------------------------------
 ; Commented out below VA modification, and re-introduced IHS mods above.
 ;-------------------------------
 ;
 ;DEL(%ZX1,%ZX2) ;ef,SR. Del files, return 1 if deleted all requested.
 ;;S Y=$$DEL^%ZISH("dir path",$NA(array))
 ;; will invoke an OS command to delete file(s)
 ;; UNIX: rm -f filespec[ ...]
 ;; VMS: del filespec[,...]
 ;N %ZARG,%ZXDEL,%ZOS,%ZDELIM,%ZCOMND,%ZLIST
 ;S %ZARG="",%ZXDEL=1
 ;S %ZX1=$$DEFDIR($G(%ZX1))
 ;S %ZOS=$$OS^%ZOSV
 ;S %ZDELIM=$S(%ZOS="UNIX":" ",1:",")
 ;S %ZCOMND=$S(%ZOS="UNIX":"rm -f ",1:"del ")
 ;D
 ;. N $ETRAP,$ESTACK S $ETRAP="D DELERR^%ZISH"
 ;. N %,%ZI,%ZISH,%ZX,%ZFOUND S %ZISH=""
 ;. F %ZI=1:1 S %ZISH=$O(@%ZX2@(%ZISH)) Q:%ZISH=""  D
 ;. . N $ETRAP,$ESTACK S $ETRAP="D DELERR^%ZISH"
 ;. . I %ZISH["*" S %ZXDEL=0 Q  ; Wild card not allowed.
 ;. . S %ZX=$S(%ZISH[%ZX1:%ZISH,1:%ZX1_%ZISH) ; prepend directory path
 ;. . I %ZOS="VMS",%ZX'[";" S %ZX=%ZX_";*"
 ;. . S %ZFOUND=$ZSEARCH(%ZX)]""  ; File exists
 ;. . S:%ZFOUND %ZARG=$S(%ZARG="":%ZX,1:%ZARG_%ZDELIM_%ZX) ; join files
 ;. . I $L(%ZARG)>2000 S %=$ZF(-1,%ZCOMND_%ZARG),%ZARG="" H 1 ; delete files at a time
 ;. ;
 ;. I $L(%ZARG) S %=$ZF(-1,%ZCOMND_%ZARG) ; delete remaining files
 ;;
 ;I %ZXDEL S %ZXDEL='$$LIST(%ZX1,%ZX2,"%ZLIST")
 ;Q %ZXDEL
 ;;
 ;DELERR ;Trap any $ETRAP error, unwind and return.
 ;S $ETRAP="D UNWIND^%ZTER"
 ;S %ZXDEL=0,%ZARG=""
 ;D UNWIND^%ZTER
 ;Q
 ;;
 ;DEL1(%ZX3) ;ef,SR. Delete one file
 ;N %ZI1,%ZI2
 ;D SPLIT(%ZX3,.%ZI1,.%ZI2) S %ZI2(%ZI2)=""
 ;Q $$DEL(%ZI1,$NA(%ZI2))
 ;;
 ;SPLIT(%I,%O1,%O2) ;Split to path,file
 ;N %ZOS,%D,D S %ZOS=$$OS^%ZOSV
 ;I %ZOS["VMS" D  Q
 ;. S D=$S(%I["]":"]",1:":")
 ;. S %O1=$P(%I,D,1)_D,%O2=$P(%I,D,2)
 ;. Q
 ;S %D=$S(%ZOS="UNIX":"/",%ZOS="NT":"\",1:""),%O1="",%O2="" Q:%D=""
 ;S D=$L(%I,%D),%O1=$P(%I,%D,1,D-1),%O2=$P(%I,%D,D)
 ;Q
 ;;
 ;FEXIST(%PATH,%FL) ;Check if files exsist.
 ;;S Y=$$DTEST("/usr/var",$NA(array))
 ;N %ZISH,%ZISHY
 ;S %ZISH=$$LIST(%PATH,%FL,"%ZISHY")
 ;Q %ZISH
 ;;
 ;----- END IHS MODIFICATION XU*8.0*1017
 ;
LIST(%ZX1,%ZX2,%ZX3) ;ef,SR. Create a local array holding file names
 ;S Y=$$LIST^%ZISH("\dir\",$NA(array),$NA(return array)) Return 1 if found anything
 ;
 N %ZISH,%ZISHN,%ZX,%ZISHY,%ZY,%ZOS
 S %ZX1=$$DEFDIR($G(%ZX1)),%ZOS=$$OS^%ZOSV
 ;S %ZX1=$$TRNLNM(%ZX1)
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1017
 ;TASSC/MFD added LISTI sub to accommodate IHS call without $NA array in %ZX2
 S %ZISHT=$ZT,X="*LISTI",@^%ZOSF("TRAP")             ;TASSC/MFD, 9/9/02 added * to not unwind stack
 I %ZX2'["*",$D(@%ZX2)<10 G LISTI                  ;TASSC/MFD
 I %ZX2["*",$D(@%ZX2)<10 G LISTI                    ;TASSC/MFD
 ;----- END IHS MODIFICATION - XU*8.0*1017
 ;
 ;Get fls to act on
 S %ZISH="" F  S %ZISH=$O(@%ZX2@(%ZISH)) Q:%ZISH=""  D
 . S %ZISHY=$P(%ZISH,"*")
 . I %ZOS="VMS",%ZISH'["." S %ZISH=%ZISH_".*" ;Allways upper
 . ;NT, display case, ignore for lookup
 . S %ZX=%ZX1_%ZISH
 . F %ZISHN=0:1 D  Q:(%ZX="")
 . . S %ZX=$ZSEARCH($S(%ZISHN:"",1:%ZX))
 . . ;Q:(%ZX="")!($$UP^XLFSTR(%ZX)'[%ZISHY)!(%ZX?.E1.2".")
 . . Q:(%ZX="")!(%ZX?.E1.2".")
 . . I %ZOS="VMS" S %ZX=$P(%ZX,"]",2),@%ZX3@(%ZX)=""
 . . I %ZOS="NT" S %ZY=$P(%ZX,"\",$L(%ZX,"\")),@%ZX3@(%ZY)=""
 . . I %ZOS="UNIX" S %ZY=$P(%ZX,"/",$L(%ZX,"/")) Q:%ZX'[%ZISHY  S @%ZX3@(%ZY)=""
 . . Q
 S X=%ZISHT,@^%ZOSF("TRAP")                         ;TASSC/MFD reset trap
 Q $O(@%ZX3@(""))]""
 ;
 ;----- BEGIN IHS MOFIDICATION - XU*8.0*1017
 ; Re-introducing IHS code
MV(X1,X2,Y1,Y2) ;ef,SR. Rename a fl
 ;S Y=$$MV^ZOSHDOS("\dir\","fl","\dir\","fl")
 ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1008
 ;This subroutine is rewritten to make sure the correct path is used
 ;when renaming or moving a file.  IHS/ITSC/AEF/04/28/03
 N X,Y,%ZISHMVC
 S X1=$$DEFDIR($G(X1)),Y1=$$DEFDIR($G(Y1))
 S X=X1_X2,Y=Y1_Y2
 S %ZISHMVC=$S($ZV["UNIX":"mv",1:"move")
 Q $$JOBWAIT^%HOSTCMD(%ZISHMVC_" "_X_" "_Y)
 ;----- END IHS MODIFICATION - XU*8.0*1008
 N %,%ZB,%ZC,%ZISHDV1,%ZISHDV2,%ZISHFN1,%ZISHFN2,%ZISHPCT,%ZISHSIZ,%ZISHX,X,Y,%ZISHMVC
 S X1=$$DEFDIR($G(X1)),Y1=$$DEFDIR($G(Y1))
 S X=X1_X2,Y=Y1_Y2
 S %ZISHMVC=$S($ZV["UNIX":"cp ",1:"copy ")        ;TASSC/MFD added line to allow cp on UNIX
 S %=$ZF(-1,%ZISHMVC_X_" "_Y)                     ;TASSC/MFD changed X1/Y1 to X/Y
 S %ZISHX(X2)="" S Y=$$DEL^%ZISH(X1,$NA(%ZISHX))
 Q 1
 ;
 S (%ZISHPCT,%ZB,%ZC)=0
 D SLOWCOPY S %ZISHX(X2)="" S Y=$$DEL^%ZISH(X1,$NA(%ZISHX))
 Q 1
 ;
SLOWCOPY ; Copy without view buffer
 N X,Y
 O %ZISHDV1:(%ZISHFN1:"R"::::""),%ZISHDV2:(%ZISHFN2:"W"::::"")
 FOR  DO  Q:%ZC!(%ZB=%ZISHSIZ)
 . U %ZISHDV1 R X#1024 Q:$L(X)=0
 . U %ZISHDV2 W X S %ZB=$ZB,%ZC=$ZC Q:%ZC
 . I %ZB=%ZISHSIZ C %ZISHDV2 S %ZC=($ZA=-1)
 . S X=%ZB/%ZISHSIZ*100\1 ; %done
 . Q:X=%ZISHPCT  S %ZISHPCT=X
 . Q  ;U 0 W $J(%ZISHPCT,3),*13
 Q
 ;
 ;---------------------------------------------
 ; Commented below VA logic due to unknown side effects IHS/OIT/FBD
 ;MV(X1,X2,Y1,Y2) ;ef,SR. Rename a fl
 ;;S Y=$$MV^ZOSHDOS("\dir\","fl","\dir\","fl")
 ;;Unix use mv, NT/VMS use COPY and DEL
 ;N %,X,Y,%ZOS,%ZISHX S %ZOS=$$OS^%ZOSV
 ;S X1=$$DEFDIR($G(X1)),Y1=$$DEFDIR($G(Y1))
 ;S X=$ZSEARCH(X1_X2),Y=Y1_Y2 ;move X to Y
 ;I X="" Q 0
 ;;Move to same place can delete file. Since at destination return 1
 ;I $P(X,";")=Y Q 1
 ;S %=$ZF(-1,$S(%ZOS="UNIX":"mv ",1:"copy ")_X_" "_Y) ;Use NT/VMS copy
 ;I %ZOS'="UNIX" D
 ;. S X2=$P(X,X1,2),%ZISHX(X2)=""
 ;. S Y=$$DEL^%ZISH(X1,$NA(%ZISHX))
 ;Q 1
 ;;
 ;----- END IHS MODIFICATION - XU*8.0*1017
 ;-----------------------------------------------------
 ; BEGIN IHS MODIFICATION - XU*8.0*1017
 ; Re-introduce IHS code and comment VA modifications - IHS/OIT/FBD
 ;
PWD(X) ;ef,SR. Print working directory    ;TASSC/MFD parameter put back in for IHS
 N Y
 S Y=$$DEFDIR("")
 I Y="" S Y=$ZSEARCH("*")
 S X(1)=$P(Y,".",1)
 Q X(1)      ;TASSC/MFD changed to subscripted return var
 ;
 ; Commented below VA code - IHS/OIT/FBD - XU*8.0*1017
 ;PWD() ;ef,SR. Print working directory
 ;N Y,%ZOS
 ;S Y=$$DEFDIR(""),%ZOS=$$OS^%ZOSV
 ;I Y="" S Y=$ZSEARCH("*")
 ;Q $S(%ZOS["VMS":Y,1:$P(Y,".",1))
 ; - END IHS MODIFICATION - XU*8.0*1017
 ;
TRNLNM(PATH) ;ef. Expand logical path
 N %ZOS,P1,P2
 S %ZOS=$$OS^%ZOSV,PATH=$G(PATH)
 I %ZOS="VMS" D  Q PATH
 . S P1=PATH_$S(PATH[":":"*.*",1:":*.*")
 . S P2=$ZSEARCH(P1)
 . S:$L(P2) PATH=$S(P2["]":$P(P2,"]",1,$L(P2,"]")-1)_"]",1:$P(P2,":",1)_":")
 . Q
 I %ZOS="NT" D  Q PATH
 . S P1=PATH_$S($E(PATH,$L(PATH))'="\":"\*",1:"*"),P2=$ZSEARCH(P1)
 . S:$L(P2) PATH=$P(P2,"\",1,$L(P2,"\")-1)_"\"
 . Q
 ;Unix Cache $ZSEARCH uses % around an environment variable
 I %ZOS="UNIX" D  Q PATH
 . S P1=PATH_$S($E(PATH,$L(PATH))'="/":"/*",1:"*"),P2=$ZSEARCH(P1)
 . S:$L(P2) PATH=$P(P2,"/",1,$L(P2,"/")-1)_"/"
 . Q
 Q PATH
 ;
DEFDIR(DF) ;ef. Default Dir and frmt
 ;Need to handle NT, VMS and Linux
 N %ZOS,P1,P2 S %ZOS=$$OS^%ZOSV,DF=$G(DF)
 Q:DF="." "" ;Special way to get current dir.
 S:DF="" DF=$G(^XTV(8989.3,1,"DEV")),DF=$P(DF,"^",$S($$PRI^%ZOSV<2:1,1:2))
 Q:DF="" ""
 ;Check syntax, VMS needs disk:[dir] or logical:
 I %ZOS="VMS" D
 . I DF[":" S P1=$P(DF,":")_":",P2=$P(DF,":",2)
 . E  S P1="",P2=DF
 . I P1="",P2["$" S P1=P2,P2=""  ;Could be a logical
 . I $L(P2) S:P2'["[" P2="["_P2 S:P2'["]" P2=P2_"]"
 . S DF=P1_P2 S:DF'[":" DF=DF_":"
 . Q
 ;Check syntax, Unix needs /mnt/fl, ./fl, ~/fl %HOME%/fl
 I %ZOS="UNIX" D
 . S DF=$TR(DF,"\","/")
 . S:$E(DF,$L(DF))'="/" DF=DF_"/"
 . Q
 ;Check syntax, NT needs c:\dir\
 I %ZOS="NT" D
 . N P1,P2
 . I DF[":" S P1=$P(DF,":")_":",P2=$P(DF,":",2)
 . E  S P1="",P2=DF
 . S P2=$TR(P2,"/","\")
 . I $L(P2) S:".\"'[$E(P2,1) P2="\"_P2 S:$E(P2,$L(P2))'="\" P2=P2_"\"
 . S DF=P1_P2
 . Q
 S DF=$$TRNLNM(DF) ;Resolve logicals
 Q DF
 ; BEGIN IHS MODIFICATION - XU*8.0*1017
DF(X) ;Dir frmt  ;TASSC/MFD added DF+2
 Q:X=""
 I $ZV["UNIX" S X=$TR(X,"\","/") S:$E(X,$L(X))'="/" X=X_"/" Q    ;TASSC/MFD added line for UNIX sys
 S X=$TR(X,"/","\")
 I $E(X,$L(X))'="\" S X=X_"\" Q
 Q
 ; END IHS MODIFICATION - XU*8.0*1017
FL(X) ;Fl len
 N ZOSHP1,ZOSHP2
 S ZOSHP1=$P(X,"."),ZOSHP2=$P(X,".",2)
 I $L(ZOSHP1)>8 S X=4 Q
 I $L(ZOSHP2)>3 S X=4 Q
 Q
 ;
STATUS() ;ef,SR. Return EOF status
 U $I
 Q $$EOF($ZEOF)
 ;
EOF(X) ;Eof flag, pass in $ZEOF
 ;Q (X=-1)  ;XU*8.0*1017 - ORIGINAL LINE - COMMENTED OUT
 Q $ZEOF  ;TASSC/MFD check for $ZEOF rather than ENDOFFILE error  XU*8.0*1017
 ;
MAKEREF(HF,IX,OVF) ;Internal call to rebuild global ref.
 ;Return %ZISHF,%ZISHO,%ZISHI,%ZISUB
 N I,F,MX
 S OVF=$G(OVF,"%ZISHOF")
 S %ZISHI=$QS(HF,IX),MX=$QL(HF) ;
 S F=$NA(@HF,IX-1) ;Get first part
 I IX=1 S %ZISHF=F_"(%ZISHI" ;Build root, IX=1
 I IX>1 S %ZISHF=$E(F,1,$L(F)-1)_",%ZISHI" ;Build root
 S %ZISHO=%ZISHF_","_OVF_",%OVFCNT)" ;Make overflow
 F I=IX+1:1:MX S %ZISHF=%ZISHF_",%ZISUB("_I_")",%ZISUB(I)=$QS(HF,I)
 S %ZISHF=%ZISHF_")"
 Q
 ;
READNXT(REC) ;Read any sized record into array. %ZB has terminator
 N %,I,X,$ES,$ET S REC="",$ET="D READNX^%ZISH Q"
 U IO R X:5 S %ZB=$A($ZB),REC=$E(X,1,255)
 Q:$L(X)<256
 S %=256 F I=1:1 Q:$L(X)<%  S REC(I)=$E(X,%,%+254),%=%+255
 Q
READNX ;Check for EOF
 ;I $ZE["ENDOFFILE" S %ZA=-1   ;TASSC/MFD commented out
 ;S $EC=""                     ;IHS/OIT/FBD - COMMENTED OUT  XU*8.0*1017
 I $ZEOF S %ZA=-1              ;TASSC/MFD added line since we are checking for $ZEOF
 Q
 ;
FTG(%ZX1,%ZX2,%ZX3,%ZX4,%ZX5) ;ef,SR. Unload contents of host file into global
 ;p1=hostf file directory
 ;p2=host file name
 ;p3= $NAME REFERENCE INCLUDING STARTING SUBSCRIPT
 ;p4=INCREMENT SUBSCRIPT
 ;p5=Overflow subscript, defaults to "OVF"
 N %ZA,%ZB,%ZC,%XX,%OVFCNT,%ZISHF,%ZISHO,POP,%ZISUB,$ES,$ET
 N I,%ZISH,%ZISH1,%ZISHI,%ZISHL,%ZISHOF,%ZISHOX,%ZISHS,%ZX,%ZISHY
 S %ZX1=$$DEFDIR($G(%ZX1)),%ZISHOF=$G(%ZX5,"OVF")
 D MAKEREF(%ZX3,%ZX4,"%ZISHOF")
 D OPEN^%ZISH(,%ZX1,%ZX2,"R")
 I POP Q 0
 S %ZC=1,%ZA=0,$ET="S %ZC=0,%ZA=-1,$EC="""" Q"
 S X="ERREOF^%ZISH",@^%ZOSF("TRAP") ; Added line from IHS side IHS/OIT/FBD - XU*8.0*1017
 U IO F  K %XX D READNXT(.%XX) Q:$$EOF($ZEOF)!%ZA  D
 . S @%ZISHF=%XX
 . I $D(%XX)>2 F %OVFCNT=1:1 Q:'$D(%XX(%OVFCNT))  S @%ZISHO=%XX(%OVFCNT)
 . S %ZISHI=%ZISHI+1
 . Q
 D CLOSE() ;Normal exit
 Q %ZC
 ;
GTF(%ZX1,%ZX2,%ZX3,%ZX4) ;ef,SR. Load contents of global to host file.
 ;p1=$NAME of global reference
 ;p2=incrementing subscript
 ;p3=host file directory
 ;p4=host file name
 N %ZISHY,%ZISHOX
 S %ZISHY=$$MGTF(%ZX1,%ZX2,%ZX3,%ZX4,"W")
 Q %ZISHY
 ;
GATF(%ZX1,%ZX2,%ZX3,%ZX4) ;ef,SR. Append to host file.
 ;
 ;p1=$NAME of global reference
 ;p2=incrementing subscript
 ;p3=host file directory
 ;p4=host file name
 N %ZISHY
 S %ZISHY=$$MGTF(%ZX1,%ZX2,%ZX3,%ZX4,"A")
 Q %ZISHY
 ;
MGTF(%ZX1,%ZX2,%ZX3,%ZX4,%ZX5) ;
 ;p1=$NAME of global reference
 ;p2=incrementing subscript
 ;p3=host file directory
 ;p4=host file name
 N %ZISH,%ZISH1,%ZISHI,%ZISHL,%ZISHS,%ZISHOX,IO,%ZX,Y,%ZC
 D MAKEREF(%ZX1,%ZX2)
 D OPEN^%ZISH(,$G(%ZX3),%ZX4,%ZX5) ;Default dir set in open
 I POP Q 0
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1017 IHS/OIT/FBD
 ; commented VA code and added IHS logic
 ;N $ETRAP S $ETRAP="S $EC="""" D CLOSE^%ZISH() Q 0"
 N X S X="ERREOF^%ZISH",@^%ZOSF("TRAP")
 ;----- END IHS MODIFICATION - XU*8.0*1017
 F  Q:'($D(@%ZISHF)#2)  S %ZX=@%ZISHF,%ZISHI=%ZISHI+1 U IO W %ZX,!
 D CLOSE()
 Q 1
 ;
 ; BEGIN IHS MODIFICATION - XU*8.0*1017
 ;
 ; TASSC/MFD all subs below are IHS-added
 ; 
OPENI(X1,X2,X3) ; called from OPEN sub above, or can be called directly
 N %,%1,%2,%I,%T,%ZA,%ZISHIO
 S %I=$I,%T=0,POP=0,X1=$$DEFDIR($G(X1)) M %ZISHIO=IO   ;TASSC/MFD 11/15/02 uncommented and changed X2= to X1= to get \ appended to directory variable X1
 S %1=$S(X3["A":"AW",X3["W":"WN",1:"R")_$S(X3["B":"U",1:"S") ;$$MODE^%ZISF(X2_X3,X4)
 S %=X1_X2 O %:(%1):2 I '$T S POP=1 Q 1
 U % S %ZA=$ZA
 I %ZA=-1 U:%I]"" %I C % S POP=1 Q 1
 S IO=%,IO(1,IO)="",IOT="HFS",POP=0
 ;I $G(X1)]"" D SAVDEV^%ZISUTL(X1)
 I '$D(ZTQUEUED) U IO(0)
 Q 0
 ;
DELI ; called from DEL sub above
 S X=%ZISHT,@^%ZOSF("TRAP")         ; reset the trap
 S %ZISH=%ZX2,%=$S(%ZISH[%ZX1:%ZISH,1:%ZX1_%ZISH) D  
 . S %=$ZF(-1,%ZISHDC_%)
 Q %
LISTI  ;List files, put in %ZX3 array
 ; called from LIST sub above
 ; reset trap first
 S X=%ZISHT,@^%ZOSF("TRAP")                     ;TASSC/MFD reset trap
 S VAR=1    ;VAR=1 means no files or a problem
 I $G(%ZX1)']""!($G(%ZX2)']"") Q
 S %ZX=%ZX1_%ZX2,%ZISHY=$$UP^XLFSTR($P(%ZX,"*"))
 F %ZISHN=0:1 D  Q:(%ZX="")
 . S %ZX=$ZSEARCH($S(%ZISHN:"",1:%ZX))
 . Q:(%ZX="")!($$UP^XLFSTR(%ZX)'[%ZISHY)!(%ZX?.E1.2".")
 . I $ZV["UNIX" S %ZY=$P(%ZX,"/",$L(%ZX,"/")),%ZX3(%ZISHN+1)=%ZY
 . I $ZV["Windows" S %ZY=$P(%ZX,"\",$L(%ZX,"\")),%ZX3(%ZISHN+1)=%ZY
 ;S VAR='$D(%ZX3)
 Q '$D(%ZX3)
 ;
SEND(ZISH1,ZISH2,ZISH3,ZISHPARM) ;Send UNIX or Windows fl
 ;  S Y=$$SEND^%ZISH("/dir/","fl","mach","ftpsend param")
 ;                           "fl*"
 ;                           .array
 ; TASSC/MFD added ZISHPARM as a 4th parameter, parameters for send scripts
 ; 
 NEW ZISH
 S ZISH1=$G(ZISH1) ; If directory not passed, use system.
 I '$L($G(ZISH2)) Q "-1^<file not specified>"
 I '$L($G(ZISH3)) Q "-1^<destination not specified>"
 S Y=$$LIST(.ZISH1,ZISH2,.ZISH2) ; Put array of files in ZISH2()
 I '$L($G(ZISHPARM)) S ZISHPARM="-a"   ; -a for ascii mode with ftpsend
 S ZISHC="cd /usr/spool/uucppublic; ftpsend "      ;TASSC/MFD moved script into a var
 ; -n = suppress sending results in UNIX mail message to the user
 ; -c = pack file(s) with 'compress' before sending
 I $ZV["Windows" S ZISHC="sendto "         ;TASSC/MFD accommodate Windows, use full path names on files
 F ZISH=1:1 Q:'$D(ZISH2(ZISH))  D
 . S ZISHC=ZISHC_ZISHPARM_" "_ZISH3_" "_ZISH2(ZISH)
 . D JW   ;IHS/AAO/RPL 4/9/99 ftpsend after cd to public or nothing gets sent.
 Q ZISHX  ;IHS/AAO/RPL moved down from above line
 ;
JW ; -- Cache extrinsic.
 S ZISHX=$$JOBWAIT^%HOSTCMD(ZISHC)
 ; Excepted from SAC 6.1.5, 6.1.2.2 and 6.1.2.3 memo dated 16Nov93.
 Q
 ;
IP() ; return underlying connections ip address
 Q $P($ZU(54,13,$P($ZIO,"/")),",")
HOST() ; return underlying host name
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1008
 ;The line below is commented out and replaced by new line to return
 ;the underlying Cache server name.  IHS/ITSC/AEF/05-01-03
 ;Q $P($ZU(54,13,$P($ZIO,"/")),",",2)      
 Q $ZU(110)
 ;
 ;New subroutine CLIENT is added to return the underlying Cache
 ;client name
CLIENT() ;return underlying client name - only works if reverse DNS
 ;available
 Q $P($ZU(54,13,$P($ZIO,"/")),",",2)
 ;----- END IHS MODIFICATION - XU*8.0*1008
 ;
SENDTO1(ZISH1,ZISH2)         ;use sendto1 script
 ;
 Q $$SENDTO1^ZISHMSMU(ZISH1,ZISH2)
 ;----- END IHS MOD - XU*8.0*1017
