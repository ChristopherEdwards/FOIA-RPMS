ABSPOSCA ; IHS/FCS/DRS - Create 9002313.02 entries ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; Create 9002313.02 entries for RXILIST(*) claims.
 ; Called from PACKET^ABSPOSQG
 ;
 ; Input:
 ;      RXILIST(IEN59)  array of pointers to 9002313.59
 ;         A list of prescriptions for the same visit/patient/etc.
 ;         to be bundled into one or more 9002313.02 claims
 ;
 ; Outputs:
 ;      CLAIMIEN(CLAIMIEN)="", pointers to the ^ABSPC(CLAIMIEN,
 ;                             claim records created.
 ;      ERROR
 ;
 ; ABSPOSCA calls:
 ;   ABSPOSCB to build ABSP(*) array
 ;      (and ABSPOSCB calls ABSPOSCC)
 ;   ABSPOSCD to build the ^ABSPC( entry
 ;
EN(DIALOUT)        ;EP - from ABSPOSQG
 I $D(RXILIST)<10 D IMPOSS^ABSPOSUE("P","TI","bad RXILIST",,,$T(+0))
 ;Manage local variables
 N ABSP,START,END,TOTAL,NCLAIMS,CLAIMN
 S ERROR=$$ABSP^ABSPOSCB(DIALOUT,.ABSP)
 I ERROR D LOG2LIST^ABSPOSQ($T(+0)_" - $$ABSP^ABSPOSCB("_DIALOUT_",.ABSP) returned "_ERROR)
 I $G(ABSP("RX",0))="" S:'ERROR ERROR=301 Q
 I $G(ABSP("NCPDP","# Meds/Claim"))="" S ERROR=302 Q
 ;
 ; Override any ABSP() nodes that you need to override.
 ;
 D  ; NDC #s - Translate POSTAGE (may be insurer-dependent someday)
 .N N F N=1:1:ABSP("RX",0) D
 ..N X,Y S X=$TR(ABSP("RX",N,"NDC"),"-",""),Y=ABSP("RX",N,"IEN59")
 ..N Z S Z=$P(^ABSPT(Y,1),U,2)
 ..I Z="POSTAGE" S Z=99999999981 ; 06/21/2000
 ..; This next part should never happen; it should already be correct
 ..;    ABSPOSQ1 already put the correct NDC # into the ^PSRX
 ..;    and ABSPOSCE will pick it out from there.
 ..I X'=Z,Z'="POSTAGE",Z'="" D  ; $TR inserted above, 03/07/2000
 ...S ABSP("RX",N,"NDC")=Z
 ...D LOG59^ABSPOSQ("CLAIM - NDC # on `"_Y_" sent as "_Z_", not "_X,Y)
 ;
 ;Calculate number of claim records to be generated for Billing Item
 S NCLAIMS=((ABSP("RX",0)-1)\ABSP("NCPDP","# Meds/Claim"))+1
 I NCLAIMS=0 S ERROR=303 Q
 ;
 ;Generate claim submission records
 F CLAIMN=1:1:NCLAIMS D  Q:$G(ERROR)
 .S START=((CLAIMN-1)*ABSP("NCPDP","# Meds/Claim"))+1
 .S END=START+ABSP("NCPDP","# Meds/Claim")-1
 .S:END>ABSP("RX",0) END=ABSP("RX",0)
 .S TOTAL=END-START+1
 .D NEWCLAIM^ABSPOSCE(START,END,TOTAL)
 .S CLAIMIEN=ABSP(9002313.02)
 .S CLAIMIEN(CLAIMIEN)=""
 .; Mark each of the .59s with the claim number and position within
 .F I=START:1:END D
 ..;IEN59 handling 06/23/2000. The ELSE should never happen again.
 ..; and the $G() can probably be gotten rid of, safely.
 ..N IEN59 S IEN59=$G(ABSP("RX",I,"IEN59"))
 ..I IEN59 D
 ...N DIE,DA,DR S DIE=9002313.59
 ...; Field (#3) CLAIM (#14) POSITION
 ...S DA=IEN59,DR=3_"////"_CLAIMIEN_";14////"_I N I D ^DIE
 ..E  D
 ...S $P(^ABSPT(ABSP("RX",I,"RX IEN"),0),"^",4)=CLAIMIEN
 ...S ^ABSPT("AE",CLAIMIEN,ABSP("RX",I,"RX IEN"))=""
 ...S $P(^ABSPT(ABSP("RX",I,"RX IEN"),0),"^",9)=I
 ..; POSITION:  Not the relative position within the packet,
 ..; but the index in ABSP("RX",n,....  This is the position in which
 ..; it will be stored in ^ABSPC(ien,400,POSITION
 ..; and likewise for 9002313.03 when the response comes in.
 Q
