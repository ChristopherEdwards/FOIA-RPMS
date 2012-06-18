ACRFPENV ;IHS/OIRM/DSD/AEF - PATCH ENVIRONMENT CHECK ROUTINE [ 1/25/2007  2:02 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**22**;NOV 05, 2001
 ;
EN(ACRPCHN,ACRPCHS,XPDQUIT)  ;EP
 ;----- MAIN ENTRY POINT
 ;
 ;      INPUT:
 ;      ACRPCHN  =  PATCH NAME
 ;      ACRPCHS  =  PREREQUISITE PATCH NUMBERS
 ;
 ;      OUTPUT:
 ;      XPDQUIT  =  KIDS INSTALL TERMINATOR VARIABLE
 ;                  1 = QUIT
 ;
 D CHK(ACRPCHN,ACRPCHS,.XPDQUIT)
 ;
 I $G(XPDQUIT) D  Q
 . D BMES^XPDUTL("This patch cannot be installed on your system.")
 D BMES^XPDUTL("Everything looks OK, you may continue with installation.")
 Q
CHK(ACRPCHN,ACRPCHS,XPDQUIT) ;EP
 ;----- DETERMINES IF PATCH VERSION MATCHES PACKAGE VERSION
 ;      
 ;      INPUT:
 ;      ACRPCHN  =  PATCH NAME
 ;      ACRPCHS  =  PREREQUISITE PATCH NUMBERS
 ;
 ;      OUTPUT:
 ;      XPDQUIT  =  KIDS INSTALL TERMINATOR VARIABLE
 ;                  1 = QUIT
 ;
 N D0,D1,I,J,P,X,Y,Z
 ;
 S Y=$$VERSION^XPDUTL("ADMIN RESOURCE MGT SYSTEM")
 ;
 ;----- CHECK TO SEE IF ARMS IS INSTALLED
 ;
 S D0=$O(^DIC(9.4,"B","ADMIN RESOURCE MGT SYSTEM",0))
 I 'D0 D  Q
 . S XPDQUIT=1
 . D BMES^XPDUTL("Unable to find 'ADMIN RESOURCE MGT SYSTEM' package in the Package file.")
 ;
 S D1=$O(^DIC(9.4,D0,22,"B",Y,0))
 I 'D1 D  Q
 . S XPDQUIT=1
 . S X="Unable to find 'ADMIN RESOURCE MGT SYSTEM' Version "_Y_" in the Package file"
 . D BMES^XPDUTL(X)
 ;
 ;----- CHECK TO SEE IF PATCH MATCHES CURRENT VERSION
 ;
 I Y'=$$VER^XPDUTL(ACRPCHN) D  Q
 . S XPDQUIT=1
 . S X="This patch is for ARMS version "_$$VER^XPDUTL(ACRPCHN)_" but you are running version "_Y_"."
 . D BMES^XPDUTL(X)
 ;
 ;----- CHECK FOR REQUIRED PATCHES
 ;
 Q:$G(ACRPCHS)']""
 F I=1:1:$L(ACRPCHS,",") D
 . S Z=$P(ACRPCHS,",",I)
 . I Z["-" D  Q
 . . F J=$P(Z,"-"):1:$P(Z,"-",2) D
 . . . I '$D(^DIC(9.4,D0,22,D1,"PAH","B",J)) D
 . . . . S XPDQUIT=1
 . . . . D PMSG(Y,J)
 . I '$D(^DIC(9.4,D0,22,D1,"PAH","B",Z)) D
 . . S XPDQUIT=1
 . . D PMSG(Y,Z)
 Q
PMSG(Y,P)          ;
 ;----- ISSUE MISSING PATCH MESSAGE
 ;
 ;      Y  =  VERSION NUMBER
 ;      P  =  PATCH NUMBER
 ;
 N X
 S X="Patch ACR*"_Y_"*"_P_" is missing"
 D BMES^XPDUTL(X)
 Q
