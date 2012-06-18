XQABGEN ;ISC-SF/JLI - GENERATE ALPHA/BETA TEST INITIALIZATION ROUTINE ;1/21/93  11:50 ;
 ;;7.1;KERNEL;;May 11, 1993
 ;;
ENTRY I '$D(DKP) S DIC=9.4,DIC(0)="MAEQ" D ^DIC Q:Y'>0  S DKP=+Y
 S DKP(0)=^DIC(9.4,+DKP,0),XQABPKG=$P(DKP(0),U),XQABNMSP=$P(DKP(0),U,2),XQABROU=XQABNMSP_$S($L(XQABNMSP)<4:"INITY",1:"INIY")
 K ^TMP($J,"XQAB") S X="XQABMAKE",XCNP=0,DIF="^TMP($J,""XQAB""," X ^%ZOSF("LOAD")
 S ^(0)=XQABROU_" "_$P(^TMP($J,"XQAB",1,0)," ",2,200)
 S ^TMP($J,"XQAB",XCNP,0)="PKGNAM ;;"_XQABPKG_";",XCNP=XCNP+1
ABTEST W !!,"Is this version of the ",XQABPKG,!?5,"an Alpha or Beta test version (Y/N) ?  " R X:DTIME G:'$T!(X[U) KILL S X=$E(X_".") I "NnYy"'[X W $C(7),"  ??",!!,"ANSWER EITHER YES OR NO OR '^' TO EXIT" G ABTEST
 S XQABTEST=$S("Nn"[X:0,1:1),^TMP($J,"XQAB",XCNP,0)="ABTEST ;;"_$S(XQABTEST:"YES;",1:"NO;"),XCNP=XCNP+1
ADRESS W !!,"Enter as an adressee for installation messages a mailgroup in NETWORK MAIL",!,"format, e.g., G.GROUPNAME@DOMAIN.NAME" W:XQABTEST "  This same address will",!,"be used for reports on Alpha/Beta Option Usage"
 R !?10,"Addressee: ",X:DTIME G:'$T!(X[U) KILL D UCASE I X'?1"G."1U.E1"@"1U.E W $C(7),"  ??" G ADRESS
 S XQABADRS=X S X=$P(X,"@",2),DIC=4.2,DIC(0)=$S(X="":"A",1:"")_"EQM" D ^DIC G:Y'>0 ADRESS S XQABADRS=$P(XQABADRS,"@",1)_"@"_$P(Y,U,2),^TMP($J,"XQAB",XCNP,0)="ADRESS ;;"_XQABADRS_";",XCNP=XCNP+1
MESG R !!,"Do you want a message returned upon installation (Y/N) ?  ",X:DTIME G:'$T!(X[U) KILL S X=$E(X,1) I "YyNn"'[X W $C(7),"  ??",!,"ENTER Y (YES) OR N (NO) OR '^' TO EXIT" G MESG
 S ^TMP($J,"XQAB",XCNP,0)="SENMSG ;;"_$S("Yy"[X:"YES",1:"NO")_";",XCNP=XCNP+1
 G:'XQABTEST FINISH
VERS R !,"ENTER Version Number: ",X:DTIME I X'?.E1"V"1N.N&(X'?.E1"T"1N.N) W !,"Enter the version number as nVm or nTm where n and m are numbers,",!,"and n may have one decimal place.",!! G VERS
 S ^TMP($J,"XQAB",XCNP,0)="VERS ;;"_X_";",XCNP=XCNP+1
 S XQABOPT=XQABNMSP,XQABOPTN=1,^TMP($J,"XQAB",XCNP,0)="OPT"_XQABOPTN_" ;;"_XQABOPT_";"
XCLUD W !!,"For the namespace '",XQABOPT,"' are there any namespaces (other than '",XQABOPT,"Z'",!?20,"that should be EXCLUDED (Y/N) ?  N// " R X:DTIME G:'$T!(X[U) KILL S:X="" X="N" S X=$E(X_".",1)
 I "YyNn"'[X W !!,"ENTER 'Y' OR 'YES' IF SOME OPTIONS BEGINNING WITH '",XQABOPT,"' SHOULD BE",!,"EXCLUDED FROM THE ANALYSIS, E.G., '",XQABOPT,"A'" G XCLUD
 I "Yy"[X D XCLUD1
NMSPAC R !!,"Enter ANOTHER namespace used by options in this package: ",X:DTIME G:'$T!(X[U) KILL
 I X["?" W !,"If this package supports options with names which begin with ANOTHER namespace",!,"than ",$S(XQABOPTN=1:"that",1:"those")," already entered, then enter THAT namespace now." G NMSPAC
 D UCASE I $L(X)<5,X?1U.UN!(X?1"%"1U.UN) S XQABOPTN=XQABOPTN+1,XQABOPT=X,XCNP=XCNP+1 S ^TMP($J,"XQAB",XCNP,0)="OPT"_XQABOPTN_" ;;"_XQABOPT_";" G XCLUD
 I X'="" W !,"The namespace or prefix must be four or fewer characters long, beginning",!,"with a letter and followed by letters and/or digits.  Enter a RETURN if there",!,"are no additional namespaces to include." G NMSPAC
FINISH S DIE="^TMP($J,""XQAB"",",XCN=0,X=XQABROU X ^%ZOSF("SAVE")
KILL K DIC,DIE,DIF,I,X,XCN,XCNP,XQABADRS,XQABTEST,XQABOPT,XQABNMSP,XQABOPTN,XQABPKG,XQABROU,Y
 K ^TMP($J,"XQAB")
 Q
UCASE F I=1:1 Q:X'?.E1L.E  I $E(X,I)?1L S X=$E(X,1,I-1)_$C($A($E(X,I))-32)_$E(X,I+1,$L(X))
 Q
 ;
XCLUD1 R !!?10,"Enter the FULL namespace or prefix to be excluded: ",X:DTIME Q:'$T!(X[U)!(X="")  D UCASE
 I $E(X,1,$L(XQABOPT))'=XQABOPT!(X=XQABOPT) W $C(7),"  ??",!,"Enter the namespace to exclude as",!?15,"'",XQABOPT,"' followed by one or more letters or digits." G XCLUD1
 S ^(0)=^TMP($J,"XQAB",XCNP,0)_X_";" W "       OK"
 G XCLUD1
