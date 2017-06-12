APCCUTL ;  IHS/CMI/LAB - PCC UTILITIES ;   
 ;;2.0;IHS PCC SUITE;**10**;MAY 14, 2009;Build 88
 ;
DL(APCCV,APCCD,APCCP,APCCT,APCCA) ;PEP - called to log the printing of a clinical summary or other document
 ;APCCV - Visit array with visit ien^document ID
 ;        e.g.:  APCCV(1)="3299999^DOC1234567"
 ;               APCCV(2)="32991000^ABC12345"
 ;        I am including a document ID because someone suggested it, the measure doesn't
 ;        require it but pass it if you know it, it might help during testing or as a trail
 ;        to make sure there really was a document.
 ;APCCD - date/time in internal fileman format - when the document was printed, assumption, per Fay
 ;        is that all visits in the array were printed at the same time
 ;APCCP - user who printed (if not passed will default to DUZ)
 ;APCCT - type of document
 ;    1 - Clinical Summary
 ;    2 - Transition of Care
 ;    this list may expand in the future
 ;    NOTE: only 1 type of document can be used per call, assumption is that all visits had the
 ;          same document type, date/time, user and action
 ;APCCA - action.  for now the only allowable value is "P" which stands for PRINTED.
 ;    I added this action field so that if, in the future, we need to log that documents
 ;    were, for example, emailed or mailed or sent by pigeon we can do so without creating
 ;    a new log
 ;
 ;
 ;RETURN VALUE WILL BE 1 IF LOG UPDATED SUCCESSFULLY, IT WILL BE 0 IF NOT, DOUBT ANY
 ;CALLER CARES BUT JUST IN CASE, ESPECIALLY DURING TESTING I AM SENDING BACK A VALUE
 ;
 I '$O(APCCV(0)) Q 0  ;NO VISIT IENS PASSED
 I $G(APCCD)="" Q 0  ;NO DATE/TIME PASSED (I WONDER IF I SHOULD DEFAULT TO $$NOW^XLFDT if blank????)
 I $G(APCCP)="" S APCCP=$G(DUZ)  ;IF NO USER USE DUZ
 I '$D(^VA(200,APCCP,0)) Q 0  ;USER INVALID
 I $G(APCCT)="" Q 0  ;I NEED A DOCUMENT TYPE
 ;I APCCT'=1 Q 0  ;I ONLY CARE ABOUT CLINICAL SUMMARY AT THIS POINT SO DON'T LOG ANY OTHERS
 I $G(APCCA)="" Q 0  ;NEED TO KNOW THE ACTION
 ;I $G(APCCA)'="P" Q 0  ;I ONLY CARE ABOUT PRINTED FOR THIS MEASURE AT THIS TIME
 ;now create an entry for each visit ien
 NEW APCCV1,DIC,DR,X,Y,DA,DIADD,DLAYGO,APCCF,APCCX,DINUM
 S APCCF=1,APCCX=0
 F  S APCCX=$O(APCCV(APCCX)) Q:APCCX=""  D
 .S APCCV1=$P(APCCV(APCCX),U,1)
 .I 'APCCV1 S APCCF=0 Q  ;NO VISIT IEN
 .I '$D(^AUPNVSIT(APCCV1,0)) S APCCF=0 Q  ;NO VISIT??
 .S DA=$O(^APCCDPL("B",APCCV1,0))
 .I DA D UPD Q
 .;CREATE ENTRY
 .K DA
 .S X=APCCV1,DIC="^APCCDPL(",DIADD=1,DINUM=X,DLAYGO=9001205,DIC(0)="L" D FILE^DICN K DIADD,DLAYGO,DIC,DINUM,DIC
 .I Y=-1 S APCCF=0 Q
 .S DA=+Y
 .D UPD
 .Q
 Q APCCF
UPD ;
 ;UPDATE MULTIPLE
 NEW APCCIENS,APCCFDA,APCCERR
 S APCCIENS=DA_","
 S APCCFDA(9001205.1,"+2,"_APCCIENS,.01)=APCCD
 S APCCFDA(9001205.1,"+2,"_APCCIENS,.02)=APCCA
 S APCCFDA(9001205.1,"+2,"_APCCIENS,.03)=APCCP
 S APCCFDA(9001205.1,"+2,"_APCCIENS,.04)=APCCT
 S APCCFDA(9001205.1,"+2,"_APCCIENS,.05)=$P(APCCV(APCCX),U,2)
 D UPDATE^DIE("","APCCFDA","APCCIENS","APCCERR(1)")
 I $D(APCCERR) S APCCF=0 Q
 Q
TEST ;
 K V
 S V(1)="3299699^ABC123456"
 S V(2)="3299709^XYZ123456"
 S V(3)="3299711^DOC345666"
 S X=$$DL(.V,$$NOW^XLFDT(),DUZ,1,"P")
 Q
