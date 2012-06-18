VAFCPTED ;ISA/RJS,Zoltan-EDIT EXISTING PATIENT ;04/06/99
 ;;5.3;Registration;**149,333**;Aug 13, 1993
EDIT(DGDFN,ARRAY,STRNGDR) ;-- Edits existing patient
 ;Input:
 ;  DGDFN - IEN in the PATIENT (#2) file
 ;  ARRAY - Array containing fields to be edited.
 ;          Ex. ARRAY(.111)="123 STREET" or ARRAY(2,.111)="123...
 ;  STRNGDR - String of delimited PATIENT (#2) file fields in the order 
 ;            in which the fields will be processed by DIE.
 ;            Ex. ".01;.03;.05..."
 ;Output:
 ;  No output
 ;
 S U="^"
 N LOCKFLE,FLD,ZTQUEUED,DIQUIET,OLDZIP,VAFCX,STRNG
 S (ZTQUEUED,DIQUIET)=1
 L +^DPT(DGDFN):60
 S LOCKFLE=$T ; Need to remember whether the lock went through.
 I $L($G(@ARRAY@(.1112)))=5 D
 . ; This section prevents a 5-digit ZIP from replacing
 . ; an otherwise equivalent ZIP+4.
 . S OLDZIP=$$GET1^DIQ(2,DGDFN_",",.1112,"I")
 . I $E(OLDZIP,1,5)=@ARRAY@(.1112) S @ARRAY@(.1112)=OLDZIP
 ;process the given PATIENT file DR string in the given order
 S STRNG=STRNGDR F VAFCX=1:1 Q:STRNG=""  S FLD=$P(STRNGDR,";",VAFCX) S STRNG=$P(STRNGDR,";",VAFCX+1,$L(STRNGDR,";")) D LOAD
 ;
 ;Do Address Bulletin if incoming Address does not equal existing
 ;Address - removed bulletin with patch DG*5.3*333
 ;
 ;I $D(@ARRAY@(.111))!$D(@ARRAY@(.112))!$D(@ARRAY@(.113))!$D(@ARRAY@(.114))!$D(@ARRAY@(.115))!$D(@ARRAY@(.117))!$D(@ARRAY@(.1112)) D  ;**333
 ;. D ADDRESS^RGRSBULL(DGDFN,$G(@ARRAY@(.01)),$G(@ARRAY@(.111)),$G(@ARRAY@(.112)),$G(@ARRAY@(.113)),@ARRAY@("SENDING SITE"),$G(@ARRAY@(.114)),$G(@ARRAY@(.117)),$G(@ARRAY@(.115)),$G(@ARRAY@(.1112)))
 ;
 I LOCKFLE L -^DPT(DGDFN)
 ;
 K DIE,DA
 Q
 ;
LOAD ; -- Loads fields to patient file
 N DR,DIE
 S DA=DGDFN,DIE="^DPT("
 I $G(@ARRAY@(FLD))="" Q
 I $G(@ARRAY@(FLD))["@" S @ARRAY@(FLD)="@"
 ;GENERATE BULLETIN FOR CONDITION BELOW ?
 I $G(@ARRAY@(FLD))[U Q
 S DR=FLD_"///^S X=$G(@ARRAY@(FLD))"
 D ^DIE
 Q
