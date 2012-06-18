ADGCRB3 ; IHS/ADC/PDW/ENM - A SHEET lines 5&6 ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ; -- main
 D INI,H5,L5,H6,L6,H61,L61 Q
 ;
INI ; -- mailing address, next of kin, emergency contact
 S DGN11=$G(^DPT(DFN,.11)),DGN21=$G(^(.21)),DGN33=$G(^(.33))  Q
 ;
H5 ; -- sub heading 5
 W !,DGLIN1,!,"9 Present Address",?62,"22 Length of Stay",! Q
 ;
L5 ; -- data line 5
 I DGN11="" W ?6,"UNKNOWN" Q
 W ?2,$P(DGN11,U),"  ",$P(DGN11,U,4),$$STM," ",$P(DGN11,U,6),?67,$$LOS Q
 ;
H6 ; -- sub heading 6a
 W !,DGLIN1,!,"23 Next of Kin",?25,"Telephone"
 W ?45,"Address",?60,"Relationship",! Q
 ;
L6 ; -- data line 6a
 I DGN21="" W ?6,"UNKNOWN" Q
 W $E($P(DGN21,U),1,23),?22,$P(DGN21,U,9)," ",$P(DGN21,U,3)," ",$P(DGN21,U,6)
 W $$STN," ",$P(DGN21,U,8),"  ",$$R21 Q
 ;
H61 ; -- sub heading 6b
 W !,"24 Person to Notify",! Q
 ;
L61 ; -- date line 6b
 I DGN33="" W ?6,"UNKNOWN" Q
 W $E($P(DGN33,U),1,23),?22,$P(DGN33,U,9)," ",$P(DGN33,U,3)," ",$P(DGN33,U,6)
 W $$STC," ",$P(DGN33,U,8),"  ",$$R33 Q
 ;
STM() ; -- state mailing
 Q ", "_$P($G(^DIC(5,+$P(DGN11,U,5),0)),U,2)
 ;
STN() ; -- state nok
 Q ", "_$P($G(^DIC(5,+$P(DGN21,U,7),0)),U,2)
 ;
STC() ; -- state emergency contact
 Q ", "_$P($G(^DIC(5,+$P(DGN33,U,7),0)),U,2)
 ;
R21() ; -- relationship, nok
 Q $P($G(^AUTTRLSH(+$P($G(^AUPNPAT(DFN,28)),U,2),0)),U)
 ;
R33() ; -- relationship, person to notify
 Q $P($G(^AUTTRLSH(+$P($G(^AUPNPAT(DFN,31)),U,2),0)),U)
 ;
LOS() ; -- length of stay
 I DGDS N X D  Q X_" hrs"
 . K ^UTILITY("DIQ1",$J) S DR(9009012.01)=8,DA(9009012.01)=DGDS
 . S DIC=9009012,DA=DFN,DR=1 D EN^DIQ1
 . S X=$G(^UTILITY("DIQ1",$J,9009012.01,DGDS,8)) K ^UTILITY("DIQ1",$J)
 Q:'$P(^DGPM(DGFN,0),U,17) ""
 N X,DGPMIFN S DGPMIFN=DGFN D ^DGPMLOS Q $S($D(X):$P(X,U,5)_" days",1:"")
