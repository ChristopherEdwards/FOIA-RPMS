ACHSTX33 ; IHS/ADC/GTH - EXPORT DATA (4/9) - RECORD 3(PATIENT FOR AO/FI) ;
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**13**;JUN 11,2001
 ;ACHS*3.1*13 11/27/06 IHS/OIT/FCJ PULL INSURED FR CORRECT FILES
 ;
 ;To get a type 3 record:
 ;       NOT be both 638 AND parm209=true. either is ok, neither
 ;                                         is ok.
 ;       I, C, and S types only.  Not P, ZA, IP, or others.
 ;                                Note:  ZA and IP are already
 ;                                       filtered out by now
 ;       parm 2,11 = y
 ;       must have patient facility, chart num and patient num
 ;       which are stored as pieces 20, 21, and 22 of ACHSDOCR
 ;
 ;       the patient record must have updated since the last time
 ;       we transmitted it  ^AUPNPAT
 ;
 ;
 ;
 I ACHSF638="Y",ACHSF209 S RET=2 Q
 I ACHSTY="P" S RET=3 Q
 I 'ACHSF211 S RET=4 Q
 I '$P(ACHSDOCR,U,20) S RET=5 Q
 I '$P(ACHSDOCR,U,21) S RET=6 Q
 I '$P(ACHSDOCR,U,22) S RET=7 Q
 ;
 S ACHSPAT=$P(ACHSDOCR,U,22)
 I '$D(AUPNPAT(ACHSPAT,0)) S RET=8 Q
 ;
 I $P(^AUPNPAT(ACHSR,0),U,15)>$P(^AUPNPAT(ACHSR,0),U,16) S RET=9 Q
 ;
 ;
 ;!!!!! WHAT if reexporting??  I $D(ACHSREEX),$D(ACHS("REXNUM")),$P(^AUPNPAT(ACHSR,0),U,15)=$P(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0),U,1) G A2
 ;
 ;!!!!!!
 S ACHSFAC=$E(ACHSAFAC_$J("",6),1,6)
 ;
 S ACHSDOB="0000000"
 I +$P(^DPT(ACHSR,0),U,3) S ACHSDOB=$E($P(^(0),U,3),1,3)+1700,ACHSDOB=$E(ACHSDOB,2)_$E($P(^(0),U,3),2,7)
 S ACHSSEX=$E($P(^DPT(ACHSR,0),U,2)_" ")
 ;
 S ACHSNAME=$E($P(^DPT(ACHSR,0),U)_$J("",30),1,30)
 ;
 ;do they have other coverage?  default no, then look for it.
 S ACHSCOV="N" I $D(^AUPNMCR(ACHSR,0))!$D(^AUPNMRE(ACHSR,0))!$D(^AUPNPRVT(ACHSR,0))!$D(^AUPNMCD("AB",ACHSR)) S ACHSCOV="Y"
 ;
 ;
 F ACHSCOMM=0:0 Q:'$O(^AUPNPAT(ACHSR,51,ACHSCOMM))  S ACHSCOMM=$O(^(ACHSCOMM))
 I 'ACHSCOMM S ACHSCOMM=$J("",7) G A5
 S ACHSCOMM=$S($D(^AUPNPAT(ACHSR,51,ACHSCOMM,0)):$P(^(0),U,3),1:0)
 I 'ACHSCOMM S ACHSCOMM=$J("",7) G A5
 S ACHSCOMM=$S($D(^AUTTCOM(ACHSCOMM,0)):$E($P(^AUTTCOM(ACHSCOMM,0),U,8)_$J("",7),1,7),1:"")
 ;
 ;
A5 ;
 S ACHSSSN=$P(^DPT(ACHSR,0),U,9)
 I $L(ACHSSSN)'=9 S ACHSSSN=$J("",9)
 ;
 ;get the SSN verification pointer.  if not there, make sure it's null.
 ;if it IS there, change it to whats in ^AUTTSSN.
 S SSV=$P($G(^AUPNPAT(X,0)),U,23) S:'SSV SSV=""  I SSV S SSV=$P($G(^AUTTSSN(X,0)),U,1)
 ;
 S ACHSUPDT=$E($P(^AUPNPAT(ACHSR,0),U,16),2,7)
 I '$L(ACHSUPDT) S ACHSUPDT="000000"
 ;
 S ACHSRCT=ACHSRCT+1,ACHSRTYP(3)=ACHSRTYP(3)+1
 ;
 S ^ACHSTXPT(ACHSRCT)="3A"_ACHSFAC_$E(ACHSHRN+1000000,2,7)_ACHSDOB_ACHSSEX_TRIBE_ACHSNAME_ACHSCOV_ACHSCOMM_ACHSSSN_ACHSUPDT_$E($$SSV(ACHSR)_" ",1)_ACHSDEST
 ;
 S PMFF=^ACHSTXPT(ACHSRCT) D ^ACHSTX99
 ;
 S ACHSRCT=ACHSRCT+1,ACHSRTYP(3)=ACHSRTYP(3)+1
 I '$D(^DPT(ACHSR,.11)) S ^ACHSTXPT(ACHSRCT)="3B"_$J("",78) S PMFF=^ACHSTXPT(ACHSRCT) D ^ACHSTX99 G A7
 ;
 S ACHSADDR=$E($P(^DPT(ACHSR,.11),U)_$J("",30),1,30),ACHSCITY=$E($P(^DPT(ACHSR,.11),U,4)_$J("",20),1,20),X=$P(^DPT(ACHSR,.11),U,5),ACHSST=$S('X:"  ",1:$P(^DIC(5,X,0),U,2)),ACHSZIP=$E($P(^DPT(ACHSR,.11),U,6)_$J("",9),1,9),ACHSINSR=$J("",16)
 S X=""
A5A ;
 S X=$O(^AUPNPRVT(ACHSR,11,X))
 G A6:+X=0
 ;ACHS*3.1*13 11/27/06 IHS/OIT/FCJ PULL INSURED FR CORRECT FILES
 ;I $P($G(^AUPNPRVT(ACHSR,11,X,0)),U,4)="" G A5A
 ;S ACHSINSR=$E($P($G(^AUPNPRVT(ACHSR,11,X,0)),U,4)_$J("",16),1,16)
 S X1=$P($G(^AUPNPRVT(ACHSR,11,X,0)),U,8)
 I $P(^AUPNPRVT(ACHSR,0),U)=$P(^AUPN3PPH(X1,0),U,2) G A5A
 S ACHSINSR=$E($P(^AUPN3PPH(X1,0),U)_$J("",16),1,16)
 ;ACHS*3.1*13 11/27/06 IHS/OIT/FCJ END OF CHANGES
A6 ;
 S ^ACHSTXPT(ACHSRCT)="3B"_ACHSADDR_ACHSCITY_ACHSST_ACHSZIP_ACHSINSR_ACHSDEST,$P(^AUPNPAT(ACHSR,0),U,15)=DT
 S PMFF=^ACHSTXPT(ACHSRCT) D ^ACHSTX99
 ;
A7 ;
 D ^ACHSTX3C
 ;
 S RET=0
 Q
 ;
CHKPAT ;
 ;check the ^AUPNPAT file
 I $P(^AUPNPAT(ACHSR,0),U,15)>$P(^AUPNPAT(ACHSR,0),U,16) S RET=9 Q
 ;!!!!! WHAT if reexporting??    I $D(ACHSREEX),$D(ACHS("REXNUM")),$P(^AUPNPAT(ACHSR,0),U,15)=$P(^ACHSTXST(DUZ(2),1,ACHS("REXNUM"),0),U,1) G A2
 Q
 ;
SSV(X) ;EP - Given the pt's DFN, return the SSN verification status code.
 S X=$P($G(^AUPNPAT(X,0)),U,23)
 I 'X Q ""
 Q $P($G(^AUTTSSN(X,0)),U,1)
 ;
