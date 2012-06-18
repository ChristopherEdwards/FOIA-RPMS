DGPFHLQ3 ;ALB/RPM - PRF HL7 QRY/ORF PROCESSING ; 3/13/03
 ;;5.3;Registration;**425**;Aug 13, 1993
 ;
PARSQRY(DGWRK,DGHL,DGQRY,DGPFERR) ;Parse QRY~R02 Message/Segments
 ;
 ;  Input:
 ;    DGWRK - Closed root global reference
 ;     DGHL - VistA HL7 environment array
 ;
 ;  Output:
 ;    DGQRY - Patient lookup components array
 ;   DGPFERR - Undefined on success, ERR segment data array on failure
 ;             Format:  DGPFERR(seg_id,sequence,fld_pos)=error_code
 ;
 N DGRSLT    ;result from CHK^DIE
 N DGFS      ;field separator
 N DGCS      ;component separator
 N DGRS      ;repetition separator
 N DGSS      ;sub-component separator
 N DGCURLIN  ;current segment line
 N DGSEG     ;segment field data array
 N DGERR     ;error processing array
 ;
 S DGFS=DGHL("FS")
 S DGCS=$E(DGHL("ECH"),1)
 S DGRS=$E(DGHL("ECH"),2)
 S DGSS=$E(DGHL("ECH"),4)
 S DGCURLIN=0
 ;
 ;loop through the message segments and retrieve the field data
 F  D  Q:'DGCURLIN
 . N DGSEG
 . S DGCURLIN=$$NXTSEG^DGPFHLUT(DGWRK,DGCURLIN,DGFS,.DGSEG)
 . Q:'DGCURLIN
 . D @(DGSEG("TYPE")_"(.DGSEG,DGCS,DGRS,DGSS,.DGQRY,.DGPFERR)")
 Q
 ;
PARSORF(DGWRK,DGHL,DGORF,DGMSG) ;Parse ORF~R04 Message/Segments
 ;
 ;  Input:
 ;    DGWRK - Closed root work global reference
 ;     DGHL - HL7 environment array
 ;
 ;  Output:
 ;    DGORF - array of ORF results
 ;            OBRsetID,assigndt,"ACTION"
 ;            OBRsetID,assigndt,"COMMENT",line#
 ;            OBRsetID,"FLAG"
 ;            OBRsetID,"NARR",line#
 ;            OBRsetID,"OWNER"
 ;            "ACKCODE" - acknowledgment code ("AA","AE","AR")
 ;            "ICN"     - patient's Integrated Control Number
 ;            "MSGDTM"  - message creation date/time in FileMan format
 ;            "MSGID"   -
 ;            "QID"     - query ID (DFN)
 ;            "RCVFAC"  - receiving facility
 ;            "SNDFAC"  - sending facility
 ;
 ;    DGMSG - undefined on success, array of MailMan text on failure
 ;
 N DGFS
 N DGCS
 N DGRS
 N DGSS
 N DGCURLIN
 ;
 S DGFS=DGHL("FS")
 S DGCS=$E(DGHL("ECH"),1)
 S DGRS=$E(DGHL("ECH"),2)
 S DGSS=$E(DGHL("ECH"),4)
 S DGCURLIN=0
 ;
 ;loop through the message segments and retrieve the field data
 F  D  Q:'DGCURLIN
 . N DGSEG
 . S DGCURLIN=$$NXTSEG^DGPFHLUT(DGWRK,DGCURLIN,DGFS,.DGSEG)
 . Q:'DGCURLIN
 . D @(DGSEG("TYPE")_"(.DGSEG,DGCS,DGRS,DGSS,.DGORF,.DGMSG)")
 Q
 ;
MSH(DGSEG,DGCS,DGRS,DGSS,DGORF,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - MSH segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;    DGORF - array of ORF results
 ;            "SNDFAC" - sending facility
 ;            "RCVFAC" - receiving facility
 ;            "MSGDTM" - message creation date/time in FileMan format
 ;    DGERR - undefined on success, error array on failure
 ;
 D MSH^DGPFHLU4(.DGSEG,DGCS,DGRS,DGSS,.DGORF,.DGERR)
 Q
 ;
MSA(DGSEG,DGCS,DGRS,DGSS,DGORF,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - MSH segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;    DGORF - array of ORF results
 ;            "ACKCODE" - Acknowledgment code
 ;            "MSGID" - Message Control ID of the message being ACK'ed
 ;    DGERR - undefined on success, error array on failure
 ;
 D MSA^DGPFHLU4(.DGSEG,DGCS,DGRS,DGSS,.DGORF,.DGERR)
 Q
 ;
ERR(DGSEG,DGCS,DGRS,DGSS,DGORF,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - MSH segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;    DGORF - array of ORF results
 ;    DGERR - undefined on success, error array on failure
 ;
 D ERR^DGPFHLU4(.DGSEG,DGCS,DGRS,DGSS,.DGORF,.DGERR)
 Q
 ;
QRD(DGSEG,DGCS,DGRS,DGSS,DGQRY,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - MSH segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;    DGQRY("ICN") - Patient's Integrated Control Number
 ;    DGQRY("QID") - Query ID
 ;           DGERR - undefined on success, error array on failure
 ;                      format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 S DGQRY("QID")=$G(DGSEG(4))
 S DGQRY("ICN")=+$P($G(DGSEG(8)),DGCS,1)
 I DGQRY("ICN")="" D
 . S DGERR("QRD",1,8)="NM"
 Q
 ;
QRF(DGSEG,DGCS,DGRS,DGSS,DGQRY,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - PID segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;    DGQRY("SSN") - Patient's Social Security Number
 ;    DGQRY("DOB") - Patient's Date of Birth
 ;           DGERR - undefined on success, error array on failure
 ;                   format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 S DGQRY("SSN")=$G(DGSEG(4))
 I DGQRY("SSN")="" S DGERR("QRF",1,4)="NM"  ;no match
 ;
 S DGQRY("DOB")=+$$HL7TFM^XLFDT($G(DGSEG(5)))
 I DGQRY("DOB")'>0 S DGERR("QRF",1,5)="NM"  ;no match
 Q
 ;
OBR(DGSEG,DGCS,DGRS,DGSS,DGORF,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - OBR segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;     DGORF(setid,"FLAG") - FLAG NAME  (.02) field, file #26.13
 ;    DGORF(setid,"OWNER") - OWNER SITE (.04) field, file #26.13
 ; DGORF(setid,"ORIGSITE") - ORIGINATING SITE (.05) field, file #26.13
 ;          DGORF("SETID") - OBR segment Set ID
 ;                   DGERR - undefined on success, error array on failure
 ;                    format: DGERR(seg_id,sequence,fld_pos)=error code
 N DGSETID  ;OBR segment Set ID
 ;
 S (DGORF("SETID"),DGSETID)=+$G(DGSEG(1))
 I DGSETID>0 D
 . S DGORF(DGSETID,"FLAG")=$P($G(DGSEG(4)),DGCS,1)_";DGPF(26.15,"
 . S DGORF(DGSETID,"OWNER")=$$IEN^XUAF4($G(DGSEG(20)))
 . S DGORF(DGSETID,"ORIGSITE")=$$IEN^XUAF4($G(DGSEG(21)))
 Q
 ;
OBX(DGSEG,DGCS,DGRS,DGSS,DGORF,DGERR) ;
 ;
 ;  Input:
 ;    DGSEG - OBX segment field array
 ;     DGCS - HL7 component separator
 ;     DGRS - HL7 repetition separator
 ;     DGSS - HL7 sub-component separator
 ;
 ;  Output:
 ;             DGORF(setid,"NARR",line) - ASSIGNMENT NARRATIVE (1) field,
 ;                                        file #26.13
 ;       DGORF(setid,assigndt,"ACTION") - ACTION             (.03) field,
 ;                                        file #26.14
 ; DGORF(setid,assigndt,"COMMENT",line) - HISTORY COMMENTS     (1) field,
 ;                                        file #26.14
 ;              DGERR - undefined on success, error array on failure
 ;                      format: DGERR(seg_id,sequence,fld_pos)=error code
 ;
 N DGADT     ;assignment date
 N DGI
 N DGLINE    ;text line counter
 N DGRSLT
 N DGSETID   ;OBR segment Set ID
 ;
 S DGSETID=+$G(DGORF("SETID"))
 Q:(DGSETID'>0)
 ;
 ; Narrative Observation Identifier
 I $P(DGSEG(3),DGCS,1)="N" D
 . S DGLINE=$O(DGORF(DGSETID,"NARR",""),-1)
 . F DGI=1:1:$L(DGSEG(5),DGRS) D
 . . S DGORF(DGSETID,"NARR",DGLINE+DGI,0)=$P(DGSEG(5),DGRS,DGI)
 ;
 ; Status Observation Identifier
 I $P(DGSEG(3),DGCS,1)="S" D
 . S DGADT=$$HL7TFM^XLFDT(DGSEG(14))
 . Q:(+DGADT'>0)
 . D CHK^DIE(26.14,.03,,DGSEG(5),.DGRSLT)
 . S DGORF(DGSETID,DGADT,"ACTION")=+DGRSLT
 ;
 ; Comment Observation Identifier
 I $P(DGSEG(3),DGCS,1)="C" D
 . S DGADT=$$HL7TFM^XLFDT(DGSEG(14))
 . Q:(+DGADT'>0)
 . S DGLINE=$O(DGORF(DGSETID,DGADT,"COMMENT",""),-1)
 . F DGI=1:1:$L(DGSEG(5),DGRS) D
 . . S DGORF(DGSETID,DGADT,"COMMENT",DGLINE+DGI,0)=$P(DGSEG(5),DGRS,DGI)
 Q
