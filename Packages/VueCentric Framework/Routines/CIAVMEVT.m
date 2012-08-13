CIAVMEVT ;MSC/IND/DKM - VueCentric Host Event Support ;04-May-2006 08:19;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; These entry points are for backward compatibility only.
GETVAR(NAME,DFLT,NMSP) ;
 Q $$GETVAR^CIANBUTL(.NAME,.DFLT,.NMSP)
SETVAR(NAME,VALUE,NMSP) ;
 N X
 S X=$$SETVAR^CIANBUTL(.NAME,.VALUE,.NMSP)
 Q:$Q X
 Q
CLRVAR(NMSP) ;
 N X
 S X=$$CLRVAR^CIANBUTL(.NMSP)
 Q:$Q X
 Q
BCAST(DATA,EVENT,LST) ;
 N STUB,USERS
 M STUB=LST("S"),USERS=LST("U")
 D BCAST^CIANBEVT(.DATA,.EVENT,.STUB,.USERS)
 Q
SIGNAL(STUB) ;
 D SIGNAL^CIANBEVT(.STUB)
 Q
BRDCAST(TYPE,STUB,USR) ;
 N X
 S X=$$BRDCAST^CIANBEVT(.TYPE,.STUB,.USR)
 Q:$Q X
 Q
