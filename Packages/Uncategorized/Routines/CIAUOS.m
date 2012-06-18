CIAUOS ;MSC/IND/DKM - Platform-dependent operations;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Return version #
VER() Q $P($T(+2),";",3)
CVTFN(CIAFIL,CIAROOT) ;
 N CIAZ,CIAZ1,CIAD
 S CIAD=$$DIRDLM,CIAROOT=$G(CIAROOT)
 S:$E(CIAROOT,$L(CIAROOT))=$E(CIAD,3) CIAROOT=$E(CIAROOT,1,$L(CIAROOT)-1)
 S CIAZ=$L(CIAFIL,"/"),CIAZ1=$P(CIAFIL,"/",1,CIAZ-1),CIAFIL=$P(CIAFIL,"/",CIAZ)
 S:$L(CIAZ1) CIAROOT=CIAROOT_$E(CIAD,$S($L(CIAROOT):2,1:1))_$TR(CIAZ1,"/.-",$E(CIAD,2))
 Q CIAROOT_$S($L(CIAROOT):$E(CIAD,3),1:"")_CIAFIL
 ; Set right margin
RM(X) ;EP
 X ^%ZOSF("RM")
 Q
 ; Test for tag/routine
TEST(X) ;EP
 N Z
 S:X[U Z=$P(X,U),X=$P(X,U,2)
 Q:'$L(X)!(X'?.1"%"1.AN) 0
 X ^%ZOSF("TEST")
 Q $S('$T:0,$G(Z)="":1,Z'?.1"%"1.AN:0,1:$T(@Z^@X)'="")
ETRAP() Q $$NEWERR^%ZTER
 ; Open a host file
OPENX(X1,X2) ;EP
 D OPEN(.X1,.X2)
 Q X1
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Open a host file
OPEN(X1,X2) ;EP
 O X1:$S("Rr"[$G(X2):"RS","Ww"[X2:"WNS","Bb"[X2:"RF",1:""):0
 E  ZT "NOPEN"
 U X1
 S ^TMP("CIAUHFS",$J,X1)=""
 Q
 ; Close a host file
CLOSE(X) ;EP
 C X
 K ^TMP("CIAUHFS",$J,X)
 Q
 ; Close all host files
CLOSEALL ;EP
 N Z
 S Z=""
 F  S Z=$O(^TMP("CIAUHFS",$J,Z)) Q:Z=""  C Z
 K ^TMP("CIAUHFS",$J)
 Q
EOF ZT:$ZA=-1 "ENDOFFILE"
 Q
EOFERR() Q:$ZE["ENDOFFILE"
 ; Read line of data
READ(X,Y) ;EP
 N $ET
 S $ET="",$ZT="READX^CIAUOS"
 U $G(Y,$I)
 Q:$ZEOF 1
 R X:5
 Q:$T 0
READX Q 1
 ; Delete a host file
DELETE(X) ;EP
 S X=$ZF(-1,"del """_X_"""")
 Q
 ; Rename a host file
RENAME(X1,X2) ;EP
 S X1=$ZF(-1,"ren """_X1_""" """_X2_"""")
 Q
 ; Return directory of files
DIR(X1,X2,X3) ;EP
 N Z,Z1,FDLM
 S FDLM=$E($$DIRDLM,1)
 S X3=$G(X3,$NA(^UTILITY("DIR",$J)))
 K @X3
 S:'$G(X2) X2=9999999999
 F Z=1:1:X2 S Z1=$ZSEARCH(X1),X1="" Q:Z1=""  D
 .S Z1=$P(Z1,FDLM,$L(Z1,FDLM))
 .S:$TR(Z1,".")'="" @X3@(Z1)=""
 Q
 ; Return path delimiters
DIRDLM() ;EP
 Q "\\\"
 ; Return default working directory
DEFDIR(X) ;EP
 N FDLM
 S FDLM=$E($$DIRDLM,1)
 S X=$G(X,$P($G(^XTV(8989.3,1,"DEV")),U))
 S:$E(X,$L(X))'=FDLM X=X_FDLM
 Q X
 ; Parse current error
ERR(X1,X2,X3) ;EP
 S X1=$E($P($ZE,">"),2,99),X2=$P($P($ZE,">",2),":"),X3=X1
 S:X2["*" X2=""
 S:$E(X1)="Z" X3=$E(X1,2,99),X1="ZTRAP"
 Q
 ; Raise an exception
RAISE(X) ;EP
 ZT $G(X)
 ; Set error trap
TRAP(X) ;EP
 Q $S($D(X):"$ZT="""_X_"""",1:"$ZT")
 ; Return size of file
SIZE(X) ;EP
 Q 0
 ; Return free disk space
FREE(X) ;EP
 Q 0
 ; Return host ip address
HOSTIP() ;EP
 Q $P($P($ZU(131,1),","),":",2)
 ; Return host name
HOSTNAME() ;EP
 Q $P($P($ZU(131,1),","),":")
 ; Return client ip address
CLIENTIP() ;EP
 N IP,$ET
 S $ET="S $EC=""""",IP=$ZU(111,0)
 Q $A(IP,1)_"."_$A(IP,2)_"."_$A(IP,3)_"."_$A(IP,4)
