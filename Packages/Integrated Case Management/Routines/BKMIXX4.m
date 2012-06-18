BKMIXX4 ;PRXM/HC/CJS - IEN LOOKUP UTILITIES ; 05 Aug 2005  1:55 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
IMM(BKMN,XACT) ;IMMUNIZATION NAME TO IEN
 ;The variable BKMN, which is the name of the immunization is
 ;passed into the subroutine. This may be passed as a number or an
 ;alpha/numeric.  And the variable BKMIEN, which is the IEN is returned.
 ;If more than one IEN can be applied, an array called BKMIENX is
 ;created to contain all of the applicable IENs.
 K BKMIEN,BKMIENX,BKMN1
 I $G(XACT)=1 D
 .S BKMIEN=$O(^AUTTIMM("B",BKMN,0))
 .Q
 I BKMN?1.N D
 .S BKMIEN=$S('$D(^AUTTIMM(BKMN)):-1,1:BKMN)
 .Q
 I BKMN'?1.N D
 .S BKMN1=$E(BKMN,1,($L(BKMN)-1))
 .F  S BKMN1=$O(^AUTTIMM("B",BKMN1)) Q:BKMN1=""!($E(BKMN1,1,$L(BKMN))'=BKMN)  D
 ..S BKMIEN=$O(^AUTTIMM("B",BKMN1,0)),BKMIENX(BKMIEN)="",BKMIENX=$G(BKMIENX)+1
 .Q
 Q $S(BKMIENX>1:0,1:BKMIEN)
 ;
 ;
LAB(BKMN,XACT) ;LABORATORY TEST NAME TO IEN
 ;The variable BKMN, which is the name of the lab test is
 ;passed into the subroutine. This may be passed as a number or an
 ;alpha/numeric.  And the variable BKMIEN, which is the IEN is returned.
 ;If more than one IEN can be applied, an array called BKMIENX is
 ;created to contain all of the applicable IENs.
 K BKMIEN,BKMIENX
 I XACT=1 D
 .S BKMIEN=$O(^LAB(60,"B",BKMN,0))
 .Q
 I BKMN?1.N D
 .S BKMIEN=$S('$D(^LAB(60,BKMN)):-1,1:BKMN)
 .Q
 I BKMN'?1.N D
 .S BKMN1=$E(BKMN,1,($L(BKMN)-1))
 .F  S BKMN1=$O(^LAB(60,"B",BKMN1)) Q:BKMN1=""!($E(BKMN1,1,$L(BKMN))'=BKMN)  D
 ..S BKMIEN=$O(^LAB(60,"B",BKMN1,0)),BKMIENX(BKMIEN)="",BKMIENX=$G(BKMIENX)+1
 .Q
 Q $S(BKMIENX>1:0,1:BKMIEN)
 ;
LOINC(BKMN) ;LABORATORY TEST LOINC TO IEN
 ;The variable BKMN, which is the LOINC number of the lab test is
 ;passed into the subroutine. This may be passed as a number or an
 ;alpha/numeric.  And the variable BKMIEN, which is the IEN is returned.
 ;If more than one IEN can be applied, an array called BKMIENX is
 ;created to contain all of the applicable IENs.
 K BKMIEN,BKMIENX I BKMN?1.N D
 .S BKMIEN=$S('$D(^LAB(60,"AF",BKMN,0)):-1,1:$O(^LAB(60,"AF",BKMN,0)))
 .Q
 I BKMN'?1.N D
 .S BKMN1=$E(BKMN,1,($L(BKMN)-1))
 .F  S BKMN1=$O(^LAB(60,"AF",BKMN1)) Q:BKMN1=""!($E(BKMN1,1,$L(BKMN))'=BKMN)  D
 ..S BKMIEN=$O(^LAB(60,"AF",BKMN1,0)),BKMIENX(BKMIEN)="",BKMIENX=$G(BKMIENX)+1
 .Q
 Q $S(BKMIENX>1:0,1:BKMIEN)
 ;
MEDS(BKMN,XACT) ;DRUG NAME TO IEN
 ;The variable BKMN, which is the name of the medication is
 ;passed into the subroutine. This may be passed as a number or an
 ;alpha/numeric.  And the variable BKMIEN, which is the IEN is returned.
 ;If more than one IEN can be applied, an array called BKMIENX is
 ;created to contain all of the applicable IENs.
 K BKMIEN,BKMIENX
 I XACT=1 D
 .S BKMIEN=$O(^PSDRUG("B",BKMN,0))
 .Q
 I BKMN?1.N D
 .S BKMIEN=$S('$D(^PSDRUG(BKMN)):-1,1:BKMN)
 .Q
 I BKMN'?1.N D
 .S BKMN1=$E(BKMN,1,($L(BKMN)-1))
 .F  S BKMN1=$O(^PSDRUG("B",BKMN1)) Q:BKMN1=""!($E(BKMN1,1,$L(BKMN))'=BKMN)  D
 ..S BKMIEN=$O(^PSDRUG("B",BKMN1,0)),BKMIENX(BKMIEN)="",BKMIENX=$G(BKMIENX)+1
 .Q
 Q $S(BKMIENX>1:0,1:BKMIEN)
BMI(X,Y) ;Calculate Body Mass Index
 ;The variable X is the weight in pounds
 ;The variable Y is the height in inches
 N BKMBMI
 S BKMBMI=(X/(Y*Y))*703,BKMBMI=(BKMBMI*10)\1/10
 Q BKMBMI
 ; This routine will pad a variable in the front or back, using
 ; any character that you specify; to the desired length.
 ; VAR is the string of characters that you would like to pad.
 ; FB indicates if you want to pad at the front or back of the string VAR.
 ; An FB value of "<" indicates that you want to pad at the front.
 ; An FB value of ">" indicates that you want to pad at the back.
 ; CHAR indicates the character that you want to use to pad the variable VAR with.
 ; LEN indicates the length that you want to pad the variable VAR to.
 ; 
 ; The value is returned extrinsically.
PAD(VAR,FB,CHAR,LEN) ;EP
 N PAD
 S $P(PAD,CHAR,LEN+1)=""
 I $L(VAR)>LEN Q $E(VAR,1,LEN)
 I FB="<" Q $E(PAD,1,LEN-$L(VAR))_VAR
 I FB=">" Q VAR_$E(PAD,1,LEN-$L(VAR))
 Q $E(VAR,1,LEN)
PROMPT(PAR,OPTS,OPTA,FIRST,SECOND) ;EP
 ; INPUT
 ;   PAR - Parameter for piece 1 of DIR(0)
 ;   OPTS - Array passed by reference containing the option names that
 ;          ^DIR will display
 ;   OPTA - DIR("A") value for prompt to user
 ;   FIRST - Do we execute the first prompt? $$PROMPT^BKMIXX4
 ;   SECOND - Do we execute the second prompt? 
ENT N STOP
 S STOP=0
 I FIRST D
 .S Y=$$PROMPT2^BKMIXX4(PAR,.OPTS,OPTA)
 .I $G(Y)?1."^"!('$G(Y))!($G(Y)<0) S Y=-1,STOP=1
 I STOP Q 1_U_Y
 S SEL=Y
 S HIVTAX=$S(Y=1:1,1:0)
 I 'SECOND Q 0_U_SEL
 I 'FIRST D
 .S HIVTAX=0,ENDDATE=DT,BEGDATE=ENDDATE-10000
 .S ENDDT=$$FMTE^XLFDT(ENDDATE),BEGDT=$$FMTE^XLFDT(BEGDATE)
 S DIR(0)="DO",DIR("A")="Beginning date",DIR("B")=BEGDT
 D ^DIR
 ;Q:Y?1."^" 1
 I $D(DTOUT)!$D(DUOUT) Q 1
 W " ("_$$FMTE^XLFDT(Y)_")" H 1
 S NOW=$P($$NOW^XLFDT,".")
 I (Y>NOW) W !!,"Beginning date can not be after today's date.",! G ENT
 S BEGDATE=Y
 S DIR(0)="DO",DIR("A")="Ending date",DIR("B")=ENDDT
 D ^DIR
 ;Q:Y?1."^" 1
 I $D(DTOUT)!$D(DUOUT) Q 1
 W " ("_$$FMTE^XLFDT(Y)_")" H 1
 S ENDDATE=Y
 I (ENDDATE<BEGDATE)!(ENDDATE>NOW) W !!,"End date can not be before beginning date or after today's date.",! K BEGDATE,ENDDATE G ENT
 ;PRXM/HC/BHS - 9/27/2005 - Remove conversion to $H format
 ;S BEGDATE=+$$FMTH^XLFDT(BEGDATE),ENDDATE=+$$FMTH^XLFDT(ENDDATE)
 ;I Y'=0 S BEGDATE=+$$FMTH^XLFDT(BEGDATE),ENDDATE=+$$FMTH^XLFDT(ENDDATE)
 Q 0_U_SEL
PROMPT2(PAR,OPTS,OPTA,HELP) ;EP
 N OPTNUM
 K BEGDATE,ENDDATE,HIVTAX
 S HIVTAX=1,ENDDATE=DT,BEGDATE=ENDDATE-10000
 S ENDDT=$$FMTE^XLFDT(ENDDATE),BEGDT=$$FMTE^XLFDT(BEGDATE)
 K DIR
 S OPTNUM=0,DIR(0)=$S($G(OPTS(1))="":PAR,$G(OPTS(1))'="":PAR_"^",1:PAR_"^"),DIR("A")=OPTA,ERR=0
 I $G(HELP)'="" S DIR("?")=HELP
 F  S OPTNUM=$O(OPTS(OPTNUM)) Q:OPTNUM=""!(ERR)  D
 .S OPTTEXT=$G(OPTS(OPTNUM))
 .I $L(DIR(0))+$L(OPTNUM)+$L(OPTTEXT)+2>245 S ERR=1 Q
 .S DIR(0)=DIR(0)_OPTNUM_":"_OPTTEXT_";"
 I ERR Q "^"
 D ^DIR
 K DIR
 Q Y
 ;
DATEPRMP() ;
 S %DT="AEPX",%DT("A")="Enter Beginning Date: "
 D ^%DT
 Q:Y'>0 0
 S BEGDATE=+Y  W " ("_$$FMTE^XLFDT(Y)_")"
 S %DT("A")="Enter Ending Date: "
 D ^%DT
 Q:Y'>0 0
 S ENDDATE=+Y
 K %DT
 Q 1
 ;
DX(PROMPT,MULT) ; EP - Prompt for dx
 ; PROMPT - Optional - if it exists will replace DIR("A")
 ; MULT - Optional - 0/1 if 1 - loop for multiple selection, else singular
 N DIR,STOP,DXFLTR,X,Y,VALS,II,CODES,DXDESC,DUOUT,DTOUT,NVALS
 S STOP=0,(DXFLTR,DXDESC)="",VALS=$P($G(^DD(90451.01,2.3,0)),U,3)
 ; Translate E* codes to other mnemonics per IHS - Tucson 9/9/2005
 ; EI = IN, EU = UNK, EO = OCC, EN = NON
 ; Build code list
 S CODES=""
 F II=1:1:$L(VALS,";")-1 S CODES=CODES_","_$P($P(VALS,";",II),":",1)
 ; Update NVALS to reflect the display values
 S NVALS=""
 F II=1:1:$L(VALS,";")-1 D
 . S CODE=$P($P(VALS,";",II),":",1),DESC=$P($P(VALS,";",II),":",2)
 . S CODE=$S(CODE="EU":"UNK",CODE="EI":"IN",CODE="EN":"NON",CODE="EO":"OCC",1:CODE)
 . S NVALS=$S(NVALS="":CODE_":"_DESC_";",1:NVALS_CODE_":"_DESC_";")
 S DIR("A")=$S($G(PROMPT)'="":$G(PROMPT),1:"Select Register Diagnosis")
 S DIR("B")="ALL"
 F  D  Q:STOP!(DXFLTR="^")!('+$G(MULT))
 .K X,Y
 .;S DIR(0)="SO^"_VALS_"ALL:ALL"
 .S DIR(0)="SO^"_NVALS_"ALL:ALL"
 .I DXFLTR'="" K DIR("B") S DIR("A")=$S($G(PROMPT)'="":$G(PROMPT),1:"Select Another Register Diagnosis")
 .D ^DIR
 .I $D(DTOUT)!$D(DUOUT) S DXFLTR="^" Q
 .I (Y="")&(DXFLTR="") S DXFLTR="^" Q
 .I (Y="")&(DXFLTR'="") S STOP=1 Q
 .; ALL
 .I Y="ALL" S DXFLTR=CODES,DXDESC="ALL",STOP=1 Q
 .I (DXFLTR_",")'[(","_$S(Y="UNK":"EU",Y="IN":"EI",Y="OCC":"EO",Y="NON":"EN",1:Y)_",") D
 ..S DXFLTR=DXFLTR_","_$S(Y="UNK":"EU",Y="IN":"EI",Y="OCC":"EO",Y="NON":"EN",1:Y)
 ..S DXDESC=$S(DXDESC'="":DXDESC_","_$S(Y(0)?1"AT RISK".E:"AT RISK-"_Y,1:Y(0)),1:$S(Y(0)?1"AT RISK".E:"AT RISK-"_Y,1:Y(0)))
 ..; Update desc if user has selected all one at a time
 ..I $L(DXFLTR,",")=$L(CODES,",") S DXDESC="ALL",STOP=1 Q
 ..; Update selection list to indicate (SELECTED)
 ..;F II=1:1:$L(VALS,";")-1 I $P($P(VALS,";",II),":",1)=Y S $P(VALS,";",II)=Y_":"_$P($P(VALS,";",II),":",2)_" (SELECTED)"
 ..F II=1:1:$L(NVALS,";")-1 I $P($P(NVALS,";",II),":",1)=Y S $P(NVALS,";",II)=Y_":"_$P($P(NVALS,";",II),":",2)_" (SELECTED)"
 Q $S(DXFLTR'="^":DXFLTR_","_U_DXDESC,1:"^")
 ;
