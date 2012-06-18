AMQQEM1 ; IHS/CMI/THL - GETS DOS/UNIX PATH AND FILE NAME ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I $G(^DD("OS"))'=8&($G(^DD("OS"))'=18) S AMQQEM("FORMAT")="MUMPS" Q
 I ^%ZOSF("OS")["UNIX" S AMQQEM("FORMAT")="UNIX" G RUN
 I ^%ZOSF("OS")["PC"!(^%ZOSF("OS")["386")!(^%ZOSF("OS")["NT") S AMQQEM("FORMAT")="PC" G RUN
 S AMQQEM("FORMAT")="MUMPS"
 Q
RUN S U="^"
 F AMQQERUN=12:1:14 D @$P("UNIX^FILE^OVER",U,AMQQERUN-11) Q:AMQQERUN<11  I $D(AMQQQUIT) Q
EXIT Q
 ;
MARK W !!,"---------",!!
 Q
 ;
FWD S AMQQEMS=AMQQERUN_U_AMQQEMS
 Q
 ;
BACKUP S AMQQERUN=$P(AMQQEMS,U)-1
 S AMQQEMS=$P(AMQQEMS,U,2,99)
 Q
 ;
CK I $D(DIRUT)!($D(DUOUT))!($D(DTOUT))!($D(DIROUT))!(X="") K DIRUT,DUOUT,DTOUT,DIROUT S AMQQQUIT=""
 Q
 ;
VAR ;EP; OS VARIABLES
 N X,I
 ; The following line contain commands that perform OPEN, USE
 ; commands without use of the kernel utilities. - An exemption to
 ; SAC 6.3.1 has been approved by Jim McArthur per memo dated 
 ; May 17, 1993. This exemption is only for version 2. ** BRJ/IHS ** 6/7/93
 I ^DD("OS")=18 D  Q
 .S AMQQEX("CHECK")="D OPEN^%ZISH("""",AMQQEX(""PATH""),AMQQEX(""FILE"")) Q:'$T  U IO S Y=$ZA"
 .S AMQQEX("IOP")="HFS"
 .S AMQQEX("READ")="D OPEN^%ZISH("""",AMQQEX(""PATH""),AMQQEX(""FILE""),""R"")"
 .S AMQQEX("WRITE")="D OPEN^%ZISH("""",AMQQEX(""PATH""),AMQQEX(""FILE""),""W"")"
 .S AMQQEX("USE")="U IO"
 .S AMQQEX("CLOSE")="D CLOSE^%ZISH()"
 .S AMQQEX("EOF")="S X=$$EOF^%ZISH()"
 .S AMQQEX("WRAPOFF")="U 0:(0)"
 S X="O 51:(AMQQEFN):5 Q:'$T  U 51 S Y=$ZA^51^O 51:(AMQQEFN:""R""::::$C(10)):5^O 51:(AMQQEFN:""W""):5^U 51^C 51^^U 0:(0)"
 F I=1:1:8 S AMQQEX($P("CHECK^IOP^READ^WRITE^USE^CLOSE^EOF^WRAPOFF",U,I))=$P(X,U,I)
 Q
 ;
UNIX ; UNIX CHOICES ; 11
 D MARK
 W "OUTPUT FILE LOCATION",!
 I AMQQEM("FORMAT")="PC" D PC Q
 S DIR(0)="S^1:UNIX FILE;2:MUMPS FILE"
 S DIR("A")="     Your choice"
 S DIR("?")="See User's Guide or type '??' for a full explanation of output format alternatives"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 D FWD
 S AMQQEM("FORMAT")=$S(Y=1:"UNIX",1:"MUMPS")
 I $G(AMQQEX("PATH"))["\" K AMQQEX("PATH")
 I Y=2 S AMQQERUN=99,AMQQEM("FORMAT")="MUMPS"
 Q
 ;
PC ; PC CHOICES ; 11
 S DIR(0)="S^1:DOS FILE;2:MUMPS FILE"
 S DIR("A")="     Your choice"
 S DIR("?")="See User's Guide or type '??' for a full explanation of output format alternatives."
 S DIR("??")="AMQQEMANHOST"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 D FWD
 S AMQQEM("FORMAT")=$S(Y=1:"DOS",1:"MUMPS")
 I $G(AMQQEX("PATH"))["/" K AMQQEX("PATH")
 I Y=2 S AMQQERUN=99
 Q
 ;
FILE ; FILE NAME AND PATH ; 12
 D VAR
 D MARK
 W "FILE NAME AND PATH",!
 I AMQQEM("FORMAT")="DOS" S DIR(0)="F^:",DIR("A")="Enter the DOS file (path, name, extension)",DIR("?")="Enter path, file name and extension; e.g., 'C:\DBASE\DATA\MYFILE.DAT'" I 1
 E  S DIR(0)="F^:",DIR("A")="Enter the UNIX file (path, name, extension)",DIR("?")="Enter path, file name and extension; e.g., 'user/mumps/myfile.data'"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP S AMQQERUN=11 Q
 D CK
 I $D(AMQQQUIT) Q
 D FWD
 S AMQQEX("FILE")=Y
 N AMQQEFN
 S AMQQEFN=AMQQEX("FILE")
CHKIT X AMQQEX("CHECK")
 E  W !,"The Host File Server is being used by someone else.  I will keep trying for 30 seconds.",!,"If it is still not free, I must terminate this session.",!! D  I $D(AMQQQUIT) Q
 .N H,T,D S H=$H,D=+H,T=$P(H,",",2)+30
 .F  X AMQQEX("CHECK") Q:$T  I +$H'=D!($P($H,",",2)>T) S AMQQQUIT="" Q
 .Q
 X AMQQEX("CLOSE")
 I Y'<0 Q
 I Y<0 X AMQQEX("WRITE"),AMQQEX("CHECK"),AMQQEX("CLOSE") I Y<0 W !!,"Sorry, I can't accept this path/filename...Check your User's Guide!" G FILE
F1 S X=AMQQEX("FILE")
 S Y=$S(AMQQEM("FORMAT")="DOS":"\",1:"/"),Z=$L(X,Y)
 I Z>1 S AMQQEX("PATH")=$P(X,Y,1,Z-1),X=$P(X,AMQQEX("PATH"),2,99)
 S %=$L(X,".")
 S AMQQEX("EXT")=$P(X,".",%)
 S AMQQEX("NAME")=$P($P(AMQQEX("FILE"),Y,Z),".")
 S AMQQERUN=99
 S AMQQEX("DOC")=$P(AMQQEX("FILE"),".")_".DOC"
 Q
 ;
OVER ; OVERWRITE OLD FILE ; 13
 D MARK
 W "OVERWRITE OLD FILE",!
 W !!,"This ASCII file already exists..."
 S DIR(0)="Y"
 S DIR("A")="Want to overwrite the old version"
 S DIR("B")="NO",DIR("?")="If you answer 'Y', you will destroy the old version and create a new file with the same name"
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U D BACKUP Q
 D CK
 I $D(AMQQQUIT) Q
 I Y="" S Y=0
 I 'Y D BACKUP Q
 D F1
 Q
 ;
