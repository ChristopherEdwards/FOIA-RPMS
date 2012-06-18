ACHSAS ; IHS/ITSC/PMF - SUPPLEMENTAL DOCUMENTS ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
A1 ; Setup environment.
 ;
 D ^ACHSUSC              ;DISPLAY DOC. CANCEL/SUPPLEMENT INFO
 I $D(DUOUT) D ENDC Q
 Q:'$D(ACHSDIEN)
 ;
 W !
 I '$$LOCK^ACHS("^ACHSF(DUZ(2),""D"",ACHSDIEN)","+") D ENDC Q
 ;
 ;
 S ACHSX=+$$DOC^ACHS(0,14)          ;GET FISCAL YEAR DIGIT
 D FYCVT^ACHSFU                     ;COMPUTE FISCAL YEAR
 S ACHSACFY=ACHSY,ACHSACWK=+ACHSFYWK(DUZ(2),ACHSACFY)
 D CKB^ACHSUUP                      ;CHECK BALANCES
 I $D(ACHSCNC) D END Q              ;QUIT IF BALANCES DONT CHECK
 ;
B2 ; Enter ammount of suplement.
 W !!,"Amount Of Supplement: "
 D READ^ACHSFU
 I $D(DTOUT) D ENDC Q
 G A1:$D(DUOUT)
 ;
 I Y?1"?".E W !,"  Enter The Amount To Be Added (e.g.  150.00)." G B2
 I Y="" W *7,"   NO AMOUNT ADDED",!!
 S:Y?1"$".E Y=$E(Y,2,99)
 F I=1:1 S F=$F(Y,",") Q:'F  S Y=$E(Y,1,F-2)_$E(Y,F,99)
 I '(Y?1N.N1"."2N!(Y?1N.N))!($L(Y)>10) W *7,"  ??" G A1
 ;
 S ACHSADAM=Y D OBLM^ACHSFU  ;CHECK IF OBLIGATION LIMIT FOR
 ;                           ;THIS TYPE DOC. IS EXCEEDED
 G:$D(DUOUT) B2
 ;
C ; Confirm data.
 S ACHSESDO=Y
 W "   ("
 S X=ACHSESDO
 D FMT^ACHS
 W ")"
 S Y=$$DIR^XBDIR("Y","Is everything correct","NO","","","",2)
 I $D(DIRUT) D ENDC Q
 G B2:$D(DUOUT)!('Y)
 ;
D1 ; Create internal transaction.
 D SBA                   ;CHECK FOR FUNDS AVAILABLE
 I $D(ACHSCNC) D ENDC Q  ;IS CANCEL FLAG SET?
 ;
 S T=DT_"^S^"_$G(DFN)_U_ACHSESDO
 ;
 D SB1                    ;CREATE TRANSACTION RECORD
 ;
END ;
 I '$D(ACHSCNC) W !!," ***  Document Updated  ***" D ACT^ACHSACT(ACHSDIEN,$$NOW^XLFDT,"<SUPPLEMENTAL>")
 I $$DOC^ACHS(2,7) S ACHSREF=$$DOC^ACHS(2,7) D AUTH^ACHSBMC K ACHSREF
ENDC ;
 I $G(ACHSDIEN),$$LOCK^ACHS("^ACHSF(DUZ(2),""D"",ACHSDIEN)","-")
 I $$DIR^XBDIR("E","Press RETURN...","","","","",1)
QUIT ; Kill vars, quit.
 K X,X1,X2
 Q
 ;
 ;SET THE TRANSACTION RECORD BYPASSING FILEMAN ???????
SB1 ;
 S X=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,0)),ACHSDCR=-1,LS=+$P(X,U,15),ACHSDCR=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,0)),U,19)
 I ACHSDCR<1 W !,"ERROR :Unknown DCR account number." Q
 S:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)) ^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)=$$ZEROTH^ACHS(9002080,100,100)
 S Y=$G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0))
S11 ;
 S M=$P(Y,U,3)+1,$P(Y,U,3)=M,$P(Y,U,4)=M
 G S11:$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M))
 S ^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)=Y,^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M,0)=T,^ACHSF(DUZ(2),"TB",DT,"S",ACHSDIEN,M)="",ACHSTIEN=M
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M,0),U,6)=LS+1,$P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,15)=LS+1
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M,0),U,11)=DUZ
 S ACHS("CHK")=0
 D SBAENT^ACHSUUP
 D SKILL:$D(ACHSCNC)
 D SBQ^ACHSUUP:$$PARM^ACHS(2,7)="Y"
 Q
 ;
SKILL ;
 S X=$P($G(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0)),U,3)
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0),U,3)=X-1
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",0),U,4)=X-1
 K ^ACHSF(DUZ(2),"D",ACHSDIEN,"T",M),^ACHSF(DUZ(2),"TB",DT,"S",ACHSDIEN,M)
 S $P(^ACHSF(DUZ(2),"D",ACHSDIEN,0),U,15)=LS
 Q
 ;
SBA ; Check for funds available.
 I '$$LOCK^ACHS("^ACHS(9,DUZ(2))","+") W !,"LOCK UNSUCCESSFUL, SBA^ACHSAS." S ACHSCNC="" Q
 S X=$G(^ACHS(9,DUZ(2),"FY",ACHSACFY,0))  ;
 S X1=$P(X,U,2)                       ;CURRENT ADVICE OF ALLOWANCE
 S X2=$P(X,U,3)                       ;TOTAL OBLIGATED FYTD
 I '$$LOCK^ACHS("^ACHS(9,DUZ(2))","-")
 I $$PARM^ACHS(2,2)="Y",ACHSACFY<ACHSCFY Q
 I X2+ACHSESDO>X1 W *7,!,"Funds are not available for this transaction",!,"Transaction Cancelled" S ACHSCNC=""
 Q
 ;
