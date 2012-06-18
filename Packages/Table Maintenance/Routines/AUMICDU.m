AUMICDU ;IHS/ASDST/DMJ - ICD UTILITIES ; [ 01/23/2002   4:23 PM ]
 ;;02.1;ICD UPDATE;**4**;SEP 15, 2001
DX(AUMX,AUMY,AUMZ) ;PEP;edit checks ICD Diagnosis (file # 80) ; IHS/ASDST/GTH AUM*2.1*4 01/23/2002
 ;aumx=code
 ;aumy=date (fm format,null=today)
 ;aumz=patient ien
 ;x=0:pass, x=1:fail inactive, x=2:fail sex, x=3:fail age
 N X
 S X=0
 I $G(AUMX)="" S X=1 Q X
 S AUMIEN=$O(^ICD9("AB",AUMX,0))
 I 'AUMIEN S X=1 Q X
 I '$D(^ICD9(AUMIEN,0)) S X=1 Q X
 S AUM0=^ICD9(AUMIEN,0)
 S AUM9=$G(^ICD9(AUMIEN,9999999))
 I '$G(DT) D DT
 I $G(AUMY)="" S AUMY=DT
 D AI
 I $G(AUMZ) D PAT
 D KILL
 Q X
PX(AUMX,AUMY,AUMZ) ;PEP;edit checks ICD Procedures (file # 80.1) ; IHS/ASDST/GTH AUM*2.1*4 01/23/2002
 ;x=code
 ;y=date (fm format,null=today))
 ;z=patient ien
 ;x=0:pass, x=1:fail inactive, x=2:fail sex, x=3:fail age
 N X
 S X=0
 I $G(AUMX)="" S X=1 Q X
 S AUMIEN=$O(^ICD0("AB",AUMX,0))
 I 'AUMIEN S X=1 Q X
 I '$D(^ICD0(AUMIEN,0)) S X=1 Q X
 S AUM0=^ICD0(AUMIEN,0)
 S AUM9=$G(^ICD0(AUMIEN,9999999))
 I '$G(DT) D DT
 I $G(AUMY)="" S AUMY=DT
 D AI
 I $G(AUMZ) D PAT
 D KILL
 Q X
DT ;set DT if missing
 S DT=$$DT^XLFDT
 Q
AI ;check dates
 S AUMIDT=$P(AUM0,"^",11)
 S AUMADT=$P(AUM9,"^",4)
 I AUMIDT,AUMIDT<AUMY S X=1
 I AUMADT,AUMADT>AUMY S X=1
 Q
PAT ;check patient
 I $P(AUM0,"^",10)'="" D SEX
 I $P(AUM9,"^",1) D AGE
 I $P(AUM9,"^",2) D AGE
 Q
SEX ;check sex
 S AUMSEX=$P($G(^DPT(AUMZ,0)),"^",2)
 I AUMSEX'=$P(AUM0,"^",10) S X=2
 Q
AGE ;check patient age
 S AUMLO=$P(AUM9,"^",1)
 S AUMHI=$P(AUM9,"^",2)
 S AUMDOB=$P($G(^DPT(AUMZ,0)),"^",3)
 S AUMDAYS=$$FMDIFF^XLFDT(AUMY,AUMDOB,1)
 Q:'AUMDAYS
 I AUMLO,AUMDAYS<AUMLO S X=3
 I AUMHI,AUMDAYS>AUMHI S X=3
 Q
KILL ;house keeping
 K AUMIDT,AUMADT,AUMIEN,AUM0,AUM9,AUMSEX,AUMDAYS,AUMHI,AUMLO,AUMDOB
 Q
