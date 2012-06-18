SROAPCA1 ;BIR/MAM - PRINT CARDIAC CATH INFO ; [ 08/31/00  9:12 AM ]
 ;;3.0; Surgery ;**38,63,71,88,95**;24 Jun 93
 F I=200,206,208 S SRA(I)=$G(^SRF(SRTN,I))
 S SRAO(1)=$P(SRA(206),"^",24)_"^357",SRAO(2)=$P(SRA(206),"^",25)_"^358",SRAO(3)=$P(SRA(206),"^",26)_"^359",SRAO(4)=$P(SRA(206),"^",27)_"^360",SRAO(5)=$P(SRA(206),"^",28)_"^361",SRAO(6)=$P(SRA(206),"^",33)_"^362.1"
 S SRAO(7)=$P(SRA(206),"^",34)_"^362.2",SRAO(8)=$P(SRA(206),"^",35)_"^362.3",Y=$P(SRA(206),"^",9),C=$P(^DD(130,415,0),"^",2) D Y^DIQ S SRAO(10)=Y_"^415"
 S NYUK=$P(SRA(206),"^",30) D LV S SRAO(9)=SHEMP_"^363"
 I $Y+14>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !!,"II. CARDIAC CATHETERIZATION AND ANGIOGRAPHIC DATA"
 S Y=$P($G(^SRF(SRTN,207)),"^",21) I Y>1 D DT S Y=X
 D NS W !,?4,"Cardiac Catheterization Date: ",$E(Y,1,8)
 W !,?4,"LVEDP:",?30,$J($P(SRAO(1),"^"),3) W:$P(SRAO(1),"^")'="" " mm Hg" W ?44,"Left Main Stenosis:",?69,$J($P(SRAO(5),"^"),3) I $P(SRAO(5),"^")?1.3N W "%"
 W !,?4,"Aortic Systolic Pressure:",?30,$J($P(SRAO(2),"^"),3) W:$P(SRAO(2),"^")'="" " mm Hg" W ?44,"LAD Stenosis:",?69,$J($P(SRAO(6),"^"),3) I $P(SRAO(6),"^")?1.3N W "%"
 W !,?4,"*PA Systolic Pressure:",?30,$J($P(SRAO(3),"^"),3) W:$P(SRAO(3),"^")'="" " mm Hg" W ?44,"Right Coronary Stenosis:",?69,$J($P(SRAO(7),"^"),3) I $P(SRAO(7),"^")?1.3N W "%"
 W !,?4,"*PAW Mean Pressure:",?30,$J($P(SRAO(4),"^"),3) W:$P(SRAO(4),"^")'="" " mm Hg" W ?44,"Circumflex Stenosis:",?69,$J($P(SRAO(8),"^"),3) I $P(SRAO(8),"^")?1.3N W "%"
 W !,?4,"Mitral Regurgitation:",?30,$P(SRAO(10),"^")
 W !,?4,"LV Contraction Grade (from contrast or radionuclide angiogram or 2D Echo):",!,?7,"Grade",?17,"Ejection Fraction Range",?51,"Definition"
 W !,?8,$P(SRAO(9),"^")
 S Y=$P($G(^SRF(SRTN,1.1)),"^",3),C=$P(^DD(130,1.13,0),"^",2) D:Y'="" Y^DIQ S SRAO(2)=Y_"^1.13"
 S SRAO(1)=$P(SRA(206),"^",31)_"^364",SRAO(3)=$P($G(^SRF(SRTN,208)),"^",12)_"^414"
 S Y=$P(SRA(206),"^",32) D DT S SRAO("1A")=X_"^364.1"
 S Y=$P(SRAO(3),"^") I Y'="" S C=$P(^DD(130,414,0),"^",2) D Y^DIQ S $P(SRAO(3),"^")=Y
 S Y=$P(SRA(208),"^",13) D DT S SRAO("3A")=X_"^414.1",Y=$P($G(^SRF(SRTN,.2)),"^",2) D DT S SRAO(0)=X_"^.22"
 I $Y+14>IOSL D PAGE^SROAPCA I SRSOUT Q
 W !!,"III. OPERATIVE RISK SUMMARY DATA" S X=$P(SRAO(0),"^") I X'="" W ?40,"(Operation Began: "_X_")"
 W !,?5,"Physician's Preoperative" S Y=$P($G(^SRF(SRTN,.2)),"^",3) I Y'="" D DT W ?40,"(Operation Ended: "_X_")"
 W !,?7,"Estimate of Operative Mortality: "_$P(SRAO(1),"^") I $P(SRAO(1),"^")'=""&($P(SRAO(1),"^")'="NS") W "%"
 S X=$P(SRAO("1A"),"^") I X'="" W ?57,"("_X_")"
 W !,?5,"ASA Classification:",?35,$P(SRAO(2),"^"),!,?5,"Surgical Priority:",?35,$P(SRAO(3),"^") S X=$P(SRAO("3A"),"^") I X'="" W ?57,"("_X_")"
 S X=$P(^SRF(SRTN,"OP"),"^",2) I X S Y=$P($$CPT^ICPTCOD(X),"^",2) D SSPRIN^SROCPT S X=Y
 S X=$S(X'="":X,1:"CPT Code Missing")
 W !,?5,"Principal CPT Code: ",X,!,?5,"Other Procedures CPT Codes: "
 S CNT=32,OTH=0 F  S OTH=$O(^SRF(SRTN,13,OTH)) Q:'OTH  S CPT=$P($G(^SRF(SRTN,13,OTH,2)),"^") D
 .I CPT S Y=$P($$CPT^ICPTCOD(CPT),"^",2) S SRDA=OTH D SSOTH^SROCPT S CPT=Y
 .S:CPT="" CPT="NONE" S CNT=CNT+2
 .I CNT+$L(CPT)'>80 W:CNT>34 ";" W ?(CNT),CPT S CNT=CNT+$L(CPT) Q
 .W !,?34,CPT S CNT=34+$L(CPT)
 W !,?5,"Preoperative Risk Factors: "
 I $G(^SRF(SRTN,206.1))'="" S SRQ=0 S X=$G(^SRF(SRTN,206.1)) W:$L(X)<49 X,! I $L(X)>48 S Z=$L(X) D
 .I X'[" " W ?25,X Q
 .S I=0,LINE=1 F  S SRL=$S(LINE=1:48,1:80) D  Q:SRQ
 ..I $E(X,1,SRL)'[" " W X,! S SRQ=1 Q
 ..S J=SRL-I,Y=$E(X,J),I=I+1 I Y=" " W $E(X,1,J-1),!,?5 S X=$E(X,J+1,Z),Z=$L(X),I=0,LINE=LINE+1 I Z<SRL W X S SRQ=1 Q
 I $Y+20>IOSL D PAGE^SROAPCA I SRSOUT Q
 K SRA,SRAO D ^SROAPCA2
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
DT I 'Y S X="" Q
 S Z=$E($P(Y,".",2),1,4),Z=Z_"0000",Z=$E(Z,1,4),X=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)_" "_$E(Z,1,2)_":"_$E(Z,3,4)
 Q
NS S Y=$S(Y="NS":"No Study",1:Y)
 Q
LV K SHEMP S SHEMP=$S(NYUK="I":" I          > or = 0.55                    NORMAL",NYUK="II":"II             0.45-0.54                   MILD DYSFUNCTION",1:NYUK)
 Q:SHEMP'=NYUK  S SHEMP=$S(NYUK="III":"III           0.35-0.44                    MODERATE DYSFUNCTION",1:NYUK)
 Q:SHEMP'=NYUK  S SHEMP=$S(NYUK="IIIa":"IIIa          0.40-0.44                    MODERATE DYSFUNCTION A",1:NYUK)
 Q:SHEMP'=NYUK  S SHEMP=$S(NYUK="IIIb":"IIIb          0.35-0.39                    MODERATE DYSFUNCTION B",1:NYUK)
 Q:SHEMP'=NYUK  S SHEMP=$S(NYUK="IV":"IV            0.25-0.34                    SEVERE DYSFUNCTION",NYUK="V":" V             <0.25                       VERY SEVERE DYSFUNCTION",NYUK="NS":"NO LV STUDY",1:"")
 Q
