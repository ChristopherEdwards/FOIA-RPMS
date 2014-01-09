BYIMSEG1 ;IHS/CIM/THL - IMMUNIZATION DATA INTERCHANGE;
 ;;2.0;BYIM IMMUNIZATION DATA EXCHANGE INTERFACE;**3**;JAN 15, 2013;Build 79
 ;
 ;this routine will contain code to supplement fields in the
 ;HL7 segments
 ;
OBXCE ;EP;
 D VSET^BYIMSEGS(INDA)
 D OBXCE1
 D OBXCE2
 D OBXCE3
 D OBXCE4
 D OBXCE5
 D OBXCE11
 D OBXCE14
 D OBXCE17
 Q
 ;-----
OBXCE1 ;subid
 S INA("OBXCE1",INDA)="1"
 Q
 ;-----
OBXCE2 ;vt
 S INA("OBXCE2",INDA)="CE"
 Q
 ;-----
OBXCE3 ;od
 S INA("OBXCE3",INDA)="64994-7"_CS_"funding source for immunization"_CS_"LN"
 Q
 ;-----
OBXCE4 ;osid
 S INA("OBXCE4",INDA)="1"
 Q
 ;-----
OBXCE5 ;ov
 S INA("OBXCE5",INDA)=$$IVFC^BYIMIMM3(INDA)
 Q
 ;-----
OBXCE11 ;abn
 S INA("OBXCE11",INDA)="F"
 Q
 ;-----
OBXCE14 ;edt
 S INA("OBXCE14",INDA)=""
 N X
 S X=$P(X12,U)
 S:'X X=$P(V0,U)
 Q:'X
 S INA("OBXCE14",INDA)=$E($$TIMEIO^INHUT10(X),1,8)
 Q
 ;-----
OBXCE17 ;METHOD OF CAPTURE
 S INA("OBXCE17",INDA)="VXC40"_CS_"per immunization"_CS_"CDCPHINVS"
OBXCEEND Q
 ;-----
 ;-----
OBXPR ;EP;
 D VSET^BYIMSEGS(INDA)
 D OBXPR1
 D OBXPR2
 D OBXPR3
 D OBXPR4
 D OBXPR5
 Q
 ;-----
OBXPR1 ;subid
 S INA("OBXPR1",INDA)="2"
 Q
 ;-----
OBXPR2 ;vt
 S INA("OBXPR2",INDA)="TS"
 Q
 ;-----
OBXPR3 ;od
 S INA("OBXPR3",INDA)="29769-7"_CS_"Date vaccine information statement presented"_CS_"LN"
 Q
 ;-----
OBXPR4 ;osid
 S INA("OBXPR4",INDA)="1"
 Q
 ;-----
OBXPR5 ;ov
 S INA("OBXPR5",INDA)=""
 S:$P(X0,U,12) INA("OBXPR5",INDA)=$P(X0,U,12)+17000000
 S:$P(V0,U) INA("OBXPR5",INDA)=$P(V0,".")+17000000
OBXPREND Q
 ;-----
 ;-----
OBXPB ;EP;
 D VSET^BYIMSEGS(INDA)
 D OBXPB1
 D OBXPB2
 D OBXPB3
 D OBXPB4
 D OBXPB5
 Q
 ;-----
OBXPB1 ;subid
 S INA("OBXPB1",INDA)="3"
 Q
 ;-----
OBXPB2 ;vt
 S INA("OBXPB2",INDA)="TS"
 Q
 ;-----
OBXPB3 ;od
 S INA("OBXPB3",INDA)="29768-9"_CS_"Date vaccine information statement published"_CS_"LN"
 Q
 ;-----
OBXPB4 ;osid
 S INA("OBXPB4",INDA)="1"
 Q
 ;-----
OBXPB5 ;ov
 N X,Y,Z
 S INA("OBXPB5",INDA)=""
 S:X0 X=$P($G(^AUTTIMM(+X0,0)),U,13)
 S:X INA("OBXPB5",INDA)=X+17000000
OBXPBEND Q
 ;-----
 ;-----
