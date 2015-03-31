BEHUENV ;MSC/IND/PLS - Environment Checker ;05-Nov-2012 16:59;PLS
 ;;1.2;BEH UTILITIES;**2**;Mar 20, 2007;Build 3
 ;=================================================================
 ; Patch 2 = EHR v1.1 Patch 11
ENV ;EP - Environment check
 N VAL,PAT,X,PATCHK,HDR,LEHR,HDRTXT
 S XPDABORT=0
 S HDR=0,HDRTXT="The following are missing from the RPMS environment:"
 F VAL=0:1 S X=$P($T(ENVDAT+VAL),";;",2) Q:'$L(X)  D
 .S PATCHK='$$PATCH^XPDUTL(X)
 .I PATCHK D
 ..I 'HDR D
 ...D BMES^XPDUTL(HDRTXT)
 ...S HDR=1
 ..D BMES^XPDUTL("  "_X)
 .S:PATCHK XPDABORT=1
 S LEHR=$$FNDEHR("EHR*1.1*10")
 I LEHR
 .I 'HDR D
 ..D BMES^XPDUTL(HDRTXT)
 ..S HDR=1
 .D BMES^XPDUTL("  EHR*1.1*10")
 I 'XPDABORT D
 .W !!,"All requirements for installation have been met...",!
 E  D
 .W !!,"Unable to continue with the installation...",!
 Q
 Q
 ;
 ; Find last EHR installation
FND() ;EP
 N LP,IEN,LSTDT,DAT,DATA,ERR
 D FIND^DIC(9.7,"","@;.01;17I","P","EHR",,,"","","DATA","ERR")
 S LP=0,IEN=0,LSTDT=0 F  S LP=$O(DATA("DILIST",LP)) Q:'LP  D
 .S DAT=DATA("DILIST",LP,0)
 .I $P(DAT,U,3)>LSTDT D
 ..S IEN=LP
 ..S LSTDT=$P(DAT,U,3)
 Q $S(IEN:DATA("DILIST",IEN,0),1:"")
 ; Returns flag indicating lack of EHR v1.1 Patch 10
FNDEHR(X) ;
 N STAT,INSTDA
 S INSTDA=""
 Q:'$D(^XPD(9.7,"B",X)) 1
 S INSTDA=$O(^XPD(9.7,"B",X,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 Q STAT'=3
 ; To add to the list of requirements, add the info specific to the
 ; application after the "ENV" label, below in the form:
 ;           Namespace*Version*Patch
 ; E.g., to check for Pt Reg, v 6.1, patch 2:
 ;           AG*6.1*2
 ; If the application has no patches, leave the patch info blank.
 ;
ENVDAT ;;XU*8.0*1017
 ;;XT*7.3*1017
 ;;DI*22.0*1017
 ;;XWB*1.1*1017
 ;;BJPC*2.0*8
 ;;GMRA*4.0*1005
 ;;GMPL*2.0*1001
 ;;GMRV*5.0*1001
 ;;GMRC*3.0*1002
 ;;TIU*1.0*1010
 ;;PXRM*1.5*1009
 ;;APSP*7.0*1014
 ;;BRA*5.0*1003
 ;;LR*5.2*1031
 ;;PIMS*5.3*1015
 ;;
