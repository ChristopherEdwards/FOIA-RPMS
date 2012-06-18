A6BVPCH ; ; 18-JAN-1994
 ;;7.1;KERNEL;**28**;JAN 18, 1994
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
 S DIK="^DD(14.7,",DA=10,DA(1)=14.7 D IX^DIK
Q Q
 ;;^DD(14.7,10,0)
 ;;=OUT OF SERVICE^RS^0:NO;1:YES;^0;11^Q
 ;;^DD(14.7,10,3)
 ;;=Answer YES to prevent any taskman jobs being sent to this cpu.
 ;;^DD(14.7,10,21,0)
 ;;=^^4^4^2940118^
 ;;^DD(14.7,10,21,1,0)
 ;;=This field is used by the TASK Manager to control if any
 ;;^DD(14.7,10,21,2,0)
 ;;=new sub-manager jobs are sent to this Box-Volume Pair.
 ;;^DD(14.7,10,21,3,0)
 ;;=If the manager gets an error when jobbing to another CPU it will
 ;;^DD(14.7,10,21,4,0)
 ;;=change the flag to mark the Box-Volume as Out of Service.
 ;;^DD(14.7,10,"DT")
 ;;=2940118
