CIAUUSR ;MSC/IND/DKM - Parse recipient list;04-May-2006 08:19;DKM
 ;;1.2;CIA UTILITIES;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Takes a list of recipients (which may be DUZ #'s, names,
 ; mail groups, or special tokens) as input and produces an
 ; array of DUZ's as output.  If a list element is found in
 ; in the token list CIALST, the value of the token entry will
 ; be substituted.
 ; Inputs:
 ;     CIAUSR = Semicolon-delimited list of recipients
 ;     CIALST = Special token list
 ; Outputs:
 ;     CIAOUT = Local array to receive DUZ list
 ;=================================================================
ENTRY(CIAUSR,CIAOUT,CIALST) ;
 N CIAZ,CIAZ1,CIAZ2
 K CIAOUT
 F CIAZ=1:1:$L(CIAUSR,";") S CIAZ1=$P(CIAUSR,";",CIAZ) D:CIAZ1'=""  S:CIAZ1 CIAOUT(+CIAZ1)=""
 .S:$D(CIALST(CIAZ1)) CIAZ1=CIALST(CIAZ1)
 .Q:CIAZ1?.N
 .I CIAZ1?1"-"1.N D MGRP(-CIAZ1) S CIAZ1=0 Q
 .S CIAZ2=$E(CIAZ1,1,2)
 .I CIAZ2="G." D MGRP($E(CIAZ1,3,999)) Q
 .I CIAZ2="L." D LIST($E(CIAZ1,3,999)) Q
 .S CIAZ1=$$LKP(CIAZ1)
 Q
LKP(CIANAME) ;
 N CIAZ,CIAZ1
 I $D(^VA(200,"B",CIANAME)) S CIAZ=CIANAME G L1
 S CIAZ=$O(^(CIANAME)),CIAZ1=$O(^(CIAZ))
 Q:(CIAZ="")!(CIANAME'=$E(CIAZ,1,$L(CIANAME))) 0
 Q:(CIAZ1'="")&(CIANAME=$E(CIAZ1,1,$L(CIANAME))) 0
L1 S CIAZ1=$O(^(CIAZ,0)),CIAZ=$O(^(CIAZ1))
 Q:'CIAZ1!CIAZ 0
 Q CIAZ1
LIST(CIALIST) ;
 Q:CIALIST=""
 S:CIALIST'=+CIALIST CIALIST=+$O(^CCCDSS(25193.6,"B",CIALIST,0))
 S @$$TRAP^CIAUOS("LERR^CIAUUSR")
 X:$D(^CCCDSS(25193.6,CIALIST,1)) ^(1)
LERR Q
MGRP(CIAMGRP) ;
 N CIAX
 S CIAX(0)=""
 D MGRP2(CIAMGRP)
 Q
MGRP2(CIAMGRP) ;
 N CIAZ,CIAZ1
 Q:CIAMGRP=""
 S:CIAMGRP'=+CIAMGRP CIAMGRP=+$O(^XMB(3.8,"B",CIAMGRP,0))
 Q:$D(CIAX(CIAMGRP))
 S CIAX(CIAMGRP)=""
 F CIAZ=0:0 S CIAZ=+$O(^XMB(3.8,CIAMGRP,1,CIAZ)) Q:'CIAZ  S CIAOUT(+^(CIAZ,0))=""
 F CIAZ=0:0 S CIAZ=+$O(^XMB(3.8,CIAMGRP,5,CIAZ)) Q:'CIAZ  D MGRP2(^(CIAZ,0))
 Q
