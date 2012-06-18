SROAPCA2 ;B'HAM ISC/MAM - PRINT OPERATIVE DATA ; [ 09/19/00  9:12 AM ]
 ;;3.0; Surgery ;**38,71,95**;24 Jun 93
 S SRA(206)=$G(^SRF(SRTN,206))
 S SRA(207)=$G(^SRF(SRTN,207))
 S SRAO(1)=$P(SRA(207),"^")_"^365",SRAO(2)=$P(SRA(207),"^",2)_"^366",SRAO(3)=$P(SRA(207),"^",20)_"^416"
 S NYUK=$P(SRA(207),"^",3) D YN S SRAO(4)=SHEMP_"^367",NYUK=$P(SRA(207),"^",4) D YN S SRAO(5)=SHEMP_"^368"
 S NYUK=$P(SRA(207),"^",5) D YN S SRAO(6)=SHEMP_"^369",NYUK=$P(SRA(207),"^",6) D YN S SRAO(7)=SHEMP_"^370",NYUK=$P(SRA(207),"^",7) D YN S SRAO(8)=SHEMP_"^371"
 S NYUK=$P(SRA(207),"^",8) D YN S SRAO(9)=SHEMP_"^372",NYUK=$P(SRA(207),"^",9) D YN S SRAO(10)=SHEMP_"^373",NYUK=$P(SRA(207),"^",10) D YN S SRAO(11)=SHEMP_"^374"
 S NYUK=$P(SRA(207),"^",11) D YN S SRAO(12)=SHEMP_"^375",NYUK=$P(SRA(207),"^",12) D YN S SRAO("12A")=SHEMP_"^376",NYUK=$P(SRA(207),"^",13) D YN S SRAO("12B")=SHEMP_"^380"
 S NYUK=$P(SRA(207),"^",14) D YN S SRAO("12C")=SHEMP_"^377",NYUK=$P(SRA(207),"^",15) D YN S SRAO("12D")=SHEMP_"^381",NYUK=$P(SRA(207),"^",16) D YN S SRAO("12E")=SHEMP_"^378"
 S NYUK=$P(SRA(207),"^",17) D YN S SRAO("12F")=SHEMP_"^382",NYUK=$P(SRA(207),"^",18) D YN S SRAO("12G")=SHEMP_"^379",NYUK=$P(SRA(207),"^",19) D YN S SRAO("12H")=SHEMP_"^383"
 S X=$P($G(^SRF(SRTN,207.1)),"^"),SRAO("12H1")=X_"^383.1"
 S SRAO(13)=$P(SRA(206),"^",36)_"^450",SRAO(14)=$P(SRA(206),"^",37)_"^451",NYUK=$P(SRA(207),"^",22) D YN S SRAO(15)=SHEMP_"^441",NYUK=$P(SRA(207),"^",23) D YN S SRAO(16)=SHEMP_"^439"
 S SRAO(17)=$P(SRA(207),"^",24)_"^464",SRAO(18)=$P(SRA(207),"^",25)_"^465"
 S Y=$P(SRA(207),"^",26),C=$P(^DD(130,468,0),"^",2) D:Y'="" Y^DIQ S SRAO(19)=Y_"^468"
 S Y=$P(SRA(207),"^",27),C=$P(^DD(130,469,0),"^",2) D:Y'="" Y^DIQ S SRAO(20)=$E(Y,1,14)_"^469"
 W !!,"IV. OPERATIVE DATA",!," Incision Type: ",$P(SRAO(19),"^")
 W !," A. Cardiac Procedures Requiring Cardiopulmonary Bypass"
 W !,?4,"CABG Distal Anastomoses",?40,"Cardiac Transplant:",?72,$P(SRAO(10),"^")
 W !,?6,"Number with Vein:",?33,$P(SRAO(1),"^"),?40,"Electrophysiologic Procedure:",?72,$P(SRAO(11),"^")
 W !,?6,"Number with IMA:",?33,$P(SRAO(2),"^"),?42,"Misc. Cardiac Procedures"
 W !,?6,"Number with Radial Artery:",?33,$P(SRAO(17),"^"),?42,"ASD Repair: ",?72,$P(SRAO("12A"),"^")
 W !,?6,"Number with Other Artery:",?33,$P(SRAO(18),"^"),?42,"VSD Repair:",?72,$P(SRAO("12B"),"^")
 W !,?6,"Number with Other Conduit:",?33,$P(SRAO(3),"^"),?42,"Myxoma Resection:",?72,$P(SRAO("12C"),"^")
 W !,?4,"Aortic Valve Replacement:",?35,$P(SRAO(4),"^"),?42,"Foreign Body Removal:",?72,$P(SRAO("12D"),"^")
 W !,?4,"Mitral Valve Replacement:",?35,$P(SRAO(5),"^"),?42,"Myectomy for IHSS:",?72,$P(SRAO("12E"),"^")
 W !,?4,"Tricuspid Valve Replacement:",?35,$P(SRAO(6),"^"),?42,"Pericardiectomy:",?72,$P(SRAO("12F"),"^")
 W !,?4,"Valve Repair:",?35,$P(SRAO(7),"^"),?42,"Other Tumor Resection:",?72,$P(SRAO("12G"),"^")
 W !,?4,"LV Aneurysmectomy:",?35,$P(SRAO(8),"^"),?42,"Minimally Invasive Procedure: ",?72,$P(SRAO(15),"^")
 W !,?4,"Great Vessel Repair (Req CPB):",?35,$P(SRAO(9),"^"),?42,"Batista Procedure: ",?72,$P(SRAO(16),"^")
 W !,?4,"Total Ischemic Time (minutes): ",?35,$P(SRAO(13),"^"),?42,"Other Procedure(s):",?72,$P(SRAO("12H"),"^") W:$P(SRAO("12H1"),"^")'=""!($P(SRAO("12H"),"^")["Y") " *"
 W !,?4,"Total CPB Time (minutes): ",?35,$P(SRAO(14),"^"),?40,"Convert Off Pump to CPB: ",$P(SRAO(20),"^")
 I $P(SRAO("12H1"),"^")'=""!($P(SRAO("12H"),"^")["Y") S SRQ=0 W !,?4,"* Other Procedures List: " S X=$P(SRAO("12H1"),"^") W:$L(X)<53 X,! I $L(X)>52 S Z=$L(X) D
 .I X'[" " W X Q
 .S I=0,LINE=1 F  S SRL=$S(LINE=1:52,1:75) D  Q:SRQ
 ..I $E(X,1,SRL)'[" " W X,! S SRQ=1 Q
 ..S J=SRL-I,Y=$E(X,J),I=I+1 I Y=" " W ?($S(LINE=1:28,1:5)),$E(X,1,J-1),! S X=$E(X,J+1,Z),Z=$L(X),I=0,LINE=LINE+1 I Z<SRL W ?5,X,! S SRQ=1 Q
 I $Y+6>IOSL D PAGE^SROAPCA I SRSOUT Q
 K SRA,SRAO D ^SROAPCA3
 Q
YN ; store answer
 S SHEMP=$S(NYUK="NS":"NS",NYUK="N":"NO",NYUK="Y":"YES",1:"")
 Q
