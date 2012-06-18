ACD4P1PB ;IHS/ADC/EDE/KML - BROKE UP ACD4P1P;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;; 01-26-98
 ;; 01-26-98
 ;
 ; This routine converts file 6 pointers to file 200 pointers.
 ;
CHGACDF ; CHANGE CDMIS FIELDS  
 I $D(^ACDCNV("B","1")) D  S ACDQ=1 Q  ;   quit if conversion done
 .  W !,"File 6 to file 200 conversion already done.",!
 .  Q
 W !,"I am now going to repoint your CDMIS provider pointers to point",!,"  to the NEW PERSON file. Please wait.",!
 D CHG70P7 ;          change file 9002170.7 (CDMIS PREVENTION)
 D CHG72 ;            change file 9002172 (CDMIS CLIENT SVCS)
 D CHG72P1 ;          change file 9002172.1 (CDMIS VISIT)
 D CHG72P7 ;          change file 9002172.7 (CDMIS CLIENT SVCS COPY SET)
 D CHG73P5 ;          change file 9002173.5 (CDMIS NTERVENTIONS)
 ;
 S X="1",DIC="^ACDCNV(",DIC(0)="L"
 K DD,DO
 D FILE^DICN
 K D,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM
 I Y<0 W !!,"Adding of CONVERSIION FLAG failed.  Notify programmer.",!!
 Q
 ;
CHG70P7 ; CHANGE FILE 9002170.7
 W !,"Changing file 9002170.7",!
 D KILL
 S D0=0
 F  S D0=$O(^ACDPD(D0)) Q:'D0  I $D(^ACDPD(D0,0)) D
 .  S Y=$P(^ACDPD(D0,0),U,5)
 .  I Y S X=$$CONVERT I X S G="^ACDPD(",F=4,ACDIEN=D0 D REPFLD
 .  S D1=0
 .  F  S D1=$O(^ACDPD(D0,1,D1)) Q:'D1  I $D(^ACDPD(D0,1,D1,0)) D
 ..  S D2=0
 ..  F  S D2=$O(^ACDPD(D0,1,D1,"PRV",D2)) Q:'D2  I $D(^ACDPD(D0,1,D1,"PRV",D2,0)) D
 ...  S Y=$P(^ACDPD(D0,1,D1,"PRV",D2,0),U)
 ...  I Y S X=$$CONVERT I X S G="^ACDPD("_D0_",1,"_D1_",""PRV"",",F=.01,ACDIEN=D2 D REPFLD
 ...  Q
 ..  Q
 .  Q
 Q
 ;
CHG72 ; CHANGE FILE 9002172 
 W !,"Changing file 9002172",!
 D KILL
 S D0=0
 F  S D0=$O(^ACDCS(D0)) Q:'D0  I $D(^ACDCS(D0,0)) D
 .  S D1=0
 .  F  S D1=$O(^ACDCS(D0,1,D1)) Q:'D1  I $D(^ACDCS(D0,1,D1,0)) D
 ..  S Y=$P(^ACDCS(D0,1,D1,0),U)
 ..  I Y S X=$$CONVERT I X S G="^ACDCS("_D0_",1,",F=.01,ACDIEN=D1 D REPFLD
 ..  Q
 .  Q
 Q
 ;
CHG72P1 ; CHANGE FILE 9002172.1
 W !,"Changing file 9002172.1",!
 D KILL
 S D0=0
 F  S D0=$O(^ACDVIS(D0)) Q:'D0  I $D(^ACDVIS(D0,0)) D
 .  S Y=$P(^ACDVIS(D0,0),U,3)
 .  I Y S X=$$CONVERT I X S G="^ACDVIS(",F=2,ACDIEN=D0 D REPFLD
 .  Q
 Q
 ;
CHG72P7 ; CHANGE FILE 9002172.7
 W !,"Changing file 9002172.7",!
 D KILL
 S D0=0
 F  S D0=$O(^ACDCSCS(D0)) Q:'D0  I $D(^ACDCSCS(D0,0)) D
 .  S D1=0
 .  F  S D1=$O(^ACDCSCS(D0,11,D1)) Q:'D1  I $D(^ACDCSCS(D0,11,D1,0)) D
 ..  S D2=0
 ..  F  S D2=$O(^ACDCSCS(D0,11,D1,11,D2)) Q:'D2  I $D(^ACDCSCS(D0,11,D1,11,D2,0)) D
 ...  S Y=$P(^ACDCSCS(D0,11,D1,11,D2,0),U)
 ...  I Y S X=$$CONVERT I X S G="^ACDCSCS("_D0_",11,"_D1_",11,",F=.01,ACDIEN=D2 D REPFLD
 ...  Q
 ..  Q
 .  Q
 Q
 ;
CHG73P5 ; CHANGE FILE 9002173.5
 W !,"Changing file 9002173.5",!
 D KILL
 S D0=0
 F  S D0=$O(^ACDINTV(D0)) Q:'D0  I $D(^ACDINTV(D0,0)) D
 .  S D1=0
 .  F  S D1=$O(^ACDINTV(D0,2,D1)) Q:'D1  I $D(^ACDINTV(D0,2,D1,0)) D
 ..  S Y=$P(^ACDINTV(D0,2,D1,0),U)
 ..  I Y S X=$$CONVERT I X S G="^ACDINTV("_D0_",2,",F=.01,ACDIEN=D1 D REPFLD
 ..  Q
 .  Q
 Q
 ;
REPFLD ; REPOINT FIELD
 NEW DA
 D D0DA  ;      setup DA array
 NEW D0,D1,D2
 S DIE=G,DA=ACDIEN,DR=F_"///"_$S(F=.01:"`",1:"/")_X
 ;L +@(DIE_DA_")"):5 I '$T W !,"Sorry, someone else is editing this record.  Try later." Q
 D ^DIE
 ;L -@(DIE_DA_")")
 K D,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM
 K ACDIEN
 Q
 ;
CONVERT() ; CONVERT FILE 6 POINTER TO FILE 200 POINTER
 NEW E,M,ACDZR,X
 S ACDZR=$$LGR^%ZOSV  ;                save file entry
 D CONVERT2 ;                          see if ptr converts
 I E D  S X="" ;                       write error
 .  W ACDZR,!,"  "_$P($T(CONVERR+E),";;",2),!,"  "_M,!
 .  Q
 Q X
 ;
CONVERR ; ERROR DESCRIPTIONS
 ;;Dangling pointer to file 6
 ;;File 6 pointer not in file 16
 ;;No A3 node in file 16
 ;;A3 pointer null or not numeric
 ;;No entry in file 200 for A3 pointer
 ;
CONVERT2 ;
 S E=0
 S M="File 6 ptr="_Y
 I '$D(^DIC(6,Y,0)) S E=1 Q  ;         dangling 6 ptr
 I '$D(^DIC(16,Y,0)) S E=2 Q  ;        6 ptr not in 16
 I '$D(^DIC(16,Y,"A3")) S E=3 Q  ;     no A3 node in 16
 S X=^DIC(16,Y,"A3")
 I 'X S E=4 Q  ;                       A3 ptr null or not numeric
 S M=M_", A3 ptr="_X
 I '$D(^VA(200,X,0)) S E=5 Q  ;        no 200 entry for A3 ptr
 Q
 ;
D0DA ; ----- Set DA array from D0 (etc).
 F I=0:1 Q:'$D(@("D"_I))  S J=I
 I J=0 S DA=D0 Q
 F I=0:1 S DA(J)=@("D"_I) S J=J-1 Q:J<1
 S DA=@("D"_(I+1))
 Q
 ;
KILL ; ----- KILL D0, D1, ETC.
 NEW I
 F I=0:1 Q:'$D(@("D"_I))  K @("D"_I)
 Q
