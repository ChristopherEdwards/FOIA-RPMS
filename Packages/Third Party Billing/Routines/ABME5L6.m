ABME5L6 ; IHS/ASDST/DMJ - Header 
 ;;2.6;IHS Third Party Billing System;**6,8**;NOV 12, 2009
 ;Header Segments
 ;
START ;START HERE
 D DXSET^ABMUTL8(ABMP("BDFN"))
 ;principal DX (BK)
 D EP^ABME5HI("BK")
 D WR^ABMUTL8("HI")
 ;admitting (BJ) or patient's reason for visit (PR)
 I $E(ABMP("BTYP"),1,2)=11 D EP^ABME5HI("BJ")  D WR^ABMUTL8("HI")
 I $E(ABMP("BTYP"),1,2)'=11,$G(ABMDX("ADM"))'="" D EP^ABME5HI("PR")  D WR^ABMUTL8("HI")
 ;external cause of injury (BN)
 I $D(ABMDXE) D
 .D EP^ABME5HI("BN")
 .D WR^ABMUTL8("HI")
 ;other (BF)
 I $G(ABMDX(2))'="" D
 .D EP^ABME5HI("BF")
 .D WR^ABMUTL8("HI")
 ;
 S ABMP("FLAT")=$$FLAT^ABMDUTL(ABMP("INS"),ABMP("VTYP"),ABMP("VDT"))
 I $P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,9)'="N" D PXSET^ABMUTL8(ABMP("BDFN"))
 ;principal PX (BR)
 I $G(ABMPX(1))'="" D
 .D EP^ABME5HI("BR")
 .D WR^ABMUTL8("HI")
 I $G(ABMPX(2))'="" D
 .D EP^ABME5HI("BQ")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),57,0)) D
 .D OSSET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME5HI("BI")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),51,0)) D
 .D OCSET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME5HI("BH")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),55,0)) D
 .D VASET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME5HI("BE")
 .D WR^ABMUTL8("HI")
 I $O(^ABMDBILL(DUZ(2),ABMP("BDFN"),53,0)) D
 .D CDSET^ABMUTL8(ABMP("BDFN"))
 .D EP^ABME5HI("BG")
 .D WR^ABMUTL8("HI")
 ;start old code abm*2.6*8 5010
 ;I $P(ABMB6,"^",6) D
 ;.D EP^ABME5QTY("NA")
 ;.D WR^ABMUTL8("QTY")
 ;I $P(ABMB7,"^",3) D
 ;.; QUIT if Medicare and not inpatient
 ;.I $P($G(^AUTNINS(ABMP("INS"),2)),U)="R",(ABMP("VTYP")'=111) Q
 ;.D EP^ABME5QTY("CA")
 ;.D WR^ABMUTL8("QTY")
 ;end old code abm*2.6*8 5010
 Q
