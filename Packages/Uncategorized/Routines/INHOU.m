INHOU ;JSH,DP; 09 Nov 1999 11:21 ;Output Driver utilities 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 13; 12-NOV-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
GETLINE(%U,%L,%D,%I,%C) ;Function which returns the next line from a UIF entry
 ;%U = UIF entry #
 ;%L = last line obtained (pass by reference)
 ;%D = variable in which to place the lines of data
 ;%I = increment counter (0:default = YES, 1 = NO)
 ;%C = increment value of %L (pass by reference)
 ;
 K %D
 Q:'$G(%U)!($G(%L)="")
 Q:'$D(^INTHU(%U))
 N L,I S L=%L
 S L=L+1 G:'$D(^INTHU(%U,3,L,0)) GQ
 S %D=^(0) I $E(%D,$L(%D)-3,$L(%D))="|CR|" S %D=$E(%D,1,$L(%D)-4) G GQ
 F I=1:1 Q:'$D(^INTHU(%U,3,L+I,0))  S %D(I)=^(0) I $E(%D(I),$L(%D(I))-3,$L(%D(I)))="|CR|" S %D(I)=$E(%D(I),1,$L(%D(I))-4) K:%D(I)="" %D(I) Q
 S L=L+I
GQ S %C=L-%L S:'$G(%I) %L=L Q
 ;
GET(%U,%I) ;Get a line from message - internal call
 ;%U = UIF entry #
 ;%I = increment counter (0:default = YES, 1 = NO)
 ;On entry: LCT = current line position
 ;On exit:  CNT = # of lines incremented
 ;          LINE= array containing the line (killed if no more)
 ;
 K LINE Q:'$G(%U)  Q:'$D(^INTHU(%U))
 N L,I S L=LCT
 S L=L+1 G:'$D(^INTHU(%U,3,L,0)) GQ2
 S LINE=^(0) I $E(LINE,$L(LINE)-3,$L(LINE))="|CR|" S LINE=$E(LINE,1,$L(LINE)-4) G GQ2
 F I=1:1 Q:'$D(^INTHU(%U,3,L+I,0))  S LINE(I)=^(0) I $E(LINE(I),$L(LINE(I))-3,$L(LINE(I)))="|CR|" S LINE(I)=$E(LINE(I),1,$L(LINE(I))-4) K:LINE(I)="" LINE(I) Q
 S L=L+I
GQ2 S CNT=L-LCT S:'$G(%I) LCT=L Q
 ;
GL(%U,%L) ;Function which returns first 250 characters of the next line from a UIF entry
 ;%U = UIF entry #
 ;%L = last line obtained
 Q:'$G(%U)!($G(%L)="") ""
 Q:'$D(^INTHU(%U)) ""
 N L S L=$G(^INTHU(%U,3,%L+1,0))
 S:$E(L,$L(L)-3,$L(L))="|CR|" L=$E(L,1,$L(L)-4)
 Q L
 ;
NOL(UIF) ;Function to return the number of lines for Entry #UIF
 N %,I,X Q:'$O(^INTHU(UIF,3,0)) 0
 S %=0 F I=1:1 Q:'$D(^INTHU(UIF,3,I,0))  S X=^(0) S:$E(X,$L(X)-3,$L(X))="|CR|" %=%+1
 Q %
 ;
QTSK ;Display currently queued entries
 D QTSK^INHOU3
 Q
 ;
REQ ;Reque an Entry for processing
 ;Description:  Requeue Interfacee Transactions
 ; Return= none
 ; Parameters = none
 ;Code Begins
 D REQ^INHOU1
 Q
REQ1 ;Reque an Entry for processing
 ;Description: REQ ( Requeue Interfacee Transactions )
 ; Return = none
 ; Parameters = none
 ; Code Begins
 D REQ1^INHOU1
 Q
 ;
VERIFY() ;Function returns a 1 if OUTPUT CONTROLLER is running, 0 otherwise
 N X S X=$$VER^INHB(1) Q $S(X=1:1,1:0)
 ;
EDIT ;Edit a message in an ERROR state
 N DIC,INY,DES,DWFILE,PRIO,DDSPARM,DDSAVE
 S DIC=4001,DIC(0)="QAEMZ",DIC("A")="Select Transaction to Edit: "
 D ^DIC Q:Y<0  S (Y,INY)=+Y
 S DES=$P(Y(0),U,2)
 I $G(^INRHD(+DES,"ED"))]"" S DWFILE="" X ^("ED") G EDIT1
 S DDSPARM="SC"
 S DIE=4001,DA=INY D EDIT^INHT("INH MESSAGE EDIT")
EDIT1 Q:'$D(DWFILE)&'$G(DDSSAVE)  ;IHS check
 ; Set USER WHO EDITED field, get priority
 S $P(^INTHU(INY,2),U,3)=DUZ,PRIO=+$P(^(0),U,16)
 S X=$$YN^UTSRD("Requeue for Output? ;1",""),Y=INY G:X REQ1
 Q
 ;
MC ;Mark as complete (need INH MESSAGE EDIT key to do this)
 D MC^INHOU4
 Q
 ;
NEXT(%D) ;Function to return next UIF entry queued
 ;%D = entry # of destination [required]
 Q:'$G(%D)  N P
 S P=$O(^INLHSCH("DEST",%D,"")) Q:P="" ""
 Q $O(^INLHSCH("DEST",%D,P,""))
 ;
UPDATE(%U,%S,%M)        ;Update status of a transaction
 ;%U = UIF entry # (file #4001) [required]
 ;%S = Status indicator: [required]
 ; 0 = successful (complete - schedule node killed)
 ; 1 = non-fatal error (pending - schedule node not killed)
 ; 2 = fatal error (error - schedule node killed)
 ;%M = message to log [requried if there is an error]
 ;
 Q:'$G(%U)!($G(%S)="")  Q:%S<0!(%S>2)
 Q:'$D(^INTHU(%U))
 N DA,DIE,DR,DEST,H,PRIO
 D ULOG^INHU(%U,$S('%S:"C",%S=1:"P",1:"E"),$G(%M))
 S DIE="^INTHU(",DA=%U,DR=".09////"_$$NOW^UTDT D ^DIE
 S DEST=$P(^INTHU(%U,0),U,2),PRIO=+$P(^INTHU(%U,0),U,16)
 I %S D ENT^INHE(%U,+DEST,$G(%M))
 Q:%S=1
 S H=$G(^INLHSCH("DEST",+DEST,PRIO,%U)) K ^INLHSCH("DEST",+DEST,PRIO,%U)
 K:H ^INLHSCH(PRIO,H,%U)
 Q
CHECKSEG(INSEG,INREQ,INLVL) ; Validate segs for required and unexpected
 ;
 ; Inputs: INSEG - Seg ID
 ;  INREQ - Required Check Flag
 ;  INLVL - Current processing level
 ;  DATA  - Only for Unexpected Seg check. Will contain
 ;   data associated with UIF entry being processed.
 ;   Value will be set by compiled script and assumed
 ;   to exist. When valid entry detected, value reset
 ;   to valid entry
 ;  DELIM - Delimeter used in segs
 ;  LCT   - Line count (current IEN in UIF for processing)
 ;  INDEFSEG array of defined segs for message
 ;   INDEFSEG(seg id, level)=
 ;    1 if repeating
 ;    "" if not repeating
 ;  UIF   - IEN of Universal Interface
 ;   File entry
 ;
 ;Outputs: Function will quit with value =
 ;  0 - Seg not valid for processing in current loop.
 ;      Quit back to prior loop for continued processing.
 ;  1 - Invalid seg, next valid seg located.
 ;      Continue processing in current loop.
 ; Variables: INMATCH  - Seg located which matches search criteria
 ;  INDATA   - Data from UIF entry
 ;  INDONE   - Flag to indicate all UIF entries have
 ;      been searched
 ;  INCURSEG - Seg ID of current seg in process
 ;  INILCT   - Initial UIF entry for processing
 ;  INLOW    - LCT of first occurrence of lower level
 ;      seg, if no higher level is found
 ;
 N INMATCH,INDATA,INDONE,INCURSEG,INILCT,INLOW
 ;
 ; If seg is invalid, and to be ignored by GIS processing,
 ; line count will be incremented to next valid seg entry in
 ; Universal Interface File.
 ;
 ; If unexpected seg check, quit if current seg is expected seg
 I '$G(INREQ) Q:$P(DATA,DELIM)=INSEG 1
 ; If unexpected seg check, no more records to process, quit.
 I '$G(INREQ) Q:$G(DATA)="" 0
 ; Initialize variables
 S (INILCT,LCT)=$G(LCT),(INMATCH,INDONE,INLOW)=0
 ;
 ; If required check, set data=UIF entry
 I $G(INREQ) S DATA=$$GL^INHOU(UIF,LCT)
 ;
 ; Check current seg against processing rules. If appropriate for
 ; higher level processing, quit. Else continue processing additional
 ; segs.
 S INCURSEG=$P($G(DATA),DELIM)
 D CK1 Q:INMATCH 1 I INDONE D DONE Q 0
 ; Loop through interface file to find first occurence of valid seg
 ; for processing.
 F  D GETNEXT,CK1 Q:INMATCH  I INDONE D DONE Q
 I INREQ,'INDONE S LCT=LCT-1
 Q INMATCH=1
 ;
DONE ; If no valid seg found and end of entries or next valid entry is
 ; located, log error if missing required. Indicate next valid UIF entry
 ; (or set to last entry in file if no valid remaining entries), and
 ; Q 0 (no further processing in current loop)
 I $G(INREQ) D ERROR^INHS("Missing required "_INSEG_" segment. Processing aborted.",2) Q
 S:$G(INLOW) LCT=INLOW
 Q
CK1 ;
 ; Quit if last record encountered.
 Q:INDONE
 ; If no value in INCURSEG, out of data. Q
 I $G(INCURSEG)="" S INDONE=1 Q
 ; If current seg ID is what you're looking for, set INMATCH and quit
 I INCURSEG=INSEG S INMATCH=1 S DATA=INDATA Q
 ; Else if current seg ID is not defined in seg definition array,
 ; continue search.
 I '$D(INDEFSEG(INCURSEG)) Q
 ; Else if current seg has definition entry but only at lower
 ; level (higher level number), continue search. (Defined entry at a
 ; lower level indicates dependence on current level seg for
 ; processing).
 I $O(INDEFSEG(INCURSEG,-1))>INLVL S:'$G(INLOW) INLOW=LCT Q
 ; Else if current seg has definition entry at equal or higher
 ; level and is repeating, set INDONE and quit. (This will cause
 ; error to display, and processing to revert to higher level loop
 ; processing for next repeating group.)
 I $D(INDEFSEG(INCURSEG,$O(INDEFSEG(INCURSEG,INLVL+1),-1))) S INDONE=1 Q
 Q
GETNEXT ; Get next entry from UIF
 D GET^INHOU(UIF,0) S INDATA=$G(LINE)
 I INDATA="" S INDONE=1 S:$G(INLOW) LCT=INLOW Q
 S INCURSEG=$P(INDATA,DELIM)
 Q
