INHUSEQ ;DGH; 6 Dec 94 12:41;SEQuence number protocol functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
SEQOUT(INUIF,INERR) ;Process outbound messages under seq # protocol.
 ;INPUT:
 ; INUIF = (req) entry in INTHU
 ; INERR = (opt) error message array (Pass by reference)
 ;OUTPUT:
 ; 0=success 1=error 2=fatal error
 N SEQ,X,DEST
 S DEST=$P($G(^INTHU(INUIF,0)),U,2)
 I 'DEST S ERR="No destination specified in UIF for message "_MESSID Q 2
 I '$D(^INRHD(DEST)) S ERR="Destination does not exist for message "_MESSID Q 2
 ;Determine if seq. # protocol is in effect--If .09 field is not 1,
 ;no need to assign seq. no.
 Q:'$P(^INRHD(DEST,0),U,9) 0
 F I=1:1:5 L +^INRHD(DEST,3):3 Q:$T
 I '$T S ERR="Lock failed on LAST SEQUENCE NUMBER field for destination "_$P(^INRHD(DEST,0),U)_" for "_MESSID Q 1
 S SEQ=$P($G(^INRHD(DEST,3)),U)+1
 ;Stuff sequence number in MSH of uif entry
 S X=$$FORMAT(INUIF,SEQ,.INERR)
 I 'X S $P(^INRHD(DEST,3),U)=SEQ
 L -^INRHD(DEST,3)
 Q X
 ;
 ;
FORMAT(UIF,SEQ,INERR) ;Entry point to add a SEQuence number to the MSH
 ;and to the SEQUENCE NUMBER field of an entry in INTHU(UIF
 ;INPUT:
 ;--UIF=ien in Universal Interface File
 ;--SEQ=seqence number to be inserted in the MSH segment of the message
 ;--INERR (opt)=array in which to place any error messages
 ;OUTPUT: 0=sucessful update, 2=unsuccessful update (fatal)
 ;LOCAL:
 ;--MSH0 = Base message MSH segment. May be an array
 ;--MSH = New MSH w SEQ inserted. Array may be one node larger than MSH0
 ;
 N C,CP,I,INDELIM,INSMIN,INV,INVS,L,LCT,MSH,MSH0,CNT,DIF,CPSEQ
 ;---Store original MSH in MSH0
 S LCT=0 D GETLINE^INHOU(UIF,.LCT,.MSH0)
 I $E(MSH0,1,3)'="MSH" S INERR="Error in FORMAT^INHUSEQ. No MSH segment in message "_UIF Q 2
 S INDELIM=$E(MSH0,4)
 ;Create string of first 12 pieces, insert sequence # in 13, then
 ;string out remaining pieces.
 S CPSEQ=13,CP=CPSEQ-1,MSH=$P(MSH0,INDELIM,1,CP)
 S CNT=$L(MSH0,INDELIM)
 I $D(MSH0)>9 F I=1:1 Q:'$D(MSH0(I))  S CNT=CNT+$L(MSH0(I),INDELIM)
 S I=CPSEQ,L=SEQ D SETPIECE^INHU(.MSH,INDELIM,I,L,.CP)
 F I=CPSEQ+1:1:CNT S L=$$PIECE^INHU(.MSH0,INDELIM,I) D SETPIECE^INHU(.MSH,INDELIM,I,L,.CP)
 ;If the number of overflow nodes DIFfers from old MSH0 and new MSH...
 S DIF=$O(MSH(""),-1)-$O(MSH0(""),-1) I 'DIF D MSH,XREF Q 0
 ;
 ;Unless the addition of SEQ has created an overflow node, the following
 ;will not occur.
 ;Store message body in array and reformat entire entry in UIF
 K ^UTILITY("INV",$J)
 S INVS=$P(^INRHSITE(1,0),U,12),INV=$S(INVS<2:"INV",1:"^UTILITY(""INV"",$J)")
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 ;Place new MSH at top of new array
 S C=1,@INV@(C)=MSH
 I $D(MSH)>9 F  Q:'$D(MSH(C))  S C=C+1,@INV@(C)=MSH(C-1)
 S @INV@(C)=@INV@(C)_"|CR|"
 ;If overflow node(s) created, lines in ^INTHU will "move" DIF
 F  S LCT=$O(^INTHU(UIF,3,LCT)) Q:'LCT  D
 .S @INV@(LCT+DIF)=^INTHU(UIF,3,LCT,0)
 .D:'INVS MC^INHS
 K ^INTHU(UIF,3)
 ;Store data from global INV
 S C=0 F  S C=$O(@INV@(C)) Q:'C  S ^INTHU(UIF,3,C,0)=@INV@(C),L=C
 S ^INTHU(UIF,3,0)="^^"_L_"^"_L
 D XREF
 Q 0
 ;
MSH ;Store replacement MSH with overflow nodes if needed
 I $D(MSH)<10 S ^INTHU(UIF,3,1,0)=MSH_"|CR|" Q
 S ^INTHU(UIF,3,1,0)=MSH
 F I=1:1 Q:'$D(MSH(I))  S C=I+1,^INTHU(UIF,3,C,0)=MSH(I)
 S ^INTHU(UIF,3,C,0)=^(0)_"|CR|"
 Q
 ;
XREF ;Store SEQ in .17 field and set x-ref.
 S $P(^INTHU(UIF,0),U,17)=SEQ,^INTHU("ASEQ",DEST,SEQ,UIF)=""
 Q
 ;
SEQIN(INDSTR,INSEQ,STAT,TXT,EXPCT) ;Process incoming sequenced messages.
 ;This will verify sequence number and set variables
 ;needed for accept ack. It does not send the ack.
 ;VARIABLES
 ; INDSTR = Entry in Interface Destination File
 ; INSEQ = Sequence number (piece 13 of MSH) (pass by reference)
 ;  This may be reset to 0 within this tag. SEQ is later stored
 ;  in LAST SEQUENCE NUMBER field of the Int. Dest. File.
 ; STAT = Status to include in ack (PBR)
 ; TXT = Message text to include in ack (PBR)
 ; EXPCT = Expected sequence number for ack (PBR)
 ;OUTPUT:
 ; 0=success   1=non-fatal error
 ;INSEQ=0 indicates start or restart
 I INSEQ=0 D  Q 0
 .I '$G(^INRHD(INDSTR,3)) S STAT="CA",TXT="Starting link",EXPCT=-1 Q
 .S STAT="CA",TXT="Re-starting link",EXPCT=1+^INRHD(INDSTR,3)
 ;INSEQ=-1 indicates re-synch. Receiver will need to reset LAST SENT to 0
 I INSEQ=-1 S INEQ=0,STAT="CA",TXT="Synchronizing link",EXPCT=-1 Q 0
 ;Else sequence is greater than 0
 I '$D(^INRHD(INDSTR,3)) S STAT="CA",TXT="Link is not initialized",EXPCT="" Q 1
 S EXPCT=1+^INRHD(INDSTR,3)
 I INSEQ=EXPCT S STAT="CA",TXT="" Q 0
 ;else sequence number is incorrect
 S STAT="CR",TXT="Out of sequence" Q 1
 ;
ACKINSEQ(MSASTAT,INDSTR,EXPCT,INSEND,INERR) ;Process incoming app ack
 ;under seq # protocol
 ;INPUT
 ;--MSASTAT = CA,CE,CR
 ;--INDSTR = ien of entry in Int. Dest. File.
 ;--EXPCT = Expected sequence number from MSA segment from other system.
 ;--INSEND = Variable to contain ien(s) of previously-sent messages
 ;           which must be resent to match EXPCT. (PBR)
 ;           Format of array is INSEND(SEQ)=UIF
 ;--INERR = variable to contain error array (PBR)
 ;RETURN
 ;0 = ok   3 = out of synch
 N SEQ,LAST
 I MSASTAT["CA" Q 0
 I EXPCT=1+^INRHD(INDSTR,3) Q 0
 I EXPCT>1+^INRHD(INDSTR,3) S INVL=1,INERR="Expected sequence number is higher than current" Q 3
 ;else EXPCT<1, so EXPCT is a previously sent message. Find ien of that
 ;entry so it can be resent, and reque all subsequent entries.
 I '$D(^INTHU("ASEQ",INDSTR,EXPCT)) S INERR="Can not locate expected message "_EXPCT Q 3
 S INSEND=$O(^INTHU("ASEQ",INDSTR,EXPCT,"")) I 'INSEND S INERR="Can not locate expected message "_EXPCT Q 3
 S SEQ=EXPCT,LAST=+^INRHD(INSTR,3)
 ;create array of all values between last sent and expected.
 ;Note: current HL7 spec indicates there will not be more than one
 ;entry in this array (ie resend only the last message).
 F I=1:1 S SEQ=$O(^INTHU("ASEQ",INDSTR,SEQ)) Q:SEQ'<LAST!'SEQ  S INSEND(SEQ)=$O(^INTHU("ASEQ",INDSTR,EXPCT,""))
 Q 0
 ;
