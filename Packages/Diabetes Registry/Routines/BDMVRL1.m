BDMVRL1 ; cmi/anch/maw - VIEW RECORD ACTION ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;;AUG 11, 2006
 ;
MP ;EP; -- view medication profile
 K BDMONLY
 S BDMVALM="BDMV MEDICATIONS"
 D VALM^BDMVRL(BDMVALM)
 Q
MP1 ;EP;TO PRINT DIABETES MEDS ONLY
 S BDMONLY=""
 S BDMVALM="BDMV MEDICATIONS"
 D VALM^BDMVRL(BDMVALM)
 K BDMONLY
 Q
OERR ;EP; -- view lab/rad results
 D REG^BDMFUTIL
 Q:$D(BDMQUIT)
 ; LORI, this will eventually be an entry point into an OE/RR rtn
 D MSG^BDMVU("SORRY, NOT READY YET!",2,1,1)
 D RETURN^BDMVU
 Q
 ;
PAUSE ; -- ask user to press RETURN when ready
 D RETURN^BDMVU
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
SURGP ;;
 ;;  1. Brief Operation Summary
 ;;  2. Operation Report
 ;;  3. Anesthesia Report
 ;;  4. Nurse Intraoperative Report
 ;;
MINIT ;EP;DISPLAY MED FROM THE V MED FILE
 K VALMCNT
 K ^TMP("BDMVR",$J)
 S VALMCNT=0
 N DATE,VMDA,X,Y,Z
 S DATE=0
 F  S DATE=$O(^AUPNVMED("AA",DFN,DATE)) Q:'DATE!$D(BDMQUIT)  D
 .S VMDA=0
 .F  S VMDA=$O(^AUPNVMED("AA",DFN,DATE,VMDA)) Q:'VMDA!$D(BDMQUIT)  D
 ..S X=$G(^AUPNVMED(VMDA,0))
 ..I $D(BDMONLY),'$D(BDMMEDS(+X)) Q
 ..D MEDDISP
 Q
MEDDISP ;DISPLAY EACH V MED ENTRY
 N Y,Z
 S Y=9999999-DATE
 S Z=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_(1700+$E(Y,1,3))
 S $E(Z,13)=$P($G(^PSDRUG(+X,0)),U)
 I 'X,$P(X,U,4) S Z=Z_$P(X,U,4)
 S Z=Z_"  QTY: "_$P(X,U,6)
 S Z=Z_"  DAYS: "_$P(X,U,7)
 I $P(X,U,8) D
 .S Y=$P(X,U,8)
 .X ^DD("DD")
 .S Z=Z_"  DC'D: "_Y
 D Z(Z)
 S Z=""
 S $E(Z,13)=$P(X,U,5)
 D Z(Z)
 Q
Z(X) ;SET TMP NODE
 S VALMCNT=VALMCNT+1
 S ^TMP("BDMVR",$J,VALMCNT,0)=X
 Q
