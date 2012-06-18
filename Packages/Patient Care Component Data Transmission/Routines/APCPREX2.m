APCPREX2 ; IHS/TUCSON/LAB - reexport in date range ; [ 12/16/03  3:16 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION;**3**;APR 03, 1998
 ;
 ;
GENREC ;EP
DELSTAT ;generate new delimited format of the statistical record
 S APCPUSED=APCPUSED+1 ;total number of visits used
 S APCP("X")=$$VREC(APCP("V DFN"),"STATISTICAL RECORD 1")
 D SETTMP
 S APCP("X")=$$VREC(APCP("V DFN"),"STATISTICAL RECORD 2")
 D SETTMP
 S APCP("X")=$$VREC(APCP("V DFN"),"STATISTICAL RECORD 3")
 D SETTMP
 ;cpt records
 K AUPNCPT S X=$$CPT^AUPNCPT(APCP("V DFN"))
 I $D(AUPNCPT) D
 .S (X,APCPV("CPT COUNT"))=0 F  S X=$O(AUPNCPT(X)) Q:X'=+X  S APCPV("CPT COUNT")=APCPV("CPT COUNT")+1
 .S APCPV("CPT RECS")=$S(APCPV("CPT COUNT")#25=0:APCPV("CPT COUNT")/25,1:(APCPV("CPT COUNT")\25)+1) ;IHS/CMI/LAB
 .F APCPV("CPT X")=1:1:APCPV("CPT RECS") D
 ..S P=1,Y=(APCPV("CPT X")*25)-25 K APCPV("CPT SET") F  S Y=$O(AUPNCPT(Y)) Q:Y=""!(Y>(APCPV("CPT X")*25))  S $P(APCPV("CPT SET"),U,P)=$P(AUPNCPT(Y),U)_"^" D  S P=P+2
 ...Q:$P(AUPNCPT(Y),U,4)'=9000010.18
 ...S E=$P(AUPNCPT(Y),U,5) S $P(APCPV("CPT SET"),U,(P+1))=$P($G(^AUPNVCPT(E,0)),U,16)
 ..S APCP("X")=$$VREC(APCP("V DFN"),"STATISTICAL RECORD 4",APCPV("CPT SET"),APCPV("CPT X"))
 ..D SETTMP
 Q
 ;
SETTMP ;
 S APCPTOTR=APCPTOTR+1
 S ^APCPDATA(APCPTOTR)=APCP("X")
 Q
VREC(APCPVIEN,APCPRTYP,APCPVAR1,APCPVAR2,APCPVAR3,APCPVAR4,APCPVAR5,APCPVAR6) ;generate 1 record delimited format
 S APCPVIEN(0)=^AUPNVSIT(APCPVIEN,0)
 S DFN=$P(^AUPNVSIT(APCPVIEN,0),U,5)
 NEW APCPRIEN S APCPRIEN=$O(^APCPREC("B",APCPRTYP,0))
 I 'APCPRIEN Q ""
 NEW APCPY,APCPT S APCPY=0,APCPT="" F  S APCPY=$O(^APCPREC(APCPRIEN,11,"B",APCPY)) Q:APCPY'=+APCPY  D
 .S X=""
 .NEW APCPZ S APCPZ=$O(^APCPREC(APCPRIEN,11,"B",APCPY,0))
 .Q:'$D(^APCPREC(APCPRIEN,11,APCPZ,1))
 .X ^APCPREC(APCPRIEN,11,APCPZ,1)
 .S $P(APCPT,U,APCPY)=X
 Q APCPT
DATE(D) ;EP - return YYYYMMDD from internal fm format
 ;IHS/CMI/LAB - added this for Y2K compliance and "^" pieced statistical record
 I $G(D)="" Q ""
 Q ($E(D,1,3)+1700)_$E(D,4,7)
EXAM(V,N) ;EP - return nth v exam on this visit
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVXAM("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVXAM(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AUTTEXAM(P)) Q ""
 Q $P(^AUTTEXAM(P,0),U,2)
 ;
PED(V,N) ;EP - return nth v patient ed on this visit
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I '$G(N) Q ""
 NEW %,Y,P,C,Z
 S (Z,P)="",(Y,C)=0
 S Y=0 F  S Y=$O(^AUPNVPED("AD",V,Y)) Q:Y'=+Y   S C=C+1 I C=N S P=$P(^AUPNVPED(Y,0),U),Z=Y
 I 'P Q P
 I '$D(^AUTTEDT(P)) Q ""
 Q $P(^AUTTEDT(P,0),U,2)
 ;
PHNAC(V) ;
 I '$G(V) Q ""
 I '$$PHN(V) Q ""  ;not a phn visit
 I $P(^AUPNVSIT(V,0),U,7)="N" Q "03"
 I $$CLINIC^APCLV(V,"C")=11 Q "01"
 Q "02"
PHN(V) ;
 ;is one of the providers a CHN?
 I '$G(V) Q ""
 NEW X,%,D,N
 I $$PRIMPROV^APCLV(V,"D")=13!($$PRIMPROV^APCLV(V,"D")=32) Q 1
 S (X,%,N)=0 F  S X=$O(^AUPNVPRV("AD",V,X)) Q:X'=+X  I $P(^AUPNVPRV(X,0),U,4)'="P" S N=N+1 S D=$$SECPROV^APCLV(V,"D",N) I D=13!(D=32) S %=1
 Q %
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
