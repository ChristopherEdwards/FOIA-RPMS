PSJLIUTL ;BIR/MV-IV LM utilities modules ;25 APR 00 / 4:28 PM
 ;;5.0; INPATIENT MEDICATIONS ;**39,50,58,81,85**;16 DEC 97
 ;
 ; Reference to ^ORD(101 is supported by DBIA #872.
 ; Reference to ^PS(52.7 is supported by DBIA #2173.
 ; Reference to ^PS(52.6 is supported by DBIA# 1231.
 ; Reference to ^PS(55 is supported by DBIA #2191.
 ; Reference to ES^ORX8 is supported by DBIA #3632.
 ;
 ; NFI changes for FR#2@wrtdrg(drgt)
FLDNO(X,COL)    ; Display the number next to the field name.
 ;
 ; X=Text; COL=Column to start from
 ;
 S:'$D(PSJSTAR) PSJSTAR=""
 NEW PSJOLDOT S PSJOLDOT=P("OT") D GTOT^PSIVUTL(P(4))
 S X=$S((X="(3)"&(P("OT")="I")):" ",PSJSTAR[X:"*",1:" ")_X
 S PSJL=$$SETSTR^VALM1($S(($G(PSJHIS)&(ON'=PSJORD)):"",1:X),PSJL,COL,5)
 Q
 ;
LONG(Y,COL,LEN) ; Display long fields.
 ;
 ; Y=Text string; COL=Start prt at this col; LEN=Total lenght per line.
 ;
 N STRLEN,STR S STR="",STRLEN=1
 ; If string has no blank space.
 I $L(Y," ")=1,$L(Y)>LEN D  Q
 . S LINE=$L(Y)\LEN+$S($L(Y)#LEN:1,1:0)
 . F X=1:1:LINE-1 D
 . . S PSJL=$$SETSTR^VALM1($E(Y,STRLEN,LEN*X),PSJL,COL,LEN)
 . . D SETTMP^PSJLMPRU("PSJI",PSJL) S PSJL="",STRLEN=LEN*X+1
 . S PSJL=$$SETSTR^VALM1($E(Y,STRLEN,LEN*LINE),PSJL,COL,LEN)
 ;
 F X=1:1:$L(Y," ") D
 . I $L(STR)+$L($P(Y," ",X))>LEN D
 . . S PSJL=$$SETSTR^VALM1(STR,PSJL,COL,LEN)
 . . D SETTMP^PSJLMPRU("PSJI",PSJL) S (STR,PSJL)=""
 . S STR=STR_$P(Y," ",X)_" "
 S PSJL=$$SETSTR^VALM1(STR,PSJL,COL,LEN)
 Q
 ;
WRTDRG(DRGT) ; Print AD/SOL drugs for "backdoor" view.
 NEW DRGX,PSJIVIEN,PSJX
 F DRGX=0:0 S DRGX=$O(DRG(DRGT,DRGX)) Q:'DRGX  D
 . S (PSJIVIEN,X)=$G(DRG(DRGT,DRGX)) I DRGT="SOL",$P($G(^PS(52.7,+X,0)),U,4)]"" S $P(X,U,2)=$P(X,U,2)_" "_$P(^(0),U,4)
 . S PSJL="",PSJX=$S($P(X,U,2)]"":$P(X,U,2)_" "_$P(X,U,3)_" "_$P(X,U,4),1:"*** Undefined ***")
 . NEW PSJNF D NFIV^PSJDIN($S(DRGT="AD":52.6,1:52.7),+PSJIVIEN,.PSJNF)
 . S PSJX=PSJX_PSJNF("NF")
 . S PSJL=$$SETSTR^VALM1(PSJX,PSJL,8,72)
 . D SETTMP^PSJLMPRU("PSJI",PSJL)
 . ;PSJLMX is newed in AD^PSJLIVMD & AD^PSJLIVFD.  This var count # of ad/sol so we knows
 . ;which line to blink the Requested start/stop dates.
 . S PSJLMX=$G(PSJLMX)+1
 Q
 ;
WTPC ; Write provider comments.
 ;F PSIVX=0:0 S PSIVX=$O(^PS(53.45,PSIVUP,4,PSIVX)) Q:'PSIVX!$D(DUOUT)!$D(DTOUT)  S Y=$G(^PS(53.45,PSIVUP,4,PSIVX,0)) D LONG(Y,22,58) D SETTMP^PSJLMPRU("PSJI",PSJL) S PSJL=""
 I $G(PSJORD),PSJORD["P" F PSIVX=0:0 S PSIVX=$O(^PS(53.1,+PSJORD,12,PSIVX)) Q:'PSIVX!$D(DUOUT)!$D(DTOUT)  S Y=$G(^PS(53.1,+PSJORD,12,PSIVX,0)) D LONG(Y,22,58) D SETTMP^PSJLMPRU("PSJI",PSJL) S PSJL=""
 I $G(PSJORD),PSJORD'["P" F PSIVX=0:0 S PSIVX=$O(^PS(55,DFN,"IV",+PSJORD,5,PSIVX)) Q:'PSIVX!$D(DUOUT)!$D(DTOUT)  S Y=$G(^PS(55,DFN,"IV",+PSJORD,5,PSIVX,0)) D LONG(Y,22,58) D SETTMP^PSJLMPRU("PSJI",PSJL) S PSJL=""
 Q
 ;
TYPE() ; IV Type
 S X=$$CODES^PSIVUTL(P(4),53.1,53) S X=$S($E(X)="C":"CHEMO",1:X)_$S(P(23)'="":" ("_P(23)_")",1:"")_$S(P(5)=1:" (I)",P(5)=0:"(C)",1:"")
 Q X
 ;
STARTDT() ; Start Date
 S X="" I $D(PSIVNUM) S:P("DTYP") X=$S(P(17)="P"!(PSIVAC="PN"):" ",1:"*")_$S(P("DTYP")=1:"(12)",$E(P("OT"))="I":"(10)",1:"(8)")
 Q $$ENDTC^PSGMI(P(2))
 ;
STOPDT() ; Stop Date
 S X="" I $D(PSIVNUM) S:P("DTYP") X=$S(P(17)="P"!(PSIVAC="PN"):" ",1:"*")_$S(P("DTYP")=1:"(13)",$E(P("OT"))="I":"(11)",1:"(9)")
 Q $$ENDTC^PSGMI(P(3))
 ;
PROVIDER() ; Provider
 S X="" I $D(PSIVNUM),P("DTYP") S X=$S(PSIVAC="PN":" ",1:"*")_$S(P("DTYP")=1:"(14)",$E(P("OT"))="I":"(12)",1:"(10)") ;I P(17)="P",(+P("CLRK")=+P(6)) S X=""
 I $G(P(21))]"",$L($T(ES^ORX8)) N ESIG,ESIG1 S ESIG=P("NAT"),ESIG1=$$ES^ORX8(+P(21)_";1") S:ESIG1=1 ESIG="ES"
 S X=$S($P(P(6),U,2)]"":$E($P(P(6),U,2),1,23),1:"*** Undefined") S:$G(ESIG)]"" X=X_" ["_$$LOW^XLFSTR(ESIG)_"]"
 Q X
WDTE(Y) ; Format and print date.
 I 'Y S Y=""
 E  X ^DD("DD") S Y=$P(Y,"@")_" "_$P($P(Y,"@",2),":",1,2)
 Q Y
 ;
ACTIONS()          ;
 N DIC,X,Y
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 I Y="PSJI LM DISCONTINUE" Q $S(PSGACT["D":1,1:0)
 I Y="PSJI LM EDIT" Q $S(PSGACT["E":1,1:0)
 I Y="PSJI PC RENEWAL" Q $S(PSGACT["R":1,1:0)
 I Y="PSJI PC HOLD" Q $S(PSGACT["H":1,1:0)
 I Y="PSJI PC ONCALL" Q $S(PSGACT["O":1,1:0)
 I Y="PSJI LM VERIFY" Q $S(PSGACT["V":1,1:0)
 I Y="PSJ LM FLAG" Q $S(PSGACT["G":1,1:0)
 Q 1
 ;
ACT() ;
 NEW Y
 S Y=$P($G(^ORD(101,+$G(^ORD(101,DA(1),10,DA,0)),0)),U) I Y="" Q 0
 I $G(PSJHIDFG),(Y="PSJ LM NEW ORDER") Q 0
 I Y="PSJ LM NEW ORDER FROM PROFILE" Q $S($G(PSIVBR)="D ^PSIVOPT":1,1:0)
 Q 1
