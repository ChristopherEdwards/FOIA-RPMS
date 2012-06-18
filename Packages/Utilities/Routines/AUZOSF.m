AUZOSF ;TRANSFER TO MGR AND REMOVE THIS LINE [ 01/28/86  2:01 PM ]
ZOSFDSM ;; SETS UP ^%ZOSF FOR DSM-3 ON PDP 11'S [ 10/16/85  11:27 AM ]
 ;OCAO/IHS DRS
 I $N(^%ZOSF(0))+1 W *7,!,"^%ZOSF GLOBAL ALREADY EXISTS. WANT TO RE-INITIALIZE? NO// " R X I X["Y" W "  OK" F I=0:0 S X=$N(^%ZOSF(0)) Q:X<0  K ^(X)
 I $D(^%ZTSK(0))[0 S ^%ZTSK(0)=1000
 F I=1:2 S Z=$P($T(Z+I),";",2) Q:Z=""  S X=$P($T(Z+1+I),";",2,99) S:'$D(^%ZOSF(Z)) ^%ZOSF(Z)=X
MGR W !,"NAME OF MANAGER'S UCI: "_^%ZOSF("MGR")_"// " R X I X'?."?" S ^("MGR")=X,I=X X ^("UCICHECK") I Y=""!(X'=I) W "??" G MGR
PROD W !,"PRODUCTION (SIGN-ON) UCI: "_^%ZOSF("PROD")_"// " R X I X]"" X ^("UCICHECK") G PROD:Y="" S ^%ZOSF("PROD")=Y
 W !!,"ALL SET UP",!! Q
Z ;
 ;AVJ
 ;S Y=63-$V($V(44)+350)
 ;BRK
 ;B 1
 ;CPU
 ;S Y=^%ZOSF("MGR"),Y=^[Y]SYS(0,"RUNNING")
 ;DEL
 ;X "ZR  ZS @X" K ^UTILITY("ROU",X)
 ;EOFF
 ;U $I:(::::1)
 ;EON
 ;U $I:(:::::1)
 ;EOT
 ;S Y=$ZA\1024#2
 ;ETRP
 ;S $ZT=X
 ;GD
 ;D ^%GD
 ;LOAD
 ;S %N=0 X "ZL @X F XCNP=XCNP+1:1 S %N=%N+1,%=$T(+%N) Q:$L(%)=0  S @(DIF_XCNP_"",0)"")=%"
 ;MAXSIZ
 ;Q
 ;MGR
 ;MGR,AAA
 ;NBRK
 ;B 0
 ;NO-TYPE-AHEAD
 ;U $I:(::::100663296)
 ;OS
 ;DSM-3
 ;PRIORITY
 ;D PRIORITY^%ZTMS
 ;PROD
 ;VAH,AAA
 ;RD
 ;D ^%RD
 ;RM
 ;U $I:X
 ;SAVE
 ;S XCS="F XCM=1:1 S XCN=$O(@(DIE_XCN_"")"")) Q:+XCN'=XCN  S %=^(XCN,0) Q:$E(%,1)=""$""  I $E(%,1)'="";"" ZI %" X "ZR  X XCS ZS @X" S ^UTILITY("ROU",X)="" K XCS
 ;SIGNOFF
 ;I 0
 ;SIZE
 ;S Y=0 F I=1:1 S %=$T(+I) Q:%=""  S Y=Y+$L(%)+2
 ;TEST
 ;I $D(^ ("ROU",X))
 ;TMK
 ;S Y=$ZA\16384#2
 ;TYPE-AHEAD
 ;U $I:(::::67108864:33554432)
 ;UCI
 ;S Y=$ZU(0)
 ;UCICHECK
 ;D UCICHECK^%ZTMS
 ;ZD
 ;S %H=X D 7^%DTC S Y=$E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
 ;TONL
 ;S Y=$ZA\64#2
 ;TWP
 ;S Y=$ZA\4#2
 ;TERCOND
 ;S Y=$ZA\32768#2
 ;TRW
 ;W *5
 ;TWLB
 ;W *4
