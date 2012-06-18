CIAUIN16 ;MSC/IND/DKM - Inits for VMS;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Open a host file
OPEN(X1,X2) ;EP
 N Z
 S Z="X1"_$S("Rr"[$G(X2):":READONLY:0","Ww"[X2:":(NEWVERSION,RECORDSIZE=65535)","Bb"[X2:":(READONLY,BLOCKSIZE=0)",1:"")
 O @Z
 U X1
 S ^TMP("CIAUHFS",$J,X1)=""
 Q
 ; Close a host file
CLOSE(X) ;EP
 C X
 K ^TMP("CIAUHFS",$J,X)
 Q
 ; Close all open host files
CLOSEALL ;EP
 N Z
 S Z=""
 F  S Z=$O(^TMP("CIAUHFS",$J,Z)) Q:Z=""  C Z
 K ^TMP("CIAUHFS",$J)
 Q
EOF U $I:TRAP
 Q
EOFERR() Q $ZE["ENDOFILE"
 ; Read a line of data
READ(X,Y) ;EP
 U $G(Y,$I):NOTRAP
 R X:5
 Q $S($T:$ZA=-1,1:1)
 ; Delete a host file
DELETE(X) ;EP
 O X::0
 C X:DELETE
 Q
 ; Rename a host file
RENAME(X1,X2) ;EP
 O X1:READONLY:0
 C X1:RENAME=X2
 Q
 ; Return directory of files
DIR(X1,X2,X3) ;EP
 N Z,Z1
 S $ZT="DIRX^CIAUOS",X3=$G(X3,"^UTILITY(""DIR"",$J)")
 K @X3
 S:'$G(X2) X2=9999999999
 F Z=1:1:X2 S Z1=$ZSEARCH(X1),X1="" Q:Z1=""  S @X3@($P(Z1,"]",2))=""
DIRX Q
 ; Return default working directory
DEFDIR(X) ;EP
 Q $G(X,$P($G(^XTV(8989.3,1,"DEV")),U))
 ; Return path delimiters
DIRDLM() ;EP
 Q "[.]"
 ; Parse current error
ERR(X1,X2,X3) ;EP
 S X1=$P($P($ZE,", ",2),"-",3),X2=$P($P($ZE,", "),":"),X3=$P($ZE,", ",$S(X1="ZTRAP":4,1:3))
 Q
 ; Raise an exception
RAISE(X) ;EP
 ZT $G(X)
 ; Set error trap
TRAP(X) ;EP
 Q $S($D(X):"$ZT="""_X_"""",1:"$ZT")
 ; Return size of a file
SIZE(X) ;EP
 Q $ZC(%GETFILE,X,"BLS")*$ZC(%GETFILE,X,"EOF")
 ; Return free disk space
FREE(X) ;EP
 Q $ZC(%GETDVI,X,"FREEBLOCKS")/2048
 ; Return host ip address
HOSTIP() ;EP
 Q ""
 ; Return host name
HOSTNAME() ;EP
 Q ""
 ; Return client ip address
CLIENTIP() ;EP
 N IP,$ET
 S $ET="S $EC=""""",IP=$&%UCXGETPEER
 Q $A(IP,1)_"."_$A(IP,2)_"."_$A(IP,3)_"."_$A(IP,4)
