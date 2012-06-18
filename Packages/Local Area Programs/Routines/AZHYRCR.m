%RCR ;GFT/SF [ 04/02/90  1:25 PM ]
 ;;17.7;VA FileMan; 6/9/89
 ;IHS/MFD,IHS/THL ;3/28/90 ; rewrite of STORLIST and %XY
 ; with no use of ^UTILITY, uses local UT variable instead
 ;
STORLIST I $D(UT("%RCR",$J))[0 S UT("%RCR",$J)=0
 S UT("%RCR",$J)=UT("%RCR",$J)+1,%D="%Z",%E="UT(""%RCR"",$J,"_UT("%RCR",$J)_",%D",%Y=%E_","
 K UT("%RCR",$J,UT("%RCR",$J))
 F  S %D=$O(%RCR(%D)) Q:%D=""  S:$D(@%D)#2 @(%E_")="_%D) I '($D(@%D)=1) S %X=%D_"(" D:$D(@%D)>9 %XY
CALL S %E=%RCR K %RCR,%X,%Y D @%E
 S %E="UT(""%RCR"",$J,"_UT("%RCR",$J)_",%D",UT("%RCR",$J)=UT("%RCR",$J)-1,%D=0,%X=%E_","
 F  S %D=$O(@(%E_")")) Q:%D=""  S:$D(UT("%RCR",$J,UT("%RCR",$J)+1,%D))#2 @%D=UT("%RCR",$J,UT("%RCR",$J)+1,%D) I '($D(UT("%RCR",$J,UT("%RCR",$J)+1,%D))=1) S %Y=%D_"(" D:$D(UT("%RCR",$J,UT("%RCR",$J)+1,%D))>9 %XY
 K %D,%E,%X,%Y,UT("%RCR",$J,UT("%RCR",$J)+1) Q
%XY ;
 ;W "$" ;to see where and how much FM calls this entry point
 N %A,%B D %A(%X) F  S %B=$Q(@%B) Q:%B'[%A  S @(%Y_$P(%B,%A,2,999)_"="_%B)
 Q
%A(%C) ;Pass local or gl var, your var,%A & %B returned
 ;%A=var w/ other vars substituted ending w/ "," and no leading ^
 ;%B=var w/ other vars substituted ending w/ ")"
 S %A="%C("_$P(%C,"(",2,99)_"1)",%B=$E(%A,1,$L(%A)-1)_",1)",@("("_%A_","_%B_")="""""),%A=$Q(@%A),%A=$P(%X,"(")_"("_$P($E(%A,1,$L(%A)-4),"(",2,99),%B=$S(%A[",":$E(%A,1,$L(%A)-1)_")",1:$P(%A,"(")),%A=$S($E(%A)="^":$E(%A,2,999),1:%A) Q
OS ;
 S $P(^%ZOSF("OS"),"^",2)=DITZS
 K ^%ZTSK(ZTSK),DITZS
 Q
