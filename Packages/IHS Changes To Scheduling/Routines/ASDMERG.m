ASDMERG ; IHS/ADC/PDW/ENM - -- sched patient merge ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 ;  ^SC(clinic,"S",appointment date/time,1,index,0)="patient^..." 
 ;  ^DPT(patient,"S",appointment date/time,0)="clinic^..."
 ;
 ;            dfn=patient, c=clinic, i=index
 ;          v=appointment date/time FM internal
 ;
 ;
 I '$G(XDRMRG("FR")),'$G(XDRMRG("TO")) Q
 N DFN,V,C,I,N,F
A ; -- update patient pointer in 44 
 S DFN=XDRMRG("FR"),V=0 F  S V=$O(^DPT(DFN,"S",V)) Q:'V  D
 . S C=+$G(^DPT(DFN,"S",V,0)) Q:'C
 . S I=0 F  S I=$O(^SC(C,"S",V,1,I)) Q:'I  D
 .. S N=$G(^SC(C,"S",V,1,I,0)) Q:'N  Q:+N'=DFN
 .. S $P(^SC(C,"S",V,1,I,0),U)=XDRMRG("TO")
 . K F S F="",I=0 F  S I=$O(^SC(C,"S",V,1,I)) Q:'I  D
 .. S N=$G(^SC(C,"S",V,1,I,0)) Q:'N
 .. K:$G(F(+N)) ^SC(C,"S",V,1,I) S F(+N)=1 Q
 Q
 ;
44 ; -- check/cleanup 44
 N DFN,V,C,I,N,F
 S C=0 F  S C=$O(^SC(C)) Q:'C  D
 . S V=0 F  S V=$O(^SC(C,"S",V)) Q:'V  D
 .. K F S F="",I=0 F  S I=$O(^SC(C,"S",V,1,I)) Q:'I  D
 ... S N=$G(^SC(C,"S",V,1,I,0)) Q:'N
 ... S DFN=$P($G(^DPT(+N,0)),U,19)
 ... I DFN,$G(F(DFN)) K ^SC(C,"S",V,1,I) Q
 ... I $G(F(+N)) K ^SC(C,"S",V,1,I) Q
 ... S F(+N)=1 Q:'DFN  S $P(^SC(C,"S",V,1,I,0),U)=DFN,F(DFN)=1
 Q
 ;
2 ; -- if patient file node and no 44, set
 N DFN,V,C,I,X,T,N,F
 S DFN=0 F  S DFN=$O(^DPT(DFN)) Q:'DFN  D
 . S V=0 F  S V=$O(^DPT(DFN,"S",V)) Q:'V  D
 .. S N=^DPT(DFN,"S",V,0) Q:'N  S C=+N
 .. S T="",(N,X,F,I)=0 F  S I=$O(^SC(C,"S",V,1,I)) Q:'I  Q:F  D
 ... S X=I+1,N=$G(^SC(C,"S",V,1,I,0)),T=$P(N,U,2) I +N=DFN S F=I
 .. Q:F  S ^SC(C,"S",V,1,X,0)=DFN_U_T_U_U_"comp. gen."_U_U_DUZ_U_DT
 Q
