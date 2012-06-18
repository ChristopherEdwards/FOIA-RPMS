CIAUHFS ;MSC/IND/DKM - Host IO Support ;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Capture output to HFS and optionally redirect to global
 ;   EXEC = Code to execute
 ;   ROOT = Global root to receive output (or null to leave in HFS)
 ;   RM   = Right margin setting (defaults to 80)
CAPTURE(EXEC,ROOT,RM) ;EP
 N UFN,HNDL,TMP,IOM,IOSL,IOST,IOF,IOT,IOS,$ET
 S $ET="",UFN=$$UFN^CIAU,TMP=$$DEFDIR^CIAUOS,HNDL="CIAUHFS",@$$TRAP^CIAUOS("ERR^CIAUHFS")
 S:$L($G(ROOT)) ROOT=$NA(@ROOT)
 D OPEN^%ZISH(HNDL,TMP,UFN,"W")
 D:'POP IOVAR(.RM),EXEC,HFSCLOSE(HNDL,UFN)
 Q:$Q TMP_UFN
 Q
EXEC X EXEC
 Q
 ; Error trap
ERR D @^%ZOSF("ERRTN"),HFSCLOSE(HNDL,UFN,1)
 Q:$Q ""
 Q
 ; Setup IO variables based on IO Device
IOVAR(XIOM,XIO,XIOSL,XIOST,XIOF,XIOT) ;
 N X
 S ION=$G(XIO,"CIAU HFS DEVICE"),IOS=+$O(^%ZIS(1,"B",ION,0)),IOM=80,IOSL=62,IOST=$G(XIOST,"P-OTHER"),IOF=$G(XIOF,""""""),IOT=$G(XIOT,"HFS")
 S:$D(^%ZIS(1,IOS,0)) IOST(0)=+$G(^("SUBTYPE")),IOT=$G(^("TYPE"),IOT),IOST=$P($G(^%ZIS(2,IOST(0),0),IOST),U)
 S X=$O(^%ZIS(2,"B",IOST,0))
 S:X IOST(0)=X,X=$G(^%ZIS(2,X,1)),IOM=$P(X,U),IOF=$P(X,U,2),IOSL=$P(X,U,3)
 S:$G(XIOM) IOM=XIOM
 S:$G(XIOSL) IOSL=XIOSL
 U IO
 Q
 ; Move HFS data to global (if ROOT specified) and cleanup
HFSCLOSE(HNDL,UFN,BAD) ;
 N DEL
 D GETDEV^%ZISUTL(HNDL)
 I IOT="HFS" D
 .D CLOSE^%ZISH(HNDL)
 E  D RMDEV^%ZISUTL(HNDL)
 Q:'$L($G(ROOT))
 K @ROOT
 I '$G(BAD),$$FTG^%ZISH($$DEFDIR^CIAUOS,UFN,$NA(@ROOT@(1)),$QL(ROOT)+1) D STRIP
 S DEL(UFN)=""
 I $$DEL^%ZISH($$DEFDIR^CIAUOS,"DEL")
 Q
 ; Strip off control chars and remove leading/trailing blank lines
STRIP N I,J,K,X
 S (I,J)=0
 F  S I=$O(@ROOT@(I)) Q:'I  S X=@ROOT@(I) D  S @ROOT@(I)=X
 .I X[$C(8),$L(X,$C(8))=$L(X,$C(95)) S X=$TR(X,$C(7,8,12,95))
 .E  S X=$TR(X,$C(7,8,12))
 .S:$L(X) J=I,K=$G(K,J)
 I $D(K) F  S I=$O(@ROOT@(I)) Q:I=K  K @ROOT@(I)
 F  S J=$O(@ROOT@(J)) Q:'J  K @ROOT@(J)
 Q
