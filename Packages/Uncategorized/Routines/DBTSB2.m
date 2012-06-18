DBTSB2 ;routine number2 called from DBTSBEG [ 03/18/1999  12:29 PM ]
 ;
 ;
ST ;
 D @ENT
 Q
7 ;    patient education chgs or adds
 I $D(DBTS("NEWPAT")) S DBTSAU=1 Q  ;2/11/99 dmh added so sql will add 
 ;                                ;records in pt. ed table on new pat
 S REC=$G(^DBTSPAT(DBTSP,"EDU"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 ;                                ;records in pt. ed table on new pat
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVPED("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S PED=$G(^AUPNVPED(N,0))
 .Q:PED=""
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(PED,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
8 ;    eye exam chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"EYE"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVPOV("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S EYE=$G(^AUPNVPOV(N,0))
 .Q:EYE=""
 .S DBTS("VDFN")=$P(EYE,U,3)
 .Q:DBTS("VDFN")=""
 .S DBTS("VREC")=$G(^AUPNVSIT(DBTS("VDFN"),0))
 .Q:DBTS("VREC")=""
 .S DBTS("CL")=$P(DBTS("VREC"),U,8)
 .Q:+DBTS("CL")=0
 .S DBTS("CLCODE")=$P(^DIC(40.7,DBTS("CL"),0),U,2)
 .Q:DBTS("CLCODE")'=18
 .S EYEPOV=$P(EYE,U,1)
 .S E=$O(^DBTSEXDI("B","DIABETIC EYE EXAM",0))
 .I E="" Q
 .I $D(^DBTSEXDI(E,11,"B",EYEPOV))
 .E  Q
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(EYE,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
9 ;    amputation chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"AMP"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVPRC("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S AMP=$G(^AUPNVPRC(N,0))
 .Q:AMP=""
 .S AMPPRC=$P(AMP,U,1)
 .S A=$O(^DBTSEXDI("B","AMPUTATIONS",0))
 .I A="" Q
 .I $D(^DBTSEXDI(A,21,"B",AMPPRC))
 .E  Q
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(EYE,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
10 ;    foot check chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"FTC"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVXAM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S EXAM=$G(^AUPNVXAM(N,0))
 .S CODE=$P(EXAM,U,1)
 .I CODE="" Q
 .S CODE=$P($G(^AUTTEXAM(CODE,0)),U,2)
 .Q:CODE'="29"
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P($G(^AUPNVXAM(N,0)),U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
11 ;    foot exam  chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"FTE"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVXAM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S EXAM=$G(^AUPNVXAM(N,0))
 .S CODE=$P(EXAM,U,1)
 .I CODE="" Q
 .S CODE=$P($G(^AUTTEXAM(CODE,0)),U,2)
 .Q:CODE'="28"
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(EXAM,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
12 ;    pelvic exam chgs or adds
 S REC=$G(^DBTSPAT(DBTSP,"PEL"))
 S DBTS("LDFN")=$P(REC,U,1),DBTS("LDT")=$P(REC,U,2)
 S DBTSAU=0
 S N=0
 F  S N=$O(^AUPNVXAM("AC",DBTSP,N)) Q:+N=0  D  I DBTSAU=1 Q
 .S EXAM=$G(^AUPNVXAM(N,0))
 .S CODE=$P(EXAM,U,1)
 .I CODE="" Q
 .S CODE=$P($G(^AUTTEXAM(CODE,0)),U,2)
 .Q:CODE'="15"
 .I N>(DBTS("LDFN")) S DBTSAU=1 Q
 .S VD=$P(EXAM,U,3)
 .I VD'="" S DBTS("MODDT")=$P($G(^AUPNVSIT(VD,0)),U,13)
 .E  S DBTS("MODDT")=""
 .I DBTS("LDT")'>(DBTS("MODDT")) S DBTSAU=1
 .Q
 Q
