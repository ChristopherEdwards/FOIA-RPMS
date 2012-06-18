ACHSALUP ; IHS/ITSC/PMF - UPDATE FACILITY FISCAL YEAR ALLOWANCE ;    [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
L1 ;
 S ACHSFYAL=$$FYSEL^ACHS
 G QUIT:$D(DUOUT)!$D(DTOUT)!('ACHSFYAL)
 I '$D(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0)) W !!,"Allowance for this FISCAL YEAR Does NOT Exist -- Please Try Another Year" G L1
 S X=+$P($G(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0)),U,2)
 W !!,"YTD allowance for ",ACHSFYAL," is:",$J("$ "_$FN(X,",",2),20)
 S X=$P($G(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0)),U,2)-$P($G(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0)),U,3)
 W !,"   Unobligated Balance is:",$J("$ "_$FN(X,",",2),20)
L2 ;
 S Y=$$DIR^XBDIR("9002069.01,1","Enter new YTD Advice of Allowance","","Please enter the NEW ALLOWANCE (e.g. 1000.00)","","",2)
 G NOUPD:$D(DUOUT)!$D(DTOUT)!(Y'>0)
 S:$E(Y)="$" Y=$E(Y,2,999)
 W !!,"For Fiscal Year ",ACHSFYAL," the new Allowance is "
 F ACHS=0:0 S F=$F(Y,",") Q:'F  S Y=$E(Y,1,F-2)_$E(Y,F,99)
 I '(Y?1N.N1"."2N!(Y?1N.N))!($L(Y)>10) W *7,"  ??" G L2
 I Y>0 S ACHSCAOA=Y W "  " S X=Y,X2=2 D FMT^ACHS
 G UPDATE:$$DIR^XBDIR("Y","Are you sure this NEW ALLOWANCE is CORRECT","NO","","","",2)
NOUPD ;
 W !!,*7,?10,"******  ALLOWANCE  NOT  UPDATED  ******"
 G END
 ;
UPDATE ;
 I '$$LOCK^ACHS("^ACHS(9,DUZ(2),""FY"",ACHSFYAL,0)","+") G NOUPD
 S $P(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0),U,2)=ACHSCAOA
 S $P(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0),U,4)=DT
 S $P(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0),U,5)=DUZ
 I '$$LOCK^ACHS("^ACHS(9,DUZ(2),""FY"",ACHSFYAL,0)","-")
 W !!?20,"******  ALLOWANCE UPDATED  ******"
END ;
 D:$G(ACHSFYAL) INITIALS(ACHSFYAL)
QUIT ;
 K ACHSFYAL,ACHSCAOA
 D RTRN^ACHS
 Q
 ;
INITIALS(ACHSFYAL) ;EP - Update Initial Register Values
 S Y=0
 F X=1:1:7 S Y=Y+$P($G(^ACHS(9,DUZ(2),"FY",ACHSFYAL,1)),U,X)
 I '(+Y=+$P($G(^ACHS(9,DUZ(2),"FY",ACHSFYAL,0)),U,2)) W *7,!!,"Your Initial Balance values don't = your Advice of Allowance (That's OK)."
 K X,Y
 Q:'$$DIR^XBDIR("Y","Do you want to update the Initial Balance values","N","","","^D HELP^ACHS(""H"",""ACHSALUP"")",1)
 N DA,DIE,DR
 S DIE="^ACHS(9,"_DUZ(2)_",""FY"",",DA(1)=DUZ(2),DA=ACHSFYAL,DR="10:16"
 I '$$LOCK^ACHS("^ACHS(9,DUZ(2),""FY"",ACHSFYAL)","+") Q
 D ^DIE
 I '$$LOCK^ACHS("^ACHS(9,DUZ(2),""FY"",ACHSFYAL)","-")
 Q
 ;
H ;EP - From DIR via HELP^ACHS().
 ;;If you answer yes, you will be able to edit the values in your
 ;;7 Initial Registers, which will appear on your Account Balances
 ;;display / print-out.
 ;;###
 ;
DIE(DR,Z) ;EP - Edit Document fields.
 I $G(Z) F %=1:1:Z W !
 S DA=ACHSDIEN,DA(1)=DUZ(2),DIE="^ACHSF("_DUZ(2)_",""D"","
