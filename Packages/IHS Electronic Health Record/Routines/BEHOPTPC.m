BEHOPTPC ;MSC/IND/DKM - RPC calls for provider information ;05-May-2009 12:01;PLS
 ;;1.1;BEH COMPONENTS;**004004**;Mar 20, 2007
 ;=================================================================
USESD() Q $G(DUZ("AG"))'="I"
 ; Get the primary provider
OUTPTPR(DFN) ;EP
 Q:$$USESD $$OUTPTPR^SDUTL3(DFN)
 N PCP
 S PCP=$$GET1^DIQ(9000001,DFN,.14,"I")
 Q $S(PCP:PCP_U_$P(^VA(200,PCP,0),U),1:"")
 ; Get team
OUTPTTM(DFN) ;EP
 Q:$$USESD $$OUTPTTM^SDUTL3(DFN)
 N TM
 S TM=$O(^BSDPCT("AB",+$$OUTPTPR(DFN),0))
 Q $S(TM:TM_U_$$GET1^DIQ(9009017.5,TM,.01),1:"")
 ; Return Primary Care Detail information
DETAIL(DATA,DFN) ;EP
 I $$USESD D
 .N I,X
 .S X=$$OUTPTTM^SDUTL3(DFN,DT),I=0
 .I X>0 D
 ..D ADDDET($P(X,U,2),"Primary Care Team")
 ..D ADDDET($P($G(^SCTM(404.51,+X,0)),U,2),"Phone")
 .E  D ADDDET("No Primary Care Team Assigned.")
 .D ADDPRV("Primary Care Provider",+$$OUTPTPR^SDUTL3(DFN,DT))
 .D ADDPRV("Associate Provider",+$$OUTPTAP^SDUTL3(DFN,DT))
 .D ADDPRV("Attending Physician",+$G(^DPT(DFN,.1041)),1)
 E  D
 .N I,X,BDPQ,BDPTYPE,BDPCOUNT,BDPRIEN,BDPTYPNM,BDPCPRV
 .S I=0
 .D ADDDET("**CURRENT DESIGNATED PROVIDERS - BY PROVIDER CATEGORY TYPE**")
 .I '$D(^BDPRECN("AA",DFN)) D ADDDET("**--NO EXISTING DESIGNATED PROVIDERS--**") Q
 .S BDPQ=0,BDPTYPE="",BDPCOUNT=0
 .F  S BDPTYPE=$O(^BDPRECN("AA",DFN,BDPTYPE)) Q:BDPTYPE=""  D
 ..S BDPCOUNT=BDPCOUNT+1,BDPRIEN=""
 ..S BDPTYPNM=$P(^BDPTCAT(BDPTYPE,0),U)                                  ;Type Print
 ..F  S BDPRIEN=$O(^BDPRECN("AA",DFN,BDPTYPE,BDPRIEN)) Q:BDPRIEN'=+BDPRIEN  D
 ...S BDPCPRV=+$P($G(^BDPRECN(BDPRIEN,0)),U,3)                           ;Current Provider IEN
 ...S BDPCPRVP=$S(BDPCPRV:$P($G(^VA(200,BDPCPRV,0)),U),1:"<None Currently Assigned>")
 ...D ADDDET(BDPCOUNT_"    "_$$LJ^XLFSTR($E(BDPTYPNM,1,30),30)_": "_$$LJ^XLFSTR($E(BDPCPRVP,1,35),45))
 Q
ADDDET(TXT,LBL) ;
 Q:'$L($G(TXT))
 S:$D(LBL) TXT=$$RJ^XLFSTR(LBL,21)_":  "_TXT
 S DATA(I)=TXT,I=I+1
 Q
ADDPRV(TYP,PRV,FLG) ;
 D ADDDET(" ")
 I $D(^VA(200,PRV,0)) D
 .N X
 .D ADDDET($P(^VA(200,PRV,0),U),TYP)
 .S X=$G(^VA(200,PRV,.13))
 .D ADDDET($P(X,U,7),"Analog Pager")
 .D ADDDET($P(X,U,8),"Digital Pager")
 .D ADDDET($P(X,U,2),"Office Phone")
 E  D:'$G(FLG) ADDDET("No "_TYP_" Assigned.")
 Q
 ; Find all providers on the team associated with the primary provider
TEAM(BEHODUZ) ;EP
 N BEHOX,BEHOY,BEHOTM,BEHOCT
 K ^TMP("ORIHS",$J)
 ;BEHOX is the team of the primary provider
 S BEHOCT=0,BEHOX=$O(^BSDPCT("AB",BEHODUZ,0)),BEHOY=0
 Q:'BEHOX
 F  S BEHOY=$O(^BSDPCT(BEHOX,1,BEHOY)) Q:BEHOY=""  D
 .S BEHOTM=$P($G(^BSDPCT(BEHOX,1,BEHOY,0)),U)
 .S:BEHOTM'="" ^TMP("ORIHS",$J,BEHOTM)=""
 Q
