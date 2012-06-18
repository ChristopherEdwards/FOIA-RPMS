A4A7P604 ; ;9/24/93  14:41
 ;;1.01;NEW PERSON;**6**;JUL 30,1992
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(200,53.4,1,0)
 ;;=^.1
 ;;^DD(200,53.4,1,1,0)
 ;;=200^ACX35^MUMPS
 ;;^DD(200,53.4,1,1,1)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,"I"),U,1)=X
 ;;^DD(200,53.4,1,1,2)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,"I"),U,1)=""
 ;;^DD(200,53.4,1,1,3)
 ;;=(Used to keep 3-16-200 in sync.)
 ;;^DD(200,53.4,1,1,"DT")
 ;;=2931020
 ;;^DD(200,53.5,1,0)
 ;;=^.1
 ;;^DD(200,53.5,1,1,0)
 ;;=200^ACX36^MUMPS
 ;;^DD(200,53.5,1,1,1)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,0),U,4)=X
 ;;^DD(200,53.5,1,1,2)
 ;;=N % S %=$P(^DIC(3,DA,0),U,16) I %,$D(^DIC(6,%,0)) S $P(^DIC(6,%,0),U,4)=""
 ;;^DD(200,53.5,1,1,3)
 ;;=Used to keep 3-16-200 in sync.
 ;;^DD(200,8980.16,0)
 ;;=PERSON FILE POINTER^RP16'^DIC(16,^0;16^Q
 ;;^DD(200,8980.16,1,0)
 ;;=^.1
 ;;^DD(200,8980.16,1,1,0)
 ;;=200^A16
 ;;^DD(200,8980.16,1,1,1)
 ;;=S ^VA(200,"A16",$E(X,1,30),DA)=""
 ;;^DD(200,8980.16,1,1,2)
 ;;=K ^VA(200,"A16",$E(X,1,30),DA)
 ;;^DD(200,8980.16,1,1,3)
 ;;=PERSON FILE CONVERSION
 ;;^DD(200,8980.16,1,1,"%D",0)
 ;;=^^2^2^2920730^
 ;;^DD(200,8980.16,1,1,"%D",1,0)
 ;;=This X-ref is to allow packages to have a stable way to convert
 ;;^DD(200,8980.16,1,1,"%D",2,0)
 ;;='person file pointers' into 'new person file pointers.
 ;;^DD(200,8980.16,1,1,"DT")
 ;;=2920730
 ;;^DD(200,8980.16,3)
 ;;=Loaded by cross file link
 ;;^DD(200,8980.16,9)
 ;;=^
 ;;^DD(200,8980.16,21,0)
 ;;=^^3^3^2920730^
 ;;^DD(200,8980.16,21,1,0)
 ;;=This field holds a pointer to the person file so there will be a way to
 ;;^DD(200,8980.16,21,2,0)
 ;;=provide a cross reference to help convert 'person file' pointers into
 ;;^DD(200,8980.16,21,3,0)
 ;;='new person file' pointer after the person file is removed.
 ;;^DD(200,8980.16,"DT")
 ;;=2920730
