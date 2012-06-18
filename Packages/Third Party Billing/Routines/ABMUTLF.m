ABMUTLF ; IHS/ASDST/DMJ - FACILITY UTILITIES ;      
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;09/21/95 12:47 PM
 ;
 ; IHS/SD/SDR - v2.5 p8 - IM14883/IM16505
 ;    Fix to pull Medicare number for Part B
 ;
 ; IHS/SD/SDR/LSL - v2.5 p8 - IM13693/IM17856
 ;   Added code for 837 PI Billing
 ;
 ; IHS/SD/SDR - v2.5 p11 - NPI
 ;
PTAX(X) ;EP - provider taxonomy
 ;x=location ien
 N I,ABM0
 S Y=""
 S I=0
 F  S I=$O(^AUTTLOC(X,11,I)) Q:'I  D
 .S ABM0=^AUTTLOC(X,11,I,0)
 .Q:$P(ABM0,U)>ABMP("VDT")
 .I $P(ABM0,"^",2) Q:$P(ABM0,"^",2)<ABMP("VDT")
 .S ABMCLASS=$P(ABM0,"^",7)
 .Q:'ABMCLASS
 .S Y=$P($G(^AUTTPTAX(ABMCLASS,1)),U)
 Q Y
MCR(X) ;EP - medicare provider number
 ;x=location ien
 ; get group number if 999 and Medicare
 S Y=""
 I ABMP("VTYP")=999,ABMP("ITYPE")="R" D
 .S Y=$P($G(^ABMNINS(X,ABMP("INS"),0)),U,6)
 .S:Y="" Y=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),0)),U,6)
 .S:Y="" Y=$P($G(^ABMNINS(X,ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 .S:Y="" Y=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 I ABMP("BTYP")=831,($G(ABMP("ITYPE"))="R") D
 .S Y=$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 S:Y="" Y=$P($G(^AUTNINS(ABMP("INS"),15,X,0)),"^",2)
 S:Y="" Y=$P($G(^AUTTLOC(X,0)),"^",19)
 Q Y
MCD(X) ;EP - medicaid provider number
 ;x=location ien
 S Y=$P($G(^ABMNINS(X,ABMP("INS"),1,ABMP("VTYP"),0)),"^",8)
 S:Y="" Y=$P($G(^AUTNINS(ABMP("INS"),15,X,0)),"^",2)
 Q Y
EIN(X) ;EP - federal tax id number
 ;x=location ien
 S Y=$P($G(^AUTTLOC(X,0)),"^",18)
 Q Y
PI(X) ;EP - PI Provider Number
 ;x=location ien
 I $G(ABMFILE)="9999999.06",($G(ABMNPIU)="N")!($G(ABMNPIU)="B"),ABMEIC="EI" S Y=$TR($P($G(^AUTTLOC(X,0)),U,18),"-") Q Y
 S Y=$P($G(^ABMNINS(X,ABMP("INS"),1,ABMP("VTYP"),0)),U,8)
 S:Y="" Y=$P($G(^AUTNINS(ABMP("INS"),15,X,0)),U,2)
 Q Y
NPIUSAGE(X,Y) ;PEP - NPI Usage in 3P Insurer file
 ;x=location (i.e., DUZ(2))
 ;y=insurer
 Q $P($G(^ABMNINS(+X,+Y,0)),U,9)
