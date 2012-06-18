AZAN ;Start up Driver Routine for AHCCCS DOWNLOAD PROGRAM [ 06/11/03  4:20 PM ]
 ;
 ;
 ;
START ;Begin Unix Down Load
 ;
 ;
 ;
NEXT ;Begin RPMS Down Load
 ;
 ;
 ;
 ;
FALLOFF ;Do the Fall Off Routine
 ;
 ;
 ;
LOGO ;EP - Print logo of main menu.
 NEW A,D,I,L,N,R,V
 S L=18,R=61,D=R-L+1,N=R-L-1
 S I=$O(^DIC(9.4,"C","AZAM",0)),V=^DIC(9.4,I,"VERSION"),A=$O(^DIC(9.4,I,22,"B",V,0)),Y=$$FMTE^XLFDT($P(^DIC(9.4,I,22,A,0),U,2))
 W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!?L,"*",$$CTR("INDIAN HEALTH SERVICE",N),?R,"*",!?L,"*",$$CTR("MEDICAID ELIGIBILITY DOWNLOAD",N),?R,"*",!?L,"*",$$CTR("VERSION "_V_", "_Y,N),?R,"*",!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W $$CTR($$LOC())
 ;Sub Menu Displays
 Q:$G(XQY0)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2)
 S:X="Medicaid Eligibility Download System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 W !,$$CTR(X),!
 Q
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
 ;
 ;
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
