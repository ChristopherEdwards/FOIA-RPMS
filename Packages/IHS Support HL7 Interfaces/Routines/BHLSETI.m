BHLSETI ; cmi/flag/maw - BHL Setup Incoming Messages ;
 ;;3.01;BHL IHS Interfaces with GIS;**1,16**;JUN 01, 2002
 ;
 ;this routine will drop through the HL7 Message Text File (#772) and
 ;pull the segments into a working area ^TMP("BHLIWRK",$J), it will
 ;then call the appropriate filing routine
 ;
 ;
MAIN ;-- this is the main routine driver
 D GVARS
 Q
 ;
GVARS ; setup global variables
 D ^XBKVAR
 S (AGHL7IN,BHLIN)=1  ;flag for other apps to know inbound
 S BHLERR="",BHLCNT=0
 S BHLFS=INDELIM
 S BHLECH=$E(INDELIMS,2,6)
 S FS=BHLFS
 S (BHLCS,CS)=$E(BHLECH,1),(BHLRS,RS)=$E(BHLECH,2)
 S BHLET=$P($G(INV("MSH9")),CS,2)
 S BHL("EVENT DATE")=$G(INV("EVN2"))
 S BHL("EVENT DATE")=$$HDATE^INHUT(BHL("EVENT DATE"),"T")
 S BHLRAP=$G(INV("MSH5"))
 S BHLSAP=$G(INV("MSH3"))
 S BHLSAF=$G(INV("MSH4"))
 S BHLRAF=$G(INV("MSH6"))
 S BHLUIF=$G(UIF)
 S BHLFILE="""^BHL""_BHLR_""I"""
 S BHLH=$H
 S BHLTMP="BHL(BHLR)"
 S BHLSTMP="BHL(BHLR,BHLPAR)"
 S BHLSSTMP="BHL(BHLR,BHLPAR,BHLSPAR)"
 S BHLERR="D TRAP^BHLERR"
 S BHLDIE="D DIE^BHLU"
 S BHLDIE4="D DIE4^BHLU"
 S BHLDIEM="D DIEM^BHLU"
 S BHLXKDIC="K DIC,DD,DO,DA"
 S BHLKW="K BHLERR(""WARNING"")"
 S BHLKSV="K APCDALVR S APCDALVR(""APCDVSIT"")=BHLVSIT,APCDALVR(""APCDPAT"")=BHLPAT"
 S APCDALVR("APCDAUTO")=""
 S APCDALVR("AUPNTALK")=""
 S APCDALVR("APCDANE")=""
 S BHLSITE=$O(^BHLSITE("B",DUZ(2),0))
 Q:$G(BHLNOST)  ;quit here when site parameters are not needed
 ;add an error if site parameter file is not setup
 I '$D(^BHLSITE(BHLSITE,0)) S BHLERCD="NOSITE" X BHLERR
 Q:$D(BHLERR("FATAL"))
 S BHLDVT=$S($G(^APCCCTRL(DUZ(2),0)):$P($G(^APCCCTRL(DUZ(2),0)),U,4),1:"I")
 S BHLDSC=$P($G(^BHLSITE(BHLSITE,1)),U,2)
 S BHLDPRV=$P($G(^BHLSITE(BHLSITE,1)),U,3)
 S BHLDLOC=$P($G(^BHLSITE(BHLSITE,1)),U,4)
 S BHLDADMT=$P($G(^BHLSITE(BHLSITE,2)),U)
 S BHLDDDMT=$P($G(^BHLSITE(BHLSITE,2)),U,2)
 S BHLDADS=$P($G(^BHLSITE(BHLSITE,2)),U,3)
 S BHLDDDS=$P($G(^BHLSITE(BHLSITE,2)),U,4)
 S BHLDWRD=""
 Q
 ;
EOJ ;EP - kill variables
 D EN^XBVK("BHL")
 D EN^XBVK("APCD")
 D EN^XBVK("AUPN")
 K CS,EID,FS,PIEN,RS,SEGCNT,SEX,SSN,VIEN
 K DIC,DR,DOB,AGHL7IN
 Q
 ;
