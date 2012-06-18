DG1010S2 ;ALB/MRL - SUPPLEMENTAL DATA SHEET FOR 10-10 (CONT) ; 8/25/00 10:16am
 ;;5.3;Registration;**343,342**;Aug 13, 1993
 ;;MAS VERSION 5.1;
 F I=.321,.52,.21,.53 S DGP(I)=$G(^DPT(DFN,I))
 S DGD=DGP(.321) F I=1:1:3 S DGD(I)=$S($P(DGD,U,I)="Y":"YES",$P(DGD,U,I)="N":"NO",1:"UNKNOWN") S:$P(DGD,U,I)'="Y" DGD(I)=DGD(I)_"^NOT APPLICABLE^NOT APPLICABLE^NOT APPLICABLE^NOT APPLICABLE" I $P(DGD,U,I)="Y" D UP
 S DGD=DGP(.52),I=3 F I1=5,11 S I=I+1,DGD(I)=$S($P(DGD,U,I1)="Y":"YES",$P(DGD,U,I1)="N":"NO",1:"UNKNOWN") S:$P(DGD,U,I1)'="Y" DGD(I)=DGD(I)_"^NOT APPLICABLE^NOT APPLICABLE^NOT APPLICABLE^NOT APPLICABLE" I $P(DGD,U,I1)="Y" D UP
 N LL
 S DGD=DGP(.53),I=5 F I2=1:1:3 S I=I+1,DGD(I)=$P(DGD,U,I2) D
 . S:I=6 LL=.531
 . S:I=7 LL=.532
 . S:I=8 LL=.533
 . S DGD(I)=$$EXTERNAL^DILFD(2,LL,,DGD(I))
 . Q
 K LL
 S DGD(6)=$S(DGD(6)]"":DGD(6),1:"UNKNOWN")
 W !?5,"9.  Vietnam Service:  ",$P(DGD(1),U,1),?38,"From:  ",$P(DGD(1),U,2),?62,"To    :  ",$P(DGD(1),U,3)
 W !?9,"Agent Orange:  ",$P(DGD(2),U,1),?38,"Reg :  ",$P(DGD(2),U,2),?62,"Exam  :  ",$P(DGD(2),U,3),?90,"Reg #:  ",$P(DGD(2),U,4) W:$P(DGD(2),U,1)="YES" ?112,"Loc:  ",$P(DGD(2),U,5)
 W !?9,"ION Radiation:  ",$P(DGD(3),U,1),?38,"Reg :  ",$P(DGD(3),U,2),?62,"Method:  ",$P(DGD(3),U,3),!?9,"Prisoner of War:  ",$P(DGD(4),U,1),?38,"From:  ",$P(DGD(4),U,2),?62,"To    :  ",$P(DGD(4),U,3),?90,"Where:  ",$P(DGD(4),U,4)
 W !?9,"Combat:  ",$P(DGD(5),U,1),?38,"From:  ",$P(DGD(5),U,2),?62,"To    :  ",$P(DGD(5),U,3),?90,"Where:  ",$P(DGD(5),U,4)
 W !?9,"Purple Heart:  ",DGD(6),?38,$S(DGD(6)="YES"&($L(DGD(7))):"Status:  ",DGD(6)="NO"&($L(DGD(8))):"Remarks:  ",1:""),$S(DGD(6)="YES":DGD(7),DGD(6)="NO":DGD(8),1:""),!?5,DGLSUP1
 K D S DGAD=DGP(.21),DGA1=3,DGD=$S($L($P(DGAD,U,1)):$P(DGAD,U,1),1:"UNKNOWN"),DGD(1)=$S($L($P(DGAD,U,2)):$P(DGAD,U,2),1:"UNKNOWN"),DGD(2)=$S($L($P(DGAD,U,9)):$P(DGAD,U,9),1:"UNKNOWN") D A
 W !?5,"10. Next of Kin, Address and Zip Code:",?90,"| Relationship:  ",$E(DGD(1),1,23),!?9,"Name:  ",DGD,?90,"|_____________________________________",!?9,DGA(1),?90,"| Phone:  ",DGD(2) F I=2:1:DGA W !?9,DGA(I),?90,"|"
 W !?5,DGLDOUBL,!?5,"reg:  ",DGAP,?90,"clerk:",$J(DGCLK,32),!
Q D ENDREP^DGUTL
 K DA,DGA,DGA1,DGAD,DGAP,DGBL,DGCLK,DGD,DGDEN,DES,DGP,DGEL,DGFAC,FREE,I,I1,I2,I3,IN,IN1,J,DGLDOUBL,DGLSUP,DGLSUP1,DGNAM,DGSV,DGSV1,DGSC,DGSS,DGZ,X,X1,X2,X3,Y Q
UP I I=1 S Y=$P(DGD,U,4) X:+Y ^DD("DD") S $P(DGD(I),U,2)=$S($L(Y):Y,1:"UNKNOWN"),Y=$P(DGD,U,5) X:+Y ^DD("DD") S $P(DGD(I),U,3)=$S($L(Y):Y,1:"UNKNOWN") Q
 I I=2 D  Q
 .S Y=$P(DGD,U,7) X:+Y ^DD("DD") S $P(DGD(I),U,2)=$S($L(Y):Y,1:"UNKNOWN")
 .S Y=$P(DGD,U,9) X:+Y ^DD("DD") S $P(DGD(I),U,3)=$S($L(Y):Y,1:"UNKNOWN")
 .S $P(DGD(I),U,4)=$S($L($P(DGD,U,10)):$P(DGD,U,10),1:"UNKNOWN")
 .S Y=$P(DGD,U,13),$P(DGD(I),U,5)=$S(Y="V":"VIETNAM",Y="K":"KOREAN DMZ",1:"UNKNOWN")
 I I=3 S Y=$P(DGD,U,11) X:+Y ^DD("DD") S $P(DGD(I),U,2)=$S($L(Y):Y,1:"UNKNOWN"),$P(DGD(I),U,3)=$S($P(DGD,U,12)="N":"NAGASAKI/HIROSHIMA",$P(DGD,U,12)="T":"NUCLEAR TESTING",$P(DGD,U,12)="B":"NUCLEAR TESTING & NAGASAKI/HIROSHIMA",1:"") Q
 I I=4 S Y=$P(DGD,U,7) X:+Y ^DD("DD") S $P(DGD(I),U,2)=$S($L(Y):Y,1:"UNKNOWN"),Y=$P(DGD,U,8) X:+Y ^DD("DD") S $P(DGD(I),U,3)=$S($L(Y):Y,1:"UNKNOWN"),$P(DGD(I),U,4)=$S($D(^DIC(22,+$P(DGD,U,6),0)):$P(^(0),U,1),1:"UNKNOWN") Q
 I I=5 S Y=$P(DGD,U,13) X:+Y ^DD("DD") S $P(DGD(I),U,2)=$S($L(Y):Y,1:"UNKNOWN"),Y=$P(DGD,U,14) X:+Y ^DD("DD") S $P(DGD(I),U,3)=$S($L(Y):Y,1:"UNKNOWN"),$P(DGD(I),U,4)=$S($D(^DIC(22,+$P(DGD,U,12),0)):$P(^(0),U,1),1:"UNKNOWN")
 Q
A S DGA=1 F I=DGA1:1:DGA1+2 S J=$P(DGAD,U,I) I $L(J) S:DGA=3 DGA(2)=DGA(2)_", "_J S:DGA<3 DGA(DGA)=J,DGA=DGA+1
 I DGA=1 S DGA(1)="STREET ADDRESS UNKNOWN",DGA=2
 S J=$S($D(^DIC(5,+$P(DGAD,U,DGA1+4),0)):$P(^(0),U,1),1:""),J(1)=$P(DGAD,U,DGA1+3),J(2)=$P(DGAD,U,DGA1+5),DGA(DGA)=$S($L(J(1))&($L(J)):J(1)_", "_J,$L(J(1)):J(1),$L(J):J,1:"CITY STATE UNKNOWN")
 S DGA(DGA)=DGA(DGA)_"  "_$P(DGAD,U,DGA1+5) K I,J,DGA1 Q
