BIMFI ;IHS/CMI/MWR - MFI INTERFACE CODE; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE FOR MFI INTERFACE WITH MACHINES STILL USING OLD IHS CODES.
 ;
 ;
 ;----------
INBOUND(BIMSG) ;EP
 ;---> Translate Inbound Vaccine carrying Old IHS Code to HL7 Code
 ;---> by scanning Inbound Message and replacing Old IHS Code
 ;---> with HL7 Code.
 ;---> Called by ^APMFPRM.
 ;---> Parameters:
 ;     1 - BIMSG (req) IEN of Inbound Immunization Visit Filegram
 ;                     in ^XMB(3.9.
 Q:$$CHECK(BIMSG)
 ;
 N BIN S BIN=1
 F  S BIN=$O(^XMB(3.9,BIMSG,2,BIN)) Q:'BIN  D
 .Q:^XMB(3.9,BIMSG,2,BIN,0)'["BEGIN:IMMUNIZATION^9999999.14"
 .S BIN=BIN+1
 .N BIX S BIX=^XMB(3.9,BIMSG,2,BIN,0)
 .Q:BIX'["KEY:CODE^.03^C="
 .;
 .;---> BIOLD=Old IHS Code.
 .N BIOLD S BIOLD=$P(BIX,"=",2)
 .;
 .;---> Quit if no match for this IHS Code.
 .Q:'$D(^AUTTIMM("AZ",BIOLD))
 .;
 .;---> Set BIDA=IEN of Vaccine, based on Old IHS Code (in X).
 .N BIDA S BIDA=$O(^AUTTIMM("AZ",BIOLD,0))
 .;
 .;---> Quit if entry doesn't exist.
 .Q:'$D(^AUTTIMM(BIDA,0))
 .;
 .;---> BINEW=New HL7 Code
 .N BINEW S BINEW=$P(^AUTTIMM(BIDA,0),U,3)
 .Q:'BINEW
 .;
 .;---> Replace Old IHS Code in Message with New HL7 Code.
 .S $P(^XMB(3.9,BIMSG,2,BIN,0),"=",2)=BINEW
 Q
 ;
 ;
 ;
 ;----------
OUTBOUND(BIMSG) ;EP
 ;---> Translate Outbound Vaccine carrying New HL7 Code to
 ;---> Old IHS Code by scanning Outbound Message and replacing
 ;---> HL7 Code with Old IHS Code.
 ;---> Called by ^APMFVFG.
 ;---> Parameters:
 ;     1 - BIMSG (req) IEN of Outbound Immunization Visit Filegram
 ;                     in ^XMB(3.9.
 Q:$$CHECK(BIMSG)
 ;
 N BIN S BIN=1
 F  S BIN=$O(^XMB(3.9,BIMSG,2,BIN)) Q:'BIN  D
 .Q:^XMB(3.9,BIMSG,2,BIN,0)'["BEGIN:IMMUNIZATION^9999999.14"
 .S BIN=BIN+1
 .N BIX S BIX=^XMB(3.9,BIMSG,2,BIN,0)
 .Q:BIX'["KEY:HL7 CODE^.03^C="
 .;
 .;---> BIOLD=Old IHS Code.
 .N BIHL7 S BIHL7=$P(BIX,"=",2)
 .;
 .;---> Quit if no match for this IHS Code.
 .Q:'$D(^AUTTIMM("C",BIHL7))
 .;
 .;---> Set BIDA=IEN of Vaccine, based on Old IHS Code (in X).
 .N BIDA S BIDA=$O(^AUTTIMM("C",BIHL7,0))
 .;
 .;---> Quit if entry doesn't exist.
 .Q:'$D(^AUTTIMM(BIDA,0))
 .;
 .;---> BINEW=Old IHS Code.
 .N BINEW S BINEW=$P(^AUTTIMM(BIDA,0),U,20)
 .Q:BINEW=""
 .;
 .;---> Replace New HL7 Code in Message with Old IHS Code.
 .S $P(^XMB(3.9,BIMSG,2,BIN,0),"KEY:",2)="CODE^.03^C="_BINEW
 Q
 ;
 ;
 ;----------
CHECK(BIMSG) ;EP
 ;---> Check required variables.
 ;---> Parameters:
 ;     1 - BIMSG (req) IEN of Immunization Visit Filegram
 ;
 ;---> Get Site IEN.
 S BIDUZ2=$G(DUZ(2))
 I 'BIDUZ2 Q:'$G(^AUTTSITE(1,0))  S BIDUZ2=+^(0)
 Q:'BIDUZ2 1
 ;
 ;---> Quit if Site Parameter says to send HL7 Standard Codes.
 Q:$P($G(^BISITE(BIDUZ2,0)),U,20) 1
 ;
 ;---> Quit if Message does not exist.
 Q:'$D(^XMB(3.9,BIMSG,2)) 1
 ;
 ;---> All okay.
 Q 0
