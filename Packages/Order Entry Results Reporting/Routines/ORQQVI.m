ORQQVI ; slc/CLA,STAFF - Functions which return patient vital and I/O data ;8/19/03  14:44
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**10,198**;Dec 17, 1997
VITALS(ORY,DFN,ORSDT,OREDT) ; return patient's vital measurements taken between start date/time and end date/time
 ;ORY: return variable, results are returned in the format:
 ;     vital measurement ien^vital type^date/time taken^rate
 ;DFN: patient identifier from Patient File [#2]
 ;ORSDT: start date/time in Fileman format
 ;OREDT: end date/time in Fileman format
 K ^UTILITY($J,"GMRVD")
 S GMRVSTR="BP;HT;WT;T;R;P;PN" ;dee 2/12/99 added PN
 S GMRVSTR(0)=ORSDT_"^"_OREDT_"^"_"^"
 D EN1^GMRVUT0
 N ORT,ORD,ORI,I
 S ORT="",ORD=0,ORI=0,I=0
 F  S ORT=$O(^UTILITY($J,"GMRVD",ORT)) Q:ORT=""  D
 .S I=I+1
 .F  S ORD=$O(^UTILITY($J,"GMRVD",ORT,ORD)) Q:ORD<1  D
 ..F  S ORI=$O(^UTILITY($J,"GMRVD",ORD,ORI)) Q:ORI<1  D
 ...S ORY(I)=ORI_"^"_ORT_"^"_$P(^UTILITY($J,"GMRVD",ORD,ORI),"^",8)_"^"_$P(^(ORI),"^")
 I I=0 S ORY(1)="^No vitals found."
 K GMRVSTR
 Q
 ;
XFASTVIT(ORY,DFN,F1,F2) ; return patient's most recent vital measurements
 ;ORY: return variable, results are returned in the format:
 ;     vital measurement ien^vital type^rate^date/time taken
 ;DFN: patient identifier from Patient File [#2]
 ; F1 & F2 are ignored
 ;
 N CNT
 S CNT=0
 D VITAL("TEMPERATURE","T",DFN,.ORY,.CNT)
 D VITAL("PULSE","P",DFN,.ORY,.CNT)
 D VITAL("RESPIRATION","R",DFN,.ORY,.CNT)
 D VITAL("BLOOD PRESSURE","BP",DFN,.ORY,.CNT)
 D VITAL("HEIGHT","HT",DFN,.ORY,.CNT)
 D VITAL("WEIGHT","WT",DFN,.ORY,.CNT)
 D VITAL("PAIN","PN",DFN,ORY,.CNT) ;dee 2/11/99
 Q
 ;
XVITAL(VITAL,ABBREV,DFN,ORY,CNT) ; get vital measurement
 N DATA,IDT,IEN,OK,VTYPE
 S VTYPE=$$FIND1^DIC(120.51,"","BX",VITAL,"","","ERR")
 I 'VTYPE Q
 S OK=0,IDT=0 F  S IDT=$O(^GMR(120.5,"AA",DFN,VTYPE,IDT)) Q:IDT<1  D  Q:OK
 .S IEN=0 F  S IEN=$O(^GMR(120.5,"AA",DFN,VTYPE,IDT,IEN)) Q:IEN<1  D  Q:OK
 ..I $P($G(^GMR(120.5,IEN,2)),U) Q  ; do not retrieve if entered in error
 ..S DATA=$G(^GMR(120.5,IEN,0))
 ..I 'DATA Q
 ..S CNT=CNT+1,OK=1
 ..S ORY(CNT)=IEN_U_ABBREV_U_$P(DATA,U,8)_U_$P(DATA,U)
 Q
 ;
NOTEVIT(ORY,DFN,NOTEIEN) ;
 N VSTR,NOTEDATE
 D NOTEVSTR^ORWPCE(.VSTR,NOTEIEN)
 Q:$P(VSTR,";",2)=""
 D FASTVIT(.ORY,DFN,$P(VSTR,";",2))
 Q
 ;
FASTVIT(ORY,DFN,F1,F2) ; return patient's most recent vital measurements
 ; in date range
 ;ORY: return variable, results are returned in the format:
 ;     vital measurement ien^vital type^rate^date/time taken
 ;DFN: patient identifier from Patient File [#2]
 ; F1: starting date/time range
 ; F2: ending date/time range
 ;
 N CNT,DT1,DT2
 S CNT=0
 I $G(F1)>0 D
 . I $G(F2)="",F1["." S DT1=$P(F1,".",1)_"."_$E($P(F1,".",2),1,4)
 . E  S DT1=F1
 E  S DT1=1
 S DT2=$S($G(F2)>0:F2,DT1>1:DT1,1:9999998)
 ;
 D VITAL("TEMPERATURE","T",DFN,.ORY,.CNT,DT1,DT2)
 D VITAL("PULSE","P",DFN,.ORY,.CNT,DT1,DT2)
 D VITAL("RESPIRATION","R",DFN,.ORY,.CNT,DT1,DT2)
 D VITAL("BLOOD PRESSURE","BP",DFN,.ORY,.CNT,DT1,DT2)
 D VITAL("HEIGHT","HT",DFN,.ORY,.CNT,DT1,DT2)
 D VITAL("WEIGHT","WT",DFN,.ORY,.CNT,DT1,DT2)
 D VITAL("PAIN","PN",DFN,.ORY,.CNT,DT1,DT2) ;dee 2/11/99
 Q
 ;
VITAL(VITAL,ABBREV,DFN,ORY,CNT,F1,F2) ;
 ;get most recent vital measurement in date range
 N DATA,IDT,ENDIDT,IEN,OK,VTYPE,MVAL,VALUE
 S VTYPE=$$FIND1^DIC(120.51,"","BX",VITAL,"","","ERR")
 I 'VTYPE Q
 S OK=0
 S IDT=9999999-(F2+$S(F2#1:.0000001,1:.7))
 S ENDIDT=9999999-(F1-.0000001)
 F  S IDT=$O(^GMR(120.5,"AA",DFN,VTYPE,IDT)) Q:IDT>ENDIDT!'IDT  D  Q:OK
 .S IEN=0 F  S IEN=$O(^GMR(120.5,"AA",DFN,VTYPE,IDT,IEN)) Q:IEN<1  D  Q:OK
 ..I $P($G(^GMR(120.5,IEN,2)),U) Q  ; do not retrieve if entered in error
 ..S DATA=$G(^GMR(120.5,IEN,0))
 ..I 'DATA Q
 ..S CNT=CNT+1,OK=1,VALUE=$P(DATA,U,8)
 ..S ORY(CNT)=IEN_U_ABBREV_U_VALUE_U_$P(DATA,U)
 ..I $P(ORY(CNT),"^",2)="T" D  ; Temperature.
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE_$S($E(VALUE):" F",1:"")
 ...S MVAL=+VALUE
 ...Q:'MVAL
 ...S MVAL=MVAL-32
 ...S MVAL=$J((MVAL*(5/9)),3,1)
 ...S ORY(CNT)=ORY(CNT)_"^("_MVAL_" C)"
 ..I $P(ORY(CNT),"^",2)="P" D  ; Pulse.
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE
 ..I $P(ORY(CNT),"^",2)="R" D  ; Respiration.
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE
 ..I $P(ORY(CNT),"^",2)="BP" D  ; Blood Pressure.
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE
 ..I $P(ORY(CNT),"^",2)="HT" D  ; Height.
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE_$S($E(VALUE):" in",1:"")
 ...S MVAL=+VALUE
 ...Q:'MVAL
 ...S MVAL=$J((MVAL*2.54),3,1)
 ...S ORY(CNT)=ORY(CNT)_"^("_MVAL_" cm)"
 ..I $P(ORY(CNT),"^",2)="WT" D  ; Weight.
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE_$S($E(VALUE):" lb",1:"")
 ...S MVAL=+VALUE
 ...Q:'MVAL
 ...S MVAL=$J((MVAL/2.2),3,1)
 ...S ORY(CNT)=ORY(CNT)_"^("_MVAL_" kg)"
 ..I $P(ORY(CNT),"^",2)="PN" D
 ...S ORY(CNT)=ORY(CNT)_"^"_VALUE
 Q
