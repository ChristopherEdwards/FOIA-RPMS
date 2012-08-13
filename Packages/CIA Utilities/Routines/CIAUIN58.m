CIAUIN58 ;MSC/IND/DKM/PLS - Inits for MSM-UNIX;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Open a host file
OPEN(X1,X2) ;EP
 N Z
 S X2=$G(X2,"R")
 F Z=51:1:55 I '$D(^TMP("CIAUHFS",$J,Z)) D  Q
 .ZT:Z=55 "TMOF"
 .O Z:(X1:$S("RrWw"[X2:X2,1:"R")::::$S("Bb"[X2:"",1:$C(10)))
 .U Z
 .ZT:$ZA "OPEN"
 .S ^TMP("CIAUHFS",$J,Z)=X1,X1=Z
 Q
 ; Close a host file
CLOSE(X) ;EP
 N Z
 S Z=X,X=$G(^TMP("CIAUHFS",$J,X))
 K ^(Z)
 C Z
 Q
 ; Close all open host files
CLOSEALL ;EP
 N Z
 F Z=0:0 S Z=$O(^TMP("CIAUHFS",$J,Z)) Q:'Z  C Z
 K ^TMP("CIAUHFS",$J)
 Q
EOF ZT:$ZC "EOF"
 Q
EOFERR() Q $ZE["ZEOF"
 ; Read a line of data
READ(X,Y) ;EP
 U:$G(Y)'="" Y
 R X:5
 Q $S($T:$ZC&'$L(X),1:1)
 ; Delete a host file
DELETE(X) ;EP
 D JW("rm "_X)
 Q
 ; Rename a host file
RENAME(X1,X2) ;EP
 D JW("mv "_X1_" "_X2)
 Q
 ; Generate a directory listing
DIR(X1,X2,X3) ;EP
 N TFN,X,Z
 N $ET
 S $ET="",@$$TRAP("DIRERR^CIAUOS")
 S X1=$G(X1),X2=+$G(X2),X3=$G(X3,"^UTILITY(""DIR"",$J)")
 S TFN=$$DEFDIR_"CIAUAUTO."_$J
 K @X3
 ;
 D DELETE(TFN)
 D JW("ls -d "_X1_" >> "_TFN)
 D OPEN(.TFN,"R")
 F Z=1:1 Q:(X2&(Z>X2))  Q:$$READ(.X,TFN)  D
 .S X=$TR($P(X,"/",$L(X,"/")),$C(10),"")
 .I X]"" S @X3@(X)=""
DIRERR D CLOSE(.TFN)
 D DELETE(TFN)
 Q
 ; Return default working directory
DEFDIR(X) ;EP
 S X=$G(X,$P($G(^XTV(8989.3,1,"DEV")),U))
 S:$E(X,$L(X))'="/" X=X_"/"
 Q X
 ; Return path delimiters
DIRDLM() ;EP
 Q "///"
 ; Return free disk space
FREE(X) ;EP
 S X=$ZOS(9,$E(X))
 Q X*$P(X,"^",2)*$P(X,"^",3)/1048576
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
 ; Return size of a file
SIZE(X) ;EP
 N I,Y,Z
 S Z=$ZOS(12,X,0),Z=$P(Z,"^",2,999),Y=0
 I Z'="" F I=30:-1:27 S Y=Y*256+$A(Z,I)
 Q Y
 ; Return host ip address
HOSTIP() ;EP
 Q ""
 ; Return host name
HOSTNAME() ;EP
 Q ""
 ; Return client ip address
CLIENTIP() ;EP
 Q ""
 ; Issue host command and wait
JW(ZOSHC) ;msm extrinsic
 N ZOSHX
 S ZOSHX=$$JOBWAIT^%HOSTCMD(ZOSHC)
 Q
