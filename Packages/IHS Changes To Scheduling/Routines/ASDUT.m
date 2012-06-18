ASDUT ; IHS/ADC/PDW/ENM - FUNCTIONS ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
HRCN() ;EP; -- IHS health record number
 Q $P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),"^",2)
 ;
HRC(DFN) ;EP; -- IHS health record number
 Q $P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),U,2)
 ;
SCCC() ;EP -- state-county-community code (STCTYCOM index)
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
SHS ; -- Health Summary set variables (used by patient inquiry--DGZPI)
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$E(Y,6,7)_""/""_$E(Y,2,3)"
 S APCHSPAT=DFN,APCHSCKP="",APCHSBRK="",APCHSNPG=0 Q
KHS ; -- Health Summary kill variables
 K APCHSCVD,APCHSICF,APCHSCKP,APCHSNPG,APCHSPG,APCHSQIT,APCHSHDR
 K APCHSEGN,APCHSEGC,APCHSEGT,APCHSEGH,APCHSEGL,APCHSDLM,APCHSDLS
 K APCHSHD2,APCHSBRK,APCHSNDM,APCHSN,APCHSQ,APCHSPAT Q
 ;
PCP(DFN) ;EP; returns primary care provider name
 Q $$VAL^XBDIQ1(9000001,DFN,.14)
 ;
TD() ;EP; returns hrcn in terminal digit order
 S Y=$$HRN(DFN) Q $P(Y,"-",3)_$P(Y,"-",2)
 ;
DIV() ;EP; -- returns division ien
 Q $S($D(^DG(40.8,+$G(DIV),0)):DIV,1:+$O(^DG(40.8,"C",DUZ(2),0)))
 ;
ACTV(SDC) ;EP; -- returns 1 if clinic is active
 Q $S($P($G(^SC(SDC,"I")),U)="":1,$P(^("I"),U)>DT:1,$P(^("I"),U,2)'>DT:1,1:0)
 ;
FULLNM(DFN) ;EP; -- returns name first last
 NEW X S X=$P($P(^DPT(DFN,0),U)," ") Q $P(X,",",2)_" "_$P(X,",")
 ;
PC(SDC) ;EP; -- returns ien for princ clinic tied to sdc clinic
 Q $S($P($G(^SC(SDC,"SL")),U,5)]"":$P(^("SL"),U,5),1:-1)
 ;
SHORTRS() ;EP; -- returns 1 if short form of RS selected
 Q $S($P($G(^DG(40.8,$$DIV,"IHS")),U,2)="S":1,1:0)
 ;
HSTYP(SC,DFN) ;EP; -- returns health summary type
 NEW X,AGE,Y
 S X=$P($G(^SC(SC,9999999)),U,2) I X]"" Q X
 S AGE=$$VAL^XBDIQ1(2,DFN,.033)
 I AGE<15 Q $$PEDHS
 Q $$ADULTHS
 ;
PEDHS() ; -- returns ien for pediatric health summary 
 Q $O(^APCHSCTL("B","PEDIATRIC",0))
 ;
ADULTHS() ; -- returns ien for adult regular health summary
 Q $O(^APCHSCTL("B","ADULT REGULAR",0))
 ;
CONF() ;EP; -- returns confidential warning
 Q "Confidential Patient Data Covered by Privacy Act"
 ;
CONF1() ;EP; -- returns shortened confidential warning 
 Q "Confidential Patient Data"
 ;
TIME ;ENTRY POINT to print time only
 N X
 S X=$E($$HTFM^XLFDT($H),1,12)
 W $P($$FMTE^XLFDT(X,"2P")," ",2,3)
 Q
