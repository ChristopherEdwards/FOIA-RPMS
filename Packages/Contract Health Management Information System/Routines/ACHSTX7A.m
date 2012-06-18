ACHSTX7A ; IHS/ITSC/JVK - EXPORT DATA (8A/9) - RECORD 7(638 STATISTICAL DATA FOR DDPS) ; JUL 10, 2008
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**11,14,15**;JUN 11,2001
 ;ITSC/SET/JVK ACHS*3.1*11 ADD ADDITIONAL FIELDS FOR EXPORT
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;3.1*15 3.4.2009 IHS/OIT/FCJ ADDED CSV CHANGES FOR CPT CODE
 ;
DXPX ;EP - ITSC/SET/JVK ACHS*3.1*11 INCREASED FOR LOOP FROM 5 TO 9 ENTRIES 
 S (ACHSAPC(1),ACHSAPC(2))="   ",ACHS=0
 F ACHSX=1:1:9 S ACHSDX(ACHSX)="     ",ACHSPX(ACHSX)="    "
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 2 LINES
 ;F ACHSX=1:1:9 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,9,ACHS)) Q:'ACHS  S ACHSDX(ACHSX)=$P(^ICD9(+^(ACHS,0),0),U) S:ACHSDX(ACHSX)["." ACHSDX(ACHSX)=$P(ACHSDX(ACHSX),".")_$P(ACHSDX(ACHSX),".",2) S ACHSDX(ACHSX)=$E(ACHSDX(ACHSX)_"     ",1,5)
 F ACHSX=1:1:9 D
 .S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,9,ACHS)) Q:'ACHS  S ACHSDX(ACHSX)=$P($$ICDDX^ICDCODE(+^(ACHS,0),0),U,2) S:ACHSDX(ACHSX)["." ACHSDX(ACHSX)=$P(ACHSDX(ACHSX),".")_$P(ACHSDX(ACHSX),".",2) S ACHSDX(ACHSX)=$E(ACHSDX(ACHSX)_"     ",1,5)
 S ACHS=0
 ;3.1*15 3.4.2009 IHS/OIT/FCJ ADDED CSV CHANGES NXT 2 LINES, LINE WAS TOO LONG, ALSO CHGD LOOP VAR
 ;F ACHSX=1:1:3 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,10,ACHS)) Q:'ACHS  S ACHSPX(ACHSX)=$P(^ICD0(+^(ACHS,0),0),U) S:ACHSPX(ACHSX)["." ACHSPX(ACHSX)=$P(ACHSPX(ACHSX),".")_$P(ACHSPX(ACHSX),".",2) S ACHSPX(ACHSX)=$E(ACHSPX(ACHSX)_"    ",1,4)
 F X=1:1:3 S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,10,ACHS)) Q:'ACHS  S ACHSPX(X)=$P($$ICDOP^ICDCODE(+^(ACHS,0)),U,2) S:ACHSPX(X)["." ACHSPX(X)=$P(ACHSPX(X),".")_$P(ACHSPX(X),".",2) S ACHSPX(X)=$E(ACHSPX(X)_"    ",1,4)
 F ACHS=1,2 S ACHSY=ACHSDX(ACHS) I ACHSY]"     " D RECODE S ACHSAPC(ACHS)=ACHS("AC")
 Q
 ;
RECODE ; Code copied from APCPAPOV. Look up the RECODE APC/ICD value.
 S ACHS("AC")="   ",ACHS("ICD")=ACHSDX(ACHS)
 ; Weed out etiology codes
 I $E(ACHSY)="E" Q
 I $E(ACHSY)="." S ACHS("ICD")="10"_$P(ACHS("ICD"),".",2)_" ",ACHSY="10"_ACHSY,ACHSY=ACHSY-.000001,ACHSY=$P(ACHSY,".")_$P(ACHSY,".",2)_" " G HIGH
 S ACHS("ICD")="09"_($P(ACHS("ICD"),".")_$P(ACHS("ICD"),".",2))_" "
 I $E(ACHSY)="V" S ACHSY=(9_$E(ACHSY,2,9999)-.000001),ACHSY="09V"_$E(ACHSY,2,9999),ACHSY=$P(ACHSY,".")_$P(ACHSY,".",2)_" " G HIGH
 S ACHSY="09"_ACHSY-.000001,ACHSY="0"_($P(ACHSY,".")_$P(ACHSY,".",2))_" "
HIGH ;
 S ACHS("HIGH")=$O(^AUTTRCD("AH",ACHSY))
 I ACHS("HIGH")="" S ACHS("AC")=999 Q
 S ACHS("DA1")=$O(^AUTTRCD("AH",ACHS("HIGH"),""))
 I ACHS("DA1")="" Q  ;  Error in Recode x-ref
 S ACHS("DA2")=$O(^AUTTRCD("AH",ACHS("HIGH"),ACHS("DA1"),"")),ACHS("LOW")=$P(^AUTTRCD(ACHS("DA1"),11,ACHS("DA2"),0),U)_" "
 I ACHS("LOW")]ACHS("ICD") S ACHS("AC")=999 Q
 S ACHS("AC")=$P(^AUTTRCD(ACHS("DA1"),0),U)
 Q
 ;
TYPE(D) ;EP - D=DFN in ^AUPNPAT.  Return "I" if Indian, else "O"
 I $L($P($G(^AUPNPAT(D,0)),U,7)) Q "I" ; Tribal Enrollment Number
 I $P($G(^AUPNPAT(D,11)),U,8) Q "I" ; Tribe of Membership
 I $L($P($G(^AUPNPAT(D,11)),U,9)) Q "I" ; Tribe Quantum
 I $L($P($G(^AUPNPAT(D,11)),U,10)) Q "I" ; Indian Quantum
 S %=$P($G(^AUPNPAT(D,11)),U,11)
 I %,$P($G(^AUTTBEN(%,0)),U,2)="01" Q "I" ; Beneficiary is "01"
 Q "O"
 ;
AGE(Y) ;EP - Y=DFN in ^AUPNPAT.  Return age of pt in 2 digit numeric string.
 N ACHSAGE
 S ACHSAGE=$$AGE^AUPNPAT(Y)
 Q $E(ACHSAGE,$L(ACHSAGE)-1,$L(ACHSAGE))
 ;
INS(ACHSR) ;EP ACHSR=DFN in ^AUPNPAT.  Return if pt has MCaid, MCare, Pvt ins.
 N ACHS3C,ACHS3CFL,ACHSDEST,ACHSDOCR,ACHSINSR,ACHSMCD,ACHSTRAN,DA
 S ACHS3CFL=0,ACHSDEST=""
 D ^ACHSTX3C
 N A,B,C
 S (A,B,C)=" "
 F %=1:1 Q:'$D(ACHS3C(%))  D
 .I $E(ACHS3C(%),3,10)="MEDICAID" S A="Y" Q
 .I $E(ACHS3C(%),3,10)="MEDICARE" S B="Y" Q
 .S C="Y"
 .Q
 Q A_B_C
 ;
ZIP(D) ;EP - D=DFN in ^DPT.  Return Zip code of pt.
 S %=$P($G(^DPT(D,.11)),U,6),%=$P(%,"-")_$P(%,"-",2),%="000000000"_%
 Q $E(%,$L(%)-8,$L(%))
 ;
ADA(F,D) ;EP - F=DUZ(2), D=Document EIN.  Return ADA codes, fee, and units.
 ;
 ; B = ADA Codes (15)
 ; E = Total Fee Charged ($$$$$cc)
 ; C = ADA Units (15)
 ;
 N A,B,C,E
 S (B,C)="",E=0
 F %=0:0 S %=$O(^ACHSF(F,"D",D,11,%)) Q:'%  S A=^(%,0) I $P($P(A,U),";",2)="AUTTADA(" S X=$P($G(^AUTTADA(+A,0)),U),B=B_$S($L(X)=4:X,1:"    "),X="0000"_$P(A,U,4),X=$E(X,$L(X)-3,$L(X)),C=C_$S(+X:X,1:"    "),E=E+$P(A,U,6)
 S B=$E(B_$J("",60),1,60),C=$E(C_$J("",60),1,60)
 S X="00000"_$P(E,"."),X=$E(X,$L(X)-4,$L(X))
 S Y="00"_$P(E,".",2),Y=$E(Y,$L(Y)-1,$L(Y))
 S E=X_Y
 Q B_U_E_U_C
 ;
CPT(F,D) ;EP- ITSC/SET/JVK ACHS*3.1*11 ADDED FOR EXPORT OF CPT
 ;    F=DUZ(2), D=Document EIN.  Return CPT codes, fee, and units.
 ;
 ; B = CPT Codes (25)
 ; E = Total Unit Fee Charged (25) ($$$$$cc)
 ; C = CPT Units (25)
 ;
 N A,B,C,E
 S (B,C,E)=""
 F %=0:0 S %=$O(^ACHSF(F,"D",D,11,%)) Q:'%  S A=^(%,0) I $P($P(A,U),";",2)="ICPT(" S X=$P($G(^ICPT(+A,0)),U),B=B_$S($L(X)=5:X,1:"     "),X="00000"_$P(A,U,4),X=$E(X,$L(X)-3,$L(X)),C=C_$S(+X:X,1:"    "),J=$P(A,U,6)
 S X="00000"_$P(J,"."),X=$E(X,$L(X)-4,$L(X)),Y="00"_$P(J,".",2),Y=$E(Y,$L(Y)-1,$L(Y)),J=X_Y,E=E_J
 S B=$E(B_$J("",125),1,125),C=$E(C_$J("",100),1,100),E=$E(E_$J("",175),1,175)
 Q B_U_E_U_C
 ;
REV(F,D) ;EP -  ITSC/SET/JVK ACHS*3.1*11 ADDED FOR EXPORT OF REV 
 ;     F=DUZ(2), D=Document EIN.  Return REV codes, fee, and units.
 ;
 ; B = REV Codes (25)
 ; E = Total Unit Fee Charged (25)($$$$$cc)
 ; C = REV Units (25)
 ;
 N A,B,C,E
 S (B,C,E)=""
 F %=0:0 S %=$O(^ACHSF(F,"D",D,11,%)) Q:'%  S A=^(%,0) I $P($P(A,U),";",2)="AUTTREVN(" S X=$P($G(^AUTTREVN(+A,0)),U),B=B_$S($L(X)=3:X,1:"  "),X="000"_$P(A,U,4),X=$E(X,$L(X)-3,$L(X)),C=C_$S(+X:X,1:"    "),J=$P(A,U,6)
 S X="00000"_$P(J,"."),X=$E(X,$L(X)-4,$L(X)),Y="00"_$P(J,".",2),Y=$E(Y,$L(Y)-1,$L(Y)),J=X_Y,E=E_J
 S B=$E(B_$J("",75),1,75),C=$E(C_$J("",100),1,100),E=$E(E_$J("",175),1,175)
 Q B_U_E_U_C
 ;
