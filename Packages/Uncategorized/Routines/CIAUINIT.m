CIAUINIT ;MSC/IND/DKM - Platform specific inits;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
POST N CIAOS,CIAH,X
 S U="^",X="ERROR^CIAUINIT",@^%ZOSF("TRAP"),CIAOS=$P(^%ZOSF("OS"),U,2)
 I 'CIAOS D
 .D HOME^%ZIS,TITLE^CIAU("Platform-Specific Inits",1.6)
 .S CIAH(1)="Enter the name of this MUMPS environment for the CIA-namespace"
 .S CIAH(2)="platform-specific initialization process."
 .S CIAOS=$$ENTRY^CIAULKP("^DD(""OS"")","UX","Operating System: ","B","*","","",0,5,"","","HELP(.CIAH)")
 .W !!
 D:CIAOS>0 INIT(CIAOS)
 Q
INIT(CIAOS) ;
 N I,X,Y,Z,N,CIAOSZ
 S CIAOSZ=$$OSRTN($G(CIAOS))
 S:$L(CIAOSZ) @("CIAOSZ="_CIAOSZ)
 I '$L(CIAOSZ) D  Q
 .X "ZL CIAUOS1 ZS CIAUOS"
 .D MES("Init not found for specified OS. Will use generic init.")
 S I=0,N="CIAU"
 K ^TMP(N,$J)
 F Z=0,1 F X=$S(Z:3,1:1):1 S Y=$T(+X^@$S(Z:CIAOSZ,1:"CIAUIN0")) Q:Y=""  S I=I+1,^TMP(N,$J,I)=Y
 S $P(^TMP(N,$J,1),";")="CIAUOS "
 X "ZR  F Z=1:1:I ZI ^TMP(N,$J,Z) ZS:Z=I CIAUOS"
 K ^TMP(N,$J)
 F Z=1:1 S X=$P($T(DEVICE+Z),";;",2,99) Q:X=""  S ^TMP(N,$J,Z)=$$MSG^CIAU(X,"|")
 I $$ENTRY^CIAUIMP($NA(^TMP(N,$J))) D
 .D MES("Unable to install CIAU HFS DEVICE.")
 W !!,"Initialization completed for "_$P(^DD("OS",CIAOS,0),"^")_" operating system.",!!
 K ^TMP(N,$J)
 Q
OSRTN(X) Q $P($T(@("OS"_X)),";",4,99)
OS8 ;;MSM;$S($ZV["UNIX":"CIAUIN58",1:"CIAUIN8")
OS16 ;;DSM;CIAUIN16
OS18 ;;Cache;$S($ZV["UNIX":"CIAUIN68",1:"CIAUIN18")
MES(X) D BMES^XPDUTL(X)
 Q
ERROR D MES("An error has occurred during initialization.")
 Q
 ; Return $I for HFS device
HFS() Q $S(CIAOS=16:"TEMP.TMP",CIAOS=8:51,CIAOS=18:"NUL",1:"@")
DEVICE ; Device setup
 ;;:3.5
 ;;.NAME: CIAU HFS DEVICE
 ;;.LOCATION OF TERMINAL: HFS
 ;;.$I: |$$HFS^CIAUINIT|
 ;;.SIGN-ON/SYSTEM DEVICE: N
 ;;.TYPE: HFS
 ;;.SUBTYPE: P-OTHER
 ;;.ASK DEVICE: N
 ;;.ASK PARAMETERS: N
 ;;.ASK HOST FILE: N
 ;;.ASK HFS I/O OPERATION: N
 ;;
