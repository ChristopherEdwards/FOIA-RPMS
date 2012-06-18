VENPCCOH ; IHS/OIT/GIS - DISPLAY VEN OPTION HEADER ;
 ;;2.6;PCC+;;NOV 12, 2007
 ;
 ; DON'S LAST CODE
 ;
START ;
 ;
 NEW VENZLINE,VENZTITL,VENZUNL,VENZUSR,VENZVER
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S VENZTITL=$E($P($G(XQY0),U,2),1,45) S:VENZTITL="" VENZTITL="* NO TITLE AVAILABLE *"
 S VENZVER=$P($P($T(VENPCCOH+1),";;",2),";")
 ;I $G(^RA("VERSION"))'=VENZVER S ^RA("VERSION")=VENZVER ;keep them in sync
 S VENZUSR=$E($$USR(),1,20)
 S VENZLINE="ILC ENC FORM/HLTH SUMMARY V"_VENZVER_":  "_IORVON_VENZTITL_IORVOFF
 W:$D(IOF) @IOF
 W !,VENZLINE,!
 W "LOCATION:  "_$$LOC(),?50,"USER:  "_VENZUSR,!
 S VENZUNL="",$P(VENZUNL,"-",80)="-"
 W VENZUNL,!
 Q
 ;
 ;----------
CTR(X,Y) ;EP-Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
LJRF(X,Y,Z) ;EP-left justify X in a field Y wide, right filling with Z.
 NEW L,M
 I $L(X)'<Y Q $E(X,1,Y-1)_Z
 S L=Y-$L(X)
 S $P(M,Z,L)=Z
 Q X_M
 ;----------
USR() ;EP-Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP-Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;
