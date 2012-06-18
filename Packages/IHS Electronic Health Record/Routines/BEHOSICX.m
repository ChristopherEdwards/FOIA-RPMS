BEHOSICX ;MSC/IND/DKM - Site Context Support ;17-Dec-2010 14:14;PLS
 ;;1.1;BEH COMPONENTS;**007001,007003**;Mar 20, 2007
 ;=================================================================
 ; Return information about site
SITEINFO(DATA) ;
 N CIAZ,INST,CNT
 S CNT=0,INST=+$G(DUZ(2))
 D ADD($G(^XMB("NETNAME")))
 F CIAZ=.01,99,.02,.05,1.01,1.02,1.03,1.04 D ADD($$GET1^DIQ(4,INST,CIAZ))
 D ADD(INST)
 D ADD($G(DUZ("AG")))  ;P8
 Q
ADD(X) S CNT=CNT+1,DATA(CNT)=X
 Q
