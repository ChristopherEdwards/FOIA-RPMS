ABMFPRT ;IHS/SET/DMJ - GENERIC FORM PRINTER 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;device is open and ready to go
EN(ABMFP) ;PEP - enter here
 S ABMLEFT=+$P($G(^ABMDEXP(ABMP("EXP"),0)),"^",2)
 S ABMTOP=+$P($G(^ABMDEXP(ABMP("EXP"),0)),"^",3)
 D PAGE
LOOP ;loop through abmfp array
 S I=0
 F  S I=$O(ABMFP(I)) Q:'I  D
 .D LINE
 .S J=0
 .F  S J=$O(ABMFP(I,J)) Q:'J  D
 ..D ONE
 Q
PAGE ;new page
 W $$EN^ABMVDF("IOF")
 W $C(13)
 S ABMLINE=1
 S ABMLINE=ABMLINE+ABMTOP
 Q
LINE ;carriage return to correct line    
 F  D  Q:'(ABMLINE<I)
 .Q:'(ABMLINE<I)
 .W !
 .S ABMLINE=ABMLINE+1
 Q
ONE ;write one data element
 W ?(J+ABMLEFT)
 W ABMFP(I,J)
 Q
