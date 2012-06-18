KMPRBD03 ;SFISC/RAK - Resource Usage Monitor Data Compression ;10 Oct 98
 ;;1.0;CAPACITY MANAGEMENT - RUM;;Dec 09, 1998
 ;
 ; Background Driver (cont.)
 ;
FILE(KMPRDATE,KMPRNODE,KMPROPT,KMPRPT,KMPRNP,KMPRPTHR,KMPRNPHR,KMPROK,KMPRMSG) ;
 ;-----------------------------------------------------------------------
 ; KMPRDATE.... Date in $H Format
 ; KMPRNODE.... Node Name
 ; KMPROPT..... Option (in 2 pieces with "***" as delimiter)
 ;                piece 1 - option name
 ;                piece 2 - protocol (optional)
 ; KMPRPT...... Prime Time Data (8 elements)
 ; KMPRNP...... Non Prime Data (8 elements)
 ; KMPRPTHR.... Number of Prime Time Hours
 ; KMPRNPHR.... Number of Non Prime Hours
 ; KMPROK...... Returns: 0 - update not successful
 ;                       1 - update successful
 ; KMPRMSG..... If KMPROK = 0 then message text will be returned in this
 ;              array (passed by reference).
 ;
 ; File data in file #8971.1 (RESOUCE USAGE MONITOR).
 ;-----------------------------------------------------------------------
 ;
 S KMPROK=0
 Q:'$G(KMPRDATE)
 Q:$G(KMPRNODE)=""
 Q:$G(KMPROPT)=""
 S KMPRPT=$G(KMPRPT),KMPRNP=$G(KMPRNP)
 S KMPRPTHR=+$G(KMPRPTHR),KMPRNPHR=+$G(KMPRNPHR)
 S KMPROK=1
 K KMPRMSG
 ;
 N FDA,I,J,MESSAGE,OPT,ZIEN
 ;
 ; date.
 S FDA($J,8971.1,"+1,",.01)=$$HTFM^XLFDT(KMPRDATE)
 ; sent to cm national database.
 S FDA($J,8971.1,"+1,",.02)=0
 ; node.
 S FDA($J,8971.1,"+1,",.03)=KMPRNODE
 ; option.
 S OPT=$P(KMPROPT,"***")
 ; rum designation.
 S FDA($J,8971.1,"+1,",.08)=$$RUMDESIG(OPT)
 ; if the first character of OPT is '`' then this is an RPC.
 I $E(OPT)="`" S FDA($J,8971.1,"+1,",.07)=$E(OPT,2,999)
 ; if the first character of OPT is '&' then this is an HL7.
 E  I $E(OPT)="&" S FDA($J,8971.1,"+1,",.09)=$E(OPT,2,999)
 ; option.
 E  S FDA($J,8971.1,"+1,",.04)=$$OPTION(OPT)
 ; protocol.
 S:$P(KMPROPT,"***",2)'="" FDA($J,8971.1,"+1,",.05)=$P(KMPROPT,"***",2)
 ;
 ; populate prime time and non-prime time fields.
 F I=1:1:8 S J=I*.01 D
 .; prime time - node 1.
 .I $P(KMPRPT,U,I)'=""&(KMPRPTHR) D 
 ..S FDA($J,8971.1,"+1,",1+J)=$FN($P(KMPRPT,U,I),"",2)
 .; non-prime time - node 2
 .I $P(KMPRNP,U,I)'=""&(KMPRNPHR) D 
 ..S FDA($J,8971.1,"+1,",2+J)=$FN($P(KMPRNP,U,I),"",2)
 ;
 ; update file 8971.1.
 D UPDATE^DIE("","FDA($J)","ZIEN","MESSAGE")
 ; if error message.
 I $D(MESSAGE) S KMPROK=0 D MSG^DIALOG("A",.KMPRMSG,60,10,"MESSAGE")
 ;
 Q
 ;
RUMDESIG(KMPROPT) ;-- extrinsic function - determine rum designation.
 ;-----------------------------------------------------------------------
 ; KMPROPT... Option name.
 ;
 ; Return: RUM Designation (see field #.08 RUM DESIGNATION in file
 ;         #8971.1).
 ;-----------------------------------------------------------------------
 ;
 ; 5 = other.
 Q:$G(KMPROPT)="" 5
 ; 1 = taskman
 Q:KMPROPT="$AFTR ZTMS$"!(KMPROPT="$STRT ZTMS$")!($E(KMPROPT)="!") 1
 ; 3 = broker.
 Q:$E(KMPROPT)="`" 3
 ; 4 = hl7
 Q:$E(KMPROPT)="&" 4
 ; 2 - user.
 Q 2
 ;
OPTION(KMPROPT) ;-- extrinsic function - option name.
 ;-----------------------------------------------------------------------
 ; KMPROPT... Option name (as it appears from ^XTMP("KMPR","HR").
 ;
 ; Return: Option name with extraneous characters removed.
 ;-----------------------------------------------------------------------
 ;
 Q:$G(KMPROPT)="" ""
 Q:$E(KMPROPT)="!" $E(KMPROPT,2,999)
 ; rpc.
 Q:$E(KMPROPT)="`" ""
 ; hl7.
 Q:$E(KMPROPT)="&" ""
 Q KMPROPT
