BAREDP01 ; IHS/SD/LSL - EDI PARSING ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**1,3**;MAR 27, 2007
 ;;
 ; IHS/ASDS/LSL - O6/15/2001 - V1.5 Patch 1 - HQW-0201-100027
 ;     FM 22 issue.  Modified to include E in DIC(0).
 ;
 ; IHS/SD/LSL - 08/19/2002 - V1.7 Patch 4 - HIPAA
 ;     Modified FILE and LOOP to accomodate X12 loops on segments
 ;     with the same ID.
 ; *********************************************************************
 ;
EN(TRDA,IMPDA)     ; EP -- Process the file loaded into Image
 S VALMBCK="R"
 D PARSE(TRDA,IMPDA)
 D FILE(TRDA,IMPDA)
 W "  ",COUNT
 Q
 ; ********************************************************************
 ;
PARSE(TRDA,IMPDA) ;
 ; parse image in ^TMP($J,"I", into segments "S"
 ; Separators S-Segment, E-Element, SE-Sub Element
 K ^TMP($J,"I"),^TMP($J,"S")
 D SEP(TRDA,IMPDA)            ; find separators 
 S BARTMP=0
 F  S BARTMP=$O(^BAREDI("I",DUZ(2),IMPDA,10,BARTMP)) Q:'+BARTMP  S ^TMP($J,"I",10,BARTMP)=^BAREDI("I",DUZ(2),IMPDA,10,BARTMP,0)
 ;
 ; remove trailing spaces if any (because control char were replaced
 ; spaces when the file was read into a global)
 S A="^TMP($J,""I"",10)"
 S B="^TMP($J,""S"")"
 S LC=$O(@A@(""),-1)
 F I=1:1:LC S X=@A@(I) D  S @A@(I)=X
 . F  S L=$L(X) Q:$E(X,L)'=" "  S X=$E(X,1,L-1)
 S X=""
 S L1=1,L2=1
 ;
 ; the following uses GO commands to simplify the logic loops
 ; have to combine lines of the import and pull out the records 
 ; uniquely into seperate segments
 ;
 W !,"Splitting image into Segments",!
 S COUNT=1
 ;
ADD ;add image lines to X till it has a seperator
 G:'$D(@A@(L1)) LAST
 G:@A@(L1)="" LAST
 S X=X_@A@(L1)
 S L1=L1+1
 I X[S G STORE
 G ADD
 ; ********************************************************************
 ;
STORE ;
 ; store segment & store more if X has  several segments in it
 W:'(COUNT#10) "."
 W:'(COUNT#500) "  ",COUNT,!
 S COUNT=COUNT+1
 S Y=$P(X,S)
 S X=$P(X,S,2,999)
 S @B@(L2)=Y
 S L2=L2+1
 I X[S G STORE
 G ADD
 ; ********************************************************************
 ;
LAST ;store last
 S X=$$STRIP^BAREDIUT(X)
 S:$L(X) @B@(L2)=X
 S Z=$O(@B@(""),-1)
 K ^BAREDI("I",DUZ(2),IMPDA,15)
 F I=1:1:Z S ^BAREDI("I",DUZ(2),IMPDA,15,I,0)=@B@(I)
 S ^BAREDI("I",DUZ(2),IMPDA,15,0)="^^"_Z_"^"_Z_"^"_DT
 Q
 ; ********************************************************************
 ;
SEP(TRDA,IMPDA) ;
 ; FIND SEPERATORS
 ;TRANSPORT - TRDA, IMPORT DA - IMPDA
 ;store S=Segment,E=Element,SE=Subelement
 S ROU=$$GET1^DIQ(90056.01,TRDA,.02)
 S ROU=$TR(ROU,"|","^")
 Q:'$L(ROU)
 D @ROU
 Q
 ; ********************************************************************
 ;
FILE(TRDA,IMPDA)   ;
 ; Take field 15 Image by Segment, find its segment and 
 ; store in segments multiple(s) ready for spliting & conversion
 ;
 W !,"Identifying Segments Uniquely",!
 S COUNT=1
 ;pull image by segment into @SEG@
 K ^TMP($J,"SEG")
 ;
 ; build SEGID array for assignments
 ; SEGID(ID,SEGMENT)=USE ; ie  SEGID("CAS","2-090-CAS")=99
 ;
 K SEGI,SESGID
 D ENPM^XBDIQ1(90056.0101,"TRDA,0",".01;.02;.06","SEGI(")
 S I=0 F  S I=$O(SEGI(I)) Q:I'>0  S SEGID(SEGI(I,.02),SEGI(I,.01))=SEGI(I,.06)
 ;
 ; Pull & build loop id array LOOP(ID)=SEGMENT
 ; If Mark(ID) then segment sets its own last segment level
 ; If BARLOOP("DUP"), then Segment Id is LOOPed more than once
 ;
 K DIC,LOOP,LOP
 S DIC=$$DIC^XBDIQ1(90056.0101)
 S DIC("S")="I +$P(^(0),U,5)"
 D ENPM^XBDIQ1(.DIC,"TRDA,0",".01;.02","LOP(")
 K BARLOOP
 S I=0
 F  S I=$O(LOP(I)) Q:I'>0  D
 . S:$D(LOOP(LOP(I,.02))) BARLOOP("DUP",LOP(I,.02))=1
 . S LOOP(LOP(I,.02))=LOP(I,.01)
 K LOP
 ;
 ; initialize current & last ID, SEGMENT, USE
 S (LSTID,LSTSEG,LSTUSE,CURID,CURSEG,CURUSE)=""
 ;
 K ^BAREDI("I",DUZ(2),20) ; clear Records
 S SEGDA=0
 F  S SEGDA=$O(^BAREDI("I",DUZ(2),IMPDA,15,SEGDA)) Q:SEGDA'>0  S SEGX=^(SEGDA,0) D
 . S LSTSEG=CURSEG
 . S LSTID=CURID
 . S LSTUSE=CURUSE
 . D IDENT
 . Q:CURID="NTE"  ;BAR*1.8*3 IM25273 CANNOT HANDLE NTE SEGMENTS
 .;               SRS TO BE WRITTEN FOR SPECIFICATIONS
 . D FILE1
 Q
 ; ********************************************************************
 ;
IDENT ; logic to locate segment from ID
 S CURID=$P(SEGX,E)
 Q:CURID="NTE"  ;BAR*1.8*3 IM25273 CANNOT HANDLE NTE SEGMENTS
 ;               SRS TO BE WRITTEN FOR SPECIFICATIONS
 I CURID'=LSTID D  Q
 . I $D(LOOP(CURID)) D  I 1
 . . I $D(BARLOOP("DUP",CURID)) D  Q
 . . . I TRNAME["HIPAA",CURID="N1" D
 . . . . S:$P(SEGX,E,2)="PR" CURSEG="2-080.A-N1"
 . . . . S:$P(SEGX,E,2)="PE" CURSEG="2-080.B-N1"
 . . . I TRNAME["3041.4A",CURID="N1" D
 . . . . S:$P(SEGX,E,2)="PR" CURSEG="1-080.A-N1"
 . . . . S:$P(SEGX,E,2)="PE" CURSEG="1-080.B-N1"
 . . S CURSEG=LOOP(CURID)
 . E  D  ;S CURSEG=$O(SEGID(CURID,LSTSEG))  ;BAR*1.8*1 SRS PATCH 1 ADDENDUM
 . . ;CHANGE MADE BECAUSE ALGORYTHM DID NOT HANDLE GOING FROM THE B TO NEXT B SEGMENTS
 . . ;IT WOULD SKIP TO THE PREVIOUS A-XXX SEGMENT
 . . S TEMPSEG=LSTSEG
 . . S LOOPID1=$P($P(LSTSEG,".",2),"-")
 . . S CURSEG=$O(SEGID(CURID,LSTSEG))
 . . S LOOPID2=$P($P(CURSEG,".",2),"-")
 . . S:LOOPID1="B"&(LOOPID2="A") CURSEG=$O(SEGID(CURID,CURSEG))
 . . ;END BAR*1.8*1 SRS PATCH 1 ADDENDUM
 . ;IHS/SD/TPF 12/16/2005 IM19044
 . I $G(CURSEG)="",($G(CURID)="ISA") W !,"File contains more than one ISA/IEA pair at "_$G(^BAREDI("I",DUZ(2),IMPDA,15,SEGDA))_" . Inform payor and request new file." H 3 Q
 . S CURUSE=SEGID(CURID,CURSEG)
 ;
 I LSTUSE>1 D  Q
 . S CURSEG=LSTSEG
 . S CURUSE=LSTUSE
 ;
 S CURSEG=$O(SEGID(CURID,LSTSEG))
 S CURUSE=SEGID(CURID,CURSEG)
 Q
 ; ********************************************************************
 ;
FILE1 ;
 W:'(COUNT#10) "."
 W:'(COUNT#500) "  ",COUNT,!
 S COUNT=COUNT+1
 K DIC,DR,DD,DO,DA
 S DIC=$$DIC^XBDIQ1(90056.0101)
 S X=CURSEG
 S DIC(0)="X"
 S DA(1)=TRDA
 D ^DIC
 N SEGLNK
 S SEGLNK=TRDA_","_+Y
 K DIC,DR,DD,DO,DA
 S DA(1)=IMPDA
 S DIC("P")="90056.0202A"
 S DIC=$$DIC^XBDIQ1(90056.0202)
 S DLAYGO=90056
 S DIC(0)="FZE"
 S X=SEGDA
 S DIC("DR")=".02///^S X=CURID"
 S DIC("DR")=DIC("DR")_";.03///^S X=CURSEG"
 S DIC("DR")=DIC("DR")_";.04///^S X=SEGLNK"
 S DIC("DR")=DIC("DR")_";1.01///^S X=SEGX"
 D FILE^DICN
 K DIC,DR,DD,DO
 Q
 ; ********************************************************************
 ;
CLEAR(IMPDA) ; kill nodes 15 & 20 for a rerun
 K ^BAREDI("I",DUZ(2),IMPDA,15)
 K ^BAREDI("I",DUZ(2),IMPDA,20)
 Q
