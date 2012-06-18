ASUJHIST ; IHS/ITSC/LMH -MARK TRANSACTION AS UPDATED ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine updates a successfully processed transaction's status
 ;flag to 'Updated', stores the date processed, and the balance on
 ;the master updated for both quantity and value after the transaction
 ;was posted.  For transaction code '3J' the account code from the
 ;master is also stored in the transaction.
 S ASUT(ASUT,"STATUS")="U",ASUT(ASUT,"DTP")=ASUK("DT","FM"),ASUTDA=ASUHDA
 S ASUT(ASUT,"MST","QTY")=$G(ASUMS("QTY","O/H")),ASUT(ASUT,"MST","VAL")=$G(ASUMS("VAL","O/H"))
 S ASUT(ASUT,"MST","D/I")=$G(ASUMS("D/I","QTY-TOT")),ASUT(ASUT,"DTE")=$P(ASUT(ASUT,"TRKY"),".") S:ASUT(ASUT,"TRKY")["." ASUT(ASUT,"DTE")=ASUT(ASUT,"DTE")_"."_$P(ASUT(ASUT,"TRKY"),".",2)
 S ASUJV=$S(ASUT="BOR":3,1:ASUJ)
 L +^ASUH(0):DTIME I '$T W !,"History file in use by another user try later!" S DA="" Q
 D HISTKEY L -^ASUH(0)
 D WRITE^ASU0TRWR(DA,"H") ;Write History transaction from variables
 S DA=ASUTDA,DIK="^ASUT("_ASUJV_","
 ;I ASUT("TRCD")'="4A" D ^DIK ;Delete old transaction
 K ASUJV
 I $G(ASUF("SV")) K ASUF("SV") Q
 D PSTKL^ASUCOKIL
 Q
HISTKEY ;EP ;GET HISTORY IEN
 N V,X,Y,Z S Z=ASUL(2,"STA","E#")_"-"_ASUK("DT","FM")_"-"_"9999999"
 S Y=($O(^ASUH("AA"),-1))+1,X=$O(^ASUH("B",Z),-1)
 I $E(X,1,14)=$E(Z,1,14) D
 .S V=($P(X,"-",3))+1
 .S V=(V*.000001)
 .S V=$P(V,".",2) S:$L(V)<6 V=V_$E("000000",1,(6-$L(V))) S $P(X,"-",3)=V
 E  D
 .S V="000001" S X=Z,$P(X,"-",3)=V
 S (ASUT(ASUT,"TRKY"),ASUH("KEY"))=X,DA=Y
 Q
ACCT ;EP ;UPDATE ACCOUNT
 S:ASUT(ASUT,"ACC")']"" ASUT(ASUT,"ACC")=$G(ASUMX("ACC"))
 S DR=DR_";.04///"_ASUT(ASUT,"ACC")_";4///"_ASUT(ASUT,"ACC")
 Q
