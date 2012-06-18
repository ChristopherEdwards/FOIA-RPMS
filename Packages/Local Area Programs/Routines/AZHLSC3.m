AZHLSC3 ; IHS/ADC/GTH:KEU:JN - SAC CHAPTER 3: INTERFACE PROGRAMMING STANDARDS & CONVENTIONS ;  [ 06/05/1998  7:20 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 W !!!,$P($P($T(+1),";",2),"-",2),!! D TTL^AZHLSC("3.1.3  (5.4)   Help")
 I 'AZHLPIEN D NPKG^AZHLSC Q
 W !,"NOTE: Any following are violations ONLY if DIE is used to edit the fields."
 S %="",$P(%,"-",60)=""
 W !?7,"H = No 'HELP'-PROMPT and no XECUTABLE 'HELP' (?)"
 ; ,!?7,"D = No field DESCRIPTION (??)"
 W !?10,"File",?30,"Field",?50,"Code",!?10,$E(%,1,18),?30,$E(%,1,18),?50,$E(%,1,4)
 NEW F,I
 ;
 S I=0
 F  S I=$O(^DIC(9.4,AZHLPIEN,4,"B",I)) Q:'I  D DD1
 Q
DD1 S F=0
 F  S F=$O(^DD(I,F)) Q:'F  S %=$P(^(F,0),U,2) D
 .I +% D  Q
 ..NEW F,I S I=+% D DD1
 ..Q
 .Q:(%["C")!(%["I")!(%["K")!(%["P")!(%["V")!(%["W")!(%["S")!(%["D")
 .S %="" I '$L($G(^DD(I,F,3))),'$L($G(^(4))) S %="H"
 . ; I '$P($G(^DD(I,F,21,0)),U,3) S %=%_"D"
 . ; Above line checks DESCRIPTION.
 .Q:'$L(%)
 .W !?10,I,?30,F,?50,%
 .Q
 Q
 ;
 ; 2nd piece of 0th node contains:
 ;     C = Computed
 ;     I = Uneditable
 ;     K = MUMPS code
 ;     P = Pointer
 ;     V = Variable Pointer
 ;     W = Word processing
 ;     S = Set of Codes
 ;     D = Date
