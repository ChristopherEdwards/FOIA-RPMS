ABME8L6 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Header Segments
 ;
 ; 01/09/04 V2.5 P5 - 837 Modifications
 ;     Don't send ICD's if flat rate (PX)
 ;
 ; IHS/SD/SDR - v2.5 p6 - 7/16/04 - IM14148 - Added code to remove
 ;     QTY segment if Medicare and not inpatient
 ;
 ; IHS/SD/SDR - v2.5 p12 - IM24245
 ;   Added check back for flat rate but made it conditional
 ;   for bill type'=131 and Medicaid Exempt (NM Mcd)
 ;   They don't want ICD-9s
 ;
START ;START HERE
 D DXSET^ABMUTL8(ABMP("BDFN"))
 D EP^ABME8HI("BK")
 D WR^ABMUTL8("HI")
 I $G(ABMDX(2))'="" D
 .D EP^ABME8HI("BF")
 .D WR^ABMUTL8("HI")
 S ABMP("FLAT")=$$FLAT^ABMDUTL(ABMP("INS"),ABMP("VTYP"),ABMP("VDT"))
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,9)'="N" D PXSET^ABMUTL8(ABMP("BDFN"))
 I $G(ABMPX(1))'="" D
 .D EP^ABME8HI("BP")
 .D WR^ABMUTL8("HI")
 I $G(ABMPX(2))'="" D
 .D EP^ABME8HI("BO")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),57,0)) D
 .D OSSET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME8HI("BI")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),51,0)) D
 .D OCSET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME8HI("BH")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),55,0)) D
 .D VASET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME8HI("BE")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),53,0)) D
 .D CDSET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME8HI("BG")
 .D WR^ABMUTL8("HI")
 I $P(ABMB6,"^",6) D
 .D EP^ABME8QTY("NA")
 .D WR^ABMUTL8("QTY")
 I $P(ABMB7,"^",3) D
 .; QUIT if Medicare and not inpatient
 .I $P($G(^AUTNINS(ABMP("INS"),2)),U)="R",(ABMP("VTYP")'=111) Q
 .D EP^ABME8QTY("CA")
 .D WR^ABMUTL8("QTY")
 Q
