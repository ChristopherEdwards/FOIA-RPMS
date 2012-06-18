ABSPECA4 ; IHS/FCS/DRS - Parse Claim Response ;    [ 08/09/2002  11:08 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,42**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Parse ASCII Response Claim Record and Sup FDATA() Array
 ;
 ;Parameters:  RREC     - Ascii Response Record
 ;             RESPIEN  - Claim Response IEN (90023130.3)
 ;----------------------------------------------------------------------
 ; Calls ABSPECA5
 ;
 ;----------------------------------------------------------------------
 ; IHS/SD/lwj  8/6/02  NCPDP 5.1 changes
 ;  NCPDP 5.1 response segments are completely different than the
 ;  3.2 response.  Of significant importance are:
 ;   In 3.2, there were 4 basic repsonse segments (header required,
 ;     header option, information required, information optional.) 
 ;   In 5.1, there are 8 possible segments (header, message, insurance,
 ;     status, claim, pricing, DUR/PPS, and prior authorization)
 ;
 ;   In 5.1, for all segments following the header, a segment separator
 ;     is used.
 ;
 ;   In 5.1, field separators, and field identifiers are used for all
 ;     fields not appearing on the header segment.
 ;
 ; To adjust to these changes, this routine has been modified.  The
 ; first thing we will try to establish is which version of response
 ; we are working with.  A new subroutine was created to hold the
 ; 3.2 basic parsing of claim information, and a new routine 
 ; (ABSPOSH4) was created to perform the parsing of a 5.1 claim.
 ;----------------------------------------------------------------------
PARSE(RREC,RESPIEN) ;EP - from ABSPOSQL from ABSPOSQ4
 N GS,FS,RHEADER,RHEADERR,RHEADERO,MEDN,RDATA,RDATAR,RDATAO
 N INDEX,FDATA,ID,XDATA,RINFO
 ;
 ;Make sure input varaibles are defined
 Q:$G(RREC)=""
 Q:$G(RESPIEN)=""
 Q:'$D(^ABSPR(RESPIEN,0))
 ;
 ;group and field separator characters
 S GS=$C(29),FS=$C(28)
 ;
 ; Special handling for what appears to be a corrupt response
 ; from First Health for Alaska Medicaid.  It's missing a GS.
 I RREC'[GS D AKMEDFIX
 ;
 ;Parse response header section from ascii record
 S RHEADER=$P(RREC,GS,1)
 S RHEADERR=$P(RHEADER,FS,1)
 ;
 ;IHS/SD/lwj 8/6/02  NCPDP 5.1 changes  - begin changes
 ; Need to split out the parsing of 3.2 and 5.1 claims - we will
 ; check the version, and if it is 3.2, we will call the PARSE32
 ; subroutine - if it's 5.1, we will call the ABSPOSH4 routine.
 ;
 S FDATA(102)=$E(RHEADERR,1,2)
 I FDATA(102)[3 D PARSE32
 ;IHS/OIT/CASSEVERN/RAN - 02/10/2011 - Patch 42 -Allows us to parse the response coming back from a D.0 Claim 
 I (FDATA(102)[5)!(FDATA(102)["D") D PARSE51^ABSPOSH4(RREC,RESPIEN)
 ;
 ;IHS/SD/lwj 8/6/02 NCPDP 5.1 end changes other than subroutine
 ; PARSE32 tag
 ;
 Q
 ;
 ;
PARSE32 ;IHS/SD/lwj 8/6/02  NCPDP 5.1 forced the splitting of the parsing - 
 ; this subroutine is the original code that will parse 3.2 still
 ;
 S RHEADERO=$P(RHEADER,FS,2)
 ;
 ;Parse required response header fields
 S FDATA(102)=$E(RHEADERR,1,2)
 S FDATA(103)=$E(RHEADERR,3,4)
 S FDATA(501)=$E(RHEADERR,5,5)
 ;
 ; Reversal response: doesn't have the GS, though it does have
 ; some prescription-multiple-type fields.  Fake it out.
 ; Right now, this works only for PCS REVERSAL format.
 ; May learn more as other reversals come along.
 I FDATA(103)=11 D PCSREV G AROUND
 ;
 ;Parse optional response header fields
 S FDATA(524)=RHEADERO
 ;
 ;Parse repsonse information section from ascii record
 S RINFO=$P(RREC,GS,2,999)
 ;
 ;Parse response information sections for each medication
 F MEDN=1:1:$L(RINFO,GS) D
 .S RDATA=$P(RINFO,GS,MEDN)
 .S RDATAR=$P(RDATA,FS,1)
 .S RDATAO=$P(RDATA,FS,2,999)
 .;
 .;Parse required response information section
 .S FDATA("M",MEDN,501)=$E(RDATAR,1,1)
 .;
 .;Duplicate claim response information fields
 .I FDATA("M",MEDN,501)="D" D
 ..S FDATA("M",MEDN,1000)=$E(RDATAR,2,85)
 ..; Was it a duplicate Paid or Captured claim?
 ..N X S X=$S($$PAID^ABSPECA7($E(RDATAR,2,85)):"P",1:"C")
 ..S FDATA("M",MEDN,501)="D"_X
 .;
 .;Payable claim response information fields
 .I FDATA("M",MEDN,501)="P"!(FDATA("M",MEDN,501)="DP") D
 ..S FDATA("M",MEDN,505)=$E(RDATAR,2,7)
 ..S FDATA("M",MEDN,506)=$E(RDATAR,8,13)
 ..S FDATA("M",MEDN,507)=$E(RDATAR,14,19)
 ..S FDATA("M",MEDN,508)=$E(RDATAR,20,25)
 ..S FDATA("M",MEDN,509)=$E(RDATAR,26,31)
 ..S FDATA("M",MEDN,503)=$E(RDATAR,32,45)
 ..S FDATA("M",MEDN,504)=$E(RDATAR,46,85)
 .;
 .;Caputured claim response information fields
 .I FDATA("M",MEDN,501)="C"!(FDATA("M",MEDN,501)="DC") D
 ..S FDATA("M",MEDN,503)=$E(RDATAR,2,15)
 ..S FDATA("M",MEDN,504)=$E(RDATAR,16,85)
 .;
 .;Rejected claim response information fields
 .I FDATA("M",MEDN,501)="R" D
 ..S FDATA("M",MEDN,510)=$E(RDATAR,2,3)
 ..S FDATA("M",MEDN,511,1)=$E(RDATAR,4,5)
 ..S FDATA("M",MEDN,511,2)=$E(RDATAR,6,7)
 ..S FDATA("M",MEDN,511,3)=$E(RDATAR,8,9)
 ..S FDATA("M",MEDN,511,4)=$E(RDATAR,10,11)
 ..S FDATA("M",MEDN,511,5)=$E(RDATAR,12,13)
 ..S FDATA("M",MEDN,511,6)=$E(RDATAR,14,15)
 ..S FDATA("M",MEDN,511,7)=$E(RDATAR,16,17)
 ..S FDATA("M",MEDN,511,8)=$E(RDATAR,18,19)
 ..S FDATA("M",MEDN,511,9)=$E(RDATAR,20,21)
 ..S FDATA("M",MEDN,511,10)=$E(RDATAR,22,23)
 ..S FDATA("M",MEDN,511,11)=$E(RDATAR,24,25)
 ..S FDATA("M",MEDN,511,12)=$E(RDATAR,26,27)
 ..S FDATA("M",MEDN,511,13)=$E(RDATAR,28,29)
 ..S FDATA("M",MEDN,511,14)=$E(RDATAR,30,31)
 ..S FDATA("M",MEDN,511,15)=$E(RDATAR,32,33)
 ..S FDATA("M",MEDN,511,16)=$E(RDATAR,34,35)
 ..S FDATA("M",MEDN,511,17)=$E(RDATAR,36,37)
 ..S FDATA("M",MEDN,511,18)=$E(RDATAR,38,39)
 ..S FDATA("M",MEDN,511,19)=$E(RDATAR,40,41)
 ..S FDATA("M",MEDN,511,20)=$E(RDATAR,42,43)
 ..S FDATA("M",MEDN,504)=$E(RDATAR,44,85)
 .;
 .;Parse optional response information section
 .D OPTR(MEDN,RDATAO)
 ;
AROUND ;
 ;File FDATA() in Claim Response File (9002313.03)
 D FILE^ABSPECA5(RESPIEN)
 Q
PCSREV ; split off of PCS REVERSAL processing - RHEADER has everything
 ; Make it look like a prescription multiple
 ; It has no GS or FS stuff, so everything is in RHEADERR
 N X S X=RHEADERR
 I FDATA(501)="A" D  ; accepted reversal
 .S FDATA("M",1,503)=$E(X,6,19)
 .S FDATA("M",1,504)=$E(X,20,$L(X))
 E  I FDATA(501)="R" D  ; rejected reversal
 .S FDATA("M",1,510)=$E(X,6,7)
 .N I F I=8:2:26 D
 ..S FDATA("M",1,511,I-8/2+1)=$E(X,I,I+1)
 .S FDATA("M",1,504)=$E(X,28,100)
 E  D  ; corrupt
 .S FDATA("M",1,504)=X
 S MEDN=1
 Q
 ;---------------------------------------------------------------------
 ;Process Optional Response Information Section
 ;
 ;Parameters:  MEDN    - Current medication sequence #
 ;             RDATAO  - Optional response information section
 ;---------------------------------------------------------------------
OPTR(MEDN,RDATAO) ;
 ;Manage local variables
 N INDEX,ID,XDATA
 ;
 ;Make sure input variables are defined
 Q:$G(MEDN)=""
 Q:$G(RDATAO)=""
 ;
 F INDEX=1:1:$L(RDATAO,FS) D
 .S FDATA=$P(RDATAO,FS,INDEX)
 .Q:FDATA=""
 .;
 .S ID=$E(FDATA,1,2)
 .S XDATA=$E(FDATA,3,$L(FDATA))
 .I ID="F9" S FDATA("M",MEDN,509)=XDATA Q  ; PCS 1997 Packet Emulator Test #2 sends Patient Pay Amount here - mistakenly?  Let's record it anyhow.
 .I ID="FC" S FDATA("M",MEDN,512)=XDATA Q
 .I ID="FD" S FDATA("M",MEDN,513)=XDATA Q
 .I ID="FE" S FDATA("M",MEDN,514)=XDATA Q
 .I ID="FH" S FDATA("M",MEDN,517)=XDATA Q
 .I ID="FI" S FDATA("M",MEDN,518)=XDATA Q
 .I ID="FJ" S FDATA("M",MEDN,519)=XDATA Q
 .I ID="FK" S FDATA("M",MEDN,520)=XDATA Q
 .I ID="FL" S FDATA("M",MEDN,521)=XDATA Q
 .I ID="FM" S FDATA("M",MEDN,522)=XDATA Q
 .I ID="FN" S FDATA("M",MEDN,523)=XDATA Q
 .I ID="FP" D  Q
 . . I XDATA?159" "1N Q  ; no DUR data, just the overflow flag
 . . S FDATA("M",MEDN,525)=XDATA
 .I ID="FQ" S FDATA("M",MEDN,526)=XDATA Q
 Q
AKMEDFIX ; as noted, above ; Alaska Medicaid while sleeping - you get
 ; this corrupt message.  May be true of other insurers, too. 
 ; This looks like it might be an NDC message.
 ; We'll find out as time goes on.
 ; Here - we make sure that it's one of those packets,
 ; and we insert GS characters so that it parses correctly.
 I $E(RREC,7,21)'="FO        R0199" Q
 I $E(RREC,1,5)'?1"3C0"1N1"A" Q
 I $E(RREC,6)'=FS Q
 I $E(RREC,22,59)'?." " Q
 I $E(RREC,60,99)'="PRT010   CARRIER DISABLED      -B1ON99CR" Q
 N NPIECES S NPIECES=$L(RREC,"R0199") ; = header + 1 for each claim
 I NPIECES-1'=$E(RREC,4) Q
 ; Length requirement:  don't be so strict if it's only one piece
 ; We have seen this packet be 439 bytes on day, but 421 the next
 ; (See ANMC devel. system 9002313.03, `249; 11/04/2000 - 421 bytes.
 ; Compare  with `247 from 11/03/2000 - 439 bytes)
 I NPIECES>1,NPIECES-1*423+16'=$L(RREC) Q
 ; Okay, we're pretty sure this is it!  Insert the GS characters.
 N X S X=$E(RREC,1,16)
 N I F I=17:423:$L(RREC) S X=X_GS_$E(RREC,I,I+423-1)
 S RREC=X
 Q
