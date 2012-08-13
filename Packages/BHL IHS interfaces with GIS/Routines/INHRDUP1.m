INHRDUP1 ;DJL,DGH; 8 Mar 96 14:09;Duplicates interface messages to multiple dests
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;This functions as the transceiver routine for messages which are to
 ;be routed to multiple destinations.
 ;
GENMSH(INCMPMSH,INTT,INRECFAC,INMESSID) ; Generate MSH nodes using REVERSE precedence order
 ;INPUT:
 ;    INCMPMSH: Contains the Original Base Message MSH (used to build on)
 ;                      and IS the RETURNED composite MSH
 ;    INTT:       The TT pointer for Gallery data acquisition
 ;    INRECFAC:  The Default Receiving Facility (if set)
 ;    INMESSID:  The NEW unique message ID for the new message
 ;OUTPUT:
 ;    INCMPMSH: Contains the MSH to be used for Message Processing
 ; Precedence order of operation is as follows:
 ;   1: @-sign variablility and User-Definded M-code execute
 ;   2: INMSH value set by User-Definded M-code execute
 ;   3: Gallery direct value usage
 ;   4: Default Recieving Facility value, clear if = ""
 ;   5: Base Message values
 ;
 N INGALMSH,INTMP,INATVAL,INDELIM,INMSH
 ; Set INDELIM to the Base Message Delimiter
 S INDELIM=$E(INCMPMSH,4)
 S INTT=$O(^INRHR("B",INTT,0))
 ; Set the Message ID into the Composite MSH
 S $P(INCMPMSH,INDELIM,10)=INMESSID
 ; Priority-4:
 I $L($G(INRECFAC)) S:INRECFAC="""""" INRECFAC="" S $P(INCMPMSH,INDELIM,6)=INRECFAC
 ; Priority-3: If 2 node is present & 2.01=0 create Composite MSH adding Gallery info
 I $D(^INRHR(INTT,2)) S INGALMSH=$G(^INRHR(INTT,2)) I 'INGALMSH K INATVAL D GALMSH(.INATVAL,.INCMPMSH,INGALMSH,INMESSID)
 I $D(^INRHR(INTT,1)) D  ;  User-defined M-code to execute
 . K INMSH  X:$L($G(^INRHR(INTT,1))) ^INRHR(INTT,1)
 . ; Priority-2: Create new composite MSH using INMSH data and INCMPMSH
 . I $D(INMSH) D
 ..  K INTMP S INTMP=$P(INCMPMSH,INDELIM,1,2),CP=2
 ..  F I=3:1:17 S L=$$PIECE^INHU(.INMSH,INDELIM,I) S L=$S('$L(L):$$PIECE^INHU(.INCMPMSH,INDELIM,I),$L(L)&(L=""""""):"",1:L) D SETPIECE^INHU(.INTMP,INDELIM,I,L,.CP)
 ..  K INCMPMSH M INCMPMSH=INTMP
 ; If @ sign variables, Reformat using INA("xxx") values
 I $D(INATVAL) D
 . K INTMP S INTMP=$P(INCMPMSH,INDELIM,1,2),CP=2
 . F I=3:1:17 S L=$S('$D(INATVAL(I)):$$PIECE^INHU(.INCMPMSH,INDELIM,I),1:$G(@INA@(INATVAL(I)))) S:L="""""" L="" D SETPIECE^INHU(.INTMP,INDELIM,I,L,.CP)
 . K INCMPMSH M INCMPMSH=INTMP
 Q
 ;
GALMSH(INATVAL,INCMPMSH,INGALMSH,INMESSID) ;Create new COMPOSITE MSH using gallery-set data
 ;INPUT:
 ;   INCMPMSH: The composit MSH to merge into
 ;   INGALMSH: The Gallery set MSH data (INGALMSH is HL7 formatted)
 ;   INMESSID: The NEW unique message ID for the new message
 ;OUTPUT: 
 ;   INATVAL: Array containing MSH piece and varable name used with @ sign access
 N INMRGMSH,CP,L,L1,I
 S INMRGMSH=$P(INCMPMSH,INDELIM,1,2),CP=2
 F I=3:1:17 D
 . I I=7 S L1=$$DATEFMT^UTDT("NOW","YYYYMMDDHHIISS") D SET Q
 . I I=9 D TYPE,SET Q
 . I I=10 S L1=INMESSID D SET Q
 . S L=$$PIECE^INHU(.INGALMSH,U,I),L1=$S(L="""""":"",L["NULL":"",L'="":L,1:$$PIECE^INHU(.INCMPMSH,INDELIM,I))
 . D SET
 K INCMPMSH M INCMPMSH=INMRGMSH
 Q
 ;
SET ;Set pieces into INMRGMSH
 I $E(L1)="@",$L($E(L1,2)) S INATVAL(I)=$P(L1,"@",2) Q  ; Set index to piece and variable to use for lookup
 D SETPIECE^INHU(.INMRGMSH,INDELIM,I,L1,.CP) Q
 ;
TYPE ;create <message type><subdelim><event type> field
 S L=$P(INGALMSH,U,I),INEVTYP=$P(INGALMSH,U,2)
 I $E(L)="@" S L1=L Q
 I '$L(INEVTYP)!(INEVTYP?.P) S L1=$S(L="""""":"",L'="":L,1:$P(INCMPMSH,INDELIM,I)) Q
 S L1=L_$E($P(INCMPMSH,INDELIM,2),1)_INEVTYP Q
 Q
INTLOOP ;Transaction Type loop
 ;* Suppressed messages will be logged in the ActivityLog Multiple 
 ;  (and Error log w/DEBUG)
 ;* INMULT array Processing LOOP at Rep TT level
 S INERROR=1,INGETOUT=0,INTT="",INIEN=""
 F  S INTT=$O(INMULT(INTT)) Q:'INTT!INGETOUT  D INTT(INTT,.INGETOUT)
 Q
 ;
INTT(INTT,INGETOUT) ;Process Transaction Type
 ;Input:
 ; INTT - Transaction Type
 ;Output:
 ; INGETOUT(r) - GET OUT OF LOOP
 ;
 N INPDEST,INSRMC,INSRPRIO
 I '$D(^INRHT(INTT)) S INERR(INERROR)="Replication attempted to unknown transaction type:"_INTT,INERROR=INERROR+1,INSTAT=1 Q
 ;* If SRMC exists for the Primary Dest (Priority-2),
 ;set SRMC variable=SRMC
 S INPDEST=$O(INMULT("PD",INTT,"")),INSRMC=$G(INMULT("PD",INTT,INPDEST))
 S:$L(INSRMC) INSRPRIO=2
 ;If SRMC exists for the Rep TT (Priority-1), set SRMC variable=SRMC
 I $L($G(INMULT("TT",INTT))) S INSRPRIO=1,INSRMC=INMULT("TT",INTT)
 ;if INSRMC variable has SRMC (PRIORITY 1 or 2) then execute SRMC.
 ;if priority=1 or 2 AND INSRDATA=1 Quit and log SUPPRESSION for this TT 
 I $L(INSRMC) N INSRDATA S INSRCTL("INTT")=INTT,INSRCTL("INDEST")=INPDEST X INSRMC
 I $G(INSRDATA) D  Q
 .S:INSRPRIO=3 INGETOUT=1,INSRCTL("INDEST")=""
 .S INDEST=INPDEST
 .D LOG^INHUT6(+INPRIO(INSRPRIO),@$P(INPRIO(INSRPRIO),U,2),$P(INPRIO(INSRPRIO),U,3),INUIF)
 ; INMULT array Processing LOOP at Destination level
 S INDEST=0
 F  S INDEST=$O(INMULT(INTT,INDEST)) Q:'INDEST  D
 .D DEST(INDEST,.INV)
 .; cleanup the UIF Messages temp storage
 .K @INV
 .S INV=$S(INVS<2:"INV",1:"^UTILITY(""INV"",$J)")
 .D:INVS<2 MC1^INHS
 .S %=0
 .F  S %=$O(@INVTMP@(%)) Q:%=""  D:INVS<2 MC^INHS M @INV@(%)=@INVTMP@(%)
 Q
DEST(INDEST,INV) ;Process destinations
 ;Input:
 ; INDEST - Destination 
 ; INV - Message segment array from UIF
 S INSRCTL("INDEST")=INDEST
 ;* If INSRDATA exists as a list then Quit
 ;if NOT $$FINDRID^INHUT5( .INSRDATA, Dest )
 ;     can't find a match of RouteID in Destination
 I $D(INSRDATA)>9,$$FINDRID^INHUT5(.INSRDATA,INDEST) D  Q
 .; can't find a matching RouteID in Destination
 .D LOG^INHUT6(+INPRIO(INSRPRIO),@($P(INPRIO(INSRPRIO),U,2)),$P(INPRIO(INSRPRIO),U,3),INUIF)
 ;Create temporary @INV@(%INV) data storage for message content/building
 K %INV S %INV=$S(INVS<2:"%INV",1:"^UTILITY(""%INV"",$J)")
 K:%INV'="%INV" @%INV
 ;
 ; * Set INCMPMSH with 
 ; GENMSH^INHRDUP1( .INCMPMSH, repINTT IEN, Def Recv Fac, MessageID ) 
 ; user reverse precedence order through all operation to allow an 
 ; accumulation of MSH/Message construction
 K INCMPMSH S INCMPMSH=INMSH0,INMESSID=$$MESSID^INHD
 D GENMSH^INHRDUP1(.INCMPMSH,INTT,INMULT(INTT,INDEST),INMESSID)
 ; create the NEW mesage w/newMSH in %INV
 D NEWMSG^INHRDUP(.INCMPMSH,.%INV,.INV)
 ; get user and division information and pass it to new msg entry
 N INORDUZ,INORDIV,INMIDGEN
 S INORDUZ=$P($G(^INTHU(INUIF,0)),U,15),INORDIV=$P($G(^(0)),U,21),INMIDGEN=$P($G(^(0)),U,5)
 ;Create new message in ^INTHU and deliver to its outbound queue
 S INNEWUIF=$$NEWO^INHD(INDEST,.%INV,+$P(^INRHT(INTT,0),U,12),INTT,INMESSID,"",INORDUZ,INORDIV,.INUIF6,.INUIF7,INMIDGEN)
 I INNEWUIF<0 S INERR(INERROR)="UIF creation failed for transaction type "_$P(INTYPE(0),U),INERROR=INERROR+1,INSTAT=1
 D LOG^INHRDUP
 ; cleanup the Replication Messages temp storage
 K @%INV
 Q
 ;
