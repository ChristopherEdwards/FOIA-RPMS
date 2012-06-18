DGPFHLL ;ALB/RPM - PRF HL7 TRANSMISSION LOG API'S ; 3/6/03
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
 Q
 ;
GETLOG(DGLIEN,DGPFL) ;retrieve a transmission log record
 ;
 ;  Input:
 ;    DGLIEN - IEN for PRF HL7 TRANSMISSION LOG (#26.17) file
 ;
 ;  Output:
 ;    Function value - 1 on success, 0 on failure
 ;    DGPFL - array of transmission data fields
 ;                    Subscript            Field#
 ;                    -----------------    ------
 ;                    "MSGID"              .01
 ;                    "ASGNHIST"           .02
 ;                    "TRANSDT"            .03
 ;                    "MSGSTAT"            .04
 ;                    "SITE"               .05
 ;                    "ACKDT"              .06
 ;
 N DGIENS ;IEN string for DIQ
 N DGFLDS ;results array for DIQ
 N DGERR  ;error arrary for DIQ
 N DGRSLT
 ;
 S DGRSLT=0
 I $G(DGLIEN)>0,$D(^DGPF(26.17,DGLIEN)) D
 . S DGIENS=DGLIEN_","
 . D GETS^DIQ(26.17,DGIENS,"*","IEZ","DGFLDS","DGERR")
 . Q:$D(DGERR)
 . S DGRSLT=1
 . S DGPFL("MSGID")=$G(DGFLDS(26.17,DGIENS,.01,"I"))_U_$G(DGFLDS(26.17,DGIENS,.01,"E"))
 . S DGPFL("ASGNHIST")=$G(DGFLDS(26.17,DGIENS,.02,"I"))_U_$G(DGFLDS(26.17,DGIENS,.02,"E"))
 . S DGPFL("TRANSDT")=$G(DGFLDS(26.17,DGIENS,.03,"I"))_U_$G(DGFLDS(26.17,DGIENS,.03,"E"))
 . S DGPFL("MSGSTAT")=$G(DGFLDS(26.17,DGIENS,.04,"I"))_U_$G(DGFLDS(26.17,DGIENS,.04,"E"))
 . S DGPFL("SITE")=$G(DGFLDS(26.17,DGIENS,.05,"I"))_U_$G(DGFLDS(26.17,DGIENS,.05,"E"))
 . S DGPFL("ACKDT")=$G(DGFLDS(26.17,DGIENS,.06,"I"))_U_$G(DGFLDS(26.17,DGIENS,.06,"E"))
 ;
 Q DGRSLT
 ;
FNDLOG(DGMSGID) ;find and return the record number for a given HL7 Message ID
 ;
 ;  Input:
 ;    DGMSGID - HL7 Message ID
 ;
 ;  Output:
 ;   Function value - IEN of PRF HL7 TRANSMISSION LOG (#26.17) file on
 ;                    success, 0 on failure
 ;
 N DGIEN
 ;
 I +$G(DGMSGID) D
 . S DGIEN=$O(^DGPF(26.17,"B",DGMSGID,0))
 Q $S($G(DGIEN)>0:DGIEN,1:0)
 ;
STOXMIT(DGHIEN,DGMSGID,DGINST,DGERR) ;store the transmission log data
 ;
 ;  Input:
 ;     DGHIEN - pointer to PRF ASSIGNMENT HISTORY (#26.14) file
 ;    DGMSGID - message ID from VistA HL7
 ;     DGINST - pointer to the INSTITUTION (#4) file
 ;
 ;  Output:
 ;    DGERR - undefined on success, error message on failure
 ;
 N DGFDA     ;fda array
 N DGFDAIEN  ;ien array from DIE
 ;
 I +$G(DGHIEN),$D(^DGPF(26.14,DGHIEN)),$D(DGMSGID),+$G(DGINST),$D(^DIC(4,DGINST)) D
 . N DGFDAIEN
 . Q:$$FNDLOG^DGPFHLL(DGMSGID)
 . S DGFDA(26.17,"+1,",.01)=DGMSGID
 . S DGFDA(26.17,"+1,",.02)=DGHIEN
 . S DGFDA(26.17,"+1,",.03)=$$NOW^XLFDT()
 . S DGFDA(26.17,"+1,",.04)="T"
 . S DGFDA(26.17,"+1,",.05)=DGINST
 . D UPDATE^DIE("","DGFDA","DGFDAIEN","DGERR")
 Q
 ;
STOSTAT(DGLIEN,DGSTAT) ;update the HL7 transmission status
 ;
 ;  Input:
 ;    DGLIEN - IEN of PRF HL7 TRANSMISSION LOG (#26.17) file
 ;    DGSTAT - internal Status value ("T","A","RJ","M","RT")
 ;
 ;  Output:
 ;    none
 ;
 N DGERR    ;filer errors
 N DGFDA    ;fda array
 N DGLIENS  ;iens string
 ;
 I +$G(DGLIEN),$D(^DGPF(26.17,DGLIEN)),$G(DGSTAT)]"" D
 . Q:'$$TESTVAL^DGPFUT(26.17,.04,DGSTAT)
 . S DGLIENS=DGLIEN_","
 . S DGFDA(26.17,DGLIENS,.04)=DGSTAT
 . S DGFDA(26.17,DGLIENS,.06)=$$NOW^XLFDT()
 . D FILE^DIE("","DGFDA","DGERR")
 Q
