ACDPCCL ;IHS/ADC/EDE/KML - PCC LINK;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; Local array set as CDMIS entries added or edited:
 ;     ACDPCCL(patient ien,visit ien)=""
 ;     ACDPCCL(patient ien,visit ien,"CS",cs ien)=""
 ;     ACDPCCL(patient ien,visit ien,"IIF",iif ien)=""
 ;     ACDPCCL(patient ien,visit ien,"TDC",tdc ien)=""
 ;
 ; Local array set by this routine for PROTOCOL file:
 ;  PGM
 ;     ACDEV("TYPE")=add/edit/delete (i.e., A,E,D)
 ;     ACDEV("SITE TYPE")=pcc visit type (e.g. I, 6)
 ;     ACDEV("CLINIC")=clinic stop ien
 ;     ACDEV("LOCATION")=location ien
 ;  VIS
 ;     ACDEV("VISIT")=visit ien
 ;     ACDEV("PAT")=patient ien
 ;     ACDEV("TC")=type contact (e.g. IN, CS)
 ;     ACDEV("V DATE")=date of CDMIS visit
 ;     ACDEV("PRI PROV")=primary provider ien
 ;     ACDEV("SVC CAT")=service category (e.g. A)
 ;  IIF & TDC
 ;     ACDEV("POV",n)=icd9 ien:code:CHEMICAL DEPENDENCY-problem narr
 ;     ACDEV("TIME")=time in minutes
 ;  CS
 ;    *ACDEV("V DATE")=date of CDMIS visit
 ;    *ACDEV("LOCATION")=location ien
 ;    *ACDEV("TIME")=time in minutes
 ;    *ACDEV("POV",1)=icd9 ien:code:CONSULTING ON SUBSTANCE USE & ABUSE
 ;     ACDEV("PROC",date,loc,n,"CS IEN")=ien of client svc entry
 ;     ACDEV("PROC",date,loc,n,"NARR")=
 ;                          cpt ien:code:CHEMICAL DEPENDENCY-CS narr
 ;     ACDEV("PROC",date,loc,n,"TIME")=time in minutes
 ;     ACDEV("PROC",date,loc,n,"PROV",provider ien)=""
 ;
 ;     ACDEV("PROC",date,loc,"PROV",provider ien)=""
 ;
START ;
 NEW ACDPROV
 S ACDQ=0
 ;W !!,"Generating CDMIS event array for visit data",!
 W !!,"Generating PCC link",!
 I '$O(ACDPCCL(0)) D ERROR("No visit data found",3) Q
 D PATLOOP
 D EOJ
 S ACDQ=0
 K ACDDFNP,ACDVIEN
 Q
 ;
PATLOOP ; GENERATE PCC LINK OR BILL FOR ALL VISITS FOR EACH PATIENT
 S ACDDFNP=0
 F  S ACDDFNP=$O(ACDPCCL(ACDDFNP)) Q:'ACDDFNP  S ACDVIEN=0 F  S ACDVIEN=$O(ACDPCCL(ACDDFNP,ACDVIEN)) Q:'ACDVIEN  D VISIT
 Q
 ;
VISIT ; EP - BUILD EVENT ARRAY AND GENERATE LINK/BILL FOR ONE VISIT
 ;//^ACDPCCLS
 D VISIT2
 K ACDEV,ACDPCCL(ACDDFNP,ACDVIEN),ACDPDD,ACDPRD
 Q
 ;
VISIT2 ;
 I ACDFHCP D CHKCOV I 'ACD3PCOV,'ACDFPCC Q  ;quit if no coverage/pcc
 K ACD3PCOV
 ;----- if edit mode delete v file entries and then add back
 I ACDMODE="E" D ^ACDPCCL7 S ACDMODEE=""
 Q:'$D(ACDPCCL(ACDDFNP,ACDVIEN))  ; quit if should not be added back
 NEW ACDMODE
 S ACDMODE="A"
 ;-----
 D GENEVENT^ACDPCCL2
 Q:ACDQ
 D:ACDFHCP GENBILL^ACDPCCL4
 D:ACDFPCC GENLINK^ACDPCCL5
 Q
 ;
CHKCOV ; EP-CHECK PATIENT 3RD PARTY COVERAGE ON VISIT DATE
 ;//^ACDBILLP
 S ACD3PCOV=0
 S ACD3PDAT=$P($G(^ACDVIS(ACDVIEN,0)),U)
 Q:ACD3PDAT=""
 S ACD3PCOV=$$MCD^AUPNPAT(ACDDFNP,ACD3PDAT)
 Q:ACD3PCOV
 S ACD3PCOV=$$MCR^AUPNPAT(ACDDFNP,ACD3PDAT)
 Q:ACD3PCOV
 S ACD3PCOV=$$PI^AUPNPAT(ACDDFNP,ACD3PDAT)
 Q:ACD3PCOV
 Q:'$D(ACDPCCLS)
 W !
 S DIR(0)="Y",DIR("A")="There is no 3rd party coverage for this visit.  Print a hardcopy anyway?",DIR("B")="N" K DA D ^DIR K DIR
 S:Y ACD3PCOV=1
 Q
 ;
ERROR(MSG,TIME) ; EP - WRITE ERROR TO OPERATOR
 S:$G(MSG)="" MSG="***** ERROR^ACDPCCL - NOTIFY PROGRAMMER *****"
 W !,$G(IORVON),MSG,$G(IORVOFF),!
 I $G(TIME) H TIME
 Q
 ;
EOJ ;
 K %,A,C,W,X,Y,Z
 K AGE
 K ACDPCCL,ACDEV
 K ACD3PCOV,ACD3PDAT
 Q
