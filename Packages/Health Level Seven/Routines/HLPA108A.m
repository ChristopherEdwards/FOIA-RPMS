HLPA108A ;CIOFO-SF/RJH - HL7 PATCH 108 PRE&POST-INIT ;02/25/04  16:19
 ;;1.6;HEALTH LEVEL SEVEN;**108**;Oct 13, 1995
 ;
 ; Pre-install II:
 ; Entries: PTR771, PEVE, PMSG, and PMSG, are called from HLPAT108
 Q
PTR771 ; resolve pointers for sub-field #771.06,.01 of field #771,6
 ; and #771.05,.01 of field #771,5
 ;
 ; HLMSGP: pointer to file #771.2
 ; HLMSGPN: redirected new pointer to file #771.2
 ; HLSEGP: pointer to file #771.3
 ; HLSEGPN: redirected new pointer to file #771.3
 ;
 N HLIEN,HLIEN2,HLMSGP,HLMSGPN,DIE,DA,DR
 N HLSEGP,HLSEGPN
 S HLIEN=0
 F  S HLIEN=$O(^HL(771,HLIEN)) Q:'HLIEN  D
 . I $D(^HL(771,HLIEN,"MSG")) D
 .. S HLIEN2=0
 .. F  S HLIEN2=$O(^HL(771,HLIEN,"MSG",HLIEN2)) Q:'HLIEN2  D
 ... I $D(^HL(771,HLIEN,"MSG",HLIEN2,0)) D
 .... S HLMSGP=$P(^HL(771,HLIEN,"MSG",HLIEN2,0),"^")
 .... S HLMSGPN=0
 .... I HLMSGP>0 S HLMSGPN=$$PMSG^HLPA108A(HLMSGP)
 .... ; redirect pointer for SUB-field #771.06,.01 of field #771,6
 .... I HLMSGPN D
 ..... S DIE="^HL(771,"_HLIEN_",""MSG"","
 ..... S DA(1)=HLIEN
 ..... S DA=HLIEN2
 ..... S DR=".01////"_HLMSGPN
 ..... D ^DIE
 . I $D(^HL(771,HLIEN,"SEG")) D
 .. S HLIEN2=0
 .. F  S HLIEN2=$O(^HL(771,HLIEN,"SEG",HLIEN2)) Q:'HLIEN2  D
 ... I $D(^HL(771,HLIEN,"SEG",HLIEN2,0)) D
 .... S HLSEGP=$P(^HL(771,HLIEN,"SEG",HLIEN2,0),"^")
 .... S HLSEGPN=0
 .... I HLSEGP>0 S HLSEGPN=$$PSEG^HLPA108A(HLSEGP)
 .... ; redirect pointer for SUB-field #771.05,.01 of field #771,5
 .... I HLSEGPN D
 ..... S DIE="^HL(771,"_HLIEN_",""SEG"","
 ..... S DA(1)=HLIEN
 ..... S DA=HLIEN2
 ..... S DR=".01////"_HLSEGPN
 ..... D ^DIE
 Q
 ;
PEVN(HLIEN) ; resolve event pointer
 ;
 ; HLEVN: original event type name
 ; HLEVN2: the event type name in the duplicate event array
 ; HLSUB: the 2nd subscript of the duplicate event array
 ; HLIEN: the IEN for the original event type 
 ; HLNIEN: the IEN for the first event type found in the file
 ; output: HLNIEN - return 0 if no duplicate,
 ;                  return the new pointer HLNIEN if duplicate
 ;
 N HLEVN,HLEVN2,HLSUB,HLDONE,HLNIEN
 Q:'$D(^HL(779.001,HLIEN,0)) 0
 S HLNIEN=0
 S HLEVN=$P(^HL(779.001,HLIEN,0),"^")
 I HLEVN'="" D
 . S HLEVN2=""
 . F  S HLEVN2=$O(HLEVNARY(HLEVN2)) Q:(HLEVN2="")  D  Q:(HLEVN2=HLEVN)
 .. I HLEVN2=HLEVN D
 ... S HLSUB=0,HLDONE=0,HLNIEN=0
 ... F  S HLSUB=$O(HLEVNARY(HLEVN,HLSUB)) Q:('HLSUB)  D  Q:HLDONE
 .... I HLEVNARY(HLEVN,HLSUB)=HLIEN S HLDONE=1 D
 ..... I HLSUB>1 S HLNIEN=HLEVNARY(HLEVN,1)
 Q HLNIEN
 ;
PMSG(HLIEN) ; resolve message pointer
 ;
 ; HLMSG: original message type name
 ; HLMSG2: the message type name in the duplicate message array
 ; HLSUB: the 2nd subscript of the duplicate message array
 ; HLIEN: the IEN for the original message type
 ; HLNIEN: the IEN for the first message type found in the file
 ; output: HLNIEN - return 0 if no duplicate,
 ;                  return the new pointer HLNIEN if duplicate
 ;
 N HLMSG,HLMSG2,HLSUB,HLDONE,HLNIEN
 Q:'$D(^HL(771.2,HLIEN,0)) 0
 S HLNIEN=0
 S HLMSG=$P(^HL(771.2,HLIEN,0),"^")
 I HLMSG'="" D
 . S HLMSG2=""
 . F  S HLMSG2=$O(HLMSGARY(HLMSG2)) Q:(HLMSG2="")  D  Q:(HLMSG2=HLMSG)
 .. I HLMSG2=HLMSG D
 ... S HLSUB=0,HLDONE=0,HLNIEN=0
 ... F  S HLSUB=$O(HLMSGARY(HLMSG,HLSUB)) Q:('HLSUB)  D  Q:HLDONE
 .... I HLMSGARY(HLMSG,HLSUB)=HLIEN S HLDONE=1 D
 ..... I HLSUB>1 S HLNIEN=HLMSGARY(HLMSG,1)
 Q HLNIEN
 ;
PSEG(HLIEN) ; resolve segment pointer
 ;
 ; HLSEG: original segment type name
 ; HLSEG2: the segment type name in the duplicate segment array
 ; HLSUB: the 2nd subscript of the duplicate segment array
 ; HLIEN: the IEN for the original segment type
 ; HLNIEN: the IEN for the first segment type found in the file
 ; output: HLNIEN - return 0 if no duplicate,
 ;                  return the new pointer HLNIEN if duplicate
 ;
 N HLSEG,HLSEG2,HLSUB,HLDONE,HLNIEN
 Q:'$D(^HL(771.3,HLIEN,0)) 0
 S HLNIEN=0
 S HLSEG=$P(^HL(771.3,HLIEN,0),"^")
 I HLSEG'="" D
 . S HLSEG2=""
 . F  S HLSEG2=$O(HLSEGARY(HLSEG2)) Q:(HLSEG2="")  D  Q:(HLSEG2=HLSEG)
 .. I HLSEG2=HLSEG D
 ... S HLSUB=0,HLDONE=0,HLNIEN=0
 ... F  S HLSUB=$O(HLSEGARY(HLSEG,HLSUB)) Q:('HLSUB)  D  Q:HLDONE
 .... I HLSEGARY(HLSEG,HLSUB)=HLIEN S HLDONE=1 D
 ..... I HLSUB>1 S HLNIEN=HLSEGARY(HLSEG,1)
 Q HLNIEN
 ;
