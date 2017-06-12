BUSAACVR ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Access Program ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
 Q
 ;
CHECKAV(BUSAAV) ;EP - Authenticate AC/VC and Return DUZ
 ;
 ; Input: BUSAAV - ACCESS CODE_";"_VERIFY CODE
 ; Output: DUZ value
 ;
 N BUSADUZ,XUF
 ;
 S:$G(U)="" U="^"
 S:$G(DT)="" DT=$$DT^XLFDT
 ;
 S XUF=0
 S BUSADUZ=$$CHECKAV^XUS(BUSAAV)
 I BUSADUZ=0 Q 0
 ;
 ;Return DUZ if user inactive
 I (+$P($G(^VA(200,BUSADUZ,0)),U,11)'>0)!(+$P($G(^VA(200,BUSADUZ,0)),U,11)'<DT) Q BUSADUZ
 Q 0
 ;
AUTH(BUSADUZ) ;EP - Authenticate User for BUSA REPORT Access
 ;
 ; Input: BUSADUZ - User's DUZ value
 ; Output: 0 - No Authorized/1 - Authorized
 ;
 N BUSAKEY,EXEC,GL
 ;
 S:$G(U)="" U="^"
 ;
 I $G(BUSADUZ)<1 Q 0
 S BUSAKEY=$O(^DIC(19.1,"B","BUSAZRPT","")) I BUSAKEY="" Q 0
 I '$D(^VA(200,"AB",BUSAKEY,BUSADUZ,BUSAKEY)) Q 0
 ;
 ;Now check if user defined in Cache User Access class
 S EXEC="S GL=$NA(^BUSA.UsersI(""StatusUserIdx"",""A""))" X EXEC
 I '$D(@GL@(" "_BUSADUZ)) Q 0
 ;
 Q 1
