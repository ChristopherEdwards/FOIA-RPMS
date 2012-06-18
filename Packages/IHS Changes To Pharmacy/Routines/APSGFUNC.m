APSGFUNC ;IHS/ITSC/ENM - FUNCTIONS ; [ 07/05/2002  4:19 PM ]
 ;;4.5;Inpatient Medications;;NOV 20, 2000
 ;THIS ROUTINE IS A COPY OF ADGF
 ;V MEASUREMENT CALL ADDED 07/05/2002
 ;
HRCN() ;EP; -- IHS health record number
 ;searhc/maw 4/16/98 chart number terminal digit
 ;Q $P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),U,2)
 S HRCN=$P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),"^",2)
 S HRCN="000000"_HRCN,HRCN=$E(HRCN,$L(HRCN)-5,$L(HRCN))
 Q $E(HRCN,1,2)_"-"_$E(HRCN,3,4)_"-"_$E(HRCN,5,6)
 ;
HRC(DFN) ;EP; -- IHS health record number
 ;Q $P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),U,2)
 S HRCN=$P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),"^",2)
 S HRCN="000000"_HRCN,HRCN=$E(HRCN,$L(HRCN)-5,$L(HRCN))
 Q $E(HRCN,1,2)_"-"_$E(HRCN,3,4)_"-"_$E(HRCN,5,6)
 ;
SCCC() ;EP; -- state-county-community code (STCTYCOM index)
 N X I '$D(DFN)!('$D(^AUPNPAT(DFN,11))) Q "UNKOWN"
 S X=$P(^AUPNPAT(DFN,11),"^",17) I 'X Q "UNKNOWN"
 S X=$P(^AUTTCOM(X,0),"^",8) I 'X Q "UNKNOWN"
 S X=$E(X,5,7)_"-"_$E(X,3,4)_"-"_$E(X,1,2) Q X
 ;
HRN(DFN) ;EP; -- health record number with dashes
 N X I '$D(DFN)!('$D(DUZ(2))) Q "UNKNOWN"
 I '$D(^AUPNPAT(DFN,41,DUZ(2),0)) Q "UNKOWN"
 S X=$P(^AUPNPAT(DFN,41,DUZ(2),0),"^",2)
 I $L(X)=7 D  Q X
 . S X=$E(X,1,3)_"-"_$E(X,4,5)_"-"_$E(X,6,7)
 S X="00000"_X,X=$E(X,$L(X)-5,$L(X))
 S X=$E(X,1,2)_"-"_$E(X,3,4)_"-"_$E(X,5,6)
 Q X
 ;
 Q $TR("123-45-67","1234567",$P($G(^AUPNPAT(+DFN,41,+DUZ(2),0)),"^",2))
 ;
SHS ;EP; -- Health Summary set variables (used by patient inquiry--DGZPI)
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$E(Y,6,7)_""/""_$E(Y,2,3)"
 S APCHSPAT=DFN,APCHSCKP="",APCHSBRK="",APCHSNPG=0 Q
KHS ;EP; -- Health Summary kill variables
 K APCHSCVD,APCHSICF,APCHSCKP,APCHSNPG,APCHSPG,APCHSQIT,APCHSHDR
 K APCHSEGN,APCHSEGC,APCHSEGT,APCHSEGH,APCHSEGL,APCHSDLM,APCHSDLS
 K APCHSHD2,APCHSBRK,APCHSNDM,APCHSN,APCHSQ,APCHSPAT Q
 ;
HTWT ;IHS/ITSC/ENM 07/05/02 HT & WT FROM V MEASUREMENTS
 ;DFN NEEDED
 N BLHT,BLWT,BHT,BWT,BX
 S (WT,HT,HTDATE,WTDATE)=""
 S BHT=$O(^AUTTMSR("B","HT","")) Q:'BHT
 S BWT=$O(^AUTTMSR("B","WT","")) Q:'BWT
 S BX=$O(^AUPNVMSR("AA",DFN,BHT,0))
 I BX D
 .S HTDATE=9999999-BX
 .S BLHT=$O(^AUPNVMSR("AA",DFN,BHT,BX,0)) Q:'BLHT
 .S BLHT=$P($G(^AUPNVMSR(BLHT,0)),"^",4)
 .S Y=$J(2.54*BLHT,0,2),HT=Y
 .;S Y=$J(2.54*BLHT,0,2),HT=BLHT_"^"_Y
 S BX=$O(^AUPNVMSR("AA",DFN,BWT,0))
 I BX D
 .S WTDATE=9999999-BX
 .S BLWT=$O(^AUPNVMSR("AA",DFN,BWT,BX,0)) Q:'BLWT
 .S BLWT=$P($G(^AUPNVMSR(BLWT,0)),"^",4)
 .S Y=$J(BLWT/2.2,0,2),WT=Y
 .;S Y=$J(BLWT/2.2,0,2),WT=BLWT_"^"_Y
 Q
