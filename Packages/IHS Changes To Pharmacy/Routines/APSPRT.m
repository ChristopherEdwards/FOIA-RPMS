APSPRT ; IHS/DSD/ENM - PRINTS PREPACK AND U/D LABELS 7/22/89 ;  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;         
START ;
 D ^APSPRT1 ;Sets parameters
 G:$D(APSPRT("QUIT")) END
BODY ;
 D ADD ;Adds entry to APSP PREPACK LOG file.
 I $D(APSPRT("QUIT")) G:APSPRT("QUIT")=1 END D EOJ G BODY
 D ASK ;Asks if correct
 I $D(APSPRT("QUIT")) D EOJ G BODY
 I APSP("TYPE")="P" D EN^APSPRT1 ;Sets sig in correct array
 D PRINT ;Print labels
 G BODY
 ;
END D EOJ ;Clean up variables
 Q  ;End of routine
 ;
ADD ;
 K APSPRT("ADD")
 W !!,"Last Prepack Number : ",APSP("LASTP")
 W "     Last Unit Dose Number : ",APSP("LASTU"),!!
 S DIC(0)="EQMALZ",DIC="^APSPP(31,",DIC("A")="IHS CONTROL # : "
 D ^DIC
 I +Y<0 S APSPRT("QUIT")=$S(X="":1,$D(DUOUT):"1",1:"") G ADDX
 S DIE=DIC,(APSPRT("DA"),DA)=+Y,DR=$S($P(Y,U,3)=1:"[APSP PREPACK LOG ADD]",1:"[APSP PREPACK LOG EDIT]")
 I $P(Y,U,3)=1 S APSPRT("ADD")=""
 D ^DIE
 I '$D(^APSPP(31,APSPRT("DA"),0)) S APSPRT("QUIT")="" G ADDX
 ; The following line of code deletes the entry if no pharmacist is
 ; entered and all the fields not filled in.
 I $D(APSPRT("ADD")),$P(^APSPP(31,APSPRT("DA"),0),U,14)="" S DIK="^APSPP(31,",DA=APSPRT("DA") D ^DIK S APSPRT("QUIT")="" W !!,"DELETED !"
 ;
ADDX ;Exit point for ADD subroutine    
 Q
 ;
ASK ;Asks if label is correct
 D SETVAR
 D DISPLAY
 W !!!,"IS THIS CORRECT (Y/N) "
 S %=1 D YN^DICN
 I %Y=""!(%Y="Y") D YES G ASKX
 I %Y["?" W !,"Enter a 'Y' if you accept this log entry, a 'N' if not and",!,"you wish to continue to edit it.  You may also enter a '^' if you want to",!,"delete this entry." G ASK
 I %Y="^" S APSPRT("QUIT")="" S DIK="^APSPP(31,",DA=APSPRT("DA") D:$D(APSPRT("ADD")) ^DIK W:$D(APSPRT("ADD")) !!,"DELETED !" G ASKX
 D DIE
 G ASK
ASKX ;Exit point for ASK subroutine
 Q
YES ;
 S:APSP("TYPE")'="P"&(APSP(29)="y") APSP("COPIES")=APSP("COPIES")/2
 I '$D(APSPRT("ADD")) G YESX
 I APSP("TYPE")="P" S APSP("LASTP")=$E(APSP("CNTL#"),5,99)
 I APSP("TYPE")'="P" S APSP("LASTU")=$E(APSP("CNTL#"),5,99)
 S ^APSPP(31,"LAST")=APSP("LASTP")_U_APSP("LASTU")
YESX ;
 Q
 ;
SETVAR ;Displays labels
 I $D(^APSPP(31,DA,"TN")),^("TN")="" K ^("TN")
 S APSPLOG=^APSPP(31,DA,0),APSPLBL=^APSPP(31.1,$P(APSPLOG,U,3),0)
 S APSP("COPIES")=$P(APSPLOG,U,9),APSP("QTY")="#"_$P(APSPLOG,U,8)
 S APSP("DRUG")=$S($D(^APSPP(31,DA,"TN")):^("TN"),$D(^PSDRUG($P(APSPLBL,U,1),0)):$P(^(0),U,1),1:"NONE")
 S APSP("EXPDATE")=$P(APSPLOG,U,6),APSP("CNTL#")="CN# "_$P(APSPLOG,U,1)
 S Y=APSP("EXPDATE") X ^DD("DD") S APSPRT("EXPDATE")="Expires: "_Y
 I $L(APSPRT("EXPDATE"))+3+$L(APSP("CNTL#"))>APSP(22) S APSPRT("EXPDATE")="Exp: "_Y
 S APSP("TYPE")=$S($P(APSPLOG,U,7)="P":"P",1:"U")
 I APSP("TYPE")="U" S APSPRT("EXPDATE")="Exp:"_Y
 G:APSP("TYPE")'="P" SETVARX
 S (APSP("SIG"),X)=$P(APSPLBL,U,3) X ^DD(9009031.1,.03,9.2)
SETVARX ;
 Q
DISPLAY ;Displays labels
 I APSP("TYPE")="P" W !!!,$E(APSP("LINE1"),1,APSP(22)),!,APSP("SIG")
 W:APSP("TYPE")'="P" !!
 W !,APSP("DRUG"),?(APSP(22)-$L(APSP("QTY"))),APSP("QTY")
 W !,APSP("CNTL#"),?(APSP(22)-$L(APSPRT("EXPDATE"))),APSPRT("EXPDATE")
 W:APSP("TYPE")="P" !,$E(APSP("LINE2"),1,APSP(22))
 Q
DIE ;     
 S DR="[APSP PREPACK LOG EDIT]"
 D ^DIE
 Q
PRINT ;
 S APSP("PRT")=$S(APSP("TYPE")="P":"^APSPRT2",1:"^APSPRT3")
 S %=1
 W !!,"Do you wish to print the labels (Y/N) "
 D YN^DICN
 I %=0 W !,"If you wish the labels to be printed enter a 'Y',",!,"if not enter a 'N'.  The prepack or unit dose is still recorded." G PRINT
 G:%'=1 PRINTX
 W !! S DIR("A")="Please enter the number of labels you wish to print : "_APSP("COPIES")_"// " ;IHS/DSD/ENM 05/24/96
 S DIR(0)="FO^1:2" D ^DIR K DIR ;IHS/DSD/ENM 05/24/96
 ;R X:DTIME G:'$T PRINTX
 I X'="",X<1!(X="^") G PRINTX ;IHS/OHPRD/JCM 9/22/89
 I X?1N.N!(X="") S APSP("COPIES")=$S(X'="":X,1:APSP("COPIES"))
 D:%=1 @APSP("PRT")
PRINTX ;
 D EOJ ;Cleans up variables
 Q
 ;
EOJ ;Clean up variables
 K APSP("DRUG"),APSP("QTY"),APSPLOG,APSPLBL,DA,DIE,DIC
 K APSP("CNTL#"),APSPIG,APSPRT("EXPDATE"),APSP("TYPE"),APSP("COPIES")
 I $D(APSPRT("QUIT")),APSPRT("QUIT") K APSP,APSPRT
 K X,Y,APSPRT("ADD"),%,%Y,APSPRT("QUIT"),APSP("QTYFLG")
 K APSPGY,APSPGC,DIE,DIC,DIK,DR,II,IOP,POP,DUOUT,APSPZZL,APSPZM,APSPZLA
 K APSPDR,APSPDR1,%ZIS,%ZIS
 Q
