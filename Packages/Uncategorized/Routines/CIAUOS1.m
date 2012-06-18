CIAUOS ;MSC/IND/DKM - Platform-dependent operations;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Return version # of RTL
VER() ;EP
 Q +$P($T(CIAUOS+1),";",3)
 ; Set right margin
RM(X) ;EP
 X ^%ZOSF("RM")
 Q
 ; Test for routine/tag
TEST(X) ;EP
 N Z
 S:X[U Z=$P(X,U),X=$P(X,U,2)
 Q:'$L(X)!(X'?.1"%"1.AN) 0
 X ^%ZOSF("TEST")
 Q $S('$T:0,$G(Z)="":1,Z'?.1"%"1.AN:0,1:$T(@Z^@X)'="")
 ; Raise an exception
RAISE(X) ;EP
 ZT $G(X)
 ; Return code to set error trap
TRAP(X) ;EP
 Q $$SUBST^CIAU(^%ZOSF("TRAP"),"X",""""_X_"""")
 ; Check for $ET capability
ETRAP() ;EP
 Q $$NEWERR^%ZTER
 ; Open a file (extrinsic)
OPENX(X1,X2) ;EP
 D OPEN(.X1,.X2)
 Q X1
 ; Open a file
OPEN(X1,X2) ;EP
 N IO,POP,X3
 D PARSE(.X1,.X3),OPEN^%ZISH(X3_X1,X3,X1,$G(X2,"R"),32767)
 I POP ZT "OPEN"
 S ^XTMP("CIAUHFS",$J,IO)=X3_X1,X1=IO
 Q
 ; Close a file
CLOSE(X) ;EP
 N Y
 S Y=$G(^XTMP("CIAUHFS",$J,X)),IO=X
 K ^(X)
 D CLOSE^%ZISH(Y)
 Q
 ; Close all open HFS
CLOSEALL ;EP
 N Z
 S Z=""
 F  S Z=$O(^XTMP("CIAUHFS",$J,Z)) Q:Z=""  D CLOSE(Z)
 Q
 ; Parse out directory from filename
PARSE(X,Y) ;EP
 N D,Z
 S D=$E($$DIRDLM,3),Z=$L(X,D),Y=$P(X,D,1,Z-1),Y=$S($L(Y):Y,1:$$PWD^%ZISH)_$S(Z>1:D,1:""),X=$P(X,D,Z)
 Q
 ; Read a line
READ(X,Y) ;EP
 N IO,%ZA,%ZB,%ZC,%ZL
 S IO=$G(Y,$I)
 D READNXT^%ZISH(.X)
 U IO
 Q $$STATUS^%ZISH&'$L(X)
 ; Delete a file
DELETE(X) ;EP
 N Z
 D PARSE(.X,.Z)
 S:$L(X) Z(X)="",Z=$$DEL^%ZISH(Z,"Z")
 Q
 ; Rename a file
RENAME(X1,X2) ;EP
 N X3,X4
 D PARSE(.X1,.X3),PARSE(.X2,.X4)
 I $$MV^%ZISH(X3,X1,X4,X2)
 Q
 ; List files
DIR(X1,X2,X3) ;EP
 N Z
 D PARSE(.X1,.Z)
 S Z(X1)="",X3=$G(X3,"^UTILITY(""DIR"",$J)")
 K @X3
 I $$LIST^%ZISH(Z,"Z",X3)
 Q
 ; Force error if at EOF
EOF I $$STATUS^%ZISH ZT "EOF"
 Q
 ; Returns true if current error is EOF
EOFERR() ;EP
 Q $$EC^%ZOSV["EOF"
 ; URL format filename-->HFS format
CVTFN(CIAFIL,CIAROOT) ;EP
 N CIAZ,CIAZ1,CIAD
 S CIAD=$$DIRDLM,CIAROOT=$G(CIAROOT)
 S:$E(CIAROOT,$L(CIAROOT))=$E(CIAD,3) CIAROOT=$E(CIAROOT,1,$L(CIAROOT)-1)
 S CIAZ=$L(CIAFIL,"/"),CIAZ1=$P(CIAFIL,"/",1,CIAZ-1),CIAFIL=$P(CIAFIL,"/",CIAZ)
 S:$L(CIAZ1) CIAROOT=CIAROOT_$E(CIAD,$S($L(CIAROOT):2,1:1))_$TR(CIAZ1,"/.-",$E(CIAD,2))
 Q CIAROOT_$S($L(CIAROOT):$E(CIAD,3),1:"")_CIAFIL
 ; Return directory delimiters
DIRDLM() ;EP
 N X
 S X=$$PWD^%ZISH
 Q $S(X["[":"[.]",X["\":"\\\",1:"///")
 ; Parse error data
ERR(X1,X2,X3) ;EP
 N X
 S X=$$EC^%ZOSV,X1=$$VERSION^%ZOSV(1)
 G ERRMSM:X1["MSM",ERRDSM:X1["DSM"
 S (X1,X2,X3)=""
 Q
ERRMSM S X1=$E($P(X,">"),2,99),X2=$P($P(X,">",2),":"),X3=X1
 S:X2["*" X2=""
 S:$E(X1)="Z" X3=$E(X1,2,99),X1="ZTRAP"
 Q
ERRDSM S X1=$P($P(X,", ",2),"-",3),X2=$P($P(X,", "),":"),X3=$$TRIM^CIAU($P(X,", ",$S(X1="ZTRAP":4,1:3)))
 Q
