CIAUIN0 ;MSC/IND/DKM - Platform-dependent operations;04-May-2006 08:19;DKM
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
