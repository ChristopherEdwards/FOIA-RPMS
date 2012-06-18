APCD3MF ; IHS/CMI/LAB - install and generate HL7 messages to 3M ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
FILE(APCD3M) ;EP
 I '$D(APCD3M) Q  ;no array passed by caller
 NEW APCDERR,APCDX,DFN,DOB,ICD9,IEN772,MSGDT,MSGTYPE,NAME,RECAPP,SENDAPP,SENDFAC,SEX,VISIT,VPOV,VPOVC
 ;new fileman and single character vars
 NEW %,%D,%E,%Y,D0,DA,DD,DI,DIC,DIE,DLAYGO,DO,DQ,DR,I,N,X,Y,Z
 D MSGSET
 I $G(APCDERR)]"" Q
 D CHECKREC
 I $G(APCDERR)]"" D LOGERR Q
 Q
CHECKREC ;
 S APCDX=0 F  S APCDX=$O(VPOV(APCDX)) Q:APCDX'=+APCDX  S Y=$P(VPOV(APCDX),"^") D
 . S Z=$G(^AUPNVPOV(Y,0)) I Z="" S APCDERR="Invalid VPOV ien passed back." Q
 . I DFN'=$P(Z,"^",2) S APCDERR="DFN in HL7 doesn't match V POV patient." Q
 . I VISIT'=$P(Z,"^",3) S APCDERR="VISIT in HL7 doesn't match V POV visit." Q
 . S N=$P(VPOV(APCDX),"^",2),%=$P(Z,"^",4),%=$P(^AUTNPOV(%,0),U) I N'=% S APCDERR="Provider Narratives mismatch" Q
 . ;file ICD9 code
 . S ICD9=$P(VPOV(APCDX),"^",3),ICD9=$$CODEN^ICDCODE(ICD9,80) S:+ICD9=-1 ICD9="" I ICD9="" S APCDERR="Could not find ICD9 code in table." Q
 . NEW DD,DO,DA,DIC,DLAYGO,I,X,Y,%,%D,%E,%Y,D0,DI,DIE,DQ,DR,AUPNSEX
 . S DA=$P(VPOV(APCDX),"^") I '$D(^AUPNVPOV(DA,0)) S APCDERR="VPOV no longer exists." Q
 . S AUPNSEX=$P(^DPT(DFN,0),"^",2)
 . S DIE="^AUPNVPOV(",DR=".01///"_ICD9 D ^DIE
 . I $D(Y) S APCDERR="Updating VPOV with code failed DIE." Q
 . Q
 Q
MSGSET ;
 S APCDERR="",VPOVC=0
 K VPOV
 S X=0 F  S X=$O(APCD3M(X)) Q:X'=+X!(APCDERR]"")  S Y=$P(APCD3M(X),"|") I $T(@Y)]"" D @Y I APCDERR]"" D LOGERR
 Q
MSH ;message segment check and set vars
 S Y=APCD3M(X)
 S SENDAPP=$P(Y,"|",3)
 S SENDFAC=$P(Y,"|",4)
 S RECAPP=$P(Y,"|",5)
 S MSGDT=$P(Y,"|",7)
 S MSGTYPE=$P(Y,"|",9)
 Q
PID ;
 S Y=$P(APCD3M(X),"|",2,999)
 S DFN=$P(Y,"|",3)
 I DFN="" S APCDERR="No DFN passed in HL7 message" Q
 S NAME=$P(Y,"|",5)
 S DOB=$P(Y,"|",3)
 S SEX=$P(Y,"|",8)
 Q
PV1 ;
 S Y=$P(APCD3M(X),"|",2,999)
 S VISIT=$P(Y,"|",19)
 I VISIT="" S APCDERR="No VISIT passed back in HL7 message." Q
 I '$D(^AUPNVSIT(VISIT,0)) S APCDERR="Visit has been deleted." Q
 I $P(^AUPNVSIT(VISIT,0),"^",11) S APCDERR="Visit has been deleted." Q
 Q
DG1 ;
 S Y=$P(APCD3M(X),"|",2,999),Z=$O(APCD3M(X))
 I 'Z S APCDERR="No ZDX immediately following DG1" Q
 I $P(APCD3M(Z),"|")'="ZDX" S APCDERR="No ZDX immediately following DG1" Q
 S Z=$P(APCD3M(Z),"|",2,999)
 I $P(Y,"|",3)="" S APCDERR="No diagnosis code passed back. "_$P(Y,"|",1) Q
 I $P(Z,"|",7)="" S APCDERR="No VPOV ien passed back. "_$P(Y,"|") Q
 I $P(Z,"|")="" S APCDERR="No provider narrative passed back. "_$P(Y,"|") Q
 S VPOVC=VPOVC+1,VPOV(VPOVC)=$P(Z,"|",7)_"^"_$P(Z,"|")_"^"_$P(Y,"|",3)
 Q
 ;check for required items
 ;patient dfn, visit ien, vpov ien and icd code and narrative
LOGERR ; Log Application Error in IHS HL7 ERROR LOG FILE (#90074)
 ;
 N DD,DO,DA,DIC,DLAYGO,I,X,Y,%,%D,%E,%Y,D0,DI,DIE,DQ,DR
 S IEN772=$S($G(APCD3M(0)):"`"_APCD3M(0),1:"")
 D NOW^%DTC S X=%
 S DIC="^BHL(90074,",DIC(0)="L",DLAYGO=90074
 S DIC("DR")=".02///^S X=RECAPP;.03///^S X=SENDAPP;.04///^S X=DUZ(2);.05///^S X=SENDFAC;.06///^S X=IEN772;.07///APCD3MF;.08///^S X=APCDERR"
 K DD,DO D FILE^DICN
 Q
