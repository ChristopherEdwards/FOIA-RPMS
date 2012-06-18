AUPNPC ; IHS/CMI/LAB - PERCENTILES ;
 ;;99.1;IHS DICTIONARIES (PATIENT);;MAR 09, 1999
 ;
 ;FOR PERCENTILES, HT AND WT
 ;
 ; This extrinsic function returns the height or weight percentile
 ; based on sex and age in months.  If any passed variable is missing
 ; or invalid null is returned.
 ;
 ; Formal list:
 ;
 ; 1) TYPE  = HT or WT (call by value)
 ; 2) SEX   = patient's sex, M or F (call by value)
 ; 3) AGE   = patient's age in whole months (call by value)
 ;            must be less than 216 months
 ; 4) VALUE = height in inches or weight in pounds (call by value)
 ;
AUHTWT(TYPE,SEX,AGE,VALUE) ; EXTRINSIC FUNCTION TO RETURN HT/WT PERCENTILE
START ;
 NEW %,AGEINC,GRP,INTERP,LASTINT,LOWAGE,MSR1,MSR2,P,P1,P2,R,RATA,V1,V2,XAGE,XSEX,XTYPE
 ; ----------
 I TYPE'="HT"&(TYPE'="WT") G ERR
 I SEX'="M"&(SEX'="F") G ERR
 I AGE<0 G ERR
 I AGE'=+AGE G ERR
 I AGE'<216 G ERR
 I VALUE'=+VALUE G ERR
 ; ----------
 S XTYPE=$O(^AUTTPCT("B",TYPE,""))
 S XSEX=$O(^AUTTPCT(XTYPE,1,"B",SEX,""))
 S AGEINC=$S(AGE<18:3,1:6)
 S LOWAGE=AGE-(AGE#AGEINC)
 S XAGE=$O(^AUTTPCT(XTYPE,1,XSEX,1,"B",LOWAGE,""))
 ; ----------
FIND S MSR1=$P(^AUTTPCT(XTYPE,1,XSEX,1,XAGE,0),"^",2)
 S MSR2=$P(^AUTTPCT(XTYPE,1,XSEX,1,XAGE+1,0),"^",2)
 S RATA=(AGE-LOWAGE)/AGEINC
 F GRP=0:1:7 Q:GRP=7  S V1=$E(MSR1,GRP*4+1,GRP*4+4)/10,V2=$E(MSR2,GRP*4+1,GRP*4+4)/10,INTERP=V1+((V2-V1)*RATA) Q:VALUE<INTERP  S LASTINT=INTERP
 S GRP=GRP+1
 I GRP=1 S %="<3" G EXIT
 I GRP=8 S %=">97" G EXIT
 S R=(VALUE-LASTINT)/(INTERP-LASTINT)
 S P=$P($T(PCT),";;",2),P2=$P(P,"^",GRP),P1=$P(P,"^",GRP-1),%=P1+(R*(P2-P1)),%=%+.5\1
DEBUG ;W LASTINT,"-",VALUE,"-",INTERP," ",R,"  ",P1,"..",%,"..",P2,!
 G EXIT
ERR ;
 S %=""
EXIT ;
 Q %
 ;
 ;
PCT ;;3^10^25^50^75^90^97
