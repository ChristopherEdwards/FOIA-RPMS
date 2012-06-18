PSSJORDF ;BIR/MV-RETURN MED ROUTES(MR) AND INSTRUCTIONS(INS) ;06-Jan-2004 07:15;PLS
 ;;1.0;PHARMACY DATA MANAGEMENT;**5,13,34,38,69**;9/30/97
 ;;
 ;* PSJORD is the Orderable Item IEN pass to Pharmacy by OE/RR.
 ;* 1. If the dosage form is valid, this routine will return all med
 ;*    routes and instructions associated with that dose form.
 ;* 2. If the dose form is null, this routine will return all med routes
 ;*    that exist in the medication routes file.
 ;* 3. ^TMP format:
 ;*    ^TMP("PSJMR",$J,#)=MED ROUTE^MED ROUTE ABREVATION^IEN^OUTPATIENT
 ;*                       EXPANSION^IV FLAG
 ;*    ^TMP("PSJNOUN",$J,D0)=NOUN^VERB^PREPOSITION
 ;*    ^TMP("PSJSCH",$J)=DEFAULT SCHEDULE NAME
 ;
 ; Modified - IHS/CIA/PLS - 01/06/04 - Line Start+2
START(PSJORD,PSJOPAC) ;
 NEW MR,MRNODE,INS,PSJDFNO,X,MCT,Z,PSJOISC
 S PSJOPAC=$G(PSJOPAC,"")  ; IHS/CIA/PLS - 01/06/04 - Prevent UNDEF error
 I '+PSJORD D MEDROUTE Q
 S PSJDFNO=+$P($G(^PS(50.7,+PSJORD,0)),U,2)
 ;S ^TMP("PSJSCH",$J)=$P($G(^PS(50.7,+PSJORD,0)),"^",8) ;default schedule
 S PSJOISC=$P($G(^PS(50.7,+PSJORD,0)),"^",8)
 I $G(PSJOPAC)="O"!(PSJOPAC="X") D:$G(PSJOISC)'="" EN^PSSOUTSC(.PSJOISC) S:$G(PSJOISC)'="" ^TMP("PSJSCH",$J)=$G(PSJOISC) G SCPASS
 I $G(PSJOISC)'="" D EN^PSSGSGUI(.PSJOISC,"I") S:$G(PSJOISC)'="" ^TMP("PSJSCH",$J)=$G(PSJOISC)
SCPASS ;
 I $G(^PS(50.606,PSJDFNO,0))="" D NOD Q:$D(^TMP("PSJMR",$J,1))  D MEDROUTE Q
 K ^TMP("PSJMR",$J),^TMP("PSJNOUN",$J)
 D DF
 Q
 ;
DF ;* Loop thru DF node to find all available med routes, nouns, and instructions.
 N VERB,MR,INS,X
 S (MR,INS,X,MCT)=0
 S VERB=$P($G(^PS(50.606,PSJDFNO,"MISC")),U)
 S MR=+$P($G(^PS(50.7,+PSJORD,0)),"^",6) I MR,$D(^PS(51.2,MR,0)),$P($G(^(0)),"^",4)=1 S ^TMP("PSJMR",$J,1)=$P(^PS(51.2,MR,0),"^")_U_$P(^(0),"^",3)_U_MR_U_$P(^(0),"^",2)_U_$S($P(^(0),"^",6):1,1:0),MCT=MCT+1
 S MR=0 F  S MR=$O(^PS(50.606,PSJDFNO,"MR",MR)) Q:'MR  D
 .  S X=+$G(^PS(50.606,PSJDFNO,"MR",MR,0)) Q:'X!($P($G(^TMP("PSJMR",$J,1)),"^",3)=X)
 .  S MRNODE=$G(^PS(51.2,X,0))
 .  I $P($G(MRNODE),"^",4)'=1 Q
 .  S MCT=MCT+1,^TMP("PSJMR",$J,MCT)=$P(MRNODE,U)_U_$P(MRNODE,U,3)_U_X_U_$P(MRNODE,U,2)_U_$S($P(MRNODE,U,6):1,1:0)
 S X=0
 ;F  S INS=$O(^PS(50.606,PSJDFNO,"INS",INS)) Q:'INS  S X=X+1,^TMP("PSJINS",$J,X)=VERB_U_$G(^PS(50.606,PSJDFNO,"INS",INS,0))
 ;I '$D(^TMP("PSJINS",$J)),VERB]"" S ^TMP("PSJINS",$J,1)=VERB
 S X=0
 I $D(^PS(50.606,PSJDFNO,"NOUN")) F Z=0:0 S Z=$O(^PS(50.606,PSJDFNO,"NOUN",Z)) Q:'Z  S X=X+1,^TMP("PSJNOUN",$J,X)=$P($G(^PS(50.606,PSJDFNO,"NOUN",Z,0)),U)_U_$P($G(^PS(50.606,PSJDFNO,"MISC")),U)_U_$P($G(^("MISC")),U,3)
 Q
 ;
MEDROUTE ;* Return all med routes in the med routes file.
 S (MR,MCT)=0 K ^TMP("PSJMR",$J)
 F  S MR=$O(^PS(51.2,MR)) Q:'MR  S MRNODE=^PS(51.2,MR,0) I $P(^PS(51.2,MR,0),"^",4)=1 S MCT=MCT+1,^TMP("PSJMR",$J,MCT)=$P(MRNODE,U)_U_$P(MRNODE,U,3)_U_MR_U_$P(MRNODE,U,2)_U_$S($P(MRNODE,U,6):1,1:0)
 Q
NOD K ^TMP("PSJMR",$J)
 S MR=+$P($G(^PS(50.7,+PSJORD,0)),"^",6) I MR,$D(^PS(51.2,MR,0)),$P(^PS(51.2,MR,0),"^",4)=1 S ^TMP("PSJMR",$J,1)=$P(^PS(51.2,MR,0),"^")_U_$P(^(0),"^",3)_U_MR_U_$P(^(0),"^",2)_U_$S($P(^(0),"^",6):1,1:0)
 Q
