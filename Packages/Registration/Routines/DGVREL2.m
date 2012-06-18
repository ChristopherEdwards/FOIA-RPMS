DGVREL2 ;ALB/MRL - GENERATE RELEASE MESSAGE/LETTER ; 2 JUN 87
 ;;5.3;Registration;;Aug 13, 1993
T D ^DGVREL3 S XMSUB=DGS_", "_DGFAC,XMDUZ=$S($D(DUZ)#2:DUZ,1:.5),XMTEXT="^UTILITY($J,""DGVREL"",",XMY(XMDUZ)="",XMY("G.MASRELEASE@DOMAIN.NAME")="" D ^XMD K XMSUB,XMTEXT,XMY
 W !!,"> Message Transmitted to PIMS Developers...Thank you for your response.",!,"> A copy of the message is located in your IN box." G Q
L D ^DGVREL3 W @IOF F I=0:0 S I=$O(^UTILITY($J,"DGVREL",I)) Q:'I  W !,^(I,0) I $Y>$S($D(IOSL):(IOSL-5),1:61) W @IOF
 F I=$Y:1:$S($D(IOSL):(IOSL-10),1:56) W !
 W !,"_____________________________________",!,"SIGNATURE OF PERSON COMPLETING REPORT",!
Q D H^DGUTL S $P(^DG(48,DGVREL,0),"^",2)=DGTIME,$P(^(0),"^",3)=DGHOW K DGDATE,DGTIME G Q^DGVREL
