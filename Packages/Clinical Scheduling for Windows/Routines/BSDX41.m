BSDX41 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;return Health Summary output
HS(BSDXY,DFN) ;Health Summary
 ;  DFN  = ien of VA PATIENT (^DPT) file 2
 ;Called by BSDX HEALTH SUMMARY remote procedure
 N BSDXI,BSDXSPSG
 D ^XBKVAR S X="ERROR^BSDXERR",@^%ZOSF("TRAP")
 S BSDXI=0
 K ^BSDXTMP($J)
 S BSDXY="^BSDXTMP("_$J_")"
 S ^BSDXTMP($J,0)="T00080ERRORID"_$C(30)
 I '+DFN D ERR^BSDXERR("Invalid Patient ID.") Q
 I '$D(^DPT(DFN,0)) D ERR^BSDXERR("Invalid Patient ID.") Q
 S APCHSPAT=$O(^AUPNPAT("B",DFN,0))
 I '+APCHSPAT D ERR^BSDXERR("Invalid Patient ID.") Q
 I $D(^DISV(DUZ,"APCHSCTL(")) S APCHSTYP=^DISV(DUZ,"APCHSCTL(")
 I $G(APCHSTYP)="",+$P($G(^APCCCTRL(DUZ(2),0)),U,3) S APCHSTYP=$P(^APCCCTRL(DUZ(2),0),U,3)
 I $G(APCHSTYP)="" D ERR^BSDXERR("Health Summary Type not defined in PCC Master Control file.") Q
 D SUPSEGS(.BSDXSPSG)
 ;
 S ^BSDXTMP($J,0)="T10000TEXT"_$C(30)
 S APCHSCKP="Q:$D(APCHSQIT)  S APCHSNPG=0 I $Y>(IOSL-3) "
 S APCHSBRK="D BREAK^BSDX41"
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 S:'$G(IO) IO="|TRM|:|"_$J
 S:'$G(IOM) IOM=80
 S:'$G(IOSL) IOSL=24
 ;collect header lines
 S %="" D NOW^%DTC S X=% X ^DD("FUNC",2,1) S APCHSTIM=X
 ;***** CONFIDENTIAL PATIENT INFORMATION --  DATE/TIME **************
 S APCHSHDR="CONFIDENTIAL PATIENT INFORMATION -- "_$$FMTE^XLFDT(DT,5)_$J(APCHSTIM,9)_"  ["_$P(^VA(200,DUZ,0),U,2)_"]"
 S X="",$P(X,"*",((80-6-$L(APCHSHDR))\2)+1)="*"
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=X_" "_APCHSHDR_" "_X_$C(30)
 S APCHSHD2=$P(^DPT(APCHSPAT,0),U)_" #"_$$HRN^AUPNPAT(APCHSPAT,DUZ(2))_" "_$$CWAD^AUPNLKID(APCHSPAT)_"("_$P(^APCHSCTL(APCHSTYP,0),U)_" SUMMARY)"  ;pg "_APCHSPG
 S X="",$P(X,"*",((80-6-$L(APCHSHD2))\2)+1)="*"
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=X_" "_APCHSHD2_" "_X_$C(30) S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(30)
 ;get segment data
 K APCHSQIT
 S BSDXQIET=1
 S APCHSEGN="",APCHSQ=""
 F  S APCHSEGN=$O(^APCHSCTL(APCHSTYP,1,"B",APCHSEGN)) Q:APCHSEGN=""  D
 . S APCHSEGT=$O(^APCHSCTL(APCHSTYP,1,"B",APCHSEGN,""))
 . D SEGMNT Q:$D(APCHSQIT)
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(31)
 Q
 ;
SEGMNT ; OUTPUT A SEGMENT TYPE
 S APCHSN=^APCHSCTL(APCHSTYP,1,APCHSEGT,0)
 S APCHSEGC=$P(APCHSN,U,2),APCHSEGH=$P(APCHSN,U,5)
 S APCHSEGP=^APCHSCMP(APCHSEGC,0)
 S APCHSEGC=$P(APCHSEGP,U,2)
 Q:'$G(BSDXSPSG($P(APCHSEGC,";",1),$P(APCHSEGC,";",2)))  ;check if segment converted
 S $P(APCHSEGC,";",2)="BSDX41"
 I APCHSEGH="" S APCHSVAR=$P(APCHSEGP,U,4) S:APCHSVAR]"" APCHSEGH=APCHSVAR
 I APCHSEGH="" S APCHSEGH=$P(APCHSEGP,U,1)
 S APCHSVAR=$P(APCHSEGP,U,5) I APCHSVAR]"",$D(^XUSEC(APCHSVAR,DUZ))[0 Q
 S APCHSN=^APCHSCTL(APCHSTYP,1,APCHSEGT,0) S APCHSNDM=$P(APCHSN,U,3),APCHSDLM=$P(APCHSN,U,4) S:APCHSNDM="" APCHSNDM=-1 ;S:APCHSNDM>0 APCHSNDM=APCHSNDM+1
 ;LIMIT OF TIME OR VISITS
 S APCHSDLS=""
 I APCHSDLM?1N.N!(APCHSDLM?1N.N1"D") S APCHSDLS=+APCHSDLM_" day"
 S:APCHSDLM?1N.N1"M" APCHSDLS=+APCHSDLM_" month",APCHSDLM=+APCHSDLM*30
 S:APCHSDLM?1N.N1"Y" APCHSDLS=+APCHSDLM_" year",APCHSDLM=+APCHSDLM*365
 S APCHSDLM=+APCHSDLM
 S:+APCHSDLS>1 APCHSDLS=APCHSDLS_"s"
 S APCHSEGL="" I APCHSNDM>0!(APCHSDLM>0) S APCHSEGL=" (max "_$S(APCHSNDM>0:APCHSNDM_$S(APCHSNDM=1:" visit",1:" visits")_$S(APCHSDLM>0:" or ",1:""),1:"")_$S(APCHSDLM>0:APCHSDLS,1:"")_")"
 K APCHSDLS,APCHSN
 I APCHSDLM'>0 S APCHSDLM=9999999
 E  S X1=DT,X2=-APCHSDLM D C^%DTC S APCHSDLM=9999999-X K X1,X2
 D @($P(APCHSEGC,";",1)_U_$P(APCHSEGC,";",2))
 Q
 ;
HEADER ;ENTRY POINT
 ;******* KETCHUP,LOIS  (CMED SUMMARY)  pg. 1 ********************
 S APCHSPG=APCHSPG+1
 S APCHSHD2=$P(^DPT(APCHSPAT,0),U)_" #"_$$HRN^AUPNPAT(APCHSPAT,DUZ(2))_" "_$$CWAD^AUPNLKID(APCHSPAT)_"("_$P(^APCHSCTL(APCHSTYP,0),U)_" SUMMARY)  pg "_APCHSPG  ;IHS/ANMC/LJF 4/30/99
 S APCHSP="",$P(APCHSP,"*",((IOM-6-$L(APCHSHD2))\2)+1)="*",APCHSP=APCHSP_" "_APCHSHD2_" "_APCHSP
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(30) S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=APCHSHDR_$C(30) S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=APCHSP_$C(30)
 Q
 ;
BREAK ;ENTRY POINT
 ;APCHSEGH IS THE COMPONENT TYPE FROM ^APCHSCMP, FROM SEGMNT ABOVE
 ;------- MEDICATIONS --------------------
 N QF
 S APCHSP="",$P(APCHSP,"-",+$G(IOM)-3-$L(APCHSEGH_APCHSEGL)/2)="",APCHSP=APCHSP_" "_APCHSEGH_APCHSEGL_" "_APCHSP
 I $Y'>(IOSL-5) D
 . S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(30) S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=APCHSP_$C(30) S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(30)
 . S QF=1
 I +$G(QF) Q
 S BSDXI=BSDXI+1 S ^BSDXTMP($J,BSDXI)=$C(30)
 X APCHSCKP
 Q
 ;
SUPSEGS(BSDXSPSG) ;build array of supported segments
 K BSDXSPSG
 ; BSDXSPSG(<TAG>,<ORIG ROUTINE>)=1
 S BSDXSPSG("ALLRG","APCHGMTS")=1    ;allergies
 S BSDXSPSG("DEMOG","APCHS1")=1      ;patient demographics
 S BSDXSPSG("EYERX","APCHS8A")=1     ;eye glass prescriptions
 S BSDXSPSG("FLOW","APCHS12")=1      ;flow sheet production
 S BSDXSPSG("HFACT","APCHS4A")=1     ;health factors
 S BSDXSPSG("HOS","APCHS6")=1        ;history of surgery
 S BSDXSPSG("INHOSP","APCHS2B")=1    ;in hospital encounters
 S BSDXSPSG("IMMUN","APCHS2")=1      ;immunizations
 S BSDXSPSG("INPT","APCHS2C")=1      ;hospitalization encounters
 S BSDXSPSG("INS","APCHS5")=1        ;insurance
 S BSDXSPSG("MCIS","APCHS9")=1       ;managed care MIS
 S BSDXSPSG("MEASP","APCHS2A")=1     ;measurement panels
 S BSDXSPSG("MEDSCURR","APCHS7")=1   ;current meds
 S BSDXSPSG("MRE","APCHS3C")=1       ;most recent examination
 S BSDXSPSG("MRL","APCHS3A")=1       ;most recent lab
 S BSDXSPSG("MRPTED","APCHS10")=1    ;most recent patient education
 S BSDXSPSG("MRR","APCHS3C")=1       ;most recent radiology
 S BSDXSPSG("OUTPT","APCHS2B")=1     ;outpatient encounters
 S BSDXSPSG("PROBA","APCHS40")=1     ;allergy problems
 S BSDXSPSG("REPHX","APCHS8")=1      ;reproductive history
 S BSDXSPSG("SCHENC","APCHS2D")=1    ;scheduled encounters
 ;S BSDXSPSG("SURV","APCHS11")=1      ;surveillance hard code   ;not supported yet; appears to use routines in APCHM series;
 S BSDXSPSG("TRTMT","APCHS8")=1      ;treatments
 ;these are not in the test scenario and have not been tested
 ;S BSDXSPSG("BIRTHM","APCHS8")=1     ;birth measurements*
 ;S BSDXSPSG("EKG","APCHS8A")=1       ;EKG summary*
 ;S BSDXSPSG("MEAS","APCHS2")=1       ;measurements*
 ;S BSDXSPSG("MEDSALL","APCHS7")=1    ;all meds*
 ;S BSDXSPSG("MEDSCHRN","APCHS7")=1   ;chronic meds*
 ;S BSDXSPSG("MEDSCHR1","APCHS7")=1   ;chronic meds; not DC'd*
 ;S BSDXSPSG("MEDSNDUP","APCHS7")=1   ;all meds, not duplicated*
 ;S BSDXSPSG("OFFHX","APCHS8")=1      ;offspring history*
 ;S BSDXSPSG("PTED","APCHS10")=1      ;patient education
 Q
 ;
ALLRG ;allergies
 G ALLRG^BSDX41C
BIRTHM ;birth measurements
 G BIRTHM^BSDX41E
DEMOG ;patient demographics
 G DEMOG^BSDX41A
EKG   ;EKG summary
 G EKG^BSDX41D
EYERX ;eye glass perscriptions
 G EYERX^BSDX41D
FLOW   ;flow sheet production
 G FLOW^BSDX41N
HFACT  ;health factors
 G HFACT^BSDX41B
HOS    ;history of surgery
 G HOS^BSDX41F
INHOSP ;InHospital Encounters
 G INHOSP^BSDX41I
INPT   ;hospitalization encounters
 G INPT^BSDX41I
IMMUN ;immunizations
 G IMMUN^BSDX41H
INS   ;insurance
 G INS^BSDX41B
MCIS  ;managed care MIS
 G MCIS^BSDX41J
MEAS  ;measurements
 G MEAS^BSDX41H
MEASP ;measurement panels
 G MEASP^BSDX41D
MEDSALL  ;all meds
 G MEDSALL^BSDX41G
MEDSCHRN ;chronic meds
 G MEDSCHRN^BSDX41G
MEDSCHR1 ;chronic meds; not DC'd
 G MEDSCHR1^BSDX41G
MEDSCURR ;current meds
 G MEDSCURR^BSDX41G
MEDSNDUP ;all meds; non duplicated
 G MEDSNDUP^BSDX41G
MRE   ;most recent examination
 G MRE^BSDX41K
MRL   ;most recent lab
 G MRL^BSDX41J
MRPTED ;most recent patient education
 G MRPTED^BSDX41L
MRR   ;most recent radiology
 G MRR^BSDX41K
OFFHX ;offspring history
 G OFFHX^BSDX41E
OUTPT    ;outpatient encounters
 G OUTPT^BSDX41I
PROBA ;allergy problems
 G PROBA^BSDX41C
PTED  ;patient education
 G PTED^BSDX41L
REPHX ;reproductive history
 G REPHX^BSDX41E
SCHENC ;scheduled encounters
 G SCHENC^BSDX41I
SURV   ;surveillance hard code
 G SURV^BSDX41M
TRTMT ;treatments
 G TRTMT^BSDX41E
 ;
 Q
 ;
FILL(PADS,CHAR=" ")
 N I
 S RET=""
 F I=1:1:PADS S RET=RET_CHAR
 Q RET
