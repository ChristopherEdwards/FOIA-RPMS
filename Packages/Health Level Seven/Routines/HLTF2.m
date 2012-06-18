HLTF2 ;AISC/SAW/MTC-Process Message Text File Entries (Cont'd) ;02/24/97  13:56
 ;;1.6;HEALTH LEVEL SEVEN;**1**;APR 04, 1997
 ;;1.6;HEALTH LEVEL SEVEN;**25**;Oct 13, 1995
MERGEIN(LLD0,LLD1,MTIEN,HDR,MSA) ;Merge Data From Communication Server
 ;Module Logical Link File into Message Text File
 ;
 ;This is a subroutine call with parameter passing.  The output
 ;parameters HDR (and optionally) MSA are returned by this call.
 ;
 ;Required input parameters
 ;  LLD0 = Internal entry number where message is stored in Logical Link
 ;            file or XM if message is stored in MailMan
 ;  LLD1 = Internal entry number of IN QUEUE multiple entry in Logical
 ;           Link file (Only required for messages stored in Logical
 ;           Link file)
 ;  MTIEN = Internal entry number where message is to be copied to in
 ;            Message Text file
 ;    HDR = The variable in which the message header segment will
 ;            be returned
 ;    MSA = The variable in which the message acknowledgement segment
 ;            will be returned, if one exists for this message
 ;
 ;Check for required parameters
 I $G(LLD0)']""!('$G(MTIEN)) Q
 I LLD0'="XM",'$G(LLD1) Q
 N FLG,HLCHAR,HLEVN,HLFS,I,X,X1,HLDONE
 S (FLG,HLCHAR,HLEVN,X)=0
 ;
 ;Move data from Logical Link file to Message Text file
 I LLD0'="XM" D
 .S I=0 F  S X=$O(^HLCS(870,LLD0,1,LLD1,1,X)) Q:X'>0  S X1=$G(^(X,0)) S:"FHS,BHS,MSH"[$E(X1,1,3) FLG=1 I FLG S HLCHAR=HLCHAR+$L(X1) D
 ..;If header segment, process it and set HDR equal to it
 ..I X1'="","FHS,BHS,MSH"[$E(X1,1,3) D
 ...I '$D(HDR) S HDR=X1,HLFS=$E(X1,4) I $E(HDR,1,3)="BHS" S MSA="MSA"_HLFS_$P($P(HDR,HLFS,10),$E(HDR,5),1)_HLFS_$P(HDR,HLFS,12)_HLFS_$P($P(HDR,HLFS,10),$E(HDR,5),2)
 ...S $P(X1,HLFS,8)=""
 ...S:$E(X1,1,3)="MSH" HLEVN=HLEVN+1
 ..;If acknowledgement segment, set MSA equal to it
 ..I $E(X1,1,3)="MSA",'$D(MSA),$E($G(HDR),1,3)="MSH" S MSA=X1
 ..S I=I+1,^HL(772,MTIEN,"IN",I,0)=X1
 ;
 ;Move data from MailMan Message file to Message Text file
 I LLD0="XM" D
 .S I=0 F  X XMREC Q:XMER<0  S:"FHS,BHS,MSH"[$E(XMRG,1,3) FLG=1 I FLG S HLCHAR=HLCHAR+$L(XMRG) D  Q:XMER<0
 ..;If header segment, process it and set HDR equal to it
 ..I XMRG'="","FHS,BHS,MSH"[$E(XMRG,1,3) D
 ...I '$D(HDR) S HDR=XMRG,HLFS=$E(XMRG,4) I $E(HDR,1,3)="BHS" S MSA="MSA"_HLFS_$P($P(HDR,HLFS,10),$E(HDR,5),1)_HLFS_$P(HDR,HLFS,12)_HLFS_$P($P(HDR,HLFS,10),$E(HDR,5),2)
 ...S $P(XMRG,HLFS,8)=""
 ...S:$E(XMRG,1,3)="MSH" HLEVN=HLEVN+1
 ..;If acknowledgement segment, set MSA equal to it
 ..I $E(XMRG,1,3)="MSA",'$D(MSA),$E($G(HDR),1,3)="MSH" S MSA=XMRG
 ..S I=I+1,^HL(772,MTIEN,"IN",I,0)=XMRG
 S ^HL(772,MTIEN,"IN",0)="^^"_I_"^"_I_"^"_$$DT^XLFDT_"^"
 ;Update statistics in Message Text file for this entry
 D STATS^HLTF0(MTIEN,HLCHAR,HLEVN)
 Q
MERGEOUT(MTIEN,LLD0,LLD1,HDR) ;Merge Text in Message Text File into
 ;Communication Server Module Logical Link File
 ;
 ;This is a routine call with parameter passing.  There are no output
 ;parameters returned by this call.
 ;
 ;Required input parameters
 ;  MTIEN = Internal entry number where message is stored in Message
 ;            Text file
 ;  LLD0 = Internal entry number where message is to be copied to in
 ;            Logical Link file
 ;  LLD1 = Internal entry number of IN QUEUE multiple entry in Logical
 ;          Link file
 ;  HDR  = Name of the array that contains HL7 Header segment
 ;         format: HLHDR - Used with indirection to build message in out
 ;                         queue
 ;  This routine will first take the header information in the array
 ;  specified by HDR and merge into the Message Text field of file 870.
 ;  Then it will move the message contained in 772 (MTIEN) into 870.
 ;
 ;Check for required parameters
 I '$G(MTIEN)!('$G(LLD0))!('$G(LLD1))!(HDR="") Q
 ;
 ;-- initilize 
 N I,X
 S I=0
 ;
 ;-- move header into 870 from HDR array
 S X="" F  S X=$O(@HDR@(X)) Q:'X  D
 . S I=I+1,^HLCS(870,LLD0,2,LLD1,1,I,0)=@HDR@(X)
 S I=I+1,^HLCS(870,LLD0,2,LLD1,1,I,0)=""
 ;
 ;Move data from Message Text file to Logical Link file
 S X=0 F  S X=$O(^HL(772,MTIEN,"IN",X)) Q:X=""  D
 . S I=I+1,^HLCS(870,LLD0,2,LLD1,1,I,0)=$G(^HL(772,MTIEN,"IN",X,0))
 ;
 ;-- update 0 node of message and format arrays
 S ^HLCS(870,LLD0,2,LLD1,1,0)="^^"_I_"^"_I_"^"_$$DT^XLFDT_"^"
 ;
 Q
