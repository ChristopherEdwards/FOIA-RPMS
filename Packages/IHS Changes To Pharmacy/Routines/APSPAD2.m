APSPAD2 ;IHS/DSD/ENM - BUILD AD2 X-REF [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;This routine will build the "AD2" X-Ref for all division fields
 ;which is used by several reports.
EP ;ENTRY POINT
 D NOW^%DTC S X1=X,X2=-90 D C^%DTC S APSPTIME=X
 S I=0,APSP=0,APSP1=0,APSP2=0,DA=""
 F  S I=$O(^PSRX(I)) Q:'I  D NEW,REF,PAR
 Q
NEW ;
 Q:$P($G(^PSRX(I,0)),"^",13)<APSPTIME
 Q:$G(^PSRX(I,2))=""  ;QUIT AT END 
 I $P($G(^PSRX(I,2)),"^",9)]"" S TYPE="N",DA=I D SET K DA
 Q
REF ;
 Q:$P($G(^PSRX(I,1,0)),"^",3)<1
 S APSP1=0 F  S APSP1=$O(^PSRX(I,1,APSP1)) Q:'APSP1  I $P($G(^PSRX(I,1,APSP1,0)),"^")'<APSPTIME  S TYPE="R",DA(1)=I,DA=APSP1 D SET K DA(1),DA
 Q
PAR ;
 Q:$G(^PSRX(I,"P",0))="" 
 S APSP2=0 F  S APSP2=$O(^PSRX(I,"P",APSP2)) Q:'APSP2  I $P($G(^PSRX(I,"P",APSP2,0)),"^")'<APSPTIME  S TYPE="P",DA(1)=I,DA=APSP2 D SET K DA(1),DA
 Q
SET ;
 I TYPE="N" S DIK(1)="20^AD2",DIK="^PSRX(" D EN1^DIK Q
 I TYPE="R" S DIK(1)="8^AD3",DIK="^PSRX("_DA(1)_",1," D EN1^DIK W !,I,?10,"TY= ",TYPE Q
 I TYPE="P" S DIK(1)=".09^AD4",DIK="^PSRX("_DA(1)_",""P""," D EN1^DIK W !,I,?10,"TY= ",TYPE Q
 Q
