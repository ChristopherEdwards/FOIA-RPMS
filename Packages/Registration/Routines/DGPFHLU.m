DGPFHLU ;ALB/RPM - PRF HL7 ORU/ACK PROCESSING ; 6/17/03 1:27pm
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
BLDORU(DGPFA,DGPFAH,DGHL,DGROOT) ;Build ORU~R01 Message/Segments
 ;
 ;  Input:
 ;      DGPFA - (required) Assignment data array
 ;     DGPFAH - (required) Assignment history data array
 ;       DGHL - (required) HL7 Kernel array passed by reference
 ;     DGROOT - (required) Closed root array or global name for segment
 ;              storage
 ;
 ;  Output:
 ;   Function Value - 1 on success, 0 on failure
 ;           DGROOT - array of HL7 segments
 ;
 N DGRSLT    ;function value
 N DGSEG     ;segment counter
 N DGSEGSTR  ;formatted segment string
 N DGSET     ;set id
 N DGSTR     ;field string
 N DGTROOT   ;text root
 ;
 S DGRSLT=0
 S DGSEG=0
 ;
 I $D(DGPFA),$D(DGPFAH),$G(DGROOT)]"" D
 . ;
 . ;build PID
 . S DGSTR="1,2,3,5,7,8,19"
 . S DGSEGSTR=$$EN^VAFHLPID(+DGPFA("DFN"),DGSTR,1,1)
 . Q:(DGSEGSTR="")
 . S DGSEG=DGSEG+1,@DGROOT@(DGSEG)=DGSEGSTR
 . ;
 . ;build OBR
 . S DGSET=1
 . S DGSTR="1,4,7,20"
 . S DGSEGSTR=$$OBR^DGPFHLU1(DGSET,.DGPFA,.DGPFAH,DGSTR,.DGHL)
 . Q:(DGSEGSTR="")
 . S DGSEG=DGSEG+1,@DGROOT@(DGSEG)=DGSEGSTR
 . ;
 . ;start OBX segments
 . S DGSET=0
 . ;
 . ;build narrative OBX segments
 . S DGTROOT="DGPFA(""NARR"")"
 . Q:'$$BLDOBXTX^DGPFHLU2(DGROOT,DGTROOT,"N",.DGPFAH,.DGHL,.DGSEG,.DGSET)
 . ;
 . ;build status OBX segment
 . S DGSTR="1,2,3,5,11,14"
 . S DGSET=DGSET+1
 . S DGSEGSTR=$$OBX^DGPFHLU2(DGSET,"S","",$P($G(DGPFAH("ACTION")),U,2),.DGPFAH,DGSTR,.DGHL)
 . Q:(DGSEGSTR="")
 . S DGSEG=DGSEG+1,@DGROOT@(DGSEG)=DGSEGSTR
 . ;
 . ;build review comment OBX segments
 . S DGTROOT="DGPFAH(""COMMENT"")"
 . Q:'$$BLDOBXTX^DGPFHLU2(DGROOT,DGTROOT,"C",.DGPFAH,.DGHL,.DGSEG,.DGSET)
 . ;
 . ;success
 . S DGRSLT=1
 ;
 Q DGRSLT
 ;
PARSORU(DGWRK,DGHL,DGPFA,DGPFAH,DGPFERR) ;Parse ORU~R01 Message/Segments
 ;
 ;  Input:
 ;     DGWRK - Closed root work global reference
 ;      DGHL - HL7 environment array
 ;
 ;  Output:
 ;     DGPFA - Assignment data array
 ;    DGPFAH - Assignment history data array
 ;   DGPFERR - Undefined on success, ERR segment data array on failure
 ;             Format:  DGPFERR(seg_id,sequence,fld_pos)=error_code
 ;
 N DGFS      ;field separator
 N DGCS      ;component separator
 N DGRS      ;repetition separator
 N DGCURLIN  ;current segment line
 N DGSEG     ;segment field data array
 N DGERR     ;error processing array
 ;
 S DGFS=DGHL("FS")
 S DGCS=$E(DGHL("ECH"),1)
 S DGRS=$E(DGHL("ECH"),2)
 S DGCURLIN=0
 ;
 ;loop through the message segments and retrieve the field data
 F  D  Q:'DGCURLIN
 . N DGSEG
 . S DGCURLIN=$$NXTSEG^DGPFHLUT(DGWRK,DGCURLIN,DGFS,.DGSEG)
 . Q:'DGCURLIN
 . D @(DGSEG("TYPE")_"(.DGSEG,DGCS,DGRS,.DGPFA,.DGPFAH,.DGPFERR)")
 ;
 ;the ENTERBY and APPRVBY will always be POSTMASTER (DUZ=.5)
 S DGPFAH("ENTERBY")=.5  ;ENTERED BY  (.04) field, file 26.14
 S DGPFAH("APPRVBY")=.5  ;APPROVED BY (.05) field, file 26.14
 Q
 ;
MSH(DGSEG,DGCS,DGRS,DGPFA,DGPFAH,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - MSH segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;
 ;  Output:
 ;   DGPFA("ORIGSITE") - ORIGINATING SITE (.05) field, file #26.13 
 ;               DGERR - undefined on success, error array on failure
 ;                      format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 S DGPFA("ORIGSITE")=$$IEN^XUAF4($P(DGSEG(4),DGCS,1))
 I (DGPFA("ORIGSITE")="")!('$$TESTVAL^DGPFUT(26.13,.05,DGPFA("ORIGSITE"))) D
 . S DGERR("MSH",1,4)="IOR"
 Q
 ;
PID(DGSEG,DGCS,DGRS,DGPFA,DGPFAH,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - PID segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;
 ;  Output:
 ;    DGPFA("DFN") - PATIENT NAME (.01) field, file #26.13
 ;           DGERR - undefined on success, error array on failure
 ;                   format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 N DGICN
 N DGDOB
 N DGSSN
 ;
 S DGICN=+$P(DGSEG(3),DGCS,1)
 S DGDOB=+$$HL7TFM^XLFDT(DGSEG(7))
 S DGSSN=DGSEG(19)
 S DGPFA("DFN")=$$GETDFN^DGPFUT2(DGICN,DGDOB,DGSSN)
 I 'DGPFA("DFN") D
 . S DGERR("PID",DGSEG(1),3)="NM"  ;no match
 Q
 ;
OBR(DGSEG,DGCS,DGRS,DGPFA,DGPFAH,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - OBR segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;
 ;  Output:
 ;    DGPFA("FLAG") - FLAG NAME  (.02) field, file #26.13
 ;   DGPFA("OWNER") - OWNER SITE (.04) field, file #26.13
 ;            DGERR - undefined on success, error array on failure
 ;                    format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 S DGPFA("FLAG")=$P($G(DGSEG(4)),DGCS,1)_";DGPF(26.15,"
 I '$$TESTVAL^DGPFUT(26.13,.02,DGPFA("FLAG")) D
 . S DGERR("OBR",DGSEG(1),4)="IF"   ;invalid flag
 S DGPFA("OWNER")=$$IEN^XUAF4(DGSEG(20))
 I (DGPFA("OWNER")="")!('$$TESTVAL^DGPFUT(26.13,.04,DGPFA("OWNER"))) D 
 . S DGERR("OBR",DGSEG(1),20)="IOW"  ;invalid owner site
 Q
 ;
OBX(DGSEG,DGCS,DGRS,DGPFA,DGPFAH,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - OBX segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;
 ;  Output:
 ;    DGPFA("STATUS") - STATUS               (.03) field, file #26.13
 ;      DGPFA("NARR") - ASSIGNMENT NARRATIVE   (1) field, file #26.13
 ; DGPFAH("ASSIGNDT") - DATE/TIME            (.02) field, file #26.14
 ;   DGPFAH("ACTION") - ACTION               (.03) field, file #26.14
 ;  DGPFAH("COMMENT") - HISTORY COMMENTS       (1) field, file #26.14
 ;              DGERR - undefined on success, error array on failure
 ;                      format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 N DGI
 N DGLINE
 N DGRSLT
 ;
 ;validate Observation ID value - quit if invalid
 I '$F("NSC",$P(DGSEG(3),DGCS,1)) D  Q
 . S DGERR("OBX",DGSEG(1),3)="IID"
 ;
 ; Narrative Observation Identifier
 I $P(DGSEG(3),DGCS,1)="N" D
 . S DGLINE=$O(DGPFA("NARR",""),-1)
 . F DGI=1:1:$L(DGSEG(5),DGRS) D
 . . S DGPFA("NARR",DGLINE+DGI,0)=$P(DGSEG(5),DGRS,DGI)
 ;
 ; Status Observation Identifier
 I $P(DGSEG(3),DGCS,1)="S" D
 . D CHK^DIE(26.14,.03,,DGSEG(5),.DGRSLT)
 . S DGPFAH("ACTION")=+DGRSLT
 . S DGPFAH("ASSIGNDT")=$$HL7TFM^XLFDT(DGSEG(14))
 . S DGPFA("STATUS")=$$STATUS^DGPFUT(DGPFAH("ACTION"))
 ;
 ; Comment Observation Identifier
 I $P(DGSEG(3),DGCS,1)="C" D
 . S DGLINE=$O(DGPFAH("COMMENT",""),-1)
 . F DGI=1:1:$L(DGSEG(5),DGRS) D
 . . S DGPFAH("COMMENT",DGLINE+DGI,0)=$P(DGSEG(5),DGRS,DGI)
 Q
 ;
