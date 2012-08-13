INHVA1 ;FRW ; 6 Feb 92 12:20; SACI-Care/VA data element mapping utilities
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
CONF ;Consistency check for the .01 field on file #4090.2
 ;Called from ^DD(4090.2,.01,9)
 ;INPUT:
 ;  X - value of .01 field
 ;  DA - entry being editted (ien)
 ;
 ;OUTPUT:
 ;  X - killed if not valid name
 ;
 S %=$O(^INVD(4090.2,"B",X,0)) I %,%'=DA W *7,!,"The function ",X," already exists." K X
 Q
 ;
DEL ;Verify if entry can be deleted
 ;INPUT:
 ;  DA - entry being deleted
 ;OUTPUT:
 ;  $T - flagged to indicate if entry can be deleted
 ;        0 - ok to delete ; 1 - NOT ok to delete
 ;
 I $D(^INVD(4090.1,"SC",DA))!$D(^INVD(4090.1,"VA",DA)) D
 .D:$D(DWD)>9 MESS^DWD(6)
 .W *7,!!,"Entry may not be deleted.",!,"Entries in the DATA ELEMENT VALUE MAP file use this function."
 .R !,"Press <RETURN> to continue ",%:DTIME
 Q
 ;
ADDR(SUBSCR,ITER) ;Transform addresses with no state
 ;INPUT:
 ;  X => value of state field (ZZZ99.5)
 ;  INV => array of data values
 ;  SUBSCR => subscript where address field resides in INV (ex. ZPD17)
 ;  ITER => (opt) indicates an iteration count
 ;
 ;OUTPUT:
 ;  X => transformed value of state
 ;  INV => modified array of data values
 ;
 S:$G(SUBSCR)="" SUBSCR="XXX"
 ;Look for zip codes in state field
 G:'$G(ITER) AD1
 I X?5N.E S @("@INV@("""_SUBSCR_".6"",ITER)")=X,X="",@("@INV@("""_SUBSCR_".5"",ITER)")=""
 I X]"" S X=$$MAP^INHVA2("GEOGRAPHIC LOCATION",@("@INV@("""_SUBSCR_".4"",ITER)")_"\"_X,0) K:'X X I $D(X) S X="`"_+X
 Q
AD1 ;non-looping
 I X?5N.E S @("@INV@("""_SUBSCR_".6"")")=X,X="",@("@INV@("""_SUBSCR_".5"")")=""
 I X]"" S X=$$MAP^INHVA2("GEOGRAPHIC LOCATION",@("@INV@("""_SUBSCR_".4"")")_"\"_X,0) K:'X X I $D(X) S X="`"_+X
 Q
 ;
TEST ;
 S INMODE="I",SUBDELIM="\"
 K INV S X="ILLINOIS",INV("ZPD17.5")=X,INV("ZPD17.4")=17 D ADDR("ZPD17") W !!,"X => ",X
 K INV S X=98124,INV("ZPD17.5")=X D ADDR("ZPD17") W !!,"X => ",X,!,"INV(17.6) => ",INV("ZPD17.6")
 Q
 ;
KILL(%V,%D,%I) ;kill segment %V
 ;%D holds description of script var which failed required check
 ;If %I exists, it is an array containing subscript levels to wipe out
 N X,Y,I,Z S (%V,X)=$E(%V,1,3)
 I '$D(%I) D  Q
 . F  S X=$O(@INV@(X)) Q:$E(X,1,3)'=%V  K @INV@(X)
 . D ERROR^INHS("Required data missing: '"_%D_"' ... "_%V_" segment deleted.  Processing continues.",0)
 S Y="",I=0 F  S I=$O(%I(I)) Q:'I  S Y=Y_","_%I(I)
 S Z=$TR(INV,")",",")_$E("(",INV'["(")
 F  S X=$O(@INV@(X)) Q:$E(X,1,3)'=%V  K @(Z_""""_X_""""_Y_")")
 S Z="Required data missing: '"_%D_"' ... "_%V_" segment deleted for iteration #" S I=0 F  S I=$O(%I(I)) Q:'I  S Z=Z_%I(I)_","
 D ERROR^INHS($E(Z,1,$L(Z)-1)_".  Processing continues.",0)
 Q
