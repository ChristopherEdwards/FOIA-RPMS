BPHRUPD ;GDIT/HS/ALA-Update parameters ; 05 Aug 2013  1:57 PM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**1**;Apr 01, 2014;Build 23
 Q
 ;
WEB ;EP - Update Web Services
 ; Add a new service and update the associated fields
 ; Edit an existing service's associated fields
 NEW DA,DIC,DIE,DR,Y,DLAYGO,DIR,X,DIRUT,DUOUT
 S DIR(0)="S^1:TEST PHR SERVER;2:PRODUCTION PHR SERVER"
 D ^DIR I Y="^"!(Y="") Q
 S DA=Y
 ;
 S DIC="^BPHR(90670.2,",DIC(0)="AELMNZ",DIE=DIC,DR="[BPHR ADD/EDIT WEB SERVICE]"
 ;S DLAYGO=90670.2 D ^DIC S DA=+Y
 D ^DIE
 Q
 ;
PROV(PROV) ;EP = Provider DIRECT address
 NEW FACAD,MAD,NCOMP,NAME,VALUE,FN,LN
 S ADDR=""
 I $G(PROV)="" Q ADDR
 S FACAD=$P($G(^AUTTLOC(DUZ(2),21)),"^",5)
 I FACAD="" Q ADDR
 I FACAD'="" S MAD=$P(FACAD,"@",2)
 S NCOMP=$P($G(^VA(200,PROV,3.1)),"^",1)
 I NCOMP'="" D
 . S FN=$P($G(^VA(20,NCOMP,1)),"^",2),FN=$$STRIP^XLFSTR(FN," "),FN=$$PUNC(FN)
 . S LN=$P($G(^VA(20,NCOMP,1)),"^",1),LN=$$STRIP^XLFSTR(LN," "),LN=$$PUNC(LN)
 . S VALUE=$$LOW^XLFSTR(FN)_"."_$$LOW^XLFSTR(LN)
 . I $G(VALUE)=""!($G(VALUE)=".") S NCOMP=""
 ;
 I NCOMP="" D
 . S NAME=$P(^VA(200,PROV,0),"^",1)
 . D STDNAME^XLFNAME(.NAME,"FC")
 . S FN=$G(NAME("GIVEN")),FN=$$STRIP^XLFSTR(FN," "),FN=$$PUNC(FN)
 . S LN=$G(NAME("FAMILY")),LN=$$STRIP^XLFSTR(LN," "),LN=$$PUNC(LN)
 . S VALUE=$$LOW^XLFSTR(FN)_"."_$$LOW^XLFSTR(LN)
 ;
 S ADDR=VALUE_"@"_MAD
 Q ADDR
 ;
AGNT(DFN) ;EP = Messaging Agent for Patient
 NEW BDPCAT,BDPIEN,MSA,BPA,AGN,ADR,BPDATA
 S ADDR=""
 S BDPCAT=$$FIND1^DIC(90360.3,,"X","MESSAGE AGENT")
 I BDPCAT="" Q ADDR
 S BDPIEN=$O(^BDPRECN("AA",DFN,BDPCAT,""))
 I BDPIEN="" Q ADDR
 S BPA=0
 F  S BPA=$O(^BDPRECN(BDPIEN,1,BPA)) Q:'BPA  D
 . S BPDATA=^BDPRECN(BDPIEN,1,BPA,0)
 . I $P(BPDATA,"^",3)<BDT Q
 . I $P(BPDATA,"^",3)>EDT Q
 . S MSA=$P(^BDPRECN(BDPIEN,1,BPA,0),"^",1)
 . S AGN(MSA)=""
 S MSA=$P(^BDPRECN(BDPIEN,0),"^",3)
 I MSA="",'$D(AGN) Q ADDR
 I MSA'="" S AGN(MSA)=""
 S MSA="" F  S MSA=$O(AGN(MSA)) Q:MSA=""  D
 . S ADR=$$LOW^XLFSTR($P($G(^BDPMSGA(MSA,0)),"^",2))
 . I ADR'["direct" Q
 . S ADDR=ADDR_ADR_","
 Q ADDR
 ;
PUNC(X) ;EP
 Q $TR(X,"`~!@#$%^&*()-_=+\|[{]};:'"",<.>/?","")
