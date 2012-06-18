BHSPMH1A ;IHS/MSC/MGH - Health Summary for Patient wellness handout ;27-May-2008 14:21;MGH
 ;;1.0;HEALTH SUMMARY COMPONENTS;**1,2**;March 17,2006
 ;===================================================================
 ;Taken from APCHPMH1 routine
 ;
 ;
MEDBLD ; EP - BUILD ARRAY OF MEDICATIONS
 ;
 K APCHSRXP,APCHSCOT
 N APCHSN,APCHSDTM,APCHSSTA,APCHSDYS,RX0,RX2,ST,ST0
 Q:'$D(^AUPNVMED(APCHSMX,0))
 S APCHSN=^AUPNVMED(APCHSMX,0)
 Q:'$D(^PSDRUG($P(APCHSN,U,1)))
 S APCHSDTM=-APCHSIVD\1+9999999  ;Visit date from V Med .03 field
 Q:$P(APCHSN,U,8)]""  ;date discontinued
 S APCHSRXP=$S($D(^PSRX("APCC",APCHSMX)):$O(^(APCHSMX,0)),1:0)  ;RX IEN
 I APCHSRXP>0 S RX0=^PSRX(APCHSRXP,0),RX2=^PSRX(APCHSRXP,2) I '$D(^PSRX(APCHSRXP,"STA")) D RXSTAT^BHSPMH1 Q:ST="EXPIRED"!(ST="CANCELLED")!(ST="DELETED")  ;CALCULATE RX STATUS
 I $G(APCHSRXP)'>0 S APCHSCOT=1  ;may be using COTS or med entered via PCC data entry
 I $P($G(^AUPNVMED(APCHSMX,12)),U,9)]"" S APCHSCOT=1  ;external key present
 S APCHSSTA=$P($G(^PSRX(APCHSRXP,0)),U,15)  ;Active? RX File status
 Q:$G(APCHSSTA)>10  ;status is expired, deleted or cancelled
 I $G(^PSRX(APCHSRXP,"STA"))>10 Q  ;Status is in "STA" node in V 7
 I $G(^PSRX(APCHSRXP,"STA"))=1 Q  ;NON-VERIFIED
 I $G(^PSRX(APCHSRXP,"STA"))=4 Q  ;DRUG INTERACTION
 S APCHSIG=""
 S APCHSIG=$P($G(APCHSN),U,5)
 D SIG  ;D ^BOMB ;get expanded sig
 S APCHSDYS=$P($G(APCHSN),U,7)  ;days supply
 ;Q:APCHSDYS=1  ;quit if only 1 day supply
 I $G(APCHSCOT)=1,$G(APCHSDYS)]"",$$FMDIFF^XLFDT(DT,APCHSDTM)>$G(APCHSDYS) Q
 Q:$P($G(^AUPNVMED(APCHSMX,0)),U,6)=1  ;quit if qty=1
 S APCHSMFX=$P(^PSDRUG(+APCHSN,0),U)  D  ;compare Drug File .01 field & V Med Name of Non Table Drug
 .Q:$P(APCHSN,U,4)=""
 .I $P($G(APCHSN),U,4)]"",$P($G(APCHSN),U,4)=$P(^PSDRUG(+APCHSN,0),U) Q
 .I $P($G(APCHSN),U,4)]"",$P($G(APCHSN),U,4)'=$P(^PSDRUG(+APCHSN,0),U) S APCHSMFX=$P(APCHSN,U,4)
 .Q
 I $G(APCHSM(APCHSMFX)) Q  ;quit if med already exists
 S APCHSM(APCHSMFX)=+APCHSN_U_APCHSDYS  ;PSDRUG ien^days supply
 I $G(APCHSRXP)>0 S $P(APCHSM(APCHSMFX),U,3)=APCHSRXP  ;^PSRX ien
 S $P(APCHSM(APCHSMFX),U,4)=$G(ST)  ;status from RXSTAT
 S $P(APCHSM(APCHSMFX),U,5)=$G(APCHSSGY)
 S APCHSMCT=APCHSMCT+1  ;number of active meds
 Q
 ;
SIG ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 S APCHSSGY="" F APCHSP=1:1:$L(APCHSIG," ") S X=$P(APCHSIG," ",APCHSP) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),"^",2) I $D(^(9)) S Y=$P(APCHSIG," ",APCHSP-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),"^",1)
 . S APCHSSGY=APCHSSGY_X_" "
 Q
