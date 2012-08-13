INHRDUP(INUIF,INERR) ;DJL,DGH; 7 May 98 12:41;Duplicates interface messages to multiple dests
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;This functions as the transceiver routine for messages which are to
 ;be routed to multiple destinations.
 ;INPUT:
 ;--INUIF = ien in Universal Interface File
 ;--INERR = array to contain any error messages
 ;USER INTERACTION IN USER-DEFINED CODE:
 ;--INUIF = ien of duplicated message. User can manipuate this message.
 ;--INMSH = variable into which user must store MSH if user-manipulated.
 ;LOCAL:
 ;--INMSH0 = Base message MSH segment. May be an array
 ;--INMSH = MSH for replicated message. May be from MSH0 or from node 2.
 ;--INMSHNEW = "Composite" MSH with non-null fields from MSH0 and MSH.
 ;--INSTAT = The return status. See OUTPUT below.
 ;OUTPUT:
 ;--INERR  = array to contain any error messages
 ;--RETURN = 0: Complete with NO errors, mark Base UIF enry complete.
 ;--RETURN = 1: Complete WITH errors, Don't mark Base UIF entry complete.
 ;
EN1 N INTT,INOTT,INMSH0,INMSH,INMSHNEW,INVS,INV,INSMIN,INL1,INCP,INDELIM,INDEST,INIEN,LCT,INMSH,INEVTYP,INNEWUIF,INUIFD,I,L,INMESSID,INMULT,INSTAT,INERROR,INHER,LOG,INSUBCOM,INSUBDEL,DSC,%
 N INSRDATA,INSRMC,INSRCTL,INSDEST,%INV,INCMPMSH,INPROC,INA,INDA,INATVAL,INSRPRIO,INPRIO,INGETOUT,INUIF6,INUIF7
 ;
 ;
 K ^UTILITY("INV",$J)
 ;If status="C", don't allow requeue
 I $P(^INTHU(INUIF,0),U,3)="C" Q 0
 ;Look up originating transaction type from UIF.
 S INOTT=$P($G(^INTHU(INUIF,0)),U,11) I 'INOTT S INERR(1)="No originating transaction type" Q 1
 I '$D(^INRHR("AC",INOTT)) S INERR(1)="No replicants defined" Q 1
 ; Set the INPROC, INDA, and INA variables
 S INSRCTL("INSRPROC")="REP",INSRCTL("INTT")=INOTT,INDA="^INTHU("_INUIF_",6)",INA="^INTHU("_INUIF_",7)"
 M INUIF6=@INDA,INUIF7=@INA  ; selective routing - pass info to replicant msgs
 ; setup the table holding File # and Nodes holding SRMC information
 S INPRIO(3)="4000^INOTT^5",INPRIO(2)="4005^INDEST^12",INPRIO(1)="4000^INTT^5"
 ;Start transaction audit of "base" message
 D:$D(XUAUDIT) TTSTRT^XUSAUD(INUIF,"",$P($G(^INTHPC(INBPN,0)),U),$G(INHSRVR),"REPLICATE")
 ;* If SRMC exists for the Base TT (Priority-3), execute it
 K INSRDATA I $L($G(^INRHT(INOTT,5))) S INSRPRIO=3 X ^INRHT(INOTT,5)
 ;---Store "base" MSH in INMSH0 to be used for non-reformatted MSHs.
 S LCT=0 D GETLINE^INHOU(INUIF,.LCT,.INMSH0)
 I INMSH0'["MSH" S INMSH0="",LCT=0
 I $L(INMSH0) S INDELIM=$E(INMSH0,4),INSUBDEL=$E(INMSH0,5),INSUBCOM=$E(INMSH0,8)
 I '$L(INMSH0) S INDELIM=$$FIELD^INHUT(),INSUBDEL=$$COMP^INHUT(),INSUBCOM=$$SUBCOMP^INHUT()
 ;**  Create @INV@ data storage for BASE message content/building
 S INVS=$P(^INRHSITE(1,0),U,12),INV=$S(INVS<2:"INV",1:"^UTILITY(""INV"",$J)"),INSTAT=0
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 ;Store message body in array starting with LCT=2 (MSH will be in 1)
 ;* This is the BASE message that all replicants will be derived from.
 S I=LCT,LCT=2,DSC=0 F  S I=$O(^INTHU(INUIF,3,I)) Q:'I  D
 .S %=^INTHU(INUIF,3,I,0)
 .D:INVS<2 MC^INHS
 .I 'DSC S @INV@(LCT)=%
 .I DSC S @INV@(LCT,DSC)=%
 .;if global line contains end of segment, increment line count
 .I $E(%,$L(%)-6,$L(%))["|CR|" S LCT=LCT+1,DSC=0 Q
 .;Else global line is continued to next line, increment DeSCendent count
 .S DSC=DSC+1
 ;---build INMULT array with all ACTIVE TTs, DESTs for the originating TT
 S INIEN="" F  S INIEN=$O(^INRHR("AC",INOTT,INIEN)) Q:INIEN=""  D
 .; process the Replication TTs' Primary Destination AND Default Rec'v Fac into INMULT
 . S INTT=+^INRHR(INIEN,0) Q:'+$P(^INRHT(INTT,0),U,5)  ; Not ACTIVE
 . S INMULT("TT",INTT)=$G(^INRHT(INTT,5)) ; set 'TT' cross-ref with SRMC
 . S INPDEST=+$P(^INRHT(INTT,0),U,2) I 'INPDEST S INSTAT=1 Q
 .; process the Primary Dest and Default Rec'v Fac into INMULT
 . S INMULT(INTT,INPDEST)=$P($G(^INRHD(INPDEST,7)),U) ; Def Rec'v Fac
 . S INMULT("PD",INTT,INPDEST)=$G(^INRHD(INPDEST,12)) ; set 'PD' cross-ref with SRMC
 .; process the Secondary Destinations AND Default Rec'v Fac into INMULT
 . S INSDEST=0 F  S INSDEST=$O(^INRHD("APD",INPDEST,INSDEST)) Q:'INSDEST  S INMULT(INTT,INSDEST)=$P($G(^INRHD(INSDEST,7)),U)
 ;--if base message is requeued, don't replicate messages/destinations
 ;--that successfully processed previously--.02="R", .03=uif msg pointer
 I $D(^INTHU(INUIF,1)) D
 .S LOG=0 F  S LOG=$O(^INTHU(INUIF,1,LOG)) Q:'LOG  D
 ..Q:'$D(^INTHU(INUIF,1,LOG,0))  Q:$P(^INTHU(INUIF,1,LOG,0),U,2)'="R"
 ..S INUIFD=+$P(^INTHU(INUIF,1,LOG,0),U,3) Q:'INUIFD  S INTT=$P(^INTHU(INUIFD,0),U,11)
 ..I INTT K INMULT(INTT,+$P(^INTHU(INUIFD,0),U,2))
 ;* Suppressed messages will be logged in the ActivityLog Multiple (and Error log w/DEBUG)
 ;* INMULT array Processing LOOP at Rep TT level
 S INERROR=1,INGETOUT=0,INTT="",INIEN="" F  S INTT=$O(INMULT(INTT)) Q:'INTT!INGETOUT  D
 . I '$D(^INRHT(INTT)) S INERR(INERROR)="Replication attempted to unknown transaction type:"_INTT,INERROR=INERROR+1,INSTAT=1 Q
 . ;* If SRMC exists for the Primary Dest (Priority-2), set SRMC variable=SRMC
 . S INPDEST=$O(INMULT("PD",INTT,"")),INSRMC=$G(INMULT("PD",INTT,INPDEST))
 . S:$L(INSRMC) INSRPRIO=2
 . ;* If SRMC exists for the Rep TT (Priority-1), set SRMC variable=SRMC
 . I $L($G(INMULT("TT",INTT))) S INSRPRIO=1,INSRMC=INMULT("TT",INTT)
 . ;* if INSRMC variable has SRMC (PRIORITY 1 or 2) then NEW INSRDATA, execute SRMC.
 . ; if priority=1 or 2 AND INSRDATA=1 Quit and log SUPPRESSION for this TT 
 . I $L(INSRMC) N INSRDATA S INSRCTL("INTT")=INTT,INSRCTL("INDEST")=INPDEST X INSRMC
 . I $G(INSRDATA) S:INSRPRIO=3 INGETOUT=1,INSRCTL("INDEST")="" S INDEST=INPDEST D LOG^INHUT6(+INPRIO(INSRPRIO),@$P(INPRIO(INSRPRIO),U,2),$P(INPRIO(INSRPRIO),U,3),INUIF) Q
 . ;* INMULT array Processing LOOP at Destination level
 . S INDEST=0 F  S INDEST=$O(INMULT(INTT,INDEST)) Q:'INDEST  D
 ..  S INSRCTL("INDEST")=INDEST
 ..  ;* If INSRDATA exists as a list then Quit if NOT $$FINDRID^INHUT5( .INSRDATA, Dest )
 ..  ;     can't find a match of RouteID in Destination
 ..  I $D(INSRDATA)>9,$$FINDRID^INHUT5(.INSRDATA,INDEST) D LOG^INHUT6(+INPRIO(INSRPRIO),@($P(INPRIO(INSRPRIO),U,2)),$P(INPRIO(INSRPRIO),U,3),INUIF) Q  ; can't find a matching RouteID in Destination
 ..  ;**  Create temporary @INV@(%INV) data storage for message content/building
 ..  K %INV S %INV=$S(INVS<2:"%INV",1:"^UTILITY(""%INV"",$J)") K:%INV'="%INV" @%INV
 ..  ;* Set INCMPMSH with GENMSH^INHRDUP1( .INCMPMSH, repINTT IEN, Def Recv Fac, MessageID )  // user reverse precedence
 ..  ;   order through all operation to allow an accumulation of MSH/Message construction
 ..  K INCMPMSH S INCMPMSH=INMSH0,INMESSID=$$MESSID^INHD D GENMSH^INHRDUP1(.INCMPMSH,INTT,INMULT(INTT,INDEST),INMESSID)
 ..  D NEWMSG(.INCMPMSH,.%INV,.INV) ; create the NEW mesage w/newMSH in %INV
 ..  ; get user and division information and pass it to new msg entry
 ..  N INORDUZ,INORDIV S INORDUZ=$P($G(^INTHU(INUIF,0)),U,15),INORDIV=$P($G(^(0)),U,21)
 ..  ;Create new message in ^INTHU and deliver to its outbound queue
 ..  S INNEWUIF=$$NEWO^INHD(INDEST,.%INV,+$P(^INRHT(INTT,0),U,12),INTT,INMESSID,"",INORDUZ,INORDIV,.INUIF6,.INUIF7)
 ..  I INNEWUIF<0 S INERR(INERROR)="UIF creation failed for transaction type "_$P(INTYPE(0),U),INERROR=INERROR+1,INSTAT=1
 ..  D LOG
 ..  K @%INV ; cleanup the Replication Messages temp storage
 G EXIT ; Cleanup Utility global (one last time) and exit
 Q
 ;
NEWMSG(INNEWMSH,%INV,INV) ; merge the message Body in INV into %INV with New MSH
 N %
 ; * Copy Base Message Body ( from @INV@ to @%INV@ )
 S @%INV@(1)=INNEWMSH I $D(INNEWMSH)>9 S @%INV@(1,1)=INNEWMSH(1)
 ;* Copy Base Message Body ( from @INV@ ) to @%INV@. After MSH.
 S %=1 F  S %=$O(@INV@(%)) Q:%=""  M @%INV@(%)=@INV@(%) D:INVS<2 MC
 Q
 ;
MC ;Check if time to move variables to a global
 Q:%INV["^"
 I $S<INSMIN M ^UTILITY("%INV",$J)=%INV K %INV S %INV="^UTILITY(""%INV"",$J)"
 Q
 ;
LOG ;In activity log multiple of "base" message, log successful messages
 ;Note: INHER is undefined on purpose, we don't want to file array
 K INHER D ULOG^INHU(INUIF,"R",.INHER,INNEWUIF)
 Q
 ;
EXIT K @INV ; cleanup the Base Messages temp storage
 ;Stop transaction audit
 D:$D(XUAUDIT) TTSTP^XUSAUD(0)
 Q INSTAT
 ;
