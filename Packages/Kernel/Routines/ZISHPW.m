%ZISH ;IHS\PR,SFISC/AC - Host File Control for MSM (PW);09/23/96  11:22 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**24,36**;JUL 10, 1995
 ;THIS ROUTINE CONTAINS IHS MODIFICATIONS BY IHS/ADC/GTH 2/19/97; IHS/ANMC/LJF 2/19/97
 ;THIS IS ROUTINE ZISHPW
 ;
OPEN(X1,X2,X3,X4,X5)    ;SR. Open Host File
 I $$IHS^ZISHMSMU Q $$OPEN^ZISHMSMU(X1,X2,X3)  ; IHS/ADC/GTH 2/19/97
 ;X1=handle name
 ;X2=directory name \dir\
 ;X3=file name
 ;X4=file access mode e.g.: W for write, R for read, A for append.
 ;X5=Max record size for a new file
 N %,%1,%2,%I,%T,%ZA,%ZISHIO
 S %I=$I,%T=0,POP=0 M %ZISHIO=IO
 F %=51:1:54 O %::0 I $T S %T=% Q
 I '%T U:%I]"" %I S POP=1 Q
 S %1=$$MODE^%ZISF(X2_X3,X4)
 S %2=%_":"_%1
 U @%2 S %ZA=$ZA
 I %ZA=-1 U:%I]"" %I C % S POP=1 Q
 S IO=%,IO(1,IO)=""
 I $G(X1)]"" D SAVDEV^%ZISUTL(X1)
 Q
 ;
CLOSE(X) ;SR. Close HFS device not opened by %ZIS.
 ;X=HANDLE NAME
 ;IO=Device
 N %
 I $G(IO)]"" C IO K IO(1,IO)
 I $G(X)]"" D RMDEV^%ZISUTL(X)
 D HOME^%ZIS
 Q
 ;
OPENERR ;
 Q 0
 ;
DEL(%ZISHX1,%ZISHX2) ;SR. Del fl(s)
 I $$IHS^ZISHMSMU Q $$DEL^ZISHMSMU(%ZISHX1,%ZISHX2)  ; IHS/ADC/GTH 2/19/97
 ;S Y=$$DEL^ZOSHMSM("\dir\","fl")
 ;                         ,.array)
 ;Changed X2 to a $NAME string
 N %,%ZISH
 N ZOSHDA,ZOSHF,ZOSHX,ZOSHQ,ZOSHDF,ZOSHC
 S %ZISHX1=$TR(%ZISHX1,"/","\")
 ;Get fls to act on
 ;No '*' allowed
 S %ZISH="" F  S %ZISH=$O(@%ZISHX2@(%ZISH)) Q:'%ZISH  I %ZISH["*" S ZOSHQ=1 Q
 I $D(ZOSHQ) Q 0
 S %ZISH="" F   S %ZISH=$O(@%ZISHX2@(%ZISH)) Q:%ZISH=""  D
 .;S ZOSHC="rm "_X1_%
 .S ZOSHC=$ZOS(2,%ZISHX1_%ZISH)
 .;D JW
 Q 1
 ;
LIST(%ZISHX1,%ZISHX2,%ZISHX3) ;SR. Create a local array holding fl names
 I $$IHS^ZISHMSMU Q $$LIST^ZISHMSMU(%ZISHX1,%ZISHX2,.%ZISHX3)  ; IHS/ADC/GTH 2/19/97
 ;S Y=$$LIST^ZOSHDOS("\dir\","fl",".return array")
 ;                           "fl*",
 ;                           .array,
 ;
 ;Change X2 = $NAME OF CLOSE ROOT
 ;Change X3 = $NAME OF CLOSE ROOT
 ;
 N %ZISH,%ZISHN,%ZISHX,%ZISHY
 S %ZISHN=0
 ;Get fls to act on
 S %ZISH="" F  S %ZISH=$O(@%ZISHX2@(%ZISH)) Q:%ZISH=""  D
 .S %ZISHX=%ZISHX1_%ZISH
 .F %ZISHN=1:1 D  Q:$P(%ZISHY,"^")=""!(%ZISHY<0)  S @%ZISHX3@($P(%ZISHY,"^"))="" ;S @%ZISHX3@(%ZISHN)=$P(%ZISHY,"^")
 ..I %ZISHN>1 S %ZISHY=$ZOS(13,%ZISHY)
 ..E  S %ZISHY=$ZOS(12,%ZISHX,0)
 Q $O(@%ZISHX3@(""))]""
 ;
MV(X1,X2,Y1,Y2) ;SR. Rename a fl
 I $$IHS^ZISHMSMU Q $$MV^ZISHMSMU(X1,X2,Y1,Y2)  ; IHS/ADC/GTH 2/19/97
 ;S Y=$$MV^ZOSHDOS("\dir\","fl","\dir\","fl")
 ;
 N %ZB,%ZC,%ZISHDV1,%ZISHDV2,%ZISHFN1,%ZISHFN2,%ZISHPCT,%ZISHSIZ,%ZISHX,X,Y
 S X=X1_X2
 S Y=Y1_Y2
 I X1=Y1 Q $ZOS(3,X,Y)'<0
 ;
 S %ZISHDV1=51,%ZISHDV2=52,%ZISHFN1=X,%ZISHFN2=Y
 O %ZISHDV1:(%ZISHFN1)
 O %ZISHDV2:(%ZISHFN2:"W")
 U %ZISHDV1:(::0:2) S %ZISHSIZ=$ZB U %ZISHDV1:(::0:0) S (%ZISHPCT,%ZB,%ZC)=0
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
PWD(X) ;SR. Print working directory
 Q $$PWD^ZISHMSMU(.X)   ; IHS/ANMC/LFJ  2/19/97
 I $ZV["UNIX" Q $$PWD^ZISHMSMU()  ; IHS/ADC/GTH  2/19/97
 N Y
 S Y=$ZOS(11,$ZOS(14))
 Q:Y<0 ""
 S Y=Y_$S($E(Y,$L(Y))'="\":"\",1:"")
 Q $ZOS(14)_":"_Y
 ;
JW ;Call dos $ZOS
 S ZOSHX=$ZOS(ZOSHNUM,ZOSHC)
 Q
DF(X) ;Dir frmt
 Q:X=""
 S X=$TR(X,"/","\")
 I $E(X,$L(X))'="\" S X=X_"\"
 Q
FL(X) ;Fl len
 N ZOSHP1,ZOSHP2
 S ZOSHP1=$P(X,"."),ZOSHP2=$P(X,".",2)
 I $L(ZOSHP1)>8 S X=4 Q
 I $L(ZOSHP2)>3 S X=4 Q
 Q
READNXT(REC) ;Read any sized record into array.
 N T,I,X,LB
 U IO S LB=$ZB R REC#255 S %ZA=$ZA,%ZB=$ZB,%ZC=$ZC,%ZL=%ZA Q:$$EOF(%ZC)
 Q:%ZA<255
 F I=1:1 S LB=LB+%ZA Q:LB<%ZB  R X#255 S %ZA=$ZA,%ZB=$ZB,%ZC=$ZC Q:$$EOF(%ZC)!('$L(X))  S REC(I)=X
 Q
STATUS() ;SR. Return EOF status
 ;U $I
 Q $ZC
 ;
 Q $$EOF($ZC)
 ;
EOF(X) ;Eof flag, pass in $ZC
 Q (X=-1)
 ;
READREC(X) ;Read record from host file.
 N Y
 U IO R X S Y=$ZC
 U $P
 Q Y
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
FTG(%ZISHX1,%ZISHX2,%ZISHX3,%ZISHX4,%ZISHX5) ;SR. Unload contents of host file into global
 ;p1=hostf file directory 
 ;p2=host file name
 ;p3= $NAME REFERENCE INCLUDING STARTING SUBSCRIPT
 ;p4=INCREMENT SUBSCRIPT
 ;p5=Overflow subscript, defaults to "OVF"
 N %ZA,%ZB,%ZC,%ZL,X,%OVFCNT,%CONT
 N I,%ZISH,%ZISH1,%ZISHI,%ZISHL,%ZISHOF,%ZISHOX,%ZISHS,%ZISHX,%ZISHY,POP,%ZISUB
 S %ZISHOF=$G(%ZISHX5,"OVF")
 D MAKEREF(%ZISHX3,%ZISHX4,"%ZISHOF")
 D OPEN^%ZISH(,%ZISHX1,%ZISHX2,"R")
 I POP Q 0
 S X="ERREOF^%ZISH",@^%ZOSF("TRAP")
 U IO F  K %XX D READNXT(.%XX) Q:$$EOF(%ZC)  D
 . S @%ZISHF=%XX
 . I $D(%XX)>2 F %OVFCNT=1:1 Q:'$D(%XX(%OVFCNT))  S @%ZISHO=%XX(%OVFCNT)
 . S %ZISHI=%ZISHI+1
 . Q
 D CLOSE() ;Normal exit
 Q 1
 ;
ERREOF D CLOSE() ;Error close and exit
 Q 0
 ;
GTF(%ZISHX1,%ZISHX2,%ZISHX3,%ZISHX4) ;SR. Load contents of global to host file.
 ;Previously name LOAD
 ;p1=$NAME of global reference
 ;p2=incrementing subscript
 ;p3=host file directory
 ;p4=host file name
 N %ZISHY,%ZISHOX
 S %ZISHY=$$MGTF(%ZISHX1,%ZISHX2,%ZISHX3,%ZISHX4,"W")
 Q %ZISHY
 ;
GATF(%ZISHX1,%ZISHX2,%ZISHX3,%ZISHX4) ;SR. Append to host file.
 ;
 ;p1=$NAME of global reference
 ;p2=incrementing subscript
 ;p3=host file directory
 ;p4=host file name
 N %ZISHY
 S %ZISHY=$$MGTF(%ZISHX1,%ZISHX2,%ZISHX3,%ZISHX4,"A")
 Q %ZISHY
MGTF(%ZISHX1,%ZISHX2,%ZISHX3,%ZISHX4,%ZISHX5) ;
 ;p1=$NAME of global reference
 ;p2=incrementing subscript
 ;p3=host file directory
 ;p4=host file name
 N %ZISH,%ZISH1,%ZISHI,%ZISHL,%ZISHS,%ZISHOX,IO,%ZISHX,Y
 D MAKEREF(%ZISHX1,%ZISHX2)
 D OPEN^%ZISH(,%ZISHX3,%ZISHX4,%ZISHX5)
 I POP Q 0
 N X
 S X="ERREOF^%ZISH",@^%ZOSF("TRAP")
 F  Q:'($D(@%ZISHF)#2)  S %ZISHX=@%ZISHF,%ZISHI=%ZISHI+1 U IO W %ZISHX,!
 D CLOSE()
 Q 1
 ;
