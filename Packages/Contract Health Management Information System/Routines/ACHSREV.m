ACHSREV ; IHS/ITSC/PMF - STANDALONE TO CLEAN AUTTREVN CROSS-REFERENCES ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;NOTE: Currently, the diag lines are in effect
 ;It is recommended that this routine be run with diag lines in effect
 ;
 ;When it is determined that the nodes that display on the screen are
 ;the correct nodes to be killed, disable the 3 diag lines and then run
 ;
 ;EP
 D REV,ADA,CPT
 Q
REV S (REV,TOT)=0
 F  S REV=$O(^AUTTREVN(REV)) Q:'REV  D
 .S TMP=$G(^AUTTREVN(REV,0))
 .D CK
 Q
CK ; Find unknown description in 0 node and kill X-references
 ; Leave 0 node in case of pointers in other files
 ; REVN=The real revenue code in the .01 field
 ; REV will be the bogus code set by chs
 Q:TMP'["unknown"
DIAG ;
 W !,REV,?10,TMP S TOT=TOT+1 Q
 S REVN=$P(TMP,"^",1),DESC=$P(TMP,"^",2)
 K ^AUTTREVN("B",REVN,REV)
 K ^AUTTREVN("C",DESC,REV)
 K ^AUTTREVN("E",DESC,REV)
 S TOT=TOT+1
 Q
ADA S (ADA,TOT)=0
 F  S ADA=$O(^AUTTADA(ADA)) Q:'ADA  D
 .S TMP=$G(^AUTTADA(ADA,0))
 .D CK2
 Q
CK2 ; Find unknown description in 0 node and kill X-references
 Q:$P(TMP,"^",2)'="unknown"
DIAG2 ;
 W !,ADA,?10,TMP S TOT=TOT+1 Q
 S ADAN=$P(TMP,"^",1),DESC=$P(TMP,"^",2)
 K ^AUTTADA("B",ADAN,ADA)
 K ^AUTTADA("C",DESC,ADA)
 S TOT=TOT+1
 Q
CPT ;
 S (CPT,TOT)=0
 F  S CPT=$O(^ICPT(CPT)) Q:'CPT  D
 .S TMP=$G(^ICPT(CPT,0))
 .D CK3
 Q
CK3 ; Find unknown description in 0 node and kill X-references
 ; Leave 0 node in case of pointers in other files
 ; CPTN=The real revenue code in the .01 field
 ; CPT will be the bogus code set by chs
 Q:TMP'["unknown"
DIAG3 ;
 W !,CPT,?10,TMP S TOT=TOT+1 Q
 S CPTN=$P(TMP,"^",1),DESC=$P(TMP,"^",2)
 K ^ICPT("B",CPTN,CPT)
 K ^ICPT("C",DESC,CPT)
 K ^ICPT("E",DESC,CPT)
 S TOT=TOT+1
 Q
