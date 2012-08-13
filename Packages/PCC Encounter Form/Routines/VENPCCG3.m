VENPCCG3 ; IHS/OIT/GIS - GET ICD PREFERENCES ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ;
 ;
A ;
NARR ; EP-convert the provider narr. to mixed case sentences
 Q:'$D(NARR)
 S VENT("F")=$E(NARR,1)
UP S VENT("F")=$TR(VENT("F"),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S VENT("L")=$E(NARR,2,80)
LOW S VENT("L")=$TR(VENT("L"),"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
 S NARR=VENT("F")_VENT("L")
 S VENT("LEN")=$L(NARR)
 D NARR2
 Q
NARR2 ; chk for ii i Dm dm etc. and change the case to upper
 ;
 I NARR?.E1" ii".E D
 . S NARR=$P(NARR," ii",1)_" II"_$P(NARR," ii",2,99)
 I NARR?.E1" iii".E D
 . S NARR=$P(NARR," iii",1)_" III"_$P(NARR," iii",2,99)
 I NARR?.E1" i ".E D
 . S NARR=$P(NARR," i ",1)_" I "_$P(NARR," i ",2,99)
 I NARR?.E1" i.".E D
 . S NARR=$P(NARR," i.",1)_" I."_$P(NARR," i.",2,99)
 I NARR?.E1" iv.".E D
 . S NARR=$P(NARR," iv.",1)_" IV."_$P(NARR," iv.",2,99)
 I NARR?.E1" iv ".E D
 . S NARR=$P(NARR," iv ",1)_" IV "_$P(NARR," iv ",2,99)
 I NARR?.E1" dm ".E D
 . S NARR=$P(NARR," dm ",1)_" DM "_$P(NARR," dm ",2,99)
 I NARR?.E1" dm.".E D
 . S NARR=$P(NARR," dm.",1)_" DM."_$P(NARR," dm.",2,99)
 I NARR?.E1" Dm ".E D
 . S NARR=$P(NARR," Dm ",1)_" DM "_$P(NARR," Dm ",2,99)
 I NARR?.E1" Dm.".E D
 . S NARR=$P(NARR," Dm.",1)_" DM."_$P(NARR," Dm.",2,99)
 I NARR?.E1"Dm.".E D
 . S NARR=$P(NARR,"Dm.",1)_"DM."_$P(NARR,"Dm.",2,99)
 I NARR="Chf" S NARR="CHF"
 I NARR="Copd" S NARR="COPD"
 I NARR="Uri" S NARR="URI"
 Q
